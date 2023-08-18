---
title: "Organization & Repository Settings"
id: "organization-repository-settings"
layout: documentation
---

Cocov leverages small configuration parameters on the Web UI, allowing those
to be defined through manifest files present on repositories. However, secrets
management is an important point to keep under the instance's domain. This
section explains how those secrets can be created, and how they can be overriden
on a per-repository basis.

## Understanding Secrets

Secrets are small pieces of information that can be mounted into a Check in
order to allow, for instance, private dependencies to be clonned, or plugins
requiring API tokens to be able to use them without exposing these information
in clear text on repositories.

Currently, Secrets can only be mounted in the form of files that will accessible
by a check runner only when required. Those secrets can be stored in two
isolated domains: Organization and Repositories.

## Organization Secrets

Organization secrets are secrets managed exclusivelly by administrators through
Adminland. Those secrets are made available for all repositories that wish to
use them, and can store, for instance, a PAT or Private Key.

![Adminland Secrets List](/assets/images/docs/adminland-secrets.png){: .screenshot }

Secrets are stored encrypted within the instance, and cannot be read by users,
which includes the Web UI, and API calls using PATs. They can then be referenced
from manifests to allow the Worker to mount them on Checks runs.

## Repository Secrets

Repository secrets can be managed from the Repository settings page, and follows
the same specificities of organization secrets. However, secrets defined on
repositories are isolated to that repository alone, and cannot be accessed or
referenced from other repositories.

Additionally, repository secrets can override organization secrets, meaning that
if a repository defines a secret with the same name as an organization secret,
the former will be used:

![Repository Secret Override](/assets/images/docs/repository-secret-override.png){: .screenshot .width-600 }

This rule is applied even if a new secret is created at organization level, with
the same name of an existing secret in a repository; the repository secret will
also be used in this case.
