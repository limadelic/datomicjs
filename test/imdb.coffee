{ Datomic } = require src + 'datomic'
{ edn, find, f } = require src + 'edn'
schema = require './schema'

describe 'Sample with movies', ->

  imdb = new Datomic 'localhost', 8888, 'db', 'imdb'

  add_movie = (id, title, rating, done) -> imdb.transact [
    [':db/add', id, ':title', title]
    [':db/add', id, ':rating', rating]
  ], -> done()

  before (done) ->
    
    imdb.createDatabase ->
      imdb.transact schema.movies, ->
        add_movie 1, 'pulp fiction', 8.9, ->
          add_movie 2, 'fight club', 8.8, ->
            add_movie 3, 'lola rennt', 7.9, ->
              add_movie 4, 'trainspotting', 8.2, ->
                done()

  it 'should return all', (done) ->

    imdb.q [':find', '?m', ':where', ['?m', ':title']], (err, movies)->
      movies.length.should.equal 4
      done()
    
  it 'should find trainspotting', (done) ->
    
    imdb.q find('?m').where('?m', ':title', 'trainspotting'), (err, movies) ->
      imdb.entity movies[0][0], (err, movie) ->
        movie.title.should.equal 'trainspotting'
        done()
  
  it 'should find a movie over 8.8', (done) ->
    
    imdb.q [
      ':find', '?t', ':where',
        ['?m', ':title', '?t']
        ['?m', ':rating', '?r']
        [ f('>', '?r', 8.8) ]
    ], (err, movies) ->
      
      movies[0][0].should.equal 'pulp fiction'
      done()

  it 'should find a movie under 8', (done) ->
    
    imdb.q find('?t')
    .where('?m', ':title', '?t')
    .and('?m', ':rating', '?r')
    .lt('?r', 8), (err, movies) ->

      movies[0][0].should.equal 'lola rennt'
      done()
  
  it 'should find any movie', (done) ->

    imdb.q '[:find ?m :in $ ?t :where [?m :title ?t]]',
    {args: ['fight club']},
    (err, movie) ->
      movie[0][0].should.equal 2
      done()

