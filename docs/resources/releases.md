# Release Notes

## Release Schedule

### Kubernetes Version Support

Docka Seca follows a release schedule that targets the **N-1 version** of the current Kubernetes release. This approach ensures:

- **Stability**: By using the previous stable version, we avoid potential issues with the latest Kubernetes release
- **Compatibility**: Gives time for the ecosystem and third-party tools to mature and stabilize
- **Reliability**: Allows for thorough testing and validation of all components

### Testing Strategy

For each supported Kubernetes version, all addons and configurations undergo comprehensive testing:

- **Addon Compatibility**: All included addons are validated against the target Kubernetes version
- **Configuration Validation**: Cluster configurations are tested for proper functionality
- **Integration Testing**: End-to-end testing ensures all components work together seamlessly
- **Upgrade Paths**: Migration and upgrade scenarios are validated

### Example

If the current Kubernetes release is `v1.34.x`, Docka Seca will target `v1.33.x` for its releases, ensuring all addons and configurations are thoroughly tested and validated for that specific version.

!!! warning "Warning"
    Additional documentation coming soon!
