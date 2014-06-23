// Cool header image scroll
$(window).scroll(function(e){
  if ($(window).width() > 800) {
    $('.header').css({
      'bottom' : -($(this).scrollTop()/3)+"px",
    }); 
    var thisdist = $(this).scrollTop();
    var headerheight = $(".header").outerHeight();
    $('.blog-info').css({
      'opacity' : (1)
    }); 
  } else {
    $('.header').css({'bottom' : 'auto'});  
    $('.blog-info').css({'opacity' : "1" });
  }
});