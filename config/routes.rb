Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'anagrams/index'
  get 'anagrams/new'
  post 'anagrams' => 'anagrams#create'
  get 'anagrams/:text' => 'anagrams#show'
  get 'anagrams/:text/show' => 'anagrams#show'


end
