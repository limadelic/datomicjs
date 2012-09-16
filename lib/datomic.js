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
    return get(this.db_uri, done);
  };

  Datomic.prototype.transact = function(data, done) {
    return request.post(this.db_uri, {body: data}, function(err, res, body) {
      return done(err, body);
    });
  };

  Datomic.prototype.datoms = function(index, opt, done) {
    var args = [].slice.call(arguments);
    
    index = args.shift(); 
    done = args.pop(); 
    opt = parse_opt(args);

    return get(this.db_uri + '/datoms/' + index + 
        query_string(opt), done);
  };

  Datomic.prototype.indexRange = function(attrid, opt, done) {
    var args = [].slice.call(arguments);

    attrid = args.shift();
    done = args.pop();
    opt = parse_opt(args);
    opt.a = attrid;

    return get(this.db_uri + '/range' + query_string(opt), done);
  };

  return Datomic;

// ------------- private stuff ------------

  function get(uri, done) {
    return request.get(uri, function(err, res, body) {
      return done(err, body);
    });
  };
  
  function parse_opt(opt) {
    return opt.length === 1 ? opt[0] : {};
  };

  function query_string(opt) {
    var results = [];
    
    for (var field in opt) 
      results.push(field + '=' + opt[field]);
    
    if (!results.length) return '';

    return '?' + results.join('&');
  };

})();
