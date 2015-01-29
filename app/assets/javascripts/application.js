// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui/datepicker
//= require jquery-ui/autocomplete
//= require ckeditor/init

// require_tree .

$(document).on('ready, dom:loaded', function(){
  $('.datepicker').datepicker();

  $('object').each(function(obj){
    a = document.createElement('param');
    a.name = 'wmode';
    a.value = 'transparent';
    obj.appendChild(a);
  });

  load_menu_from_plugins();
});

function onChangeRequest(obj, url){
  if (obj.value != '' ){
    jQuery.ajax({
      url: makeUrl(obj, url),
      type: 'GET',
      dataType: 'script',
    });
  }
}

function makeUrl(obj, url ){
  var reg = /paramid/g;
  return url.replace(reg, obj.value);
}

function redirectTo(obj, url){
  window.location.href = makeUrl(obj, url);
}


// $( document ).ajaxStart(function() {
//   Element.show('loader');
// });

// $( document ).ajaxStop(function() {
//   Element.hide('loader');
// });



function toggleEffect(eId){
  jQuery('#' + eId).toggle();
}