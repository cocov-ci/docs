---
title: "Administration"
id: "administration"
layout: documentation
---

Cocov Administrators are trusted users which receives an extra set of
permissions that overrides the ones the instance automatically obtains from
GitHub. By default, the first user to login to the instance is automatically
promoted to a system administrator, which can then select other users as they
deem fit. Do notice, however, that in order to promote an user to an
administrative role, they must have logged into the platform at least once.

## On This Section

This section contains information regarding how the platform handles
permissions, and how to perform administrative and maintenance tasks that are
not directly related to infrastructure tasks.

- **{% doclink "Users" %}** shows how to manage users using the Adminland. This
section shows information on how to promote or demote users from administrative
functions, remove users from an instance, and sync permissions or force them to
be logged out.
- **{% doclink "Permissions" %}** explains how restrictions are applied to user
actions based on their access level to GitHub repositories.
- **{% doclink "Service Tokens" %}** describes how to create, use, and manage
Service Tokens from the Adminland interface. Those tokens are used to allow
applications or integrations to access data from your instance without tying
them to an specific user.
- **{% doclink "Repositories" %}** contains details on how to manage repositories
present in the instance, allowing administrators to easily remove them, or free
up disk space by purging their cache from an unified list.
- **{% doclink "Personal Access Tokens" %}** provides information on how PATs
can be managed from the Adminland interface, allowing administrators to easily
revoke personal tokens in case of exposure, and observe how users are using
those tokens.
- **{% doclink "Badges" %}** provides a detailed overview of how the instance's
badger service works, and how to use it.
- **{% doclink "Organization & Repository Settings" %}** provides instructions
on how to handle repository settings, and how organization settings may affect
settings defined by a single repository.
- **{% doclink "Sidekiq Dashboard" %}** shows how the Sidekiq Dashboard can be
accessed, how to use it, and when to use it.
- **{% doclink "Caches" %}** details how caching works on Cocov, how to control
it, and how it affects runs.
