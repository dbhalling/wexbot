namespace :wexusdm1 do
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
      
    unit = TradeDatumUsdm1.last.units
    crypto = TradeDatumUsdm1.last.crypto
    target = TradeDatumUsdm1.last.target
    crypto_pairs_array = ["btc_usd"]
    price_array = []
    
    
    while true
      #calculates the one hour moving average
      maarray = Usdma1.all
      lastpricearray = maarray.collect { |x| x.last }
      lastpricearray6 =[]
      lastpricearray6 = lastpricearray.pop(6)
      sum = 0.0
      lastpricearray6.each { |x| sum += x }
      ma1 = sum / 6
    
    puts "Moving average is #{ma1}"

    
      crypto_pairs_array.each do |c| 
        puts "The Last Buy Sell is #{exchange(c)}"
        puts "Time #{Time.now}"
        price_array = exchange(c)
        @last_btc_usd = price_array[0]
        @buy_btc_usd =  price_array[1]
        @sell_btc_usd = price_array[2]
      end
      #This is the trade logic
      case crypto
      when "Bitcoin"
        puts "In Bitcoin loop"
        puts "target is #{target} and last_btc_usd is #{@last_btc_usd}"
      
        #The price is whether to trade BTC for USD
        if ( @last_btc_usd <= ( 0.98 * target )) and ( @last_btc_usd < ma1 )
          puts "buy usd"
          unit = ((unit/@buy_btc_usd) * 0.998)
          crypto = "USD"
          #This logic adjusts the target if BTC has gained value compared to USD 
        elsif @sell_btc_usd < target
          puts "adjust target"
          target = ((0.5 * target) + (0.5 * @sell_btc_usd))
          puts "the new target is #{target}"
          
        else
        end
      when "USD"
        puts "in USD loop"
        # This logic determine whether to trade USD for BTC
        if @buy_btc_usd >= (1.02 * target)
          puts "buy btc"
          unit = ((unit * @sell_btc_usd) * 0.998)
          crypto = "Bitcoin"
          target = @buy_btc_usd
          puts "New target is #{target}"
          puts "New crypto is #{crypto}"
          
        elsif @buy_btc_usd > (target)
          puts "adjust target"
          target = ((0.5 * target) + (0.5 * @buy_btc_usd))
          puts "the new target is #{target}"
          puts "Your bitcoin equivalent position is  #{@last_btc_usd * unit}"
        else
          btce = @last_btc_usd * unit
          puts "Your bitcoin equivalent position is #{btce}"
        end
      end  
      puts "The loop just executed"
      puts "this is the buy price #{Usdma1.last.buy}"
      puts ""
      puts "Your position is #{unit} units of #{crypto}"
      if crypto == "USD"
        btce = @last_btc_usd * unit
      else
        btce = unit
      end
      
      
      TradeDatumUsdm1.create do |x|
        x.crypto = crypto
        x.units = unit
        x.target = target
        x.btc_equivalent = btce
        x.last = @last_btc_usd
      end
      # puts the price data in the database
      Usdma1.create do |x|
        x.last = @last_btc_usd
        x.buy = @buy_btc_usd
        x.sell = @sell_btc_usd
      end
      Usdma1.where("created_at < ?", (Time.now - 4.days)).destroy_all
      TradeDatumUsdm1.where("created_at < ?", (Time.now - 4.days)).destroy_all
      sleep(1.minutes)
    end      
      
  end
end 
