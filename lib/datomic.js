var request = require('superagent')

module.exports = function(server, port, alias, name) {
  var self = this
    , root = "http://" + server + ":" + port + '/'

  this.db_uri = function() { 
    return [root + "db", alias].join("/") 
  }

  this.createDatabase = function(done) {
    var uri = self.db_uri() + '/' + name
    console.log(uri)
    request.put(uri, function(err, res) {
      done(err, res.statusCode === 201)
    })
  }

  this.db = function(done) {
    request(self.db_uri(), function(err, res) {
      done(err, res.body)
    })
  }

  this.transact = function(data, done) {
    request.post(self.db_uri())
      .data({ body: '[:db/add 1 :x 42]' })
      .end(function(err, res) {
        done(err, res.body)
      })
  }
}
