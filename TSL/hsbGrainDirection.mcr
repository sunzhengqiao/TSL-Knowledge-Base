#Version 8
#BeginDescription
#Versions
Version 7.14 06.10.2025 HSB-24511 Acceptance of plan view alignment tolerances Thorsten Huck

Version 7.13 10/09/2025 HSB-24493: Add calculation of outer contour area for extended data "Parameterliste childpanel" for Södra , Author Marsel Nakuci
Version 7.12 11/04/2025 HSB-23793: Fix when setting association from "ExtendedDataAssociation"; Fix text orientation , Author Marsel Nakuci
Version 7.11 10/04/2025 HSB-23793: Add parameter "ExtendedDataAssociation" in xml "propSetName\propName" for the definition of Association on Auto , Author Marsel Nakuci
Version 7.10 09/04/2025 HSB-23793: Add parameter "3DGrain" in xml , Author Marsel Nakuci
Version 7.9 01.12.2023 HSB-18515: Fix solid representation 
Version 7.8 22.11.2023 HSB-20302 ensuring grain direction is executed as last tsl of panel NOTE: requires hsbDesign 26 or higher
Version 7.7 09.10.2023 HSB-20282: fix 3d generation of letters 
Version 7.6 30.08.2023 HSB-19795: on plan view show surfaceQuality text close to the panel side 
Version 7.5 29.08.2023 HSB-19795: On Plan view show quality position on the side of the quality 
Version 7.4 25.08.2023 HSB-19791: On side view show the relevant quality 
Version 7.3 25.08.2023 HSB-19795: Fix side of text 
Version 7.2 07.06.2023 HSB-19142 Text Location corrected
Version 7.1 09.05.2023 HSB-18930 'Fit In View': supports scaling of textheight, block and pline symbol if sd_EntitySymbolDisplay has a fixed textheight
Version 7.0 08.05.2023 HSB-18924 allow coma or semicolon separation of color association
Version 6.9 29.03.2023 HSB-18497 single line format parsing improved
Version 6.8 17.02.2023 HSB-17629 3D Text respects viewing side
Version 6.7 22.11.2022 HSB-17134 text displays with static offset
Version 6.6 07.11.2022 HSB-16983 bugfix default marking drill location
Version 6.5 25.10.2022 HSB-16887 new settings property to specify a preferred nesting face for floor panels with identical qualities on each face. 
New graphics showing preferred nesting face if set. 
New context commands to override preferred nesting face
















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 7
#MinorVersion 14
#KeyWords Graindirection;CLT;Sip
#BeginContents
//region Part #1
		

//region History
/// <History>
// #Versions
// 7.14 06.10.2025 HSB-24511 Acceptance of plan view alignment tolerances Thorsten Huck
// 7.13 10/09/2025 HSB-24493: Add calculation of outer contour area for extended data "Parameterliste childpanel" for Södra , Author Marsel Nakuci
// 7.12 11/04/2025 HSB-23793: Fix when setting association from "ExtendedDataAssociation"; Fix text orientation , Author Marsel Nakuci
// 7.11 10/04/2025 HSB-23793: Add parameter "ExtendedDataAssociation" in xml "propSetName\propName" for the definition of Association on Auto , Author Marsel Nakuci
// 7.10 09/04/2025 HSB-23793: Add parameter "3DGrain" in xml , Author Marsel Nakuci
// 7.9 01.12.2023 HSB-18515: Fix solid representation Author: Marsel Nakuci
// 7.8 22.11.2023 HSB-20302 ensuring grain direction is executed as last tsl of panel NOTE: requires hsbDesign 26 or higher , Author Thorsten Huck
// 7.7 09.10.2023 HSB-20282: fix 3d generation of letters Author: Marsel Nakuci
// 7.6 30.08.2023 HSB-19795: on plan view show surfaceQuality text close to the panel side Author: Marsel Nakuci
// 7.5 29.08.2023 HSB-19795: On Plan view show quality position on the side of the quality Author: Marsel Nakuci
// 7.4 25.08.2023 HSB-19791: On side view show the relevant quality Author: Marsel Nakuci
// 7.3 25.08.2023 HSB-19795: Fix side of text Author: Marsel Nakuci
// 7.2 07.06.2023 HSB-19142 Text Location corrected , Author Thorsten Huck
// 7.1 09.05.2023 HSB-18930 'Fit In View': supports scaling of textheight, block and pline symbol if sd_EntitySymbolDisplay has a fixed textheight  , Author Thorsten Huck
// 7.0 08.05.2023 HSB-18924 allow coma or semicolon separation of color association , Author Thorsten Huck
// 6.9 29.03.2023 HSB-18497 single line format parsing improved , Author Thorsten Huck
// 6.8 17.02.2023 HSB-17629 3D Text respects viewing side , Author Thorsten Huck
// 6.7 22.11.2022 HSB-17134 text displays with static offset , Author Thorsten Huck
// 6.6 07.11.2022 HSB-16983 bugfix default marking drill location , Author Thorsten Huck
// 6.5 25.10.2022 HSB-16887 new settings property to specify a preferred nesting face for floor panels with identical qualities on each face. New graphics showing preferred nesting face if set. New context commands to override preferred nesting face. , Author Thorsten Huck
// 6.4 01.08.2022 HSB-16169 3D-Text also shown when using block based symbol , Author Thorsten Huck
// 6.3 25.07.2022 HSB-15863 text composition restructured, formatting supports helper method, new option to set hidden qualities in plan view , Author Thorsten Huck
// 6.2 28.06.2022 HSB-15863 new options to display text in 3D (IFC Export) , Author Thorsten Huck
// 6.1 07.04.2022 HSB-15103 bugfix updating property sets when rotating grain direction , Author Thorsten Huck
// 6.0 10.01.2022 HSB-14250 bugfix resolving custom property set , Author Thorsten Huck
// 5.9 24.11.2021 HSB-13971 changing the grain direction can be done by selcting two points. , Author Thorsten Huck
// 5.8 15.11.2021 HSB-13805 bugfix writing property sets , Author Thorsten Huck
// 5.7 27.10.2021 HSB-13181 production type has become a readOnly property except on insert , Author Thorsten Huck
// 5.6 25.10.2021 HSB-13181 production type has become a readOnly property , Author Thorsten Huck
// 5.5 28.09.2021 HSB-13291 location of grain direction symbol published to subMapX , Author Thorsten Huck
// 5.4 23.06.2021 HSB-12355 weight written to submap and subMapX  'extendedProperties' of the panel , Author Thorsten Huck
// 5.3 05.03.2021 HSB-11067 Settings exposed to context command, new property/parameter to toggle between 2D or 3D display of grain direction , Author Thorsten Huck
// 5.2 04.03.2021 HSB-11063 In the submap 'ExtendedProperties' of a CLT panel a new property 'GrainDirection' is exposed. You can access the value by the format expression @(ExtendedProperties.GrainDirection) , Author Thorsten Huck
///<version value="5.1" date="20oct2020" author="thorsten.huck@hsbcad.com"> HSB-9338 internal naming bugfix </version>
///<version value="5.0" date=25sep2020" author="thorsten.huck@hsbcad.com"> HSB-8966 bugfix association color </version>
///<version value="4.9" date=08sep2020" author="thorsten.huck@hsbcad.com"> HSB-8771 bugfix association </version>
///<version value="4.8" date=27jul2020" author="thorsten.huck@hsbcad.com"> HSB-8368 supports automatic grain detection during creation, supports dialog for automatic tsl creation </version>
///<version value="4.7" date=16jul2020" author="thorsten.huck@hsbcad.com"> HSB-7915 formatting supports weight, use rounding argument to format decimals i.e. '@(Weight:RL1) kg' show the weight as '89.6 kg', text offsets of multilines improved </version>
///<version value="4.6" date=30mar2020" author="thorsten.huck@hsbcad.com"> HSB-7143 bugfix BeginMapX </version>
///<version value="4.5" date="25mar2020" author="thorsten.huck@hsbcad.com"> HSB-6215 format syntax changed to @(<PROPERTYNAME>), _LastInserted  catalog entry will be updated, instances with old syntax will be automatically converted </version>
///<version value="4.4" date=12jul19" author="thorsten.huck@hsbcad.com"> HSB-6473 flat mapX content can be displayed by specifying the property by <MapName>.<KeyName>, i.e. Hsb_SequenceChild.Buildingphase will display the buildingphase of a panel if specified by the tsl ErectionSequence </version>
///<version value="4.3" date=12jul19" author="thorsten.huck@hsbcad.com"> HSB-5370 display of planview text fixed </version>
///<version value="4.2" date=26jun19" author="thorsten.huck@hsbcad.com"> HSB-5237 settings file supports custom definition of text orientation, default = aligned with device </version>
///<version value="4.1" date=08may19" author="thorsten.huck@hsbcad.com"> version info fixed </version>
///<version value="4.0" date=28mar19" author="thorsten.huck@hsbcad.com"> Orientation of marking drill text fixed </version>
///<version value="3.9" date=28mar19" author="thorsten.huck@hsbcad.com"> HSBACD-647: automatic association assigns roof/floor to panels which parallel to XY-World </version>
///<version value="3.8" date=14sep18" author="thorsten.huck@hsbcad.com"> HSBACD-99: display supports visual styles other than wireframe, supports modelmap export </version>
///<version value="3.7" date=13jun18" author="thorsten.huck@hsbcad.com"> bugfix invalid association assignment </version>
///<version value="3.6" date=16apr18" author="thorsten.huck@hsbcad.com"> association stored in submap 'extendedProperties' </version>
///<version value="3.5" date=16apr18" author="thorsten.huck@hsbcad.com"> supports new setting to control visibilty of surface qualities in plan view </version>
///<version value="3.4" date=26mar18" author="thorsten.huck@hsbcad.com"> bugfix marking drill association </version>
///<version value="3.3" date=23mar18" author="thorsten.huck@hsbcad.com"> NOTE: mayor update, might requirface = e custom action! Settings are now stored in company\tsl\settings\<name>.xml, default can be exported if no settings file exists. settiings can be imported via hsbTslSettingsIO tsl, new optional block display of grain direction if blocks 'hsbGrainDirectionWall' and/or 'hsbGrainDirectionFloor' are found in dwg, new optional marking drill for panels which match conditions given in the settings file </version>
///<version value="3.2" date=07nov17" author="thorsten.huck@hsbcad.com"> bugfix property assignment on creation, grain direction gets copied along with a copy of the panel, NOTE: as property indices have changed an orphaned and redundant property will be present at instances which have been inserted with a previous version </version>
///<version value="3.1" date="19Oct16" author="thorsten.huck@hsbcad.com"> bugfix when using 'GeneralCLT' in plan view, plan view symth sidel enhanced </version>
///<version value="3.0" date="21sept16" author="thorsten.huck@hsbcad.com"> surface quality creates view dependent dimension requests, requires sd_EntitySymbolDisplay Version 2.6 or higher </version>
///<version value="2.9" date="10aug16" author="thorsten.huck@hsbcad.com"> new optional display 'GeneralCLT' added. This display will be used if configured in display manager. </version>
///<version value="2.8" date="27jul16" author="thorsten.huck@hsbcad.com"> plan view representation conform with shopdrawings </version>
///<version value="2.7" date="15jul16" author="thorsten.huck@hsbcad.com"> auto value of sublabel2 removed, property display supports subLabel2 </version>
///<version value="2.6" date="01jul16" author="thorsten.huck@hsbcad.com"> introducing new property text height plan view and new display of tagged properties in plan view </version>
///<version value="2.5" date="18nov15" author="thorsten.huck@hsbcad.com"> introducing CLT settings based on external file '<comapny>\sips\CLTSettings.xml'. Panel coordinate system will be adjusted to wood grain direction if settings file contains entry 'GrainMapping' with value 1 (X-Axis) or 2 (Y-Axis) </version>
///<version value="2.4" date="21may15" author="thorsten.huck@hsbcad.com"> bugfix on insert with new property 'Properties' </version>
///<version value="2.3" date="20may15" author="thorsten.huck@hsbcad.com"> new property 'Properties' added. The value of this property defines the content of the displayed text </version>
///<version value="2.2" date="02sep14" author="th@hsbCAD.de"> the symbol color is now accesible as property </version>
///<version value="2.1" date="28feb14" author="th@hsbCAD.de"> bugfix X-Axis orientation on insert </version>
///<version value="2.0" date="04dec13" author="th@hsbCAD.de"> bugfix controlling the production width </version>
///<version value="1.9" date="08mar13" author="th@hsbCAD.de"> association type colors changed to 1 (red) and 4(cyan) </version>
///<version value="1.8" date="08may13" author="th@hsbCAD.de"> symbol and text publishes as DimRequest. this feature is reimplemented due to version conflicts introduced with version 1.7 10.04.13 vs. 1.7 08.05.13</version>
///<version value="1.7" date="08may13" author="th@hsbCAD.de"> changing grain direction also triggers the chnage of the production type. X-Axis of panel is controlled by production type</version>
///<version value="1.6" date="05apr13" author="th@hsbCAD.de"> new property association added, color property removed, color is dependent from association type</version>
///<version value="1.5" date="21mar13" author="th@hsbCAD.de"> project path written to property set on creation</version>
///<version value="1.4" date="08mar13" author="th@hsbCAD.de"> reference point will stay in panel plane</version>
///<version value="1.3" date="07mar13" author="th@hsbCAD.de"> surface quality styles will be exported with the sip submap</version>
///<version value="1.2" date="06mar13" author="th@hsbCAD.de"> group assignment added and hidden surface quality property added</version>
///<version value="1.1" date="04feb13" author="th@hsbCAD.de"> new properties to assign production type (lengthwise, transverse), new functionality to auto assign property sets</version>
///<version value="1.0" date="08jan13" author="th@hsbCAD.de"> initial</version>
/// </History>

/// <insert Lang=en>
/// Select one or multiple sips to attach this tsl.
/// </insert>

/// <summary Lang=en>
/// This tsl displays and controls the grain direction of a panel.
/// </summary>

/// <remark Lang=en>
/// A property set with a property called 'ProductionType' will be auto assigned and values will be set on acoording events
/// </remark>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbGrainDirection")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Rotate grain direction|") (_TM "|Select grain direction|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Change grain direction|") (_TM "|Select grain direction|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Rotate grain direction|") (_TM "|Select grain direction|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Update Project Path|") (_TM "|Select grain direction|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add/Remove Format|") (_TM "|Select grain direction|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Remove Marking Drill|") (_TM "|Select grain direction|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Marking Drill|") (_TM "|Select grain direction|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Set Marking Depth/Alignment|") (_TM "|Select grain direction|"))) TSLCONTENT


//endregion

//region Constants
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
	
	String sProductionTypes[] = {"Transverse", "Lengthwise"};
	String sProductionTypesUI[] ={T("|" + sProductionTypes[0] + "|"),T("|" + sProductionTypes[1] + "|")};
	
	String sAssociationBlockNames[] ={"hsbGrainDirectionWall", "hsbGrainDirectionFloor"};
	String sAssociations[] = {"Wall","Roof/Floor"};
	String sAssociationsUI[] ={T("|" + sAssociations[0] + "|"),T("|" + sAssociations[1] + "|")};
	
	String sColorDescription = T("|Defines the color of the grain direction symbol. invalid or empty will display ByBlock, if the associations should display in different colors separate color indices by a semicolon.|");
	
	String sTextAligns[] ={ T("|Model|"), T("|Device|"), T("|Device X|")};
	int nTextAligns[] ={ _kModel, _kDevice, _kDeviceX};
	String sGrainMappings[] = { T("|Unchanged|"), T("|X-Axis|"), T("|Y-Axis|")};

	Vector3d vecZView = getViewDirection();
	String tVertical = T("|Vertical|"), kVersal="VersalHeight", kDisabled = T("<|Disabled|>"), 
	kRefSide = T("|Reference Side|"), kTopSide = T("|Top Side|"), kBothSides = T("|Both Sides|"),
	k3DText = "3DText",k3DGrain = "3DGrain",
	kWidthGrain = "WidthGrain",kWidthOutline="WidthOutline", tByBlock = T("|byBlock|");
	String s3DTexts[] = { kDisabled, kRefSide, kTopSide, kBothSides};
	String tFDDisabled = T("|Disabled|"), tFDPosZ = T("|Z-World|"), tFDNegZ = T("|Negative Z-World|"), kPreferredTopFace = "PreferredTopFace";
	
//region Color and view	
	int bIsDark;{int n = getBackgroundTrueColor();bIsDark = ((rgbR(n) + rgbB(n) + rgbG(n)) / 3 < 127);}
	int grey = bIsDark?rgb(199,200,202):rgb(99,100,102);
	int white = bIsDark?rgb(255,255,255):rgb(0,0,0);	
	
	int lightblue = rgb(204,204,255);
	int blue = rgb(69,84,185);	
	int darkblue = rgb(26,50,137);	
	int yellow = rgb(241,235,31);
	int darkyellow = rgb(254, 204, 102);
	int orange = rgb(242,103,34);
	int red = rgb(205,32,39);
	int purple = rgb(147,39,143);
	int petrol = rgb(16,86,137);
	int green = rgb(19,155,72);
//endregion

//end Constants//endregion

//region Functions

	//region Function collectGenbeamTslsByName
	// collects tsls attached to a genbeam
	// names: the scriptnames to be acxcepted, empty = all
	// gb: the genbeam
	TslInst[] collectGenbeamTslsByName(GenBeam gb, String names[])
	{
		TslInst out[0];
	
		Entity ents[] = gb.eToolsConnected();
		
		for (int i=0;i<ents.length();i++) 
		{ 
			Entity& e = ents[i];
			TslInst t = (TslInst)e;
			if (t.bIsValid() && t!=_ThisInst)
			{ 
				reportNotice("\n"+scriptName() + " " + e.handle() + e.formatObject("@(scriptName:D) @(type:D) @(Style:D)")); 
				if (names.length()==0 || (names.length()>0 && names.findNoCase(t.scriptName(),-1)>-1))
					out.append(t);				
			}
			 
		}//next i
		
		return out;
		
	}//End collectGenbeamTslsByName //endregion
	
	//region Function collectGenbeamTsls
	// collects tsls attached to a genbeam
	// names: the scriptnames to be acxcepted, empty = all
	// gb: the genbeam
	TslInst[] collectGenbeamTsls(GenBeam gb)
	{
		TslInst out[0];
	
		Entity ents[] = gb.eToolsConnected();		
		for (int i=0;i<ents.length();i++) 
		{ 
			TslInst t = (TslInst)ents[i];
			if (t.bIsValid() && t!=_ThisInst)
				out.append(t);				 
		}//next i
		
		return out;
		
	}//End collectGenbeamTsls //endregion	
	
//endregion

//region bOnJig
	if (_bOnJig && _kExecuteKey=="ChangeGrain") 
	{
		//
	    Point3d pt1 = _Map.getPoint3d("pt1"); // set by second argument in PrPoint
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point
	    String sBlockName = _Map.getString("BlockName");
	    PLine plGrain = _Map.getPLine("plGrain");
	    int bDrawBlock = sBlockName.length()>0 && _BlockNames.findNoCase(sBlockName ,- 1) >- 1;
	    Vector3d vecZ = _Map.getVector3d("vecZ");
	    Vector3d vecGrain= _Map.getVector3d("vecGrain");
	    int nColor = _Map.getInt("Color");
	    double dScale = _Map.getDouble("scale");
	    
	    Line(ptJig, vecZ).hasIntersection(Plane(pt1, vecZ), ptJig);
	    
	    Vector3d vecX = ptJig - pt1;
	    vecX.normalize();
	    Vector3d vecY = vecX.crossProduct(-vecZ);
	    
	    //_ThisInst.setDebug(TRUE); // sets the debug state on the jig only, if you want to see the effect of vis methods
	    //ptJig.vis(1);

		Display dp(nColor);
		if (bDrawBlock)
		{
			dp.draw(Block(sBlockName), ptJig, vecX*dScale, vecY*dScale, vecZ*dScale);
			dp.draw(scriptName()+bDrawBlock + ":" +sBlockName, ptJig, vecX, vecY,1,0);
		}
		else
		{
			Point3d pts[] = plGrain.vertexPoints(true);
			Point3d ptMid;
			ptMid.setToAverage(pts);
			plGrain.transformBy(pt1- ptMid);
			
			CoordSys csRot;
			csRot.setToRotation(vecGrain.angleTo(vecX, vecZ), vecZ, pt1);
			plGrain.transformBy(csRot);
				
			double dY = abs(vecY.dotProduct(plGrain.ptEnd() - plGrain.ptStart()))*.05;
		
			PLine pl2 = plGrain;
			plGrain.offset(dY, false);
			pl2.offset(-dY, false);
			pl2.reverse();
			plGrain.append(pl2);
			plGrain.close();
			
			dp.draw(PlaneProfile(plGrain), _kDrawFilled, 50);
			dp.draw(plGrain);
			
			dp.draw(pl2);
			
		}

	    return;
	}
//End bOnJig//endregion 

//region DialogMode
	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode>0)
	{ 
		if (nDialogMode == 1) // specify index when triggered to get different dialogs
		{
			setOPMKey("Settings");
			
		category = T("|Display|");
			String sHiddenQualityListName=T("|Suppress Plan View Qualities|");	
			// 0
			PropString sHiddenQualityList(nStringIndex++, "", sHiddenQualityListName);	
			sHiddenQualityList.setDescription(T("|Defines a list of qualities which will be suppressed in plan view|") + T("|Separate entries by semicolon ';'|"));
			sHiddenQualityList.setCategory(category);
			if (sTextAligns.findNoCase(sHiddenQualityList ,- 1) >- 1)sHiddenQualityList.set(""); // legacy: property was used in different context

//			String sTextAlignName=T("|Text Alignment|");	
//			PropString sTextAlign(nStringIndex++, sTextAligns, sTextAlignName);	
//			sTextAlign.setDescription(T("|Defines the alignment of the text|"));
//			sTextAlign.setCategory(category);
			
		category = T("|Solid Display|");
			String sShowSolidName=T("|Graindirection|");
			String sShowSolids[0]; sShowSolids = sNoYes;
			
			if (_BlockNames.findNoCase(sAssociationBlockNames[0],-1)>-1 || _BlockNames.findNoCase(sAssociationBlockNames[1],-1)>-1)
				sShowSolids.append(tByBlock);
			// 1
			PropString sShowSolid(nStringIndex++, sShowSolids, sShowSolidName);	
			sShowSolid.setDescription(T("|Defines wether the grain direction will be shown as 3D-Solid.|") + T(" |Solids can be used for a potential IFC export.| ") + T("|This setting will be overruled if custom grain direction blocks are found in the drawing.|"));
			sShowSolid.setCategory(category);
			
			String sWidthName=T("|Width|");	
			PropDouble dWidth(nDoubleIndex++, U(10), sWidthName);
			dWidth.setDescription(T("|Defines the width of the of the outline of the grain direction|"));
			dWidth.setCategory(category);
			
			String sShowSolidTextName=T("|3D-Text|");
			// 2
			PropString sShowSolidText(nStringIndex++, s3DTexts, sShowSolidTextName);
			sShowSolidText.setDescription(T("|Defines if text will be displayed as 3D represenation, requires TypeWRiter settings xml|"));
			sShowSolidText.setCategory(category);
			
			String sShowSolidGrainName=T("|3D-Grain|");
			// 3
			PropString sShowSolidGrain(nStringIndex++, s3DTexts, sShowSolidGrainName);
			sShowSolidGrain.setDescription(T("|Defines if grain will be displayed as 3D represenation, requires TypeWRiter settings xml|"));
			sShowSolidGrain.setCategory(category);
			
			String sOutlineWidthName=T("|Outline Width|");
			PropDouble dOutlineWidth(nDoubleIndex++, U(5), sOutlineWidthName);
			dOutlineWidth.setDescription(T("|Defines the outline width of a character if not defined as closed polyline|"));
			dOutlineWidth.setCategory(category);
			
		category = T("|Behaviour|");
			String sGrainMappingName=T("|Grain-Axis Relation|");
			// 4
			PropString sGrainMapping(nStringIndex++,sGrainMappings , sGrainMappingName,1);
			sGrainMapping.setDescription(T("|Defines wether the grain direction will be shown as 3D-Solid.|") + T(" |Solids can be used for a potential IFC export.| ") + T("|This setting will be overruled if custom grain direction blocks are found in the drawing.|"));
			sGrainMapping.setCategory(category);
			
			String sFloorFaceDirs[] = {tFDDisabled , tFDPosZ ,tFDNegZ };
			String sPreferredNestFaceFloorName=T("|Preferred Nesting Face Floor|");	
			// 5
			PropString sPreferredNestFaceFloor(nStringIndex++, sFloorFaceDirs, sPreferredNestFaceFloorName);
			sPreferredNestFaceFloor.setDescription(T("|Defines an override to the nesting orienation if the surface qualities of a panel do not differ.|") + T("|Only applicable if the panel is not aligned perpendicular to Z-World.|"));
			sPreferredNestFaceFloor.setCategory(category);
			
			// Association
			String sAssociationSettingPathPropName=T("|Association path|");	
			// 6
			PropString sAssociationSettingPathProp(nStringIndex++, "", sAssociationSettingPathPropName);	
			sAssociationSettingPathProp.setDescription(T("|Defines the Association path at extended data. Valid path consists of the property set name and the property name written as propSetName/propName|"));
			sAssociationSettingPathProp.setCategory(category);
			
		}
		return;
	}
//End DialogMode//endregion

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sFileName ="hsbGrainDirection";
	Map mapSetting;

// find settings file
	String sFolders[]=getFoldersInFolder(sPath); 
	int bPathFound;
	if (_bOnInsert)
		bPathFound= sFolders.find(sFolder)>-1?true:makeFolder(sPath+"\\"+sFolder);	
	String sFullPath = sPath+"\\"+sFolder+"\\"+sFileName+".xml";
	String sFile=findFile(sFullPath); 
	// if no settings file could be found in company try to find it in the installation path
	if (sFile.length()<1)sFile=findFile(_kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\"+sFileName+".xml");


// read a potential mapObject
	MapObject mo(sDictionary ,sFileName);
	if (mo.bIsValid())
	{
		mapSetting=mo.map();
		setDependencyOnDictObject(mo);
	}
	// create a mapObject to make the settings persistent	
	else if ((_bOnInsert || _bOnDebug) && !mo.bIsValid() && sFile.length()>0)
	{
		mapSetting.readFromXmlFile(sFile);
		mo.dbCreate(mapSetting);
	}
	int n3DText = mapSetting.getInt(k3DText); // { kDisabled, kRefSide, kTopSide, kBothSides};
	// HSB-23793
	int n3DGrain = mapSetting.getInt(k3DGrain); // { kDisabled, kRefSide, kTopSide, kBothSides};
	// path in extended data for association
	String sAssociationSettingPath;
	if(mapSetting.hasString("ExtendedDataAssociation"))
	{
		sAssociationSettingPath=mapSetting.getString("ExtendedDataAssociation");
	}
//End Settings//endregion

//region Settings TypeWriter
// settings prerequisites
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileNameTypeWriter ="TypeWriter";
	Map mapSettingTypeWriter;

// compose settings file location
	String sFullPathTypeWriter = sPath+"\\"+sFolder+"\\"+sFileNameTypeWriter+".xml";

// read a potential mapObject
	double dVersalHeight = U(100);
	MapObject moTypeWriter(sDictionary ,sFileNameTypeWriter);
	
	if (n3DText>0)
	{ 
		if (moTypeWriter.bIsValid())
		{
			mapSettingTypeWriter=moTypeWriter.map();
			setDependencyOnDictObject(moTypeWriter);
		}
		// create a mapObject to make the settings persistent	
		else if (!moTypeWriter.bIsValid() )
		{
			String sFileTypeWriter=findFile(sFullPathTypeWriter); 
		// if no settings file could be found in company try to find it in the installation path
			if (sFileTypeWriter.length()<1) sFileTypeWriter=findFile(sPathGeneral+sFileNameTypeWriter+".xml");	
			if (sFileTypeWriter.length()>0)
			{ 
				mapSettingTypeWriter.readFromXmlFile(sFileTypeWriter);
				moTypeWriter.dbCreate(mapSettingTypeWriter);			
			}
		}
		// validate version when creating a new instance
		if(_bOnDbCreated)
		{ 
			int nVersion = mapSetting.getInt("GeneralMapObject\\Version");
			String sFile = findFile(sPathGeneral + sFileNameTypeWriter + ".xml");		// set default xml path
			if (sFile.length()<1) sFile=findFile(sFullPathTypeWriter);				// set custom xml path if no default found
			Map mapSettingInstall; mapSettingInstall.readFromXmlFile(sFile);	// read the xml from installation directory
			int nVersionInstall = mapSettingInstall.getMap("GeneralMapObject").getInt("Version");		
			if(sFile.length()>0 && nVersion!=nVersionInstall)
				reportNotice(TN("|A different Version of the settings has been found for|") + sFileNameTypeWriter+
				TN("|Current Version| ")+nVersion + "	" + _kPathDwg + TN("|Other Version| ") +nVersionInstall + "	" + sFile);
		}		
	}

	Map mapFont, mapFonts, mapChars;
	String sFont;
//End Settings//endregion	

//region Properties
// General
	String sProductionTypeName =  T("|Production Type|");
	PropString sProductionType(1, sProductionTypesUI, sProductionTypeName);	
	sProductionType.setDescription(T("|Defines the orientation of the top layer during production.|") + " " + T("|The dimension perpendicular to the grain direction specifies the max production width|"));	
	sProductionType.setReadOnly(_bOnInsert?false:true);//HSB-13181
	
	PropDouble dMaxProductionWidth(1,U(3000), T("|Max. Production Width|"));
	dMaxProductionWidth.setDescription(T("|Sets the maximal production width and alerts the user if the woidth exceeds the value.|"));
	
	String sAssociationName=  T("|Association|");
	sAssociationsUI.append(T("|Automatic|"));
	PropString sAssociation(2, sAssociationsUI, sAssociationName);	
	sAssociation.setDescription(T("|Defines the association to a wall (W) or floor/roof(D)of the panel.|")+
		T("|Select <Automatic> if panels are derived from wall and roof elements, select type if derived from 2D Polylines|"));	

// display
	category = T("|Display|");	

	String sFormatName=T("|Format|");
	PropString sFormat(4,"@(PosNum)\P@(SurfaceQuality)",sFormatName);	
	sFormat.setDescription(T("|Defines the text and/or attributes.|") + " " + T("|Multiple lines are separated by| ") + " '\P'. " + T("|Attributes can also be added or removed by context commands.|"));
	sFormat.setCategory(category);

	PropString sDimStyle(0, _DimStyles.sorted(), T("|Dimstyle|"));	
	sDimStyle.setCategory(category);
		
	PropDouble dTxtH(0,U(60), T("|Text Height|"));
	dTxtH.setCategory(category);
	
	PropString sColor(3, "1;4", T("|Colors|"));		
	sColor.setDescription(sColorDescription);
	sColor.setCategory(category);
	
// display
	category = T("|Display|") + " " + T("Plan View");	
	PropDouble dTxtHPlan(2,U(60), T("|Text Height|")+" ");
	dTxtHPlan.setDescription(T("|Specifies the text height in plan view.|") + " " + T("|0 = do not display|"));
	dTxtHPlan.setCategory(category);			
//End Properties//endregion 

//region mapIO: support property dialog input via map on panel creation
	{
		int bHasPropertyMap = _Map.hasMap("PROPSTRING[]")  && _Map.hasMap("PROPDOUBLE[]");
		if (_bOnMapIO)
		{ 
			if (bHasPropertyMap)
				setPropValuesFromMap(_Map);	
			showDialog();
			_Map = mapWithPropValues();
			return;
		}
		if (_bOnDbCreated && bHasPropertyMap)
		{ 
			setPropValuesFromMap(_Map);
			_Map = Map();
		}	
	}		
//End mapIO: support property dialog input via map on element creation//endregion 

//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }

	// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();
		if (sKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			if (sEntries.findNoCase(sKey,-1)>-1)			
				setPropValuesFromCatalog(sKey);
			else
				showDialog();					
		}		
		else	
			showDialog();

		int nAssociation = sAssociationsUI.find(sAssociation);

	// selection set
		Entity ents[0];
		PrEntity ssE(T("|Select panels or elements which contain panels|"), Sip());	
		ssE.addAllowedClass(Element());
		if (ssE.go())
			ents= ssE.set();
		
	// collect sips
		Sip sips[0];
		for(int i = 0;i <ents.length();i++)
		{
			if(ents[i].bIsKindOf(Sip()))
			{
				Sip sip = (Sip)ents[i];
				
			// validate if any panelGrain tsl is applied
				Entity entTool[] = sip.eToolsConnected();
				int bOk=true;
				for (int t=0;t<entTool.length();t++)
				{
					TslInst tsl = (TslInst)entTool[t];
					if (!tsl.bIsValid())continue;
					String sName= tsl.scriptName().makeUpper();
					if (sName.find("GRAINDIRECTION",0)>-1)
					{
						bOk=false;
						break;
					}
				}
				if (!bOk)continue;
				
				Element el = sip.element();
				Vector3d vecGrain = sip.vecX();
			// element link is valid
				if (el.bIsValid())
				{
					if (el.bIsKindOf(ElementWall()))
						vecGrain =el.vecY();	
					else
						vecGrain =el.vecX();
				}
				if (sips.find(sip)<0)sips.append(sip);
				sip.setWoodGrainDirection(vecGrain);	
			}
			else if(ents[i].bIsKindOf(Element()))
			{
				Element el = (Element)ents[i];
				Sip childs[]=el.sip();
				for(int c= 0;c<childs.length();c++)
				{
					Sip sip = childs[c];
					
				// validate if any panelGrain tsl is applied
					Entity entTool[] = sip.eToolsConnected();
					int bOk=true;
					for (int t=0;t<entTool.length();t++)
					{
						TslInst tsl = (TslInst)entTool[t];
						if (!tsl.bIsValid())continue;
						String sName= tsl.scriptName().makeUpper();
						if (sName.find("GRAINDIRECTION",0)>-1)
						{
							bOk=false;
							break;
						}
					}
					if (!bOk)continue;

					
					Vector3d vecGrain = sip.vecX();
					if (el.bIsKindOf(ElementWall()))
						vecGrain =el.vecY();	
					else
						vecGrain =el.vecX();
					if (sips.find(sip)<0) sips.append(sip);
					sip.setWoodGrainDirection(vecGrain);
				}					
			}
		}

	// prepare tsl cloning
		TslInst tslNew; Map mapTsl; 
		GenBeam gbsTsl[1]; Entity entsTsl[]={}; Point3d ptsTsl[1];// = {};
		int nProps[]={};
		double dProps[]={dTxtH,dMaxProductionWidth,dTxtHPlan};
		String sProps[]={sDimStyle,sProductionType,sAssociation,sColor,sFormat};//sAssociationsUI[0]
		
		String sScriptname = scriptName();
		
	// create tsl
		for(int i = 0;i <sips.length();i++)
		{
			Sip& sip = sips[i];
			
			Vector3d vecX = sip.vecX();
			Vector3d vecY = sip.vecY();
			Vector3d vecZ = sip.vecZ(); 
			
			gbsTsl[0] = sip;
			ptsTsl[0]=sip.ptCen();
			
		// automatic association	
			if (nAssociation==2)
			{ 
				// on automatic
				// first check whether association is defined in extended data
				// if not then do automatic set as usual
				int bAssociationSetFromSetting;
				if(sAssociationSettingPath!="")
				{ 
					// path is defined to get the association from the extended data
					String sAssociationSettingPaths[]=sAssociationSettingPath.tokenize("/");
					if(sAssociationSettingPaths.length()==2)
					{ 
						String sPropSetName=sAssociationSettingPaths[0];
						String sPropSetProps[]={sAssociationSettingPaths[1]};
						
						Map mapAttachedSip=sip.getAttachedPropSetMap(sPropSetName,sPropSetProps);
						String sAssociationSetting = mapAttachedSip.getString(sPropSetProps[0]);
						if(sAssociationSetting.find(T("|Wall|"),-1,false)>-1)
						{ 
							// its a wall
							sProps[2] = sAssociationsUI[0];
							sProps[1] = sProductionTypesUI[0];
							bAssociationSetFromSetting=true;
						}
						else if(sAssociationSetting.find(T("|Roof|"),-1,false)>-1
							|| sAssociationSetting.find(T("|Floor|"),-1,false)>-1)
						{ 
							// its a roof or a floor
							sProps[2] = sAssociationsUI[1];
							bAssociationSetFromSetting=true;
						}
					}
				}
				if(!bAssociationSetFromSetting)
				{ 
				// element relation	
					Element el = sip.element();	
					if (el.bIsValid())
					{ 
						if (el.bIsKindOf(ElementWall()))
						{
							sProps[2] = sAssociationsUI[0];
							sProps[1] = sProductionTypesUI[0];
						}
						else
						{	sProps[2] = sAssociationsUI[1];if(bDebug)reportMessage("\ncaseB");	}		
					}
				// no element relation
					else
					{ 
					// roof / floor	
						if (!vecZ.isPerpendicularTo(_ZW) && !vecZ.isParallelTo(_ZW))
						{	sProps[2] = sAssociationsUI[1];if(bDebug)reportMessage("\ncase0");	}
						
					// wall
						else if (vecZ.isPerpendicularTo(_ZW))//// HSBCAD-647   vecX.isParallelTo(_XW) || 
						{	sProps[2] = sAssociation.set(sAssociationsUI[0]);if(bDebug)reportMessage("\ncase1");}
					// anything else will be also roof/floor		
						else
						{	sProps[2] = sAssociationsUI[1];	if(bDebug)reportMessage("\ncase2");	}
					}
				}
			}
			tslNew.dbCreate(scriptName() , vecX ,vecY,gbsTsl, entsTsl, ptsTsl, 
				nProps, dProps, sProps,_kModelSpace, mapTsl);				
		}
		eraseInstance();
		return;
	}	
//end on insert________________________________________________________________________________//endregion 

//region Standards
	setEraseAndCopyWithBeams(_kBeam0);
	setKeepReferenceToGenBeamDuringCopy(_kBeam0);
	//sAssociation.setReadOnly(true); // disabled HSB-8771
	
// validate
	if (_Sip.length()<1)
	{
		reportMessage("\n" + T("|No panel reference found.|"));
		//eraseInstance();
		return;	
	}
	Sip sip = _Sip[0];
	SipStyle style(sip.style());

// set dependency and assignment
	if (_Entity.find(sip)<0)_Entity.append(sip);
	setDependencyOnEntity(sip);	
	assignToGroups(sip, 'I');
	
	// HSB-20302 make sure grainDirection will be executed as last attched tsl
	{ 
		int maxSeq = 1000;
		TslInst tsls[]=collectGenbeamTsls(sip);
		for (int i=0;i<tsls.length();i++) 
		{ 
			int seq = tsls[i].sequenceNumber(); 
			if (seq>maxSeq)
				maxSeq = seq;
		}//next i
		maxSeq++;
		_ThisInst.setSequenceNumber(maxSeq);
		//reportNotice("\n"+ scriptName() + " Seq# " + _ThisInst.sequenceNumber());
	}
	
// assign colors // HSB-18924 allow coma or semicolon separation of color association
	int nColor1=-1, nColor2=-1;
	{ 
		int bHasComma = sColor.find(",",0,false)>-1;
		int bHasSemicolon = sColor.find(";",0,false)>-1;
		
		String tokens[0];
		// default
		tokens= sColor.tokenize(";");
		if(bHasSemicolon)
			tokens= sColor.tokenize(";");		
		else if(bHasComma)
			tokens= sColor.tokenize(",");		

		if (tokens.length()>0)
			nColor1 = tokens[0].trimLeft().trimRight().atoi();	
		if (tokens.length()>1)
			nColor2 = tokens[1].trimLeft().trimRight().atoi();	
		else
			nColor2 = nColor1;
	}
	int nColors[] = {nColor1, nColor2};	
		
// ints
	int nAssociation = sAssociationsUI.find(sAssociation);
	if (nAssociation<0) // fall back to wall
	{ 
		nAssociation = 0;
		sAssociation.set(sAssociationsUI[nAssociation]);
	}
	int nProductionType= sProductionTypesUI.find(sProductionType);
	

// get grain direction	
	Vector3d vxGrain = sip.woodGrainDirection();	
	Vector3d vx = sip.vecX();
	Vector3d vy = sip.vecY();
	Vector3d vz = sip.vecZ();	
	double dZ = sip.dH();
	
// automatic assignment on creation
	if (((_bOnDbCreated || _kNameLastChangedProp==sAssociationName) && nAssociation==2) || vxGrain.bIsZeroLength())//HSB-8966
	{ 
		// on automatic
		// first check whether association is defined in extended data
		// if not then do automatic set as usual
		int bAssociationSetFromSetting;
		if(sAssociationSettingPath!="")
		{ 
			// path is defined to get the association from the extended data
			String sAssociationSettingPaths[]=sAssociationSettingPath.tokenize("/");
			if(sAssociationSettingPaths.length()==2)
			{ 
				String sPropSetName=sAssociationSettingPaths[0];
				String sPropSetProps[]={sAssociationSettingPaths[1]};
				
				Map mapAttachedSip=sip.getAttachedPropSetMap(sPropSetName,sPropSetProps);
				String sAssociationSetting = mapAttachedSip.getString(sPropSetProps[0]);
				if(sAssociationSetting.find(T("|Wall|"),-1,false)>-1)
				{ 
					// its a wall
					sAssociation.set(sAssociationsUI[0]);
					sProductionType.set(sProductionTypesUI[0]);
					bAssociationSetFromSetting=true;
					// set vxGrain
					Element el = sip.element();
					if (el.bIsValid())
					{ 
						vxGrain = el.vecY();
					}
					else
					{ 
						if(vz.isPerpendicularTo(_ZW))
						{ 
							Quader qdr(sip.ptCen(), vx, vy, vz, sip.solidLength(), sip.solidWidth(), sip.solidHeight(), 0, 0, 0);
							vxGrain = qdr.vecD(_ZW);
						}
						else
						{ 
							vxGrain = sip.vecX();
						}
					}
				}
				else if(sAssociationSetting.find(T("|Roof|"),-1,false)>-1
					|| sAssociationSetting.find(T("|Floor|"),-1,false)>-1)
				{ 
					// its a roof or a floor
					sAssociation.set(sAssociationsUI[1]);
					bAssociationSetFromSetting=true;
					// set vxGrain
					vxGrain = sip.vecX();
				}
			}
		}
		if (!bAssociationSetFromSetting)
		{
			// element relation	
			Element el = sip.element();
			if (el.bIsValid())
			{
				if (el.bIsKindOf(ElementWall()))
				{
					vxGrain = el.vecY();
					sAssociation.set(sAssociationsUI[0]);
					sProductionType.set(sProductionTypesUI[0]);
				}
				else
				{
					vxGrain = el.vecX();
					sAssociation.set(sAssociationsUI[1]);
				}
			}
			
			// no element relation
			else
			{
				// roof / floor	
				if ( ! vz.isPerpendicularTo(_ZW) && !vz.isParallelTo(_ZW))
				{
					vxGrain = sip.vecX();
					sAssociation.set(sAssociationsUI[1]);
				}
				
				// wall
				else if (vz.isPerpendicularTo(_ZW))
				{
					Quader qdr(sip.ptCen(), vx, vy, vz, sip.solidLength(), sip.solidWidth(), sip.solidHeight(), 0, 0, 0);
					vxGrain = qdr.vecD(_ZW);
					sAssociation.set(sAssociationsUI[0]);
				}
				// anything else will be also roof/floor		
				else
				{
					vxGrain = sip.vecX();
					sAssociation.set(sAssociationsUI[1]);
				}
			}
		}
		sip.setWoodGrainDirection(vxGrain);
		nAssociation = sAssociationsUI.find(sAssociation);
		nProductionType= sProductionTypesUI.find(sProductionType);
	}
	
// control panels coordSys based on settings
	int nColor = nColors[(nAssociation>1?0:nAssociation)];//HSB-8966
	int nGrainMapping;
	int nShowSolid = mapSetting.getInt("ShowSolid");
	
	double d3DThickness = U(2);
	
	double dWidth3DGrain;
	if (mapSetting.hasDouble(kWidthGrain)) dWidth3DGrain = mapSetting.getDouble(kWidthGrain);
	dWidth3DGrain = dWidth3DGrain <= 0 ? U(10):dWidth3DGrain;
	
	double dWidthOutline;
	if (mapSetting.hasDouble(kWidthOutline)) dWidthOutline = mapSetting.getDouble(kWidthOutline);
	dWidthOutline = dWidthOutline <= 0 ? U(5):dWidthOutline;
	
	int nTextOrientation = _kModel;
	// 0 = _kModel (Default)
	// 1 = _kDevice
	// 2 = _kDeviceX	
	if (mapSetting.hasInt("GrainMapping"))
	{
		nGrainMapping = mapSetting.getInt("GrainMapping");
	// align X-Axis with grain direction
		if (nGrainMapping==1 && !vxGrain.isCodirectionalTo(vx))
			sip.setXAxisDirectionInXYPlane(vxGrain);
	// align Y-Axis with grain direction
		else if (nGrainMapping==2 && !vxGrain.isCodirectionalTo(vy))
			sip.setXAxisDirectionInXYPlane(vxGrain.crossProduct(-vz));
		vx = sip.vecX();
		vy = sip.vecY();
		vx.vis(_Pt0,1);
		vy.vis(_Pt0,3);
		vz.vis(_Pt0,150);
	}
//End Standards//endregion 

//region Read Settings
	String sHiddenQualities[0];// collect qualities which should not be displayed in planview layout if any defined in settings
	Map mapNestingPreference;
	{ 
		String k;
		Map m;
		m = mapSetting.getMap("Display");
		k="TextOrientation";		if (m.hasInt(k))		nTextOrientation=m.getInt(k);	
		
		if (nAssociation==1) // Floor
			mapNestingPreference = mapSetting.getMap("Nesting\Floor");
		
		k="Display\\PlanView\\SurfaceQuality[]";
		m = mapSetting.getMap(k);
		for (int i=0;i<m.length();i++)
		{ 
			String sHiddenQuality = m.getString(i).makeUpper();
			if (sHiddenQualities.find(sHiddenQuality)<0)
				sHiddenQualities.append(sHiddenQuality);
		}	
	}
//End Read Settings//endregion 

//region Displays
// collect disprep names
	String sDispRepNames[] = _ThisInst.dispRepNames();	
	String sDispRepName = "GeneralCLT";
	int bDispRepName= sDispRepNames.find(sDispRepName)>-1;
	
// Displays
	Display dp(nColor), dpRef(nColor), dpTop(nColor), dpModel(nColor), dpPlan(nColor);
	double textHeight = dTxtH > dEps ? dTxtH : dp.textHeightForStyle("O", sDimStyle);
	
	// General
	dp.showInDxa(true);
	if (bDispRepName)dp.showInDispRep(sDispRepName);
	dp.dimStyle(sDimStyle);
	dp.textHeight(textHeight);
	if (vz.isPerpendicularTo(_ZW))dp.addHideDirection(_ZW);
	dp.addHideDirection(-vz);
	dp.addHideDirection(vz);	
	
	// Ref Side
	if (bDispRepName) dpRef.showInDispRep(sDispRepName);
	dpRef.dimStyle(sDimStyle);
	dpRef.textHeight(textHeight);
	dpRef.addViewDirection(-vz);
	
	// Top Side
	if (bDispRepName)dpTop.showInDispRep(sDispRepName);	
	dpTop.dimStyle(sDimStyle);
	dpTop.textHeight(textHeight);
	dpTop.addViewDirection(vz);

	// Model
	if (n3DText>0)
	{ 
		if (bDispRepName)dpModel.showInDispRep(sDispRepName);
		dpModel.showInDxa(true);
		dpModel.addHideDirection(vx);
		dpModel.addHideDirection(-vx);
		dpModel.addHideDirection(vy);
		dpModel.addHideDirection(-vy);
		dpModel.addHideDirection(vz);
		dpModel.addHideDirection(-vz);			
	}
	
	// Plan
	if (bDispRepName)dpPlan.showInDispRep(sDispRepName);
	dpPlan.dimStyle(sDimStyle);	
	dpPlan.textHeight(dTxtHPlan);
	dpPlan.addViewDirection(_ZW);
			
//endregion 


//region Events
// ref point
	Point3d ptCen=sip.ptCentreOfGravity();
	_Pt0=_Pt0-vz*vz.dotProduct(_Pt0-sip.ptCen());
	Point3d ptRef=_Pt0;
	ptCen.vis(4);
	
	double dLL=4*textHeight;

// triggers
	String sTriggerGrainRotate= T("|Rotate grain direction|");
	String sTriggerGrainDirection = T("|Change grain direction|");
	
// define event on which property set data will be written
	int bWritePropSet = _bOnDbCreated;
	String sWritePropsetTriggers[] = {sTriggerGrainRotate,sTriggerGrainDirection};
	if (_bOnRecalc || sWritePropsetTriggers.find(_kExecuteKey)>-1)
		bWritePropSet =true;
		
	String sPropertyTriggers[] = {sProductionTypeName,sAssociationName};	
	if(sPropertyTriggers.find(_kNameLastChangedProp)>-1)
		bWritePropSet =true;
	
// on the event of dragging the entity relocate if required
	PlaneProfile ppTest(sip.coordSys());
	ppTest.joinRing(sip.plEnvelope(), _kAdd);
	if (ppTest.pointInProfile(_Pt0)==_kPointOutsideProfile)
	{ 
		PlaneProfile pp2 = ppTest;
		pp2.shrink(.5 * dLL);
		if (pp2.area()<pow(dEps,2))
			pp2 = ppTest;
		_Pt0 = pp2.closestPointTo(_Pt0);
		setExecutionLoops(2);
	}
//End Events//endregion 

//region Trigger
// add direction trigger
	addRecalcTrigger(_kContextRoot, sTriggerGrainRotate);
	if (_bOnRecalc && (_kExecuteKey==sTriggerGrainRotate  || _kExecuteKey == sDoubleClick)) 
	{
		vxGrain = vxGrain.crossProduct(-vz);	
		sip.setWoodGrainDirection(vxGrain);

	// alter production type simultaneously version 1.7
		if (nProductionType==0) sProductionType.set(sProductionTypesUI[1]);
		else if (nProductionType==1) sProductionType.set(sProductionTypesUI[0]);
		nProductionType= sProductionTypesUI.find(sProductionType);
		
	// control axis direction on dependency of the selected production type
		if (nProductionType==0 && nGrainMapping==0) //sProductionTypes[] = {"Transverse", "Lengthwise"};
		{
			Vector3d vyGrain = vxGrain.crossProduct(-vz);
			sip.setXAxisDirectionInXYPlane(vyGrain);
		}	
		else if (nProductionType==1 && nGrainMapping==0) //sProductionTypes[] = {"Transverse", "Lengthwise"};
		{
			sip.setXAxisDirectionInXYPlane(vxGrain);
		}
		vx = sip.vecX();
		vy = sip.vecY();
		setExecutionLoops(2);
		
		if (!bWritePropSet)return;		
		 
	}	

	Vector3d vyGrain = vxGrain.crossProduct(-vz);	
	
// add project path update trigger
	String sTriggerUpdatePath =T("|Update Project Path|");
	addRecalcTrigger(_kContext, sTriggerUpdatePath);
	int bUpdatePath=_bOnDbCreated;
	if (_bOnRecalc && _kExecuteKey==sTriggerUpdatePath) 
	{
		bUpdatePath=true;
		bWritePropSet =true;
	}	
//End Trigger//endregion 

//endregion END Part #1

//region Part #2

// reading directions
	Vector3d vxRead = vxGrain;
	Vector3d vyRead = vyGrain;
	if ((vz.isParallelTo(_ZW) && _YW.dotProduct(vyRead)<0) ||
		vyRead.isParallelTo(_ZW) && !vyRead.isCodirectionalTo(_ZW))
	{
		vxRead*=-1;
		vyRead*=-1;	
	}
	Vector3d vecViewX=getViewDirection(0);
	Vector3d vecViewY=getViewDirection(1);
	Vector3d vecViewZ=getViewDirection(2);
	
	if(vecViewX.dotProduct(vxRead)<0)
	{ 
		vxRead*=-1;
	}
	if(vecViewY.dotProduct(vyRead)<0)
	{ 
		vyRead*=-1;	
	}

// validate production width
	if (dMaxProductionWidth>=dEps)
	{
		Vector3d vecXTest = vxGrain;
		Vector3d vecYTest = vyGrain;
		if (nProductionType==1)
		{
			vecXTest = vyGrain;
			vecYTest = vxGrain;
		}
		LineSeg seg = PlaneProfile(sip.plShadow()).extentInDir(vecXTest );

		double dThisProductionWidth=abs(vecXTest.dotProduct(seg.ptStart()-seg.ptEnd()));
		double dThisProductionLength=abs(vecYTest.dotProduct(seg.ptStart()-seg.ptEnd()));
				
		if (dThisProductionWidth>dMaxProductionWidth+dEps && dThisProductionLength<dThisProductionWidth)
		{

		// on creation auto correct production type
			//if (_bOnDbCreated)				
			{
			// alter production type simultaneously version 1.7
				if (nProductionType==0) sProductionType.set(sProductionTypesUI[1]);
				else if (nProductionType==1) sProductionType.set(sProductionTypesUI[0]);
				nProductionType= sProductionTypesUI.find(sProductionType);	
				setExecutionLoops(2);
							
			}
		}
		else if (dThisProductionWidth>dMaxProductionWidth+dEps && dThisProductionLength>=dThisProductionWidth)
		{
			reportMessage("\n" + T("|Warning|") + ": " + T("|Panel|") +" " + sip.posnum() + " " +T("|exceeds the maximal production width|") + " " + dThisProductionWidth + ">"+ dMaxProductionWidth);
		// draw warning in another color
			int nRedColors[] = {1,10,20,240};
			int nWarningColor = 1;
			if (nRedColors.find(nColor)>-1)nWarningColor =220;
			Display dpWarning(nWarningColor);
			dpWarning.textHeight(dTxtH*2);
			dpWarning.draw("!",ptRef ,vxRead ,vyRead ,0,0);	
		}

	}
	


// collect quality and overrides
	String sqTop,sqBottom; 	
	sqTop = sip.surfaceQualityOverrideTop();
	if (sqTop.length() < 1)sqTop = style.surfaceQualityTop();
	if (sqTop.length() < 1)sqTop = "?";
	int nQualityTop = SurfaceQualityStyle(sqTop).quality();
	
	sqBottom = sip.surfaceQualityOverrideBottom();
	if (sqBottom.length() < 1)sqBottom = style.surfaceQualityBottom();
	if (sqBottom.length() < 1)sqBottom = "?";
	int nQualityBottom = SurfaceQualityStyle(sqBottom).quality();	
	String sQualities[] ={ sqTop, sqBottom};
		

// add/write property set if applicable
	if (bWritePropSet) // HSB-13805	
	{
		String sPropertyNames[]={"PRODUCTIONTYPE", "PROJECTPATH", "ASSOCIATION"};
		String sAvailablePropSetNames[] = Sip().availablePropSetNames();
		int debugPS=false;
	// loop available property sets	
		for (int f=0; f<sAvailablePropSetNames.length();f++)
		{
			if (debugPS)reportNotice("\n	" +sAvailablePropSetNames[f]);	
			
		// try to attach the property set	
			int bAttachMe = sip.attachPropSet(sAvailablePropSetNames[f]);
			Map map = sip.getAttachedPropSetMap(sAvailablePropSetNames[f], sPropertyNames);	

		// validate if the first property of the sPropertyNames can be found	
			int bOk=false;
			for (int m=0;m<map.length();m++)
			{
				if (debugPS)reportNotice("\n		property " + m + " = " + map.keyAt(m));
				if (map.keyAt(m).makeUpper()==sPropertyNames[0].makeUpper())
				{
					bOk=true;
					break;
				}	
			}				
			
		// if it does not contain this property and it was attached bythis tool remove it	
			if (!bOk && bAttachMe)
			{
				sip.removePropSet(sAvailablePropSetNames[f]);
				if (debugPS)reportNotice("\n" +sAvailablePropSetNames[f]+ "		removed");	
				continue;
			}
		
		// write production type and association to the propertyset map	// HSB-13805
			if (nProductionType>-1)
				map.setString(sPropertyNames[0],sProductionTypes[nProductionType]); 	// store the untranslated value in the property set
			if (nAssociation>-1)
				map.setString(sPropertyNames[2],sAssociations[nAssociation]); 	// store the untranslated value in the property set	
			if (bUpdatePath && map.hasString(sPropertyNames[1]))
			{
				map.setString(sPropertyNames[1],_kPathDwg); 
				reportMessage("\n"+ T("|Project path|") + " " + _kPathDwg + " " + T("|saved with panel|") + " " + sip.posnum());
			}
			//version value="2.7" date="15jul16" author="thorsten.huck@hsbcad.com"> auto value of sublabel2 removed
			//sip.setSubLabel2(sProductionType+"_" + sQualities[0]+ "_" + sQualities[1]);
		// set properties map
			sip.setAttachedPropSetFromMap(sAvailablePropSetNames[f], map, sPropertyNames);				
			if (bOk)break;	
					
		}// next f: loop available property sets

	}// END IF // add/write property set if applicable	
	

// declare dim request map
	Map mapRequests, mapRequest;

//endregion END Part #2


//region Preferreed Nesting Face Override // HSB-16887
	Vector3d vecNestFace; // the default nesting face
	String sFaceDirectionFloor = tFDDisabled;
	if (nQualityBottom==nQualityTop && mapNestingPreference.length()>0)
	{ 
		vecNestFace = -vz; // the default nesting face
		Vector3d vecPrefDir = mapNestingPreference.getVector3d(kPreferredTopFace);
		if (vecPrefDir.bIsZeroLength())
			sFaceDirectionFloor = tFDDisabled;
		else if (vecPrefDir.dotProduct(_ZW)>0)
			sFaceDirectionFloor = tFDPosZ;
		else
			sFaceDirectionFloor = tFDNegZ;

		if(_Map.hasVector3d(kPreferredTopFace))
			vecPrefDir= _Map.getVector3d(kPreferredTopFace);

		
		if (!vecPrefDir.bIsZeroLength() && !vecPrefDir.isPerpendicularTo(vz))
		{ 
			if (vecPrefDir.dotProduct(vecNestFace)<0)
				vecNestFace *= -1;
				
			vecNestFace.vis(_Pt0, 40);	
		}
		else
			vecNestFace = Vector3d(0, 0, 0);	
	}
//endregion 


//region FORMAT and draw text in panel view

	//region Convert format to @ syntax
	// Versions prior 4.5 HSB-6215 worked with a semicolon separated list (i.e. 'Name;Posnum;Style') instead of the @(Syntax)
	if (sFormat.find(";",0)>-1 && sFormat.find("@",0)<0)
	{ 
		String sVariables[] = sip.formatObjectVariables();
		String keys[] = sFormat.tokenize(";");
		String newFormat;
		for (int i=0;i<keys.length();i++) 
		{ 
			String key = keys[i].trimLeft().trimRight();
			if (sVariables.findNoCase(key,-1)>-1)
			{
				newFormat += newFormat.length() > 0 ? "\P" : "";
				newFormat += "@(" + keys[i] + ")";
			} 
		}//next i
		if (newFormat.length()>0)
		{ 
			//reportMessage(TN("|updating format| ") + sip.posnum() + " " + sip.handle());
			
			sFormat.set(newFormat);
			setCatalogFromPropValues(sLastInserted);
			setExecutionLoops(2);
			return;
		}
	}	
	//End Convert format to @ syntax
	//endregion


// Add additional variables which are currently not supported by core	
	Map mapAdditional;
	
	mapAdditional.setString("SurfaceQuality", sqTop + "(" + sqBottom + ")");
	mapAdditional.setString("SurfaceQualityTop", sip.formatObject("@(SurfaceQualityTopStyleDefinition.Name)"));
	mapAdditional.setString("SurfaceQualityBottom", sip.formatObject("@(SurfaceQualityBottomStyleDefinition.Name)"));
	mapAdditional.setString("SipComponentName", style.sipComponentAt(0).name());
	mapAdditional.setString("SipComponentMaterial", style.sipComponentAt(0).material());
	mapAdditional.setString("Symbol","");
	mapAdditional.setInt("IsFloor", nAssociation);// store association 0 = wall, 1 = floor
	mapAdditional.setString("GrainDirection",sProductionType);	

// prefeered nesting face
	if (!vecNestFace.bIsZeroLength())
	{ 
		//reportNotice(("\nupdating "+ sip.posnum() + " vecFace " + vecNestFace));
		mapAdditional.setVector3d("vecNestFace",vecNestFace);
		mapAdditional.setString("NestingFace",vecNestFace.dotProduct(vz)>0? T("|Reference Side|") : T("|Top Side|"));
	}

	// get weight and write to property of propSet if found
	{ 
	
		Map mapIO;
		Map mapEntities;
		mapEntities.appendEntity("Entity", sip);
		mapIO.setMap("Entity[]",mapEntities);
		TslInst().callMapIO("hsbCenterOfGravity", mapIO);
		Point3d ptCen = mapIO.getPoint3d("ptCen");// returning the center of gravity
		double dNetWeight= mapIO.getDouble("Weight");// returning the weight
		mapAdditional.setDouble("Weight", dNetWeight,_kNoUnit);	
	}
	sip.setSubMap("ExtendedProperties", mapAdditional );
	sip.setSubMapX("ExtendedProperties", mapAdditional);
	sFormat.setDefinesFormatting(sip, mapAdditional);	

// Collect formats by line
	String sFormats[0];
	int bHasFormatTop, bHasFormatRef, bHasFormatRefTop;
	int nLineIndexRef=-1, nLineIndexTop=-1; // store the index of the line of SurfaceQualityBottom and SurfaceQualityTop
	if (sFormat.find("@",0)>-1)
	{ 
		String source = sFormat;
		int an = source.find("\n", 0);
		int ap = source.find("\\P", 0, false);
		int a = ap >- 1 && (ap < an || an<0) ?ap : an;
		
		while (a>-1 && source.length()>0)
		{ 
			String L = source.left(a-(ap>-1 && (ap<an || an<0)?0:1));
			String R = source.right(source.length()-a-(ap>-1 && (ap < an || an<0)?2:1));
			sFormats.append(L);
			source = R;

			int bHasTop = L.find("@(SurfaceQualityTop", 0, false)>-1;
			int bHasRef = L.find("@(SurfaceQualityBottom", 0, false)>-1;
			int bHasRefTop = L.find("@(SurfaceQuality", 0, false)>-1 && !bHasRef && !bHasTop; 
		
			if (bHasTop || bHasRefTop) nLineIndexTop=sFormats.length()-1;
			if (bHasRef || bHasRefTop) nLineIndexRef=sFormats.length()-1;

			an = source.find("\n", 0);
			ap = source.find("\\P", 0, false);
			a = ap >- 1 && (ap < an || an<0) ?ap : an;
		}
		
		int bHasTop = source.find("@(SurfaceQualityTop", 0, false)>-1;
		int bHasRef = source.find("@(SurfaceQualityBottom", 0, false)>-1;
		int bHasRefTop = source.find("@(SurfaceQuality", 0, false)>-1 && !bHasRef && !bHasTop; 
		
		if (bHasTop )nLineIndexTop=sFormats.length()-1; // || bHasRefTop
		if (bHasRef || bHasRefTop) nLineIndexRef=sFormats.length()-1;//HSB-18497 // 
		
		sFormats.append(source);		
	}
	
	
//region Collect display text as array
	String sLines[0], sTopLines[0], sRefLines[0], sPlanTopLines[0],sPlanRefLines[0] ;
	// HSB-19791
	String sTopLinesSide[0],sRefLinesSide[0];
	
	int bHasQualityTop,bHasQualityBottom;
	String sQualityTopTxt,sQualityBottomTxt;
// test if formatting resolves multiple lines
	int bIsMultiline = sFormat.find("\\P", 0, false) >- 1 || sFormat.find("\n", 0, false) >- 1;	
//	if (bIsMultiline)
	for (int i=0;i<sFormats.length();i++) 
	{ 
		String format = sFormats[i]; 
		String text = sip.formatObject(format, mapAdditional); 	
		sLines.append(text);		

		int nTop = format.find("@(SurfaceQualityTop", 0, false);
		int nRef = format.find("@(SurfaceQualityBottom", 0, false);
		int nRefTop = (nTop<0 && nRef<0)?format.find("@(SurfaceQuality", 0, false):-1;

		int a = -1;
		if (nTop>-1)a=nTop;
		else if (nRef>-1)a=nRef;
		else if (nRefTop>-1)a=nRefTop;
		
	// quality format found
		if (a>-1)
		{ 
			int b = format.find(")", a+1, false);
			int c = nTop>-1?19:(nRef>-1?22:16);
			if (b > -1)
			{ 
				String L = format.left(a);
				String R = format.right(format.length()-b-1);
				String arg = format.right(format.length()-a-c);
				b = arg.find(")", 0, false);
				arg = arg.left(b+1);
				
			// get quality text and append top and ref line texts				
				String s, qualityRef, qualityTop;				
				if (nTop>-1)
				{
					qualityTop = sip.formatObject("@(SurfaceQualityTop"+arg, mapAdditional);
					s = L + qualityTop + R;
					if (s.length()>0)
					{
						sTopLines.append(s);
						// HSB-19791
						sTopLinesSide.append(s);
						bHasQualityTop=true;
						sQualityTopTxt=s;
					}
				}
				else if (nRefTop>-1)//HSB-18497
				{
					qualityTop = sip.formatObject("@(SurfaceQuality"+arg, mapAdditional);
					s = L + qualityTop + R;
					if (s.length()>0)
					{
//						sTopLines.append(s);
						
						
						s="";
						String _qualityTop = sip.formatObject("@(SurfaceQualityTop"+arg, mapAdditional);
						qualityTop=_qualityTop;
						s = L + _qualityTop + R;
						if (s.length()>0)
						{
							sTopLines.append(s);
							bHasQualityTop=true;
							sQualityTopTxt=s;
						}
						s="";
						String _qualityRef = sip.formatObject("@(SurfaceQualityBottom"+arg, mapAdditional);
						qualityRef=_qualityRef;
						s = L + _qualityRef + R;
						if (s.length()>0)
						{
							sRefLines.append(s);
							bHasQualityBottom=true;
							sQualityBottomTxt=s;
						}
					}
					
				// HSB-19791
					s="";
					String _qualityTop = sip.formatObject("@(SurfaceQualityTop"+arg, mapAdditional);
					s = L + _qualityTop + R;
					if (s.length()>0)
					{
						sTopLinesSide.append(s);
						bHasQualityTop=true;
						sQualityTopTxt=s;
					}
					
					s="";
					String _qualityRef = sip.formatObject("@(SurfaceQualityBottom"+arg, mapAdditional);
					s = L + _qualityRef + R;
					if (s.length()>0)
					{
						sRefLinesSide.append(s);
						bHasQualityBottom=true;
						sQualityBottomTxt=s;
					}
				}				
				if (nRef>-1)
				{
					qualityRef = sip.formatObject("@(SurfaceQualityBottom"+arg, mapAdditional);
					s = L + qualityRef + R;
					if (s.length()>0)
					{
						sRefLines.append(s);
						//HSB-19791
						sRefLinesSide.append(s);
						bHasQualityBottom=true;
						sQualityBottomTxt=s;
					}
				}
				
			// build plan view texts on top and ref side	
				if (qualityTop.length()>0 && sHiddenQualities.findNoCase(qualityTop,-1)<0)
					sPlanTopLines.append(L + qualityTop + R);
				if (qualityRef.length()>0 && sHiddenQualities.findNoCase(qualityRef,-1)<0)
					sPlanRefLines.append(L + qualityRef + R);
			}			
		}
		else
		{
		// HSB-19795:
			if (i>=nLineIndexTop && nLineIndexTop>-1)				
			{
				sPlanRefLines.append(text);
				sRefLines.append(text);
			}
			else
			{
				sPlanTopLines.append(text);
				sTopLines.append(text);
			}
			// HSB-19791
			sRefLinesSide.append(text);
			sTopLinesSide.append(text);
		}
	}//next i
	
	
	String text = sip.formatObject(sFormat, mapAdditional);

	String textRef, textTop,textPlanBot, textPlanTop;	
	for (int i=0;i<sTopLines.length();i++) 
	{
		String s = sip.formatObject(sTopLines[i], mapAdditional);//HSB-18497
		textTop+=(textTop.length()>0?"\\P":"")+ s; 
	}
	for (int i=0;i<sRefLines.length();i++) 
	{
		String s = sip.formatObject(sRefLines[i], mapAdditional);//HSB-18497
		textRef+=(textRef.length()>0?"\\P":"")+ s; 
	}
	// text for plan view
	for (int i=0;i<sPlanTopLines.length();i++) 
	{
		String s = sip.formatObject(sPlanTopLines[i], mapAdditional);//HSB-18497
		textPlanTop+=(textPlanTop.length()>0?"\\P":"")+ s; 
	}
	for (int i=0;i<sPlanRefLines.length();i++) 
	{
		String s = sip.formatObject(sPlanRefLines[i], mapAdditional);//HSB-18497
		textPlanBot+=(textPlanBot.length()>0?"\\P":"")+ s; 
	}		

	if (!bIsMultiline)//HSB-18497
	{ 
		textRef = text;
		textPlanBot = text;
	}
//endregion 

//region Draw Text
	Point3d ptTxtTop=_Pt0, ptTxtRef = _Pt0;
	
// panel view
{ 
	double dYTop=.5*(.5*dLL+dp.textHeightForStyle(textTop, sDimStyle, textHeight)) ;// HSB-19142 // + dp.textHeightForStyle(textTop, sDimStyle, textHeight)) ;
	double dYRef=.5*(.5*dLL+dp.textHeightForStyle(textRef, sDimStyle, textHeight)) ;
	
	ptTxtTop = ptRef + vz * (.5 * dZ + dEps)+vyRead*dYTop;	//ptTxtTop.vis(3);	
	if (n3DText==0)
		dp.draw(textTop,ptTxtTop,vxRead ,vyRead ,0,0,nTextOrientation);
	dpTop.draw(textTop,ptTxtTop,vxRead ,vyRead ,0,0,_kDevice);
	dpRef.draw(textTop, ptRef - vz * (.5 * dZ + dEps)-vyRead*dYTop ,vxRead ,vyRead ,0,0,_kDevice);
	
	ptTxtRef = ptRef - vz * (.5 * dZ + dEps)+vyRead*dYRef;
	if (n3DText==0)
		dp.draw(textRef,ptRef + vz * (.5 * dZ + dEps)-vyRead*dYRef,vxRead ,vyRead ,0,0,nTextOrientation);
	dpTop.draw(textRef,ptRef + vz * (.5 * dZ + dEps)-vyRead*dYRef ,vxRead ,vyRead ,0,0,_kDevice);		
	dpRef.draw(textRef,ptTxtRef,vxRead ,vyRead ,0,0,_kDevice);


// Dim Requests
	mapRequest.setInt("Color", nColor);
	mapRequest.setVector3d("AllowedView", vz);
	mapRequest.setInt("AlsoReverseDirection", true);										
	mapRequest.setDouble("textHeight",textHeight);	
	mapRequest.setString("dimStyle",sDimStyle);
	
	mapRequest.setVector3d("vecX", vxRead );
	mapRequest.setVector3d("vecY", vyRead );
	//mapRequest.setInt("deviceMode", _kDevice);
	mapRequest.setDouble("dXFlag", 0);
	
	mapRequest.setPoint3d("ptScale",ptRef);
	
	mapRequest.setPoint3d("ptLocation",ptRef +vyRead*dYTop);	//Point3d(ptRef +vyRead*dYTop).vis(4);
	mapRequest.setDouble("dYFlag", 0);//1.3			
	mapRequest.setString("text", textTop);	
	mapRequests.appendMap("DimRequest",mapRequest);		
	
	mapRequest.setPoint3d("ptLocation", ptRef -vyRead*dYRef );	//Point3d(ptRef -vyRead*dYRef).vis(2);
	mapRequest.setDouble("dYFlag", 0);//-1.3				
	mapRequest.setString("text", textRef);	
	mapRequests.appendMap("DimRequest",mapRequest);	


	if (nShowSolid > 0)
	{ 
		ptTxtTop+= vyRead * .5 * dWidth3DGrain;
		ptTxtRef-= vyRead * .5 * dWidth3DGrain;
	}
	
//// top text
//	ptTxtTop = ptRef - vz * (.5 * dZ + dEps);
//	Vector3d vecYOffset;
//	if (textTop.length()>0)
//	{ 
//		double dY = .5 * (.5 * dLL + dp.textHeightForStyle(textTop, sDimStyle, textHeight));
//		if (nShowSolid>0)
//			dY += .5 * dWidth3DGrain;	
//		vecYOffset = vyRead * dY;
//		ptTxtTop+= vecYOffset;		
//	}
//	if (n3DText==0)
//		dp.draw(textTop,ptTxtTop,vxRead ,vyRead ,0,0,nTextOrientation);
//	dpTop.draw(textTop,ptTxtTop,vxRead ,vyRead ,0,0,_kDevice);
////	dpRef.draw(textTop, ptTxtTop - vz  * (dZ + dEps) - vecYOffset,vxRead ,vyRead ,0,0,_kDevice);
////
////Point3d (ptTxtTop - vz * (dZ + dEps) - vecYOffset).vis(1);
//	dpRef.draw(textTop, ptRef - vz * (.5 * dZ + dEps) - vecYOffset,vxRead ,vyRead ,0,0,_kDevice);
//		
//	
//// ref text
//	vecYOffset = Vector3d();
//	ptTxtRef = ptRef - vz * (.5 * dZ + dEps);	
//	if (textRef.length()>0)
//	{ 	
//		double dY = .5 * (.5 * dLL + dp.textHeightForStyle(textRef, sDimStyle, textHeight));
//		if (nShowSolid>0)
//			dY += .5 * dWidth3DGrain;	
//		vecYOffset = -vyRead * dY;	
//		ptTxtRef+= vecYOffset;		
//	}
//	if (n3DText==0)
//		dp.draw(textRef,ptTxtRef,vxRead ,vyRead ,0,0,nTextOrientation);		
//	dpTop.draw(textRef,ptTxtRef,vxRead ,vyRead ,0,0,_kDevice);		
//	dpRef.draw(textRef,ptRef-vz*(.5 * dZ + dEps)+vecYOffset,vxRead ,vyRead ,0,0,_kDevice);	
//	
	
//region Draw preferred nesting face 
	if (!vecNestFace.bIsZeroLength())
	{ 
		PlaneProfile pp(CoordSys(ptCen, vxRead, vyRead, vxRead.crossProduct(vyRead)));
		{ 
			double dX = dp.textLengthForStyle(textTop, sDimStyle, textHeight);
			double dY = dp.textHeightForStyle(textTop, sDimStyle, textHeight);
			Vector3d vec = .5 * (vxRead * dX + vyRead * dY);
			PLine pl; pl.createRectangle(LineSeg(ptTxtTop - vec, ptTxtTop + vec), vxRead, vyRead);
			//pl.vis(2);	
			pp.joinRing(pl,_kAdd);
		}
		{ 
			double dX = dp.textLengthForStyle(textRef, sDimStyle, textHeight);
			double dY = dp.textHeightForStyle(textRef, sDimStyle, textHeight);
			Vector3d vec = .5 * (vxRead * dX + vyRead * dY);
			PLine pl; pl.createRectangle(LineSeg(ptTxtRef - vec, ptTxtRef + vec), vxRead, vyRead);
			//pl.vis(2);
			pp.joinRing(pl,_kAdd);
		}
		PLine pl; pl.createRectangle(pp.extentInDir(vyRead), vxRead, vyRead);
		pl.offset(.5 * textHeight, true);
		pl.transformBy(vecNestFace * .5 * dZ);
		//pl.vis(2);
		
		pp=PlaneProfile(pl);
		PlaneProfile ppx = pp;
		ppx.shrink(.25 * textHeight);
		pp.subtractProfile(ppx);
		
		Display dpNest(-1);
		int trueColor = vecNestFace.dotProduct(vz) > 0 ? darkyellow : lightblue;
		dpNest.trueColor(trueColor);
		dpNest.draw(pp, _kDrawFilled, 70);
		
		mapRequest = Map();
		mapRequest.setInt("TrueColor", trueColor);
		mapRequest.setVector3d("AllowedView", vecNestFace);
		mapRequest.setInt("DrawFilled",_kDrawFilled);
		mapRequest.setInt("Transparency",70);
		mapRequests.appendMap("DimRequest",mapRequest);	
	}
//endregion 	

}	

	//endregion 

//End FORMAT
//endregion 

// draw grain direction
// the grain direction is visualized by a pline symbol or by custom defined blocks. blocks have to be named'hsbGrainDirectionFloor' or 'hsbGrainDirectionWall'
	String sAssociationBlockName = sAssociationBlockNames[nAssociation];
	int bDrawBlock = _BlockNames.findNoCase(sAssociationBlockName ,- 1) >- 1 && nShowSolid==2;
	double dBlockScaleFactor = 1;
	PLine plGrainSymbol(vz), plGrain(vz);
//	for (int i=0;i<_BlockNames.length();i++) 
//	{ 
//		String sBlockName = _BlockNames[i]; 
//		bDrawBlock = sAssociationBlockName.makeLower() == sBlockName.makeLower();
//		if (bDrawBlock)break;
//	}
	//bDrawBlock = false;
	if (bDrawBlock)
	{
		Block block(sAssociationBlockName);
	
	// scale to size
		LineSeg seg = block.getExtents();
		double dX = abs(_XW.dotProduct(seg.ptStart() - seg.ptEnd()));
		if (dX<=dEps)
		{ 
			bDrawBlock = false;
			dBlockScaleFactor = dLL / dX;
		}
		else
			dBlockScaleFactor = dLL / dX;

		Vector3d vecXB = vxGrain * dBlockScaleFactor;
		Vector3d vecYB = vyGrain * dBlockScaleFactor;
		Vector3d vecZB = vecXB.crossProduct(vecYB);
		
		dp.draw(Block(sAssociationBlockName), ptRef, vecXB, vecYB, vecZB);
		dpRef.draw(Block(sAssociationBlockName), ptRef-vz*(.5 * dZ + dEps), vecXB, vecYB, vecZB);
		dpTop.draw(Block(sAssociationBlockName), ptRef+vz*(.5 * dZ + dEps), vecXB, vecYB, vecZB);

		mapRequest = Map();
		mapRequest.setInt("Color", nColor);
		mapRequest.setVector3d("AllowedView", vz);				
		mapRequest.setString("BlockName", sAssociationBlockName);
		mapRequest.setDouble("textHeight",textHeight);	// needed to scale the block for fit in view
		mapRequest.setPoint3d("ptLocation", ptRef);
		mapRequest.setVector3d("vecX", vxGrain*dBlockScaleFactor);
		mapRequest.setVector3d("vecY", vyGrain*dBlockScaleFactor);
		mapRequests.appendMap("DimRequest",mapRequest);			
	}

// draw grain direction symbol as pline
	if (!bDrawBlock)
	{ 	
		plGrainSymbol.addVertex(ptRef +  (vxGrain*.5*dLL - vyGrain*dLL/5));
		plGrainSymbol.addVertex(ptRef +  (vxGrain*dLL));	
		plGrainSymbol.addVertex(ptRef + (-vxGrain*dLL));	
		plGrainSymbol.addVertex(ptRef + (-vxGrain*.5*dLL + vyGrain*dLL/5));	
		plGrain = plGrainSymbol;
		
		mapRequest = Map();
		mapRequest.setInt("Color", nColor);
		mapRequest.setVector3d("AllowedView", vz);	
		//mapRequest.setInt("AlsoReverseDirection", true);			
		mapRequest.setPLine("pline", plGrainSymbol);
		mapRequest.setDouble("textHeight",textHeight);	// needed to scale the block for fit in view
		mapRequest.setPoint3d("ptScale", ptRef);
		
		mapRequests.appendMap("DimRequest",mapRequest);	
	
		//plGrainSymbol.vis(nColor);
		double d = (.5 * dZ + dEps);
		
	// the side of the 3D bodies	
		int nSide;
		if (n3DText == 1 || n3DText == 3)nSide = -1;
		else if (n3DText == 2)nSide = 1;
		
		if(n3DText==0)
		{ 
			// HSB-23793
			if (n3DGrain == 1 || n3DGrain == 3)nSide = -1;
			else if (n3DGrain == 2)nSide = 1;
		}
		
		plGrainSymbol.transformBy(-vz*d);
		if (!nShowSolid)
			dp.draw(plGrainSymbol);
		dpRef.draw(plGrainSymbol);
		plGrainSymbol.transformBy(vz*d*2);
		dpTop.draw(plGrainSymbol);
		plGrainSymbol.transformBy(-vz*d);
		
		if (nShowSolid)
		{
			PLine pl1 = plGrainSymbol;
			pl1.offset(.5*dWidth3DGrain, false);
			PLine pl2 = plGrainSymbol;
			pl2.offset(-.5*dWidth3DGrain, false);
			pl2.reverse();
			Point3d pts[] = pl2.vertexPoints(true);
			for (int i=0;i<pts.length();i++) 
				pl1.addVertex(pts[i]); 
			pl1.close();
			pl1.transformBy(vz * nSide * .5 * dZ);
			pl1.vis(2);

			// TODO try to suppress 3D in model but only export to IFC
//			Display dpIFC(2);
//			dpIFC.showInDispRep("hsb__ifc");
//			dpIFC.showInDxa(true);
//			dpIFC.addViewDirection(-_ZW);

			Body bd (pl1, vz * d3DThickness, nSide);		bd.vis(3);
			dpModel.draw(bd);
			if (n3DText==3)
			{ 
				bd.transformBy(vz * (dZ + d3DThickness));
				dpModel.draw(bd);
			}
			if(n3DText==0)
			{ 
				// HSB-23793
				if (n3DGrain==3)
				{ 
					bd.transformBy(vz * (dZ + d3DThickness));
					dpModel.draw(bd);
				}
			}
		}
	}
	
	
//region Draw formatting as 3D Solid	
	if (n3DText!=0)
	{
		Vector3d vecXT = vxGrain;
		Vector3d vecYT = vyGrain;
		
		if (vecYT.isParallelTo(_ZW) && !vecYT.isCodirectionalTo(_ZW))
		{ 
			vecXT *= -1;
			vecYT *= -1;
		}
		Vector3d vecZT = vecXT.crossProduct(vecYT);

	//region Get character definitions
		String sFontNames[0];
		mapFont;
		mapFonts= mapSettingTypeWriter.getMap("Font[]");
		for (int i=0;i<mapFonts.length();i++) 
		{ 
			Map m = mapFonts.getMap(i);
			String name = m.getMapName();
			if (name.length()>0 && sFontNames.findNoCase(name,-1)<0)
				sFontNames.append(name);	 
		}//next i
		sFontNames = sFontNames.sorted();
		
		// set default or get first existant font
		sFont = "Standard";
		if (sFontNames.findNoCase(sFont,-1)<0 && sFontNames.length()>0)
			sFont = sFontNames.first();
		
		// get font map
		
		for (int i = 0; i < mapFonts.length(); i++)
		{
			Map m = mapFonts.getMap(i);
			String name = m.getMapName();
			if (name.makeUpper() == sFont.makeUpper())
			{
				mapFont = m;
				double d = m.getDouble(kVersal);
				dVersalHeight = d > 0 ? d : U(100);
				break;
			}
		}
		
		// collect defined characters
		mapChars= mapFont.getMap("Character[]");
		String allChars[0];
		for (int i=0;i<mapChars.length();i++) 
		{ 
			Map m = mapChars.getMap(i); 
			if (!m.hasPLine(0)){ continue;}
			if (!m.hasPlaneProfile("box")){ continue;}
			
			String character = m.getMapName();
			if (allChars.find(character)<0)
				allChars.append(character);		 
		}//next i
		//endregion 
		
	// Draw 3D Text on top and reference side	
		if (sTopLines.length()>0 || sRefLines.length()>0)
		{ 
			double scale = textHeight / dVersalHeight;
			double pitch = dVersalHeight / 7;
			
			if (n3DText == 1 || n3DText == 2)
			{ 
				sTopLines.append("\\P");
				sTopLines.append(sRefLines);
				sRefLines.setLength(0);
//				sRefLines.append(sTopLines);
//				sTopLines.setLength(0);
			}
			else if (n3DText == 3)
			{ 
				sTopLines.append("\\P");
				sTopLines.append(sRefLines);
				sRefLines = sTopLines;
			}			
			
		// loop Z-faces top and ref	
			for (int f=0;f<2;f++) 
			{ 
				int face = f == 0 ? 1 :- 1;

				double dRowOffset;
//				String lines[0];lines = f==0?sTopLines:sRefLines;
				String lines[0];lines = f==0?sTopLinesSide:sRefLinesSide;
				Point3d ptTxt = f==0?ptTxtTop:ptTxtRef;	
				ptTxt+=face*vecYT*.5*textHeight*scale;	//ptTxt.vis(2);
				
				int nReadDir = 1;
				if (n3DText == 1)
				{
					face = -1;
					nReadDir*=-1;
					if(f==0)continue;
				}
				else if (n3DText == 2)
				{
					face = 1;
					if(f==1)continue;
				}
				else if (n3DText == 3 && f==1)
				{
					nReadDir*=-1;					
				}
				else if (n3DText == 4 && f==1)
					nReadDir*=-1;
			
				for (int j=0;j<lines.length();j++) 
				{ 
					String text = lines[j];		
					if (text.length() < 1) { continue; }
					
					if (text=="\\P")
					{ 
						dRowOffset -= textHeight*1.5;
						continue;
					}
		
				//region Get polylines by character
					Point3d ptChar = ptTxt + vz * (vz.dotProduct(sip.ptCen()-ptTxt));
					Point3d pts[0];
					PLine plines[0];
					for (int i=0;i<text.length();i++) 
					{ 
						String character = text.getAt(i);
						int n = allChars.find(character);
						
						double dX = dVersalHeight/3;
						if (n>-1)
						{ 
							Map mapChar = mapChars.getMap(n);
							
							PlaneProfile box = mapChar.getPlaneProfile("box");	box.vis(i+1);
							dX = box.dX();
							double dY = box.dY();
				
							CoordSys cs2el;
							cs2el.setToAlignCoordSys(_PtW, _XW, _YW, _ZW, ptChar, nReadDir*scale*vecXT, scale*vecYT, nReadDir*scale*vecZT);
							
							//box.transformBy(cs2el);box.vis(3);	
							for (int c=0;c<mapChar.length();c++) 
							{ 
								if (mapChar.hasPLine(c))
								{ 
									PLine pl = mapChar.getPLine(c);
									
									pl.transformBy(cs2el);
									//pl.vis(2);
									plines.append(pl);
									// collect extreme verices
									pl.convertToLineApprox(dEps);
									pts.append(pl.vertexPoints(true));
									
								}	 
							}//next c		
						}
						
						if (character == "T") dX *= .6;
						else if (character == "F") dX *= .5;
						
						ptChar += nReadDir*scale*vecXT * (dX+pitch);	
					}//next i	
				//endregion 
	
				// transform to row and centered alignment
					double dX;
					pts = Line(_Pt0, vecXT).orderPoints(pts);
					if (pts.length()>0)
						dX= abs(vecXT.dotProduct(pts.last() - pts.first()));
					Body bd;	
					for (int i=0;i<plines.length();i++) 
					{ 
						PLine pl = plines[i];

						pl.transformBy(-vecXT*.5*dX*nReadDir+vecYT * dRowOffset);		//pl.vis(j); 
						
						Point3d pt1=pl.ptStart();
						Point3d pt2=pl.ptEnd();
						int bIsClosed=(pt1-pt2).length()<dEps;
						if (!bIsClosed)
						{
							PLine pl1=pl;
							int bSuccess=pl1.offset(.5*dWidthOutline,true);
							if(!bSuccess)
							{ 
							// operation not successful
								pl1=pl;
								pl1.convertToLineApprox(U(10));
								bSuccess=pl1.offset(.5*dWidthOutline,true);
								if(!bSuccess)
								{ 
									pl1=pl;
									pl1.convertToLineApprox(U(10));
									bSuccess=pl1.offset(.5*dWidthOutline,false);
								}
							}
							pl1.vis(2);
							PLine pl2=pl;
							bSuccess=pl2.offset(-.5*dWidthOutline,true);
							if(!bSuccess)
							{ 
							// operation not successful
								pl2=pl;
								pl2.convertToLineApprox(U(10));
								bSuccess=pl2.offset(-.5*dWidthOutline,false);
								if(!bSuccess)
								{ 
									pl2=pl;
									pl2.convertToLineApprox(U(10));
									bSuccess=pl2.offset(-.5*dWidthOutline,false);
								}
							}
							pl2.vis(2);
							pl2.reverse();
							pl1.append(pl2);
							pl1.close();	//pl1.vis(3);						
							pl=pl1;
						}
						pl.close();
						// make sure to remove duplicated points
						{ 
							Point3d ptsI[]=pl.vertexPoints(true);
							for (int ipt=ptsI.length()-2; ipt>=0 ; ipt--) 
							{ 
								if((ptsI[ipt]-ptsI[ipt+1]).length()<U(0.1))
									ptsI.removeAt(ipt);
								
							}//next ipt
							PLine _pl;
							for (int ipt=0;ipt<ptsI.length();ipt++) 
							{ 
								_pl.addVertex(ptsI[ipt]); 
							}//next ipt
							pl=_pl;
						}
						pl.transformBy(vz *.5 * dZ * face);
						Body bdi (pl,vz*d3DThickness,face); bdi.vis(2)	;
						bd.combine(bdi);
						bd.vis(3);
						
					}//next i
					dpModel.draw(bd);
					dRowOffset -= textHeight*1.5;
				}//next j						
				
			}//next f
		}
	}		
//endregion 	

	mapRequest = Map();// clear map

//region Draw Planview Texts and Symbols
	if (abs(vz.dotProduct(_ZW))<dEps && dTxtHPlan>0) //HSB-24511 Acceptance of plan view alignment tolerances // replaced vz.isPerpendicularTo(_ZW)
	{ 
		Point3d ptRef = _Pt0 - vz*vz.dotProduct(ptCen-_Pt0);//		ptRef.vis(6);
		Vector3d vecYSym = -vz, vecXSym=vecYSym.crossProduct(_ZW);	
		
		Vector3d vecXRead = vecXSym;
		double dYFlag=-1;
		if (vecXRead.dotProduct(_XW) < 0 || vecXSym.isCodirectionalTo(-_YW))
		{
			dYFlag *= -1;
			vecXRead *= -1;
		}
		Vector3d vecYRead = vecXRead.crossProduct(-_ZW);
		// make sure the surface quality is closest to the panel side 
		if(bIsMultiline)
		{ 
			if(vecYRead.dotProduct(vecYSym)>0)
			{ 
				// make sure at reference it is the last
				if(bHasQualityBottom)
				{ 
					textPlanBot="";
					for (int i=0;i<sPlanRefLines.length();i++) 
					{
						if(sPlanRefLines[i]==sQualityBottomTxt)continue;
						String s = sip.formatObject(sPlanRefLines[i], mapAdditional);//HSB-18497
						textPlanBot+=(textPlanBot.length()>0?"\\P":"")+ s; 
					}
					String s = sQualityBottomTxt;//HSB-18497
					textPlanBot+=(textPlanBot.length()>0?"\\P":"")+ s; 
				}
				// make sure at top it is the first
				if(bHasQualityTop)
				{ 
					textPlanTop="";
					String s = sQualityTopTxt;//HSB-18497
					textPlanTop+=(textPlanTop.length()>0?"\\P":"")+ s; 
					for (int i=0;i<sPlanTopLines.length();i++) 
					{
						if(sPlanTopLines[i]==sQualityTopTxt)continue;
						String s = sip.formatObject(sPlanTopLines[i], mapAdditional);//HSB-18497
						textPlanTop+=(textPlanTop.length()>0?"\\P":"")+ s; 
					}
				}
			}
			else
			{ 
				// make sure at reference it is the last
				if(bHasQualityBottom)
				{ 
					textPlanBot="";
					String s = sQualityBottomTxt;//HSB-18497
					textPlanBot+=(textPlanBot.length()>0?"\\P":"")+ s; 
					for (int i=0;i<sPlanRefLines.length();i++) 
					{
						if(sPlanRefLines[i]==sQualityBottomTxt)continue;
						String s = sip.formatObject(sPlanRefLines[i], mapAdditional);//HSB-18497
						textPlanBot+=(textPlanBot.length()>0?"\\P":"")+ s; 
					}
				}
				if(bHasQualityTop)
				{ 
					textPlanTop="";
					for (int i=0;i<sPlanTopLines.length();i++) 
					{
						if(sPlanTopLines[i]==sQualityTopTxt)continue;
						String s = sip.formatObject(sPlanTopLines[i], mapAdditional);//HSB-18497
						textPlanTop+=(textPlanTop.length()>0?"\\P":"")+ s; 
					}
					String s = sQualityTopTxt;//HSB-18497
					textPlanTop+=(textPlanTop.length()>0?"\\P":"")+ s; 
				}
			}
		}
		
		//vecXRead.vis(ptRef, 1);
		
	// draw triangle in plan view
		PLine plSym(_ZW);
		plSym.addVertex(ptRef -vecYSym*.5*dZ);
		plSym.addVertex(ptRef -vecYSym*(.5*dZ+dTxtHPlan)+vecXSym*.5*dTxtHPlan);
		plSym.addVertex(ptRef -vecYSym*(.5*dZ+dTxtHPlan)-vecXSym*.5*dTxtHPlan);		
		plSym.close();//		plTriangle.vis(2);
		dpPlan.draw(PlaneProfile(plSym), _kDrawFilled);	

	// publish dimRequest // TODO
		mapRequest = Map();
		mapRequest.setInt("Color", nColor);
		mapRequest.setInt("DrawFilled", _kDrawFilled);
		mapRequest.setInt("Transparency", 0);
		mapRequest.setVector3d("AllowedView", _ZW);
		mapRequest.setInt("AlsoReverseDirection", false);									
		mapRequest.setPlaneProfile("PlaneProfile",PlaneProfile(plSym) );		
	
		mapRequests.appendMap("DimRequest",mapRequest);	


	// draw grain direction pline or block
		if (!vxGrain.isParallelTo(_ZW))// else
		{
			double f = dTxtHPlan/textHeight;
			f*=.5*dTxtHPlan/dLL;

			Point3d ptPlan = ptRef - vecYSym * .5 * (dZ + dTxtHPlan) + vecXSym * (f * dLL + .5 * dTxtHPlan);
		// draw block in plan view
			if (bDrawBlock)
			{
				f *= dTxtHPlan / textHeight;
				dpPlan.draw(Block(sAssociationBlockName), ptPlan, vecXSym*f, vecYSym*f, _ZW*f);		
			}
		// draw pline in plan view
			else
			{
				CoordSys csAlign;
				csAlign.setToAlignCoordSys(_Pt0, vxGrain, vyGrain, vz, ptPlan, vecXSym*f, vecYSym*f, _ZW*f);
				plGrainSymbol.transformBy(csAlign);
				dpPlan.draw(plGrainSymbol);
				
				mapRequest = Map();
				mapRequest.setInt("Color", nColor);
				mapRequest.setVector3d("AllowedView", _ZW);
				mapRequest.setPLine("PLine",plGrainSymbol );
				
				mapRequests.appendMap("DimRequest",mapRequest);	
				
			}		
		}

	//region draw plan view texts
		Point3d ptTxtTop = ptRef-vecYSym*(1.7*dTxtHPlan+0.5*dZ); ptTxtTop.vis(1);
		Point3d ptTxtBot = ptRef+vecYSym*(0.7*dTxtHPlan+0.5*dZ); ptTxtBot.vis(2);	
		
		dpPlan.draw(textPlanBot,ptTxtBot, vecXRead, vecYRead, 0, -dYFlag);	
		dpPlan.draw(textPlanTop, ptTxtTop, vecXRead, vecYRead, 0, dYFlag);	

		mapRequest = Map();
		mapRequest.setInt("Color", nColor);
		mapRequest.setVector3d("vecX", vecXRead);
		mapRequest.setVector3d("vecY", vecYRead);
		mapRequest.setString("DimStyle",sDimStyle);	
		mapRequest.setDouble("TextHeight", dTxtHPlan);
		mapRequest.setDouble("dXFlag", 0);
		
		mapRequest.setVector3d("AllowedView", _ZW);
		mapRequest.setInt("AlsoReverseDirection", false);									

		mapRequest.setString("text", textPlanBot);		
		mapRequest.setPoint3d("ptLocation", ptTxtBot);
		
		mapRequest.setDouble("dYFlag", -dYFlag);
		mapRequests.appendMap("DimRequest",mapRequest);	

		mapRequest.setPoint3d("ptLocation", ptTxtTop);
		mapRequest.setDouble("dYFlag", dYFlag);
		mapRequest.setString("text", textPlanTop);		
		mapRequests.appendMap("DimRequest",mapRequest);	

	//End draw plan view texts//endregion 


	}
//End Draw Planview Texts and Symbols//endregion 

// special actions based on settings//region
// Marking Drill
	if (mapSetting.hasMap("MarkingDrill"))
	{ 
		String k;
		int bOk=true;
		Map m = mapSetting.getMap("MarkingDrill");
		Map c = m.getMap("Condition[]");
		Map t = c.getMap("BlockadeTsl[]");

	// Flag if marking is active: in order to provide a sample xml we deliver this with state false	
		k = "Activated";	if(m.hasInt(k)) bOk = m.getInt(k);

	// test against blockadeTsls, if one is found the marking drill will not be appended
		String sBlockadeTsls[0];
		for (int i=0;i<t.length();i++) 	sBlockadeTsls.append(t.getString(i).makeLower()); 
		if(sBlockadeTsls.length()>0)
		{ 
			Entity ents[] = sip.eToolsConnected();
			for (int i=0;i<ents.length();i++)
			{ 
				TslInst tsl =(TslInst) ents[i];
				if (!tsl.bIsValid() || tsl == _ThisInst)continue;
				String s = tsl.scriptName();
				if (sBlockadeTsls.find(s.makeLower())>-1)
				{ 
					bOk = false;
					break;
				}
			}
		}
		
	// test other conditions
		if (bOk)
		{ 
			for (int i=0;i<c.length();i++)
			{ 
				String sKey = c.keyAt(i).makeLower();
				if (c.hasString(i))
				{ 
					String value = c.getString(i);
					if (sKey == "SurfaceQualityTop".makeLower() && value != sQualities[0])bOk = false;
					else if (sKey == "SurfaceQualityBottom".makeLower() && value != sQualities[1])bOk = false;
				}
				if (c.hasInt(i))
				{ 
					int value = c.getInt(i);
					if (sKey == "Association".makeLower() && value != nAssociation)bOk = false;
				}	
				if (!bOk)break;
			}
		}
	
	// add marking drill
		if (bOk)
		{ 
		// parameters of marking drill
			int nColor = m.getInt("color");
			double dTextHeight= m.getDouble("textHeight");
			double dRadius= m.getDouble("diameter")*.5;
			double dDepth= m.getDouble("depth");
			double dOffset = m.getDouble("offset"); if (dOffset <= dEps)dOffset = U(50);
			int nSide = m.getInt("side"); if (abs(nSide) != 1)nSide = 1;
			String sDescription = m.getString("description");
			
			
		// triggers to add/remove or flip an additional marking drill
			int bAddMarkDrill =!_Map.hasInt("MarkDrill")?true:_Map.getInt("MarkDrill");
			String sTriggerToggleMarkDrill =bAddMarkDrill?T("|Remove Marking Drill|"):T("|Add Marking Drill|");
			
		// add trigger	
			addRecalcTrigger(_kContext, sTriggerToggleMarkDrill);
			if (_bOnRecalc && _kExecuteKey==sTriggerToggleMarkDrill)
			{
				bAddMarkDrill = bAddMarkDrill ? false : true;
				_Map.setInt("MarkDrill", bAddMarkDrill);
				setExecutionLoops(2);
				return;
			}
			
		// Trigger to control depth or alignment
			dDepth = _Map.hasDouble("MarkDrillDepth") ?_Map.getDouble("MarkDrillDepth"): dDepth;	
			if (dDepth > 0)nSide *= -1;
			
		// Trigger SetMarkingDepth
			if (bAddMarkDrill)
			{
				String sTriggerSetMarkingDepth = T("|Set Marking Depth/Alignment|");
				addRecalcTrigger(_kContext, sTriggerSetMarkingDepth );
				if (_bOnRecalc && _kExecuteKey == sTriggerSetMarkingDepth)
				{
					dDepth = getDouble(T("|Depth of marking drill, sign flips side| (") + dDepth + ")");
					_Map.setDouble("MarkDrillDepth", dDepth);
					
					// remove if depth set to 0 
					if (dDepth == 0)
					{
						_Map.removeAt("MarkDrillDepth", true);
						_Map.removeAt("MarkDrill", true);
						//reportMessage(TN("|Marking Drill removed.|"));
					}
					setExecutionLoops(2);
					return;
				}
				
				// evaluate location
				Point3d ptFace = sip.ptCen() + vz * nSide * .5 * dZ; //HSB-16983 was using COG as reference which did not return a valid ptFace
				Body bdReal = sip.realBody();
				PlaneProfile pp = bdReal.extractContactFaceInPlane(Plane(ptFace, vz), dEps);
				if (pp.area()<pow(dEps,2))
				{ 
					pp = bdReal.shadowProfile(Plane(ptFace, vz));
				}
				if (_PtG.length() > 0)
				{
					PLine plCirc;
					plCirc.createCircle(_PtG[0], vz, dRadius+dEps);
					pp.joinRing(plCirc, _kAdd);
				}
				pp.shrink(dOffset);
				
				Point3d ptLoc;
				if (_PtG.length() > 0)
				{
					if (pp.pointInProfile(_PtG[0]) == _kPointOutsideProfile)
						_PtG[0] = pp.closestPointTo(_PtG[0]);
					_PtG[0].transformBy(vz * vz.dotProduct(ptFace - _PtG[0]));
					ptLoc = _PtG[0];
				}
				else
				{
					// get default location
					LineSeg seg = pp.extentInDir(vx);
					double dX = abs(vx.dotProduct(seg.ptStart() - seg.ptEnd()));
					double dY = abs(vy.dotProduct(seg.ptStart() - seg.ptEnd()));
					ptLoc = pp.closestPointTo(seg.ptMid() - .5 * (vx * dX + vy * dY));
					_PtG.append(ptLoc);
				}

				// add tool
				Drill dr(ptLoc, ptLoc - nSide * vz * abs(dDepth), dRadius);
				sip.addTool(dr);
				
				// add symbol
				PLine pl(ptLoc + (vx + vy) * dRadius, ptLoc - (vx + vy) * dRadius, ptLoc, ptLoc - (vx - vy) * dRadius);
				pl.addVertex(ptLoc + (vx - vy) * dRadius);
				
				Display dp(nColor);
				if (dTextHeight > 0)dp.textHeight(dTextHeight);
				
				{ 
					dp.draw(pl);
					mapRequest = Map();
					mapRequest.setInt("Color", nColor);
					mapRequest.setVector3d("AllowedView", vz);				
					mapRequest.setPLine("pline", pl);	
					mapRequests.appendMap("DimRequest",mapRequest);						
				}

				if (sDescription.length() > 0)
				{
					double d =0;//.3*dTextHeight /dRadius;
					Point3d pt = ptLoc + (vx + vy) * (dRadius+.5*dTextHeight);
					dp.draw(sDescription,pt , vx, vy, d, d);
					
					mapRequest = Map();
					mapRequest.setInt("Color", nColor);
					mapRequest.setVector3d("AllowedView", vz);
					mapRequest.setInt("AlsoReverseDirection", true);		
					mapRequest.setDouble("textHeight", dTextHeight);				
					mapRequest.setPoint3d("ptLocation",pt);		
					mapRequest.setVector3d("vecX", vx );
					mapRequest.setVector3d("vecY", vy );
					mapRequest.setDouble("dXFlag", 0);
					mapRequest.setDouble("dYFlag", 0);		
					mapRequest.setInt("deviceMode", _kDeviceX);
					mapRequest.setString("text", sDescription);	
					mapRequests.appendMap("DimRequest",mapRequest);
				}
			}
			else // set ok to false to remove grip
				bOk = false;
		// 	ptLoc.vis(6);pp.vis(3);pl.vis(2);
		}
		
		if (!bOk && _PtG.length()>0)
			_PtG.setLength(0);
			
		if(_PtG.length()>0)
			_Map.setVector3d("vecGrip0", _PtG[0] - _PtW);
	}//endregion



// publish dim requests	
	_Map.setMap("DimRequest[]", mapRequests);
	

// HSB-24493: update extended data
	String sAttachedPropSetNames[]= sip.attachedPropSetNames();
	String sPropSetName = "Parameterlista childpanel";
	if (sAttachedPropSetNames.find(sPropSetName)>-1)
	{ 
		Map map=sip.getAttachedPropSetMap(sPropSetName);
		if(map.hasDouble("_Area(outercontour)"))
		{ 
			PlaneProfile ppOutter(sip.plEnvelope());
			double da=ppOutter.area();
			map.setDouble("_Area(outercontour)",da,_kArea);
			sip.setAttachedPropSetFromMap(sPropSetName, map);
		}
//		double dAreaOuter = map.getDouble("Area(outercontour)");
	}
	//sip.woodGrainDirection().vis(_Pt0+vy*U(100),2);	

// add direction trigger (only if not in sectional view)
	addRecalcTrigger(_kContextRoot, sTriggerGrainDirection);
	if (_bOnRecalc && (_kExecuteKey==sTriggerGrainDirection))
	{
		if (vecZView.isPerpendicularTo(vz))
		{ 
			reportMessage(TN("|Grain direction can not be set in this view direction|"));
			setExecutionLoops(2);
			return;		
		}
		
		
		Point3d pt1 = _Pt0;
		PrPoint ssP("\n" + T("|Select first point|")); 
		if (ssP.go()==_kOk) 
		{
			Point3d ptPick = ssP.value(); // retrieve the selected point
			Line(ptPick, vz).hasIntersection(Plane(ptCen, vz), pt1);
//			vxGrain = ptLast-_Pt0;
//			vxGrain .normalize();
//			

		}
		
		ssP = PrPoint ("\n" + T("|Select second point|"), pt1); 
		
		
	    Map mapArgs;
	    mapArgs.setPoint3d("pt1", pt1); // add all the info you need for Jigging
	    mapArgs.setInt("Color", nColor);
	    mapArgs.setVector3d("vecGrain", vxGrain);
	    mapArgs.setVector3d("vecZ", vz);
   
	    if (bDrawBlock)
	    {
	    	mapArgs.setString("blockName", sAssociationBlockName);
	    	mapArgs.setDouble("scale", dBlockScaleFactor);
	    	
	    }
	    else
	    	mapArgs.setPLine("plGrain", plGrain);
	    int nGoJig = -1;
	    while (nGoJig != _kOk && nGoJig != _kNone)
	    {
	        nGoJig = ssP.goJig("ChangeGrain", mapArgs); 
    
	        if (nGoJig == _kOk)
	        {
				Point3d pt2 = ssP.value(); //retrieve the selected point
				Line(pt2, vz).hasIntersection(Plane(pt1, vz), pt2);
				
				vxGrain = pt2-pt1;
				vxGrain .normalize();
				
			// if the user selects an arbitrary direction correct the coord sys of the sip
				if (!vxGrain.isCodirectionalTo(vx) && !vxGrain.isCodirectionalTo(vy))
				{
				// control axis direction on dependency of the selected production type
					if (nProductionType==0 && nGrainMapping==0) //sProductionTypes[] = {"Transverse", "Lengthwise"};
					{
						Vector3d vyGrain = vxGrain.crossProduct(-vz);
						sip.setXAxisDirectionInXYPlane(vyGrain);
					}	
					else if (nProductionType==1 && nGrainMapping==0) //sProductionTypes[] = {"Transverse", "Lengthwise"};
					{
						sip.setXAxisDirectionInXYPlane(vxGrain);
					}
					vx = sip.vecX();
					vy = sip.vecY();				
					
				}		
				sip.setWoodGrainDirection(vxGrain);	
	        }
//	        else if (nGoJig == _kKeyWord)
//	        { 
//	            if (ssP2.keywordIndex() == 0)
//	                mapArgs.setInt("isLeft", TRUE);
//	            else 
//	                mapArgs.setInt("isLeft", FALSE);
//	        }
	        else if (nGoJig == _kCancel)
	        { 
	            return; 
	        }
	    }		

		setExecutionLoops(2);
		return;
	}


// Trigger TogglePrefNestFace
	if (!vecNestFace.bIsZeroLength())
	{ 
		String sTriggerTogglePrefNestFace =vecNestFace.dotProduct(vz)>0? T("|Override Nesting Face => Reference Side|"):T("|Override Nesting Face => Top Side|");
		addRecalcTrigger(_kContextRoot, sTriggerTogglePrefNestFace);
		if (_bOnRecalc && _kExecuteKey==sTriggerTogglePrefNestFace)
		{
			Vector3d vec = vecNestFace;
			_Map.setVector3d(kPreferredTopFace, -vecNestFace);		
			setExecutionLoops(2);
			return;
		}
		
	//region Trigger RemoveOverride
		if (_Map.hasVector3d(kPreferredTopFace))
		{ 
			String sTriggerRemoveOverride = T("|Remove Override Nesting Face|");
			addRecalcTrigger(_kContextRoot, sTriggerRemoveOverride );
			if (_bOnRecalc && _kExecuteKey==sTriggerRemoveOverride)
			{
				_Map.removeAt(kPreferredTopFace, true);		
				setExecutionLoops(2);
				return;
			}//endregion				
		}
		
		//region Collect depending child panels to be updated
		if (_kExecutionLoopCount==1)
		{ 
			Entity entsC[] = Group().collectEntities(true, ChildPanel(), _kModelSpace);
			for (int i=0;i<entsC.length();i++) 
			{ 
				ChildPanel child= (ChildPanel)entsC[i]; 
				Sip sipC;
				if (child.bIsValid())
					sipC = child.sipEntity();
				if (sipC.bIsValid() && sipC == sip)
				{
					//reportNotice(("\nupdating child of panel ") + sip.posnum());
					child.transformBy(Vector3d(0, 0, 0));
					break;
				}
				 
			}//next i				
		}
			
	//endregion 	
		
	}
	Entity entFormat = sip;

//region Dialog Trigger
{ 
	// create TSL
	TslInst tslDialog;			Map mapTsl;						
	GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };
	
//region Trigger DisplaySettings
	String sTriggerDisplaySetting = T("|Settings|");
	addRecalcTrigger(_kContext, sTriggerDisplaySetting );
	if (_bOnRecalc && _kExecuteKey==sTriggerDisplaySetting)	
	{ 
		mapTsl.setInt("DialogMode",1);
			
		dProps.append(dWidth3DGrain);
		dProps.append(dWidthOutline);
	
	
		String sHiddenQualityList;
		for (int i=0;i<sHiddenQualities.length();i++) 
			sHiddenQualityList += (sHiddenQualityList.length()>0?";":"")+sHiddenQualities[i]; 
		sProps.append(sHiddenQualityList);	// 0
//		sProps.append(sTextAligns[nTextOrientation]);
//		// 0 = _kModel (Default)
//		// 1 = _kDevice
//		// 2 = _kDeviceX	

		String showSolid = bDrawBlock?tByBlock:sNoYes[nShowSolid];
		sProps.append(showSolid);// 1
		// 0 = no
		// 1 = yes
		// 2 = byBlock

		String s3DText = kDisabled;
		if (n3DText>-1 && n3DText<s3DTexts.length())
			s3DText = s3DTexts[n3DText];
		sProps.append(s3DText);//2
		// 0 = no
		// 1 = yes
		// HSB-23793 grain
		String s3DGrain = kDisabled;
		if (n3DGrain>-1 && n3DGrain<s3DTexts.length())
			s3DGrain = s3DTexts[n3DGrain];
		sProps.append(s3DGrain);//3
		
		//
		sProps.append(sGrainMappings[nGrainMapping]);//4
		// 0 = unchanged
		// 1 = X-Axis
		// 2 = Y-Axis
		
		sProps.append(sFaceDirectionFloor);//5
		
		// sAssociationSettingPath
		sProps.append(sAssociationSettingPath);//6


		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{ 
//				nTextOrientation = sTextAligns.find(tslDialog.propString(0));
//				mapSetting.setInt("Display\\TextOrientation",nTextOrientation<0?0:nTextOrientation);
//
				Map m;
				sHiddenQualityList = tslDialog.propString(0);
				sHiddenQualities = sHiddenQualityList.tokenize(";");
				for (int i=0;i<sHiddenQualities.length();i++) 
				{ 
					m.appendString("SurfaceQuality", sHiddenQualities[i]); 
					 
				}//next i
				if (m.length()>0)
					mapSetting.setMap("Display\\PlanView\\SurfaceQuality[]",m);

				showSolid = tslDialog.propString(1);
				nShowSolid = showSolid == tByBlock?2:sNoYes.find(showSolid);
				mapSetting.setInt("ShowSolid",nShowSolid<0?0:nShowSolid);

				s3DText = tslDialog.propString(2);
				s3DGrain = tslDialog.propString(3);// HSB-23793
				n3DText = s3DTexts.findNoCase(s3DText ,- 1);
				n3DGrain = s3DTexts.findNoCase(s3DGrain ,- 1);
				if (n3DText>-1)	mapSetting.setInt(k3DText, n3DText);
				if (n3DGrain>-1) mapSetting.setInt(k3DGrain, n3DGrain);// HSB-23793
				
				nGrainMapping = sGrainMappings.find(tslDialog.propString(4));
				mapSetting.setInt("GrainMapping",nGrainMapping<0?0:nGrainMapping);

				dWidth3DGrain = tslDialog.propDouble(0);
				mapSetting.setDouble(kWidthGrain, dWidth3DGrain);
				
				dWidthOutline = tslDialog.propDouble(1);
				mapSetting.setDouble(kWidthOutline, dWidthOutline);

				{ 
					m = Map();
					sFaceDirectionFloor = tslDialog.propString(5);
					if (sFaceDirectionFloor==tFDNegZ)
						m.setVector3d(kPreferredTopFace, -_ZW);
					else if (sFaceDirectionFloor==tFDPosZ)
						m.setVector3d(kPreferredTopFace, _ZW);
					mapSetting.setMap("Nesting\\Floor",m);					
				}
				// 
				sAssociationSettingPath=tslDialog.propString(6);
				mapSetting.setString("ExtendedDataAssociation",sAssociationSettingPath);
				
				//mapSetting.setMap("SubMapKey", m);
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);
				
			//region Collect depending child panels to be updated
				Entity ents[] = mo.getReferencesToMe();
				Entity entsC[] = Group().collectEntities(true, ChildPanel(), _kModelSpace);
				//reportNotice(("\nreferences founds ") + ents.length() + " childs " + entsC.length());
				
				GenBeam gbs[0];
				for (int i=0;i<ents.length();i++) 
				{
					TslInst t = (TslInst)ents[i];
					if (t.bIsValid())
						gbs.append(t.genBeam());
					
				}
				//reportNotice(("\npanel in tsl ents") + gbs.length());
				
				for (int i=0;i<entsC.length();i++) 
				{ 
					ChildPanel child= (ChildPanel)entsC[i]; 
					Sip sipC;
					if (child.bIsValid())
						sipC = child.sipEntity();
						
					if (sipC.bIsValid() && gbs.find(sipC)>-1)
					{
						//reportNotice(("\nupdating child of panel ") + sipC.posnum());
						child.transformBy(Vector3d(0, 0, 0));
					}
					 
				}//next i				
			//endregion 	

			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;	
	}
	//endregion	

//region Trigger Import/Export Settings
	if (findFile(sFullPath).length()>0)
	{ 
		String sTriggerImportSettings = T("|Import Settings|");
		addRecalcTrigger(_kContext, sTriggerImportSettings );
		if (_bOnRecalc && _kExecuteKey==sTriggerImportSettings)
		{
			mapSetting.readFromXmlFile(sFullPath);	
			if (mapSetting.length()>0)
			{ 
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);	
				reportMessage(TN("|Settings successfully imported from| ") + sFullPath);	
			}
			setExecutionLoops(2);
			return;
		}			
	}

// Trigger ExportSettings
	if (mapSetting.length() > 0)
	{
		String sTriggerExportSettings = T("|Export Settings|");
		addRecalcTrigger(_kContext, sTriggerExportSettings );
		if (_bOnRecalc && _kExecuteKey == sTriggerExportSettings)
		{
			int bWrite;
			if (findFile(sFullPath).length()>0)
			{ 
				String sInput = getString(T("|Are you sure to overwrite existing settings?|") + " [" + T("|No|") +"/"+T("|Yes|")+"]").left(1);
				bWrite = sInput.makeUpper() == T("|Yes|").makeUpper().left(1);
			}
			else bWrite = true;
				
			if (bWrite && mapSetting.length() > 0)
			{ 
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);
				
			// make sure the path exists	//HSB-10750
				int bPathFound= sFolders.find(sFolder)>-1?true:makeFolder(sPath+"\\"+sFolder);	
				
			// write file	
				mapSetting.writeToXmlFile(sFullPath);
				
			// report rsult of writing	
				if (findFile(sFullPath).length()>0)		reportMessage(TN("|Settings successfully exported to| ") + sFullPath);
				else									reportMessage(TN("|Failed to write to| ") + sFullPath);		
			}
			
			setExecutionLoops(2);
			return;
		}
	}
	//endregion 
	
	
//region Trigger DefineCharacter
	String sTriggerDefineCharacter = T("|Define Character|");
	addRecalcTrigger(_kContext, sTriggerDefineCharacter );
	if (_bOnRecalc && _kExecuteKey==sTriggerDefineCharacter)
	{
		reportNotice(TN("|To define a character draw its polyline definition in world XY plane.|") + TN("|The current versal height is set to| ") + dVersalHeight + TN("|The versal height describes the height of an upper case character.|"));
		Point3d ptBase = getPoint(T("|Pick point on base line|"));
		ptBase.setZ(0);
		Plane pn(_PtW, _ZW);
		Line lnX(ptBase, _XW);
		Line lnY(ptBase, _YW);
		
	// prompt for polylines	
		PrEntity ssEpl(T("|Select polylines|"), EntPLine());
		while(ssEpl.go() && ssEpl.set().length()>0)
		{ 
			Entity ents[0];
			ents.append(ssEpl.set());

			String c = getString(T("|Enter character|"));
			if (c.length()>1)
				c = c.left(1);
			else if (c.length()<1)
			{ 
				continue;
			}	

			PLine plines[0];
			Point3d pts[0];
			for (int i=0;i<ents.length();i++) 
			{ 
				EntPLine epl =(EntPLine)ents[i];
				PLine pl = epl.getPLine();
				if (!pl.coordSys().vecZ().isParallelTo(_ZW))
				{
					reportNotice(TN("|Polyline needs to be drawn in XY-World|"));
					continue;
				}				
				pl.projectPointsToPlane(pn, _ZW);
				plines.append(pl);				
				pl.convertToLineApprox(dEps);
				pts.append(pl.vertexPoints(true));
			}//next i

			
			if (pts.length()>0)
			{
				Point3d ptsX[] = lnX.orderPoints(pts, dEps);
				Point3d ptsY[] = lnY.orderPoints(pts, dEps);
				double dX, dY;
				if (ptsX.length() > 0) dX = _XW.dotProduct(ptsX.last() - ptsX.first());
				if (ptsY.length() > 0) dY = _YW.dotProduct(ptsY.last() - ptsY.first());
				
				if (dX <= 0) dX = dEps;
		
				Point3d pt = ptsX.first();
				pt += _YW*_YW.dotProduct(ptBase - pt);		
				Vector3d vecOrg = _PtW - pt;
				
			// remove if character exists
				for (int j=0;j<mapChars.length();j++) 
				{ 
					Map m= mapChars.getMap(j); 
					if (m.getMapName()==c)
					{
						mapChars.removeAt(j,true);
						break;
					} 
				}//next j				
				
			// append new character	
				Map m;
				for (int i=0;i<plines.length();i++) 
				{ 
					PLine pl= plines[i]; 
					pl.transformBy(vecOrg);
					m.appendPLine("pline", pl);
					 
				}//next i
				PlaneProfile box;
				box.createRectangle(LineSeg(pt, pt + _XW * dX + _YW * dVersalHeight), _XW, _YW);
				box.transformBy(vecOrg);
				m.appendPlaneProfile("box", box);
				m.setMapName(c);
				mapChars.appendMap("Character", m);
			}
			ssEpl=PrEntity(T("|Select polylines of next character|"), EntPLine());
		}
		
		// remove existing
		for (int i=0;i<mapFonts.length();i++) 
		{ 
			Map m= mapFonts.getMap(i); 
			if (m.getMapName().makeUpper()==sFont)
			{ 
				mapFonts.removeAt(i, true);
				break;
			}		 
		}//next i
		
		// add new
		mapFont.setDouble(kVersal, dVersalHeight);
		mapFont.setMap("Character[]", mapChars);
		mapFonts.appendMap("Font", mapFont);
		mapSettingTypeWriter.setMap("Font[]", mapFonts);
		
		if (moTypeWriter.bIsValid())
			moTypeWriter.setMap(mapSettingTypeWriter);
		else
			moTypeWriter.dbCreate(mapSettingTypeWriter);
		setExecutionLoops(2);
		return;
	}//endregion			
}
//End Dialog Trigger//endregion 











#End
#BeginThumbnail
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
<BG(!*@`_AS72V<+6]E!`Q!:.,*2.G`J>B@#_V?US
`



























































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
        <int nm="BreakPoint" vl="1409" />
        <int nm="BreakPoint" vl="1978" />
        <int nm="BreakPoint" vl="1928" />
        <int nm="BreakPoint" vl="1785" />
        <int nm="BreakPoint" vl="1080" />
        <int nm="BreakPoint" vl="2432" />
        <int nm="BreakPoint" vl="2436" />
        <int nm="BreakPoint" vl="2069" />
      </lst>
    </lst>
  </lst>
  <lst nm="TslInfo">
    <lst nm="TSLINFO">
      <lst nm="TSLINFO">
        <lst nm="TSLINFO">
          <lst nm="TSLINFO">
            <lst nm="TSLINFO">
              <lst nm="TSLINFO" />
            </lst>
          </lst>
        </lst>
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-24511 Acceptance of plan view alignment tolerances" />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="14" />
      <str nm="DATE" vl="10/6/2025 12:42:50 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-24493: Add calculation of outer contour area for extended data &quot;Parameterliste childpanel&quot; for Södra" />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="13" />
      <str nm="DATE" vl="9/10/2025 10:17:38 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23793: Fix when setting association from &quot;ExtendedDataAssociation&quot;; Fix text orientation" />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="12" />
      <str nm="DATE" vl="4/11/2025 2:44:23 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23793: Add parameter &quot;ExtendedDataAssociation&quot; in xml &quot;propSetName\propName&quot; for the definition of Association on Auto" />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="11" />
      <str nm="DATE" vl="4/10/2025 10:45:34 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23793: Add parameter &quot;3DGrain&quot; in xml" />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="10" />
      <str nm="DATE" vl="4/9/2025 4:42:26 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18515: Fix solid representation" />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="9" />
      <str nm="DATE" vl="12/1/2023 4:37:56 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-20302 ensuring grain direction is executed as last tsl of panel NOTE: requires hsbDesign 26 or higher" />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="11/22/2023 11:25:03 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-20282: fix 3d generation of letters" />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="10/9/2023 3:51:04 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-19795: on plan view show surfaceQuality text close to the panel side" />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="8/30/2023 4:01:51 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-19795: On Plan view show quality position on the side of the quality" />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="8/29/2023 5:09:52 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-19791: On side view show the relevant quality" />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="8/25/2023 2:38:37 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-19795: Fix side of text" />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="8/25/2023 9:59:53 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-19142 Text Location corrected" />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="6/7/2023 11:45:36 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18930 'Fit In View': supports scaling of textheight, block and pline symbol if sd_EntitySymbolDisplay has a fixed textheight " />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="5/9/2023 11:58:01 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18924 allow coma or semicolon separation of color association" />
      <int nm="MAJORVERSION" vl="7" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="5/8/2023 3:24:24 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18497 single line format parsing improved" />
      <int nm="MAJORVERSION" vl="6" />
      <int nm="MINORVERSION" vl="9" />
      <str nm="DATE" vl="3/29/2023 12:34:51 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-17629 3D Text respects viewing side" />
      <int nm="MAJORVERSION" vl="6" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="2/17/2023 12:34:37 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-17134 text displays with static offset" />
      <int nm="MAJORVERSION" vl="6" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="11/22/2022 1:54:31 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-16983 bugfix default marking drill location" />
      <int nm="MAJORVERSION" vl="6" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="11/7/2022 10:45:42 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-16887 new settings property to specify a preferred nesting face for floor panels with identical qualities on each face. New graphics showing preferred nesting face if set. New context commands to override preferred nesting face." />
      <int nm="MAJORVERSION" vl="6" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="10/25/2022 10:20:27 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-16169 3D-Text also shown when using block based symbol" />
      <int nm="MAJORVERSION" vl="6" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="8/1/2022 10:23:33 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15863 text composition restructured, formatting supports helper method" />
      <int nm="MAJORVERSION" vl="6" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="7/25/2022 2:14:29 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15863 new options to display text in 3D (IFC Export)" />
      <int nm="MAJORVERSION" vl="6" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="6/28/2022 1:56:03 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15103 bugfix updating property sets when rotating grain direction" />
      <int nm="MAJORVERSION" vl="6" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="4/7/2022 12:11:05 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-14250 bugfix resolving custom property set" />
      <int nm="MAJORVERSION" vl="6" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="1/10/2022 9:14:26 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13971 changing the grain direction can be done by selcting two points." />
      <int nm="MAJORVERSION" vl="5" />
      <int nm="MINORVERSION" vl="9" />
      <str nm="DATE" vl="11/24/2021 2:49:34 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13805 bugfix writing property sets" />
      <int nm="MAJORVERSION" vl="5" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="11/15/2021 2:06:33 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13181 production type has become a readOnly property except on insert" />
      <int nm="MAJORVERSION" vl="5" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="10/27/2021 8:52:57 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13181 production type has become a readOnly property" />
      <int nm="MAJORVERSION" vl="5" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="10/25/2021 12:44:51 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13291 location of grain direction symbol published to subMapX" />
      <int nm="MAJORVERSION" vl="5" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="9/28/2021 12:12:15 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-12355 weight written to submap and subMapX  'extendedProperties' of the panel" />
      <int nm="MAJORVERSION" vl="5" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="6/23/2021 12:51:33 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-11067 Settings exposed to context command, new property/parameter to toggle between 2D or 3D display of grain direction" />
      <int nm="MAJORVERSION" vl="5" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="3/5/2021 5:01:09 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-11063 In the submap 'ExtendedProperties' of a CLT panel a new property 'GrainDirection' is exposed. You can access the value by the format expression @(GrainDirection)" />
      <int nm="MAJORVERSION" vl="5" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="3/4/2021 5:01:13 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End