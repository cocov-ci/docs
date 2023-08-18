---
title: "Worker"
id: "worker"
layout: documentation
---

Cocov's Worker is responsible for orchestrating Checks runs, and emitting their
results to the {% doclink "API" %}. When a new commit is pushed to a repository
that is being tracked by a Cocov instance, and either the commit itself or a
parent commit includes a `.cocov.yaml` manifest defining Checks to be executed,
API enqueues a new check on Worker's job queue, to be executed asynchronously.

A check comprises one or more plugins to be executed against files of a given
commit. Each repository may indicate which plugins to use and other settings on
their Manifest file. See {% doclink "Checks & Limits: The Manifest File" %}.

Each plugin image is then downloaded and a new container is created to execute
it against the obtained commit. The Worker then watches the plugin execution
state, and depending on the result, obtains all findings, sending those to the
API for further processing. After all checks are done, containers are
automatically removed and the worker thread is then cleared to take the next
commit to be checked. For information on developing plugins, see
{% doclink "Plugin Development" %}.

Each Worker must have its own [DinD](https://hub.docker.com/_/docker) instance
to manage. This way, Workers can be horizontally scaled, and workloads can be
safely split. It is also responsible for emitting status updates to the API,
which then updates GitHub statuses, and providing extra error information in
case of failures, which can then be displayed by the {% doclink "Web UI" %}.
