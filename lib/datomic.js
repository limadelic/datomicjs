request = require('request');
qs = require('querystring');
EventStream = require('eventsource');

exports.Datomic = (function() {

  function Datomic(server, port, alias, name) {
    this.root = 'http://' + server + ':' + port + '/';
    this.alias = alias;
    this.db_alias = alias + '/' + name;
    this.db_uri = this.root + 'data/' + this.db_alias + '/';
    this.db_uri_ = this.db_uri + '-/';
    this.db_name = name;
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

  Datomic.prototype.datoms = function(index, opts, done) {
    var args = [].slice.call(arguments);
    
    index = args.shift(); 
    done = args.pop(); 
    opts = parse_opts(args);

    return get(this.db_uri_ + 'datoms?' + qs.stringify(opts), done);
  };

  Datomic.prototype.indexRange = function(attrid, opts, done) {
    var args = [].slice.call(arguments);

    attrid = args.shift();
    done = args.pop();
    opts = parse_opts(args);
    opts.a = attrid;

    return get(this.db_uri_ + 'datoms?' + qs.stringify(opts), done);
  };
  
  Datomic.prototype.entity = function(eid, opts, done) {
    var args = [].slice.call(arguments);

    eid = args.shift();
    done = args.pop();

    if (is_object(eid)) {
      opts = eid;
    } else {
      opts = parse_opts(args);
      opts.e = eid;
    }

    return get(this.db_uri_ + 'entity?' + qs.stringify(opts), done);
  };

  Datomic.prototype.q = function(query, opts, done) {
    var args = [].slice.call(arguments);

    query = args.shift();
    done = args.pop();
    opts = parse_opts(args);
    opts.q = query;
    opts.args = '[{:db/alias ' + this.db_alias + '}]';

    return get(this.root + 'api/query?' + qs.stringify(opts), done);
  };
  
  Datomic.prototype.events = function() {
    return new EventStream(this.root + 'events/' + this.db_alias);
  };

  return Datomic;

// ------------- private stuff ------------

  function get(uri, done) {
    var opts = {
      uri: uri,
      headers: {
        accept: 'application/edn'
      }
    };

    return request(opts, function(err, res, body) {
      return done(err, body);
    });
  };
  
  function parse_opts(opts) {
    return opts.length === 1 ? opts[0] : {};
  };

  function is_object(obj) {
    return obj === Object(obj);
  };

})();
