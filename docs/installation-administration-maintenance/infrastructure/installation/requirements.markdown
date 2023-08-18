---
title: "Requirements"
id: "requirements"
layout: documentation
---

{% include beta-warning.html %}

As listed by {% doclink "Platform Components" %}, Cocov requires a few base
components to be able to start:

## PostgreSQL

Cocov's principal data storage facility is PostgreSQL, which is used solely by
the {% doclink "API" %} to store user data, repositories, commits, check results,
coverage data, and statistics that are shown on the UI or returned through API
endpoints.

Although where the database is host is not really important — minding the
latency, — the user the API uses to connect to said database must have
permission to create/update/delete tables (as required by Rails migration
mechanism), and to create/read/update/delete data on those tables.

## Redis

Redis is heavily used for a few different activities required by almost all of
Cocov's components, such as:

- Inter-process communication
- Ephemeral data storage
- Cache
- Distributed locks
- Queues

Just like PostgreSQL, Cocov does not mind where your Redis instance is located,
as long as it is able to quickly reply to components. The configuration
documentation requires three different Redis URLs for different usages; those
URLs may point to the same Redis instance, as long as they use different
databases. We have successfully ran relatively large Cocov installations with
a single Redis database without issues.

## Data Storage

Data storage is essential to Cocov's runtime, as it clones and reads data from
commits, meaning a reliable storage medium is of great importance.
Additionally, such storage must also be able to accommodate concurrent accesses
from more than one component, as {% doclink "API" %}, {% doclink "Sidekiq" %}, and
the {% doclink "Worker" %} may require data to be read/written to such storage.

| Component | Read/Write? |
|-----------|-------------|
| API       | Read/Write  |
| Sidekiq   | Read/Write  |
| Worker    | Read-Only   |

Additionally, extra storage may need to be provisioned if the instance being
set up intends to leverage the {% doclink "Cache" %} service to speedup checks.

When leveraging AWS S3 or Minio as a storage backend, make sure to allow both
bucket and its objects to be accessible by Cocov. In terms of policy, the
following actions should be permitted:

- `s3:Put*`
- `s3:Get*`
- `s3:List*`
- `s3:Delete*`

On both the bucket and its sub-resources. Given a bucket named
`foobar-cocov-storage`, the following resources should be present in the policy
statement:

- `arn:aws:s3:::foobar-cocov-storage`
- `arn:aws:s3:::foobar-cocov-storage/*`

## Ingress/Egress

Cocov requires requests from the internet to be able to reach the API, and the
{% doclink "Badger" %} if enabled, and to make external requests to a few
different services.

The system makes requests to GitHub.com, Docker Hub, and may make arbitrary
requests to download dependencies from projects being checked, tooling such as
interpreters and/or compilers, and images for plugins being used by projects.

{% info %}
**Notice**: Cocov does not collect or send telemetry data anywhere. However,
caution is advised when using third-party plugins. Make sure to review plugins
before using them.
{% endinfo %}
