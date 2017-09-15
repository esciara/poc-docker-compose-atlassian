describe 'Atlassian Confluence with Embedded Database' do
  include_examples 'a running Docker container', 'atlassiandockercompose_confluence_1'

  include_examples 'a Confluence instance properly setup', 'using an embedded database'
end