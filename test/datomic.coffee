{ Datomic } = require src + 'datomic'
schema = require './schema'

describe 'Datomic', ->

  datomic = new Datomic 'localhost', 8888, 'db', 'test'
  
  it 'should create a DB', (done) ->
    
    datomic.createDatabase (err, created) ->
      datomic.db (err, db) ->
        db.should.include 'db/test'
        done()

  it 'should make transactions', (done) ->

    datomic.transact schema.movies, (err, future) ->
      future.should.include ':db-after'
      done()

  it 'should get datoms', (done) ->

    datomic.datoms 'eavt', (err, datoms) ->
      datoms.should.not.be.empty
      done()
      
  it 'should get datoms with options', (done) ->

    datomic.datoms 'avet', {limit:1}, (err, datoms) ->
      datoms.should.not.be.empty
      done()
      
  it 'should get a range of index data', (done) ->

    datomic.indexRange 'db/ident', (err, datoms) ->
      datoms.should.not.be.empty
      done()

  it 'should get an entity', (done) ->

    datomic.entity 1, (err, entity) ->
      entity.should.include ':db/id 1'
      done()

  it 'should get an entity with options', (done) ->

    datomic.entity {e:1, since:0}, (err, entity) ->
      entity.should.include ':db/id 1'
      done()

  it 'should allow to query', (done) ->
    
    datomic.transact '[[:db/add 1 :movie/title "trainspotting"]]', ->
      datomic.q '[:find ?m :where [?m :movie/title "trainspotting"]]', (err, movies) ->
        movies.should.equal '[[1]]'
        done()

  it 'should allow to query with opt', (done) ->
    
    datomic.transact '[[:db/add 2 :movie/title "the matrix"]]', ->
      datomic.transact '[[:db/add 3 :movie/title "the matrix reloaded"]]', ->
        datomic.q '[:find ?m :where [?m :movie/title]]', {limit:1, offset:2}, (err, movies) ->
          movies.should.equal '[[2]]'
          done()

###
  it 'should register to events', (done) ->
    client = datomic.events()
    client.onmessage = (event) ->
      event.data.should.include ':db-after'
      client.close()
      done()

    datomic.transact schema.movies, ->
