
var engines = {
		shelfmark: {
			engine:new Bloodhound({
				//datumTokenizer: Bloodhound.tokenizers.obj.whitespace,
				datumTokenizer: Bloodhound.tokenizers.obj.whitespace('mods.title[0]'),
				queryTokenizer: Bloodhound.tokenizers.whitespace,
				remote: {
					url: '../servlets/solr/select',
					filter: function(list) {
						list=list.response.docs;
						$.each(list,function (index,item){
							item.name=item['shelfLocator']+' - '+item['mods.title'][0];
							item.value=item['shelfLocator'];
						});
						return list;
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
		},
		isbn: {
			engine:new Bloodhound({
				//datumTokenizer: Bloodhound.tokenizers.obj.whitespace,
				datumTokenizer: Bloodhound.tokenizers.obj.whitespace('mods.title[0]'),
				queryTokenizer: Bloodhound.tokenizers.whitespace,
				remote: {
					url: '../servlets/solr/select',
					filter: function(list) {
						list=list.response.docs;
						$.each(list,function (index,item){
							item.name=item['identifier.type.isbn']+' - '+item['mods.title'][0];
							item.value=item['identifier.type.isbn'];
						});
						return list;
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
		},
		issn: {
			engine:new Bloodhound({
				//datumTokenizer: Bloodhound.tokenizers.obj.whitespace,
				datumTokenizer: Bloodhound.tokenizers.obj.whitespace('mods.title[0]'),
				queryTokenizer: Bloodhound.tokenizers.whitespace,
				remote: {
					url: '../servlets/solr/select',
					filter: function(list) {
						list=list.response.docs;
						$.each(list,function (index,item){
							item.name=item['identifier.type.issn']+' - '+item['mods.title'][0];
							item.value=item['identifier.type.issn'];
						});
						return list;
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
		},
		title: {
			engine: new Bloodhound({
			    //datumTokenizer: Bloodhound.tokenizers.obj.whitespace,
				datumTokenizer: Bloodhound.tokenizers.obj.whitespace('mods.title[0]'),
				queryTokenizer: Bloodhound.tokenizers.whitespace,
				remote: {
					url: '../servlets/solr/select',
					filter: function(list) {
						list=list.response.docs;
						$.each(list,function (index,item){
							item.name=item['mods.title'][0];
							item.value=item['mods.title'][0];
						});
						return list;
					},
					replace : function (url, query) {
						param="?&q=%2Bmods.title%3A*"+query+"*";
						param+="+%2Bcategory.top%3A%22mir_genres\%3A"+$(document.activeElement).data("genre")+"%22";
						param+="+%2BobjectType%3A%22mods%22";
			    		param+="&fl=mods.title%2Cid%2Cidentifier.type.issn";
			    		param+="&version=4.5&rows=1000&wt=json";
			    		return url+param;
					}
				}
			}),
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
			source: Engine.engine.ttAdapter(),
			updater: function (current) {
				current.name=current.value;
				return(current);
			},
			afterSelect: function (current) {
				fieldset=$(document.activeElement).closest("fieldset.mir-relatedItem");
				relatedItemBody=fieldset.children('div.mir-relatedItem-body');
				relatedItemBody.find("input[id^='relItem']").val(current.id);
				disableFieldset(fieldset);
				fillFieldset(fieldset,current);
			}
		}); 
		
	});
	
	$('.host-reset').click(function(event) {
		event.preventDefault();
		relatedItemBody=$(document.activeElement).closest("fieldset.mir-relatedItem").children('div.mir-relatedItem-body');
		relatedItemBody.find("div.form-group:not(.mir-modspart)").find('input').prop('disabled', false );
		relatedItemBody.find("div.form-group:not(.mir-modspart)").find('input').val("");
		relatedItemBody.find("input[id^='relItem']").val("");
		$(document.activeElement).closest("fieldset.mir-relatedItem").find("fieldset.mir-relatedItem").prop('disabled', false );
	});
	
	$("input[id^='relItem']").each (function (index,input){
		if (input.value!="") {
			fieldset=$(input).closest("fieldset.mir-relatedItem");
			disableFieldset(fieldset);
			
		}
	});
	
});

function disableFieldset(fieldset){
	relatedItemBody=fieldset.children('div.mir-relatedItem-body');
	relatedItemBody.find("div.form-group:not(.mir-modspart)").find('input').prop('disabled', true );
	relatedItemBody.find("input[type='hidden']").prop('disabled', false );
	fieldset.find("fieldset.mir-relatedItem").prop('disabled', true );
};

function fillFieldset(fieldset,current){
	relatedItemBody=fieldset.children('div.mir-relatedItem-body');
	relatedItemBody.find('input').each(function (index,input){
		if ($(input).data("responsefield")){
			if ($(input).data("responsefield")) {
				if ($.isArray(current [$(input).data("responsefield")])) {
					$(input).val() = current [$(input).data("responsefield")][0];
				} else {
					$(input).val() = current [$(input).data("responsefield")];
				}
			} else {
				$(input).val()="";
			}
					
		}
	});
};
/*
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
});*/


