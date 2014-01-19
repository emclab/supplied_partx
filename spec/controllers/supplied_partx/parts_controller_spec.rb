require 'spec_helper'

module SuppliedPartx
  describe PartsController do
    before(:each) do
      controller.should_receive(:require_signin)
      controller.should_receive(:require_employee)
           
    end
    
    before(:each) do
      wf = "def submit
          wf_common_action('fresh', 'entering_receiving_date', 'submit')
        end 
        def enter_receiving_date
          wf_common_action('entering_receiving_date', 'entering_purchasing_data', 'enter_receiving_data')
        end 
        def enter_purchasing_data
          wf_common_action('entering_purchasing_data', 'manager_reviewing', 'enter_purchasing_data')
        end
        def vp_approve
          wf_common_action('manager_reviewing', 'ceo_reviewing', 'manager_approve')
        end 
        def vp_reject
          wf_common_action('manager_reviewing', 'entering_purchasing_data', 'manager_reject')
        end   
        def ceo_approve
          wf_common_action('manager_reviewing', 'approved', 'ceo_approve')
        end    
        def ceo_reject
          wf_common_action('manager_reviewing', 'rejected', 'ceo_reject')
        end
        def ceo_rewind
          wf_common_action('manager_reviewing', 'fresh', 'ceo_rewind')
        end
        def stamp
          wf_common_action('approved', 'stamped', 'stamp')
        end
        def receive_delivery
          wf_common_action('stamped', 'delivered', 'receive_delivery')
        end "
      FactoryGirl.create(:engine_config, :engine_name => 'supplied_partx', :engine_version => nil, :argument_name => 'part_wf_action_def', :argument_value => wf)
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_pdef_in_config', :argument_value => 'true')
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_route_in_config', :argument_value => 'true')
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_validate_in_config', :argument_value => 'true')
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_list_open_process_in_day', :argument_value => '45')
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      @project_num_time_gen = FactoryGirl.create(:engine_config, :engine_name => 'heavy_machinery_projectx', :engine_version => nil, :argument_name => 'project_num_time_gen', :argument_value => ' HeavyMachineryProjectx::Project.last.nil? ? (Time.now.strftime("%Y%m%d") + "-"  + 112233.to_s + "-" + rand(100..999).to_s) :  (Time.now.strftime("%Y%m%d") + "-"  + (HeavyMachineryProjectx::Project.last.project_num.split("-")[-2].to_i + 555).to_s + "-" + rand(100..999).to_s)')
      engine_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'piece_unit', :argument_value => "set, piece")
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      
      @pur_sta = FactoryGirl.create(:commonx_misc_definition, 'for_which' => 'purchasing_part')
      @cust = FactoryGirl.create(:kustomerx_customer) 
      @proj = FactoryGirl.create(:heavy_machinery_projectx_project, :customer_id => @cust.id) 
    end
    
    render_views
    
    describe "GET 'index'" do
      it "returns parts" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'supplied_partx_parts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "SuppliedPartx::Part.where(:void => false).order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:supplied_partx_part, :project_id => @proj.id)
        task1 = FactoryGirl.create(:supplied_partx_part, :project_id => @proj.id, :name => 'a new task')
        get 'index', {:use_route => :supplied_partx}
        assigns[:parts].should =~ [task, task1]
      end
      
      it "should only return the part for a project_id" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'supplied_partx_parts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "SuppliedPartx::Part.where(:void => false).order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:supplied_partx_part, :project_id => @proj.id)
        task1 = FactoryGirl.create(:supplied_partx_part, :project_id => @proj.id + 1, :name => 'a new task')
        get 'index', {:use_route => :supplied_partx, :project_id => @proj.id}
        assigns[:parts].should =~ [task]
      end
      
      it "should only return the part for the customer_id" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'supplied_partx_parts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "SuppliedPartx::Part.where(:void => false).order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:supplied_partx_part, :project_id => @proj.id, :void => true)
        task1 = FactoryGirl.create(:supplied_partx_part, :project_id => @proj.id, :name => 'a new task', :customer_id => @cust.id)
        get 'index', {:use_route => :supplied_partx, :project_id => @proj.id, :customer_id => @cust.id}
        assigns[:parts].should =~ [task1]
      end
            
    end
  
    describe "GET 'new'" do
      it "returns bring up new page" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'supplied_partx_parts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        get 'new', {:use_route => :supplied_partx,  :project_id => @proj.id}
        response.should be_success
      end
      
    end
  
    describe "GET 'create'" do
      it "should create and redirect after successful creation" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'supplied_partx_parts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.attributes_for(:supplied_partx_part, :project_id => @proj.id )  
        get 'create', {:use_route => :supplied_partx, :part => task, :project_id => @proj.id}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      end
      
      it "should render 'new' if data error" do        
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'supplied_partx_parts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.attributes_for(:supplied_partx_part, :project_id => @proj.id, :name => nil)
        get 'create', {:use_route => :supplied_partx, :part => task, :project_id => @proj.id}
        response.should render_template('new')
      end
    end
  
    describe "GET 'edit'" do
      it "returns edit page" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'supplied_partx_parts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:supplied_partx_part, :project_id => @proj.id)
        get 'edit', {:use_route => :supplied_partx, :id => task.id}
        response.should be_success
      end
      
      it "redirect to previous page for open process" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'supplied_partx_parts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:supplied_partx_part, :project_id => @proj.id, :wf_state => 'manager_reviewing')
        get 'edit', {:use_route => :supplied_partx, :id => task.id}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=NO Update. Record Being Processed!")
      end
    end
  
    describe "GET 'update'" do
      it "should return success and redirect" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'supplied_partx_parts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:supplied_partx_part, :project_id => @proj.id)
        get 'update', {:use_route => :supplied_partx, :id => task.id, :part => {:name => 'new name'}}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      end
      
      it "should render edit with data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'supplied_partx_parts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:supplied_partx_part, :project_id => @proj.id)
        get 'update', {:use_route => :supplied_partx, :id => task.id, :part => {:name => ''}}
        response.should render_template('edit')
      end
    end
  
    describe "GET 'show'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'supplied_partx_parts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.requested_by_id == session[:user_id]")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        supplier = FactoryGirl.create(:supplierx_supplier)
        status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'part_purchasing_status')
        task = FactoryGirl.create(:supplied_partx_part, :project_id => @proj.id,  :purchasing_id => @u.id, :supplier_id => supplier.id, :status_id => status.id)
        get 'show', {:use_route => :supplied_partx, :id => task.id}
        response.should be_success
      end
    end
    
    describe "GET 'list open process" do
      it "return open process only" do
        user_access = FactoryGirl.create(:user_access, :action => 'list_open_process', :resource =>'supplied_partx_parts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "SuppliedPartx::Part.where(:void => false).order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:supplied_partx_part, :project_id => @proj.id, :created_at => 50.days.ago, :wf_state => 'fresh')
        task1 = FactoryGirl.create(:supplied_partx_part, :project_id => @proj.id, :name => 'a new task', :wf_state => 'rejected')
        task2 = FactoryGirl.create(:supplied_partx_part, :project_id => @proj.id, :name => 'a new task1', :wf_state => 'enter_receiving_date')
        task3 = FactoryGirl.create(:supplied_partx_part, :project_id => @proj.id, :name => 'a new task23', :wf_state => 'ceo_reviewing')
        get 'list_open_process', {:use_route => :supplied_partx}
        assigns(:parts).should =~ [task3, task2]
      end
    end
    
  end
end
