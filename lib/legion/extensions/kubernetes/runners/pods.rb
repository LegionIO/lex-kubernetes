# frozen_string_literal: true

module Legion
  module Extensions
    module Kubernetes
      module Runners
        module Pods
          def list_pods(namespace: 'default', **)
            resp = connection(**).get_pods(namespace: namespace)
            { pods: resp.items }
          end

          def get_pod(name:, namespace: 'default', **)
            resp = connection(**).get_pod(name, namespace)
            { pod: resp }
          end

          def delete_pod(name:, namespace: 'default', **)
            connection(**).delete_pod(name, namespace)
            { deleted: true, name: name, namespace: namespace }
          end

          def pod_logs(name:, namespace: 'default', container: nil, **)
            query = container ? { container: container } : {}
            resp  = connection(**).get_pod_log(name, namespace, **query)
            { logs: resp }
          end
        end
      end
    end
  end
end
