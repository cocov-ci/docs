---
title: "Users"
id: "users"
layout: documentation
---

A Cocov instance can receive all users that are part of the organization in
which it is installed. A configuration parameter can, however, allow or deny
access to outside collaborators.

Each user is identified by their GitHub Account unique identifier, and will be
able to access the instance as long as they are part of the organization. Cocov
activelly listens for events emitted by GitHub to ensure that any user that is
removed from the organization or converted into an outside collaborator have
their permissions updated or their account removed completely from the instance,
effectively revoking any kind of access they might have had to the instance.

The Adminland area encompasses a sub-section designed for managing users who
have access to the instance:

![Adminland Users List](/assets/images/docs/adminland-users-list.png){: .screenshot }

Each user with access to the instance is listed along with information
regarding their access levels, providing a clear way to understand to which
components they may have access. For each user, the following actions may be
performed:


![Adminland User Actions](/assets/images/docs/adminland-users-actions.png){: .screenshot }

- **Make Admin**: Promotes a given user to an Administrator. Administrators have
unlimited access to all repositories in Cocov, and this will override
permissions Cocov obtained from GitHub for that specific user. They will also
have access to Adminland, and all other sensitive and/or destructive operations.
- **Sync Permissions**: Enqueues a new background operation to force Cocov to
replace locally stored permission data with any changes that can have been made
on GitHub and were not applied to the instance. This is useful in case of GitHub
outages or in case changes are made on GitHub while your instance is offline.
- **Force Logout**: Forces all sessions pertaining to that specific users to be
revoked, requiring them to perform the authentication flow again. This operation
will not cause their Personal Access Tokens to be revoked.
- **Delete**: Removes all data associated with that specific user from the
current instance. This will revert the instance to a state as if that user have
never logged in on the platform. Do notice that this won't prevent them from
accessing the instance in case they are still part of your GitHub organization.

Administrative users on that list have the same options, the only difference
being the first option, that in this case would allow that user to be demoted
from an administrative position.

{% warning %}
**Beware**: Cocov requires at least one administrator to be present in the user
list, meaning that the last administrator cannot be deleted or demoted.
{% endwarning %}
