Rails.application.routes.draw do
  get 'health_check', to: 'health_check#index'
  get 'unite_attacks', to: 'unite_attacks#index'
  get 'result_illustration_applications', to: 'result_illustration_applications#index'
end
