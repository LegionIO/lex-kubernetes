# frozen_string_literal: true

module Legion
  module Extensions
    module Kubernetes
      module Runners
        module Deployments
          def list_deployments(namespace: 'default', **)
            resp = extensions_connection(**).get_deployments(namespace: namespace)
            { deployments: resp.items }
          end

          def get_deployment(name:, namespace: 'default', **)
            resp = extensions_connection(**).get_deployment(name, namespace)
            { deployment: resp }
          end

          def scale_deployment(name:, replicas:, namespace: 'default', **)
            conn   = extensions_connection(**)
            scale  = conn.get_scale('Deployment', name, namespace)
            scale.spec.replicas = replicas
            conn.update_scale(scale)
            { scaled: true, name: name, namespace: namespace, replicas: replicas }
          end

          def restart_deployment(name:, namespace: 'default', **)
            conn       = extensions_connection(**)
            deployment = conn.get_deployment(name, namespace)
            deployment.spec.template.metadata ||= Kubeclient::Resource.new
            deployment.spec.template.metadata.annotations ||= {}
            deployment.spec.template.metadata.annotations['kubectl.kubernetes.io/restartedAt'] = Time.now.utc.iso8601
            conn.update_deployment(deployment)
            { restarted: true, name: name, namespace: namespace }
          end

          def extensions_connection(**opts)
            server    = opts[:server]    || helpers_settings_value(:server, 'https://localhost:6443')
            token     = opts[:token]     || helpers_settings_value(:token, nil)
            verify    = opts.fetch(:verify_ssl, OpenSSL::SSL::VERIFY_PEER)

            ssl_options  = { verify_ssl: verify }
            auth_options = token ? { bearer_token: token } : {}

            Kubeclient::Client.new("#{server}/apis/apps", 'v1', ssl_options: ssl_options, auth_options: auth_options)
          end

          def helpers_settings_value(key, default)
            return default unless defined?(Legion::Settings)

            settings = Legion::Settings[:'lex-kubernetes']
            settings.is_a?(Hash) ? settings.fetch(key, default) : default
          end
        end
      end
    end
  end
end
