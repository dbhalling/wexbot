namespace :trade do
  desc "excutes trade logic"
  task rails: :environment do
    
    
    @bch_btc_trade = BitcoincashBitcoin.all
    @last = @bch_btc_trade[0].last
    @buy = @bch_btc_trade[0].buy 
    @sell = @bch_btc_trade[0].sell
    @time = @bch_btc_trade[0].created_at
    
    
    puts "Last is #{@last}"
    puts "Buy is #{@buy}"
    puts "Sell is #{@sell}"
    puts "Timestamp is #{@time}"
    
    
    #This is the initial position - one bitcoin
    unit = 1.0
    crypto = "Bitcoin"
    
    target = @last
    
    @bch_btc_trade.each do |i|
      puts ""
      puts "Last #{i.last} Buy #{i.buy} Sell #{i.sell}              Time #{i.created_at}"
     
      
      case crypto
      when "Bitcoin"
        puts "In Bitcoin loop"
        
#The price is how many bitcoins will you give up or recieve
#As a result, while we are buying BCH we want the target to be based on what we can sell it for.
        #target = i.sell  
      #This logic determines whether to trade BTC for BCH
        if i.sell >= (1.022 * target)
          puts "buy bch"
          unit = ((unit/i.buy) * 0.998)
          crypto = "BitcoinCash"

#This logic adjusts the target if BTC has gained value compared to BCH 
        elsif i.sell < target
          puts "adjust target"
          target = (target + i.sell)/2
          puts "the new target is #{target}"
        else
        end
      
      when "BitcoinCash"
        puts "in Bitcoin Cash loop"
  
  # This logic determine whether to trade BCH for BTC
        if i.buy <= (0.99 * target)
          puts "buy btc"
          unit = ((unit * i.sell) * 0.998)
          crypto = "Bitcoin"
          target = i.buy
          puts "New target is #{target}"
          puts "New crypto is #{crypto}"
          
        elsif i.buy > (target)
          puts "adjust target"
          target = i.buy
          puts "the new target is #{target}"
          puts "Your bitcoin equivalent position is  #{i.last * unit}"
        else
          puts "Your bitcoin equivalent position is #{i.last * unit}"
        end
            
        
      end
      puts "Your position is #{unit} units of #{crypto}"
      #if crypto = "BitcoinCash"
        #ebtc = unit * i.last
        #puts "Your bitcoin equivalent is"
      #end
      
    end
    
    
    
    
    
    
    
    
    
    
    
    
 end   
end
