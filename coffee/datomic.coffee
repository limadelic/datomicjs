request = require 'request'
qs = require 'querystring'

class exports.Datomic

  constructor: (server, port, alias, name) ->
    @root = "http://#{server}:#{port}/"
    @db_alias = alias + '/' + name
    @db_uri = "#{@root}db/#{@db_alias}"

  createDatabase: (done) ->
    request.put @db_uri, (err, res, body) ->
      done err, res.statusCode is 201

  db: (done) -> get @db_uri, done

  transact: (data, done) ->
    request.post @db_uri, {body: data}, (err, res, body) ->
      done err, body

  datoms: (index, opt..., done) ->
    opt = parse_opt opt
    get "#{@db_uri}/datoms/#{index}?#{qs.stringify opt}", done

  indexRange: (attrid, opt..., done) ->
    opt = parse_opt opt
    opt.a = attrid

    get "#{@db_uri}/range?#{qs.stringify opt}", done

  entity: (eid, opt..., done) ->
    if is_object eid
      opt = eid
      eid = ''
    else
      opt = parse_opt opt
      eid = '/' + eid

    get "#{@db_uri}/entity#{eid}?#{qs.stringify opt}", done

  q: (query, done) -> done null, 'choose life'
    

# -------------- private stuff ---------------------------

  get = (uri, done) ->
    request.get uri, (err, res, body) ->
      done err, body

  parse_opt = (opt) -> if opt.length is 1 then opt[0] else {}

  is_object = (obj) -> obj is Object obj
