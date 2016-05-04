#
class Container
  attr_accessor :host, :id, :service_key, :response
  def initialize(host, id, service_key)
    @host = host
    @id = id
    @service_key = service_key
  end
end
