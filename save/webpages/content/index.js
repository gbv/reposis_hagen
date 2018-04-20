           
$(document).ready( function() {
  $.ajax({
    method: "GET",
    url: webApplicationBaseURL+"servlets/solr/find?qry=objectType:mods&rows=3&sort=created+desc",
    dataType: "html"
  }) .done(function( html ) {
    var hitListHtml=$(html).find('#hit_list').html();
    $('#hit_list').html(hitListHtml);
    $('.hit_counter').html("&nbsp");
    $('.hit_options').html("&nbsp");
  });
});
			
