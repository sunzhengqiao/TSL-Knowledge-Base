#Version 8
#BeginDescription
#Versions
Version 4.4 18.06.2025 HSB-24005 grip move behaviour imrpoved
Version 4.3 28.02.2025 HSB-22730 new component display, now also supporting MetalPartCollections
Version 4.2 12.02.2025 HSB-22730 display componnets dialog prepared (not accessible yet)
Version 4.1 12.02.2025 HSB-23372 fully supporting new behaviour of controlling properties
Version 4.0 31.01.2025 HSB-23426 do not consider in any sectional view
Version 3.9 19.12.2024 HSB-23165 panel element orientation fixed
Version 3.8 19.12.2024 HSB-23166 bugfix property assignment projection / dimstyle fixed
Version 3.7 12.12.2024 HSB-23171 bugfix vertical spacer height available during insert
Version 3.6 06.12.2024 HSB-21818 a new command has been implemented to address and support xref datalinks. The text size issue has been resolved, and xref dimstyles have been declined.
Version 3.5 29.11.2024 HSB-23089 new property to filter the content of the stack item, ie to exclude sheeting zones being mounted onsite from stacking
Version 3.4 29.11.2024 HSB-23088 performance improvement when using shape type for metalparts
Version 3.3 24.09.2024 HSB-22717 element references improved
Version 3.2 17.09.2024 HSB-21161 on insert invisble items which are not assigned to a parent are made visible
Version 3.1 17.09.2024 HSB-22000 insert jig supports vertical/horizontal toggle, alignment corrected if current UCS does not match WCS
Version 3.0 11.09.2024 HSB-22649 bugfix parent assignment with spacer height 
Version 2.9 22.08.2024 HSB-21998 settings introduced to enable custom color coding
Version 2.8 20.08.2024 HSB-21681 new property 'Projection Display' to show item boundaries
Version 2.7 16.08.2024 HSB-21677 jigging imroved, HSB-22468.4 improved, solid detailing improved
Version 2.6 05.08.2024 HSB-22468.4 new command to rotate item in any of the main axes
Version 2.5 29.07.2024 HSB-22467 vertical element stacking improved
Version 2.4 29.07.2024 HSB-22467 vertical element stacking improved
Version 2.3 03.06.2024 HSB-21677 drag jigs made more transparent
Version 2.2 10.05.2024 HSB-21994 updating pack when dragging location to update item list
Version 2.1 08.05.2024 HSB-21973 StackItem written to Datalink subMapX
Version 2.0 13.12.2023 HSB-20750 low and high resoultion of elements improved, selection set will be filtered on bySelection if elements are selected
Version 1.9 01.12.2023 HSB-20750 supporting elements
Version 1.8 24.11.2023 HSB-20724 debug messages removed
Version 1.7 17.11.2023 HSB-19662 drag behaviour, parent nesting updated
Version 1.6 08.11.2023 HSB-19659 added dataLink purging, dragging into package improved
Version 1.5 24.10.2023 HSB-19659 coloring improved, reference link renamed
Version 1.4 18.10.2023 HSB-19659 first beta release
Version 1.3 12.10.2023 HSB-19659 renamed, bedding height and auto assignmment improved
Version 1.2 06.10.2023 HSB-19659 functions unified
































#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 4
#MinorVersion 4
#KeyWords 
#BeginContents
//region Part #A

//region <History>
// #Versions
// 4.4 18.06.2025 HSB-24005 grip move behaviour imrpoved , Author Thorsten Huck
// 4.3 28.02.2025 HSB-22730 new component display, now also supporting MetalPartCollections , Author Thorsten Huck
// 4.2 12.02.2025 HSB-22730 display componnets dialog prepared (not accessible yet) , Author Thorsten Huck
// 4.1 12.02.2025 HSB-23372 fully supporting new behaviour of controlling properties , Author Thorsten Huck
// 4.0 31.01.2025 HSB-23426 do not consider in any sectional view , Author Thorsten Huck
// 3.9 19.12.2024 HSB-23165 panel element orientation fixed , Author Thorsten Huck
// 3.8 19.12.2024 HSB-23166 bugfix property assignment projection / dimstyle fixed , Author Thorsten Huck
// 3.7 12.12.2024 HSB-23171 bugfix vertical spacer height available during insert , Author Thorsten Huck
// 3.6 06.12.2024 HSB-21818 a new command has been implemented to address and support xref datalinks. The text size issue has been resolved, and xref dimstyles have been declined. , Author Thorsten Huck
// 3.5 29.11.2024 HSB-23089 new property to filter the content of the stack item, ie to exclude sheeting zones being mounted onsite from stacking , Author Thorsten Huck
// 3.4 29.11.2024 HSB-23088 performance improvement when using shape type for metalparts , Author Thorsten Huck
// 3.3 24.09.2024 HSB-22717 element references improved , Author Thorsten Huck
// 3.2 17.09.2024 HSB-21161 on insert invisble items which are not assigned to a parent are made visible. , Author Thorsten Huck
// 3.1 17.09.2024 HSB-22000 insert jig supports vertical/horizontal toggle, alignment corrected if current UCS does not match WCS , Author Thorsten Huck
// 3.0 11.09.2024 HSB-22649 bugfix parent assignment with spacer height , Author Thorsten Huck
// 2.9 22.08.2024 HSB-21998 settings introduced to enable custom color coding , Author Thorsten Huck
// 2.8 20.08.2024 HSB-21681 new property 'Projection Display' to show item boundaries , Author Thorsten Huck
// 2.7 16.08.2024 HSB-21677 jigging imroved, HSB-22468.4 improved, solid detailing improved , Author Thorsten Huck
// 2.6 05.08.2024 HSB-22468.4 new command to rotate item in any of the main axes , Author Thorsten Huck
// 2.5 29.07.2024 HSB-22467 vertical element stacking improved , Author Thorsten Huck
// 2.4 29.07.2024 HSB-22467 vertical element stacking improved , Author Thorsten Huck
// 2.3 03.06.2024 HSB-21677 drag jigs made more transparent , Author Thorsten Huck
// 2.2 10.05.2024 HSB-21994 updating pack when dragging location to update item list , Author Thorsten Huck
// 2.1 08.05.2024 HSB-21973 StackItem written to Datalink subMapX , Author Thorsten Huck
// 2.0 13.12.2023 HSB-20750 low and high resoultion of elements improved, selection set will be filtered on bySelection if elements are selected , Author Thorsten Huck
// 1.9 01.12.2023 HSB-20750 supporting elements , Author Thorsten Huck
// 1.8 24.11.2023 HSB-20724 debug messages removed , Author Thorsten Huck
// 1.7 17.11.2023 HSB-19662 drag behaviour, parent nesting updated , Author Thorsten Huck
// 1.6 08.11.2023 HSB-19659 added dataLink purging, dragging into package improved , Author Thorsten Huck
// 1.5 24.10.2023 HSB-19659 coloring improved, reference link renamed , Author Thorsten Huck
// 1.4 18.10.2023 HSB-19659 first beta release , Author Thorsten Huck
// 1.3 12.10.2023 HSB-19659 renamed, Spacer height and auto assignmment improved , Author Thorsten Huck
// 1.2 06.10.2023 HSB-19659 functions unified , Author Thorsten Huck
// 1.1 29.09.2023 HSB-19659 rotations added , Author Thorsten Huck
// 1.0 27.09.2023 HSB-19659 initial version , Author Thorsten Huck

/// <insert Lang=en>
/// Select entities to create a flattened child representation
/// </insert>

// <summary Lang=en>
// This tsl creates stackable items for the 'StackXXX' tool set
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "StackItem")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Flip Face|") (_TM "|Select item|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Rotate 90°|") (_TM "|Select item|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Rotate 180°|") (_TM "|Select item|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Flip + Rotate|") (_TM "|Select item|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Flip Face|") (_TM "|Select item|"))) TSLCONTENT
//endregion

//region Constants
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;

	String tDefault =T("|_Default|");
	String tLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};

	String sDialogLibrary = _kPathHsbInstall + "\\Utilities\\DialogService\\TslUtilities.dll";
	String sClass = "TslUtilities.TslDialogService";	
	String listSelectorMethod = "SelectFromList";
	String optionsMethod = "SelectOption";
	String simpleTextMethod = "GetText";
	String askYesNoMethod = "AskYesNo";
	String showNoticeMethod = "ShowNotice";
	String showMultilineNotice = "ShowMultilineNotice";
	String showDynamic = "ShowDynamicDialog";
	
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

	Vector3d vecXView = getViewDirection(0);
	Vector3d vecYView = getViewDirection(1);
	Vector3d vecZView = getViewDirection(2);
	double dViewHeight = getViewHeight();	
	//endregion 	
	
	int mode = _Map.getInt("mode");
	String sDefinitions[] = TruckDefinition().getAllEntryNames();
	
	double dSnapTolerance=U(300); // the tolerance to accept snap/drag of items into packs or ents
	
	String sTruckDefinitionPropertyName=T("|Definition|"); // used to query the truck definition name from property of tsl
	String sTruckDescriptionPropertyName=T("|Description|"); // used to query the truck definition name from property of tsl

	String kTruckParent = "hsb_TruckParent";
	String kTruckChild = "hsb_TruckChild";
	String kPackageParent = "hsb_PackageParent";
	String kPackageChild = "hsb_PackageChild";

	String kTruckData = "truckData";
	
	String sAssemblyScripts[] = { "AssemblyDefinition"};
	
	String kDataLink = "DataLink",kData= "Data", kScriptItem = "StackItem", kScriptPack="StackPack", kScriptStack="StackEntity";
	
	String tSpacerHeightName=T("|Spacer Height|"), tVerticalSpacerThicknessName=T("|Vertical Spacer Thickness|");	
	String kLayerIndexPack = "LayerIndexPack", kLayerSubIndexPack = "LayerSubIndexPack",kLayerIndexStack = "LayerIndexStack", kLayerSubIndexStack = "LayerSubIndexStack";
	String sParentScripts[] = { kScriptPack, kScriptStack};
	int nColorItem = 9;

	String kDirKeys[] = { "X_", "Y_", "Z_"};
	String sItemModeName=T("|Item Mode|");
	String tIMEdit= T("|Edit|"), tIMHideMultipage = T("|Hide in Shopdrawing|"), tIMHidden = T("|Hidden|"),sItemModes[] ={ tIMEdit, tIMHidden, tIMHideMultipage};
	
	String tPMNone=T("|None|"), 
		tPMViewZP=T("|Top|"), tPMViewZN= T("|Bottom|"), tPMViewZ = T("|Top + Bottom|"), 
		tPMViewXP=T("|Front|"), tPMViewXN= T("|Back|"), tPMViewX = T("|Front + Back|"), 
		tPMViewYP=T("|Right|"), tPMViewYN= T("|Left|"), tPMViewY = T("|Left + Right|"), 
		tPMAll = T("|All|"), 
		sProjectionModes[] ={tPMNone, tPMViewZP, tPMViewZN, tPMViewZ,tPMViewXP, tPMViewXN, tPMViewX, tPMViewYP, tPMViewYN, tPMViewY, tPMAll };


	String tDisabledEntry = T("<|Disabled|>"), tAnyEntry = T("<|Any Type|>");
	String tBySelection = T("<|bySelection|>");
	String tByDefault = T("<|Default|>");
	
	String kGenBeam = "GenBeam", kBeam = "Beam", kSheet="Sheet", kPanel = "Panel", kElement = "Element", kWall = "Wall", kRoofFloor = "RoofFloor", kMetalPart = "MetalPart", kTslInst= "TslInstance";
	String sEntityTypes[] = { "Disabled","AnyType" ,kGenBeam,kBeam,kSheet,kPanel,kElement,kWall,kRoofFloor,kMetalPart};
	String tEntityTypes[] = { tDisabledEntry, tAnyEntry, T("|GenBeam|"), T("|Beam|"), T("|Sheet|"), T("|Panel|"), T("|Element|"), T("|Wall|"), T("|Roof/Floor|"), T("|MetalPart|")};

	String tCOG =T("|Center of Gravity|") ,kGrainDirection="GrainDirection", kCOG = "COG", kSurfaceQualityMin="SurfaceQualityMin",kSurfaceQualityMax="SurfaceQualityMax";
	String sComponents[] = { "Disabled", kCOG, kGrainDirection, kSurfaceQualityMax,kSurfaceQualityMin};
	String tComponents[] = { tDisabledEntry, tCOG, T("|Grain Direction|"), T("|Highest Surface Quality|"), T("|Lowest Surface Quality|") };
	
	Display dpModel(-1),dpPlan(-1),dpModelPlan(-1), dp(-1),dpRed(-1), dpWhite(-1),dpModelOnly(-1),dpJig(-1), dpText(-1), dpOverlay(-1),dpInvisible(-1);
	dpPlan.addViewDirection(_ZW);
	
//	dpModel.addHideDirection(_ZW);
//	dpModel.addHideDirection(-_ZW);	
	
	dpModelPlan.addHideDirection(_XW);
	dpModelPlan.addHideDirection(-_XW);	
	dpModelPlan.addHideDirection(_YW);
	dpModelPlan.addHideDirection(-_YW);	

	dpModelOnly.addHideDirection(_XW);
	dpModelOnly.addHideDirection(-_XW);	
	dpModelOnly.addHideDirection(_YW);
	dpModelOnly.addHideDirection(-_YW);
	dpModelOnly.addHideDirection(_ZW);
	dpModelOnly.addHideDirection(-_ZW);		
	dpModelOnly.trueColor(grey, 50);
	
	_ThisInst.setDrawOrderToFront(100);



//region Dialog config
	String kRowDefinitions = "MPROWDEFINITIONS";
	String kControlTypeKey = "ControlType";
	String kHorizontalAlignment = "HorizontalAlignment";
	String kLabelType = "Label";
	String kHeader = "Title";
	String kIntegerBox = "IntegerBox";
	String kTextBox = "TextBox";
	String kDoubleBox = "DoubleBox";
	String kComboBox = "ComboBox";
	String kCheckBox = "CheckBox";
	String kLeft = "Left", kRight = "Right", kCenter = "Center", kStretch = "Stretch";	

	String tToolTipColor = T("|Specifies the color of the component.|")+ 
		T(", |-1 = color by Stack Item|") +
		T(", |-2 = by Alias: the quality can be mapped to specific colors by using an alias 'SQ' (Panel Surface Quality)|");
	String tToolTipTransparency = T("|Specifies the level of transparency of the shape of the tool.|");

//endregion	



//end Constants //endregion

//End Part #A //endregion

//region Part #B

//region Rotation Trigger Jigs and Functions

//region Function GetClosestCircle
	// returns the closest circle
	int GetClosestCircle(Point3d pt, PLine circles[])
	{ 
	    double dMin = U(10e6);
	    int n;
	    for (int i=0;i<circles.length();i++) 
	    { 	
	    	double d = (circles[i].closestPointTo(pt)-pt).length();
	    	if (d<dMin)
	    	{ 
	    		dMin = d;
	    		n = i;
	    	}	    	 
	    }//next i
	    
	    return n;
	}//endregion

//region Function AlignCoordSysView
	// returns
	CoordSys AlignCoordSysView(Point3d ptOrg, Vector3d vecX, Vector3d vecY, Vector3d vecZ)
	{ 
    	if (vecZ.dotProduct(vecZView)<0)
    	{ 
    		vecX *= -1;
    		vecZ *= -1;		    		
    	}
    	CoordSys cs(ptOrg, vecX, vecY, vecZ);
    	
    	return cs;
	}//endregion	

//region Function GetCoordSysCircles
	// returns circles perpendicular to each vector of the coordSys
	PLine[] GetCoordSysCircles(CoordSys cs, double diameter)
	{ 
		Point3d pt = cs.ptOrg();
		PLine circle, circles[0];
	    circle.createCircle(pt, cs.vecX(), diameter);
	    circles.append(circle);
	    circle.createCircle(pt, cs.vecY(), diameter);
	    circles.append(circle);
	    circle.createCircle(pt, cs.vecZ(), diameter);
	    circles.append(circle);
	    
	    return circles;
	}//endregion

//region Function GetAngle
	// returns the rotation angle snapping to differnt grids based on the offset
	// vecDir: not normalized, the direction vector to derive the angle to vecRef
	// vecRef: the refrence vector
	// vecZ: used to distinguish neg/pos in the range of +-180°
	// diameter: the preview circle size
	// gridAngle: the angle increment derived from the selected offset, 0=full precision
	double GetAngle(Vector3d vecDir, Vector3d vecRef, Vector3d vecZ, double diameter, double& gridAngle)
	{ 

		double offset = vecDir.length();
		vecDir.normalize();
		double angle = vecRef.angleTo(vecDir) *(vecZ.dotProduct(vecRef.crossProduct(vecDir))<0?-1:1);
			
		if (offset>2*diameter)			gridAngle = 1;
		else if (offset>1.5*diameter)	gridAngle = 5;
		else if (offset>1.0*diameter)	gridAngle = 10;		
		else if (offset>0.5*diameter)	gridAngle = 22.5;
		else							gridAngle = 45;

		if (offset<2.5*diameter)
			angle = round(angle / gridAngle) * gridAngle;
		else
			gridAngle = 0;
		return angle;
	}//endregion

//region Function GetTextFlags
	// returns
	// t: the tslInstance to 
	void GetTextFlags(Vector3d vecDir, Vector3d vecRef, double& xFlag, double& yFlag)
	{ 
	    if(vecDir.isPerpendicularTo(vecRef))
	    	xFlag = 0;
	    else
	    	xFlag = vecDir.dotProduct(vecXView)<0?-1:1;

	    if(vecDir.isParallelTo(vecRef))
	    	yFlag = 0;
	    else
	    	yFlag = vecDir.dotProduct(vecYView)<0?-1:1;
	   
		return;
	}//endregion



//region Jig SelectAxis
	String kJigSelectAxis = "JigSelectAxis";
	if (_bOnJig && _kExecuteKey==kJigSelectAxis) 
	{
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point		

		PlaneProfile pp = _Map.getPlaneProfile("pp");
		CoordSys cs = pp.coordSys();
		Point3d pt = cs.ptOrg();
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		Vector3d vecZ = cs.vecZ();
		Plane pn(pt, vecZView);
		Line(ptJig, vecZView).hasIntersection(pn, ptJig);

		Display dp(-1);
		dp.addViewDirection(vecZView);
	    int colors[] = { 1, 3, 150};
	    
	    double diameter = dViewHeight * .15;
	    PLine circles[] = GetCoordSysCircles(cs, diameter);
  
	    double dMin = U(10e6);
	    int n = GetClosestCircle(ptJig, circles);

	    for (int i=0;i<circles.length();i++)
	    { 
	    	PLine circle = circles[i];
	    	circle.convertToLineApprox(dEps);	    	
	    	dp.color(colors[i]);
	    	if (n==i)
	    	{
	    		dp.draw(PlaneProfile(circle), _kDrawFilled, 80);
	    		dp.trueColor(darkyellow);
	    	}
	    	dp.draw(circles[i]);//, _kDrawFilled, n==i?30:60);
	    }
	    
	    return;
	}
//endregion  

//region Jig Rotation
	String kJigRotation = "JigRotation";
	if (_bOnJig && _kExecuteKey==kJigRotation) 
	{
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point		
		int indexAxis = _Map.getInt("indexAxis");
		PlaneProfile pp = _Map.getPlaneProfile("pp");
		CoordSys cs = pp.coordSys();
		Point3d pt = cs.ptOrg();
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		Vector3d vecZ = cs.vecZ();
		Plane pn(pt, vecZ);
		Line(ptJig, vecZView).hasIntersection(pn, ptJig);

	    int colors[] = { 1, 3, 150};
	    
	    double diameter = dViewHeight * .15;
	    PLine circles[0], circle;
	    circle.createCircle(pt, vecZ, diameter);
	    circles.append(circle);

		Vector3d vecJig = ptJig - pt;
		
		double dGridAngle;
		double angle = GetAngle(vecJig, vecX, vecZ, diameter, dGridAngle);
		double dJigLength = vecJig.length();

		
		CoordSys rot;
		rot.setToRotation(angle, vecZ, pt);
		Vector3d vecDir = vecX;
		vecDir.transformBy(rot);
		Vector3d vecMid = vecX + vecDir; vecMid.normalize();
		Point3d ptOnArc = circle.closestPointTo(pt +vecMid * diameter);

		PLine plSector(vecZ);
		plSector.addVertex(pt);
		plSector.addVertex(pt + vecX * diameter);
		plSector.addVertex(pt + vecDir * diameter, ptOnArc);	
		plSector.close();

	    Display dp(-1);
	    double textHeight = dViewHeight * .05;
	    dp.textHeight(textHeight);
	        
	    if (indexAxis>0 && indexAxis<3)
	    	dp.color(colors[indexAxis]);	    
	    dp.draw(plSector);
	    
	    
		dp.trueColor(lightblue,80);
		double diamGrid;
	    if (dJigLength>diameter) // 10°
	    { 
	    	diamGrid = diameter * 1.5;
	    	circle.createCircle(pt, vecZ, diamGrid);
	    	dp.draw(circle);
	    }	    
	    if (dJigLength>diameter*1.5)
	    { 
	    	diamGrid = diameter * 2;
	    	circle.createCircle(pt, vecZ, diamGrid);
	    	dp.draw(circle);
	    }		    
	    if (dJigLength>diameter*2)
	    { 
	    	diamGrid = diameter * 2.5;
	    	circle.createCircle(pt, vecZ, diamGrid);
	    	dp.draw(circle);
	    }		    
	    
	    Body bd = _Map.getBody("bd");
	    bd.transformBy(rot);
	    dp.draw(bd);
	    
	    Point3d ptTxt = pt + vecDir * (diameter + .5 * textHeight);
	    if(diamGrid>0)
	    { 
		    if (indexAxis>0 && indexAxis<3)
		    	dp.color(colors[indexAxis]);
		    Point3d pt2 = pt + vecDir * (diamGrid);
		    Point3d pt1 = pt2 -vecDir* .5 * diameter;
		    dp.transparency(0);
		    dp.draw(PLine(pt1, pt2));
		    ptTxt = pt2 + vecDir * .5 * textHeight;
	    }	    
	    
	    
	    
	    dp.trueColor(darkyellow);
	    dp.transparency(0);
	    if (abs(angle)>0)
	    { 
		    plSector.convertToLineApprox(dEps);
		    dp.draw(PlaneProfile(plSector), _kDrawFilled, 40);
		}   
		{ 
		    double xFlag, yFlag;
		    GetTextFlags(vecDir, vecX,xFlag, yFlag);
		    dp.draw(angle+"°", ptTxt, vecXView, vecYView, xFlag, yFlag);	   			
		}


	// draw grid angle
		dp.trueColor(lightblue);
		if (dGridAngle>0)
		{ 
			dp.textHeight(.75 * textHeight);			
			double xFlag, yFlag;
		    GetTextFlags(-vecMid,vecX, xFlag, yFlag);		
			dp.draw(dGridAngle+"°", pt-vecMid*.375*textHeight, vecXView, vecYView, xFlag, yFlag);
		}

	    return;
	}//endregion 

//region Jig ReferenceLine
	String kJigReferenceLine = "JigReferenceLine";
	if (_bOnJig && _kExecuteKey==kJigReferenceLine) 
	{
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point		
		int indexAxis = _Map.getInt("indexAxis");
		PlaneProfile pp = _Map.getPlaneProfile("pp");
		CoordSys cs = pp.coordSys();
		Point3d pt = cs.ptOrg();
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		Vector3d vecZ = cs.vecZ();
		Plane pn(pt, vecZ);
		Line(ptJig, vecZView).hasIntersection(pn, ptJig);

	    int colors[] = { 1, 3, 150};
	    
	    double diameter = dViewHeight * .15;
	    PLine circle;
	    circle.createCircle(pt, vecZ, diameter);
		Vector3d vecB = ptJig - pt; vecB.normalize();

	    
	    Display dp(-1);
 
	    if (indexAxis>0 && indexAxis<3)dp.color(colors[indexAxis]);	    
	    dp.draw(circle);	    
	    dp.trueColor(lightblue);
	    circle.convertToLineApprox(dEps);
	    dp.draw(PlaneProfile(circle), _kDrawFilled, 60);

		dp.trueColor(red);		
	    dp.draw(PLine (pt, pt+vecB*diameter));

	    
//	    dp2.draw(PLine(pt, pt + vecB * diameter));
	    return;
	}//endregion 
		
//END Rotation Trigger Jigs and Functions //endregion 

//region Functions #FU


//region ArrayToMapFunctions

	//region Function GetDoubleArray
	// returns an array of doubles stored in map
	double[] GetDoubleArray(Map mapIn, int bSorted)
	{ 
		double values[0];
		for (int i=0;i<mapIn.length();i++) 
			if (mapIn.hasDouble(i))
				values.append(mapIn.getDouble(i));
				
		if (bSorted)
			values.sorted();		
				
		return values;
	}//endregion

	//region Function SetDoubleArray
	// sets an array of doubles in map
	Map SetDoubleArray(double values[], String key)
	{ 
		key = key.length() < 1 ? "value" : key;
		Map mapOut;
		for (int i=0;i<values.length();i++) 
			mapOut.appendDouble(key, values[i]);	
		return mapOut;
	}//endregion

	//region Function GetStringArray
	// returns an array of doubles stored in map
	String[] GetStringArray(Map mapIn, int bSorted)
	{ 
		String values[0];
		for (int i=0;i<mapIn.length();i++) 
			if (mapIn.hasString(i))
				values.append(mapIn.getString(i));
				
		if (bSorted)
			values.sorted();		
				
		return values;
	}//endregion

	//region Function SetStringArray
	// sets an array of strings in map
	Map SetStringArray(String values[], String key)
	{ 
		key = key.length() < 1 ? "value" : key;
		Map mapOut;
		for (int i=0;i<values.length();i++) 
			mapOut.appendString(key, values[i]);	
		return mapOut;
	}//endregion

	//region Function GetIntArray
	// returns an array of doubles stored in map
	int[] GetIntArray(Map mapIn, int bSorted)
	{ 
		int values[0];
		for (int i=0;i<mapIn.length();i++) 
			if (mapIn.hasInt(i))
				values.append(mapIn.getInt(i));
				
		if (bSorted)
			values.sorted();		
				
		return values;
	}//endregion

	//region Function SetIntArray
	// sets an array of ints in map
	Map SetIntArray(int values[], String key)
	{ 
		key = key.length() < 1 ? "value" : key;
		Map mapOut;
		for (int i=0;i<values.length();i++) 
			mapOut.appendInt(key, values[i]);	
		return mapOut;
	}//endregion

	//region Function GetBodyArray
	// returns an array of bodies stored in map
	Body[] GetBodyArray(Map mapIn)
	{ 
		Body bodies[0];
		for (int i=0;i<mapIn.length();i++) 
			if (mapIn.hasBody(i))
				bodies.append(mapIn.getBody(i));
	
		return bodies;
	}//endregion

	//region Function SetBodyArray
	// sets an array of bodies in map
	Map SetBodyArray(Body bodies[])
	{ 
		Map mapOut;
		for (int i=0;i<bodies.length();i++) 
			mapOut.appendBody("bd", bodies[i]);	
		return mapOut;
	}//endregion

	//region Function GetPlaneProfileArray
	// returns an array of PlaneProfiles stored in map
	PlaneProfile[] GetPlaneProfileArray(Map mapIn)
	{ 
		PlaneProfile pps[0];
		for (int i=0;i<mapIn.length();i++) 
			if (mapIn.hasPlaneProfile(i))
				pps.append(mapIn.getPlaneProfile(i));
	
		return pps;
	}//endregion

	//region Function SetPlaneProfileArray
	// sets an array of PlaneProfiles in map
	Map SetPlaneProfileArray(PlaneProfile pps[])
	{ 
		Map mapOut;
		for (int i=0;i<pps.length();i++) 
			mapOut.appendPlaneProfile("pp", pps[i]);	
		return mapOut;
	}//endregion

//End ArrayToMapFunctions //endregion 	 	



//region Dialog Functions

//region Function SetItemList
	// returns a map which can be consumed by a comboBox of the dialog service
	// values[]: an array of strings
	Map SetItemList(String values[], String defaultValue)
	{ 
		Map mapOut;
		for (int i=0;i<values.length();i++) 
		{
			String value = values[i];
			mapOut.setString("Item" + (i+1), value);
		}
		if (mapOut.length()<1)
			mapOut.setString("Item1",defaultValue);
		return mapOut;
	}//endregion

//region Function Equals
	// returns true if two strings are equal ignoring any case sensitivity
	int Equals(String str1, String str2)
	{ 
		str1 = str1.makeUpper();
		str2 = str2.makeUpper();		
		return str1==str2;
	}//endregion

//region Function ShowComponentSettings
	// returns the map of the dialog
	Map ShowComponentSettings(Map mapIn)
	{ 
	
		Map rowDefinitions = mapIn.getMap(kRowDefinitions);
		Map mapBlocks = mapIn.getMap("Blocks");
		Map mapEntityTypes = mapIn.getMap("EntityTypes");
		Map mapComponents = mapIn.getMap("Components");
		int numRow = rowDefinitions.length() < 1 ? 1:rowDefinitions.length();
		double dHeight = numRow * 40 + 160;
		
	
	//region dialog config	
		Map mapDialog ;
		Map mapDialogConfig ;
		mapDialogConfig.setString("Title", scriptName() + T(" |Display|"));
		mapDialogConfig.setDouble("Height", dHeight);
		mapDialogConfig.setDouble("Width", 1100);
		mapDialogConfig.setDouble("MaxHeight",1200);
		mapDialogConfig.setDouble("MaxWidth", 2000);
		mapDialogConfig.setDouble("MinHeight", 100);
		mapDialogConfig.setDouble("MinWidth", 600);
		mapDialogConfig.setInt("AllowRowAdd", 1);	
		
	    mapDialogConfig.setString("Description", T("|Specifies optional display components of an stacking item.|"));
	    mapDialog.setMap("mpDialogConfig", mapDialogConfig);			
	//endregion 		

	//region Columns
		Map columnDefinitions ;

	    Map column ;
	   	column.setString(kControlTypeKey, kComboBox);
	    column.setString(kHorizontalAlignment, kStretch);
	    column.setString(kHeader, T("|Component|"));
	    column.setString("ToolTip", T("|Specifies the component of this row.|")); 
	   	column.setMap("Items[]", mapComponents);	
	    columnDefinitions.setMap("Component", column);

	    column.setString(kControlTypeKey, kComboBox);
	    column.setString(kHorizontalAlignment, kStretch);
	    column.setString(kHeader, T("|Applies to|"));
	    column.setString("ToolTip", T("|Specifies to which entity type the component display applies to.|") + T("|Some components are only supported for certain types and will fall back to default.|")); 
	    column.setMap("Items[]", mapEntityTypes);	
	    columnDefinitions.setMap("EntityType", column);

	    column.setString(kControlTypeKey, kCheckBox);
	    column.setString(kHorizontalAlignment, kStretch);
	    column.setString(kHeader, T("|Visibility Item|"));
	    column.setString("ToolTip", T("|Toggles the visbility of the component.|")); 
	    columnDefinitions.setMap("VisibleItem", column);

	    column.setString(kControlTypeKey, kCheckBox);
	    column.setString(kHorizontalAlignment, kStretch);
	    column.setString(kHeader, T("|Visibility Pack|"));
	    column.setString("ToolTip", T("|Toggles the visbility of the component when assigned to a pack.|")); 
	    columnDefinitions.setMap("VisiblePack", column);
	    
	    column.setString(kControlTypeKey, kCheckBox);
	    column.setString(kHorizontalAlignment, kStretch);
	    column.setString(kHeader, T("|Visibility Stack|"));
	    column.setString("ToolTip", T("|Toggles the visbility of the component when assigned to a stack.|")); 
	    columnDefinitions.setMap("VisibleStack", column);	    

	    column.setString(kControlTypeKey, kDoubleBox);
	    column.setString(kHorizontalAlignment, kStretch);
	    column.setString(kHeader, T("|Scale|"));
    	column.setString("ToolTip", T("|Specifie the scale of the component display, must be > 0|"));   
	    columnDefinitions.setMap("Scale", column);		

	    column.setString(kControlTypeKey, kIntegerBox);
	    column.setString(kHorizontalAlignment, kStretch);
	    column.setString(kHeader, T("|Color|"));
	    column.setString("ToolTip", tToolTipColor);
	    columnDefinitions.setMap("Color", column);	

	    column.setString(kControlTypeKey, kIntegerBox);
	    column.setString(kHorizontalAlignment, kStretch);
	    column.setString(kHeader, T("|Transparency|"));
	    column.setString("ToolTip", tToolTipTransparency);
	    columnDefinitions.setMap("Transparency", column);	

		mapDialog.setMap("mpColumnDefinitions", columnDefinitions);			
	//endregion 
		
//	//region Default Rows	
//		if (rowDefinitions.length()<1)
//		{ 
//			Map row;
//	
//			row.setString("Component", tCOG);
//			row.setString("EntityType", tDisabledEntry);
//			row.setInt("VisibleItem", true);
//			row.setInt("VisiblePack", false);
//			row.setInt("VisibleStack", false); 
//			row.setDouble("Scale", 1);
//			row.setInt("Color", 1);
//			row.setInt("Transparency", 50);		
//			rowDefinitions.setMap("row"+rowDefinitions.length(), row);	
//	 
//			row.setString("Component", T("|Grain Direction|"));
//			rowDefinitions.setMap("row"+rowDefinitions.length(), row);	
//	 
//			row.setString("Component", tDisabledEntry);
//			rowDefinitions.setMap("row"+rowDefinitions.length(), row);
//	
//			row.setString("Component", tDisabledEntry);
//			rowDefinitions.setMap("row"+rowDefinitions.length(), row);			
//		}


	    mapDialog.setMap(kRowDefinitions, rowDefinitions);			
	//endregion 			
		
		
		Map mapRet = callDotNetFunction2(sDialogLibrary, sClass, showDynamic, mapDialog);

		if (0 && mapRet.length()>0)
		{ 
			String sFileMap = _kPathPersonalTemp + "\\" + scriptName() + ".dxx";
			mapRet.writeToDxxFile(sFileMap);
			spawn_detach("",_kPathHsbInstall+"\\Utilities\\hsbMapExplorer\\hsbMapExplorer.exe", sFileMap,"");			
		}

		return mapRet;
	}//endregion	





	
//endregion 

//region Mixed Functions

//region Function GetBodyFromQuader
	// returns the body of a quader
	Body GetBodyFromQuader(Quader qdr)
	{ 
		CoordSys cs = qdr.coordSys();
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		Vector3d vecZ = cs.vecZ();
		
		Body bd;
		if (qdr.dX()>dEps && qdr.dY()>dEps && qdr.dZ()>dEps)
		{ 
			bd = Body (qdr.pointAt(0, 0, 0), vecX, vecY, vecZ, qdr.dX(), qdr.dY(), qdr.dZ(), 0, 0, 0);	
		}
			
		return bd;
	}//endregion

//region Function TranslateInverse
	// returns the inverse translation of the given term
	String TranslateInverse(String value)
	{ 
		int n = sComponents.findNoCase(value ,- 1);
		if (n>-1)	return tComponents[n];
		
		n = tComponents.findNoCase(value ,- 1);
		if (n>-1)	return  sComponents[n];
		
		n = sEntityTypes.findNoCase(value ,- 1);
		if (n>-1)	return  tEntityTypes[n];
		
		n = tEntityTypes.findNoCase(value ,- 1);
		if (n>-1)	return  sEntityTypes[n];
		
		return value;
	}//endregion



//region Function TranslateRows
	// translates the language dependent string values and returns the translated map
	Map TranslateRows(Map rows)//, int bInverse)
	{ 
		Map out;
		for (int i=0;i<rows.length();i++) 
		{ 
			if (rows.hasMap(i))
			{ 
				Map row = rows.getMap(i);
				String component = TranslateInverse(row.getString("Component"));
				String entityType = TranslateInverse(row.getString("EntityType"));

				double scale = row.getDouble("Scale");
				if (scale <= 0)scale = 1;
				row.setDouble("Scale", scale,_kNoUnit);
				row.setString("Component", component);
				row.setString("EntityType", entityType);
				
				out.appendMap("row" + out.length(), row);
			}	 
		}//next i		
		
		return out;
	}//endregion



//region Function CenterPointInProfile
	// returns the mid point of the smallest shrink result
	Point3d CenterPointInProfile(PlaneProfile pp)
	{ 
		double shrink = (pp.dX() > pp.dY() ? pp.dY() : pp.dX())*.1;
		Point3d pt = pp.ptMid();
		PLine rings[] = pp.allRings(true, false);
		int cnt;
		while (rings.length()>0 && cnt<6)
		{ 
			pp.shrink(shrink);			
			//{Display dpx(cnt+1); dpx.draw(pp, _kDrawFilled,80);}
			rings = pp.allRings(true, false);
			cnt++;
			if(pp.area()>pow(dEps,2))
				pt = pp.ptMid();	
		}
		return pt;
	}//endregion
	
//region Function IsXrefDimStyle
	// returns true or false if a dimstyle is part of an xref
	int IsXrefDimStyle(String dimStyle, String xRefNames[])
	{ 
		int bOk;
	// ignore xref styles
		int n = dimStyle.find("|",0,false);
		if (n>-1)
		{ 
			String tokens[] = dimStyle.tokenize("|");
			if (tokens.length()>0 && xRefNames.findNoCase(tokens[0],-1)>-1)
				bOk= true;
		}		
		
		return bOk;
	}//endregion	
	
//region Function GetGroupedDimstyles
	// returns 2 arrays of same length (translated and source) of dimstyles which match the filter criteria
	// type: 0 = linear, 1 = undefined, 2 = angular, 3= diameter, 4 = Radial, 6 = coordinates, 7= leader and tolerances
	String[] GetGroupedDimstyles(int type, String& dimStyles[])
	{ 
		String dimStylesUI[0];
		dimStyles.setLength(0);

	// some types are not supported, fall back to linear
		if (type<0 || type>4)
			type = 0;

	// Collect potential xRef Names
		AcadDatabase dbs[] = _kCurrentDatabase.xrefDatabases();
		String sXRefNames[0];
		for (int i=0;i<dbs.length();i++) 
		{
			String dwgName = dbs[i].dwgName();
			dwgName.replace(".dwg", "");
			String tokens[] = dwgName.tokenize("\\");
			if (tokens.length() > 0)dwgName = tokens.last();
			sXRefNames.append(dwgName);
		}


	// append potential linear overrides	
		String sOverrides[0];
		for (int i=0;i<_DimStyles.length();i++) 
		{ 
			String dimStyle = _DimStyles[i]; 
			
			if (IsXrefDimStyle(dimStyle, sXRefNames))
			{ 
				continue;
			}
			
		// ignore xref styles
			int np = dimStyle.find("|",0,false);
			if (np>-1)
			{ 
				String tokens[] = dimStyle.tokenize("|");
				if (tokens.length()>0 && sXRefNames.findNoCase(tokens[0],-1)>-1)
				{ 
					continue;
				}
			}
			
			int n = dimStyle.find("$"+type, 0, false);	// indicating it is an override of the dimstyle
			if (n>-1 && dimStyles.find(dimStyle,-1)<0)
			{
				dimStylesUI.append(dimStyle.left(n)); // trim the appendix
				dimStyles.append(dimStyle);
			}
		}//next i

	// append all non overrides	
		for (int i = 0; i < _DimStyles.length(); i++)
		{
			String dimStyle = _DimStyles[i]; 
			
			if (IsXrefDimStyle(dimStyle, sXRefNames))
			{ 
				continue;
			}	
			
			int n = dimStyle.find("$", 0, false);	// <0 it is not any override of a dimstyle

			if (n<0 && dimStyles.findNoCase(dimStyle)<0 && dimStylesUI.findNoCase(dimStyle)<0) // do not append any parent of a grouped one
			{ 
				dimStylesUI.append(dimStyle);
				dimStyles.append(dimStyle);				
			}
		}
	
	// nothing found
		if (dimStylesUI.length()<1)
		{ 
			dimStylesUI = _DimStyles;
			dimStyles = _DimStyles;	
		}

	// order alphabetically
		for (int i=0;i<dimStylesUI.length();i++) 
			for (int j=0;j<dimStylesUI.length()-1;j++) 
				if (dimStylesUI[j]>dimStylesUI[j+1])
				{
					dimStylesUI.swap(j, j + 1);
					dimStyles.swap(j, j + 1);
				}
		
		return dimStylesUI;
	}//endregion
	

//endregion 

//region Draw Functions

//region Function SetSequenceColor
	// returns the color mapping by a sequence number
	void SetSequenceColor(int& color, int colors[])
	{ 
		if (colors.length()>0)
		{ 
			int n=color;
			while(n>colors.length()-1)
				n-=colors.length();
			color=colors[n];			
		}				
		return;
	}//endregion

//region Function DrawTag
	// returns
	void DrawTag(String text, Point3d ptLoc, String dimStyle, double textHeight, int bWarn)
	{ 
		
		PLine plTag;
		if (text.length()>0)
		{ 
			ptLoc.vis(3);
			Point3d ptTxt = ptLoc;
			double dXTxt = dpText.textLengthForStyle(text, dimStyle, textHeight);
			double dYTxt = dpText.textHeightForStyle(text, dimStyle, textHeight);
			
			Vector3d vec = .5 * (_XW * dXTxt - _YW * dYTxt);
			Vector3d vecMargin = .3 * textHeight*(_XW - _YW);
			ptTxt.transformBy(vec);
			ptTxt.transformBy(vecMargin);
			
			plTag.createRectangle(LineSeg(ptTxt-vec, ptTxt+vec), _XW, _YW);
			plTag.offset(textHeight * .3, true);
			
			PlaneProfile ppTag(plTag);			
			
			dpPlan.draw(PlaneProfile(plTag));
			dpWhite.draw(ppTag, _kDrawFilled, 20);
			dpText.draw(text, ptTxt, _XW, _YW, 0 ,0);
			
			if (bWarn)
			{ 
				dpWhite.trueColor(red, 40);
				PlaneProfile ppWarn = ppTag;
				ppWarn.shrink(-.15 * textHeight);
				ppWarn.subtractProfile(ppTag);
				dpRed.draw(ppWarn, _kDrawFilled);
			}	
		}

		return;
	}//endregion










//region Function DrawPLine
	// draws a pline
	void DrawPLine(PLine pline, Vector3d vecTrans, int rgb,int transparencyWire, int transparency,Display display)
	{ 
	    if (rgb>255)   
	    	display.trueColor(rgb);		    
	    else if (rgb>-1)	    			    
	    	display.color(rgb);

	    int bDrawFilled = transparency>0;	
		display.transparency(transparency);
		
    	PLine& pl = pline;
    	Vector3d vecZ = pl.coordSys().vecZ();
    	if (!vecTrans.bIsZeroLength())	pl.transformBy(vecTrans);

    	if (bDrawFilled)
    		display.draw(PlaneProfile(pl), _kDrawFilled); 
    	
    	display.transparency(transparencyWire);
    	display.draw(pl); 

	    return;
	}//End DrawPLine //endregion

//region Function DrawBodies
	// draws bodies 
	void DrawBodies(Body bodies[], Vector3d vecTrans, int rgb, int transparency,  Display display)
	{ 
		Display displayDrag(-1); // declare new display to ensure the bodies are always drawn on top of the snap profile
		
	    if (rgb<256)
	    {
	    	display.color(rgb);
	    	displayDrag.color(rgb);	    	
	    }
	    else
	    {
	    	display.trueColor(rgb);
	    	displayDrag.trueColor(rgb);	    	
	    }
 
		if (transparency>0)
		{
			display.transparency(transparency);
			displayDrag.transparency(transparency);			
		}

	    for (int i=0;i<bodies.length();i++) 
	    { 
	    	Body bd = bodies[i];
	    	if (!vecTrans.bIsZeroLength())
	    	{
	    		bd.transformBy(vecTrans);
	    		displayDrag.draw(bd);
	    	}
	    	else
	    	{
	    		display.draw(bd);	    	
	    	}
	    	 
	    }//next i
	    return;
	}//endregion

	//region Function drawSpacer
	// returns
	// t: the tslInstance to 
	void drawSpacer(PLine pl, double dSpacerHeight)
	{ 
		Vector3d vecZ = pl.coordSys().vecZ();

		String lineType = "HIDDEN";
		int n = _LineTypes.findNoCase("HIDDEN2" ,- 1);
		if (n>-1)
			lineType = _LineTypes[n];
		else
		{ 
			n = _LineTypes.findNoCase("VERDECKT" ,- 1);
			if (n>-1)lineType = _LineTypes[n];
		}	

		Display dp(-1);
		dp.addHideDirection(_ZW);
		dp.trueColor(lightblue, 50);
		dp.lineType(lineType, 80);
		
		Point3d ptsShape[]= pl.vertexPoints(true);
		for (int i=0;i<ptsShape.length();i++) 
		{ 
			LineSeg seg(ptsShape[i], ptsShape[i]-vecZ*dSpacerHeight); 
			dp.draw(seg); 
		}//next i
		
		pl.transformBy(-vecZ * dSpacerHeight);
		dp.draw(pl);
		return;
	}//End drawSpacer //endregion
	
	//region Function DrawSnap
	// draws the snap ring of a pack 
	void DrawSnap(PlaneProfile pp, double thickness, Vector3d vecTrans, int rgb, int transparency, TslInst parent, Display display)
	{ 
		pp.transformBy(vecTrans);
		PlaneProfile pp1 = pp;
		pp.shrink(-thickness);
		pp.subtractProfile(pp1);

	    if (rgb<256)	display.color(rgb);
	    else			display.trueColor(rgb);	
	    
//	    display.trueColor(rgb, 90);
//	    display.draw(pp1, _kDrawFilled);
	    display.transparency(transparency);
	    display.draw(pp, _kDrawFilled);     
    
		// draw snap area as well    
	    if (parent.bIsValid() && sParentScripts.findNoCase(parent.scriptName(),-1)==1)
	    { 
	    	PlaneProfile ppSnap = parent.map().getPlaneProfile("Snap");
	    	display.draw(ppSnap);
	    }	
	    

	    display.transparency(0);
	    display.draw(pp);
 
	    
	    return;
	}//endregion
	
	//region Function drawShadow
	// returns
	// t: the tslInstance to 
	void drawBodyShadow(Body bd, Vector3d vecView, double offset, int rgb, int transparencyWire, int transparency, Display display)
	{ 
	    if (rgb<256)	display.color(rgb);
	    else			display.trueColor(rgb);	
	    int bDrawFilled = transparency > 0?_kDrawFilled:0;
	    Plane pn(bd.ptCen(), vecView);
	    PlaneProfile pp = bd.shadowProfile(pn);
	    
	    display.draw(pp, bDrawFilled, transparency);
	    if (abs(offset)>dEps)
	    { 
	    	PlaneProfile pp2 = pp;
	    	if (offset>0)	pp.shrink(offset);
	    	else			pp2.shrink(offset);
	    	pp.subtractProfile(pp2);
	    }
	    
	    display.draw(pp, bDrawFilled, transparency);
	    display.transparency(transparencyWire);
	    display.draw(bd);  
	}//End drawShadow //endregion	



//region Function DrawProjections
	// draws shadow projections of the solids in the specified planes
	void DrawProjections(Body bd, PlaneProfile pps[], String lineType, int transparency, Display display, String projectionMode)
	{ 		
		
		Plane pns[0];//tPMNone,tPMViewZP,tPMViewZN,tPMViewZ, tPMAll

		if (projectionMode==tPMViewXP || projectionMode==tPMViewXN || projectionMode==tPMViewX || projectionMode==tPMAll)
		{ 
			Point3d pts[] = bd.extremeVertices(_XW);
			if (pts.length()>0)
			{ 
				if(projectionMode!=tPMViewXN)	pns.append(Plane(pts.last(),_XW));
				if(projectionMode!=tPMViewXP)	pns.append(Plane(pts.first(),-_XW));				
			}				
		}

		if (projectionMode==tPMViewYP || projectionMode==tPMViewYN || projectionMode==tPMViewY || projectionMode==tPMAll)
		{ 
			Point3d pts[] = bd.extremeVertices(_YW);
			if (pts.length()>0)
			{ 
				if(projectionMode!=tPMViewYN)	pns.append(Plane(pts.last(),_YW));
				if(projectionMode!=tPMViewYP)	pns.append(Plane(pts.first(),-_YW));				
			}				
		}

		if (projectionMode==tPMViewZP || projectionMode==tPMViewZN || projectionMode==tPMViewZ || projectionMode==tPMAll)
		{ 
			Point3d pts[] = bd.extremeVertices(_ZW);
			if (pts.length()>0)
			{ 
				if(projectionMode!=tPMViewZN)	pns.append(Plane(pts.last(),_ZW));
				if(projectionMode!=tPMViewZP)	pns.append(Plane(pts.first(),-_ZW));				
			}				
		}
		

		Display dpThis = display;
		if (_LineTypes.findNoCase(lineType,-1)>-1)
			dpThis.lineType(lineType, 80);
		//dpThis.transparency(transparency);
		
		for (int i=0;i<pns.length();i++) 
		{ 
			Plane& pn = pns[i];
			Vector3d vecZ = pn.normal();
			if (vecZ.isParallelTo(vecZView)){ continue;}
			
			PlaneProfile pp = vecZ.isParallelTo(_XW)?pps[0]:(vecZ.isParallelTo(_YW)?pps[1]:pps[2]);
			pp.project(pn, vecZ, dEps);
			dpThis.draw(pp); 
			if (transparency>0 && transparency<100)
				dpThis.draw(pp, _kDrawFilled, transparency );
		}//next i
		
		
		return;
	}//endregion




	//END Draw Functions //endregion 

//region Body Functions

//region Function GetSimplePLineBody
	// returns a simple body by an infinite extrusion of 2 orthogonal plines and intersecting them
	Body GetSimplePLineBody(PLine pl1, PLine pl2)
	{ 
		Vector3d vecZ1 = pl1.coordSys().vecZ();
		if (!pl1.isClosed() || !pl2.isClosed())
		{ 
			reportMessage(TN("|Unexpected error| ") + "GetSimplePLineBody: " + T("|Polylines not closed.|"));
			return Body();			
		}		
		if (pl1.area()<pow(dEps,2) ||pl2.area()<pow(dEps,2))
		{ 
			reportMessage(TN("|Unexpected error| ") + "GetSimplePLineBody: " + T("|Polylines have invalid shapes.|"));
			return Body();			
		}
		Vector3d vecZ2 = pl2.coordSys().vecZ();
		if (!vecZ1.isPerpendicularTo(vecZ2))
		{ 
			reportMessage(TN("|Unexpected error| ") + "GetSimplePLineBody: " + T("|Polylines not orthogonal.|"));
			return Body();
		}
		
		Body bd1(pl1, vecZ1 * U(10e5), 0);
		Body bd2(pl2, vecZ2 * U(10e5), 0);
		if (!bd1.isNull() && !bd2.isNull())
		{
			bd1.intersectWith(bd2);
			return bd1;
		}
		else
			return Body();
	}//endregion

//region Function GetCoordinateProfiles
	// returns teh profiles in each coordinate view, failure if not ==3
	PlaneProfile [] GetCoordinateProfiles(CoordSys cs, Body bd)
	{ 
		Vector3d vecs[] = { cs.vecX(), cs.vecY(), cs.vecZ()};
		PlaneProfile pps[0];
		for (int i=0;i<vecs.length();i++) 
		{ 
			Vector3d vecZ = vecs[i];
			Point3d pt; pt.setToAverage(bd.extremeVertices(vecZ));
			PlaneProfile pp = bd.shadowProfile(Plane(pt, vecZ));
			if (pp.area()>pow(dEps,2)) // if one shadow fails
			{ 
				if(bDebug)pp.vis(i+1);
				pps.append(pp);
			}
		}
		return pps;
	}//endregion		

//region Function GetProfilesSimpleBody
	// returns a simplified body by intersecting coordinate extrusions
	Body GetProfilesSimpleBody(CoordSys cs, PlaneProfile pps[])
	{ 
		Body bdOut;
		for (int i=0;i<pps.length();i++) 
		{ 
			PlaneProfile pp = pps[i];
			Vector3d vecZ = pp.coordSys().vecZ();

			if (pp.area()<pow(dEps,2)) // if one shadow fails
			{ 
				return bdOut;
			}
			Body bdx;
			PLine rings[] = pp.allRings(true, false);
			for (int r=0;r<rings.length();r++) 
			{ 
				Body bdi(rings[r], vecZ * U(10e4), 0);
				if (!bdi.isNull())
					bdx.addPart(bdi);					
			}
			rings = pp.allRings(false, true);
			for (int r=0;r<rings.length();r++) 
			{ 
				Body bdi(rings[r], vecZ * U(10e5), 0);
				if (!bdi.isNull())
					bdx.subPart(bdi);					
			}
			
			if (bdOut.volume()<pow(dEps,3))
			{
				bdOut = bdx;
			}
			else
			{
				bdOut.intersectWith(bdx);
			}
			 
		}//next i

		return bdOut;
	}//endregion

//region Function GetSimpleBody
	// returns a simplified body by intersecting coordinate extrusions
	void GetSimpleBody(CoordSys cs, Body& bd)
	{ 
		Vector3d vecs[] = { cs.vecX(), cs.vecY(), cs.vecZ()};
		Body bdOut;
		for (int i=0;i<vecs.length();i++) 
		{ 
			Vector3d vecZ = vecs[i];
			
			Point3d pts[] = bd.extremeVertices(vecZ);
			Point3d ptm; ptm.setToAverage(pts);
			PlaneProfile pp = bd.shadowProfile(Plane(ptm, vecZ));

			pp.vis(i+1);
			if (pp.area()<pow(dEps,2)) // if one shadow fails
			{ 
				bdOut = bd;
				return;
			}
			Body bdx;
			PLine rings[] = pp.allRings(true, false);
			for (int r=0;r<rings.length();r++) 
			{ 
				Body bdi(rings[r], vecZ * U(10e4), 0);
				if (!bdi.isNull())
					bdx.addPart(bdi);					
			}
			rings = pp.allRings(false, true);
			for (int r=0;r<rings.length();r++) 
			{ 
				Body bdi(rings[r], vecZ * U(10e5), 0);
				if (!bdi.isNull())
					bdx.subPart(bdi);					
			}
			
			if (bdOut.volume()<pow(dEps,3))
			{
				bdOut = bdx;
			}
			else
			{
				bdOut.intersectWith(bdx);
			}
			 
		}//next i
		if (bdOut.volume()>pow(dEps,3))
			bd = bdOut;
		return;
	}//endregion	
	
//region Function GetElementOrg
	// returns the origin based on the solid
	Point3d GetElementOrg(CoordSys cs, Body bd)
	 { 
	 	Point3d ptOrg = cs.ptOrg();
	 	
	 	Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		Vector3d vecZ = cs.vecZ();
		
		PlaneProfile ppZ = bd.shadowProfile(Plane(ptOrg, vecZ));
		ptOrg = ppZ.extentInDir(vecX).ptMid();

		PlaneProfile ppY = bd.shadowProfile(Plane(ptOrg, vecY));//ppY.vis(40);
		ptOrg+=vecZ*vecZ.dotProduct(ppY.extentInDir(vecX).ptMid()-ptOrg);

		Point3d pts[] = bd.extremeVertices(vecY);
		if (pts.length()>0)
			ptOrg += vecY * vecY.dotProduct(pts.first() - ptOrg);

		ptOrg.vis(6);
		return ptOrg;
	}//endregion

//region Function GetMediumElementBody
	// returns an simplified body of an element with no openings
	Body GetMediumElementBody(Element el, Point3d& ptOrg)
	{ 
		Body bdOut;
		Vector3d vecX = el.vecX();
		Vector3d vecY = el.vecY();
		Vector3d vecZ = el.vecZ();
		
		for (int z=-5;z<6;z++) 
		{ 
			ElemZone zone = el.zone(z);
			double dH =zone.dH();
			if (dH>dEps)
			{ 
				Body bdz;
				PlaneProfile pp(CoordSys(zone.ptOrg(), vecX, vecY, vecZ));
				pp.unionWith(el.profNetto(z, true, true));
				//pp.vis(z + 6);
				PLine rings[] = pp.allRings(true, false);
				for (int r=0;r<rings.length();r++) 
				{
					if (r==0)
						bdz=Body(rings[r], dH * zone.vecZ(), 1);							
					else
						bdz.addPart(Body(rings[r], dH * zone.vecZ(), 1));
				}

				rings = pp.allRings(false, true);
				for (int r=0;r<rings.length();r++) 
					bdz.subPart(Body(rings[r],el.vecZ()* U(10e5), 0));
				//bdz.vis(z+6);
				bdOut.addPart(bdz);
			}
			 
		}//next z	
	
	// catch elements with no construction
		if (bdOut.isNull())
		{ 
			PLine pl = el.plEnvelope();
			LineSeg seg = el.segmentMinMax();		seg.vis(1);
			double dH = abs(vecZ.dotProduct(seg.ptEnd() - seg.ptStart()));
			ElementRoof elr = (ElementRoof)el;
			if (elr.bIsValid() && dH<dEps)
			{ 
				dH = elr.dReferenceHeight();
			}	
			else	
			{
				Plane pn(el.segmentMinMax().ptMid(), vecZ);
				pl.projectPointsToPlane(pn, vecZ);
			}

			if (dH>dEps && pl.length()>dEps && pl.isClosed())
			{
				bdOut=Body(pl, vecZ*dH, 0);
			}
			else
			{ 
				bdOut = el.realBody();
				if (bDebug)reportMessage("\n" + scriptName() + ": " +T("|could not resolve element body|"));
				
			}
			
		}
		if (bDebug)bdOut.vis(150);
		//ptOrg = GetElementOrg(el.coordSys(), bd);
		return bdOut;
	}//endregion		

//region Function GetLowResElementBody
	// returns an simplified body of an element with no openings
	Body GetLowResElementBody(Element el, Point3d& ptOrg)
	{ 
		Body bd;
		Vector3d vecX = el.vecX();
		Vector3d vecY = el.vecY();
		Vector3d vecZ = el.vecZ();

		LineSeg seg = el.segmentMinMax();

		double dX = abs(vecX.dotProduct(seg.ptEnd() - seg.ptStart()));
		double dY = abs(vecY.dotProduct(seg.ptEnd() - seg.ptStart()));
		double dZ = abs(vecZ.dotProduct(seg.ptEnd() - seg.ptStart()));

		bd = Body(seg.ptMid(), vecX, vecY, vecZ, dX, dY, dZ, 0, 0, 0);

		PlaneProfile ppx(CoordSys(seg.ptMid(), vecX, vecY, vecZ));
		for (int z=-5;z<6;z++) 
		{ 
			ElemZone zone = el.zone(z);
			double dH =zone.dH();
			if (dH>dEps)
			{
				PlaneProfile ppb = el.profBrutto(z);
				ppx.unionWith(el.profBrutto(z));//, true, true));
			}
			 
		}//next z	
		ppx.createRectangle(ppx.extentInDir(vecX), vecX, vecY);	ppx.vis(2);
		PLine rings[] = ppx.allRings(true, false);

		for (int r=0;r<rings.length();r++) 
		{
//			rings[r].vis()
			bd.addPart(Body(rings[r], dZ * vecZ, 0));
		}			


		if (bDebug)bd.vis(4);
	
		ptOrg = GetElementOrg(el.coordSys(), bd);
		return bd;
	}//End getLowResElement //endregion		

//region Function GetWallBody
	// returns the simplified body of a wall trying to rtesolve the AEC Body
	Body GetWallBody(ElementWall elw, int shapeMode)
	{ 
		CoordSys csDef = elw.coordSys();
		Vector3d vecX = csDef.vecX();
		Vector3d vecY = csDef.vecY();
		Vector3d vecZ = csDef.vecZ();
		Point3d ptOrg = csDef.ptOrg();
		Wall wall = (Wall)elw;
		
		
		//bCacheGraphics, bDoMergers, bCutOpenings, bDoInterference, bApplyBodyModifiers
		Body bd = wall.shrinkWrapBody(true, false, false, true, true);
		if (bd.isNull())// another attempt with no interferences
			bd = wall.shrinkWrapBody(true, false, false, false, true);
		if (bd.isNull())// another attempt with no ApplyBodyModifiers
			bd = wall.shrinkWrapBody(true, false, false, true, false);
		if (bd.isNull())// another attempt with no interferences and no ApplyBodyModifiers
			bd = wall.shrinkWrapBody(true, false, false, false, false);	
		if (bd.isNull())// another attempt with no interferences and no ApplyBodyModifiers
			bd = wall.realBody();	
		
		// last trap: in some gable scenarious the shrinkWrap appears also to be corrupt, fall back to shape extrusion
		if (bd.isNull())// version 7.3, 7.4
		{
			double dWidth = wall.instanceWidth();
			PLine pl=elw.plEnvelope();
			Vector3d vecAec = vecZ;
			if (vecZ.dotProduct(wall.ptStart()-ptOrg)>0)vecAec*=-1;
			pl.transformBy(vecZ*vecZ.dotProduct(wall.ptStart()-pl.coordSys().ptOrg()));
			bd = Body(pl,vecAec *dWidth,1);
		}	
		//bd.vis(2);
		
	// get outline
		PlaneProfile pp(CoordSys(ptOrg, vecX, - vecZ, vecY));
		Plane pn(ptOrg, vecY);
		pp.unionWith(bd.shadowProfile(pn));
		if (pp.area()<pow(dEps,2))
			pp.joinRing(elw.plOutlineWall(), _kAdd);
		
	// reconstruct planview as hull, this solcves issues on gable walls
		PLine hull;
		if (shapeMode == 3)
			hull.createRectangle(pp.extentInDir(vecX), vecX, - vecZ);
		else
		{ 
			hull.createConvexHull(pn,pp.getGripVertexPoints());
			hull.simplify();			
		}
		//hull.vis(6);
		pp.joinRing(hull, _kAdd);
		
		
		
	// reconstruct body by the intersection of two extrusions
		PLine rings[] = bd.shadowProfile(Plane(ptOrg, vecZ)).allRings(true, false);
		Opening openings[] = elw.opening();
		if (rings.length()>0)// plEnvelope.area()>pow(dEps,2))
		{ 
			Body bdh(hull, vecY * U(10e4), 0);

			Body bdx;
			for (int r=0;r<rings.length();r++) 
			{  
				Body bdr(rings[r], vecZ * U(10e4), 0);
				bdx.addPart(bdr);
			}//next r
			
			if (!bdh.isNull() && !bdx.isNull())
				bdh.intersectWith(bdx);
			if(!bdh.isNull())
			{
				bd = bdh;
			
			}
			if (shapeMode !=3)
				for (int r=0;r<openings.length();r++) 
					bd.subPart(Body(openings[r].plShape(), vecZ*U(10e4),0)); 
			//bd.vis(3);
			
			
		}		

		return bd;
	}//endregion

//region Function GetGenBeamBody
	// returns
	// t: the tslInstance to 
	Body GetGenBeamBody(GenBeam genbeam,int shapeMode)
	{ 
		GenBeam g = genbeam;
		Body bd;
		if (shapeMode == 1)bd =g.envelopeBody(false,true);
		else if (shapeMode == 2)bd =g.envelopeBody(true,true);
		else if (shapeMode == 3){bd =g.envelopeBody();}
		else bd =g.realBody();
		return bd;
	}//End GetGenBeamBody //endregion	

//region Function GetMetalPartBody // HSB-23088
	// returns the body of a metalpart
	Body GetMetalPartBody(MetalPartCollectionEnt ce, int shapeMode, PainterDefinition pd)
	{ 
		Body out;
		
		if (shapeMode<1)
			return ce.realBodyTry();
		else if (shapeMode==3) // Low
		{ 
			Quader qdr = ce.bodyExtents();
			out = GetBodyFromQuader(qdr);
			return out;
		}
		
		MetalPartCollectionDef cd = ce.definitionObject();
		CoordSys cs = ce.coordSys();
		
	// get from genbeam	
		GenBeam gbs[] = cd.genBeam();
		if (pd.bIsValid())gbs = pd.filterAcceptedEntities(gbs);
		
		for (int i=0;i<gbs.length();i++) 
		{ 
			Body bd;
			GenBeam g = gbs[i];
			if (g.bIsDummy())continue;
			bd = GetGenBeamBody(g, shapeMode );		
			
			if (!bd.isNull())
			{
				bd.transformBy(cs);
				out.combine(bd);
			}
		}//next i

	// get from entity
		Entity ents[] = cd.entity();
		if (pd.bIsValid())ents = pd.filterAcceptedEntities(ents);
		for (int i=0;i<ents.length();i++) 
		{ 
			Entity e= ents[i]; 
			if (gbs.find(e)>-1){ continue;}
			
			Body bd;
			GenBeam g = (GenBeam)e;
			MetalPartCollectionEnt ce = (MetalPartCollectionEnt)e;
			if (g.bIsValid())
			{ 
				if (g.bIsDummy())continue;
				bd = GetGenBeamBody(g, shapeMode );					
			}
			else if (ce.bIsValid())
			{ 
				bd = GetMetalPartBody(ce, shapeMode, pd );					
			}			
			else
				bd = e.realBodyTry();
			
			if (!bd.isNull())
			{
				bd.transformBy(cs);
				out.combine(bd);
			}
		}//next i




		return out;
	}//endregion


//End Body Functions //endregion 	

//region Filter Functions
	
//region Function FilterTslsByName
	// returns all tsl instances with a certain scriptname
	// ents: the array to search, if empty all tsls in modelspace are taken
	// names: the names of the tsls to be returned, all if empty
	TslInst[] FilterTslsByName(Entity ents[], String names[])
	{ 
		TslInst out[0];
		int bAll = names.length() < 1;
		
		if (ents.length()<1)
			ents = Group().collectEntities(true, TslInst(),  _kModelSpace);
		
		for (int i=0;i<ents.length();i++) 
		{ 
			TslInst t= (TslInst)ents[i]; 
			//reportNotice("\ngetTslsByName: " + t.scriptName() +" "+names);
			if (t.bIsValid())
			{
				if (!bAll && names.findNoCase(t.scriptName(),-1)>-1)
					out.append(t);	
				else if (bAll)
					out.append(t);									
			}
				
		}//next i

		return out;
	
	}//endregion
		

//region Function FilterCloseSiblings
	// returns siblings which are closed to thisinst
	// segMe: the extents of the reference item
	// siblings: the items or packs of the parent
	// vecX, vecZ: the coordSys of the test
	// bDraw: flag to draw the result
	TslInst[] FilterCloseSiblings(PlaneProfile ppMe, TslInst siblings[], int bDraw)
	{ 
		TslInst out[0];
		
		CoordSys cs = ppMe.coordSys();
		Vector3d vecX = cs.vecX();
		Vector3d vecZ = cs.vecZ();
		
		LineSeg segMe = ppMe.extentInDir(vecX);
		
		Point3d ptm = segMe.ptMid();
		
		if (bDraw)
		{ 
			dp.color(40);
			PLine circMe;
			circMe.createCircle(segMe.ptMid(), vecZ, segMe.length() * .5);
			dp.draw(circMe);
		}

		for (int i=0;i<siblings.length();i++) 
		{ 
			TslInst t = siblings[i];
			PlaneProfile pp(cs);
			pp.unionWith(t.realBody(_XW+_YW+_ZW).shadowProfile(Plane(ptm, vecZ)));
			LineSeg seg = pp.extentInDir(vecX);
			Point3d ptmi = seg.ptMid();
			
			double dist = (ptmi - ptm).length();
			if (dist < .5 * (seg.length() + segMe.length()))
			{ 	
				if (bDraw)
				{
					dp.color(i);
					PLine circ;
					circ.createCircle(ptmi, vecZ, seg.length() * .5);	
					dp.draw(circ);
				}
				out.append(t);
			} 
		}//next i		
	
		return out;
	}//End FilterCloseSiblings //endregion

//region Function FilterIntersectingSiblings
	// returns siblings of a parent if the projection of the solid intersects
	// siblings: the siblings of the parent
	// ppMe: the shadow of the reference item
	// bDraw: flag to draw the result
	TslInst[] FilterIntersectingSiblings(PlaneProfile ppMe, TslInst siblings[], int bDraw)
	{ 
		TslInst out[0];
		CoordSys cs = ppMe.coordSys();
	
		//{Display dpx(1); dpx.draw(ppMe, _kDrawFilled,80);}		
		
		PlaneProfile ppAll(cs);
		for (int i=0;i<siblings.length();i++)
		{ 
			TslInst& t = siblings[i];
			Map m = t.map();
			PlaneProfile pp(cs);
			
			Body bdSibling;
//			if (m.hasBody("Cache"))
//				bdSibling =	m.getBody("Cache");
			if (bdSibling.isNull())
				bdSibling = t.realBody(_XW + _YW + _ZW);
			if (bDebug && bdSibling.isNull())
			{
				reportNotice("\nUnexpeced no body of FilterIntersectingSiblings");
			}	
			pp.unionWith(bdSibling.shadowProfile(Plane(cs.ptOrg(), cs.vecZ())));
			
				
			PlaneProfile ppx = ppMe;
			if (ppx.intersectWith(pp))
			{
				//{Display dpx(2); dpx.draw(ppx, _kDrawFilled,30);	}
				out.append(t);
				if (bDraw)
				{
					dp.trueColor(red, 35);
					dp.draw(ppx, _kDrawFilled);
				}
			}	
		}
		return out;
	}//endregion

//region Function FilterIntersectingSolids
	// returns siblings of a parent if the projection of the solid intersects
	// siblings: the siblings of the parent
	// ppMe: the shadow of the reference item
	// bDraw: flag to draw the result
	TslInst[] FilterIntersectingSolids(TslInst this, Body bdMe, TslInst siblings[], int bDraw)
	{ 
		TslInst out[0];
	
		for (int i=0;i<siblings.length();i++)
		{ 
			TslInst t  = siblings[i];
			if (this == t)continue;
			
			Body bdi = t.realBody(_XW+_YW+_ZW);
			//reportNotice("\nvol " + bdi.volume() + "...");
			bdi.intersectWith(bdMe);
	
			if (!bdi.isNull())
			{ 
				//reportNotice(" intersections found with " + t.handle());
				out.append(t);
				if (bDraw)
				{
					dpModelPlan.trueColor(red, 50);
					//dpModelPlan.draw(bdi.shadowProfile(Plane(bdi.ptCen(), vecZView)), _kDrawFilled);
					dpRed.draw(bdi.shadowProfile(Plane(bdi.ptCen()-_ZW*.5*bdi.lengthInDirection(_ZW), _ZW)), _kDrawFilled);
					dp.transparency(0);
					dpRed.draw(bdi);	
				}
			}	
		}
		return out;
	}//endregion

	//region Function getLoadProfiles
	// returns the loading profiles of a truck definition specified as property of a tsl
	// t: the tslInstance to query the truckDefinition from
	// ppIntersect: used for intersection test if not null
	PlaneProfile[] getLoadProfiles(Entity ent, PlaneProfile ppIntersect)
	{ 		
		TslInst t = (TslInst)ent;
		PlaneProfile out[0];
		int bTestIntersection = ppIntersect.area() > pow(dEps, 2);
		CoordSys csx = ppIntersect.coordSys();
		
		if (t.bIsValid())
		{
			CoordSys cs = t.coordSys();
			String sDefinition = t.propString(sTruckDefinitionPropertyName);
			TruckDefinition td(sDefinition);
			if (sDefinitions.findNoCase(sDefinition ,- 1) >- 1 && td.bIsValid())
			{
				PlaneProfile pps[] = td.loadProfiles();

				for (int i=pps.length()-1; i>=0 ; i--) 
				{ 
					PlaneProfile ppi=pps[i]; 
					ppi.transformBy(cs);
					CoordSys csi = ppi.coordSys();
					
				// test if coplanar
					if (!csi.vecZ().isParallelTo(csx.vecZ()))
					{ 
						reportMessage("\nload profile not coplanar, refused " + i);
						continue;
					}	
					//dp.draw(ppi, _kDrawFilled, 30);
					if (bTestIntersection && !ppi.intersectWith(ppIntersect))
					{
						pps.removeAt(i);	
						continue;
					}
					else
					{ 
						pps[i].transformBy(cs);
						out.append(pps[i]);
					}
				}//next i
			}
			else
				reportMessage("\n" +  T("|Error| getLoadProfiles(): ") +sDefinition + T(" |could not be retrieved from| ") + t.scriptName());
		}					 
		else
			reportMessage("\n" +  T("|Error| getLoadProfiles(): ") +T(" |invalid tsl instance|"));

		return out;
	}//endregion 

//region Function FindIntersectingParentBySolid
	// returns a stack or package tsl if an intersection was found
	// bd: the body to be tested 
	// bdMax: the body of the entity with the largest intersection
	// explicitScript: use explicitly if specified
	TslInst FindIntersectingParentBySolid(Body bd, Body& bdMax, Vector3d vecApplied, String explicitScript)
	{
		String parentScripts[0];
		if (sParentScripts.findNoCase(explicitScript ,- 1) >- 1)
			parentScripts.append(explicitScript);
		else
			parentScripts = sParentScripts;
		TslInst tslParents[] = FilterTslsByName(Group().collectEntities(true, TslInst(), _kModelSpace), parentScripts);

		double volumes[0];
		Entity entsX[0];
		Body bodies[0];
		bd.transformBy(vecApplied);
		int bHasPack;
		
		for (int i = 0; i < tslParents.length(); i++)
		{
			TslInst& t = tslParents[i];
			String scriptName = t.scriptName();
			Map m = t.map();
			double dSpacerHeight = t.propDouble(tSpacerHeightName);
			
			PlaneProfile ppShapeY = m.getPlaneProfile("ShapeY");
			PlaneProfile ppShapeZ = m.getPlaneProfile("ShapeZ");
			CoordSys cs1= ppShapeY.coordSys();
			CoordSys cs2= ppShapeZ.coordSys();
			Point3d pt1 = ppShapeY.ptMid();
			Point3d pt2 = ppShapeZ.ptMid();
			
			PLine pl2; pl2.createRectangle(ppShapeZ.extentInDir(cs2.vecX()), cs2.vecX(), cs2.vecY());

			// make sure rectangle has same X-dim as pl2
			pt1+=cs2.vecX()*cs2.vecX().dotProduct(pt2-pt1);
			Vector3d vec1 =.5*(cs1.vecX() * ppShapeZ.dX() + cs1.vecY() * (ppShapeY.dY()+U(100)+dSpacerHeight));
			PLine pl1; pl1.createRectangle(LineSeg(pt1-vec1, pt1+vec1), cs1.vecX(), cs1.vecY());

			Body bdx = GetSimplePLineBody(pl1, pl2);
			Body bdx2=bdx;
			if (!bdx.isNull() && bdx.intersectWith(bd))
			{ 
				volumes.append(bdx.volume());
				entsX.append(t);
				bodies.append(bdx2);
				if (scriptName==kScriptPack)// StackPack
					bHasPack = true;
					
//				Display dpx(2);
//				dpx.draw(bdx2);					
			}	
		}


	// remove Stacks if any packs are found
		if (bHasPack)
		{ 
			for (int i=entsX.length()-1; i>=0 ; i--) 
			{ 
				TslInst t=(TslInst)entsX[i];
				if (t.bIsValid() && t.scriptName()==kScriptStack)
				{ 
					volumes.removeAt(i);
					entsX.removeAt(i);
					bodies.removeAt(i);
				}			
			}//next i			
		}

	// order ascending by volume
		for (int i=0;i<volumes.length();i++) 
			for (int j=0;j<volumes.length()-1;j++) 
				if (volumes[j]>volumes[j+1])
				{
					volumes.swap(j, j + 1);
					entsX.swap(j, j + 1);
					bodies.swap(j, j + 1);					
				}


		TslInst out;
		if (bodies.length()>0)
		{
			bdMax = bodies.first();	
			//if (bDebug){Display dpx(3);dpx.draw(bdMax);}		
			out = (TslInst)entsX.first();
		}
		return out;
		
	}



//region Function FindIntersectingParent
	// returns a stack or package tsl if an intersection was found
	// shape: the shape to be tested 
	// ppMax: the profile of the largest intersection
	// explicitScript: use explicitly if specified
	TslInst FindIntersectingParent(PlaneProfile shape, PlaneProfile& ppMax, String explicitScript)
	{ 	
		String parentScripts[0]; 
		if (sParentScripts.findNoCase(explicitScript,-1)>-1)
			parentScripts.append(explicitScript);
		else
			parentScripts = sParentScripts;
		
		
		Vector3d vecZ = shape.coordSys().vecZ();
		
		
	// collect tsl candidates	
		Entity ents[] = Group().collectEntities(true, TslInst(), _kModelSpace);
		TslInst tslParents[0];
		for (int i=0;i<ents.length();i++) 
		{ 
			TslInst t = (TslInst)ents[i];	
			if (t.bIsValid() && t.isVisible() && parentScripts.findNoCase(t.scriptName(),-1)>-1)
				tslParents.append(t);				 
		}//next i
		//reportMessage("\n" + tslParents.length() + " found");
		
		
		PlaneProfile pps[0];
		int indices[0];
		double areas[0];
		Entity entsX[0];		

		int bHasPack;
		for (int i = 0; i < tslParents.length(); i++)
		{
			TslInst t = tslParents[i];
			String scriptName = t.scriptName();

			if (scriptName==kScriptStack) // StackEntity
			{ 
				PlaneProfile ppLoads[] = getLoadProfiles(t, PlaneProfile());// TODO use ppIntersect instead
				for (int j=0;j<ppLoads.length();j++) 
				{ 
					PlaneProfile ppx,ppi = ppLoads[j];
					ppx = ppi;
					ppx.shrink(-dSnapTolerance*.5); // allow snapping closed to current outline
					ppx.intersectWith(shape);
					double area = ppx.area();
					//reportNotice("\n" +t.handle() +" load j " + j + " reports area " + area);
					if (area > pow(dEps, 2))
					{
						pps.append(ppi);
						areas.append(area);
						indices.append(i);
						entsX.append(t);
					}									 
				}//next j				
			}
			else if (scriptName==kScriptPack) // StackPack
			{ 
				PlaneProfile ppxs[0];
				Map map = t.map();
				
			// find profile coplanar to current view	
				PlaneProfile ppShapes[] = { map.getPlaneProfile("ShapeZ"), map.getPlaneProfile("ShapeY"), map.getPlaneProfile("ShapeX") };
				for (int i=0;i<ppShapes.length();i++) 
				{ 
					if(ppShapes[i].coordSys().vecZ().isParallelTo(vecZ))
					{ 
						ppxs.append(ppShapes[i]);
						break;
					}						 
				}//next i

				
				for (int j=0;j<ppxs.length();j++) 
				{ 
					PlaneProfile ppi =ppxs[j];
					PlaneProfile ppx;
					ppx = ppi;
					ppx.shrink(-dSnapTolerance); // allow snapping closed to current outline
					ppx.intersectWith(shape);
					//dp.draw(ppx, _kDrawFilled, 40);				
					
					double area = ppx.area();
					//reportNotice("\n" +t.handle() +" load j " + i + " reports area " + area);
					if (area > pow(dEps, 2))
					{
						pps.append(ppxs[j]);
						areas.append(area);
						indices.append(i);
						entsX.append(t);
						bHasPack = true;
						break;
					}		 
				}//next j
				
			
			}
			
		}//next i
	
	// remove Stacks if any packs are found
		if (bHasPack)
		{ 
			for (int i=entsX.length()-1; i>=0 ; i--) 
			{ 
				TslInst t=(TslInst)entsX[i];
				if (t.bIsValid() && t.scriptName()==kScriptStack)
				{ 
					pps.removeAt(i);
					areas.removeAt(i);
					indices.removeAt(i);
					entsX.removeAt(i);					
				}			
			}//next i			
		}

	// find biggest intersection
		for (int i=0;i<areas.length();i++) 
			for (int j=0;j<areas.length()-1;j++) 
				if (areas[j]<areas[j+1])
				{	
					areas.swap(j, j + 1);
					pps.swap(j, j + 1);
					indices.swap(j, j + 1);
					entsX.swap(j, j + 1);	
				}			
		
		TslInst out;
		for (int i=0;i<areas.length();i++)
		{ 
			if (i==0)
			{
				ppMax = pps[i];
				out = (TslInst)entsX.first();
			}
//			else
//				ppOthers.append(pps[i]);
			
		}

		return out;
	}//endregion

	//region Function getTslTruckDefinition
	// returns the loading profiles of a truck definition specified as property of a tsl
	// t: the tslInstance to query the truckDefinition from
	TruckDefinition getTslTruckDefinition(TslInst t)
	{ 		
		TruckDefinition td;
		if (t.bIsValid())
		{
			String sDefinition = t.propString(sTruckDefinitionPropertyName);
			td=TruckDefinition(sDefinition);
			if (sDefinitions.findNoCase(sDefinition ,- 1) >- 1 && td.bIsValid())
			{
				//reportMessage("\n returnning" + td.entryName()); 
				return; 
			}
			else
				reportMessage("\n" +  T("|Error| getTslTruckDefinition(): ") +sDefinition + T(" |could not be retrieved from| ") + t.scriptName());
		}					 
		else
			reportMessage("\n" +  T("|Error| getTslTruckDefinition(): ") +T(" |invalid tsl instance|"));

		return;
	}//endregion

	//region Function getTruckDefinitions
	// collects all tsls which specify a truckDefinition
	Map[] getTruckDefinitions()
	{ 	
		Map out[0];
		Entity ents[] = Group().collectEntities(true, TslInst(), _kModelSpace);
		for (int i=0;i<ents.length();i++) 
		{ 
			TslInst t = (TslInst)ents[i];	
			if (t.bIsValid() && t.isVisible())
			{
				String sDefinition = t.propString(sTruckDefinitionPropertyName);
				TruckDefinition td(sDefinition);

				if (sDefinitions.findNoCase(sDefinition ,- 1) >- 1 && td.bIsValid())
				{ 
					Map m;
					m.setEntity("ent", t);
					m.setString("definition", sDefinition);
					m.setMap("Stacking",t.subMapX("Stacking"));

					out.append(m);
				}						
			}					 
		}//next i	
		return out;
	}//endregion 	


	//END Filter Functions //endregion
	
//region Mixed Functions
	
//region Function ReorderAlternatingPoints
	// reorders points alternating
	void ReorderAlternatingPoints(Point3d& pts[], Vector3d vecZ)
	{ 
		
		Line lnZ(_Pt0, vecZ);
		pts = lnZ.orderPoints(lnZ.projectPoints(pts), dEps);
		if (pts.length() > 1)
		{
			pts.removeAt(pts.length() - 1);	
			
			Point3d pts2[0];
			int i = 0;
	        int j = pts.length() - 1;			
	        while (i <= j)
	        {
	            if (i == j)
	            {
	                pts2.append(pts[i]);
	            }
	            else
	            {
	                pts2.append(pts[i]);
	                pts2.append(pts[j]);
	            }
	            i++;
	            j--;
	        }
	   		pts = pts2;			
		}
   		return;
	}//endregion	
	
	
	//region Function: createPainter
	// Creates a painter definition in a given collection if at least one object can be found in the database
	// sPainters: existing painters + new painter on success
	// type: the entity type
	// filter: the painter filter
	// format: the painter format
	// collectionName: the collectionName of the painter
	// name: the name of the painter definition	
		void createPainter(String& sPainters[], String type, String filter, String format, String collectionName, String name)
		{ 
			if (sPainters.findNoCase(name,-1)<0)
			{ 
				Entity ents[0];
				if (type.find("Beam",0,false)==0)
					ents= Group().collectEntities(true, Beam(), _kModelSpace);
				else if (type.find("Panel",0,false)==0)
					ents= Group().collectEntities(true, Sip(), _kModelSpace);
				else if (type.find("Sheet",0,false)==0)
					ents= Group().collectEntities(true, Sheet(), _kModelSpace);
				else 
					return;
					
				String painter = collectionName + name;
				PainterDefinition pd(painter);	
				if (!pd.bIsValid() && ents.length()>0)
				{ 
					pd.dbCreate();
					if (pd.bIsValid())
					{ 
						pd.setType(type);
						if (filter.length()>0)pd.setFilter(filter);
						if (format.length()>0)pd.setFormat(format);
					}
				}				
				if (sPainters.findNoCase(name,-1)<0 && pd.bIsValid())
					sPainters.append(name);		
			}			
		}//endregion



//region Function GetTslChildBodies
	// returns the bodies of the entities linked by a tsl
	// t: the tslInstance to analyse 
	Body[] GetTslChildBodies(TslInst t, int shapeMode, PainterDefinition pd)
	{ 
		Body out[0];
		

	// get from genbeam	
		GenBeam gbs[] = t.genBeam();
		if (pd.bIsValid())gbs = pd.filterAcceptedEntities(gbs);
		for (int i=0;i<gbs.length();i++) 
		{ 
			Body bd;
			GenBeam g = gbs[i];
			if (g.bIsDummy())continue;
			bd = GetGenBeamBody(g, shapeMode );		
			if (!bd.isNull())
				out.append(bd);
		}//next i

		
	// get from entity
		Entity ents[] = t.entity();
		if (pd.bIsValid())ents = pd.filterAcceptedEntities(ents);
		for (int i=0;i<ents.length();i++) 
		{ 
			Entity e= ents[i]; 
			if (gbs.find(e)>-1){ continue;}
			
			Body bd;
			GenBeam g = (GenBeam)e;
			MetalPartCollectionEnt ce = (MetalPartCollectionEnt)e;
			if (g.bIsValid())
			{ 
				if (g.bIsDummy())continue;
				bd = GetGenBeamBody(g, shapeMode );					
			}
			else if (ce.bIsValid())
			{ 
				bd = GetMetalPartBody(ce, shapeMode,pd);	// HSB-23088				
			}			
			else
				bd = e.realBodyTry();
			
			if (!bd.isNull())
				out.append(bd);
		}//next i

		return out;	
	}//endregion

	//region Function hasDuplicate
	// returns if a script of the given scriptname is attached to the entity
	// this: the tslInstance which runs the test
	// ent: the entity to test the associtions
	// scriptName: optional scriptName
	int hasDuplicate(Entity ent, TslInst this, String scriptName)
	{ 
		int out;
		
		if (scriptName.length()<1 && this.bIsValid())
			scriptName = this.scriptName();
		else if (scriptName.length()<1)
			scriptName = scriptName();
		scriptName.makeLower();
	
		TslInst tsls[] = ent.tslInstAttached();
		for (int j= 0; j < tsls.length(); j++)
		{ 
			TslInst t = tsls[j];
			String scriptNameB = t.scriptName(); scriptNameB.makeLower();
			if (scriptName == scriptNameB && t!=this)
			{ 
				if (bDebug)reportMessage("\n" + ent.handle() + T(" |has already a stacking clone attached|"));
				out = true;
				break;	
			}
		}
		return out;
	}//End hasDuplicate //endregion

//region Function GetBodiesShadow
	// returns a planeprofile made of the shadowprofile of bodies
	// bodies: the bodies to analyse
	// cs the coordSys of the planeprofile defining the view direction
	PlaneProfile GetBodiesShadow(Body bodies[], CoordSys cs, double merge)
	{ 
		PlaneProfile pp(cs);
		Plane pn(cs.ptOrg(), cs.vecZ());
		for (int i=0;i<bodies.length();i++) 
		{ 
			PlaneProfile ppx(cs);
			ppx.unionWith(bodies[i].shadowProfile(pn));
			if (merge>0)
				ppx.shrink(-merge);
			pp.unionWith(ppx);				 
		}//next i
		if (merge>0)
			pp.shrink(merge);
		return pp;
	} //endregion

//region Function GetProfileHull
	// returns a polyline of a planeprofile by an iteration of blowup and shrinks
	PLine GetProfileHull(PlaneProfile pp, int bReconstructArcs)
	{ 
		PLine out;
	
	// smoothen the profile
		pp.removeAllOpeningRings();		
		PLine rings[] = pp.allRings();
		if (rings.length()>0)
			out = rings[0];
		
		pp.removeAllRings();
		for (int r=0;r<rings.length();r++) 
		{ 
			PLine& pl = rings[r];
			pl.simplify();
			if (bReconstructArcs)
				pl.reconstructArcs(dEps, 70); 
			pp.joinRing(pl, _kAdd); 
		}//next r

		if (rings.length()>1)
		{ 
			double d = (pp.dX()>pp.dY()?pp.dX():pp.dY()) / 20;
			double merge = d;
			int cnt;
			while (rings.length()>1 && cnt<20)
			{ 
				PlaneProfile ppt = pp;
				ppt.shrink(-merge);
				ppt.shrink(merge);
				
//				if (ppt.coordSys().vecZ().isParallelTo(_ZW))
//				{ 
//					Display dp(4);
//					dp.draw(ppt);					
//				}

				
				rings = ppt.allRings(true, false);
				cnt++;
			}
			if (rings.length()>0)
				out = rings[0];
		}
		else if (rings.length()>0)
			out = rings[0];
		

		return out;
	}//endregion

	//region Function addMidPoints
	// appends points which are not closed to the input points
	// pp: the planeprofile
	void addMidPoints(PlaneProfile pp, Point3d& pts[])
	{ 
		CoordSys cs = pp.coordSys();
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		Point3d pt = pp.ptMid();
		
		for (int xy=0;xy<2;xy++) 
		{ 
			Point3d ptsX[] = pp.intersectPoints(Plane(pt, (xy == 0 ? vecX : vecY)), true, false);
			if (ptsX.length()>2)
			{ 
				ptsX.swap(1, ptsX.length() - 1);
				ptsX.setLength(2);
			}
			for (int i=0;i<ptsX.length();i++) 
			{ 
				int bOk=true;
				for (int j=0;j<pts.length();j++)
				{ 
					if (Vector3d(ptsX[i]-pts[j]).length()<dEps)
					{ 
						bOk = false;
						break;
					}
				}
				if (bOk)
					pts.append(ptsX[i]);
				 
			}//next i 
		}//next xy
	}//End addMidPoints //endregion

//region Function GetGripIndexByName
	// returns the grip index if found in array of grips
	// name: the name of the grip
	int GetGripIndexByName(Grip grips[], String name)
	{ 
		int out = - 1;
		for (int i=0;i<grips.length();i++) 
		{ 
			if (grips[i].name()== name)
			{
				out = i;
				break;
			}	 
		}//next i
		return out;
	}///endregion

//region Function GetTagGrip
	// returns the grip index if found in array of grips
	int GetTagGrip(Grip grips[], Map& mapGrip)
	{ 
		int out = - 1;
		for (int i=0;i<grips.length();i++) 
		{ 
			String name = grips[i].name();
			Map m;
			int bOk = m.setDxContent(name, true);
			if (m.getInt("isTag"))
			{
				out = i;
				mapGrip = m;
				break;
			}	 
		}//next i
		return out;
	}///endregion



	//region Function createGrip
	// creates a new grip
	// vecX, vecY: the coordSys and hide directions
	Grip createGrip(Point3d ptLoc, int shapeType, String name, Vector3d vecX, Vector3d vecY, int color, String toolTip)
	{ 
		Grip grip;
		grip.setPtLoc(ptLoc);
		grip.setName(name);
		grip.setColor(color);
		grip.setShapeType(shapeType);	
		
		grip.setVecX(vecX);
		grip.setVecY(vecY);
		
		grip.addHideDirection(vecX);
		grip.addHideDirection(-vecX);
		grip.addHideDirection(vecY);
		grip.addHideDirection(-vecY);	
		
		grip.setToolTip(toolTip);
		return grip;
	}//End createGrip //endregion
			
	//endregion 

//region Relation Functions
	
	

//region Function RemoveLayerIndices
	// returns
	void RemoveLayerIndices(Map& map)
	{ 
		int n;
		n+=map.removeAt(kLayerIndexPack, true);
		n+=map.removeAt(kLayerSubIndexPack, true);
		n+=map.removeAt(kLayerIndexStack, true);
		n+=map.removeAt(kLayerSubIndexStack, true);
		//reportNotice("\nremoved entries "  + n);
		return;
	}//endregion


	
//region Function ReleaseParent
	// releases the nestingChild info from a parent and resets the _Entity array of the parent
	// returns true if succeeded
	// parent: the parent nesting entity
	// child: the child nesting entity
	int ReleaseParent(TslInst parent, TslInst child)
	{ 
		int out;
		Entity childs[] = parent.entity();
		int n = childs.find(child);
		
		if (n>-1)
		{ 
			child.removeSubMapX(kPackageChild);
			child.removeSubMapX(kTruckChild);
			
			Map mapChild = child.map();
			RemoveLayerIndices(mapChild);
			child.setMap(mapChild);

			childs.removeAt(n);
			Map map = parent.map();
			Map m;
			m.setEntityArray(childs, true, "ent[]", "", "ent");
			map.setMap("RemoteSet", m);
			parent.setMap(map);
			parent.transformBy(Vector3d(0, 0, 0));
			
			//reportNotice("\n   Item.ReleaseParent" + child.handle() + " to be removed from "+ parent.handle()+" new childs set " + parent.entity().length());
			
			out = true;
		}
		return out;
	}//endregion 

//region Function AssignParent
	// assigns the nestingChild to a new parent and sets the _Entity array of the parent
	// returns true if succeeded
	// parent: the parent nesting entity
	// child: the child nesting entity
	int AssignParent(TslInst parent, TslInst child)
	{ 
		int out;
		Entity childs[] = parent.entity();
		int n = childs.find(child);	
		if (n<0)
		{ 
			childs.append(child);
			Map map = parent.map();
			Map m;
			m.setEntityArray(childs, true, "ent[]", "", "ent");
			map.setMap("RemoteSet", m);
			parent.setMap(map);
			parent.transformBy(Vector3d(0, 0, 0));				
			
			//reportNotice("\n   Item.AssignParent: "+ child.handle() + " added as new child to a set of " + parent.entity().length());
			
			out = true;
		}
		return out;
	}//endregion 

	//region Function getParent
	// returns the paent of the given instance by its childRefRelation
	// 
	// t: the instance to get the parent from
	TslInst getParent(TslInst t)
	{ 
		TslInst out;
		//reportNotice("\ngetParent: " + t.scriptName() + " " + t.handle() + " subMapXKeys " +t.subMapXKeys());	
		String key = t.scriptName() == scriptName() ? kPackageChild : kTruckChild;
		Map mapX =t.subMapX(key);
		String parentUID = mapX.getString("ParentHandle");				
		Entity entParent; entParent.setFromHandle(parentUID);
		//reportNotice("\n	key " + key+ " parentUID " + parentUID + " (" + out.bIsValid()+")" + "\n	"+mapX);
		out = (TslInst)entParent;
		return out;
	}//End getParent //endregion

		
		
	//endregion 

//region Element Body Functions
	

//region Function HasZoneGenbeams
	// returns true or false if the specified zone has also genbeams in it
	// zoneIndex: the zoneIndex to be tested
	int HasZoneGenbeams(int zoneIndex, GenBeam gbs[])
	{ 
		int out;
		
		for (int i=0;i<gbs.length();i++) 
		{ 
			if(gbs[i].myZoneIndex()==zoneIndex)
			{ 
				out = true;
				break;
			} 
		}//next i
		
		return out;
	}//endregion

//region Function CollectZones
	// returns zones of the element which have a valid thickness
	ElemZone[] CollectZones(Element el)
	{ 
		ElemZone zones[0]; // make sure they are appended from the outside to the inside
		for (int i=-5;i<0;i++) 
		{ 
			ElemZone zone = el.zone(i);
			if (zone.dH()>dEps)
				zones.append(zone);
		}//next i
		
		for (int i=5; i>=0 ; i--) 
		{ 
			ElemZone zone = el.zone(i);
			if (zone.dH()>dEps)
				zones.append(zone);		
		}//next i
		return zones;
	}//endregion

////region Function CollectValidZones
//	// returns zones of the element which have a valid thickness
//	ElemZone[] CollectValidZones(Element el, GenBeam gbs[], PainterDefinition pd)
//	{ 
//		ElemZone zones[0]; // make sure they are appended from the outside to the inside
//		GenBeam gbs[] = el.genBeam();
//		if (pd.bIsValid())gbs = pd.filterAcceptedEntities(gbs);
//		for (int i=-5;i<0;i++) 
//		{ 
//			ElemZone zone = el.zone(i);
//			if (zone.dH()>dEps && (gbs.length()<1 || HasZoneGenbeams(i, gbs)))
//			{ 
//				zones.append(zone);
//			}	 
//		}//next i
//		
//		for (int i=5; i>=0 ; i--) 
//		{ 
//			ElemZone zone = el.zone(i);
//			if (zone.dH()>dEps && (gbs.length()<1 || HasZoneGenbeams(i, gbs)))
//			{ 
//				zones.append(zone);
//			}		
//		}//next i
//
//
//		
//		return zones;
//	}//endregion

//region Function GetZoneGenBeams
	// returns the genbeams of a zone ignoring very thin and dummies, modifies input genbeams
	GenBeam[] GetZoneGenBeams(ElemZone zone, GenBeam& gbsIn[])
	{ 
		GenBeam gbsOut[0];
		Vector3d vecZ = zone.vecZ();
		int zoneIndex = zone.zoneIndex();
		
		for (int i=gbsIn.length()-1; i>=0 ; i--) 
		{ 
			GenBeam g = gbsIn[i];
			if (g.bIsDummy() || g.dD(vecZ)<U(1))
				gbsIn.removeAt(i);
			else if(g.myZoneIndex()==zoneIndex)
			{ 
				gbsOut.append(g);
				gbsIn.removeAt(i);
			} 
		}//next i		

		return gbsOut;
	}//endregion

////region Function GetZoneProfile
//	// returns
//	PlaneProfile GetZoneProfile(Element el, GenBeam gbs[], ElemZone zone, int shapeType, double blowUp)
//	{
//
//		Vector3d vecZ = zone.vecZ();		
//		Vector3d vecY = el.vecY();
//		Vector3d vecX = vecY.crossProduct(vecZ);
//		Point3d ptOrg = zone.ptOrg();
//		double dH = zone.dH();
//		int zoneIndex = zone.zoneIndex();
//		CoordSys cs(ptOrg, vecX, vecY, vecZ);
//		Plane pn(ptOrg, vecZ);
//		
//		PlaneProfile out(cs);
//		for (int i=0;i<gbs.length();i++) 
//		{ 
//			GenBeam g = gbs[i];
//			int n = g.myZoneIndex();
//			if (n == zoneIndex)
//			{ 
//				Body b = GetGenBeamBody(g, shapeType); 
//				b.vis(i);
//				PlaneProfile pp(cs);
//				pp.unionWith(b.shadowProfile(pn));
//				pp.shrink(-blowUp);
//				pp.vis(i);
//				out.unionWith(pp);				
//			}
//		}//next 	
//		out.shrink(blowUp);
//
//		//{Display dpx(6); dpx.draw(out, _kDrawFilled, 50);}
//		return out;
//	
//	}//endregion

//region Function GetElementGenBeamBodies
	// returns the bodies of the genbeams passed in, might modify gbsIn
	Body[] GetElementGenBeamBodies(GenBeam& gbsIn[], Vector3d vecZ, int shapeType)
	{ 
		Body bodies[0];

		for (int i=gbsIn.length()-1; i>=0 ; i--) 
		{ 
			GenBeam g = gbsIn[i];
			if (g.bIsDummy() || g.dD(vecZ)<U(1))
			{
				gbsIn.removeAt(i);
				continue;
			}

			Body b = GetGenBeamBody(g, shapeType);	//b.vis(abs(g.myZoneIndex()));
			
			if (b.isNull())
			{
				gbsIn.removeAt(i);
				continue;
			}			
			else
				bodies.append(b);
		}//next i		
		bodies.reverse();
		return bodies;
	}//endregion

//region Function FilterBodiesIntersectZone
	// returns
	Body [] FilterBodiesIntersectZone(Element el, ElemZone zone, Body& bodies[])
	{ 
		Body out[0];
		CoordSys cs = el.coordSys();
		Vector3d vecY = cs.vecY();
		Vector3d vecZ = zone.vecZ();
		Vector3d vecX = vecY.crossProduct(vecZ);
		
		double dH = zone.dH();
		if (dH<2*dEps)
		{
			return out;
		}
		int zoneIndex = zone.zoneIndex();
		Point3d pt1 = zone.ptOrg();
		Point3d pt2 = pt1+vecZ*dH;
		Point3d ptm = (pt1 + pt2) * .5;
		Body bdz(ptm, vecX, vecY, vecZ, U(10e4), U(10e4), (dH - 2 * dEps), 0, 0, 0);

		Body bodiesZ[0];
		for (int i=bodies.length()-1; i>=0 ; i--) 
		{ 
			Body& b =bodies[i];
			
			if (!b.hasIntersection(bdz))
			{ 
				continue;
			}
			else
			{
				out.append(b);
				bodies.removeAt(i);
				if (bDebug && zoneIndex==0)
				{
					b.vis(zoneIndex==0?32:abs(zone.zoneIndex()));
				}
			}
			
		}//next i

		return out;
	}//endregion



//region Function GetLowDetailElement
	// returns a simple element body
	Body GetLowDetailElement(Element el, Body bodies[])
	{
		Body bdOut;
		//int tick = getTickCount();
		Vector3d vecY = el.vecY();
		Vector3d vecZ = el.vecZ();
		ElemZone zones[] = CollectZones(el);
		
		PlaneProfile ppEl(el.coordSys());
		Point3d ptsZ[0];
		for (int j=0;j<zones.length();j++) 
		{ 
			int tickZ = getTickCount();
			ElemZone zone = zones[j];
			Vector3d vecZZone = zone.vecZ();
			double dH = zone.dH();
			Body bodiesZ[] = FilterBodiesIntersectZone(el, zone, bodies);
			PlaneProfile ppZone = GetBodiesShadow(bodiesZ, CoordSys(zone.ptOrg(), vecY.crossProduct(vecZZone), vecY, vecZZone), U(5));				
			ppZone.removeAllOpeningRings();
			
			if (ppZone.area()>pow(dEps,2))
			{ 
				ptsZ.append(zone.ptOrg());
				ptsZ.append(zone.ptOrg()+vecZZone*dH);
				
			}
			ppEl.unionWith(ppZone);		
			//reportNotice("\n   element profile elapsed zone: " +zone.zoneIndex() +" "+ (getTickCount()-tickZ)+"ms");
		}
		double merge = el.dBeamWidth()>dEps?el.dBeamWidth():U(10);
		ppEl.shrink(-merge);
		ppEl.shrink(merge);
		
		
		
		
		ptsZ = Line(_Pt0, vecZ).orderPoints(ptsZ, dEps);
		if (ptsZ.length()>1)
		{ 
			double dH = vecZ.dotProduct(ptsZ.last() - ptsZ.first());
			ppEl.transformBy(vecZ * vecZ.dotProduct(ptsZ.first() - el.ptOrg()));
			
			PLine rings[] = ppEl.allRings(true, false);//
			for (int r=0;r<rings.length();r++) 
			{ 
				Body bdi(rings[r], vecZ * dH, 1);
				if (!bdi.isNull())
				{
					bdOut.addPart(bdi);
					//bdi.vis(i);
				}						 
			}//next r					
		}
		
	// append bodies which do not intersect any zone
		for (int i=0;i<bodies.length();i++) 
			bdOut.addPart(bodies[i]);
		
		//reportNotice("\n   GetLowDetailElement elasped " + (getTickCount()-tick)+"ms");
		return bdOut;
	}//endregion




	
//endregion 

//END Functions //endregion

//region JIGS
// Jig Insert
	String kJigInsert = "JigInsert";
	if (_bOnJig && _kExecuteKey==kJigInsert) 
	{
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point		
		Map mapItems = _Map.getMap("Item[]");
		
		CoordSys rot; 
		
	    PlaneProfile pps[0];
	    for (int i=0;i<mapItems.length();i++) 
	    {
	    	Map m = mapItems.getMap(i);
	    	if (m.hasPlaneProfile("pp"))
	    	{
	    		PlaneProfile pp = m.getPlaneProfile("pp");
	    		rot.setToRotation(_Map.getDouble("rotation"), _ZW, pp.ptMid());
	    		pp.transformBy(rot);
	    		pps.append(pp);
	    	}
	    }
	    		
		if (pps.length()>0)
			ptJig.setZ(pps[0].coordSys().ptOrg().Z());

	    
	    Display dp(-1);
	    dp.trueColor(lightblue, 50);
	    
	    Vector3d vec = ptJig - _PtW;
	    for (int i=0;i<pps.length();i++)
	    { 
	    	PlaneProfile pp = pps[i];
	    	
	    	pp.transformBy(vec);	
	    	dp.draw(pp, _kDrawFilled);
	    	dp.draw(pp);
	    }
	    
	    
	    return;
	}
	
//END Jigs //endregion 

//END Part #B //endregion 

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="StackEntity";
	Map mapSetting;

// compose settings file location
	String sFolders[]=getFoldersInFolder(sPath); 
	int bPathFound = _bOnInsert ? sFolders.find(sFolder) >- 1 ? true : makeFolder(sPath + "\\" + sFolder) : false;
	String sFullPath = sPath+"\\"+sFolder+"\\"+sFileName+".xml";

// read a potential mapObject
	MapObject mo(sDictionary ,sFileName);
	if (mo.bIsValid())
	{
		mapSetting=mo.map();
		setDependencyOnDictObject(mo);
	}
	// create a mapObject to make the settings persistent	
	else if ((_bOnInsert || _bOnDebug) && !mo.bIsValid() )
	{
		String sFile=findFile(sFullPath); 
	// if no settings file could be found in company try to find it in the installation path
		if (sFile.length()<1) sFile=findFile(sPathGeneral+sFileName+".xml");	
		if (sFile.length()>0)
		{ 
			mapSetting.readFromXmlFile(sFile);
			mo.dbCreate(mapSetting);			
		}
	}
	// validate version when creating a new instance
	if(_bOnDbCreated)
	{ 
		int nVersion = mapSetting.getInt("GeneralMapObject\\Version");
		String sFile = findFile(sPathGeneral + sFileName + ".xml");		// set default xml path
		if (sFile.length()<1) sFile=findFile(sFullPath);				// set custom xml path if no default found
		Map mapSettingInstall; mapSettingInstall.readFromXmlFile(sFile);	// read the xml from installation directory
		int nVersionInstall = mapSettingInstall.getMap("GeneralMapObject").getInt("Version");		
		if(sFile.length()>0 && nVersion!=nVersionInstall)
			reportNotice(TN("|A different Version of the settings has been found for|") + scriptName()+
			TN("|Current Version| ")+nVersion + "	" + _kPathDwg + TN("|Other Version| ") +nVersionInstall + "	" + sFile);
	}
	
//End Settings//endregion	



//Part B //endregion

//region Part #C Properties onInsert

//region PreRequisites Painters

	//region Painters


	String tPDPanels = T("|Panels|");
	String tPDBeams = T("|Beams|");

// Get or create default painter definition
	String sPainterCollection = "TSL\\Stacking\\";
	String sPainters[0],sContentPainters[0], sAllPainters[] = PainterDefinition().getAllEntryNames().sorted();
	for (int i=0;i<sAllPainters.length();i++) 
	{ 
		if (sAllPainters[i].find(sPainterCollection,0,false)==0)
		{
			PainterDefinition pd(sAllPainters[i]);
			if (!pd.bIsValid()){continue;}
			
		// add painter name	
			String name = sAllPainters[i];
			name = name.right(name.length() - sPainterCollection.length());
			if (sPainters.findNoCase(name,-1)<0)// && name!=tSelectionPainter)
			{ 
				sPainters.append(name);	
				sContentPainters.append(name);					
			}

		}		 
	}//next i
	
// Create Default Painters	
	if (_bOnInsert || _bOnRecalc)
	{ 
		String types[] ={"Beam", "Panel"};
		String names[] ={tPDBeams, tPDPanels};
		String formats[] =
		{
			"@(SolidLength:RL0:PL5;0)_@(SolidHeight:RL0:PL5;0)", 
			"@(SolidHeight:RL0:PL3;0)_@(SolidLength:RL0:PL5;0)_@(SolidWidth:RL0:PL5;0)"
		};
		for (int i=0;i<types.length();i++) 
			createPainter(sPainters, types[i], "", formats[i], sPainterCollection, names[i]);	
	}

	sPainters.sorted();	
	sPainters.insertAt(0, tBySelection);
	
	sContentPainters.sorted();	
	sContentPainters.insertAt(0, tByDefault);
	
	
	//END Painters //endregion
		
//PreRequisites //endregion 

//region Properties	

category = T("|Filter|");
	String sPainterName=T("|Filter|");	
	PropString sPainter(0, sPainters, sPainterName,2);	
	sPainter.setDescription(T("|Defines the painter definition which will be used to filter items|"));
	sPainter.setControlsOtherProperties(true);	
	sPainter.setCategory(category);
	
	String tAscending = T("|Ascending|"), tDescending= T("|Descending|"), sSortings[] ={tDisabledEntry, tAscending, tDescending };
	String sSortingName=T("|Sorting|");	
	PropString sSorting(1,sSortings, sSortingName);	
	sSorting.setDescription(T("|Defines the Sorting|"));
	sSorting.setCategory(category);
	
	String sContentPainterName=T("|Content Filter|");	
	PropString sContentPainter(7, sContentPainters, sContentPainterName);	
	sContentPainter.setDescription(T("|Defines the painter definition which will be used to filter the content of the item.|"));
	sContentPainter.setCategory(category);
	
category = T("|Alignment|");
	String tVertical = T("|Vertical|"), tHorizontal= T("|Horizontal|"), sAlignments[] ={tHorizontal, tVertical };
	String sAlignmentName=T("|Alignment|");	
	PropString sAlignment(2,sAlignments, sAlignmentName);	
	sAlignment.setDescription(T("|Defines the alignment of the stacking item|"));
	sAlignment.setCategory(category);
	sAlignment.setControlsOtherProperties(true);
	if (sAlignments.findNoCase(sAlignment,-1)<0)sAlignment.set(tHorizontal);	

	PropDouble dSpacerHeight(0, U(0), tSpacerHeightName);	
	dSpacerHeight.setDescription(T("|Defines the height of a spacer for the entity|"));
	dSpacerHeight.setCategory(category);

	PropDouble dVerticalSpacerThickness(2, U(0), tVerticalSpacerThicknessName);	
	dVerticalSpacerThickness.setDescription(T("|Defines the thickness of vertical spacers for the entity|") + T(",  |(Vertical alignment only)|"));	
	dVerticalSpacerThickness.setCategory(category);


category = T("|Display|");
	String sFormatName=T("|Format|");	
	PropString sFormat(3, "@(PosNum:D)", sFormatName);	
	sFormat.setDescription(T("|Defines the format of the header display|"));
	sFormat.setCategory(category);
	Map mapAdd;
	if (_bOnInsert)
	{ 
		//mapAdd.setString("Yield", "85%"); // dummy
		sFormat.setDefinesFormatting("TslInst", mapAdd);
	}

	String kResHigh = T("|High Detail|"), kResMedium = T("|Medium Detail|"), kResMediumProf = T("|Medium Profile Detail|"), kResLow = T("|Low Detail|"), sResolutions[] ={ kResLow, kResMedium, kResMediumProf, kResHigh};
	String sResolutionName=T("|Resolution|");	
	PropString sResolution(4, sResolutions, sResolutionName,1);	
	sResolution.setDescription(T("|Defines the Resolution|"));
	sResolution.setCategory(category);
	if (sResolutions.findNoCase(sResolution ,- 1) < 0) sResolution.set(kResMedium);

	String sProjectionModeName=T("|Projection Display|");	

	PropString sProjectionMode(6, sProjectionModes, sProjectionModeName);	
	sProjectionMode.setDescription(T("|Defines the Projection Mode|"));
	sProjectionMode.setCategory(category);
	if (sProjectionModes.findNoCase(sProjectionMode ,- 1) < 0)sProjectionMode.set(tPMNone);

	String sDimStyles[] = _DimStyles, sDimStylesUI[] = GetGroupedDimstyles(0, sDimStyles); // type: 0 = linear, 1 = undefined, 2 = angular, 3= diameter, 4 = Radial, 6 = coordinates, 7= leader and tolerances
	String sDimStyleName=T("|Dimstyle|");	
	PropString sDimStyleUI(5, sDimStylesUI, sDimStyleName);	
	sDimStyleUI.setDescription(T("|Defines the dimension style.|"));
	sDimStyleUI.setCategory(category);
	if (sDimStylesUI.length()>0 && sDimStylesUI.findNoCase(sDimStyleUI ,- 1) < 0)sDimStyleUI.set(sDimStylesUI.first());	
	String sDimStyle = sDimStyles[sDimStylesUI.findNoCase(sDimStyleUI, 0)];

	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(1, U(0), sTextHeightName);	
	dTextHeight.setDescription(T("|Defines the text height, 0 = byDimstyle|"));
	dTextHeight.setCategory(category);
	double textHeight;
	if (dTextHeight>0)
		textHeight=dTextHeight;
	else
	{
		Display dp(0);
		dp.dimStyle(sDimStyle); 
		textHeight=dp.textHeightForStyle("G", sDimStyle);
	}


//region Function setReadOnlyFlagOfProperties
	// sets the readOnlyFlag
	void setReadOnlyFlagOfProperties()
	{ 	
		sPainter.setReadOnly(_bOnInsert || bDebug ? false : _kHidden);
		sSorting.setReadOnly(sPainter!=tBySelection || bDebug ? false : _kHidden);
		dVerticalSpacerThickness.setReadOnly((bDebug || sAlignment == tVertical) ? false : _kHidden);

		return;
	}//endregion	



//End Properties//endregion 

//region OnInsert #1
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		if (_kExecuteKey.length()>0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey,-1)>-1)
			setPropValuesFromCatalog(_kExecuteKey);						
	// standard dialog	
		else	
		{
			setPropValuesFromCatalog(tLastInserted);
			setReadOnlyFlagOfProperties();
			while (showDialog("---") == _kUpdate) // _kUpdate means a controlling property changed.	
			{ 
				setReadOnlyFlagOfProperties(); // need to set hidden state
			}			
			setReadOnlyFlagOfProperties();
		}

	// Painter
		String prompt = T("|Select entities|");
		PainterDefinition pd(sPainterCollection+sPainter);
		if (pd.bIsValid())
			prompt = T("|Select entities of type| ")+ T("|"+pd.type()+"|");
		
	// prompt for entities
		PrEntity ssE(T("|Select entities|"), Entity());
		ssE.allowNested(true);
		if (ssE.go())
			_Entity.append(ssE.set());
			
	// allow master or childpanels to add panels to the selection set
		for (int i=_Entity.length()-1; i>=0 ; i--) 
		{ 
			Entity e = _Entity[i];
			MasterPanel master = (MasterPanel)e;
			ChildPanel childs[0],child= (ChildPanel)e;
			
			if (master.bIsValid())
			{
				childs = master.nestedChildPanels();
				_Entity.removeAt(i);
			}
			else if (child.bIsValid())
			{
				childs.append(child);
				_Entity.removeAt(i);
			}
			for (int j=0;j<childs.length();j++) 
			{ 
				Sip sip = childs[j].sipEntity(); 
				if (_Entity.find(sip)<0)
					_Entity.append(sip);
			}//next j			
		}//next i
		

	// filter by painter
		if (pd.bIsValid())
		{
			_Entity= pd.filterAcceptedEntities(_Entity);
			if (_Entity.length()<1)
			{ 
				reportNotice("\n" + sPainterCollection + sPainter + T(" |does not return any entity.|") + TN("|The tool cannot be inserted.|"));
				eraseInstance();
				return;
			}
		}
	// refuse non assembly tsls and non solids
		else
		{ 
			String sExcludeScripts[] ={ scriptName()};
			sExcludeScripts = sAssemblyScripts;
			sExcludeScripts.append(sParentScripts);
			
		// Remove entities of sset which refer to an element of sset
			Element elements[0];
			for (int i=_Entity.length()-1; i>=0 ; i--) 			
			{ 
				Element el = (Element)_Entity[i];
				if (el.bIsValid())
					elements.append(el);
			}
			
			for (int i=_Entity.length()-1; i>=0 ; i--) 			
			{ 
				Element el = (Element)_Entity[i];
				if (el.bIsValid()){ continue;}
				
				Element parent = _Entity[i].element();
				if (parent.bIsValid() && elements.find(parent)>-1)
					_Entity.removeAt(i);
			}			

			for (int i=_Entity.length()-1; i>=0 ; i--) 
			{ 
				TslInst t = (TslInst)_Entity[i];
				if (t.bIsValid() && sExcludeScripts.findNoCase(t.scriptName(),-1)<0)
					_Entity.removeAt(i);
				else if (_Entity[i].realBody(_XW+_YW+_ZW).isNull() && !_Entity[i].bIsKindOf(Element()))
					_Entity.removeAt(i);
			}
		}

	//region refuse instances which have a stacking clone attached
		for (int i=_Entity.length()-1; i>=0 ; i--) 
		{ 
			TslInst tsls[] = _Entity[i].tslInstAttached();
			for (int j= 0; j < tsls.length(); j++)
			{ 
				TslInst t = tsls[j];
				if (scriptName() == t.scriptName() && t!=_ThisInst)
				{ 
					
				// HSB-21161 toggle visibility if orphaned				
					Map mapX =t.subMapX(kPackageChild);
					String parentUID = mapX.getString("ParentHandle");
					Entity entParent; entParent.setFromHandle(parentUID);
					int bHasParent = entParent.bIsValid();
					if (!bHasParent)
					{ 
						mapX =t.subMapX(kTruckChild);
						parentUID = mapX.getString("ParentHandle");
						entParent; entParent.setFromHandle(parentUID);
						bHasParent = entParent.bIsValid();
					}	
					if (!bHasParent && !t.isVisible())
					{
						reportMessage("\n" + _Entity[i].handle() + T(" |has already a stacking clone attached, the item is now visible|"));
						t.setIsVisible(true);					
					}
					else
						reportMessage("\n" + _Entity[i].handle() + T(" |has already a stacking clone attached|"));
					_Entity.removeAt(i);
					continue;	
				}
			}			
		}//next i	
	//endregion 	

		mode = 1;
		_Map.setInt("mode", mode);// distribution mode

	}	
	setReadOnlyFlagOfProperties();
//OnInsert  #1//endregion 

//region All modes
	int nShapeType = 2; //0 = realBody, 1 = envelope(0, 1), 2 = envelope(1, 1), 3 = envelope;
	if (sResolution == kResHigh)nShapeType = 0;
	else if (sResolution == kResLow)nShapeType = 3;
	else if (sResolution == kResMediumProf)nShapeType = 1;
	
	int bIsVertical = sAlignment==tVertical;


	dpWhite.trueColor(rgb(255, 255, 254), 60);
	dpWhite.addHideDirection(_XW);
	dpWhite.addHideDirection(-_XW);
	dpWhite.addHideDirection(_YW);
	dpWhite.addHideDirection(-_YW);
	
	dpText.addHideDirection(_XW);
	dpText.addHideDirection(-_XW);
	dpText.addHideDirection(_YW);
	dpText.addHideDirection(-_YW);
	dpText.trueColor(rgb(0,0,0));
	dpText.dimStyle(sDimStyle);
	dpText.textHeight(textHeight);
	
	dpJig.trueColor(lightblue, 80);
	dpOverlay.trueColor(lightblue);
	dpRed.trueColor(red);

	// ContentFilter //#cf
	PainterDefinition pdContent; 	if (sContentPainter!=tByDefault) pdContent = PainterDefinition(sPainterCollection+sContentPainter);

//endregion 


//region Grip
	int indexOfMovedGrip = Grip().indexOfMovedGrip(_Grip);
	//if (bDebug)indexOfMovedGrip = 3; // testing grip map content
	Grip grip;
	int bDrag = _bOnGripPointDrag;// && indexOfMovedGrip >- 1 && _kExecuteKey=="_Grip";
	int bOnDragEnd = !_bOnGripPointDrag && indexOfMovedGrip >- 1;	
	int bDragTag, bShapeGrip, bGipLocX,bGipLocY,bGipLocZ;
	Vector3d vecApplied;
	TslInst stackByGrip, packByGrip;
	Map mapGrip;
	if (indexOfMovedGrip>-1)
	{ 
		grip = _Grip[indexOfMovedGrip];
		String name = grip.name();
		
		int bOk = mapGrip.setDxContent(name, true);
		if(bOk && mapGrip.getInt("isTag"))
		{ 
			bDragTag = true;
		}
		else if(bOk && mapGrip.getInt("isLocation"))
		{ 
			{ Entity e = mapGrip.getEntity("pack");  packByGrip =(TslInst)e;}
			{ Entity e = mapGrip.getEntity("stack"); stackByGrip =(TslInst)e;}
			
			String dirKey = mapGrip.getString("dirKey");
			bGipLocX = dirKey==kDirKeys[0];
			bGipLocY = dirKey==kDirKeys[1];
			bGipLocZ = dirKey==kDirKeys[2];// 
			bShapeGrip= bGipLocX || bGipLocY || bGipLocZ;	
			
			if (bGipLocZ && !vecZView.isParallelTo(_ZW))// unlock transformation in model view to current Z
				bGipLocZ=false; 
	
			vecApplied = grip.vecOffsetApplied();	
			if (bGipLocX)vecApplied -= _XW * vecApplied.dotProduct(_XW);
			if (bGipLocY)vecApplied -= _YW * vecApplied.dotProduct(_YW);
			if (bGipLocZ)vecApplied -= _ZW * vecApplied.dotProduct(_ZW);
			//reportNotice("\n" + scriptName() + " Grip " + indexOfMovedGrip + " " + dirKey + " pack " + packByGrip.bIsValid()+ " stack " + stackByGrip.bIsValid());	
		}

	}
	
//region Dragging
	//onDrag a location grip
	if ((bDrag || bOnDragEnd) && bShapeGrip)
	{ 	
		PLine shape = mapGrip.getPLine("shape");		
		PLine shape2 = mapGrip.getPLine("shape2");
		Body bdSimple = GetSimplePLineBody(shape, shape2);
		// HSB-22649 consider spacer height as solid for dragging to detect the solids below 
		// HSB-23426 do not consider in any sectional view
		if (dSpacerHeight>dEps && !shape.coordSys().vecZ().isPerpendicularTo(_ZW))
		{ 
			Body bd(shape, _ZW * dSpacerHeight ,- 1);
			bdSimple.addPart(bd);
		}
		
	// the snap pp of the dragged item
		PlaneProfile ppSnap(shape);
		ppSnap.transformBy(vecApplied);			
		
	// flag current parent assignment
		int bHasPack = packByGrip.bIsValid();//mapGrip.getInt("hasPack");	
		int bHasStack =stackByGrip.bIsValid();// mapGrip.getInt("hasStack");	

		Body bdMax;
		TslInst tslNewParent= FindIntersectingParentBySolid(bdSimple, bdMax, vecApplied, "");	
		if (bDebug)reportNotice("\nparent/pack/stack found " + tslNewParent.bIsValid() +"/"+ bHasPack +"/"+ bHasStack);	

	// Draw Drag Graphics
		if (bDrag)
		{ 
			DrawPLine(shape, vecApplied, lightblue, 0,80,dp);
			if (!bdSimple.isNull())
				DrawBodies(bdSimple.decomposeIntoLumps(), vecApplied, lightblue, 0, dpJig);	
			else
				DrawPLine(shape2, vecApplied, nColorItem, 0,80,dp);
			
			if (tslNewParent.bIsValid() && !bdMax.isNull())
			{
				DrawBodies(bdMax.decomposeIntoLumps(), Vector3d(), darkyellow, 0, dpJig);	
				Vector3d vecZS = shape.coordSys().vecZ();
				Point3d pts[] = bdMax.extremeVertices(vecZS);
				if (pts.length()>0)
				{
					PlaneProfile ppMax = bdMax.shadowProfile(Plane(pts.first(), vecZS));
					DrawSnap(ppMax, dViewHeight/300, Vector3d(0,0,0), darkyellow, 100,tslNewParent, dpPlan);
					DrawSnap(ppMax, dViewHeight/300, Vector3d(0,0,0), darkyellow, 90,tslNewParent, dpModel);
				}
			}		
	//		reportNotice("\n" + scriptName() + " " + bOnDragEnd);
	//		dp.draw(scriptName() + " " + bOnDragEnd, grip.ptLoc(), _XW, _YW, 1, 0);	
			return;
		}
	// Reassignment
		else if (bOnDragEnd)
		{ 
			//reportNotice("\nbOnDragEnd new is valid " + tslNewParent.bIsValid());
			_Pt0.transformBy(vecApplied);

			
			TslInst tslParent = bHasPack ? packByGrip : stackByGrip;
			
			if ((!tslParent.bIsValid()) || (bHasPack && tslNewParent!=packByGrip) || (bHasStack && tslNewParent!=stackByGrip) )
			{ 
			// release current parent if different
				//reportNotice("\ntslParent " + tslParent.bIsValid() + " tslNewParent " + tslNewParent.bIsValid());
				if (tslParent.bIsValid() && tslParent != tslNewParent)
				{ 
					int bOk = ReleaseParent(tslParent, _ThisInst);	
//					if (bOk && _ThisInst.color()>0)
//						_ThisInst.setColor(0);
					//if(bDebug)reportNotice("\nrelease " + bOk);
				}	
			// write to new parent
				if (tslNewParent.bIsValid() && tslParent != tslNewParent)// (!tslParent.bIsValid() || tslParent != tslNewParent))
				{ 
					int bOk = AssignParent(tslNewParent, _ThisInst );	
					//if(bDebug)reportNotice("\nnew assign " + bOk);	
					
					pushCommandOnCommandStack("_HSB_Recalc");
 					pushCommandOnCommandStack("(handent \""+_ThisInst.handle()+"\")");					
				}				
			}
			else
			{ 
				RemoveLayerIndices(_Map);
			}
//			setExecutionLoops(2);
//			return;
		}
		
	}
	else if (bDragTag && !bOnDragEnd)
	{
		String text = mapGrip.getString("text");
		DrawTag(text, grip.ptLoc(), sDimStyle, textHeight, false);
		return;
	}
//endregion 	


//endregion 

//region Distribution Mode


//region Function CollectJigArgs
	// composes the mapArgs of the jig
	Map CollectJigArgs(Entity& ents[], int bIsVertical)
	{ 
		Map mapArgs, mapItems;
		CoordSys cs();

		Vector3d vecYOrder = bIsVertical ? _YW :- _YW;

	//region Create flattened distribution
		double dRowOffset;// = U(200);	
		double dColOffset;// = U(200);	
		double dMaxRowHeight, dMaxRowLength = U(14000);
		
		Point3d ptX = _PtW;
		Point3d ptRow = ptX;	//ptRow.vis(7);
		for (int i = 0; i < ents.length(); i++)
		{
			Entity& e = ents[i];
			GenBeam g = (GenBeam)e;
			TslInst t = (TslInst)e;
			Element el = (Element)e;
			ElementRoof elRoof = (ElementRoof)e;
			ElementWall elw= (ElementWall)e;
			MetalPartCollectionEnt ce= (MetalPartCollectionEnt)e;

			//double dX, dY, dZ;
			Vector3d vecX, vecY, vecZ;
			Point3d ptOrg;
			
			Body bd;
			if (g.bIsValid())
			{
				vecX = g.vecX();
				vecY = g.vecY();
				vecZ = g.vecZ();
				ptOrg = g.ptCenSolid();	
				
				bd = g.envelopeBody(true, true);
			}				
			else if (t.bIsValid() && sAssemblyScripts.findNoCase(t.scriptName(),-1)>-1)
			{ 
				CoordSys cst = t.coordSys();
				vecX = cst.vecX();
				vecY = cst.vecY();
				vecZ = cst.vecZ();
				ptOrg = cst.ptOrg();
				
				Body bodies[] = GetTslChildBodies(t, 1, pdContent);
				for (int i=0;i<bodies.length();i++) 
					bd.combine(bodies[i]);	
			}
			else if (el.bIsValid())
			{
				vecX = el.vecX();
				vecY = el.vecY();
				vecZ = el.vecZ();
				ptOrg = el.ptOrg();	
				GenBeam gbs[] = el.genBeam();
				if (pdContent.bIsValid())gbs = pdContent.filterAcceptedEntities(gbs);
				
				
				LineSeg seg = el.segmentMinMax();
				if (seg.length()<dEps)
				{ 
					reportNotice("\n" + T("|Element|") + el.number() + T(" |has mo solid represenation and will be refused.|"));
					continue;
				}
				
				Body bde;
				if (elw.bIsValid() && gbs.length()<1)
				{
					bde = GetWallBody(elw, nShapeType);//0 = realBody, 1 = envelope(0, 1), 2 = envelope(1, 1), 3 = envelope;
				}
				else
				{
					bde = GetMediumElementBody(el, ptOrg);
				}
				bd = bde;
				ptOrg = GetElementOrg(el.coordSys(), bd);	//ptOrg.vis(2);
				if(bDebug)bd.vis(4);
			}							
			else if (ce.bIsValid())
			{ 
				CoordSys cst = ce.coordSys();
				Quader qdr = ce.bodyExtents();
				vecX = cst.vecX();
				vecY = cst.vecY();
				vecZ = cst.vecZ();	
				ptOrg = qdr.pointAt(0,0,0);

//EntPLine epl;
//epl.dbCreate(PLine(_PtW, ptOrg,qdr.pointAt(0,0,0)));
//



				bd = GetMetalPartBody(ce, 3, pdContent); 		// 3 = keep it very simple
			}
			
			Vector3d vecXM = vecX;
			Vector3d vecYM = vecY;
			Vector3d vecZM = vecZ;		
			
			double dX = bd.lengthInDirection(vecX);
			double dY = bd.lengthInDirection(vecY);
			double dZ = bd.lengthInDirection(vecZ);		
			double dXM=dX;
			double dYM=dY;
			double dZM=dZ;
			
			
			if (!el.bIsValid() && !ce.bIsValid())// HSB-22467   //
			{ 
				if (dX<dY)
				{ 
					if (dY<dZ)
					{ 
						dXM = dZ;		dYM = dX;		dZM = dY; 
						vecXM = vecZ;	vecYM = vecX;					
					}
					else
					{ 
						dXM = dY;		dYM = dX;		dZM = dZ;  
						vecXM = vecY;	vecYM = -vecX;				
					}
				}
				else if (dX<dZ)
				{ 
					dXM = dZ;		dYM = dX;		dZM = dY;  
					vecXM = vecZ;	vecYM = vecX;				
				}	
				vecZM = vecXM.crossProduct(vecYM);				
			}

			
			if (bIsVertical)
			{ 
				vecZM = vecYM;
				vecYM = vecXM.crossProduct(-vecZM);
				double d = dYM;
				dYM = dZM;
				dZM = d;	
			}			

			ptX += _XW * (.5* dXM);
			if (_XW.dotProduct(ptX-_PtW)+.5*dXM>=dMaxRowLength)
			{ 
				ptX += vecYOrder * (dMaxRowHeight + dRowOffset);
				ptRow += vecYOrder * (dMaxRowHeight + dRowOffset);	//ptRow.vis(2);
				ptX.transformBy(_XW * _XW.dotProduct(_PtW - ptX));
				ptX += _XW * (.5* dXM);
				
				dMaxRowHeight = 0;
			}
			ptX += vecYOrder * (vecYOrder.dotProduct(ptRow-ptX)+.5 * dYM);

			//ptX.vis(i);

			CoordSys ms2ps, ps2ms;
			ms2ps.setToAlignCoordSys(ptOrg, vecXM, vecYM, vecZM, ptX, _XW, _YW, _ZW); //HSB-22000 alignment corrected if current UCS does not match WCS
			bd.transformBy(ms2ps);
			//bd.vis(i);
			PlaneProfile pp(cs);
			pp.unionWith(bd.shadowProfile(Plane(_Pt0, _ZW)));
			

			Map m;
			m.setPlaneProfile("pp", pp);
			m.setEntity("ent", e);
			m.setPoint3d("pt", pp.ptMid());
			mapItems.appendMap("Item", m);

			if(bDebug)bd.vis(i%5+1);
			
			ptX += _XW * (.5* dXM + dColOffset);				
			dMaxRowHeight = dYM > dMaxRowHeight ? dYM : dMaxRowHeight;			
	
		}
		
		mapArgs.setMap("Item[]", mapItems);

		return mapArgs;
	}//endregion


	//bDebug = mode == 1;
	Map mapArgs, mapItems;
	if (mode==1)
	{ 
		//bDebug = true;
		int bIsVertical = sAlignment==tVertical;
		
		Vector3d vecYOrder = bIsVertical ? _YW :- _YW;
		
		
	//Painter based filtering and sorting
		PainterDefinition pd(sPainterCollection+sPainter);
		int nGroupIndices[_Entity.length()]; // indicating to which group the entity belongs to
		if (pd.bIsValid() && _Entity.length()>1)
		{
			_Entity= pd.filterAcceptedEntities(_Entity);
			nGroupIndices.setLength(_Entity.length());
			String ftr = pd.format();
			
		//region Collect tags based on given format
			String tags[0];
			if (ftr.length()>0)
				for (int i = 0; i < _Entity.length(); i++)
				{
					Entity e = _Entity[i];
					String tag= e.formatObject(ftr);
					tags.append(tag);
				}
	
		// order ascending or descending
			int bAscending = sSorting == tAscending;
			int bDescending = sSorting == tDescending;
			for (int i=0;i<tags.length();i++) 
				for (int j=0;j<tags.length()-1;j++) 
					if ((bAscending && tags[j]>tags[j+1]) || (bDescending && tags[j]<tags[j+1]))
					{
						_Entity.swap(j, j + 1);
						tags.swap(j, j + 1);
					}
	
		// Collect group indices
			int index;
			for (int i=0;i<tags.length();i++) 
			{ 
				if (i>0 && tags[i]!=tags[i-1])
				{ 
					index++;
				}
				nGroupIndices[i] = index;
			}
		//endregion			

		}
		if(_Entity.length()<1)
		{ 
			reportMessage("\n" + scriptName() + ": " +T("|no reference found|"));	
			eraseInstance();
			return;
		}



		mapArgs = CollectJigArgs(_Entity, bIsVertical);

		
		if (bDebug)return;
	//endregion 
	}
//endregion 


//region OnInsert #2
	if(_bOnInsert)
	{ 

	//region Show Jig
		String prompt1 = T("|Pick insertion point|");
		String prompt2 = T(" |["+(bIsVertical?"Horizontal":"Vertical")+"/Rotate90°]|");//HSB-22000 insert jig supports vertical/horizontal toggle
		
		
		PrPoint ssP(prompt1+prompt2);
		double dRotation;
	    int nGoJig = -1;
	    while (nGoJig != _kOk && nGoJig != _kNone)
	    {
	        nGoJig = ssP.goJig(kJigInsert, mapArgs); 
	        if (bDebug)reportMessage("\ngoJig returned: " + nGoJig);
	        
	        if (nGoJig == _kOk)
	        {
	            _Pt0 = ssP.value(); //retrieve the selected point
	        }
	        else if (nGoJig == _kKeyWord)
	        { 
	            if (ssP.keywordIndex() == 0)
	            {
	            	bIsVertical =! bIsVertical;
	            	mapArgs = CollectJigArgs(_Entity, bIsVertical);
	            	prompt2 = T(" |["+(bIsVertical?"Horizontal":"Vertical")+"/Rotate90°]|");;
	            	ssP = PrPoint(prompt1 + prompt2);
	            	sAlignment.set((bIsVertical ? tVertical : tHorizontal));
	            }
	            else if (ssP.keywordIndex() == 1)
	            {
	            	dRotation += 90;
	            	mapArgs.setDouble("rotation", dRotation);
	            }	            

	        }
	        else if (nGoJig == _kCancel)
	        { 
	            eraseInstance(); // do not insert this instance
	            return; 
	        }
	    }			
	//End Show Jig//endregion 
		
		
	// create TSL
		TslInst tslNew;
		GenBeam gbsTsl[] = {};					
		int nProps[]={};
		double dProps[]={dSpacerHeight,dTextHeight, dVerticalSpacerThickness};				
		String sProps[]={sPainter,sSorting,sAlignment,sFormat,sResolution, sDimStyleUI,sProjectionMode,sContentPainter};
		Map mapTsl;	

		Vector3d vec = _Pt0- _PtW;
		mapItems = mapArgs.getMap("Item[]");
	    for (int i=0;i<mapItems.length();i++)
	    { 
	    	
	    	Map m = mapItems.getMap(i);
	    	Entity e = m.getEntity("ent");
	    	Point3d pt = m.getPoint3d("pt");
	    	
	    	//reportNotice("\ncreating item of " + e.typeDxfName());
	    	pt += vec;
	    	if (e.bIsValid() && !bDebug)
	    	{ 
	    		Entity entsTsl[] = {e};
	    		Point3d ptsTsl[] = {pt};
	    		tslNew.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
	    		
	    		if (tslNew.bIsValid())
	    		{
	    			tslNew.setColor(0);
	    			tslNew.recalcNow();
	    		}
	    		//if (tslNew.bIsValid())reportNotice(" ok" );
	    	}
	    }

		if (!bDebug)
			eraseInstance();
		return;		
	}
//OnInsert  #2//endregion



//End Part #C //endregion

//region Part #D

//region Standards
	//reportNotice("\n" + _ThisInst.formatObject("@(ScriptName) @(Handle) starting..."));
	if (_Entity.length()<1)
	{ 
		reportNotice("\n" + T("|Invalid selection set.|") + T(" |The tool cannot be inserted.|"));
		eraseInstance();
		return;
	}

	Entity& entDefine = _Entity[0];	
	setDependencyOnEntity(entDefine);	
	addRecalcTrigger(_kGripPointDrag, "_Grip");	
	_ThisInst.setAllowGripAtPt0(false);

//region Store ThisInst in _Map to enable debugging with submapx and fastenerGuideLines until HSB-22564 is implemented
	TslInst this = _ThisInst;
	if (bDebug && _Map.hasEntity("thisInst"))
	{
		Entity ent = _Map.getEntity("thisInst");	
		this = (TslInst)ent;
	}
	else if (_bOnDbCreated || !_Map.hasEntity("thisInst"))
		_Map.setEntity("thisInst", this);
	//endregion


	mapAdd.copyMembersFrom(_Map); // copy submapx keys for format provider
	Map mapXStackData;
	
	// check for duplictates
	if (!_bOnGripPointDrag && !bDebug && hasDuplicate(entDefine, this, ""))
	{ 
		reportMessage("\n" + T("|purging duplicate linked to| ") + entDefine.typeDxfName() + " " + entDefine.handle());
		eraseInstance();
		return;		
	}



	int bIsPanel, bIsSheet;


	Body bd, bdLowModel, bdModel, bdChilds[0];	
	
	Beam bm = (Beam)entDefine;
	Sheet sh = (Sheet)entDefine;
	Sip pa = (Sip)entDefine;
	GenBeam gbs[0], gb = (GenBeam)entDefine;
	TslInst tsl = (TslInst)entDefine;
	Element el = (Element)entDefine;
	MetalPartCollectionEnt ce = (MetalPartCollectionEnt)entDefine;
	CoordSys csDef();	

	String sRefEntityType;
	
	// content filter should not be accessible for a defining genbeam
	if (gb.bIsValid())
	{ 
		sContentPainter.set(tByDefault);
		sContentPainter.setReadOnly(bDebug ? false : _kHidden);
	}


	Vector3d vecX, vecY, vecZ;
	if (pa.bIsValid())
	{ 
		sRefEntityType = kPanel;
		csDef = gb.coordSys();
		csDef = CoordSys(pa.ptCen(), csDef.vecX(), csDef.vecY(), csDef.vecZ());	
		vecX = csDef.vecX();
		vecY = csDef.vecY();
		vecZ = csDef.vecZ();	
		
		Element el = pa.element();
		
	// correct coordSys if element dependent //HSB-23165
		if (el.bIsValid())
		{
			vecX = el.vecX();			
			vecY = el.vecY();
			vecZ = el.vecZ();
			csDef = CoordSys(pa.ptCen(), vecX, vecY, vecZ);
		}

		csDef.vis(3);
		bd = GetGenBeamBody(gb, nShapeType);
		nColorItem = 150;

	}		
	else if (gb.bIsValid())
	{ 
		sRefEntityType = bm.bIsValid()?kBeam:kSheet;

		csDef = gb.coordSys();	//csDef.vis(3);
		vecX = csDef.vecX();
		vecY = csDef.vecY();
		vecZ = csDef.vecZ();		

		bd = GetGenBeamBody(gb, nShapeType);
		nColorItem = gb.color();
	}
	else if (tsl.bIsValid())
	{ 
		sRefEntityType = kTslInst;
		csDef = tsl.coordSys();
		vecX = csDef.vecX();
		vecY = csDef.vecY();
		vecZ = csDef.vecZ();		
		
		nColorItem = tsl.color();
		Body _bodies[] = GetTslChildBodies(tsl, nShapeType, pdContent);
		bdChilds = _bodies;
	}
	else if (el.bIsValid())
	{ 
		sRefEntityType =kElement;
		//0 = realBody, 1 = envelope(0, 1), 2 = envelope(1, 1), 3 = envelope;
		// use envelopeWithCuts as override to cope with gables
		int shapeType = nShapeType==0 || nShapeType==2  ? 2 : 1;
		double merge = el.dBeamWidth();
		
		csDef = el.coordSys();
		vecX = csDef.vecX();
		vecY = csDef.vecY();
		vecZ = csDef.vecZ();
		Point3d ptOrg = csDef.ptOrg();		
	
	// Get Element Content
		gbs= el.genBeam();
		if (pdContent.bIsValid())gbs = pdContent.filterAcceptedEntities(gbs);
		
		Body bodies[0];
		bodies = GetElementGenBeamBodies(gbs, vecZ, shapeType);//0 = realBody, 1 = envelope(0, 1), 2 = envelope(1, 1), 3 = envelope;
		
		// append metalparts HSB-23088
		Entity entMetalParts[] = el.elementGroup().collectEntities(true, MetalPartCollectionEnt(), _kModelSpace);
		if (pdContent.bIsValid())entMetalParts = pdContent.filterAcceptedEntities(entMetalParts);
		for (int i=0;i<entMetalParts.length();i++) 
		{ 
			MetalPartCollectionEnt ce = (MetalPartCollectionEnt)entMetalParts[i];
			Body bd = GetMetalPartBody(ce, shapeType, pdContent);
			if (!bd.isNull())
				bodies.append(bd);
		}//next i

		//region Low
		//int tick = getTickCount();
		//reportNotice("\n" + _ThisInst.formatObject("@(Scriptname) @(Handle): ") + " collecting in solid mode " + nShapeType);
		
		if (!_bOnDbCreated && !_bOnRecalc && _Map.hasBody("Cache") && _kNameLastChangedProp!=sResolutionName)
		{
			bd = _Map.getBody("Cache");
		}
		else if (nShapeType == 3)
		{ 
			//reportNotice("\n" + _ThisInst.handle() + " collecting low solid");
 			bd = GetLowDetailElement(el, bodies);
		
		}//endregion 

		//region Medium or Medium Profiled
		else if (nShapeType == 1 ||nShapeType == 2)
		{
			//reportNotice("\n" + _ThisInst.handle() + " collecting Medium solid");
			PlaneProfile ppOpenings(csDef);
			Opening openings[] = el.opening();
			for (int i=0;i<openings.length();i++) 
				ppOpenings.joinRing(openings[i].plShape(), _kAdd); 			
			
			
			ElemZone zones[] = CollectZones(el);
			for (int j=0;j<zones.length();j++) 
			{ 
				ElemZone zone = zones[j];
				Vector3d vecZZone = zone.vecZ();
				Plane pnZone(zone.ptOrg(), vecZZone);
				double dH = zone.dH();
				Body bodiesZ[] = FilterBodiesIntersectZone(el, zone, bodies);
				PlaneProfile ppZone = GetBodiesShadow(bodiesZ, CoordSys(zone.ptOrg(), vecY.crossProduct(vecZZone), vecY, vecZZone), U(5));				
				//ppZone.removeAllOpeningRings();

				Body bdZone, bdZoneO;
				PLine rings[] = ppZone.allRings(true, false);
				for (int r=0;r<rings.length();r++) 
				{ 
					Body bdi(rings[r], vecZ * dH, 1);
					if (!bdi.isNull())
					{
						bdZone.addPart(bdi);
						//bdi.vis(i);
					}						 
				}//next r

				rings = ppOpenings.allRings(true, false);
				
				for (int r=0;r<rings.length();r++) 
				{ 
					Body bdi(rings[r], vecZZone * U(10e4), 0);
					if (!bdi.isNull())
					{
						bdi.vis(r);
						bdZone.subPart(bdi);
					}								 
				}//next r
//
				bd.addPart(bdZone);
			}
			
		// append bodies which do not intersect any zone
			for (int i=0;i<bodies.length();i++) 
				bd.addPart(bodies[i]); 


			PlaneProfile pps[] = GetCoordinateProfiles(el.coordSys(), bd);
			if (pps.length()<3)
			{ 
				reportNotice("\n" +el.number() +  T("|Element content too complex, falling back to| ") + kResLow);
				sResolution.set(kResLow);
				bodies = GetElementGenBeamBodies(gbs, vecZ, shapeType);
				bd = GetLowDetailElement(el, bodies);
				pps = GetCoordinateProfiles(el.coordSys(), bd);
			}	

		//  Medium
			if(nShapeType == 2 && pps.length()>2)
				bd = GetProfilesSimpleBody(el.coordSys(), pps);
			
		}//endregion 
		
		//region High Detail
		else
		{ 
			//reportNotice("\n" + _ThisInst.handle() + " collecting high solid");
			Point3d ptsZ[0];
			PlaneProfile ppShadows[0];
			double dThicks[0];
			for (int i=0;i<bodies.length();i++) 
			{
				Body b = bodies[i];	//b.vis(i%6);			
				Point3d pts[] = b.extremeVertices(vecZ);
				Plane pn(pts.first(), vecZ);
				PlaneProfile pp = b.shadowProfile(pn);
				ppShadows.append(pp);
				dThicks.append(b.lengthInDirection(vecZ));
				ptsZ.append(pts); 
			}
	
	
		// order ascending
			for (int i=0;i<ppShadows.length();i++) 
				for (int j=0;j<ppShadows.length()-1;j++) 
					if (dThicks[j]>dThicks[j+1])
					{
						dThicks.swap(j, j + 1);
						ppShadows.swap(j, j + 1);
						bodies.swap(j, j + 1);
					}
	
	
		// reorder alternating
			ReorderAlternatingPoints(ptsZ, vecZ);
	
			PlaneProfile ppCoverA(CoordSys((ptsZ.length()>0?ptsZ[0]:el.ptOrg()), vecX, vecY, vecZ));
			PlaneProfile ppCoverB=ppCoverA;
			for (int i = 0; i < ptsZ.length(); i++)
			{ 
				Point3d pt = ptsZ[i];
				pt.vis(i);
				
				Body bdz;
				for (int j=bodies.length()-1; j>=0 ; j--) 
				{ 
					Body b=bodies[j]; 
					Point3d pts[] = b.extremeVertices(vecZ);
					double dd = abs(vecZ.dotProduct(pts.first() - pt));
					if (dd < dEps)
					{
						//b.vis(i);
						bdz.addPart(b);
						bodies.removeAt(j);
					}
				}//next j
				//bdz.vis(i);
				//bd.addPart(bdz);			
				
				PlaneProfile pp = bdz.shadowProfile(Plane(pt, vecZ));
				PlaneProfile ppx = i%2==1?ppCoverA:ppCoverB;
				int bAddCover = ppx.area() > pow(dEps, 2 );
				if (bAddCover)
				{ 
					ppx.intersectWith(pp);
					ppx.createRectangle(ppx.extentInDir(vecX), vecX, vecY);
					ppx.intersectWith(i%2==1?ppCoverA:ppCoverB);				
				}
				pp.unionWith(ppx);
				if (i%2==1)
					ppCoverA = pp;
				else
					ppCoverB = pp;				
	
				if (bAddCover)
				{ 
					Body bdCover;
					PlaneProfile& ppc = i % 2 == 1 ? ppCoverA : ppCoverB;
					ppc.transformBy(vecZ * vecZ.dotProduct(pt - ppc.coordSys().ptOrg()));
					//{Display dpx(i); dpx.draw(ppc, _kDrawFilled, 60);}
					PLine rings[] = ppc.allRings(true, false);//
					for (int r=0;r<rings.length();r++) 
					{ 
						Body bdi(rings[r], vecZ * bdz.lengthInDirection(vecZ), 1);
						if (!bdi.isNull())
						{
							bdCover.addPart(bdi);
							//bdi.vis(6);
						}						 
					}//next r	
					rings= ppc.allRings(false, true);//
					for (int r=0;r<rings.length();r++) 
					{ 
						Body bdi(rings[r], vecZ * bdz.lengthInDirection(vecZ), 1);
						if (!bdi.isNull())
						{
							bdCover.subPart(bdi);
							//bdi.vis(6);
						}						 
					}//next r
					if (!bdCover.isNull())
						bd.addPart(bdCover);
				}
				else
					bd.addPart(bdz);	
	
			}
			
						
		}

		if (_bOnDbCreated || _bOnRecalc || !_Map.hasBody("Cache") || _kNameLastChangedProp==sResolutionName)
		{ 
			_Map.setBody("Cache", bd);
			
		}
	//endregion 

		//reportNotice("..." + (getTickCount()-tick) + "ms");

		ptOrg = GetElementOrg(el.coordSys(), bd);
		csDef = CoordSys(ptOrg, csDef.vecX(), csDef.vecY(), csDef.vecZ());
	}
	else if (ce.bIsValid())
	{ 
		sRefEntityType = kMetalPart;
		Quader qdr = ce.bodyExtents();
	
		csDef = ce.coordSys();		
		vecX = csDef.vecX();
		vecY = csDef.vecY();
		vecZ = csDef.vecZ();		
		csDef = CoordSys(qdr.pointAt(0, 0, 0), vecX, vecY, vecZ);
		
		nColorItem = ce.color();		
		bd = GetMetalPartBody(ce, nShapeType, pdContent); 		//bd.vis(6);
	}


	double dWeight, dVolume;
	Point3d ptCOG;
	{ 	
		String type = entDefine.typeDxfName();
		Map mapIO;
		Map mapEntities;
		mapEntities.appendEntity("Entity", entDefine);
		if (el.bIsValid())
		{ 
			for (int i=0;i<gbs.length();i++) 
				mapEntities.appendEntity("Entity", gbs[i]); 			
		}
		mapIO.setMap("Entity[]",mapEntities);
		TslInst().callMapIO("hsbCenterOfGravity", mapIO);
		ptCOG = mapIO.getPoint3d("ptCen");// returning the center of gravity
		dWeight= mapIO.getDouble("Weight");// returning the weight
		mapAdd.setDouble("Weight", dWeight,_kNoUnit);	
	}
	
	Point3d ptModelOrg = csDef.ptOrg();
	if (bdChilds.length()<1)
		bdChilds.append(bd);
	
	// realBody
	if (bd.isNull())
		for (int i=0;i<bdChilds.length();i++) 
			bd.combine(bdChilds[i]); 	
	bdModel = bd;
	if (bdModel.isNull())
	{ 
		if (pdContent.bIsValid())
		{ 
			reportMessage(TN("|The selected content filter invalidates the item, filter has been diabled.|"));
			sContentPainter.set(tByDefault);
			setExecutionLoops(2);
			return;
		}

		if (!bDebug)eraseInstance();
		return;
	}
	else
		dVolume = bdModel.volume();
	


//Standards //endregion 

//region Move Items when Base Grip is dragged or Spacer height changed
	if (_kNameLastChangedProp == tSpacerHeightName)
	{ 
		double d = dSpacerHeight - _Map.getDouble("SpacerHeight");
		_Pt0 += _ZW * d;
	
	}	
	_Map.setDouble("SpacerHeight", dSpacerHeight);
//endregion 


//region Parent
	int bHasStack, bHasPack;
	String subMapXKeys[] = this.subMapXKeys();	
	if (bDebug)reportNotice("\n" + scriptName() + " " + this.handle() + " has subMapX Keys " + subMapXKeys);
	String thisParent;
	if (subMapXKeys.findNoCase(kPackageChild,-1)>-1)// Get potential parent package
		thisParent = kPackageChild;
	else if (subMapXKeys.findNoCase(kTruckChild,-1)>-1)// Get potential parent stack/truck
		thisParent = kTruckChild;		
	if (bDebug && thisParent.length()>0)	
		reportNotice("\n" + scriptName() + " " + this.handle() + " has " + thisParent);

	Map mapX =this.subMapX(thisParent);
	String parentUID = mapX.getString("ParentHandle");
	Entity entParent; entParent.setFromHandle(parentUID);	
	TslInst pack, stack, tslParent = (TslInst)entParent;	
	if (!bDebug)
	{ 
		mapX.setString("Entity", entDefine.uniqueId());	
		_ThisInst.setSubMapX(thisParent,mapX);	
	}

	PlaneProfile ppLoads[0];

	if (tslParent.bIsValid())
	{ 
		String scriptName = tslParent.scriptName();
		TruckDefinition td(tslParent.propString(sTruckDefinitionPropertyName));// = getTslTruckDefinition(tslParent);
		if (td.bIsValid())
		{ 
			Map m = td.subMapX(kTruckData);
			m.setString("DescriptionTruck", tslParent.propString(sTruckDescriptionPropertyName));
			mapAdd.copyMembersFrom(m);
			mapXStackData.copyMembersFrom(m);			
			ppLoads=getLoadProfiles(entParent, PlaneProfile());
			bHasStack = true;
			stack = tslParent;
			if (bDebug)reportNotice("\n" + tslParent.handle() + " stack detected");	
		}
		else if (scriptName == kScriptPack)
		{
			if (bDebug)reportNotice("\n" + tslParent.handle() + " pack detected");			
			bHasPack = true;
			pack = tslParent;
		}

		//if (bDebug)PLine(tslParent.ptOrg(), _ThisInst.ptOrg()).vis(bHasPack);
		
	// Get potential stack/truck link	
		if (bHasPack)
		{ 
			stack = getParent(pack);
			bHasStack = stack.bIsValid();			
			
		}
		if (bDebug)reportNotice("\n" + scriptName() + " " + this.handle() + " pack (" +bHasPack+" )has " +(bHasStack?"also":"no")+ " stack ref\n");	
	}
	else if(bDebug)
	{ 
		reportNotice("\n" + this.formatObject("@(ScripName) @(Handle)") + " has no parent");
	}
	

	
// DataLink: make sure no false references to pack or stack exist
	if ((!bHasPack || !bHasStack) && entDefine.subMapXKeys().findNoCase(kDataLink,-1)>-1)
	{ 	
		
		int bUpdate;
		Map m = entDefine.subMapX(kDataLink);
				
		if (!bHasPack && m.hasEntity(kScriptPack))
		{
			m.removeAt(kScriptPack, true);
			bUpdate = true;
			//reportNotice("\nfound " + m + " still has ent " + m.hasEntity(kScriptPack));
		}
		if (!bHasStack && m.hasEntity(kScriptStack))
		{
			m.removeAt(kScriptStack, true);
			bUpdate = true;
		}
		if (bUpdate && !bDebug)
		{
			if (m.length()<1)
				entDefine.removeSubMapX(kDataLink);
			else
			{ 
				entDefine.setSubMapX(kDataLink, m);				
			}
		}
	}
	
	if (!bHasPack && _Map.hasInt(kLayerIndexPack))
	{ 
		RemoveLayerIndices(_Map);
	}
//	if (!bHasPack && !bHasStack)
//	{ 
//		_ThisInst.setColor(0);
//	}
	
	
	
	
//endregion


//region Transformation
	_XE.vis(_Pt0,1);
	_YE.vis(_Pt0,3);
	_ZE.vis(_Pt0,150);

	CoordSys ms2ps, ps2ms, csRot;
	CoordSys csView(_Pt0, vecXView, vecYView, vecZView);
	
	
	// align flattened, longest dim = X
	{ 
		Vector3d vecXM = vecX;
		Vector3d vecYM = vecY;
		Vector3d vecZM = vecZ;		
		
		double dX = bd.lengthInDirection(vecX);
		double dY = bd.lengthInDirection(vecY);
		double dZ = bd.lengthInDirection(vecZ);		
		
		if (!el.bIsValid() && !ce.bIsValid())
		{ 
			if (dX<dY)
			{ 
				if (dY<dZ)
				{ 
					vecXM = vecZ;	vecYM = vecX;					
				}
				else
				{ 
					vecXM = vecY;	vecYM = -vecX;				
				}
			}
			else if (dX<dZ)
			{ 
				vecXM = vecZ;	vecYM = vecX;				
			}			
		}
		

		ms2ps.setToAlignCoordSys(ptModelOrg, vecXM, vecYM, vecZM, _Pt0, _XE, _YE, _ZE);
	}


	if (bIsVertical)
	{ 
		csRot.setToRotation(90, _XE, _Pt0);
		ms2ps.transformBy(csRot);
	}
	bd.transformBy(ms2ps);
	

	
	
//bd.vis(4);
	
// Project to bottom plane
	Point3d ptsZ[] = bd.extremeVertices(_ZW);
	double dDeltaZ = ptsZ.length()>0?_ZW.dotProduct(_Pt0 - ptsZ.first()):0;
	
	double dZ = bd.lengthInDirection(_ZW);	
//	double dDeltaZ = (bIsVertical && el.bIsValid())?0:.5 * dZ;//el.bIsValid()?-el.dPosZOutlineBack():
	for (int i=0;i<bdChilds.length();i++) 
	{ 
		Body& child = bdChilds[i];
		child.transformBy(ms2ps);
		child.transformBy(_ZW * dDeltaZ);
	}//next i
	bd.transformBy(_ZW * dDeltaZ);			//bd.vis(2); _Pt0.vis(8);
	
	CoordSys ms2psX = ms2ps;
	ms2psX.transformBy(_ZW *dDeltaZ);	
	ptCOG.transformBy(ms2psX);	//ptCOG.vis(6);	


// get most aligned vecs to world
	Point3d ptCen = bd.ptCen();
	Quader qdr(ptCen, _XE, _YE, _ZE, bd.lengthInDirection(_XE), bd.lengthInDirection(_YE), bd.lengthInDirection(_ZE), 0, 0, 0);
	Vector3d vecXI = qdr.vecD(_XW).crossProduct(_ZW).crossProduct(-_ZW); vecXI.normalize();
	Vector3d vecYI = vecXI.crossProduct(-_ZW);
	
	vecXI.vis(_Pt0,12);
	vecYI.vis(_Pt0,93);

	CoordSys csX(_Pt0,vecYI,_ZW,vecXI);	
	CoordSys csY(_Pt0, -vecXI ,_ZW, vecYI);
	CoordSys csZ(_Pt0,vecXI,vecYI,_ZW);
	CoordSys css[] ={ csX, csY, csZ};

//endregion 



//region Set Child Relation
	if (bHasPack || bHasStack)
	{ 
		Map mapX;
		mapX.setString("Entity", entDefine.uniqueId());	
			
//		CoordSys csChild = t.coordSys();
		CoordSys csChildRel(_Pt0, vecXI, vecYI, vecXI.crossProduct(vecYI)); 

//TODO
//		csChildRel.setToAlignCoordSys(
//			_Pt0, csParent.vecX(), csParent.vecY(), csParent.vecZ(),
//			csChild.ptOrg(), csChild.vecX(), csChild.vecY(), csChild.vecZ());
//		mapX.setPoint3d("ptRelOrg", csChildRel.ptOrg(), _kAbsolute);
//		mapX.setPoint3d("ptVecX", csChildRel.ptOrg() + csChildRel.vecX(), _kAbsolute);
//		mapX.setPoint3d("ptVecY", csChildRel.ptOrg() + csChildRel.vecY(), _kAbsolute);
//		mapX.setPoint3d("ptVecZ", csChildRel.ptOrg() + csChildRel.vecZ(), _kAbsolute);
		
		mapX.setPoint3d("ptRelOrg", csChildRel.ptOrg(), _kAbsolute);
		mapX.setPoint3d("ptVecX", csChildRel.ptOrg() + csChildRel.vecX(), _kAbsolute);
		mapX.setPoint3d("ptVecY", csChildRel.ptOrg() + csChildRel.vecY(), _kAbsolute);
		mapX.setPoint3d("ptVecZ", csChildRel.ptOrg() + csChildRel.vecZ(), _kAbsolute);

		if(bHasPack)
		{
			mapX.setString("ParentHandle", pack.handle());
			mapX.setString("ParentUID", pack.uniqueId());
			if (!bDebug)this.setSubMapX(kPackageChild, mapX);

		// HSB-21994 updating item list	
			pack.transformBy(Vector3d(0, 0, 0));			
			
		}
		if(bHasStack)
		{
			mapX.setString("ParentHandle", stack.handle());
			mapX.setString("ParentUID", stack.uniqueId());
			if (!bDebug)this.setSubMapX(kTruckChild, mapX);
		}
		
	}	
//endregion 



//region Read Settings
	int nColorRule; //byLayerIndex
	int nSequentialColors[0], nSequentialPackColors[0];
	int ntWirePlan, ntWireModel, ntFillPlan, ntFillModel;
	Map rowDefinitions;
	{
		String k;
		Map m= mapSetting.getMap("Item");

	// sequential colors: these colors are used to replace the index colors by the given value.
		Map mapColors = m.getMap("SequentialColor[]");		
		for (int i=0;i<mapColors.length();i++) 
			nSequentialColors.append(mapColors.getInt(i)); 
		mapColors = mapSetting.getMap("Pack\\SequentialColor[]");		
		for (int i=0;i<mapColors.length();i++) 
			nSequentialPackColors.append(mapColors.getInt(i)); 


	//	k="DoubleEntry";		if (m.hasDouble(k))	dDoubleEntry = m.getDouble(k);
	//	k="StringEntry";		if (m.hasString(k))	sStringEntry = m.getString(k);
		k="ColorRule";			if (m.hasInt(k))	nColorRule = m.getInt(k);
	
	// Transparencies
		m= mapSetting.getMap("Item\\"+(bIsVertical?"Vertical":"Horizontal")+"\\Plan");
		k="TransparencyWire";		if (m.hasInt(k))	ntWirePlan = m.getInt(k);
		k="TransparencyFill";		if (m.hasInt(k))	ntFillPlan = m.getInt(k);
		
		m= mapSetting.getMap("Item\\"+(bIsVertical?"Vertical":"Horizontal")+"\\Model");
		k="TransparencyWire";		if (m.hasInt(k))	ntWireModel = m.getInt(k);
		k="TransparencyFill";		if (m.hasInt(k))	ntFillModel = m.getInt(k);			

	// Get component settings
		rowDefinitions=mapSetting.getMap("Item\\Components\\"+kRowDefinitions);
		

	}//End Read Settings//endregion 




//region Display
	int nColor;
	// 0=bylayerPackIndex, 1=byPackNumber, 2=byStackIndex
	if (nColorRule==0 && _Map.hasInt(kLayerIndexPack))
	{
		nColor = _Map.getInt(kLayerIndexPack)+1;
		SetSequenceColor(nColor, nSequentialColors);	
	}
	else if (nColorRule==1 && bHasPack)
	{
		nColor = pack.propInt(0);
		SetSequenceColor(nColor, nSequentialPackColors);

	}
	else if (nColorRule==2)
	{
		if (bHasStack)
		{
			nColor = pack.map().getInt(kLayerIndexStack)+1;
		}
//		else if (bHasPack)
//		{
//			nColor = pack.propInt(0);
//		}
		else if (_Map.hasInt(kLayerIndexPack))
		{
			nColor = _Map.getInt(kLayerIndexPack)+1;
		}
		SetSequenceColor(nColor, nSequentialPackColors);	
	}	
	nColor = nColor<=0?nColorItem:nColor;
	if (nColor<=256 && this.color()!=nColor)
		this.setColor(nColor);
	//reportNotice("\nSelected color = " + nColor);
	dpPlan.color(nColor);
	dpModel.color(nColor);
	
//Display //endregion 

//region Get Shapes
	PLine plShapes[0]; // the bounding plines per xyz view	
	PlaneProfile ppShapes[0];
	
	for (int i=0;i<css.length();i++) 
	{ 
		PlaneProfile pp = GetBodiesShadow(bdChilds, css[i], dEps);	//pp.vis(i);
		ppShapes.append(pp);
		PLine pl = GetProfileHull(pp, gb.bIsValid());			
		pl.simplify();
//		if (gb.bIsValid() && i==2) // HSB-22467
//			pl.reconstructArcs(dEps, 70 );
		//pl.vis(i + 1);
		plShapes.append(pl); 
	}//next j	
	PlaneProfile ppShapeX(csX), ppShapeY(csY), ppShapeZ(csZ), ppShapeView(csView);
	ppShapeX = ppShapes[0];
	ppShapeY = ppShapes[1];
	ppShapeZ = ppShapes[2];	

//endregion 


//region Store formatting data
	{
		int bHideItemInPage; // indicating that the item shall not be shown in a multipage
		if (bHasPack)
		{ 
			String itemMode = tslParent.propString(sItemModeName);
			
			if (itemMode!="" && (itemMode==tIMHidden || itemMode==tIMHideMultipage))
				bHideItemInPage = true;
			//reportNotice("\nitemMode=" + itemMode + " of " + tslParent.scriptName() + " = " + bHideItemInPage + " weight " + dWeight);	
		}

		Map m = this.subMapX(kData);		
		m.setInt("hideItemInPage", bHideItemInPage);
		m.setInt("hasPack", bHasPack);
		m.setInt("hasStack", bHasStack);
		m.setDouble("Weight", dWeight, _kNoUnit);
		m.setDouble("Volume", dVolume, _kVolume);
		m.setPoint3d("COG", ptCOG);
		m.setPlaneProfile("shapeZ", ppShapeZ);
		this.setSubMapX(kData, m);
		mapAdd.copyMembersFrom(m);
	}//endregion

//region Managing DataLink
	Map mapDataLink = entDefine.subMapX(kDataLink);
	String xrefName = entDefine.xrefName();
	int bIsXref = xrefName!="";	
	int bUpdateDataLink;
	
	// check item (this)
	if(mapDataLink.getEntity(kScriptItem)!=this)
	{ 
		bUpdateDataLink = true;
		mapDataLink.setEntity(kScriptItem, this, bIsXref);// add as unresolved if xref
	}	
	// check pack
	if (bHasPack)
	{ 
		if(mapDataLink.getEntity(kScriptPack)!=tslParent)
		{
			bUpdateDataLink = true;
			mapDataLink.setEntity(kScriptPack, tslParent, bIsXref);// add as unresolved if xref
		}
	}
	else if (mapDataLink.hasEntity(kScriptPack))
	{ 
		bUpdateDataLink = true;
		mapDataLink.removeAt(kScriptPack, true);
	}
	// check stack
	if (bHasStack)
	{ 
		if(mapDataLink.getEntity(kScriptStack)!=tslParent)
		{
			bUpdateDataLink = true;
			mapDataLink.setEntity(kScriptStack, tslParent, bIsXref);// add as unresolved if xref
		}
	}
	else if (mapDataLink.hasEntity(kScriptStack))
	{ 
		bUpdateDataLink = true;
		mapDataLink.removeAt(kScriptStack, true);
	}	
	
	if (!bIsXref && bUpdateDataLink)
	{
		bUpdateDataLink = false;
		entDefine.setSubMapX(kDataLink, mapDataLink);	
	}
	else if (bIsXref && bUpdateDataLink)
	{ 

	//region Trigger Test
		String sTriggerUpdateXRef = T("|Update XRef-Data|");
		addRecalcTrigger(_kContextRoot, sTriggerUpdateXRef );
		if (_bOnRecalc && _kExecuteKey==sTriggerUpdateXRef)
		{
 			int nLockErr;
			XrefLocker locker;
			nLockErr = locker.lockDatabaseOf(entDefine);
			entDefine.setSubMapX(kDataLink, mapDataLink);

			if (nLockErr>0)
			{ 
				Map mapNoticeIn;
				mapNoticeIn.setString("Notice", T("|Not possible to lock xRef file.|") + 
					"\n\n"+xrefName + "\n"+TN("|The file is probably already open, please close and retry.|") + 
					TN("|Error Number|: ")+nLockErr);
				mapNoticeIn.setString("Title", T("|Update not successful|"));
				Map mpNoticeOut = callDotNetFunction2(sDialogLibrary, sClass, "ShowNotice", mapNoticeIn);				
			}
			else
				bUpdateDataLink = false;

			if (bDebug)reportNotice("\ndata written: " + xrefName+ ": "+ entDefine.bIsValid() + 
				"\n   dataLinkMap: " +entDefine.subMapX(kDataLink));
			//setExecutionLoops(2);
			//return;
		}//endregion		
	}
		
//endregion 

//region Default Tag Location
	Point3d ptTagPlan = ppShapeZ.ptMid();
	{ 
		double dXShape = ppShapeZ.dX()-.5*textHeight;
		double dYShape = ppShapeZ.dY()-.5*textHeight;
		ptTagPlan += _ZW * dZ - .5 * (csZ.vecX() * dXShape - csZ.vecY() * dYShape);			
	}

	if (ppShapeZ.pointInProfile(ptTagPlan)==_kPointOutsideProfile)
	{ 
		Point3d pt = ppShapeZ.closestPointTo(ptTagPlan);
		pt.setZ(ptTagPlan.Z());
		ptTagPlan = pt;
	}		
	ptTagPlan.vis(40);	
	
	String text = entDefine.formatObject(sFormat, mapAdd);
	if (text.length() < 1 && bDebug)text = scriptName();
	sFormat.setDefinesFormatting(entDefine, mapAdd);		
	
	
//endregion 



//End Part #D //endregion

//region Part #E
		
//region Grip Management #GM

	// Update/Manage Grips
	if (!_bOnGripPointDrag)
	{ 
		//reportNotice("\n   " + scriptName() + " Loop:"+_kExecutionLoopCount + " " + _ThisInst.handle() + " current color "+_ThisInst.color() + "bOnDragEnd"+bOnDragEnd);
		if (bOnDragEnd)setExecutionLoops(2);
	// remove any location and/or non DX Content grip;
		for (int i=_Grip.length()-1; i>=0 ; i--) 
		{ 
			Map mapGrip;
			int bOk = mapGrip.setDxContent(_Grip[i].name(), true);
			if(!bOk || !mapGrip.getInt("isTag"))
				_Grip.removeAt(i);	
		}//next i
		
	//region Tagging Grip
		Map mapGripTag;
		int nTagPlan = GetTagGrip(_Grip, mapGripTag);
		if (text.length()>0)
		{
		// Update/Store content in grip map
			mapGripTag.setInt("isTag", true);		
			mapGripTag.setString("text", text);
			String sDXContent = mapGripTag.getDxContent(true);
			
			if (nTagPlan<0)
			{ 
				Grip gripTag = createGrip(ptTagPlan, _kGSTCircle, sDXContent, _XW, _YW, 40, T("|Moves the location of the tag in plan view|"));
				_Grip.append(gripTag);
				nTagPlan = _Grip.length() - 1;
			}
			else
			{ 
				Grip& gripTag = _Grip[nTagPlan];
				//double z = ptTagPlan.Z();
				ptTagPlan = gripTag.ptLoc();		
				gripTag.setName(sDXContent);
				//ptTagPlan.setZ(z);			
			}
		}
		else if (nTagPlan>-1 && text.length()<1)
		{
			_Grip.removeAt(nTagPlan);		
		}//endregion 
				
	//region Set Location Grips
		if (!bDrag)
		{ 
			//reportNotice("\nnot on drag " + scriptName());
			Map mapGrip;
			mapGrip.setInt("isLocation", true);
			if (bHasPack)mapGrip.setEntity("pack", pack);
			if (bHasStack)mapGrip.setEntity("stack", stack);
	
			for (int i=0;i<plShapes.length();i++) 
			{ 		
				CoordSys csi = css[i];
				String key = kDirKeys[i];
				
				PLine& plShape = plShapes[i];	
				PLine plShapeGrip = plShape;
				
				PlaneProfile ppi(csi);
				ppi.joinRing(plShape,_kAdd);
				
				if (bIsVertical && el.bIsValid() && i==2)//HSB-22467
				{ 
					plShape.createRectangle(ppi.extentInDir(csi.vecX()), csi.vecX(), csi.vecY());
				}
				
				if (bIsVertical  && (i==0 ||i==2))
				{ 
					Point3d ptm = ppi.ptMid();
					Vector3d vec;
					if (i==0)
						vec = csi.vecX() * (.5 *ppi.dX()+dVerticalSpacerThickness) + (csi.vecY() * .5*ppi.dY());
					else if (i==2)
						vec = (csi.vecX() * .5 *ppi.dX()) + (csi.vecY() * (.5*ppi.dY()+dVerticalSpacerThickness));
					plShapeGrip.createRectangle(LineSeg(ptm-vec, ptm+vec), csi.vecX(), csi.vecY());					
				}

				//plShape.vis(6);
				
				Point3d ptsShape[]= plShapeGrip.vertexPoints(true);
				PlaneProfile ppShape(css[i]);
				ppShape.joinRing(plShapeGrip,_kAdd);
				Point3d ptsC[0];
				ptsC.append(ptsShape);
				addMidPoints(ppShape, ptsC);
				
				mapGrip.setString("DirKey", key);
				mapGrip.setPLine("shape", plShape);
				mapGrip.setPLine("shape2", i==2?plShapes[1]:plShapes[2]);
				mapGrip.setInt("hasPack", bHasPack);
				mapGrip.setInt("hasStack", bHasStack);
				
				String sDXContent = mapGrip.getDxContent(true);
				
				
				// move points of base plane by Spacer height
				if (dSpacerHeight>dEps)
					for (int i=0;i<ptsC.length();i++) 
						if (_ZW.dotProduct(ptsC[i]-_Pt0)<=dEps)
							ptsC[i].transformBy(-_ZW * dSpacerHeight);
		
				//for (int p=0;p<ptsC.length();p++) 			ptsC[p].vis(i+4); 			 
				
				for (int p=0;p<ptsC.length();p++) 
				{ 
					Point3d pt= ptsC[p]; 
		
					Grip grip;
					grip.setPtLoc(pt);
					grip.setVecX(csi.vecX());
					grip.setVecY(csi.vecY());
					grip.setColor(4);
					grip.setShapeType(_kGSTCircle);
				
					grip.setName(sDXContent);//key +i);
			
					if (i==2)
					{ 
						grip.addHideDirection(csi.vecX());
						grip.addHideDirection(-csi.vecX());
						grip.addHideDirection(csi.vecY());
						grip.addHideDirection(-csi.vecY());				
					}
					else
					{ 
						grip.addViewDirection(csi.vecZ());
						grip.addViewDirection(-csi.vecZ());				
					}
		
					
					grip.setToolTip(T("|Moves the item by selected vertex|"));	
					
					_Grip.append(grip); 
				}//next p		
			}//next i
					
		}
			
		
		
	}//endregion 

//endregion 

//End Part #E //endregion 

//region Draw


	// draw projections
	if (sProjectionMode!=tPMNone)
	{
		PlaneProfile ppProjections[] = { ppShapeX, ppShapeY, ppShapeZ};
		
		String lineType = "HIDDEN";
		int n = _LineTypes.findNoCase("HIDDEN2" ,- 1);
		if (n>-1)
			lineType = _LineTypes[n];
		else
		{ 
			n = _LineTypes.findNoCase("VERDECKT" ,- 1);
			if (n>-1)lineType = _LineTypes[n];
		}	
		
		dpModelOnly.color(nColor);
		DrawProjections(bd, ppProjections, lineType, 0, dpModelOnly,sProjectionMode);
	}


	DrawTag(text, ptTagPlan, sDimStyle, textHeight, bUpdateDataLink);

	if (dSpacerHeight>dEps && plShapes.length()>2)
		drawSpacer(plShapes[2], dSpacerHeight);	
	
//	DrawBodies(bdChilds, Vector3d(), nColor,(!bHasPack && !bHasStack?5:20), dpPlan);//_bOnGripPointDrag?60:90);	
	DrawBodies(bdChilds, Vector3d(), nColor,ntWireModel, dpModel);
	//dpModelX.draw(bd);
	
	DrawPLine(plShapes[2], Vector3d(), nColor, ntWirePlan,(bHasPack || bHasStack)?ntFillPlan:95, dpPlan); // only show wire frame when stacked
//
	// Draw other items intersecting within range of my parent
	if (tslParent.bIsValid())
	{ 
		Entity entSiblings[] = tslParent.entity();
		TslInst siblings[0];
		for (int i=0;i<entSiblings.length();i++) 
		{ 
			TslInst t= (TslInst)entSiblings[i]; 
			if (t.bIsValid() && t!=this && siblings.find(t)<0)
				siblings.append(t);
			 
		}//next i

		siblings = FilterCloseSiblings(ppShapeZ, siblings, false);
		siblings = FilterIntersectingSiblings(ppShapeZ, siblings, false); // false/true to draw result			
		siblings = FilterIntersectingSolids(this, bd, siblings, true);//reportNotice("\nDraw Found closed intersections " + siblings.length() );
		
//		if (siblings.length()>0)
//			reportNotice("\n"+  siblings + " intersections found with me " + _ThisInst.handle() + " lumps " + bd.decomposeIntoLumps().length());

	}



//endregion 

//region Draw Specials
	for (int j=0;j<rowDefinitions.length();j++) 
	{ 
		
	//region Get Row Data
		Map row  = rowDefinitions.getMap(j); 
		String entityType = row.getString("EntityType");
		String component = row.getString("Component");
		int bAny =entityType=="AnyType";	
		// Get Color and Scaling	
		int color = row.getInt("Color");	color = color<0?nColor:color;
		int transparency = row.getInt("Transparency");
		double scale= row.getDouble("Scale");
		double size = U(100)*scale;		
		
		if (!Equals(entityType, sRefEntityType) && !bAny){continue;}
	//endregion 	

	//region Visibilty Setting Acceptance
		int bVisibleItem = row.getInt("VisibleItem");
		int bVisiblePack = row.getInt("VisiblePack");
		int bVisibleStack = row.getInt("VisibleStack");

		int bAccept = bVisibleItem;
		if (bHasPack)
			bAccept = bVisiblePack;
		if (bHasStack)
			bAccept = bVisibleStack;				
	
		if (!bAccept){ continue;}
		//endregion	

	//region COG
		if (Equals(component, kCOG))
		{ 
			for (int v = 0; v < css.length(); v++)
			{
				CoordSys cs = css[v];
				Vector3d vecXV = cs.vecX();
				Vector3d vecYV = cs.vecY();
				Vector3d vecZV = cs.vecZ();
				Display dp(color), dpSnap(250);//);
				dp.showDuringSnap(false); 
				dp.showInDxa(true);
				dpSnap.showInDxa(true);
				dpSnap.showDuringSnap(true); 				
				if (v==0)
				{ 
					dp.addHideDirection(-cs.vecX());	dp.addHideDirection(cs.vecX());
					dp.addHideDirection(-cs.vecY());	dp.addHideDirection(cs.vecY());	
					dpSnap.addHideDirection(-cs.vecX());	dpSnap.addHideDirection(cs.vecX());
					dpSnap.addHideDirection(-cs.vecY());	dpSnap.addHideDirection(cs.vecY());						
				}		
				else
				{ 
					dp.addViewDirection(-cs.vecZ());	dp.addViewDirection(cs.vecZ());
					dpSnap.addViewDirection(-cs.vecZ());	dpSnap.addViewDirection(cs.vecZ());					
				}

				PLine c;
				c.createCircle(ptCOG, cs.vecZ(), .5*size);
				c.convertToLineApprox(dEps);
				PlaneProfile pp(CoordSys(ptCOG, vecXV, vecYV, vecZV));
				pp.joinRing(c, _kAdd);
				PlaneProfile pp2 = pp;
				pp2.shrink(.05 * size);
				pp.subtractProfile(pp2);
				
				CoordSys rot; rot.setToRotation(45, vecZV, ptCOG);
				PLine rec; rec.createRectangle(LineSeg(ptCOG - size * vecXV - vecYV * .025 * size, ptCOG + size * vecXV + vecYV * .025 * size), vecXV, vecYV);
				
				rec.transformBy(rot);
				pp.joinRing(rec,_kSubtract);
				rec.transformBy(rot);rec.transformBy(rot);
				pp.joinRing(rec,_kSubtract);					
				rec.transformBy(rot);
				PlaneProfile ppRec(rec);
				pp.unionWith(ppRec);
				ppRec.transformBy(rot);ppRec.transformBy(rot);
				pp.unionWith(ppRec);
				dp.draw(pp, _kDrawFilled, transparency);
				c.createCircle(ptCOG, cs.vecZ(), .5*size);
				dpSnap.draw(c);
				c.createCircle(ptCOG, cs.vecZ(), .45*size);
				dpSnap.draw(c);
//				PLine pl1(ptCOG - vecXV * size, ptCOG + vecXV * size);	dpSnap.draw(pl1);
//				PLine pl2(ptCOG - vecYV * size, ptCOG + vecYV * size);	dpSnap.draw(pl2);

			}				
		}//COG //endregion 
	
	//region GrainDirection: panels only
		else if (pa.bIsValid() && Equals(component, kGrainDirection))
		{ 
			Vector3d vecXG = pa.woodGrainDirection();
			vecXG.transformBy(ms2ps);			
			Vector3d vecZG = vecZ; 	vecZG.transformBy(ms2ps);
			Vector3d vecYG = vecXG.crossProduct(-vecZG);
			
		//region Define Grain Symbol in WCS and transform to item	
			PlaneProfile ppGrain;
			if (!vecXG.bIsZeroLength())
			{
				PLine plGrain(_ZW);

				double size = U(100)*scale;
				plGrain.addVertex(_PtW - _XW * .5 * size - _YW * .25 * size);
				plGrain.addVertex(_PtW - _XW * 1.0 * size);
				plGrain.addVertex(_PtW + _XW * 1.0 * size);
				plGrain.addVertex(_PtW + _XW * .5 * size + _YW * .25 * size);		
				PLine pl1 = plGrain; pl1.offset(size * .05, true);
				PLine pl2 = plGrain; pl2.offset(-size * .05, true);pl2.reverse();
				plGrain = pl1;
				plGrain.append(pl2); plGrain.close();	
				CoordSys cs2Item; cs2Item.setToAlignCoordSys(_PtW, _XW, _YW, _ZW, _Pt0, vecXG, vecYG, vecZG);
				plGrain.transformBy(cs2Item);
				
				ppGrain = PlaneProfile(CoordSys(_Pt0, vecXG, vecYG, vecZG));
				ppGrain.joinRing(plGrain,_kAdd);
	
				//{Display dpx(1); dpx.draw(ppGrain, _kDrawFilled,20);}
			}//endregion	
						
		//region Loop main views
			if (ppGrain.area()>pow(dEps,2))
				for (int v=0;v<css.length();v++) 
				{ 
					CoordSys cs = css[v];
					Vector3d vecZV = cs.vecZ();
					
					Plane pn(cs.ptOrg(), vecZV);
					Point3d ptc = CenterPointInProfile(bd.shadowProfile(pn));			
					double dzv = bd.lengthInDirection(vecZV);
					ptc += vecZV * vecZV.dotProduct(ptCen - ptc);	
					
				// Grain Direction	
					CoordSys csg = ppGrain.coordSys();
					ppGrain.transformBy(ptc - csg.ptOrg());
		
					if (csg.vecZ().isPerpendicularTo(vecZV))
					{ 
						vecZV.vis(ptc, 1);
						continue;
					}
					
					Display dpGrain(in3dGraphicsMode()?1:color);//);
					dpGrain.showDuringSnap(false); 
					dpGrain.showInDxa(true);
					dpGrain.addHideDirection(-cs.vecX());
					dpGrain.addHideDirection(cs.vecX());
					dpGrain.addHideDirection(-cs.vecY());
					dpGrain.addHideDirection(cs.vecY());				
				
				// lumnceptual/Real
					if (in3dGraphicsMode())
					{ 
						PlaneProfile pp1 = ppGrain;
						pp1.transformBy((.5 * dzv+dEps) * vecZV);
						if(csg.vecZ().isCodirectionalTo(_ZW) || csg.vecZ().isPerpendicularTo(_ZW))
							dpGrain.draw(pp1, _kDrawFilled,0);				
					
						PlaneProfile pp2 = ppGrain;
						pp2.transformBy((.5 * dzv+dEps) * -vecZV);
						if((-csg.vecZ()).isCodirectionalTo(_ZW) || csg.vecZ().isPerpendicularTo(_ZW))
							dpGrain.draw(pp2, _kDrawFilled,0);				
					}				
				// Wireframe	
					else
					{
						dpGrain.draw(ppGrain, _kDrawFilled,transparency);	
					}	
				}//next v //endregion 	

		}//GrainDirection //endregion 		

	//region SurfaceQuality
		else if (pa.bIsValid() && (Equals(component, kSurfaceQualityMin) || Equals(component, kSurfaceQualityMax)))	
		{ 
			size *= .25;
			int bIsMax = Equals(component, kSurfaceQualityMax);
			int qualityBot = pa.formatObject("@(surfaceQualityBottomStyle.Quality)").atoi();
			int qualityTop = pa.formatObject("@(surfaceQualityTopStyle.Quality)").atoi();
			
			Vector3d vecFace = pa.vecZ(); // top side
			
			int quality;
			if(qualityBot==qualityTop)
			{
				quality = qualityTop;
				vecFace *=(bIsMax ? 1 :- 1);
			}
			else if (bIsMax)
			{ 
				if (qualityTop>=qualityBot)
				{
					quality = qualityTop;
				}
				else
				{ 
					quality = qualityBot;
					vecFace *= -1;
				}				
			}
			else
			{ 
				if (qualityTop<=qualityBot)
				{
					quality = qualityTop;
				}
				else
				{ 
					quality = qualityBot;
					vecFace *= -1;
				}				
			}			
			vecFace.vis(pa.ptCen(), bIsMax?1:2);
			vecFace.transformBy(ms2ps);
			vecFace.vis(ptCOG, bIsMax?150:6);
			
			Point3d ptFace = bd.ptCen() + vecFace * .5 * bd.lengthInDirection(vecFace);
	
	
			

			
			PlaneProfile pp=bd.extractContactFaceInPlane(Plane(ptFace, vecFace), dEps);
			pp.removeAllOpeningRings();
			PlaneProfile pp2 = pp;
			pp2.shrink(size);
			pp.subtractProfile(pp2);

			if (row.getInt("Color")<-1)
			{ 
				Map mapAdd;
				mapAdd.setInt("qualityColor", quality);
				color = this.formatObject("@(qualityColor:A;SQ)", mapAdd).atoi();
			}

			Vector3d vecXV = vecX; vecXV.transformBy(ms2ps);
			Vector3d vecYV = vecXV.crossProduct(-vecFace);
			Display dp(color);
			dp.showInDxa(true);
			dp.showDuringSnap(false); 
			dp.addHideDirection(-vecXV);
			dp.addHideDirection(vecXV);
			dp.addHideDirection(-vecYV);
			dp.addHideDirection(vecYV);							
			dp.draw(pp, _kDrawFilled,transparency);
			
			
		}
	//End SurfaceQuality //endregion 



	}//next j component row
//Draw Specials //endregion 

//region Trigger
	Point3d ptRot = ppShapeZ.ptMid() + _ZW * .5 * dZ;		ptRot.vis(6);_ZE.vis(ptRot,150);

//region Trigger ComponentSettings	#DIA
	String sTriggerComponentSettings = T("|Component Settings|");
	//if (bDebug)
	addRecalcTrigger(_kContext, sTriggerComponentSettings ); // TODO remove bDebug once fully implememted
	if (_bOnRecalc && _kExecuteKey==sTriggerComponentSettings)
	{
		Map mapIn;	
//		String sBlocks[] = _BlockNames.sorted();
//		sBlocks.insertAt(0, tByDefault);
//		mapIn.setMap("Blocks", SetStringArray(sBlocks, ""));
		mapIn.setMap("Components", SetStringArray(tComponents, ""));
		mapIn.setMap("EntityTypes", SetStringArray(tEntityTypes, ""));
		mapIn.setMap(kRowDefinitions, TranslateRows(rowDefinitions)); // pass in translated rows
		Map mapRet = ShowComponentSettings(mapIn);
		
		
	// Cancelled
		int bCancel = mapRet.getInt("WasCancelled");


		if (!bCancel)
		{ 
		// collect rows	
			Map rowDefinitionsT;
			for (int i=0;i<mapRet.length();i++) 
			{ 
				if (mapRet.hasMap(i))
				{ 
					Map row = mapRet.getMap(i);
					if (!row.hasString("Component")){ continue;}
	
					double scale = row.getDouble("Scale");
					if (scale <= 0)scale = 1;
					row.setDouble("Scale", scale,_kNoUnit);			
					rowDefinitionsT.appendMap("row" + rowDefinitionsT.length(), row);
				}	 
			}//next i
			
		// translate back to source	and write settings
			if(rowDefinitionsT.length()>0)
			{ 
				rowDefinitions = TranslateRows(rowDefinitionsT);//, true);
				mapSetting.setMap("Item\\Components\\"+kRowDefinitions, rowDefinitions);
				
				if(!mo.bIsValid())
				{
					mo.dbCreate(mapSetting);
					//TODO check if all instances need to be triggered
				}
				else
					mo.setMap(mapSetting);			
			}
		// remove settings	
			else
			{ 
				mapSetting.removeAt("Item\\Components\\"+kRowDefinitions, true);
				if(!mo.bIsValid())
					mo.dbCreate(mapSetting);
				else
					mo.setMap(mapSetting);				
			}			
			
		}

		if (0 && mapRet.length()>0)
		{ 
			String sFileMap = _kPathPersonalTemp + "\\" + scriptName() + ".dxx";
			mapRet.writeToDxxFile(sFileMap);
			spawn_detach("",_kPathHsbInstall+"\\Utilities\\hsbMapExplorer\\hsbMapExplorer.exe", sFileMap,"");			
		}



		setExecutionLoops(2);
		return;
	}//endregion	
	


	//region Trigger Rotate //compare and update template HSB-22506 
	String sTriggerRotate = T("|Rotate|");
	addRecalcTrigger(_kContextRoot, sTriggerRotate);
	if (_bOnRecalc && _kExecuteKey==sTriggerRotate)
	{
		
		int bCancel,indexAxis;//0=X, 1=Y, 2=Z
		double dAngle;
		CoordSys cs = CoordSys(_Pt0, vecX, vecY, vecZ), csRot;	

		
	//region Select Axis Jig
	
		// Do not show axis jig if view is orthogonal to one of the axes
		if (cs.vecX().isParallelTo(vecZView))
			indexAxis = 0;
		else if (cs.vecY().isParallelTo(vecZView))
			indexAxis = 1;
		else if (cs.vecZ().isParallelTo(vecZView))
			indexAxis = 2;
		else	
		{ 
			PrPoint ssP(T("|Select axis|")); // second argument will set _PtBase in map
		    
		    Map mapArgs;
		    PlaneProfile pp(cs);
		    mapArgs.setPlaneProfile("pp", pp); // carries coordSys
		
		    double diameter = dViewHeight * .15;
		    PLine circles[] = GetCoordSysCircles(cs, diameter);
	
		    int nGoJig = -1;
		    while (nGoJig != _kOk && nGoJig != _kNone)
		    {
	
		        nGoJig = ssP.goJig(kJigSelectAxis, mapArgs); 
		        if (bDebug)reportMessage("\ngoJig returned: " + nGoJig);
		        
		        if (nGoJig == _kOk)
		        {
		            Point3d ptPick  = ssP.value(); //retrieve the selected point
		            Line(ptPick, vecZView).hasIntersection(Plane(_Pt0, vecZView), ptPick);
		            indexAxis = GetClosestCircle(ptPick, circles);
		            //reportNotice("\nSelect axis = " +indexAxis);
		        }
		        else if (nGoJig == _kCancel)
		        { 
		        	bCancel = true;
		        	break;
		        }
		    }	

		}//End Select Axis Jig
		
	// Get a coordSys with a normal towardy the users view
	    if (indexAxis==0)//RotateBy X-Axis
	    	cs = AlignCoordSysView(cs.ptOrg(), cs.vecY(), cs.vecZ(), cs.vecX());
	    else if (indexAxis==1)//RotateBy Y-Axis
	    	cs = AlignCoordSysView(cs.ptOrg(), -cs.vecX(), cs.vecZ(), cs.vecY());
	    else if (indexAxis==2)//RotateBy Z-Axis
	    	cs = AlignCoordSysView(cs.ptOrg(), cs.vecX(), cs.vecY(), cs.vecZ());		
	//endregion 

	//region Show Rotation Jig
	EntPLine epls[0];
	{ 

		PlaneProfile ppShadow(cs);
		ppShadow.unionWith(bd.shadowProfile(Plane(cs.ptOrg(), cs.vecZ())));
		PLine rings[] = ppShadow.allRings();  	
    	for (int r=0;r<rings.length();r++) 
    	{ 
    		EntPLine epl;
    		epl.dbCreate(rings[r]);
    		epl.setTrueColor(lightblue);
    		epl.setTransparency(80);
			epls.append(epl);
    	}//next r	   


		PrPoint ssP(T("|Pick point to rotate [Angle/Basepoint/ReferenceLine]|"));
		
	    Map mapArgs;
		Point3d pt = cs.ptOrg();
	    Plane pn(pt, cs.vecZ());
	    
	    PlaneProfile pp(cs);
	    mapArgs.setPlaneProfile("pp", pp); // carries coordSys
		mapArgs.setInt("indexAxis", indexAxis); 
		mapArgs.setBody("bd", bd); 
	
	    double diameter = dViewHeight * .15;
	    PLine circle;
	    circle.createCircle(pt, cs.vecZ(), diameter);

	    int nGoJig = -1;
	    while (!bCancel && nGoJig != _kOk && nGoJig != _kNone)
	    {

	        nGoJig = ssP.goJig(kJigRotation, mapArgs); 
	        if (bDebug)reportMessage("\ngoJig returned: " + nGoJig);        
	        if (nGoJig == _kOk)
	        {
	            Point3d ptPick  = ssP.value(); //retrieve the selected point
	            Line(ptPick, vecZView).hasIntersection(pn, ptPick);
	            
	            double diameter = dViewHeight * .15;
	            Vector3d vecPick = ptPick-pt;
	            
	            double dGridAngle;
	            dAngle = GetAngle(vecPick, cs.vecX(), cs.vecZ(), diameter, dGridAngle);
	        }
	        else if (nGoJig == _kKeyWord)
	        { 
	            if (ssP.keywordIndex() == 0)
	            { 
	            	dAngle = getDouble(T("|Enter angle in degrees|"));
	            	break;
	            }
	            else if (ssP.keywordIndex() == 1)
	            {
	            	pt = getPoint(T("|Select base point|"));
	            	pn=Plane (pt, cs.vecZ());
	            	cs= CoordSys(pt, cs.vecX(), cs.vecY(), cs.vecZ());
	            	pp = PlaneProfile(cs);
	            	mapArgs.setPlaneProfile("pp", pp);	
	            	ssP=PrPoint (T("|Pick point to rotate [Angle/Basepoint/ReferenceLine]|"), pt);
	            }
	            else if (ssP.keywordIndex() == 2)
	            {            	
				//region Show ReferenceLineJig
					PrPoint ssP2(T("|Select point on reference line|")); // second argument will set _PtBase in map

				    int nGoJig2 = -1;
				    while (nGoJig2 != _kOk && nGoJig != _kNone)
				    {
				        nGoJig2 = ssP2.goJig(kJigReferenceLine, mapArgs); 
				        if (bDebug)reportMessage("\ngoJig returned: " + nGoJig2);
				        
				        if (nGoJig2 == _kOk)
				        {
			            	Point3d ptPick =ssP2.value();
			            	Line(ptPick, vecZView).hasIntersection(pn, ptPick);
			            	Vector3d vecXB = ptPick - pt; vecXB.normalize();
			            	cs= CoordSys(pt, vecXB, vecXB.crossProduct(-cs.vecZ()), cs.vecZ());
			            	pp = PlaneProfile(cs);
			            	mapArgs.setPlaneProfile("pp", pp);	
			            	
			            	ssP=PrPoint (T("|Pick point to rotate [Angle/Basepoint/ReferenceLine]|"), pt);
				        }
				        else if (nGoJig2 == _kCancel)
				        { 
				            break;
				        }
				    }			
				//End Show Jig//endregion 
	            }		            
	        }
	        else if (nGoJig == _kCancel)
	        { 
	        	bCancel = true;
	        	break;
	        }
	    }			
	}//End Rotation Jig//endregion 

	// Apply Rotation
		if (!bCancel && abs(dAngle)>0)
		{ 
			PLine plx;
			plx.addVertex(cs.ptOrg());
			plx.addVertex(_Pt0);
			csRot.setToRotation(dAngle, cs.vecZ(), cs.ptOrg());
			_ThisInst.transformBy(csRot);
	
		}
		
	// purge jig plines
	    for (int i=epls.length()-1; i>=0 ; i--) 
	    { 
	    	if (epls[i].bIsValid())
	    		epls[i].dbErase(); 
	    	
	    }//next i		
		
		
		setExecutionLoops(2);
		return;
	}//endregion		
		
	//region Trigger FlipFace
		String sTriggerFlipFace = T("|Flip Face|");
		addRecalcTrigger(_kContextRoot, sTriggerFlipFace );
		if (_bOnRecalc && _kExecuteKey==sTriggerFlipFace)
		{
			CoordSys csRot;
			csRot.setToRotation(180, _XE, ptRot);
			_ThisInst.transformBy(csRot);		
			setExecutionLoops(2);
			return;
		}//endregion	

	//region Trigger Rotate 90°
		String sTriggerRotate90 = T("|Rotate 90°|");
		addRecalcTrigger(_kContextRoot, sTriggerRotate90 );
		if (_bOnRecalc && _kExecuteKey==sTriggerRotate90)
		{
			CoordSys csRot;
			csRot.setToRotation(90, _ZE, ptCOG);
			_ThisInst.transformBy(csRot);		
			setExecutionLoops(2);
			return;
		}//endregion
		
	//region Trigger Rotate 180°
		String sTriggerRotate180 = T("|Rotate 180°|");
		addRecalcTrigger(_kContextRoot, sTriggerRotate180 );
		if (_bOnRecalc && _kExecuteKey==sTriggerRotate180)
		{
			CoordSys csRot;
			csRot.setToRotation(180, _ZE, ptRot);
			_ThisInst.transformBy(csRot);		
			setExecutionLoops(2);
			return;
		}//endregion

	//region Trigger FlipRotate
		String sTriggerFlipRotate = T("|Flip + Rotate|");
		addRecalcTrigger(_kContextRoot, sTriggerFlipRotate );
		if (_bOnRecalc && _kExecuteKey==sTriggerFlipRotate)
		{
			CoordSys csRot;
			csRot.setToRotation(180, _XE, ptRot);
			CoordSys csRot2;
			csRot2.setToRotation(180, _ZE, ptRot);
			csRot.transformBy(csRot2);
			_ThisInst.transformBy(csRot);		
			setExecutionLoops(2);
			return;
		}//endregion	

//endregion 



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
        <int nm="BreakPoint" vl="3845" />
        <int nm="BreakPoint" vl="2445" />
        <int nm="BreakPoint" vl="3845" />
        <int nm="BreakPoint" vl="2445" />
        <int nm="BreakPoint" vl="1378" />
        <int nm="BreakPoint" vl="4107" />
        <int nm="BreakPoint" vl="4102" />
        <int nm="BreakPoint" vl="4966" />
        <int nm="BreakPoint" vl="4318" />
        <int nm="BreakPoint" vl="4251" />
        <int nm="BreakPoint" vl="2374" />
        <int nm="BreakPoint" vl="3579" />
        <int nm="BreakPoint" vl="3819" />
        <int nm="BreakPoint" vl="912" />
        <int nm="BreakPoint" vl="929" />
        <int nm="BreakPoint" vl="3841" />
        <int nm="BreakPoint" vl="2441" />
        <int nm="BreakPoint" vl="3841" />
        <int nm="BreakPoint" vl="2441" />
        <int nm="BreakPoint" vl="1374" />
        <int nm="BreakPoint" vl="4103" />
        <int nm="BreakPoint" vl="4098" />
        <int nm="BreakPoint" vl="4931" />
        <int nm="BreakPoint" vl="4314" />
        <int nm="BreakPoint" vl="4247" />
        <int nm="BreakPoint" vl="2370" />
        <int nm="BreakPoint" vl="3575" />
        <int nm="BreakPoint" vl="3815" />
        <int nm="BreakPoint" vl="908" />
        <int nm="BreakPoint" vl="925" />
        <int nm="BreakPoint" vl="5270" />
        <int nm="BreakPoint" vl="5046" />
        <int nm="BreakPoint" vl="4533" />
        <int nm="BreakPoint" vl="3983" />
        <int nm="BreakPoint" vl="4471" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24005 grip move behaviour imrpoved" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="6/18/2025 11:23:00 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22730 new component display, now also supporting MetalPartCollections" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="2/28/2025 12:42:51 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22730 display componnets dialog prepared (not accessible yet)" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="2/12/2025 5:00:34 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23372 fully supporting new behaviour of controlling properties" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="2/12/2025 11:55:48 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23426 do not consider in any sectional view" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="1/31/2025 12:22:50 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23165 panel element orientation fixed" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="12/19/2024 11:25:06 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23166 bugfix property assignment projection / dimstyle fixed" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="12/19/2024 11:00:49 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23171 bugfix vertical spacer height available during insert" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="12/12/2024 4:51:23 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21818 a new command has been implemented to address and support xref datalinks. The text size issue has been resolved, and xref dimstyles have been declined." />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="12/6/2024 1:26:35 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23089 new property to filter the content of the stack item, ie to exclude sheeting zones being mounted onsite from stacking" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="11/29/2024 3:37:55 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23088 performance improvement when using shape type for metalparts" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="11/29/2024 12:47:27 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22717 element references improved" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="9/24/2024 5:59:52 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21161 on insert invisble items which are not assigned to a parent are made visible." />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="9/17/2024 1:04:45 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22000 insert jig supports vertical/horizontal toggle, alignment corrected if current UCS does not match WCS" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="9/17/2024 12:44:49 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22649 bugfix parent assignment with spacer height" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="9/11/2024 11:34:39 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21998 settings introduced to enable custom color coding" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="8/22/2024 4:29:08 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21681 new property 'Projection Display' to show item boundaries" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="8/20/2024 12:49:15 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21677 jigging imroved, HSB-22468.4 improved, solid detailing improved" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="8/16/2024 5:13:27 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22468.4 new command to rotate item in any of the main axes" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="8/5/2024 3:52:03 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22467 vertical element stacking improved" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="7/29/2024 5:10:55 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22467 vertical element stacking improved" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="7/29/2024 12:36:34 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21677 drag jigs made more transparent" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="6/3/2024 2:01:25 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21994 updating pack when dragging location to update item list" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="5/10/2024 10:22:54 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21973 StackItem written to Datalink subMapX" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="5/8/2024 3:20:16 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20750 low and high resoultion of elements improved, selection set will be filtered on bySelection if elements are selected" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="12/13/2023 3:04:24 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20750 supporting elements" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="12/1/2023 2:52:16 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20724 debug messages removed" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="11/24/2023 12:15:33 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19662 drag behaviour, parent nesting updated" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="11/17/2023 3:47:29 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19659 added dataLink purging, dragging into package improved" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="11/8/2023 4:48:58 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19659 coloring improved, reference link renamed" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="10/24/2023 3:43:17 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19659 first beta release" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="10/18/2023 5:17:41 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19659 renamed, bedding height and auto assignmment improved" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="10/12/2023 5:45:22 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19659 functions unified" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="10/6/2023 5:47:22 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End