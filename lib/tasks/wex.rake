namespace :wex do
  desc "price"
  task rails: :environment do
    
    #ruby file to access WEX API

    require 'net/http'
    require 'json'
 
 
    #c = "btc_usd"
      

 
    def exchange (c)
      url = "https://wex.nz/api/3/ticker/#{c}"
      uri = URI(url)
      response = Net::HTTP.get(uri)
      exchange_data = JSON.parse(response)
      last = exchange_data["#{c}"]["last"]
      buy = exchange_data["#{c}"]["buy"]
      sell = exchange_data["#{c}"]["sell"]
      puts "#{c}"
      return last, buy, sell
    end
      
    


    #crypto_pairs_array = ["btc_usd", "bch_btc", "ltc_btc", "nvc_btc", "ppc_btc", "dsh_btc", "eth_btc", "zec_btc"]
    crypto_pairs_array = ["bch_btc"]
    price_array = []
    
    while true
      crypto_pairs_array.each do |c| 
        puts "The Last Buy Sell is #{exchange(c)}"
        price_array = exchange(c)
        @last_bch_btc = price_array[0]
        @buy_bch_btc =  price_array[1]
        @sell_bch_btc = price_array[2]
        puts "last is #{@last_bch_btc}"
      end
         
      # puts the price data in the database
      BitcoincashBitcoin.create do |x|
        x.last = @last_bch_btc
        x.buy = @buy_bch_btc
        x.sell = @sell_bch_btc
      end
      BitcoincashBitcoin.where("created_at < ?", (Time.now - 7.days)).destroy_all
      puts "The loop just executed"
      puts "this is the buy price #{BitcoincashBitcoin.last.buy}"
      puts ""
      sleep(5.minutes) 
    end
  end 
end