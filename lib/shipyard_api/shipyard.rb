require 'json'
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
    @response = post('/auth/login', option)

    if @response.code.to_i == 200
      body = JSON.load(@response.read_body)
      @access_token = body['auth_token']
    end

    @response.code.to_i
  end

  def create_service_key
    @response = post_with_access_token('/api/servicekeys', {})
    if @response.code.to_i == 200
      body = JSON.load(@response.read_body)
      @service_key = body['key']
    end

    @response.code.to_i
  end

  # def list_container
  #
  # end
  #
  # def get_container
  # end
  #
  # def create_container
  #
  # end

  private

  def post(api, option)
    http = Net::HTTP.new(host, port)

    request = Net::HTTP::Post.new(api)
    request['content-type'] = 'application/json'
    request.body = option.to_json

    http.request(request)
  end

  def post_with_access_token(api, option)
    http = Net::HTTP.new(host, port)

    request = Net::HTTP::Post.new(api)
    request['content-type'] = 'application/json'
    request['x-access-token'] = "#{@username}:#{@access_token}"
    request.body = option.to_json

    http.request(request)
  end

  def post_with_service_key(api, option)
    http = Net::HTTP.new(host, port)

    request = Net::HTTP::Post.new(api)
    request['content-type'] = 'application/json'
    request['x-service-key'] = "#{@username}:#{@service_key}"
    request.body = option.to_json

    http.request(request)
  end

  def get_with_service_key(api)
    http = Net::HTTP.new(host, port)

    request = Net::HTTP::Get.new(api)
    request['content-type'] = 'application/json'
    request['x-service-key'] = "#{@username}:#{@service_key}"

    http.request(request)
  end
end
