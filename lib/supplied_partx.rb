require "supplied_partx/engine"

module SuppliedPartx
  mattr_accessor :project_class, :supplier_class, :customer_class, :show_project_path, :show_customer_path, :show_supplier_path, :manufacturer_class
  
  def self.project_class
    @@project_class.constantize
  end
  
  def self.supplier_class
    @@supplier_class.constantize
  end
  
  def self.customer_class
    @@customer_class.constantize
  end
  
  def self.manufacturer_class
    @@manufacturer_class.constantize
  end
  
end
