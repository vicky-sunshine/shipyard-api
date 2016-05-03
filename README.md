# Shipyard-api


## Development
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
