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
//= require jquery-ui
//= require turbolinks
//= require jquery-ui/datepicker
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
  var reg = /paramid/g;
    console.log(obj.value)
  if (obj.value != '' ){
    var new_url = url.replace(reg, obj.value);
    jQuery.ajax({
      url: new_url,
      type: 'GET',
      dataType: 'script',
    });
  }
}


$( document ).ajaxStart(function() {
  Element.show('loader');
});

$( document ).ajaxStop(function() {
  Element.hide('loader');
});

