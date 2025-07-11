# Security Policy

## 🔒 Overview

DoKa Seca is committed to maintaining the security and integrity of our platform engineering framework.
This document outlines our security practices, supported versions, and procedures for reporting security vulnerabilities.

## 🛡️ Supported Versions

We actively maintain security updates for the following versions of DoKa Seca:

| Version | Supported | Status             |
|---------|-----------|--------------------|
| main    | ✅ Yes     | Active development |
| 0.x.x   | ✅ Yes     | Current stable     |

## 🚨 Reporting a Vulnerability

We take security vulnerabilities seriously and appreciate responsible disclosure. If you discover a security vulnerability in DoKa Seca, please follow these steps:

### Preferred Reporting Method

#### Private Security Advisory (Recommended)

1. Go to the [Security tab](../../security/advisories) of this repository
2. Click "Report a vulnerability"
3. Fill out the security advisory form with detailed information
4. Submit the report

This method allows us to collaborate privately on the fix before public disclosure.

### What to Include

When reporting a vulnerability, please provide:

- **Description**: Clear description of the vulnerability
- **Impact**: Potential security impact and affected components
- **Reproduction**: Step-by-step instructions to reproduce the issue
- **Environment**:
  - DoKa Seca version
  - Kubernetes version
  - Operating system
- **Supporting Evidence**: Screenshots, logs, or proof-of-concept code
- **Suggested Fix**: If you have ideas for remediation

### Example Report Template

```text
**Vulnerability Summary**
Brief description of the security issue

**Affected Components**
- Component: [e.g., ArgoCD configuration, Vault setup, etc.]
- Version: [e.g., DoKa Seca v1.2.0]

**Impact Assessment**
- Severity: [Critical/High/Medium/Low]
- Attack Vector: [Network/Local/Physical]
- Affected Users: [All users/Admin users/Specific configurations]

**Reproduction Steps**
1. Step one
2. Step two
3. Step three

**Expected vs Actual Behavior**
- Expected: Secure behavior description
- Actual: Vulnerability behavior description

**Supporting Evidence**
[Attach screenshots, logs, or code snippets]

**Suggested Mitigation**
[Your recommendations for fixing the issue]
```

## 🔧 Security Tools and Automation

DoKa Seca uses various automated security tools:

### Continuous Security

- **Dependabot**: Automated dependency vulnerability scanning
- **CodeQL**: Semantic code analysis for security issues
- **Container Scanning**: Automated container image vulnerability scanning
- **Secret Scanning**: Detection of committed secrets and tokens
- **SBOM Generation**: Software Bill of Materials for transparency

### Security Policies

- **Branch Protection**: Required reviews and status checks
- **Signed Commits**: Verification of commit authenticity (recommended)
- **Release Signing**: Cryptographic signing of releases
- **Vulnerability Alerts**: Automated notifications for security issues

Thank you for helping keep DoKa Seca and our community safe! 🛡️
