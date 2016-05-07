# Shipyard-api


## Development
### Shipyard
```ruby
require './lib/shipyard_api/shipyard.rb'
HOST = 'x.x.x.x'
PORT = 8080

# initialize
s = Shipyard.new(HOST, PORT)

# login and get access token
opt = {
  username: 'your_username',
  password: 'your_password'
}
s.login(opt)
s.access_token

# create and get service key
s.create_service_key
s.service_key
```
### Container
```ruby
# create a new container
option = {
  image: 'ubuntu',
  name: '',
  portBindings: {},
  command: []
}
container = shipyard.create_container(option)
# inspect
container.inspect
# start
container.start
# stop
container.stop
# restart
container.restart
# kill
container.kill
# removeM
container.remove

```
