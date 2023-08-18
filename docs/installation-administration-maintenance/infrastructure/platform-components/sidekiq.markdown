---
title: "Sidekiq"
id: "sidekiq"
layout: documentation
toc: true
---

Sidekiq is a well-known queue processing software for Ruby, responsible for
running background jobs. It is also used by large projects such as Mastodon,
Diaspora, GitLab, and Discourse.

In Cocov, Sidekiq inherits the same settings of API, and is responsible for
running several tasks for housekeeping and updating repositories, users,
and commits. A list of all operations handled by it is available below:

## `ComputeRepositoryCommitsSizeJob`
`ComputeRepositoryCommitsSizeJob` updates internal repository metadata after a
commit is clonned into the system storage. Whenever executed, the job updates
a given repository's `commits_size` field with the total amount of storage used
by clonned commits.

## `DestroyRepositoryJob`
`DestroyRepositoryJob` is executed whenever a tracked repository is deleted from
GitHub, or manually removed from Cocov through the Repository Settings
page. The platform does not perform soft deletes, so deletes are destructive.
The job is also responsible for requesting an asynchronous cache purge from the
{% doclink "Cache" %} service if it is enabled.

## `InitializeRepositoryJob`
`InitializeRepositoryJob` is enqueued for execution when a new repository is
added to the instance. It is responsible for clonning the repository's last
commit, creating the reference the the repository's main branch, and enqueueing
a `ProcessCommitJob` to process the clonned commit, in case it already contains
a manifest file.

## `ProcessCommitJob`
`ProcessCommitJob` is executed after a new commit is clonned, and is responsible
for enqueuing the commit's checks (if any) to be executed asynchronously by an
available {% doclink "Worker" %}, while the job also attempts to associate an
known User to the clonned commit. This last operation attempts to find an user
that has logged in at least once into the Platform that has an email that
matches the commit's author email, and connects both.

## `ProcessCoverageJob`
`ProcessCoverageJob` is enqueued when coverage data is received for an already
known commit. In case coverage data is received before the commit data (in case
GitHub Webhooks are delayed, for instance), data is held on Redis for at most
two hours, and is processed as soon as the commit event is delivered. The
process comprises looking for a valid manifest among the commit's files, parsing
the received coverage information, validating its results against any rules
defined by the loaded manifest (if any), and emitting a status back to GitHub.

## `RequestCacheEvictionJob`
`RequestCacheEvictionJob` determines which objects must be removed from a Cache
Storage in case it surpasses the allowed quota. An eviction request is them
emitted to the {% doclink "Cache" %} service to have those objects asynchronously
removed from the storage.

## `UpdateCommitsAuthorJob`
`RequestCacheEvictionJob` is executed when an user's email list is updated, or
a previously unknown user logs into the platform for the first time. It then
attempts to link all commits having an Author Email address that matches one of
the user's emails to the new user.

## `UpdateOrganizationReposJob`
`UpdateOrganizationReposJob` lists and caches all repositories from the GitHub
organization that Cocov is installed on.

## `UpdateRepoPermissionsJob`
Executed when repositories are added/removed/updated on the GitHub organization,
`UpdateRepoPermissionsJob` ensures that all user's visibility settings are
up-to-date and matching permissions defined on GitHub.

## `UpdateUserPermissionsJob`
Executed when users are added/removed/updated on the GitHub organization,
`UpdateUserPermissionsJob` ensures that all user's visibility settings are
up-to-date and matching permissions defined on GitHub.
