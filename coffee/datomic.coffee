request = require 'request'
{ Edn } = require './edn'

class @Datomic

  constructor: (server, port, @alias) ->
    @root = "http://#{server}:#{port}/"

  db_uri: -> "#{@root}db/#{@alias}/#{@name}"  

  createDatabase: (@name, done) ->
    request.put @db_uri(), (err, res, body) ->
      done err, res.statusCode is 201

  db: (@name, done) ->
    request.get @db_uri(), (err, res, body) ->
      done err, new Edn body
