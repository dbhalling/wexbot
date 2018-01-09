# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


TradeDatum.create do |x|
  x.crypto = 'btc'
  x.units = 1.1
  x.target = 2.2
  x.btc_equivalent = 1.1
  x.last = 2.1
  
end