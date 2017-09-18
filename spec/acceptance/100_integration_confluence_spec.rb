describe 'Atlassian Confluence with PostgreSQL Database' do
  include_examples 'a running Confluence Docker container', 'pocdockercomposeatlassian_confluence_1'
  include_examples 'a running Postgresql Docker container', 'pocdockercomposeatlassian_database_1'

  include_examples 'a Confluence instance properly setup', 'using a PostgreSQL database'
end

# describe 'Atlassian Confluence with Embedded Database' do
#   include_examples 'a running Docker container', 'pocdockercomposeatlassian_confluence_1'
#
#   include_examples 'a Confluence instance properly setup', 'using an embedded database'
# end