{ db, create_database } = require './datomic'

create_database 'hello/time', (err, created) ->
  console.log created
  db 'hello/time', (err, db) ->
    console.log db
