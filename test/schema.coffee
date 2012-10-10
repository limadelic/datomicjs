@movies = '''
[
  {:db/id #db/id[:db.part/db]
   :db/ident :movie/title
   :db/valueType :db.type/string
   :db/cardinality :db.cardinality/one
   :db/doc "movie's title"
   :db.install/_attribute :db.part/db}

  {:db/id #db/id[:db.part/db]
   :db/ident :movie/rating
   :db/valueType :db.type/double
   :db/cardinality :db.cardinality/one
   :db/doc "movie's rating"
   :db.install/_attribute :db.part/db}
]
'''
