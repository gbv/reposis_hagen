
var engines = {
		shelfmark: {
			engine:new Bloodhound({
				//datumTokenizer: Bloodhound.tokenizers.obj.whitespace,
				datumTokenizer: Bloodhound.tokenizers.obj.whitespace('mods.title[0]'),
				queryTokenizer: Bloodhound.tokenizers.whitespace,
				remote: {
					url: '../servlets/solr/select',
					filter: function(list) {
						return list.response.docs;
					},
					replace : function (url, query) {
						param="?&q=%2BshelfLocator%3A"+query+"*";
						param+="+%2Bcategory.top%3A%22mir_genres\%3A"+$(document.activeElement).data("genre")+"%22";
						param+="+%2BobjectType%3A%22mods%22";
			    		param+="&fl=mods.title%2Cid%2CshelfLocator";
			    		param+="&version=4.5&rows=1000&wt=json";
			    		return url+param;
					}
				}
			}),
			displayText: function(item) {
				return item['shelfLocator']+' - '+item['mods.title'][0] || item; 
			}
		},
		isbn: {
			engine:new Bloodhound({
				//datumTokenizer: Bloodhound.tokenizers.obj.whitespace,
				datumTokenizer: Bloodhound.tokenizers.obj.whitespace('mods.title[0]'),
				queryTokenizer: Bloodhound.tokenizers.whitespace,
				remote: {
					url: '../servlets/solr/select',
					filter: function(list) {
						return list.response.docs;
					},
					replace : function (url, query) {
						param="?&q=%2Bidentifier.type.isbn%3A"+query+"*";
						param+="+%2Bcategory.top%3A%22mir_genres\%3A"+$(document.activeElement).data("genre")+"%22";
						param+="+%2BobjectType%3A%22mods%22";
			    		param+="&fl=mods.title%2Cid%2Cidentifier.type.isbn";
			    		param+="&version=4.5&rows=1000&wt=json";
			    		return url+param;
					}
				}
			}),
			displayText: function(item) {
				return item['identifier.type.isbn']+' - '+item['mods.title'][0] || item; 
			}
		},
		issn: {
			engine:new Bloodhound({
				//datumTokenizer: Bloodhound.tokenizers.obj.whitespace,
				datumTokenizer: Bloodhound.tokenizers.obj.whitespace('mods.title[0]'),
				queryTokenizer: Bloodhound.tokenizers.whitespace,
				remote: {
					url: '../servlets/solr/select',
					filter: function(list) {
						return list.response.docs;
					},
					replace : function (url, query) {
						param="?&q=%2Bidentifier.type.issn%3A"+query+"*";
						param+="+%2Bcategory.top%3A%22mir_genres\%3A"+$(document.activeElement).data("genre")+"%22";
						param+="+%2BobjectType%3A%22mods%22";
			    		param+="&fl=mods.title%2Cid%2Cidentifier.type.issn";
			    		param+="&version=4.5&rows=1000&wt=json";
			    		return url+param;
					}
				}
			}),
			displayText: function(item) {
				return item['identifier.type.issn']+' - '+item['mods.title'][0] || item; 
			}
		},
		title: {
			engine: new Bloodhound({
			    //datumTokenizer: Bloodhound.tokenizers.obj.whitespace,
				datumTokenizer: Bloodhound.tokenizers.obj.whitespace('mods.title[0]'),
				queryTokenizer: Bloodhound.tokenizers.whitespace,
				remote: {
					url: '../servlets/solr/select',
					filter: function(list) {
						return list.response.docs;
					},
					replace : function (url, query) {
						param="?&q=%2Bmods.title%3A*"+query+"*";
						param+="+%2Bcategory.top%3A%22mir_genres\%3A"+$(document.activeElement).data("genre")+"%22";
						param+="+%2BobjectType%3A%22mods%22";
			    		param+="&fl=mods.title%2Cid";
			    		param+="&version=4.5&rows=1000&wt=json";
			    		return url+param;
					}
				}
			}),
			displayText: function(item) {
				return item['mods.title'][0] || item;
			}
		},
	    empty:  {
			engine: new Bloodhound({
				//datumTokenizer: Bloodhound.tokenizers.obj.whitespace,
				datumTokenizer: Bloodhound.tokenizers.obj.whitespace('mods.title[0]'),
				queryTokenizer: Bloodhound.tokenizers.whitespace,
				remote: {
					url: '../servlets/solr/select?&q=%2Bmods.title%3A*%QUERY*+%2Bcategory.top%3A%22mir_genres\%3Aseries%22+%2BobjectType%3A%22mods%22&version=4.5&rows=1000&fl=mods.title%2Cid%2Cmods.identifier&wt=json',
					filter: function(list) {
						return {};
					} 
				}
			}),
			displayText: function(item) {
				return item;
			}
		}
};

$(document).ready( function() {
	
	$("input[data-provide='typeahead']").each(function (index,input){
		var Engine;
		if (engines[$(this).data("searchengine")]) {
			Engine=engines[$(this).data("searchengine")];
		} else {
			Engine=engines["empty"];
		}
		Engine.engine.initialize();
		$(this).typeahead({
			items: 4,
			displayText: Engine.displayText,
			source: Engine.engine.ttAdapter() 
		}); 
		$(this).change(function() {
		    var current = $(this).typeahead("getActive");
		    if (current) {
		    	if (current['mods.title'][0]==$(this).val()){
		    	    $('#hostid').val(current.id);
		    	    $(this).val(current['mods.title'][0]);
		    	    $(this).parents("fieldset").find("input:not(.mir-modspart)").prop('disabled', true );
		    	} else {
		    		$('#hostid').val("");
		    	}
		    }
		});
	});
	
	$('.host-reset').click(function(event) {
		event.preventDefault();
		$(this).parents("fieldset").find("input[data-provide='typeahead']").val("");
		$(this).parents("fieldset").find("input[data-provide='typeahead']").prop('disabled', false );
		//$("input[data-provide='typeahead']").val("");
		//$("input[data-provide='typeahead']").prop('disabled', false );
	});
	
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


