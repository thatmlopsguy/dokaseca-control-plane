# Contributing

Thank you for taking the time to make a contribution to this project!

## Code of Conduct

This project adheres to a [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

The following document provides guidelines and instructions to help you contribute effectively.

## Ways to Contribute

There are many ways to contribute:

- **Report bugs** - File detailed bug reports with reproduction steps
- **Suggest features** - Propose new features or improvements
- **Write code** - Submit bug fixes or new features
- **Improve documentation** - Fix typos, clarify content, add examples
- **Review pull requests** - Provide feedback on proposed changes
- **Answer questions** - Help other users in issues or discussions
- **Write tests** - Improve test coverage

## DevOps & Tooling

- **Automation:**
  - Use provided Makefile targets or scripts in the `scripts/` directory for common tasks.
- **Secrets & Credentials:**
  - Never commit secrets, credentials, or sensitive data to the repository.
  - Use environment variables or secret management tools as described in the documentation.

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:

   ```bash
   git clone https://github.com/YOUR_USERNAME/dokaseca-control-plane.git
   cd dokaseca-control-plane
   ```

3. **Add upstream remote**:

   ```bash
   git remote add upstream https://github.com/thatmlopsguy/dokaseca-control-plane.git
   ```

4. **Install dependencies**:
  Install [`mise`](https://mise.jdx.dev/) to manage project-specific tools and tasks, then run `mise install`
  in the repository root to download the tool versions declared in `.tool-versions` and make them available in your shell.

   ```bash
   mise run tools
   ```

## Development Workflow

1. **Create a branch** for your changes:

   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** - Write code, add tests, update docs

3. **Test your changes** - Run `make pre-commit-run`

4. **Commit your changes**:

   ```bash
   git commit -m "Description of your changes"
   ```

   Use `git commit -s` to sign off your commits (required)

5. **Push to your fork**:

   ```bash
   git push origin feature/your-feature-name
   ```

## Pull Request Process

### Before Submitting

- Ensure your code follows the project's coding standards
- Add or update tests for your changes
- Run pre-commit checks: `make pre-commit-run`
- Update documentation as needed
- Keep pull requests focused on a single concern

### PR Description

Include in your pull request description:

- **What** - Summary of changes
- **Why** - Motivation and context
- **How** - Implementation approach
- **Testing** - How you tested the changes
- **Related Issues** - Link any related issues (e.g., "Fixes #123")

### Review Process

1. Automated checks will run on your PR
2. Maintainers will review your changes
3. Address any feedback or requested changes
4. Once approved, a maintainer will merge your PR

## Coding Standards

Follow the project's coding style enforced by `make pre-commit-run`.

## Commit Sign-off

We strongly recommend that all maintainers sign their commits.

Signed commits verify your identity and help ensure that changes to the repository are authentic and have not been tampered with.

### Benefits of signed commits

- Verify the author's identity
- Prevent commit forgery or alteration
- Improve trust and security in the project's history
- Ensure compliance with the Developer Certificate of Origin (DCO)

### How to start

- Generate a GPG key pair on your local machine.
- Upload your public GPG key in your profile settings under SSH / GPG keys.
- Configure Git to use your GPG key for signing.

Add the `-s` flag when committing:

```bash
git commit -s -m "Your commit message"
```

This adds a "Signed-off-by" line:

```
Signed-off-by: Your Name <your.email@example.com>
```

Push your changes as usual - Git will show a "Verified" badge next to signed commits.

For a detailed step-by-step guide, see the [Codeberg GPG key documentation](https://docs.codeberg.org/guides/gpg-keys/).

Learn more at [https://developercertificate.org/](https://developercertificate.org/)

## Communication

- **Issues** - Report bugs and request features via [GitHub Issues](https://github.com/thatmlopsguy/dokaseca-control-plane/issues)
- **Discussions** - Ask questions in [GitHub Discussions](https://github.com/thatmlopsguy/dokaseca-control-plane/discussions)
- **Pull Requests** - Submit code changes via [GitHub Pull Requests](https://github.com/thatmlopsguy/dokaseca-control-plane/pulls)

## Need Help?

If you have questions, open an issue or start a discussion. We're happy to help!

---

Thank you for helping make this project better!
