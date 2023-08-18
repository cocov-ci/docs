---
title: "Permissions"
id: "permissions"
layout: documentation
---

As mentioned in other, Cocov relies on permission information fetched
from GitHub and continually monitors and responds to any changes in those
permissions within the organization where the instance is installed. Given that,
Cocov also attempts to map certain operations to match permission levels
present on GitHub, those being:

- Read, Triage, Write: Those three levels are condensed into a single "User"
role within Cocov. Users have access to the same set of repositories they can
work on GitHub, and common operations such as viewing repository metrics,
coverage, and issues is permitted. Those users can also manage issues by marking
them as ignored.
- Maintain: Allows extra repository-specific administrative actions such as
requesting its unique token to be regenerated, forcing a GitHub sync in case
of inconsistencies, and deleting the repository and all its data from the
instance.
- Admin: Have all permissions from the previous tiers, but also have access to
all repositories on Cocov. All operations are allowed, and Adminland is also
accessible.

## When are Permissions Synced?

Permissions for each user are synced in background as soon as they login. Cocov
also requires a few webhook endpoints to be configured on GitHub to keep track
of changes in permissions, automatically updating the local permissions mirror.
The following GitHub events causes Cocov to reassess permissions:

- Member events: This event occurs when there is activity relating to
collaborators in a repository. E.g., when a collaborator is added, removed,
or their permissions are edited.
- Membership events: This event occurs when there is activity relating to
team membership. E.g., when a team is created or deleted.
- Organization events: his event occurs when there is activity relating to an
organization and its members. For this topic, the only relevant events are,
for instance, when a new member is invited, added, or removed from the
organization.

In case any event is missed, Adminland provides ways to manually force user
permission synchronization.

## When a User Leaves the GitHub Organization

Once a user leaves the organization in which the instance is installed, all
their authentication tokens, personal access tokens, and sessions are
immediately revoked, and they will not be able to access the instance even if
they still have access to their endpoints (e.g., your instance is not installed
behind a VPN or firewall). This rule is imposed for all user tiers, meaning it
also applies to users with administrative access to the instance.

## Outside Collaborators

Administrators can determine whether outside collaborators can access the
instance during the setup steps mentioned in {% doclink "Infrastructure/Platform Components/API/Configuration Options", title: "API Configuration Options" %}.
In case outside collaborators are allowed, all authorization mechanisms are
enforced just like to any other user, which implies that they will only have
access to repositories they are able to access on GitHub.
