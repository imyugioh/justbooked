// Lockr cart_items --> from Hash into Array
'use strict';


// Global App vars
var App = {
  user_location: {lat: null, lng: null}
};

Lockr.prefix = 'JB';

var checkLockr = Lockr.get('cart_items');

if (checkLockr === undefined) {
  clearCart();
  console.log("init cart Lockr...");
} else {
  console.log("Lockr defined");
}


function clearCart() {
  Lockr.set('cart', {});  
  Lockr.set('cart_items', []);  
}

// React events ----------------------------------
// This is a custom event handler for adding a menu to the cart
window.JB_handleCartAddEvent = (e, chef_id, menu_id, menu_name, menu_img, max_delivery_distance, total, total_menus_count, special_instructions, addon_counts = {}, addon_info = {}, menu_items_counts = {}, menu_items_info = {}) => {
  var cartAddEvent = new CustomEvent('cart_add', {  
    detail: {
      dom_id: e.target.id, event: e, chef_id: chef_id, menu_id: menu_id, menu_name: menu_name, menu_img: menu_img, max_delivery_distance: max_delivery_distance, 
      total: total, total_menus_count: total_menus_count, special_instructions: special_instructions, addon_counts: addon_counts, addon_info: addon_info, menu_items_counts: menu_items_counts, menu_items_info: menu_items_info
    }
  });
  window.dispatchEvent(cartAddEvent);
}

// window.JB_handleCartRemoveEvent = (e, menu_id) => {                  
//   var cartRemoveEvent = new CustomEvent('cart_remove', {  
//     detail: {dom_id: e.target.id, event: e, menu_id: menu_id}
//   });
//   window.dispatchEvent(cartRemoveEvent);
// }

window.JB_gotGeocodeResult = (lat, lng, address) => {
  var geocodeEvent = new CustomEvent('location_found', {
      detail: {lat: lat, lng: lng, address: address}
  });

  Lockr.set('search_location', geocodeEvent.detail);  
  window.dispatchEvent(geocodeEvent);
}

window.GeoSetup = () => {
  var locationAutocomplete = $('.js-location-autocomplete');
  if (locationAutocomplete.length) {
    locationAutocomplete.geocomplete({
      country: 'CA',
      locality: 'ON'
    }).bind('geocode:result', function(e, result) {
      var lat = result.geometry.location.lat();
      var lng = result.geometry.location.lng();
      App.user_location.lat = lat;
      App.user_location.lng = lng;

      // console.log("got geocode result. lat: ", lat, " lng: ", lng, "  address: ", result.formatted_address);
      window.JB_gotGeocodeResult(lat, lng, result.formatted_address);
    });
  }

  $('.js-detect-location').click(function (e) {
    getLocation();
    $(this).addClass('is-loading');
  });
}

document.addEventListener('DOMContentLoaded', function () {

  $(window).on('load scroll resize', navbarHelper);


  $('.js-scrolltop').click(scrollTop);
  
  $('.js-rateyo-editable').rateYo({
    normalFill: '#a2a5aa',
    ratedFill: '#f21400',
    starWidth: '13px',
    rating: 5,
    spacing: '4px',
    starSvg: '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 53.97 52.02">' + '<path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z"></path>' + '</svg>'
  });
  $('.js-rateyo').rateYo({
    normalFill: '#a2a5aa',
    ratedFill: '#f21400',
    starWidth: '15px',
    rating: 5,
    spacing: '4px',
    readOnly: true,
    starSvg: '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 53.97 52.02">' + '<path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z"></path>' + '</svg>'
  });
  $('.js-truncate-text').each(function (idx, el) {
    var stringToTruncate = $(this).text();
    var trucatedString = trucateText(stringToTruncate);
    $(this).text(trucatedString);
  });
  $('.js-change-location').on('click', function () {
    $('.location-display').hide();
    $('.location-search').show();
  });
  $('.js-display-location').on('click', function () {
    $('.location-display').show();
    $('.location-search').hide();
  });

  $('[data-toggle="tooltip"]').tooltip();

  var sliderSelector = $('.js-bootstrap-slider');
  if (sliderSelector.length) {
    sliderSelector.slider({
      min: 0,
      max: 10,
      value: 5,
      tooltip: 'always',
      tooltip_position: 'bottom'
    });
    $('#capacity').on('shown.bs.dropdown', function () {
      sliderSelector.trigger('slide');
    });
  }

  var bookingDatePicker = $('.js-daterangepicker');
  if (bookingDatePicker.length) {
    bookingDatePicker.daterangepicker({
      parentEl: '.js-booking-date-parent',
      singleDatePicker: true,
      opens: 'center',
      drops: 'bottom',
      showDropdowns: false,
      autoApply: true,
      autoUpdateInput: false,
      format: 'MM/DD/YYYY',
      locale: {
        cancelLabel: 'Clear'
      }
    });
    bookingDatePicker.on('show.daterangepicker', function () {
      $('.js-booking-date-parent').addClass('show');
    });
    bookingDatePicker.on('hide.daterangepicker', function () {
      setTimeout(function () {
        $('.js-booking-date-parent').removeClass('show');
      }, 250);
    });
    $('#booking_date').on('click', function () {
      if (!$('.js-booking-date-parent').hasClass('show')) {
        $('.js-daterangepicker').data('daterangepicker').show();
      } else {
        $('.js-booking-date-parent').removeClass('show');
        $('.js-daterangepicker').data('daterangepicker').hide();
      }
    });
  }

  var calendarPicker = $('.js-calendar-picker');
  calendarPicker.daterangepicker({
    parentEl: '.calendar-picker',
    singleDatePicker: true,
    alwaysShowCalendars: true,
    showDropdowns: false,
    autoApply: true,
    autoUpdateInput: false,
    format: 'MM/DD/YYYY',
    locale: {
      cancelLabel: 'Clear'
    }
  });

  $('.calendar-modal').on('shown.bs.modal', function () {
    calendarPicker.data('daterangepicker').show();
  });

  $(document).on('click', '.filters .dropdown-menu', function (e) {
    e.stopPropagation();
  });

  $('.js-expand-text').click(function (e) {
    e.preventDefault();
    var extraText = $(this).parent().next('.js-extra-description');
    if (extraText.length) {
      $(this).hide();
      extraText.fadeIn();
    }
  });

  var welcomeModal = $('.welcome-modal');
  if (welcomeModal.length && $('body').hasClass('homepage')) {
    // welcomeModal.modal('show');
  }

  var inviteModal = $('.invite-modal');
  if (inviteModal.length && $('body').hasClass('chefs-flow-step-3')) {
    inviteModal.modal('show');
  }

  var restaurantFavorite = $('.js-fav-toggle');
  window.unsigned = true;
  if (restaurantFavorite.length && $('body').hasClass('listing')) {
    restaurantFavorite.click(function (e) {
      if (window.unsigned) {
        $('#signupModal').modal('show');
        e.preventDefault();
        return false;
      }
      $(this).toggleClass('is-active');
      e.preventDefault();
    });
  }

  // Allow Bootstrap dropdown menus to have forms/checkboxes inside,
  // and when clicking on a dropdown item, the menu doesn't disappear.
  // $(document).on('click', '.filters .dropdown-menu', function (e) {
  //   $(this).dropdown('toggle');
  // });

  $('.js-modal-root').on('shown.bs.modal', function (event) {
    var $this = $(this);
    var $modalContent = $this.find('.js-modal-slides');
    var $swiper = $this.find('.js-modal-swiper');
    var $swiperText = $this.find('.js-modal-swiper-text');
    var primaryCarousel, secondaryCarousel;
    primaryCarousel = new Swiper($swiper, {
      observer: true,
      observerParents: true,
      centeredSlides: true,
      spaceBetween: 30,
      autoHeight: true,
      keyboardControl: true,
      pagination: false
    });

    secondaryCarousel = new Swiper($swiper, {
      spaceBetween: 30,
      centeredSlides: true,
      slidesPerView: 'auto',
      touchRatio: 0.2,
      slideToClickedSlide: true,
      pagination: '.swiper-pagination',
      paginationType: 'fraction',
      nextButton: '.swiper-button-next',
      prevButton: '.swiper-button-prev'
    });
    primaryCarousel.params.control = secondaryCarousel;
    secondaryCarousel.params.control = primaryCarousel;
  });

  $('.js-item-slides').swiper({
    slidesPerView: 'auto',
    pagination: '.swiper-pagination',
    paginationClickable: true,
    shortSwipes: false
  });

  $('.js-add-checkbox').click(function () {
    $(this).parent().prepend('<div class="mb-2 js-checkbox d-flex flex-nowrap">' + '<input type="text" name="tags[cuisine_types][]" class="form-control form-control-sm" placeholder="" />' + '<button class="btn btn-sm btn-link btn-remove js-remove-checkbox ml-1" type="button">' + '<img src="/images/icons/remove.png" srcset="/images/icons/remove.png 1x, /images/icons/remove@2x.png 2x" alt="Remove" width="12">' + '</button>' + '</div>');
  });

  $('.js-add-cuisine-type-checkbox').click(function () {
    $(this).parent().prepend('<div class="mb-2 js-checkbox d-flex flex-nowrap">' + '<input type="text" name="tags[cuisine_types][]" class="form-control form-control-sm" placeholder="" />' + '<button class="btn btn-sm btn-link btn-remove js-remove-checkbox ml-1" type="button">' + '<img src="/images/icons/remove.png" srcset="/images/icons/remove.png 1x, /images/icons/remove@2x.png 2x" alt="Remove" width="12">' + '</button>' + '</div>');
  });

  $('.js-add-dietary-type-checkbox').click(function () {
    $(this).parent().prepend('<div class="mb-2 js-checkbox d-flex flex-nowrap">' + '<input type="text" name="tags[dietary_types][]" class="form-control form-control-sm" placeholder="" />' + '<button class="btn btn-sm btn-link btn-remove js-remove-checkbox ml-1" type="button">' + '<img src="/images/icons/remove.png" srcset="/images/icons/remove.png 1x, /images/icons/remove@2x.png 2x" alt="Remove" width="12">' + '</button>' + '</div>');
  });

  $('.js-add-order-selection-checkbox').click(function () {
    $(this).parent().prepend('<div class="mb-2 js-checkbox d-flex flex-nowrap">' + '<input type="text" name="menu_items[][name]" class="form-control form-control-sm" placeholder="Menu item name" style="width: 150px"/>&nbsp;&nbsp;<input type="text" name="menu_items[][price]" class="form-control form-control-sm" placeholder="$$" style="width: 60px"/>' + '<button class="btn btn-sm btn-link btn-remove js-remove-checkbox ml-1" type="button">' + '<img src="/images/icons/remove.png" srcset="/images/icons/remove.png 1x, /images/icons/remove@2x.png 2x" alt="Remove" width="12">' + '</button>' + '</div>');
  });

  $('.js-add-add-ons-checkbox').click(function () {
    $(this).parent().prepend('<div class="mb-2 js-checkbox d-flex flex-nowrap">' + '<input type="text" name="addons[][name]" class="form-control form-control-sm" placeholder="Addon name" style="width: 150px"/>&nbsp;&nbsp;<input type="text" name="addons[][price]" class="form-control form-control-sm" placeholder="$$" style="width: 60px"/>' + '<button class="btn btn-sm btn-link btn-remove js-remove-checkbox ml-1" type="button">' + '<img src="/images/icons/remove.png" srcset="/images/icons/remove.png 1x, /images/icons/remove@2x.png 2x" alt="Remove" width="12">' + '</button>' + '</div>');
  });

  var confirmEle;
  $('button[id^="js-remove-checkbox"]').click(function (e) {
    if ($(e.target).context.tagName === 'IMG')
      confirmEle = $(e.target).parent().parent().prev()
    else
      confirmEle = $(e.target).parent().prev()
    return false;
  });


  $('#confirm-btn-yes').click(function () {
    confirmEle.val('true')
    confirmEle.parent().css('display', 'none')
  });


  initQuantityInput('.js-quantity');

  $(document).on('click', '#carts_app', function (e) {
      this.closable = false;
      return false;
  });

  $('.cart-nr-circle').click(function (e) {
      e.preventDefault();
      $('.cart-icon').trigger('click');
  });


  $('#modalSigninLink').on('click', function () {
      $('#signupModal').modal('hide');

  });

  $('#signupModalLink').on('click', function () {
      $('#signinModal').modal('hide');

  });

  $('#chefSignupLink').on('click', function () {
      $('#signupModal').modal('show');
  });


  // Delete confirmation modals
  $('#delete-confirm').on('show', function() {
    var $submit = $(this).find('.btn-danger'),
        href = $submit.attr('href');
    $submit.attr('href', href.replace('pony', $(this).data('id')));
  });

  $('.delete-confirm').click(function(e) {
    e.preventDefault();
    $('#delete-confirm').data('id', $(this).data('id')).modal('show');
  });


  $('#require_chef_certification_close').click(function(e) {
    document.cookie = "require_chef_certification=DONE";
  });


  // setTimeout(function() {
  //   $(".alert").alert('close');
  // }, 2000);

  console.log('[jb] loaded...........');
});



function trucateText(str) {
  var text;
  if (str.length > 150) {
    text = str.substring(0, 150);
  } else {
    text = str;
  }
  return text;
}

function scrollTop() {
  $('body, html').stop().animate({
    scrollTop: 0
  });
}

function navbarHelper() {

  if ($('.navbar').length > 0) {
    if ($('.navbar').offset().top < 100) {
      $('.fixed-top').removeClass('navbar-shrink');
    } else {
      $('.fixed-top').addClass('navbar-shrink');
    }
  }
  if ($(window).width() < 768) {
    $('.navbar').on('show.bs.collapse', function () {
      if ($('.navbar').offset().top < 100) {
        $('.fixed-top').addClass('navbar-shrink');
      }
    }).on('hide.bs.collapse', function () {
      if ($('.navbar').offset().top < 100) {
        $('.fixed-top').removeClass('navbar-shrink');
      }
    });
  }
  if ($('body').hasClass('homepage')) {
    $('#navbarCollapse').on('show.bs.collapse', function () {
      $('.navbar-default').addClass('show');
    }).on('hide.bs.collapse', function () {
      $('.navbar-default').removeClass('show');
    });
  }
}

function initQuantityInput(selector) {
  var $selector = $(selector) || $('.js-quantity');
  if (!$selector.length) return false;
  var $quantityBtnDec = $('.js-quantity-minus');
  var $quantityBtnInc = $('.js-quantity-plus');

  $selector.find($quantityBtnDec).click(function (e) {
    var $input = $(this).closest('.js-quantity').find('input');
    var currentValue = $input.val();
    $input.val(Math.max(parseInt(currentValue) - 1, 0));
  });
  $selector.find($quantityBtnInc).click(function (e) {
    var $input = $(this).closest('.js-quantity').find('input');
    var currentValue = $input.val();
    $input.val(parseInt(currentValue) + 1);
  });
}

function getLocation() {
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(geoSuccess, geoError);
  } else {
    console.error('Geolocation is not supported by this browser.');
  }
}

function geoSuccess(position) {
  var lat = position.coords.latitude;
  var lng = position.coords.longitude;
  codeLatLng(lat, lng);
}

function geoError() {
  console.error('Geocoder failed.');
}

function codeLatLng(lat, lng) {
  var geocoder = new google.maps.Geocoder();
  var latlng = new google.maps.LatLng(lat, lng);
  var city;
  geocoder.geocode({
    'latLng': latlng
  }, function (results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      // callback to update input value
      console.log(results[0]);
      var formatted_address = results[0].formatted_address;

      window.App.user_location.location = formatted_address;
      window.App.user_location.lat = lat;
      window.App.user_location.lng = lng;

      window.JB_gotGeocodeResult(lat, lng, formatted_address);
      updateHeroLocationInput(formatted_address);
    } else {
      console.info('Geocoder failed due to: ' + status);
    }
  });
}

function updateHeroLocationInput(val) {
  $('.hero-form__input--location').val(val);
  $('.js-detect-location').removeClass('is-loading');

  return false;
}

