request = require 'request'
{ Edn } = require './edn'

server = 'http://localhost:8888/'

@create_database = (uri, done) ->
  request.put server + 'db/' + uri, (err, res, body) ->
    done err, res.statusCode is 201

@db = (connection, done) ->
  request.get server + 'db/' + connection, (err, res, body) ->
    done err, new Edn body
