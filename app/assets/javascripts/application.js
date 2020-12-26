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
  var watched = localStorage.getItem('watched');
  watched = watched ? JSON.parse(watched) : [];
  $(".videolist .content-item").each(function(index) {
    var id = $(this).attr('id');
    if (watched.indexOf(id) > -1) {
      $(this).find('img').attr('style', 'border: 5px solid #E65100');
    }
  });

  $(".videolist .content-item").click(function () {
    var id = $(this).attr('id');
    var watched = localStorage.getItem('watched');
    watched = watched ? JSON.parse(watched) : [];
    if (watched.indexOf(id) == -1) {
      watched.push(id);
    }
    localStorage.setItem('watched', JSON.stringify(watched));
    $(this).find('img').attr('style', 'border: 5px solid #E65100');
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
