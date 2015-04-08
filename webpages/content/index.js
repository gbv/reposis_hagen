           
$(document).ready( function() {
  $.ajax({
    method: "GET",
    url: "http://reposis-test.gbv.de/hagen/servlets/solr/find?qry=&rows=4&sort=created+desc&XSL.Transformer=response-resultlist",
    dataType: "html"
  }) .done(function( html ) {
    $('#hit_list').html(html);
    $('.hit_counter').html("&nbsp");
    $('.hit_options').html("&nbsp");
  });
});
			
