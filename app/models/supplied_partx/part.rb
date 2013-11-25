module SuppliedPartx
  class Part < ActiveRecord::Base
    attr_accessor :supplier_name, :project_name, :void_nopudate, :received_noupdate, :customer_name, :requested_by_name, :purchasing_name, :status_name
    attr_accessible :actual_receiving_date, :comment, :purchasing_id, :requested_by_id, :last_updated_by_id, :name, :order_date, :part_num, :project_id, :qty, :received,
                    :receiving_date, :spec, :state, :supplier_id, :unit, :unit_price, :void, :wfid, :customer_id, :status_id, :shipping_cost, :tax, :total, :misc_cost,
                    :total, :brief_note,
                    :as => :role_new
    attr_accessible :actual_receiving_date, :comment, :purchasing_id, :requested_by_id, :last_updated_by_id, :name, :order_date, :part_num, :project_id, :qty, :received,
                    :receiving_date, :spec, :state, :supplier_id, :unit, :unit_price, :void, :wfid, :customer_id, :status_id, :shipping_cost, :tax, :total, :misc_cost, :brief_note,
                    :total, :void_nopudate, :received_noupdate, :customer_name,
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
    validates_numericality_of :project_id, :customer_id, :qty, :status_id, :requested_by_id, :greater_than => 0, :only_integer => true    
    validates :unit_price, :total, :numericality => { :greater_than => 0 }
    validates :unit, :spec, :presence => true
    
  end
end
