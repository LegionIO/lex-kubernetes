# frozen_string_literal: true

RSpec.describe Legion::Extensions::Kubernetes::Runners::Services do
  let(:client)      { Legion::Extensions::Kubernetes::Client.new(server: 'https://k8s.example.com', token: 'tok') }
  let(:kube)        { double('kubeclient') }
  let(:svc_item)    { double('service', name: 'web-svc', namespace: 'default') }

  before { allow(client).to receive(:connection).and_return(kube) }

  describe '#list_services' do
    it 'returns services from the given namespace' do
      allow(kube).to receive(:get_services).with(namespace: 'default').and_return(double(items: [svc_item]))
      result = client.list_services(namespace: 'default')
      expect(result[:services]).to contain_exactly(svc_item)
    end
  end

  describe '#get_service' do
    it 'returns a single service' do
      allow(kube).to receive(:get_service).with('web-svc', 'default').and_return(svc_item)
      result = client.get_service(name: 'web-svc', namespace: 'default')
      expect(result[:service]).to eq(svc_item)
    end
  end
end
