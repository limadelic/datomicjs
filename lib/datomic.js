request = require('request');

exports.Datomic = (function() {

  function Datomic(server, port, alias, name) {
    this.root = 'http://' + server + ':' + port + '/';
    this.alias = alias
    this.db_uri = this.root + 'data/' + alias + '/' + name + '/'
    this.db_uri_ = this.db_uri + '-/'
    this.db_name = name
  }

  Datomic.prototype.createDatabase = function(done) {
    var opts = {
      method: 'POST',
      uri: this.root + 'data/' + this.alias + '/',
      form: { 'db-name': this.db_name }
    }
    return request(opts, function(err, res) {
      return done(err, res.statusCode === 201);
    });
  };

  Datomic.prototype.db = function(done) {
    return get(this.db_uri + '-/', done);
  };

  Datomic.prototype.transact = function(data, done) {
    var opts = {
      uri: this.db_uri,
      headers: { accept: 'application/edn' },
      form: { 'tx-data': data }
    }

    return request.post(opts, function(err, res, body) {
      return done(err, body);
    });
  };

  Datomic.prototype.datoms = function(index, opt, done) {
    var args = [].slice.call(arguments);
    
    index = args.shift(); 
    done = args.pop(); 
    opt = parse_opt(args);

    return get(this.db_uri_ + 'datoms?' + query_string(opt), done);
  };

  Datomic.prototype.indexRange = function(attrid, opt, done) {
    var args = [].slice.call(arguments);

    attrid = args.shift();
    done = args.pop();
    opt = parse_opt(args);
    opt.a = attrid;

    return get(this.db_uri + '/range' + query_string(opt), done);
  };
  
  Datomic.prototype.entity = function(eid, opt, done) {
    var args = [].slice.call(arguments);

    eid = args.shift();
    done = args.pop();

    if (is_object(eid)) {
      opt = eid;
      eid = '';
    } else {
      opt = parse_opt(args);
      eid = '/' + eid;
    }

    return get(this.db_uri + '/entity' + eid + query_string(opt), done);
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

  function is_object(obj) {
    return obj === Object(obj);
  };

})();
