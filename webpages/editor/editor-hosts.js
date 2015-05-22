
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
			    		param+="&fl=mods.title%2Cid%2Cidentifier.type.isbn%2CshelfLocator";
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
			    		param+="&fl=mods.title%2Cid%2Cidentifier.type.isbn%2CshelfLocator";
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
			    		param+="&fl=mods.title%2Cid%2Cidentifier.type.issn%2Cidentifier.type.isbn%2CshelfLocator";
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
				fillFieldset(fieldset,current.id);
				createbadge($(document.activeElement).closest("div"),current.id);
				
			}
		}); 
		
	});
	/*
	$('.host-reset').click(function(event) {
		event.preventDefault();
		relatedItemBody=$(document.activeElement).closest("fieldset.mir-relatedItem").children('div.mir-relatedItem-body');
		relatedItemBody.find("div.form-group:not(.mir-modspart)").find("input[type!='hidden']").each ( function(index,input){
			$(input).prop('disabled', false );
			$(input).val($(input).data('value'));
		});
		relatedItemBody.find("input[id^='relItem']").val("");
		$(document.activeElement).closest("fieldset.mir-relatedItem").find("fieldset.mir-relatedItem").prop('disabled', false );
	});*/
	
	$("input[id^='relItem']").each (function (index,input){
		if (input.value!="") {
			fieldset=$(input).closest("fieldset.mir-relatedItem");
			disableFieldset(fieldset);
			fillFieldset(fieldset,input.value);
			createbadge($(fieldset.find("div.input-group")[0]),input.value);
		}
	});
	
});

function disableFieldset(fieldset){
	relatedItemBody=fieldset.children('div.mir-relatedItem-body');
	relatedItemBody.find("div.form-group:not(.mir-modspart)").find("input[type!='hidden']").each( function(index,input){
		if (input != document.activeElement) {
			$(input).prop('disabled', true );
			$(input).data('value',$(input).val());
		}
	});
	$(".searchbadge").addClass("disabled");
	
	fieldset.find("fieldset.mir-relatedItem").prop('disabled', true );
};

function fillFieldset(fieldset,relItemid){
	/*relatedItemBody=fieldset.children('div.mir-relatedItem-body');
	relatedItemBody.find('input').each(function (index,input){
		if ($(input).data("responsefield") && current [$(input).data("responsefield")]){
			if ($.isArray(current [$(input).data("responsefield")])) {
				$(input).val(current [$(input).data("responsefield")][0]);
			} else {
				$(input).val(current [$(input).data("responsefield")]);
			}
		}
	});*/
	$.ajax({
		method: "GET",
		url: "http://reposis-test.gbv.de/hagen/receive/"+relItemid+"?XSL.Style=xml",
		dataType: "xml"
	  }).done(function( xml ) {
		fieldset.find('input').each(function(index,input){
			path=input.name.substr(input.name.indexOf("relatedItem/") + 12);
			path="/mycoreobject/metadata/def.modsContainer/modsContainer/mods:mods/"+path;
			function nsResolver(prefix) {
				  var ns = {
				    'mods' : 'http://www.loc.gov/mods/v3',
				    'xlink': 'http://www.w3.org/1999/xlink',
				  };
				  return ns[prefix] || null;
			}
			xPathRes=xml.evaluate(path,xml,nsResolver,XPathResult.ANY_TYPE,null)
			node=xPathRes.iterateNext ();
			if (node) {
				input.value=$(node).text();
			}
		});
		//alert(xml);
	    
	});
};

function createbadge(inputgroup,relItemid) {
	badge='<a href="../receive/'+relItemid+'" target="_blank" class="badge"> ';
	badge+='intern ';
	badge+='<span class="glyphicon glyphicon-remove-circle relItem-reset"> </span>';
	badge+='</a>';
	
	inputgroup.find(".searchbadge").html(badge);
	
	inputgroup.find(".relItem-reset").click(function(event) {
		event.preventDefault();
		relatedItemBody=$(this).closest("fieldset.mir-relatedItem").children('div.mir-relatedItem-body');
		relatedItemBody.find("div.form-group:not(.mir-modspart)").find("input[type!='hidden']").each ( function(index,input){
			$(input).prop('disabled', false );
			$(input).val($(input).data('value'));
		});
		$('.searchbadge').removeClass("disabled");
		relatedItemBody.find("input[id^='relItem']").val("");
		$(document.activeElement).closest("fieldset.mir-relatedItem").find("fieldset.mir-relatedItem").prop('disabled', false );
		inputgroup=$(this).closest("div");
		inputgroup.find(".searchbadge").html("");
	});
};
