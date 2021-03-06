Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
root "home#index"
namespace :api, defaults: { format: 'json' } do
  get 'games', to:"game#index"
  get 'chars', to: "game#getRandomChars"
 post 'check', to: "game#checkWord"
  #  get 'check', to: "game#checkWord"
  get 'al', to: "game#adjacentlist"
  get 'adj', to:"game#adjacent"
  get 'dt', to: "game#dfs"
  get "board", to: "game#createBoard"
  post "word", to:"words#validwords"
end
end
