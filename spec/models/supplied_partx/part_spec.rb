require 'spec_helper'

module SuppliedPartx
  describe Part do
    it "should be OK" do
      c = FactoryGirl.build(:supplied_partx_part)
      c.should be_valid
    end
    
    it "should reject nil name" do
      c = FactoryGirl.build(:supplied_partx_part, :name => nil)
      c.should_not be_valid
    end
    
    it "should reject nil unit" do
      c = FactoryGirl.build(:supplied_partx_part, :unit => nil)
      c.should_not be_valid
    end
    
    it "should reject dup name" do
      c = FactoryGirl.create(:supplied_partx_part, :name => "nil")
      c1 = FactoryGirl.build(:supplied_partx_part, :name => "Nil", :project_id => c.project_id)
      c1.should_not be_valid
    end
    
    it "should reject 0 qty" do
      c = FactoryGirl.build(:supplied_partx_part, :qty => 0)
      c.should_not be_valid
    end
    
    it "should reject 0 project_id" do
      c = FactoryGirl.build(:supplied_partx_part, :project_id => 0)
      c.should_not be_valid
    end
    
    it "should reject nil status_id" do
      c = FactoryGirl.build(:supplied_partx_part, :status_id => nil)
      c.should_not be_valid
    end
    
    it "should reject 0 customer_id" do
      c = FactoryGirl.build(:supplied_partx_part, :customer_id => 0)
      c.should_not be_valid
    end
    
    it "should reject 0 requested_by_id" do
      c = FactoryGirl.build(:supplied_partx_part, :requested_by_id => 0)
      c.should_not be_valid
    end
  end
end
