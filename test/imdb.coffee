{ Datomic } = require src + 'datomic'
{ edn, find, f } = require src + 'edn'
parse = require '../lib/parse'
schema = require './schema'

describe 'Sample with movies', ->

  imdb = new Datomic 'localhost', 8888, 'db', 'imdb'

  add_movie = (title, rating, done) -> 
    imdb.transact "[{:db/id #db/id [:db.part/user] :movie/title \"#{title}\" :movie/rating #{rating}}]", done

  before (done) ->
    
    imdb.createDatabase ->
      imdb.transact schema.movies, ->
        add_movie 'pulp fiction', 8.9, ->
          add_movie 'fight club', 8.8, ->
            add_movie 'lola rennt', 7.9, ->
              add_movie 'trainspotting', 8.2, ->
                done()

  describe 'pure json', ->
  
    it 'should return all', (done) ->

      imdb.q '[:find ?m :where [?m :movie/title]]', (err, movies)->
        parse.json(movies).length.should.be.above 1
        done()
      
   
    it 'should find a movie over 8.8', (done) ->

      imdb.q "[:find ?t :where [?m :movie/title ?t] [?m :movie/rating ?r] [(> ?r  8.8)]]", (err, movies) ->
        parse.json(movies)[0][0].should.equal 'pulp fiction'
        done()

    it 'should find any movie', (done) ->

      imdb.q "[:find ?m :in $ ?t :where [?m :movie/title ?t]]", 
        {args: '[{:db/alias "db/imdb"} "fight club"]'},
        (err, movie) ->
          parse.json(movie)[0][0].should.be.above 2
          done()

  describe 'fluent interface', ->

    it 'should find trainspotting', (done) ->
      
      imdb.q find('?m').where('?m', ':movie/title', 'trainspotting'), (err, movies) ->

        imdb.entity parse.json(movies)[0][0], (err, movie) ->
         
          parse.json(movie)['movie/title'].should.equal 'trainspotting'
          done()

    it 'should find a movie under 8', (done) ->
      
      imdb.q find('?t')
      .where('?m', ':movie/title', '?t')
      .and('?m', ':movie/rating', '?r')
      .lt('?r', 8), (err, movies) ->

        parse.json(movies)[0][0].should.equal 'lola rennt'
        done()
          
    it 'should find any movie', (done) ->

      imdb.q find('?m')
        .in('?t')
        .where('?m', ':movie/title', '?t'),
        {args: '[{:db/alias "db/imdb"} "trainspotting"]'},
        (err, movie) ->

          parse.json(movie)[0][0].should.be.above 4
          done()
