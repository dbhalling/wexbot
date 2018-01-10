namespace :wextrade do
  desc "Obtain price and trade"
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
      
    unit = TradeDatum.last.unit
    crypto = TradeDatum.last.crypto
    target = TradeDatum.last.target
    crypto_pairs_array = ["bch_btc"]
    price_array = []

    #while true
      crypto_pairs_array.each do |c| 
        puts "The Last Buy Sell is #{exchange(c)}"
        puts "Time #{Time.now}"
        price_array = exchange(c)
        @last_bch_btc = price_array[0]
        @buy_bch_btc =  price_array[1]
        @sell_bch_btc = price_array[2]
      end
      #This is the trade logic
      case crypto
      when "Bitcoin"
        puts "In Bitcoin loop"
        puts "target is #{target} and last_bch_btc is #{@last_bch_btc}"
      
        #The price is how many bt whether to trade BTC for BCH
        if @last_bch_btc >= (1.025 * target)
          puts "buy bch"
          unit = ((unit/@buy_bch_btc) * 0.998)
          crypto = "BitcoinCash"
          #This logic adjusts the target if BTC has gained value compared to BCH 
        elsif @sell_bch_btc < target
          puts "adjust target"
          target = ((0.5 * target) + (0.5 * @sell_bch_btc))
          puts "the new target is #{target}"
        else
        end
      when "BitcoinCash"
        puts "in Bitcoin Cash loop"
        # This logic determine whether to trade BCH for BTC
        if @buy_bch_btc <= (0.99 * target)
          puts "buy btc"
          unit = ((unit * @sell_bch_btc) * 0.998)
          crypto = "Bitcoin"
          target = @buy_bch_btc
          puts "New target is #{target}"
          puts "New crypto is #{crypto}"
          
        elsif @buy_bch_btc > (target)
          puts "adjust target"
          target = @buy_bch_btc
          puts "the new target is #{target}"
          puts "Your bitcoin equivalent position is  #{@last_bch_btc * unit}"
        else
          btce = @last_bch_btc * unit
          puts "Your bitcoin equivalent position is #{btce}"
        end
      end  
      puts "The loop just executed"
      puts "this is the buy price #{BitcoincashBitcoin.last.buy}"
      puts ""
      puts "Your position is #{unit} units of #{crypto}"
      btce = @last_bch_btc * unit
      
      
      TradeDatum.create do |x|
        x.crypto = crypto
        x.units = unit
        x.target = target
        x.btc_equivalent = btce
        x.last = @last_bch_btc
      end
      # puts the price data in the database
      BitcoincashBitcoin.create do |x|
        x.last = @last_bch_btc
        x.buy = @buy_bch_btc
        x.sell = @sell_bch_btc
      end
      BitcoincashBitcoin.where("created_at < ?", (Time.now - 7.days)).destroy_all
      #sleep(1.minutes)
    #end      
      
  end
end 
