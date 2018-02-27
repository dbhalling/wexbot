Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'backtrade#index'
  get 'backtrade/btcbchhigh', to: 'backtrade#btcbchhigh'
  get 'backtrade/btcbchlow' , to: 'backtrade#btcbchlow'
  get 'backtrade/ltc'       , to: 'backtrade#ltc'
  get 'backtrade/dsh'       , to: 'backtrade#dsh'
  get 'backtrade/eth'       , to: 'backtrade#eth'
  get 'backtrade/zec'       , to: 'backtrade#zec'
  get 'backtrade/bm1'       , to: 'backtrade#bm1'
  get 'backtrade/bm6'       , to: 'backtrade#bm6'
end
