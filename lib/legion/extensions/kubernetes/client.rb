# frozen_string_literal: true

require_relative 'helpers/client'
require_relative 'runners/pods'
require_relative 'runners/deployments'
require_relative 'runners/services'
require_relative 'runners/namespaces'

module Legion
  module Extensions
    module Kubernetes
      class Client
        include Helpers::Client
        include Runners::Pods
        include Runners::Deployments
        include Runners::Services
        include Runners::Namespaces

        attr_reader :opts

        def initialize(server: 'https://localhost:6443', token: nil, namespace: 'default', **extra)
          @opts = { server: server, token: token, namespace: namespace, **extra }
        end

        def settings
          { options: @opts }
        end

        def connection(**override)
          Helpers::Client.connection(**@opts, **override)
        end
      end
    end
  end
end
