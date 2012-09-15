request = require 'request'

class @Datomic

  constructor: (server, port, @alias, @name) ->
    @root = "http://#{server}:#{port}/"

  db_uri: -> "#{@root}db/#{@alias}/#{@name}"  

  createDatabase: (done) ->
    request.put @db_uri(), (err, res, body) ->
      done err, res.statusCode is 201

  db: (done) ->
    request.get @db_uri(), (err, res, body) ->
      done err, body

  transact: (data, done) ->
    request.post @db_uri(), {body: data}, (err, res, body) ->
      done err, body


  datoms: (index, opt..., done) ->
    uri = "#{@db_uri()}/datoms/#{index}#{@query_string opt}"  
    
    request.get uri, (err, res, body) ->
      done err, body

  indexRange: (attrid, opt, done) ->


  query_string: (opt) ->
    return '' if opt.length isnt 1
    '?' + (field + '=' + value for field, value of opt[0]).join '&'
