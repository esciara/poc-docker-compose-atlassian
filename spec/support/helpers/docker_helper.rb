require 'docker'
require 'uri'
require 'rspec'
require 'rspec/expectations'

module Docker
  class Container
    def mapped_port(port)
      port_string = port.first.reverse.join '/'
      json['NetworkSettings']['Ports'][port_string].first['HostPort']
    end

    def host
      json['NetworkSettings']['IPAddress']
    end

    def host_or_service
      if host.to_s.empty?
        # We assume the container has been managed through Docker Compose
        json['Config']['Labels']['com.docker.compose.service']
      else
        host
      end
    end

    def setup_capybara_confluence_url(port, path = '')
      docker_url        = URI.parse Docker.url
      docker_url.host   = ENV['CONFLUENCE_DOMAIN_NAME'] || 'localhost' || Docker.info['Name']
      docker_url.scheme = ENV['ATLASSIAN_PROXY_SCHEME']
      docker_url.path   = path
      docker_url.port   = ENV['ATLASSIAN_PROXY_PORT']
      Capybara.app_host = docker_url.to_s
    end

    def setup_capybara_jira_url(port, path = '')
      docker_url        = URI.parse Docker.url
      docker_url.host   = ENV['JIRA_DOMAIN_NAME'] || 'localhost' || Docker.info['Name']
      docker_url.scheme = ENV['ATLASSIAN_PROXY_SCHEME']
      docker_url.path   = path
      docker_url.port   = ENV['ATLASSIAN_PROXY_PORT']
      Capybara.app_host = docker_url.to_s
    end

    def kill_and_wait(options = {})
      options = { timeout: Docker::DSL.timeout }.merge(options)
      kill options
      wait options[:timeout]
    end

    def wait_for_output(regex)
      thread = Thread.new do
        Timeout.timeout(Docker::DSL.timeout) do
          Thread.handle_interrupt(TimeoutError => :on_blocking) do
            streaming_logs stdout: true, stderr: true, follow: true do |_, chunk|
              if chunk =~ regex
                Thread.current[:chunk] = chunk
                Thread.exit
              end
            end
          end
        end
      end
      thread.join
      thread[:chunk].to_s.match(regex).to_a.drop 1
    end
  end
end
