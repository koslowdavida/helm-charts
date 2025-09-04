---
applyTo: "charts/library/common/**/*"
---

# Common Library development instructions

The common library chart is the foundation of this repository. It provides reusable templates and functions for Kubernetes resource generation.

## Structure

templates/classes/: Contains template definitions for various Kubernetes resources
templates/lib/: Contains library functions used across templates
templates/loader/: Contains code for loading and initializing templates
templates/render/: Contains code for rendering resources
templates/values/: Contains code for value validation
schemas/: JSON schemas for validating values

## Key Concepts

1. **Template Classes**: These are blueprint templates for Kubernetes resources like Deployments, Services, etc.
2. **Library Functions**: Helper functions that can be used across templates
3. **Values Schema**: JSON schema definitions for validating chart values

## Common Library Best Practices

- Keep template functions focused and reusable
- Use clear naming conventions for functions and parameters
- Document function parameters and behavior
- Maintain backward compatibility where possible

## Testing and validation

Testing is a critical part of chart development to ensure reliability and compatibility.

### Testing Structure

- `charts/library/common/test-chart/`: Contains a test chart for validating the common library
- `charts/library/common/test-chart/unittests/`: Contains unit tests for different resource types
- `charts/library/common/test-chart/ci/`: Contains CI test values

### Testing Tools

This repository uses:

1. **Helm lint**: For syntax validation
2. **Schema validation**: For values validation
3. **Unit tests**: For template functionality validation

### Adding New Tests

When adding new features, always add corresponding tests:

1. For new resource types, add unit tests in the appropriate directory
2. For new value options, add test cases that exercise those options
3. For edge cases, add specific test values to validate behavior

### Testing Best Practices

1. Test both valid and invalid configurations
2. Test resource generation with different combinations of values
3. Test template functions with various inputs
4. Test backward compatibility when making changes
