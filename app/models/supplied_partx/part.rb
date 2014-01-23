module SuppliedPartx
  require 'workflow'
  class Part < ActiveRecord::Base
    include Workflow
    workflow_column :wf_state
    
    workflow do
      wf = Authentify::AuthentifyUtility.find_config_const('part_wf_pdef', 'supplied_partx')
      if Authentify::AuthentifyUtility.find_config_const('wf_pdef_in_config') == 'true' && wf.present?
        eval(wf) if wf.present? && self.wf_state.present 
      else   
        state :fresh do
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
          event :ceo_rewind, :transitions_to => :fresh
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
    
    attr_accessor :supplier_name, :project_name, :void_nopudate, :received_noupdate, :customer_name, :requested_by_name, :purchasing_name, :status_name, :id_noupdate, :wf_comment
    attr_accessible :actual_receiving_date, :purchasing_id, :requested_by_id, :last_updated_by_id, :name, :order_date, :part_num, :project_id, :qty, :received,
                    :receiving_date, :spec, :wf_state, :supplier_id, :unit, :unit_price, :void, :wfid, :customer_id, :status_id, :shipping_cost, :tax, :total, :misc_cost,
                    :total, :brief_note,
                    :as => :role_new
    attr_accessible :actual_receiving_date, :purchasing_id, :requested_by_id, :last_updated_by_id, :name, :order_date, :part_num, :project_id, :qty, :received,
                    :receiving_date, :spec, :wf_state, :supplier_id, :unit, :unit_price, :void, :wfid, :customer_id, :status_id, :shipping_cost, :tax, :total, :misc_cost, :brief_note,
                    :total, :void_nopudate, :received_noupdate, :customer_name, :requested_by_name, :purchasing_name, :status_name, :supplier_name, :wf_comment, :id_noupdate,
                    :as => :role_update

    attr_accessor   :project_id_s, :start_date_s, :end_date_s, :purchasing_id_s, :customer_id_s, :eng_id_s,
                    :supplier_id_s, :delivered_s, :time_frame_s, :keyword_s, :status_id_s, :requested_by_id_s

    attr_accessible :project_id_s, :start_date_s, :end_date_s, :purchasing_id_s, :customer_id_s, :eng_id_s, :status_id_s,
                    :supplier_id_s, :delivered_s, :keyword_s, :requested_by_id_s, :as => :role_search_stats

    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :purchasing, :class_name => 'Authentify::User'
    belongs_to :requested_by, :class_name => 'Authentify::User'
    belongs_to :status, :class_name => 'Commonx::MiscDefinition'
    belongs_to :project, :class_name => SuppliedPartx.project_class.to_s
    belongs_to :supplier, :class_name => SuppliedPartx.supplier_class.to_s
    belongs_to :customer, :class_name => SuppliedPartx.customer_class.to_s

    validates :name, :presence => true, :uniqueness => {:scope => :project_id, :case_sensitive => false, :message => I18n.t('Duplicate Product Name') }
    validates_numericality_of :project_id, :customer_id, :qty, :requested_by_id, :greater_than => 0, :only_integer => true    
    validates :unit, :spec, :presence => true
    validates :unit_price, :presence => true, :numericality => { :greater_than => 0 }, :if => 'unit_price.present?'
    validates :total, :presence => true, :numericality => { :greater_than => 0 }, :if => 'total.present?'
    
    #for workflow input validation  
    validate :validate_wf_input_data, :if => 'wf_state.present?' 
    
    def validate_wf_input_data
      wf = Authentify::AuthentifyUtility.find_config_const('validate_part_' + self.wf_state, 'supplied_partx')
      if Authentify::AuthentifyUtility.find_config_const('wf_validate_in_config') == 'true' && wf.present? 
        eval(wf) if wf.present?
      else
        #validate code here
        case wf_state
        when 'submit'
        when 'receiving_date_entered'
          validates :receiving_date, :presence => true
        when 'price_order_receiving_date_entered'
          validates :unit_price, :actual_receiving_date, :order_date, :presence => true
        else
        end
      end
    end
  end
end
