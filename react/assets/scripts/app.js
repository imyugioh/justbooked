'use strict';

var Mapbox = new function (container, geojson, props) {
  var markers = [];
  var gmarkers = [];
  var map;

  this.init = function (container, geojson, props) {
    var toronto = {
      lat: 43.6525165,
      lng: -79.3864094
    };
    if (geojson.features.length) {}
    map = new google.maps.Map(document.getElementById(container), {
      zoom: 11,
      center: toronto,
      mapTypeId: 'terrain'
    });
    window[container] = map;

    var infowindow = new google.maps.InfoWindow({
      maxWidth: 240,
      pixelOffset: new google.maps.Size(30, 40)
    });

    var props = {
      infowindow: infowindow
    };

    Mapbox.addMarkers(map, geojson, props);
    return this;
  };

  this.createPopup = function (feature) {
    var v = feature.properties;
    var popupContent = $('<div class="venue" />');
    var venueImage = $('<a>').addClass('venue-image').attr('href', '#').css('background-image', 'url(' + v.image + ')');
    if ($(window).width() > 768) {
      venueImage.appendTo(popupContent);
    }
    var venueFooter = $('<div>').addClass('venue-footer').appendTo(popupContent);
    var venueName = $('<div>').addClass('venue-name').text(v.name).appendTo(venueFooter);
    var venueRating = $('<div>').addClass('venue-rating').data('rating-value', v.rating);
    var venuePrice = $('<div>').addClass('venue-price').text('$' + v.price).appendTo(venueFooter);

    venueRating.appendTo(venueFooter);
    venueRating.rateYo({
      rating: v.rating,
      readOnly: true,
      normalFill: '#a2a5aa',
      ratedFill: '#f21400',
      starWidth: '13px',
      spacing: '4px',
      starSvg: '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 53.97 52.02">' + '<path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z"></path>' + '</svg>'
    });

    return popupContent.html();
  };

  this.addMarkers = function (map, geojson, props) {
    // Create markers.
    geojson.features.forEach(function (feature) {
      var image = '../images/icons/marker-icon.png';
      var marker = new google.maps.Marker({
        position: {
          lat: feature.geometry.coordinates[1],
          lng: feature.geometry.coordinates[0]
        },
        icon: image,
        map: map,
        category: feature.properties.category,
        label: '$' + feature.properties.price
      });

      markers.push(marker);

      var html_content = Mapbox.createPopup(feature);
      var infowindow = props['infowindow'];
      marker.addListener('click', function () {
        infowindow.setContent(html_content);
        infowindow.open(map, marker);
      });

      google.maps.event.addListener(map, 'click', function () {
        infowindow.close();
      });

      google.maps.event.addListener(infowindow, 'domready', function () {
        // Reference to the DIV which receives the contents of the infowindow using jQuery
        var iwOuter = $('.gm-style-iw');
        /* The DIV we want to change is above the .gm-style-iw DIV.
         * So, we use jQuery and create a iwBackground variable,
         * and took advantage of the existing reference to .gm-style-iw for the previous DIV with .prev().
         */
        var iwBackground = iwOuter.prev();
        // Remove transparent arrow
        iwBackground.children(':nth-child(1)').css({
          'display': 'none'
        });
        // Remove the background shadow DIV
        iwBackground.children(':nth-child(2)').css({
          'display': 'none'
        });
        // Remove close button
        iwBackground.children(':nth-child(3)').css({
          'display': 'none'
        });
        // Remove the white background DIV
        iwBackground.children(':nth-child(4)').css({
          'display': 'none'
        });
        iwBackground.children('img').css({
          'display': 'none'
        });
        iwBackground.siblings().prev().hide();
      });
    });
  };
}();

'use strict';

document.addEventListener('DOMContentLoaded', function () {
  $(window).on('load scroll resize', navbarHelper);

  $('.js-scrolltop').click(scrollTop);
  $('.js-mapview').click(function (e) {
    e.preventDefault();
    $('.js-listview').removeClass('active');
    $('.js-venues').addClass('show');
    $(this).addClass('active');
  });
  $('.js-listview').click(function (e) {
    e.preventDefault();
    $('.js-mapview').removeClass('active');
    $(this).addClass('active');
    $('.js-venues').removeClass('show');
  });
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

  var deliveryDatePicker = $('.js-order-date-picker');
  if (deliveryDatePicker.length) {
    deliveryDatePicker.daterangepicker({
      singleDatePicker: true,
      opens: 'center',
      drops: 'bottom',
      showDropdowns: false,
      autoApply: true,
      autoUpdateInput: true,
      format: 'MM/DD/YYYY',
      locale: {
        cancelLabel: 'Clear'
      }
    });
  }

  var deliveryTimePicker = $('.js-order-time-picker');
  if (deliveryTimePicker.length) {
    deliveryTimePicker.pickatime();
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

  var locationAutocomplete = $('.js-location-autocomplete');
  if (locationAutocomplete.length) {
    locationAutocomplete.geocomplete();
  }

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
  $(document).on('click', '.filters .dropdown-menu', function (e) {
    var $this = $(this);
    if ($this.data('option-array-index') == 0) {
      $('.listview .restaurant-grid-item').fadeIn();
    } else {
      $('.listview .restaurant-grid-item:even').fadeOut('slow');
    }
  });

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
    $(this).parent().prepend('<div class="mb-2 js-checkbox d-flex flex-nowrap">' + '<input type="text" class="form-control form-control-sm" placeholder="" />' + '<button class="btn btn-sm btn-link btn-remove js-remove-checkbox ml-1" type="button">' + '<img src="images/icons/remove.png" srcset="images/icons/remove.png 1x, images/icons/remove@2x.png 2x" alt="Remove" width="12">' + '</button>' + '</div>');
  });

  $('body').on('click', '.js-remove-checkbox', function () {
    $(this).closest('.js-checkbox').remove();
  });

  initQuantityInput('.js-quantity');

  $(document).on('click', '.cart-dropdown-menu', function (e) {
    e.stopPropagation();
  });

  $('.js-detect-location').click(function (e) {
    getLocation();
    $(this).addClass('is-loading');
  });

  $('.js-form-send-invites').on('submit', function (e) {
    $('#inviteModal').modal('hide');
    $('#invite-success-modal').modal('show');
    return false;
  });

  console.log('[jbs] loaded');
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
  'use strict';

  if ($('.navbar').offset().top < 100) {
    $('.fixed-top').removeClass('navbar-shrink');
  } else {
    $('.fixed-top').addClass('navbar-shrink');
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
    $input.val(parseInt(currentValue) - 1);
  });
  $selector.find($quantityBtnInc).click(function (e) {
    var $input = $(this).closest('.js-quantity').find('input');
    var currentValue = $input.val();
    $input.val(parseInt(currentValue) + 1);
  });
  console.log('[jb] quanitity inited');
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
  console.log(lat, lng);
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
      updateHeroLocationInput(results[0].formatted_address);
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
