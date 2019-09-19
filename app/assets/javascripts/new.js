function toggleCart() {
  if($("#floating-cart").hasClass('active')) {
    $("#cart-details").html('Less')
    $("#floating-cart").find('.content').animate({width:'toggle'}, 51, function () {
      $("#floating-cart").find('.content *').css('opacity', 1);
    });
    $("#floating-cart").addClass('shadow-left')
  } else {
    $("#floating-cart").removeClass('shadow-left')
    $("#cart-details").html('Details')
    $("#floating-cart").find('.content').animate({width:'toggle'}, 10, function () {
      $("#floating-cart").find('.content *').css('opacity', 0);
    });
  }
}

function cartToggleHandler() {
  $("#floating-cart").toggleClass('active');
  toggleCart();
  // Now disable body scrolling on mobile
  if(window.innerWidth <= 768) {
    if($("#floating-cart").hasClass('active')) {
      $(document.body).css('overflow', 'hidden');
    }
    else {
      $(document.body).css('overflow', 'auto');
    }
  }
}
