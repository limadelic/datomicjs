request = require 'request'
qs = require 'querystring'
EventStream = require 'eventsource'

class exports.Datomic

  constructor: (server, port, alias, @name) ->
    @root = "http://#{server}:#{port}/"
    @db_alias = alias + '/' + name
    @db_uri = "#{@root}data/#{@db_alias}/"

  createDatabase: (done) ->
    opts =
      method: 'POST'
      uri: "#{@root}data/db/"
      form:
        'db-name': @name

    request opts, (err, res, body) ->
      done err, res.statusCode is 201

  db: (done) -> get @db_uri + '-/', done

  transact: (data, done) ->
    opts =
      method: 'POST'
      uri: @db_uri
      headers:
        accept: 'application/edn'
      form:
        'tx-data': data

    request.post opts, (err, res, body) ->
      done err, body

  datoms: (index, opt..., done) ->
    opt = parse_opt opt
    opt.index = index

    get "#{@db_uri}-/datoms/?index=#{index}&#{qs.stringify opt}", done

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

  q: (query, opt..., done) ->
    opt = parse_opt opt
    opt.q = query
    opt.args = "[{:db/alias #{@db_alias}}]"

    get "#{@root}api/query?#{qs.stringify opt}", done

  events: -> 
    client = new EventStream("#{@root}events/#{@db_alias}")
    client.onerror = ->
      console.dir 'HOLY SHIT'

    return client


# -------------- private stuff ---------------------------

  get = (uri, done) ->
    request.get uri, (err, res, body) ->
      done err, body

  parse_opt = (opt) -> if opt.length is 1 then opt[0] else {}

  is_object = (obj) -> obj is Object obj
