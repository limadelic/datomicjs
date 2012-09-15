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
      console.log datoms
      done()
