global.src = '../lib/'

var api = require(src + 'datomic')
  , schema = require('./schema')


describe('Datomic', function(){
  var datomic = new api.Datomic('localhost', 8888, 'db', 'test')

  it('should create a DB', function(done){
    datomic.createDatabase(function(err, created){
      datomic.db(function(err, db){
        if (err) console.log(err.stack)
        db.should.include('db/test')
        done()
      })
    })
  })
})
