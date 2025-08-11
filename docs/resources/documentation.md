# Documentation

DoKa Seca uses [MkDocs](https://www.mkdocs.org/) with the [Material theme](https://squidfunk.github.io/mkdocs-material/) to generate and publish comprehensive platform documentation. This guide provides detailed instructions for configuring, writing, and deploying documentation for the DoKa Seca platform.

## Overview

The documentation system in DoKa Seca provides:

- **Static Site Generation**: Uses MkDocs to convert Markdown files into a static website
- **Material Design**: Clean, responsive theme with dark/light mode support
- **Automated Deployment**: GitHub Actions workflow for automatic publishing to GitHub Pages
- **Live Development**: Local development server with hot reloading
- **Enhanced Markdown**: Support for advanced features like tabs, code blocks, and diagrams

## Architecture

The documentation system consists of several key components:

```text
docs/                          # Documentation source files
├── index.md                   # Homepage
├── getting_started/           # Getting started guides
├── adr/                      # Architecture Decision Records
└── *.md                      # Feature documentation

mkdocs.yaml                   # MkDocs configuration
requirements/docs.txt         # Python dependencies
.github/workflows/docs.yml    # Automated deployment
```

## Prerequisites

Before working with documentation, ensure you have:

- Python 3.13 or higher
- Git
- Text editor or IDE
- Basic Markdown knowledge

## Local Development

### Quick Start

1. **Install dependencies** using the provided Makefile:

   ```bash
   make docs-install
   ```

2. **Start the development server**:

   ```bash
   make docs-serve
   ```

3. **Access the documentation** at `http://localhost:8000`

The development server provides live reloading, so changes to Markdown files will be automatically reflected in your browser.

### Manual Installation

If you prefer manual installation:

1. **Create a virtual environment**:

   ```bash
   python -m venv .venv
   source .venv/bin/activate  # On Windows: .venv\Scripts\activate
   ```

2. **Install dependencies**:

   ```bash
   pip install -U pip
   pip install -r requirements/docs.txt
   ```

3. **Start the server**:

   ```bash
   mkdocs serve
   ```

## Writing Documentation

### File Organization

- Place new documentation files in the `docs/` directory
- Use descriptive filenames with lowercase and hyphens (e.g., `cluster-api.md`)
- Organize related content in subdirectories (e.g., `getting_started/`)
- Follow the existing naming conventions

### Markdown Guidelines

DoKa Seca documentation uses extended Markdown with the following features:

#### Code Blocks

Use fenced code blocks with language specification:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: example
data:
  key: value
```

#### Admonitions

Use admonitions for important information:

```markdown
!!! note "Installation Note"
    This requires administrative privileges.

!!! warning "Security Warning"
    Never commit secrets to version control.

!!! tip "Pro Tip"
    Use the Makefile for consistent commands.
```

#### Tabs

Group related content using tabs:

```markdown
=== "Kubernetes"
    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    ```

=== "Docker"
    ```bash
    docker run nginx
    ```
```

#### Tables

Use standard Markdown tables:

```markdown
| Component | Purpose    | Port |
|-----------|------------|------|
| Grafana   | Monitoring | 3000 |
| ArgoCD    | GitOps     | 8080 |
```

### Navigation Structure

Update the navigation in `mkdocs.yaml` when adding new pages:

```yaml
nav:
  - Overview: index.md
  - Getting Started:
    - Installation: getting_started/install.md
    - Your New Page: getting_started/new-page.md
```

### Page Metadata

Include frontmatter for better organization:

```markdown
---
title: Page Title
description: Brief description of the page content
---

# Page Title

Content starts here...
```

## Configuration

### MkDocs Configuration

The main configuration is in `mkdocs.yaml`:

- **Site Information**: Name, description, and repository links
- **Navigation**: Page hierarchy and organization  
- **Theme**: Material theme configuration with color schemes
- **Extensions**: Enhanced Markdown features
- **Plugins**: Additional functionality

Key configuration sections:

```yaml
# Site metadata
site_name: Doka Seca
site_description: A comprehensive framework for bootstrapping cloud-native platforms

# Theme configuration
theme:
  name: material
  palette:
    - scheme: default      # Light mode
    - scheme: slate        # Dark mode

# Markdown extensions
markdown_extensions:
  - pymdownx.superfences  # Enhanced code blocks
  - pymdownx.tabbed      # Tab support
  - pymdownx.details     # Collapsible sections
```

### Dependencies

Documentation dependencies are managed in `requirements/docs.txt`:

- `mkdocs`: Core static site generator
- `mkdocs-material`: Material Design theme
- `mkdocs-material-extensions`: Additional theme features

## Deployment

### Automatic Deployment

DoKa Seca uses GitHub Actions for automatic documentation deployment:

1. **Trigger**: Pushes to the `main` branch automatically trigger deployment
2. **Build**: GitHub Actions installs dependencies and builds the site
3. **Deploy**: The built site is deployed to GitHub Pages
4. **Access**: Documentation is available at the configured GitHub Pages URL

The workflow (`.github/workflows/docs.yml`) handles:

- Python environment setup
- Dependency installation
- Site building with `mkdocs gh-deploy`
- Caching for faster builds

### Manual Deployment

For manual deployment:

```bash
# Build the site locally
mkdocs build

# Deploy to GitHub Pages
mkdocs gh-deploy --force
```

### Build Output

The built documentation is generated in the `site/` directory:

```text
site/
├── index.html
├── getting_started/
├── assets/
└── ...
```

## Best Practices

### Content Guidelines

1. **Clear Structure**: Use descriptive headings and logical organization
2. **Consistent Style**: Follow established patterns and terminology
3. **Code Examples**: Include practical, working examples
4. **Cross-References**: Link to related documentation sections
5. **Regular Updates**: Keep documentation current with platform changes

### Writing Style

- Use active voice and clear, concise language
- Include prerequisites and assumptions
- Provide step-by-step instructions
- Use consistent terminology across documents
- Include troubleshooting sections where appropriate

### Version Control

- Make atomic commits for documentation changes
- Use descriptive commit messages
- Review changes in pull requests
- Test locally before committing

## Troubleshooting

### Common Issues

**MkDocs server won't start**:

- Check Python version (3.7+ required)
- Verify virtual environment activation
- Ensure dependencies are installed: `make docs-install`

**Navigation not updating**:

- Check `mkdocs.yaml` syntax
- Verify file paths in navigation section
- Restart the development server

**Build failures**:

- Check Markdown syntax
- Verify image and link paths
- Review MkDocs logs for specific errors

**GitHub Pages not updating**:

- Check GitHub Actions workflow status
- Verify repository settings for GitHub Pages
- Ensure proper branch permissions

### Getting Help

- Check [MkDocs documentation](https://www.mkdocs.org/)
- Review [Material theme docs](https://squidfunk.github.io/mkdocs-material/)
- Examine existing DoKa Seca documentation for patterns
- Open issues in the project repository for platform-specific questions

## Contributing

When contributing to documentation:

1. **Fork** the repository
2. **Create** a feature branch for your changes
3. **Write** or update documentation following these guidelines
4. **Test** locally using `make docs-serve`
5. **Submit** a pull request with clear description of changes

See the [Contributing Guide](contributing.md) for detailed contribution workflows and standards.
