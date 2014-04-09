require 'spec_helper'

describe "LinkTests" do
  describe "GET /supplied_partx_link_tests" do
    mini_btn = 'btn btn-mini '
    ActionView::CompiledTemplates::BUTTONS_CLS =
        {'default' => 'btn',
         'mini-default' => mini_btn + 'btn',
         'action'       => 'btn btn-primary',
         'mini-action'  => mini_btn + 'btn btn-primary',
         'info'         => 'btn btn-info',
         'mini-info'    => mini_btn + 'btn btn-info',
         'success'      => 'btn btn-success',
         'mini-success' => mini_btn + 'btn btn-success',
         'warning'      => 'btn btn-warning',
         'mini-warning' => mini_btn + 'btn btn-warning',
         'danger'       => 'btn btn-danger',
         'mini-danger'  => mini_btn + 'btn btn-danger',
         'inverse'      => 'btn btn-inverse',
         'mini-inverse' => mini_btn + 'btn btn-inverse',
         'link'         => 'btn btn-link',
         'mini-link'    => mini_btn +  'btn btn-link'
        }
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
        def manager_approve
          wf_common_action('manager_reviewing', 'ceo_reviewing', 'manager_approve')
        end 
        def manager_reject
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
      
      FactoryGirl.create(:engine_config, :engine_name => 'supplied_partx', :engine_version => nil, :argument_name => 'part_submit_inline', 
                         :argument_value => "<%= f.input :receiving_date, :label => t('Receiving Date') , :as => :string %>")
      FactoryGirl.create(:engine_config, :engine_name => 'supplied_partx', :engine_version => nil, :argument_name => 'validate_part_submit', 
                         :argument_value => "validates :receiving_date, :presence => true                                             
                                           ")
      FactoryGirl.create(:engine_config, :engine_name => 'supplied_partx', :engine_version => nil, :argument_name => 'part_wf_final_state_string', :argument_value => 'from_warehouse, delivered, rejected')
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_pdef_in_config', :argument_value => 'true')
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_route_in_config', :argument_value => '')
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_validate_in_config', :argument_value => 'true')
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_list_open_process_in_day', :argument_value => '45')
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      @project_num_time_gen = FactoryGirl.create(:engine_config, :engine_name => 'heavy_machinery_projectx', :engine_version => nil, :argument_name => 'project_num_time_gen', :argument_value => ' HeavyMachineryProjectx::Project.last.nil? ? (Time.now.strftime("%Y%m%d") + "-"  + 112233.to_s + "-" + rand(100..999).to_s) :  (Time.now.strftime("%Y%m%d") + "-"  + (HeavyMachineryProjectx::Project.last.project_num.split("-")[-2].to_i + 555).to_s + "-" + rand(100..999).to_s)')
      piece_unit = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'piece_unit', :argument_value => "set, piece")
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      
      ua1 = FactoryGirl.create(:user_access, :action => 'index', :resource => 'supplied_partx_parts', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "SuppliedPartx::Part.where(:void => false).order('created_at DESC')")
      ua1 = FactoryGirl.create(:user_access, :action => 'create', :resource => 'supplied_partx_parts', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'update', :resource => 'supplied_partx_parts', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'supplied_partx_parts', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "record.requested_by_id == session[:user_id]")
      user_access = FactoryGirl.create(:user_access, :action => 'create_part_supplied', :resource => 'commonx_logs', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'event_action', :resource => 'supplied_partx_parts', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'submit', :resource => 'supplied_partx_parts', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'list_open_process', :resource => 'supplied_partx_parts', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "SuppliedPartx::Part.where(:void => false).order('created_at DESC')")
      @pur_sta = FactoryGirl.create(:commonx_misc_definition, 'for_which' => 'part_purchasing_status')
      @cust = FactoryGirl.create(:kustomerx_customer) 
      @supplier = FactoryGirl.create(:supplierx_supplier)
      @proj = FactoryGirl.create(:heavy_machinery_projectx_project, :customer_id => @cust.id) 
      @mfg = FactoryGirl.create(:manufacturerx_manufacturer)
      
      visit '/'
      #save_and_open_page
      fill_in "login", :with => @u.login
      fill_in "password", :with => @u.password
      click_button 'Login'
    end
    it "works! (now write some real specs)" do
      task = FactoryGirl.create(:supplied_partx_part, :project_id => @proj.id, :supplier_id => @supplier.id, :manufacturer_id => @mfg.id)
      visit parts_path
      #save_and_open_page
      page.should have_content('Parts')
      click_link 'Edit'
      page.should have_content('Edit Part')
      #save_and_open_page
      visit parts_path
      click_link task.id.to_s
      #save_and_open_page
      page.should have_content('Part Info')
      click_link 'New Log'
      #save_and_open_page
      page.should have_content('Log')
      
      visit parts_path
      save_and_open_page
      click_link 'Submit'
      save_and_open_page
      fill_in 'part_wf_comment', :with => 'this line tests workflow'
      fill_in 'part_receiving_date', :with => '2014/01/01'
      #save_and_open_page
      click_button 'Save'
      #
      visit parts_path
      save_and_open_page
      click_link 'Open Process'
      page.should have_content('Parts')
      
      visit new_part_path(:project_id => @proj.id)
      #save_and_open_page
      page.should have_content('New Part')
      fill_in 'part_name', :with => 'test'
      fill_in 'part_qty', :with => 3
      fill_in 'part_spec', :with => 'spec'
      select('piece', :from => 'part_unit') 
      click_button 'Save'
    end
  end
end
