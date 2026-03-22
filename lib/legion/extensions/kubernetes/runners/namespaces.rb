# frozen_string_literal: true

module Legion
  module Extensions
    module Kubernetes
      module Runners
        module Namespaces
          def list_namespaces(**)
            resp = connection(**).get_namespaces
            { namespaces: resp.items }
          end

          def get_namespace(name:, **)
            resp = connection(**).get_namespace(name)
            { namespace: resp }
          end
        end
      end
    end
  end
end
