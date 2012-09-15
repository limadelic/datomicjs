{ Datomic } = require '../coffee/datomic'
schema = require './schema'

describe 'Datomic DB', ->

  datomic = new Datomic 'localhost', 8888, 'db', 'test'

  it 'should create a DB', (done) ->
    
    datomic.createDatabase (err, created) ->
      console.log created
      datomic.db (err, db) ->
        console.log db
        done()

  it 'should make transactions', (done) ->
    console.log schema.movies

    datomic.transact schema.movies, (err, future) ->
      console.log future
      done()
