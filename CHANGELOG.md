# Changelog

All notable changes to this project are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Apache-2.0 licence, security policy and threat model documentation.
- SHA256 checksums and build provenance attestation for release artifacts.

### Changed

- Releases are now cut from `v*` tags rather than a branch.
- CI runs on the branches actually used for development.
- The report save dialog now opens from the Rust side, so the destination path
  is no longer supplied by the webview.

### Security

- Enabled a restrictive content security policy, which was previously disabled.
- Removed the `write_file` command, which accepted an arbitrary path from the
  frontend.

## [0.1.0] - 2026-09-17

Initial pre-release. Scans local files and folders for email addresses, phone
numbers and other personal identifiers, and exports findings as JSON.
