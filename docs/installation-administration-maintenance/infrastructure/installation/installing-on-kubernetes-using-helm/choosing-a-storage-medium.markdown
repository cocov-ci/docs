---
title: "Choosing a Storage Medium"
id: "choosing-a-storage-medium"
layout: documentation
---

The importance of choosing the right storage medium is described thoroughly on
other parts of this documentation. This section describes which kind of data
Cocov stores, and where, along with options for storing such data.

## Commit Data

Every time the platform receives an event from GitHub indicating that a new
commit has been pushed, it download, clean, and store it within a predetermined
storage location. This location in specific must be shared between three
components, those being the API, the Worker, and Sidekiq. The API and Sidekiq
may require access to it in order to prepare previews, coverage results, and
reading the manifest present in that commit, if any. The Worker requires a full
copy of the all files from the commit in order to mount them for plugins to
access.

On Kubernetes, there are four options to provide this storage to the platform:

1. Using a remote storage service like S3
2. Using a local storage service like Minio
3. Using a local storage within a node through a StatefulSet
4. Using a local storage provided through NFS, for instance.

Each option have their pros and cons, and they must be weighted by sysadmins in
order to provide a good experience to their users. This collection of data is
the most essential for the platform to function correctly, so a stable and fast
access to those files are critical. Also, losing data stored in this collection
will lead to errors and unexpected behaviors from the platform, so ensuring data
integrity is crucial.

{% warning %}
**Warning**: Do not manually alter, move, delete, or create files within this
storage medium. Do not share it with other applications, and make sure to
properly secure any medium used, as it may contain sensitive data from projects
being analyzed by the platform.
{% endwarning %}


## Cache Data

Cocov may store, if the Cache service is enabled, two different kinds of data to
speedup checks. One is what is called "tool artifacts" which are packages
containing interpreters, compilers, package managers, and other tools used to
build, maintain dependencies, and any other operation regarding a language's
infrastructure, but not tied to a specific repository. This prevents the
platform from downloading those tools every time a check is executed, and
saves time, and possibly bandwidth costs.

The other kind of cached data are dependencies. Some plugins may require all
dependencies to be present in order to run checks, and downloading, installing,
and in some cases compiling dependencies may as well take some time which may
vary due an array of variables. For those cases, plugins may opt to cache a
project's dependencies on the local cache, and restore them based on whether
files describing those dependencies were changed.

The medium storing cache data does not need to be as well kept as the Commit
Data medium, but some important points must be noticed:

1. The Cache service coordinates locks and whether the presence of a given
artifact (tool or dependency) by leveraging the API. This means that keeping
storage in different regions, for instance, is currently not possible.
2. The service is able to detect inconsistencies between data provided by the
API and data present on the chosen medium, meaning that it gracefully handles
cases in which the API may indicate that a given object exists, while it is
absent from the storage.
3. Latency to the cache storage medium directly affects pushing and pulling data
from it, which may then affect how long checks take to begin and finish.

Options to maintain this medium are the same as listed on the Commit Data
section, as we are limited to options provided by Kubernetes.

----

The chart will handle all cases that either points to S3/Minio, or to a local
mounted path, which means that as long as the storage medium can be mounted into
the platform's container, it should work transparently.
