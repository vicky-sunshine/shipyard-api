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
    if response.code == 200
      body = JSON.load(response.to_s)
    else
      raise "#{response.code}: #{response}"
    end
    body
  end

  def start
    post_container('start')
  end

  def stop
    post_container('stop')
  end

  def restart
    post_container('restart')
  end

  def kill
    post_container('kill')
  end

  def remove
    response = HTTP.headers('x-service-key' => @service_key)
                   .delete("http://#{@host}/containers/#{@id}")
    if response.code == 204
      body = JSON.load(response.to_s)
    else
      raise "#{response.code}: #{response}"
    end
    body
  end

end

private

def post_container(action)
  response = HTTP.headers('x-service-key' => @service_key)
                 .post("http://#{@host}/containers/#{@id}/#{action}")
  if response.code == 204
    body = JSON.load(response.to_s)
  else
    raise "#{response.code}: #{response}"
  end
  body
end
