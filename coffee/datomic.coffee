request = require 'request'
qs = require 'querystring'
{ transaction, json } = require './parse'

jsedn = require 'jsedn'
EventStream = require 'eventsource'

class exports.Datomic

  constructor: (server, port, alias, @name) ->
    @root = "http://#{server}:#{port}/"
    @db_alias = alias + '/' + name
    @db_uri = "#{@root}data/#{@db_alias}/"
    @db_uri_ = @db_uri + '-/'

  createDatabase: (done) ->
    opts =
      uri: "#{@root}data/db/"
      form:
        'db-name': @name

    request.post opts, (err, res, body) ->
      done err, res.statusCode is 201

  db: (done) -> get @db_uri_, done

  transact: (data, done) ->
    data = transaction data
    opts =
      uri: @db_uri
      headers:
        accept: 'application/edn'
      form:
        'tx-data': data

    request.post opts, (err, res, body) ->
      done err, body

  datoms: (index, opts..., done) ->
    opts = parse_opts opts
    opts.index = index

    get "#{@db_uri_}datoms?#{qs.stringify opts}", done

  indexRange: (attrid, opts..., done) ->
    opts = parse_opts opts
    opts.a = attrid
    opts.index ?= 'aevt'

    get "#{@db_uri_}datoms?#{qs.stringify opts}", done

  entity: (eid, opts..., done) ->
    if is_object eid
      opts = eid
    else
      opts = parse_opts opts
      opts.e = eid

    get "#{@db_uri_}entity?#{qs.stringify opts}", done

  q: (query, opts..., done) ->
    opts = parse_opts opts
    opts.q = query
    opts.args = "[{:db/alias #{@db_alias}}]"

    get "#{@root}api/query?#{qs.stringify opts}", done

  events: ->
    new EventStream("#{@root}events/#{@db_alias}")


# -------------- private stuff ---------------------------

  get = (uri, done) ->
    opts =
      uri: uri
      headers:
        accept: 'application/edn'

    request opts, (err, res, body) ->
      done err, json body

  parse_opts = (opts) -> if opts.length is 1 then opts[0] else {}

  is_object = (obj) -> obj is Object obj
