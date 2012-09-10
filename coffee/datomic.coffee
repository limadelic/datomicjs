request = require 'request'

db = (connection) ->
  request.get 'http://localhost:8888/db/' + connection, (err, response, body) ->
    console.log body

db 'hello/world'
