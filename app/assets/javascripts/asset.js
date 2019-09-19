'use strict';

$(document).ready(function(){

  // disable auto discover
  Dropzone.autoDiscover = false;

  // We can render result into this dom id
  const resultDomID = $(".dropzone-modal").data('dropzone-result-dom-id');
  const hiddenValueDomID = $(".dropzone-modal").data('hidden-val-dom-id');

  $("#my-dropzone").dropzone({
    maxFilesize: 5,
    addRemoveLinks: true,
    paramName: 'asset[image]',
    success: function(file, response){
      // find the remove button link of the uploaded file and give it an id
      // based of the fileID response from the server


      var asset = $.parseJSON(response).asset


      $(file.previewTemplate).find('.dz-remove').attr('id', asset.id);
      // $(file.previewTemplate).find('.dz-remove').attr('token', response.asset.token);
      $(file.previewTemplate).find('.dz-remove').attr('delete_url', asset.delete_url);
      // add the dz-success class (the green tick sign)
      $(file.previewElement).addClass("dz-success");

      showUploadedImage(asset);
      manageAssetIDs('add', asset.id);
    },

    //when the remove button is clicked
    removedfile: function(file){
      // grab the id and token of the uploaded file we set earlier

      const id = $(file.previewTemplate).find('.dz-remove').attr('id');
      // const token = $(file.previewTemplate).find('.dz-remove').attr('token');
      const delete_url = $(file.previewTemplate).find('.dz-remove').attr('delete_url');

      // make a DELETE ajax request to delete the file
      $.ajax({
        type: 'DELETE',
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
        url: delete_url,
        success: function(data){
          // console.log(data.message);
          $(file.previewElement).remove();
          removeDeletedImage(id);
          manageAssetIDs('remove', id);
        }
      });
    }
  });

  function showUploadedImage(asset) {
    var tmpl = Mustache.to_html($('#uploaded_image_template').html(), asset);
    // console.log(tmpl);
    $(`#${resultDomID}`).append(tmpl);
  }

  function removeDeletedImage(id) {
    $(`#asset_${id}`).remove();
  }


  function manageAssetIDs(operation, id) {
    var dom_node = $(`#${hiddenValueDomID}`);
    var dom_values = dom_node.val();
    var current_values = [];


    if (dom_values) {
      current_values = dom_values.split(',');

      // remove empty element
      current_values = $.map( current_values, function(v){ return v === "" ? null : v});
    }

    var set = new Set(current_values);

    if (operation === 'add') {
      set.add(id);
    } else {
      set.delete(id);
    }

    var v = Array.from(set).join(',');
    dom_node.val(v)
  }


});