---
title: "Platform Components"
id: "platform-components"
layout: documentation
---

Cocov's Platform is composed of a few smaller components in order to isolate
them and provide optional capabilities that are not necessarily required for
every workload.
The diagram below lists all components and their relations.

Components with dashed borders are optional, and instances can work normally
without them. _Repository Storage_ and _Cache Storage_ lists all storage
mediums supported by the platform, whereas only one of each list may be
used for each storage.

![](/assets/images/diagrams/all-components.png)

### Required Dependencies

- [PostgreSQL](https://postgresql.org)
- [Redis](https://redis.io)

### Base Components

- {% doclink "API" %}
- {% doclink "Sidekiq" %}
- {% doclink "Web UI" %}
- {% doclink "Worker" %}

### Optional Components

- {% doclink "Badger" %}
- {% doclink "Cache" %}

## On This Section

- {% doclink "API" %}
    - {% doclink "API/Configuration Options" %}
- {% doclink "Sidekiq" %}
- {% doclink "Web UI" %}
- {% doclink "Worker" %}
    - {% doclink "Worker/Configuration Options" %}
- {% doclink "Cache" %}
    - {% doclink "Cache/Configuration Options" %}
- {% doclink "Badger" %}
