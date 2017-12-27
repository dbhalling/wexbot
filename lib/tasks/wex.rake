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


#     crypto_pairs_array = ["btc_usd", "bch_btc", "ltc_btc", "nvc_btc", "ppc_btc", "dsh_btc", "eth_btc", "zec_btc"]
      crypto_pairs_array = ["bch_btc"]
      
      price_array = []

      i = 1
      while i == 1
        crypto_pairs_array.each do |c| 
          puts "The Last Buy Sell is #{exchange(c)}"
          price_array = exchange(c)
          @last_bch_btc = price_array[0]
          @buy_bch_btc =  price_array[1]
          @sell_bch_btc = price_array[2]
          puts "last is #{@last_bch_btc}"
          
          # puts the price data in the database
          BitcoincashBitcoin.create do |x|
            x.last = @last_bch_btc
            x.buy = @buy_bch_btc
            x.sell = @sell_bch_btc
          end
          
          
        end  
        puts "The loop just executed"
        puts BitcoincashBitcoin.last.buy
        sleep 10
      end
    
  end 
end