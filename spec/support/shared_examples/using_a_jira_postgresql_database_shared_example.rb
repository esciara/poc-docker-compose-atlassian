shared_examples 'a running Jira Postgresql Docker container' do |container_name, |
  before :all do
    @container_jira_db = Docker::Container.get(container_name)
    @container_jira_db.start! PublishAllPorts: true
  end

  describe 'when checking a Jira Postgresql container' do
    subject { @container_jira_db }

    it { is_expected.to_not be_nil }
    # it { is_expected.to be_running }
    it { is_expected.to wait_until_output_matches REGEX_STARTUP_POSTGRESQL }
  end
end

shared_examples 'using a Jira PostgreSQL database' do
  before :all do
    within 'form#jira-setup-database' do
      # select using external database
      choose 'jira-setup-database-field-database-external'
      # allow some time for the DOM to change
      sleep 1
      # fill in database configuration
      # select 'PostgreSQL', from: 'jira-setup-database-field-database-type'
      fill_in 'jira-setup-database-field-database-type-field', with: 'PostgreSQL'
      fill_in 'jdbcHostname', with: @container_jira_db.host
      fill_in 'jdbcPort', with: '5432'
      fill_in 'jdbcDatabase', with: 'jiradb'
      fill_in 'jdbcUsername', with: ENV['ATLASSIAN_DB_USERNAME']
      fill_in 'jdbcPassword', with: ENV['ATLASSIAN_DB_PASSWORD']
      # continue database setup
      click_button 'Next'
    end
  end
end

