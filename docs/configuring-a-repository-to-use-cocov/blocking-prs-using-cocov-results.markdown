---
title: "Blocking PRs using Cocov Results"
id: "blocking-prs-using-cocov-results"
layout: documentation
---

While Cocov is able to emit checks for Commits, and therefore, Pull Requests,
extra configuration is required to ensure GitHub actually prevents offending
changes from being merged. First, refer to their documentation regarding
[Branch Protection](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches),
and then make sure to review the section regarding [Status Checks Requirements](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches#require-status-checks-before-merging).

Depending on features enabled on your {% doclink "Checks & Limits: The Manifest File", title: "Manifest File" %},
two contexts will be reported back to GitHub on a given commit/pull request:

![GitHub PR Checklist](/assets/images/docs/blocking-prs-pr-context.png){: .screenshot .width-600}

- `cocov`: Emitted when checks are configured, it will assume a positive or
negative state depending on the number of issues reported by checks. At the
moment, this is not configurable, meaning that a single issue encountered will
cause this status to be marked as failing. However, issues can be ignored.
- `cocov/coverage`: Emitted when a CI pipeline submits coverage information to
the instance using the {% doclink "Uploading Test Coverage to Cocov", title: "Coverage Reporter" %},
displays the current coverage percentage, and conditionally fails based on
what is defined on the Manifest File.

After confirming that checks are being correctly reported, access the repository's
_Branch Protection_ settings, and check the _Require status checks to pass before merging_,
adding Cocov's contexts you intend to use on the box below. For instance:

![GitHub's Branch Protection settings](/assets/images/docs/blocking-prs-branch-protection.png){: .screenshot .width-600}
