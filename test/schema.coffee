@movies = '''
[
  {:db/id #db/id[:db.part/db]
   :db/ident :movie/title
   :db/valueType :db.type/string
   :db/cardinality :db.cardinality/one
   :db/doc "movie's title"
   :db.install/_attribute :db.part/db}
]
'''

@json =
  movies: [{
    'db/id': '#db/id[:db.part/db]'
    'db/ident': ':movie/title'
    'db/valueType': ':db.type/string'
    'db/cardinality': ':db.cardinality/one'
    'db/doc': "movie's title"
    'db.install/_attribute': ':db.part/db'
  }]

