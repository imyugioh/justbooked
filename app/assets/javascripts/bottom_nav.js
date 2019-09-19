// JavaScript Document
	$('a[href*="#"]')
  // Remove links that don't actually link to anything
  .not('[href="#"]')
  .not('[href="#0"]')
  .click(function(event) {
		event.preventDefault();
    if (
      location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '') 
      && 
      location.hostname == this.hostname
    ) {
      // Figure out element to scroll to
      var target = $(this.hash);
      target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');
      // Does a scroll target exist?
      if (target.length) {
		  
        event.preventDefault();
        $('html, body').animate({
          scrollTop: target.offset().top
        }, 600, function() {
          // Callback after animation
          // Must change focus!
          var $target = $(target);
          $target.focus();
          if ($target.is(":focus")) { // Checking if the target was focused
            return false;
          } else {
            $target.attr('tabindex','-1'); // Adding tabindex for elements not focusable
            $target.focus(); // Set focus again
          };
        });
      }
    }
  });


// Cache selectors
var lastId = undefined;

window.onscroll = function() {stickyNav()};

function stickyNav() {
  var navbar = document.getElementById("filtersNav");
  if(!navbar) return;
  
  if (window.pageYOffset >= 100) {
    navbar.classList.add("sticky")
  } else {
    navbar.classList.remove("sticky");
  }

  // change menu category color into red
  var 
    topMenu = $("#top-menu"),
    topMenuHeight = topMenu.outerHeight()+15,
    // All list items
    menuItems = topMenu.find("a"),
    // Anchors corresponding to menu items
    scrollItems = menuItems.map(function(){
      var item = $($(this).attr("href"));
      if (item.length) { return item; }
    });
  // Get container scroll position
  var fromTop = $(window).scrollTop() + topMenuHeight;
   
  // Get id of current scroll item
  var cur = scrollItems.map(function(){
    if ($(this).offset().top < fromTop)
      return this;
  });
  // Get the id of the current element
  cur = cur[cur.length - 1];
  var id = cur && cur.length ? cur[0].id : "";
  if (lastId !== id) {
    lastId = id;
    // Set/remove active class
    menuItems
      .parent().removeClass("active")
      .end().filter("[href='#"+id+"']").parent().addClass("active");
  }


  // cart view mobile popup only when pageYOffset >= 100
  if (window.innerWidth <= 768 && window.pageYOffset >= 100) {
    // get bottom nav height
    $("#floating-cart > .summary").addClass("sticky");
    $("#floating-cart > .summary").css('bottom', (navbar.offsetHeight + 2) + 'px');
  }
  else {
    $("#floating-cart > .summary").removeClass("sticky");
  }
}
