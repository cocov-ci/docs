---
title: "Protecting the Manifest File"
id: "protecting-the-manifest-file"
layout: documentation
---

As noted in other pages, the manifest file includes all configurations required
to run Cocov in a repository, and also how it should behave. Preventing
unauthorised access is essential in order to maintain consistency.

In order to do that, repository administrators and maintainers may configure
pull requests to enforce reviews from specific people and groups when specific
files are changed. To use this feature, refer to the [CODEOWNERS](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners)
documentation on GitHub.

However, setting a CODEOWNERS file is not enough. After you are done and
CODEOWNERS is already on your default branch, refer to [Protected Branches](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)
documentation.
