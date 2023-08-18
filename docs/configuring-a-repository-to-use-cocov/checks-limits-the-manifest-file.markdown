---
title: "Checks & Limits: The Manifest File"
id: "checks-limits-the-manifest-file"
layout: documentation
---

The Manifest File is the central point for configuring Cocov on a given
repository. That file is responsible for describing how the platform should
reject changes based on coverage results, which plugins should be executed,
which files must be ignored, and how secrets are injected into check runs in
order to, for instance, obtain private dependencies from third-party services or
other repositories of your organisation.

## The Manifest Version

Each manifest must begin declaring its version. Currently, only one version is
available, and that will ensure that in case the file format inevitably changes
in the future, no immediate action is required from the repository's
collaborators. Given that, begin the manifest file indicating its version:
`0.1.alpha`:

```yaml
version: "0.1.alpha"
```

## Requiring Coverage Levels

If your repository CI emits coverage information when running tests, it may be
a good idea to make sure that introducing new code does not lower your coverage
total. In order to instruct Cocov to emit a failure state in case the reported
coverage is below a certain value, use the `coverage.min_percent` property:

```yaml
coverage:
  min_percent: 90
```

Adding those lines to your manifest will cause Cocov to emit a failure in case
the reported total coverage is below 90% (<= 89%).


## Excluding Paths from Checks

In case your repository has checks configured and there are paths that should
not be checked, or can be safely ignored, they can be provided as a list of
exact paths or wildcards:

```yaml
exclude_paths:
  - coverage/
  - spec/**/.ignore
```

Bash-like globs are supported. In the example above, all files under the
`coverage` directory, and all `.ignore` files under the `spec` directory would
be ignored by checks.

{% info %}
**Notice**: While utilizing the file-ignore feature offers convenience, we
recommend referring to the documentation of the check tool to determine if it
supports specifying exceptions through its dedicated configuration file.
Additionally, please consult the check repository to verify if it follows a
specific configuration file convention.
{% endinfo %}

## Defining Checks to be Executed

Each Cocov check is defined by at least its name, which must be the path for
a Docker image for a plugin. Checks can also receive two extra arguments: a list
of _environments_ and _mounts_. A check can be defined as simple as the
following:

```yaml
checks:
  - plugin: cocov/rubocop:v0.1
```

Which would use the Rubocop plugin without defining environments or mounts.

### Providing Extra Environment Variables

Some plugins may behave differently depending on the environment is it executing
on. For instance, Go plugins may respond differently to `GONOSUMDB` and
`GOPRIVATE` environment variables. In order to specify environments to a given
check, use the `envs` key and pass desired environments in a mapping:

```yaml
checks:
  - plugin: cocov/golangci-lint:v0.1
    envs:
      GOPRIVATE: github.com/cocov-ci
```

### Mounting Secrets as Files

Cocov supports secrets to be defined within an organization and each of its
repositories. Secrets can be mounted into the filesystem of a check through the
'mounts' option. For instance, let's suppose we'd like to mount a custom Git
configuration file into our check:

```yaml
checks:
  - plugin: cocov/golangci-lint:v0.1
    envs:
      GOPRIVATE: github.com/cocov-ci
    mounts:
      - source: secrets:GIT_CONFIG
        destination: ~/.gitconfig
```

This instructs Cocov to load a secret named GIT_CONFIG and make its contents
available to the check plugin in the path `~/.gitconfig`.

### Defining Secrets and Environments for All Checks

Sometimes several plugins requires the same configuration, which can be
annoying to be defined over and over for each check. On those situations, a
special key `defaults.checks` can be used to apply the same `envs` and `mounts`
to all checks:

```yaml
defaults:
  checks:
    envs:
      GOPRIVATE: github.com/cocov-ci
    mounts:
      - source: secrets:GIT_CONFIG
        destination: ~/.gitconfig

checks:
  - plugin: cocov/golangci-lint:v0.1
  - plugin: cocov/staticcheck:v0.1
```

In the example above, `envs` and `mounts` from `defaults.checks` will be applied
to every check defined in `checks`.

{% info %}
**Notice**: In case a check explicitly defines an extra env under a different
name, the environments lists are merged. Environments defined with the same name
on a check level takes precedence over environments defined on
`defaults.checks`. The same applies to mounts: if the same destination is
defined on a check level, and the same mount already exists on the `defaults`
definition, the one defined on the check is used.
{% endinfo %}
