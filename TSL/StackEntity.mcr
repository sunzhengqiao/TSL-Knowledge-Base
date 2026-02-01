#Version 8
#BeginDescription
This tsl displays a truck definition and offers methods to maintain truck definitions

#Versions
Version 3.2 12.02.2025 HSB-23372 fully supporting new behaviour of controlling properties , Author Thorsten Huck
Version 3.1 10.01.2025 HSB-22732: Add Axle load calculation , 
Version 3.0 22.11.2024 HSB-21733 supports relocation of attached spacers when moved
Version 2.9 24.09.2024 HSB-22717 element references improved
Version 2.8 17.09.2024 HSB-21161 debug messages removed
Version 2.7 06.09.2024 HSB-22636 tag also visible in model view
Version 2.6 22.08.2024 HSB-21998 settings introduced to enable custom color coding
Version 2.5 16.08.2024 HSB-21677 jigging items improved
Version 2.4 26.07.2024 HSB-22260 Z-load dimension measured from base point, bugfix on insert with no truck definitions present
Version 2.3 16.07.2024 HSB-22260 load dimensions exposed: @(LoadLength), @(LoadWidth), @(LoadHeight) 
Version 2.2 25.06.2024 HSB-22260 oversizes and load dimensions prepared
Version 2.1 27.02.2024 HSB-21199 A new property 'Number' has been added. The number can be used for formatting and specifies a fixed unique number

Version 2.0 21.12.2023 HSB-20205 wireframe display improved, new format property and grips to display tag
Version 1.9 24.11.2023 HSB-20724 bugfix pack model display
Version 1.8 24.11.2023 HSB-20724 debug messages removed
Version 1.7 17.11.2023 HSB-19662 drag behaviour, parent nesting updated
Version 1.6 08.11.2023 HSB-19664 layer assignment fixed, weight and volume fixed
Version 1.5 24.10.2023 HSB-19659 reference link renamed, default painter definitions made non translateable to support language independent shopdrawing definitions
Version 1.4 18.10.2023 HSB-19659 first beta release
Version 1.3 12.10.2023 HSB-19659 data export and stacking layer assignment added
Version 1.2 29.09.2023 HSB-19659 jigs improved
Version 1.1 27.09.2023 HSB-19659 renamed, layer collection added
Version 1.0 17.01.2023 HSB-17564 initial version of truck definition






















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 3
#MinorVersion 2
#KeyWords 
#BeginContents
//region Part #1

//region <History>
// #Versions
// 3.2 12.02.2025 HSB-23372 fully supporting new behaviour of controlling properties , Author Thorsten Huck
// 3.1 10.01.2025 HSB-22732: Add Axle load calculation , Author: Marsel Nakuci
// 3.0 22.11.2024 HSB-21733 supports relocation of attached spacers when moved , Author Thorsten Huck
// 2.9 24.09.2024 HSB-22717 element references improved , Author Thorsten Huck
// 2.8 17.09.2024 HSB-21161 debug messages removed , Author Thorsten Huck
// 2.7 06.09.2024 HSB-22636 tag also visible in model view , Author Thorsten Huck
// 2.6 22.08.2024 HSB-21998 settings introduced to enable custom color coding
// 2.5 16.08.2024 HSB-21677 jigging items improved , Author Thorsten Huck
// 2.4 26.07.2024 HSB-22260 Z-load dimension measured from base point, bugfix on insert with no truck definitions present , Author Thorsten Huck
// 2.3 16.07.2024 HSB-22260 load dimensions exposed: @(LoadLength), @(LoadWidth), @(LoadHeight) , Author Thorsten Huck
// 2.2 25.06.2024 HSB-22260 oversizes and load dimensions prepared , Author Thorsten Huck
// 2.1 27.02.2024 HSB-21199 A new property 'Number' has been added. The number can be used for formatting and specifies a fixed unique number. , Author Thorsten Huck
// 2.0 21.12.2023 HSB-20205 wireframe display improved, new format property and grips to display tag , Author Thorsten Huck
// 1.9 24.11.2023 HSB-20724 bugfix pack model display , Author Thorsten Huck
// 1.8 24.11.2023 HSB-20724 debug messages removed , Author Thorsten Huck
// 1.7 17.11.2023 HSB-19662 drag behaviour, parent nesting updated , Author Thorsten Huck
// 1.6 08.11.2023 HSB-19664 layer assignment fixed, weight and volume fixed , Author Thorsten Huck
// 1.5 24.10.2023 HSB-19659 reference link renamed, default painter definitions made non translateable to support language independent shopdrawing definitions , Author Thorsten Huck
// 1.4 18.10.2023 HSB-19659 first beta release , Author Thorsten Huck
// 1.3 12.10.2023 HSB-19659 data export and stacking layer assignment added , Author Thorsten Huck
// 1.2 29.09.2023 HSB-19659 jigs improved , Author Thorsten Huck
// 1.1 27.09.2023 HSB-19659 renamed, layer collection added , Author Thorsten Huck
// 1.0 17.01.2023 HSB-17564 initial version of truck definition , Author Thorsten Huck

/// <insert Lang=en>
/// Pick insertion point. If no truck definitions are present as style toggle to edit mode via context menu and create a style
/// </insert>

// <summary Lang=en>
// This tsl displays a truckDefinition and offers methods to maintain truck definitions
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "StackEntity")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Save Definitio|") (_TM "|Select truck definition|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Edit Definition|") (_TM "|Select truck definition|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Load Profile|") (_TM "|Select truck definition|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Set truck display|") (_TM "|Select truck definition|"))) TSLCONTENT

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
	
	int lightgrey = rgb(153,153,153);
	int lightblue = rgb(204,204,255);
	int blue = rgb(69,84,185);	
	int darkblue = rgb(26,50,137);	
	int yellow = rgb(241,235,31);
	int darkyellow = rgb(254, 204, 102);
	int orange = rgb(242,103,34);
	int red = rgb(205,32,39);
	int purple = rgb(147,39,143);
	int petrol = rgb(16,86,137);
	int darkcyan = rgb(0,214,214);
	int green = rgb(19,155,72);	

	Vector3d vecXView = getViewDirection(0);
	Vector3d vecYView = getViewDirection(1);
	Vector3d vecZView = getViewDirection(2);
	double dViewHeight = getViewHeight();	
//endregion 	
	
	String kJigInsert = "JigInsert", kJigDrawRectangle= "JigDrawRectangle", kProperties = "Properties", kTruckData="truckData",
		tEditDefinition = T("|Edit Definition|");
	double dXDefault = U(13600);
	double dYDefault = U(2480);
	double dZDefault = U(2700);

	String sDefinitions[] = TruckDefinition().getAllEntryNames().sorted();
	String tVertical = T("|Vertical|"), tHorizontal = T("|Horizontal|");
	String kLayerIndexStack = "LayerIndexStack", kLayerSubIndexStack = "LayerSubIndexStack";

	String tCRbyPackLayer=T("|byLayer|"), tCRbyPackNumber=T("|byPackNumber|"), tCRbyStackIndex= T("|byStackLayer|"), tColorRules[] ={ tCRbyPackLayer, tCRbyPackNumber, tCRbyStackIndex};

	String kTruckParent = "hsb_TruckParent";
	String kTruckChild = "hsb_TruckChild";
	String kPackageParent = "hsb_PackageParent";
	String kPackageChild = "hsb_PackageChild";
	
	String kDataLink = "DataLink", kData="Data", kScriptItem="StackItem", kScriptPack="StackPack", kScriptStack="StackEntity";
	String sChildScripts[] = { kScriptItem, kScriptPack};
	String sColorName=T("|Color|");	
	
	int nColorStack = grey;
	String kDirKeys[] = { "X_", "Y_", "Z_"};
	int nFaces[] ={ _kXP, _kXN, _kYP, _kYN, _kZP, _kZN};
	
	int bEditDefinition = _Map.getInt("EditDefinition");
	String kGripTagPlan = "Tag", kGripLoc = "Loc", kGripOversize = "Oversize";
	
	Display dpRed(-1),dpOversize(-1),dp(-1), dpWhite(-1),dpText(255) , dpInvisible(0);
	dpOversize.trueColor(orange,70);	
	dpWhite.trueColor(rgb(255, 255, 254), 60);	
	dpText.trueColor(rgb(0, 0, 1));	
	
	dpWhite.addHideDirection(_XW);
	dpWhite.addHideDirection(-_XW);
	dpWhite.addHideDirection(_YW);
	dpWhite.addHideDirection(-_YW);
	dpText.addHideDirection(_XW);
	dpText.addHideDirection(-_XW);
	dpText.addHideDirection(_YW);
	dpText.addHideDirection(-_YW);	

	dpInvisible.addViewDirection(-_ZW);
	
//end Constants//endregion

//region DialogMode
	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode>0)
	{ 
	// Truck Eidt	
		if (nDialogMode == 1) // specify index when triggered to get different dialogs
		{
			setOPMKey("EditTruck");	

		category = T("|Category|");
			String sDefinitionName=T("|Truck Definition|");	
			PropString sDefinition(nStringIndex++, "", sDefinitionName);	
			sDefinition.setDescription(T("|Defines the Definition|"));
			sDefinition.setCategory(category);

		category = T("|Geometry|");
			String sLengthName=T("|Length|");	
			PropDouble dLength(nDoubleIndex++, U(0), sLengthName);	
			dLength.setDescription(T("|Defines the Length|"));
			dLength.setCategory(category);
			
			String sWidthName=T("|Width|");	
			PropDouble dWidth(nDoubleIndex++, U(0), sWidthName);	
			dWidth.setDescription(T("|Defines the Width|"));
			dWidth.setCategory(category);
			
			String sHeightName=T("|Height|");	
			PropDouble dHeight(nDoubleIndex++, U(0), sHeightName);	
			dHeight.setDescription(T("|Defines the Height|"));
			dHeight.setCategory(category);
			
		category = T("|Load Definitions|");
			String sTaraName=T("|Tara|");	
			PropDouble dTara(nDoubleIndex++, U(0), sTaraName,_kNoUnit);	
			dTara.setDescription(T("|Tara defines the difference of gross and net weight of the truck.|"));
			dTara.setCategory(category);
			
			String sMaxGrossName=T("|Gross Weight|");	
			PropDouble dMaxGross(nDoubleIndex++, U(0), sMaxGrossName,_kNoUnit);	
			dMaxGross.setDescription(T("|Defines the max gross weight|"));
			dMaxGross.setCategory(category);
			
		}
		
	// Truck Eidt	
		if (nDialogMode == 2) // specify index when triggered to get different dialogs
		{
			setOPMKey("Settings");	

		category = T("|Item|");
			String sColorRuleName=T("|Color Rule|");	
			PropString sColorRule(nStringIndex++, tColorRules, sColorRuleName);	
			sColorRule.setDescription(T("|Defines how items will be colored in model|"));
			sColorRule.setCategory(category);

		}		
		
		
		return;		
	}
//End DialogMode//endregion

//Part #1 //endregion

//region Part #2

//region Functions



//region Function ExtrudeProfile
	// returns an extruded body from the given planeProfile
	// pp: the profile to be extruded
	Body ExtrudeProfile(PlaneProfile pp, double dExtrude, int zFlag)
	{ 
		Body bd;
		CoordSys cs = pp.coordSys();
		Vector3d vecZ = cs.vecZ();
		PLine rings[] = pp.allRings(true, false);
		
		if (dExtrude>0)
		{ 
			for (int r=0;r<rings.length();r++) 
			{ 
				PLine pl= rings[r]; 
				bd.addPart(Body(pl, vecZ * dExtrude, zFlag));
			}//next r
		}
		
		
		return bd;
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


	//region Function findNextFreeNumber
	// returns the next free number starting from the given value
	// nStart: the start number
	int findNextFreeNumber(int nStart)
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
	}//End //endregion

	//region Function getNumbers
	// returns the amount of appearances of the given number and the array of numbers in use
	// t: the tslInstance to 
	int getNumbers(TslInst stacks[], int& numbers[], int number )
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
	}//End getNumbers //endregion

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


	//region Function getLayerIndices
	// returns
	// t: the tslInstance to 
	Map getLayerIndices(Body bodies[], int& nItemXLayers[], int& nItemYLayers[], int& nItemZLayers[])
	{ 
		Map out;
		Vector3d vecDirs[] ={ _XW, _YW, _ZW};
		for (int v=0;v<vecDirs.length();v++) 
		{ 
			Vector3d vecZ = vecDirs[v]; 
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
			out.setPoint3dArray(kDirKeys[v],ptsDir);
			
		// compare layer locations with each body point	
			for (int i=0;i<ptsC.length();i++) 				
			{ 
				// index i refers to the body
				for (int j=0;j<ptsDir.length();j++) 
				{ 
					double d = abs(vecZ.dotProduct(ptsDir[j]-ptsC[i]));
					if (d<dEps)
					{ 
						if (v == 0)nItemXLayers[i] = j;
						else if (v == 1)nItemYLayers[i] = j;
						else if (v == 2)nItemZLayers[i] = j;
						
						//if (v==2)vecZ.vis(bodies[i].ptCen(),j); // matches the index
						break;
					}
					 
				}//next j				 
			}//next i
		}//next v		
		return out;
	}//End getLayerIndices //endregion

	//region Function: createProfile
	// Creates a planeprofile parallel to _ZW wih a given offset
	// pt1: first point of rectangle
	// pt2: second point of rectangle
	// offset: Z-offset relative to world			
	PlaneProfile createProfile(Point3d pt1, Point3d pt2, double offset)
	{ 
		CoordSys cs();
		cs.transformBy(_ZW * offset);
		PlaneProfile pp(cs);
		PLine pl;
		pl.createRectangle(LineSeg(pt1, pt2), _XW, _YW);
		pp.joinRing(pl, _kAdd);
		return pp;
	}//End createProfile //endregion 

	//region Function: getLoadVolumes
	// Returns bodies as loading volumes from a loading plane by extruding it
	// pp: the planeprofile to be extruded
	// ptCut: the absolute point which defines a horizontal cutting plane 	
	Body[] getLoadVolumes(PlaneProfile pp, Point3d ptCut)
	{ 
		Body bodies[0];	
		CoordSys csp = pp.coordSys();
		int bCut = _ZW.dotProduct(ptCut - csp.ptOrg()) > dEps;		
		PLine rings[] = pp.allRings(true, false);
		
		for (int r=0;r<rings.length();r++) 
		{ 
			Body bd (rings[r],_ZW*U(10e5),1); 
			if (bCut)	bd.addTool(Cut(ptCut, _ZW), 1);
			bodies.append(bd); 
			//bd.vis(3);
		}//next r

		return bodies;
	}//End getLoadVolumes //endregion 

	//region Function: GetVolumeFace
	// Returns the combined planeprofile of all loading volumes on a given face	
	// bodies: the bodies to extract the planeprofiles from
	// face: the face of the quader to be tested: 0=vecX, 1=-vecX, 2=vecY, 3=-vecY, 4=vecZ
	// qdr: the quader to align the faces with
	PlaneProfile GetVolumeFace(Body bodies[], int face, Quader qdr)
	{ 
		Vector3d vecZ = qdr.vecX();
		if (face == 1)vecZ *= -1;
		else if (face == 2)vecZ =qdr.vecY();
		else if (face == 3)vecZ =-qdr.vecY();
		else if (face == 4)vecZ =qdr.vecZ();
		else if (face == 5)vecZ =-qdr.vecZ();
		
		Vector3d vecY = face > 3 ? qdr.vecY() : qdr.vecZ();
		Vector3d vecX = vecY.crossProduct(vecZ);
		
		Plane pnFace = qdr.plFaceD(vecZ);
		CoordSys cs(pnFace.ptOrg(), vecX, vecY, vecZ);
		//cs.vis(4);
		Point3d pts[0];
		for (int i=0;i<bodies.length();i++) 
		{ 
			Body bd = bodies[i];
			pts.append(bd.extremeVertices(vecZ));
		}
		pts = Line(_Pt0, - vecZ).orderPoints(pts, dEps);
		Plane pn = pnFace; // HSB-20205
		if (pts.length()>0)
			pn = Plane(pts.first(), vecZ);

		PlaneProfile ppX(cs);
		for (int i=0;i<bodies.length();i++) 
		{ 
			if (bDebug)bodies[i].vis(i);
			PlaneProfile pp =bodies[i].extractContactFaceInPlane(pn, dEps);//pnFace
			pp.shrink(-dEps);
			ppX.unionWith(pp);
			 
		}//next i
		ppX.shrink(dEps);
		return ppX;
	}//endregion 

	//region Function: createEntPLine
	// Creates a polylines from a planeprofile
	// pp: the planeprofile to be analysed
	// bIsOpening: flags if the voids (grey) or the openings(lightblue) are to be created
	EntPLine[] createEntPLine(PlaneProfile pp, int bIsOpening)
	{
		EntPLine epls[0];
		PLine rings[] = pp.allRings( ! bIsOpening, bIsOpening);
		for (int r = 0; r < rings.length(); r++)
		{
			EntPLine epl;
			epl.dbCreate(rings[r]);
			if (epl.bIsValid())
			{
				epl.setTrueColor(bIsOpening ? lightblue : nColorStack);
				epls.append(epl);
			}
		}//next r
		return epls;
	}//endregion
	
	//region Function getGenBeamTsls
	// returns a boolean if the genbeam has a stacking item attached
	// gb: the genbeam
	int hasStackingClone(GenBeam gb)
	{ 
		int out;
		Entity tents[] = gb.eToolsConnected();
		
		for (int i = 0; i < tents.length(); i++)
		{
			TslInst t = (TslInst)tents[i];
			if (!t.bIsValid()){ continue;}
			if (t.scriptName() == scriptName())
			{
				out = true;
				break;
			}
		}
		
		return out;
	}//Function hasStackingClone //endregion 	
		
	//region Function releaseParent
	// releases the nestingChild info from a parent and resets the _Entity array of the parent
	// returns true if succeeded
	// parent: the parent nesting entity
	// child: the child nesting entity
	int releaseParent(Entity entParent, Entity entChild)
	{ 
		int out;
		TslInst parent = (TslInst)entParent;
		TslInst child = (TslInst)entChild;
		
		if (!parent.bIsValid() || !child.bIsValid() )
		{
			reportNotice("\nStack.releaseParent: parent/child valid " + parent.bIsValid() + !child.bIsValid());
			return out;
		}
		
		Entity childs[] = parent.entity();
		int n = childs.find(child);
		
		if (n>-1)
		{ 
			reportNotice("\nStack.releaseParent: subMapXKeys" + child.subMapXKeys());
			child.removeSubMapX(kTruckParent);

			childs.removeAt(n);
			Map map = parent.map();
			Map m;
			m.setEntityArray(childs, true, "ent[]", "", "ent");
			map.setMap("RemoteSet", m);
			parent.setMap(map);
			parent.transformBy(Vector3d(0, 0, 0));
			//reportNotice("\n" + child.handle() + " to be removed from "+ parent.handle()+" new childs set " + parent.entity().length());
			
			out = true;
		}
		return out;
	}//endregion 
	
	//region Function getItemShadowMap
	// 
	Map getItemShadowMap(Entity entsX[])
	{
		Map out;
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
		out.appendMap("Body[]", mapBodies);
		if (ptsZ.length()>0)
			pp.transformBy(_ZW * _ZW.dotProduct(ptsZ.first() - _PtW));
		out.setPlaneProfile("pp", pp);	
		
		return out;
	}//endregion 

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
	}//endregion

//region Function DrawTag
	// draws a boxed text as overlay
	void DrawTag(String text, Point3d ptLoc, String dimStyle, double textHeight, Display display, int nXFlag)
	{ 
		PLine plBox;
		if (text.length()>0)
		{ 
			double dXTxt = display.textLengthForStyle(text, dimStyle, textHeight);
			double dYTxt = display.textHeightForStyle(text, dimStyle, textHeight);
			
			Vector3d vec = .5 * (_XW * dXTxt - _YW * dYTxt);
			Vector3d vecTrans = nXFlag*_XW*.5*dXTxt;
			//vecTrans= .3 * textHeight*(_XW - _YW);
			ptLoc.transformBy(vecTrans);
	
			plBox.createRectangle(LineSeg(ptLoc-vec, ptLoc+vec), _XW, _YW);
			plBox.offset(textHeight * .3, true);
			dpWhite.draw(PlaneProfile(plBox), _kDrawFilled, 20);
			
			dpText.dimStyle(dimStyle);
			if (textHeight>0)dpText.textHeight(textHeight);
			dpText.draw(text, ptLoc, _XW, _YW, 0 ,0);
		}
		return;
	}//endregion



//region Function GetClosestIndexToPlane
	// returns
	int GetClosestIndexToPlane(Point3d pts[], Point3d pt, Vector3d vecDir)
	{ 
		int out = -1;
		double min = U(10e5);
		
		for (int i=0;i<pts.length();i++) 
		{ 
			double d =vecDir.dotProduct(pt-pts[i]);
			if (d>0 && d<min)
			{ 
				min = d;
				out = i;
			}
			 
		}//next i
		return out;
	
	}
//endregion


//region calcAxleWeights
// This routine does the load distribution at axles
	double[] calcAxleWeights(double _das[], double _dXcog, double _dWeight)
	{ 
		// _das -> x coordinates of each axle
		// _dXcog -> x coordinate of cog
		// _dWeight -> total weight to be distributed
//		Map _mOut;
		double _dWeights[0];
		
		double dSuma, dSumaSquared;
		
		for (int i=0;i<_das.length();i++) 
		{ 
			dSuma+=_das[i];
			dSumaSquared+=(_das[i]*_das[i]);
		}//next i
		int nrAxles=_das.length();
		
		
		
		if(abs(dSuma-_dXcog*nrAxles)>dEps)
		{ 
		// there is a rotation point
		// calc center of rotation
			double dXrot=(_dXcog*dSuma-dSumaSquared)/(dSuma-_dXcog*nrAxles);
			double dRot=_dWeight/(nrAxles*dXrot+dSuma);
			for (int ia=0;ia<_das.length();ia++) 
			{ 
				double dFi=(dXrot+_das[ia])*dRot;
				_dWeights.append(dFi);
			}//next ia
		}
		else
		{ 
		// transversal uniform displacement
			double dFi=_dWeight/nrAxles;
			for (int ia=0;ia<_das.length();ia++) 
			{ 
				_dWeights.append(dFi);
			}//next ia
		}
		return _dWeights;
	}
//endregion//calcAxleWeights


//END Functions //endregion

//region Painters
	String tPDItems = "Stacks";
	String tPDPacks = "Packages";
	String tPDItemPacks = "Items + Packages";
	String tPDSpacers = "Spacer";
	String tPDShowSet = "Show Set";
	String tPDSelectionSet = "Selection Set";
	

// Get or create default painter definition
	String sPainterCollection = "Shopdrawing\\Stacking\\";
	String sPainters[0],sAllPainters[] = PainterDefinition().getAllEntryNames().sorted();
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
				sPainters.append(name);
		}		 
	}//next i

// Create Default Painters	
	if (_bOnInsert || _bOnRecalc || _bOnDebug)
	{ 
		String names[] ={tPDItems, tPDPacks,tPDItemPacks,tPDSpacers, tPDShowSet,tPDSelectionSet};
		String filters[] =
		{
			"ScriptName = 'StackItem'",
			"ScriptName = 'StackPack'",
			"ScriptName = 'StackPack' or (ScriptName = 'StackItem' and Data.hideItemInPage != 1)",
			"ScriptName = 'StackSpacer'",
			"ScriptName = 'StackEntity' or ScriptName = 'StackPack' or ScriptName = 'StackSpacer' or (ScriptName = 'StackItem' and Data.hideItemInPage != 1)",
			"ScriptName = 'StackEntity'"
		};
		String formats[] =
		{
			"@(ColorIndex)", 
			"@(ColorIndex)",
			"@(ColorIndex)",
			"@(Alignment), @(Relation)",
			"@(ScriptName:D)", 
			"@(Description:D)"
		};
		for (int i=0;i<names.length();i++) 
		{ 
			String painter = sPainterCollection + names[i];
			PainterDefinition pd(painter);	
			if (!pd.bIsValid())
			{ 
				reportMessage(TN("|Creating painter| ") + painter);
				
				pd.dbCreate();
				if (pd.bIsValid())
				{ 
					pd.setType("TslInstance");
					if (filters[i].length()>0)pd.setFilter(filters[i]);
					if (formats[i].length()>0)pd.setFormat(formats[i]);
				}
			}				
			if (sPainters.findNoCase(names[i],-1)<0 && pd.bIsValid())
				sPainters.append(names[i]);					
		}
		
	}

	//sPainters.sorted();	
//END Painters //endregion

//region Properties
	String sDescriptionName=T("|Description|");	
	PropString sDescription(nStringIndex++, "", sDescriptionName);	
	sDescription.setDescription(T("|Defines the description of the truck|"));
	sDescription.setCategory(category);
	
	String sDeliveryName=T("|Delivery|");	
	PropString sDelivery(nStringIndex++, "", sDeliveryName);	
	sDelivery.setDescription(T("|Defines the delivery property|"));
	sDelivery.setCategory(category);
	sDelivery.setReadOnly(bEditDefinition ? _kHidden:false);

	String sNumberName=T("|Number|");	
	PropInt nNumber(nIntIndex++, 0, sNumberName);	
	nNumber.setDescription(T("|Defines a unique number of a stack entity.|") + 
		T(" |The existing sequence of numbers will be preserved by incrementing the range of affected numbers when created of modified.|")+ 
		T(" |The value of zero signifies that the subsequent available number, commencing from one, will be allocated.|"));
	nNumber.setCategory(category);
	nNumber.setControlsOtherProperties(true);
	nNumber.setReadOnly(bEditDefinition ? _kHidden:false);
	
	String sDefinitionName=T("|Definition|");	
	PropString sDefinition(nStringIndex++, sDefinitions, sDefinitionName);	
	sDefinition.setDescription(T("|Defines the Definition|"));
	sDefinition.setCategory(category);	

category = T("|Display|");
	String sDimStyleName=T("|DimStyle|");	
	PropString sDimStyle(nStringIndex++, _DimStyles.sorted(), sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the DimStyle|"));
	sDimStyle.setCategory(category);
	
	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(200), sTextHeightName);	
	dTextHeight.setDescription(T("|Defines the text height|") + T(", |0 = byDimstyle|"));
	dTextHeight.setCategory(category);
	
	String sFormatName=T("|Format|");	
	PropString sFormat(nStringIndex++, "@("+T("|Description|")+":D) @("+T("|Number|")+":D)\n@("+T("|Delivery|")+":D)", sFormatName);	
	sFormat.setDescription(T("|Defines the Format|"));
	sFormat.setCategory(category);
	sFormat.setDefinesFormatting(_ThisInst);
	sFormat.setReadOnly(bEditDefinition ? _kHidden:false);
	
category = T("|Load Definitions|");
	String sTaraName=T("|Tara|");	
	PropDouble dTara(nDoubleIndex++, U(0), sTaraName,_kNoUnit);	
	dTara.setDescription(T("|Tara defines the difference of gross and net weight of the truck.|"));
	dTara.setCategory(category);
	dTara.setReadOnly(bEditDefinition ? false: _kReadOnly);
	
	String sMaxGrossName=T("|Gross Weight|");	
	PropDouble dMaxGross(nDoubleIndex++, U(0), sMaxGrossName,_kNoUnit);	
	dMaxGross.setDescription(T("|Defines the max gross weight|"));
	dMaxGross.setCategory(category);
	dMaxGross.setReadOnly(bEditDefinition ? false: _kReadOnly);
	
//region Function setReadOnlyFlagOfProperties
	// sets the readOnlyFlag
	void setReadOnlyFlagOfProperties()
	{ 	
		if (sDefinitions.length() > 0 && sDefinitions.findNoCase(sDefinition ,- 1) < 0)sDefinition.set(sDefinitions.first());
		//sPainter.setReadOnly(_bOnInsert || bDebug ? false : _kHidden);

		return;
	}//endregion	
	
	
//End Properties//endregion 

//region JIG
	String kJigMoveItem = "JigMoveItem";
// Jig Insert
	int bJig;
	if (_bOnJig && _kExecuteKey==kJigInsert) 
	{
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point		
	    ptJig.setZ(0);
	    _Pt0 = ptJig;
	    //_Pt0 += _ZW * _ZW.dotProduct(_PtW - _Pt0);
		_ThisInst.setPropValuesFromMap(_Map.getMap(kProperties));
		bJig = true;
	}
	else if (_bOnJig && _kExecuteKey == kJigDrawRectangle)
	{
		Point3d ptJig = _Map.getPoint3d("_PtJig");
		Point3d pts[] = _Map.getPoint3dArray("pts");
		Vector3d vecX = _Map.getVector3d("vecX");
		
		if (pts.length()>1)
		{ 
			Point3d pt1=pts[0], pt2=pts[1];
			pt1 = pts[0];
			pt2 = pts[1];

			Line lnX(pt1, vecX);
			Vector3d vecY = ptJig-lnX.closestPointTo(ptJig);
			vecY.normalize();
			Vector3d vecZ = vecX.crossProduct(vecY);
			if (!vecZ.isPerpendicularTo(_ZW) && vecZ.dotProduct(_ZW)<0)
			{ 
				vecX *= -1;
				vecZ *= -1;
			}

			PlaneProfile pp; pp.createRectangle(LineSeg(pt1, ptJig), vecX, vecY);
			
			Display dp(-1);
			dp.trueColor(darkyellow, 60);
			dp.draw(pp);
			dp.draw(pp, _kDrawFilled);
		}
		return;
	}
	else if (_bOnJig && _kExecuteKey==kJigMoveItem) 
	{
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point		
	    Point3d ptFrom = _Map.getPoint3d("ptFrom");
	    
	    Map mapBodies = _Map.getMap("Body[]");
	    PlaneProfile pp = _Map.getPlaneProfile("pp");
	    
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
//endregion 

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


//	// sequential colors
//		m = Map();
//		int _nSeqColors[] ={14,144,94,134,174,214,24,64,104,154};
//		for (int i=0;i<_nSeqColors.length();i++) 
//			m.appendInt(i+1,_nSeqColors[i]); 
//		mapSetting.appendMap("SequentialColor[]", m);


	int nColorRule; //byLayerIndex
	{
		String k;
		Map m= mapSetting.getMap("Item");
	
	//	k="DoubleEntry";		if (m.hasDouble(k))	dDoubleEntry = m.getDouble(k);
	//	k="StringEntry";		if (m.hasString(k))	sStringEntry = m.getString(k);
		k="ColorRule";			if (m.hasInt(k))	nColorRule = m.getInt(k);
		
	}//End Read Settings//endregion 
	
	
	
	
//End Settings//endregion	




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
			
			nNumber.set(findNextFreeNumber(nNumber));
			setReadOnlyFlagOfProperties();
			while (showDialog("---") == _kUpdate) // _kUpdate means a controlling property changed.	
			{ 
				setReadOnlyFlagOfProperties(); // need to set hidden state
			}	
			setReadOnlyFlagOfProperties();			
		}

		int nStart = findNextFreeNumber(nNumber);


	// create TSL
		TslInst tslNew;
		GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			
		double dProps[]={dTextHeight,dTara,dMaxGross};				String sProps[]={sDescription,sDelivery,sDefinition,sDimStyle,sFormat};
		Map mapTsl;	
		// for the creation of axle
		TslInst tslNewAxle;
		GenBeam gbsTslAxle[] = {}; Entity entsTslAxle[1];Point3d ptsTslAxle[] = {_Pt0};
		double dPropsAxle[]={}; String sPropsAxle[]={};int nPropsAxle[]={};
		Map mapTslAxle;
				

	//region Show Jig
		PrPoint ssP(T("|Select location|"));
	    Map mapArgs;
		mapArgs.setMap(kProperties, mapWithPropValues());
	    int nGoJig = -1;
	    while (nGoJig != _kNone)
	    {
	        nGoJig = ssP.goJig(kJigInsert, mapArgs); 
  
	        if (nGoJig == _kOk)
	        {
	            Point3d pt = ssP.value(); //retrieve the selected point
				Point3d ptsTsl[] = {pt};
				int nProps[]={nStart};
			
				tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			
				if (tslNew.bIsValid())
				{ 
					nStart = findNextFreeNumber(nStart);
					// insert StackAxle
					entsTslAxle[0]=tslNew;
					tslNew.dbCreate("StackAxle",_XW,_YW,gbsTslAxle, entsTslAxle, 
						ptsTslAxle, nPropsAxle, dPropsAxle, sPropsAxle,_kModelSpace, mapTslAxle);			
				}
				
				
				if (sDefinitions.find(sDefinition)<0) // do not insert multiple times when no definition found
					break;
	        }
	        else if (nGoJig == _kCancel)
	        { 
	            eraseInstance(); // do not insert this instance
	            return; 
	        }
	    }			
	//End Show Jig//endregion 

		eraseInstance();
		return;
	}	
	setReadOnlyFlagOfProperties();	
//endregion 

//region Displays
	dpRed.trueColor(red);
	dpRed.dimStyle(sDimStyle);
	dp.dimStyle(sDimStyle);
	double textHeight = dTextHeight;
	if (textHeight>0)dp.textHeight(textHeight);
	else textHeight = dp.textHeightForStyle("O", sDimStyle);
	dpRed.textHeight(textHeight);
	dpText.textHeight(textHeight);
//endregion 


//region Trigger SelectReference // workaround for HSB-22564
	String sTriggerSelectReference = T("|Set Reference|");
	if (bDebug)addRecalcTrigger(_kContextRoot, sTriggerSelectReference );
	if (_bOnRecalc && _kExecuteKey==sTriggerSelectReference)
	{
		_Map.setEntity("Ref", _ThisInst);		
		setExecutionLoops(2);
		return;
	}
	TslInst this = _ThisInst;
	if (bDebug)
	{ 
		Entity ent = _Map.getEntity("Ref");
		if (ent.bIsValid())
			this = (TslInst)ent;
	}//endregion



//region Unique Sequence Number Control
	TslInst stacks[0];
	{ 
		Entity ents[0];
		String names[] ={ (bDebug ? "StackEntity" : scriptName())};
		stacks= FilterTslsByName(ents, names);
	}

	int nNumbers[0], nNumberAppearance= nNumber<1?0:getNumbers(stacks, nNumbers, nNumber);
	
// On modifying the number adjust affected instances	
	if (_kNameLastChangedProp == sNumberName && nNumber>0 && nNumberAppearance>0)	
	{ 
		
	// order by number
		for (int i=0;i<stacks.length();i++) 
			for (int j=0;j<stacks.length()-1;j++) 
			{
				int n1 = nNumbers[j];
				int n2 = nNumbers[j+1];
				
				if (n1>n2)
				{
					stacks.swap(j, j + 1);
					nNumbers.swap(j, j + 1);
				}
			}	
			
	// remove thisInst
		int n = stacks.find(_ThisInst);
		if (n>-1)
		{ 
			nNumbers.removeAt(n);
			stacks.removeAt(n);
		}
			
	// collect stacks to renumber if occupied
		int numbersX[0];
		TslInst stacksX[0];
		int xStart = nNumbers.find(nNumber);
		if (xStart>-1)
		{ 
			for (int i=xStart;i<stacks.length();i++) 
			{ 
				TslInst& t= stacks[i]; 
				int num = t.propInt(0);

				if (numbersX.length()==0 || (numbersX.length()>0 && numbersX.last()==num))
				{
					num++;
					numbersX.append(num);
					stacksX.append(t);
				}
			}//next i			
		}
	
	// Renumber topdown
		for (int i=stacksX.length()-1; i>=0 ; i--) 
		{ 			
			TslInst& t=stacksX[i]; 
			reportMessage("\n" + t.propString(2)+ T(" |renumbered from| ") + t.propInt(0) + " -> "+ numbersX[i]);
			t.setPropInt(0, numbersX[i]);
		}//next i

		setExecutionLoops(2);
		return;					

	}
	
// Auto Renumber on Copy or when number is set to <=0	
	if (nNumberAppearance>1 || nNumber<=0)// && 
	{ 
		int newNumber = findNextFreeNumber(nNumber);
		reportMessage("\n" + sDefinition+ T(" |renumbered from| ") + nNumber + " -> "+ newNumber);
		nNumber.set(newNumber);
		setExecutionLoops(2);
		return;
	}

//endregion 




//Part #2 //endregion

//region TruckDefinition

	TruckDefinition td(sDefinition);
	int bValid = sDefinitions.findNoCase(sDefinition ,- 1) >- 1 && td.bIsValid();
	double dX = bValid?td.length():dXDefault;
	double dY = bValid?td.width():dYDefault;
	double dZ = bValid?td.height():dZDefault;
	
	double dAllowedOversizes[0];
	for (int i=0;i<nFaces.length();i++) 
		dAllowedOversizes.append(bValid?td.allowedOversize(nFaces[i]):0); 
	String kAsynchronWidth ="AsynchronousOversizeWidth"; 
	int bAsynchronousOversize = _Map.getInt(kAsynchronWidth);	
//endregion 

//region Grip Management #GM 1
	addRecalcTrigger(_kGripPointDrag, "_Grip");	
	_ThisInst.setAllowGripAtPt0(bDebug);
	//if (bEditDefinition)_Grip.setLength(0);
	
	int indexOfMovedGrip = Grip().indexOfMovedGrip(_Grip);
	Grip grip;
	Vector3d vecOffsetApplied;
	int bDrag, bOnDragEnd,bDragTag, bDragLoc;
	if (indexOfMovedGrip>-1)
	{ 
		bDrag = _bOnGripPointDrag && _kExecuteKey=="_Grip";
		bOnDragEnd = !_bOnGripPointDrag;
		
		Grip& g = _Grip[indexOfMovedGrip];	
		grip = g;
		vecOffsetApplied = grip.vecOffsetApplied();
		String name = grip.name();

		if (name.find(kGripTagPlan,0,false)==0)
			bDragTag = true;
		else if (name.find(kGripLoc,0,false)==0)
			bDragLoc = true;

		if (bOnDragEnd && bDragLoc)
		{
//			_Pt0 += vecOffsetApplied;
//			_Pt0.setZ(0);
			
			Point3d pt = g.ptLoc();
			pt.setZ(0);
			g.setPtLoc(pt);
		}
		
		
	//region Synchronous oversize change
		if (!bAsynchronousOversize)
		{ 
			String names[] = { kGripOversize + "2", kGripOversize + "3" };
			int nSync = names.findNoCase(name ,- 1);
			if (nSync>-1)
			{ 
				String other = nSync == 0 ?names[1]:names[0] ;
				int indexOther = GetGripIndexByName(_Grip, other);
				Point3d pt = _Grip[indexOther].ptLoc();
				pt.transformBy(-vecOffsetApplied);
				_Grip[indexOther].setPtLoc(pt);
			}			
		}
		
	//endregion 

	
	}

// Location
	Point3d ptLoc = _Pt0;
	int nGripLoc = bJig?-1:GetGripIndexByName(_Grip, kGripLoc);
	if (nGripLoc>-1)
	{ 
		ptLoc = _Grip[nGripLoc].ptLoc();
//		if (!bDragLoc)
//			_Pt0 = ptLoc;
	}
	ptLoc.setZ(0);	
	
// Tagging Grip 
	int nGripTag = bJig?-1:GetGripIndexByName(_Grip, kGripTagPlan);
	Point3d ptTagPlan = ptLoc - _YW * (.5 * dY + 2*textHeight);
	if (nGripTag>-1)
	{
	// no tag grip if format is empty	
		if (sFormat.length()<1)
		{ 
			_Grip.removeAt(nGripTag);
			nGripTag = -1;			
		}
		else
		{ 
			Grip& g = _Grip[nGripTag];
			Point3d pt = g.ptLoc();
			if (bOnDragEnd && bDragLoc)
			{
				pt += vecOffsetApplied;
				pt.setZ(0);
				g.setPtLoc(pt);		
			}
			ptTagPlan=pt;			
		}
	}

//region Add Grips
	int nGrips[] ={ nGripLoc, nGripTag};
	if (!bEditDefinition && !bJig)
	{ 
		for (int i=0;i<nGrips.length();i++) 
		{ 
			if (i==1 && sFormat.length()<1){ continue;}// no tag grip
	
			int& n = nGrips[i]; 
			if (n<0)
			{ 
				Point3d pt = i == 0 ? ptLoc : ptLoc - _YW * (.5 * dY + 2*textHeight);
		
				Grip g;
				g.setPtLoc(pt);
				g.setVecX(_XW);
				g.setVecY(_YW);
				//g.setIsRelativeToEcs(false);
				g.setColor(i==0?255:40);
				g.setShapeType(_kGSTCircle);
				g.setName(i==0?kGripLoc:kGripTagPlan);
				g.setToolTip(i==0?T("|Moves the stack and all associated packs and items|"):T("|Specifies tag location|"));	
				if (i == 1)g.addViewDirection(_ZW);
				_Grip.append(g); 
				
				n = _Grip.length();
	
			}	
		}//next i		
	}

	_Pt0.vis(6);	ptLoc.vis(1);	ptTagPlan.vis(2);		
//endregion 	


//Grip Management 1 //endregion 

//region Defaults
	Vector3d vecX = _XW;
	Vector3d vecY = _YW;
	Vector3d vecZ = _ZW;
	Point3d ptOrg = ptLoc;
	CoordSys cs = CoordSys(ptOrg, vecX, vecY, vecZ);
	CoordSys csInv = cs;
	csInv.invert();

	CoordSys csParent(ptOrg+vecX*.5*dX, vecX, vecY, vecZ);
	_ThisInst.setSequenceNumber(3);
	_ThisInst.setDrawOrderToFront(300);
	//reportNotice("\nStarting " + _ThisInst.scriptName() + " " + _ThisInst.handle());

	Quader qdr = td.quader();
	qdr.transformBy(cs);//qdr.vis(4);

	Map mapTruckData;
	PlaneProfile pps[0]; 
	if (bValid)
	{
		pps= td.loadProfiles();
		setDependencyOnDictObject(td);
		mapTruckData = td.subMapX(kTruckData);
		_ThisInst.setSubMapX(kTruckData, mapTruckData);
	}
	else // show some kind of default
	{ 
		qdr = Quader(_Pt0, vecX, vecY, vecZ, dX, dY, dZ, 1 , 0, 1);
		PlaneProfile pp;
		pp.createRectangle(LineSeg(_Pt0 - vecY * .5 * dY, _Pt0 + vecX * dX + vecY * .5 * dY), vecX, vecY);
		pp.transformBy(csInv);
		pps.append(pp);
		
		dp.trueColor(red);
		String text = scriptName() + " " + sDefinition;
		text += "\n" + T("|No truck definitions found.|");
		text += "\n" + T("|Please import truck definition styles or create a definition using context command|\n'" + tEditDefinition + "'");
		
		double x = dp.textLengthForStyle(text, sDimStyle, textHeight);
		double y = dp.textHeightForStyle(text, sDimStyle, textHeight);
		
		if (x>0 && y>0)
		{ 
			double d1 = (dXDefault-2*textHeight) / x;
			double d2 = (dYDefault-2*textHeight) / y;	
			double f = d1 < d2 ? d1 : d2;
			dp.textHeight(f*textHeight);
		}
	
		dp.draw(text, ptOrg+vecX*textHeight, vecX, vecY, 1, 0);
		
		
		
	}
	
	if (!bEditDefinition)
	{ 
		double tara = mapTruckData.getDouble("Tara");
		if (abs(tara-dTara)>dEps)
			dTara.set(tara);
		
		double gros = mapTruckData.getDouble("GrosWeight");
		if (abs(gros-dMaxGross)>dEps)
			dMaxGross.set(gros);	
	}
	
	

	
//endregion

//region Edit Mode
	
// Trigger to Edit or Save a TruckDefinition	
	String sTriggerEditDefinition =bEditDefinition?T("|Save Definition|"):tEditDefinition;
	addRecalcTrigger(bEditDefinition?_kContextRoot:_kContext, sTriggerEditDefinition);
	if (_bOnRecalc && _kExecuteKey==sTriggerEditDefinition)
	{
		bEditDefinition = bEditDefinition ? false : true;
		_Map.setInt("EditDefinition", bEditDefinition);	
		
		if (bEditDefinition)
		{
		// create Dialog instance
			TslInst tslDialog;			Map mapTsl;
			GenBeam gbsTsl[] = { };		Entity entsTsl[] = { };			Point3d ptsTsl[] = { _Pt0};
			int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };

			mapTsl.setInt("DialogMode", 1);
			sProps.append(sDefinition);

			dProps.append(dX);
			dProps.append(dY);
			dProps.append(dZ);

			dProps.append(dTara);
			dProps.append(dMaxGross);

			tslDialog.dbCreate(scriptName() , _XW, _YW, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
			if (tslDialog.bIsValid())
			{
				int bOk = tslDialog.showDialog();
				if (bOk)
				{ 
					String definition = tslDialog.propString(0);
					
					dX = tslDialog.propDouble(0);
					dY = tslDialog.propDouble(1);
					dZ = tslDialog.propDouble(2);
					
					dTara.set(tslDialog.propDouble(3));
					dMaxGross.set(tslDialog.propDouble(4));
					
					mapTruckData.setDouble("Tara", dTara);
					mapTruckData.setDouble("GrosWeight", dMaxGross);
					mapTruckData.setDouble("Length", dX);
					mapTruckData.setDouble("Width", dY);
					mapTruckData.setDouble("Height", dZ);


				// truck definition exists	
					td=TruckDefinition(definition);
					// new definition
					if (sDefinitions.find(definition) < 0)
					{
						td.dbCreate();
						sDefinition.set(definition);
					}
					td.setLength(dX);
					td.setWidth(dY);
					td.setHeight(dZ);	
				
					//td.setAllowedOversize(int side, double dVal);
				
				
					td.setSubMapX(kTruckData, mapTruckData);
					
				}
				tslDialog.dbErase();
			}
		}
		else
		{ 
			mapTruckData.setDouble("Tara", dTara);
			mapTruckData.setDouble("GrosWeight", dMaxGross);
			td.setSubMapX(kTruckData, mapTruckData);
		}
		
	}

//region Collect defining load plines and reassign to load profiles
		
// Collect entPLines from _Map	
	EntPLine epls[0];
	{ 
		Entity ents[] = _Map.getEntityArray("Entity[]", "", "Entity");
		for (int i=0;i<ents.length();i++) 
		{ 
			EntPLine epl = (EntPLine)ents[i];
			if (epl.bIsValid())
				epls.append(epl);		 
		}//next i		
	}

	int bHasEpl = epls.length() > 0;

// create definining polylines from loadProfiles
	if (bEditDefinition && epls.length()<1)
	{ 
		for (int i=0;i<pps.length();i++) 
		{ 
			PlaneProfile pp= pps[i]; 
			pp.transformBy(cs);
			epls.append(createEntPLine(pp, false));
		}//next i	
		_Map.setEntityArray(epls, true,"Entity[]", "", "Entity");
	}
	
// collect defining envelopes and openings	
	PLine plEnvelopes[0], plOpenings[0];
	for (int i=0;i<epls.length();i++) 
	{ 
		EntPLine epl = (EntPLine)epls[i];
		_Entity.append(epl);
		setDependencyOnEntity(epl);
		
		int bIsOpening = epl.trueColor() == lightblue;
		
		PLine pl = epl.getPLine();
		pl.transformBy(csInv);
		if (bIsOpening)
			plOpenings.append(pl);
		else
			plEnvelopes.append(pl);
	}//next i
	
// rebuild profiles from envelopes and openings	
	PlaneProfile pps2[0];
	for (int i=0;i<plEnvelopes.length();i++) 
	{ 
		PlaneProfile pp(plEnvelopes[i]);
		pps2.append(pp);		 
	}//next i
	for (int i=0;i<pps2.length();i++) 
	{ 
		CoordSys csi = pps2[i].coordSys();
		for (int j=0;j<plOpenings.length();j++) 
		{ 
			CoordSys csj = plOpenings[j].coordSys();
			if (csi.vecZ().isCodirectionalTo(csj.vecZ()))//TODO check offset
			{ 
				pps2[i].joinRing(plOpenings[j], _kSubtract);
			}		 
		}//next i			
	}

// Update and Store
	if (pps2.length()>0)
	{
		pps = pps2;			
		if (bEditDefinition && !bHasEpl)
		{ 
			pushCommandOnCommandStack("HSB_RECALC");
 			pushCommandOnCommandStack("(handent \""+_ThisInst.handle()+"\")");	
 			pushCommandOnCommandStack("(Command \"\")");
		}
		else if(!bEditDefinition)
		{ 
			td.setLoadProfiles(pps);
			for (int i=epls.length()-1; i>=0 ; i--) 
			{ 
				EntPLine e = epls[i];
				
				if (e.bIsValid())
				{
					int n = _Entity.find(e);
					if (n >- 1)_Entity.removeAt(n);
					e.dbErase(); 
				}
			}//next i
			_Map.removeAt("Entity[]", true);
		}
	}
// End Collect defining load plines //endregion 

//region Edit Trigger

	if (bEditDefinition)
	{ 
	
	//region TriggerAddLoadProfile
		String sTriggerAddLoadProfile = T("|Add Load Profile|");
		addRecalcTrigger(_kContextRoot, sTriggerAddLoadProfile );
		if (_bOnRecalc && _kExecuteKey==sTriggerAddLoadProfile)
		{
			Point3d pts[0];
		// prompt for point input
			PrPoint ssP(TN("|Pick first point|") + T(", |<Enter> to select existing polylines|")); 
			if (ssP.go()==_kOk) 
			{
				pts.append(ssP.value()); // append the selected points to the list of grippoints _PtG

				ssP = PrPoint (TN("|Pick second point on axis|"),pts.first()); 
				if (ssP.go()==_kOk) 
				{
					pts.append(ssP.value()); // append the selected points to the list of grippoints _PtG
				
					Vector3d vecX1 = pts[1] - pts[0];
					vecX1.normalize();
	
					ssP = PrPoint (T("|Select second point|"));// [RotateX]
				    Map mapArgs;
				    mapArgs.setPoint3dArray("pts", pts);
				    mapArgs.setVector3d("vecX", vecX1);
				    
				    int nGoJig = -1;
				    while (nGoJig != _kOk && nGoJig != _kNone)
				    {
				        nGoJig = ssP.goJig(kJigDrawRectangle, mapArgs); 
				        if (bDebug)reportMessage("\ngoJig returned: " + nGoJig);
				        
				        if (nGoJig == _kOk)
				        {
				            pts.append(ssP.value()); //retrieve the selected point
				        }
				        else if (nGoJig == _kKeyWord)
				        { 
				            if (ssP.keywordIndex() == 0)
				                mapArgs.setInt("isLeft", TRUE);
				        }
				        else if (nGoJig == _kCancel)
				        { 
				            return; 
				        }
				    }
	
					if (pts.length()>2)
					{ 
						Line lnX(pts[0], vecX1);
						Vector3d vecY1 = pts[2]-lnX.closestPointTo(pts[2]);
						vecY1.normalize();
						Vector3d vecZ1 = vecX1.crossProduct(vecY1);
						if (!vecZ1.isPerpendicularTo(_ZW) && vecZ1.dotProduct(_ZW)<0)
						{ 
							vecX1 *= -1;
							vecZ1 *= -1;
						}
						
						PLine pl; pl.createRectangle(LineSeg(pts[0], pts[2]), vecX1, vecY1);
						if (pl.area()>pow(dEps,2))
						{ 
							EntPLine epl;
							epl.dbCreate(pl);
							epl.setTrueColor(nColorStack);
							_Entity.append(epl);
							
							epls.append(epl);
							_Map.setEntityArray(epls, true,"Entity[]", "", "Entity");
						}
					}
				}
			}
		// Select existing polylines	
			else
			{ 
			// prompt for polylines
				Entity ents[0];
				PrEntity ssEpl(T("|Select polylines|"), EntPLine());
			  	if (ssEpl.go())
					ents.append(ssEpl.set());
					
			// Remove duplicates
				for (int i=ents.length()-1; i>=0 ; i--) 
				{ 
					EntPLine epl = (EntPLine)ents[i];
					if (!epl.bIsValid() || epls.find(epl)>-1)
					{
						ents.removeAt(i); 
						continue;
					}
					epls.append(epl);
				}//next i
				
			// Append
				_Entity.append(ents);
				_Map.setEntityArray(epls, true,"Entity[]", "", "Entity");			
			}

			setExecutionLoops(2);
			return;
		}//endregion	

		String sTriggerDefineDisplay = T("|Set truck display|");
		addRecalcTrigger(_kContextRoot, sTriggerDefineDisplay );
		if (_bOnRecalc && _kExecuteKey == sTriggerDefineDisplay )
		{
			Display adp(-1);
			adp.showInTslInst(0);
			td.setDisplay(adp);
			//adp.draw("Test tekst", _Pt0, _XU, _YU, 0, 0);
			
			PrEntity ssE(T("|Select a set of body entities that define the graphical representation of the truck|"), Entity());
			if (ssE.go()) 
			{
				Entity ents[] = ssE.set();
				for (int e = 0; e < ents.length(); e++)
				{ 
					Body body = ents[e].realBody(_XW+_YW+_ZW);
					
					if (body.isNull())
						continue;
					body.transformBy(csInv);	
					adp.draw(body);
				}
			}
			
			td.setDisplay(adp);
			setExecutionLoops(2);
			return;
		}			
	}
	else
		_Map.removeAt("EditDefinition", true);

//endregion 


//region Get Extents
	if (bEditDefinition)
	{ 
		PlaneProfile ppRange(cs);
		for (int i=0;i<pps.length();i++) 
		{ 
			PlaneProfile pp = pps[i];
			pp.transformBy(ptLoc - _PtW);
			ppRange.unionWith(pp); 			 
		}//next i
		ppRange.extentInDir(_XW).vis(6);	
		
		double dX = ppRange.dX();
		double dY = ppRange.dY();
		_Pt0 = ppRange.ptMid() - _XW * .5 * dX;
		ptLoc = _Pt0;
		
		td.setLength(dX);
		td.setWidth(dY);
		//td.setHeight(dZ);	

		mapTruckData.setDouble("Length", dX);
		mapTruckData.setDouble("Width", dY);
		mapTruckData.setDouble("Height", dZ);



		td.setSubMapX(kTruckData, mapTruckData);
							
		
		
	}

//endregion 


//End Edit Mode //endregion 

//region Stack Mode
	String sWriteEvents[] = { sDescriptionName, sDefinitionName};
	int bWriteStackX = sWriteEvents.findNoCase(_kNameLastChangedProp,-1)>-1;
	String handle = this.handle();

//region Remove and/or Collect entities
	if (_Map.hasMap("RemoteSet"))
	{ 
		int n0 = _Entity.length();
		Map m = _Map.getMap("RemoteSet");
		_Entity=m.getEntityArray("ent[]", "", "ent");
		_Map.removeAt("RemoteSet", true);
		if (bDebug)reportNotice("\n"+scriptName() + " remote reset of _Entity from " +n0 + " to " +_Entity.length());		
	}
	else if (_Map.hasMap("AppendRemoteSet"))
	{ 		
		Map m = _Map.getMap("AppendRemoteSet");
		Entity ents[]=m.getEntityArray("ent[]", "", "ent");
		int n = ents.length();
		_Entity.append(ents);
		_Map.removeAt("AppendRemoteSet", true);
		if (bDebug)reportNotice("\n"+scriptName() + " "+ n + " remotely appendend to _Entity( "+ _Entity.length()+ ")");		
	}
		
// remove entities which are linked to another Stack entity
	if (!bDebug)
	for (int i=_Entity.length()-1; i>=0 ; i--) 
	{ 
		Entity& e= _Entity[i];  
		Map mapX = e.subMapX(kTruckChild);
		String parentHandle = mapX.getString("ParentHandle");
		if(parentHandle!=handle)
		{ 
			Entity entParent; entParent.setFromHandle(parentHandle);
			if (!bDrag && entParent.bIsValid() && entParent!=this)
			{ 
				reportMessage("\n" + T("|Removing duplicate assignment of| ") +entParent);
				_Entity.removeAt(i);
				setExecutionLoops(2);
			}
		}				
	}//next i	
	
	
	Entity ents[0];
	Entity entMovableSpacers[0];
	for (int i=0;i<_Entity.length();i++) 
	{ 
		Entity& e= _Entity[i]; 
		
	// do not add dependency and do not add to ents[] if of type spacer
		if (e.formatObject("@(ScriptName:D)").makeUpper() == "STACKSPACER")
		{
			entMovableSpacers.append(e);
			continue;
		}		
		
		setDependencyOnEntity(e);
		ents.append(e);	 
	}//next i
	
//endregion

//region Move Items when Base Grip is dragged
	if (_kNameLastChangedProp=="_Pt0" || (indexOfMovedGrip>-1 && indexOfMovedGrip==nGripLoc))
	{ 
		//Get parent mapX with Nesting info
		Map mapX = _ThisInst.subMapX(kTruckParent);
		if (mapX.hasPoint3d("ptOrg"))
		{ 
			Point3d ptFrom = mapX.getPoint3d("ptOrg");
			Point3d ptTo = ptLoc;
			//ptTo.setZ(0);
			
			Entity entMoves[0];
			for (int i=0;i<ents.length();i++) 
			{ 
				Entity e= ents[i];  
				TslInst t =(TslInst)e;
				
			// append items of pack	
				if (t.bIsValid() && kScriptPack.find(t.scriptName(),0,false)==0)
					entMoves.append(t.entity());
			// append pack or item of stack
				entMoves.append(e);
			}

			Vector3d vec = ptTo - ptFrom;
			for (int i=0;i<entMoves.length();i++) 
				entMoves[i].transformBy(vec); 
			for (int i=0;i<entMovableSpacers.length();i++) 
			{
				Entity e= entMovableSpacers[i]; 
				e.transformBy(Vector3d(0,0,0)); 				
			}
			//reportNotice("\nStack is moving spacers " +entMovableSpacers);
		}
		
	//region Move other grips (oversize) if location has changed
		if (indexOfMovedGrip==nGripLoc && bOnDragEnd)	
		{ 
			for (int i=0;i<_Grip.length();i++) 
			{ 
				if (i!=nGripLoc)
				{ 
					Grip& g = _Grip[i];
					Point3d pt = g.ptLoc();
					pt.transformBy(vecOffsetApplied);
					g.setPtLoc(pt);
				}	
			}//next i
		}
	//endregion 	
		
		
		
		
		
		setExecutionLoops(2);
		return;
	}
//endregion 

//region Draw Loading Profiles and publish loadable planes
	
	Map mapX;
	Body bdVolumes[0], bdOversizeVolumes[0];
	Point3d ptTop = ptLoc + vecZ * dZ;
	int bHasChilds = ents.length() > 0;
	dp.trueColor(bEditDefinition?darkyellow:nColorStack, bEditDefinition?50:(bHasChilds>0?0:90));
	PlaneProfile ppsT[0];
	for (int i=0;i<pps.length();i++) 
	{ 
		PlaneProfile pp= pps[i]; 
		pp.transformBy(cs);	pp.extentInDir(_XW).vis(i);
		ppsT.append(pp);
		if (!bDebug)
			dp.draw(pp, bEditDefinition?_kDrawFilled:(bHasChilds?0:60));
		//dp.draw(pp, _kDrawFilled,20);
		if (bDebug)dp.color(i + 1);
		dp.draw(pp);
		
		mapX.appendPlaneProfile("pp", pp);
		
	// get loadable volume	
		bdVolumes.append(getLoadVolumes(pp, ptTop)); // must cut at top
	}//next i

		
	Point3d ptTopOver = ptTop;
	{ 
		String name = kGripOversize + 4;
		int index = GetGripIndexByName(_Grip, name);
		if (index>-1)
			ptTopOver = _Grip[index].ptLoc();
	}
	
	for (int i=0;i<ppsT.length();i++) 
	{ 
		PlaneProfile& pp= ppsT[i]; 
		//pp.transformBy(cs);	pp.extentInDir(_XW).vis(i);
		Point3d ptsT[] = pp.getGripEdgeMidPoints();


	// Oversize Profile
		for (int f=0;f<4;f++) 
		{ 
			int face = nFaces[f];
			String name = kGripOversize + f;
			int index = GetGripIndexByName(_Grip, name);
			
			if (index>-1)
			{ 
				PlaneProfile ppf=GetVolumeFace(bdVolumes, face, qdr);
				
				
				
				CoordSys csf = ppf.coordSys();
				Vector3d vecZF = csf.vecZ();
				Point3d pt = csf.ptOrg();
				
				Grip& g = _Grip[index];
				Point3d ptLoc = g.ptLoc();
				//vecZF.vis(ptLoc,2);
				
			// stretchable
				int vertex = GetClosestIndexToPlane(ptsT, ptLoc, vecZF);
				if (vertex>-1)
				{
					double d = vecZF.dotProduct(ptLoc - ptsT[vertex]);
					pp.moveGripEdgeMidPointAt(vertex, vecZF * d);
					//dpOversize.draw(pp);//, _kDrawFilled, 30);
				}				

			}
			ptsT= pp.getGripEdgeMidPoints(); 
		}//next f


		bdOversizeVolumes.append(getLoadVolumes(pp, ptTopOver)); // must cut at top
		//dpOversize.draw(pp, _kDrawFilled, 30);

	}//next i	

	
	
	
	// draw a tiny body to get the instance displayed in shopdrawing
	//dp.draw(Body(ptLoc, _XW, _YW, _ZW, dEps, dEps, dEps, - 1, 0, 1));
	for (int i=0;i<pps.length();i++) 
	{ 
		PlaneProfile pp = pps[i];
		pp.transformBy(cs);	
		Body bd = ExtrudeProfile(pp, dEps,-1);
		dp.draw(bd);


	}//next i
	
	
	
	
	//_ThisInst.setSubMapX("Stacking", mapX);
	dp.transparency(30);
	
	//Draw Loadable Volume and TruckDefinition		
	PlaneProfile ppFaces[0];
	PlaneProfile ppShapeZ(cs), ppShapeY(CoordSys(cs.ptOrg(), vecX, vecZ, -vecY));
	
	for (int i=0;i<nFaces.length();i++) 
	{ 
		PlaneProfile pp=GetVolumeFace(bdVolumes, nFaces[i], qdr);
		CoordSys csf = pp.coordSys();
		Vector3d vecZF = csf.vecZ();
		
		//if (bDebug){ Display dpx(i+1); dpx.draw(pp,_kDrawFilled,20);}
		if (vecZF.isParallelTo(vecZ))
			ppShapeZ.unionWith(pp);
		else if (vecZF.isParallelTo(vecY))
		{
			ppShapeY.unionWith(pp);
		}
			


		if (i<4)
		{
			dp.draw(pp);	
		}
	
		//csf.vecZ().vis(csf.ptOrg(),i);
		ppFaces.append(pp);
		
	}//next i		
	dp.draw(td, cs);
	
	_Map.setPlaneProfile("ShapeY", ppShapeY);
	_Map.setPlaneProfile("ShapeZ", ppShapeZ);
	
//	if (bDebug){ Display dpx(3); dpx.draw(ppShapeY,_kDrawFilled,20);}
//	if (bDebug){ Display dpx(150); dpx.draw(ppShapeZ,_kDrawFilled,20);}
//endregion 

//region Oversize Display
	Body bdOversize;
	double dOversizes[nFaces.length()];
	if (!bJig)
	{ 
		for (int i=0;i<ppFaces.length();i++) 
		{ 
			PlaneProfile ppFace= ppFaces[i]; 
			CoordSys csf = ppFace.coordSys();
			Vector3d vecZF = csf.vecZ();
			Point3d pt = csf.ptOrg();
			Point3d pts[] = ppFace.getGripVertexPoints();
			
		// Get/Set Grip
			if (i<5)
			{ 
				String name = kGripOversize + i;
				int index = GetGripIndexByName(_Grip, name);
				
				if (i == 1)pt.transformBy(_YW * U(200)); // avoid collision with base location grip
				Line ln(pt, vecZF);
				
			// Add Grip	
				if (index<0)
				{ 
	
					Vector3d vecXG = vecZF;
					Vector3d vecYG = vecXG.crossProduct(i>3?_YW:_ZW);
	
					Grip g;
					g.setPtLoc(pt);
					g.setVecX(vecXG);
					g.setVecY(vecYG);
//					g.setIsRelativeToEcs(false);
					g.setColor(252);
					g.setShapeType(_kGSTArrow);
					g.setName(name);
					g.setToolTip(T("|Sets the allowed oversize in the indicated direction|"));	
					g.addHideDirection(-vecZF);
					g.addHideDirection(vecZF);
					_Grip.append(g); 
					index = _Grip.length();
				}
			// avoid grips to be inside	
				else
				{ 
					Grip& g = _Grip[index];
					Point3d ptLoc = g.ptLoc();
					ptLoc = ln.closestPointTo(ptLoc);
					double oversize = vecZF.dotProduct(ptLoc - pt);
					if (oversize<dEps)
					{
						ptLoc=pt;
						g.setColor(253);
					}
					else 
					{
						dOversizes[i] = oversize;
						if (g.color()!=20)
							g.setColor(20);
					}
						
					if ((ptLoc-g.ptLoc()).length()>dEps)
						g.setPtLoc(ptLoc);
//					g.setIsRelativeToEcs(true);	
					Vector3d vecN = vecZF * vecZF.dotProduct(ptLoc - pt);
					
					PlaneProfile pp2 = ppFace;
					
					Plane png(ptLoc, vecZF);
					pp2.transformBy(vecN);
					for (int j=0;j<bdOversizeVolumes.length();j++) 
					{ 
						PlaneProfile ppj = bdOversizeVolumes[j].shadowProfile(png); 
						pp2.unionWith(ppj); 
					}//next j
					
					if (vecN.bIsZeroLength())
						pp2.subtractProfile(ppFace);
					
				
				// Draw Jig
					int bDragOversize = bDrag && indexOfMovedGrip == index ;
					dpOversize.draw(pp2);
					if (bDragOversize)
					{ 
						dpOversize.draw(pp2, _kDrawFilled, 60);	
					}
	
				}
				//csf.vis(i);
			} 
			
		}//next i		
	}





	//region Function GetBodiesDimensionInDir
	// returns
	// t: the tslInstance to 
	double GetBodiesDimensionInDir(Body bodies[], Vector3d vecDir)
	{ 
		double out;
		Point3d pts[0];
		for (int i=0;i<bodies.length();i++) 
		{ 
			Body bd =bodies[i];
			if (!bd.isNull())
				pts.append(bd.extremeVertices(vecDir));
		}//next i	
		if (vecDir.isParallelTo(_ZW))pts.append(_Pt0); // vertical dimension to be taken from base level HSB-22260
		pts = Line(_Pt0, vecDir).orderPoints(pts);
		
		if (pts.length()>0)
			out = vecDir.dotProduct(pts.last() - pts.first());
		return out;	
	}//endregion


	//region Function GetBoundingBoxInView
	// returns
	// t: the tslInstance to 
	void GetBoundingBoxInView(Body bodies[], PlaneProfile& pp)
	{ 

		CoordSys cs = pp.coordSys();
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		Vector3d vecZ = cs.vecZ();
		
		Point3d pts[0];
		for (int i=0;i<bodies.length();i++) 
		{ 
			Body bd =bodies[i];
			if (!bd.isNull())
			{
				pts.append(bd.extremeVertices(vecX));
				pts.append(bd.extremeVertices(vecY));				
			}
		}//next i	
		pts.append(_Pt0); // include potential stacking height at bottom
		PLine hull;
		hull.createConvexHull(Plane (cs.ptOrg(), vecZ), pts);
		pp.createRectangle(PlaneProfile(hull).extentInDir(vecX), vecX, vecY);

		return;
	
	}//endregion



//endregion 

//region Collect childs (items or packs)	
	double dWeight, dVolume;
	Point3d ptCOG;
	
	TslInst childs[0], packs[0], items[0], itemsNoPack[0];
	Body bdChilds[0], bdPacks[0], bdItems[0]; 	
	int nItemXLayers[0], nItemYLayers[0], nItemZLayers[0];// same length as items
	int nPackXLayers[0], nPackYLayers[0], nPackZLayers[0];// same length as packs
	for (int i = 0; i < ents.length(); i++)
	{
		Entity& e = ents[i];
		TslInst t = (TslInst)e;
		if (!t.bIsValid() || sChildScripts.findNoCase(t.scriptName() ,- 1) < 0){continue;}

		int bIsItem = kScriptItem.find(t.scriptName(), 0, false) == 0;
		int bIsPack = kScriptPack.find(t.scriptName(), 0, false) == 0;

		Entity refs[] = t.entity();
		if (refs.length() < 1){continue;}
		
		Body bd = t.realBody(_XW+_YW+_ZW);
		if (bIsPack && bd.isNull())
		{ 
			double dX = t.propDouble(T("|Length|"));
			double dY = t.propDouble(T("|Width|"));
			double dZ = t.propDouble(T("|Height|"));
			
			if (dX>0 && dY>0 && dZ>0)
				bd = Body(t.ptOrg(), _XW,_YW,_ZW, dX, dY, dZ,0,0,1);
		}
		if (bd.isNull())
		{
			reportMessage("\n" + t.scriptName() + " has no solid representation");
			//continue;
		}
		
		//bd.vis(161);
			
		if (kScriptItem.find(t.scriptName(), 0, false) == 0)
		{
			//reportMessage("\n" + scriptName() + ": " + t.scriptName() + " appended");
			items.append(t);
			itemsNoPack.append(t);
			bdItems.append(bd);
			
			nItemXLayers.append(-1);
			nItemYLayers.append(-1);
			nItemZLayers.append(-1);			
		}
		else if (kScriptPack.find(t.scriptName(), 0, false) == 0)
		{
			//reportMessage("\n" + scriptName() + ": " + t.scriptName() + " appended desc:" + t.propString(T("|Description|")));
			packs.append(t);
			bdPacks.append(bd);
			
			nPackXLayers.append(-1);
			nPackYLayers.append(-1);
			nPackZLayers.append(-1);				
		}

		childs.append(t);		
		bdChilds.append(bd);

		
	// collect items of packs
		if (bIsPack)
		{ 
			Entity entsT[] = t.entity();
			for (int j = 0; j < entsT.length(); j++)
			{ 
				TslInst tj = (TslInst)entsT[j];
				if (childs.find(tj)<0)
				{ 
					bd = tj.realBody(_XW+_YW+_ZW);
					childs.append(tj);		
					bdChilds.append(bd);
		
					if (kScriptItem.find(tj.scriptName(), 0, false) == 0 && items.find(tj)<0)
					{
						items.append(tj);
						bdItems.append(bd);

						nItemXLayers.append(-1);
						nItemYLayers.append(-1);
						nItemZLayers.append(-1);
					}
				}			
			}
		}

	}
	int numItem=items.length(), numPack=packs.length();
	
// collect stacking layer indices per direction
	Vector3d vecStackDir = GetMainStackingDirection(items);
	
	{
		TslInst gridItems[0];
		Body gridBodies[0];
		gridItems.append(itemsNoPack);
		for (int i=0;i<itemsNoPack.length();i++) 
		{ 
			int n = items.find(itemsNoPack[i]);
			gridBodies.append(bdItems[n]);		 
		}//next i
		
		gridItems.append(packs);
		gridBodies.append(bdPacks);
		
		Point3d ptGrids[0];
		int nStackIndices[] = GetSequencesInDir(vecStackDir, gridItems, gridBodies, ptGrids);
		
	// loop grid locations and assign subindices in vecX
		for (int i=0;i<ptGrids.length();i++) 
		{ 
			int nStackIndex = i;
			TslInst gridItemsX[0];
			Body gridBodiesX[0];
			for (int j=0;j<gridItems.length();j++) 
			{ 
				if (nStackIndices.length()>j && nStackIndices[j]==nStackIndex)
				{
					gridItemsX.append(gridItems[j]);
					gridBodiesX.append(gridBodies[j]);		
				}
			}//next j
	
			Point3d ptGridsX[0];
			int nStackIndicesX[] = GetSequencesInDir(vecX, gridItemsX, gridBodiesX, ptGridsX);
	
		// write indices to map if modified
			for (int j=0;j<gridItemsX.length();j++) 
			{ 
				int nStackIndexX = nStackIndicesX.length()>j?nStackIndicesX[j]:0;
				
				int n = gridItems.find(gridItemsX[j]);
				if (n<0){ continue;}
				
				TslInst t = gridItems[n];
				Map m = t.map();
				int stackIndex = m.hasInt(kLayerIndexStack)?m.getInt(kLayerIndexStack):-1;
				int stackIndexX = m.hasInt(kLayerSubIndexStack)?m.getInt(kLayerSubIndexStack):-1;
	
				//reportNotice("\nStackPack: " + t.formatObject("@(ScriptName)-@(Handle)-@(Data.LayerIndexPack)")+stackIndex+nStackIndex);
	
				if (nStackIndex!=stackIndex || nStackIndexX!=stackIndexX)
				{ 
					m.setInt(kLayerIndexStack, nStackIndex);
					m.setInt(kLayerSubIndexStack, nStackIndexX);
					t.setMap(m);
					//reportNotice("\n"+_ThisInst.formatObject("@(ScriptName)-@(Handle): writing to ") + t.handle() + " " + nStackIndex + "." + nStackIndexX);
				}
				
				//reportNotice("\nStackPack reading item " + t.subMapX(kData));
			}		 
		}//next i		
	
		
	}


	Map mapItemLayers = getLayerIndices(bdItems, nItemXLayers,nItemYLayers,nItemZLayers);	
	Map mapPackLayers = getLayerIndices(bdPacks, nPackXLayers,nPackYLayers,nPackZLayers);
	
//endregion 

//region Get Load Dimensions

	PlaneProfile ppLoadX(CoordSys(_Pt0, -_YW, _ZW, -_XW));
	GetBoundingBoxInView(bdChilds, ppLoadX);
	ppLoadX.vis(1);
	
	PlaneProfile ppLoadY(CoordSys(_Pt0, _XW, _ZW, _YW));
	GetBoundingBoxInView(bdChilds, ppLoadY);	
	ppLoadY.vis(3);
	
	PlaneProfile ppLoadZ(CoordSys(_Pt0, _XW, _YW, _ZW));
	GetBoundingBoxInView(bdChilds, ppLoadZ);	
	ppLoadZ.vis(150);

	double dXLoad =GetBodiesDimensionInDir(bdItems, _XW);//ppLoadZ.dX();// 
	double dYLoad =GetBodiesDimensionInDir(bdItems, _YW);//ppLoadZ.dY();// 
	double dZLoad= GetBodiesDimensionInDir(bdItems, _ZW);//ppLoadY.dY();
	
	
//endregion 









//region Draw
	Map mapAdd;
	String text = bJig?sFormat:this.formatObject(sFormat, mapAdd);
	if (text.length()>0)
	{ 	
		DrawTag(text, ptTagPlan, sDimStyle, textHeight, dpText, 1);
	}
	if (bJig)return;
//endregion 

//region Nesting Info


//Set parent/child relations
	for (int i=0;i<childs.length();i++) 
	{ 
	// get potential parent entity	
		TslInst& t = childs[i];
		Map mapX = t.subMapX(kTruckChild);		
		Entity entParent; entParent.setFromHandle(mapX.getString("ParentHandle"));	
		TslInst tslParent = (TslInst)entParent;	
		
	// identify type of relation	
		int bIsItem = kScriptItem.find(t.scriptName(), 0, false) == 0;
		int bIsPack = kScriptPack.find(t.scriptName(), 0, false) == 0;
		int bIsPackedItem= tslParent.bIsValid() && kScriptPack.find(tslParent.scriptName(), 0, false) == 0;
		
	// set reference of stack entity to defining item entity	
		if (bIsItem)
		{ 
		// Set Reference
			{ 
				Entity refs[] = t.entity();
				if (refs.length()<1)
				{ 
					continue;
				}
				Entity entRef = refs.first();			
				Map m=entRef.subMapX(kDataLink);
				m.setEntity(kScriptStack, this);
				entRef.setSubMapX(kDataLink, m);				
			}

		// cumulate weight	
			{ 
				Map m= t.subMapX(kData);
				dWeight += m.getDouble("Weight");
				dVolume += m.getDouble("Volume");
			}		
		}

		
		
		int c = 0;
		if (bIsItem && !bIsPackedItem)
		{ 
			
			int n = items.find(t);
			mapX.setInt("LayerX", nItemXLayers[n]);
			mapX.setInt("LayerY", nItemYLayers[n]);
			mapX.setInt("LayerZ", nItemZLayers[n]);	
			
			String alignment = t.propString(2);
			if (tVertical==alignment)
				c=nItemYLayers[n]+1;				
			else if (tHorizontal==alignment)
				c = nItemZLayers[n]+1;
			
		}
		else if (bIsPack)
		{ 
			int n = packs.find(t);
			mapX.setInt("LayerX", nPackXLayers[n]);
			mapX.setInt("LayerY", nPackYLayers[n]);
			mapX.setInt("LayerZ", nPackZLayers[n]);	
			
			c=nPackZLayers[n]+1;
			
		}
		
	// Set parent relation for unpacked items or packs
		if (bIsPack || (bIsItem && !bIsPackedItem))
		{ 
		// Control color by stacking layer
			//reportNotice("\n" + scriptName() + ": " + t.scriptName() + " appended as layer:" + c);
			
			// tColorRules[] ={ tCRbyPackLayer, tCRbyPackNumber, tCRbyStackIndex};//TOD if to be done by the entity itself
//			if ((bIsPack || bIsItem) && c!=t.color())// only control pack color
//			{		
//				t.setColor(c);
//				t.transformBy(Vector3d(0, 0, 0));
//			}	
			
			mapX.setString("ParentUid", this.uniqueId());
			mapX.setString("ParentHandle", this.handle());		
			
			CoordSys csChild = t.coordSys();
			CoordSys csChildRel;
			csChildRel.setToAlignCoordSys(
				ptLoc, csParent.vecX(), csParent.vecY(), csParent.vecZ(),
				csChild.ptOrg(), csChild.vecX(), csChild.vecY(), csChild.vecZ());
			mapX.setPoint3d("ptRelOrg", csChildRel.ptOrg(), _kAbsolute);
			mapX.setPoint3d("ptVecX", csChildRel.ptOrg() + csChildRel.vecX(), _kAbsolute);
			mapX.setPoint3d("ptVecY", csChildRel.ptOrg() + csChildRel.vecY(), _kAbsolute);
			mapX.setPoint3d("ptVecZ", csChildRel.ptOrg() + csChildRel.vecZ(), _kAbsolute);			
			
			t.setSubMapX(kTruckChild,mapX);
			
			
		// set reference of stackEntity data to pack or unpacked item
			Map m= t.subMapX(kDataLink);
			{
				m.setEntity(kScriptStack, this);	
				t.setSubMapX(kDataLink, m);
			}			
			
		}
	}//next i	



//Compose parent mapX with Nesting info
{ 
	Map mapX;	ptLoc.vis(3);
	//mapX.setPlaneProfile("Shape", ppMaster);
	mapX.setString("MyHandle", this.handle());
	mapX.setString("MyUid", this.uniqueId());
	mapX.setPoint3d("ptOrg", ptLoc, _kRelative);
	mapX.setVector3d("vecX", _XW, _kScalable); // coordsys carries size
	mapX.setVector3d("vecY", _YW, _kScalable);
	mapX.setVector3d("vecZ", _ZW, _kScalable);
	
	mapX.setMap("Layer", mapItemLayers); // stores the layer base points of the ortho directions
	this.setSubMapX(kTruckParent,mapX);			
}
//endregion 

//region Trigger AddItems
	String sTriggerAddItems = T("|Add Items|");
	if (!bEditDefinition)addRecalcTrigger(_kContextRoot, sTriggerAddItems );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddItems)
	{
		
	// prompt for entities
		Entity entsX[0];
		PrEntity ssE(T("|Select stackable items|"), TslInst());
		if (ssE.go())
			entsX.append(ssE.set());

		for (int i=entsX.length()-1; i>=0 ; i--) 
		{ 
			TslInst t = (TslInst)entsX[i];
			String name = t.scriptName();
			if (sChildScripts.findNoCase(name,-1)<0)
				entsX.removeAt(i);			
		}

		Map mapArgs = getItemShadowMap(entsX);
		PlaneProfile pp = mapArgs.getPlaneProfile("pp");
		Point3d ptFrom = pp.ptMid();
		Point3d ptTo = ptFrom;
		mapArgs.setPoint3d("ptFrom", ptFrom);

	//region Show Jig
		PrPoint ssP(T("|Pick location|, ") + T("|<Enter>| to keep current location"), ptFrom);
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

	// release from existing parent
	if (bDebug)reportNotice("\nStack.SetRef" +  entsX.length());
	for (int i=0;i<entsX.length();i++) 
		{ 
			Entity& e = entsX[i];
				
			if (ents.find(e)>-1)
			{
				reportNotice("\n" + e.formatObject("@(ScriptName) @(Handle) belongs to me"));
				continue;
			}
			_Entity.append(e);
			
		// Get parent nester (TODO ?)if existant
			Map mapX =e.subMapX(kTruckChild);
			String parentUID = mapX.getString("ParentHandle");
			Entity parent; parent.setFromHandle(parentUID);	
			
			if (parent.bIsValid())
			{ 
				int bOk = releaseParent(parent, e);
				if (bOk) e.transformBy(Vector3d(0, 0, 0));
				reportNotice("\n" + e.handle() + (bOk ? "" : " not") + " released");
			}	

			
			if (!vec.bIsZeroLength())
				e.transformBy(vec);
			
		}//next i

		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger RemoveItems
	String sTriggerRemoveItems = T("|Remove Items|");
	if (childs.length()>0)
		addRecalcTrigger(_kContextRoot, sTriggerRemoveItems );
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

		
		if (entsX.length()<1)
		{ 
			reportMessage(TN("|The selection set does not contain removable items.|"));			
			setExecutionLoops(2);
			return;			
		}
		
		Map mapArgs = getItemShadowMap(entsX);
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
			e.removeSubMapX(kTruckChild);
			int n = _Entity.find(e);
			if (n>-1)
				_Entity.removeAt(n);
			e.setColor(0);
			e.transformBy(vec); 
		}

		setExecutionLoops(2);
		return;
	}//endregion	

// Trigger AsynchronousOversizeWidth
	
	String sTriggerAsynchronousOversizeWidth =bAsynchronousOversize?T("|Synchronous Oversize Width|"):T("|Asynchronous Oversize Width|");
	if (dOversizes.length()>3 && (dOversizes[2]>0 ||dOversizes[3]>0))
		addRecalcTrigger(_kContextRoot, sTriggerAsynchronousOversizeWidth);
	if (_bOnRecalc && _kExecuteKey==sTriggerAsynchronousOversizeWidth)
	{
		bAsynchronousOversize = !bAsynchronousOversize;
		_Map.setInt(kAsynchronWidth, bAsynchronousOversize);		
		setExecutionLoops(2);
		return;
	}
	
	
//region AxleLoad
	double dAxleWeights[0];
	if(this.subMapXKeys().find("Axle")>-1)
	{
		// ptCog,dWeight
		Map mapAxle=this.subMapX("Axle");
		// calculate weight for each axle
		double das[0];// X coordinates of each axle wrt ptOrg
		for (int i=0;i<mapAxle.length();i++) 
		{ 
			Map mi=mapAxle.getMap(i);
			das.append(mi.getDouble("X"));
		}//next i
		
		double dXcog=vecX.dotProduct(ptCOG-ptOrg);
		dAxleWeights=calcAxleWeights(das,dXcog,dWeight);
	}
//endregion//AxleLoad




//endregion 

//region Store formatting data
	{
		Map m= this.subMapX(kData);
		
		m.setInt("QuantityItems", numItem);
		m.setInt("QuantityPacks", numPack);
		m.setInt("QuantityItemPacks", numPack+numItem);
		m.setDouble("Weight", dWeight, _kNoUnit);
		m.setDouble("volume", dVolume, _kVolume);
		m.setPoint3d("COG", ptCOG);
		m.setString("Description", sDescription);
		
		m.setDouble("LoadLength", dXLoad, _kLength);
		m.setDouble("LoadWidth", dYLoad, _kLength);
		m.setDouble("LoadHeight", dZLoad, _kLength);
		
		
		m.setEntityArray(items, true, "Item[]", "", "Item");

		this.setSubMapX(kData, m);
	}
//endregion 


//region Dialog Trigger
{ 
	// create TSL
	TslInst tslDialog;			Map mapTsl;						
	GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };
	
//region Trigger DisplaySettings
	String sTriggerSetting = T("|Settings|");
	addRecalcTrigger(_kContext, sTriggerSetting);
	if (_bOnRecalc && _kExecuteKey==sTriggerSetting)	
	{ 
		mapTsl.setInt("DialogMode",2);
		
		String colorRule = nColorRule > 0 && nColorRule < tColorRules.length() ? tColorRules[nColorRule]: tColorRules.first();
		sProps.append(colorRule);
			
		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{ 
				nColorRule = tColorRules.findNoCase(tslDialog.propString(0),0);

				Map m = mapSetting.getMap("Item");
				m.setInt("ColorRule",nColorRule);

				mapSetting.setMap("Item", m);
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
        <int nm="BreakPoint" vl="2701" />
        <int nm="BreakPoint" vl="2477" />
        <int nm="BreakPoint" vl="2169" />
        <int nm="BreakPoint" vl="2408" />
        <int nm="BreakPoint" vl="2472" />
        <int nm="BreakPoint" vl="2325" />
        <int nm="BreakPoint" vl="1034" />
        <int nm="BreakPoint" vl="2428" />
        <int nm="BreakPoint" vl="1370" />
        <int nm="BreakPoint" vl="2721" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23372 fully supporting new behaviour of controlling properties" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="2/12/2025 12:24:29 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22732: Add Axle load calculation" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="1/10/2025 2:56:10 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21733 supports relocation of attached spacers when moved" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="11/22/2024 4:16:42 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22717 element references improved" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="9/24/2024 6:02:20 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21161 debug messages removed" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="9/17/2024 1:40:53 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22636 tag also visible in model view" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="9/6/2024 8:54:03 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21998 settings introduced to enable custom color coding" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="8/22/2024 4:29:46 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21677 jigging items improved" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="8/16/2024 5:16:19 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22260 Z-load dimension measured from base point, bugfix on insert with no truck definitions present" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="7/26/2024 3:20:15 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22260 load dimensions exposed: @(LoadLength), @(LoadWidth), @(LoadHeight)" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="7/16/2024 5:14:48 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22260 oversizes and load dimensions prepared" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="6/25/2024 4:34:38 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21199 A new property 'Number' has been added. The number can be used for formatting and specifies a fixed unique number." />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="2/27/2024 12:21:13 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20205 wireframe display improved, new format property and grips to display tag" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="12/21/2023 5:09:02 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20724 bugfix pack model display" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="11/24/2023 1:06:24 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20724 debug messages removed" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="11/24/2023 12:16:37 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19662 drag behaviour, parent nesting updated" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="11/17/2023 3:46:07 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19664 layer assignment fixed, weight and volume fixed" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="11/8/2023 4:45:04 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19659 reference link renamed, default painter definitions made non translateable to support language independent shopdrawing definitions" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="10/24/2023 3:44:51 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19659 first beta release" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="10/18/2023 5:18:29 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19659 data export and stacking layer assignment added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="10/12/2023 5:52:11 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19659 jigs improved" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="9/29/2023 3:59:40 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19659 renamed, layer collection added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="9/27/2023 1:57:43 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-17564 initial version of truck definition" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="1/17/2023 11:04:29 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End