_ = require 'underscore'
edn = require 'jsedn'

@transaction = (json) ->
  return json if _.isString json
  edn.encode json

@json = (edn_str) ->
  try
    edn.toJS edn.parse edn_str
  catch e
    edn_str
