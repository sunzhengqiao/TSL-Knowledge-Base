#Version 8
#BeginDescription
#Versions
Version 3.4 10.04.2025 HSB-23577 new command to rotate a package
Version 3.3 12.02.2025 HSB-23372 fully supporting new behaviour of controlling properties
Version 3.2 19.12.2024 HSB-23169 pack height fixed
Version 3.1 22.11.2024 HSB-21733 supports relocation of attached spacers when moved, Z-Filter bugfix when using sectional grips
Version 3.0 24.09.2024 HSB-22717 element references improved
Version 2.9 17.09.2024 HSB-21161 debug messages removed
Version 2.8 22.08.2024 HSB-21998 settings introduced to enable custom color coding
Version 2.7 16.08.2024 HSB-21677 jigging items improved
Version 2.6 02.08.2024 HSB-22468 visibilty improved, dragging in plan view turns Z-filtering on
Version 2.5 17.07.2024 HSB-21811 A new property 'Number' has been added. The number can be used for formatting and specifies a fixed unique number
Version 2.4 21.06.2024 HSB-22001 new custom command to toggle between raw and shrink package size
Version 2.3 03.06.2024 HSB-21677 drag jigs made more transparent
Version 2.2 10.05.2024 HSB-21994 item list ordered by layer index
Version 2.1 08.01.2024 HSB-20285 tag does not contribute to snap points anymore
Version 2.0 22.12.2023 HSB-20893 catching tolerance issue in hidden mode
Version 1.9 01.12.2023 HSB-20750 debug message removed
Version 1.8 24.11.2023 HSB-20724 bugfix model display
Version 1.7 24.11.2023 HSB-20724 supports automatic layer nesting as context command
Version 1.6 17.11.2023 HSB-19662 drag behaviour improved when stacked and packed
Version 1.5 08.11.2023 HSB-19659 color updating enhanced, grip color changed
Version 1.4 24.10.2023 HSB-19659 reference link renamed
Version 1.3 18.10.2023 HSB-19659 first beta release
Version 1.2 12.10.2023 HSB-19659 data export added 
Version 1.1 06.10.2023 HSB-19659 dragging behaviour improved
Version 1.0 29.09.2023 HSB-19659 initial version
























#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 3
#MinorVersion 4
#KeyWords 
#BeginContents
//region Part #A

//region <History>
// #Versions
// 3.4 10.04.2025 HSB-23577 new command to rotate a package , Author Thorsten Huck
// 3.3 12.02.2025 HSB-23372 fully supporting new behaviour of controlling properties , Author Thorsten Huck
// 3.2 19.12.2024 HSB-23169 pack height fixed , Author Thorsten Huck
// 3.1 22.11.2024 HSB-21733 supports relocation of attached spacers when moved, Z-Filter bugfix when using sectional grips , Author Thorsten Huck
// 3.0 24.09.2024 HSB-22717 element references improved , Author Thorsten Huck
// 2.9 17.09.2024 HSB-21161 debug messages removed , Author Thorsten Huck
// 2.8 22.08.2024 HSB-21998 settings introduced to enable custom color coding , Author Thorsten Huck
// 2.7 16.08.2024 HSB-21677 jigging items improved , Author Thorsten Huck
// 2.6 02.08.2024 HSB-22468 visibilty improved, dragging in plan view turns Z-filtering on , Author Thorsten Huck
// 2.5 17.07.2024 HSB-21811 A new property 'Number' has been added. The number can be used for formatting and specifies a fixed unique number , Author Thorsten Huck
// 2.4 21.06.2024 HSB-22001 new custom command to toggle between raw and shrink package size , Author Thorsten Huck
// 2.3 03.06.2024 HSB-21677 drag jigs made more transparent , Author Thorsten Huck
// 2.2 10.05.2024 HSB-21994 item list ordered by layer index , Author Thorsten Huck
// 2.1 08.01.2024 HSB-20285 tag does not contribute to snap points anymore , Author Thorsten Huck
// 2.0 22.12.2023 HSB-20893 catching tolerance issue in hidden mode , Author Thorsten Huck
// 1.9 01.12.2023 HSB-20750 debug message removed , Author Thorsten Huck
// 1.8 24.11.2023 HSB-20724 bugfix model display , Author Thorsten Huck
// 1.7 24.11.2023 HSB-20724 supports automatic layer nesting as context command , Author Thorsten Huck
// 1.6 17.11.2023 HSB-19662 drag behaviour improved when stacked and packed , Author Thorsten Huck
// 1.5 08.11.2023 HSB-19659 color updating enhanced, grip color changed , Author Thorsten Huck
// 1.4 24.10.2023 HSB-19659 reference link renamed , Author Thorsten Huck
// 1.3 18.10.2023 HSB-19659 first beta release , Author Thorsten Huck
// 1.2 12.10.2023 HSB-19659 data export added , Author Thorsten Huck
// 1.1 06.10.2023 HSB-19659 dragging behaviour improved , Author Thorsten Huck
// 1.0 29.09.2023 HSB-19659 initial version , Author Thorsten Huck

/// <insert Lang=en>
/// Select entities
/// </insert>

// <summary Lang=en>
// This tsl creates 
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "StackPack")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|"))) TSLCONTENT
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
	int navy = rgb(114,116,48);	
	int darkcyan = rgb(36,188,181);
	Vector3d vecXView = getViewDirection(0);
	Vector3d vecYView = getViewDirection(1);
	Vector3d vecZView = getViewDirection(2);
	double dViewHeight = getViewHeight();	
//endregion 	


	String sDefinitions[] = TruckDefinition().getAllEntryNames();
	String sTruckDefinitionPropertyName=T("|Definition|"); // used to query the truck definition name from property of tsl
	String sTruckDescriptionPropertyName=T("|Description|"); // used to query the truck definition name from property of tsl

	String kTruckParent = "hsb_TruckParent";
	String kTruckChild = "hsb_TruckChild";
	String kPackageParent = "hsb_PackageParent";
	String kPackageChild = "hsb_PackageChild";

	String sPainterCollection = "TSL\\Stacking\\";
	String tAscending = T("|Ascending|"), tDescending = T("|Descending|");
	String kCallNester = "CallNester";
	String tVertical = T("|Vertical|"), tHorizontal = T("|Horizontal|");
	String kLayerIndexPack = "LayerIndexPack", kLayerSubIndexPack = "LayerSubIndexPack",kLayerIndexStack = "LayerIndexStack", kLayerSubIndexStack = "LayerSubIndexStack";
	String tCRbyPackLayer=T("|byLayer|"), tCRbyPackNumber=T("|byPackNumber|"), tCRbyStackIndex= T("|byStackLayer|"), tColorRules[] ={ tCRbyPackLayer, tCRbyPackNumber, tCRbyStackIndex};


	String kDataLink = "DataLink", kData="Data", kScriptItem="StackItem", kScriptPack="StackPack", kScriptStack="StackEntity";
	String sParentScripts[] = {kScriptStack};
	String sChildScripts[] = {kScriptItem};
	String tLengthName= T("|Length|"), tWidthName=T("|Width|"), tHeightName = T("|Height|");

	CoordSys csX(_Pt0,_YW,_ZW,_XW);	
	CoordSys csY(_Pt0, -_XW ,_ZW, _YW);
	CoordSys csZ(_Pt0,_XW,_YW,_ZW);
	CoordSys css[] ={ csX, csY, csZ};
	Vector3d vecDirs[] ={ csX.vecZ(), csY.vecZ(), csZ.vecZ()};
	double dBoxDims[] = { U(13600) , U(2480), U(3000)};
	String kDirKeys[] = { "X_", "Y_", "Z_"};
	String kGripTagPlan = "Tag";
	String kRawPack = "RawPack";

	int nColorStack = grey;
	
	Display dp(-1),dpPlan(-1),dpModel(-1),dpRed(-1), dpWhite(-1),dpJig(-1), dpText(-1), dpOverlay(-1), dpInvisible(-1);
	dpWhite.trueColor(rgb(255, 255, 254), 60);
	dpWhite.showDuringSnap(false);
	dpText.showDuringSnap(false);
	
	dpModel.addHideDirection(_ZW);
	dpModel.addHideDirection(-_ZW);
	
	dpPlan.addViewDirection(_ZW);
	dpPlan.addViewDirection(-_ZW);

	dpInvisible.addViewDirection(-_ZW);
	_ThisInst.setDrawOrderToFront(80);
	_ThisInst.setSequenceNumber(2);
	//reportNotice("\nStarting " + _ThisInst.scriptName() + " " + _ThisInst.handle());
//end Constants//endregion


//region DialogMode
	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode>0)
	{ 
		
	// Display Settings	
		if (nDialogMode == 2) // specify index when triggered to get different dialogs
		{
			setOPMKey("Settings");	
			
			String info = T(" |The color index which will be returned maybe used as index for sequential color assignments if the correspnding definition exists.|");
	
		category = T("|Item|");
			String sColorRuleName=T("|Color Rule|");	
			PropString sColorRule(nStringIndex++, tColorRules, sColorRuleName);	
			sColorRule.setDescription(T("|Defines how items will be colored in model|")+info);
			sColorRule.setCategory(category);


		category = T("|Pack|");
			String sColorRulePackName=T("|Color Rule|");	
			tColorRules.removeAt(0);
			PropString sColorRulePack(nStringIndex++, tColorRules, sColorRulePackName);	
			sColorRulePack.setDescription(T("|Defines how packs will be colored in model|")+info);
			sColorRulePack.setCategory(category);


		}		
		
		
		return;		
	}
//End DialogMode//endregion




//End Part #A //endregion





//region FUNCTIONS #FU

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

//region Function GetSimplePLineBody
	// returns a simple body by an infinite extrusion of 2 orthogonal plines and intersecting them
	Body GetSimplePLineBody(PLine pl1, PLine pl2)
	{ 
		Vector3d vecZ1 = pl1.coordSys().vecZ();
		Vector3d vecZ2 = pl2.coordSys().vecZ();
		if (!vecZ1.isPerpendicularTo(vecZ2))
		{ 
			reportMessage(TN("|Unexpected error| ") + "Pack.GetSimplePLineBody: " + T("|Polylines not orthogonal.|"));
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

	//endregion

	//region Other Functions


//region Function CreateJigEpls
	// returns
	EntCircle[] CreateJigCircles(Point3d pts[], double radius, Vector3d vecN, int color, int transparency)
	{ 
		Map mapX;
		mapX.setInt("isJig", true);		
		
		EntCircle circles[0];
    	for (int p=0;p<pts.length();p++) 
    	{ 
    		EntCircle c;
    		c.dbCreate(pts[p], vecN,radius );
    		if (color>256)
	    		c.setTrueColor(color);
    		else
    			c.setColor(color);
			c.setSubMapX("Jig", mapX);
			circles.append(c);
    	}//next r		
		
		return circles;
	}//endregion

////region Function CreateJigEpls
//	// returns
//	void CreateJigEpls(PLine plines, EntCircle)
//	{ 
//		int color = 1;
//		int transparency = 20;
//
//		Map mapX;
//		mapX.setInt("isJig", true);		
//		return;
//	}//endregion


//region Function PurgeJigs
	// purges the entplines or entCircles which tagged as jigs from model
	void PurgeJigs()
	{ 
		Entity ents[] = Group().collectEntities(true, EntPLine(), _kModelSpace, false);
		ents.append(Group().collectEntities(true, EntCircle(), _kModelSpace, false));
		
		//reportNotice("\nPurgeJigs: " + ents.length());
    	for (int i=ents.length()-1; i>=0 ; i--) 
	    	if (ents[i].bIsValid())
	    		if (ents[i].subMapX("Jig").getInt("isJig"))
		    		ents[i].dbErase(); 			
		
		return;
	}//endregion

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

	//region Function FindNextFreeNumber
	// returns the next free number starting from the given value
	// nStart: the start number
	int FindNextFreeNumber(int nStart)
	{ 
		int out = nStart<=0?1:nStart;
		
		Entity ents[0];
		String names[] ={ (bDebug ? "StackEntity" : scriptName())};
		TslInst stacks[] = FilterTslsByName(ents, names);
		
	// get existing indices
		int numbers[0];
		for (int i = 0; i < stacks.length(); i++)
		{
			int n = stacks[i].propInt(0);
			if (n>0 && n>=nStart && numbers.find(n)<0)
				numbers.append(n);
		}
		numbers = numbers.sorted();
		
		//reportNotice("\nNumbers: " + numbers);
			
		for (int i=0;i<numbers.length();i++) 
			if (numbers[i]==out)
				out++;
		
		return out;
	}//endregion

	//region Function GetNumbers
	// returns the amount of appearances of the given number and the array of numbers in use
	// t: the tslInstance to 
	int GetNumbers(TslInst stacks[], int& numbers[], int number )
	{ 

	// Validate number
		numbers.setLength(stacks.length());
		for (int i = 0; i < stacks.length(); i++)
			numbers[i]=stacks[i].propInt(0);

		int num;
		for (int i=0;i<numbers.length();i++) 
			if (numbers[i]==number)
				num++; 

		return num;
	}//endregion

	//region Function GetBoxDimneions
	// sets dimensions of the bounding box of a raw package
	void GetBoxDimensions(Map map, double& sizes[])
	{ 
		sizes.setLength(3);
		String k;
		{k = "dXRaw"; double d = map.getDouble(k); if (d > 0)sizes[0] = d;}
		{k = "dYRaw"; double d = map.getDouble(k); if (d > 0)sizes[1] = d;}
		{k = "dZRaw"; double d = map.getDouble(k); if (d > 0)sizes[2] = d;}
		return;
	}//endregion

//endregion 

	//region Function runNester
	// returns
	// t: the tslInstance to 
	void runNester(NesterCaller& nester, PlaneProfile ppMaster, int& nMasterIndices[], int& nLeftOverChilds[], NesterData nd)
	{ 
		NesterMaster nm(_ThisInst.handle(), ppMaster);
		nester.addMaster(nm);	

		int nSuccess = nester.nest(nd, true);
		if (bDebug)reportMessage("\n\n	NestResult: "+nSuccess);
		if (nSuccess!=_kNROk) 
		{
			reportNotice("\n" + scriptName() + ": " + T("|Not possible to nest|"));
			if (nSuccess==_kNRNoDongle)
				reportNotice("\n" + scriptName() + ": " + T("|No dongle present|"));
			setExecutionLoops(2);
			return;
		}		

		nMasterIndices = nester.nesterMasterIndexes();	
		nLeftOverChilds = nester.leftOverChildIndexes();

		return ;
	}//End runNester //endregion	

	//region Function getGroupedProfiles
	// groups planeprofiles which have an intersection in _YW and assigns the group indices
	PlaneProfile[] getGroupedProfiles(PlaneProfile& pps[], int& nInds[], Entity& ents[])
	{ 
		Point3d pts[0];
		for (int i=0;i<pps.length();i++) 
		{ 
			PlaneProfile pp = pps[i]; 
			pts.append(pp.ptMid() - _XW * .5 * pp.dX());
		}//next i
		
	// order horizontally
		for (int i=0;i<pts.length();i++) 
			for (int j=0;j<pts.length()-1;j++) 
			{
				double d1 = _XW.dotProduct(pts[j]-_Pt0);
				double d2 = _XW.dotProduct(pts[j+1]-_Pt0);				
				if (d2<d1)
				{ 
					pts.swap(j, j + 1);
					pps.swap(j, j + 1);
					ents.swap(j, j + 1);
				}
			}
		
	// build groups which intersect in Y-Dir
		PlaneProfile ppGroups[0];
		nInds.setLength(0); // indicating to which group the profile belongs
		for (int i = 0; i < pps.length(); i++)
		{
			PlaneProfile pp = pps[i];
			if (i==0)
			{ 
				nInds.append(0);
				ppGroups.append(pp);
				continue;
			}
			PlaneProfile& ppg = ppGroups.last();
			Vector3d vec = .5 * _XW * ppg.dX() + _YW*(U(10e5));
			PlaneProfile ppx;
			ppx.createRectangle(LineSeg(ppg.ptMid() - vec, ppg.ptMid() + vec), _XW, _YW);
			
			if (ppx.intersectWith(pp))
				ppg.unionWith(pp);
			else
				ppGroups.append(pp);				
			nInds.append(ppGroups.length()-1);
		}

		return ppGroups;
	}//End getGroupedProfiles //endregion

	//region Function setPackageChildRef
	// returns and sets the submapX packageChild
	// t: the child tslInstance
	// parent: the parent tslInstance (pack)
	Map setPackageChildRef(TslInst t, TslInst parent)
	{ 
		Map mapX = t.subMapX(kPackageChild);		
		mapX.setString("ParentUid", parent.uniqueId());
		mapX.setString("ParentHandle", parent.handle());
		
		CoordSys csParent = parent.coordSys();		
		CoordSys csChild = t.coordSys();
		
		CoordSys csChildRel;
		csChildRel.setToAlignCoordSys(
			csParent.ptOrg(), csParent.vecX(), csParent.vecY(), csParent.vecZ(),
			csChild.ptOrg(), csChild.vecX(), csChild.vecY(), csChild.vecZ());
		mapX.setPoint3d("ptRelOrg", csChildRel.ptOrg(), _kAbsolute);
		mapX.setPoint3d("ptVecX", csChildRel.ptOrg() + csChildRel.vecX(), _kAbsolute);
		mapX.setPoint3d("ptVecY", csChildRel.ptOrg() + csChildRel.vecY(), _kAbsolute);
		mapX.setPoint3d("ptVecZ", csChildRel.ptOrg() + csChildRel.vecZ(), _kAbsolute);

		t.setSubMapX(kPackageChild,mapX);	
		return mapX;
	}//End setPackageChildRef //endregion

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
	// draws a boxed text as overlay
	void DrawTag(String text, Point3d ptLoc, String dimStyle, double textHeight, Display display)
	{ 
		PLine plBox;
		if (text.length()>0)
		{ 
			double dXTxt = display.textLengthForStyle(text, dimStyle, textHeight);
			double dYTxt = display.textHeightForStyle(text, dimStyle, textHeight);
			
			Vector3d vec = .5 * (_XW * dXTxt - _YW * dYTxt);
			Vector3d vecTrans = -_XW*.5*dXTxt;
			//vecTrans= .3 * textHeight*(_XW - _YW);
			ptLoc.transformBy(vecTrans);
	
			plBox.createRectangle(LineSeg(ptLoc-vec, ptLoc+vec), _XW, _YW);
			plBox.offset(textHeight * .3, true);

			dpWhite.draw(PlaneProfile(plBox), _kDrawFilled, 20);
			dpText.draw(text, ptLoc, _XW, _YW, 0 ,0);
		}	
	}//endregion


//	//region Function drawShadow
//	// returns
//	// t: the tslInstance to 
//	void DrawBodyShadow(Body bd, Vector3d vecView, double offset, int rgb, int transparencyWire, int transparency, Display display)
//	{ 
//	    if (rgb<256)	display.color(rgb);
//	    else			display.trueColor(rgb);	
//	    int bDrawFilled = transparency > 0?_kDrawFilled:0;
//	    Plane pn(bd.ptCen(), vecView);
//	    PlaneProfile pp = bd.shadowProfile(pn);
//	    
//	    display.draw(pp, bDrawFilled, transparency);
//	    if (abs(offset)>dEps)
//	    { 
//	    	PlaneProfile pp2 = pp;
//	    	if (offset>0)	pp.shrink(offset);
//	    	else			pp2.shrink(offset);
//	    	pp.subtractProfile(pp2);
//	    }
//	    
//	    display.draw(pp, bDrawFilled, transparency);
//	    display.transparency(transparencyWire);
//	    display.draw(bd);  
//	}//End drawShadow //endregion	

//region Function DrawBody
	// draws a body
	// bd: the body to be drawn
	// transparencyWire:
	// display:
	void DrawBody(Body bd, int rgb, int transparencyWire, Display display)
	{ 
	    if (rgb<256)	display.color(rgb);
	    else			display.trueColor(rgb);	
	    display.transparency(transparencyWire);
	    display.draw(bd);  
	}//endregion

//region Function DrawPLine
	// draws a pline
	void DrawPLine(PLine pline, Vector3d vecTrans, int rgb,int transparencyWire, int transparency,Display display)
	{ 
	    if (rgb>255)		display.trueColor(rgb);		    
	    else if (rgb>-1)	display.color(rgb);

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
	}//endregion

//region Function getGripIndexByName
	// returns the grip index if found in array of grips
	// name: the name of the grip
	int getGripIndexByName(Grip grips[], String name)
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
	}//End getGripIndexByName //endregion

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


//region Function DrawPLines
	// draws plines 
	void DrawPLines(PLine plines[], Vector3d vecTrans, int rgb, int transparencyWire, int transparency)
	{ 
		Display dp(-1);
	    if (rgb<256)   	
	    	dp.color(rgb);
	    else	    	
	    	dp.trueColor(rgb);

		
	    int bDrawFilled = transparency>0;	
		dp.transparency(transparencyWire);
		
	    for (int i=0;i<plines.length();i++) 
	    { 
	    	PLine& pl = plines[i];
	    	Vector3d vecZ = pl.coordSys().vecZ();
	    	if (!vecTrans.bIsZeroLength())
	    		pl.transformBy(vecTrans);
	    	
	    	if (vecZ.isParallelTo(_ZW))
	    	{ 
	    		dp.addHideDirection(_XW);
	    		dp.addHideDirection(-_XW);
	    		dp.addHideDirection(_YW);
	    		dp.addHideDirection(-_YW);	    		
	    	}
	    	else 
	    	{ 
	    		dp.addViewDirection(vecZ);
	    		dp.addViewDirection(-vecZ);    		
	    	}	    	

	    	dp.transparency(transparency);
	    	
	    	if (bDrawFilled)
	    		dp.draw(PlaneProfile(pl), _kDrawFilled); 
			dp.transparency(transparencyWire);
	    	dp.draw(pl); 
	    }//next i
	    return;
	}//endregion


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
	    		display.draw(bd);	    	
	    	 
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
		
		dp.draw(pl);
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
	void DrawSnap(PlaneProfile pp, double thickness, Vector3d vecTrans, int rgb, int transparency, Display display)//, TslInst parent
	{ 
		pp.transformBy(vecTrans);
		PlaneProfile pp1 = pp;
		pp.shrink(-thickness);
		pp.subtractProfile(pp1);

	    if (rgb<256)	display.color(rgb);
	    else			display.trueColor(rgb);	
	    
	    if(transparency>0 && transparency<100)
		    display.draw(pp, _kDrawFilled,transparency);     
	    display.transparency(0);
	    display.draw(pp);

	    return;
	}//endregion	

//region Function DrawWireframe
	// draws the wireframe of a pack 
	// bd: the body to be drawn
	// vecTrans: the transformation from the defined location
	void DrawWireframe(Body bd, Vector3d vecTrans, int rgb, int transparencyWire, int transparency)
	{ 
	    bd.transformBy(vecTrans);
	    if (bd.isNull())
	    { 
	    	reportMessage("\n"+ scriptName() + T("|unexpected error|"));
	    	return;
	    }
	    Point3d ptsX[] = bd.extremeVertices(_XW);
	    Point3d ptsY[] = bd.extremeVertices(_YW);
	    Point3d ptsZ[] = bd.extremeVertices(_ZW);
	    
	    
	    PlaneProfile pps[0];
	    for (int i=0;i<ptsZ.length();i++) 
	    { 
	    	if (i==0)
	    		pps.append(bd.shadowProfile(Plane(ptsZ[i], _ZW)));
	    	else
	    		pps.append(bd.extractContactFaceInPlane(Plane(ptsZ[i], _ZW),dEps));	    			    	 
	    }//next i
		for (int i=0;i<ptsX.length();i++) 
	    	pps.append(bd.extractContactFaceInPlane(Plane(ptsX[i], _XW),dEps));	 	    
		for (int i=0;i<ptsY.length();i++) 
	    	pps.append(bd.extractContactFaceInPlane(Plane(ptsY[i], _YW),dEps));	    		
	    
	    //Display dp(-1);
	    dp.trueColor(rgb, transparency);
	    for (int i=0;i<pps.length();i++)
	    { 
	    	PlaneProfile pp = pps[i];
	    	if (pp.coordSys().vecZ().isParallelTo(_ZW))
		    {
		    	dp.draw(pp, _kDrawFilled);
		    	dp.transparency(transparencyWire);
		    }
		    dp.draw(pp);
	    }	
	}//endregion

	//END Draw Functions //endregion 


//region Function GetSequencesInDir
	// returns the sequence indices in the given direction and modifies the given layer grid locations
	int[] GetSequencesInDir(Vector3d vecDir, TslInst childs[], Body bodies[], Point3d& ptsDir[])
	{ 
		int indices[childs.length()];
		Plane pn(_Pt0, vecDir);
		
	// collect first point in direction per child	
		Point3d ptsC[0];
		for (int i = 0; i < bodies.length(); i++)
		{ 
			Body& bd = bodies[i];
			Point3d pts[]=bd.extremeVertices(vecDir);
			if (pts.length() > 0)
				ptsC.append(pts.first());
			else 
				ptsC.append(_Pt0); // should not happen
		}		

	// order all collected points, remove duplicates and store in map	
		Line ln(_Pt0, vecDir);
		ptsDir = ln.orderPoints(ln.projectPoints(ptsC), dEps);
		for (int j=0;j<ptsDir.length();j++) 
		{
			Point3d pt = ptsDir[j]+(vecDir.crossProduct(-_ZW)*U(50));
			pt.vis(40);
		}
	// compare layer locations with each body point	
		for (int i=0;i<ptsC.length();i++) 				
		{ 
			// index i refers to the body
			for (int j=0;j<ptsDir.length();j++) 
			{ 
				double d = abs(vecDir.dotProduct(ptsDir[j]-ptsC[i]));
				if (d<dEps)
				{ 
					indices[i] = j;
					break;
				}
			}//next j				 
		}//next i
		return indices;
	}//endregion


//region Function GetLayerIndices
	// loops through the orthogonal world view directions, and returns the order of the bodies in the corresponding direction
	Map GetLayerIndices(Body bodies[], int& nXLayers[], int& nYLayers[], int& nZLayers[])
	{ 
		Map mapOut;
	
		for (int v=0;v<css.length();v++) 
		{ 

			Vector3d vecZ = css[v].vecZ(); 
			Plane pn(_Pt0, vecZ);
			
		// collect first point in direction per child	
			Point3d ptsC[0];
			for (int i = 0; i < bodies.length(); i++)
			{ 
				Body& bd = bodies[i];
				Point3d pts[]=bd.extremeVertices(vecZ);
				if (pts.length() > 0)
					ptsC.append(pts.first());
				else 
					ptsC.append(_Pt0);
			}
			
		// order all collected points and store in map	
			Line ln(_Pt0, vecZ);
			Point3d ptsDir[] = ln.orderPoints(ln.projectPoints(ptsC), dEps);
			mapOut.setPoint3dArray(kDirKeys[v],ptsDir);
			//if (ptsDir.length()>0)vecZ.vis(ptsDir.first(), v + 1);
			
		// compare layer locations with each body point	
			for (int i=0;i<ptsC.length();i++) 				
			{ 
				// index i refers to the body
				for (int j=0;j<ptsDir.length();j++) 
				{ 
					double d = abs(vecZ.dotProduct(ptsDir[j]-ptsC[i]));
					if (d<dEps)
					{ 
						if (v == 0)nXLayers[i] = j;
						else if (v == 1)nYLayers[i] = j;
						else if (v == 2)nZLayers[i] = j;
						
						//if (v==2)vecZ.vis(bodies[i].ptCen(),j); // matches the index
						break;
					}
					 
				}//next j				 
			}//next i

			
		}//next v
		
		
		
		
		return mapOut;
	}//endregion

//region Function GetItemShadowMap
	// 
	Map GetItemShadowMap(Entity entsX[])
	{
		Map mapOut;
		PlaneProfile pp(CoordSys());
		Map mapBodies;
		Point3d ptsZ[0];
		for (int i=0;i<entsX.length();i++) 
		{
			Entity e = entsX[i];
			GenBeam g = (GenBeam)e;
			Body bd;
			if (g.bIsValid())
				bd = g.envelopeBody(false, true);
			else
				bd = e.realBody(_XW+_YW+_ZW);
			
			if (!bd.isNull())
			{ 
				ptsZ.append(bd.extremeVertices(_ZW));
				mapBodies.appendBody("bd", bd); 
				pp.unionWith(bd.shadowProfile(Plane(_PtW, _ZW)));
			}			
		}
		ptsZ = Line(_PtW, _ZW).orderPoints(ptsZ, dEps);
		mapOut.appendMap("Body[]", mapBodies);
		if (ptsZ.length()>0)
			pp.transformBy(_ZW * _ZW.dotProduct(ptsZ.first() - _PtW));
		mapOut.setPlaneProfile("pp", pp);	
		
		return mapOut;
	}//endregion 

//region Function GetProfileHull
	// returns a polyline of a planeprofile by an iteration of blowup and shrinks
	PLine GetProfileHull(PlaneProfile pp)
	{ 
		PLine out;
		
//		if (pp.area()<pow(dEps,2))
//		{ 
//			reportNotice("\nGetProfileHull: " + T("|unexpected error, profile is empty|"));
//			return out;
//		}
	
	
	// smoothen the profile
		pp.removeAllOpeningRings();		
		PLine rings[] = pp.allRings();
		if (rings.length()>0)
			out = rings[0];
		pp.removeAllRings();
		//pp.vis(2);
		for (int r=0;r<rings.length();r++) 
		{ 
			PLine& pl = rings[r];
			pl.simplify();
			//pl.reconstructArcs(dEps, 80); 
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
				//ppt.vis(cnt);
				rings = ppt.allRings(true, false);
				cnt++;
			}
			if (rings.length()>0 && rings.first().length()>dEps)
				out = rings[0];
		}
		
		if (rings.length()>0 && rings.first().length()>dEps)
			out = rings[0];
		

		return out;
	}//End GetProfileHull //endregion

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

	//region Function getGripByName
	// returns the grip index if found in array of grips
	// name: the name of the grip
	int getGripByName(Grip grips[], String name)
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
	}//End getGripByName //endregion

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
					//ppx.vis(3);
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
			
			PlaneProfile ppShapeY = m.getPlaneProfile("ShapeY");
			PlaneProfile ppShapeZ = m.getPlaneProfile("ShapeZ");
			CoordSys cs1= ppShapeY.coordSys();
			CoordSys cs2= ppShapeZ.coordSys();
			//reportNotice("\n" + cs1 + "\n" + cs2);
			Point3d pt1 = ppShapeY.ptMid();
			Point3d pt2 = ppShapeZ.ptMid();
			
			PLine pl2; pl2.createRectangle(ppShapeZ.extentInDir(cs2.vecX()), cs2.vecX(), cs2.vecY());

			// make sure rectangle has same X-dim as pl2
			pt1+=cs2.vecX()*cs2.vecX().dotProduct(pt2-pt1);
			Vector3d vec1 =.5*(cs1.vecX() * ppShapeZ.dX() + cs1.vecY() * ppShapeY.dY());
			PLine pl1; pl1.createRectangle(LineSeg(pt1-vec1, pt1+vec1), cs1.vecX(), cs1.vecY());
//
//				Display dpx(2);
//				dpx.draw(pl1);


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
		
	}//endregion 

//region Function findIntersectingParent
	// collects all parent tsls which intersect with the profile 'shape'
	// if an intersection could be found the max intersection instance will be returned
	// ppMax: the profile of the largest intersection
	// ppOthers: the profiles which do not intersect or not ppMax
	TslInst findIntersectingParent(Map mapParents[], PlaneProfile shape, PlaneProfile& ppMax, PlaneProfile& ppOthers[])
	{ 
		PlaneProfile pps[0];
		int indices[0];
		double areas[0];
		Entity entsX[0];

		for (int i = 0; i < mapParents.length(); i++)
		{
			Map m = mapParents[i];
			Entity ent = m.getEntity("ent");
			TslInst t = (TslInst)ent;
			
			PlaneProfile ppLoads[] = getLoadProfiles(t, PlaneProfile());// TODO use ppIntersect instead
			for (int j=0;j<ppLoads.length();j++) 
			{ 
				PlaneProfile ppx,ppi = ppLoads[j];
				ppx = ppi;
				ppx.intersectWith(shape);
				double area = ppx.area();
				//reportNotice("\n" +t.handle() +" load j " + j + " reports area " + area);
				if (area > pow(dEps, 2))
				{
					pps.append(ppi);
					areas.append(area);
					indices.append(i);
					entsX.append(ent);
				}									 
			}//next j			
		}//next i
			
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
//			Map m;
//			m.setEntity("ent", entsX[i]);
//			m.setPlaneProfile("pp", pps[i]);
//			mapOut.appendMap("pack", m);
			
			if (i==0)
			{
				ppMax = pps[i];
				out = (TslInst)entsX.first();
			}
			else
				ppOthers.append(pps[i]);
			
		}
		//reportNotice("\nfindIntersectingParent:" + out.handle());
		return out;
	}//endregion

//region Function ReleaseParent
	// releases the nestingChild info from a parent and resets the _Entity array of the parent
	// returns true if succeeded
	// parent: the parent nesting entity
	// child: the child nesting entity
	int ReleaseParent(Entity entParent, Entity entChild)
	{ 
		int debug = false;
		if (debug)reportNotice("\nCalling ReleaseParent:");
		int out;
		TslInst parent = (TslInst)entParent;
		TslInst child = (TslInst)entChild;

		if (!parent.bIsValid() || !child.bIsValid() )
		{
			if(debug)reportNotice("\nPACK.ReleaseParent: parent/child valid " + parent.bIsValid() + !child.bIsValid());
			return out;
		}

		
		Entity childs[] = parent.entity();
		int n = childs.find(child);
		
		if (n>-1)
		{ 
			int bChildIsItem = child.scriptName().find(kScriptItem, 0, false) >- 1;
			int bChildIsPack = child.scriptName().find(kScriptPack, 0, false) >- 1;
			
			int bParentIsPack = parent.scriptName().find(kScriptPack, 0, false) >- 1;
			int bParentIsStack = parent.scriptName().find(kScriptStack, 0, false) >- 1;
			
			if (bParentIsPack || bParentIsStack)
			{ 
				if (bParentIsPack)child.removeSubMapX(kPackageChild);
				if (bParentIsStack)child.removeSubMapX(kTruckChild);//TODO
	
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
				
				String text = "\nReleaseParent: " + child.formatObject("@(ScriptName) @(Description)") + " released from " + parent.formatObject("@(ScriptName) @(Description)");
				if(debug)reportNotice(text);
				//reportNotice("\n" + child.handle() + " to be removed from "+ parent.formatObject("@(ScriptName) @(Description)") + parent.handle()+" new childs set " + parent.entity().length());
				
				out = true;				
			}

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
			//reportNotice("\n" +child.handle() + " added as new child to parent "+ parent.handle() + " with subset " + parent.entity().length());
			
			out = true;
		}
		else if (bDebug)
		{ 
			reportNotice("\n" +child.handle() + " already linked to parent "+ parent.handle() + " with subset " + parent.entity().length());
		}
		return out;
	}//endregion 

//region PlaneProfile UnionTry Functions

	//region Function UnionWithBridges
	// returns
	// t: the tslInstance to 
	void UnionWithBridges(PlaneProfile& ppMax,PlaneProfile pps[])
	{ 
		CoordSys cs = ppMax.coordSys();
		Plane pn(cs.ptOrg(), cs.vecZ());
		PlaneProfile ppBridges[0];
		for (int i=0;i<pps.length();i++) 
		{ 
			for (int j=i+1;j<pps.length();j++) 
			{ 
				PlaneProfile ppi= pps[i]; 
				PlaneProfile ppj= pps[j]; 
				
				ppi.shrink(-dEps);
				ppj.shrink(-dEps);
				
				if (ppi.intersectWith(ppj))
				{ 
					//ppi.vis(i);
					
					PlaneProfile ppai = ppi;
					ppai.intersectWith(pps[i]);
					//ppai.vis(i);
					
					PlaneProfile ppaj = ppi;
					ppaj.intersectWith(pps[j]);
					//ppaj.vis(j);				
					
					Point3d pts[0];
					pts.append(ppai.getGripVertexPoints());
					pts.append(ppaj.getGripVertexPoints());
					
					PLine hull;
					hull.createConvexHull(pn, pts);
					//hull.vis(j);
					
					PlaneProfile ppBridge(cs);
					ppBridge.joinRing(hull, _kAdd);
					ppMax.unionWith(ppBridge);
				}
			}//next j
	
		}//next i
		
		
		
		return;

	}//endregion

	//region Function UnionTry
	// returns true or false if the unification was successful and modifies the first argument wit the resulting pp
	// t: the tslInstance to 
	int UnionTry(PlaneProfile& ppUnion, PlaneProfile pp)
	{ 
		int out;
		
		PlaneProfile ppa = ppUnion;
		PlaneProfile ppb = pp;	
		ppb.shrink(-dEps);
		
		double areaUnion = ppUnion.area();
		if (areaUnion<pow(dEps,2))
		{ 
			ppUnion = pp;
			out= true;			
		}

		else if (ppb.intersectWith(ppa))
		{ 
			ppb = pp;
			ppa.shrink(-dEps);
			ppb.shrink(-dEps);
			ppa.unionWith(ppb);
			ppa.shrink(dEps);
		}
		else
		{
			ppb = pp;
			ppa.unionWith(ppb);
		}
		if (ppa.area()>pow(dEps,2) && ppa.area()>areaUnion)
		{ 
			ppUnion = ppa;
			out= true;				
		}	

		return out;
	}//endregion

	//region Function SimplifyMax
	// returns
	// t: the tslInstance to 
	void SimplifyMax(PlaneProfile ppMax)
	{ 
		PLine rings[] = ppMax.allRings(true, false);
		ppMax.removeAllRings();	
		for (int r=0;r<rings.length();r++) 
		{ 
			PLine pl = rings[r];
			pl.simplify();
			ppMax.joinRing(pl,_kAdd);
		}//next r
		return;
	}//endregion

//endregion 




//END Functions //endregion 


//region Part #B

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
	
//region Read Settings
	int nColorRule=0; //byLayer
	int nColorRulePack=1; //byPackNumber
	int nColorPack = darkcyan, ntWire = 60, ntFill = 60, ntStackedWire=60, ntStackedFill=99; //byLayerIndex
	int nSequentialPackColors[0];
	{
		String k;
		Map m;
		
		m= mapSetting.getMap("Item");
		k="ColorRule";			if (m.hasInt(k))	nColorRule = m.getInt(k);
		
		m= mapSetting.getMap("Pack");
	//	k="DoubleEntry";		if (m.hasDouble(k))	dDoubleEntry = m.getDouble(k);
	//	k="StringEntry";		if (m.hasString(k))	sStringEntry = m.getString(k);
		k="ColorRule";			if (m.hasInt(k))	nColorRulePack = m.getInt(k);
		k="ColorPack";			if (m.hasInt(k))	nColorPack = m.getInt(k);		
		
		m= mapSetting.getMap("Pack\\NotStacked");
		k="TransparencyWire";			if (m.hasInt(k))	ntWire = m.getInt(k);
		k="TransparencyFill";			if (m.hasInt(k))	ntFill = m.getInt(k);
		
		m= mapSetting.getMap("Pack\\Stacked");
		k="TransparencyWire";			if (m.hasInt(k))	ntStackedWire = m.getInt(k);
		k="TransparencyFill";			if (m.hasInt(k))	ntStackedFill = m.getInt(k);

		m = mapSetting.getMap("Pack\\SequentialColor[]");		
		for (int i=0;i<m.length();i++) 
			nSequentialPackColors.append(m.getInt(i)); 

	}//End Read Settings//endregion 
	
	
	
	
//End Settings//endregion	

//region JIGS
	
// Jig Insert
	String kJigInsert = "JigInsert";
	if (_bOnJig && _kExecuteKey==kJigInsert) 
	{
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point		
	    Body bd = _Map.getBody("bd");
	    Vector3d vecTrans = ptJig-_PtW;
	    if (bd.isNull())
	    { 
	    	reportMessage("\n"+ scriptName() + T("|unexpected error|"));
	    	return;
	    }
	    
	    DrawWireframe(bd, vecTrans, nColorPack, 0, 70);

	    return;
	}
	
	String kJigMoveItem = "JigMoveItem";
	if (_bOnJig && _kExecuteKey==kJigMoveItem) 
	{
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point		
	    Point3d ptFrom = _Map.getPoint3d("ptFrom");
	    
	    Map mapBodies = _Map.getMap("Body[]");
	    PlaneProfile pp = _Map.getPlaneProfile("pp");
	    PlaneProfile ppSnap = _Map.getPlaneProfile("ppSnap");
	    
	    
	    DrawSnap(ppSnap, dViewHeight/200, Vector3d(0,0,0), darkyellow, 60, dpModel);  
 
	    
	    Display dp(-1);
		dp.trueColor(lightblue, 60);
	    
	    Vector3d vec = ptJig - ptFrom;
	    for (int i=0;i<mapBodies.length();i++) 
	    { 
	    	Body bd = mapBodies.getBody(i);
	    	bd.transformBy(vec);
	    	dp.draw(bd); 
	    }//next i
	    
	    pp.transformBy(vec);
	    dp.draw(pp,_kDrawFilled);
	    dp.draw(pp);
	    
	    return;
	}	

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
	}//endregion

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


	// highlight closest circle
		if (_Map.getInt("PickBase"))
		{ 
			PlaneProfile pps[] = GetPlaneProfileArray(_Map.getMap("mapCircles"));
			
			if (pps.length()>0)
				ptJig.setZ(pps[0].coordSys().ptOrg().Z());
	
		    
		    Display dp(-1);
		    dp.trueColor(lightblue, 50);
	
		    double dMin = U(10e6);
		    int n;
		    for (int i=0;i<pps.length();i++) 
		    { 
		    	double d = (pps[i].closestPointTo(ptJig)-ptJig).length();
		    	if (d<dMin)
		    	{ 
		    		dMin = d;
		    		n = i;
		    	}	    	 
		    }//next i
		    for (int i=0;i<pps.length();i++)
		    { 
		    	PlaneProfile pp = pps[i];
		    	if (n==i && pp.pointInProfile(ptJig)==_kPointInProfile)
		    	   	dp.trueColor(darkyellow,0);		    	
		    	else
		    	   	dp.trueColor(lightblue, 50);
		    	dp.draw(pp, _kDrawFilled);
		    }			
		    
			return;
		}



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
	    dp.addViewDirection(vecZView);
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
	    
	    dp.trueColor(lightblue);
	    dp.draw(bd.shadowProfile(Plane(_Pt0, vecZView)), _kDrawFilled, 80);
	    
	    dp.trueColor(in3dGraphicsMode()?orange:darkyellow,20);
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
	    
	    
	    
	    dp.trueColor(in3dGraphicsMode()?orange:darkyellow,0);
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

//END Jigs //endregion 	


//region Dimstyles
	//region DimStyles
	// Find DimStyle Overrides, order and add Linear only
	String sDimStyles[0], sSourceDimStyles[0];
	{ 
	// append potential linear overrides	
		String sOverrides[0];
		for (int i=0;i<_DimStyles.length();i++) 
		{ 
			String dimStyle = _DimStyles[i]; 
			int n = dimStyle.find("$0", 0, false);	// indicating it is a linear override of the dimstyle
			if (n>-1 && sSourceDimStyles.find(dimStyle,-1)<0)
			{
				sDimStyles.append(dimStyle.left(n));
				sSourceDimStyles.append(dimStyle);
			}
		}//next i
		
	// append all non overrides	
		for (int i = 0; i < _DimStyles.length(); i++)
		{
			String dimStyle = _DimStyles[i]; 
			int nx = dimStyle.find("$", 0, false);	// <0 it is not any override of the dimstyle
			if (nx<0 && sDimStyles.findNoCase(dimStyle)<0)
			{ 
				sDimStyles.append(dimStyle);
				sSourceDimStyles.append(dimStyle);				
			}
		}

	// order alphabetically
		for (int i=0;i<sDimStyles.length();i++) 
			for (int j=0;j<sDimStyles.length()-1;j++) 
				if (sDimStyles[j]>sDimStyles[j+1])
				{
					sDimStyles.swap(j, j + 1);
					sSourceDimStyles.swap(j, j + 1);
				}
	}//endregion
//PreRequisites //endregion 

//region Properties
	String sDescriptionName=T("|Description|");	
	PropString sDescription(nStringIndex++, "", sDescriptionName);	
	sDescription.setDescription(T("|Defines the description of the package|"));
	sDescription.setCategory(category);


	String sNumberName=T("|Number|");	
	PropInt nNumber(nIntIndex++, 0, sNumberName);	
	nNumber.setDescription(T("|Defines a unique number of a pack entity.|") + 
		T(" |The existing sequence of numbers will be preserved by incrementing the range of affected numbers when created of modified.|")+ 
		T(" |The value of zero signifies that the subsequent available number, commencing from one, will be allocated.|"));
	nNumber.setCategory(category);
	nNumber.setControlsOtherProperties(true);
	//nNumber.setReadOnly(bEditDefinition ? _kHidden:false);

	String sItemModeName=T("|Item Mode|");
	String tIMEdit= T("|Edit|"), tIMHideMultipage = T("|Hide in Shopdrawing|"), tIMHidden = T("|Hidden|"),sItemModes[] ={ tIMEdit, tIMHidden, tIMHideMultipage};
	PropString sItemMode(nStringIndex++, sItemModes, sItemModeName);	
	sItemMode.setDescription(T("|Defines how items will be shown within a pack.| ")+ T("|This setting also influences the appearance in shopdrawings and alters the visibility of items and packages.|"));
	sItemMode.setCategory(category);
	if (sItemModes.findNoCase(sItemMode,-1)<0)sItemMode.set(tIMEdit); 


category = T("|Geometry|");
	PropDouble dLength(nDoubleIndex++, U(0), tLengthName);	
	dLength.setDescription(T("|Defines the length of the package|") + T(", |0 = byContent|"));
	dLength.setControlsOtherProperties(true);
	dLength.setCategory(category);
	
	PropDouble dWidth(nDoubleIndex++, U(0), tWidthName);	
	dWidth.setDescription(T("|Defines the width of the package|")+ T(", |0 = byContent|"));
	dWidth.setControlsOtherProperties(true);
	dWidth.setCategory(category);
	
	PropDouble dHeight(nDoubleIndex++, U(0), tHeightName);	
	dHeight.setDescription(T("|Defines the height of the package|")+ T(", |0 = byContent|"));
	dHeight.setControlsOtherProperties(true);
	dHeight.setCategory(category);

category = T("|Alignment|");
	String sSpacerHeightName=T("|Spacer Height|");	
	PropDouble dSpacerHeight(nDoubleIndex++, U(0), sSpacerHeightName);	
	dSpacerHeight.setDescription(T("|Defines the height of a spacer for the entity|"));
	dSpacerHeight.setCategory(category);
	
category = T("|Display|");
	String sFormatName=T("|Format|");	
	PropString sFormat(nStringIndex++, T("|Package| ") +"@(Description:D) @(Number:D)\n@(Data.weight:D'0':CU;m:RL2)to", sFormatName);	
	sFormat.setDescription(T("|Defines the format of the header display|"));
	sFormat.setCategory(category);	
	//HSB-22201 legacy compatibility: auto correct subMapX key StackData -> Data
	if (sFormat.find("@(StackData",0, false)>-1)
	{ 
		String format = sFormat;
		format.replace("@(StackData", "@(Data");
		sFormat.set(format);
		reportMessage("\n"+ scriptName() + T(" |The name of the subMapX containg the data of the pack has been renamed from 'StackData' to 'Data'.|") + T(" |Kindly avoid utilizing the outdated syntax.|"));		
	}

	Map mapAdd;
	if (_bOnInsert)
	{ 
		mapAdd.setInt("Number", 1); // dummy
		sFormat.setDefinesFormatting("TslInst", mapAdd);
	}
	
	String sDimStyleName=T("|Dimstyle|");	
	PropString sDimStyle(nStringIndex++, sDimStyles, sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the Dimstyle|"));
	sDimStyle.setCategory(category);
	String dimStyle = sSourceDimStyles[sDimStyles.find(sDimStyle,0)];
	if (_DimStyles.findNoCase(dimStyle ,- 1) < 0)dimStyle = _DimStyles.first();

	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(100), sTextHeightName,_kLength);	
	dTextHeight.setDescription(T("|Defines the text height|") + T(", |0 = byDimstyle|"));
	dTextHeight.setCategory(category);	
	
//region Property Dependent Functions

//region Function ChangeBoxDimension
	// modifies the box dims stored in map
	void ChangeBoxDimension(String lastChangedProp, Map& m)
	{ 
		if (lastChangedProp == tLengthName)
			m.setDouble("dXRaw", dLength);
		else if (lastChangedProp == tWidthName)
			m.setDouble("dYRaw", dWidth);
		else if (lastChangedProp == tHeightName)
			m.setDouble("dZRaw", dHeight);
		return;	
	}//endregion
	
//endregion 	
		

//region Function setReadOnlyFlagOfProperties
	// sets the readOnlyFlag
	void setReadOnlyFlagOfProperties()
	{ 	
		//sPainter.setReadOnly(_bOnInsert || bDebug ? false : _kHidden);

		return;
	}//endregion		
	
	
//	String kResHigh = T("|High Detail|"), kResMedium = T("|Medium Detail|"), kResMediumProf = T("|Medium Profile Detail|"), kResLow = T("|Low Detail|"), sResolutions[] ={ kResLow, kResMedium, kResMediumProf, kResHigh};
//	String sResolutionName=T("|Resolution|");	
//	PropString sResolution(nStringIndex++, sResolutions, sResolutionName,1);	
//	sResolution.setDescription(T("|Defines the Resolution|"));
//	sResolution.setCategory(category);
//	if (sResolutions.findNoCase(sResolution ,- 1) < 0) sResolution.set(kResMedium);

//End Properties//endregion 

//region OnInsert
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
			sItemMode.set(tIMEdit); 
			setReadOnlyFlagOfProperties();	
			
			while (showDialog("---") == _kUpdate) // _kUpdate means a controlling property changed.	
			{ 
				setReadOnlyFlagOfProperties(); // need to set hidden state
			}	
			setReadOnlyFlagOfProperties();				
		}

		int nStart = FindNextFreeNumber(nNumber);
		nNumber.set(nStart);
		
		if (dLength > 0)dBoxDims[0] = dLength;
		if (dWidth > 0)dBoxDims[1] = dWidth;
		if (dHeight > 0)dBoxDims[2] = dHeight;
		
		_Map.setDouble("dXRaw", dBoxDims[0]);
		_Map.setDouble("dYRaw", dBoxDims[1]);
		_Map.setDouble("dZRaw", dBoxDims[2]);
		
		_Map.setInt(kRawPack, true);



	//region Show Jig
		PrPoint ssP(T("|Select insertion point|")); // second argument will set _PtBase in map
	    Map mapArgs;
	    
	    Body bd(_PtW, _XW, _YW, _ZW, dBoxDims[0], dBoxDims[1], dBoxDims[1], 1, 0, 1);
	    mapArgs.setBody("bd", bd);
	    
	    int nGoJig = -1;
	    while (nGoJig != _kOk && nGoJig != _kNone)
	    {
	        nGoJig = ssP.goJig(kJigInsert, mapArgs); 

	        if (nGoJig == _kOk)
	        {
	            Point3d ptPick = ssP.value(); //retrieve the selected point
				_Pt0 = ptPick+_ZW*dSpacerHeight+.5*_XW*dBoxDims[0];
	        }
//	        else if (nGoJig == _kKeyWord) [Left/Right]
//	        { 
//	            if (ssP.keywordIndex() == 0)
//	                mapArgs.setInt("isLeft", TRUE);
//	            else 
//	                mapArgs.setInt("isLeft", FALSE);
//	        }
	        else if (nGoJig == _kCancel)
	        { 
	            eraseInstance(); // do not insert this instance
	            return; 
	        }
	    }			
	//End Show Jig//endregion 

		return;
	}
	setReadOnlyFlagOfProperties();	
//endregion 

//region Grip Management #GM 1
	int indexOfMovedGrip = Grip().indexOfMovedGrip(_Grip);
	Grip grip;
	Vector3d vecApplied;
	int bDrag, bOnDragEnd,bDragTag,bOnDragEndLocation;
	int bShapeGrip, bGipLocX,bGipLocY,bGipLocZ;
	int bIsLocationGrip; // indicating if the grip is a location grip
	Map mapGrip;
	TslInst stackByGrip;
	if (indexOfMovedGrip>-1)
	{ 
		bDrag = _bOnGripPointDrag && _kExecuteKey=="_Grip";
		bOnDragEnd = !_bOnGripPointDrag;
		
		grip = _Grip[indexOfMovedGrip];
		vecApplied = grip.vecOffsetApplied();
		String name = grip.name();

		int bOk = mapGrip.setDxContent(name, true);
		if(bOk && mapGrip.getInt("isLocation"))
		{ 
			{ Entity e = mapGrip.getEntity("stack"); stackByGrip =(TslInst)e;}
			bIsLocationGrip = true;
			
		// Enable Z-Filtering in sectional views	
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
		}
		else if (name.find(kGripTagPlan,0,false)>-1)
			bDragTag = true;


		bOnDragEndLocation = bIsLocationGrip && bOnDragEnd;
		//reportNotice("\ndragging "+name + " _kExecuteKey " + _kExecuteKey +"\n  bDrag:" + bDrag+ "\n  bOnDragEnd:" + bOnDragEnd+ "\n  bDragTag:" + bDragTag+ "\n  bIsLocationGrip:" + bIsLocationGrip);	
	}	
	


//region Dragging
	if (bDrag ||bOnDragEndLocation)
	{ 
	// Get Geometry	
		PLine shape = mapGrip.getPLine("shape");
		PLine shape2 = mapGrip.getPLine("shape2");
		Body bdSimple = GetSimplePLineBody(shape, shape2);	
		
		Map mapBodies = mapGrip.getMap("bodies");
		Body bodies[0];
		for (int i=0;i<mapBodies.length();i++) 
			bodies.append(mapBodies.getBody(i)); 

		int bHasStack =stackByGrip.bIsValid();
		Body bdMax;
		TslInst tslNewParent= FindIntersectingParentBySolid(bdSimple, bdMax, vecApplied, "");	
		
	// Draw Drag Graphics	
		if (bDrag)
		{ 
			DrawPLine(shape, vecApplied, lightblue, 0,80,dp);
			DrawBodies(bodies, vecApplied, lightblue, 0, dpJig);	
			
			if (tslNewParent.bIsValid() && !bdMax.isNull())
			{
				DrawBodies(bdMax.decomposeIntoLumps(), Vector3d(), darkyellow, 0, dpJig);	
				Vector3d vecZS = shape.coordSys().vecZ();
				Point3d pts[] = bdMax.extremeVertices(vecZS);
				if (pts.length()>0)
				{
					PlaneProfile ppMax = bdMax.shadowProfile(Plane(pts.first(), vecZS));
					DrawSnap(ppMax, dViewHeight/300, Vector3d(0,0,0), darkyellow, 100, dpPlan);
					DrawSnap(ppMax, dViewHeight/300, Vector3d(0,0,0), darkyellow, 90, dpModel);
				}
			}
			return;
		}
		
		else if (bOnDragEndLocation)
		{ 
			_Pt0.transformBy(vecApplied);
			
			TslInst tslParent = stackByGrip;
			//if(bDebug)reportNotice("\nPack.DragEnd, has stack:" + bHasStack);
			if ((!tslParent.bIsValid())  || (bHasStack && tslNewParent!=stackByGrip) )
			{ 			
			// release current parent if different
				//reportNotice("\ntslParent " + tslParent.bIsValid() + " tslNewParent " + tslNewParent.bIsValid());
				if (tslParent.bIsValid() && tslParent != tslNewParent)
				{ 
					int bOk = ReleaseParent(tslParent, _ThisInst );	
					if (bOk && _ThisInst.color()>0)
						_ThisInst.setColor(0);
					if(bDebug)reportNotice("\nrelease " + bOk);
				}
			}	
			else
			{ 
				RemoveLayerIndices(_Map);
			}			
			
			// write to new parent
			if (tslNewParent.bIsValid() && tslParent != tslNewParent)// (!tslParent.bIsValid() || tslParent != tslNewParent))
			{ 
				int bOk = AssignParent(tslNewParent, _ThisInst );	
				//if(bDebug)reportNotice("\nnew assign " + bOk);	
				
				pushCommandOnCommandStack("_HSB_Recalc");
				pushCommandOnCommandStack("(handent \""+_ThisInst.handle()+"\")");					
			}	

			//reportNotice("\non bOnDragEndLocation: " +_Pt0); 
			setExecutionLoops(2);
			//return;
		}		
		
		
		
	}

//endregion 

//Grip Management 1 //endregion 

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

//End Part #B //endregion


//region Part #C
	//reportNotice("\n" + _ThisInst.formatObject("@(Scriptname) @(Handle): #C"));
	
	int bIMEdit = sItemMode == tIMEdit;
	int bIMHidden = sItemMode == tIMHidden;
	int bIMHideMultipage = sItemMode == tIMHideMultipage;
	
	double dWeight, dVolume;
	String sItemList; // will contain the format results of the linked items
	Point3d ptCOG;

	Vector3d vecX = _XW;	//_XE = vecX;
	Vector3d vecY = _YW;	//_YE = vecY;
	Vector3d vecZ = _ZW;	//_ZE = vecZ;
	Point3d ptOrg = _Pt0;
	Plane pnZ(_Pt0, vecZ);
	CoordSys cs = CoordSys(ptOrg, vecX, vecY, vecZ);
	CoordSys csInv = cs;
	csInv.invert();

	CoordSys csParent(ptOrg, vecX, vecY, vecZ);
	int bInPlanView = vecZView.isParallelTo(_ZW);

	//addRecalcTrigger(_kGripPointDrag, "_Pt0");
	addRecalcTrigger(_kGripPointDrag, "_Grip");	
	_ThisInst.setAllowGripAtPt0(bDebug);
	_ThisInst.setDrawOrderToFront(false);
	
	// HSB-22001
	int bRawPack = _Map.getInt(kRawPack);
	if (_bOnDbCreated)setExecutionLoops(2);
	
//The dimensions shown are always true pack dims, when changing a property the value is stored in the box dimensions
	if (_kNameLastChangedProp!="")
		ChangeBoxDimension(_kNameLastChangedProp, _Map);
	GetBoxDimensions(_Map, dBoxDims);

	
//region Display
	dpText.trueColor(rgb(0,0,0));
	dpText.dimStyle(sDimStyle);
	double textHeight = dTextHeight;
	if (textHeight>0)
		dpText.textHeight(textHeight);
	else
		textHeight = dpText.textHeightForStyle("O", sDimStyle);
//endregion 

//	int nShapeType = 2; //0 = realBody, 1 = envelope(0, 1), 2 = envelope(1, 1), 3 = envelope;
//	if (sResolution == kResHigh)nShapeType = 0;
//	else if (sResolution == kResLow)nShapeType = 3;
//	else if (sResolution == kResMediumProf)nShapeType = 1;


	//reportMessage("\n_bOnGripPointDrag " + _bOnGripPointDrag + " indexOfMovedGrip: "+indexOfMovedGrip + " _kExecuteKey: " + _kExecuteKey  + " bDrag " + bDrag);
	
	
//End Part #C //endregion 
	

//region Unique Sequence Number Control
	TslInst packs[0];
	{ 
		Entity ents[0];
		String names[] ={ (bDebug ? kScriptPack : scriptName())};
		packs= FilterTslsByName(ents, names);
	}
	int nNumbers[0], nNumberAppearance= nNumber<1?0:GetNumbers(packs, nNumbers, nNumber);
	
// On modifying the number adjust affected instances	
	if (_kNameLastChangedProp == sNumberName && nNumber>0 && nNumberAppearance>0)	
	{ 		
	// order by number
		for (int i=0;i<packs.length();i++) 
			for (int j=0;j<packs.length()-1;j++) 
			{
				int n1 = nNumbers[j];
				int n2 = nNumbers[j+1];
				
				if (n1>n2)
				{
					packs.swap(j, j + 1);
					nNumbers.swap(j, j + 1);
				}
			}	
			
	// remove thisInst
		int n = packs.find(this);
		if (n>-1)
		{ 
			nNumbers.removeAt(n);
			packs.removeAt(n);
		}
			
	// collect packs to renumber if occupied
		int numbersX[0];
		TslInst packsX[0];
		int xStart = nNumbers.find(nNumber);
		if (xStart>-1)
		{ 
			for (int i=xStart;i<packs.length();i++) 
			{ 
				TslInst& t= packs[i]; 
				int num = t.propInt(0);

				if (numbersX.length()==0 || (numbersX.length()>0 && numbersX.last()==num))
				{
					num++;
					numbersX.append(num);
					packsX.append(t);
				}
			}//next i			
		}
	
	// Renumber topdown
		for (int i=packsX.length()-1; i>=0 ; i--) 
		{ 			
			TslInst& t=packsX[i]; 
			reportMessage("\n" + t.propString(2)+ T(" |renumbered from| ") + t.propInt(0) + " -> "+ numbersX[i]);
			t.setPropInt(0, numbersX[i]);
		}//next i

	// If coloring by pack number is active trigger items
		if(nColorRule==1)
		{ 
			TslInst items[] = FilterTslsByName(this.entity(), sChildScripts);
			for (int i=0;i<items.length();i++) 
				items[i].transformBy(Vector3d(0,0,0)); 
		}


		setExecutionLoops(2);
		return;					

	}
	
// Auto Renumber on Copy or when number is set to <=0	
	if (nNumberAppearance>1 || nNumber<=0)// && 
	{ 
		int newNumber = FindNextFreeNumber(nNumber);
		reportMessage("\n" + sDescription+ T(" |renumbered from| ") + nNumber + " -> "+ newNumber);
		nNumber.set(newNumber);
		setExecutionLoops(2);
		return;
	}

//endregion 

//region Get potential Parent

// Get parent if existant
	String parentUID;
	Entity entParent;
//	if (bOnDragEndLocation)
//	{ 
//		String tokens[] = grip.name().tokenize("_");
//		//reportNotice("\ntokens of grip = " +tokens);
//
//		if (tokens.length()>2)
//		{
//			parentUID = tokens[2];
//		}
//	}
//	else
//	{ 
//		
		Map mapX =this.subMapX(kTruckChild);
		parentUID = mapX.getString("ParentHandle");	
		
//	}
//
	entParent.setFromHandle(parentUID); 	
	TslInst tslParent = (TslInst)entParent;	
	
	if (tslParent.bIsValid())
	{ 	
		String name = tslParent.scriptName();
		PLine (tslParent.ptOrg(), _Pt0).vis(3);
		String props[] = tslParent.getListOfPropNames();
		for (int i=0;i<props.length();i++) 
		{ 
			if (tslParent.hasPropString(props[i]))
				mapAdd.setString(name+"_"+props[i], tslParent.propString(props[i])); 
		}//next i
		
		nColorPack = this.color();
		if (bDebug)reportNotice("\n" + name+" as parent found, (drag/drag ended " + bDrag+bOnDragEnd+")");
	}	

//endregion

//region Remove and/or get entities
	if (_Map.hasMap("RemoteSet"))
	{ 
		int n0 = _Entity.length();
		Map m = _Map.getMap("RemoteSet");
		_Entity=m.getEntityArray("ent[]", "", "ent");
		_Map.removeAt("RemoteSet", true);
		//reportNotice("\n"+scriptName() + " remote reset of _Entity from " +n0 + " to " +_Entity.length());
	}	
	Entity ents[0];
	for (int i=0;i<_Entity.length();i++) 
	{ 
		Entity& e= _Entity[i]; 
	
	// do not add dependency and do not add to list if spacer
		String name = e.formatObject("@(ScriptName:D)").makeUpper();
		if (name == "STACKSPACER")
		{
			continue;
		}

		setDependencyOnEntity(e);
		ents.append(e);	 
	}//next i

// Spacers which are attached to this pack only should be transformed if the pack is moved
	TslInst tslMovableSpacers[0], tslPackSpacers[0], tslStackSpacers[0];
	{ 
		String tRPackItems = T("|Items in Pack|"),tRPack2Pack = T("|Pack to Pack|"),tRStack = T("|Entire Stack|"),   sRelations[] ={ tRPackItems,tRPack2Pack,tRStack};

		
		String names[] = { "StackSpacer"};
		Entity _ents[0];
		TslInst spacers[] = FilterTslsByName(_ents, names); // search entire dwg
		for (int i=0;i<spacers.length();i++) 
		{ 
			TslInst spacer= spacers[i]; 
			String relation = spacer.propString(1);
			_ents = spacer.entity();
			
		// spacer belongs to this pack	
			if (_ents.find(this)>-1 && _Entity.find(spacer)<0)
			{ 
				_Entity.append(spacer);
			}
			
		// packToPack and entirteStack should not be movable	
			if (relation!=tRPackItems)
			{ 
				continue;
			}
		// if assigned to one pack only append to movable spacers
			else if (_ents.length()==1 && _ents[0]==this)
			{ 
				tslMovableSpacers.append(spacer);
			}
		}//next i
	
	}



	
	
	
	
//endregion

//region Move Items when Base Grip is dragged or Spacer height changed
	int bMoveItems = (_kNameLastChangedProp == "_Pt0" || bOnDragEndLocation);
	if (_kNameLastChangedProp == sSpacerHeightName)
	{ 
		double d = dSpacerHeight - _Map.getDouble("SpacerHeight");
		_Pt0 += _ZW * d;
		bMoveItems = true;
		vecApplied=_ZW * d;

	}	
	_Map.setDouble("SpacerHeight", dSpacerHeight);

	if (bMoveItems && ents.length()>0)
	{ 
		//reportNotice("\n "+scriptName()+" moving items = true " + " qty = " + ents.length() + " + " + tslMovableSpacers.length());
		for (int i=0;i<ents.length();i++) 
			ents[i].transformBy(vecApplied); 
		for (int i=0;i<tslMovableSpacers.length();i++) 
		{
			tslMovableSpacers[i].transformBy(vecApplied); 
		}


		// HSB-22001 dragging of a pack did not respect Z-Elevation
		if(!bOnDragEndLocation)// continue script bOnDragEndLocation
		{ 
			if(bDebug)reportNotice("\n "+scriptName()+" moving items drag state " + bDrag+bOnDragEnd+bIsLocationGrip);
			setExecutionLoops(2);
			return;			
		}
	}
//endregion 

//region Collect childs (items only)
	Point3d ptsXExtents[0], ptsYExtents[0], ptsZExtents[0];
	TslInst childs[0];
	Quader qdrChilds[0]; Body bdChilds[0]; 	
	PlaneProfile ppChilds[0];
	int nXLayers[0], nYLayers[0], nZLayers[0];;// same length as childs
//
//	if (!(bInPlanView && bDrag))
//	{ 
	for (int i = 0; i < ents.length(); i++)
	{
		Entity& e = ents[i];
		TslInst t = (TslInst)e;
		if (!t.bIsValid() || sChildScripts.findNoCase(t.scriptName() ,- 1) < 0){continue;}
		
		Entity refs[] = t.entity();
		if (refs.length() < 1){continue;}
		
		childs.append(t);
		//reportNotice("\n" + _ThisInst.formatObject("@(ScriptName)-@(Handle) looping ")+i + t.formatObject(" @(ScriptName)-@(Handle)-@(Data.LayerIndexPack)"));
		
	// set visibility	
		int bIsVisible = t.isVisible();
		if (bIMHidden && bIsVisible && !bDebug)
			t.setIsVisible(false);
		else if (!bIMHidden && !bIsVisible)
			t.setIsVisible(true);

		Body bd = t.realBody(_XW+_YW+_ZW);
		PlaneProfile pp(CoordSys());
		pp.unionWith(bd.shadowProfile(Plane(_Pt0, _ZW)));
		ppChilds.append(pp);	//pp.vis(2);
		//bd.vis(i);

		bdChilds.append(bd);
		nXLayers.append(-1);
		nYLayers.append(-1);
		nZLayers.append(-1);
		
//		ptsXExtents.append(bd.extremeVertices(vecX));
//		ptsYExtents.append(bd.extremeVertices(vecY));
//		ptsZExtents.append(bd.extremeVertices(vecZ));
	
	}
	
//	ptsXExtents = Line(_Pt0, vecX).orderPoints(ptsXExtents, dEps);
//	ptsYExtents = Line(_Pt0, vecY).orderPoints(ptsYExtents, dEps);
//	ptsZExtents = Line(_Pt0, vecZ).orderPoints(ptsZExtents, dEps);
//	if (ptsXExtents.length()>2){ ptsXExtents.swap(1, ptsXExtents.length()-1); ptsXExtents.setLength(2);}
//	if (ptsYExtents.length()>2){ ptsYExtents.swap(1, ptsYExtents.length()-1); ptsYExtents.setLength(2);}
//	if (ptsZExtents.length()>2){ ptsZExtents.swap(1, ptsZExtents.length()-1); ptsZExtents.setLength(2);}
//	

	

	//reportNotice("\nPack: " + _ThisInst.handle() + " assigning childs "+childs.length());
//Set parent/child relations
	int numChild = childs.length();
	int bHasChilds = numChild > 0;
	String sItemEntries[0];
	int nItemLayers[0];

//region Function GetStackingDirection
	// returns the stacking direction based on the majority of child alignments
	Vector3d GetMainStackingDirection(TslInst childs[])
	{ 
		Vector3d vecDir = _ZW;
		int horizontal, vertical;
		for (int i=0;i<childs.length();i++) 
		{ 
			TslInst& t = childs[i]; 
			String alignment = t.propString(2); 
			if (alignment == tVertical)vertical++;
			else if (alignment == tHorizontal)horizontal++;			
		}//next i
		
		if (vertical>horizontal)
			vecDir = _YW;
		return vecDir;
	}//endregion

//region Get and store layer indices of childs
	
// Distinguish stacking direction	
	Vector3d vecStackDir = GetMainStackingDirection(childs);
	Point3d ptGrids[0];
	int nStackIndices[] = GetSequencesInDir(vecStackDir, childs, bdChilds, ptGrids);
	
// loop grid locations and assign subindices in vecX
	for (int i=0;i<ptGrids.length();i++) 
	{ 
		int nStackIndex = i;
		TslInst childsX[0];
		Body bdChildsX[0];
		for (int j=0;j<childs.length();j++) 
		{ 
			if (nStackIndices.length()>j && nStackIndices[j]==nStackIndex)
			{
				childsX.append(childs[j]);
				bdChildsX.append(bdChilds[j]);		
			}
		}//next j

		Point3d ptGridsX[0];
		int nStackIndicesX[] = GetSequencesInDir(vecX, childsX, bdChildsX, ptGridsX);

	// write indices to map if modified
		for (int j=0;j<childsX.length();j++) 
		{ 
			int nStackIndexX = nStackIndicesX.length()>j?nStackIndicesX[j]:0;
			
			int n = childs.find(childsX[j]);
			if (n<0){ continue;}
			
			TslInst t = childs[n];
			Map m = t.map();
			int stackIndex = m.hasInt(kLayerIndexPack)?m.getInt(kLayerIndexPack):-1;
			int stackIndexX = m.hasInt(kLayerSubIndexPack)?m.getInt(kLayerSubIndexPack):-1;

			//reportNotice("\nStackPack: " + t.formatObject("@(ScriptName)-@(Handle)-@(Data.LayerIndexPack)")+stackIndex+nStackIndex);

			if (nStackIndex!=stackIndex || nStackIndexX!=stackIndexX)
			{ 
				m.setInt(kLayerIndexPack, nStackIndex);
				m.setInt(kLayerSubIndexPack, nStackIndexX);
				t.setMap(m);
				//reportNotice("\n"+_ThisInst.formatObject("@(ScriptName)-@(Handle): writing to ") + t.handle() + " " + nStackIndex + "." + nStackIndexX);
			}
			
			//reportNotice("\nStackPack reading item " + t.subMapX(kData));
		}		 
	}//next i		
//endregion 

	




// Append child data
	for (int i=0;i<childs.length();i++) 
	{ 
		TslInst& t = childs[i];
		Entity refs[] = t.entity();
		if (refs.length()<1)
		{ 
			continue;
		}
		Entity entRef = refs.first();
		
	// set reference of pack data to defining item entity
		{
			Map m= entRef.subMapX(kDataLink);
			m.setEntity(kScriptPack, this);	
			entRef.setSubMapX(kDataLink, m);
		}
	// cumulate weight	
		Map m= t.subMapX(kData);
		{ 
			dWeight += m.getDouble("Weight");
			dVolume += m.getDouble("Volume");
		}
		t.setSubMapX(kData, m);



	// make sure child is never below the load plane of the pack
//			double dZOffset = _ZW.dotProduct(_Pt0-t.ptOrg());
//			if(dZOffset>dEps)
//			{ 
//				double dSpacer = t.hasPropDouble(sSpacerHeightName) ? t.propDouble(sSpacerHeightName) : 0;
//				t.transformBy(_ZW * (dSpacer+dZOffset));
//			}

		
		
	// get item list data
		String itemEntry = entRef.formatObject("@(PosNum:D)");
		sItemEntries.append(itemEntry);
		nItemLayers.append(t.map().getInt(kLayerIndexPack));

		// HSB-21994 item list order by layer
		// sItemList += (sItemList.length()>0?", ":" ")+itemEntry;			
		//reportNotice("\nassigning layer " +t.color() + " to item "+ i);

//			Map mapX = t.subMapX(kPackageChild);		
//			mapX.setString("ParentUid", _ThisInst.uniqueId());
//			mapX.setString("ParentHandle", _ThisInst.handle());
//				
//			CoordSys csChild = t.coordSys();
//			CoordSys csChildRel;
//			csChildRel.setToAlignCoordSys(
//				_Pt0, csParent.vecX(), csParent.vecY(), csParent.vecZ(),
//				csChild.ptOrg(), csChild.vecX(), csChild.vecY(), csChild.vecZ());
//			mapX.setPoint3d("ptRelOrg", csChildRel.ptOrg(), _kAbsolute);
//			mapX.setPoint3d("ptVecX", csChildRel.ptOrg() + csChildRel.vecX(), _kAbsolute);
//			mapX.setPoint3d("ptVecY", csChildRel.ptOrg() + csChildRel.vecY(), _kAbsolute);
//			mapX.setPoint3d("ptVecZ", csChildRel.ptOrg() + csChildRel.vecZ(), _kAbsolute);
//	
//			t.setSubMapX(kPackageChild,mapX);
		Map mapX = setPackageChildRef(t, this);
	}//next i	

	
	//Compose parent mapX with Nesting info
	{ 
		Map mapX;	
		//mapX.setPlaneProfile("Shape", ppMaster);
		mapX.setString("MyHandle", this.handle());
		mapX.setString("MyUid", this.uniqueId());
		mapX.setPoint3d("ptOrg", _Pt0, _kRelative);
		mapX.setVector3d("vecX", _XW, _kScalable); // coordsys carries size
		mapX.setVector3d("vecY", _YW, _kScalable);
		mapX.setVector3d("vecZ", _ZW, _kScalable);
		
		//mapX.setMap("Layer", mapLayer); // stores the layer base points of the ortho directions
		
		this.setSubMapX(kPackageParent,mapX);			
	}	
	
//region Order item entries by layer and write HSB-21994 item list order by layer
	for (int i=0;i<sItemEntries.length();i++) 
		for (int j=0;j<sItemEntries.length()-1;j++) 
			if (nItemLayers[j]>nItemLayers[j+1])
			{
				nItemLayers.swap(j, j + 1);
				sItemEntries.swap(j, j + 1);
			}

	for (int i=0;i<sItemEntries.length();i++) 
		sItemList += (sItemList.length()>0?", ":" ")+sItemEntries[i];	
	//endregion 
	//reportNotice("\nassigning childs ended");

//endregion 

//region Get bounding body of pack and shadows

	PLine plShapes[0];
	Body bdPack(_Pt0, vecX, vecY, vecZ, dBoxDims[0], dBoxDims[1], dBoxDims[2], 0, 0, 1);//HSB-23169 index of z paste copy err
	Body bdRawPack(_Pt0, vecX, vecY, vecZ, dBoxDims[0], dBoxDims[1], dBoxDims[2], 0, 0, 1);
	{ 
		Body bodies[0];
		if (childs.length()<1)// || bRawPack)
			bodies.append(bdPack);//bRawPack?bdRawPack:bdPack);
		else
			bodies = bdChilds;
		

		Body bd;
		for (int j=0;j<css.length();j++) 
		{ 			
			PlaneProfile ppMax(css[j]);
			Plane pn(_Pt0, css[j].vecZ());

		// Collect shadow profiles from bodies
			PlaneProfile pps[0];
			for (int i=0;i<bodies.length();i++) 
			{ 
				Body& bdi = bodies[i];
				if (bdi.isNull())
				{
					continue;
				}
				//bdi.vis(i);
				PlaneProfile ppi(css[j]);
				ppi.unionWith(bdi.shadowProfile(pn));
				pps.append(ppi);				
			}

		// Try unification	
			PlaneProfile pps2[0];
			pps2 = pps;
			for (int i=pps2.length()-1; i>=0 ; i--) 
			{ 
				PlaneProfile pp= pps2[i]; 
				int bOk = UnionTry(ppMax, pp);
				if(bOk)
				{ 
					pps2.removeAt(i);
				}
			}//next i
			pps2.append(ppMax);	

		// Reappend the ones which were removed by false intersections and get union by bridging profiles
			for (int i=0;i<pps.length();i++) 
			{ 
				PlaneProfile pp= pps[i];
				if (!ppMax.intersectWith(pp))
					pps2.append(pp);
				 
			}//next i
			UnionWithBridges(ppMax,pps2);	
			for (int i=0;i<pps2.length();i++) 
				ppMax.unionWith(pps2[i]);				
			SimplifyMax(ppMax);

			PLine pl = GetProfileHull(ppMax);			//pl.vis(j + 1);
			pl.simplify();
			plShapes.append(pl);

			
		// create simplified solid	
			PLine rings[] = ppMax.allRings(true, false);
			if (rings.length()== 1 && pl.area()>pow(dEps,2))
			{ 
				if (bd.isNull())
					bd = Body(pl, pn.vecZ() * U(10e4), 0);
				else
				{
					Body bdj(pl, pn.vecZ() * U(10e4), 0);
					//if(j==2)bdj.vis(4);
					Body bdx = bd;
					if (!bdj.isNull())
						bdx.intersectWith(bdj);		
					
				// intersection succeeded	
					if (!bdx.isNull())
						bd = bdx;
				// intersection failed, try with even more simplified			
					else
					{ 
						pl.createConvexHull(pn, pl.vertexPoints(true));
						Body bdj(pl, pn.vecZ() * U(10e4), 0);
						bdj = Body(pl, pn.vecZ() * U(10e4), 0);
						bd.intersectWith(bdj);	
					}
				}
				//bd.vis(3);
			}
			else
			{ 
				Body bdr;
				for (int r=0;r<rings.length();r++) 
				{ 
					pl = rings[r]; 
					if (pl.area() < pow(U(10), 2)) 
					{
						continue;
					}
					//pl.coordSys().vis(4);pn.vis(3);pl.vis(2);
					bdr.addPart(Body(pl, pn.vecZ() * U(10e4), 0));
				}//next r
				
				if (bd.isNull())
					bd = bdr;
				else if (!bdr.isNull())
				{ 
					bd.intersectWith(bdr);		
				}
				
//				if (bDebug)
//				{
//					{Display dpx(1); dpx.draw(ppMax, _kDrawFilled, 20);}
//				}				
			}
	
		}//next j			

		if (!bd.isNull())
		{
			bdPack=bd;//.vis(j);
		}
		
		if (bDebug){Body bdx = bdPack; bdx.transformBy(_ZW * U(300));bdx.vis(6);}
	}
	
	PLine plRawShape(_ZW);
	PlaneProfile ppSnap(cs);
	ppSnap.joinRing(plShapes[2],_kAdd);
	
	{

//		PLine(bdRawPack.ptCen(),_PtW).vis(4);
//		PLine(_Pt0,_PtW).vis(3);
		Plane pn(_Pt0, css[2].vecZ());
		PlaneProfile ppMax(css[2]);
		ppMax.joinRing(plShapes[2], _kAdd);
		LineSeg segMax = ppMax.extentInDir(_XW);//segMax.vis(6);
		double dx0 = ppMax.dX();
		bdRawPack.transformBy(_XW *(_XW.dotProduct(segMax.ptMid()-bdRawPack.ptCen())+.5*(dBoxDims[0]-dx0)));// (dx0-dBoxDims[0]));
		//bdRawPack.vis(2);		
		ppMax.unionWith(bdRawPack.shadowProfile(pn));//ppMax.extentInDir(_XW).vis(2);

		SimplifyMax(ppMax);
		plRawShape = GetProfileHull(ppMax);
		plRawShape.simplify();	 	//plRawShape.vis(4);
		if (bRawPack)
			ppSnap.joinRing(plRawShape, _kAdd);
		//ppSnap.unionWith(bdRawPack.shadowProfile(Plane(_Pt0, _ZW)));
	}
	//{ Display dpx(6); dpx.draw(PlaneProfile(plRawShape), _kDrawFilled,10);}	
//endregion 
	
//region Nest new items to pack
	Map mapNestingItems = _Map.getMap("NestingItem[]");
	if (mapNestingItems.length()>0)
	{ 
		//bDebug = true;
		
		Point3d ptZMax = _Pt0;
		if (childs.length()>0)
		{
			Point3d pts[] = Line(_Pt0, _ZW).orderPoints(plShapes[1].vertexPoints(true));
			ptZMax =pts.length()>0?pts.last():_Pt0;	
		}
		
		
		
	//region Nester Defaults
	// set nester data
		double dDuration = 1;
		int bNestInOpening = false;
		double dNestRotation = 360;//set value in degrees: 0 for any angle, 90 for rotations per 90 degrees, 360 for no rotations allowed
		
		double dGap;
	
		NesterData nd;
		nd.setAllowedRunTimeSeconds(dDuration); //seconds
		nd.setMinimumSpacing(dGap);
		nd.setChildOffsetX(0);
		nd.setGenerateDebugOutput(false);
		nd.setNesterToUse(_kNTRectangularNester);
	
		int bNest = _Map.getInt(kCallNester);
		
	//endregion 		
		
	//region Collects shapes of items to be nested
		NesterCaller nester;
		NesterChild ncs[0];			
	
		Entity ents[] = mapNestingItems.getEntityArray("ents", "", "ent");
		
		// get painter definition and sorting direction from first item
		String ftr, sSorting;
		if (ents.length()>0)
		{ 
			TslInst t = (TslInst)ents[0];
			String sPainter = t.propString(0);
			sSorting =  t.propString(1);
			PainterDefinition pd(sPainterCollection+sPainter);
			
			if (pd.bIsValid())	
				ftr = pd.formatToResolve();

		}
		int bAscending = sSorting == tAscending;
		int bDescending = sSorting == tDescending;
		
	//region Collect tags based on given format
		int nGroupIndices[ents.length()]; // indicating to which group the entity belongs to
		String tags[0];
		if (ftr.length()>0)
			for (int i = 0; i < ents.length(); i++)
			{
				Entity e = ents[i];
				TslInst t = (TslInst)e;
				Entity entDefines[] = t.entity();
				String tag;
				if (entDefines.length()>0)
					tag= entDefines.first().formatObject(ftr);
				tags.append(tag);
			}

	// order ascending or descending
		
		for (int i=0;i<tags.length();i++) 
			for (int j=0;j<tags.length()-1;j++) 
				if ((bAscending && tags[j]>tags[j+1]) || (bDescending && tags[j]<tags[j+1]))
				{
					ents.swap(j, j + 1);
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
		
		
		PlaneProfile pps[0];
		double dXCMax, dYCMax, dNetArea; // the net area of all childs
		for (int i=0;i<ents.length();i++) 
		{ 
			Entity& e = ents[i];
			Map m = e.subMapX(kData);
			PlaneProfile ppi = m.getPlaneProfile("shapeZ");
			PlaneProfile pp(CoordSys(ppi.coordSys().ptOrg(),_XW,_YW,_ZW));
			pp.unionWith(ppi);	
			//if (bDebug){ dp.color(i);dp.draw(pp,_kDrawFilled,50);}
			
			pps.append(pp); 	
			dNetArea += pp.area();
			dXCMax = pp.dX() > dXCMax ? pp.dX() : dXCMax;
			dYCMax = pp.dY() > dYCMax ? pp.dY() : dYCMax;
			NesterChild nc(e.handle(), pp);
			nc.setNestInOpenings(bNestInOpening);
			nc.setRotationAllowance(dNestRotation);
			nester.addChild(nc);
			ncs.append(nc);
		}//next i		
	//endregion 	
			
	//region Run iterations of nester until no left overs
		int nMasterIndices[0],nLeftOverChilds[0];
		PlaneProfile ppSubMaster(CoordSys(ptZMax, _XW,_YW,_ZW));		
		ppSubMaster.joinRing(plRawShape,_kAdd);

		Point3d ptm = ppSubMaster.ptMid(); 
		double dXMax = ppSubMaster.dX();
		double dYMax = ppSubMaster.dY();
		Point3d pt1 = ptm - .5 * (_XW * dXMax + _YW * dYMax);

		// pass in a shortened profile to stuff the childs instead of stretched out distribution
		double dXMin = dNetArea/dYMax*1.5;
		if (dXMin > dXMax)	dXMin = dXMax;
		else if(dXMin < dXCMax && dXCMax<dXMax)	dXMin = dXCMax;
		double dXRest = dXMax - dXMin;

		PlaneProfile ppNester; ppNester.createRectangle(LineSeg(pt1, pt1 + _XW *dXMin +  _YW * dYMax ), _XW, _YW);
		if (!bDebug || (bDebug && _bOnRecalc))
			runNester(nester, ppNester, nMasterIndices, nLeftOverChilds, nd);

		// if the initial attempt has failed increase x-length
		int cnt;
		while (!bDebug && nLeftOverChilds.length()>0 && cnt<10 && dXMin<dXMax)//dXM < (dXMaster - dXPar))
		{ 
			dXMin += dXRest/5;

			if (dXMin>dXMax){ break;}
			nester = NesterCaller();
			for (int j=0;j<ncs.length();j++) 
				nester.addChild(ncs[j]);

			double dXN = dXMin;
			double dYN = dYMax<dYCMax?dYCMax:dYMax;
			
			Point3d pt1N = ptm - .5 * (_XW * dXN + _YW * dYN);
			pt1N += _XW * _XW.dotProduct(pt1 - pt1N);
			ppNester.createRectangle(LineSeg(pt1N, pt1N + _XW *dXN +  _YW * dYN ), _XW, _YW);	
			//ppNester.createRectangle(LineSeg(pt1, pt1 + _XW *dXMin +  _YW * dYMax ), _XW, _YW);	
			runNester(nester, ppNester, nMasterIndices, nLeftOverChilds, nd);//nester, ncs
			reportNotice("\n"  + T("|Nesting Area modified| ")  + (cnt+1) + "  "+ dXN+ "x" + dYN);
			if (nLeftOverChilds.length()>0)
				reportNotice("\n" + T("|Could not nest| ") + nLeftOverChilds.length());	
			cnt++;
		}

	//region transform shapes
		for (int i=0; i<nMasterIndices.length(); i++) 
		{
			int nIndexMaster = nMasterIndices[i];
			int nChildIndices[] = nester.childListForMasterAt(nIndexMaster);
			CoordSys csWorldXformIntoMasters[] = nester.childWorldXformIntoMasterAt(nIndexMaster);
			if (nChildIndices.length()!=csWorldXformIntoMasters.length()) 
			{
				reportNotice("\n" + scriptName()+": " + T("|The nesting result is invalid!|"));
				continue;
			}
			
		// locate the childs within the master
			for (int c=0; c<nChildIndices.length(); c++) 
			{
				String strChild = nester.childOriginatorIdAt(nChildIndices[c]);
				Entity ent; ent.setFromHandle(strChild);
				TslInst t = (TslInst)ent;
				CoordSys cs = csWorldXformIntoMasters[c];

				int n = ents.find(ent);
				if (n>-1 && t.bIsValid())
				{ 	
					PlaneProfile& ppn = pps[n];
					cs.transformBy(_ZW * t.propDouble(T("|Spacer Height|")));
					ppn.transformBy(cs);	
					
//					if (!bDebug && t.bIsValid())
//					{
//						t.transformBy(cs);
//						Map mapX = setPackageChildRef(t, _ThisInst);
//						_Entity.append(t);
//					}
				}
			}
		}			
	//endregion 
	
	//region order profiles in X
		int nInds[0];
		PlaneProfile ppGroups[] = getGroupedProfiles(pps, nInds, ents);
//		for (int i=0;i<pps.length();i++) 
//		{ 
//			PlaneProfile pp = pps[i]; 
//			//pts.append(pp.ptMid() - _XW + .5 * pp.dX());
//			if (bDebug){ dp.color(nInds[i]);dp.draw(pp,_kDrawFilled,80);}
//		}//next i				
	//endregion 

	//region transform shapes
		for (int i=0; i<nMasterIndices.length(); i++) 
		{
			int nIndexMaster = nMasterIndices[i];
			int nChildIndices[] = nester.childListForMasterAt(nIndexMaster);
			CoordSys csWorldXformIntoMasters[] = nester.childWorldXformIntoMasterAt(nIndexMaster);
			if (nChildIndices.length()!=csWorldXformIntoMasters.length()) 
			{
				reportNotice("\n" + scriptName()+": " + T("|The nesting result is invalid!|"));
				continue;
			}
			
		// locate the childs within the master
			for (int c=0; c<nChildIndices.length(); c++) 
			{
				String strChild = nester.childOriginatorIdAt(nChildIndices[c]);
				Entity ent; ent.setFromHandle(strChild);
				TslInst t = (TslInst)ent;
				CoordSys cs = csWorldXformIntoMasters[c];

				int n = ents.find(ent);
				if (n>-1 && t.bIsValid())
				{ 	
					PlaneProfile& ppn = pps[n];
					int ind = nInds[n]; // the index of the grouped profile
					PlaneProfile ppg = ppGroups[ind];
					if (bDebug)dp.draw(ppg.extentInDir(_XW));
					
					Vector3d vecMid = _YW * _YW.dotProduct(ptm - ppg.extentInDir(_XW).ptMid());
					ppn.transformBy(vecMid);	
					cs.transformBy(vecMid);
					cs.transformBy(_ZW * t.propDouble(T("|Spacer Height|")));
			
					if (!bDebug && t.bIsValid())
					{
						t.transformBy(cs);
						Map mapX = setPackageChildRef(t, this);
						_Entity.append(t);
					}
				}
			}
		}			
	//endregion

		if (bDebug)
			for (int i=0;i<pps.length();i++) 
			{ 
				dp.color(nInds[i]);
				dp.draw(pps[i],_kDrawFilled,80);
			}//next i	

	//endregion

		
		if (bDebug)
		{
			dp.draw(plRawShape);
			dp.draw(scriptName(), _Pt0, _XW, _YW, 1, 0);
			return;
		}
		else
		{
			pushCommandOnCommandStack("HSB_RECALC");
 			pushCommandOnCommandStack("(handent \""+_ThisInst.handle()+"\")");	
 			pushCommandOnCommandStack("(Command \"\")");
			_Map.removeAt("NestingItem[]", true);
		}

	}
//endregion 

//region On Drag show potential Stacks intersecting the package
//	if (((bDrag || bOnDragEnd) && !bDragTag) || bDebug)
//	{
//		PlaneProfile ppMax, ppOthers[0];
//		if (bDrag)ppSnap.transformBy(vecApplied);
//		
//		Map mapParents[] = getTruckDefinitions();
//		TslInst newParent = findIntersectingParent(mapParents, ppSnap, ppMax, ppOthers);
//
//		int bNewIsValid = newParent.bIsValid();
//		int bCurIsValid = tslParent.bIsValid();
//		int bReleaseParent = (bCurIsValid && bNewIsValid && newParent != tslParent) || (bCurIsValid && !bNewIsValid);
//		int bAssignParent = (bCurIsValid && bNewIsValid && newParent != tslParent) || (!bCurIsValid && bNewIsValid);
//
////		String text = bOnDragEnd ? "On drag end " : (bDebug ? "On debug " : "On drag ")+ (bIsLocationGrip?" of location grip ":" unkonwn ");
////		text += ", current(" + bCurIsValid + ")";
////		text += ", new(" + bNewIsValid + ")";
////		text += ", release parent(" + bReleaseParent + ")";
////		text += ", assign parent(" + bAssignParent + ")";		
////		reportNotice("\n"+scriptName() + " "+text);
//
//		if (bOnDragEndLocation)
//		{ 
//		// release current parent if different
//			//reportNotice("\nparent " + bCurIsValid + ", newParent " + bNewIsValid + " release/assign " + bReleaseParent+bAssignParent);
//			if (bReleaseParent)
//			{ 
//				int bOk = ReleaseParent(tslParent, _ThisInst );	
//				if (bOk && _ThisInst.color()>0)_ThisInst.setColor(0);
//				//if(bDebug)				reportNotice("\nrelease " + bOk);
//			}	
//		// write to new parent
//			if (bAssignParent)
//			{ 
//				int bOk = AssignParent(newParent, _ThisInst );	
//				//if(bDebug)				reportNotice("\n" + _ThisInst.scriptName() +" assigning " + bOk);				
//			}
//			setExecutionLoops(2);		
//		}
//		else
//		{ 
//		// draw Stack snap
//			DrawSnap(ppMax, dViewHeight/300, Vector3d(0,0,0), darkyellow, 60); 
//			for (int i=0;i<ppOthers.length();i++) 
//			{ 
//				DrawSnap(ppOthers[i], dViewHeight/400, Vector3d(0,0,0), lightblue, 60); 	 
//			}//next i
//	
//		// draw pack
//			int c = bReleaseParent && !bAssignParent ? red : lightblue;
//			//reportNotice("\nc "+ c +" release/assign " + bCurIsValid +bNewIsValid+bReleaseParent+bAssignParent);
//			DrawPLine(plShapes[2], vecApplied, c, 50,0, dpPlan);
////			DrawBodies(bdChilds, vecApplied, c, 70, dpModel );		//TODO	
//		}
//
//		if (!bDebug)
//		{
//			setExecutionLoops(2);
//			return;
//		}
//	}
//endregion 

//region Grip Managment #GM

//reportNotice("\n"+this.bIsValid()+"XXX 4 format:" +sFormat + " hnd:"+ this.handle() + " " + mapAdd);	

//Tag
	Point3d ptTagPlan = ppSnap.ptMid()-_XW*(.5*ppSnap.dX()+3*textHeight);
	String text = this.formatObject(sFormat, mapAdd);
	//if (text.length() < 1)setExecutionLoops(2);
	if (text.length() < 1 && bDebug)text = scriptName();
	sFormat.setDefinesFormatting(this, mapAdd);
	
	// Tagging Grip
	int nTagPlan = getGripIndexByName(_Grip, kGripTagPlan);	
	if (nTagPlan>-1)
	{
		//double z = ptTagPlan.Z();
		ptTagPlan = _Grip[nTagPlan].ptLoc();
		//ptTagPlan.setZ(z);
	}	
	
	if (bDragTag && !bOnDragEnd && !bOnDragEndLocation)
	{ 
		DrawTag("Pack", ptTagPlan, sDimStyle, textHeight, dpText);
		return;
	}

	// remove any shape grip, append missing grips
	if (indexOfMovedGrip<0)
	{ 
		for (int i=_Grip.length()-1; i>=0 ; i--) 
		{ 
			String name =_Grip[i].name();
			int bOk = mapGrip.setDxContent(name, true);
			if(bOk && mapGrip.getInt("isLocation"))
			{ 
				_Grip.removeAt(i);	
			}

		}//next i
		
	// append/remove tag grip
		
		if (nTagPlan<0 && text.length()>0)
		{ 			
			Grip grip = createGrip(ptTagPlan, _kGSTCircle, kGripTagPlan, _XW, _YW, 40, T("|Moves the location of the tag in plan view|"));
			_Grip.append(grip);
		}
		else if (nTagPlan>-1 && text.length()<1)
			_Grip.removeAt(nTagPlan);
	}			


	PlaneProfile ppShapes[0];
	for (int i=0;i<plShapes.length();i++) 
	{ 		
		CoordSys csi = css[i];
		String key = kDirKeys[i];
		PLine& plShape = plShapes[i];	//plShape.vis(i+1);
		
		if (bRawPack && i==2 && plRawShape.length()>dEps)
		{
			plShape = plRawShape;
		}
		plRawShape.vis(4);
		plShape.simplify();			//plShape.vis(30);
		Point3d ptsShape[]= plShape.vertexPoints(true);
		PlaneProfile ppShape(css[i]);
		ppShape.joinRing(plShape,_kAdd);
		ppShapes.append(ppShape);
		
		
		if (bDrag){ continue;}// do not re-add grips during dragging
		//if (i == 2 && dSpacerHeight > 0)ppShape.transformBy(-_ZW * dSpacerHeight);
		
		Point3d ptsC[0];
		ptsC.append(ptsShape);
		addMidPoints(ppShape, ptsC);
		
		// move points of base plane by Spacer height
		if (dSpacerHeight>dEps)
			for (int i=0;i<ptsC.length();i++) 
				if (_ZW.dotProduct(ptsC[i]-_Pt0)<=dEps)
				{
					ptsC[i].transformBy(-_ZW * dSpacerHeight);
					ptsC[i].vis(6);
				}

		if (bDebug)
			for (int p=0;p<ptsC.length();p++) 
				ptsC[p].vis(i+4); 			 
	
		
		for (int p=0;p<ptsC.length();p++) 
		{ 
			Point3d pt= ptsC[p]; 



		// Collect data in map
			Map m;
			m.setString("DirKey", key);
			m.setInt("isLocation", true);
			m.setPLine("shape", plShape);
			m.setPLine("shape2", i==2?plShapes[1]:plShapes[2]);
			m.setEntity("stack", tslParent);
			m.setInt("hasStack", tslParent.bIsValid());

			Map mapBodies;
			for (int i2=0;i2<bdChilds.length();i2++) 
				mapBodies.appendBody("bd",bdChilds[i2]); 
			m.setMap("bodies", mapBodies);

			Grip grip;
			grip.setPtLoc(pt);
			grip.setVecX(csi.vecX());
			grip.setVecY(csi.vecY());
			grip.setColor(81);
			grip.setShapeType(_kGSTCircle);
			grip.setName(m.getDxContent(true));

			if (i==2) // model / plan view
			{ 
				grip.addHideDirection(csi.vecX());
				grip.addHideDirection(-csi.vecX());
				grip.addHideDirection(csi.vecY());
				grip.addHideDirection(-csi.vecY());				
			}
			else // sectional
			{ 
				grip.addViewDirection(csi.vecZ());
				grip.addViewDirection(-csi.vecZ());				
			}

			
			grip.setToolTip(T("|Moves the pack by selected vertex|"));	
			
			_Grip.append(grip); 
		}//next p		
		
		
		

	}//next i


// set geometry 
	if (childs.length()>0)
	{ 
		if (ppShapes[1].dX()>0)	dLength.set(ppShapes[1].dX());
		if (ppShapes[0].dX()>0)	dWidth.set(ppShapes[0].dX());
		if (ppShapes[0].dY()>0)	dHeight.set(ppShapes[0].dY());	
	}
//endregion 

//region Draw
	if (bHasChilds) nColorPack = nNumber; // byDefault use the number as color
	if (tslParent.bIsValid() && nColorRulePack == 2)// byStack
	{ 		
		nColorPack =  _Map.hasInt(kLayerIndexStack)?_Map.getInt(kLayerIndexStack)+1:nColorPack;
	}
	if (bHasChilds)	SetSequenceColor(nColorPack, nSequentialPackColors);	

	
	if (dSpacerHeight>dEps && plShapes.length()>2)
		drawSpacer(plShapes[2], dSpacerHeight);	
	{PLine plines[] = { plShapes[0]}; DrawPLines(plines, Vector3d(), nColorPack, 0,0);}
	{PLine plines[] = { plShapes[1]}; DrawPLines(plines, Vector3d(), nColorPack, 0,0);}
	
	DrawPLine(plShapes[2], Vector3d(),nColorPack, bHasChilds?ntStackedWire:ntWire,bHasChilds?ntStackedFill:ntFill, dpPlan);//HSB-22468.6
	DrawPLine(plShapes[2], Vector3d(),nColorPack, bHasChilds?ntStackedWire:ntWire,bHasChilds?ntStackedFill:ntFill, dpModel);//
	DrawTag(text, ptTagPlan, sDimStyle, textHeight, dpText);
	
	if (bIMHidden || bIMHideMultipage)
		DrawBody(bdPack, nColorPack, bHasChilds?ntStackedWire:ntWire, dp);
	else
	{
		DrawBody(bdPack, nColorPack,  bHasChilds?ntStackedWire:ntWire, dpModel);//dpInvisible); //TODO check if dpMdeol works for multipage
		//DrawWireframe(bdPack, Vector3d(), nColorPack, 20,_bOnGripPointDrag?60:90);
	}
	//DrawBody(bdPack, nColorPack, 90, dpModel);	
	_Map.setPlaneProfile("ShapeX", ppShapes[0]);
	_Map.setPlaneProfile("ShapeY", ppShapes[1]);
	_Map.setPlaneProfile("ShapeZ", ppShapes[2]);
	_Map.setPlaneProfile("Snap", ppSnap);
	if (this.color()!=nColorPack)
		this.setColor(nColorPack);
	
	//_Pt0.vis(6);
//endregion 

//region Trigger

//region Trigger AddItems
	String sTriggerAddItems = T("|Add Items|");
	addRecalcTrigger(_kContextRoot, sTriggerAddItems );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddItems)
	{
		
	// prompt for entities
		Entity entsX[0];
		PrEntity ssE(T("|Select stackable items|"), TslInst());
		if (ssE.go())
			entsX.append(ssE.set());
			
	// Accept only tsls of certain scriptNames		
		for (int i=entsX.length()-1; i>=0 ; i--) 
		{ 
			TslInst t = (TslInst)entsX[i];
			String name = t.scriptName();
			if (sChildScripts.findNoCase(name,-1)<0)
				entsX.removeAt(i);			
		}

		Map mapArgs = GetItemShadowMap(entsX);
		PlaneProfile pp = mapArgs.getPlaneProfile("pp");
		Point3d ptFrom = pp.ptMid()-vecX*.5*pp.dX();
		Point3d ptTo = ptFrom;
		mapArgs.setPoint3d("ptFrom", ptFrom);
		mapArgs.setPlaneProfile("ppSnap", ppSnap);
		
	//region JigMoveItem
	
		PrPoint ssP(T("|Pick location|, ") + T("|<Enter>| to keep current location"), ptFrom);
		//ssP.setSnapMode(0);
	    int nGoJig = -1;
	    while (nGoJig != _kOk && nGoJig != _kNone)
	    {
	        nGoJig = ssP.goJig(kJigMoveItem, mapArgs); 
	        if (bDebug)reportMessage("\ngoJig returned: " + nGoJig);
	        
	        if (nGoJig == _kOk)
	            ptTo = ssP.value();
	        else if (nGoJig == _kCancel)
	            return; 
	    }
	    Vector3d vec = ptTo - ptFrom;
	    
	//End JigMoveItem//endregion 

	// release from existing parent
		for (int i=0;i<entsX.length();i++) 
		{ 
			Entity& e = entsX[i];
			if (ents.find(e)>-1){ continue;}
			_Entity.append(e);
			
		// Get parent if existant
			// pack
			Map mapX =e.subMapX(kPackageParent);
			String parentUID = mapX.getString("ParentHandle");
			Entity parent; parent.setFromHandle(parentUID);	
			if (parent.bIsValid())
			{ 
				int bOk = ReleaseParent(parent, e);
				if (bOk) e.transformBy(vec);
				//reportNotice("\n" + e.handle() + e.formatObject("@(ScriptName) @(Description) ")+ (bOk ? "" : " not") + " released");
			}			
			// stack
			else
			{ 
				mapX =e.subMapX(kTruckParent);
				parentUID = mapX.getString("ParentHandle");
				parent.setFromHandle(parentUID);	
				if (parent.bIsValid())
				{ 
					int bOk = ReleaseParent(parent, e);
					if (bOk) e.transformBy(vec);
					//reportNotice("\n" + e.handle() + e.formatObject("@(ScriptName) @(Description) ")+ (bOk ? "" : " not") + " released");
				}	
				else if (!vec.bIsZeroLength())
					e.transformBy(vec);
				
			}
			
			
			
		}//next i

		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger AddNestedItems
	String sTriggerAddNestedItems = T("|Add Nested Items|");
	addRecalcTrigger(_kContextRoot, sTriggerAddNestedItems );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddNestedItems)
	{
	// prompt for entities
		Entity entsX[0];
		PrEntity ssE(T("|Select stackable items|"), TslInst());
		if (ssE.go())
			entsX.append(ssE.set());
			
	// Accept only tsls of certain scriptNames		
		for (int i=entsX.length()-1; i>=0 ; i--) 
		{ 
			TslInst t = (TslInst)entsX[i];
			String name = t.scriptName();
			if (sChildScripts.findNoCase(name,-1)<0)
				entsX.removeAt(i);			
		}
		
		if (entsX.length()>0)
		{ 
			Map mapItems;
			mapItems.setEntityArray(entsX, true, "ents", "", "ent");
			_Map.setMap("NestingItem[]", mapItems);
		}

		//reportNotice("\n" + _Map.getMap("NestingItem[]").getEntityArray("ents", "", "ent").length() + " stored!");
		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger RemoveItems
	String sTriggerRemoveItems = T("|Remove Items|");
	if (childs.length()>0)addRecalcTrigger(_kContextRoot, sTriggerRemoveItems );
	if (_bOnRecalc && _kExecuteKey==sTriggerRemoveItems)
	{
	// prompt for entities
		Entity entsX[0];
		PrEntity ssE(T("|Select items to be removed|"), TslInst());
		if (ssE.go())
			entsX.append(ssE.set());
			
		for (int i=entsX.length()-1; i>=0 ; i--) 
			if (_Entity.find(entsX[i])<0)
				entsX.removeAt(i);

		Map mapArgs = GetItemShadowMap(entsX);
		PlaneProfile pp = mapArgs.getPlaneProfile("pp");
		Point3d ptFrom = pp.ptMid();
		Point3d ptTo = ptFrom;
		mapArgs.setPoint3d("ptFrom", ptFrom);
		

	//region Show Jig
		PrPoint ssP(T("|Pick location|"), ptFrom);
	    int nGoJig = -1;
	    while (nGoJig != _kOk && nGoJig != _kNone)
	    {
	        nGoJig = ssP.goJig(kJigMoveItem, mapArgs); 
	        if (bDebug)reportMessage("\ngoJig returned: " + nGoJig);
	        
	        if (nGoJig == _kOk)
	            ptTo = ssP.value();
	        else if (nGoJig == _kCancel)
	            return; 
	    }
	    Vector3d vec = ptTo - ptFrom;
	//End Show Jig//endregion 

		
		for (int i=0;i<entsX.length();i++) 
		{
			Entity& e = entsX[i];
			String subMapXKeys[] = e.subMapXKeys();
			if (subMapXKeys.findNoCase(kPackageParent,-1)>-1)
			{ 
				e.removeSubMapX(kPackageParent);	
				//if (bDebug)				reportMessage("\n" +kPackageParent + " removed from " + e.formatObject("@(ScriptName) @(description)"));	
			}
			if (subMapXKeys.findNoCase(kTruckParent,-1)>-1)
			{ 
				e.removeSubMapX(kTruckParent);	
				//if (bDebug)				reportMessage("\n" +kTruckParent + " removed from " + e.formatObject("@(ScriptName) @(description)"));	
			}
			int n = _Entity.find(e);
			if (n>-1)
				_Entity.removeAt(n);
			e.setColor(0);
			e.transformBy(vec); 
		}
		
	// reset default package size	
		if (_Entity.length()<1)
		{ 
			dLength.set(0);
			dWidth.set(0);
			dHeight.set(0);
			
		}

		setExecutionLoops(2);
		return;
	}//endregion	


// Trigger ToggleRawPack
	String sTriggerToggleRawPack =bRawPack?T("|Show shrink pack|"):T("|Show raw pack|");
	addRecalcTrigger(_kContextRoot, sTriggerToggleRawPack);
	if (_bOnRecalc && (_kExecuteKey==sTriggerToggleRawPack || _kExecuteKey==sDoubleClick))
	{
		bRawPack =! bRawPack;
		_Map.setInt(kRawPack, bRawPack);			
//		if (bRawPack)
//		{
//			double dxMin = ppShapes[2].dX();
//			double dyMin =ppShapes[2].dY();
//			_Pt0.transformBy(-_XW * .5 * (dxMin - dLength)) ;//- _YW * .5 * (dyMin - dWidth));
//			
//		}
		setExecutionLoops(2);
		return;
	}
	

	//region Trigger Rotate //compare and update template HSB-22506 
	String sTriggerRotate = T("|Rotate|");
	addRecalcTrigger(_kContextRoot, sTriggerRotate);
	if (_bOnRecalc && _kExecuteKey==sTriggerRotate)
	{
		
		int bCancel,indexAxis= 2;//0=X, 1=Y, 2=Z // roation only supported in XY plane
		double dAngle;
		CoordSys cs = CoordSys(_Pt0-vecZ*dSpacerHeight, vecX, vecY, vecZ), csRot;	

	//region Rotation Jig
		EntPLine epls[0];

		PlaneProfile ppShadow(cs);
		ppShadow.unionWith(bdPack.shadowProfile(Plane(cs.ptOrg(), cs.vecZ())));
		cs = CoordSys(ppShadow.ptMid(), vecX, vecY, vecZ);

		PrPoint ssP(T("|Pick point to rotate [Angle/Basepoint]|"));///ReferenceLine
		ssP.setSnapMode(TRUE, 0); // turn off all snaps
		
	    Map mapArgs;
		Point3d pt = cs.ptOrg();
	    Plane pn(pt, cs.vecZ());
	    
	    PlaneProfile pp(cs);
	    mapArgs.setPlaneProfile("pp", pp); // carries coordSys
		mapArgs.setInt("indexAxis", indexAxis); 
		
		mapArgs.setBody("bd", bdPack); 
	
	    double diameter = dViewHeight * .15;
	    PLine circle;
	    circle.createCircle(pt, cs.vecZ(), diameter);

	    int bPickBase, nGoJig = -1;
	    mapArgs.setInt("PickBase", bPickBase); // flag if the point picked will be the new base point
	    while (nGoJig != _kOk)// && nGoJig != _kNone)
	    {
	        nGoJig = ssP.goJig(kJigRotation, mapArgs); 
	        //if (bDebug) reportMessage("\ngoJig returned: " + nGoJig);        
	        if (nGoJig == _kOk)
	        {
	            Point3d ptPick  = ssP.value(); //retrieve the selected point

			// Set new base point
				if (bPickBase)
				{ 
        			pt  = ptPick;
        			pn=Plane (pt, cs.vecZ());
        			cs= CoordSys(pt, cs.vecX(), cs.vecY(), cs.vecZ());
        			pp = PlaneProfile(cs);
        			mapArgs.setPlaneProfile("pp", pp);

					PurgeJigs();
					bPickBase = false;
					nGoJig = -1;
					mapArgs.setInt("PickBase", bPickBase); 
				}
			// Set rotation angle	
				else
				{ 
					Line(ptPick, vecZView).hasIntersection(pn, ptPick);	            
		            double diameter = dViewHeight * .15;
		            Vector3d vecPick = ptPick-pt;		            
		            double dGridAngle;
		            dAngle = GetAngle(vecPick, cs.vecX(), cs.vecZ(), diameter, dGridAngle);					
				}
	        }
	        else if (nGoJig == _kKeyWord)
	        { 
	        // Specify angle as value   
	            if (ssP.keywordIndex() == 0)
	            { 
	            	bPickBase = false;
	            	ssP.setSnapMode(false,0);
	            	dAngle = getDouble(T("|Enter angle in degrees|"));
	            	break;
	            }
	        // Basepoint selection: show potential vertex locations as jigs 
	            else if (ssP.keywordIndex() == 1 && !bPickBase)
	            {		     	
	            // Create jig circles at vertices
	            	Point3d ptsJig[] = ppShadow.getGripVertexPoints();
	            	{ 
	            		PlaneProfile rect;
	            		rect.createRectangle(ppShadow.extentInDir(cs.vecX()), cs.vecX(), cs.vecY());
	            		ptsJig.append(rect.getGripEdgeMidPoints());
	            	}
	            	EntCircle entCircles[] = CreateJigCircles(ptsJig, dViewHeight*.01,cs.vecZ(), darkyellow, 5);
	            	PlaneProfile ppCircles[0];
	            	for (int c=0;c<entCircles.length();c++) 
	            	{ 
	            		PLine pl= entCircles[c].getPLine();
	            		pl.convertToLineApprox(dEps);
	            		ppCircles.append(PlaneProfile(pl));	            		 
	            	}//next c
	            	Map mapCircles = SetPlaneProfileArray(ppCircles);
	            	mapArgs.setMap("mapCircles", mapCircles);
	            	bPickBase = true;
	            	mapArgs.setInt("PickBase", bPickBase); 

					//PurgeJigs();
	            	ssP=PrPoint (T("|Pick new base point of rotation [Angle/SelectRotation]|"));    	
	            	ssP.setSnapMode(true, _kOsModeCen);

	            }
	        // Switching back frm base point to rotion selection    
	            else if (ssP.keywordIndex() == 1 && bPickBase)
	            {	
	            	mapArgs.removeAt("mapCircles", true);
	            	bPickBase = false;
					PurgeJigs();
	            	ssP=PrPoint (T("|Pick point to rotate [Angle/Basepoint]|"), pt);    	
	            	ssP.setSnapMode(false, 0);

	            }
	        // reset 
	            else
	            { 
	            	bPickBase = false;
	            	PurgeJigs();
	            }		            
	        }
	        else // if (nGoJig == _kCancel || nGoJig == _kNone)
	        { 	 
				PurgeJigs();        	        	
	        	bCancel = true;
	        	break;
	        }
	    }	
	//End Rotation Jig//endregion 	

	// Apply Rotation
		if (!bCancel && abs(dAngle)>0)
		{ 
			csRot.setToRotation(dAngle, cs.vecZ(), cs.ptOrg());
			for (int i=0;i<childs.length();i++) 
				childs[i].transformBy(csRot);	
		}

		PurgeJigs();
		setExecutionLoops(2);
		return;
	}//endregion


//END Trigger //endregion	

//region Store formatting data
	{

		Map m= this.subMapX(kData);
		
		m.setInt("QuantityItems", numChild);
		m.setDouble("Weight", dWeight, _kNoUnit);
		m.setDouble("Volume", dVolume, _kVolume);
		m.setDouble("Length", dLength, _kLength);
		m.setDouble("Width", dWidth, _kLength);
		m.setDouble("Height", dHeight, _kLength);
		m.setPoint3d("COG", ptCOG);
		m.setString("ItemList", sItemList);
//		m.setString("Description", sDescription); // store untranslated
		this.setSubMapX(kData, m);
	}
//endregion 


//region Dialog Trigger
{ 
	// create TSL
	TslInst tslDialog;			Map mapTsl;						
	GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };

//region Trigger Settings
	String sTriggerDisplaySettings = T("|Display Settings|");
	addRecalcTrigger(_kContext, sTriggerDisplaySettings );
	if (_bOnRecalc && _kExecuteKey==sTriggerDisplaySettings)
	{
		String kControlTypeKey = "ControlType";
		String kHorizontalAlignment = "Alignment";
		String kLabelType = "Label";
		String kHeader = "Header";
		String kIntegerBox = "IntegerBox";
		String kTextBox = "TextBox";
		String kDoubleBox = "DoubleBox";
		String kComboBoxType = "ComboBox";
		
		Map mapDialog ;
	    Map mapDialogConfig ;
	    mapDialogConfig.setString("Title", "Dynamic Dialog");
	    mapDialogConfig.setDouble("Height", 400);
	    mapDialogConfig.setDouble("Width", 700);
	    mapDialogConfig.setDouble("MaxHeight",800);
	    mapDialogConfig.setDouble("MaxWidth", 1000);
	    mapDialogConfig.setDouble("MinHeight", 120);
	    mapDialogConfig.setDouble("MinWidth", 180);
	    mapDialogConfig.setString("Description", T("|Specifies the display properties if the individual components|"));
	    mapDialog.setMap("mpDialogConfig", mapDialogConfig);
	
	//region Columns
		Map columnDefinitions ;
	    Map column1;
	    column1.setString(kControlTypeKey, kLabelType);
	    column1.setString(kHorizontalAlignment, "Left");
	    column1.setString(kHeader, T("|Component|"));
	    columnDefinitions.setMap("Component", column1);	
		
	    Map column2 ;
	    column2.setString(kControlTypeKey, kIntegerBox);
	    column2.setString(kHorizontalAlignment, "Right");
	    column2.setString(kHeader, T("|Color|"));
	    columnDefinitions.setMap("Color", column2);		
		
	    Map column3 ;
	    column3.setString(kControlTypeKey, kIntegerBox);
	    column3.setString(kHorizontalAlignment, "Right");
	    column3.setString(kHeader, T("|Transparency|"));
	    columnDefinitions.setMap("Transparency", column3);			
	
	   
    	Map mapItems4 ;
    	for (int i=0;i<_LineTypes.length();i++) 
    		mapItems4.setString("Item" + (i+1), _LineTypes[i]);	

	    Map column4 ;
	    column4.setString(kControlTypeKey, kComboBoxType);
	    column4.setString(kHorizontalAlignment, "Left");
	    column4.setString(kHeader, T("|Linetype|"));
	    column4.setMap("Items[]", mapItems4);	    
	    columnDefinitions.setMap("Linetype", column4);

	    Map column5 ;
	    column5.setString(kControlTypeKey, kDoubleBox);
	    column5.setString(kHorizontalAlignment, "Right");
	    column5.setString(kHeader, T("|Linetype Factor|"));
	    columnDefinitions.setMap("LinetypeFactor", column5);

		mapDialog.setMap("mpColumnDefinitions", columnDefinitions);			
	//endregion 

	//region Rows
	    Map rowDefinitions ;
	    for (int i = 0; i < 5; i++)
	    {
	        Map row ;
	       // row.setString("RowName", "xx" + i);
	        row.setString("Component", T("|Text Entry| ") + i);
	        row.setInt("Color", 3);
	        row.setInt("Transparency", 4);
	       	row.setString("Linetype", _LineTypes.first());
	        row.setDouble("LinetypeFactor", 1.0,_kNoUnit);
	        rowDefinitions.setMap("row"+(i+1), row);
	    }	
	    mapDialog.setMap( "mpRowDefinitions", rowDefinitions);			
	//endregion 	
		
		Map mapOut = callDotNetFunction2(sDialogLibrary, sClass, showDynamic, mapDialog);
		mapOut.writeToXmlFile("C:\\temp\\mapOut.xml");
		setExecutionLoops(2);
		return;
	}//endregion	

	
//region Trigger ColorRuleSettings
	String sTriggerColorRuleSettings = T("|Color Rules|");
	addRecalcTrigger(_kContext, sTriggerColorRuleSettings);
	if (_bOnRecalc && _kExecuteKey==sTriggerColorRuleSettings)	
	{ 
		mapTsl.setInt("DialogMode",2);
		
		String colorRule = nColorRule > -1 && nColorRule < tColorRules.length() ? tColorRules[nColorRule]: tColorRules.first();
		sProps.append(colorRule);

		String colorRulePack = nColorRulePack > 0 && nColorRulePack < tColorRules.length() ? tColorRules[nColorRulePack]: tColorRules[1];
		sProps.append(colorRulePack);

		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{ 
				nColorRule = tColorRules.findNoCase(tslDialog.propString(0),0);
				nColorRulePack = tColorRules.findNoCase(tslDialog.propString(1),1);
				Map m = mapSetting.getMap("Item");
				m.setInt("ColorRule",nColorRule);
				mapSetting.setMap("Item", m);
				
				m = mapSetting.getMap("Pack");
				m.setInt("ColorRule",nColorRulePack);
				mapSetting.setMap("Pack", m);
				
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);				
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
}
//End Dialog Trigger//endregion 



































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
        <int nm="BreakPoint" vl="3256" />
        <int nm="BreakPoint" vl="3242" />
        <int nm="BreakPoint" vl="3197" />
        <int nm="BreakPoint" vl="3713" />
        <int nm="BreakPoint" vl="4167" />
        <int nm="BreakPoint" vl="3036" />
        <int nm="BreakPoint" vl="2728" />
        <int nm="BreakPoint" vl="3926" />
        <int nm="BreakPoint" vl="3960" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23577 new command to rotate a package" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="4/10/2025 11:22:31 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23372 fully supporting new behaviour of controlling properties" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="2/12/2025 12:11:12 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23169 pack height fixed" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="12/19/2024 11:43:17 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21733 supports relocation of attached spacers when moved, Z-Filter bugfix when using sectional grips" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="11/22/2024 4:18:02 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22717 element references improved" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="9/24/2024 6:01:33 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21161 debug messages removed" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="9/17/2024 1:41:45 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21998 settings introduced to enable custom color coding" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="8/22/2024 4:27:41 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21677 jigging items improved" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="8/16/2024 5:15:19 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22468 visibilty improved, dragging in plan view turns Z-filtering on" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="8/2/2024 3:47:23 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21811 A new property 'Number' has been added. The number can be used for formatting and specifies a fixed unique number" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="7/17/2024 7:18:43 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21677 drag jigs made more transparent" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="6/3/2024 2:03:26 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21994 item list ordered by layer index" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="5/10/2024 10:23:56 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20285 tag does not contribute to snap points anymore" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="1/8/2024 1:22:59 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20893 catching tolerance issue in hidden mode" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="12/22/2023 2:37:40 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20750 debug message removed" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="12/1/2023 3:00:44 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20724 bugfix model display" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="11/24/2023 1:05:36 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20724 supports automatic layer nesting as context command" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="11/24/2023 12:13:52 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19662 drag behaviour improved when stacked and packed" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="11/17/2023 3:43:57 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19659 color updating enhanced, grip color changed" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="11/8/2023 4:47:25 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19659 reference link renamed" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="10/24/2023 3:44:22 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19659 first beta release" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="10/18/2023 5:16:47 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19659 data export added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="10/12/2023 5:51:09 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19659 dragging behaviour improved" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="10/6/2023 5:45:41 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19659 initial version" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="9/29/2023 4:00:57 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End