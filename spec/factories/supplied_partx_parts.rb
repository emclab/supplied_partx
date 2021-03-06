# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :supplied_partx_part, :class => 'SuppliedPartx::Part' do
    name "MyString"
    part_num "MyString"
    spec "MyString"
    project_id 1
    qty 1
    unit "MyString"
    unit_price "9.99"
    supplier_id 1
    order_date "2013-10-31"
    receiving_date "2013-10-31"
    actual_receiving_date "2013-10-31"
    last_updated_by_id 1
    wfid "MyString"
    comment "MyText"
    state "MyString"
    purchasing_id 1
    requested_by_id 1
    received false
    void false
    customer_id 1
    status_id 1
  end
end
