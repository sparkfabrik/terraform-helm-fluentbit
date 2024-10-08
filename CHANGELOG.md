# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres
to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Fix typo in outputs: `final_k8s_common_labels` instead of `finale_k8s_common_labels`.

## [0.4.0] - 2024-09-20

[Compare with previous version](https://github.com/sparkfabrik/terraform-helm-fluentbit/compare/0.3.1...0.4.0)

### Changed

- Feat: added a new default log group `application-errors` containing all application errors `4xx` and `5xx`

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
