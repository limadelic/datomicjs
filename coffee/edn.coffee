parser = require 'jsedn'

class @Edn

  constructor: (string) ->
    edn = parser.parse string
    @[key] = edn.at key for key in edn.keys
