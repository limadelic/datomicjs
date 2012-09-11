{ Datomic } = require './datomic'

datomic = new Datomic 'localhost', 8888, 'hello', 'world'

datomic.createDatabase (err, created) ->
  console.log created
  datomic.db (err, db) ->
    console.log db

datomic.transact ['db/add', 1, 'name', 'value'], (err, future) ->
  console.log future
