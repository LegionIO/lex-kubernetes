# frozen_string_literal: true

RSpec.describe Legion::Extensions::Kubernetes::Client do
  subject(:client) { described_class.new(server: 'https://k8s.example.com', token: 'test-token') }

  describe '#initialize' do
    it 'stores server in opts' do
      expect(client.opts[:server]).to eq('https://k8s.example.com')
    end

    it 'stores token in opts' do
      expect(client.opts[:token]).to eq('test-token')
    end

    it 'defaults namespace to default' do
      expect(client.opts[:namespace]).to eq('default')
    end
  end

  describe '#settings' do
    it 'returns a hash with options key' do
      expect(client.settings).to eq({ options: client.opts })
    end
  end

  describe '#connection' do
    it 'returns a Kubeclient::Client' do
      fake_client = double('kubeclient')
      allow(Legion::Extensions::Kubernetes::Helpers::Client).to receive(:connection).and_return(fake_client)
      expect(client.connection).to be(fake_client)
    end
  end
end
