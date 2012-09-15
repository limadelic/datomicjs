request = require 'request'

class exports.Datomic

  constructor: (server, port, alias, name) ->
    root = "http://#{server}:#{port}/"
    @db_uri = "#{root}db/#{alias}/#{name}"  

  createDatabase: (done) ->
    request.put @db_uri, (err, res, body) ->
      done err, res.statusCode is 201

  db: (@done) -> @get @db_uri

  transact: (data, done) ->
    request.post @db_uri, {body: data}, (err, res, body) ->
      done err, body

  datoms: (index, opt..., @done) ->
    @get "#{@db_uri}/datoms/#{index}#{@query_string @parse_opt opt}"  

  indexRange: (attrid, opt..., @done) ->
    opt = @parse_opt opt 
    opt.a = attrid

    @get "#{@db_uri}/range#{@query_string opt}"

  get: (uri) ->
    request.get uri, (err, res, body) =>
      @done err, body

  parse_opt: (opt) -> if opt.length is 1 then opt[0] else {}

  query_string: (opt) ->
    result = '?' + (field + '=' + value for field, value of opt).join '&'
    return '' if result is '?'
    result
