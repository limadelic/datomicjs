{ Datomic } = require src + 'datomic'
schema = require './schema'

describe 'Sample with movies', ->

  imdb = new Datomic 'localhost', 8888, 'db', 'imdb'

  add_movie = (id, title, done) ->
    imdb.transact [['db/add', id, 'movie/title', title]], ->
      done()

  before (done) ->
    
    imdb.createDatabase ->
      imdb.transact schema.movies, ->
        add_movie 1, "pulp fiction", ->
          add_movie 2, "fight club", ->
            add_movie 3, "lola rennt", ->
              done()

  it 'should return all', (done) ->
    imdb.q '[:find ?m :where [?m :movie/title]]', (err, movies)->
      console.log movies
      done()
