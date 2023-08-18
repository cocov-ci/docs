---
title: "API"
id: "api"
layout: documentation
toc: true
---

Cocov's API is responsible for all state storage, access management, and
responding to events from GitHub Webhooks, the {% doclink "Web UI" %}, possible
user requests (made using {% doclink "Personal Access Tokens" %}), and also
internal requests from other components such as {% doclink "Worker" %},
{% doclink "Cache" %}, and {% doclink "Badger" %}.
The API is also responsible for running database migrations and offering a
REPL console capable of running commands in case of an emergency.

A complete list of tasks the API performs is:

- User Authentication (through GitHub's OAuth flow)
- User Authorization (based on platform configuration/GitHub roles)
- Secrets management and cryptography
- Repository management
- Maintain branch information
- Maintain commit information
- Checks management and validation
- Issues management and validation
- Coverage storage and correlation
- Cache catalog management
- Handling GitHub Webhook Events
- Hosting Sidekiq's Web Panel
- Calculate Repository usage quotas
- Update commit author information
- Automatically update organization repository list
- Automatically sync with user/organization permissions from GitHub
- Process events from Worker and relay them as needed to GitHub

## Deployment Architecture
The API is a Rails 7 application with a fine-tuned Garbage Collector, which
should be consume relatively low resources. Although the API does not perform
any computational-intensive operation, it heavily relies on IO for git
operations and repository bookeeping. Whenever possible, those operations are
dispatched to {% doclink "Sidekiq" %}, but some non-async operations may require
data to be moved from GitHub or Cocov's _Repository Storage_, in case of a cold
cache or a repository not commonly accessed. Given those constraints, it is
important to allow containers running API instances to use a portion of disk in
order to perform those operations.

Another important point regarding API deployment is the number of database
connections per running container. Each API instance will pool, by default,
5 connections to the PostgreSQL database configured for the platform. Each API
container runs Puma, which will automatically spin 5 instances for processing
parallel requests. Be aware of those number in case the configured database have
connection limits, and keep in mind that {% doclink "Sidekiq" %} will also take a
few more connections for each one of its workers.

## Scaling and Performance
TBD

## Data Storage and Management
API needs integrity of two of its three data sources: The _Repository Storage_
and its Database. Repository storage usage can be controlled by imposing storage
limits through the API configuration, which may then automatically evict old
and/or orphaned commits and its related data from both the Storage and the
database.

When creating or restoring backups, make sure to either always restore both the
database and the _Repository Storage_, or that the contents of the storage
matches the state described on the database. Nonconformity may cause unexpected
errors on certain operations and request, but should not render the system
unusable for new data.

It may be important to notice that Cocov do not emply a soft-deletion mechanism;
this means that any data that is delete, is indeed deleted and therefore not
retained. For instance, deleting a repository from GitHub or through a Cocov
administrative facility means that data related to that repository will be
permanently lost when removed from the platform. Of course restoring a backup
could bring these information back, but do notice that this is the only way to
recover deleted data.

The API is also responsible for encrypting and decrypting secrets provided by
users. Those secrets are stored encrypted on the database using AES-256-CBC, and
decrypted and relayed to internal services when necessary. Once set, those
secrets cannot be read by users, only overwritten. Data encrypted cannot be
recovered without the key used to encrypt it, and currently there is no way to
rotate such key; this will be implemented in the near future.

## Monitoring and Alerting
TBD

## Networking and Security
The API requires a single endpoint to be exposed to the internet, in order to
receive events from GitHub through WebHooks. This can be done through a reverse
proxy, ingress, or any other fashion that makes sense to your infrastructure.
Other endpoints may be also exposed to users, in case it is intended to allow
users to use their {% doclink "Personal Access Tokens" %} to perform actions
programatically (such as collect metrics from projects). All other communication
between components may be performed internally. For instance, the
{% doclink "Web UI" %} proxies all requests internally in order to prevent
browsers from directly accessing the platform's API.
