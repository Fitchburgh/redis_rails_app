// $(document).ready(function () {
//   $("a.genre").colorbox({
//     rel: 'genre',
//     dataType: 'jsonp',
//     transition: "elastic",
//     width: "75%",
//     height: "75%",
//     previous: "<",
//     next: ">",
//   })
// })
$('body').animate({
  scrollTop: target.offset().top
}, 1000);

$('.container-all').fadeOut('slow', function(){
    $('.container-all').load(link+' #content', function(){
        $('.container-all').fadeIn('slow');
    });
});
