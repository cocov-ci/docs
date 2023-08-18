---
title: "Cache"
id: "cache"
layout: documentation
---

Cocov's Cache mechanism is a special service that allows plugins running on
{% doclink "Worker" %} to store versions of tools and/or pre-processed assets
that are required for checks to be executed in specific repositories (such as Go
modules or NPM dependencies), which may take a while to reinstall on every run,
allowing checks to perform faster.

The cache is split into two zones. The first one is common to all repositories,
and is used to cache _tools_. Tools can be system dependencies, or a full Ruby
installation, for instance. As those assets may be reused among all
repositories, the are stored in a special location and are not associated to
any commit or repository.

The second one is the _artifact_ storage. Artifacts belongs to repositories, and
are tied to specific files, allowing those artifacts to be found across checks,
if required.

## How Cache is Used
Caching is available for plugins to use, although they are not supposed to know
whether the cache facility is enabled on an instance. Plugins requesting
artifacts on instances without an Cache service in place receives the same
response from the Worker as if the service was present, but didn't find a cache
artifact. Similarly, if a plugin attempts to store an artifact in an instance
without a cache in place, the Worker emulates a success message to the plugin,
without actively storing the payload.

Conventions for storing tools exist and are listed in
{% doclink "Plugin Development" %}.

## How Artifacts are Stored
The artifact cache is supposed to be used to store caches and/or dependencies in
order to allow checks to be performed faster. For instance, running ESLint
requires dependencies to be pulled from the internet and installed through a
package manager like NPM and Yarn. Storing a cache of the project's
`node_modules` can improve initialization times, as the package manager would
not need to download and unpack all dependencies — and NodeJS itself.

For instance, a NodeJS plugin could utilize the output of a hashing function
that takes both the `package.json` and `package-lock.json` files as input. By
using the resulting hash as a key, the plugin can easily reuse the artifact in
subsequent builds as long as the contents of both files are the same. Upon a
change to those files, dependencies would be downloaded again, and a new
artifact is then created. Cocov SDKs already abstracts this process, and only
require a list of files to be _digested_, and the path of a directory to have
its contents cached in order to work.

## Preventing Unbounded Cache Growth
Storage is not infinite, and keeping things we don't need around is not really
sustainable. With that in mind, Cocov allows quotas to be defined to cache
storage on a per-repository basis. The quota is defined once, and is applied to
every repository. When a repository is about to, or already surpassed its quota,
the API identifies the oldest unused items and automatically requests their
eviction in order to keep the repository under the defined quota.

{% info %}
**Notice**: At the time of writing, Cocov does not provide a way to reapply
quotas after changing configuration parameters. If the value is adjusted,
repositories surpassing the defined limit will have their contents cleaned
after a new item is pushed to the cache.
{% endinfo %}
