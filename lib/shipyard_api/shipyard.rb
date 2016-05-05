require 'json'
require 'http'
require_relative './config/shipyard_config'
require_relative './container.rb'

#
class Shipyard
  attr_accessor :host, :username, :access_token, :service_key
  def initialize(ip, port)
    @host = "#{ip}:#{port}"
  end

  # opiton = {
  #   username: 'xxxx',
  #   password: 'xxxx'
  # }
  # notice that keys are all `string`
  def login(option)
    @username = option[:username]
    response = HTTP.post("http://#{host}/auth/login", json: option)

    if response.code == 200
      body = JSON.load(response.to_s)
      @access_token = "#{@username}:#{body['auth_token']}"
    else
      raise "#{response.code}: #{response}"
    end
    @access_token
  end

  def create_service_key
    response = HTTP.headers('x-access-token' => @access_token)
                   .post("http://#{host}/api/servicekeys", json: {})

    if response.code == 200
      body = JSON.load(response.to_s)
      @service_key = body['key']
    else
      raise "#{response.code}: #{response}"
    end

    @service_key
  end

  def list_container
    response = HTTP.headers('x-access-token' => @access_token)
                   .get("http://#{host}/containers/json")
    if response.code == 200
      list = JSON.load(response.to_s)
    else
      raise "#{response.code}: #{response}"
    end
    list
  end

  def get_container(id)
    response = HTTP.headers('x-access-token' => @access_token)
                   .get("http://#{host}/containers/#{id}/json")
    if response.code == 200
      body = JSON.load(response.to_s)
      container = Container.new(@host, body['Id'], @service_key)
    else
      raise "#{response.code}: #{response}"
    end
    container
  end

  # option[:image], a string, must be filled
  # option[:portBindings], a hash or {},
  #                        each pair container_port => host_port
  #                        both string
  # option[:name], a string or ''
  # option[:command], an array of string or []
  def create_container(option)
    api = "http://#{@host}/containers/create?name=#{option[:name]}"
    template = generate_create_template(option)

    response = HTTP.headers('x-access-token' => @access_token)
                   .post(api, json: template)

    if response.code == 201
      body = JSON.load(response.to_s)
      container = get_container(body['Id'])
    else
      raise "#{response.code}: #{response}"
    end
    container
  end
end

private

def generate_create_template(option)
  template = ShipyardConfig::CREATE_TEMPLATE.clone
  template[:Image] = option[:image]

  unless option[:portBindings].empty?
    option[:portBindings].each do |k, v|
      template[:HostConfig][:PortBindings][k] = [{ HostPort: v }]
    end
  end

  template[:Cmd] = option[:command]
  template
end
