#async = require 'async'
{ Datomic } = require src + 'datomic'
schema = require './schema'

describe 'Sample with movies', ->

  imdb = new Datomic 'localhost', 8888, 'db', 'imdb'

  before (done) ->
    imdb.createDatabase ->
      imdb.transact schema.movies, (err, future) ->
        done()

  it 'should return all', (done) ->
    imdb.q '[:find ?m :where [?m :movie/title]]', (err, movies) ->
      console.log movies
      done err
