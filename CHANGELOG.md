# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Enhancements

- Sourcery installation is now optional!
  - Since the generated files are included in the repository now, the sourcery step in Build Phases is now optional, so framework users don't have to install it.

## [0.1.3] - 2019-04-18

### Added
- An optional parameter `disposer` for `beObserved` methods in `Observable`s.
  - if you don't pass any value to this parameter, then the observer will become the disposer.
  - When the disposer become released, the observation will be removed.

## [0.1.2] - 2019-04-10

### Added
- `.asyncOnMain` and `.asyncOnGlobal(qos:)` access for `ExecutionMethod`

## [0.1.1] - 2019-04-02

### Added
- A method `runWithLatestValue` for `Observable`s to run a command immediately with latest value available.
- A new method `accept` to update the value with a closure

### Others
- SwiftLint support
- Danger support
- Templates including this CHANGELOG file to help the OSS community on contributing this project  

## [0.1.0] - 2019-03-27
- Initial release
