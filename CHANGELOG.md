# Changelog

## [0.1.0] - 2026-03-22

### Added
- Initial release
- `Helpers::Client` — Kubeclient::Client connection builder with server/token/namespace/ssl configuration
- `Runners::Pods` — list_pods, get_pod, delete_pod, pod_logs
- `Runners::Deployments` — list_deployments, get_deployment, scale_deployment, restart_deployment
- `Runners::Services` — list_services, get_service
- `Runners::Namespaces` — list_namespaces, get_namespace
- Standalone `Client` class for use outside the Legion framework
