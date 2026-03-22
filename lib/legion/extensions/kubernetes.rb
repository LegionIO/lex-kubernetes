# frozen_string_literal: true

require 'legion/extensions/kubernetes/version'
require 'legion/extensions/kubernetes/helpers/client'
require 'legion/extensions/kubernetes/runners/pods'
require 'legion/extensions/kubernetes/runners/deployments'
require 'legion/extensions/kubernetes/runners/services'
require 'legion/extensions/kubernetes/runners/namespaces'
require 'legion/extensions/kubernetes/client'

module Legion
  module Extensions
    module Kubernetes
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core
    end
  end
end
