# frozen_string_literal: true

module Legion
  module Extensions
    module Kubernetes
      module Runners
        module Services
          def list_services(namespace: 'default', **)
            resp = connection(**).get_services(namespace: namespace)
            { services: resp.items }
          end

          def get_service(name:, namespace: 'default', **)
            resp = connection(**).get_service(name, namespace)
            { service: resp }
          end
        end
      end
    end
  end
end
