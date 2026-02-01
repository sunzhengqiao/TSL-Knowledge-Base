#Version 8
#BeginDescription

This Tsl creates a grid that represents the horizontal and vertical tiling of roof tiles.
 It serves as base functionality to all additional options of roofscaping.

version value="5.9" date="22jul23" author="nils.gregor@hsbcad.com">HSB-19266 Bugfix offset at verges"
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 5
#MinorVersion 9
#KeyWords 
#BeginContents
//region general vertical/horizontal
/// <summary Lang=de> //region
/// Dieses TSL erzeugt das Raster einer horizontalen und vertikalen Ziegelverteilung
/// </summary>

/// <summary Lang=en> //region
/// This Tsl creates a grid that represents the horizontal and vertical tiling of roof tiles.
/// It serves as base functionality to all additional options of roofscaping.
/// </summary>

/// <insert=en>
/// Select a roofplane
/// </insert>

/// <insert=de>
/// Dachfläche wählen
/// </insert>

/// <remark>
/// This version is in beta state and uses dummy data for the tile distribution
/// </remark>

/// <History>
///<version value="5.9" date="22jul23" author="nils.gregor@hsbcad.com">HSB-19266 Bugfix offset at verges"</version>
///<version value="5.8" date="18jun19" author="nils.gregor@hsbcad.com">Bugfix on using other units than millimeter"</version>
///<version value="5.7" date="23may19" author="nils.gregor@hsbcad.com">Adjusted horizontal distribution with half standard tiles as verge tiles"</version>
///<version value="5.6" date="21may19" author="nils.gregor@hsbcad.com">Adjusted sloped dormer function"</version>
///<version value="5.5" date="20may19" author="nils.gregor@hsbcad.com">Adjusted pent ridge if eave cut is perpendicular"</version>
///<version value="5.4" date="20may19" author="nils.gregor@hsbcad.com">Added surface to the colour"</version>
///<version value="5.3" date="17may19" author="nils.gregor@hsbcad.com">changed auto start mode </version>
///<version value="5.2" date="16may19" author="nils.gregor@hsbcad.com">changed the dimension </version>
///<version value="5.1" date="15may19" author="nils.gregor@hsbcad.com">corrected the exported tile quantity</version>
///<version value="5.0" date="05apr19" author="nils.gregor@hsbcad.com">Elementary changes in the behavior of the instance. Initial version for release V22</version>
///<version value="4.1" date="26jul18" author="thorsten.huck@hsbcad.com"> trigger added to update dependent instances when changing the Z-offset or eave cut mode </version>
///<version value="4.0" date="26jul18" author="thorsten.huck@hsbcad.com"> RS-139, staggered horizontal distribution uses full verge tile as distribution base </version>
///<version value="3.9" date="26jul18" author="thorsten.huck@hsbcad.com"> RS-138, auto adjust horizontal grid alignment mode only on creation </version>
///<version value="3.8" date="20jul18" author="thorsten.huck@hsbcad.com"> RS-139, verge edge distribution is  used for horizontal distribution </version>
///<version value="3.7" date="20jul18" author="thorsten.huck@hsbcad.com"> RS-138, new option for automatic horizontal distribution mode during insert </version>
///<version value="3.6" date="20jul18" author="thorsten.huck@hsbcad.com"> RS-118 new context command to distribute based on the average, new context command to set a fixed distribution value within the allowed range </version>
///<version value="3.5" date="06jul18" author="thorsten.huck@hsbcad.com"> RS-119, RS-120, RS-121, RS-122: eave front cut fixed </version>
///<version value="3.4" date="27jun18" author="thorsten.huck@hsbcad.com"> vertical grid with additional grip to place dimension line, projected dim added for vertical grid </version>
///<version value="3.3" date="26jun18" author="thorsten.huck@hsbcad.com"> properties reorganized, verge tile display separated into new tsl </version>
///<version value="3.2" date="26feb18" author="thorsten.huck@hsbcad.com"> RS-75: automatic half tile column creation if applicable </version>
///<version value="3.1" date="26feb18" author="thorsten.huck@hsbcad.com"> bugfix distribution preview at additional eaves and ridges </version>
///<version value="3.0" date="16jan18" author="thorsten.huck@hsbcad.com"> distribution preview at additional eaves and ridges </version>
///<version value="2.11" date="28nov17" author="florian.wuermseer@hsbcad.com"> version is now compatible with both V21 and V22 map data structure</version>
///<version value="2.10" date="28nov17" author="florian.wuermseer@hsbcad.com"> version now honors new map structure at roofplane's eaves edge</version>
///<version value="2.9" date="14aug17" author="florian.wuermseer@hsbcad.com"> bugfixes with variable LAF and LAT, bugfixes if there was a distribution with fixed laths, bugfix eaves/ridge edge detection</version>
///<version value="2.8" date="11aug17" author="florian.wuermseer@hsbcad.com"> Eaves offset now considered in range preview, distribution bugs fixed</version>
///<version value="2.7" date="16jan17" author="thorsten.huck@hsbcad.com"> case 3139: honours PÜT and lath section of a potential eave definition </version>
///<version value="2.6" date="11jan17" author="thorsten.huck@hsbcad.com"> vertical distribution enhanced, supports lath section override, various debug features, group assignment improved </version>
///<version value="2.5" date="30nov16" author="thorsten.huck@hsbcad.com"> vertical distribution supports eave tiles and eave tile offset </version>
///<version value="2.4" date="23sept16" author="thorsten.huck@hsbcad.com"> vertical distribution: new property front cut case 2825, alternative grid display now dependent to only one block called 'hsbTileGrid' with color definition by block, auto scale to fit of range block </version>
///<version value="2.3" date="23sept16" author="thorsten.huck@hsbcad.com"> vertical distribution: fixed lath position will not be moved with base point movement, eave front cut property contributes to distribution </version>
///<version value="2.2" date="19july16" author="thorsten.huck@hsbcad.com"> new property 'group' allows auto assignment to absolute or relative group </version>
///<version value="2.1" date="18july16" author="thorsten.huck@hsbcad.com"> debug messages enhanced, bugfix connecting ridge tile </version>
///<version value="2.0" date="20may16" author="thorsten.huck@hsbcad.com"> vertical distribution honours connecting ridge tile </version>
///<version value="1.9" date="25aug15" author="thorsten.huck@hsbcad.com"> bugfix display content toggle, range of vertical distribution more tolerant, location of lath width corrected, multiple verges display fixed, helper grid locations for multiple verges corrected </version>
///<version value="1.8" date="19jun15" author="thorsten.huck@hsbcad.com"> vertical distribution range supports alternative block display if range blocks with name 'hsbTileGridGreen','hsbTileGridRed','hsbTileGridGrey' are found</version>
///<version value="1.7" date="18jun15" author="thorsten.huck@hsbcad.com"> dimension of vertical tile grid fixed, supports new DB structure </version>
///<version value="1.6" date="03jun15" author="thorsten.huck@hsbcad.com"> half tile context command only available if half tiles supported by selected family </version>
///<version value="1.5" date="02jun15" author="thorsten.huck@hsbcad.com"> reference point with offset, linetypes and dimstyles validated, dimension added to vertical tile grid, new property to toggle visibility of grid and/or dimension, grid toggle removed from context commands </version>
///<version value="1.4" date="18may15" author="thorsten.huck@hsbcad.com"> new toggle to show/hide grid, accesible as context command or double click</version>
///<version value="1.3" date="12may15" author="thorsten.huck@hsbcad.com"> roof planes with no ridge edge supported. Requires RoofTilingManager.dll Version 20.0.0.1 </version>
///<version value="1.2" date="09may15" author="thorsten.huck@hsbcad.com"> debug data removed, unit issue maximum pitch solved, error display if no ridge data detected </version>
///<version value="1.1" date="08may15" author="thorsten.huck@hsbcad.com"> Data of RidgeDefinition included </version>
///<version value="1.0" date="07may15" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>//endregion



// constants //region
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	String sOpmKeys[] ={"Horizontal","Vertical"};

// properties by settings
	int ncGrid=252;
	int nRed = 10;
	int nGreen = 72;
	int nRangeColors[] = {nGreen , nRed,ncGrid};
	int nTransparency = 80;
	int nTransparency1 = 40;
	double dHelperGridLength = U(50);

	int ncText = 7, ncHalfVerge = 12, ncVerge= 44, ncHalf, ncVergeRidge = 1, ncRidgeConnection=62, ncRidgeConnectionHalf=142;// colors
	int ntHalfVerge = 80, ntVerge= 90, ntHalf, ntVergeRidge = 80, ntRidgeConnection=90,ntRidgeConnectionHalf=90;// transparency

	String sLineType =T("|Hidden|");
	double dLineScale = 1;
	
	String strAssemblyPath = _kPathHsbInstall+"\\Utilities\\RoofTiles\\RoofTilingManager.dll";  
	String strType = "hsbCad.Roof.TilingManager.Editor"; 
	
	String sHorizontalAlignmentName=T("|Horizontal Grid Alignment|");
	String sHorizontalAlignments[] = {T("|Left|"), T("|Center|"), T("|Right|")};
	String sHorizontalAlignmentDesc = T("|Defines the alignment of the horizontal grid.|") + T("|Automatic will resolve the alignment by roofplane.|");

	String sFrontCutModeName = T("|Eave front cut|");
	String sFrontCutModeDesc = T("|Overrides the orientation of the eaves front cut|");		
	String sFrontCutModes[] = {T("|by Roofplane|"), T("|Plumb|"), T("|perpendicular to roof|") };

// Properties	

// Display
	category = T("|Display|");//T("|Dimensions and Description|");
	String sDimStyleName=T("|Dimstyle|");
	PropString sDimStyle(2,_DimStyles.sorted(), sDimStyleName);
	sDimStyle.setCategory(category);
	sDimStyle.setDescription(T("|Defines the dimstyle which is used to display any text|"));

	String sTxtHName=T("|Text Height|");
	PropDouble dTxtH(0,U(80), sTxtHName);
	dTxtH.setCategory(category);
	dTxtH.setDescription(T("|Defines the text height.|"));

	String sDisplayContents[] = {T("|All|"), T("|Dimension|"), T("|Grid|")};
	String sDisplayContentName=T("|Display Content|");
	PropString sDisplayContent(0,sDisplayContents, sDisplayContentName);
	sDisplayContent.setCategory(category);
	sDisplayContent.setDescription(T("|Defines the content of the display.|"));

// grouping
	category=T("|General|");
	String sGroupName=T("|Group|");
	PropString sGroup(1,"", sGroupName);
	sGroup.setCategory(category);
	sGroup.setDescription(T("|Defines the automatic grouping of the instance|") + ", " + 
		TN("|seperate Level by '\\'|") + ". " + 
		TN("|Examples|")+"\n(A) "+T("|Absolute group name: 'House\\Roof\\Tiling'|") + " " +
		+"\n(B) "+T("|Relative group name: 'Tiling'|") + " " +
		+"\n(C) "+T("|Relative group name with wildcards: '**80 Tiling'|") + " " +
		TN("|To set one specific group name one would use (A)|") + " " + 
		TN("|If the roofplane is assigned to a group the instance is assigned to a group below the parent group of the roofplane (B or C).|") + " " + 
		T("|With Option (C) wildcards can be used to copy a substring of the parent group to the new group name i.e. '\\**80 Tiling' will create the group called '5080 Tiling' if the parent group is i.e. called 'House\\5000 Roof'.|"));

// get mode 
	int nMode = _Map.getInt("mode"); // 0 = onCreation, 1 = hor, 2  ver	
//endregion
	
	
//region on insert
	if (_bOnInsert || nMode==0)
	{	
		//bDebug = true;
		if (insertCycleCount()>1) { eraseInstance(); return; }

	// Geometry	
		category = T("|Geometry|");	
		String sZOffsetTilePlaneName=T("|Z-Offset|");
		PropDouble dZOffsetTilePlane(1,U(0), sZOffsetTilePlaneName);
		dZOffsetTilePlane.setCategory(category);	
		dZOffsetTilePlane.setDescription(T("|Defines the total distance between selected roofplane and the plane on the lower side of the tile lath.|"));

		category = T("|Grid|");
		sHorizontalAlignments.append(T("|Automatic|"));
		PropString sHorizontalAlignment(3,sHorizontalAlignments, sHorizontalAlignmentName,3);
		sHorizontalAlignment.setCategory(category );	
		sHorizontalAlignment.setDescription(sHorizontalAlignmentDesc);

		category = T("|Geometry|");
		PropString sFrontCutMode(4,sFrontCutModes, sFrontCutModeName,0);
		sFrontCutMode.setCategory(category);
		sFrontCutMode.setDescription(sFrontCutModeDesc);

	// silent/dialog
		int bDialog;
		if (_kExecuteKey.length()>0)
			setPropValuesFromCatalog(_kExecuteKey);	
		else if (_bOnInsert)
		{
			showDialog();	
			bDialog=true;
		}
		else
			setPropValuesFromCatalog(sLastInserted);
			
		Map mapTsl;
		mapTsl.setString("sFrontCutMode", sFrontCutMode);
		mapTsl.setDouble("dZOffsetTilePlane", dZOffsetTilePlane);
			
		int nHorizontalAlignment = sHorizontalAlignments.find(sHorizontalAlignment);		
	
	// prompt user to select roofplanes
		Entity entities[0];
		if (_bOnInsert)
		{
			PrEntity ssE(T("|Select roofplane(s)|"), ERoofPlane ());
	  		if (ssE.go())
	    		entities=ssE.set();	 
		}
		else
			entities=_Entity;
	
	// get subsets of eroofplanes main and openings
		ERoofPlane ers[0], erOthers[0];
		//PLine plEnvelopes[0];
		for (int i=0;i<entities.length();i++)
		{
			ERoofPlane er = (ERoofPlane)entities[i];
			if (!er.bIsValid() && er.planeType() != _kRPTRoof)continue;

			int bIsOpening;
			if(er.findParentRoofplane(entities).bIsValid())
				bIsOpening = true;
			
		// the selected eroofplane is a main type	
			if (!bIsOpening && ers.find(er)<0)
				ers.append(er);
		//...opening		
			else if (bIsOpening && erOthers.find(er)<0)
				erOthers.append(er);						
		}
		
		if(bDebug)reportMessage("\n"+ scriptName() +" " + ers.length() + " main roofs selected");
		if(bDebug)reportMessage("\n"+ scriptName() +" " + erOthers.length() + " opening roofs selected");

	// collect all grid tsl's of this drawing
		Entity entsGrid[] = Group().collectEntities(true, TslInst(), _kModelSpace);
		TslInst tslsGrid[0];
		for (int i=0;i<entsGrid.length();i++)
		{
			TslInst tsl= (TslInst)entsGrid[i];
			if (tsl.bIsValid() && scriptName() == tsl.scriptName())
				tslsGrid.append(tsl);	
		}

	// declare the tsl props
		TslInst tslNew;
		Vector3d vecX = _XW;		Vector3d vecY = _YW;
		GenBeam gbs[0];		Entity ents[1];		Point3d pts[1];
		int nProps[0];
		double dPropsH[] = {dTxtH};
		double dPropsV[] = {dTxtH,dZOffsetTilePlane};
		String sPropsH[] = {sDisplayContent,sGroup,sDimStyle,sHorizontalAlignment};
		String sPropsV[] = {sDisplayContent,sGroup,sDimStyle,sFrontCutMode};
		String sScriptname = scriptName();	

	// insert per roofplane, make sure the requested instance is not assigned yet to this roofplane
		for (int e=0;e<ers.length();e++)
		{
			ERoofPlane& rp = ers[e];
			
		// filter grid tsl's assigned to this roofplane
			int bHorizontalFound, bVerticalFound;
			for (int t=0;t<tslsGrid.length();t++)
			{
				TslInst tsl = tslsGrid[t];	
				Entity entsTsl[] = tsl.entity();
				if (entsTsl.find(rp)>-1)
				{
					if (tsl.opmName().find(sOpmKeys[0],0)>-1) bHorizontalFound=true;

					else if (tsl.opmName().find(sOpmKeys[1],0)>-1)	bVerticalFound=true;	
				}
			}	
			
			CoordSys cs = rp.coordSys();
			vecX = cs.vecX();
			vecY = cs.vecY();

			ents[0] = rp;
		
		// create horizontal grid tsl if not existing yet
			if (!bHorizontalFound)
			{				
			// get topology and set alignment property
				if (nHorizontalAlignment==3)
				{ 
					EdgeTileData edges[] = rp.edgeTileTopology(); 
					int bHasLeft, bHasRight;
					for (int i = 0; i < edges.length(); i++)
					{
						EdgeTileData edge = edges[i];
						int tileType = edge.tileType();
						if (tileType == _kTileRight)bHasRight = true;						
						else if (tileType == _kTileLeft)bHasLeft = true;
					}
					
				// default = right	
					if (bHasRight)
						sPropsH[3] = sHorizontalAlignments[2];//right
					else if (bHasLeft)
						sPropsH[3] = sHorizontalAlignments[0];//left
					else 
						sPropsH[3] = sHorizontalAlignments[1];//center						
				}

				Line lnX(cs.ptOrg(), cs.vecX());
				Point3d ptsEnv[]=lnX.projectPoints(lnX.orderPoints(rp.plEnvelope().vertexPoints(true)));
				if (ptsEnv.length()>0)
					pts[0]=ptsEnv[ptsEnv.length()-1]+(vecX-vecY) *dTxtH;

				mapTsl.setInt("mode",1); // horizontal grid
				tslNew.dbCreate(sScriptname, vecX,vecY,gbs, ents, pts, 
					nProps, dPropsH, sPropsH,_kModelSpace, mapTsl); // create new instance	
					
			// try to find a default catalog entry, if found set properties
				String sEntries[]=TslInst().getListOfCatalogNames(scriptName()+"-"+sOpmKeys[0]);	
				int nEntry = sEntries.find(sDefault);		
				if (tslNew.bIsValid() && nEntry>-1 && !bDialog)
					tslNew.setPropValuesFromCatalog(sDefault);	
				if(tslNew.bIsValid())
					_Map.setEntity("tslGrid", tslNew);
			}
			else if(_bOnInsert)
				reportMessage("\n" + scriptName() + "-" + sOpmKeys[1] + " " + T("|already attached to roofplane.|"));
			
			// create vertical grid tsl if not existing yet
			if (!bVerticalFound)
			{
			// store the ZOffsetTilePlane in a subMapX of the roofplane
				Map m = rp.subMapX("Hsb_TileExportData");
				m.setDouble("ZOffsetTilePlane", dZOffsetTilePlane);
				rp.setSubMapX("Hsb_TileExportData",m);
								
				Line lnY(cs.ptOrg(), cs.vecY());
				Point3d ptsEnv[]=lnY.orderPoints(rp.plEnvelope().vertexPoints(true));
				if (ptsEnv.length()>1 && (abs(cs.vecY().dotProduct(ptsEnv[0]-ptsEnv[1]))<dEps))
					pts[0]=(ptsEnv[0]+ptsEnv[1])/2;
				else if (ptsEnv.length()>0)	
					pts[0]=ptsEnv[0];
				else 
					pts[0] = _Pt0;
				mapTsl.setInt("mode",2); // vertical grid
				mapTsl.setEntity("tslGrid", _Map.getEntity("tslGrid"));
				tslNew.dbCreate(sScriptname, vecX,vecY,gbs, ents, pts, 
					nProps, dPropsV, sPropsV,_kModelSpace, mapTsl); // create new instance	
			
			// try to find a default catalog entry, if found set properties
				String sEntries[]=TslInst().getListOfCatalogNames(scriptName()+"-"+sOpmKeys[0]);	
				int nEntry = sEntries.find(sDefault);		
				if (tslNew.bIsValid() && nEntry>-1 && !bDialog)
					tslNew.setPropValuesFromCatalog(sDefault);
			}
			else if(_bOnInsert)
				reportMessage("\n" + scriptName() + "-" + sOpmKeys[0] + " " + T("|already attached to roofplane.|"));
		}		
		eraseInstance();
		return;		
	}//endregion end on insert_______________________________________________________________________________________________


// validate roofplane
	if (_Entity.length()<1 || !_Entity[0].bIsKindOf(ERoofPlane()))		
	{
		eraseInstance();
		return;	
	}	
	else
		setDependencyOnEntity(_Entity[0]);	
			
// set opm name
	setOPMKey(sOpmKeys[nMode-1]);	
	//if (bDebug)	reportNotice("\nStarting " + sOpmKeys[nMode-1] + "...");

// Display contents
	int nDisplayContent=sDisplayContents.find(sDisplayContent);
	if (nDisplayContent<0) // avoid hickups with previous releases and catalog entries
	{
		sDisplayContent.set(sDisplayContents[0]);
		setExecutionLoops(2);
		return;	
	}	
	// 0 = All
	// 1 = Dimension
	// 2 = Grid

// make sure the line type and dimstyle are valid: if the catalog entry points to linetype which is not in the dwg this could lead into a reduced list of properties in the opm manager
	if (_LineTypes.find(T("|"+sLineType+"|"))<0 && _LineTypes.length()>0)
		sLineType=_LineTypes[0];

// get the roofplane and its coordSys
	ERoofPlane er = (ERoofPlane)_Entity[0];
	CoordSys csErp = er.coordSys();
	Vector3d vecX=csErp.vecX(), vecY=csErp.vecY(), vecZ=csErp.vecZ(), vecYN=vecY.crossProduct(_ZW).crossProduct(-_ZW);
	Point3d ptOrg = csErp.ptOrg();
	PLine plEnvelope = er.plEnvelope();
	Plane pnErp(ptOrg, vecZ);
	PlaneProfile ppErp(plEnvelope); ppErp.vis(4);
// Defined in line 770 to respect the possible offset
	//	LineSeg segErp = ppErp.extentInDir(vecX);
	//	double dXErp = abs(vecX.dotProduct(segErp.ptStart()-segErp.ptEnd()));
	//	double dYErp = abs(vecY.dotProduct(segErp.ptStart()-segErp.ptEnd()));
	Line lnX(ptOrg,vecX);
	Line lnY(ptOrg,vecY);
	double dPitch = 90-vecY.angleTo(_ZW);

// get main roof topology
//	EdgeTileData edgesMain[] = er.edgeTileTopology();
	EdgeTileData edgesMain[] = er.edgeTileTopology();
	EdgeTileData edgesForTest[] = er.edgeTileData();
	Display ng1(4); Display ng2(6);
	
	
// Reset former attached rooftile data to the roofplane
	String sTriggerReset = T("|Reset rooftile information|");
	addRecalcTrigger(_kContext, sTriggerReset);
	if (_bOnRecalc && _kExecuteKey==sTriggerReset || _bOnDbCreated)
	{ 
		er.removeSubMapX("Hsb_TileExportData");
	}
	
	if(_bOnRecalc)
		er.removeSubMapX("Hsb_TileExportData");

Map mapEdge;	
	if(edgesMain.length() > edgesForTest.length())
		for(int i=0; i < edgesMain.length(); i++)
		{
			LineSeg seg1 = edgesMain[i].segment(); 
			PLine pl1(seg1.ptStart(), seg1.ptEnd());

			for(int j=0; j < edgesForTest.length();j++)
			{
				LineSeg seg2 = edgesForTest[j].segment(); 
				Line ln(seg2.ptStart(), seg2.ptEnd() - seg2.ptStart());
				PLine pl2(seg2.ptStart(), seg2.ptEnd());
				Point3d ptL1 = ln.closestPointTo(seg1.ptStart());
				Point3d ptL2 = ln.closestPointTo(seg1.ptEnd());

				if(ptL1 == seg1.ptStart() && ptL2 == seg1.ptEnd() && pl2.length() > pl1.length()+dEps)
				{
					Vector3d vX = seg2.ptEnd() - seg2.ptStart();
					if(vX.dotProduct(seg1.ptMid() - seg2.ptStart()) > dEps && vX.dotProduct(seg1.ptMid() - seg2.ptEnd()) < -dEps)
					{					
						if(edgesMain[i].partnerRoofplane().bIsValid())
						{
							mapEdge.setInt(i, j);
						}	
						else
						{
							edgesMain.removeAt(i);
							i--;
						}
					}
				}
			}
		}	
	
	EdgeTileData edges[0]; 
	edges = edgesMain;

// set flag to assign me to a group if no groups found or user changes group name property
	int bAssignToGroup = _ThisInst.groups().length()<1 || _kNameLastChangedProp == sGroupName;

// the displays
	Display dpPlan(252),dpGrid(ncGrid), dpSection(252), dpDimPlan(252), dpDimModel(252);
	dpPlan.dimStyle(sDimStyle);		dpPlan.textHeight(dTxtH);
	dpDimPlan.dimStyle(sDimStyle);	dpDimPlan.textHeight(dTxtH);
	dpDimModel.dimStyle(sDimStyle);	dpDimModel.textHeight(dTxtH);
	dpSection.dimStyle(sDimStyle);	dpSection.textHeight(dTxtH);
	if (nMode==2)
	{
		dpPlan.addHideDirection(vecX);
		dpPlan.addHideDirection(-vecX);
		dpSection.addViewDirection(-vecX);
		dpSection.addViewDirection(vecX);
		dpDimPlan.addViewDirection(_ZW);
		dpDimModel.addHideDirection(_ZW);
		dpDimPlan.addHideDirection(vecX);
		dpDimPlan.addHideDirection(-vecX);
		dpDimModel.addHideDirection(vecX);
		dpDimModel.addHideDirection(-vecX);		
	}
	dpGrid.lineType(sLineType, dLineScale);
	if (bDebug) dpPlan.draw(_ThisInst.opmName(),_Pt0,_XW,_YW,1,nMode*3);

// resolve grouping name	
	if (sGroup.length()>0)
	{
	// test if the declared group
		String sCompositeName= sGroup;
		Group group(sCompositeName);
	// test if group exists	
		if (group.bExists())	group.addEntity(_ThisInst, true);
	// test if parent group exists
		else
		{
		// get name parts from given group name
			int x1 = sCompositeName.find("\\",0);
			int x2 = sCompositeName.find("\\",x1+2);
			String sLevel0 = sCompositeName.left(x1);
			String sLevel1 = sCompositeName.left(x2).right(x2-x1-1);
			String sLevel2 = sCompositeName.right(sCompositeName.length()-x2-1);
			// namePart() against the group name appears to fail if '-' is in the group name

		// check roofplane groups for second level assignment
			if (sLevel0=="" && sLevel1=="")
			{
				Group groups[] = er.groups();
				for(int i=0;i<groups.length();i++)
				{
					if (groups[i].namePart(1)!="")
					{
						sLevel0=groups[i].namePart(0);
						sLevel1=groups[i].namePart(1);
						break;
					}
				}// next i
			}

		// extract jokers and replace by corresponding character of parent group
			String sLevel2New;
			for(int i=0;i<sLevel2.length();i++)
			{
				char c=sLevel2.getAt(i);
				if (c=='*' && sLevel1.length()>i)
				{
					c = sLevel1.getAt(i);
				}
				sLevel2New+=c;
			}// next i
			sLevel2 = sLevel2New;

		// check if parent levels are valid
			if (bAssignToGroup && (sLevel0=="" || sLevel1==""))
				bAssignToGroup=false;

		// assign to and/or create new group
			if (bAssignToGroup)
			{
				Group floorGroup(sLevel0, sLevel1, sLevel2);
				if (!floorGroup.bExists())floorGroup.dbCreate();
				if (floorGroup.bExists())floorGroup.addEntity(_ThisInst, true);
			}
		}
					
		Group parentGroups[] = er.groups();	
	}// end if resolving group name

// restore grips from map if _Pt0 has been moved
	Map mapGrips = _Map.getMap("Grip[]");
	if (_kNameLastChangedProp=="_Pt0" && mapGrips.length()>0)
	{
		_PtG.setLength(0);
		for (int i=0; i<mapGrips.length();i++)
		{
			Vector3d vec = mapGrips.getVector3d(i);
			_PtG.append(_PtW+vec);
		}
	}		

// collect all opening roofplanes
	ERoofPlane erOpenings[0];
	EdgeTileData edgesOpening[0];
	erOpenings = er.findContainingRoofplanes();
	
// declare a planeProfile including all openings	
	PlaneProfile ppRoof=ppErp;	
	PLine plsAll[] = {plEnvelope};
	int bIsOp[plsAll.length()];
	ERoofPlane ers[] = {er};
	
	for (int i=0;i<erOpenings.length();i++)
	{
		ERoofPlane& _er = erOpenings[i];
		PLine plOpening = erOpenings[i].plEnvelope();
		edgesOpening.append(_er.edgeTileData());
		
	//transform opening if the Z offset > 0 and opening is a chimney
		double dZOffsetTilePlane = 	er.subMapX("Hsb_TileExportData").getDouble("ZOffsetTilePlane");
		if(dZOffsetTilePlane > dEps && erOpenings[i].planeType()==4)
		{
			plOpening.transformBy(vecY * sin(dPitch) * dZOffsetTilePlane);		
//			dpGrid.draw(plOpening);
		}
		
	// collect plines and subtract openings from main			
		ers.append(erOpenings[i]);
		ppRoof.joinRing(plOpening, _kSubtract);
		plsAll.append(plOpening);
		bIsOp.append(true);
	}
	edges.append(edgesOpening);

// get family data
	Map mapFamilyDefinition = er.subMapX("Hsb_RoofTile").getMap("RoofFamilyDefinition");
	if (mapFamilyDefinition.length()<1)
	{
		reportMessage("\n" + _ThisInst.opmName() + " " + T("|could not find valid roof tile data.|") + T("|Please make sure the roofplane has a roof tile style assigned.|") +
		T("|The tool will be deleted.|"));
		eraseInstance();
		return;
	}
	Map mapFamily = mapFamilyDefinition.getMap("RoofTileFamily");
	String sFamilyName = mapFamily.getString("FamilyName");
	String sFamilyId = mapFamily.getString("Id");
	int nTileDistribution = mapFamily.getInt("TileDistribution"); // 0 = standard, 1 = staggered

// get standard tile	
	Map mapStandardTile = mapFamilyDefinition.getMap("StandardRoofTile");
	double dOverhang = mapStandardTile.getDouble("DistanceToTopOfLathKey"); 
	
// Horizontal tile spacing
	Map mapHorizontalTileSpacing = mapStandardTile.getMap("HorizontalTileSpacing");	
	double dXMin=mapHorizontalTileSpacing.getDouble("Minimum");
	double dXMax=mapHorizontalTileSpacing.getDouble("Maximum");
	if (dXMax<dEps )
	{
		reportMessage("\n" + _ThisInst.opmName() + " " + T("|could not find valid roof tile data.|") +T("|The tool will be deleted.|"));
		eraseInstance();
		return;
	}
	
// Vertical tile spacing
	Map mapSVTS = mapFamilyDefinition.getMap("VerticalTilingDefinition").getMap("VerticalTileSpacing");
	double dYMin = mapSVTS.getDouble("Minimum");
	double dYMax = mapSVTS.getDouble("Maximum");

// general data
// get manufacturer data
	Map mapManufacturer = mapStandardTile.getMap("ManufacturerData");
	String sManufacturer = mapManufacturer.getString("Manufacturer");	
	String sColor = mapFamilyDefinition.getMap("Characteristic").getString("Surface") +" " + mapFamilyDefinition.getMap("Characteristic").getString("Colour");	
	
// get half tile data from database	
	Map mapIn;
	mapIn.setString("ManufacturerId",mapManufacturer.getString("ID"));
	mapIn.setString("RoofTileFamilyId",mapFamily.getString("Id"));
	mapIn.setInt("TileType",7);    
	Map mapOut = callDotNetFunction2(strAssemblyPath, strType, "GetTiles", mapIn);
	Map mapHalfTile = mapOut.getMap("RoofTile[]\RoofTile");

// declare the collection of edge data
	EdgeTileData verges[0], eaves[0], ridges[0], saddleRidges[0], pentRidges[0], edgesHorizontal[0], edgesSloped[0];
	
// lath dimensions
	double dYLath;
	double dZLath;
	
// get eave lath section from a potential eave definition
	double dYLathEave, dZLathEave;
	double dZOffsetTilePlane;	
	{ 
	// loop through edges to adjust profile with edge offsets (main and openings)
		Point3d ptsEdgeMid[] = ppRoof.getGripEdgeMidPoints();
		
		int bModified;
		for (int i=0;i<edges.length();i++) 
		{ 
			EdgeTileData edge = edges[i];
			Map map = edge.tileMap();
			ERoofPlane er = edge.myRoofplane();
		// flag if this edge is derived from opening
			int bIsOpening = erOpenings.find(er)>-1;
			
		// get local coordSys from seg
			LineSeg seg = edge.segment(); 
			Vector3d vecXSeg = seg.ptEnd() - seg.ptStart();vecXSeg.normalize();
			Vector3d vecYSeg = vecZ.crossProduct(vecXSeg);
			vecYSeg.normalize();	
			if (bIsOpening)vecYSeg *= -1; 

		// verge assignment
			double dAngleY = vecXSeg.angleTo(vecY);
			double dAngleX = vecXSeg.angleTo(vecX);
						
			if (abs(dAngleY) < dEps || abs(dAngleY - 180) < dEps)
				verges.append(edge);		

		// edgesHorizontal assignment		
			else if (abs(dAngleX) < dEps || abs(dAngleX - 180) < dEps)		
				edgesHorizontal.append(edge);
		
		// edgesSloped assignment. Used to check if sloped eave or vally
			else
				edgesSloped.append(edge);

		// get offset			
			double dOffset = map.getDouble("Offset");
			Point3d ptMid = seg.ptMid();
			
		// find matching edgeVertex and stretch roof profile
			//if(dOffset > dEps)
				for (int p=0;p<ptsEdgeMid.length();p++)
				{	
					double dY = abs(vecYSeg.dotProduct(ptMid - ptsEdgeMid[p]));
					double dX = abs(vecXSeg.dotProduct(ptMid - ptsEdgeMid[p]));
					
					if (dX<.5*seg.length() && dY<dEps && abs(dOffset)>dEps)
					{		
						
						ppRoof.moveGripEdgeMidPointAt(p, vecYSeg*dOffset);				
						bModified = true;
						break; // breaking pgetGripEdgeMidPoints
					}			
				}
	 	}	

	//Adjust the roofPlane to the given Eave front cut
		 dZOffsetTilePlane = 	er.subMapX("Hsb_TileExportData").getDouble("ZOffsetTilePlane");

		if(dZOffsetTilePlane > 0)	
		{
		 	double dZplumb = dZOffsetTilePlane / cos(dPitch);	 
			ppRoof.transformBy(_ZW * dZplumb);
			int bFrontCutPerToRoofplane = er.subMapX("Hsb_TileExportData").getInt("FrontCutMode");
					
		 	if(bFrontCutPerToRoofplane)
		 	{				
		 		double dYEave = dZOffsetTilePlane * tan(dPitch);
		 		Point3d ptsMid[] = ppRoof.getGripEdgeMidPoints();
		 			
		 	// Find eave edge points. Eave edge points are inside the PlaneProfile after being moved in vecY dirction
		 		for(int i=0; i < ptsMid.length();i++)
		 		{
		 			Point3d ptTest = ptsMid[i] + vecY * dEps;
		 			
		 			if(ppRoof.pointInProfile(ptTest) == 0)
		 				ppRoof.moveGripEdgeMidPointAt(i, -vecY * dYEave);
		 		}
		 		bModified = true;
		 	}				
		}

		//if (bModified)
		{ 
			
		// draw in mode 1
			Display dpGrid(ncGrid);
			PlaneProfile pp;
			
		// refresh rings
			plsAll = ppRoof.allRings();
			bIsOp = ppRoof.ringIsOpening();	
			plEnvelope = PLine();
			for (int r=0;r<plsAll.length();r++)
				if (!bIsOp[r] && plsAll[r].area()>plEnvelope.area())
				{
					plEnvelope = plsAll[r];						
				}
				else if (bIsOp[r])
				{ 
					dpGrid.draw(plsAll[r]);
				}
			plsAll = ppRoof.allRings(true, false);
			PLine plsOp[] = ppRoof.allRings(false, true);
			ppRoof = PlaneProfile(plsAll[0]);
			for(int i=0; i < plsOp.length();i++)
			{
				ppRoof.joinRing(plsOp[i], true);
			}
		}
	}			

// Collect all information for vertical tile distribution
// declare eave and ridge batten distances
	double dEaveLATs[0], dRidgeLAFs[0], dRidgeCTDs[0], dOffsets[0], dOffsetsR[0];
	LineSeg segMainRoof, segDormer;
	ERoofPlane rpMain;
		
// edgesHorizontal Type
	int nEdgeHtype[0];
//Vertical grip points of eaves and ridges	
	Point3d ptsGripsV[0], ptsRidge[0], ptsEave[0];
			
// order edgeHorizontal along -vecY ([0] is bottom most edge)
	for (int i=0;i<edgesHorizontal.length()-1;i++)
		for (int j=i+1;j<edgesHorizontal.length();j++)
		{
			double d1 = vecY.dotProduct(ptOrg-edgesHorizontal[i].segment().ptMid());
			double d2 = vecY.dotProduct(ptOrg-edgesHorizontal[j].segment().ptMid());
			if (d1<d2)
				edgesHorizontal.swap(i,j);
		}	
		
	for (int i=0;i<edgesHorizontal.length();i++)
	{
		Map map = edgesHorizontal[i].tileMap();
		double dOffset = map.getDouble("Offset");
		String sKeyWidth="LathWidth", sKeyHeight="LathHeight";
		Point3d ptT = edgesHorizontal[i].segment().ptMid();
				
	// get ridge data from roofplane map
		if(map.hasMap("RidgeConnectionDefinition[]"))   // Offset should not be needed because points are already moved maybe in case they are not updated that keep them
		{
		// saddle ridge
			if(edgesHorizontal[i].tileTypePartner()== 1)
			{
				saddleRidges.append(edgesHorizontal[i]);	
				ptsGripsV.append(edgesHorizontal[i].segment().ptMid()-vecY*dOffset); // offset not yet declared for saddleRidges
				ptsRidge.append(ptsGripsV.last() + vecY*dOffset);
				nEdgeHtype.append(1);
				dOffsets.append(dOffset);
				ptsGripsV.last().vis(2);
			}
				
		// pent ridge
			else
			{
				pentRidges.append(edgesHorizontal[i]);
				ptsGripsV.append(edgesHorizontal[i].segment().ptMid()-vecY*dOffset); // offset not yet declared for saddleRidges
				ptsRidge.append(ptsGripsV.last() + vecY*dOffset);
				nEdgeHtype.append(2);
				dOffsets.append(dOffset);
			}
					
		// get lath section from a potential ridge definition		
			if (saddleRidges.length() < 1)
			{
				dYLath = map.getDouble(sKeyWidth);
				dZLath = map.getDouble(sKeyHeight);
			}
				
		//collecting ridge distances for vertical distribution	
			ridges.append(edgesHorizontal[i]);
			Map mapRCDB = map.getMap("RidgeConnectionDefinition[]");
			Map mapRCD = mapRCDB.getMap("RidgeConnectionDefinition");
			Map mapVTD = mapRCD.getMap("VerticalTilingDefinition");
			Map mapVTS = mapVTD.getMap("VerticalTileSpacing");
			dRidgeLAFs.append(mapVTD.getDouble("RidgeBattenDistance"));
			dRidgeCTDs.append(mapVTS.getDouble("Minimum"));
			dRidgeCTDs.append(mapVTS.getDouble("Maximum"));					
		}
			
	// get ridge data if no roofplane information exists
		else if(edgesHorizontal[i].tileType() == 1)
		{
			ridges.append(edgesHorizontal[i]);
			pentRidges .append(edgesHorizontal[i]);
			ptsGripsV.append(edgesHorizontal[i].segment().ptMid()-vecY*dOffset); // notyet declared for saddleRidges
			nEdgeHtype.append(3);
			dOffsets.append(dOffset);	
			dRidgeLAFs.append(0);
			dRidgeCTDs.append(0);
			dRidgeCTDs.append(0);	
		}

	// get eave data from roofplane map
		if(map.hasMap("EavesDefinition"))
		{
			eaves.append(edgesHorizontal[i]);
			ptsGripsV.append(edgesHorizontal[i].segment().ptMid()+vecY*dOffset);
			ptsEave.append(ptsGripsV.last() + vecY*dOffset);
			nEdgeHtype.append(0);
			dOffsets.append(dOffset);
				
		//collecting eave distances for vertical distribution		
			Map mapED = map.getMap("EavesDefinition");
			Map mapVTD = mapED.getMap("VerticalTilingDefinition");
			Map mapVTS = mapVTD.getMap("VerticalTileSpacing");	
			dEaveLATs.append(mapVTS.getDouble("Minimum"));
			dEaveLATs.append(mapVTS.getDouble("Maximum"));	
				
			if (mapED.length()>0)
			{
				dYLathEave = mapED.getDouble(sKeyWidth);
				dZLathEave = mapED.getDouble(sKeyHeight);
			}
		}
			 
	// get eave data if no roofplane information exists
		else if(edgesHorizontal[i].tileType() == 0)
		{
			eaves.append(edgesHorizontal[i]);
			ptsGripsV.append(edgesHorizontal[i].segment().ptMid()+vecY*dOffset);
			nEdgeHtype.append(0);
			dOffsets.append(dOffset);	
			dEaveLATs.append(0);
			dEaveLATs.append(0);	
		}
	}	
	
	
//Prepare PlaneProfile to deal with tile overhang at the eave and visualisation
	PlaneProfile ppS;
	{ 		
		ERoofPlane rpOpening[] = er.findContainingRoofplanes();	
		PLine plRoof[] = ppRoof.allRings(true, false);
		PlaneProfile ppTiling(plRoof[0]);
		PlaneProfile pp1;
		PlaneProfile pp2;

	// Opening is Loggia and has a relevant eave
		for(int i=0; i < rpOpening.length(); i++)
		{
			if(rpOpening[i].planeType() == 5)
				ppTiling.joinRing(rpOpening[i].plEnvelope(), true);	
		}

		Point3d ptsTiling[] = ppTiling.getGripEdgeMidPoints();	
		
		
		for(int i=0; i < ptsTiling.length();i++)
		{
			int nER = ppTiling.pointInProfile((ptsTiling[i] + vecY * dEps));

			if(nER ==0)
			{
				int nTrue = true;
				
				double dUsedOverhang; 
				
				if(dEaveLATs.length() > 1)
					dUsedOverhang = dOverhang -(dEaveLATs[0]+dEaveLATs[1])/2;

			// Horizontal eave
				for(int j=0; j < ptsEave.length();j++)
				{							
					if((ptsTiling[i] - ptsEave[j]).length() < dEps)
					{
					// get the actual used overhang for the eave
						dUsedOverhang = dOverhang -(dEaveLATs[j]+dEaveLATs[j+1])/2;
						ppTiling.moveGripEdgeMidPointAt(i, - vecY * dUsedOverhang);
						nTrue = false;
						break;
					}
				}	
			// Sloped eave	
				if(nTrue)
				{
					int bContinue;
				// Overhang must not created at 	valleys
					for(int j=0; j < edgesSloped.length(); j++)
					{
						LineSeg segS = edgesSloped[j].segment();
						if(PLine(segS.ptStart(), segS.ptEnd()).isOn(ptsTiling[i]))
						{
							if(edgesSloped[j].partnerRoofplane().bIsValid())
							{
								bContinue = true;
								break;
							}
						}						
					}
					
					if (bContinue) continue;
					
					ppTiling.moveGripEdgeMidPointAt(i, - vecY * dUsedOverhang);
				}
				
			}
			else if(nER == 1 )
			{
				for(int j=0; j < ptsRidge.length();j++)
				{
					Point3d ptR = ptsTiling[i] - _ZW * (dZOffsetTilePlane / cos(dPitch));				
					LineSeg segR = ridges[j].segment();
					
					if(PLine(segR.ptStart(), segR.ptEnd()).isOn(ptR))
					{
						ppTiling.moveGripEdgeMidPointAt(i, - vecY * dRidgeLAFs[j]);		
						break;
					}
				}
			}
		}	
		
		PLine plS[] = ppTiling.allRings(true, false);
		ppS = PlaneProfile(plS[0]);
		PLine plR[] = ppRoof.allRings(false, true);
		for(int i=0; i < plR.length(); i++)
			ppS.joinRing(plR[i], true);

		PlaneProfile ppT = ppTiling; 
		 pp1 = ppRoof; 
		 pp1.subtractProfile(ppT);
		 pp2 = ppT;
		 pp2.subtractProfile(ppRoof);
	}
	
// Points use for dimension
//	LineSeg segErp = ppRoof.extentInDir(vecX);segErp.vis(2);
	LineSeg segErp = ppS.extentInDir(vecX);
	double dXErp = abs(vecX.dotProduct(segErp.ptStart()-segErp.ptEnd()));
	double dYErp = abs(vecY.dotProduct(segErp.ptStart()-segErp.ptEnd()));
	
// declare variables for the dimensioning
	Vector3d vecXDim, vecYDim;
	int bOnTop = false;
	Point3d ptRefDim=_Pt0;
	Point3d ptsDim[0];
	//Vector3d vecRead = _YW-_XW;// reading vector
	Vector3d vecRead = - vecX.crossProduct(_ZW) - vecX;
	PLine plSnap = plEnvelope;
	PlaneProfile ppSnap=ppErp;
	ppSnap.shrink(-.1*dTxtH);	
	if (ppSnap.area()>pow(dEps,2))
	{
		PLine pls[] = ppSnap.allRings();
		if (pls.length()>0)	plSnap = pls[0];
	}
	Plane pnSnap;// the plane where all dimpoints will be projected to	

//endregion general vertical/horizontal

//region START HORIZONTAL MODE ________
	if (nMode==1)
	{			
		category = T("|Grid|");
		PropString sHorizontalAlignment(3,sHorizontalAlignments, sHorizontalAlignmentName);
		sHorizontalAlignment.setCategory(category);
		sHorizontalAlignment.setDescription(sHorizontalAlignmentDesc);	
		int nHorizontalAlignment=sHorizontalAlignments.find(sHorizontalAlignment);
		
		if (nHorizontalAlignment<0)// 0 = left, 1 = center, 2 = right
		{ 
			nHorizontalAlignment = 2;
			sHorizontalAlignment.set(sHorizontalAlignments[nHorizontalAlignment]);
		}
		
	// Change direction for delta dim	
		if(nHorizontalAlignment==2)
			lnX = Line(ptOrg, -vecX);
	
		double dZOffsetTilePlane = er.subMapX("Hsb_TileExportData").getDouble("ZOffsetTilePlane");
		Point3d ptsExtrErp[] = {segErp.ptMid()-vecX*.5*dXErp,segErp.ptMid()+vecX*.5*dXErp}; 	
		
	// get half tile data	
		double dXMaxHalf,dXMinHalf;
		String sHalfName;
//		Map mapHalfTile = mapOut.getMap("RoofTileWithFamily[]\\RoofTileWithFamily\\RoofTile");

		if (mapHalfTile.length()>0)
		{
			dXMaxHalf= mapHalfTile.getMap("HorizontalTileSpacing").getDouble("Maximum"); // 20.0.83.0 has wrong data for half tiles
			dXMinHalf= mapHalfTile.getMap("HorizontalTileSpacing").getDouble("Minimum");
			sHalfName = mapHalfTile.getString("Name");
			//_Map.setMap("mapHalfTile", mapHalfTile);
		}

	//order verges along vecX ([0] is left most verge)
		for (int i=0;i<verges.length();i++)
			for (int j=0;j<verges.length()-1;j++)
			{
				double d1 = vecX.dotProduct(ptOrg-verges[j].segment().ptMid());
				double d2 = vecX.dotProduct(ptOrg-verges[j+1].segment().ptMid());
				if (d1<d2)
					verges.swap(j,j+1);
			}
			
	// find most left an right verges if existing and get edge tile data
		Point3d ptsTmp[2];
		int nLr = 1;
		Vector3d vecVergeDir = -vecX;
		double dAv1[2], dAv2[2], dDist1[2], dDist2[2];
		int a = 1;	
		int bRightV;

		for (int lr=verges.length()-1;lr>-1;lr--) 
		{ 				
			EdgeTileData edge = verges[lr];				
			Map m = edge.tileMap();
		
		// Edgetyp Auswertung fehlt noch, dann funktioniert Abfrage ob Edge von Opening
			if(edge.tileType() == _kTileRightOpening || edge.tileType() == _kTileLeftOpening)
				continue;

		// check horizontal tile spacings	
			Map mapTiles = m.getMap("RoofTile[]");
			LineSeg seg = edge.segment();
			Point3d ptVerge = seg.ptMid();
			Vector3d vecXVerge = vecZ.crossProduct(seg.ptEnd()-ptVerge);
			vecXVerge.normalize();

			if (vecXVerge.isCodirectionalTo(vecVergeDir) )
			{
				if (bRightV == true)
					continue;	
				bRightV = true;
				a = 1;
			}
			else
				a = 0;
			
			ptsTmp[a] = ptVerge +  vecXVerge * m.getDouble("Offset");

			for (int i=0;i<mapTiles.length();i++) 
			{ 
				Map mV= mapTiles.getMap(i);
				double dMax =mV.getMap("HorizontalTileSpacing").getDouble("Maximum");	
				double dMin =mV.getMap("HorizontalTileSpacing").getDouble("Minimum");
				
			// The standard Tile as right verge tile needs a bigger horizontal spacing ( tile spacing + overlaped part)
				if(a ==1 &&(mV.getInt("TileType") == 0 || mV.getInt("TileType") == 7))
				{
					double dAdd = mV.getDouble("Width") - (dMax + dMin) / 2;
					dMax += dAdd;
					dMin += dAdd;				
				}
					
				if (i==0 || dMax > dAv1[a])
				{ 				
					dAv1[a] = (dMax+dMin)/2;
					dDist1[a] = (dMax - dMin)/2;
				}								
		
				if (i==0 || dMin < dAv2[a] || dAv2[a] == 0)
				{ 						
					dAv2[a] = (dMax+dMin)/2;
					dDist2[a] = (dMax - dMin)/2;
				}												
			}//next i		
		}

		if(_bOnRecalc)
		{
			_Map.removeAt("nHalfRemoved", true);	
			_Map.removeAt("nSwaped", true);	
		}

	// Trigger SwapStaggered
		int bSwapStaggered = _Map.getInt("SwapStaggered");
		String sTriggerSwapStaggered =bSwapStaggered?T("|Start with full verge|"):T("|Start with half verge|");
			
		if(nTileDistribution==1)// && (dAv1[0] > dAv2[0] + dEps || dAv1[1] > dAv2[1] + dEps))
		{
			addRecalcTrigger(_kContext, sTriggerSwapStaggered);
			if (_bOnRecalc && _kExecuteKey==sTriggerSwapStaggered)
			{
				bSwapStaggered = bSwapStaggered ? false : true;
				_Map.setInt("SwapStaggered", bSwapStaggered);		
				_Map.setInt("nSwaped", true);
			}			
		}				

	// Declare verge width 
		double dVergeL = dAv1[0];
		double dVergeR = dAv1[1];
		double dVDistL = dDist1[0];
		double dVDistR = dDist1[1];
			
		if(bSwapStaggered)
		{
			dVergeL =  dAv2[0];
			dVergeR = dAv2[1];
			dVDistL = dDist2[0];
			dVDistR = dDist2[1];
		}
		
	// Declare standard and half tile width
		double dAv = (dXMax + dXMin) / 2;
		double dDist = (dXMax - dXMin)/2;
		double dAvHalf = (dXMaxHalf + dXMinHalf) / 2;
		double dDistHalf = dXMaxHalf - dXMinHalf;	
		
	// auto adjust horizontal grid alignment mode
		if(nHorizontalAlignment==3)
		{
			if (dVergeL ==0 && dVergeR > 0)
				sHorizontalAlignment.set(sHorizontalAlignments[2]);

			else if (dVergeR ==0 && dVergeL > 0 )	
				sHorizontalAlignment.set(sHorizontalAlignments[0]);

			else if(dVergeL ==0 && dVergeR ==0)
				sHorizontalAlignment.set(sHorizontalAlignments[1]);							
		}	
		
		
	// Add extrem points if roof has not left and right verge	
		if((ptsTmp[0] - _PtW).length() < dEps || nHorizontalAlignment == 1)
			ptsTmp[0] = ptsExtrErp[0]; 
		if((ptsTmp[1] - _PtW).length() < dEps || nHorizontalAlignment == 1)
			ptsTmp[1] = ptsExtrErp[1]; 

		
	// Distribute length
		double dDistribute = abs(vecX.dotProduct(ptsTmp[0] - ptsTmp[1])); 
		double dRestLeft;
		double dRestRight;		
		int bPtGLR;

	// add half tile trigger if half tile could be found in database
		if (dAvHalf>0)
		{
			String sAddHalfTileTrigger = T("|Add|") +" " + sHalfName ;
			addRecalcTrigger(_kContext, sAddHalfTileTrigger );
			if (_bOnRecalc && _kExecuteKey==sAddHalfTileTrigger) 
			{
				Point3d pt = getPoint(T("|Pick point in tile column|"));
				_PtG.append(lnX.closestPointTo(pt));	
			}

		// remove all half tile grips if not within extremes or snap to line	
			for (int i=_PtG.length()-1;i>=0;i--)
			{
				Point3d pt = _PtG[i];
				
				if (vecX.dotProduct(pt-ptsExtrErp[0])<0 || vecX.dotProduct(pt-ptsExtrErp[1])>0)
				{
					reportMessage("\n" + scriptName() + ": " +T("|The location of the half tile column is outside of the distribution range.|") + 
						T(" |The location will be removed| (") + pt+")");
					
					_PtG.removeAt(i);
					continue;	
				}
				else if(_PtG.length() > 1)
				{
					for(int j=i+1; j < _PtG.length(); j++)
					{
						if(vecX.dotProduct(_PtG[i] - _PtG[j]) < dAvHalf +dEps && vecX.dotProduct(_PtG[i] - _PtG[j]) > -dAvHalf -dEps )
						{
							_PtG.removeAt(j);
							j--;
							reportMessage("\n" + scriptName() + ": " +T("|The location of the half tile column is in range of another half tile column.|") + 
							T(" |The location will be removed| (") + pt+")");							
						}
					}
				}			
			}	
		}// end if half tile

	// remove half tile grips trigger
		if (_PtG.length()>0)
		{
			String sRemoveHalfTileTrigger = T("|Remove|")+" " + sHalfName;
			addRecalcTrigger(_kContext, sRemoveHalfTileTrigger );
			int nRemoved;
			if (_bOnRecalc && _kExecuteKey==sRemoveHalfTileTrigger ) 
			{
				Point3d pt = getPoint(T("|Pick point near tile column|"));
				for (int i=0; i<_PtG.length();i++)
				{
					if (abs(vecX.dotProduct(_PtG[i]-pt))<dAv+dDist)
					{
						_PtG.removeAt(i);	
						nRemoved = true;
						_Map.setInt("nHalfRemoved", true);
						String sI = i;
						break;
					}
				}
				if(! nRemoved)
					reportMessage("\n"+ T("|Could not a find a column nearby.|") + " " + T("|Try to pick a point closed to a half tile column...|"));						
			}			
		}
		
		for(int i=0; i < _PtG.length();i++)
		{
			if (vecX.dotProduct(_PtG[i] - ptsTmp[0]) < 0) bPtGLR = (bPtGLR ==0)?  -1 : 0;
			else if( -vecX.dotProduct(_PtG[i] - ptsTmp[1]) < 0) bPtGLR = (bPtGLR ==0)?  2 : 0;
			else
				bPtGLR = (bPtGLR ==0)?  1 : 0;
//			else if (-vecX.dotProduct(pt - ptsTmp[1]) < 0) bPtGLR = 1;			
		}
		
			
	// customize width
	// Trigger SetHorizontalDistribution//region
		double dXMaxCustom; // 0 = not custom
		dXMaxCustom = _Map.getDouble("XMaxCustom");
		String sTriggerSetHorizontalDistribution = T("|Set horizontal distribution|");
		addRecalcTrigger(_kContext, sTriggerSetHorizontalDistribution );
		if (_bOnRecalc && _kExecuteKey==sTriggerSetHorizontalDistribution)
		{
			double dDistTotal;	
			dDistTotal += _PtG.length() * dDistHalf;	
			
		// Precalculation	 for distribution forcast
			double dDistribute1 = dDistribute;
			if(dVergeL > 0  ) 
			{
				dDistribute1 -=  dVergeL;
				dDistTotal += dVDistL;
			}
	
			if(dVergeR > 0 ) 
			{
				dDistribute1 -=  dVergeR;
				dDistTotal += dVDistR;
			}
		
			int nColumn = dDistribute1 / dAv;
			double dRest = dDistribute1 - nColumn * dAv ;
			String sAv;
			dAv += dRest / nColumn;
			sAv = dAv;
			
			if(abs(dRest) > dDistTotal)
				sAv = T("|No possibillity|");
		
		// get userinput
			double d = getDouble(T("|Enter distribution value| (") + dXMin + "..." + dXMax + ")"+dAv+" |to fit| " + (dXMaxCustom>0?T("|(0 = reset)|"):""));

			if (d>=dXMin && d<= dXMax)
				dXMaxCustom = d;
			else
				dXMaxCustom = 0;
			_Map.setDouble("XMaxCustom", dXMaxCustom);	
			setExecutionLoops(2);
			return;
		}			
		
		if (dXMaxCustom!=0)
		{ 
			String sTriggerResetHorizontalDistribution = T("|Reset custom distribution|");
			addRecalcTrigger(_kContext, sTriggerResetHorizontalDistribution );
			if (_bOnRecalc && _kExecuteKey==sTriggerResetHorizontalDistribution)
			{
				_Map.removeAt("XMaxCustom", true);	
				setExecutionLoops(2);
				return;
			}			
		}
		
		
				
	// validate / reset custom distribution
		if (dXMaxCustom!= 0 && (dXMaxCustom<dXMin || dXMaxCustom>dXMax))dXMaxCustom = 0;
		
	// Set value for grid 
		double dGrid = dAv;
		int nColumn;
		double dRest;
		
		if(dXMaxCustom == 0)
		{
			double dDistTotal;
			double dDistribute1 = dDistribute;
			
			if(dVergeL > 0) 
			{
				dDistribute1 -=  dVergeL;
				dDistTotal += dVDistL;
			}
	
			if(dVergeR > 0) 
			{
				dDistribute1 -=  dVergeR;
				dDistTotal += dVDistR;
			}			
			
			nColumn = dDistribute1 / dGrid;	
			dRest = dDistribute1 - nColumn * dGrid;
			dDistTotal += nColumn * dDist;

			if(dRest < dDistTotal)
				dGrid += dRest /nColumn ;				

			else if(abs(dRest - dGrid) < (dDistTotal+dDist))
				dGrid += (dRest-dGrid) / (nColumn+1);
		}
	
	// Calculate dGrid		
		if(dXMaxCustom > 0)
			dGrid = dXMaxCustom;
			
		dAvHalf = dAvHalf * dGrid / dAv;
		
// Halbe Ziegelreihen berücksichtigen	
	// verge TSL adds a half tile
		int bVergeAddHalf[2];
		if(nTileDistribution == 1 )
		{
			if(dAv1[0] - dAv2[0] < dEps && dAv1[0] - dAv2[0] > -dEps )
			{
				if(bSwapStaggered)
					dVergeL += dAvHalf;
				bVergeAddHalf[0] = true;
			}

			if(dAv1[1] -dAv2[1] < dEps && dAv1[1] -dAv2[1] > -dEps)
			{
				if(bSwapStaggered)
					dVergeR += dAvHalf;
				bVergeAddHalf[1] = true;
			}
		}

	// final calculation of dRest
		nColumn = dDistribute / dGrid;
		dRest = dDistribute - nColumn * dGrid;
		double dRestStart;

	//calculate potential rest on left side. dRestLeft also used for right side
		double dDLeft = vecX.dotProduct(ptsTmp[0] - ptsExtrErp[0]);
		int nLeft = dDLeft / dGrid;
		dRestLeft = (dDLeft / dGrid - nLeft) * dGrid;	
		Point3d ptRange;
		Vector3d vecVerge;
		int nHalf = (bPtGLR == 1) ? 1 : 0;

		if(nHorizontalAlignment == 0) // Left aligned
		{		
			if(dVergeL > dEps)
			{
				if(dDLeft < dEps)
					dRestLeft = dVergeL;
				else
					dRestLeft -= dGrid - dVergeL;
			}
			else
				dRestLeft = dGrid;

			if(bPtGLR == -1)
				dRestStart = dAvHalf;
				
			dRestStart += dRestLeft;
			ptRange = ptsTmp[1];
			vecVerge = vecX;
		}
		else if(nHorizontalAlignment == 1) // middle
		{		
			if(bPtGLR != 0)
				dRestStart = dAvHalf/2;			
			dRestStart += dRest / 2;
		}
		else // Right aligned
		{
			double dDRight = vecX.dotProduct(ptsExtrErp[1] - ptsTmp[1]);
			int nRight = dDRight / dGrid;
			dRestRight = (dDRight / dGrid - nRight) * dGrid;

			if(dVergeR > dEps)
			{
				if(dDRight < dEps)
					dRestRight = dVergeR;
				else
					dRestRight = -dGrid + dVergeR;
			}	
			
			if(bPtGLR == -1)
				dRestStart = dAvHalf;			
			
			dRestStart += dRestLeft + dRest - dRestRight; 
			dRestStart -= nHalf * dAvHalf;
			ptRange = ptsTmp[0];
			vecVerge = - vecX;
		} 
		
		while(dRestStart > dGrid)
			dRestStart -= dGrid;

	// Verge adjustment or automatic add of half tile and range fit
		if(_Map.getInt("PtGAdded") && !_kNameLastChangedProp.find("_PTG",0)>-1 && _bOnRecalc)
		{
			_PtG.removeAt(0);
			_Map.setInt("PtGAdded", false);
		}

//		double dAdd = abs(dDistribute - dVergeL - dVergeR - _PtG.length() * dAvHalf ) /dGrid;
		double dAdd = abs(dDistribute - dVergeL - dVergeR - nHalf * dAvHalf ) /dGrid;	
		int nAdd = dAdd;
		int nAdd1 = 2 * dAdd;
		int bFit, bSwapSide, bAddHalf;
		int nVergePoint;

		if(nAdd < dAdd + dEps && nAdd > dAdd - dEps)
			bFit = true;	

		else if(nAdd1 < 2*dAdd + dEps && nAdd1 > 2*dAdd - dEps)
			bSwapSide = true;

	// Swap verge tile or add half tile    Der Teil verhindert die Anpassung
		if(bSwapSide && nHorizontalAlignment == 0 )
		{
		// Left verge has a full and half verge tile
			if(dAv1[1] > dAv2[1] + dEps || bVergeAddHalf[1])
			{
				nVergePoint = 3;
				double d = dAv1[1] - dAv2[1];
				if(bVergeAddHalf[1])
					d = dAvHalf;
			}
			else 
				bAddHalf = true;
		}	
	
	// Swap verge tile or add half tile	
		else if (bSwapSide && nHorizontalAlignment == 2 )
		{
		// check if verges have full/half verge tiles. (dAv1 contain the full verge tile, dAv2 the half if existing, else they also cotain full tiles) If not half tiles are used to stagger the tiles.
		// Left verge has a full and half verge tile
			if(dAv1[0] > dAv2[0] + dEps  || bVergeAddHalf[0])
			{
				nVergePoint= 2;
				double d = dAv1[0] - dAv2[0];
				if(bVergeAddHalf[0])
					d = dAvHalf;
				bFit = true;
			}
			else 
				bAddHalf = true;
		}

		while(dRestStart < 0)
			dRestStart += dGrid;		

	// order half tiles	
		Line lnXX(ptOrg,vecX);	
		_PtG = lnXX.orderPoints(_PtG);
		
	// Make sure dRestStart is bigger than the overhang in vecX direction. Otherwise the tile can not be fixed
		if(nHorizontalAlignment == 1)
		{ 
			LineSeg segEave = ppRoof.extentInDir(vecX);
			if(vecX.dotProduct(segEave.ptStart() - ptsExtrErp[0]) > dRestStart)
			{
				dRestStart += dGrid / 2;
			}		
		}
		
	// Append grid points and draw horizontal distribution. Allways started from left
		dDistribute = vecX.dotProduct(ptsExtrErp[1] - ptsExtrErp[0]);	
		dDistribute -= dRestStart;
		
		Point3d ptsGrid[0];
		ptsGrid.append(ptsExtrErp[0]);
		if(dRestStart > U(1))
			ptsGrid.append(ptsExtrErp[0] + vecX*dRestStart);
		
	// Automatic add of half tile column
		int nPtGs = 0;		
		
		if(nTileDistribution ==2 )
			bAddHalf = false;

		if(bAddHalf && !_Map.getInt("nHalfRemoved"))
		{
			Point3d ptAdd = ptsTmp[0] + vecX * (dGrid);

			_PtG.insertAt(0, lnX.closestPointTo(ptAdd));	
			bFit = true;
			_Map.setInt("PtGAdded", true);
		}	
		
	
	// Draw horizontal tile grid and append gridpoints	
		while(dDistribute  > dGrid + dEps)
		{
		// Stopp distribution check if verge tile right is wider than standard tile ( Eg: Standart tile as right verge)
			if(dDistribute < dVergeR + dEps && dDistribute > dVergeR -dEps)
				break;
			
			if(nPtGs <= _PtG.length()-1)
			{
				if(vecX.dotProduct(ptsGrid.last() - _PtG[nPtGs]) >= -dGrid/2  && vecX.dotProduct(ptsGrid.last() - _PtG[nPtGs]) < dGrid/2)
				{			
					_PtG[nPtGs] = ptsGrid.last() + vecX * dAvHalf * 0.5;
					ptsGrid.append(ptsGrid.last()+ vecX*dAvHalf);

					nPtGs++;
					dDistribute -= dAvHalf;	
					
				// Check range
					if(dDistribute <= dGrid)
						break;
					continue;
				}				
			}
			
			ptsGrid.append(ptsGrid.last() + vecX * dGrid);
			dDistribute -= dGrid; 
			ptsGrid.last().vis(2);
		}
		
		ptsGrid.append(ptsExtrErp[1]);	

	// Draw Range line for distribution check
//		dpGrid.lineType(sLineType, dLineScale*.25);
//	
//		double dRangeIS;
//		double dRangeOS;
//		double dAdjust = 2 * dGrid - dVergeL - dVergeR;
//		int	nRangeISColors = nRed;
//		int	nRangeOSColors = 40;
//		
//		dRest += nHalf * dAvHalf;
//		
//		if(nHorizontalAlignment == 0)
//		{
//			dRangeOS = dRest + dAdjust;
//			while (dRangeOS > dGrid) dRangeOS -= dGrid;
//			dRangeOS = (dRangeOS > 0) ? - dRangeOS : dRangeOS;
//			dRangeIS = dGrid + dRangeOS;
//		}
//		
//		else if(nHorizontalAlignment == 2)
//		{
//			dRangeOS = dRest + dAdjust;
//			while (dRangeOS > dGrid) dRangeOS -= dGrid;
//			dRangeOS = (dRangeOS > 0) ? - dRangeOS : dRangeOS;
//			dRangeIS = dGrid + dRangeOS;
//		}
//		
//		if(bFit)
//		{
//			nRangeOSColors = nGreen;
//			nRangeISColors = nGreen;
//		}
//
//		if (nRangeOSColors == nGreen) 
//		{
//			dRangeOS = dGrid;
//			dRangeIS = -dGrid;
//		}
//		
//		if(nHorizontalAlignment != 1)
//		{
//			PLine plRangeOS(ptRange, ptRange + vecVerge  * dRangeOS);
//			PLine plRangeEnd(ptRange + vecVerge * dRangeOS - vecY * U(50), ptRange + vecVerge * dRangeOS + vecY * U(50));
//			dpGrid.color(nRangeOSColors);
//			dpGrid.draw(plRangeOS);
//			dpGrid.draw(plRangeEnd);
//			PLine plRangeIS(ptRange, ptRange + vecVerge * dRangeIS);
//			plRangeEnd.transformBy(vecVerge * (dRangeIS - dRangeOS)); // dRangeOS is always negative => normal addition
//			dpGrid.color(nRangeISColors);
//			dpGrid.draw(plRangeIS);		
//			dpGrid.draw(plRangeEnd);				
//		}
	

	// show grid points	
//		if(_bOnDebug)
//		{
//			ptsGrid = lnX.orderPoints(lnX.projectPoints(ptsGrid));
//			for (int p=0;p<ptsGrid.length();p++)
//				ptsGrid[p].vis(p);			
//		}
		
//	// Points get projected to roofplane in X -direction. Eave overlap of tiles is kicked out of dimension
//		PLine plGrid(segErp.ptStart(), segErp.ptStart() + vecX * dXErp); 
//		for(int i=0; i < ptsGrid.length(); i++)
//			ptsGrid[i] = plGrid.closestPointTo(ptsGrid[i]);

	// order and  project grid points along vecX	
		ptsGrid = lnX.projectPoints(ptsGrid);	
		ptsGrid = lnX.orderPoints(ptsGrid, dEps);

	// set variables for dimensioning
		dpPlan.color(252);
		vecXDim = vecX;
		vecYDim=vecYN;
		ptRefDim = _Pt0;
		if (vecXDim.isCodirectionalTo(_YW))
		{
			vecXDim*=-1;
			vecYDim*=-1;
			bOnTop=true;		
		}

//		//ptsDim.append(ptsGrid);	
//		{ 
//			LineSeg segDim = ppRoof.extentInDir(vecX);
//			ptsDim.append(segDim.ptStart());
//			for(int i = 1; i < ptsGrid.length()-1; i++)
//				ptsDim.append(ptsGrid[i]);
//			ptsDim.append(segDim.ptEnd());
//			ptsDim = lnX.orderPoints(ptsDim);
//		}

// TODO Warning needs to be double checked, Sometimes wrong warning

//		String sNoWarning = (_Map.getInt("NoWarning"))? T("|Show dimension, if tile adjustment required|") : T("|Don´t show dimension, if tile adjustment required|");
//		addRecalcTrigger(_kContext, sNoWarning);
//		if (_bOnRecalc && _kExecuteKey==sNoWarning) 
//		{
//			(_Map.getInt("NoWarning"))? _Map.setInt("NoWarning", false) : _Map.setInt("NoWarning", true);	
//		}

	// Adding Dim points. The Dim points are at the eave ( without overhang)	
		 if(ptsGrid.length() > 1)
		{ 
			int bDrawWarning;
			
			Vector3d vecXD = ptsGrid[1] - ptsGrid[0];
			vecXD.normalize();
			
			LineSeg segDim = ppRoof.extentInDir(vecXD); 
			ptsDim.append(segDim.ptStart()); 
			
			if (vecXD.dotProduct(ptsGrid[0] - ptsDim[0]) > dEps) 
				ptsDim.append(ptsGrid[0]);
			if (vecXD.dotProduct(ptsGrid[1] - ptsDim[0]) > dEps) 
				ptsDim.append(ptsGrid[1]); 			
				
			for(int i = 2; i < ptsGrid.length()-2; i++)
			{		
				ptsDim.append(ptsGrid[i]);			
			}
			
			if (vecXD.dotProduct(segDim.ptEnd() - ptsGrid[ptsGrid.length()-2]) > dEps) 
				ptsDim.append(ptsGrid[ptsGrid.length() - 2]);						
			if (vecXD.dotProduct(segDim.ptEnd() - ptsGrid.last()) > dEps) 
				ptsDim.append(ptsGrid.last());
			if(vecXD.dotProduct(segDim.ptEnd() - ptsDim.last()) > dEps)	
				ptsDim.append(segDim.ptEnd());
			ptsDim = lnX.orderPoints(ptsDim);
			
			
			if(vecXD.isCodirectionalTo(vecX))
			{	
				Point3d ptDims[0];
				if((ptsDim[0] - ptsGrid[1]).length() > dXMax)
				{
					ptDims.append(ptsGrid[0]);
					ptDims.append(ptsDim[1]);
				}
				else if((ptsGrid.last() - ptsDim[ptsDim.length()-2]).length() > mapStandardTile.getDouble("Width"))
				{
					ptDims.append(ptsGrid.last());
					ptDims.append(ptsDim[ptsDim.length()-2]);					
				}
				
//				if(ptDims.length() > 0 && !_Map.getInt("NoWarning"))
//				{
//					dpPlan.color(6);
//					DimLine dl(ptDims[0], vecX, vecY);
//					Dim dim(dl ,ptDims, "<>", "<>", _kDimPar, _kDimNone);
//					dpPlan.draw(dim);
//					dpPlan.color(252);					
//				}				
			}
			else 
			{
				Point3d ptDims[0];
				if((ptsDim[1] - ptsGrid[0]).length() > mapStandardTile.getDouble("Width"))
				{
					ptDims.append(ptsGrid[0]);
					ptDims.append(ptsDim[1]);
				}				
				else if ((ptsGrid.last() - ptsDim[ptsDim.length()-2]).length() > dXMax )
				{
					ptDims.append(ptsGrid.last());
					ptDims.append(ptsDim[ptsDim.length()-2]);					
				}	
//				if(ptDims.length() > 0 && !_Map.getInt("NoWarning"))
//				{
//					dpPlan.color(6);
//					DimLine dl(ptDims[0], vecX, vecY);
//					Dim dim(dl ,ptDims, "<>", "<>", _kDimPar, _kDimNone);
//					dpPlan.draw(dim);
//					dpPlan.color(252);					
//				}
			}
		}		
			
		_Map.setPoint3dArray("ptsGrid", ptsGrid);
		
	// Add _PtGs from half tiel columns to the map. Used for tile count and visualisation
		{ 
			Map mapHalfColumn;
			
			for(int i =0; i < _PtG.length(); i++)
				mapHalfColumn.setPoint3d(i, _PtG[i]);
				
			_Map.setMap("mapHalfColumn", mapHalfColumn);		
		}


	// set plane for dimension point projection
		pnSnap = Plane(segErp.ptMid()-vecY*(.5*dYErp+.1*dTxtH), vecYN);

	// draw statistics
		String sData[] = {sManufacturer + " " + sFamilyName, sColor};
		Vector3d vecXTxt = vecX;
		Vector3d vecYTxt = vecY.crossProduct(_ZW).crossProduct(-_ZW);
		vecYTxt.normalize();
		Point3d ptTxt=_Pt0 + vecX * U(100);	
//		if (vecYTxt.dotProduct(_YW) < 0)
//			ptTxt-= vecYTxt*(sData.length()+2)*dTxtH;
		double dYFlag=-3;
		for (int i=0;i< sData.length();i++)
		{
			String s = sData[i];
			if (s.length()<1) continue;
//			dpPlan.draw(s, ptTxt, vecXTxt, vecYTxt, 1,dYFlag, _kDevice);
			dpPlan.draw(s, ptTxt, vecX, vecY, 1,dYFlag, _kModel);
			dYFlag-=3;
		}
		
		double dDistance; 
		if(nTileDistribution == 1 || nTileDistribution == 2)
			dDistance = dAvHalf;

	// export data
		Map mapExport=er.subMapX("Hsb_TileExportData");
		mapExport.setPoint3dArray("HorizontalDistribution", ptsGrid);
		mapExport.setDouble("ColumnWidth", dGrid);
		mapExport.setInt("Staggered", bSwapStaggered);
		mapExport.setDouble("Distance", dDistance);
		mapExport.setInt("nHorizontalAlignment", nHorizontalAlignment);
		mapExport.setDouble("dAvHalf", dAvHalf);
		mapExport.setInt("bPtGLR", bPtGLR);
		mapExport.setPoint3dArray("PtGsHalfColumn", _PtG);

		if(nVergePoint == 2)
		{
			mapExport.setPoint3d("VergePoint", ptsTmp[0]);	
			mapExport.setPoint3d("VergePoint1", ptsTmp[1]);
		}

		else if(nVergePoint == 3)
		{
			mapExport.setPoint3d("VergePoint", ptsTmp[1]);	
			mapExport.setPoint3d("VergePoint1", ptsTmp[0]);
		}
	
		else 
		{
			mapExport.removeAt("VergePoint", true);	
		}
		er.setSubMapX("Hsb_TileExportData", mapExport);	
		er.transformBy(Vector3d(0, 0, 0));
		
		ptsTmp.setLength(0);	

	}// end if mode = 0
//endregion END HORIZONTAL MODE __________


PlaneProfile ppSegs;
	PlaneProfile ppStaggered1;
	PlaneProfile ppStaggered2;
	PlaneProfile ppTile;
	
//region START VERTICAL MODE___________
	if (nMode==2)
	{		

// Distribution//region		
	// Geometry	
		category = T("|Geometry|");	
		String sZOffsetTilePlaneName=T("|Z-Offset|");
		PropDouble dZOffsetTilePlane(1,U(0), sZOffsetTilePlaneName);
		if (_Map.hasDouble("dZOffsetTilePlane"))
		{
			dZOffsetTilePlane.set(_Map.getDouble("dZOffsetTilePlane"));
			_Map.removeAt("dZOffsetTilePlane",true);		
		}
		dZOffsetTilePlane.setCategory(category);	
		dZOffsetTilePlane.setDescription(T("|Defines the total distance between upper face of rafter and the plane on the lower side of the tile lath.|"));


		PropString sFrontCutMode(3,sFrontCutModes, sFrontCutModeName,0);
		if(_Map.hasString("sFrontCutMode"))
		{
			sFrontCutMode.set(_Map.getString("sFrontCutMode"));	
			_Map.removeAt("sFrontCutMode",true);	
		}
		sFrontCutMode.setCategory(category);
		sFrontCutMode.setDescription(sFrontCutModeDesc);		
		int nFrontCutMode=sFrontCutModes.find(sFrontCutMode);	

// TODO get to work in next release

//		PropString sVDistribute(4, sNoYes, T("|Eaven vertical distribution|"),1);
//		sVDistribute.setCategory(category);	
//		sVDistribute.setDescription(T("|The disibution can be eaven for the whole roof or it can change from edge to edge|"));
//		int nVDistribute = sNoYes.find(sVDistribute);
		int nVDistribute = 1;
		
	// store the ZOffsetTilePlane in a subMapX of the roofplane
		if (_kNameLastChangedProp == sZOffsetTilePlaneName)
		{ 
			Map m = er.subMapX("Hsb_TileExportData");
			m.setDouble("ZOffsetTilePlane", dZOffsetTilePlane);
			er.setSubMapX("Hsb_TileExportData",m);	
			er.transformBy(Vector3d(0, 0, 0));// trigger update of dependecies
		}
			
	// get FrontCutPerToRoofplane property
		if (_kNameLastChangedProp==sFrontCutModeName)
			er.transformBy(Vector3d(0, 0, 0));// trigger update of dependecies
		
		Vector3d vecZEave=_ZW;
		int bFrontCutPerToRoofplane;
		if (nFrontCutMode==0) // byRoofplane
		{
		// set export flags to retrieve project data
			ModelMapComposeSettings composeSettings;
			ModelMapInterpretSettings interpreteSettings;	
			interpreteSettings.resolveEntitiesByHandle(true);
			Map map;
			Entity ents[]={er};
			
		// compose
			ModelMap mm;
			mm.setEntities(ents);
			mm.dbComposeMap(composeSettings);
		
		// interrete modelMap
			mm.dbInterpretMap(interpreteSettings);
			map = mm.map().getMap("Model\\EROOFPLANE");
			bFrontCutPerToRoofplane = map.getInt("FRONTCUTPERPTOROOFPLANE");
			if (bFrontCutPerToRoofplane)
			{
				vecZEave=vecZ;		
				nFrontCutMode == 2;
			}

		}
		else if (nFrontCutMode==2) // perpendicular to roofplane
		{
			vecZEave=vecZ;
			bFrontCutPerToRoofplane = true;
		}

	// snap _Pt0 to the closest eave segment found
		double dMin = U(10e5);
		int nEaveIndex=-1;
		int nEaveLATIndex = - 1;
		Point3d ptRoof[] = Line(_Pt0 ,vecY).orderPoints(plEnvelope.vertexPoints(true));	
		int bppRoofByDormer;

	 	ppStaggered1 = ppS;
	 	ppStaggered2 = ppS;
	 	ppTile = ppS; 
	
	// The position of the eave taken for the distribution can be choosen by placing the range check (_Pt0). 
		for (int i=0;i<eaves.length();i++)
		{
			double d = (eaves[i].segment().closestPointTo(_Pt0)-_Pt0).length();	
			if (d<dMin)
			{
				dMin = d;
				nEaveIndex=i;
				nEaveLATIndex = nEaveIndex;
			}
		}
	
	// if no eave exists, take lowest point of the roof
		if(eaves.length()>0)
		{
			_Pt0 = eaves[nEaveIndex].segment().closestPointTo(_Pt0);	
			ptRoof = Line(_Pt0 ,vecY).orderPoints(plEnvelope.vertexPoints(true));	
		}

		else
			_Pt0 = ptRoof[0];

	// Check if lath size has been taken from map (704 ff)
		int bValidLathSection = dYLath>dEps && dZLath>dEps;
		int bValidLathEaveSection = dYLathEave>dEps && dZLathEave>dEps;		
		String sKeyWidth="LathWidth", sKeyHeight="LathHeight";

	// use overrides if defined
		if (!bValidLathSection)
		{
			if (_Map.hasDouble(sKeyWidth)) dYLath = _Map.getDouble(sKeyWidth);
			if (_Map.hasDouble(sKeyHeight)) dZLath = _Map.getDouble(sKeyHeight);			
		}
	
	// add lath section override trigger
		String sSetLathSectionTrigger = T("|Set lath section|");
		if (!bValidLathSection)
			addRecalcTrigger(_kContext, sSetLathSectionTrigger);
		if (_bOnRecalc && _kExecuteKey==sSetLathSectionTrigger) 
		{
			dYLath = getDouble(T("|Enter lath width, 0 = use default|") + " (" + dYLath+") ");
			if (dYLath>dEps)
				_Map.setDouble(sKeyWidth, dYLath);
			else
				_Map.removeAt(sKeyWidth, true);
			
			dZLath = getDouble(T("|Enter lath height, 0 = use default|") + " (" + dZLath+") ");	
			if (dZLath>dEps)
				_Map.setDouble(sKeyHeight, dZLath);
			else
				_Map.removeAt(sKeyHeight, true);				
			setExecutionLoops(2);	
			return;					
		}
		bValidLathSection = dYLath>dEps && dZLath>dEps;					


	// collect grip points at B: any _PtG within the dY range represents a fixed lath and is projected per to the WCS, other PtGs are considered as roof extension points and are projected by frontEndCut property
		Point3d ptsGripsB[0];	
			
		for (int i=1; i<_PtG.length();i++)
		{
			_PtG[i] = Line(_PtG[i], _ZW).intersect(pnErp,0);
			Point3d pt=_PtG[i];
		// fixed lath
//			if (vecY.dotProduct(eaves[0].segment().ptMid()-pt)<0)
			if (vecY.dotProduct(ptRoof[0]-pt)<0)
				pt= (Line(pt, _ZW).intersect(pnErp,dZOffsetTilePlane));
		// below roof extents: extension
			else 
				pt= (Line(pt, vecZEave).intersect(pnErp,dZOffsetTilePlane));

			ptsGripsB.append(pt);
		}
		ptsGripsB = Line(_Pt0, vecY).orderPoints(ptsGripsB);

// Vertical tile distribution
	// collector of all vertical grid points	
		Point3d ptsGrid[0];// export data
		int bAddRidge, bAddEdge;


	// Projecting all points to the offset plane 
		for(int i=0; i< ptsGripsV.length(); i++)
		{		
			if(nEdgeHtype.length()> i && (nEdgeHtype[i] == 1 || nEdgeHtype[i] == 2))
				ptsGripsV[i] = Line(ptsGripsV[i], _ZW).intersect(pnErp,dZOffsetTilePlane);		
			else
				ptsGripsV[i] = Line(ptsGripsV[i], vecZEave).intersect(pnErp,dZOffsetTilePlane);	
		}

		if(ptRoof.length() && ptsGripsV.length())
		{
		// Add roof points if more extrem
			if( vecY.dotProduct(ptRoof[0] - ptsGripsV[0])+dEps < 0)
			{
				ptsGripsV.insertAt(0, ptRoof[0]);
				nEdgeHtype.insertAt(0 ,- 1);
				dOffsets.insertAt(0, 0);
				//nEaveIndex++;
				bAddEdge = true;
			}
		
			if(vecY.dotProduct(ptRoof[ptRoof.length()-1] - ptsGripsV[ptsGripsV.length()-1])-dEps > 0)
			{
				ptsGripsV.append(ptRoof[ptRoof.length() - 1]);
				nEdgeHtype.append(100);
				dOffsets.append(0);
				bAddRidge = true;
				dRidgeLAFs.append(0);
			}	
		}

	// collect vertices of (modified) roof envelope and  get top ref point
		ptsGripsV=lnY.orderPoints(ptsGripsV);
				
		int nRangeColor = nRed;
		int nRidgeNum;
		double dSection;
		double dRangeSnap;
		double dStandardAv = (dYMin + dYMax) / 2;
		double dMinMax = dStandardAv;
		double dStandardDist = (dYMax - dYMin)/2;
		double dAv, dEaveDist, dEaveAv;
		Point3d ptDormerDim;
		
	// Check data
		if (ptsGripsV.length()<1 || dStandardAv < dEps)
		{
			reportMessage("\n" + T("|Unexpected error.|"));
			eraseInstance();
			return;	
		}
		
	// get ridge and eave ranges to calcuate the distribution
		if(nEaveLATIndex > -1 && dEaveLATs.length() > nEaveLATIndex * 2 )
		{
			dEaveDist = (dEaveLATs[nEaveLATIndex * 2 + 1] - dEaveLATs[nEaveLATIndex * 2])/2;
			dEaveAv = (dEaveLATs[nEaveLATIndex * 2 + 1] + dEaveLATs[nEaveLATIndex * 2]) / 2;
		}
		
		
	// Trigger SwapStaggered
		int bAdjustDormer = _Map.getInt("bAdjustDormer");
		String sTriggerAdjustDormer =bAdjustDormer?T("|Use sloped dormer roof function|"):T("|Do not use sloped dormer roof function|");
			
		addRecalcTrigger(_kContext, sTriggerAdjustDormer);
		
		if (_bOnRecalc && _kExecuteKey==sTriggerAdjustDormer)
		{
			bAdjustDormer = bAdjustDormer ? false : true;
			_Map.setInt("bAdjustDormer", bAdjustDormer);		

		}			
	

	// Custom command adjust dormer roof to a fit tilinig
		int bSlopedDormer;
		if(bAdjustDormer)
		{ 
		// Check for potential single pitched dormer roof to set special ridge definition	
			ERoofPlane rpAll[] = er.getAllRoofPlanes(); 
			Point3d ptDormer1, ptDormer2;
			Map mapRP;
			Vector3d vecYHor = er.coordSys().vecX().crossProduct(_ZW); vecYHor.vis(ptOrg, 3);
			Plane pnDormer(ptOrg + vecZ*dZOffsetTilePlane, vecZ);
			Plane pnNormX(segErp.ptMid(), vecX);
			Plane pnMain;
			Point3d ptCross;
			double dZOffset;
			Vector3d vecYAll;
			double dDormerAv;
			int nSameDir;
						
			for(int j=0; j < rpAll.length();j++)
			{
				CoordSys csAll = rpAll[j].coordSys();
				Vector3d vecYHorAll = csAll.vecX().crossProduct(_ZW);
				Vector3d vecZM = csAll.vecZ();
				vecYAll = csAll.vecY();
				nSameDir = (vecYHor.isCodirectionalTo(vecYHorAll));
				if(!nSameDir  || Vector3d(csAll.ptOrg() - ptOrg).length() > U(20000) ||  rpAll[j].findParentRoofplane().bIsValid() )
					continue;
					
				mapRP = rpAll[j].subMapX("Hsb_TileExportData");
				dZOffset = mapRP.getDouble("ZOffsetTilePlane");	
				PlaneProfile ppErpM = mapRP.getPlaneProfile("ppErp");
				pnMain = Plane (csAll.ptOrg()+ vecZM*dZOffset, vecZM);
				Line lnInter;

				if(pnMain.hasIntersection(pnDormer))
				{
					lnInter= pnMain.intersect(pnDormer);
					ptCross = pnNormX.closestPointTo(lnInter.ptOrg());	
					
				}
				if(ptCross != _PtW && _ZW.angleTo(vecY) > _ZW.angleTo(rpAll[j].coordSys().vecY()) && ppErpM.pointInProfile(ptCross) ==_kPointInProfile)
				{
					ptDormer1 = ptCross; ptDormer1.vis(2);
					rpMain = rpAll[j];
					break;
				}
			}		
	
		// Check if segDormer and segMainRoof are in one line => ERoofplane is a single pitched dormer roof		
			if(rpMain.bIsValid() && ptCross != _PtW && nSameDir)
			{
				Point3d ptsV[] = mapRP.getPoint3dArray("VerticalDistribution");
				Plane pnDormer(ptsGripsV[0], vecZ);
				int bPtFound;
	
				if(ptsV.length() > 1)
				{
					Vector3d vecMain(ptsV[1] - ptsV[0]);
					vecMain.normalize();
						
					for(int i=0; i < ptsV.length(); i++)
					{
						bPtFound = true;
						if(vecMain.dotProduct(ptsV[i] - ptDormer1) > 0)
						{
							ptDormer1 = ptsV[i];
							if(i > 0)
								ptDormer2 = ptsV[i - 1];
							break;
						}
						bPtFound = false;
					}					
				}
				if(bPtFound)						
					bSlopedDormer = true;
			}	

			if (bSlopedDormer ==1)
			{ 				
				String sDormerAdjustName[] = { T("|No adjustment|"), T("|Adjust tiling|"), T("|Adjust pitch upwards|"), T("|Adjust pitch downwards|"), T("|Move roofplane upwards|"), T("|Move roofplane downwards|") };
				PropString sDormerAdjust(4, sDormerAdjustName, T("|Adjust sloped dormer|"),1);
				sDormerAdjust.setCategory(category);	
				sDormerAdjust.setDescription(T("|The connection of a sloped dormer and a main roof can be adjusted by setting the top lath  or changing the roofangle of the dormer roof|"));
				int nDormerAdjust = sDormerAdjustName.find(sDormerAdjust);	
				
			// Reset all previous settings before adjusting the dormer roof
				if(_kNameLastChangedProp == T("|Adjust sloped dormer|") || _kNameLastChangedProp == sZOffsetTilePlaneName)
				{
					if(_Map.hasMap("mapPtsEr"))
					{
						Point3d pts[0];
						Map mapPtsEr = _Map.getMap("mapPtsEr");
			
						for(int j=0; j < mapPtsEr.length(); j++ )				
							pts.append(mapPtsEr.getPoint3d(j));
							
						er.setVertices(pts);

						_Map.removeAt("mapPtsEr", true);
						return;
					}
				}
			
			// The roofplane is changed to adjust the tiling
				if(nDormerAdjust > 1 && !_Map.hasMap("mapPtsEr"))
				{
					Point3d ptDormer = (nDormerAdjust == 2 || nDormerAdjust == 4 ) ? ptDormer1 : ptDormer2;
					int n = (nDormerAdjust == 2 || nDormerAdjust == 4) ? 1 : -1;
					Vector3d vecZR = vecZ;
					Vector3d vecYDormer;	
					CoordSys csDormer = csErp;
					double dYAdjust;
					double dMove;
					int bAdjust = true;
					
					for(int j=0; j < 3;j++)
					{
						vecYDormer = (pnNormX.closestPointTo(ptDormer - vecZR*dZOffsetTilePlane) - pnNormX.closestPointTo(_Pt0));	
						vecYDormer.normalize();
						vecZR = vecX.crossProduct(vecYDormer);
					}		
					
					Point3d ptIntersect;
					Line lnIntersect (_Pt0, vecYDormer);
					if(lnIntersect.hasIntersection(pnMain))
						ptIntersect = lnIntersect.intersect(pnMain, 0);	
					else
					{
						reportMessage(T("|No possible intersection between slooped dormer and main roof|"));
						bAdjust = false;
					}
					
				// If intersection found	
					if(bAdjust)
					{
					// Adjust the angle of the dormer roof to match the tiling of the main roof
						if( nDormerAdjust < 4)
						{	
							double dAngleNew = vecY.angleTo(vecYDormer);
							csDormer.setToRotation(dAngleNew, n*vecX, _Pt0);		
							dMove = vecYDormer.dotProduct(ptIntersect - _Pt0) - vecY.dotProduct(ptsGripsV.last() - _Pt0);
						}
						else
						{
							Plane pn(ptIntersect, vecYHor);
							Point3d ptIntersect1 = Line(ptsGripsV.last(), vecY).intersect(pn, 0); 
							dYAdjust = _ZW.dotProduct(ptIntersect - ptIntersect1);		
							dMove = n * (ptIntersect1 - ptsGripsV.last()).length();
						}
					
						Point3d ptsEr[] = er.vertices();	
						Map mapPtsEr;
						
						for(int j=0; j < ptsEr.length();j++)
						{
							mapPtsEr.appendPoint3d("ptsEr", ptsEr[j], _kAbsolute );
							double dMatch = vecYDormer.dotProduct(ptsGripsV.last() - ptsEr[j]);
							if(dMatch < dEps && dMatch > -dEps)
								ptsEr[j] += vecY * dMove;
								//ptsEr[j] += vecYDormer * dMove;
							if(nDormerAdjust > 3)
								ptsEr[j] += _ZW * dYAdjust;
						}
					
						er.setVertices(ptsEr);
						
						if( nDormerAdjust < 4)	
							er.transformBy(csDormer);
	
						_Map.setMap("mapPtsEr", mapPtsEr);						
					}
				}
				
			// Only the tiling is adjusted. The roodplane is kept
				if(nDormerAdjust == 1)
				{
					PLine plCirc;
					plCirc.createCircle(ptDormer1, vecX, dStandardAv);
					Point3d ptTops[] = plCirc.intersectPoints(pnDormer);
					if(ptTops.length()> 1 && vecY.dotProduct(ptTops[0] -ptTops[1]) > 0)
						ptTops.swap(0, 1);
		
					if(ptTops.length() < 1)
					{
						reportMessage(T("|Adjustment impossible|"));
						return;
					}	
		
				// Recalc the distance from ptDormer1 to the top dormer lath
					double dDormerLength = vecY.dotProduct(ptTops[0] - _Pt0) - dEaveAv;
					
					int nNRow;
					double dDS = dEaveDist;
					if(dStandardAv)
						nNRow = dDormerLength / dStandardAv;
					if(nNRow > 0)
						dDS += nNRow * dStandardDist;
			
				// Calculation used ranges
					double dDiff = dDormerLength - nNRow * dStandardAv;		
					
				// Check is set negative if distance is smaller than. This way dStandardAv can become smaller, too.
					if(abs(dDiff) > abs(dDiff-dStandardAv))
					{
						dDiff -= dStandardAv;
						dDS += dStandardDist;
						nNRow++;
					}
							
					double dAv = (dDS > 0)?  dDiff / dDS : 0;
					dDormerAv = dStandardAv + dAv * dStandardDist;
					
					plCirc.createCircle(ptDormer1, vecX, dDormerAv);
					plCirc.vis(2);
					ptTops = plCirc.intersectPoints(pnDormer);
					if(ptTops.length()> 1 && vecY.dotProduct(ptTops[0] -ptTops[1]) > 0)
						ptTops.swap(0, 1);
						
					if(ptTops.length() < 1)
					{
						reportMessage(T("|Adjustment impossible|"));
						return;
					}	
						
					if(ptsGripsV.length() > 1)
					{
						ptDormerDim = ptsGripsV.last();
						ptsGripsV.last() = ptTops[0];							
					}

					
					PlaneProfile ppMain = mapRP.getPlaneProfile("ppRoof");
					Point3d ptsMain[] = ppMain.getGripEdgeMidPoints();
					int nPt = -1;
					double dPtDist = U(20000);
					
					for(int j=0; j < ptsMain.length(); j++)
					{
						Point3d ptTest = ptsMain[j] - vecY * dEps;
						if(ppMain.pointInProfile(ptTest) == 1)
						{
							Vector3d vecTest (ptDormer1 - ptTest);
							if(vecTest.length() < dPtDist)
							{
								nPt = j;
								dPtDist = vecTest.length();
							}
						}
					}		
					
					if(nPt > -1)
					{
						dPtDist = vecYAll.dotProduct(ptDormer1 - ptsMain[nPt]);
						ppMain.moveGripEdgeMidPointAt(nPt, vecYAll * (dPtDist - dDormerAv));
					}
				}
				
			// Set ridge lath distance to zero
				for(int j=0; j < dRidgeLAFs.length(); j++)
					dRidgeLAFs[j] = 0;
			}
		}	

	//Defines if the roof has an eave or ridge. Otherwise lowest/ highest point is used
		int nNoEave = dEaveLATs.length() == 0;
		int nNoRidge = dRidgeCTDs.length() == 0;
		
		double dUsedZOff = (nFrontCutMode == 1) ? dZOffsetTilePlane / cos(dPitch) : dZOffsetTilePlane;
		double dUsedEave;
	
	// Distribution
		for(int i= ptsGripsV.length()-1;i > -1; i--)
		{
			int nType = nEdgeHtype[i]; 
	
			if(saddleRidges.length() > 0)
			{
				if(nType != 1)
					continue;				
			}
	
			else if(pentRidges.length() > 0 && nType != 2)
				continue;
											
			double  dRidgeDist, dRidgeAv, dDist, dLAF;
			int nNumRow;	
			nRidgeNum = i;
			int nRidge = (nNoEave)? i -1 : i - eaves.length();	
			//nRidgeNum = nRidge;
			//nRidge = 0;

		// ridge adjustment of the ridge used to make the distribution
			if(dRidgeCTDs.length() > nRidge*2)
			{
				dRidgeDist = (dRidgeCTDs[nRidge * 2+1] - dRidgeCTDs[nRidge * 2])/2;
				dRidgeAv = (dRidgeCTDs[nRidge * 2+1] + dRidgeCTDs[nRidge * 2]) / 2;
				dLAF = dRidgeLAFs[nRidge];
			}
				
		// Calculating the distribution
		
		
			dDist = vecY.dotProduct(ptsGripsV[i] - (_Pt0 + vecY * dOffsets[nEaveIndex] + vecZEave * dUsedZOff)); ptsGripsV[i].vis(6);
//			dDist = vecY.dotProduct(ptsGripsV[i] - (ptRoof[0]));//+ vecY * dOffsets[nEaveIndex])); 
			dDist -= dEaveAv;
			dSection += dEaveDist;		
					
			if(dDist > 0) // roofplane is longer than one tile
			{					
				dDist -= (dLAF + dRidgeAv);	
				dSection += dRidgeDist;
			}	
			
			if(dStandardAv > 0)
				nNumRow = round(dDist / dStandardAv);
			if(nNumRow > 0)
				dSection += nNumRow * dStandardDist;
		
		// Calculation used ranges
			double dDiff = dDist - nNumRow * dStandardAv;		
			
		// Check if  negative  distance is smaller . This way dStandardAv can become smaller, too.
			if(abs(dDiff) > abs(dDiff-dStandardAv))
			{
				dDiff -= dStandardAv;
				dSection += dStandardDist;
				nNumRow++;
			}
					
			dAv = (dSection > 0) ? dDiff / dSection : 0;	

		// Startpoint for range snap segents
			double dEaveAdd = (dEaveAv > dEps)?	dEaveAv - dStandardAv : 0;
			dRangeSnap = nNumRow * dStandardAv + dRidgeAv + dLAF + dEaveAdd;
			
		// Change ranges from averidge to used size
			dEaveAv = dEaveAv + dAv * dEaveDist;
			dUsedEave = dEaveAv;
			dRidgeAv = dRidgeAv + dAv * dRidgeDist;
			dStandardAv = dStandardAv + dAv * dStandardDist;

		
		// Calculate rest if used eave is not bottom eave
			double dRest = vecY.dotProduct((_Pt0 + vecY*dOffsets[nEaveIndex]) - ptsGripsV[0]) + dEaveAv; 
			int nRest = dRest / dStandardAv;
			dRest -= nRest * dStandardAv;
			
		// Distribution stopp. Get range of top ridge/point
			double dTopRidge;
			if(bAddRidge)
				dTopRidge = 0;
			else if(nRidge == dRidgeLAFs.length()-1)
				dTopRidge = dRidgeAv + dLAF;
			else
			{
				dTopRidge = dAv* (dRidgeCTDs.last() - dRidgeCTDs[dRidgeCTDs.length()-2])/2;
				dTopRidge += (dRidgeCTDs.last() + dRidgeCTDs[dRidgeCTDs.length()-2])/2;
				dTopRidge += dRidgeLAFs.last();					
			}

			if(nEaveIndex == 0 || !nVDistribute && !bAddEdge)					
			{
				ptsGrid.append(ptsGripsV[0] + vecY*dEaveAv);	
				dRest = dEaveAv;
			}			
			else
				ptsGrid.append(ptsGripsV[0] + vecY*dRest);
							
		// If distrbute is not eaven add edgesHorizontal to ptsGripsB		
			if(nVDistribute == 0)
			{
				int nEdgeHtypes[] = { 0, 1, 2, 3, 13};
				int nEave;
					
				for(int j=0; j < ptsGripsV.length(); j++)
				{
					int nFind = nEdgeHtypes.find(nEdgeHtype[j]);
	
					if( nFind == -1)
						continue;
					Point3d ptAdd = ptsGripsV[j];
		
					if(nFind == 0)
					{		
						if (dEaveLATs.length() > j * 2 )
						{
							ptAdd += vecY*(dEaveLATs[j * 2 + 1] + dEaveLATs[j * 2]) / 2;
							ptAdd += vecY*dAv*(dEaveLATs[j * 2 + 1] - dEaveLATs[j * 2]) / 2;							
						}
						nEave++;
					}	
					else
					{		
//						int nI = j - eaves.length();
						int nI = j - nEave;
		
						if(dRidgeCTDs.length() > nI * 2)
						{
							//ptAdd -= vecY*(dRidgeCTDs[nI * 2+1] + dRidgeCTDs[nI * 2]) / 2;
							//ptAdd += vecY * dAv * (dRidgeCTDs[nI * 2 + 1] - dRidgeCTDs[nI * 2]) / 2;
							ptAdd -= vecY*dRidgeLAFs[nI];
						}	
					}
					ptsGripsB.append(ptAdd);

				}	
				ptsGripsB = Line(_Pt0, vecY).orderPoints(ptsGripsB);
			}

			for(int j=0; j < ptsGripsB.length()+1; j++)
			{
				Point3d ptDist1 = (j == 0) ? (ptsGripsV[0] + vecY * dRest) : ptsGripsB[j-1];
				Point3d ptDist2 = (j == ptsGripsB.length()) ? (ptsGripsV.last() - vecY * dTopRidge) : ptsGripsB[j];  ptDist2.vis(5);
				double d = vecY.dotProduct(ptDist2 - ptDist1) ;
				double d1 = vecY.dotProduct((ptsGripsV[i]-vecY*(dLAF+dRidgeAv)) - ptDist1);			
		
				if(d1 < -dEps || ! nVDistribute || ptsGripsB.length() > 0)  // || _PtG.length() > 0) // changed 20.02 has to be tested
					d1 = d;
					
			// New calculation of dStandard if ptsGripsB existing
				int n = (d1+dEps)/dStandardAv;
					
				if(n > 0)
					d1 = (abs(d1/n - dStandardAv) < abs(d1/(n+1) - dStandardAv))?  d1 / n : d1/(n+1);

				if(d1 < dEps)
					continue;					
		
	
				while(d+dEps >= d1)
				{
					ptsGrid.append(ptsGrid.last() + vecY * d1);	
					PLine pl(ptsGrid.last() - vecX * 0.3 * dXMax, ptsGrid.last() + vecX * 0.3 * dXMax);
						
					if (nDisplayContent!=1)
						dpPlan.draw(pl);		
					d -= d1;
				}
	
				PLine pl(ptsGrid.last() - vecX * 0.3 * dXMax, ptsGrid.last() + vecX * 0.3 * dXMax);						
				//if (nDisplayContent!=1) dpPlan.draw(pl);				
			}	

			if(ptsGrid.length() > 0)
			{
				ptsGrid.append(ptsGrid.last() + vecY * (dTopRidge - dRidgeLAFs.last()));				
			}

			ptsGrid.append(ptsGripsV.last());
			break;								
		}
	
	// Split roofplane into segments if tiles are staggered	
		//if(false) 
		double dLAFHalfsCount;
		PlaneProfile ppEave = ppStaggered1;		
		//ppStaggered1.vis(2);

	//To calculate the amound of tiles the grid is always created
		//if(nTileDistribution==1)
		{
//			PlaneProfile ppEave = ppRoof;
//			PlaneProfile ppEave = ppStaggered1;		

			for(int i=1; i < eaves.length(); i++)
			{				
				double dEave;
				
				if(dEaveLATs.length() > i*2)
				{
					double dEDist = (dEaveLATs[i * 2+1] - dEaveLATs[i * 2])/2;
					dEave = (dEaveLATs[i * 2+1] + dEaveLATs[i * 2]) / 2;
					dEave += dAv * dEDist;
				}
	
				double dUsedOh = dOverhang - dEave;
				Point3d ptEave = eaves[i].segment().ptMid();
				
				if(dEave > dEps)// && dEave > dStandardAv)
				{
					dEave -= dStandardAv - dUsedOh;
					Point3d ptsE[] = ppEave.getGripEdgeMidPoints();
					double dPoint = U(10000);
					int nMove = - 1;
					
					for(int j=0; j < ptsE.length(); j++)
					{	
						if (ppEave.pointInProfile((ptsE[j] + vecY * dEps)) != _kPointInProfile) 
							continue;
							
						if((ptEave - ptsE[j]).length() < dPoint)
						{
							dPoint = (ptEave - ptsE[j]).length();
							nMove = j;
						}
					}
					
					if(nMove > -1)
						ppEave.moveGripEdgeMidPointAt(nMove , vecY * (dEave + dEps));
				}	
			}			

			//ppStaggered2 = ppStaggered1;
			PlaneProfile ppSt1 = ppEave;//ppRoof;//ppStaggered1;
			PlaneProfile ppSt2 = ppEave;//ppRoof;//ppStaggered2; 
			
			int nCount;		
			Plane pnRoof(ppRoof.coordSys().ptOrg(), vecZ);
			Point3d pt1 = segErp.ptStart() - vecX * U(500); 
			Point3d pt2 = segErp.ptEnd() - vecY * vecY.dotProduct(segErp.ptEnd() - pt1) + vecX * U(500); 
			PLine plSub(vecZ);
			Point3d ptsGrid1[0];
			ptsGrid1.append(ptsGripsV[0]);
			ptsGrid1.append(ptsGrid);
			
		// If the tiling is part of the overhang, create a longer tile	
			int bOverhang;
			
			for (int i = 0; i < ptsGrid1.length()-1; i++)
			{
				if(i==0 &&	ptsGrid1.length()>1 && vecY.dotProduct(ptsGrid1[2] - ptsGrid1[0]) <= dOverhang)
					bOverhang = true;
				else if(i > 1)
					bOverhang = false;
				 
				Point3d ptS1;
				if(i==0)
					ptS1 = pt1;
				else
					ptS1= pt1 + vecY * vecY.dotProduct(ptsGrid1[i] - pt1);
					
				Point3d ptS3 = pt2 + vecY * vecY.dotProduct(ptsGrid1[i] - pt2);
				ptS1 = pnRoof.closestPointTo(ptS1);
				ptS3 = pnRoof.closestPointTo(ptS3);
				pt2 = pnRoof.closestPointTo((pt2));
				LineSeg segGridV[0];
				segGridV = ppEave.splitSegments(LineSeg(ptS1, ptS3), true);
				
				if (nDisplayContent != 1 && !bOverhang )
				{
					if(segGridV.length() > 0 && i > 0)
						dpGrid.draw(segGridV);
				}
				
				Point3d ptS2 = pt2 + vecY * vecY.dotProduct(ptsGrid1[i + 1] - pt2);
				ptS2 += vecX* U(10);
				LineSeg seg(ptS1, ptS2);
				plSub.createRectangle(seg, vecX, vecY);
 				PlaneProfile ppSub(plSub);
 				
 			// Make sure the tile has an overhang. This is needed, if the range is not set at the lowest eave
 				if(bOverhang && i==0)
 				{
	 				if ( i % 2 == 1)
						ppSt1.subtractProfile(ppSub);		
					else 
	 					ppSt2.subtractProfile(ppSub);					
 				}
				else
				{
					if ( i % 2 == 1)
						ppSt2.subtractProfile(ppSub);	
					else 
	 					ppSt1.subtractProfile(ppSub);					
				}
				
			}

			ppStaggered1.subtractProfile(ppSt1); 
			ppStaggered2.subtractProfile(ppSt2);  
		}
	
	//TODO IF EAVE AND rIDGE ARE AT THE SAME HIGHT CALCULATION CAN BE WRONG
		//if(edgesHorizontal.length()>0)
		{
			int nCount , nCountI, nAdd, nI, nRidge, nEave;
			double dEdgePrev;
			nRidgeNum -= eaves.length(); 

			for (int i = 0; i < ptsGrid.length();i++)
			{ 
			 	if(nCount > ptsGripsV.length()-1)
			 		break;	
			 		
			 	if(nEaveLATIndex > nCount && !nVDistribute && !nAdd)
					nAdd = 1;
				else if(nEaveLATIndex <= nCount && !nVDistribute)
					nAdd = 0;
			 		
			 	nCountI++;
			 	
			 	int nSub = (nEdgeHtype[nCount] == 0) ? U(50) : 0;
			 	
			 	if((vecY.dotProduct(ptsGrid[i] - ptsGripsV[nCount]) > -nSub &&  vecY.dotProduct(ptsGrid[i] - ptsGripsV[nCount]) < dStandardAv + nSub) || i== ptsGrid.length()-1)
			 		nI = i;
			 		
			 	int bEdgeHArgument = vecY.dotProduct(ptsGrid[i] - ptsGripsV[nCount + nAdd]) > - nSub;
		 				 	
			 	if(bEdgeHArgument  || i== ptsGrid.length()-1)
			 	{		 			
			 		if(nCount > edgesHorizontal.length()-1)
			 			continue;
			 			
			 	// Use only edges with a length		
			 		LineSeg segL = edgesHorizontal[nCount].segment();
					if(segL.length() < dEps)
						continue;
			 		
			 		Point3d ptAv;
					double dRange;
					Point3d ptDims[0];

					double dUsedAv = (nVDistribute) ? dStandardAv : dMinMax;
					if( nCount==nEaveLATIndex)
						dUsedAv = dMinMax;

					double dEaveDef, dRidgeDef;

					if(nVDistribute)
					{
						if(i == ptsGrid.length()-1)
							ptAv = ptsGrid[i-1] ;		
						else
							ptAv = ptsGrid[nI] ;	
					}

					else
					{
						ptAv = (nCount > 0) ? ptsGripsV[nCount - 1] : ptsGripsV[0];
				 		ptAv += vecY * (nCountI + 1) * dUsedAv;					
					}	

				 // Eave
			 		if(nEdgeHtype[nCount] == 0)
			 		{
			 		// range snap segments
			 			double dEaveDist, dEaveAv;
			 			
						if (dEaveLATs.length() > nEave * 2 )
						{
							dEaveDist = (dEaveLATs[nEave * 2 + 1] - dEaveLATs[nEave * 2])/2;
							dEaveAv = (dEaveLATs[nEave * 2 + 1] + dEaveLATs[nEave * 2]) / 2;
							dEaveDef = dEaveAv;
							dEaveAv += dAv * dEaveDist;

							if(nEave > 0)
							{
								dEdgePrev = (dEaveLATs[(nEave-1) * 2 + 1] + dEaveLATs[(nEave-1) * 2]) / 2;	
								dEdgePrev += dAv*(dEaveLATs[(nEave-1) * 2 + 1] - dEaveLATs[(nEave-1) * 2])/2;
							}
							else
								dEdgePrev = vecY.dotProduct(ptsGrid[0] - ptsGripsV[0]);
						}
		 		
				 		dRange = dEaveDist;		
				 		double dA = vecY.dotProduct(ptsGrid[nI + 1] - ptsGripsV[nEave]);			
						int a = (dEaveAv + U(5)> dA)?  nI+1 : nI;
						
						if(nVDistribute)
						{
							ptAv -= vecY * (dEaveAv - dUsedAv);
							if(vecY.dotProduct(ptAv-ptsGrid[i]) < U(50))
								ptAv += vecY * dUsedAv;
						}
						else
						{
							ptAv += vecY*(dEaveAv - dEdgePrev);						
							if(nEaveLATIndex > nEave)
							{
								if(nVDistribute)
									ptAv = ptsGrid[a] + vecY * (dStandardAv - dEaveAv);
								else
									ptAv = ptsGripsV[nEave + 1] - vecY * ((nCountI-1)* dMinMax );
							}												
						}

						ptAv -= vecY * dOffsets[nCount];						
				 		ptDims.append(ptsGripsV[nCount]);
										 		
				 		if(a < ptsGrid.length()-1 && abs(vecY.dotProduct(ptDims.last() - ptsGrid[a]))< 0.5*dEaveAv)
				 			ptDims.append(ptsGrid[a+1]);	
				 		else
				 			ptDims.append(ptsGrid[a]);;
				 			
				 		nEave++;
				 	}				 	
				 	
				 // Ridge
				 	else if(nEdgeHtype[nCount] == 1 || nEdgeHtype[nCount] == 2 || nEdgeHtype[nCount] == 3 || nEdgeHtype[nCount] == 13)
				 	{
				 		double dRidgeDist, dRidgeAv, dLAF, dLAFPrev;

						if( dRidgeCTDs.length() > nRidge*2)
						{
							dRidgeDist = (dRidgeCTDs[nRidge * 2+1] - dRidgeCTDs[nRidge * 2])/2;
							dRidgeAv = (dRidgeCTDs[nRidge * 2+1] + dRidgeCTDs[nRidge * 2]) / 2;
							dRidgeAv += dAv * dRidgeDist;
							dRidgeDef += dRidgeAv;
							dLAF = dRidgeLAFs[nRidge];
							dLAFHalfsCount = dLAF;
							dRidgeDef += dLAF;
						}	
						
				 		ptAv += vecY * dRidgeDef;
				 		if(nRidge > nRidgeNum)
				 		ptAv += vecY * (dUsedAv - dRidgeAv);					
				 		
						ptAv += vecY * dOffsets[nCount];	
				
//					 	dRange = dRidgeDist;
					 	dRange = 0;
						
						if(ptDims.length() == 0)
						{
							if(ptsGrid.length()>2 && dLAF > dEps && nI > 1)
								ptDims.append(ptsGrid[nI-2]);								
							ptDims.append(ptsGrid[nI-1]);// - vecY*dOffsets[nCount]);							
						}
						ptDims.append(ptsGripsV[nCount]) ;//- vecY*dOffsets[nCount]);
						
						nRidge++;
						int nn = nEdgeHtype[nCount];
						
					// Adjust pent ridge if eave cut is perpendicular
						if(nEdgeHtype[nCount] == 2 && nFrontCutMode==2)
							ptAv -= vecY*dZOffsetTilePlane * tan(dPitch);

				 	}
			 	
//				 	else
//						continue;

					Point3d ptUsedBottom, ptUsedTop;
				
				// Roof has no eave or ridge or both.  If fixed lath existing they are used otherwise the extreme points.
					if(nNoEave || nNoRidge)
				 	{						 		
				 		double dSub;
				 		ptUsedBottom = _Pt0;
				 		ptUsedBottom = Line(ptUsedBottom, vecZEave).intersect(pnErp, dZOffsetTilePlane);
				 		
				 		if(nNoEave)
				 		{
				 			dSub += dRidgeDef;
				 		}
				 		ptUsedTop;
				 		if(nNoRidge)
				 		{
				 			ptUsedTop = ptsGripsV.last();
				 			dSub += dEaveDef;
				 		}
				 		
				 		if(ptsGripsB.length() >0)
				 		{
				 			ptsGripsB[0] = Line(ptsGripsB[0], vecZEave).intersect(pnErp, dZOffsetTilePlane);
				 			
				 			if(ptsGripsB.length() > 1)
				 			{
				 				ptsGripsB.last() = Line(ptsGripsB.last(), vecZEave).intersect(pnErp, dZOffsetTilePlane);
				 				ptUsedBottom = ptsGripsB[0];
				 				ptUsedTop = ptsGripsB.last();
				 			}
				 			else
				 			{
				 				if(vecY.dotProduct(ptsGripsB[0] - ptUsedBottom) < vecY.dotProduct(ptUsedTop - ptsGripsB[0]))
				 					ptUsedBottom = ptsGripsB[0];
				 				else
				 					ptUsedTop = ptsGripsB[0];
				 			}
				 		}

				 		double dCalc = vecY.dotProduct(ptUsedTop - ptUsedBottom); ptUsedTop.vis(3); ptUsedBottom.vis(2);
				 		dCalc -= dSub + dOffsets[nCount];
				 		int nNumRange = dCalc / dMinMax ;
				 		double dUsedAv = (abs(dCalc / nNumRange - dMinMax ) < abs(dCalc / (nNumRange+1) - dMinMax )+ U(1))? dCalc / nNumRange : dCalc / (nNumRange+1);
				 		nNumRange = (dCalc + dEps) / dUsedAv;
				 		dRange += (nNumRange * dStandardDist + dEaveDist) ;
				 		dRangeSnap = (nNumRange) * dUsedAv + dEaveDef;				
//				 		
						if(vecY.dotProduct((ptUsedTop- vecY * dRangeSnap) - ptUsedBottom) <= 0.8 * dMinMax )
						{
							
				 			nNumRange--;	
				 			//dRange = dStandardDist;
						}


				 		dRangeSnap = (nNumRange) * dMinMax + dEaveDef;
				 		//dRangeSnap += (nEdgeHtype[nCount] == 0) ? dOffsets[nCount] : -dOffsets[nCount];

				 		ptAv = ptUsedTop - vecY * (dRangeSnap + dOffsets[nCount]) - vecX*vecX.dotProduct(ptUsedTop - ptUsedBottom);

				 	}			 	

				 // Choosen Eave gets a range section
				 	else if( nCount==nEaveLATIndex)
					{		
						dRange = dSection;
						ptAv = ptsGripsV[nRidgeNum+eaves.length()] - vecY * dRangeSnap - vecX * vecX.dotProduct(ptsGripsV[nRidgeNum+eaves.length()] - _Pt0);	
						ptAv += (nEdgeHtype[nCount] == 0) ? -vecY*dOffsets[nCount] : +vecY*dOffsets[nCount];
					}
					
					 if (nCount!=nEaveLATIndex)
					{
						ptAv += vecX * vecX.dotProduct(ptsGripsV[nCount] - ptAv);
						
						double dOffset = (nEdgeHtype[nCount] == 0) ? - dOffsets[nCount] : dOffsets[nCount];
						
						while(vecY.dotProduct(ptAv - (ptsGripsV[nCount] + vecY*dOffset)) > 1.5*dUsedAv)
							ptAv -= vecY * dUsedAv;
						 if(vecY.dotProduct(ptAv - (ptsGripsV[nCount] + vecY*dOffset))  < 0.5*dUsedAv)
							ptAv += vecY * dUsedAv;
					}

						
					ptAv.vis(4);
					
					if(nCount != nEaveIndex && !nVDistribute)
						dRange += (nCountI) * dStandardDist;	
	
				 // Check range
				 	nRangeColor = nRed;
					double dRangeDist = abs(vecY.dotProduct(ptsGripsV[nCount] - ptAv));
					dRangeDist -= dUsedAv - dOffsets[nCount];
//					dRangeDist -= dEaveAv - dOffsets[nCount];

					int nH = (dRangeDist+dEps) / dMinMax;
//					dRangeDist -= nH * dMinMax;
					dRangeDist -= (nCount == nEaveLATIndex)?  nH * dMinMax : nH*dUsedAv;
				
					if(abs(dRangeDist) < dRange+dEps || abs(dRangeDist - dUsedAv) < dRange+dEps)
						nRangeColor = nGreen;		
						
				// Adjusting rangesnap by offset
					//ptAv += (nEdgeHtype[nCount] == 0) ?  -vecY*dOffsets[nCount] : +vecY*dOffsets[nCount];
					
					if (nDisplayContent != 1 && nRidge != nRidgeNum+1)//&& !nVDistribute)// || nCount != ptsGripsV.length()-1) 
					{							
						double dYFactor = .33;						
						for (int s = 0; s < 3; s++)
						{
							Point3d ptStart = ptAv + vecY * dRange + vecX * dYFactor * .5 * dXMax;
							Point3d ptEnd = ptAv - vecY * dRange- vecX * dYFactor * .5 * dXMax;
							LineSeg seg(ptStart, ptEnd);
							
							dpPlan.color(s == 1 ? nRangeColor : ncGrid);
							if(nCount != nEaveLATIndex && nRangeColor == nGreen)
								dpPlan.color(nGreen);
							
							PLine plRange(vecZ);

							if(nCount==nEaveLATIndex || !nVDistribute || nNoEave)
							{
								plRange.createRectangle(seg, vecX, vecY);
								plRange.projectPointsToPlane(pnErp, vecZEave);
								dpPlan.draw(PlaneProfile(plRange), _kDrawFilled, nTransparency1);
							}							
							else
							{
								plRange.addVertex(ptAv + vecX * dYFactor * .5 * dXMax);
								plRange.addVertex(ptAv - vecX * dYFactor * .5 * dXMax);
								plRange.projectPointsToPlane(pnErp, vecZEave);
								dpPlan.draw(plRange);
							}						
							ptAv -= vecY*dUsedAv;
						}
					}

					DimLine dl(ptAv, -vecY, vecX);
					Dim dim(dl ,ptDims, "<>", "<>", _kDimPerp, _kDimNone);
					
					if (nDisplayContent!=2)
					{
						dpDimPlan.draw(dim);
						dpDimModel.draw(dim);					
					}

					nCountI = 0;
					
					if(nCount == nEaveLATIndex || nEdgeHtype[nCount] != 0 )
						nCountI = 1;
						
					nCount++;
			 	}
		 	}			
		}
		
		if(ptsGripsV.length() < 2 || ptsGrid.length() < 2)
		{
			reportMessage(T("|Can not create vertical tiling, Please check edge definition|"));
			return;
		}

	// Dimension points
		if(ptsGrid.length() > 0 && ptsGripsV.length() > 0 && vecY.dotProduct(ptsGrid[0]  - ptsGripsV[0]) > dEps)
			ptsDim.append(ptsGripsV[0]);
		ptsDim.append(ptsGrid);
		if(ptDormerDim != _PtW)
			ptsDim.append(ptDormerDim);
			
		if(vecY.dotProduct(ptsGripsV[ptsGripsV.length()-1] - ptsDim[ptsDim.length()-1]) > dEps)
			ptsDim.append(ptsGripsV[ptsGripsV.length() - 1]);
			
		if(ptsDim.length() > 2)
		{
			double d1 = vecY.dotProduct(ptsDim[1] - ptsDim[0]);
			double d2 = vecY.dotProduct(ptsDim[2] - ptsDim[1]);
			
			if(d1+d2 > dUsedEave - dEps && d1+d2 < dUsedEave + dEps )
				ptsDim.removeAt(1); 
		}

	// Trigger//region
	//add static location trigger
		String sAddStaticLocationTrigger = T("|Add fixed lath|");
		addRecalcTrigger(_kContext, sAddStaticLocationTrigger );
		if (_bOnRecalc && _kExecuteKey==sAddStaticLocationTrigger ) 
		{
			Point3d pt = getPoint(T("|Pick point|"));
			_PtG.append(Line(pt,_ZW).intersect(pnErp, dZOffsetTilePlane));
			setExecutionLoops(2);	
			return;					
		}		
			
	 //remove static location trigger
		if (_PtG.length()>0)
		{
			String sRemoveStaticLocationTrigger = T("|Remove fixed lath|");
			addRecalcTrigger(_kContext, sRemoveStaticLocationTrigger );
			if (_bOnRecalc && _kExecuteKey==sRemoveStaticLocationTrigger ) 
			{
				Point3d pt = getPoint(T("|Pick point near fixed lath|"));
				pt = Line(pt,_ZW).intersect(pnErp, dZOffsetTilePlane);
				int bFound;
				for (int i=0; i<_PtG.length();i++)
				{
					if (abs(vecY.dotProduct(_PtG[i]-pt))<dYMax)
					{
						_PtG.removeAt(i);
						bFound=true;
						setExecutionLoops(2);
						return;	
					}
				}
				reportMessage("\n"+ T("|Could not a find a fixed lath nearby.|") + " " + T("|Try to pick a point closed to a fixed lath...|"));			
			}	
		}	
		
	// Evaluate verge tiles //region 
		dpGrid.color(ncVerge);
		double dNumRemoved; // collect the amount of tiles to be removed from the over all amount as double to count by half of the append tiles
		Map mapRoofTilesLeftVerge, mapRoofTilesRightVerge;	
		
		
	// remove bottom point for export
		Point3d ptsExport[0];
		ptsExport = ptsGrid;
//		ptsExport = ptsDim;
		ptsExport.removeAt(ptsExport.length() - 1);
		
		for(int i=0; i < ptsExport.length(); i++)
		{
			ptsExport[i].vis(2);
		}
			
	// Export data//region
		Map mapExport=er.subMapX("Hsb_TileExportData");
		mapExport.setPoint3dArray("VerticalDistribution", ptsExport);
		mapExport.setInt("FrontCutMode", bFrontCutPerToRoofplane);
		mapExport.setDouble("ZOffsetTilePlane", dZOffsetTilePlane);
		mapExport.setVector3d("vecZEave", vecZEave);
		mapExport.setPlaneProfile("ppRoof", ppRoof);
		mapExport.setPlaneProfile("ppTile", ppTile);
		mapExport.setPlaneProfile("ppErp", ppErp);
		if(ppRoof.area() > dEps)
			mapExport.setPlaneProfile("ppPositioning", ppRoof);

		//mapExport.setMap("mapHalfTilesToAdd", Map());

		
		vecXDim = vecY;
		vecYDim = -vecX;

//	// add grip for dimline
		if (_PtG.length()<1)
		{ 
			int nFlip = 1;
			if (vecX.dotProduct(_XW)<0 || vecX.isCodirectionalTo(_YW))
				nFlip *= -1;
			
			ptRefDim = segErp.ptMid()+.5*(nFlip*vecX*dXErp-vecY*dYErp)+(nFlip*3*vecX-vecY)*dTxtH;
			ptRefDim = Line(ptRefDim , vecZ).intersect(pnErp, dZOffsetTilePlane);
			_PtG.append(ptRefDim);
		}

		//ptRefDim = segErp.ptMid()-.5*(vecX*dXErp-vecY*dYErp)-(vecX+vecY)*dTxtH;
		ptRefDim = Line(_PtG[0] , vecZ).intersect(pnErp, dZOffsetTilePlane);
		_PtG[0] = ptRefDim;
		
	// set plane for dimension point projection
		{ 
			bOnTop = vecX.dotProduct(ptRefDim-segErp.ptMid())<0;
			pnSnap = Plane(segErp.ptMid()+(bOnTop?-1:1)*vecX*(.5*dXErp+.1*dTxtH), vecX);
		}
		
		er.transformBy(Vector3d(0, 0, 0));
		
//		mapExport.setInt("mapHalfTilesToAdd\\mapTileGrid\\HalfTile", nNumHalfs);
		er.setSubMapX("Hsb_TileExportData", mapExport);
			
	// Get horizontal tile grid
		Entity en = _Map.getEntity("tslGrid");
		Map map = ((TslInst)en).map();
		Point3d ptsGridH[] = map.getPoint3dArray("ptsGrid");

		double dA1; 
	// Only used for staggered tiles		
		if(nTileDistribution == 1)
			dA1 = mapExport.getDouble("dAvHalf");
		
		int bSwapStaggered = mapExport.getInt("Staggered");
		int nHorizontalAlignment =	mapExport.getInt("nHorizontalAlignment");
		Plane pnRoof(ppRoof.coordSys().ptOrg(), vecZ);
		dpGrid.color(ncGrid);
		
		for(int i=0; i< ptsGridH.length();i++)
			ptsGridH[i] = pnRoof.closestPointTo(ptsGridH[i]);	
			
		if(ptsGridH.length() > 1)
		{
			Vector3d vecStaggered( ptsGridH[1] - ptsGridH[0]); vecStaggered.normalize();
			vecX = vecStaggered;			
		}
		

		int nFullTiles;
		int nPrevFullTiles;
		int nPrevFullTiles1;
		int nAllFull;
		int nAllHalf;
		int bHalfTile;
		int iH;
		Point3d ptOut2 = ppStaggered1.extentInDir(vecX).ptEnd(); 
		Point3d ptHalfColumn[0];
		Map mapHalfColumn = map.getMap("mapHalfColumn");
		
		for (int i = 0; i < mapHalfColumn.length(); i++)
		{
			ptHalfColumn.append(mapHalfColumn.getPoint3d(i));
		}
		
		ptHalfColumn = Line(_Pt0, vecX).orderPoints(ptHalfColumn); 
		
	// get all grid edge points to ind out if a top tile needs to be added
		Point3d ptStaggered1, ptStaggered2;
		{ 
			Point3d ptsStaggered1[] = ppStaggered1.getGripVertexPoints();
			ptsStaggered1 = Line(_Pt0, vecY).orderPoints(ptsStaggered1); 

			for(int i= ptsStaggered1.length()-1; i> -1; i--)
			{
				if(vecY.dotProduct(ptsStaggered1[i] - ptsStaggered1[i-1] )> dEps)
				{
					ptStaggered1 = ptsStaggered1[i - 1];	
					
					break;
				}
			}
			ptStaggered1.vis(4);
			
			Point3d ptsStaggered2[] = ppStaggered2.getGripVertexPoints();
			ptsStaggered2 = Line(_Pt0, vecY).orderPoints(ptsStaggered2); 
			
			for(int i= ptsStaggered2.length()-1; i> -1; i--)
			{
				if(vecY.dotProduct(ptsStaggered2[i] - ptsStaggered2[i-1]) > dEps)
				{
					ptStaggered2 = ptsStaggered2[i - 1];		
					break;
				}
			}
			ptStaggered2.vis(5);	
		}

		
		int bAddStaggered1 = 1, bAddStaggered2 = 1;
		ppStaggered1.vis(2);
		
	// Draw vertical tile grid and count tiles	
		for(int i=0; i < ptsGridH.length()-1; i++)
		{ 
//			if (i == 0 && dA1 < dEps ) continue;
			if (i == 0 && nTileDistribution != 1) continue;
			
			bHalfTile = false;
			
			if(ptHalfColumn.length() > iH)	
			{			
				if(vecX.dotProduct(ptsGridH[i+1] - ptHalfColumn[iH]) > dEps && vecX.dotProduct(ptHalfColumn[iH] - ptsGridH[i]) > dEps)
				{
					dpGrid.color(4);		
					bHalfTile = true;
					iH++;
				}
			}
			
			if(! bHalfTile)
				dpGrid.color(ncGrid);
				
			LineSeg segGrid[0]; 	//ppEave.vis(3);
			
			if( vecX.dotProduct(ptOut2 - (ptsGridH[i] + vecX*dA1)) > U(1) )
			{			
		
				if(i ==0 && nHorizontalAlignment == 0)
				{
					segGrid = ppStaggered2.splitSegments(LineSeg(ptsGridH[i+1]-vecY*U(10e6) - vecX*dA1,ptsGridH[i+1]+vecY*U(10e6) - vecX*dA1),true);
//					if (segGrid.length() >0 && ppRoof.pointInProfile(segGrid[0].ptMid()) !=0) segGrid.removeAt(0);
					if (segGrid.length() >0 && ppEave.pointInProfile(segGrid[0].ptEnd() - vecY*U(1)) ==1) segGrid.removeAt(0);
					if (segGrid.length() >0 && nDisplayContent!=1 ) 
					{
						for(int j=0; j < segGrid.length(); j++)
						{
							if(segGrid[j].length() < U(1))
							{
								segGrid.removeAt(j);
								j--;
							}
						// Check if LineSeg is in the top row
							if(bAddStaggered2)
							{
								if(vecY.dotProduct(segGrid[j].ptMid() - ptStaggered2) > dEps)
									bAddStaggered2 = 0;
							}			
						}
						dpGrid.draw(segGrid);	
						nFullTiles = segGrid.length();
					}
				}

				else if(i==0 && nHorizontalAlignment == 2)
				{
					double dFirst = vecX.dotProduct(ptsGridH[i + 1] - ptsGridH[i]) - dA1;
					segGrid = ppStaggered2.splitSegments(LineSeg(ptsGridH[i]-vecY*U(10e6) + vecX*dFirst,ptsGridH[i]+ vecY*U(10e6) + vecX*dFirst),true);
//					if (segGrid.length() >0 && ppRoof.pointInProfile(segGrid[0].ptMid())!=0) segGrid.removeAt(0);
					if (segGrid.length() >0 && ppEave.pointInProfile(segGrid[0].ptEnd() - vecY*U(1))==1) segGrid.removeAt(0);
					if (segGrid.length() >0 && nDisplayContent!=1 )
					{
						for(int j=0; j < segGrid.length(); j++)
						{
							if(segGrid[j].length() < U(1))
							{
								segGrid.removeAt(j);
								j--;
							}
						// Check if LineSeg is in the top row
							if(bAddStaggered2)
							{
								if(vecY.dotProduct(segGrid[j].ptMid() - ptStaggered2) > dEps)
									bAddStaggered2 = 0;
							}
						}
						dpGrid.draw(segGrid);	
						nFullTiles = segGrid.length();
					}
				}
				else
				{
					segGrid = ppStaggered2.splitSegments(LineSeg(ptsGridH[i]-vecY*U(10e6) + vecX*dA1,ptsGridH[i]+ vecY*U(10e6) + vecX*dA1),true);
//					if (segGrid.length() >0 && ppRoof.pointInProfile(segGrid[0].ptMid())!=0) segGrid.removeAt(0);
					if (segGrid.length() >0 && ppEave.pointInProfile(segGrid[0].ptEnd() - vecY*U(1))==1) segGrid.removeAt(0);
					if (segGrid.length() >0 && nDisplayContent!=1 ) 
					{
						for(int j=0; j < segGrid.length(); j++)
						{
							if(segGrid[j].length() < U(1))
							{
								segGrid.removeAt(j);
								j--;
							}
						// Check if LineSeg is in the top row
							if(bAddStaggered2)
							{
								if(vecY.dotProduct(segGrid[j].ptMid() - ptStaggered2) > dEps)
									bAddStaggered2 = 0;
							}
						}
						dpGrid.draw(segGrid);		
						nFullTiles = segGrid.length();				
					}
				}
				
				if(! bHalfTile)
				{
					if(nFullTiles < nPrevFullTiles)
						nAllFull += nPrevFullTiles;
					else
						nAllFull += nFullTiles;					
				}
				else
				{
					if(nFullTiles < nPrevFullTiles)
						nAllHalf += nPrevFullTiles;
					else
						nAllHalf += nFullTiles;						
				}
				
				nPrevFullTiles = nFullTiles;
				nFullTiles = 0;
			}
				if (i == 0 ) continue;
			
				segGrid = ppStaggered1.splitSegments(LineSeg(ptsGridH[i]-vecY*U(10e6), ptsGridH[i]+vecY*U(10e6)),true); //ppRoof.vis(2);
//				if (segGrid.length() > 0 && ppRoof.pointInProfile(segGrid[0].ptMid() - vecY * U(1)) != 0) segGrid.removeAt(0); 
				if (segGrid.length() > 0 && ppEave.pointInProfile(segGrid[0].ptEnd() - vecY * U(1)) == 1) segGrid.removeAt(0); 
				if (segGrid.length() >0 && nDisplayContent!=1 ) 
				{
					for(int j=0; j < segGrid.length(); j++)
					{
						if(segGrid[j].length() < U(1))
						{
							segGrid.removeAt(j);
							j--;
						}
						// Check if LineSeg is in the top row
							if(bAddStaggered1)
							{
								if (vecY.dotProduct(segGrid[j].ptMid() - ptStaggered1) > dEps) 
									bAddStaggered1 = 0;
							}
					}
					dpGrid.draw(segGrid);		
					nFullTiles = segGrid.length();
				}

				if(! bHalfTile)
				{
					if(nFullTiles < nPrevFullTiles1)
						nAllFull += nPrevFullTiles1;
					else
						nAllFull += nFullTiles;					
				}
				else
				{
					if(nFullTiles < nPrevFullTiles1)
						nAllHalf += nPrevFullTiles1;
					else
						nAllHalf += nFullTiles;						
				}
					nPrevFullTiles1 = nFullTiles;
					nFullTiles = 0;				
		}
		
		if(! bHalfTile)
		{
			//if(nTileDistribution != 1)
			{
				nAllFull += nPrevFullTiles;
				nAllFull += nPrevFullTiles1;					
			}
			nAllFull += bAddStaggered1;
			nAllFull += bAddStaggered2;			
		}
		else
		{
			nAllHalf += nPrevFullTiles;
			nAllHalf += nPrevFullTiles1;			
		}
		
	// Add amount of tiles for export
		{ 
		Map mapTiles;
		mapTiles.setInt("FullTiles", nAllFull);
		mapTiles.setInt("HalfTiles", nAllHalf);
		_Map.setMap("mapTiles", mapTiles);
		}
	}


//Dimlines//region

// toggle grid visibility by double click
	if (_bOnRecalc &&  _kExecuteKey==sDoubleClick) 
	{
		//reportNotice("\nset from " + nDisplayContent);
	// current setting All	
		if (nDisplayContent==0)
			nDisplayContent=1;
	// current setting Grid	
		else if (nDisplayContent==1)
			nDisplayContent=2;
	// current setting Dimension	
		else if (nDisplayContent==2)
			nDisplayContent=0;
		sDisplayContent.set(sDisplayContents[nDisplayContent]);
		setExecutionLoops(2);
		reportNotice("...to " + nDisplayContent);
		return;		
	}
	
	Point3d ptsDimD[0];

// snap to outline contour
	for (int p=0;p<ptsDim.length();p++)
	{
		ptsDim[p] = Line(ptsDim[p],vecYDim).intersect(pnSnap,0);
		
		if(p%3 ==0)
			ptsDimD.append(ptsDim[p]);
	}

	ptRefDim -= vecY * dOverhang;
		
// draw dimensions
	DimLine dl(ptRefDim, vecXDim,vecYDim);		
	Dim dim(dl, ptsDim,"<>","<>",_kDimPerp, _kDimNone);
	dim.setDeltaOnTop(bOnTop);
	dim.setReadDirection(vecRead);
	
	Dim dimD;
	if(ptsDimD.length() > 0)
	{
		if(ptsDimD[ptsDimD.length()-1] != ptsDim[ptsDim.length()-1])
			ptsDimD.append(ptsDim[ptsDim.length() - 1]);
		dimD = Dim (dl, ptsDimD,"<>","<>",_kDimNone, _kDimDelta);
		dim.setDeltaOnTop(true);
		dimD.setDeltaOnTop(true);
		dimD.setReadDirection(vecRead);
	}
	
	dpPlan.color(252);
	if (nDisplayContent!=2 && nMode!=2) 		// 0 = all, 1 = dim, 2 = grid 
	{
		dpPlan.draw(dim);	
		dpPlan.draw(dimD);
	}


// vertical distribution
	if (nMode==2)
	{
	// 0 = all, 1 = dim, 2 = grid 

		if (nDisplayContent!=2)
		{
		// draw model dim
			Dim dimM(dl, ptsDim,"<>","<>",_kDimPerp, _kDimPerp);
			//dimM.setDeltaOnTop(bOnTop);
			dimM.setReadDirection(vecRead);
			dpDimModel.draw(dimM);
			
		// draw projected plan dim
			Vector3d vecXDim2 = vecXDim.crossProduct(_ZW).crossProduct(-_ZW);
			Point3d pts[0];
			DimLine dlPlan(ptRefDim, vecXDim2,vecYDim);	
			Dim dimPlan(dlPlan, pts,"<>","<>",_kDimPerp, _kDimNone);
			for (int i=0;i<ptsDim.length();i++) 
			{ 
//				Point3d pt = ptsDim[i+1] + _ZW * _ZW.dotProduct(ptRefDim - ptsDim[i + 1]);//pt.vis(2);
				Point3d pt = ptsDim[i] + _ZW * _ZW.dotProduct(ptRefDim - ptsDim[i]); 
				String s;
				if(i <ptsDim.length()-1)
					 s.formatUnit(abs(vecXDim.dotProduct(ptsDim[i + 1] - ptsDim[i])), sDimStyle);
				dimPlan.append(pt, s, ""); 	 
			}//next i
			dimPlan.setDeltaOnTop(bOnTop);
			dimPlan.setReadDirection(vecRead);

			dpDimPlan.draw(dimPlan);			
				
		// draw sectional dimensions
		// draw dimensions
			DimLine dl(ptRefDim+vecZ*dTxtH, vecY,-vecZ);		
			Dim dim(dl, ptsDim,"<>","<>",_kDimPerp, _kDimNone);
			dim.setDeltaOnTop(false);
			dim.setReadDirection(vecY);	
			dpSection.draw(dim);		
		}	
		if(nDisplayContent!=1)
		{
			dpGrid.color(252);
			dpGrid.draw(ppS);
		}
	}

// store defaults
	String sStoreDefaultTrigger = T("|Save defaults|");
	addRecalcTrigger(_kContext, sStoreDefaultTrigger );
	if (_bOnRecalc && _kExecuteKey==sStoreDefaultTrigger) 
	{
		setCatalogFromPropValues(sDefault);	
	}

// store grips absolute to allow movement of _Pt0
	if (_kNameLastChangedProp.find("_PTG",0)>-1 || mapGrips.length()!=_PtG.length())
	{
		mapGrips=Map();
		for (int i=0; i<_PtG.length();i++)
		{
			Vector3d vec = _PtG[i]-_PtW;
			mapGrips.appendVector3d("Grip", vec);
		}	
		_Map.setMap("Grip[]", mapGrips);
	}	
	//endregion
	
// Add hardware infos for export
	//if(! _Map.hasMap("mapHardware") || sFamilyName != _Map.getMap("mapHardware").getString("Model"))
	{
		// declare the groupname of the hardware components
		String sHWGroupName;
		Group groups[] = _ThisInst.groups();
		if (groups.length()>0)
			sHWGroupName=groups[0].name();
	
		Map mapHardware;
		mapHardware.setString("FullTileName", mapStandardTile.getString("Name"));
		mapHardware.setString("HalfTileName", mapHalfTile.getString("Name"));
		mapHardware.setString("Manufacturer", mapManufacturer.getString("Manufacturer"));
		mapHardware.setString("Model", sFamilyName);
		mapHardware.setString("Material", mapFamilyDefinition.getString("Characteristic\Surface") + " " + mapFamilyDefinition.getString("Characteristic\Colour"));
		mapHardware.setString("Notes", er.roofNumber());
		mapHardware.setString("Group", sHWGroupName);
		mapHardware.setEntity("LinkedEntity", er);
		mapHardware.setString("Category", T("|Rooftiles|"));
		mapHardware.setString("RepType", _kRTTsl);
		mapHardware.setDouble("DScaleX", mapStandardTile.getDouble("Length"));
		mapHardware.setDouble("DScaleY", mapStandardTile.getDouble("Width"));
		mapHardware.setDouble("DScaleZ", 0);
		mapHardware.setDouble("DAngleA", dPitch);		
		
		_Map.setMap("mapHardware", mapHardware);
	}




// Automatic recorded v1.1
#End
#BeginThumbnail


























#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End