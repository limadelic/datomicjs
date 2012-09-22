_ = require 'underscore'
edn = require 'jsedn'

@transaction = (json) ->
  return json if _.isString json

  new edn.Vector(
    new edn.Vector tran for tran in json
  ).ednEncode()
