# frozen_string_literal: true

require 'kubeclient'
require 'openssl'

module Legion
  module Extensions
    module Kubernetes
      module Helpers
        module Client
          module_function

          def connection(**opts)
            server    = opts[:server]    || settings_value(:server, 'https://localhost:6443')
            token     = opts[:token]     || settings_value(:token, nil)
            namespace = opts[:namespace] || settings_value(:namespace, 'default')
            verify    = opts.fetch(:verify_ssl, OpenSSL::SSL::VERIFY_PEER)

            ssl_options  = { verify_ssl: verify }
            auth_options = token ? { bearer_token: token } : {}

            client = Kubeclient::Client.new(server, 'v1', ssl_options: ssl_options, auth_options: auth_options)
            client.instance_variable_set(:@namespace, namespace)
            client
          end

          def settings_value(key, default)
            return default unless defined?(Legion::Settings)

            settings = Legion::Settings[:'lex-kubernetes']
            settings.is_a?(Hash) ? settings.fetch(key, default) : default
          end
        end
      end
    end
  end
end
