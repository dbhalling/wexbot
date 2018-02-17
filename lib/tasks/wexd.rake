namespace :wexd do
  desc "Obtain price and trade dash bitcoin"
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
      
    unit = TradeDatumD.last.units
    crypto = TradeDatumD.last.crypto
    target = TradeDatumD.last.target
    crypto_pairs_array = ["dsh_btc"]
    price_array = []

    #while true
      crypto_pairs_array.each do |c| 
        puts "The Last Buy Sell is #{exchange(c)}"
        puts "Time #{Time.now}"
        price_array = exchange(c)
        @last_dsh_btc = price_array[0]
        @buy_dsh_btc =  price_array[1]
        @sell_dsh_btc = price_array[2]
      end
      #This is the trade logic
      case crypto
      when "Bitcoin"
        puts "In Bitcoin loop"
        puts "target is #{target} and last_dsh_btc is #{@last_dsh_btc}"
      
        #The price is whether to trade BTC for DSH
        if @last_dsh_btc >= (1.02 * target)
          puts "buy dsh"
          unit = ((unit/@buy_dsh_btc) * 0.998)
          crypto = "Dash"
          #This logic adjusts the target if BTC has gained value compared to Dash
        elsif @sell_dsh_btc < target
          puts "adjust target"
          target = ((0.5 * target) + (0.5 * @sell_dsh_btc))
          puts "the new target is #{target}"
          
        else
        end
      when "Dash"
        puts "in Dash loop"
        # This logic determine whether to trade DSH for BTC
        if @buy_dsh_btc <= (0.99 * target)
          puts "buy btc"
          unit = ((unit * @sell_dsh_btc) * 0.998)
          crypto = "Bitcoin"
          target = @buy_dsh_btc
          puts "New target is #{target}"
          puts "New crypto is #{crypto}"
          
        elsif @buy_dsh_btc > (target)
          puts "adjust target"
          target = ((0.5 * target) +(0.5 * @buy_dsh_btc))
          puts "the new target is #{target}"
          puts "Your bitcoin equivalent position is  #{@last_dsh_btc * unit}"
        else
          btce = @last_dsh_btc * unit
          puts "Your bitcoin equivalent position is #{btce}"
        end
      end  
      puts "The loop just executed"
      puts "this is the buy price #{DashBitcoin.last.buy}"
      puts ""
      puts "Your position is #{unit} units of #{crypto}"
      if crypto == "Dash"
        btce = @last_dash_btc * unit
      else
        btce = unit
      end
      
      
      TradeDatumD.create do |x|
        x.crypto = crypto
        x.units = unit
        x.target = target
        x.btc_equivalent = btce
        x.last = @last_dsh_btc
      end
      # puts the price data in the database
      DashBitcoin.create do |x|
        x.last = @last_dsh_btc
        x.buy = @buy_dsh_btc
        x.sell = @sell_dsh_btc
      end
      DashBitcoin.where("created_at < ?", (Time.now - 4.days)).destroy_all
      TradeDatumD.where("created_at < ?", (Time.now - 4.days)).destroy_all
      #sleep(1.minutes)
    #end      
      
  end
end