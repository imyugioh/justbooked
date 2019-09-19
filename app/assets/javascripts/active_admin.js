// = require active_admin/base
// = require chosen-jquery
//= require activeadmin_reorderable
//= require active_admin_datetimepicker

jQuery(document).ready(function($) {
  $("#article_tag_list, #switch_user_identifier, #venue_user_id").chosen({
    max_selected_options: 5,
    width: "50%"
  });
});
