# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-03-07

### Added

- Azure Virtual Network resource with multiple address spaces and custom DNS servers.
- Subnet creation with configurable address prefixes, service endpoints, and delegation.
- Per-subnet Network Security Groups with flexible rule definitions.
- NSG-to-subnet association.
- NAT Gateway with configurable public IP count, idle timeout, and subnet associations.
- DDoS Protection Plan association for the virtual network.
- NSG Flow Logs with Log Analytics traffic analytics integration.
- Private DNS Zones with automatic VNet linking and support for additional VNet links.
- Subnet submodule for standalone subnet creation with NSG and delegation.
- Private Endpoint submodule with Private DNS Zone integration.
- VNet Peering submodule for bidirectional peering between virtual networks.
- Basic, advanced, and complete usage examples.
- Comprehensive documentation with architecture diagram and Azure references.
