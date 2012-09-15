request = require 'request'
_ = require 'underscore'

class @Datomic

  constructor: (server, port, @alias, @name) ->
    @root = "http://#{server}:#{port}/"

  db_uri: -> "#{@root}db/#{@alias}/#{@name}"  
  datoms_uri: -> "#{@db_uri()}/datoms/#{@index}"  

  createDatabase: (done) ->
    request.put @db_uri(), (err, res, body) ->
      done err, res.statusCode is 201

  db: (done) ->
    request.get @db_uri(), (err, res, body) ->
      done err, body

  transact: (data, done) ->
    request.post @db_uri(), {body: data}, (err, res, body) ->
      done err, body

  datoms: (@index, component...) ->
    done = _.last component
    request.get @datoms_uri(), (err, res, body) ->
      done err, body
