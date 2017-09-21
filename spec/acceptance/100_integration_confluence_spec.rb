describe 'Atlassian Confluence with PostgreSQL Database' do
  # include_examples 'a running Confluence Docker container without reverse proxy', 'pocdockercomposeatlassian_confluence_1'
  # include_examples 'a running Postgresql Docker container', 'pocdockercomposeatlassian_database_1'
  include_examples 'a running Nginx Docker container', 'pocdockercomposeatlassian_nginx_1'
  include_examples 'a running Confluence Docker container with reverse proxy', 'pocdockercomposeatlassian_confluence_1'
  include_examples 'a running Postgresql Docker container', 'pocdockercomposeatlassian_confluence_postgresql_1'

  include_examples 'a Confluence instance properly setup', 'using a PostgreSQL database'
end

# describe 'Atlassian Confluence with Embedded Database' do
#   include_examples 'a running Docker container', 'pocdockercomposeatlassian_confluence_1'
#
#   include_examples 'a Confluence instance properly setup', 'using an embedded database'
# end