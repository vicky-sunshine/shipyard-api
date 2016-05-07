require 'http'
require 'json'

#
class Container
  attr_accessor :host, :id, :service_key, :response
  def initialize(host, id, service_key)
    @host = host
    @id = id
    @service_key = service_key
  end

  def inspect
    response = HTTP.headers('x-service-key' => @service_key)
                   .get("http://#{@host}/containers/#{@id}/json")
    handle_response(response)
  end

  def start
    response = HTTP.headers('x-service-key' => @service_key)
                   .post("http://#{@host}/containers/#{@id}/start")
    handle_response(response)
  end

  def stop
    response = HTTP.headers('x-service-key' => @service_key)
                   .post("http://#{@host}/containers/#{@id}/stop")
    handle_response(response)
  end

  def restart
    response = HTTP.headers('x-service-key' => @service_key)
                   .post("http://#{@host}/containers/#{@id}/restart")
    handle_response(response)
  end

  def kill
    response = HTTP.headers('x-service-key' => @service_key)
                   .post("http://#{@host}/containers/#{@id}/kill")
    handle_response(response)
  end

  def remove
    response = HTTP.headers('x-service-key' => @service_key)
                   .delete("http://#{@host}/containers/#{@id}")
    handle_response(response)
  end

  private

  def handle_response(response)
    if response.code == 200 || response.code == 204
      return JSON.load(response.to_s) # force to return
    end

    raise "#{response.code}: #{response}"
  end
end
