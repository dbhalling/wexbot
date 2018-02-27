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
  
  def ltc
    @ltc_btc_trade = LitecoinBitcoin.all
    @trade_data = TradeDatumL.all
  end
  
  def dsh
    @dsh_btc_trade = DashBitcoin.all
    @trade_data = TradeDatumD.all
  end
  
  def eth
    @eth_btc_trade = EtheriumBitcoin.all
    @trade_data = TradeDatumE.all
  end
  
  def zec
    @zec_btc_trade = ZcashBitcoin.all
    @trade_data = TradeDatumZ.all
  end
  
  def bm1
    @bch_btc_trade = BtcbchMa1.all
    @trade_data = TradeDatumMa1.all
  end
  
  def bm6
    @bch_btc_trade = BtcbchMa6.all
    @trade_data = TradeDatumMa6.all
  end
  
  


end



