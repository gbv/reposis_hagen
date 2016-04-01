           
$(document).ready( function() {
  $.ajax({
    method: "GET",
    url: webApplicationBaseURL+"servlets/solr/find?qry=objectType:mods&rows=3&sort=created+desc&XSL.Transformer=response-resultlist",
    dataType: "html"
  }) .done(function( html ) {
    $('#hit_list').html(html);
    $('.hit_counter').html("&nbsp");
    $('.hit_options').html("&nbsp");
  });
});
			
