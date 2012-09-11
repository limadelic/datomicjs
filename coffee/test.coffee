{ Datomic } = require './datomic'


datomic = new Datomic 'localhost', 8888, 'hello'

datomic.createDatabase 'world', (err, created) ->
  console.log created
  datomic.db 'world', (err, db) ->
    console.log db
