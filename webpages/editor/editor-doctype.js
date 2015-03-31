  
var GenreXML;

function changeHostOptions(){
	var id = $( '#genre option:selected' )[0].value;
	var hosts = $($(GenreXML).find('[ID="'+id+'"]')[0]).children('label[xml\\:lang="x-hosts"]').attr('text');
	$( '#host').empty();
	$.each(hosts.split(' '),function (ind,val) {
		if (val=='standalone') {
			$('#host').prepend('<option value="standalone" selected="selected" >(bitte ggf. auswählen)</option>');
		} else {
			text = $($(GenreXML).find('[ID="'+val+'"]')[0]).children('label[xml\\:lang="de"]').attr('text');
			$('#host').append('<option value="'+val+'">'+text+'</option>');
		}
	})
}


        
function createGenreOptions() {
  var Options="";
  $(GenreXML).find('categories > category').each(function(){
    var Title = $(this).children('label[xml\\:lang="de"]').attr('text');
    var id = $(this).attr('ID');
    Options+='<option value="'+id+'">' + Title + '</option>';
    $(this).find('category').each(function(){
      var Title = $(this).children('label[xml\\:lang="de"]').attr('text');
      var id = $(this).attr('ID');
      Options+='<option value="'+id+'">&nbsp;&nbsp;&nbsp;' + Title + '</option>';
    });
  });
  $('#genre').append(Options);
}
  
$(document).ready( function() {
  $('#genre').change(function (){changeHostOptions();});
  $.ajax({
    method: "GET",
    url: "http://reposis-test.gbv.de/hagen/api/v1/classifications/mir_genres",
    dataType: "xml"
  }) .done(function( xml ) {
    GenreXML=xml;
    createGenreOptions();
    changeHostOptions();
  });
});