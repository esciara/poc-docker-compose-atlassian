shared_examples 'a running Confluence Docker container' do |container_name, |
  before :all do
    @container = Docker::Container.get(container_name)
    @container.start! PublishAllPorts: true
    @container.setup_capybara_url tcp: 8090
  end

  describe 'when checking a Confluence container' do
    subject { @container }

    it { is_expected.to_not be_nil }
    # it { is_expected.to be_running }
    it { is_expected.to have_mapped_ports tcp: 8090 }
    it { is_expected.not_to have_mapped_ports udp: 8090 }
    it { is_expected.to wait_until_output_matches REGEX_STARTUP_ATLASSIAN }
  end
end
