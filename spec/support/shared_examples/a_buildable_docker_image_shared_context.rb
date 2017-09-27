shared_examples 'a running Confluence Docker container without reverse proxy' do |container_name, |
  before :all do
    @container_confluence = Docker::Container.get(container_name)
    @container_confluence.start! PublishAllPorts: true
    @container_confluence.setup_capybara_confluence_url tcp: 8090
  end

  describe 'when checking a Confluence container' do
    subject { @container_confluence }

    it { is_expected.to_not be_nil }
    # it { is_expected.to be_running }
    it { is_expected.to have_mapped_ports tcp: 8090 }
    it { is_expected.not_to have_mapped_ports udp: 8090 }
    it { is_expected.to wait_until_output_matches REGEX_STARTUP_CONFLUENCE }
  end
end

shared_examples 'a running Confluence Docker container with reverse proxy' do |container_name, |
  before :all do
    @container_confluence = Docker::Container.get(container_name)
    @container_confluence.start! PublishAllPorts: true
    @container_confluence.setup_capybara_confluence_url tcp: 8090
  end

  describe 'when checking a Confluence container' do
    subject { @container_confluence }

    it { is_expected.to_not be_nil }
    # it { is_expected.to be_running }
    it { is_expected.to wait_until_output_matches REGEX_STARTUP_CONFLUENCE }
  end
end

shared_examples 'a running Jira Docker container without reverse proxy' do |container_name, |
  before :all do
    @container_jira = Docker::Container.get(container_name)
    # @container_jira.start! PublishAllPorts: true
    @container_jira.setup_capybara_jira_url tcp: 8080
  end

  describe 'when checking a Jira container' do
    subject { @container_jira }

    it { is_expected.to_not be_nil }
    # it { is_expected.to be_running }
    it { is_expected.to have_mapped_ports tcp: 8080 }
    it { is_expected.not_to have_mapped_ports udp: 8080 }
    it { is_expected.to wait_until_output_matches REGEX_STARTUP_JIRA }
  end
end

shared_examples 'a running Jira Docker container with reverse proxy' do |container_name, |
  before :all do
    @container_jira = Docker::Container.get(container_name)
    @container_jira.start! PublishAllPorts: true
    @container_jira.setup_capybara_jira_url tcp: 8080
  end

  describe 'when checking a Jira container' do
    subject { @container_jira }

    it { is_expected.to_not be_nil }
    # it { is_expected.to be_running }
    it { is_expected.to wait_until_output_matches REGEX_STARTUP_JIRA }
  end
end
