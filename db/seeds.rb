# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


TradeDatum.create do |x|
  x.crypto = 'Bitcoin'
  x.units = 1.0
  x.target = 0.164
  x.btc_equivalent = 1.0
  x.last = 0.164
end

BitcoincashBitcoin.create do |x|
  x.last = 0.164
  x.buy = 0.165
  x.sell =  0.163
  x.target = 0.164
  
end


TradeDatumHigh.create do |x|
  x.crypto = 'Bitcoin'
  x.units = 1.0
  x.target = 0.164
  x.btc_equivalent = 1.0
  x.last = 0.164
end

TradeDatumLow.create do |x|
  x.crypto = 'Bitcoin'
  x.units = 1.0
  x.target = 0.164
  x.btc_equivalent = 1.0
  x.last = 0.164
end


TradeDatumE.create do |x|
  x.crypto = 'Bitcoin'
  x.units = 1.0
  x.target = 0.09938
  x.btc_equivalent = 1.0
  x.last = 0.09938
end

EtheriumBitcoin.create do |x|
  x.last = 0.09938
  x.buy = 0.09938
  x.sell =  0.09938
  x.target = 0.09938
end
  
  
TradeDatumL.create do |x|
  x.crypto = 'Bitcoin'
  x.units = 1.0
  x.target = 0.01814
  x.btc_equivalent = 1.0
  x.last = 0.01814
end

LitecoinBitcoin.create do |x|
  x.last = 0.01814
  x.buy = 0.01814
  x.sell =  0.01814
  x.target = 0.01814
end

TradeDatumZ.create do |x|
  x.crypto = 'Bitcoin'
  x.units = 1.0
  x.target = 0.052
  x.btc_equivalent = 1.0
  x.last = 0.052
end

ZcashBitcoin.create do |x|
  x.last = 0.052
  x.buy = 0.052
  x.sell =  0.052
  x.target = 0.052
end

TradeDatumD.create do |x|
  x.crypto = 'Bitcoin'
  x.units = 1.0
  x.target = 0.0711
  x.btc_equivalent = 1.0
  x.last = 0.0711
end

DashBitcoin.create do |x|
  x.last = 0.0711
  x.buy = 0.0711
  x.sell =  0.0711
  x.target = 0.0711
end