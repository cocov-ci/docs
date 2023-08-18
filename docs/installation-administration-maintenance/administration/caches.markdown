---
title: "Caches"
id: "caches"
layout: documentation
---

Cocov instances have the option to enable an internal cache server to store
artifacts responsible for speeding up checks. Those artifacts can be stored
in a local disk, or remotely, on an S3-compatible service. For information
on configuring this feature, see {% doclink "Platform Components/Cache", title: "Platform Components/Cache" %}.

## How Cache is Used

Cocov plugins can optionally request artifacts to be stored and retrieved from
the instance's cache. Those artifacts are stored in a per-plugin, per-repository
basis, maintaining isolation between each of those components.

Data stored by plugins is arbitrary, but we recommend plugins to store only
relevant data. For instance, a Go plugin may cache project dependencies in case
a full working tree is required for a plugin execute correctly.

Enabling the cache server is optional, and instances not offering said internal
services poses no difference to plugins; the only downside is potentially slower
checks. Administrators can define a storage quota applied to all repositories;
enabling this allows older cache artifacts to be evicted when the quota is
exhausted, effectively removing older or least-accessed artifacts in order to
give space to new artifacts.

## Managing Cache Usage

Maintainers and Administrators can observe cache usage through the repository
settings section. In this section, a couple of actions can be performed:

![Repository Cache List](/assets/images/docs/repository-cache-list.png){: .screenshot }

The Cache List section allows users to observe how much of their quota was
consumed, and also allow to the entire cache pertaining to that specific
repository to be purged at once. Additionaly, cache artifacts may be removed
manually.
