# frozen_string_literal: true

RSpec.describe Legion::Extensions::Kubernetes::Runners::Deployments do
  let(:client)     { Legion::Extensions::Kubernetes::Client.new(server: 'https://k8s.example.com', token: 'tok') }
  let(:apps_conn)  { double('kubeclient-apps') }
  let(:deploy)     { double('deployment', name: 'web', namespace: 'default', spec: deploy_spec) }
  let(:deploy_spec) do
    double('spec', replicas: 2, template: double('template', metadata: double('meta', annotations: {})))
  end

  before { allow(client).to receive(:extensions_connection).and_return(apps_conn) }

  describe '#list_deployments' do
    it 'returns deployments from the given namespace' do
      allow(apps_conn).to receive(:get_deployments).with(namespace: 'default').and_return(double(items: [deploy]))
      result = client.list_deployments(namespace: 'default')
      expect(result[:deployments]).to contain_exactly(deploy)
    end
  end

  describe '#get_deployment' do
    it 'returns a single deployment' do
      allow(apps_conn).to receive(:get_deployment).with('web', 'default').and_return(deploy)
      result = client.get_deployment(name: 'web', namespace: 'default')
      expect(result[:deployment]).to eq(deploy)
    end
  end

  describe '#scale_deployment' do
    it 'updates replicas and returns confirmation' do
      scale_obj = double('scale', spec: double('spec', replicas: 2))
      allow(scale_obj.spec).to receive(:replicas=)
      allow(apps_conn).to receive(:get_scale).with('Deployment', 'web', 'default').and_return(scale_obj)
      allow(apps_conn).to receive(:update_scale).with(scale_obj)
      result = client.scale_deployment(name: 'web', namespace: 'default', replicas: 5)
      expect(result[:scaled]).to be true
      expect(result[:replicas]).to eq(5)
    end
  end

  describe '#restart_deployment' do
    it 'patches the restart annotation and returns confirmation' do
      annotations = {}
      meta        = double('meta', annotations: annotations)
      allow(meta).to receive(:annotations=)
      template    = double('template', metadata: meta)
      spec        = double('spec', template: template)
      dep         = double('dep', spec: spec)
      allow(apps_conn).to receive(:get_deployment).with('web', 'default').and_return(dep)
      allow(apps_conn).to receive(:update_deployment).with(dep)
      result = client.restart_deployment(name: 'web', namespace: 'default')
      expect(result[:restarted]).to be true
      expect(result[:name]).to eq('web')
    end
  end
end
