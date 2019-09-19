$(document).ready(function(){

  $( ".button_to" ).submit(function( event ) {
    event.preventDefault();
    jQuery('#payment-buttons').showLoading();

    $("#payment-buttons :input").attr("disabled", true);
    setTimeout(function() { enableSubmit() }, 15000);

    var success_message = "Order was successfully accepted";
    var fail_message = "Failed. Please try it again";

    var actionurl = event.currentTarget.action;
    if (actionurl.endsWith("request_status=Declined")) {
      success_message = "Order was successfully declined";
    }

    $.ajax({
      url: actionurl,
      type:'PUT',
      success:function(result){
        jQuery('#payment-buttons').hideLoading();
        jQuery('#payment-buttons').hide();
        alert(success_message);
        document.location.href='/orders';
      },
      error: function(xhr, status, error) {
        jQuery('#payment-buttons').hideLoading();
        enableSubmit();
        alert(fail_message);
      }      
    });    
  });
});

var enableSubmit = function(ele) {
  $("#payment-buttons :input").removeAttr("disabled");
  jQuery('#payment-buttons').hideLoading();
}