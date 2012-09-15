var Datomic = require('./datomic')
  , request = require('superagent')

var datomic = new Datomic('localhost', 9999, 'datomapi', 'test')

datomic.createDatabase(function(err, created) {
  console.log(created)
  datomic.db(function(err, db) {
    console.dir(db)

    datomic.transact([], function(err, future) {
      console.dir(future)
    })
  })
})
