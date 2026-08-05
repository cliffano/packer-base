# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

### Changed
- Decouple deps from ci alias target

## 1.1.0 - 2026-08-05
### Changed
- Upgrade source to Ubuntu 26.04
- Upgrade Docker Packer Plugin to 1.1.4
- Upgrade Ansible Packer Plugin to 1.1.6

### Removed
- Remove snapd due to lack of systemd on container

## 1.0.0 - 2026-04-18
### Added
- Add snapd package provisioning

### Removed
- Remove unused community.general Ansible collection

### Fixed
- Fix Publish Docker Base workflow name

## 0.10.0 - 2025-12-30
### Added
- Initial version
