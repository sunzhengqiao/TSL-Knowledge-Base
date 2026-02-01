#Version 8
#BeginDescription
TSL used to lauch hsbMakeLite Shopdrawing review app









































#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
Unit(1,"mm");
 

if (_bOnInsert) {
	
	
	PrEntity ssE(T("|Select elements to be exported|"), Element());
	
	if ( ! ssE.go()) {
		
		eraseInstance();
		
		return;
		
	}
	
	Entity elems[] = ssE.set();
	reportMessage(T("\n|Number of elements selected:| ") + elems.length());
	
	// find entities from elements
	Entity ents[] = ssE.set(); //add elements as well

	
	for (int i = 0; i < elems.length(); i++) {
		
		Element el = (Element)elems[i]; //cast the entity to a element
		
		if ( ! el.bIsValid())
			
		continue;
		
		Group grp = el.elementGroup(); //get group from element
		
		
		
		// get entities from group
		
		Entity elEnts[] = grp.collectEntities(FALSE, Entity(), _kModelSpace);
		
		reportMessage("\nFor elem " + el.number() + " found " + elEnts.length() + " entities.");
		
		
		
		ents.append(elEnts); //append to collection
		
	}
	
	reportMessage(T("\n|Number of entities collected:| ") + ents.length());
	
	
	ModelMapComposeSettings mmFlags;
	mmFlags.addSolidInfo(TRUE); //default FALSE
	mmFlags.addAnalysedToolInfo(TRUE); //default FALSE
	mmFlags.addElemToolInfo(TRUE); //default FALSE
	mmFlags.addConstructionToolInfo(TRUE); //default FALSE
	mmFlags.addHardwareInfo(TRUE); //default FALSE
	mmFlags.addRoofplanesAboveWallsAndRoofSectionsForRoofs(TRUE); //default FALSE
	mmFlags.addCollectionDefinitions(TRUE); //default FALSE
	
	// compose ModelMap
	ModelMap mm;
	mm.setEntities(ents);
	mm.dbComposeMap(mmFlags);
	
	String strAssemblyPath = _kPathHsbInstall + "\\Utilities\\\hsbMakeLiteConnector\\hsbMakeLiteConnector.dll";
	String strType = "hsbMakeLiteConnector.HsbCadIO";
	String strFunction = "ShopdrawingReview";

	Map mpOut;
	mpOut = callDotNetFunction2( strAssemblyPath, strType, strFunction , mm.map() );
	eraseInstance();
	
	return;
}
#End
#BeginThumbnail













































#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]" />
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End