class CreateSuppliedPartxParts < ActiveRecord::Migration
  def change
    create_table :supplied_partx_parts do |t|
      t.string :name
      t.string :part_num
      t.text :part_spec
      t.integer :project_id
      t.integer :qty
      t.string :unit
      t.decimal :unit_price, :precision => 10, :scale => 2
      t.integer :purchasing_id
      t.integer :supplier_id
      t.date :order_date
      t.date :receiving_date
      t.boolean :received, :default => false
      t.integer :last_updated_by_id
      t.timestamps
      t.integer :requested_by_id
      t.date :actual_receiving_date
      t.string :wf_state
      t.boolean :void, :default => false
      t.integer :customer_id
      t.integer :status_id
      t.text :brief_note
      t.decimal :shipping_cost, :precision => 10, :scale => 2
      t.decimal :tax, :precision => 10, :scale => 2
      t.decimal :misc_cost, :precision => 10, :scale => 2
      t.decimal :total, :precision => 10, :scale => 2
      t.integer :manufacturer_id
      t.integer :purchase_order_id
      t.boolean :approved, :default => false
      t.date :approved_date
      t.integer :approved_by_id
      t.integer :received_by_id
      t.string :brand
      
    end
    
    add_index :supplied_partx_parts, :name
    add_index :supplied_partx_parts, :project_id
    add_index :supplied_partx_parts, :wf_state
    add_index :supplied_partx_parts, :supplier_id
    add_index :supplied_partx_parts, :purchasing_id
    add_index :supplied_partx_parts, :requested_by_id
    add_index :supplied_partx_parts, :void
    add_index :supplied_partx_parts, :part_spec
    add_index :supplied_partx_parts, :customer_id
    add_index :supplied_partx_parts, :received
    add_index :supplied_partx_parts, :status_id
    add_index :supplied_partx_parts, :purchase_order_id
    add_index :supplied_partx_parts, :approved
 
  end
end
