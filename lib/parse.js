var
  _ = require('underscore'),
  edn = require('jsedn');

exports.transaction = function(json) {
  if (_.isString(json)) return json;

  return new edn.Vector(
    _.map(json, function(tran){
      return new edn.Vector(tran);  
    }) 
  ).ednEncode();
};

exports.json = function(edn_str) {
  try {
    return edn.toJS(edn.parse(edn_str));
  } catch (e) {
    return edn_str;
  }
};
