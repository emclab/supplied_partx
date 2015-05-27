Rails.application.routes.draw do

  mount SuppliedPartx::Engine => "/supplied_partx"
  mount Commonx::Engine => "/commonx"
  mount Authentify::Engine => '/authentify'
  mount Kustomerx::Engine => '/customerx'
  mount HeavyMachineryProjectx::Engine => '/projectx'
  mount Supplierx::Engine => '/supplierx'
  mount Manufacturerx::Engine => '/manufacturer'
  mount Searchx::Engine => '/searchx'
  mount StateMachineLogx::Engine => '/sm_log'
  mount BizWorkflowx::Engine => '/biz_wf'
  mount PaymentRequestx::Engine => '/pr'
  
  #resource :session
  
  root :to => "authentify/sessions#new"
  get '/signin',  :to => 'authentify/sessions#new'
  get '/signout', :to => 'authentify/sessions#destroy'
  get '/user_menus', :to => 'user_menus#index'
  get '/view_handler', :to => 'authentify/application#view_handler'
end
