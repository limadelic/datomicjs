_ = require 'underscore'
edn = require 'jsedn'

@edn = (json) ->
  return json if _.isString json
  return json.edn() if json.edn?
  edn.encode json

@json = (edn_str) ->
  console.log edn_str
  try
    edn.toJS edn.parse edn_str
  catch e
    edn_str

@find = (args...) -> new Query args

@f = (args...) ->
  result = edn.parse '(> ?r 8.8)'
  result.val[1] = '?r'
  console.log edn.encode [ result ]
  result
  
class Query

  constructor: (args) ->
    @data = [':find'].concat args

  where: (args...) -> @data = @data.concat [':where', args]

  edn: -> edn @data
