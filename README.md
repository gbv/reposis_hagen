
# repois_hagen

This is a jar-modul to customize MIR for the repository deposit_hagen. 
deposit_hagen is located under https://ub-deposit.fernuni-hagen.de

## Installation Instructions

* run `mvn clean install`
* copy jar to ~/.mycore/(dev-)mir/lib/

## Development

You can add these to your ~/.mycore/(dev-)mir/.mycore.properties
```
MCR.Developer.Resource.Override=/path/to/reposis_hagen/src/main/resources
MCR.LayoutService.LastModifiedCheckPeriod=0
MCR.UseXSLTemplateCache=false
MCR.SASS.DeveloperMode=true
```
