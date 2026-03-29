# lex-kubernetes: Kubernetes Integration for LegionIO

**Repository Level 3 Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-other/CLAUDE.md`
- **Grandparent**: `/Users/miverso2/rubymine/legion/CLAUDE.md`

## Purpose

Legion Extension that connects LegionIO to Kubernetes clusters via the `kubeclient` gem. Provides runners for pod management, deployment scaling, service inspection, and namespace management.

**GitHub**: https://github.com/LegionIO/lex-kubernetes
**License**: MIT
**Version**: 0.1.2

## Architecture

```
Legion::Extensions::Kubernetes
├── Runners/
│   ├── Pods         # list_pods, get_pod, delete_pod, pod_logs
│   ├── Deployments  # list_deployments, get_deployment, scale_deployment, restart_deployment
│   ├── Services     # list_services, get_service
│   └── Namespaces   # list_namespaces, get_namespace
├── Helpers/
│   └── Client       # Kubeclient::Client factory (server, token, namespace, SSL)
└── Client           # Standalone client class (includes all runners)
```

## Key Files

| Path | Purpose |
|------|---------|
| `lib/legion/extensions/kubernetes.rb` | Entry point, extension registration |
| `lib/legion/extensions/kubernetes/runners/pods.rb` | Pod list/get/delete/logs runners |
| `lib/legion/extensions/kubernetes/runners/deployments.rb` | Deployment runners; uses `/apis/apps` endpoint for extensions_connection |
| `lib/legion/extensions/kubernetes/runners/services.rb` | Service list/get runners |
| `lib/legion/extensions/kubernetes/runners/namespaces.rb` | Namespace list/get runners |
| `lib/legion/extensions/kubernetes/helpers/client.rb` | Kubeclient::Client factory (v1 API) |
| `lib/legion/extensions/kubernetes/client.rb` | Standalone `Client` class |

## Runner Methods

**Pods**: `list_pods(namespace:)`, `get_pod(name:, namespace:)`, `delete_pod(name:, namespace:)`, `pod_logs(name:, namespace:, container:)`

**Deployments**: `list_deployments(namespace:)`, `get_deployment(name:, namespace:)`, `scale_deployment(name:, replicas:, namespace:)`, `restart_deployment(name:, namespace:)`

**Services**: `list_services(namespace:)`, `get_service(name:, namespace:)`

**Namespaces**: `list_namespaces`, `get_namespace(name:)`

## Architecture Note

The `Deployments` runner uses a separate `extensions_connection` method that connects to `/apis/apps` (v1) instead of the core `/api` endpoint used by `Helpers::Client`. This is necessary because deployments are an apps API resource, not a core resource.

## Connection Defaults

| Option | Default |
|--------|---------|
| `server` | `https://localhost:6443` |
| `token` | `nil` (no auth) |
| `namespace` | `default` |
| `verify_ssl` | `OpenSSL::SSL::VERIFY_PEER` |

## Dependencies

| Gem | Purpose |
|-----|---------|
| `kubeclient` (~> 4.0) | Kubernetes API client |
| `base64` | Required dependency |

## Development

18 specs total.

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

---

**Maintained By**: Matthew Iverson (@Esity)
