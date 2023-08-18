---
title: "Configuration Options"
id: "configuration-options"
layout: documentation
toc: true
---

{% include helm-chart-warning.html %}

## GitHub Configuration
As mentioned a few times throughout this documentation, Cocov relies on a few
resources provided by GitHub. Users are authenticated, repository data, and
events are all obtained from their systems. On the {% doclink "Installation" %}
guides, the first step mentioned is "_{% doclink "Creating a GitHub App" %}_".
This section uses several of the values obtained from that process.

| Variable Name                         | Description                          |
|---------------------------------------|--------------------------------------|
| `COCOV_GITHUB_ORG_NAME`               | The name of the GitHub Organization in which Cocov is being installed on. |
| `COCOV_GITHUB_APP_ID`                 | The GitHub App numeric ID for the created App. |
| `COCOV_GITHUB_APP_PRIVATE_KEY`        | The Private Key provided by GitHub when creating the app. This value must include the private key encoded in base64. |
| `COCOV_GITHUB_APP_INSTALLATION_ID`    | The installation identifier of the app after installing it on the target organization. Check installation documentation for details. |
| `COCOV_GITHUB_OAUTH_CLIENT_ID`        | The GitHub App's Client ID used for OAuth authentication. Not to be confused with App ID. |
| `COCOV_GITHUB_OAUTH_CLIENT_SECRET`    | The GitHub App's Client Secret used to authenticate users through GitHub. |
| `COCOV_GITHUB_WEBHOOK_SECRET_KEY`     | The secret value passed to the GitHub App's Webhook configuration used as a salt to hash contents delivered from them. |
| `COCOV_ALLOW_OUTSIDE_COLLABORATORS`   | Indicates whether users belonging to the _Outside Collaborators_ group may access this Cocov instance. Accepts values such as `true` and `false`.|

## Common URLs
Common URLs are URLs that may be used by external clients and users to access
this instance's resources. For instance, `COCOV_UI_BASE_URL` must be the base
URL that user's will use to access this instance's Web UI. This will not be
resolved by the API, but will be used to compose URLs passed and displayed on
GitHub Statuses, for instance.

| Variable Name                         | Description                          |
|---------------------------------------|--------------------------------------|
| `COCOV_UI_BASE_URL`                   | The complete base URL the users use to access Cocov. The URL may be hosted behind a VPN, but must be accessible to your users; the same URL is used by the API facility to generate URLs used by GitHub to direct users to Cocov's internal pages. Format is `http[s]://domain.for.cocov` |
| `COCOV_BADGES_BASE_URL`               | If {% doclink "Badger" %} is enabled, this variable must contain the base URL for users and other external services to access Cocov's Badger service. Providing this value indicates to the API that the badger service is active on this instance, and the value will be provided to other facilities to allow users to copy-paste the value to other external services such as READMEs. |

## Redis Configuration

Cocov leverages Redis for several processes, from Caching to lock coordination,
to inter-process communication. URLs passed through those values may point to
the same server, but it is strongly recommended to use [different databases](https://redis.io/commands/select/)
on this case. Each URL must be in the format
`redis[s]://[[username:]password@]host[:port][/database]`.

| Variable Name                         | Description                          |
|---------------------------------------|--------------------------------------|
| `COCOV_REDIS_URL`                     | The URL for the primary Redis database used by Cocov. This database will be used for primary operations, which are essential for platform operation. |
| `COCOV_REDIS_CACHE_URL`               | The URL for a Redis instance or database to used for caching operations. Although the instance must be accessible, data loss should not affect normal operation, only possibly slow it down. |
| `COCOV_SIDEKIQ_REDIS_URL`             | The URL for a Redis used exclusively by Sidekiq to schedule and perform background operations. |

## Storage Configuration

The platform automatically keeps a shallow copy of commits to quickly create
views that displays code assciated with an issue or test coverage data.

Currently, Cocov supports storing data either on a local volume, or an S3
bucket, which is defined by the following environment variable:

| Variable Name                         | Description                          |
|---------------------------------------|--------------------------------------|
| `COCOV_GIT_SERVICE_STORAGE_MODE`      | Which storage mode to use. Must be either `local` or `s3`. |

Then, depending on the chosen mode, one of the following extra variables must
also be defined:

### Local Storage Mode

The Local Storage mode stores data in a local shared directory. The directory
must be also accessible by other components such as the {% doclink "Worker" %}.
Although the path must exist locally, it may point to an NFS share, for instance.

| Variable Name                          | Description                          |
|----------------------------------------|--------------------------------------|
| `COCOV_GIT_SERVICE_LOCAL_STORAGE_PATH` | The path in which the platform will store files. It must exist and also be available to the Worker facility. |

### S3 Storage Mode

The S3 storage mode stores shared data within a S3 bucket, and only takes the
target bucket name. All other configuration options are processed by the AWS
SDK. Refer to its documentation for further information.

| Variable Name                              | Description                          |
|--------------------------------------------|--------------------------------------|
| `COCOV_GIT_SERVICE_S3_STORAGE_BUCKET_NAME` | The bucket name to be used to store Git data |

## Cryptographic Key

Cocov uses an user-defined cryptographic key to encode sensitive information
like Secrets, and other data stored on databases or transferred
through Redis. The key must be compsosed of 32 hexadecimal characters.

| Variable Name                              | Description                          |
|--------------------------------------------|--------------------------------------|
| `COCOV_CRYPTOGRAPHIC_KEY`                  | 32 hexadecimal characters representing the cryptographic key used to encode data |

## Cache Configuration

In case {% doclink "Cache" %} is enabled on this instance, those keys configure
where the Cache server is located, and the quota for each repository. Although
those keys belong to the Cache service, they must be defined on the API, which
is responsible for bookeeping and cleanup requests.

| Variable Name                              | Description                          |
|--------------------------------------------|--------------------------------------|
| `COCOV_REPOSITORY_CACHE_MAX_SIZE`          | The size, in bytes, of how much data each repository may store in the cache. A zero value or in case the value is empty indicates no limit. |
| `COCOV_CACHE_SERVICE_URL`                  | The URL to the Cache service, if enavled on this instance. |
