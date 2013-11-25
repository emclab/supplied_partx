// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
	$("#part_order_date").datepicker({dateFormat: 'yy-mm-dd'});
	$("#part_receiving_date").datepicker({dateFormat: 'yy-mm-dd'});
    $("#part_actual_receiving_date").datepicker({dateFormat: 'yy-mm-dd'});
    $("#part_start_date_s").datepicker({dateFormat: 'yy-mm-dd'});
    $("#part_end_date_s").datepicker({dateFormat: 'yy-mm-dd'});
});

//for calculating total
$(function(){
    $("#part_qty").change(function(){
    	rpt = ($("#part_qty").val() * $("#part_unit_price").val()).toFixed(2);
    	//alert(rpt);
    	if ($.isNumeric(rpt) && rpt > 0){
    		//alert($.isNumeric(rpt));
    		$("#part_total").val(rpt);
    	} else {
    		$("#part_total").val("");
    	}
    });
});
$(function(){
    $("#part_unit_price").change(function(){
    	rpt = ($("#part_qty").val() * $("#part_unit_price").val()).toFixed(2);
    	if ($.isNumeric(rpt) && rpt > 0){
    	    //alert(rpt);
    		$("#part_total").val(rpt);
    	} else {
    		//alert(rpt);
    		$("#part_total").val("");
    	}  	
    });
});