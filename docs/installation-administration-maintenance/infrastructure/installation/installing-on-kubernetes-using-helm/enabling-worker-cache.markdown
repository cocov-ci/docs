---
title: "Enabling Worker Cache"
id: "enabling-worker-cache"
layout: documentation
---

As explained in {% doclink "Platform Components/Cache" %}, the Cache is
responsible for providing a space for Plugins to store reusable data such as
dependencies in order to speedup future runs.

## Choosing a Storage Medium

It is important to understand requirements for cache storage as mentioned in
{% doclink "Choosing a Storage Medium", hash: "cache-data" %}, as it is
essential for good performance.

## Configuring the Chart

Since the Cache requires a connection with the API, a new {% doclink "Service Tokens", title: "Service Token" %}
must be created. Access the {% doclink "Administration", title: "Adminland" %},
select _Service Tokens_, and create a new one, using a descriptive name. Take
note of the token, since it will not be displayed again.

{% info %}
**Notice**: {% doclink "Initializing the Worker instance" %} goes through the
process of creating a Service Token in detail. Feel free to follow instructions
from that section, if required.
{% endinfo %}

Then, update the chart to enable the cache, and provide the new service token
to it:

```yaml
cocov:
  cache:
    enabled: true
    apiToken:
      valueFrom:
        secretKeyRef:
          name: cocov-secrets
          key: cache-api-token
```

## Configuring Storage

Just like other Cocov services that require storage, Cache accepts both a local
path as the storage path, or an S3 (or Minio) bucket. Then, configure storage
options accordingly:

```yaml
cocov:
  cache:
    # Snip! 8<
  cacheStorage:
    local:
      enabled: true
      volume:
        persistentVolumeClaim:
          claimName: cocov-system-cache-pvc
```

The value of `volume` is provided verbatim to the container's volume list, so
as long as the volume type is known by your cluster, it will work. It is not
required to provide a `name`, any value provided to the `name` property will be
discarded.

To use S3 or Minio, use `s3` instead of `local`:

```yaml
cocov:
  cache:
    # Snip! 8<
  cacheStorage:
    s3:
      enabled: true
      bucketName: my-bucket-for-cocov-system-cache
```

## Limiting Repository Usage
In order to prevent the cache from growing without a limit, Cocov allows limits
to be set on a per-repository basis, meaning that the platform can automatically
remove older items when a repository uses a given amount of cache storage.

By default, such limit is disabled, but it can be configured through the
`cocov.cache.repositoryMaxSize` key:

```yaml
cocov:
  cache:
    repositoryMaxSize: 4Gi
```

The format is a storage unit just like the ones Kubernetes uses. This value
can also be provided as a `secretKeyRef` or `configMapKeyRef`.

## Finishing Up

Once enabled, cache will automatically be used by plugins during runs.
Information about usage can then be found on Adminland and on each repository's
settings page.
