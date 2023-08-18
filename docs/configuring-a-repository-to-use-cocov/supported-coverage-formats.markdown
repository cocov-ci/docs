---
title: "Supported Coverage Formats"
id: "supported-coverage-formats"
layout: documentation
---

Currently, the following coverage formats are accepted by the automated
coverage reporter:

### Cobertura
[Cobertura](https://cobertura.github.io/cobertura/) files are automatically
located and used.

### Gocov
Coverage information reported directly by the `go test -coverprofile` are
nativelly supported by Cocov, meaning no extra steps between the `go test` and
coverage processing are required. As the `go test` tool does not have a standard
for file names, we suggest naming your coverage output file `c.out`. For
instance, on GitHub Actions, the following would be enough to get coverage up
and running:

```yaml
    - name: Test
      run: go test -v ./... -covermode=count -coverprofile=c.out
```

### JaCoCo
[JaCoCo](https://github.com/jacoco/jacoco) files are automatically located and
used.


### lcov
The reporter locates all files with both `.lcov` and `.info` extensions, and
attempts to parse them as lcov. If successful, results are used.

### Simplecov

[Simplecov](https://github.com/simplecov-ruby/simplecov) support is provided
by searching and parsing files named `coverage.json`. In order to have Simplecov
creating those files, ensure to configure your test runner to use an extra
formatter like [simplecov_json_formatter](https://rubygems.org/gems/simplecov_json_formatter)

## Missing a Format?

Feel free to create an issue or pull request in our [coverage-reporter](https://github.com/cocov-ci/coverage-reporter)
repository!
