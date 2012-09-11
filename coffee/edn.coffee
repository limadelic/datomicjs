parser = require 'jsedn'

@json = (string) ->
  edn = parser.parse string
  result = {}
  result[key] = edn.at key for key in edn.keys
  result

@edn = (array) ->
  console.log parser.encode new parser.Vector array
