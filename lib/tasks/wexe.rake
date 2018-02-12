namespace :wexe do
  desc "Obtain price and trade etherium bitcoin"
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
      
    unit = TradeDatumE.last.units
    crypto = TradeDatumE.last.crypto
    target = TradeDatumE.last.target
    crypto_pairs_array = ["eth_btc"]
    price_array = []

    while true
      crypto_pairs_array.each do |c| 
        puts "The Last Buy Sell is #{exchange(c)}"
        puts "Time #{Time.now}"
        price_array = exchange(c)
        @last_eth_btc = price_array[0]
        @buy_eth_btc =  price_array[1]
        @sell_eth_btc = price_array[2]
      end
      #This is the trade logic
      case crypto
      when "Bitcoin"
        puts "In Bitcoin loop"
        puts "target is #{target} and last_eth_btc is #{@last_eth_btc}"
      
        #The price is how many bt whether to trade BTC for ETH
        if @last_eth_btc >= (1.02 * target)
          puts "buy eth"
          unit = ((unit/@buy_eth_btc) * 0.998)
          crypto = "Etherium"
          #This logic adjusts the target if BTC has gained value compared to ETH
        elsif @sell_eth_btc < target
          puts "adjust target"
          target = ((0.5 * target) + (0.5 * @sell_eth_btc))
          puts "the new target is #{target}"
          
        else
        end
      when "Etherium"
        puts "in Etherium loop"
        # This logic determine whether to trade ETH for BTC
        if @buy_eth_btc <= (0.99 * target)
          puts "buy btc"
          unit = ((unit * @sell_eth_btc) * 0.998)
          crypto = "Bitcoin"
          target = @buy_eth_btc
          puts "New target is #{target}"
          puts "New crypto is #{crypto}"
          
        elsif @buy_eth_btc > (target)
          puts "adjust target"
          target = ((0.5 * target) +(0.5 * @buy_eth_btc))
          puts "the new target is #{target}"
          puts "Your bitcoin equivalent position is  #{@last_eth_btc * unit}"
        else
          btce = @last_eth_btc * unit
          puts "Your bitcoin equivalent position is #{btce}"
        end
      end  
      puts "The loop just executed"
      puts "this is the buy price #{EtheriumBitcoin.last.buy}"
      puts ""
      puts "Your position is #{unit} units of #{crypto}"
      if crypto == "Etherium"
        btce = @last_eth_btc * unit
      else
        btce = unit
      end
      
      
      TradeDatumE.create do |x|
        x.crypto = crypto
        x.units = unit
        x.target = target
        x.btc_equivalent = btce
        x.last = @last_eth_btc
      end
      # puts the price data in the database
      EtheriumBitcoin.create do |x|
        x.last = @last_eth_btc
        x.buy = @buy_eth_btc
        x.sell = @sell_eth_btc
      end
      EtheriumBitcoin.where("created_at < ?", (Time.now - 7.days)).destroy_all
      sleep(1.minutes)
    end      
      
  end
end 
