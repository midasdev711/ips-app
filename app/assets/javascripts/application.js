// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//= require jquery.readonly
//= require paloma
//= require autonumeric
//= require_tree .
//= require plyr
//= require owl.carousel

$(function(){
  Paloma.start();
  $(document).foundation();

  var vimeoPlayer;

  $(document).on("turbolinks:load", function() {
    vimeoPlayer = new Plyr('#player');
  });

  $(".owl-carousel").owlCarousel({
    loop: true,
    margin: 10,
    autoplay: true,
    autoplayTimeout: 5000,
    center: true,
    video: true,
  });

  // $(".owl-carousel .content-item").click(function () {
  //   var id = $(this).attr('id');
  //   console.log(id);
  //   var newVideoLink = "https://player.vimeo.com/video/" + id + "?loop=false&amp;byline=false&amp;portrait=false&amp;title=false&amp;speed=true&amp;transparent=0&amp;gesture=media";
  //   $(".plyr__video-embed iframe").attr("src", newVideoLink);
  //   if (vimeoPlayer) {
  //     vimeoPlayer.source = newVideoLink;
  //   }
  // });
  $(".videolist .content-item").click(function () {
    var id = $(this).attr('id');
    $(this).find('img').attr('style', 'border: 5px solid #E65100');
    console.log(id);
    var newVideoLink = "https://player.vimeo.com/video/" + id + "?loop=false&amp;byline=false&amp;portrait=false&amp;title=false&amp;speed=true&amp;transparent=0&amp;gesture=media&amp;autoplay=true";
    $(".plyr__video-embed iframe").attr("src", newVideoLink);
    if (vimeoPlayer) {
      vimeoPlayer.source = newVideoLink;
      vimeoPlayer.play();
      vimeoPlayer.on('ready', event => {
        vimeoPlayer.play();
      });
    }
  });
});
