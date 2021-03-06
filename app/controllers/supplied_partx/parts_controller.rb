require_dependency "supplied_partx/application_controller"

module SuppliedPartx
  class PartsController < ApplicationController
    before_filter :require_employee
    before_filter :load_parent_record
        
    def index
      @title = t('Parts')
      @parts = params[:supplied_partx_parts][:model_ar_r]  #returned by check_access_right
      @parts = @parts.where(:customer_id => @customer.id) if @customer
      @parts = @parts.where(:project_id => @project.id) if @project       
      @parts = @parts.page(params[:page]).per_page(@max_pagination) 
      @erb_code = find_config_const('part_index_view', 'supplied_partx_parts')
    end
  
    def new
      @title = t('New Part')
      @part = SuppliedPartx::Part.new()
      @qty_unit = find_config_const('piece_unit').split(',').map(&:strip)
      @erb_code = find_config_const('part_new_view', 'supplied_partx_parts')
    end
  
    def create
      @part = SuppliedPartx::Part.new(params[:part], :as => :role_new)
      @part.last_updated_by_id = session[:user_id]
      @part.customer_id = @customer.id if @customer
      @part.customer_id = SuppliedPartx.project_class.find_by_id(@project.id).customer.id unless @customer
      @part.project_id = @project.id
      @part.requested_by_id = session[:user_id]
      if @part.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        flash[:notice] = t('Data Error. Not Saved!')
        render 'new'
      end
    end
  
    def edit
      @title = t('Update Part')
      @part = SuppliedPartx::Part.find_by_id(params[:id])
      @qty_unit = find_config_const('piece_unit').split(',').map(&:strip)
      @erb_code = find_config_const('part_edit_view', 'supplied_partx_parts')
    end
  
    def update
      @part = SuppliedPartx::Part.find_by_id(params[:id])
      @part.last_updated_by_id = session[:user_id]
      if @part.update_attributes(params[:part], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      else
        flash[:notice] = t('Data Error. Not Updated!')
        render 'edit'
      end
    end
  
    def show
      @title = t('Part Info')
      @part = SuppliedPartx::Part.find_by_id(params[:id])
      @erb_code = find_config_const('part_show_view', 'supplied_partx_parts')
    end
    
    protected
    def load_parent_record
      @customer = SuppliedPartx.customer_class.find_by_id(params[:customer_id]) if params[:customer_id].present?
      @project = SuppliedPartx.project_class.find_by_id(params[:project_id]) if params[:project_id].present?
      @customer = SuppliedPartx.customer_class.find_by_id(@project.customer_id) if params[:project_id].present?
      @project = SuppliedPartx.project_class.find_by_id(SuppliedPartx::Part.find_by_id(params[:id]).project_id) if params[:id].present?
      @customer = SuppliedPartx.customer_class.find_by_id(SuppliedPartx::Part.find_by_id(params[:id]).customer_id) if params[:id].present?
    end
  end
end
