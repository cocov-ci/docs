---
title: "Uploading Test Coverage to Cocov"
id: "uploading-test-coverage-to-cocov"
layout: documentation
---

Uploading test coverage information to your Cocov instance comprises of adding
an extra step on your CI pipeline.

## Using GitHub Actions

Cocov provides an Action that can be leveraged for pushing results
to Cocov automatically. For that, before running your tests, usually right after
your `uses: actions/checkout` instruction, add Cocov's action:

```yaml
- uses: cocov-ci/coverage-reporter@v1
  with:
    instance: https://my-cocov-instance-api.mydomain.com
    token: crt_69a82147a5da9c3a7b503f0cd291d1761446277a9f
```

The `token` parameter can be obtained from the repository's Settings page,
whilst the `instance` parameter must point to either your instance's API, or
your instance's homepage URL, as the Action is able to automatically discover
the API URL from the home.

Then, ensure your test runner outputs information in one of the
{% doclink "Supported Coverage Formats", title: "formats supported by Cocov" %}.

{% info %}
**Notice**: Depending on how your GitHub Actions is configured (in case your
organization leverages self-hosted runners), you may not be required to provide
those values. Consult your Actions administrator or Cocov responsible for
further information.
{% endinfo %}

## Using Automatic Configuration

If your instance has this feature enabled, using the reporter action can be done
by simply providing the same address you use to access your instance:

```yaml
- uses: cocov-ci/coverage-reporter@v1
  with:
    instance: https://my-cocov-instance.mydomain.com
```

Additionally, if you leverage self-hosted runners, or have already exported
a `COCOV_REPORTER_INSTANCE_URL` environment variable, the `instance` parameter
can also be omitted, yielding something as minimal as:

```yaml
- uses: cocov-ci/coverage-reporter@v1
```

## Using Other Providers

In case you use another provider for running your CI pipeline, you can also
manually download and run the runner. Before running your tests, download the
latest version from the [releases](https://github.com/cocov-ci/coverage-reporter)
page, and request the reporter to prepare to run by invoking it with the
following arguments:

```
./coverage-reporter --token YOUR_COCOV_REPOSITORY_TOKEN prepare
```

Then, after your tests are done and coverage information is available, invoke
the reporter once again, this time requesting it to push data to your instance:

```
./coverage-reporter --token YOUR_COCOV_REPOSITORY_TOKEN \
                    --url https://your-cocov-api-instance.yourdomain.com \
                    submit
```
