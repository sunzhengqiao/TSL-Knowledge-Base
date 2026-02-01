#Version 8
#BeginDescription
#Versions:
Version 1.2 20.11.2024 HSB-23011. Just a comment , Author Marsel Nakuci
1.1 03/06/2024 HSB-20484: Fix density Marsel Nakuci
1.0 27/05/2024 HSB-20484: Initial 

This tsl sets the weight at openings
It allows the user to set the weight at openings windows, doors, assemblies
A pseudo density is calculated from the volume of the opening
The information is saved in a mapX called "OpeningCOG"
When the mapX with the density is present at opening
then the hsbCenterOfGravity TSL will use that information for the calculation of weight


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
//region <History>
// #Versions
// 1.2 20.11.2024 HSB-23011. Just a comment , Author Marsel Nakuci
// 1.1 03/06/2024 HSB-20484: Fix density Marsel Nakuci
// 1.0 27/05/2024 HSB-20484: Initial Marsel Nakuci

/// <insert Lang=en>
/// Select entities
/// </insert>

// <summary Lang=en>
// This tsl sets the weight at openings
// It allows the user to set the weight at openings windows, doors, assemblies
// A pseudo density is calculated from the volume of the opening
// The information is saved in a mapX called "OpeningCOG"
// When the mapX with the density is present at opening
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
//end Constants//endregion
	
	
//region Properties
	String sWeightName=T("|Weight|");
	PropDouble dWeight(nDoubleIndex++, U(0), sWeightName);
	dWeight.setDescription(T("|Defines the Weight of the opening in Kg.|")+" "+T("|Entries 0 will disable the mapX and the hsbCenterOfGravity TSL will ignore the mapX.|"));
	dWeight.setCategory(category);
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
				Opening opE=(Opening)ents[e];
				if(!opE.bIsValid())continue;
				Map map = opE.getAutoPropertyMap();
				String sStyleE;
				if (map.hasString(T("|Style|")))
					sStyleE = map.getString(T("|Style|")).makeUpper();
				else if (map.hasString("Stil"))
					sStyleE = map.getString("Stil").makeUpper();
				double dWidthE=opE.width();
				double dHeightE=opE.height();
				
				if(dWidth==U(0))
				{ 
					sStyle=sStyleE;
					dWidth=dWidthE;
					dHeight=dHeightE;
				}
				else
				{ 
					if(sStyle!=sStyleE || dWidth!=dWidthE || dHeight!=dHeightE)
					{ 
						bSameOpeningStyles=false;
						break;
					}
				}
				if(ops.find(opE)<0)
				{ 
					ops.append(opE);
				}
			}//next e
			
			if(bSameOpeningStyles)
			{ 
			// create TSL
				TslInst tslNew;	Vector3d vecXTsl=_XW; Vector3d vecYTsl=_YW;
				GenBeam gbsTsl[]={}; Entity entsTsl[1]; Point3d ptsTsl[]={_Pt0};
				int nProps[]={}; 
				double dProps[]={dWeight}; String sProps[]={};
				Map mapTsl;
				
				for (int o=0;o<ops.length();o++) 
				{ 
					entsTsl[0]=ops[o]; 
					//
					tslNew.dbCreate(scriptName(),vecXTsl,vecYTsl,gbsTsl,entsTsl,
						ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
				}//next o
				reportMessage("\n"+scriptName()+" "+T("|Weight was set|"));
			}
			else
			{ 
				reportMessage("\n"+scriptName()+" "+T("|Different openings were selected|"));
				reportMessage("\n"+scriptName()+" "+T("|command was ignored|"));
			}
			
			showDialog();
		}
		eraseInstance();
		return;
	}
// end on insert	__________________//endregion	


Opening op;
if(_Opening.length()==1)
{ 
	op=_Opening[0];
}
if(!op.bIsValid())
{ 
	reportMessage("\n"+scriptName()+" "+T("|One valid opening needed|"));
	eraseInstance();
	return;
}


_Pt0=op.coordSys().ptOrg();
Body bdReal=op.realBody();
double dVol=bdReal.volume();
if(dVol<pow(U(10),3))
{ 
	// calculate the volume
	double dFrameWidth;
	Map mapOpeningSF, mapOpening;
	{ 
		ModelMapComposeSettings mmFlags;
		mmFlags.addElemToolInfo(TRUE);
		mmFlags.addConstructionToolInfo(true);
		
		ModelMap mm;
		Entity ents[0];
		ents.append(op);
		mm.setEntities(ents);
		mm.dbComposeMap(mmFlags);
		mapOpeningSF = mm.map().getMap("Model\\OpeningSF\\Opening");
		mapOpening = mm.map().getMap("Model");
		Map mapOpeningModel = mm.map().getMap("Model");
		if(mapOpeningModel.hasMap("OpeningSF"))
		{ 
			mapOpening=mm.map().getMap("Model\\OpeningSF\\Opening");
			
		}
		else
		{ 
			mapOpening=mm.map().getMap("Model\\Opening");
		}
		dFrameWidth = mapOpening.getDouble("frameWidth");
	}
	PLine plShape=op.plShape();
	if(dFrameWidth>dEps)
	{
		bdReal=Body(plShape, op.coordSys().vecZ()*dFrameWidth);
	}
}
//dVol=dVol/(1e9);
double dDensity=dWeight/dVol;
Map mapX;
// HSB-23011
// In hsbCenterOfGravity the pseudo density will be used instead of the weight
// bc the errors are less when the opening volume is modified
mapX.setDouble("Density",dDensity);// pseudo density
mapX.setDouble("WeightInitial",dWeight);
op.setSubMapX("OpeningCOG",mapX);
eraseInstance();
return;


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
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23011. Just a comment" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="11/20/2024 9:47:26 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20484: Fix density" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="6/3/2024 10:53:04 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20484: Initial" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="5/27/2024 10:12:00 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End