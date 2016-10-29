
$('body').animate({
  scrollTop: target.offset().top
}, 1000);


$('.container-all').fadeOut('slow', function(){
    $('.container-all').load(link+' #content', function(){
        $('.container-all').fadeIn('slow');
    });
});
