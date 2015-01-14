// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//= require jquery-ui/datepicker
//= require ckeditor/init
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require turbolinks

$(document).ready( function(){
  $('.datepicker').datepicker();
});

document.observe("dom:loaded", function() {
    $$('object').each(function(obj){
        a  = document.createElement('param');
        a.name = 'wmode';
        a.value = 'transparent';
        obj.appendChild(a);
    });

    load_menu_from_plugins();
});

function onChangeRequest(obj, url){
  // var reg = /params/ng;
  // var new_url = url.replace(reg, obj.val);
  // console.log(new_url)
}