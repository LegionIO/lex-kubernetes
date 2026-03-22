# frozen_string_literal: true

RSpec.describe Legion::Extensions::Kubernetes::Runners::Namespaces do
  let(:client)   { Legion::Extensions::Kubernetes::Client.new(server: 'https://k8s.example.com', token: 'tok') }
  let(:kube)     { double('kubeclient') }
  let(:ns_item)  { double('namespace', name: 'production') }

  before { allow(client).to receive(:connection).and_return(kube) }

  describe '#list_namespaces' do
    it 'returns all namespaces' do
      allow(kube).to receive(:get_namespaces).and_return(double(items: [ns_item]))
      result = client.list_namespaces
      expect(result[:namespaces]).to contain_exactly(ns_item)
    end
  end

  describe '#get_namespace' do
    it 'returns a single namespace' do
      allow(kube).to receive(:get_namespace).with('production').and_return(ns_item)
      result = client.get_namespace(name: 'production')
      expect(result[:namespace]).to eq(ns_item)
    end
  end
end
