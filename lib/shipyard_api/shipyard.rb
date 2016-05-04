require 'json'
require 'http'
require_relative '../config/shipyard_config'

#
class Shipyard
  attr_accessor :host, :port, :username, :access_token, :service_key, :response
  def initialize(host, port)
    @host ||= host || '127.0.0.1'
    @port ||= port || 8080
  end

  def login(option)
    @username = option[:username]
    @response = HTTP.post("http://#{host}:#{port}/auth/login", json: option)

    if @response.code == 200
      body = JSON.load(@response.to_s)
      @access_token = "#{@username}:#{body['auth_token']}"
    end

    @access_token
  end

  def create_service_key
    @response = HTTP.headers('x-access-token' => @access_token)
                    .post("http://#{host}:#{port}/api/servicekeys", json: {})

    if @response.code == 200
      body = JSON.load(@response.to_s)
      @service_key = "#{@username}:#{body['key']}"
    end

    @service_key
  end

  def list_container
    @response = HTTP.headers('x-access-token' => @access_token)
                    .get("http://#{host}:#{port}/containers/json")
    JSON.load(@response.to_s)
  end

  # def get_container(id)
  #   @response = HTTP.headers('x-access-token' => @access_token)
  #                   .get("http://#{host}:#{port}/containers/#{id}/json")
  #   JSON.load(@response.to_s)
  # end
end
