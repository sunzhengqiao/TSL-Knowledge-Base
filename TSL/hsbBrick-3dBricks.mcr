#Version 8
#BeginDescription
version value="1.4" date="14jun2019" author="marsel.nakuci@hsbcad.com"

cosmetic
delete TSL if hsbBrick-BrickDistributionInterior/hsbBrick-BrickDistributionExterior or hsbBrick-CourseDistribution not found
change name + create property about brick type
write readonly properties

This tsl creates 3D body of special bricks
The TSL is called by "hsbBrickDistributionExterior" and "hsbBrickDistributionInterior"
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords micasa, automatic, brick, generation, special, shop, drawing
#BeginContents
/// <History>//region
/// <version value="1.4" date="14jun2019" author="marsel.nakuci@hsbcad.com"> cosmetic</version>
/// <version value="1.3" date="03jun2019" author="marsel.nakuci@hsbcad.com"> delete TSL if hsbBrick-BrickDistributionInterior/hsbBrick-BrickDistributionExterior or hsbBrick-CourseDistribution not found</version>
/// <version value="1.2" date="30may2019" author="marsel.nakuci@hsbcad.com"> change name + create property about brick type </version>
/// <version value="1.1" date="15apr2019" author="marsel.nakuci@hsbcad.com"> write readonly properties </version>
/// <version value="1.0" date="11mar2019" author="marsel.nakuci@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// 
/// </insert>

/// <summary Lang=en>
/// This tsl creates 3D body of bricks
/// The TSL is called by "hsbBrickDistributionExterior" and "hsbBrickDistributionInterior"
/// </summary>

/// commands
// command to insert a G-connection
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbBrick-3dBricks")) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|"))) TSLCONTENT
//endregion

//region constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	// read a potential mapObject defined by hsbDebugController
	{ 
		MapObject mo("hsbTSLDev" ,"hsbTSLDebugController");
		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true;	break;}}
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		
	}
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
//end constants//endregion


//region properties

// get data written by hsbBrick-BrickDistributionExterior or hsbBrick-BrickDistributionInterior
	double dOffsetX = _Map.getDouble("dOffsetX");
	double dOffsetY = _Map.getDouble("dOffsetY");
	double dOffsetZ = _Map.getDouble("dOffsetZ");
	String sBrickTypeMap = _Map.getString("sBrickTypeMap");
	
	category = "Position";
	String sPositionXName=("X");	
	PropDouble dPositionX(nDoubleIndex++, dOffsetX, sPositionXName);	
	dPositionX.setDescription(T("|Defines the PositionX|"));
	dPositionX.setCategory(category);
	dPositionX.setReadOnly(true);
	
	String sPositionYName=("Y");	
	PropDouble dPositionY(nDoubleIndex++, dOffsetY, sPositionYName);	
	dPositionY.setDescription(T("|Defines the PositionY|"));
	dPositionY.setCategory(category);
	dPositionY.setReadOnly(true);
	
	String sPositionZName=("Z");	
	PropDouble dPositionZ(nDoubleIndex++, dOffsetZ, sPositionZName);	
	dPositionZ.setDescription(T("|Defines the PositionZ|"));
	dPositionZ.setCategory(category);
	dPositionZ.setReadOnly(true);
	
	category = "Brick type: Special or not";
	String sBrickTypes[] = { T("|Regular|"), T("|Special|")};
	String sBrickTypeName=T("|BrickType|");	
	PropString sBrickType(nStringIndex++, sBrickTypes[0], sBrickTypeName);	
	sBrickType.setDescription(T("|Defines the BrickType|"));
	sBrickType.setCategory(category);
	sBrickType.setReadOnly(true);
	
	int iBrickType = sBrickTypes.find(sBrickTypeMap);
	if(iBrickType>-1)
	{ 
		sBrickType.set(sBrickTypes[iBrickType]);
	}
	
//End properties//endregion 
	
	
// bOnInsert//region
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
				
	// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();
		
		if (sKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			for(int i=0;i<sEntries.length();i++)
				sEntries[i] = sEntries[i].makeUpper();	
			if (sEntries.find(sKey)>-1)
				setPropValuesFromCatalog(sKey);
			else
				setPropValuesFromCatalog(sLastInserted);					
		}
		else	
			showDialog();
			
		return;
	}	
// end on insert	__________________//endregion

//region compare key
// set compare key
	String sCompareKey = scriptName() + dPositionX + dPositionY + dPositionZ;
	setCompareKey(sCompareKey);
//End compare key//endregion 

//region if brick has opening
	PlaneProfile pp = _Map.getPlaneProfile("planeProfile");// get plane profile
	PLine pls[] = pp.allRings();
	if(pls.length()>1)
	{ 
		reportMessage(TN("|more than one ring in brick plane profile, not allowed|"));
		eraseInstance();
		return;
	}
	PLine pl = pls[0];	

//End if brick has opening//endregion 

//region set dependency on hsbBrick-BrickDistributionInterior or hsbBrick-BrickDistributionExterior
	TslInst tslBrick;
	int iTslBrickFound = false;
	for (int i = 0; i < _Entity.length(); i++)
	{
		TslInst _tslBrick = (TslInst)_Entity[i];
		if (_tslBrick.bIsValid())
		{
			if(_tslBrick.scriptName()!="hsbBrick-BrickDistributionInterior" && _tslBrick.scriptName()!="hsbBrick-BrickDistributionExterior")
			{ 
				// normally should not happen but to be safe
				// disregard all that are not "hsbBrick-BrickDistributionInterior"
				continue;
			}
			
			// get and validate family data
			tslBrick = _tslBrick;
			setDependencyOnEntity(tslBrick);
			iTslBrickFound = true;
			break;
		}
	}
//End set dependency on hsbBrick-BrickDistributionInterior or hsbBrick-BrickDistributionExterior//endregion 
	
	
//region set dependency on hsbBrick-CourseDistribution
	TslInst tslCourse;
	int iTslCourseFound = false;
	for (int i = 0; i < _Entity.length(); i++)
	{
		TslInst _tslCourse = (TslInst)_Entity[i];
		if (_tslCourse.bIsValid())
		{
			if(_tslCourse.scriptName()!="hsbBrick-CourseDistribution" )
			{ 
				// normally should not happen but to be safe
				// disregard all that are not "hsbBrick-CourseDistribution"
				continue;
			}
			
			// get and validate family data
			tslCourse = _tslCourse;
			setDependencyOnEntity(tslCourse);
			iTslCourseFound = true;
			break;
		}
	}
//End set dependency on hsbBrick-CourseDistribution//endregion
	
//region delete if its dependency TSL is deleted
	
	if(!iTslBrickFound || !iTslCourseFound)
	{ 
		eraseInstance();
		return;
	}

//End delete if its dependency TSL is deleted//endregion


//region some error handling
	if(_Element.length()<1)
	{ 
		// wall element should always be passed from the "hsbBrick-BrickDistribution"
		reportMessage(TN("|no element found|"));
		eraseInstance();
		return;
	}
	Element el = _Element[0];
	
	if(!el.bIsValid())
	{ 
		reportMessage(TN("|element of wall not found|"));
		eraseInstance();
		return;
	}

//End some error handling//endregion 

//region generate bodies, group assignment

	Vector3d vecX = el.vecX();
	Vector3d vecY = el.vecY();
	Vector3d vecZ = el.vecZ();
	// width is passed from the "hsbBrick-BrickDistribution" into the map
	double dWidth = _Map.getDouble("width");
	
	Vector3d vecExtrusion = -dWidth * vecZ;
	Body body(pl, vecExtrusion);
//	MetalPart mp(pl, vecExtrusion);
	Display dp(4);
	dp.draw(body);
	
	assignToElementGroup(el, false, 0, 'E');	

//End generate bodies//endregion 
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
  <lst nm="TslInfo">
    <lst nm="TSLINFO" />
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End