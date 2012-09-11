parser = require 'jsedn'

class @Edn

  constructor: (string) ->
    console.log edn = parser.parse string
    @[key] = edn.at key for key in edn.keys
