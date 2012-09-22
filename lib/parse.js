var
  _ = require('underscore'),
  edn = require('jsedn');

exports.transaction = function(json) {
  return json;
};

exports.json = function(edn_str) {
  try {
    return edn.toJS(edn.parse(edn_str));
  } catch (e) {
    return edn_str;
  }
};
