class BacktradeController < ApplicationController


  def index 
    @bch_btc_trade = BitcoincashBitcoin.all
  end


end



