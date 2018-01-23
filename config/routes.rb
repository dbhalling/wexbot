Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'backtrade#index'
  get 'backtrade/btcbchhigh', to: 'backtrade#btcbchhigh'
  get 'backtrade/btcbchlow', to: 'backtrade#btcbchlow'

end
