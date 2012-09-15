var request = require('superagent');

exports.Datomic = (function() {

  function Datomic(server, port, alias, name) {
    var root = "http://" + server + ":" + port + "/";
    this.db_uri = root + "db/" + alias + "/" + name;
  }

  Datomic.prototype.createDatabase = function(done) {
    return request.put(this.db_uri, function(err, res) {
      return done(err, res.statusCode === 201);
    });
  };

  Datomic.prototype.db = function(done) {
    return this.get(this.db_uri, done);
  };

  Datomic.prototype.get = function(uri, done) {
    return request(uri, function(err, res) {
      return done(err, res);
    });
  };

  return Datomic;

})();

/*
  this.createDatabase = function(done) {
    var uri = self.db_uri() + '/' + name
    console.log(uri)
    request.put(uri, function(err, res) {
      done(err, res.statusCode === 201)
    })
  }

  this.db = function(done) {
    console.log('here');
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
*/
