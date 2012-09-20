Fiber = require 'fibers'
require 'fibrous'

{ Datomic } = require src + 'datomic'
schema = require './schema'

describe 'Sample with movies', ->

  imdb = new Datomic 'localhost', 8888, 'db', 'imdb'

  add_movie = (id, title) ->
    imdb.sync.transact "[[:db/add #{id} :movie/title \"#{title}\"]]"

  before (done) -> Fiber( ->
    
    imdb.sync.createDatabase()
    imdb.sync.transact schema.movies

    add_movie 1, "trainspotting"
    add_movie 2, "the matrix"
    add_movie 3, "lola rennt"
    
    done()
  ).run()

  it 'should return all', (done) ->
    imdb.q '[:find ?m :where [?m :movie/title]]', (err, movies) ->
      console.log movies
      done err
