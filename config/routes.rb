SuppliedPartx::Engine.routes.draw do

  resources :parts do
    collection do
      get :search
      get :search_results
      get :stats
      get :stats_results    
    end

#=begin    
    workflow_routes = Authentify::AuthentifyUtility.find_config_const('part_wf_route', 'supplied_partx')
    if Authentify::AuthentifyUtility.find_config_const('wf_route_in_config') == 'true' && workflow_routes.present?
      eval(workflow_routes) 
    elsif Rails.env.test?
      member do
        get :event_action
        patch :submit
        patch :enter_receiving_date
        patch :checkout_from_warehouse
        patch :enter_purchasing_data
        patch :manager_accept
        patch :manager_reject
        patch :ceo_accept
        patch :ceo_reject
        patch :ceo_rewind
        patch :stamp
        patch :receive_delivery
        
      end
      
      collection do
        get :list_open_process
      end
    end
#=end
  end
  
  root :to => 'parts#index'
end
