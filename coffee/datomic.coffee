request = require 'request'
{ Edn } = require './edn'

class @Datomic

  constructor: (server, port, @alias, @name) ->
    @root = "http://#{server}:#{port}/"

  db_uri: -> "#{@root}db/#{@alias}/#{@name}"  

  createDatabase: (done) ->
    request.put @db_uri(), (err, res, body) ->
      done err, res.statusCode is 201

  db: (done) ->
    request.get @db_uri(), (err, res, body) ->
      done err, new Edn body

  transact: (data, done) ->
    
