namespace :wexz do
  desc "Obtain price and trade Zcash bitcoin"
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
      
    unit = TradeDatumZ.last.units
    crypto = TradeDatumZ.last.crypto
    target = TradeDatumZ.last.target
    crypto_pairs_array = ["zec_btc"]
    price_array = []

    while true
      crypto_pairs_array.each do |c| 
        puts "The Last Buy Sell is #{exchange(c)}"
        puts "Time #{Time.now}"
        price_array = exchange(c)
        @last_zec_btc = price_array[0]
        @buy_zec_btc =  price_array[1]
        @sell_zec_btc = price_array[2]
      end
      #This is the trade logic
      case crypto
      when "Bitcoin"
        puts "In Bitcoin loop"
        puts "target is #{target} and last_zec_btc is #{@last_zec_btc}"
      
        #The price is how many bt whether to trade BTC for ZEC
        if @last_zec_btc >= (1.02 * target)
          puts "buy zec"
          unit = ((unit/@buy_zec_btc) * 0.998)
          crypto = "Zcash"
          #This logic adjusts the target if BTC has gained value compared to ZEC
        elsif @sell_zec_btc < target
          puts "adjust target"
          target = ((0.5 * target) + (0.5 * @sell_zec_btc))
          puts "the new target is #{target}"
          
        else
        end
      when "Zcash"
        puts "in Zcash loop"
        # This logic determine whether to trade ZEC for BTC
        if @buy_zec_btc <= (0.99 * target)
          puts "buy btc"
          unit = ((unit * @sell_zec_btc) * 0.998)
          crypto = "Bitcoin"
          target = @buy_zec_btc
          puts "New target is #{target}"
          puts "New crypto is #{crypto}"
          
        elsif @buy_zec_btc > (target)
          puts "adjust target"
          target = ((0.5 * target) +(0.5 * @buy_zec_btc))
          puts "the new target is #{target}"
          puts "Your bitcoin equivalent position is  #{@last_zec_btc * unit}"
        else
          btce = @last_zce_btc * unit
          puts "Your bitcoin equivalent position is #{btce}"
        end
      end  
      puts "The loop just executed"
      puts "this is the buy price #{ZcashBitcoin.last.buy}"
      puts ""
      puts "Your position is #{unit} units of #{crypto}"
      if crypto == "Zcash"
        btce = @last_zec_btc * unit
      else
        btce = unit
      end
      
      
      TradeDatumZ.create do |x|
        x.crypto = crypto
        x.units = unit
        x.target = target
        x.btc_equivalent = btce
        x.last = @last_zec_btc
      end
      # puts the price data in the database
      ZcashBitcoin.create do |x|
        x.last = @last_zec_btc
        x.buy = @buy_zec_btc
        x.sell = @sell_zec_btc
      end
      ZcashBitcoin.where("created_at < ?", (Time.now - 7.days)).destroy_all
      sleep(1.minutes)
    end      
      
  end
end 
