# frozen_string_literal: true

RSpec.describe Legion::Extensions::Kubernetes::Runners::Pods do
  let(:client)     { Legion::Extensions::Kubernetes::Client.new(server: 'https://k8s.example.com', token: 'tok') }
  let(:kube)       { double('kubeclient') }
  let(:pod_item)   { double('pod', name: 'web-abc', namespace: 'default') }

  before { allow(client).to receive(:connection).and_return(kube) }

  describe '#list_pods' do
    it 'returns pods from the given namespace' do
      allow(kube).to receive(:get_pods).with(namespace: 'default').and_return(double(items: [pod_item]))
      result = client.list_pods(namespace: 'default')
      expect(result[:pods]).to contain_exactly(pod_item)
    end
  end

  describe '#get_pod' do
    it 'returns a single pod' do
      allow(kube).to receive(:get_pod).with('web-abc', 'default').and_return(pod_item)
      result = client.get_pod(name: 'web-abc', namespace: 'default')
      expect(result[:pod]).to eq(pod_item)
    end
  end

  describe '#delete_pod' do
    it 'deletes the pod and returns confirmation' do
      allow(kube).to receive(:delete_pod).with('web-abc', 'default')
      result = client.delete_pod(name: 'web-abc', namespace: 'default')
      expect(result[:deleted]).to be true
      expect(result[:name]).to eq('web-abc')
    end
  end

  describe '#pod_logs' do
    it 'returns logs for the pod' do
      allow(kube).to receive(:get_pod_log).with('web-abc', 'default').and_return("line1\nline2\n")
      result = client.pod_logs(name: 'web-abc', namespace: 'default')
      expect(result[:logs]).to include('line1')
    end

    it 'passes container name when provided' do
      allow(kube).to receive(:get_pod_log).with('web-abc', 'default', container: 'nginx').and_return('nginx log')
      result = client.pod_logs(name: 'web-abc', namespace: 'default', container: 'nginx')
      expect(result[:logs]).to eq('nginx log')
    end
  end
end
