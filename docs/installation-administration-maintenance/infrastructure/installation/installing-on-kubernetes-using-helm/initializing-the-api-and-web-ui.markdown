---
title: "Initializing the API and Web UI"
id: "initializing-the-api-and-web-ui"
layout: documentation
toc: true
---

{% info %}
**Notice**: This assumes all {% doclink "Requirements", title: "dependencies" %}
were provisioned, a {% doclink "Creating a GitHub App", title: "GitHub App" %}
was created, and a {% doclink "Installing on Kubernetes using Helm", title: "storage medium" %}
was chosen.
{% endinfo %}
<br/>

Configuring the chart is easy, and all configuration is separated into groups.
This page contains information on how to initialize the API and UI. This is
required in order to perform the initial authentication and create
{% doclink "Service Tokens" %} for other components.

## Configuring the API

All API keys are contained within the `api` object. The following keys are
**required**:

### `api.secretKeyBase`
`secretKeyBase` is used by Rails cryptographic facilities. It is recommended to be
composed of a 32-byte, base64 encoded random value.
This value may be provided as a `secretKeyRef` or `configMapKeyRef`.

The value can be easily generated by piping `head` into `base64`:

```bash
head -c 32 /dev/urandom | base64
```

### `api.cryptoKey`
`cryptoKey` is used by Cocov's encryption facilities to encode sensitive data
stored on databases and memory-storage components such as Redis. Must be
composed of 32 hexadecimal characters.
This value may be provided as a `secretKeyRef` or `configMapKeyRef`.

The value can be easily generated by leveraging `xxd`:

```bash
xxd -l 16 -p /dev/urandom
```

### `api.github`
The `github` subkey contains all GitHub information the platform requires to
operate.

### `api.github.orgName`
`orgName` is the name of the GitHub organization in which Cocov is installed
This value may be provided as a `secretKeyRef` or `configMapKeyRef`.

### `api.github.app`
The `github.app` subkey contains all information regarding the GitHub App created
and installed into the organization. For more information, see
{% doclink "Creating a GitHub App" %}.

Most of keys may be obtained accessing
`https://github.com/organizations/<your organization name>/settings/apps` and
clicking the application you created as part of the setup process described in
{% doclink "Creating a GitHub App" %}.
Documentation for subkeys will constantly mention contents from pages found
under that app page.

### `api.github.app.id`

`id` is the GitHub's App numeric identifier, obtained from the application's
configuration _General_ page, over at the _About_ section as _App ID_.
This value may be provided as a secretKeyRef or configMapKeyRef.

![A red arrow showing the placement of the App ID field](/assets/images/docs/initialize-api-github-app-id.png){: .screenshot}

### `api.github.app.clientID`

`clientID` is the GitHub's App client ID, obtained from the application's
configuration _General_ page, over at the _About_ section as _Client ID_.
(Not to be confused with _App ID_.)
This value may be provided as a `secretKeyRef` or `configMapKeyRef`.

![A red arrow showing the placement of the client ID field](/assets/images/docs/initialize-api-github-client-id.png){: .screenshot}

### `api.github.app.installationID`

`installationID` is the installation identifier generated by GitHub after the
GitHub App created during the Cocov's setup process is effectively installed on
the organization. The value can be obtained by visiting the GitHub App page ,
choosing _Install App_ on the leftmost menu, and then clicking on the gear
button. The installation ID will be available as the last component of the
page's URL. For instance:

```
https://github.com/organizations/cocov-ci/settings/installations/12345678
```

The installation ID for the `cocov-ci` organization would be `12345678`.

This value may be provided as a `secretKeyRef` or `configMapKeyRef`.


### `api.github.app.privateKey`

`privateKey` is the private key provided by GitHub when creating the
organization's app, used to sign access token requests. During the
{% doclink "Creating a GitHub App" %} step, you must have downloaded a file
containing the private key. The value this property takes is the base64-encoded
contents of this file.

This value may be provided as a `secretKeyRef` or `configMapKeyRef`.

### `api.github.app.clientSecret`
`clientSecret` is the value of the GitHub's app Client Secret used to
authenticate users through GitHub. During the
{% doclink "Creating a GitHub App" %} step, you must have created and copied the
secret key. Provide it to this field.

This value may be provided as a `secretKeyRef` or `configMapKeyRef`.

### `api.github.app.webhookSecret`
`webhookSecret` is the secret value passed to the GitHub App's webhook
configuration and is used to secure hashes received from it.

This value may be provided as a `secretKeyRef` or `configMapKeyRef`.

### `api.db`
The `db` subkey contains configuration required by the API and Sidekiq to
connect to the platform's main database.

### `api.db.host`
`host` is either an IP, hostname, or FQDN of the database server.
This value may be provided as a `secretKeyRef` or `configMapKeyRef`.

### `api.db.name`
`name` is the name of the database to be used to store Cocov's relational
data.
This value may be provided as a `secretKeyRef` or `configMapKeyRef`.

### `api.db.username`

`username` is the username Cocov will use to authenticate against the
database.
This value may be provided as a `secretKeyRef` or `configMapKeyRef`.

### `api.db.password`

`password` is the password Cocov will use to authenticate against the
database.
This value may be provided as a `secretKeyRef` or `configMapKeyRef`.

Finally, the smallest configuration for the API component would be something
along the following:

```yaml
cocov:
  api:
    secretKeyBase: "X2Pg1WwMFoQysKnY/nXbq0tB8FT70/HJrWtgmGAHaj9C2ZhX60yXhEmWy6cfBdB36Rrt3OOy8B3Wv8UdyLhSewlSVSyjyw4/HLYKNcU3mPyqAEh+rO2KbOdHYuzS5C1GlbOSfKSSu3KURomaX7adOOjvIswbYBW8DgAJVUG52DA"
    cryptoKey: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"

    github:
      orgName: "cocov-ci"
      app:
        clientID: "Iv1.aaaaaaaaaaaaaaaa"
        clientSecret: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
        id: "XXXXXX"
        installationID: "XXXXXXXX"
        webhookSecret: "a big Base64 value, a vault: reference, a secretKeyRef or configMapKeyRef"
    db:
      host: "my-cocov-db.us-east-1.rds.amazonaws.com"
      name: "cocov"
      password:
        secretKeyRef:
          key: "password"
          name: "cocov-database-credentials"
      username:
        secretKeyRef:
          name: "cocov-database-credentials"
          key: "username"
      port: 5432
```

----

## API Ingresses

The chart allows ingresses to be defined within itself, but those may as well
be disabled in case one wants to roll their own ingresses. In case one decides
to use the chart's ingresses, do notice the following:

As mentioned in the documentation, the API requires a specific route to be
exposed to the internet in order to receive requests from GitHub's webhook. The
chart provides one ingress that provides access to all the API endpoints under
the `ingress` key, and another ingress configured to serve a single URL under
`publicIngress`. The only difference between them is the routes available, and
they don't actually provide any kind of protection as this is left for the
implementer to decide.

Both ingresses provide the following options:

### `api.(publicIngress|ingress).enabled`
Whether the ingress is enabled or not. Disabling it prevents the ingress from
being applied by the chart.

### `api.(publicIngress|ingress).annotations`
A set of annotations to be provided to the ingress

### `api.(publicIngress|ingress).hosts`
A list of hosts to be provided to the ingress

### `api.(publicIngress|ingress).tls`
A list of TLS configuration to be provided to the ingress

### `api.(publicIngress|ingress).ingressClassName`
`ingressClassName` is the name of an `IngressClass` cluster resource.
Ingress controller implementations use this field to know whether they should be
serving this Ingress resource, by a transitive connection (controller ->
`IngressClass` -> Ingress resource).

For instance, the following would configure both ingresses for Cocov:

```yaml
cocov:
  api:
    # Required API options would go here...

    ingress:
      enabled: true
      ingressClassName: "nginx"
      hosts:
        - "my-cocov-api.mydomain.com"

    publicIngress:
      enabled: true
      ingressClassName: "nginx"
      hosts:
        - "cocov-ext-api.mydomain.com"
```

In this scenario, `my-cocov-api.mydomain.com` would route all requests to all
possible routes to the API, but the only possible route for
`cocov-ext-api.mydomain.com` is `/v1/github/events`.

Again, this is provided as a convenience to make separating those endpoints
easier, but are in no way required. One may use a single ingress for all traffic
if they wish so.

## Configuring the Storage Medium
Storage configuration is done through the `storage` subkey of the chart, not the
`api`. This is due to the fact that those values are shared with Worker and
Sidekiq, so isolating it on the `api` subkey seemed dissonant.

As mentioned several times, storage can be configured to use a local volume
or S3/Minio bucket. For a local volume, the following would suffice:

```yaml
cocov:
  api:
    # Snip! 8<
  storage:
    local:
      enabled: true
      volume:
        persistentVolumeClaim:
          claimName: cocov-system-storage-pvc
```

The value of `volume` is provided verbatim to the container's volume list, so
as long as the volume type is known by your cluster, it will work. It is not
required to provide a `name`, any value provided to the `name` property will be
discarded.

To use S3 or Minio, use `s3` instead of `local`:

```yaml
cocov:
  api:
    # Snip! 8<
  storage:
    s3:
      enabled: true
      bucketName: my-bucket-for-cocov-system-storage
```

## Providing Redis Connectivity

Redis connectivity is provided through the `cocov.redis` subkey. The key and all
subkeys are **required**.

As was already mentioned, using the same server for all three URLs is safe as
long as different databases are specified.

URLs must be in the format `redis[s]://[[USER]:PASSWORD]@HOST[:PORT]/DATABASE_ID`
### `redis.commonURL`

`commonURL` is the base URL for a Redis instance that Cocov will use for primary
operations. Those operations are essential for normal operation.

This value may be provided as a `secretKeyRef` or `configMapKeyRef`.

### `redis.cacheURL`

`cacheURL` is the URL for a Redis instance or database to used for caching
operations. Although the instance must be accessible, data loss should not
affect normal operation, only possibly slow it down.

This value may be provided as a `secretKeyRef` or `configMapKeyRef`.

### `redis.sidekiqURL`

`sidekiqURL` is the URL for a Redis used exclusively by Sidekiq to schedule
and perform background operations.

This value may be provided as a `secretKeyRef` or `configMapKeyRef`.


Using all of the required keys, the following objects is obtained, for instance:

```yaml
cocov:
  api:
    # Snip! 8<
  storage:
    # Snip! 8<
  redis:
    commonURL: redis://cocov-redis-master.cocov.svc.cluster.local:6379/0
    cacheURL: redis://cocov-redis-master.cocov.svc.cluster.local:6379/1
    sidekiqURL: redis://cocov-redis-master.cocov.svc.cluster.local:6379/2
```


## Configuring the UI

The UI component requires little configuration, but getting it right is
essential. The following keys are required:

### `ui.externalURL`
Represents the complete base URL the users use to access Cocov.
The URL may be hosted behind a VPN, but must be accessible to your users; the
same URL is used by the API facility to generate URLs used by GitHub to direct
users to Cocov's internal pages. Format is `http[s]://domain.for.cocov`.
If you are using the UI ingress provided by the chart, the value of this field
usually reflect the host used with the ingress, with the difference that it must
contain the URL schema.

This value may be provided as a `secretKeyRef` or `configMapKeyRef`.

An example of UI configuration is:

```yaml
cocov:
  api:
    # Snip! 8<
  storage:
    # Snip! 8<
  redis:
    # Snip! 8<
  ui:
    externalURL: https://cocov.mydomain.com
    ingress:
      enabled: true
      ingressClassName: nginx
      hosts:
        - cocov.mydomain.com
```

----

Then, perform the first deploy of the chart, and check if pods are healthy.
Finally, access your instance on the address provided to `cocov.ui.externalURL`,
and authenticate using GitHub. You should then be able to see a page indicating
that there are no repositories configured. If you see it, congratulations! You
have configured the bare minimum to be able to connect to your Cocov instance.
It will not be able to process checks, though. If you are unable to get to the
aforementeioned page, please refer to {% doclink "Troubleshooting" %}.

If everything is working as it should, proceed to {% doclink "Initializing the Worker instance" %}.
