class BacktradeController < ApplicationController


  def index 
    @bch_btc_trade = BitcoincashBitcoin.all
    @trade_data = TradeDatum.all
  end


end



