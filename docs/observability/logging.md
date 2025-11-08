# Logging Solutions

DoKa Seca provides comprehensive logging solutions to collect, store, process, and analyze logs from your Kubernetes clusters and applications.
The platform supports multiple logging backends and collection agents to meet different requirements and use cases.

## Default Logging Architecture

The **default and recommended** logging solution in DoKa Seca uses **Victoria Logs** as the logging backend with various agent options for log collection and shipping.

### Default Stack: Victoria Logs + Collection Agents

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Applications  │───▶│  Collection      │───▶│ Victoria Logs  │
│   & Kubernetes  │    │  Agents          │    │   (Storage)     │
│     Logs        │    │ (Alloy/OTel/FB)  │    │                 │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                                          │
                                                          ▼
                                               ┌─────────────────┐
                                               │    Grafana      │
                                               │ (Visualization) │
                                               └─────────────────┘
```

## Logging Backends

### 1. Victoria Logs (Primary/Default)

**Victoria Logs** is DoKa Seca's **primary and recommended** logging backend, providing high-performance log management.

#### Configuration

```hcl
addons = {
  enable_victoria_logs = true
}
```

#### Features

* **LogQL Compatibility**: Full compatibility with Grafana Loki's LogQL query language
* **High Performance**: Optimized for high ingestion rates and fast queries
* **Cost-Effective**: Excellent compression ratios reduce storage costs
* **Grafana Integration**: Native integration with Grafana for log visualization
* **Long-term Storage**: Efficient storage for log retention policies

#### Components

* **Victoria Logs Single Server**: Centralized log storage and query engine
* **Vector Integration**: Pre-configured Vector for log collection
* **Grafana Datasource**: Automatic Grafana configuration

#### Access

```bash
# Victoria Logs UI
kubectl port-forward svc/victoria-logs-single-server -n monitoring 9428:9428
```

### 2. Grafana Loki (Alternative)

While not explicitly mentioned in the configuration, Loki can be used as an alternative backend.

#### Loki Features

* **LogQL**: Native query language for log exploration
* **Multi-tenancy**: Support for multiple tenants
* **Object Storage**: Integration with cloud object storage
* **Horizontal Scaling**: Distributed architecture support

## Log Collection Agents

DoKa Seca provides multiple options for collecting and shipping logs to the backend systems. Choose the agent that best fits your requirements.

### 1. Grafana Alloy (Recommended)

**Alloy** is Grafana's distribution of the OpenTelemetry Collector, optimized for the Grafana ecosystem.

#### Alloy Configuration

```hcl
addons = {
  enable_alloy = true
  enable_victoria_logs = true
}
```

#### Alloy Features

* **Multi-Signal Collection**: Collects metrics, logs, and traces
* **Low Resource Footprint**: Optimized for efficiency
* **Data Transformation**: Built-in data processing and routing
* **Multi-Destination**: Can ship to multiple backends simultaneously
* **Grafana Optimized**: Native integration with Grafana ecosystem

#### Alloy Capabilities

* **Log Sources**:
  * Container logs
  * Application logs
  * System logs
  * Custom log files
* **Data Processing**:
  * Log parsing and structuring
  * Filtering and routing
  * Label extraction
  * Format transformation

#### Example Configuration

```yaml
# Alloy configuration for log collection
logs:
  receivers:
    - kubernetes_logs
    - syslog
  processors:
    - parser
    - filter
  exporters:
    - victoria_logs
    - loki
```

### 2. OpenTelemetry Collector

The **OpenTelemetry Collector** provides vendor-neutral observability data collection.

#### OTel Configuration

```hcl
addons = {
  enable_opentelemetry_operator = true
  enable_victoria_logs = true
}
```

#### OTel Features

* **Vendor Neutral**: Standard OpenTelemetry implementation
* **Extensible**: Rich ecosystem of receivers, processors, and exporters
* **Multi-Backend**: Send logs to multiple destinations
* **Cloud Native**: Kubernetes-native deployment and management

#### OTel Components

* **OpenTelemetry Operator**: Kubernetes operator for managing collectors
* **Collector Instances**: DaemonSet for node-level collection
* **Custom Resources**: OpenTelemetryCollector CRDs

### 3. Fluent Bit

**Fluent Bit** is a lightweight log processor and forwarder.

#### Fluent Bit Configuration

```hcl
addons = {
  enable_fluent_bit = true
  enable_victoria_logs = true
}
```

#### Fluent Bit Features

* **Lightweight**: Minimal resource consumption
* **High Performance**: Optimized for high-throughput log processing
* **Kubernetes Native**: Deep Kubernetes integration
* **Flexible Routing**: Advanced log routing capabilities
* **Built-in Parsers**: Support for various log formats

### 4. Vector

**Vector** is a high-performance log and metrics router.

#### Vector Configuration

```hcl
addons = {
  enable_vector = true
  enable_victoria_logs = true
}
```

#### Vector Features

* **High Performance**: Built in Rust for maximum efficiency
* **Real-time Processing**: Stream processing capabilities
* **Data Transformation**: Rich set of transformation functions
* **Memory Efficient**: Optimized memory usage
* **Built-in Error Handling**: Robust error handling and retry logic

#### Vector Setup

```yaml
# Vector configuration for log collection
sources:
  kubernetes_logs:
    type: kubernetes_logs
    include_paths:
      - "/var/log/pods/*/*/*.log"

transforms:
  parse_logs:
    type: remap
    inputs: ["kubernetes_logs"]
    source: |
      .timestamp = parse_timestamp!(.timestamp, "%Y-%m-%dT%H:%M:%S%.fZ")
      .level = parse_regex!(.message, r'level=(?P<level>\w+)')

sinks:
  victoria_logs:
    type: loki
    inputs: ["parse_logs"]
    endpoint: "http://victoria-logs:9428"
```

## Logging Architecture Patterns

### 1. Single Agent Pattern (Recommended)

Use one collection agent per node for simplicity and efficiency:

```hcl
addons = {
  enable_victoria_logs = true
  enable_alloy = true  # Single agent for logs, metrics, and traces
}
```

### 2. Specialized Agent Pattern

Use different agents for different purposes:

```hcl
addons = {
  enable_victoria_logs = true
  enable_alloy = true          # For metrics and traces
  enable_vector = true         # For high-performance log processing
}
```

## Log Management Best Practices

### 1. Log Structure and Standards

* **Structured Logging**: Use JSON format for application logs
* **Consistent Fields**: Standardize timestamp, level, and message fields
* **Correlation IDs**: Include trace/request IDs for correlation
* **Kubernetes Labels**: Leverage pod labels for log routing

### 2. Performance Optimization

* **Log Sampling**: Sample high-volume logs to reduce costs
* **Efficient Queries**: Use time ranges and filters in LogQL
* **Resource Limits**: Configure appropriate resource limits for agents
* **Batch Processing**: Use batching for log shipping

### 3. Retention and Storage

* **Retention Policies**: Configure appropriate log retention periods
* **Storage Tiering**: Use object storage for long-term retention
* **Compression**: Enable compression to reduce storage costs
* **Backup Strategy**: Implement backup for critical logs

### 4. Security and Compliance

* **Log Sanitization**: Remove sensitive data from logs
* **Access Control**: Implement RBAC for log access
* **Audit Trails**: Maintain audit logs for compliance
* **Encryption**: Enable encryption for log transmission and storage

## Compliance and Data Privacy

DoKa Seca logging solutions support comprehensive data privacy and compliance requirements for highly regulated environments. Personal data, sensitive information, and regulated data must be properly masked or redacted before being sent to storage backends.

### GDPR Compliance (General Data Protection Regulation)

GDPR requires organizations to protect personal data of EU citizens and implement privacy by design principles.

#### GDPR Requirements for Logging

* **Data Minimization**: Log only necessary data for operational purposes
* **Purpose Limitation**: Use logs only for defined purposes (monitoring, debugging, security)
* **Storage Limitation**: Implement appropriate retention periods
* **Right to Erasure**: Capability to delete personal data from logs
* **Data Protection by Design**: Built-in privacy protection mechanisms

#### Personal Data Masking Configuration

**Alloy Configuration for GDPR:**

```yaml
# Alloy GDPR-compliant log processing
processors:
  - redact:
      fields:
        - email
        - ip_address
        - user_id
        - session_id
      replacement: "[REDACTED]"

  - regex_replace:
      patterns:
        # Email addresses
        - pattern: '\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'
          replacement: '[EMAIL_REDACTED]'
        # IP addresses
        - pattern: '\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b'
          replacement: '[IP_REDACTED]'
        # Phone numbers
        - pattern: '\b\d{3}-\d{3}-\d{4}\b'
          replacement: '[PHONE_REDACTED]'
```

**Vector Configuration for GDPR:**

```yaml
transforms:
  gdpr_redaction:
    type: remap
    inputs: ["application_logs"]
    source: |
      # Redact email addresses
      .message = replace(.message, r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b', "[EMAIL_REDACTED]")

      # Redact IP addresses
      .message = replace(.message, r'\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b', "[IP_REDACTED]")

      # Redact credit card numbers
      .message = replace(.message, r'\b\d{4}[\s-]?\d{4}[\s-]?\d{4}[\s-]?\d{4}\b', "[CARD_REDACTED]")

      # Remove sensitive fields
      del(.user_email)
      del(.client_ip)
      del(.personal_id)
```

### HIPAA Compliance (Health Insurance Portability and Accountability Act)

HIPAA protects Protected Health Information (PHI) in healthcare environments.

#### HIPAA Requirements for Logging

* **PHI Protection**: All 18 HIPAA identifiers must be removed or encrypted
* **Access Controls**: Role-based access to log data
* **Audit Logs**: Comprehensive audit trails for PHI access
* **Data Integrity**: Ensure log data hasn't been tampered with
* **Transmission Security**: Encrypt logs in transit and at rest

#### PHI Redaction Configuration

**OpenTelemetry Collector HIPAA Configuration:**

```yaml
processors:
  transform/hipaa:
    log_statements:
      - context: log
        statements:
          # Redact medical record numbers
          - replace_pattern(body, "MRN[:\\s]*\\d+", "MRN:[MRN_REDACTED]")

          # Redact social security numbers
          - replace_pattern(body, "\\b\\d{3}-\\d{2}-\\d{4}\\b", "[SSN_REDACTED]")

          # Redact dates of birth
          - replace_pattern(body, "\\b\\d{1,2}/\\d{1,2}/\\d{4}\\b", "[DOB_REDACTED]")

          # Redact patient names (basic pattern)
          - replace_pattern(body, "Patient[:\\s]+[A-Za-z\\s]+", "Patient: [NAME_REDACTED]")

          # Remove PHI attributes
          - delete_key(attributes, "patient_id")
          - delete_key(attributes, "ssn")
          - delete_key(attributes, "dob")

  batch:
    timeout: 1s
    send_batch_size: 1024
```

**Fluent Bit HIPAA Configuration:**

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: fluent-bit-hipaa-config
data:
  fluent-bit.conf: |
    [FILTER]
        Name    modify
        Match   kube.*
        Remove  patient_id
        Remove  ssn
        Remove  medical_record_number

    [FILTER]
        Name    grep
        Match   kube.*
        Regex   log ^(?!.*(?:SSN|DOB|MRN)).*$

    [FILTER]
        Name    lua
        Match   kube.*
        Script  /fluent-bit/scripts/hipaa_redact.lua
        Call    redact_phi
```

**HIPAA Redaction Lua Script:**

```lua
-- /fluent-bit/scripts/hipaa_redact.lua
function redact_phi(tag, timestamp, record)
    local log = record["log"]
    if log then
        -- Redact SSN patterns
        log = string.gsub(log, "%d%d%d%-%d%d%-%d%d%d%d", "[SSN_REDACTED]")

        -- Redact MRN patterns
        log = string.gsub(log, "MRN[:%s]*%d+", "MRN:[MRN_REDACTED]")

        -- Redact phone numbers
        log = string.gsub(log, "%(%d%d%d%)%s*%d%d%d%-%d%d%d%d", "[PHONE_REDACTED]")

        record["log"] = log
    end
    return 1, timestamp, record
end
```

### PCI DSS Compliance (Payment Card Industry Data Security Standard)

PCI DSS protects cardholder data in payment processing environments.

#### PCI DSS Requirements for Logging

* **Cardholder Data Protection**: Primary Account Numbers (PAN) must be masked
* **Sensitive Authentication Data**: Never store in logs
* **Access Controls**: Restrict access to cardholder data in logs
* **Log Monitoring**: Real-time monitoring for security events
* **Log Integrity**: Protect logs from unauthorized modification

#### PCI DSS Redaction Configuration

**Vector PCI DSS Configuration:**

```yaml
transforms:
  pci_redaction:
    type: remap
    inputs: ["payment_logs"]
    source: |
      # Redact credit card numbers (PAN)
      .message = replace(.message, r'\b4\d{15}\b', "4***-****-****-[VISA_REDACTED]")  # Visa
      .message = replace(.message, r'\b5[1-5]\d{14}\b', "5***-****-****-[MC_REDACTED]")  # MasterCard
      .message = replace(.message, r'\b3[47]\d{13}\b', "3***-******-*[AMEX_REDACTED]")  # AmEx

      # Redact CVV codes
      .message = replace(.message, r'\bCVV[:\s]*\d{3,4}\b', "CVV:[CVV_REDACTED]")

      # Redact track data
      .message = replace(.message, r'%[^?]+\?[^?]+\?', "[TRACK_DATA_REDACTED]")

      # Remove sensitive fields
      del(.pan)
      del(.cvv)
      del(.expiry_date)
      del(.cardholder_name)

      # Mask account numbers (show only last 4 digits)
      if exists(.account_number) {
        .account_number = replace(.account_number, r'\b\d{12,19}\b') do |match|
          "**** **** **** " + slice(match, -4)
        end
      }
```

**Alloy PCI DSS Configuration:**

```yaml
processors:
  - redact:
      # Credit card patterns
      patterns:
        - pattern: '\b4[0-9]{15}\b'
          replacement: '4***-****-****-[VISA]'
        - pattern: '\b5[1-5][0-9]{14}\b'
          replacement: '5***-****-****-[MC]'
        - pattern: '\b3[47][0-9]{13}\b'
          replacement: '3***-******-*[AMEX]'

      # Sensitive authentication data
      fields:
        - cvv
        - cvv2
        - cvc
        - pin
        - track_data

      replacement: "[PCI_REDACTED]"
```

### Multi-Compliance Architecture

For environments requiring multiple compliance standards:

```yaml
# Comprehensive compliance pipeline
transforms:
  compliance_processor:
    type: remap
    inputs: ["raw_logs"]
    source: |
      # GDPR - Personal data redaction
      .message = replace(.message, r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b', "[EMAIL_REDACTED]")
      .message = replace(.message, r'\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b', "[IP_REDACTED]")

      # HIPAA - PHI redaction
      .message = replace(.message, r'\b\d{3}-\d{2}-\d{4}\b', "[SSN_REDACTED]")
      .message = replace(.message, r'MRN[:\s]*\d+', "MRN:[REDACTED]")

      # PCI DSS - Payment data redaction
      .message = replace(.message, r'\b4\d{15}\b', "4***-****-****-[MASKED]")
      .message = replace(.message, r'\b5[1-5]\d{14}\b', "5***-****-****-[MASKED]")

      # Add compliance tags
      .compliance_processed = true
      .redaction_timestamp = now()
```

### Compliance Validation and Monitoring

#### Automated Compliance Checks

```yaml
# Vector compliance validation
transforms:
  compliance_validator:
    type: remap
    inputs: ["processed_logs"]
    source: |
      # Check for potential data leaks
      if match(.message, r'\b\d{3}-\d{2}-\d{4}\b') {
        log("COMPLIANCE_VIOLATION: Potential SSN found in logs", level: "error")
        .compliance_violation = "SSN_DETECTED"
      }

      if match(.message, r'\b4\d{15}\b') {
        log("COMPLIANCE_VIOLATION: Potential credit card found in logs", level: "error")
        .compliance_violation = "CARD_DETECTED"
      }
```

## References

- [Victoria Logs Documentation](https://docs.victoriametrics.com/victorialogs/)
- [Grafana Alloy Documentation](https://grafana.com/docs/alloy/latest/)
- [OpenTelemetry Collector Documentation](https://opentelemetry.io/docs/collector/)
- [Fluent Bit Documentation](https://docs.fluentbit.io/manual/)
- [Vector Documentation](https://vector.dev/docs/)
- [GDPR Compliance Guidelines](https://gdpr.eu/)
- [HIPAA Compliance Overview](https://www.hhs.gov/hipaa/index.html)
- [PCI DSS Standards](https://www.pcisecuritystandards.org/standards/pci-dss/)
