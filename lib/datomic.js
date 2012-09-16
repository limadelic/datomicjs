request = require('request');

exports.Datomic = (function() {

  function Datomic(server, port, alias, name) {
    var root = 'http://' + server + ':' + port + '/';
    this.db_uri = root + 'db/' + alias + '/' + name;
  }

  Datomic.prototype.createDatabase = function(done) {
    return request.put(this.db_uri, function(err, res) {
      return done(err, res.statusCode === 201);
    });
  };

  Datomic.prototype.db = function(done) {
    return this.get(this.db_uri, done);
  };

  Datomic.prototype.transact = function(data, done) {
    return request.post(this.db_uri, {body: data}, function(err, res, body) {
      return done(err, body);
    });
  };

  Datomic.prototype.get = function(uri, done) {
    return request.get(uri, function(err, res, body) {
      return done(err, body);
    });
  };
  
  Datomic.prototype.datoms = function() {
    var 
      args = [].slice.call(arguments),
      done = args.pop(), 
      index = args.shift(), 
      opt = args;

    return this.get(this.db_uri + '/datoms/' + index + 
        this.query_string(this.parse_opt(opt)), done);
  };

  Datomic.prototype.parse_opt = function(opt) {
    return (opt.length === 1) ? opt[0] : {};
  };

  Datomic.prototype.query_string = function(opt) {
    var results = [];
    
    for (field in opt) 
      results.push(field + '=' + opt[field]);
    
    if (!results.length) return '';

    return '?' + results.join('&');
  };

  return Datomic;

})();
