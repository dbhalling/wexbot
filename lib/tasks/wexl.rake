namespace :wexl do
  desc "Obtain price and trade litecoin bitcoin"
  task rails: :environment do
    require 'net/http'
    
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
      
    unit = TradeDatumL.last.units
    crypto = TradeDatumL.last.crypto
    target = TradeDatumL.last.target
    crypto_pairs_array = ["ltc_btc"]
    price_array = []

    #while true
      crypto_pairs_array.each do |c| 
        puts "The Last Buy Sell is #{exchange(c)}"
        puts "Time #{Time.now}"
        price_array = exchange(c)
        @last_ltc_btc = price_array[0]
        @buy_ltc_btc =  price_array[1]
        @sell_ltc_btc = price_array[2]
      end
      #This is the trade logic
      case crypto
      when "Bitcoin"
        puts "In Bitcoin loop"
        puts "target is #{target} and last_ltc_btc is #{@last_ltc_btc}"
      
        #The price is how many bt whether to trade BTC for LTC
        if @last_ltc_btc >= (1.02 * target)
          puts "buy ltc"
          unit = ((unit/@buy_ltc_btc) * 0.998)
          crypto = "Litecoin"
          #This logic adjusts the target if BTC has gained value compared to LTC
        elsif @sell_ltc_btc < target
          puts "adjust target"
          target = ((0.5 * target) + (0.5 * @sell_ltc_btc))
          puts "the new target is #{target}"
          
        else
        end
      when "Litecoin"
        puts "in Litecoin loop"
        # This logic determine whether to trade LTC for BTC
        if @buy_ltc_btc <= (0.99 * target)
          puts "buy btc"
          unit = ((unit * @sell_ltc_btc) * 0.998)
          crypto = "Bitcoin"
          target = @buy_ltc_btc
          puts "New target is #{target}"
          puts "New crypto is #{crypto}"
          
        elsif @buy_ltc_btc > (target)
          puts "adjust target"
          target = ((0.5 * target) +(0.5 * @buy_ltc_btc))
          puts "the new target is #{target}"
          puts "Your bitcoin equivalent position is  #{@last_ltc_btc * unit}"
        else
          btce = @last_ltc_btc * unit
          puts "Your bitcoin equivalent position is #{btce}"
        end
      end  
      puts "The loop just executed"
      puts "this is the buy price #{LitecoinBitcoin.last.buy}"
      puts ""
      puts "Your position is #{unit} units of #{crypto}"
      if crypto == "Litecoin"
        btce = @last_ltc_btc * unit
      else
        btce = unit
      end
      
      
      TradeDatumL.create do |x|
        x.crypto = crypto
        x.units = unit
        x.target = target
        x.btc_equivalent = btce
        x.last = @last_ltc_btc
      end
      # puts the price data in the database
      LitecoinBitcoin.create do |x|
        x.last = @last_ltc_btc
        x.buy = @buy_ltc_btc
        x.sell = @sell_ltc_btc
      end
      LitecoinBitcoin.where("created_at < ?", (Time.now - 4.days)).destroy_all
      TradeDatumL.where("created_at < ?", (Time.now - 4.days)).destroy_all
      #sleep(1.minutes)
    #end      
      
  end
end 
