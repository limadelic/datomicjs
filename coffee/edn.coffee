_ = require 'underscore'
edn = require 'jsedn'

@edn = (json) ->
  return json if _.isString json
  edn.encode json

@json = (edn_str) ->
  try
    edn.toJS edn.parse edn_str
  catch e
    edn_str

@find = (args...) -> [':find'].concat args

Array.prototype.where = (args...) -> @.concat [':where', args]
