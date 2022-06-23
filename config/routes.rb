Rails.application.routes.draw do
  get 'health_check', to: 'health_check#index', format: 'json'
  get 'unite_attacks', to: 'unite_attacks#index', format: 'json'
  get 'result_illustration_applications', to: 'result_illustration_applications#index', format: 'json'
  get 'check_votes_and_bonuses', to: 'check_votes_and_bonuses#index', format: 'json'
  get 'characters', to: 'characters#index', format: 'json'
end
