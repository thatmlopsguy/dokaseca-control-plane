# Alerts

## Alert severity levels

DoKa Seca's alerting system categorizes alerts into three severity levels to help prioritize response efforts:

## Alerting Tools

### VMAlert

VMAlert is the alerting component of the Victoria Metrics ecosystem, responsible for evaluating alerting rules and
sending notifications based on defined conditions.

### VMAlertmanager

VMAlertmanager is the alert management component that handles deduplication, grouping, and routing of alerts to various
notification channels such as email, Slack, PagerDuty, etc.

Additionally, [Service Level Objective (SLO)](https://sre.google/sre-book/service-level-objectives/) alerts generated with
[Sloth](https://sloth.dev/) are included.
