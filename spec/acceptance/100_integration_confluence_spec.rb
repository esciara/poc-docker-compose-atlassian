describe 'Atlassian Confluence with PostgreSQL Database' do

  url = URI::Generic.build(:scheme => ENV['ATLASSIAN_PROXY_SCHEME'])
  url.port = Integer(ENV['ATLASSIAN_PROXY_PORT'])

  include_examples 'a running Nginx Docker container', 'pocdockercomposeatlassian_nginx_1'
  include_examples 'a running Confluence Docker container with reverse proxy', 'pocdockercomposeatlassian_confluence_1'
  include_examples 'a running Confluence Postgresql Docker container', 'pocdockercomposeatlassian_confluence_postgresql_1'

  url.host = ENV['CONFLUENCE_DOMAIN_NAME']
  Capybara.app_host = url.to_s

  include_examples 'a Confluence instance properly setup', 'using a Confluence PostgreSQL database'
end

# describe 'Atlassian Confluence with Embedded Database' do
#   include_examples 'a running Docker container', 'pocdockercomposeatlassian_confluence_1'
#
#   include_examples 'a Confluence instance properly setup', 'using an embedded database'
# end