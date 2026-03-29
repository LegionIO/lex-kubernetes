# lex-kubernetes

Kubernetes integration for [LegionIO](https://github.com/LegionIO/LegionIO). Manage pods, deployments, services, and namespaces from within Legion task chains or as a standalone client library.

## Installation

```bash
gem install lex-kubernetes
```

Or add to your Gemfile:

```ruby
gem 'lex-kubernetes'
```

## Standalone Usage

```ruby
require 'legion/extensions/kubernetes'

client = Legion::Extensions::Kubernetes::Client.new(
  server: 'https://k8s.example.com:6443',
  token: 'my-service-account-token',
  namespace: 'production'
)

# Pods
client.list_pods(namespace: 'default')
client.get_pod(name: 'web-abc123', namespace: 'default')
client.pod_logs(name: 'web-abc123', namespace: 'default', container: 'app')
client.delete_pod(name: 'web-abc123', namespace: 'default')

# Deployments
client.list_deployments(namespace: 'default')
client.scale_deployment(name: 'web', replicas: 3, namespace: 'default')
client.restart_deployment(name: 'web', namespace: 'default')

# Services
client.list_services(namespace: 'default')
client.get_service(name: 'web-svc', namespace: 'default')

# Namespaces
client.list_namespaces
client.get_namespace(name: 'production')
```

## Runners

### Pods

| Method | Parameters | Description |
|--------|-----------|-------------|
| `list_pods` | `namespace: 'default'` | List all pods in a namespace |
| `get_pod` | `name:`, `namespace: 'default'` | Get pod details |
| `delete_pod` | `name:`, `namespace: 'default'` | Delete a pod |
| `pod_logs` | `name:`, `namespace: 'default'`, `container:` | Fetch pod logs |

### Deployments

| Method | Parameters | Description |
|--------|-----------|-------------|
| `list_deployments` | `namespace: 'default'` | List all deployments |
| `get_deployment` | `name:`, `namespace: 'default'` | Get deployment details |
| `scale_deployment` | `name:`, `replicas:`, `namespace: 'default'` | Scale replicas |
| `restart_deployment` | `name:`, `namespace: 'default'` | Rolling restart |

### Services

| Method | Parameters | Description |
|--------|-----------|-------------|
| `list_services` | `namespace: 'default'` | List all services |
| `get_service` | `name:`, `namespace: 'default'` | Get service details |

### Namespaces

| Method | Parameters | Description |
|--------|-----------|-------------|
| `list_namespaces` | — | List all namespaces |
| `get_namespace` | `name:` | Get namespace details |

## Configuration

```json
{
  "lex-kubernetes": {
    "server": "https://k8s.example.com:6443",
    "token": "vault://secret/k8s#token",
    "namespace": "default"
  }
}
```

## Requirements

- Ruby >= 3.4
- `kubeclient` ~> 4.0
- Kubernetes API server accessible from the Legion runtime

## License

MIT
