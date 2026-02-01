#Version 8
#BeginDescription
#Versions:
1.0 12/11/2024 Pilot version Author: Robert Pol


This tsl sets the weight at openings



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
//region <History>
// #Versions
//1.0 12/11/2024 Pilot version Author: Robert Pol


/// <insert Lang=en>
/// Select entities
/// </insert>

// <summary Lang=en>
// This tsl sets the weight at openings

// then the hsbCenterOfGravity TSL will use that information for the calculation of weight
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCenterOfGravity_setOpeningWeight")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|"))) TSLCONTENT
//endregion
	
//region Constants 
	U(1,"mm");	
	double dEps=U(.1);
	int nDoubleIndex,nStringIndex,nIntIndex;
	String sDoubleClick="TslDoubleClick";
	int bDebug=_bOnDebug;
	// read a potential mapObject defined by hsbDebugController
	{ 
		MapObject mo("hsbTSLDev","hsbTSLDebugController");
		if (mo.bIsValid()){Map m=mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug=true;break;}}
		if(bDebug)reportMessage("\n"+scriptName()+" starting "+_ThisInst.handle());
	}
	String sDefault=T("|_Default|");
	String sLastInserted=T("|_LastInserted|");
	String category=T("|General|");
	String sNoYes[]={ T("|No|"),T("|Yes|")};
	
	String arSZoneLayer[] = {
	"Tooling",
	"Information",
	"Zone",
	"Element"
};
char arChZoneCharacter[] = {
	'T',
	'I',
	'Z',
	'E'
};
//end Constants//endregion
	
	
//region Properties
	String sWeightName=T("|Weight|");
	PropDouble dWeight(nDoubleIndex++, U(0), sWeightName);
	dWeight.setDescription(T("|Defines the Weight of the opening in Kg.|")+" "+T("|Entries 0 will disable the mapX and the hsbCenterOfGravity TSL will ignore the mapX.|"));
	dWeight.setCategory(category);
	
	String sFormatName=T("|Text Format|");
	PropString sFormat(nStringIndex++, "@(OpeningStickDescription) - \n @(CenterOfGravity.Weight)", sFormatName);
	//sFormat.setDescription(T("|Defines the Weight of the opening in Kg.|")+" "+T("|Entries 0 will disable the mapX and the hsbCenterOfGravity TSL will ignore the mapX.|"));
	sFormat.setCategory(category);
	
	category = T("|Style|");
	String sDimensionStyleName=T("|Dimension Style|");	
	PropString sDimensionStyle(nStringIndex++, _DimStyles, sDimensionStyleName);	
	sDimensionStyle.setDescription(T("|Defines the dimstyle for the text of the percentage|"));
	sDimensionStyle.setCategory(category);	
	
	String sTextLayerName =T("|Text Layer|");	
	PropString sTextLayer(nStringIndex++, arSZoneLayer, sTextLayerName);
	sTextLayer.setCategory(category);
//End Properties//endregion 
	
//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) {eraseInstance();return;}
					
	// silent/dialog
		if (_kExecuteKey.length()>0)
		{
			String sEntries[]= TslInst().getListOfCatalogNames(scriptName());
			if (sEntries.findNoCase(_kExecuteKey,-1)>-1)
				setPropValuesFromCatalog(_kExecuteKey);
			else
				setPropValuesFromCatalog(sLastInserted);
		}
	// standard dialog
		else
			showDialog();
		

		while(true)
		{ 
		
		
		// prompt for sips
			Entity ents[0];
			PrEntity ssE(T("|Select openings|"), Opening());
			if (ssE.go())
				ents.append(ssE.set());
			
			if(ents.length()==0)
			{ 
				break;
			}
			
			String sStyle;
			double dWidth, dHeight;
		// evaluate that all openings are the same
			int bSameOpeningStyles=true;
			Opening ops[0];
			for (int e=0;e<ents.length();e++) 
			{ 

			// create TSL
				TslInst tslNew;	Vector3d vecXTsl=_XW; Vector3d vecYTsl=_YW;
				GenBeam gbsTsl[]={}; Entity entsTsl[1]; Point3d ptsTsl[]={_Pt0};
				int nProps[]={}; 
				double dProps[]={dWeight}; String sProps[]={};
				Map mapTsl;
				

					entsTsl[0]=ents[e]; 
					//
					tslNew.dbCreate(scriptName(),vecXTsl,vecYTsl,gbsTsl,entsTsl,
						ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
						
			}
			
			showDialog();
		}
		eraseInstance();
		return;
	}
// end on insert	__________________//endregion	


Opening opening;
if(_Opening.length()==1)
{ 
	opening=_Opening[0];
}
if(!opening.bIsValid())
{ 
	reportMessage("\n"+scriptName()+" "+T("|One valid opening needed|"));
	eraseInstance();
	return;
}

Element element = opening.element();
setDependencyOnEntity(opening);
if (!element.bIsValid())
{
	eraseInstance();
	return;
}

TslInst elementTsls[] = element.tslInst();
for (int i=0;i<elementTsls.length();i++)
{
	TslInst elementTsl = elementTsls[i];
	if (elementTsl.scriptName() != scriptName()) continue;
	
	Entity tslEnts[] = elementTsl.entity();
	for (int p=0;p<tslEnts.length();p++)
	{
		Entity ent = tslEnts[p];
		Opening tslOpening = (Opening)ent;
		if ( ! tslOpening.bIsValid()) continue;
		
		if (tslOpening != opening) continue;
		
		elementTsl.dbErase();
	}
}

String textToDisplay = opening.formatObject(sFormat);

CoordSys openingCoordsys = opening.coordSys();
Point3d openingOrg = openingCoordsys.ptOrg();
Vector3d openingX = openingCoordsys.vecX();
Vector3d openingY = openingCoordsys.vecY();
Vector3d openingZ = openingCoordsys.vecZ();
double openingWidth = opening.width();
double openingHeight = opening.height();
PLine openingPline = opening.plShape();

_Pt0=openingOrg + openingX * 0.5 * openingWidth + openingY * openingHeight * 0.5;
_ThisInst.assignToElementGroup(element, true, 0, 'E');
Map mapX;
mapX.setDouble("Weight",dWeight);
mapX.setPoint3d("Center",_Pt0);
_ThisInst.setSubMapX("CenterOfGravity",mapX);
opening.setSubMapX("CenterOfGravity", mapX);

Display display(-1);
//display.draw(openingPline);
display.dimStyle(sDimensionStyle);
display.elemZone(element, 0, arChZoneCharacter[arSZoneLayer.find(sTextLayer, 0)]);
display.draw(textToDisplay, _Pt0, -openingX, openingY, 0, 0, _kDeviceX );
//eraseInstance();
//return;
//

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
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="181" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Pilot version" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="11/12/2024 4:02:51 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End