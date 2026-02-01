#Version 8
#BeginDescription
/// This tsl defines a joint board connection on one common edge between at least two panels. On insert it may create a split if only one panel was selected.

#Versions
Version 3.4 25.06.2025 HSB-24228: add property gap panel , Author: Marsel Nakuci
3.3 05.12.2024 HSB-23001: save graphics in file for render in hsbView and make Author: Marsel Nakuci
Version 3.2 20.11.2024 HSB-23017: Fix connection for angled edge panels , Author Marsel Nakuci
Version 3.1 19.09.2024 HSB-22701 performance enhanced
Version 3.0 17.04.2024 HSB-21901 custom commands moved to root context menu
   commands to import/export settings added
   grouping option added
   default grip option added

Version 2.9 04.04.2021 HSB-11210: moveGripEdgeMidPointAt sometimes doesnt work, replace  with add/subtract profile
Version 2.8 30.03.2021 HSB-10784: add extra tolerance to cut through the body
Version 2.7 19.02.2021 HSB-10732 bugfix writing default XML


/// The closest point to the main contour in relation to the reference point (_Pt0) defines the edge where the tool is
/// assigned to.
/// This tsl can also be used in conjunction with the command HSB_PANELTSLSPLITLOCATION








#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 3
#MinorVersion 4
#KeyWords CLT;Jointboard;Connection
#BeginContents
//region Part 1


//region <History>	
// #Versions
// 3.4 25.06.2025 HSB-24228: add property gap panel , Author: Marsel Nakuci
// 3.3 05.12.2024 HSB-23001: save graphics in file for render in hsbView and make Author: Marsel Nakuci
// 3.2 20.11.2024 HSB-23017: Fix connection for angled edge panels , Author Marsel Nakuci
// 3.1 19.09.2024 HSB-22701 performance enhanced , Author Thorsten Huck
// 3.0 17.04.2024 HSB-21901 custom commands moved to root context menu, new commands import/export settings, new grouping option, new default grip option , Author Thorsten Huck
// 2.9 04.04.2021 HSB-11210: moveGripEdgeMidPointAt sometimes doesnt work, replace  with add/subtract profile Author: Marsel Nakuci
// 2.8 30.03.2021 HSB-10784: add extra tolerance to cut through the body Author: Marsel Nakuci
// 2.7 19.02.2021 HSB-10732 bugfix writing default XML , Author Thorsten Huck
/// <version value="2.6" date="26octl2020" author="nils.gregor@hsbcad.com"> HSB-9121: bugfix length of beamcut</version>
/// <version value="2.5" date="23jul2019" author="thorsten.huck@hsbcad.com"> HSB-2857: bugfix relief cut property on insert</version>
/// <version value="2.4" date="11jul2019" author="thorsten.huck@hsbcad.com"> HSB-5355: beam creation on insert supported via settings </version>
/// <version value="2.3" date="22may2019" author="thorsten.huck@hsbcad.com"> HSB-5076: beamcut alignment fixed </version>
/// <version value="2.2" date="16nov2018" author="thorsten.huck@hsbcad.com"> HSB-300: find jointboard corner connections and add mitred chamfers if found </version>
/// <version value="2.1" date="15nov2018" author="thorsten.huck@hsbcad.com"> HSB-297, HSB-298, HSB-299: new custom commands to create color mapping as settings file and to join panels +erase jointboard. color mapping if settings defined </version>
/// <version value="2.0" date="25jul2018" author="thorsten.huck@hsbcad.com"> HSB-4546: creates joint board beams with a consistant coordinate system II </version>
/// <version value="1.9" date="25may2018" author="thorsten.huck@hsbcad.com"> creates joint board beams with a consistant coordinate system </version>
/// <version value="1.8" date="16apr2018" author="thorsten.huck@hsbcad.com"> new context command 'convert to static' applies static tools to the panels and removes the tool instance </version>
/// <version value="1.7" date="23jan2018" author="thorsten.huck@hsbcad.com"> new option relief cut (not available with centered alignment) </version>
/// <version value="1.6" date="04aug2017" author="thorsten.huck@hsbcad.com"> beam creation supports naming of joint boards </version>
/// <version value="1.5" date="26jul2017" author="thorsten.huck@hsbcad.com"> beam creation can be executed for multiple instances with the same settings </version>
/// <version value="1.4" date="12apr2017" author="thorsten.huck@hsbcad.com"> grouping of beam based joint boards fixed and extended, gap issue of different modes fixed, beam based beamcuts fixed </version>
/// <version value="1.3" date="05apr2017" author="thorsten.huck@hsbcad.com"> transparency deactivated on debug </version>
/// <version value="1.2" date="04apr2017" author="thorsten.huck@hsbcad.com"> created beams are honouring alignment, if beams are created beamcuts are dependent from those </version>
/// <version value="1.1" date="17nov2016" author="thorsten.huck@hsbcad.com"> custom command ''create beams' added' </version>
/// <version value="1.0" date="27oct2016" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <summary Lang=en>
/// This tsl defines a joint board connection on one common edge between at least two panels. On insert it may create a split if only one panel was selected.
/// The closest point to the main contour in relation to the reference point (_Pt0) defines the edge where the tool is
/// assigned to.
/// This tsl can also be used in conjunction with the command HSB_PANELTSLSPLITLOCATION
/// </summary>

/// <command name="Create beams" Lang=en>
/// This command creates the joint boards as beams. Any hardware output is deactivated when beams are created.
/// You can specify an automatic group to assign the joint boards to. The group will be created if it is not existing.
/// Calling the command again will erase previously created joint boards. The joint board beams are tied to the location of the joint itself.
/// If you specify an catalog entry against the 'create beams' instance you will get a new command which can be called next time.
/// One can define a command to call this from palette, ribbon etc (replace 'YourCommandName' by a unique and meaning full name, 'Test' is the name of a potential catalog entry):
/// ^C^C(defun c:YourCommandName() (hsb_recalcTslWithKey (_TM "|Create beams (Test)|") (_TM "|Select Tool|"))) YourCommandName
/// </command>

/// <insert Lang=en>
/// Insert as Splitting Tool
/// ·	Select one panel, select two points which define the line to split
/// ·	The TSL will split the selected panel and will insert a tool at the designated edge
/// Insert as a single tool on one edge of a panel
/// One can use this TSL to modify one edge of the panel. This may enhance design time compared of drawing a beam and using the command HSB_LINKTOOLS.
/// ·	Select one panel, select two points on the edge where you want to attach the lap
/// ·	The TSL will not split the selected panel, but it will insert a tool at the designated edge
/// ·	If another panel needs to join with this tool at a later stage one can use the custom command 'Add panel' to link this entity to the tool.
/// Insert as Tool to multiple panels
/// To link two panels or multiple panels to one reference panel you can use this TSL to assign a tool.
/// ·	Select all desired panels, make sure that your reference panel will be selected first
/// ·	Pick a point near to the edge which you would like to join
/// </insert>


// commands
// command to insert
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCLT-JointBoard")) TSLCONTENT 

// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Tool|") (_TM "|Select joint board|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Flip Side|") (_TM "|Select joint board|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Remove Panel|") (_TM "|Select joint board|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Convert to static|") (_TM "|Select joint board|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Edit in Place|") (_TM "|Select joint board|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Disable Edit in Place|") (_TM "|Select joint board|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Panel|")(_TM "|Select joint board|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Join + Erase|")(_TM "|Select joint board|"))) TSLCONTENT
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

	int bLog;//=true;
	int bDebugMapIO;//=true;
	if (bLog)reportMessage("\n\n***" + scriptName() + " starting");	

	// categories
	String sCategoryGeo = T("|Geometry|");
	String sCategoryChamfer = T("|Chamfer|");
	String sCategoryGap = T("|Gaps|");
	String sCatDesc = T("|Description|");	

	String sAlignments[] = {T("|Reference Side|"), T("|Center|"), T("|Opposite Side|"), T("|Higher Quality|"),T("|Lower Quality|") };
//end Constants//endregion

//region Functions
//region visPp
//
	void visPp(PlaneProfile _pp, Vector3d _vec)
	{ 
		_pp.transformBy(_vec);
		_pp.vis(6);
		_pp.transformBy(-_vec);
		return;
	}
//End visPp//endregion

//End Functions//endregion 

//region Mode 2
// get mode
	if (bLog)reportMessage("\n	" + _ThisInst.handle() + "(" + _kExecutionLoopCount + ")");
	int nMode = _Map.getInt("mode");
	// 0 = wall mode
	// 1 = panel mode
	// 2 = board creation mode: different set of properties and opm name


// board creation as beams mode
	
	if (nMode==2)
	{
		setOPMKey(T("|Creation|"));
	
		String sAutoGroupName=T("|Auto Group|");
		PropString sAutoGroup(nStringIndex++, T("|Joint Board|"), sAutoGroupName);
		sAutoGroup.setDescription(T("|Specify a Group Name to group joint boards into a group. You can specify the full group path i.e. 'House\\Floor\\Jointboard' or any subgroup path i.e. 'Floor\\Jointboard' or 'Jointboard'|"));
		sAutoGroup.setCategory(sCategoryGeo);	

		String sNameName=T("|Name|");	
		PropString sName(nStringIndex++, T("|Joint board|"), sNameName);	
		sName.setDescription(T("|Defines the Name|"));
		sName.setCategory(sCategoryGeo);

		String sColorName=T("|Color|");
		PropInt nColor(nIntIndex,0, sColorName);
		nColor.setDescription(T("|Specifies the color of the boards.|"));
		nColor.setCategory(sCategoryGeo);		
		
	// tokenize autoGroup
		int bAssignGroup=true;
		if (sAutoGroup.length()>0)
		{
			String sTest = sAutoGroup;
			String sHouseGroup = sTest.token(0,"\\");
			String sFloorGroup= sTest.token(1,"\\");
			String sItemGroup = sTest.token(2,"\\");
		
		// shift
			for (int i=0;i<2;i++) 
			{ 
				if (sItemGroup.length()<1)
				{
					sItemGroup=sFloorGroup;
					sFloorGroup=sHouseGroup;
					sHouseGroup="";
				} 
			}
			
		// get floor group by instance
			if (sHouseGroup=="" || sFloorGroup=="") 
			{
				Group groups[] = _ThisInst.groups();
				String sNamePart0, sNamePart1, sNamePart2;
			// 	
				for (int i=0;i<groups.length();i++) 
				{ 
					Group group= groups[i]; 
					if (group.namePart(1)!="")
					{
						sNamePart0	=group.namePart(0);
						sNamePart1	=group.namePart(1);
						break;
					}
				}
				// fall back, get house group
				if (sNamePart0=="")
					for (int i=0;i<groups.length();i++) 
					{ 
						Group group= groups[i]; 
						if (group.namePart(0)!="")
						{
							sNamePart0	=group.namePart(0);
							break;
						}
					}	
				if (sHouseGroup=="")sHouseGroup=sNamePart0;
				if (sFloorGroup=="")sFloorGroup=sNamePart1;
				
			}
			
			if (sHouseGroup!="" && sFloorGroup!="" && sItemGroup!="")
			{
				Group gr(sHouseGroup+"\\" + sFloorGroup+ "\\"+sItemGroup);
				if (!gr.bExists())
					gr.dbCreate();	

			// assign  properties and group by beam	
				for (int i=0;i<_Beam.length();i++) 
				{ 
					Beam bm = _Beam[i]; 
					bm.setColor(nColor);
					bm.setName(sName);
					if(gr.bExists())
						gr.addEntity(bm, true,0, 'Z');
				}
				bAssignGroup=false;
			}			
		}
	// assign to instance groups	
		if (bAssignGroup)
		{
		// assign  properties and group by beam	
			for (int i=0;i<_Beam.length();i++) 
			{ 
				Beam bm = _Beam[i]; 
				bm.setColor(nColor);
				bm.assignToGroups(_ThisInst,'Z');
			}			
		}
		
		if (!_Map.getInt("dialog") || _Beam.length()<1)
			eraseInstance();
		return;
	}		


//End Mode 2//endregion 

//region properties
// Geometry
	String sWidthName="(A)   " +T("|Width|") ;	
	PropDouble dWidth (nDoubleIndex++, U(100), sWidthName);
	dWidth.setCategory(sCategoryGeo);
	
	String sGapWidthName="(C)   "+T("|Width|") ;
	PropDouble dGapWidth (nDoubleIndex++, U(2), sGapWidthName);
	dGapWidth.setCategory(sCategoryGap);
		
	String sDepthName="(B)   "+T("|Depth|");		
	PropDouble dDepth (nDoubleIndex++, U(20), sDepthName);	
	dDepth.setCategory(sCategoryGeo);

// gap
	String sGapDepthName="(D)   "+T("|Depth|");
	PropDouble dGapDepth (nDoubleIndex++, U(2), sGapDepthName);
	dGapDepth .setCategory(sCategoryGap);


// chamfer
	String sChamferRefName="(E)  "+sAlignments[0];
	PropDouble dChamferRef(nDoubleIndex++, U(0), sChamferRefName);
	dChamferRef.setCategory(sCategoryChamfer );

	String sChamferOppName="(F)  "+sAlignments[2];
	PropDouble dChamferOpp(nDoubleIndex++, U(0), sChamferOppName);
	dChamferOpp.setCategory(sCategoryChamfer );

// relief cut
	String sGapReliefName="(X)   "+T("|Relief Cut|");
	PropDouble dGapRelief (nDoubleIndex++, U(0), sGapReliefName);
	dGapRelief.setCategory(sCategoryGap);


// Category 2: General
	String sCategory2 = T("|General|");
	String sAlignmentName="(G)  "+T("|Alignment|");		
	PropString sAlignment(0, sAlignments, sAlignmentName);
	sAlignment.setCategory(sCategory2);

	String sMaterialName=T("|Material|");	
	PropString sMaterial(1, T("|Spruce|"), sMaterialName);
	sMaterial.setCategory(sCategory2);

	String sGradeName=T("|Grade|");	
	PropString sGrade(2, "", sGradeName);
	sGrade.setCategory(sCategory2);
	
	// HSB-24228: panel gap
	String sGapPanelName="(H)   "+T("|Gap Panel|");	
	PropDouble dGapPanel(nDoubleIndex++, U(0), sGapPanelName);	
	dGapPanel.setDescription(T("|Defines the gap for the panel.|"));
	dGapPanel.setCategory(sCategoryGap);
	
	double dRange = U(5);
	double dMinArea = pow(dRange,2);
	//endregion
		
//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="hsbCLT-JointBoard";
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


//region onMapIO
	if (_bOnMapIO || (bDebugMapIO && !_bOnInsert)) 
	{
		int nFunction= _Map.getInt("function");
		if (bLog)reportMessage("\n" + " mapIO execution function " + nFunction);
		Sip sips[0];
		bDebug= _Map.getInt("debug");
		double dXRange = _Map.getDouble("XRange");//dXRange =U(50);
		for (int i=0;i<_Map.length();i++)
		{
			Entity ent = _Map.getEntity(i);
			if (ent.bIsValid() && ent.bIsKindOf(Sip()))
				sips.append((Sip)ent);
		}
		if (bDebug)reportMessage("\ncalling mapIO function " + nFunction + " with " + sips.length() + " panels" );
		_Map=Map();
		
	// get panels from _Sip
		if (bDebugMapIO)	
			sips=_Sip;	
		
		
		if (sips.length()<2)
			return;	
	// use the first panel as reference	
		Sip sip = sips[0];
		Vector3d vecX=sip.vecX();
		Vector3d vecY=sip.vecY();
		Vector3d vecZ=sip.vecZ();
		Point3d ptCen = sip .ptCenSolid();	
		
		if (nFunction==0)
		{
			Point3d ptMinMaxThis[] = {ptCen -vecZ*.5*sip.dH(),ptCen +vecZ*.5*sip.dH()};
				
		// remove every panel from _Sip array if not coplanar and of same thickness
			for (int i = sips.length()-1; i>0;i--)
			{
				Sip sipOther = sips[i];			
				Point3d ptMinMaxOther[] = {sipOther.ptCen()-vecZ*.5*sipOther .dH(),sipOther.ptCen()+vecZ*.5*sipOther .dH()};
				double dA0B1 = vecZ.dotProduct(ptMinMaxOther[1]-ptMinMaxThis[0]);
				double dB0A1 = vecZ.dotProduct(ptMinMaxThis[1]-ptMinMaxOther[0]);		
			// the panel is not in the same plane
				if (!vecZ.isParallelTo(sipOther.vecZ()) || !(dA0B1>=0 && dB0A1>=0))
					sips.removeAt(i);	
			}// next i
			
		// collect pairs of panels if edges are parallel, but not codirectional and touching
			Map mapConnections;	
			int nNumConnection,nNumEdge;
			Vector3d vecRefNormal;
			int bIsParallel=true;// a flag which indicates that all edges are parallel to each other
			for (int i=0;i<sips.length()-1;i++)
			{
				SipEdge edgesA[] = sips[i].sipEdges();
				for (int a=0;a<edgesA.length();a++)
				{
					Point3d ptMidA = edgesA[a].ptMid();ptMidA.vis(a);
					Vector3d vecA = edgesA[a].vecNormal();
					
					Point3d ptsA[] = edgesA[a].plEdge().vertexPoints(true);
					if (ptsA.length()<1) continue;
					Vector3d vecXA = ptsA[1]-ptsA[0];	vecXA.normalize();
					Line lnA(ptsA[0], vecXA);
					ptsA = lnA.orderPoints(ptsA);
					
				// try to find another edge within range
					int bDirectionBySelection ; // a flag which indicates that the connecting direction is to be detected from the selection sequence. Happens if panels are already overlapping on insert	
					for (int j=i+1;j<sips.length();j++)
					{	
						Map mapConnection;
						SipEdge edgesB[] = sips[j].sipEdges();	
						Map mapEdges;
						for (int b=0;b<edgesB.length();b++)
						{
							Point3d ptMidB = edgesB[b].ptMid();ptMidB.vis(a);
							Vector3d vecB = edgesB[b].vecNormal(); 
						// not parallel or codirectional	
							if (!vecA.isParallelTo(vecB) ||  (vecA.isParallelTo(vecB) && vecA.isCodirectionalTo(vecB))) continue;
							
						// get range offset
							double dRangeXOffset = 	abs(vecA.dotProduct(ptMidA-ptMidB));
							if (dXRange>dEps && abs(dRangeXOffset -dXRange)<dEps)
								bDirectionBySelection =true;// accept intersecting ranges
						// not in line	
							else if (dRangeXOffset >dEps) continue;
						
						// test range
							Point3d ptsB[] = edgesB[b].plEdge().vertexPoints(true);
							ptsB= lnA.orderPoints(ptsB);
							if (ptsB.length()<1) continue;
							double dA0B1=vecXA.dotProduct(ptsA[0]-ptsB[1]);
							double dB0A1=vecXA.dotProduct(ptsB[0]-ptsA[1]);
							if (!(dA0B1<0 && dB0A1<0))continue;

						// store the ref vector
							if (vecRefNormal.bIsZeroLength())
								vecRefNormal=vecA;
						// test parallelism
							else if (!vecRefNormal.isParallelTo(vecA))	
								bIsParallel=false;
							
						// count connections
							nNumEdge++;


						// debug display
							if (bDebugMapIO)
							{	
								Point3d pt = ptMidA+vecXA*(i+j)*U(30);
								Display dp(i+j); dp.textHeight(U(20));
								dp.draw(sips[i].posnum() + "+" + sips[j].posnum() + " "  + dA0B1 + "_" + dB0A1,pt, vecA, vecXA, 0,0 );
								vecA.vis(pt,i);
								vecB.vis(pt,i);
							}	

						// compose and append edge		
							Map mapEdge;
							mapEdge.setVector3d("vecNormal", vecA);
							mapEdge.setPoint3d("ptStart", edgesA[a].ptStart());
							mapEdge.setPoint3d("ptMid", edgesA[a].ptMid());
							mapEdge.setPoint3d("ptEnd", edgesA[a].ptEnd());
							mapEdge.setPLine("plEdge", edgesA[a].plEdge());
							mapEdges.appendMap("Edge", mapEdge);							

						// append secondary panel if not set yet	
							if (!mapConnection.hasEntity("Sip1"))
							{
								mapConnection.setEntity("Sip1", sips[j]);	
							}											
						}// next edge b
						if (mapEdges.length()>0)
						{
							nNumConnection++;
							mapConnection.setInt("DirectionBySelection",bDirectionBySelection );
							mapConnection.setEntity("Sip0", sips[i]);
							mapConnection.setMap("Edge[]", mapEdges);
							mapConnections.appendMap("Connection", mapConnection);	
						}						
					}// next j
					
				}// next edge A	
			}		
			mapConnections.setInt("MultipleParallel", bIsParallel);
			mapConnections.setInt("numConnection", nNumConnection);
			mapConnections.setInt("numEdges", nNumEdge);	
			_Map.setMap("Connection[]",mapConnections);
			if (bDebugMapIO)_Map.writeToDxxFile(_kPathDwg + "\\" + dwgName() + "Connections.dxx");							
		}// end if (nFunction==0)
		return;	
	}// END on mapIO
//endregion End onMapIO	//_______________________________________________________________

//region on insert
	if (_bOnInsert)
	{
	// collect catalog and style entries and test if style alike named catalog entries are existing
		String sEntries[] = TslInst().getListOfCatalogNames(scriptName());	
		String sStyleEntries[] = SipStyle().getAllEntryNames();
		int bHasStyleEntries;
		for (int i=0;i<sStyleEntries.length();i++)
			sStyleEntries[i]=sStyleEntries[i].makeUpper();
		for (int i=0;i<sEntries.length();i++)
		{
			String sEntry = sEntries[i];
			sEntry.makeUpper();
			for (int j=0;j<sStyleEntries.length();j++)
			{
				if(sStyleEntries[j].find(sEntry,0)>-1)
				{
					bHasStyleEntries=true;
					if(bDebug)reportMessage("\nhas at least one style alike entry");
					break;
				}
			}
			if (bHasStyleEntries)break;
		}			
			
	// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();
		
//	// has been called in the beam creation mode	
//		if (sKey.find("_CREATEASBEAM",0)>-1)
//		{
//			_Map.setInt("CreateAsBeam", true);
//			sKey = sKey.spanExcluding("_CREATEASBEAM");
//		}
//		
//		
		if (sKey.length()>0)
			setPropValuesFromCatalog(sKey);
		else
			showDialogOnce();		
		//if (bDebug)reportMessage("\nInserting with key "+ sKey);

		int nAlignment = sAlignments.find(sAlignment);
		int bGripModeCreation = mapSetting.getInt("General\GripModeCreation");

	// get selection set
		PrEntity ssE(T("|Select panels|")+ ", " + T("|<Enter> to select a wall|"), Sip());
		Entity ents[0];
		if (ssE.go())
			ents = ssE.set();
	
	// cast to sips
		Sip sips[0];
		for (int i=0;i<ents.length();i++)
			sips.append((Sip)ents[i]);

	// if any catalog key was given try to find an entry matching the style name
		if (sKey.length()>0 && bHasStyleEntries && sips.length()>0)
		{	
			String sStyle = sips[0].style();
			sStyle.makeUpper();
			int bOk;
			for(int i=0;i<sEntries.length();i++)
			{
				String sEntry = sEntries[i];
				sEntry.makeUpper();
//				reportMessage("\n"+ sEntry);
				if (sStyle.find(sEntry,0)>-1)
				{
					//reportMessage("\nassigning catalog " + sStyle);
					bOk=setPropValuesFromCatalog(sEntry);
					break;
				}
			}// next i
			
			//reportMessage("\nassigning catalog of style based entry = " + bOk);
		}

	// set _Sip from mapIO debug
		if (bDebugMapIO)
		{
			_Sip=sips;
			return;
		}
		
	// prompt alternativly for an element
		if (sips.length()<1)
		{
			_Element.append(getElement());
			_Pt0 = getPoint();
			return; // stop insert code here
		}
	// get split location in case only one panel is selected
		else if (sips.length()==1)
		{
			Sip sip = sips[0];
			_Map.setInt("mode", 1);// panel mode
			_Pt0 = getPoint(T("|Select first split point on plane|"));	
			
			Point3d ptSplit;
			PrPoint ssP("\n" + T("|Select second point|"), _Pt0); 
			
			if (ssP.go()==_kOk) 
				ptSplit= ssP.value();	
			if (Vector3d(_Pt0-ptSplit).length()<dEps) 
			{
				reportMessage("\n"+scriptName()+" "+T("|Invalid points selected|"));
				eraseInstance();
				return;		
			}					
				
			Vector3d vecZ = sip.vecZ();
			Vector3d vecZ2 = ptSplit-_Pt0;
			vecZ2.normalize();
			Vector3d vecDir;
			
			
		// split point not in XY plane
			if (vecZ2.isParallelTo(vecZ) && !_ZU.isParallelTo(vecZ2))
			{
				vecDir = vecZ2.crossProduct(-_ZU);
			}
			else	
			{	
			// for roof panels project selected points on to panel center plane
				if (!vecZ.isParallelTo(_ZW) && !vecZ.isCodirectionalTo(_ZW) && !vecZ.isPerpendicularTo(_ZW))
				{
					double dDistanceToPlane = 0;
					int bProject=true;

					// default axis
					if (nAlignment==0) // reference side
						dDistanceToPlane =-.5*sip.dH();	
					else if (nAlignment==2) // opp side
						dDistanceToPlane =.5*sip.dH();	
					
//				// prompt user for input
//					String sInput;
//					String sAlignments[] = {T("|Bottom face|"), T("|Axis|"),T("|Top face|"), T("|Not projected|")};
//					sInput=getString(T("|Projection of splitting points|") + ": [" + sAlignments[0]+"/" + sAlignments[1]+"/" + sAlignments[2]+"/" + sAlignments[3]+ "]" + " <"+ sAlignments[1]+ ">");
//					if (sInput.length()>0)
//					{
//						String sFirstChar = sInput.left(1).makeUpper();
//						if (sFirstChar==sAlignments[0].left(1).makeUpper())
//							dDistanceToPlane =-.5*sip.dH();
//						else if (sFirstChar==sAlignments[2].left(1).makeUpper())
//							dDistanceToPlane =.5*sip.dH();				
//						else if (sFirstChar==sAlignments[3].left(1).makeUpper())
//							bProject=false;
//					}						

					if (bProject)
					{
						Plane pnFace(sip.ptCen(), vecZ);
						_Pt0=Line(_Pt0,_ZW).intersect(pnFace, dDistanceToPlane);
						ptSplit=Line(ptSplit,_ZW).intersect(pnFace,dDistanceToPlane );
					}
				}
				else
					ptSplit.transformBy(_ZU*_ZU.dotProduct(_Pt0-ptSplit));	
				
			// get split vectors
				Vector3d vecX = ptSplit-_Pt0;	
				vecX.normalize();
				vecDir = vecX.crossProduct(vecZ);
			}
			
		// show debug	
			if (0)
			{
				EntPLine epl;
				epl.dbCreate(PLine(_Pt0,ptSplit));	
				epl.setColor(1);
			}
			
		// declare splitting plane and publish as map entry
			Plane pnSplit(_Pt0,vecDir);
			_Map.setVector3d("vecDir", vecDir);
			Vector3d vecX = vecZ.crossProduct(vecDir);	
		// relocate reference point to the center of the envelope
			PLine pl = sips[0].plEnvelope();		
			Point3d ptsInt[] = Line(_Pt0,vecX).orderPoints(pl.intersectPoints(pnSplit));
			if (ptsInt.length()>0)
			{
				Point3d ptMid = (ptsInt[0]+ptsInt[ptsInt.length()-1])*.5; 
				_Pt0.transformBy(vecX*vecX.dotProduct(ptMid-_Pt0));
			}

		// split the apnel and add it to the list of panels
			Sip sipSplit[0];
			sipSplit= sip.dbSplit(pnSplit,0);	
		
		// append to _Sip
			_Sip.append(sip);
			_Sip.append(sipSplit);			
		}// end if only one panel selected	 ------------------------------------one panel selected		
				
	// multiple panels selected
		else if (sips.length()>1)
		{
			Sip sip = sips[0];
			Vector3d vecX,vecY,vecZ;
			vecX = sip .vecX();
			vecY = sip .vecY();
			vecZ = sip .vecZ();
			Point3d ptCen = sip .ptCenSolid();		
		
		// prepare tsl cloning
			TslInst tslNew;
			Vector3d vecXTsl= vecX;
			Vector3d vecYTsl= -vecZ;
			GenBeam gbsTsl[2];
			Entity entsTsl[0];
			Point3d ptsTsl[1];
			int nProps[]={};
			double dProps[]={dWidth,dGapWidth,dDepth,dGapDepth,
				dChamferRef,dChamferOpp,dGapRelief,dGapPanel};
			String sProps[]={sAlignment,sMaterial,sGrade};
			Map mapTsl;
			mapTsl.setInt("mode", 1);// panel mode
			String sScriptname = scriptName();		

		// retrieve connection data		
			Map mapIO;
			mapIO.setDouble("XRange",0);//dDepth
			for (int e=0;e<sips.length();e++)
				mapIO.appendEntity("Entity", sips[e]);
			TslInst().callMapIO(scriptName(), mapIO);
			Map mapConnections = mapIO.getMap("Connection[]");		
		
			int nNumConnection = mapConnections.getInt("numConnection");
			int nNumEdges= mapConnections.getInt("numEdges");
			int bMultipleParallel= mapConnections.getInt("MultipleParallel");
			if(bDebug)reportMessage("\nThe call returned:" + "\n	"+
			 	nNumConnection  + " connections" +"\n	" +	
				nNumEdges+ " edges" +"\n	" +	
				bMultipleParallel + " multi parallelism");
			
		// the connection direction, default is first connection
			Vector3d vecDir = mapConnections.getMap("Connection\\Edge[]\\Edge").getVector3d("vecNormal");	
			_Pt0 = sips[0].ptCen();		
		
		// decide prompt behaviour
			// if multiple parallelism applies we only need a direction, else an edge location is required
			int bApplyAll;
			if (!bMultipleParallel)
			{
				PrPoint ssP("\n" + T("|Select point closed to the desired lap joint|") + ", " + T("|<Enter> for all connections|"));
				if (ssP.go()==_kOk)
					_Pt0 = ssP.value();	
				else
					bApplyAll=true;
				
			// collect pline edges
				PLine plEdges[0];
				Vector3d vecDirs[0];
				for (int i=0;i<mapConnections.length();i++)
				{
					Map mapConnection = mapConnections.getMap(i);
					for (int j=0;j<mapConnection.length();j++)
					{
						Map mapEdges = mapConnection.getMap(j);
						for (int e=0;e<mapEdges.length();e++)
						{
							Map mapEdge = mapEdges.getMap(e);
							plEdges.append(mapEdge.getPLine("plEdge"));
							vecDirs.append(mapEdge.getVector3d("vecNormal"));
						}	
					}// next j
				}// next i
				//reportMessage("\n	" + plEdges.length() + " collected");
			
			// snap _Pt0 to the closest plEdge
				double dDistMin=U(10e8);
				PLine plEdge;
				for (int i=0;i<plEdges.length();i++)
				{
					Point3d ptNext = plEdges[i].closestPointTo(_Pt0);
					ptNext.transformBy(vecZ*vecZ.dotProduct(_Pt0-ptNext));
					double dDist = (ptNext-_Pt0).length();
					if (dDist<dDistMin)
					{
						dDistMin = dDist;
						plEdge= plEdges[i];
						vecDir = vecDirs[i]; 
					}	
				}// next i			
				if (plEdge.length()>dEps)
				{
					if (bDebug){EntPLine epl;epl.dbCreate(plEdge);epl.setColor(bApplyAll);}			
					_Pt0.setToAverage(plEdge.vertexPoints(true));
				}
			}// END IF (!bMultipleParallel)		
		// get optional direction
			if (bMultipleParallel || !bApplyAll)
			{
			// test if any selected connection has is overlapping 
				int bHasDirectionBySelection;
				for (int i=0;i<mapConnections.length();i++)
					if (mapConnections.getMap(i).getInt("DirectionBySelection"))
					{
						bHasDirectionBySelection=true;
						break;
					}

			// skip selection of direction if all connections overlap
			// disabled due to parity of panels
				if(0 && !bHasDirectionBySelection)
				{
					PrPoint ssDirection("\n" + T("|Specify direction|") + ", " + T("|<Enter> for default direction|"), _Pt0);
					if (ssDirection.go()==_kOk)
					{
						Point3d pt2 = ssDirection.value();
						pt2.transformBy(vecZ*vecZ.dotProduct(_Pt0-pt2));
						Vector3d vecDirUser= _Pt0-pt2;
						if (vecDirUser.dotProduct(vecDir)<0)
							vecDir*=-1;
						//vecDir= vecDir.crossProduct(vecZ).crossProduct(-vecZ);
						//vecDir.normalize();				
					}	
				}
			}	
			
		// create instances per connection
			Vector3d vecDirs[0]; // collect created directions and locations
			Point3d ptsLocs[0];
			for (int i=0;i<mapConnections.length();i++)
			{
				Map mapConnection = mapConnections.getMap(i);
				Entity ent0 = mapConnection.getEntity("Sip0");
				Entity ent1 = mapConnection.getEntity("Sip1");
				Sip sip0 = (Sip)ent0;
				Sip sip1 = (Sip)ent1;
				if (!sip0.bIsValid() ||!sip1.bIsValid())
				{
					if (bLog)reportMessage("\ninvalid connection ignored");
					continue;	
				}
				
			// get flag if direction is to be detected from selection sequence	
				int bDirectionBySelection = mapConnection.getInt("DirectionBySelection");
				for (int j=0;j<mapConnection.length();j++)
				{
					Map mapEdges = mapConnection.getMap(j);
					for (int e=0;e<mapEdges.length();e++)
					{
						Map mapEdge = mapEdges.getMap(e);
						Vector3d vecNormal = mapEdge.getVector3d("vecNormal");
						Point3d ptMid= mapEdge.getPoint3d("ptMid");
						
					// creation flag
						int bCreate, nDebugColor=-1;	
						
					// just a single connection with multiple edges available, i.e. a header in another panel	
						if (sips.length()==2 && !bMultipleParallel && !bApplyAll)
						{
							if(abs(vecDir.dotProduct(_Pt0-ptMid))<dEps)
								nDebugColor=1;	
						}
					// fixed orientation, normal must be parallel with vecDir
						else if (!bMultipleParallel && !bApplyAll && vecNormal.isParallelTo(vecDir))
						{
							nDebugColor=vecNormal.isCodirectionalTo(vecDir)+2;	
						}
						else if (bMultipleParallel)
						{
							nDebugColor=vecNormal.isCodirectionalTo(vecDir)+4;	
						}
						else if (bApplyAll)
						{		
							vecDir = vecNormal;
						
						// collect unique directions
							int bAdd=true;
							for (int v=0;v<vecDirs.length();v++)
								if (vecDirs[v].isParallelTo(vecDir) && abs(vecDir.dotProduct(ptMid-ptsLocs[v]))<dEps)
								{
									vecDir=vecDirs[v];
									bAdd=false;		
								}	
							if (bAdd)
							{
								vecDirs.append(vecDir);
								ptsLocs.append(ptMid);	
							}
						
							nDebugColor=3;	
						}	
						if (nDebugColor>-1)bCreate=true;	
						
						if (bDebug)reportMessage("\n	type " + nDebugColor + " detected" + " bApplyAll:" + bApplyAll + " bMultipleParallel" +  bMultipleParallel);
									
						if (bDebug && bCreate)
						{
							EntPLine epl;
							epl.dbCreate(mapEdge.getPLine("plEdge"));
							epl.setColor(nDebugColor);
						}
						
					// create
						if (bCreate && !bDebug)
						{
						// swap panel sequence
							double dNormal = vecDir.dotProduct(vecNormal);
							int bSwap;
								
							if (bDirectionBySelection && dNormal<0)
								vecDir*=-1;
							else if (!bApplyAll && dNormal<0)
								bSwap=true;

							if (bSwap)
							{
								if (bDebug)reportMessage("\n	swapping..." + "\n	dNormal: "+dNormal+ "\n	bApplyAll : "+bApplyAll + "\n	bDirectionBySelection : "+bDirectionBySelection);
								Sip sipTemp = sip0;
								sip0=sip1;
								sip1=sipTemp;	
							}	
						
							//reportMessage("\n	create " + nDebugColor + " for " + sip0.posnum() + " + " +sip1.posnum());
							gbsTsl[0] = sip0;
							gbsTsl[1] = sip1;
							
							if (bDebug)reportMessage("\n	gbs0 " + sip0.posnum()+ " " + " gbs1 " + sip1.posnum());
							
							ptsTsl[0] = ptMid;
							mapTsl.setVector3d("vecDir", vecDir);
			
							if (bGripModeCreation)
								mapTsl.setInt("directEdit", true);							
							
							tslNew.dbCreate(scriptName(), vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
								nProps, dProps, sProps,_kModelSpace, mapTsl);	
								
							if (tslNew.bIsValid())
								tslNew.transformBy(Vector3d(0,0,0));	
							//EntPLine epl;
							//epl.dbCreate(PLine(ptMid, ptMid+vecDir*U(300)));
							//epl.setColor(nDebugColor);		
								
								
						}						
					}	
				}// next j
			}// next i	
			if (bLog)reportMessage("\nerasing insert instance");
			eraseInstance();							
		}
		return;	
	}		
//End on insert//endregion 

//region read settings and set variables if possible
	int nVersion;
	int nc = 252, nt;
	Map mapSQColor;
	String sGroupName;
	int bCreateAsBeam;
	{
		String k;
		Map m = mapSetting.getMap("General");
		k = "Version";			if (m.hasInt(k))	nVersion = m.getInt(k);
		k = "Color";			if (m.hasInt(k))	nc = m.getInt(k);
		
		mapSQColor = mapSetting.getMap("SurfaceQualityStyle[]");
		
		m = mapSetting.getMap("Conversion");
		k = "GroupName";		if (m.hasString(k))	sGroupName = m.getString(k);
		k = "ConvertToBeam";	if (m.hasInt(k))	bCreateAsBeam = m.getInt(k);
	}
//endregion


//region Get Surface Qualities and set dependency
// get highest quality of associated panels
	String sSqNames[2]; // 0= bottom, 1 = top
	int nSqQualities[2];
	for (int i=0;i<_Sip.length();i++) 
	{ 
		Sip& sip= _Sip[i];
		_Entity.append(sip);
		setDependencyOnEntity(sip);
		
		SipStyle style = sip.style();
		SurfaceQualityStyle sqs[0];
		sqs.append(sip.surfaceQualityOverrideBottom().length() > 0 ? SurfaceQualityStyle(sip.surfaceQualityOverrideBottom()) : SurfaceQualityStyle(style.surfaceQualityBottom()));
		sqs.append(sip.surfaceQualityOverrideTop().length() > 0 ? SurfaceQualityStyle(sip.surfaceQualityOverrideTop()) : SurfaceQualityStyle(style.surfaceQualityTop()));
		for (int j=0;j<sqs.length();j++) 
		{ 
			SurfaceQualityStyle& sq = sqs[j];
			int nQuality = sq.quality();
			if (nSqQualities[j]<nQuality)
			{ 
				nSqQualities[j] = nQuality;
				sSqNames[j] = sq.entryName().makeUpper();
			}			
		}//next j	
	}//next i		
//End Get Surface Qualities //endregion 

//region Set alignment
	int nAlignment = sAlignments.find(sAlignment);
	// change to ref/opp side if same quality
	if (nAlignment>2 && nSqQualities[0] == nSqQualities[1])
	{ 
		int n = nAlignment;
	// auto correct selected alignment during creation	
		if (_bOnDbCreated)
			nAlignment = nAlignment == 3 ? 0 : 2;
	// make sure changing surface qualities to identical values will not chnage alignment		
		else if (_Map.hasInt("PreviousAlignment"))
			nAlignment = _Map.getInt("PreviousAlignment");

		if (n!=nAlignment)
		{
			sAlignment.set(sAlignments[nAlignment]);
			reportMessage("\n"+scriptName()+" "+T("|Qualities are identical on each side, alignment changed to| ")+ sAlignment);
			setExecutionLoops(2);
			return;	
		}
	}
	// to higher quality
	if (nAlignment==3)
	{ 
	
		nAlignment = nSqQualities[0] < nSqQualities[1] ? 0 :2;	
	}
	// to lower quality
	else if (nAlignment==4)
	{ 
		nAlignment = nSqQualities[0] < nSqQualities[1] ? 2 :0;	
	}
	_Map.setInt("PreviousAlignment", nAlignment);		
//End Set alignment //endregion 

//region Color assignment
// color assignment on dbCreated
	if (_bOnDbCreated)
	{
		_ThisInst.setColor(nc);
	}
	
// color assignment based on highest quality
	if (mapSQColor.length()>0)
	{ 
//	// get highest quality of associated panels
		String sSQName = sSqNames[0];// bottom
		if (nSqQualities[0]<nSqQualities[1])// top
			sSQName = sSqNames[1];
	// find color match in setting
		for (int i=0;i<mapSQColor.length();i++) 
		{ 
			Map m= mapSQColor.getMap(i);
			if (m.getString("Name").makeUpper()==sSQName && m.hasInt("Color"))
			{ 
				nc = m.getInt("Color");
				break;
			} 
		}//next i
		
		if (_ThisInst.color()!=nc)
			_ThisInst.setColor(nc);
	}		
//End Color assignment//endregion 
		

//End Part 1//endregion 	

//region Panel mode
if (nMode==1)
{
	
//region Standards

// validate referenced sips
	if (_Sip.length()<2)
	{
		reportMessage("\n" + scriptName() + " "+ T("|requires at least 2 panels|"));
		eraseInstance();
		return;	
	}

// set copy behavior
	setEraseAndCopyWithBeams(_kBeam0);	
	
// the first panel is taken as reference sip
	Sip sipRef = _Sip[0];
	PLine plEnvelope =sipRef.plEnvelope();
	Vector3d vecX,vecY,vecZ;
	vecX = sipRef.vecX();
	vecY = sipRef.vecY();
	vecZ = sipRef.vecZ();
	Point3d ptCen = sipRef.ptCenSolid();
	vecX.vis(ptCen ,1);	vecY.vis(ptCen ,3);	vecZ.vis(ptCen ,150);
	double dZ = sipRef.dH();
	CoordSys cs(ptCen ,vecX, vecY, vecZ);
	Plane pnFace(ptCen+vecZ*(nAlignment-1)*.5*dZ, vecZ);	
	
// set the stretch value
	double dOverlap = 0;//dDepth;
	
// set the connection vector, it points from the male to the female panel
	Vector3d vecDir = _Map.getVector3d("vecDir");
	vecDir = vecDir .crossProduct(vecZ).crossProduct(-vecZ);vecDir.normalize();
	vecDir.vis(_Pt0,2);
	Vector3d vecPerp = vecDir.crossProduct(-vecZ);

	if (_Map.getInt("revertDirection"))
	{
		vecDir *= -1;
		_Map.setVector3d("vecDir", vecDir);
		if (bDebug)reportMessage("\n" + scriptName() + ": " +T("|executing|")   + " loop " + _kExecutionLoopCount+ " vecDir: " +vecDir);
		_Map.removeAt("revertDirection", true);	
		_ThisInst.transformBy(Vector3d(0,0,0));
	}	
//endregion 	
	
//region Trigger

	//region TriggerAddTool
	String sTriggerAddTool = T("|Add Tool|");
	if(bDebug)addRecalcTrigger(_kContextRoot, sTriggerAddTool );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddTool)
	{
		_Entity.append(getEntity("Select tool"));
		setExecutionLoops(2);
		return;
	}//endregion 
	
	//region TriggerFlipSide
	String sFlipTrigger = T("|Flip Side|");
	addRecalcTrigger(_kContextRoot, sFlipTrigger );//sTriggerFlipDirection
	if (_bOnRecalc && (_kExecuteKey==sFlipTrigger || _kExecuteKey==sDoubleClick)) 
	{
		if (nAlignment ==0)
			nAlignment =2;
		else if (nAlignment==2)
			nAlignment=0;
		else if (nAlignment==3)
			nAlignment=4;	
		else if (nAlignment==4)
			nAlignment=3;		
		sAlignment.set(sAlignments[nAlignment]);
		setExecutionLoops(2);
		return;
	}//endregion 	

	//region TriggerAddPanel
	String sTriggerAddPanel = T("|Add Panel|");
	addRecalcTrigger(_kContextRoot, sTriggerAddPanel);
	if (_bOnRecalc && _kExecuteKey==sTriggerAddPanel)
	{
	// get selection set
		PrEntity ssE(T("|Select panels|"), Sip());
			Entity ents[0];
			if (ssE.go())
				ents = ssE.set();

	// append if not found
		for (int i=0;i<ents.length();i++)
			if (_Sip.find(ents[i])<0)	
					_Sip.append((Sip)ents[i]);
		setExecutionLoops(2);
	}	
	// TriggerRemovePanel
		String sTriggerRemovePanel = T("|Remove Panel|");
		if (_Sip.length()>2)addRecalcTrigger(_kContextRoot, sTriggerRemovePanel );			
	//endregion 

	//region TriggerEditInPlacePanel
	int bEditInPlace=_Map.getInt("directEdit");
	String sTriggerEditInPlaces[] = {T("|Edit in Place|"),T("|Disable Edit in Place|")};
	String sTriggerEditInPlace = sTriggerEditInPlaces[bEditInPlace];
	if (_Beam.length()<1)addRecalcTrigger(_kContextRoot, sTriggerEditInPlace );
	if (_bOnRecalc && _kExecuteKey==sTriggerEditInPlace )	
	{
		if (bEditInPlace)
		{
			bEditInPlace=false;
			_PtG.setLength(0);	
		}
		else
			bEditInPlace= true;
		_Map.setInt("directEdit",bEditInPlace);
		setExecutionLoops(2);
		return;
	}//endregion 

	//region TriggerStaticTool
	String sTriggerStaticTool = T("|Convert to static|");
	addRecalcTrigger(_kContextRoot, sTriggerStaticTool);
	int bAddStatic;
	if (_bOnRecalc && _kExecuteKey==sTriggerStaticTool)
	{
		bAddStatic=true;
	}//endregion 

//endregion 

//region Purging and Validating

	//region Remove duplicates of this script
	// by the flag setEraseAndCopyWithBeams the instance is copied every time a panel is splitted. 
	// if the split is done perpendicular to another instance it might result into multiple instances acting on the same edge
	if (!vecDir.bIsZeroLength())
	{
		for (int i=0;i<_Sip.length();i++)
		{
			Sip sipThis = _Sip[i];
			Entity entTools[] = sipThis.eToolsConnected();
			//reportMessage("\n" + entTools.length() + " on " + sip.handle());	
			for (int j=entTools.length()-1;j>=0; j--)
			{
				TslInst tsl = (TslInst)entTools[j];

				if (tsl.bIsValid() && tsl!= _ThisInst && (tsl.scriptName()==scriptName()) && tsl.map().hasVector3d("vecDir"))
				{
				// compare double properties
					int bMatch=true;
					for (int p=0;p<nDoubleIndex;p++)	if(tsl.propDouble(p)!=_ThisInst.propDouble(p)){bMatch=false;break;}
					if (!bMatch)continue;
				// compare string property
					if(tsl.propString(0)!=_ThisInst.propString(0))continue;
				// test codirectional				
					if (!tsl.map().getVector3d("vecDir").isCodirectionalTo(vecDir)) continue;
				// test in line
					if (abs(vecDir.dotProduct(_Pt0-tsl.ptOrg()))>dEps) continue;

				// append panels of the other tool				
					{
						GenBeam gbsOthers[] = tsl.genBeam();
						for (int p=0;p<gbsOthers.length();p++)
							if (_Sip.find(gbsOthers[p])<0 && gbsOthers[p].bIsKindOf(Sip()))
								_Sip.append((Sip)gbsOthers[p]);
								
					// erase the other instance
						if (bLog)reportMessage("\n	" + tsl.handle() + " will be purged");
						tsl.dbErase();
					}
				}	
			}// next j
		}// next i
	}// END IF (!vecDir.bIsZeroLength())
		
//endregion 

	//region Remove every panel from _Sip array if not coplanar and of same thickness
// TODO this code needs to be reviewed, different thicknesses should be supported
	Point3d ptMinMaxThis[] = {ptCen-vecZ*.5*dZ,ptCen+vecZ*.5*dZ};
	for (int i = _Sip.length()-1; i>=0;i--)
	{
		Sip sipOther = _Sip[i];
		if (sipOther == sipRef) continue;
		
		Point3d ptMinMaxOther[] = {sipOther.ptCen()-vecZ*.5*sipOther .dH(),sipOther.ptCen()+vecZ*.5*sipOther .dH()};
		double dA0B1 = vecZ.dotProduct(ptMinMaxOther[1]-ptMinMaxThis[0]);
		double dB0A1 = vecZ.dotProduct(ptMinMaxThis[1]-ptMinMaxOther[0]);		

	// the panel is not in the same plane
		if (!vecZ.isParallelTo(sipOther.vecZ()) || !(dA0B1>=0 && dB0A1>=0))
		{
			reportMessage("\n"+scriptName()+" "+sipOther.posnum()+ " " + T("|removed from sset|"));
			_Sip.removeAt(i);
		}		
	}			
	//endregion 

//endregion 

//region Get overall profile
	PlaneProfile ppContour(cs);
	Plane pnRef(ptCen , vecZ);
	for (int i=0; i<_Sip.length();i++)
	{
		if (bDebug)reportMessage("\n	panel i:" +i);
		Body bd =_Sip[i].envelopeBody();
		PlaneProfile pp = bd.shadowProfile(pnRef);
		PLine plRings[] = pp.allRings();
		int bIsOp[] = pp.ringIsOpening();
		for (int r=0;r<plRings.length();r++)
			if (!bIsOp[r])
				ppContour.joinRing(plRings[r],_kAdd);
	}
	if (bDebug)reportMessage("\n	area:" +ppContour.area());
	ppContour.shrink(-dEps);
	ppContour.shrink(dEps);
	for (int i=0; i<_Sip.length();i++)
	{						
		PLine plOpenings[] = _Sip[i].plOpenings();
		if (bLog)reportMessage("\n	panel i:" +i + " adding openings " + plOpenings.length());
		for (int o=0;o<plOpenings.length();o++)
			ppContour.joinRing(plOpenings[o],_kSubtract);	
	}	
	//{Display dp(2); dp.draw(ppContour, _kDrawFilled, 60);}
//endregion 		

//region Get openings from contour
	int bReconstructOpening; // a flag to reconstruct the openings, true if any tslinst property  changes but false if the user modifies the vertices
	PLine plOpenings[0];
	PlaneProfile ppOpening(cs),ppContourNoOpening(cs);
	PLine plRings[] = ppContour.allRings();
	int bIsOp[] = ppContour.ringIsOpening();
	for (int r=0;r<plRings.length();r++) 
	{
		if (bIsOp[r]) 
		{
			plOpenings.append(plRings[r]);	
			ppOpening.joinRing(plRings[r], _kAdd);	
		}
		else
		{
			ppContourNoOpening.joinRing(plRings[r], _kAdd);				
		}
	}		
//endregion 
//		return;
//region Reference Location
// set the ref point
	_Pt0.transformBy(vecZ*vecZ.dotProduct(ptCen-_Pt0));
	Point3d ptRef = _Pt0;//XX +vecDir*dOverlap;

// in case _Pt0 has been dragged
	if (_Map.hasVector3d("vecRef") && _kNameLastChangedProp=="_Pt0")
	{
		ptRef =_PtW+_Map.getVector3d("vecRef");
		bReconstructOpening=true;
	}	
	
	vecPerp .vis(ptRef ,3);
	Line lnPerp(ptRef, vecPerp);		
//endregion 
	// HSB-24228
	double dGapApplied=_Map.getDouble("dGapApplied");

// collect relevant edges and its panel refs
	SipEdge edgesMales[0], edgesFemales[0];
	Sip sipsMales[0], sipsFemales[0];
	for (int i=0; i<_Sip.length();i++)
	{
		Sip sip = _Sip[i];
		SipEdge edges[] = sip.sipEdges();
		for (int e=edges.length()-1;e>=0;e--)
		{
			SipEdge edge = edges[e];
			Vector3d vecNormal = edge.vecNormal().crossProduct(vecZ).crossProduct(-vecZ);vecNormal.normalize();
		
			double dDistEdge=edge.vecNormal().dotProduct(edge.ptMid()-ptRef);
			double dDist = vecDir.dotProduct(edge.ptMid()-ptRef);
			int bMaleTest = abs(dDist-dOverlap)<dEps;
			int bFemaleTest = abs(dDist)<dEps;
			
			int bIsParallel = vecDir.isParallelTo(vecNormal) || 1-abs(vecNormal.dotProduct(vecDir))<0.0001;
			// HSB-24228	
//			if (!bIsParallel || (!bMaleTest && !bFemaleTest))
			if (!bIsParallel || abs(dDistEdge+.5*dGapApplied)>dEps)
			{
				//vecNormal.vis(edge.ptMid(),i+1);
				edges.removeAt(e);
				continue;
			}					
			vecNormal.vis(edge.ptMid(),i);
		}			
		for (int e=edges.length()-1;e>=0;e--)
		{
			Vector3d vecNormal = edges[e].vecNormal();
			Point3d ptMid = edges[e].ptMid();
			
		// ignore segments of openings
			if (0 && plOpenings.length()>0 && (ppOpening.closestPointTo(ptMid)-ptMid).length()<dEps && ppOpening.pointInProfile(ptMid+vecDir*dEps)==_kPointInProfile) 
			{
				ppOpening.vis(30);
				ptMid.vis(1);
				continue;	
			}
			
			double d=vecNormal.dotProduct(vecDir);
			int bIsMale = vecNormal.dotProduct(vecDir)>0;
			vecNormal.vis(edges[e].ptMid(),bIsMale);
			if (bIsMale)
			{
				edgesMales.append(edges[e]);
				sipsMales.append(sip);	
			}	
			else
			{
				edgesFemales.append(edges[e]);	
				sipsFemales.append(sip);		
			}
		}		
	}	
//	HSB-24228
	{ 
		// apply gap to panels
		if(_bOnDbCreated || _kNameLastChangedProp==sGapPanelName || _bOnDebug)
		{ 
			// apply gap at the edges
			for (int i=0;i<edgesFemales.length();i++) 
			{ 
				SipEdge edge=edgesFemales[i];
				Vector3d vEdge=edge.vecNormal();
				Point3d ptNew=ptRef-.5*vEdge*dGapPanel;
				
				Vector3d vMove=vEdge*vEdge.dotProduct(ptNew-edge.ptMid());
				if(vMove.length()>dEps)
				{ 
					//
					sipsFemales[i].stretchEdgeTo(edge.ptMid(),Plane(ptNew,vEdge));
				}
			}//next i
			for (int i=0;i<edgesMales.length();i++) 
			{ 
				SipEdge edge=edgesMales[i];
				Vector3d vEdge=edge.vecNormal();
				Point3d ptNew=ptRef-.5*vEdge*dGapPanel;
				
				Vector3d vMove=vEdge*vEdge.dotProduct(ptNew-edge.ptMid());
				if(vMove.length()>dEps)
				{ 
					//
					sipsMales[i].stretchEdgeTo(edge.ptMid(),Plane(ptNew,vEdge));
				}
			}//next i
			_Map.setDouble("dGapApplied",dGapPanel);
		}
	}
//	return;
// erase male only connections
	if (sipsMales.length()>1 && sipsFemales.length()<1)
	{
		reportMessage("\n"+scriptName()+" "+T("|Two male panels cannot be connected.|") + " " + T("|Tool will be deleted.|"));
		//eraseInstance();
		return;	
	}
	
//region Assigning to group
	if (sipsMales.length()>0)
	{
		Sip& male = sipsMales[0];
		
	// Get group of male panel	
		Group group, groups[] = male.groups();
		String part0, part1;
		for (int i=0;i<groups.length();i++) 
		{ 
			group = groups[i];
			part0 = group.namePart(0);
			part1 = group.namePart(1);					
			if (part1.length() > 0)break;
		}//next i	
		
	// assign to fixed custom group
		sGroupName.trimLeft().trimRight();
		if (sGroupName.length()>0 && part1.length() > 0)
		{ 
			String tokens[] = sGroupName.tokenize("\\");
		// item level	
			if (tokens.length()==1)
				group = Group(part0 + "\\" + part1 + "\\" + tokens.first());
		// floor level		
			else if (tokens.length()==2)
				group = Group(part0 + "\\" + tokens[0] + "\\" + tokens[1]);
		// house levelk
			else if (tokens.length()==3)
				group = Group(tokens[0] + "\\" + tokens[1]+ "\\" + tokens[2]);
			if (!group.bExists())
				group.dbCreate();
			group.addEntity(_ThisInst, true, 0, 'T');
			assignToGroups(_ThisInst); // addEntity not sufficient on _ThisInst
		}
		else		
		{
			if (bDebug)reportNotice("\ndefault assigning to group " +male.formatObject("@(PosNum) @(Name)"));
			assignToGroups(male);	
		}
	}
		
//endregion 
_Pt0.vis(3);
//region TriggerRemovePanel: remove the panel from _Sip and reset the panel edge if applicable
	if (_bOnRecalc && _kExecuteKey==sTriggerRemovePanel )
	{
		bReconstructOpening=true;
	// get selection set
		PrEntity ssE(T("|Select panel(s)|"), Sip());
			Entity ents[0];
			if (ssE.go())
				ents = ssE.set();

	// loop sset
		for (int i=0;i<ents.length();i++)
		{
			Sip sipRemove = (Sip)ents[i];
		// reset female stretch if is a female panel
			int nFemale = sipsFemales.find(sipRemove);
			if (nFemale >-1)
				sipRemove.stretchEdgeTo(edgesFemales[nFemale].ptMid(),Plane(_Pt0,vecDir));
			
			int n = _Sip.find(sipRemove);
			if (n>-1)
				_Sip.removeAt(n);	
		}
		setExecutionLoops(2);
		return;		
	}		
//endregion 

	// HSB-11210
	PlaneProfile ppAll(cs);
	for (int i=0;i<sipsMales.length();i++) 
		ppAll.joinRing(sipsMales[i].plShadow(), _kAdd);
	for (int i=0;i<sipsFemales.length();i++) 
		ppAll.joinRing(sipsFemales[i].plShadow(), _kAdd);
	
//region Get common range
	PlaneProfile ppCommon(cs);
	{
		PlaneProfile pp(cs), ppMale(cs), ppFemale(cs);
		Sip sips[0]; sips=sipsMales;
		Vector3d vec = vecDir;
		double dThisGap= .5*(dWidth+dGapWidth);
		Point3d ptStretch = ptRef;
		for (int x=0;x<2;x++)
		{
			// 2 panels first will be male, second will be female
			//ptStretch .vis(x);
			for (int i=0;i<sips.length();i++)
			{
				PlaneProfile pp(sips[i].plShadow());
//					pp.vis(1);
			// stretch at least slightly to detect common range
				if (dThisGap<=0)dThisGap = dEps;
				if (dThisGap>0)
				{	
					Point3d pts[] = pp.getGripEdgeMidPoints();
					int bs[0];
					for (int p=0;p<pts.length();p++)
					{
						int b;
						if (abs(vecDir.dotProduct(ptStretch - pts[p]))<dEps)
						{
//							pts[p].vis(4);
							b=true;
						}
						bs.append(b);
					}
//					pp.vis(1);
					// HSB-11210
					PlaneProfile ppStripLong(pp.coordSys()), ppStrip(pp.coordSys());
					PLine plStripLong, plStrip;
					Vector3d vecLong = vec.crossProduct(vecZ);
					vecLong.normalize();
					LineSeg lSegStripLong(ptStretch - vec * dEps - vecLong * U(10e3), ptStretch + vec * dEps + vecLong * U(10e3));
					LineSeg lSegStrip(ptStretch - vec * dEps - vecLong * U(10e3), ptStretch + vec * (dEps+2*dThisGap) + vecLong * U(10e3));
					plStripLong.createRectangle(lSegStripLong, vec, vecLong);
					plStrip.createRectangle(lSegStrip, vec, vecLong);
					ppStripLong.joinRing(plStripLong, _kAdd);
					ppStrip.joinRing(plStrip, _kAdd);
						ppStripLong.vis(5);
						ppStrip.vis(5);
					PlaneProfile ppIntersectTest = ppStripLong;
					ppIntersectTest.transformBy(vec * 2 * dEps);
					if(!ppIntersectTest.intersectWith(pp))
					{ 
						// add
						ppStrip.intersectWith(ppAll);
						pp.unionWith(ppStrip);
					}
					else
					{ 
						// subtract
						ppStrip.intersectWith(ppAll);
						pp.subtractProfile(ppStrip);
					}
//						for (int p=0;p<bs.length();p++)
//						{
//							if (bs[p])
//							{
//								// method doesnt always work
//								pp.moveGripEdgeMidPointAt(p, vec*2*dThisGap);
//							}
//						}
				}
//				pp.vis(3);
			// resolve rings
				plRings = pp.allRings();
				bIsOp=pp.ringIsOpening();
				for (int r=0;r<plRings .length();r++)
				{
					plRings[r].vis(x);
					if (!bIsOp[r] && x==0)	
						ppMale.joinRing(plRings[r], _kAdd);
					else if (!bIsOp[r] && x==1)	
						ppFemale.joinRing(plRings[r], _kAdd);
				}						
			}// next i sip
			vec*=-1;			
			ptStretch.transformBy(vec*dOverlap);
			sips=sipsFemales;
		}// next x
		//ppMale.vis(4);ppFemale.vis(6);
		ppCommon = ppMale;
		ppCommon.intersectWith(ppFemale);
		//ppCommon.transformBy(vecZ*U(400));
		//ppCommon.vis(20);
		
//		visPp(ppCommon,_ZW*U(600));
		
		//{Display dp(2); dp.draw(ppCommon, _kDrawFilled, 60);}
	}		
	LineSeg segCommon = ppCommon.extentInDir(vecPerp);	segCommon.vis(6);
//endregion 

	

// in case edit in place is active limit the common range to the grip range
	if (_PtG.length()>1)
	{
		_PtG = lnPerp.orderPoints(_PtG);
		
		
	// transform grips to reference face to allow  grip access in plan view
		int n=1; // alternating side
		for (int i=0;i< _PtG.length();i++)
		{
			_PtG[i].transformBy(vecZ*vecZ.dotProduct((ptRef-vecZ*n*.5*dZ) -_PtG[i]) + vecDir*vecDir.dotProduct(ptRef-_PtG[i]));	
			n*=-1;	
		}

		Point3d ptStart = segCommon.ptStart();
		ptStart.transformBy(vecPerp*vecPerp.dotProduct(_PtG[0]-ptStart));
		Point3d ptEnd = segCommon.ptEnd();
		ptEnd .transformBy(vecPerp*vecPerp.dotProduct(_PtG[_PtG.length()-1]-ptEnd ));	
		segCommon = LineSeg(ptStart, ptEnd);
//		segCommon.vis(1);
		PLine plRec;
		plRec.createRectangle(segCommon, vecPerp, vecDir);
		PlaneProfile pp(plRec);
		ppCommon.intersectWith(pp);
		
		
	}
	// HSB-24228
	if(dGapApplied>dEps)
	{ 
		ppCommon.shrink(-(.5*dGapApplied+U(1)));
		ppCommon.shrink((.5*dGapApplied+U(1)));
		ppCommon.shrink((.5*dGapApplied+U(1)));
		ppCommon.shrink(-(.5*dGapApplied+U(1)));
	}
	visPp(ppCommon,_ZW*U(700));
	
// HSB-21901 Only full intersections allowed
	PlaneProfile ppBox; ppBox.createRectangle(ppCommon.extentInDir(vecDir), vecDir, vecPerp);
	// HSB-23017: create rectangular ppCommon envelope, for skew cut panels
	PlaneProfile ppCommonEnvelope(ppCommon.coordSys());
	{ 
		PLine plsCommonOutter[]=ppCommon.allRings(true,false);
		PLine plsCommonInner[]=ppCommon.allRings(true,false);
		for (int i=0;i<plsCommonOutter.length();i++) 
		{ 
			PlaneProfile ppPl(plsCommonOutter[i]);
			PlaneProfile ppI(ppCommon.coordSys());
			ppI.createRectangle(ppPl.extentInDir(vecPerp),cs.vecX(), cs.vecY());
			ppCommonEnvelope.unionWith(ppI);
		}//next i
		visPp(ppCommonEnvelope,_ZW*U(1000));
	}
	// HSB-23017
//	ppBox.subtractProfile(ppCommon);
	ppBox.subtractProfile(ppCommonEnvelope);
	PLine rings[] = ppBox.allRings(true, false);
	for (int r=0;r<rings.length();r++) 
	{ 
		PlaneProfile ppSub(cs);
		ppSub.joinRing(rings[r], _kAdd);
		Vector3d vec = .5*cs.vecX() * ppSub.dX() + cs.vecY() * U(10e4);//ppSub.dY();
		ppSub.createRectangle(LineSeg(ppSub.ptMid()-vec,ppSub.ptMid()+vec),cs.vecX(), cs.vecY()); 
//		visPp(ppSub,_ZW*U(800));
		ppCommon.subtractProfile(ppSub);
	}//next r	
	segCommon = ppCommon.extentInDir(vecPerp);
	
	ppCommon.transformBy(vecZ*U(300));
	ppCommon.vis(6);
	segCommon .vis(40);
//region Remove any segment which is not intersecting the common range
	Point3d ptsCommon[] = {segCommon.ptStart(), segCommon.ptEnd()};
	ptsCommon = lnPerp.orderPoints(ptsCommon);
	
// validate common range
	if (ptsCommon.length()<2)
	{
		reportMessage("\n"+scriptName()+" "+T("|no common range|"));
		return;	
	}		
	for (int x=0; x<2;x++)
	{
		PlaneProfile ppTest(cs);
		SipEdge edges[0];
		if (x==0) edges=edgesMales;
		if (x==1) edges=edgesFemales;
		
		for (int e=edges.length()-1;e>=0;e--)
		{
			Point3d ptsB[] = {edges[e].ptStart(),edges[e].ptEnd()};
			ptsB= lnPerp.orderPoints(ptsB);
			if (ptsB.length()<2)
			{
				reportError("\nno common range");
				return;	
			}			
			double dA1B2 = vecPerp.dotProduct(ptsCommon[0]-ptsB[1]);
			double dB1A2 = vecPerp.dotProduct(ptsB[0] - ptsCommon[1]);
			if (dA1B2>dEps || dB1A2>dEps)
			{
				edges.removeAt(e);
				if (x==0)sipsMales.removeAt(e);
				if (x==1)sipsFemales.removeAt(e);
			}
		}
		
		if (x==0) edgesMales=edges;
		if (x==1) edgesFemales=edges;					
	}
		
//endregion 

// loop valid edges
	for (int x=0; x<2;x++)
	{
		SipEdge edges[0];
		Sip sips[0];
		Point3d ptStretch = _Pt0;
		if (x==0) 
		{
			sips= sipsMales;
			edges=edgesMales;
			ptStretch.transformBy(vecDir*dOverlap);	//XX
		}
		if (x==1) 
		{
			sips= sipsFemales;
			edges=edgesFemales;
			//ptStretch.transformBy(-vecDir*dOverlap);
		}	
		
		for (int e=0; e<edges.length();e++)
		{
			if (sips.length()>e)
			{
				// HSB-24228
				ptStretch=ptRef-edges[e].vecNormal()*.5*dGapApplied;
				Plane pnStretch(ptStretch,-vecDir);
				Sip sip = sips[e];

				// HSB-22701 performance enhanced
				Vector3d vecNormal = edges[e].vecNormal();
				double dStretch = vecNormal.dotProduct(ptStretch - edges[e].ptMid());				
				if (abs(dStretch)<dEps)
				{ 
					continue;
				}
				//if (bDebug)reportMessage("\n" + sip.handle() + ": " +T("|stretch edge|") + " " + e+ " to plane " +pnStretch + " by " +dStretch);
				sip.stretchEdgeTo(edges[e].ptMid(),pnStretch);
//				vecNormal.vis(edges[e].ptMid(), x);
//				vecNormal.vis(sip.ptCen(), x);
			
			// reconstruct the opeings if flagged
				if (bReconstructOpening)
				{
					for (int o=0; o<plOpenings.length();o++)
					{
						PLine plOpening = plOpenings[o];
					// test if this opening is intersected by the edge
						Point3d ptsInt[] = plOpening.intersectPoints(pnStretch);
						pnStretch.transformBy(vecDir*dOverlap);
						ptsInt.append(plOpening.intersectPoints(pnStretch));
						if (ptsInt.length()>0)
							sip.addOpening(plOpening, false);	
					}	
				}
			}
		}// next e
	}// next x



// on the event of moving _Pt0
	if(_kNameLastChangedProp=="_Pt0")
	{
		if (bDebug)reportMessage("\n" + scriptName() + ": _Pt0 modified");
		setExecutionLoops(2);
		return;
	}//end if(_kNameLastChangedProp=="_Pt0")	

// Display
	Display dpModel(_ThisInst.color()), dpPanel(_ThisInst.color());
	dpModel.addHideDirection(vecZ);
	dpModel.addHideDirection(-vecZ);
	dpModel.showInDxa(true);// HSB-23001
	dpPanel.addViewDirection(vecZ);
	dpPanel.addViewDirection(-vecZ);
	dpPanel.showInDxa(true);// HSB-23001

// collect other instances added to any of the sips
	TslInst tslOthers[0];
// do not collect other tools if in edit mode
	if (!bEditInPlace)
		for (int i=0 ; i < _Sip.length() ; i++) 
		{ 
		    Sip sip = _Sip[i]; 
		    Entity eTools[]=sip.eToolsConnected();
		    for (int j=0 ; j<eTools.length();j++) 
		    {
		    	TslInst t=(TslInst)eTools[j];//
						    	
		    	if (t.bIsValid() && t!=_ThisInst &&
		    		t.propString(0) == _ThisInst.propString(0) && 
		    		(scriptName()==t.scriptName() || (_bOnDebug && scriptName()=="__HSB__PREVIEW" && t.scriptName()=="hsbCLT-JointBoard")) && 
		    		tslOthers.find(t)<0)
		    		tslOthers.append(t);
		    }
		}
		
//// since eToolsConnected does not return all tools of a complex test model one can add test tools in debug	
//	if (bDebug)
//	{
//		for (int i=0 ; i < _Entity.length() ; i++) 
//		{ 
//		   TslInst t=(TslInst)_Entity[i];//						    	
//	    	if (t.bIsValid() && t!=_ThisInst && "hsbCLT-Joint2"==t.scriptName() && tslOthers.find(t)<0)
//	    		tslOthers.append(t);  
//		}
//		
//		reportMessage("\n" + tslOthers.length() + " detected");
//	}
			

// START TOOL ____________________________________________________________________________________________________ START TOOL	



// derive tool profile from common contour
	PlaneProfile ppTool(cs);
	{
		PLine pl;
		LineSeg seg (_Pt0-vecPerp*U(10e4)-vecDir * .5*dWidth,_Pt0+vecPerp*U(10e4)+vecDir * .5*dWidth);
		pl.createRectangle(seg, vecPerp, vecDir);
		ppTool.joinRing(pl,_kAdd);
		ppTool.intersectWith(ppCommon);
	}
	//{Display dp(6); dp.draw(ppTool, _kDrawFilled, 30);}
	LineSeg segTool = ppTool.extentInDir(vecPerp); segTool.vis(2);
	LineSeg segChamfer = segTool;
	
//region Detect potential corner connection
	if (tslOthers.length()>0)
	{ 
		Point3d ptMidA = segTool.ptMid();
		double dXA = abs(vecPerp.dotProduct(segTool.ptStart()-segTool.ptEnd()));
		double dYA = abs(vecDir.dotProduct(segTool.ptStart()-segTool.ptEnd()));
		PLine plA;
		plA.createRectangle(segTool, vecPerp, vecDir);//plA.vis(171);

		for (int j = 0; j < tslOthers.length(); j++)
		{
			TslInst& tslB = tslOthers[j];
			if ((bDebug && j == 0) || _ThisInst.handle() < tslB.handle())continue;
			
			Body bdOther = tslB.realBody();
			double dWidthB = tslB.propDouble(sWidthName);
			Vector3d vecDirB = tslB.map().getVector3d("vecDir");

			PlaneProfile ppA1 = ppTool;
			PlaneProfile ppB = bdOther.shadowProfile(pnFace);
			
			// test intersection of a and b
			ppA1.shrink(-U(2));
			ppA1.intersectWith(ppB);
			if (ppA1.area() < pow(dEps, 2))continue;
			
			if (bDebug)	{Display dp(j + 4);dp.draw(ppB, _kDrawFilled);}
			
			// segment B
			Vector3d vecPerpB = vecDirB.crossProduct(vecZ);
			LineSeg segB = ppB.extentInDir(vecPerpB);
			Point3d ptMidB = segB.ptMid();
			double dXB = abs(vecPerpB.dotProduct(segB.ptStart() - segB.ptEnd()));
			double dYB = abs(vecDirB.dotProduct(segB.ptStart() - segB.ptEnd()));
			
			Vector3d vecSeg = .5 * (vecPerpB * dXB)+.5 * (vecDirB * dYB);
			PLine plB;
			plB.createRectangle(LineSeg(ptMidB -vecSeg, ptMidB+vecSeg), vecPerpB, vecDirB);	//plB.vis(3);
			
			Point3d pts1[] = plB.intersectPoints(Plane(segTool.ptStart(), vecDir));
			Point3d pts2[] = plB.intersectPoints(Plane(segTool.ptEnd(), vecDir));
			
			
			int bIsMaleT, bIsFemaleCorner;
			if (pts1.length() > 1 && pts2.length() > 1)
				bIsMaleT = true;
			else if (pts1.length() > 1 || pts2.length() > 1)
				bIsFemaleCorner=true;	
			
			if (bIsFemaleCorner)
			{ 
				vecSeg = .5 * (vecPerp * (dXA + 2 * dWidthB) + vecDir * (dYA));
				plA.createRectangle(LineSeg(segTool.ptMid()-vecSeg,segTool.ptMid()+vecSeg), vecPerp, vecDir);//	plA.vis(2);
				vecSeg = .5 * (vecPerpB * (dXB+2*dWidth) + vecDirB * dYB);
				plB.createRectangle(LineSeg(segB.ptMid() -vecSeg, segB.ptMid() + vecSeg), vecPerpB, vecDirB);//	plB.vis(3);

				PlaneProfile ppAdd;
				ppAdd.joinRing(plA, _kAdd);
				ppAdd.intersectWith(PlaneProfile(plB));
				ppTool.unionWith(ppAdd);
				segCommon = ppTool.extentInDir(vecPerp); segTool.vis(20);
				
				ppCommon = ppTool;
				ppCommon.shrink(-dGapWidth);
	
				if (bDebug)
				{
					Display dp(j);
					dp.draw(ppCommon, _kDrawFilled,85);
				}
				
			// add chamfer cleanup as solid subtract
				Point3d ptX;
				int bOk = Line(ptMidB, vecPerpB).hasIntersection(Plane(ptMidA, vecDir),ptX);
				if (bOk)
				{
					ptX += vecZ * vecZ.dotProduct(ptMidA - ptX);
					ptMidB += vecZ * vecZ.dotProduct(ptMidA - ptMidB);
					
					Vector3d vecXA = ptX - segTool.ptMid(); vecXA.normalize();
					Vector3d vecXB = ptX - ptMidB; vecXB.normalize();
					Vector3d vecXMitre = vecXA + vecXB;	vecXMitre.normalize();
					Vector3d vecZMitre = vecXMitre.crossProduct(-vecZ);
					if (vecZMitre.dotProduct(vecXA) < 0)vecZMitre *= -1;
					
					ptX += vecZ * vecZ.dotProduct(ptCen - ptX);
					int nDir=-1;
					double dChamfers[] = {nAlignment!=0?dChamferRef:0,nAlignment!=2?dChamferOpp:0};
					for (int i = 0; i < dChamfers.length(); i++)
					{
						Display dpDebug(i);
						double dChamfer = dChamfers[i];
						if (dChamfer <= 0){nDir *= -1;continue;}
						
						Point3d pt = ptX;
						pt.transformBy(vecZ * (vecZ.dotProduct(ptCen-pt)+nDir*.5*dZ));

						CoordSys csRot;
						
						csRot.setToRotation(-45,vecXA ,pt);						
						Body bdA(pt,vecXA, vecXA.crossProduct(vecZ), vecZ,dChamfer*2, dChamfer,dChamfer,1,0,0);
						bdA.transformBy(csRot);
						bdA.addTool(Cut(ptX, vecZMitre),0);
						//dpDebug.draw(bdA);
						SolidSubtract sosu(bdA, _kSubtract);
						sosu.addMeToGenBeamsIntersect(_Sip);
						
						csRot.setToRotation(-45,vecXB ,pt);	
						Body bdB(pt,vecXB, vecXB.crossProduct(vecZ), vecZ,dChamfer*2, dChamfer,dChamfer,1,0,0);
						bdB.transformBy(csRot);
						bdB.addTool(Cut(ptX, -vecZMitre),0);
						//dpDebug.draw(bdB);
						SolidSubtract sosuB(bdB, _kSubtract);
						sosuB.addMeToGenBeamsIntersect(_Sip);							
						nDir *= -1;
					}	
				}
				
				tslB.transformBy(Vector3d(0, 0, 0));
			}	
		}			
	}
//End Detect potential corner connection//endregion 

// add beamcuts and chamfers
	double dChamfers[] = {nAlignment!=0?dChamferRef:0,nAlignment!=2?dChamferOpp:0};
	double dGaps[] = {0,0};

	Vector3d vecXT = vecPerp;
	Vector3d vecYT = vecPerp.crossProduct(-vecDir);
	Vector3d vecZT = vecDir;	
	double dLength = abs(vecPerp.dotProduct(segCommon.ptStart()-segCommon.ptEnd()));
	//vecXT.vis(_Pt0,1);vecYT.vis(_Pt0,3);vecZT.vis(_Pt0,150);	 

	//double dBcGaps[] ={0,0 };// {dGapRef, dGapOpp};

	
// add tools per ring
	Body bdBeamcuts[0];
	int nNumAllowedGrips;
	plRings = ppCommon.allRings();
	bIsOp = ppCommon.ringIsOpening();
	for (int r=0; r<plRings.length();r++)
	{
		if (bIsOp[r])continue;
		PLine plRing = plRings[r];
		nNumAllowedGrips+=2;
		LineSeg seg = PlaneProfile(plRings[r]).extentInDir(vecPerp);
		seg.vis(3);
		Point3d pts[] = {seg.ptStart(), seg.ptEnd()};
		pts= lnPerp.orderPoints(pts);
		
	//create grips on this edge
		if (bEditInPlace && _PtG.length()<nNumAllowedGrips)
		{
			_PtG.append(pts[0]);
			_PtG.append(pts[pts.length()-1]);		
		}				
		else if (bEditInPlace && _PtG.length()>=nNumAllowedGrips)
		{
			pts[0]=_PtG[nNumAllowedGrips-2];
			pts[pts.length()-1]=_PtG[nNumAllowedGrips-1];		
		}

	// project to face
		plRing.projectPointsToPlane(pnFace, vecZ);

		double dXBc = abs(vecPerp.dotProduct(pts[0]-pts[pts.length()-1]));	
		double dYBc = dWidth+2*dGapWidth;		
		double dZBc = dDepth+dGapDepth;

	// beamless tool creation
		if (_Beam.length()<1)
		{
			Point3d ptBc = (pts[0]+pts[pts.length()-1])/2;
			ptBc.transformBy(vecZ*(vecZ.dotProduct(ptCen-ptBc)+(nAlignment-1)*.5*dZ));
			if (nAlignment!=1)dZBc*=2;
			vecXT.vis(_Pt0,3);
			vecYT.vis(_Pt0,4);
			_Pt0.vis(4);
			// HSB-10784: add extra tolerance to cut through the body
			BeamCut bc(ptBc,vecXT,vecZT,-vecYT,dXBc+2*dEps,dYBc,dZBc,0,0,0);
			Body bdBc = bc.cuttingBody(); 
			if (bdBc.isNull()){ continue;}
			bdBeamcuts.append(bdBc);
			if(bDebug)bdBc.vis(2);
			
		// BEAMCUT
			if(bAddStatic)
			{ 
				for (int i=0;i<sipsMales.length();i++) 
					if (bdBc.hasIntersection(sipsMales[i].envelopeBody()))
						sipsMales[i].addToolStatic(bc);
				for (int i=0;i<sipsFemales.length();i++) 
					if (bdBc.hasIntersection(sipsFemales[i].envelopeBody()))
						sipsFemales[i].addToolStatic(bc);					
			}
			else
			{
				bc.addMeToGenBeamsIntersect(sipsMales);
				bc.addMeToGenBeamsIntersect(sipsFemales);
			}
		}

	// add chamfers
		int nDir=-1;
		Vector3d vecDirChamf = vecDir;
		for (int i=0; i<dChamfers.length(); i++)
		{
			double dChamfer = dChamfers[i];
			double dGapOpp = dGaps[i];
			if (dChamfer<=dEps)
			{
				//ptTool.transformBy(-vecDirChamf*dOverlap);
				nDir*=-1;
				continue;
			}
			
			double dXChamfer = abs(vecXT.dotProduct(segChamfer.ptStart() - segChamfer.ptEnd()));
			
			Point3d pt=segChamfer.ptMid();//;pt.setToAverage(pts);
			pt.transformBy(vecZ * (vecZ.dotProduct(ptCen-pt)+nDir*.5*dZ));
			double dA = sqrt(pow((dChamfer+.5*dGapOpp),2)/2);
			pt.transformBy(vecZ*-nDir*dA);
			pt.transformBy(vecDirChamf*-nDir*.5* dGapOpp);
			//pt.vis(7);
			CoordSys csRot;
			csRot.setToRotation(-45,vecXT ,pt);
			
			BeamCut bc(pt ,vecXT ,vecDirChamf, vecZ, dXChamfer, dChamfer*2 , dChamfer*2 ,0,nDir,nDir);
			bc.transformBy(csRot);
			//bc.cuttingBody().vis(4);
			if (bAddStatic)
			{
				Body bdBc = bc.cuttingBody();
				for (int i=0;i<_Sip.length();i++) 
					if (bdBc.hasIntersection(_Sip[i].envelopeBody()))
						_Sip[i].addToolStatic(bc);					
			}
			else
				bc.addMeToGenBeamsIntersect(_Sip);	
			
			nDir*=-1;
		}//next i
		
	// add relief cut (not with center alignment)
		if (dGapRelief>0 && nAlignment==1)
		{ 
			dGapRelief.set(0);
			dGapRelief.setReadOnly(true);
		}
		else if (dGapRelief>0 && nAlignment!=1)
		{ 
			nDir = nAlignment == 0 ?- 1 : 1;
			Point3d ptA;ptA.setToAverage(pts);
			Point3d ptB=ptA;
			
			double dAOffset = sqrt(pow((dChamferOpp),2)/2);
			if (nDir==1)
				dAOffset = sqrt(pow((dChamferRef),2)/2);
			
			ptA.transformBy(vecZ * (vecZ.dotProduct(ptCen-ptA)-nDir*(.5*dZ-dAOffset)));
			ptB.transformBy(vecZ * (vecZ.dotProduct(ptCen-ptB)+nDir*.5*dZ));
			ptA.vis(4);	ptB.vis(4);				
			
			Vector3d vecA = ptB - ptA; vecA.normalize();
			ptB += nDir * vecDir*dGapRelief * .5;
			Vector3d vecB = ptB - ptA; vecB.normalize();
			CoordSys csA, csB;
			
			BeamCut bcA(ptB ,vecXT ,vecDir, vecZ, dXBc, dZ , dZ*3 ,0,-nDir,0);
			double dRot = vecA.angleTo(vecB);			
			csA.setToRotation(dRot,vecXT ,ptB);
			bcA.transformBy(csA);

			ptB -= nDir * vecDir*dGapRelief;
			BeamCut bcB(ptB ,vecXT ,vecDir, vecZ, dXBc, dZ , dZ*3 ,0,nDir,0);
			ptB.vis(3);
			csB.setToRotation(-dRot,vecXT ,ptB);
			bcB.transformBy(csB);

			bcA.cuttingBody().vis(4);
			bcB.cuttingBody().vis(6);
			
			Sip sipsA[0], sipsB[0];
			
			
			if (nDir == 1)
			{
				sipsA = sipsMales;
				sipsB = sipsFemales;
			}
			else
			{
				sipsB = sipsMales;
				sipsA = sipsFemales;
			}										
				
			if (bAddStatic)
			{ 
				Body bdBc = bcA.cuttingBody();
				for (int i=0;i<sipsA.length();i++) 
					if (bdBc.hasIntersection(sipsA[i].envelopeBody()))
						sipsA[i].addToolStatic(bcA);	
				bdBc = bcB.cuttingBody();
				for (int i=0;i<sipsB.length();i++) 
					if (bdBc.hasIntersection(sipsB[i].envelopeBody()))
						sipsB[i].addToolStatic(bcB);				
			}
			else
			{
				bcB.addMeToGenBeamsIntersect(sipsA);
				bcA.addMeToGenBeamsIntersect(sipsB);					
			}
		}
	}// next r	
	

	
		
// collect boards per ring or beam
	Body bdBoards[0];
	if (_Beam.length()<1)
	{
	// HSB-21901 Get tool profile based on beamcut bodies
		PlaneProfile ppx(cs);
		Plane pnx(ptCen, vecZ);
		for (int i=0;i<bdBeamcuts.length();i++) 
			ppx.unionWith(bdBeamcuts[i].shadowProfile(pnx)); 
		ppx.intersectWith(ppTool);
		//{Display dp(6); dp.draw(ppx, _kDrawFilled, 30);}
		
		plRings = ppx.allRings();
		bIsOp = ppx.ringIsOpening();
		for (int r=0; r<plRings.length();r++)
		{
			if (bIsOp[r])continue;
			PLine plRing = plRings[r];
		// project to face
			plRing.projectPointsToPlane(pnFace, vecZ);
			Body bdBoard = Body(plRing, vecZ*dDepth, -(nAlignment-1));
			bdBoard.transformBy(-(nAlignment-1)*vecZ*dGapDepth);
			//bdBoard.vis(4);
			bdBoards.append(bdBoard);
		}			
	}
	else
	{
		for (int b=0;b<_Beam.length();b++) 
			bdBoards.append(_Beam[b].envelopeBody(false,true)); 
	}

// test intersection against other jointboards
	for (int i=0; i<bdBoards.length();i++)
	{
		Body& bdBoard=bdBoards[i];
		PlaneProfile ppA= bdBoard.shadowProfile(pnFace);
		LineSeg segA=ppA.extentInDir(vecPerp);
		double dXA = abs(vecPerp.dotProduct(segA.ptStart()-segA.ptEnd()));
		double dYA = abs(vecDir.dotProduct(segA.ptStart()-segA.ptEnd()));
		PLine plA;
		plA.createRectangle(LineSeg(segA.ptMid()-.5*(vecPerp*(dXA)+vecDir*(dYA)),segA.ptMid()+.5*(vecPerp*(dXA)+vecDir*(dYA))), vecPerp, vecDir);
		plA.vis(171);	
		
		for (int j = 0; j < tslOthers.length(); j++)
		{
			if (bDebug && j == 0)continue;
			TslInst tslB = tslOthers[j];
			Body bdOther = tslB.realBody();
			double dWidthB = tslB.propDouble(sWidthName);
			Vector3d vecDirB = tslB.map().getVector3d("vecDir");
			
			
			PlaneProfile ppA1 = ppA;
			PlaneProfile ppB = bdOther.shadowProfile(pnFace);
			
			// test intersection of a and b
			ppA1.shrink(-U(2));
			ppA1.intersectWith(ppB);
			if (ppA1.area() < pow(dEps, 2))continue;
			
			if (bDebug)
			{
				Display dp(j + 4);
				dp.draw(ppB, _kDrawFilled);//,85);
			}
			
			// segment B
			Vector3d vecPerpB = vecDirB.crossProduct(vecZ);
			LineSeg segB = ppB.extentInDir(vecPerpB);
			double dXB = abs(vecPerpB.dotProduct(segB.ptStart() - segB.ptEnd()));
			double dYB = abs(vecDirB.dotProduct(segB.ptStart() - segB.ptEnd()));
			
			PLine plB;
			plB.createRectangle(LineSeg(segB.ptMid() - .5 * (vecPerpB * (dXB) + vecDirB * (dYB)), segB.ptMid() + .5 * (vecPerpB * (dXB) + vecDirB * (dYB))), vecPerpB, vecDirB);
			//plB.vis(3);
			
			Point3d pts1[] = plB.intersectPoints(Plane(segA.ptStart(), vecDir));
			Point3d pts2[] = plB.intersectPoints(Plane(segA.ptEnd(), vecDir));

			int bIsMaleT, bIsFemaleCorner;
			if (pts1.length() > 1 && pts2.length() > 1)
				bIsMaleT = true;
			else if (pts1.length() > 1 || pts2.length() > 1)
			{ 
				if (_ThisInst.handle() < tslB.handle())
					bIsFemaleCorner=true;	
//					else
//						bIsMaleT = true;
			}
				
			if (bIsMaleT)
			{ 
//					LineSeg segTest= ppTest.extentInDir(vecDirB);	
				LineSeg seg= ppB.extentInDir(vecDirB);seg.vis(2);
				
				Vector3d vecXC = vecPerp;
				if (vecXC.dotProduct(seg.ptMid()-segTool.ptMid())<0)
					vecXC*=-1;
				Vector3d vecCut = vecDirB;
				if (vecCut.dotProduct(vecXC)<0)
					vecCut*=-1;
				vecCut.vis(seg.ptMid(),4);
				Point3d pts[]={ segB.ptStart(),segB.ptEnd()};
				pts=Line(_Pt0,vecCut).orderPoints(pts);
				if (pts.length()>0)
					bdBoard.addTool(Cut(pts[0], vecCut),1);	
			}
//				else if (bIsFemaleCorner)
//				{ 
//					plA.createRectangle(LineSeg(segA.ptMid()-.5*(vecPerp*(dXA+dWidthB)+vecDir*(dYA)),segA.ptMid()+.5*(vecPerp*(dXA+dWidthB)+vecDir*(dYA))), vecPerp, vecDir);
//					plB.createRectangle(LineSeg(segB.ptMid() - .5 * (vecPerpB * (dXB+2*dWidth) + vecDirB * (dYB)), segB.ptMid() + .5 * (vecPerpB * (dXB+2*dWidth) + vecDirB * (dYB))), vecPerpB, vecDirB);
//					
//					
//					PlaneProfile ppAdd;
//					ppAdd.joinRing(plA, _kAdd);
//					ppAdd.intersectWith(PlaneProfile(plB));
//					PLine plRings[] = ppAdd.allRings(true, false);
//					if (plRings.length()>0)
//					{ 
//						PLine pl = plRings[0];
//						pl.projectPointsToPlane(Plane(bdBoard.ptCen(),vecZ), vecZ);
//						bdBoard.addPart(Body(pl, vecZ*dDepth, 0));
//					}
//				}
		}

		
	// get planview 	
		{
			Point3d pt = bdBoard.ptCen();
			pt.transformBy(vecZ*vecZ.dotProduct(ptCen-pt));
			PlaneProfile pp = bdBoard.getSlice(Plane(pt, vecXT));
			pp.vis(3);
			CoordSys cs2Panel;
			cs2Panel.setToAlignCoordSys(pt, vecDir, vecZ, vecDir.crossProduct(-vecZ),pt,  vecDir, vecPerp,vecZ);
			pp.transformBy(cs2Panel);
			dpPanel.draw(pp);
			dpPanel.draw(pp.extentInDir(vecDir));
			dpPanel.draw(pp.extentInDir(-vecXT));
			
			
			PLine pl(vecXT);
			pl.addVertex(pt-vecDir*.5*(dWidth+dGapWidth)-vecZ*.5*dZ);
			pl.addVertex(pt-vecDir*.5*(dWidth+dGapWidth)+vecZ*.5*dZ);
			pl.addVertex(pt+vecDir*.5*(dWidth+dGapWidth)+vecZ*.5*dZ);
			pl.addVertex(pt+vecDir*.5*(dWidth+dGapWidth)-vecZ*.5*dZ);
			pl.transformBy(cs2Panel);
			dpPanel.color(_Sip[0].color());
			dpPanel.draw(pl);
			
			pl = PLine(pt-vecDir*.5*(dWidth+dGapWidth)-vecZ*.5*dZ,pt+vecDir*.5*(dWidth+dGapWidth)-vecZ*.5*dZ);
			pl.transformBy(cs2Panel);
			dpPanel.color(5);
			dpPanel.draw(pl);
			dpPanel.color(_ThisInst.color());
			//dpModel.draw(pp,_kDrawFilled);
		}
		
		if (_Beam.length()<1)
		{ 		
			dpPanel.draw(bdBoard);					
		}
		dpModel.draw(bdBoard);	
	
	}


// beam based tool definition
	for (int b=0;b<_Beam.length();b++) 
	{ 
		Beam bm= _Beam[b]; 
		setDependencyOnBeamLength(bm);

		double dXBc = bm.solidLength();//version value="2.3" date="22may2019" author="thorsten.huck@hsbcad.com"> HSB-5076: beamcut alignment fixed
		double dYBc = bm.solidWidth();
		double dZBc = bm.solidHeight();

		Point3d pt =bm.ptCenSolid(); 
		if (nAlignment!=1)
		{
			pt.transformBy(vecZ*(nAlignment-1)*.5*dZBc);
			dZBc*=2;
		}
		BeamCut bc(pt,bm.vecX(), bm.vecY(), bm.vecZ(), dXBc,dYBc+2*dGapWidth,dZBc,0,0,0);
		
		bc.cuttingBody().vis(6);
	// BEAMCUT
		if (bAddStatic)
		{
			Body bdBc = bc.cuttingBody();
			for (int i = 0; i < sipsMales.length(); i++)
				if (bdBc.hasIntersection(sipsMales[i].envelopeBody()))
					sipsMales[i].addToolStatic(bc);
			for (int i = 0; i < sipsFemales.length(); i++)
				if (bdBc.hasIntersection(sipsFemales[i].envelopeBody()))
					sipsFemales[i].addToolStatic(bc);
		}
		else
		{
			bc.addMeToGenBeamsIntersect(sipsMales);
			bc.addMeToGenBeamsIntersect(sipsFemales);				
		}
			
	}



// END TOOL ____________________________________________________________________________________________________END TOOL


// collect catalog entries of beam creator
	String sScriptNameDebug = scriptName()=="__HSB__PREVIEW"?"hsbCLT-JointBoard": scriptName();
	String sAllEntries[] = TslInst().getListOfCatalogNames(sScriptNameDebug+"-"+T("|Creation|"));// scriptName()


//region TriggerCreateBeamBoard
	int nBeamCreation=-1;
	if (_Map.hasInt("BeamCreation"))
	{
		if(bDebug)reportMessage("\n" + scriptName() + ": "+ _ThisInst.handle() + " has a Beam creation flag");	
		nBeamCreation=_Map.getInt("BeamCreation");
		_Map.removeAt("BeamCreation", true);
	}
	TslInst tslOtherCreations[0];
	String sTriggerCreateBeams[]={ T("|Create beams|")};
	for (int i=0 ; i < sAllEntries.length() ; i++)
		sTriggerCreateBeams.append(sTriggerCreateBeams[0] + " (" +sAllEntries[i]+")");
	
	if (_Beam.length()<1)
	for (int t=0 ; t< sTriggerCreateBeams.length() ; t++)
	{ 
		String sTriggerCreateBeam=sTriggerCreateBeams[t];
		addRecalcTrigger(_kContextRoot, sTriggerCreateBeam );	
		if (_bOnRecalc && _kExecuteKey==sTriggerCreateBeam)	
		{
		// if this trigger is called from palette and multiple are selected we don't want the dialog to pop up multiple times
			if (_Map.getInt("RemoteCreation"))
			{ 
				_Map.removeAt("RemoteCreation", true);
				setExecutionLoops(2);
				return;
			}
			else
			{ 
				nBeamCreation=t;
			// collect other instances	
				Entity tents[0];
				PrEntity ssE(T("|Select additional joint board(s) (optional)|"), TslInst());
				if (ssE.go())
					tents= ssE.set();
				for (int i=0; i<tents.length();i++)	
				{
					TslInst tsl = (TslInst)tents[i];
					if (_ThisInst!=tsl && tsl.scriptName()==scriptName())
						tslOtherCreations.append(tsl);	
				}					
				
				
				break; // breaking t					
			}
		}	
	}
	
	
	
	
	
	
// create joint board beams
	if (nBeamCreation>-1 || (bCreateAsBeam && _bOnDbCreated))
	{ 
		if(bDebug)reportMessage("\n" + _ThisInst.handle() + " removes " + _Beam.length() + " beams");	
	// remove any existing joint board
		for (int i=_Beam.length()-1; i>=0 ; i--) 
		{ 
			_Beam[i].dbErase(); 
		}

	// resolve group name if possible
		Group grBeam;
		int bAssignGroup;
		if(bCreateAsBeam && sGroupName.length()>0)
		{ 
			String sTest = sGroupName;
			String sHouseGroup = sTest.token(0,"\\");
			String sFloorGroup= sTest.token(1,"\\");
			String sItemGroup = sTest.token(2,"\\");
		
		// shift
			for (int i=0;i<2;i++) 
			{ 
				if (sItemGroup.length()<1)
				{
					sItemGroup=sFloorGroup;
					sFloorGroup=sHouseGroup;
					sHouseGroup="";
				} 
			}
			
		// get floor group by instance
			if (sHouseGroup=="" || sFloorGroup=="") 
			{
				Group groups[] = _ThisInst.groups();
				String sNamePart0, sNamePart1, sNamePart2;
			// 	
				for (int i=0;i<groups.length();i++) 
				{ 
					Group group= groups[i]; 
					if (group.namePart(1)!="")
					{
						sNamePart0	=group.namePart(0);
						sNamePart1	=group.namePart(1);
						break;
					}
				}
				// fall back, get house group
				if (sNamePart0=="")
					for (int i=0;i<groups.length();i++) 
					{ 
						Group group= groups[i]; 
						if (group.namePart(0)!="")
						{
							sNamePart0	=group.namePart(0);
							break;
						}
					}	
				if (sHouseGroup=="")sHouseGroup=sNamePart0;
				if (sFloorGroup=="")sFloorGroup=sNamePart1;	
			}	

			if (sHouseGroup!="" && sFloorGroup!="" && sItemGroup!="")
			{
				Group gr(sHouseGroup+"\\" + sFloorGroup+ "\\"+sItemGroup);
				if (!gr.bExists())
					gr.dbCreate();	
				grBeam = gr;
				bAssignGroup=true;
			}

		}




	// prepare tsl cloning
		TslInst tslNew;
		GenBeam gbsTsl[0];	Entity ents[0];
		Point3d pts[0];

		int nProps[]={};
		double dProps[]={};
		String sProps[]={};
		Map mapTsl;
		String sScriptname = scriptName();	
		
		for (int i=0 ; i < bdBoards.length() ; i++)
		{
			Beam bm;
			Vector3d vecXBm = vecPerp;
			Vector3d vecYBm = vecDir;
			Vector3d vecZBm = vecXBm.crossProduct(vecYBm);
			bm.dbCreate(bdBoards[i], vecXBm, vecYBm, vecZBm);
			if (bm.bIsValid())
			{
				if(grBeam.bExists() && bAssignGroup)
					grBeam.addEntity(bm, true,0, 'Z');

				bm.setGrade(sGrade);
				bm.setMaterial(sMaterial);
				bm.setColor(nc);
				_Beam.append(bm);
			}
			gbsTsl.append(bm);
		}
		
	// beam creation by trigger
		if(nBeamCreation>-1)
		{ 
		// create a dialog instance	
			mapTsl.setInt("mode",2);
			mapTsl.setInt("dialog",true);
			
			tslNew.dbCreate(scriptName(), _XW,_YW ,gbsTsl, ents, pts, 
				nProps, dProps, sProps,_kModelSpace, mapTsl);		
			
			if (tslNew.bIsValid())
			{
				String sEntry = tLastInserted;
				tslNew.assignToGroups(sipRef,'Z');
				if (_Map.getInt("RemoteCreation"))
					tslNew.setPropValuesFromCatalog(sEntry);
				else if (nBeamCreation==0)
				{
					tslNew.showDialog();
					tslNew.setCatalogFromPropValues(tLastInserted);
				}
				else
				{
					sEntry = sAllEntries[nBeamCreation-1];
					tslNew.setPropValuesFromCatalog(sEntry);
					tslNew.setCatalogFromPropValues(tLastInserted);
				}

				Map map = tslNew.map();
				map.setInt("dialog",false);
				tslNew.setMap(map);
				
			}	
			
		// trigger other tsls
			for (int i=0;i<tslOtherCreations.length();i++) 
			{
				if(bDebug)reportMessage("\n" + scriptName() + ": " +"calling beam creation in mode " + nBeamCreation);
				
				Map map = tslOtherCreations[i].map();
				map.setInt("BeamCreation", nBeamCreation);
				map.setInt("RemoteCreation", true);
				tslOtherCreations[i].setMap(map);
			}
			
			
			setExecutionLoops(2);
			return;				
		}
	}


// set control point for joint board beam	
	for (int i=0;i<_Beam.length();i++) 
	{ 
		Point3d ptCtrl = _Pt0;
		if (nAlignment!=1)
			ptCtrl.transformBy(vecZ*(nAlignment-1)*(.5*dZ-.5*_Beam[i].dD(vecZ)-dGapDepth));
		_Beam[i].setPtCtrl(ptCtrl,vecDir.crossProduct(-vecZ));
		 
	}			

	if (_Beam.length() > 0)_PtG.setLength(0);
//endregion End TriggerCreateBeamBoard


// Trigger MergeErase//region
	String sTriggerJoinErase = T("|Join + Erase|");
	addRecalcTrigger(_kContextRoot, sTriggerJoinErase );
	if (_bOnRecalc && _kExecuteKey==sTriggerJoinErase)
	{
		for (int i=_Sip.length()-1; i>0 ; i--) 
			_Sip[0].dbJoin(_Sip[i]); 
		eraseInstance();			
		setExecutionLoops(2);
		return;
	}//endregion	


// set hardware
	HardWrComp hwComps[0];
	double dYBoard = dWidth;
	double dZBoard = dDepth;
	if (_Beam.length()<1)
		for (int i=0 ; i < bdBoards.length() ; i++) 
		{ 
		    Body bd = bdBoards[i]; 
		    double dX = bd.lengthInDirection(vecXT);
			
			String sArticle=T("|Joint Board|");
			HardWrComp hw(sArticle, 1);	
			hw.setCategory(T("|Board|"));
			hw.setManufacturer("");
			hw.setModel(sArticle + dDepth + " x " + dWidth);
			hw.setMaterial(sMaterial);
			hw.setDescription(sGrade);
			hw.setDScaleX(dX);
			hw.setDScaleY(dWidth);
			hw.setDScaleZ(dDepth);	
			hwComps.append(hw);		    
		}
	else
	{
		sMaterial.setReadOnly(true);
		sGrade.setReadOnly(true);
	}
	_ThisInst.setHardWrComps(hwComps);

	
// store previous location
	_Map.setVector3d("vecRef", _Pt0-_PtW);
	_Map.setDouble("previousZDepth", dOverlap);
	//if(bDebug)reportMessage("\n" + _ThisInst.handle() + " ended " + _kExecutionLoopCount);
	//vecDir.vis(_Pt0,30);		
	
	
	
	if (bAddStatic)
	{ 
		eraseInstance();
		return;
	}
	
}
		
//Panel mode___________ //endregion 
	
//region Wall mode
	else if (nMode==0)
	{
		setExecutionLoops(2);
		//reportMessage("\n" + _ThisInst.handle() + " " + scriptName() + " starting mode " + sOpmName + " onDbCreated: " + _bOnDbCreated + " map: "+ _Map);

	// validate selection set
		if (_Element.length()<1 || !_Element[0].bIsKindOf(ElementWall()))		
		{
			reportMessage("\n" + scriptName() + " " + T("|could not find reference to element.|"));
			eraseInstance();
			return;				
		}		

	/// standards
		Element el = _Element[0];
		CoordSys cs =el.coordSys();
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		Vector3d vecZ = cs.vecZ();
		Point3d ptOrg = cs.ptOrg();
		PLine plOutlineWall = el.plOutlineWall();
		Point3d ptsOutline[] = plOutlineWall.vertexPoints(true);
		Point3d ptMid;
		ptMid.setToAverage(ptsOutline);
		assignToElementGroup(el, true,0,'C');
		double dZ = el.dBeamWidth();
		if (dZ<=0)
		{
			ptsOutline=Line(ptOrg, vecZ).orderPoints(ptsOutline);
			if (ptsOutline.length()>0)
				dZ = abs(vecZ.dotProduct(ptsOutline[0]-ptsOutline[ptsOutline.length()-1]));	
		}

		
	// on creation
		if (_bOnDbCreated)
		{
			_Pt0.transformBy(vecZ*vecZ.dotProduct(ptOrg-_Pt0));
			
			
		// set catalog properties if specified
			if (_kExecuteKey.length()>0)
			{
				
				String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
				if (sEntries.find(_kExecuteKey)<0)
				{
					reportNotice("\n***************** " + scriptName() + " *****************");
					reportNotice("\n" + T("|Could not find|") + " " + _kExecuteKey	+ " " + T("|in the list of catalog entries.|"));
					reportNotice("\n" + T("|Available entries:|"));
					for (int i=0;i<sEntries.length();i++)
						reportNotice("\n	" + sEntries[i]);
					reportNotice("\n" + T("|The instance is now created with its default values.|"));
					reportNotice("\n**************************************************************");	
					
				}
				setPropValuesFromCatalog(_kExecuteKey);	
			}
		}

	// get side
		int nSide = 1;
		if (vecZ.dotProduct(_Pt0-ptMid)<dEps)nSide*=-1;	
					
	// trigger double click
		String sFlipTrigger = T("|Flip Side|");
		addRecalcTrigger(_kContextRoot, sFlipTrigger);
		if (_bOnRecalc && (_kExecuteKey==sFlipTrigger || _kExecuteKey==sDoubleClick)) 
		{
			nSide*=-1;
			_Pt0.transformBy(nSide*vecZ*U(10e2));
			return;					
		}

	// TriggerFlipSide
		int bFlipDir = _Map.getInt("flipDirection");
		String sTriggerFlipDirection = T("|Flip Direction|");
		addRecalcTrigger(_kContextRoot, sTriggerFlipDirection );
		if (_bOnRecalc && _kExecuteKey==sTriggerFlipDirection)
		{
			if (bFlipDir)bFlipDir=false;
			else bFlipDir=true;
			_Map.setInt("flipDirection",bFlipDir);	
		}	
		Vector3d vecZFace = vecZ;
		if (bFlipDir)vecZFace *=-1;

	//// add update settings trigger
		//addRecalcTrigger(_kContext, sLoadSettingsTrigger);
			
		_Pt0 = el.plOutlineWall().closestPointTo(_Pt0);		
		_Pt0.vis(1);	
	
	// if construction is not present display, stay invisible
		GenBeam genBeams[] = el.genBeam();	
		Sip sipsAll[0];
		for (int i=genBeams.length()-1;i>=0;i--)
			if (!genBeams[i].bIsKindOf(Sip()))
				genBeams.removeAt(i);
			else
				sipsAll.append((Sip)genBeams[i]);
				
		int bShow = genBeams.length()<1;

	// if the instance is inerted by tsl split locations it somehow needs a transformation to work //version 1.8	
		if (bShow && _kExecutionLoopCount==1)
		{
			_ThisInst.transformBy(Vector3d(0,0,0));
			if (bLog)reportMessage("\n" + _ThisInst.handle() + " has been transformed by null vector"); 
		}


	// declare display and draw
		Display dpPlan(_ThisInst.color());
		dpPlan.showInDxa(true);// HSB-23001
		if (bShow)
		{
		//// build plan symbol
			//Point3d ptSym = _Pt0+vecZFace *(vecZFace .dotProduct(ptOrg-_Pt0)-dZ);
			//Vector3d vecDir = vecX;
			//double dDepthOppThis;
			//if (dWidthOpp>dEps) dDepthOppThis = dDepthOpp;
			//Point3d ptsSym[] = {ptSym};
			//ptsSym.append(ptsSym[ptsSym.length()-1]+vecDir*dGapRef);
			//ptsSym.append(ptsSym[ptsSym.length()-1]+vecZFace *(dDepth+dGapCen));
			//ptsSym.append(ptsSym[ptsSym.length()-1]-vecDir*(dWidth+dGapRef));
			//ptsSym.append(ptsSym[ptsSym.length()-1]+vecZFace *(dZ-dDepth-dDepthOppThis-dGapCen));		
			//ptsSym.append(ptsSym[ptsSym.length()-1]-vecDir*(dGapOpp));
			//ptsSym.append(ptsSym[ptsSym.length()-1]-vecZFace *(dZ-dDepth-dDepthOppThis));
			//ptsSym.append(ptsSym[ptsSym.length()-1]+vecDir*(dWidth+dGapOpp));	
			//ptsSym.append(ptSym);
			
			//PLine plSym(vecY);	
			//for (int i=0;i<ptsSym.length();i++)
				//plSym.addVertex(ptsSym[i]);
			////plSym.vis(6);
			//dpPlan.draw(plSym);	
			//dpPlan.draw(PLine(_Pt0, _Pt0-nSide*vecZ*el.dBeamWidth()));	
			dpPlan.draw(scriptName(),_Pt0, _XW,_YW,1,1,_kDeviceX);
		}
		
		if ((_bOnDbCreated ||_bOnElementConstructed || _bOnDebug) && sipsAll.length()>0)
		{
			setExecutionLoops(2);
		// prepare tsl cloning
			TslInst tslNew;
			Vector3d vecXTsl= vecX;
			Vector3d vecYTsl= -vecZ;
			GenBeam gbsTsl[0];
			Entity ents[0];
			Point3d pts[1];

			int nProps[]={};
			double dProps[]={dWidth,dGapWidth,dDepth,dGapDepth,dChamferRef,dChamferOpp,dGapRelief};
			String sProps[]={sAlignment,sMaterial,sGrade};
			Map mapTsl;
			String sScriptname = scriptName();	
			
			Plane pnSplit (_Pt0, vecX);
			for (int i=0;i<sipsAll.length();i++)
			{
			// find intersection points
				Sip sip = sipsAll[i];
				
				Point3d ptsInt[] = sip.plEnvelope().intersectPoints(pnSplit);
				if (ptsInt.length()>0)
				{
				// split the panel and add it to the list of panels
					Sip sipSplit[0];
					sipSplit= sip.dbSplit(pnSplit,0);	
					gbsTsl.setLength(0);
					gbsTsl.append(sip);
					for (int s=0;s<sipSplit.length();s++)	
						gbsTsl.append(sipSplit[s]);						
					pts[0] = _Pt0+vecY*U(100);
					mapTsl.setInt("mode",1);
					mapTsl.setVector3d("vecDir", vecX);	
					tslNew.dbCreate(scriptName(), vecXTsl,vecYTsl ,gbsTsl, ents, pts, 
						nProps, dProps, sProps,_kModelSpace, mapTsl);
						
					//if (tslNew.bIsValid())
						//tslNew.recalcNow();
					break;	
				}
			}// next i	
		}// END IF ((_bOnDbCre...
	}// END else if (nMode==0)		
			
//endregion 	

//region Dialog Trigger
{ 
	// create TSL
	TslInst tslDialog;			Map mapTsl;						
	GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };

//region Trigger GroupAssignment
	String sTriggerGroupAssignment = T("|Settings Group Assignment|");
	addRecalcTrigger(_kContext, sTriggerGroupAssignment );
	if (_bOnRecalc && _kExecuteKey==sTriggerGroupAssignment)
	{
		Map mapIn;
		mapIn.setString("Prompt", 
			TN("|The name will determine the group to which the joint board shall be assigned.| ")+
			TN("|In the event that the tree structure is specified, the joint board will be allocated to the corresponding branch.|")+
			TN("|Otherwise, it will be created within the same branch as the male panel's assignment| ")+
			TN("|Separate levels by '\\', i.e.\n   House\\Floor\\Jointboard\n   Floor\\Jointboard\n   Jointboard|")+
			TN("|Export the settings if you want to make them available for other users or drawings.|")+
			TN("\n|Specify a Group Name to group joint boards into a group.|"));
		mapIn.setString("Title", T("|Group Assignment|"));
		mapIn.setString("Alignment", "Left");//__"Left", "Center", "Right" supported. 

  		mapIn.setString("PrefillText", sGroupName);//__optional, default is empty string
		mapIn.setInt("PrefillIsSelected", true);//__optional, default is false
	
		Map mapOut = callDotNetFunction2(sDialogLibrary, sClass, "GetText", mapIn);
		
		if (mapOut.length()>0)
		{ 
			sGroupName = mapOut.getString("Text").trimLeft().trimRight();
			Map m; m = mapSetting.getMap("Conversion");
			if (sGroupName.length()<1)
				m.removeAt("GroupName", true);
			else
				m.setString("GroupName",sGroupName);
			mapSetting.setMap("Conversion", m);		
	
		// Get/Reset legacy version
			int version = mapSetting.getInt("General\\Version");
			if (version>0)	mapSetting.removeAt("General\\Version", true);
		// Get /Set Version
			if (mapSetting.hasInt("GeneralMapObject\\Version"))
				version = mapSetting.getInt("GeneralMapObject\\Version");
			else if (version < 1)
				version = 2;
			mapSetting.setInt("GeneralMapObject\\Version",version);
	
			if (mo.bIsValid())mo.setMap(mapSetting);
			else mo.dbCreate(mapSetting);			
		}

		setExecutionLoops(2);
		return;
	}//endregion	

// Trigger GripModeCreation
	int bGripModeCreation = mapSetting.getInt("General\GripModeCreation");
	String sTriggerGripModeCreation =bGripModeCreation?T("|Grip Mode Creation off|"):T("|Grip Mode Creation on|");
	addRecalcTrigger(_kContext, sTriggerGripModeCreation);
	if (_bOnRecalc && _kExecuteKey==sTriggerGripModeCreation)
	{
		bGripModeCreation = bGripModeCreation ? false : true;
		mapSetting.setInt("General\GripModeCreation",bGripModeCreation);

		if (mo.bIsValid())mo.setMap(mapSetting);
		else mo.dbCreate(mapSetting);			
		
		if (bGripModeCreation)
			reportMessage("\n"+scriptName()+" "+T("|Stretch grips will be created on future inserts.|"));
			
		else
			reportMessage("\n"+scriptName()+" "+T("|Stretch grips will not be created on future inserts.|"));
			
		reportMessage("\n"+scriptName()+" "+T("|Export the settings if you want to make them available for other users or drawings!|"));
		
		setExecutionLoops(2);
		return;
	}


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
				reportMessage("\n"+scriptName()+" "+T("|Settings successfully imported from| ") + sFullPath);
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
				if (findFile(sFullPath).length()>0) reportMessage("\n"+scriptName()+" "+T("|Settings successfully exported to| ") + sFullPath);
				else reportMessage("\n"+scriptName()+" "+T("|Failed to write to| ") + sFullPath);
			}
			
			setExecutionLoops(2);
			return;
		}
	}
	//endregion 
}


//// Trigger CreateSettings//region
//	if (sFile.length()<1 && mapSetting.length()<1)
//	{ 
//		String sTriggerCreateSettings = T("|Create default settings|");
//		addRecalcTrigger(_kContext, sTriggerCreateSettings );
//		if (_bOnRecalc && _kExecuteKey==sTriggerCreateSettings)
//		{
//			reportMessage("\n" + scriptName() + ": " +T("|writing default settings|"));
//			
//			Map mapGeneral;
//			mapGeneral.setInt("Version", 1);
//			if (_DimStyles.length()>0)
//				mapGeneral.setString("DimStyle", _DimStyles[0]);
//			mapGeneral.setDouble("TextHeight", U(80));
//			mapGeneral.setInt("Color", _ThisInst.color());
//			mapSetting.setMap("General", mapGeneral);
//			
//			Map mapSQ, mapSQs;
//			SurfaceQualityStyle sqs[] = SurfaceQualityStyle().getAllEntries();
//			for (int i=0;i<sqs.length();i++) 
//			{ 
//				SurfaceQualityStyle& sq = sqs[i];
//				mapSQ.setString("Name", sq.entryName());
//				mapSQ.setInt("Color", sq.quality()); // initially we use the quality as color definition
//				mapSQs.appendMap("SurfaceQualityStyle", mapSQ);
//				reportMessage("\n"+sq.entryName()+ ":	" + sq.quality());
//				
//			}//next i
//			mapSetting.setMap("SurfaceQualityStyle[]", mapSQs);
//			
//		// the general mapObject	
//			{
//				Map m;
//				m.setString("Identifier", "hsbCLT-JointBoard");
//				mapSetting.setMap("GeneralMapObject", m);
//			}
//		
//		// the convert to beam	
//			{
//				Map m;
//				m.setString("GroupName", T("|JointBoard|"));
//				m.setInt("ConvertToBeam", 0);
//				mapSetting.setMap("Conversion", m);
//			}			
//
//			
//			mapSetting.writeToXmlFile(sFullPath);
//			mo.dbCreate(mapSetting);
//			reportMessage("\n" + T("|Default settings have been written to|\n")+sFullPath+"\n");
//			setExecutionLoops(2);
//			return;
//		}		
//	}
////end create settings //endregion	
	
	



//End Dialog Trigger//endregion 








#End
#BeginThumbnail
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
"_]F+
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
        <int nm="BreakPoint" vl="179" />
        <int nm="BreakPoint" vl="2218" />
        <int nm="BreakPoint" vl="1542" />
        <int nm="BreakPoint" vl="1544" />
        <int nm="BreakPoint" vl="1678" />
        <int nm="BreakPoint" vl="1362" />
        <int nm="BreakPoint" vl="1366" />
        <int nm="BreakPoint" vl="1423" />
        <int nm="BreakPoint" vl="1507" />
        <int nm="BreakPoint" vl="1639" />
        <int nm="BreakPoint" vl="1669" />
        <int nm="BreakPoint" vl="1348" />
        <int nm="BreakPoint" vl="1757" />
        <int nm="BreakPoint" vl="1457" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24228: add property gap panel" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="6/25/2025 6:25:19 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23001: save graphics in file for render in hsbView and make" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="12/5/2024 9:32:49 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23017: Fix connection for angled edge panels" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="11/20/2024 3:10:44 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22701 performance enhanced" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="9/19/2024 2:23:50 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21901 custom commands moved to root context menu, new commands import/export settings, new grouping option, new default grip option" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="4/17/2024 11:05:50 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-10784: add extra tolerance to cut through the body" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="3/30/2021 3:29:34 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-10732 bugfix writing default XML" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="2/19/2021 11:54:50 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End