shared_examples 'a running Confluence Postgresql Docker container' do |container_name, |
  before :all do
    @container_confluence_db = Docker::Container.get(container_name)
    @container_confluence_db.start! PublishAllPorts: true
  end

  describe 'when checking a Confluence Postgresql container' do
    subject { @container_confluence_db }

    it { is_expected.to_not be_nil }
    # it { is_expected.to be_running }
    it { is_expected.to wait_until_output_matches REGEX_STARTUP_POSTGRESQL }
  end
end

shared_examples 'using a Confluence PostgreSQL database' do
  before :all do
    # This is for up to 6.3.X
    # within 'form[name=standardform]' do
    #   select 'PostgreSQL', from: 'dbChoiceSelect'
    #   click_button 'External Database'
    #   wait_for_page
    # end
    # This is for >= 6.4.0
    within 'form[name=setupdbchoice]' do
      find(:css, 'div.select-database-choice-box[data-database-choice=custom]').trigger('click')
      click_button 'Next'
      wait_for_page
    end
  end

  # This is for up to 6.3.X
  # it { is_expected.to have_button 'Direct JDBC' }
  # This is for >= 6.4.0
  it { is_expected.to have_current_path %r{/setup/setupdbtype-start.action} }
  it { is_expected.to have_css 'form[name=setupdbtype]' }
  it { is_expected.to have_css 'select[name=dbChoiceSelect]' }
  it { is_expected.to have_button 'Next' }

  # This is for >= 6.4.0 only (not in earlier versions)
  describe 'selecting PostgreSQL as database' do
    before :all do
      within 'form[name=setupdbtype]' do
        select 'PostgreSQL', from: 'dbChoiceSelect'
        click_button 'Next'
        wait_for_page
      end
    end

    it { is_expected.to have_button 'Direct JDBC' }
  end

  describe 'setting up Direct JDBC Connection' do
    before :all do
      click_button 'Direct JDBC'
      wait_for_page
    end

    it { is_expected.to have_css 'form[name=dbform]' }
    it { is_expected.to have_field 'dbConfigInfo.databaseUrl' }
    it { is_expected.to have_field 'dbConfigInfo.userName' }
    it { is_expected.to have_field 'dbConfigInfo.password' }
    it { is_expected.to have_button 'Next' }
  end

  describe 'setting up JDBC Configuration' do
    before :all do
      within 'form[name=dbform]' do
        fill_in 'dbConfigInfo.databaseUrl', with: "jdbc:postgresql://#{@container_confluence_db.host_or_service}:5432/#{ENV['ATLASSIAN_DB']}"
        fill_in 'dbConfigInfo.userName', with: ENV['ATLASSIAN_DB_USERNAME']
        fill_in 'dbConfigInfo.password', with: ENV['ATLASSIAN_DB_PASSWORD']
        click_button 'Next'
        wait_for_page
      end
    end

    it { is_expected.to have_current_path %r{/setup/setupdata-start.action} }
    it { is_expected.to have_css 'form#demoChoiceForm' }
    it { is_expected.to have_button 'Example Site' }
  end
end
