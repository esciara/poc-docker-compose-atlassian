describe 'Atlassian Jira with PostgreSQL Database' do

  # url = URI::Generic.build(:scheme => ENV['ATLASSIAN_PROXY_SCHEME'])
  # url.port = Integer(ENV['ATLASSIAN_PROXY_PORT'])
  #
  # # include_examples 'a running Nginx Docker container', 'pocdockercomposeatlassian_nginx_1'
  # # include_examples 'a running Jira Docker container with reverse proxy', 'pocdockercomposeatlassian_jira_1'
  # # include_examples 'a running Jira Postgresql Docker container', 'pocdockercomposeatlassian_jira_postgresql_1'
  #
  # url.host = ENV['JIRA_DOMAIN_NAME']
  # Capybara.app_host = url.to_s

  # include_examples 'a Jira instance properly setup', 'using a Jira PostgreSQL database'
end
