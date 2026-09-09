# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres
to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.5.0] - 2026-09-09

[Compare with previous version](https://github.com/sparkfabrik/terraform-helm-fluentbit/compare/0.4.0...0.5.0)

### Changed

- Migrate the FluentBit IAM role to the `iam-role` module of `terraform-aws-modules/iam/aws` v6. The v6 major consolidated the `iam-assumable-role-with-oidc` submodule into `iam-role` with `enable_oidc`, so the v5 call no longer initialises.
- Require the AWS provider `>= 6.0`. The constraint is not declared in this module's `versions.tf`, because the module uses no `aws` resource of its own: it propagates from the `iam-role` submodule at init time.

### Upgrade notes

The module interface does not change: `role_policy_arns` is still a `list(string)` and no output is renamed.

The IAM role itself is not recreated, but the policy attachments are re-keyed from `count` to `for_each`, so Terraform plans to destroy `aws_iam_role_policy_attachment.custom[N]` and create `aws_iam_role_policy_attachment.this["pN"]` for each policy. The role to policy link in AWS is the same object on both sides, so the attach call is idempotent and no policy is detached in the process.

To avoid even the short window between the destroy and the create, remove the old entries from the state before applying, one per policy in `role_policy_arns`:

```bash
terraform state rm \
  'module.<name>.module.iam_assumable_role_with_oidc_for_fluent_bit.aws_iam_role_policy_attachment.custom[0]' \
  'module.<name>.module.iam_assumable_role_with_oidc_for_fluent_bit.aws_iam_role_policy_attachment.custom[1]'
```

## [0.4.0] - 2024-09-20

[Compare with previous version](https://github.com/sparkfabrik/terraform-helm-fluentbit/compare/0.3.1...0.4.0)

### Changed

- Feat: added a new default log group `application-errors` containing all application errors `4xx` and `5xx`
- Fix typo in outputs: `final_k8s_common_labels` instead of `finale_k8s_common_labels`.

## [0.3.1] - 2024-06-03

[Compare with previous version](https://github.com/sparkfabrik/terraform-helm-fluentbit/compare/0.3.0...0.3.1)

### Changed

- Fix: change `kubernetes` filter to match platform and fluentbit logs as well. Use `Match_regex` instead of `Match` in other filters.

## [0.3.0] - 2024-05-22

[Compare with previous version](https://github.com/sparkfabrik/terraform-helm-fluentbit/compare/0.2.0...0.3.0)

### Added

- Feat: add support for FluentBit additional fileters to decrease the amount of logs sent to the output.

### Changed

- Fix: fix the pattern used to parse the FluentBit logs to process the JSON format if used.

## [0.2.0] - 2024-05-09

[Compare with previous version](https://github.com/sparkfabrik/terraform-helm-fluentbit/compare/0.1.0...0.2.0)

- Fix the pattern used to catch the FluentBit logs.

## [0.1.0] - 2024-05-09

- First release.
