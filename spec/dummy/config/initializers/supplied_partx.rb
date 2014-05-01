SuppliedPartx.project_class = 'HeavyMachineryProjectx::Project'
SuppliedPartx.customer_class = 'Kustomerx::Customer'
SuppliedPartx.supplier_class = 'Supplierx::Supplier'
SuppliedPartx.manufacturer_class = 'Manufacturerx::Manufacturer'
SuppliedPartx.show_project_path = 'heavy_machinery_projectx.project_path(r.project_id)'
SuppliedPartx.show_customer_path = 'kustomerx.customer_path(r.customer_id)'
SuppliedPartx.show_supplier_path = 'supplierx.supplier_path(r.supplier_id)'
SuppliedPartx.index_payment_request_path = "payment_requestx.payment_requests_path(:resource_id => r.id, :resource_string => params[:controller], :project_id => r.project_id)"
SuppliedPartx.index_payment_request_supplied_partx_path = "payment_requestx.payment_requests_path(:resource_id => r.id, :resource_string => params[:controller], :project_id => r.project_id, :subaction => 'supplied_partx')"
SuppliedPartx.payment_request_resource = 'payment_requestx/payment_requests'
