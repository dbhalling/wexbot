class BacktradeController < ApplicationController


  def index 
    @bch_btc_trade = BitcoincashBitcoin.all
    @trade_data = TradeDatum.all
  end
  
  def btcbchhigh
    @bch_btc_trade = BitcoincashBitcoin.all
    @trade_data = TradeDatumHigh.all
  end
  
  def btcbchlow
    @bch_btc_trade = BitcoincashBitcoin.all
    @trade_data = TradeDatumLow.all
  end
  
  


end



