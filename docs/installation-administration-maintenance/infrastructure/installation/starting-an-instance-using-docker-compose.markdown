---
title: "Starting an Instance Using Docker Compose"
id: "starting-an-instance-using-docker-compose"
layout: documentation
toc: true
---

Although not ideal, a complete Cocov instance can be created through Docker
Compose (or Podman Compose).

The same basic requirements from Kubernetes also applies to the Docker instance,
as the platform requires a GitHub App to authenticate users and perform other
operations, and external connectivity is required in order to receive events
from GitHub.

{% warning %}
This page will not provide guidance on configuring DNS, nor configuring a
reverse proxy, focusing only on the `docker-compose.yaml` file and its contents.
{% endwarning %}

{% info %}
**Notice**: This assumes you understand Cocov's {% doclink "Requirements", title: "dependencies" %},
and that a {% doclink "Creating a GitHub App", title: "GitHub App" %} was
created.
{% endinfo %}
<br/>

## Starting the API and Web UI

The first step is to initialize the API and Web UI in order to be able to create
service tokens, which are required to provision other components.

First, setup the basic dependencies. In case you intend to use an external
PostgreSQL or Redis instance, the next step can be omitted, and you will need to
configure environment keys to point to your external services.

### Initializing Base Dependencies

Create a new `docker-compose.yaml` file, and set its version:

```yaml
version: "3"
services:
```

Then, add a Redis and PostgreSQL instance. Ensure to map PostgreSQL's data
directory to a directory within your host:

{% warning %}
**Notice**: PostgreSQL is using `postgres` as both its username and password.
Feel free to change it as you wish, but in case you do, remember to set API's
environment keys accordingly.
{% endwarning %}

```yaml
version: "3"
services:
  redis:
    image: redis:alpine

  postgres:
    image: postgres:alpine
    environment:
      POSTGRES_DB: cocov
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      PGDATA: /var/lib/postgresql/data/pgdata
    volumes:
      - ./postgres-storage:/var/lib/postgresql/data
```

### Initializing the API

Then, create new services for the API and Sidekiq:

```yaml
version: "3"
services:
  # snip 8<

  api:
    image: cocov/api:v0.1
    env_file: env/api
    ports:
      - 3000:3000
    volumes:
      - ./git-storage:/git-storage
    depends_on:
      - redis
      - postgres

  sidekiq:
    image: cocov/api:v0.1
    env_file: env/api
    command: ["bundle", "exec", "sidekiq"]
    volumes:
      - ./git-storage:/git-storage
    depends_on:
      - redis
      - postgres
```

Both services share the same `env_file`, `volumes`, e `depends_on`.

### API's environment variables
Create a new `env` directory at the same level as your `docker-compose.yaml`,
then create a new `api` file within it:

```
COCOV_GITHUB_ORG_NAME=
COCOV_GITHUB_APP_ID=
COCOV_GITHUB_APP_INSTALLATION_ID=
COCOV_GITHUB_OAUTH_CLIENT_ID=
COCOV_GITHUB_OAUTH_CLIENT_SECRET=
COCOV_GITHUB_APP_PRIVATE_KEY=
COCOV_GITHUB_WEBHOOK_SECRET_KEY=

COCOV_GIT_SERVICE_LOCAL_STORAGE_PATH=/git-storage

COCOV_DATABASE_USERNAME=postgres
COCOV_DATABASE_PASSWORD=postgres
COCOV_DATABASE_NAME=cocov
COCOV_DATABASE_HOST=postgres

SECRET_KEY_BASE=
COCOV_CRYPTOGRAPHIC_KEY=
COCOV_UI_BASE_URL=
# Uncomment and set the following property in case you intend to use the Badger
# service
# COCOV_BADGES_BASE_URL=
```

Keys are grouped by scope. `COCOV_GITHUB` contains information about the GitHub
App you provisioned. `COCOV_GIT_SERVICE_LOCAL_STORAGE` indicates where Git data
will be stored. This is the shared volume that was mounted both on API and
Sidekiq services. Then, `COCOV_DATABASE` contains connection information for the
system database. The last group contains other keys that could not be part of
the previous ones. A list of all available keys and their usage is available
under the API's {% doclink "API/Configuration Options" %} page.

Once all options are set, it's time to initialize the database:

### Initializing the Database

Initializing the database can be done in a single command:

```bash
docker compose run --rm -it api bundle exec rails db:migrate
```

Once this is done, it is time to configure the Web UI:


### Initializing the Web UI

Unlike the API, the Web UI needs way less configuration. First, update
`docker-compose.yaml` to add a new `ui` service:

```yaml
version: "3"
services:
  # snip 8<

  ui:
    image: cocov/web:v0.1
    env_file: env/ui
    ports:
      - 4000:3000
    depends_on:
      - api
```

Then, create a new `ui` file under the `env` directory. It will need the
following contents:

```
COCOV_API_URL=http://api:3000
COCOV_UI_URL=https://cocov.vito.io
```

`COCOV_API_URL` is the URL that the UI server will use to connect to the API. On
this case we are pointing to the internal API docker service. then,
`COCOV_UI_URL` must be set using the same value as the API's `COCOV_UI_BASE_URL`.

Start the new instance using `docker compose up -d`. This will download and
start the UI server, which will be available on port `4000`. Then, configure
your reverse proxy as required, if any, in order to access the UI. Once there,
login using your GitHub account, and you will be presented the Cocov homepage
with no repositories. _Do not add a repository yet_, as we will need to
configure the Worker to be able to process checks.

## Initializing the Worker

The first step to initialize the Worker is to create a new {% doclink "Service Tokens", title: "Service Token" %}.
Access the {% doclink "Administration", title: "Adminland" %}, select
_Service Tokens_, and create a new one, using a descriptive name. Take note of
the token, since it will not be displayed again.

{% info %}
**Notice**: Kubernetes documentation on {% doclink "Initializing the Worker instance" %}
goes through the process of creating a Service Token in detail. Feel free to follow
instructions from that section, if required.
{% endinfo %}

### Adding a DinD container

DinD stands for _Docker in Docker_, which the Worker leverages to provide a
pristine isolated container for each check. DinD, however, uses TLS to secure
communication with the daemon, meaning the Worker will need to have access to
its keys and certificates. In order to satisfy this requirement, two volumes
must be provisioned and shared between `docker` and `worker`. The first step is
to define those volumes. In `docker-compose.yaml`, at the same level as
`services`, add a new `volumes` key, as shown below:



```yaml
version: "3"
services:
  # snip 8<
volumes:
  docker-ca:
  docker-certs:
```

Then, create the new `docker` service:

```yaml
version: "3"
services:
  # snip 8<
  docker:
    image: docker:dind
    privileged: true
    environment:
      - DOCKER_TLS_CERTDIR=/certs
    volumes:
      - docker-ca:/certs/ca
      - docker-certs:/certs/client

volumes:
  # snip 8<
```

{% warning %}
**Notice**: `docker:dind` requires `privileged` access on the host's Docker instance,
since it requires extra permissions in order to run nested containers.
{% endwarning %}

### Adding the Worker service
Now, add the `worker` service to `docker-compose.yaml`:

```yaml
version: "3"
services:
  # snip 8<
  worker:
    image: cocov/worker:v0.1
    env_file: env/worker
    environment:
      - DOCKER_TLS_CERTDIR=/certs
    volumes:
      - ./git-storage:/git-storage
      - docker-certs:/certs/client:ro
    depends_on:
      - api
      - redis
      - docker

volumes:
  # snip 8<
```

As can be noted from the snipped above, the Worker requires access to
certificates generated by the `dind` daemon, and also to the `git-storage`
directory shared between the API and Sidekiq services. It also declares
dependencies on `docker`, `redis`, and the `api` itself.

Next, it is time to configure the Worker environment. Create a new `worker` file
on the `env` directory, with the following contents:

```
REDIS_URL=redis://redis:6379/0
API_URL=http://api:3000
SERVICE_TOKEN=

GIT_SERVICE_STORAGE_MODE=local
GIT_SERVICE_LOCAL_STORAGE_PATH=/git-storage

# Uncomment the line below in case you intend to also setup the Cache service:
# CACHE_SERVER_URL=http://cache:5000

DOCKER_SOCKET=tcp://docker:2376
DOCKER_TLS_CA_PATH=/certs/client/ca.pem
DOCKER_TLS_CERT_PATH=/certs/client/cert.pem
DOCKER_TLS_KEY_PATH=/certs/client/key.pem
```

The only key that must be filled is `SERVICE_TOKEN`. Insert the value you
obtained from the beginning of this section. Also, in case you intend to setup
the optional Cache service, uncomment the respective line.

## Configuring the Cache (Optional)

In case you wish to also use the Cache service on this instance, first create
and take note of a new Service Token. Then, add it to `docker-compose.yaml`:

```yaml
version: "3"
services:
  # snip 8<
  cache:
    image: cocov/cache:v0.1
    env_file: env/cache
    volumes:
      - ./cache_data:/cache-data
    depends_on:
      - api
      - redis

volumes:
  # snip 8<
```

Next, create a new `cache` file under the `env` directory, with the following
contents:

```
REDIS_URL=redis://redis:6379
CACHE_STORAGE_MODE=local
CACHE_LOCAL_STORAGE_PATH=/cache-data
API_URL=http://api:3000
API_TOKEN=
```

Again, the only key that need to be filled is `API_TOKEN`. Additional
configuration options are available and listed under the Cache's {% doclink "Cache/Configuration Options" %}
page.

## Configuring the Badger
In case you wish to also use the Badger service on this instance, first create
and take note of a new Service Token. Then, add it to `docker-compose.yaml`:

```yaml
version: "3"
services:
  # snip 8<
  badger:
    image: cocov/badger:dev
    env_file: env/badger
    ports:
      - 7000:4000
    depends_on:
      - api

volumes:
  # snip 8<
```

Next, create a new `badger` file under `env`, with the following contents,
updating `COCOV_BADGER_API_SERVICE_TOKEN` accordingly.

```
COCOV_BADGER_BIND_ADDRESS=0.0.0.0
COCOV_BADGER_API_URL=http://api:3000
COCOV_BADGER_API_SERVICE_TOKEN=
```

## Finish Up

Finally start all services using `docker compose up -d`, and check for their
statuses. When all instances are up and running, your instance is ready for use.
