// instantiate the bloodhound suggestion engine
var titles = new Bloodhound({
  //datumTokenizer: Bloodhound.tokenizers.obj.whitespace,
  datumTokenizer: Bloodhound.tokenizers.obj.whitespace('mods.title[0]'),
  queryTokenizer: Bloodhound.tokenizers.whitespace,
  remote: {
	  url: '../servlets/solr/select?&q=%2Bmods.title%3A*%QUERY*+%2Bcategory.top%3A%22mir_genres\%3Aseries%22+%2BobjectType%3A%22mods%22&version=4.5&rows=1000&fl=mods.title%2Cid%2Cmods.identifier&wt=json',
	  filter: function(list) {
		return list.response.docs;
	  } 
  }
    
});
// initialize the bloodhound suggestion engine
titles.initialize();

var issns = new Bloodhound({
  //datumTokenizer: Bloodhound.tokenizers.obj.whitespace,
  datumTokenizer: Bloodhound.tokenizers.obj.whitespace('mods.title[0]'),
  queryTokenizer: Bloodhound.tokenizers.whitespace,
  remote: {
	  url: '../servlets/solr/select?&q=%2Bmods.identifier%3A*%QUERY*+%2Bcategory.top%3A%22mir_genres\%3Aseries%22+%2BobjectType%3A%22mods%22&version=4.5&rows=1000&fl=mods.title%2Cid%2Cmods.identifier&wt=json',
	  filter: function(list) {
		return list.response.docs;
	  } 
  }
    
});
issns.initialize();


$('#series-title').typeahead(
{
  items: 4,
  displayText: function(item) {
    return item['mods.title'][0] || item;
  },
  source:titles.ttAdapter()  
}); 

$('#series-issn').typeahead(
{
  items: 4,
  displayText: function(item) {
	issn = "";
	$.each(item['mods.identifier'],function (index,identifier) {
	  if (identifier.match(/(\d\d\d\d-\d\d\d[0-9xX])/g)!=null) {
		issn= identifier+' - '+item['mods.title'][0]; 
	    return false;
	  }
	});
    return issn;
  },
  source:issns.ttAdapter()  
});

$('#series-title').change(function() {
    var current = $('#series-title').typeahead("getActive");
    if (current) {
    	if (current['mods.title'][0]==$('#series-title').val()){
    	    $('#hostid').val(current.id);
    	    $('#series-title').val(current['mods.title'][0]);
    	    $('#series-title').prop('disabled', true );
    	    $('#series-issn').prop('disabled', true );
    	} else {
    		$('#hostid').val("");
    	}
    }
});

$('#series-issn').change(function() {
    var current = $('#series-issn').typeahead("getActive");
    if (current) {
    	issn="";
    	issnanz="";
    	$.each(current['mods.identifier'],function (index,identifier) {
    	  if (identifier.match(/(\d\d\d\d-\d\d\d[0-9xX])/g)!=null) {
    		issnanz= identifier+' - '+item['mods.title'][0]; 
    		issn= identifier;
    	    return false;
    	  }
    	});
    	if (issn==$('#series-issn').val()){
    	    $('#hostid').val(current.id);
    	    $('#series-issn').val(issn); 
    	  	$('#series-issn').prop('disabled', true );
    	    $('#series-title').prop('disabled', true );
    	} else {
    		$('#hostid').val("");
    	}
    }
});

$('.host-reset').click(function(event) {
  event.preventDefault();
  $('#series-title').val("");
  $('#series-issn').val("");
  $('#series-title').prop('disabled', false );
  $('#series-issn').prop('disabled', false );
});

