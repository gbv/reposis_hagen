//Class OA Widget

function OAWidget (element,providerurl) {
  this.providerurl = providerurl;
  this.$element = $(element);
  this.data = "";
};

OAWidget.prototype= {
  constructor: OAWidget
  
  ,requestData: function () {
    $.ajax({
		method : "GET",
		url : this.providerurl + "jsonloader.php?identifier=oai:ub-deposit.fernuni-hagen.de:mir_mods_00000008&amp;from=2016-01-01&amp;until=2016-03-31&amp;formatExtension=xml&amp;granularity=total",
		dataType : "xml"
	}).done(function(data) {
		OAWidget.receiveData(this, data)
	}).error(function(e) {
		console.log("Fehler beim Holen der Daten vom Graphprovider");
	});
  }
  
  ,render: function () {
    console.log("Rendern");
  }
};

OAWidget.receiveData = function(oawidget,data) {
  oawidget.data = data;
  oawidget.render();
};

$(document).ready(function() {
  $('[data-oasproviderurl]').each(function(index, oasdiv) {
    $(oasdiv).text("each test");
    oawidget = new OAWidget(oasdiv,$(oasdiv).data('oasproviderurl'));
    oawidget.requestData();
  });
});
