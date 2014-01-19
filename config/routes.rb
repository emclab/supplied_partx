SuppliedPartx::Engine.routes.draw do

  resources :parts do
    collection do
      get :search
      put :search_results
      get :stats
      put :stats_results    
    end

#=begin    
    workflow_routes = Authentify::AuthentifyUtility.find_config_const('part_workflow_routes', 'supplied_partx')
    if Authentify::AuthentifyUtility.find_config_const('wf_route_in_config') == 'true' && workflow_routes.present?
      eval(workflow_routes) 
    else
      member do
        get :event_action
        put :submit
        put :enter_receiving_date
        put :checkout_from_warehouse
        put :enter_pur_data
        put :vp_accept
        put :vp_reject
        put :ceo_accept
        put :ceo_reject
        put :ceo_rewind
        
      end
      
      collection do
        get :list_open_process
      end
    end
#=end
  end
  
  root :to => 'parts#index'
end
