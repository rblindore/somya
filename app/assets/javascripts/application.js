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

// This are the list of those js which listed in aaplication layout file.
//= require scripts/nicetitle
//= require droplicious
//= require builder
//= require modalbox
//= require fedena_plugin

$(document).on('ready dom:loaded', function(){
  $('.datepicker').datepicker({dateFormat: "dd/mm/yy"});

  $('object').each(function(obj){
    a = document.createElement('param');
    a.name = 'wmode';
    a.value = 'transparent';
    obj.appendChild(a);
  });

  // load_menuo_from_plugins();
});

function onChangeRequest(obj, url){
  if (obj.value != '' ){
    ajaxRequest(makeUrl(obj, url))
  }
}


function ajaxRequest(url){
  $.ajax({
    url: url,
    type: 'GET',
    dataType: 'script',
  });
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
  $('#' + eId).toggle();
}

function selectAll(class_name){
  $('div.' + class_name + ' > input').prop('checked', true)
}

function selectNone(class_name){
  $('div.' + class_name + ' > input').prop('checked', false)
}
