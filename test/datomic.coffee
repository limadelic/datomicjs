{ Datomic } = require src + 'datomic'
parse = require '../lib/parse'
schema = require './schema'

describe 'Datomic', ->

  datomic = new Datomic 'localhost', 8888, 'db', 'test'
  
  it 'should fetch available storage aliases', (done) ->

    datomic.storages (err, storages) ->
      parse.json(storages).should.include 'db'
      done()

  it 'should fetch a list of databases for a storage alias', (done) ->

    datomic.databases 'db', (err, databases) ->
      parse.json(databases).should.include 'test'
      done()

  it 'should create a DB', (done) ->
    
    datomic.createDatabase (err, created) ->
      datomic.db (err, db) ->
        parse.json(db)['db/alias'].should.equal 'db/test'
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
      parse.json(datoms).length.should.equal 1
      done()
      
  it 'should get a range of index data', (done) ->

    datomic.indexRange 'db/ident', (err, datoms) ->
      datoms.should.not.be.empty
      done()

  it 'should get an entity', (done) ->

    datomic.entity 1, (err, entity) ->
      parse.json(entity)['db/id'].should.equal 1
      done()

  it 'should get an entity with options', (done) ->

    datomic.entity {e:1, since:0}, (err, entity) ->
      parse.json(entity)['db/id'].should.equal 1
      done()

  it 'should allow to query', (done) ->
    
    datomic.transact '[[:db/add #db/id [:db.part/user] :movie/title "trainspotting"]]', ->
      datomic.q '[:find ?m :where [?m :movie/title "trainspotting"]]', (err, movies) ->
        parse.json(movies)[0][0].should.be.above 1
        done()

  it 'should allow to query with opt', (done) ->
    
    datomic.transact '[[:db/add #db/id [:db.part/user] :movie/title "the matrix"]]', ->
      datomic.transact '[[:db/add #db/id [:db.part/user] :movie/title "the matrix reloaded"]]', ->
        datomic.q '[:find ?m :where [?m :movie/title]]', {limit:1, offset:2}, (err, movies) ->
          parse.json(movies)[0][0].should.be.above 1
          done()

  it 'should allow passing arguments to query', (done) ->

    datomic.q '[:find ?first ?height :in [?last ?first ?email] [?email ?height]]',
      args: """[
        ["Doe" "John" "jdoe@example.com"]
        ["jdoe@example.com" 71]
      ]"""
      (err, result) ->
        data = parse.json result
        data[0][0].should.equal 'John'
        data[0][1].should.equal 71
        done()

  it 'should register to events', (done) ->
    client = datomic.events()
    client.onmessage = (event) ->
      event.data.should.include ':db-after'
      client.close()
      done()

    datomic.transact schema.movies, ->
