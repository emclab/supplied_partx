module SuppliedPartx
  require 'workflow'
  class Part < ActiveRecord::Base
    include Workflow
    workflow_column :wf_state
    
    workflow do
      wf = Authentify::AuthentifyUtility.find_config_const('part_wf_pdef', 'supplied_partx')
      if Authentify::AuthentifyUtility.find_config_const('wf_pdef_in_config') == 'true' && wf.present?
        eval(wf)
      elsif Rails.env.test?   
        state :initial_state do
          event :submit, :transitions_to => :entering_receiving_date
        end
        state :entering_receiving_date do
          event :enter_receiving_date, :transitions_to => :entering_purchasing_data
          event :checkout_from_warehouse, :transitions_to => :from_warehouse
        end
        state :entering_purchasing_data do
          event :enter_purchasing_data, :transitions_to => :manager_reviewing
        end
        state :manager_reviewing do
          event :manager_approve, :transitions_to => :ceo_reviewing
          event :manager_reject, :transitions_to => :entering_purchasing_data
        end
        state :ceo_reviewing do
          event :ceo_approve, :transitions_to => :approved
          event :ceo_reject, :transitions_to => :rejected
          event :ceo_rewind, :transitions_to => :initial_state
        end
        state :approved do
          event :stamp, :transitions_to => :stamped
        end
        state :stamped do
          event :receive_delivery, :transitions_to => :delivered
        end
        state :from_warehouse
        state :delivered
        state :rejected
      end
    end
    
    attr_accessor :supplier_name, :project_name, :void_nopudate, :received_noupdate, :customer_name, :requested_by_name, :purchasing_name, :status_name, :id_noupdate, :wf_comment,
                  :manufacturer_name, :purchase_order_id_noupdate, :approved_noupdate, :wf_state_noupdate, :wf_event
    attr_accessible :actual_receiving_date, :purchasing_id, :requested_by_id, :last_updated_by_id, :name, :order_date, :part_num, :project_id, :qty, :received, :manufacturer_id,
                    :receiving_date, :part_spec, :wf_state, :supplier_id, :unit, :unit_price, :void, :customer_id, :status_id, :shipping_cost, :tax, :total, :misc_cost,
                    :total, :brief_note, :purchase_order_id, :approved, :approved_date, :approved_by_id, :received_by_id, :brand,
                    :customer_name, :project_name, 
                    :as => :role_new
    attr_accessible :actual_receiving_date, :purchasing_id, :requested_by_id, :last_updated_by_id, :name, :order_date, :part_num, :project_id, :qty, :received, :manufacturer_id,
                    :receiving_date, :part_spec, :wf_state, :supplier_id, :unit, :unit_price, :void, :customer_id, :status_id, :shipping_cost, :tax, :total, :misc_cost, :brief_note,
                    :total, :void_nopudate, :received_noupdate, :customer_name, :requested_by_name, :purchasing_name, :status_name, :supplier_name, :wf_comment, :id_noupdate, :project_name,
                    :purchase_order_id, :purchase_order_id_noupdate, :approved, :approved_date, :wf_state_noupdate,  :approved_by_id, :received_by_id, :brand,
                    :as => :role_update

    attr_accessor   :project_id_s, :start_date_s, :end_date_s, :purchasing_id_s, :customer_id_s, :eng_id_s, :name_s, :part_spec_s, :part_num_s, :purchase_order_id_s,
                    :supplier_id_s, :delivered_s, :time_frame_s, :keyword_s, :status_id_s, :requested_by_id_s, :manufacturer_id_s, :approved_s

    attr_accessible :project_id_s, :start_date_s, :end_date_s, :purchasing_id_s, :customer_id_s, :eng_id_s, :status_id_s, :manufacturer_id_s, :approved_s,
                    :supplier_id_s, :delivered_s, :keyword_s, :requested_by_id_s, :name_s, :part_spec_s, :part_num_s, :as => :role_search_stats

    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :purchasing, :class_name => 'Authentify::User'
    belongs_to :requested_by, :class_name => 'Authentify::User'
    belongs_to :approved_by, :class_name => 'Authentify::User'
    belongs_to :received_by, :class_name => 'Authentify::User'
    belongs_to :status, :class_name => 'Commonx::MiscDefinition'
    belongs_to :project, :class_name => SuppliedPartx.project_class.to_s
    belongs_to :supplier, :class_name => SuppliedPartx.supplier_class.to_s
    belongs_to :customer, :class_name => SuppliedPartx.customer_class.to_s
    belongs_to :manufacturer, :class_name => SuppliedPartx.manufacturer_class.to_s
    belongs_to :purchase_order, :class_name => SuppliedPartx.purchase_order_class.to_s

    validates :name, :presence => true, :uniqueness => {:scope => :project_id, :case_sensitive => false, :message => I18n.t('Duplicate Product Name') }
    validates :project_id, :customer_id, :qty, :requested_by_id, :numericality => {:greater_than => 0, :only_integer => true}    
    validates :unit, :part_spec, :qty, :presence => true
    validates :unit_price, :numericality => { :greater_than => 0 }, :if => 'unit_price.present?'
    validates :total, :numericality => { :greater_than_or_equal_to => 0 }, :if => 'total.present?'
    validates :tax, :numericality => { :greater_than_or_equal_to => 0 }, :if => 'tax.present?'
    validates :misc_cost, :numericality => { :greater_than_or_equal_to => 0 }, :if => 'misc_cost.present?'
    validates :shipping_cost, :numericality => { :greater_than_or_equal_to => 0 }, :if => 'shipping_cost.present?'
    validates :manufacturer_id, :numericality => {:greater_than => 0, :only_integer => true}, :if => 'manufacturer_id.present?'
    validates :supplier_id, :numericality => {:greater_than => 0, :only_integer => true}, :if => 'supplier_id.present?'
    validates :approved_by_id, :numericality => {:greater_than => 0, :only_integer => true}, :if => 'approved_by_id.present?'
    validates :received_by_id, :numericality => {:greater_than => 0, :only_integer => true}, :if => 'received_by_id.present?'
    validate :dynamic_validate
    #for workflow input validation  
    validate :validate_wf_input_data, :if => 'wf_state.present?' 
    
    def validate_wf_input_data
      wf = Authentify::AuthentifyUtility.find_config_const('validate_part_' + self.wf_event, 'supplied_partx') if self.wf_event.present?
      if Authentify::AuthentifyUtility.find_config_const('wf_validate_in_config') == 'true' && wf.present? 
        eval(wf) 
      end
    end
    
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate', 'supplied_partx')
      eval(wf) if wf.present?
    end 
  end
end
