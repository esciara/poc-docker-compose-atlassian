shared_examples 'a running Nginx Docker container' do |container_name, |
  before :all do
    @container_proxy = Docker::Container.get(container_name)
    @container_proxy.start! PublishAllPorts: true
    # @container_proxy.setup_capybara_url tcp: 80
  end

  describe 'when checking a Nginx container' do
    subject { @container_proxy }

    it { is_expected.to_not be_nil }
    # it { is_expected.to be_running }
    it { is_expected.to wait_until_output_matches REGEX_STARTUP_NGINX }
  end
end