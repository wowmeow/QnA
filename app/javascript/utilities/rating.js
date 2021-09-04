$(document).on('turbolinks:load', function(){
  $('.vote').on('ajax:success', function(e) {
    let id = e.detail[0]['id'];
    let type = e.detail[0]['type'];
    let rating = e.detail[0]['rating'];

    $('#' + type + '_' + id).html(rating);
  })
})