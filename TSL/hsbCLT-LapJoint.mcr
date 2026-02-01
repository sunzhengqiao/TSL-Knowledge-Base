#Version 8
#BeginDescription
#Versions:
4.13 05.12.2024 HSB-23002: save graphics in file for render in hsbView and make Author: Marsel Nakuci
Version 4.12 21.10.2024 HSB-22813: Fix when applying drills at corners , Author Marsel Nakuci
4.11 19/08/2024 HSB-22548: make sure the other side of mortise doesnt cut rounds at panel; increase width of mortise 
4.10 13.05.2022 HSB-15474: Add flag "MortiseCornerCleanupAsDrill" to control corner rounding by mortise or drill 
4.9 14.09.2021 HSB-11596: fix bug when joining multiple panels with openings Author: Marsel Nakuci
version  value="4.8" date="26mar2020" author="thorsten.huck@hsbcad.com"
HSB-7000 add static tool to male instead of female
HSB-7034 export enabled
HSB-6068 typo fixed
HSB-6068 new property 'Radius': one can now specify the lapjoint to be milled rounded. If the radius is negative it will create an overshoot tool (not supported for BTL output)

/// This tsl defines a lap joint on one edge between at least two panels. On insert it may create a split if only one panel was selected.
/// The closest point to the main contour in relation to the reference point (_Pt0) defines the edge where the lap joint is 
/// assigned to.






#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 4
#MinorVersion 13
#KeyWords CLT;Lap;Lapjoint;joint;rabbet;Falz
#BeginContents
//region History
/// <summary Lang=en>
/// This tsl defines a lap joint on one common edge between at least two panels. On insert it may create a split if only one panel was selected.
/// The closest point to the main contour in relation to the reference point (_Pt0) defines the edge where the lap joint is
/// assigned to.
/// This tsl can also be used in conjunction with the command HSB_PANELTSLSPLITLOCATION
/// </summary>


/// <insert Lang=en>
/// Insert as Splitting Tool
/// ·	Select one panel, select two points which define the line to split
/// ·	The TSL will split the selected panel and will insert a lap joint at the designated edge
/// Insert as a single tool on one edge of a panel
/// One can use this TSL to modify one edge of the panel. This may enhance design time compared of drawing a beam and using the command HSB_LINKTOOLS.
/// ·	Select one panel, select two points on the edge where you want to attach the lap
/// ·	The TSL will not split the selected panel, but it will insert a lap joint at the designated edge
/// ·	If another panel needs to join with this lap at a later stage one can use the custom command 'Add panel' to link this entity to the tool.
/// Insert as Tool to multiple panels
/// To link two panels or multiple panels to one reference panel you can use this TSL to assign a lap joint.
/// ·	Select all desired panels, make sure that your reference panel will be selected first
/// ·	Pick a point near to the edge which you would like to join
/// </insert>

/// History
/// #Versions:
// 4.13 05.12.2024 HSB-23002: save graphics in file for render in hsbView and make Author: Marsel Nakuci
// 4.12 21.10.2024 HSB-22813: Fix when applying drills at corners , Author Marsel Nakuci
// 4.11 19/08/2024 HSB-22548: make sure the other side of mortise doesnt cut rounds at panel; increase width of mortise Marsel Nakuci
// 4.10 13.05.2022 HSB-15474: Add flag "MortiseCornerCleanupAsDrill" to control corner rounding by mortise or drill Author: Marsel Nakuci
// Version 4.9 14.09.2021 HSB-11596: fix bug when joining multiple panels with openings Author: Marsel Nakuci
///<version  value="4.8" date="26mar2020" author="robert.pol@hsbcad.com"> HSB-7000 add static tool to male instead of female </version>
///<version  value="4.7" date="20mar2020" author="thorsten.huck@hsbcad.com"> HSB-7034 export enabled </version>
///<version  value="4.6" date="03dec19" author="thorsten.huck@hsbcad.com"> HSB-6068 typo fixed </version>
///<version  value="4.5" date="28nov19" author="thorsten.huck@hsbcad.com"> HSB-6068 new property 'Radius': one can now specify the lapjoint to be milled rounded. If the radius is negative it will create an overshoot tool (not supported for BTL output) </version>
///<version  value="4.4" date="02apr19" author="thorsten.huck@hsbcad.com"> HSBCAD-596 new behaviour for depth = 0: depth of lap joint and center gap are in the center of the joint</version>
///<version  value="4.3" date="15nov18" author="thorsten.huck@hsbcad.com"> bugfix chamfer length corrected when gap is also used </version>
///<version  value="4.2" date="02aug18" author="thorsten.huck@hsbcad.com"> bugfix properties dialog </version>
///<version  value="4.1" date="18apr18" author="thorsten.huck@hsbcad.com"> bugfix split projection if base panel is aligned perpendicular to the XY world plane </version>
///<version  value="4.0" date="20mar18" author="thorsten.huck@hsbcad.com"> new optional gap parameter considered if defined in settings file. settings file renamed to 'hsbCLT-LapJoint' and structure flattened, use default settings export to see structure. import and export of settings now done through hsbTSLSettingsIO.mcr </version>
///<version  value="3.9" date="09mai17" author="thorsten.huck@hsbcad.com"> version control considers flip state and tool length extension </version>
///<version  value="3.8" date="08mai17" author="thorsten.huck@hsbcad.com"> gap version control to keep persistent model  </version>
///<version  value="3.7" date="08mai17" author="thorsten.huck@hsbcad.com"> duplicate beamcuts avoided when tool is converted to static </version>
///<version  value="3.6" date="03apr17" author="thorsten.huck@hsbcad.com"> Gap values are persistent to its sides when alignment is flipped (II) )</version>
///<version  value="3.5" date="03apr17" author="thorsten.huck@hsbcad.com"> Gap values are persistent to its sides when alignment is flipped </version>
///<version  value="3.4" date="02mar17" author="thorsten.huck@hsbcad.com"> EndExtension UI change </version>
///<version  value="3.3" date="28febt17" author="rl@hsbcadna.com"> Set the additional length of U(60) to the properties </version>
///<version  value="3.1" date="28sept16" author="thorsten.huck@hsbcad.com"> new context command to convert the instance into static tools </version>
///<version  value="3.0" date="08apr16" author="thorsten.huck@hsbcad.com"> debug removed </version>
///<version  value="2.9" date="08apr16" author="thorsten.huck@hsbcad.com"> when applying this tool to a single roof panel the projection of the splitting points can be toggled, default is plane through panel axis </version>
///<version  value="2.8" date="08apr16" author="thorsten.huck@hsbcad.com"> bugfix when inserting as split loaction tsl on a wall, OPM override of walls removed </version>
///<version  value="2.7" date="29Mar16" author="thorsten.huck@hsbcad.com"> insertion at overlapping panels further enhanced, new properties to add chamfers, insert plan view supported </version>
///<version  value="2.6" date="23Mar16" author="thorsten.huck@hsbcad.com"> insertion at overlapping panels supported if overlap matches lap width, multiple insert on single panels supported </version>
///<version  value="2.5" date="23Mar16" author="thorsten.huck@hsbcad.com"> bugfix common range detection if no gaps selected </version>
///<version  value="2.4" date="08feb16" author="thorsten.huck@hsbcad.com"> split direction of slightly beveled panels corrected </version>
///<version  value="2.3" date="01feb16" author="thorsten.huck@hsbcad.com"> split method enhanced, surface quality gaps corrected </version>
///<version  value="2.2" date="01feb16" author="thorsten.huck@hsbcad.com"> settings file now supports individual colors per surface quality rule </version>
///<version  value="2.1" date="29Jan16" author="thorsten.huck@hsbcad.com"> insertion via tsl splitting point supported </version>
///<version  value="2.0" date="29Jan16" author="thorsten.huck@hsbcad.com"> detection of common range enhanced </version>
///<version  value="1.9" date="28Jan16" author="thorsten.huck@hsbcad.com"> opening reconstruction further refined and limited to intersecting openings </version>
///<version  value="1.8" date="27Jan16" author="thorsten.huck@hsbcad.com"> opening reconstruction only during grip move and property width change to enhance regular stretch behaviour at openings </version>
///<version  value="1.7" date="11Jan16" author="thorsten.huck@hsbcad.com"> gable intersections enhanced </version>
///<version  value="1.6" date="11Jan16" author="thorsten.huck@hsbcad.com"> base grip and edit in place grips are not in same XY-plane in plan view </version>
///<version  value="1.5" date="11Jan16" author="thorsten.huck@hsbcad.com"> insert mechanism further enhanced </version>
///<version  value="1.4" date="09Dec15" author="thorsten.huck@hsbcad.com"> default settings file can only be created if main panel contains valid surface quality definitions </version>
///<version  value="1.3" date="08Dec15" author="thorsten.huck@hsbcad.com"> opening recognition added </version>
///<version  value="1.2" date="08Dec15" author="thorsten.huck@hsbcad.com"> default settings file can be created via context command </version>
///<version  value="1.1" date="08Dec15" author="thorsten.huck@hsbcad.com"> insert mechanism enhanced, symbol adjusted to visualize stretch direction </version>
///<version  value="1.0" date="04Dec15" author="thorsten.huck@hsbcad.com"> initial </version>

// Commands
// commmand to create an instance
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCLT-LapJoint")) TSLCONTENT

// command to add panels
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Panel(s)|") (_TM "|Select lap joint(s)|"))) TSLCONTENT
// command to remove panels
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Remove Panel(s)|") (_TM "|Select lap joint(s)|"))) TSLCONTENT
// command to Edit in Place
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Edit in Place|") (_TM "|Select lap joint(s)|"))) TSLCONTENT
// command to flip the alignment
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Flip Alignment|") (_TM "|Select lap joint(s)|"))) TSLCONTENT
// command to swap the depth
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Swap Depth|") (_TM "|Select lap joint(s)|"))) TSLCONTENT
// command to convert to static tools
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Convert to static|") (_TM "|Select lap joint(s)|"))) TSLCONTENT
// command to convert to reset + erase the tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "||Reset + Erase|") (_TM "|Select lap joint(s)|"))) TSLCONTENT		
//End History//endregion 

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
	
	int bLog=false;
	int bDebugMapIO;//=true;
//end Constants//endregion

//region Functions
//region getMaleFemaleSips
// investigates male female panel
// male is the une that penetrates the most 
 
	Map getMaleFemaleSips(Sip _sips[])
	{ 
		Map _mOut;
		
		if(_sips.length()!=2)
		{ 
			return _mOut;
		}
		
		// 
		Sip _sipMale, _sipFemale;
		
		PLine pl0=_sips[0].plEnvelope();
		Point3d pts0[]=pl0.vertexPoints(true);
		PLine pl1=_sips[1].plEnvelope();
		Point3d pts1[]=pl1.vertexPoints(true);
		
		PLine _pl0Convex, _pl1Convex;
		_pl0Convex.createConvexHull(Plane(_sips[0].ptCen(),_sips[0].vecZ()),pts0);
		_pl1Convex.createConvexHull(Plane(_sips[1].ptCen(),_sips[1].vecZ()),pts1);
		
		PlaneProfile _pp0Convex(_pl0Convex);
		PlaneProfile _pp1Convex(_pl1Convex);
		
		PlaneProfile _pp0(_sips[0].plEnvelope());
		PlaneProfile _pp1(_sips[1].plEnvelope());
		
		PlaneProfile _ppSub0=_pp0;_ppSub0.subtractProfile(_pp1Convex);
		PlaneProfile _ppSub1=_pp1;_ppSub1.subtractProfile(_pp0Convex);
		
		if(_ppSub0.area()<_ppSub1.area())
		{ 
			_sipMale=_sips[0];
			_sipFemale=_sips[1];
		}
		else
		{ 
			_sipMale=_sips[1];
			_sipFemale=_sips[0];
		}
		
		_mOut.setEntity("male",_sipMale);
		_mOut.setEntity("female",_sipFemale);
		
		return _mOut;
	}
//End getMaleFemaleSips//endregion
//End Functions//endregion 

//region on mapIO
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
					Point3d ptMidA = edgesA[a].ptMid();//ptMidA.vis(a);
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
							Point3d ptMidB = edgesB[b].ptMid();//ptMidB.vis(a);
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
//_______________________________________________________________
//_______________________________________________________________	
		
//End on mapIO//endregion 
	
// SETTINGS //region
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sScript = _bOnDebug?"hsbCLT-LAPJOINT":scriptName();
	Map mapSetting;

// find settings file
	String sFolders[]=getFoldersInFolder(sPath); 
	int bPathFound;
	if (_bOnInsert)
		bPathFound= sFolders.find(sFolder)>-1?true:makeFolder(sPath+"\\"+sFolder);	
	String sFullPath = sPath+"\\"+sFolder+"\\"+sScript+".xml";
	String sFile=findFile(sFullPath); 

// read a potential mapObject
	MapObject mo(sDictionary ,sScript);
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
	//endregion		

//region Properties
// default display color if no settings found
	int nColor = 72;
	
// reference side
	String sCategoryRef = T("|Reference Side|");
	String sWidthName="(A)  " + T("|Width|");
	PropDouble dWidth(nDoubleIndex++, U(50),sWidthName);
	dWidth.setDescription(T("|Defines the width of the lap joint of the main panel|"));
	dWidth.setCategory(sCategoryRef );
	
	String sDepthName="(B)  " + T("|Depth|");	
	PropDouble dDepth(nDoubleIndex++, U(0), sDepthName);
	dDepth.setDescription(T("|Defines the depth of the lap joint seen from reference side|") + " " + T("|0 = 50% of thickness|"));
	dDepth.setCategory(sCategoryRef );	
	
	String sGapRefName="(C)  " + T("|Gap|");	
	PropDouble dGapRef(nDoubleIndex++, U(3), sGapRefName);
	dGapRef.setDescription(T("|Defines the gap of the lap joint on the reference side|"));
	dGapRef.setCategory(sCategoryRef );
	
// opposite
	String sCategoryOpp = T("|opposite side|");
	String sWidthOppName=T("|Width|")+" ";	
	//PropDouble dWidthOpp(nDoubleIndex++, U(0),sWidthOppName);
	//dWidthOpp.setDescription(T("|Defines the width of the lap joint of the main panel|") + " " + T("|Value may not exceed width of reference side.|"));
	//dWidthOpp.setCategory(sCategoryOpp);
	//nDoubleIndex++;
	double dWidthOpp=0;
	
	String sDepthOppName=T("|Depth|") + " ";	
	//PropDouble dDepthOpp(nDoubleIndex++, U(0), sDepthOppName);
	//dDepthOpp.setDescription(T("|Defines the depth of the lap joint seen from opposite of the reference side|"));
	//dDepthOpp.setCategory(sCategoryOpp );
	//nDoubleIndex++;
	double dDepthOpp=0;
	
	String sGapOppName="(E)  " + T("|Gap|");	
	PropDouble dGapOpp(nDoubleIndex++, U(3),sGapOppName); // keep enums of previous versions	
	dGapOpp.setDescription(T("|Defines the gap of the lap joint on the top side|"));
	dGapOpp.setCategory(sCategoryOpp );
	
// center
	String sCategoryCen = T("|Center|");
	String sGapCenName="(G)  " + T("|Gap|");	
	PropDouble dGapCen(nDoubleIndex++, U(0), sGapCenName);	
	dGapCen.setDescription(T("|Defines the gap at the center|"));
	dGapCen.setCategory(sCategoryCen );	
	
// general
	String sAutoGapModes[] = {T("|Disabled|"), T("|Enabled|")};
	String sAutoGapModeName="(H)  " + T("|Automatic Surface Gap|");	
	PropString sAutoGapMode(nStringIndex++, sAutoGapModes, sAutoGapModeName,0);	
	sAutoGapMode.setDescription(T("|Specifies if the surface gaps are to be controlled by the value which is found in the surface quality - gap mapping in the external settings file.|"));
	
// chamfer
	String sChamferRefName="(D)  "+T("|Chamfer|");
	PropDouble dChamferRef(nDoubleIndex++, U(0), sChamferRefName);
	dChamferRef.setCategory(sCategoryRef);
	
	String sChamferOppName="(F)  "+T("|Chamfer|");
	PropDouble dChamferOpp(nDoubleIndex++, U(0), sChamferOppName);
	dChamferOpp.setCategory(sCategoryOpp );
	
// Addition length for tool
	category = T("|Tool|");
	String sEndExtensionName="(I)  "+T("|Tool End Extension|");	
	PropDouble dEndExtensionRef(nDoubleIndex++, U(30), sEndExtensionName);
	dEndExtensionRef.setDescription(T("|Defines the extension in length of the tool. It is recommended to always have an additional extension in length to break through the end face of the CLT. In some cases this is not desired.|"));
	dEndExtensionRef.setCategory(category);
	
	String sRadiusName=T("(J)   |Radius|");	
	PropDouble dRadius(nDoubleIndex++, U(0), sRadiusName);	
	dRadius.setDescription(T("|Defines the rounding radius.|") + T(" |A negative value will create an overshoot|."));
	dRadius.setCategory(category);			
//End Properties//endregion 
	
	int bMortiseCornerCleanupAsDrill;
	if(mapSetting.hasInt("MortiseCornerCleanupAsDrill"))
	{ 
		bMortiseCornerCleanupAsDrill=mapSetting.getInt("MortiseCornerCleanupAsDrill");
	}
// on insert
	if (_bOnInsert)
	{
		//if (insertCycleCount()>1) { eraseInstance(); return; }
	// show the dialog if no catalog in use
		if (_kExecuteKey == "")
			showDialogOnce();		
	// set properties from catalog		
		else	
			setPropValuesFromCatalog(_kExecuteKey);	

	// get selection set
		PrEntity ssE(T("|Select panel(s)|")+ ", " + T("|<Enter> to select a wall|"), Sip());
		Entity ents[0];
		if (ssE.go())
			ents = ssE.set();
	
	// cast to sips
		Sip sips[0];
		for (int i=0;i<ents.length();i++)
			sips.append((Sip)ents[i]);

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
				reportMessage("\n" + T("|Invalid points selected|"));
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
					
				// prompt user for input
					String sInput;
					String sAlignments[] = {T("|Bottom face|"), T("|Axis|"),T("|Top face|"), T("|Not projected|")};
					sInput=getString(T("|Projection of splitting points|") + ": [" + sAlignments[0]+"/" + sAlignments[1]+"/" + sAlignments[2]+"/" + sAlignments[3]+ "]" + " <"+ sAlignments[1]+ ">");
					if (sInput.length()>0)
					{
						String sFirstChar = sInput.left(1).makeUpper();
						if (sFirstChar==sAlignments[0].left(1).makeUpper())
							dDistanceToPlane =-.5*sip.dH();
						else if (sFirstChar==sAlignments[2].left(1).makeUpper())
							dDistanceToPlane =.5*sip.dH();				
						else if (sFirstChar==sAlignments[3].left(1).makeUpper())
							bProject=false;
					}						

					if (bProject)
					{
						Plane pnFace(sip.ptCen(), vecZ);
						_Pt0=Line(ptSplit,_ZW).intersect(pnFace,dDistanceToPlane);	
						ptSplit=Line(ptSplit,_ZW).intersect(pnFace,dDistanceToPlane);
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
			Plane pnSplit(_Pt0-vecDir*.5*dWidth,vecDir);
			_Map.setVector3d("vecDir", vecDir);
			Vector3d vecX=vecZ.crossProduct(vecDir);
		// relocate reference point to the center of the envelope
			PLine pl=sips[0].plEnvelope();
			Point3d ptsInt[]=Line(_Pt0,vecX).orderPoints(pl.intersectPoints(pnSplit));
			if (ptsInt.length()>0)
			{
				Point3d ptMid=(ptsInt[0]+ptsInt[ptsInt.length()-1])*.5;
				_Pt0.transformBy(vecX*vecX.dotProduct(ptMid-_Pt0));
			}

		// split the apnel and add it to the list of panels
			Sip sipSplit[0];
			sipSplit=sip.dbSplit(pnSplit,-dWidth);
		
		// append to _Sip
			_Sip.append(sip);
			_Sip.append(sipSplit);
		}// end if only one panel selected
	// multiple panels selected
		else if (sips.length()>1)
		{
//			if(bMortiseCornerCleanupAsDrill && sips.length()==2)
//			{ 
//				// investigate which is male which is female
//				Map mapMaleFemale=getMaleFemaleSips(sips);
//				Entity entMale=mapMaleFemale.getEntity("male");
//				Sip sipMale=(Sip)entMale;
//				Entity entFemale=mapMaleFemale.getEntity("female");
//				Sip sipFemale=(Sip)entFemale;
//				if(sips[0]==sipMale)
//				{ 
//					// HSB-22548
//					sips.reverse();
//				}
//			}
			Sip sip=sips[0];
			Vector3d vecX,vecY,vecZ;
			vecX = sip .vecX();
			vecY = sip .vecY();
			vecZ = sip .vecZ();
			Point3d ptCen = sip .ptCenSolid();			
	
		// prepare tsl cloning
			TslInst tslNew;
			Vector3d vecUcsX = vecX;
			Vector3d vecUcsY= -vecZ;
			GenBeam gbs[2];
			Entity ents[0];
			Point3d pts[1];
			int nProps[]={};
			double dProps[]={dWidth, dDepth, dGapRef,dGapOpp, dGapCen,dChamferRef,dChamferOpp,dEndExtensionRef,dRadius};
			String sProps[]={sAutoGapMode};
			Map mapTsl;
			mapTsl.setInt("mode", 1);// panel mode
			String sScriptname = scriptName();	
			
		// retrieve connection data		
			Map mapIO;
			mapIO.setDouble("XRange",dWidth);
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
				if(!bHasDirectionBySelection)
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
							gbs[0] = sip0;
							gbs[1] = sip1;
							
							if (bDebug)reportMessage("\n	gbs0 " + sip0.posnum()+ " " + " gbs1 " + sip1.posnum());
							
							pts[0] = ptMid;
							mapTsl.setVector3d("vecDir", vecDir);
							tslNew.dbCreate(scriptName(), vecUcsX ,vecUcsY ,gbs, ents, pts, 
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
// end on insert_______________________________________________________________________________________________________________
// ____________________________________________________________________________________________________________________________


// get mode
	if (bLog)reportMessage("\n	" + _ThisInst.handle() + "(" + _kExecutionLoopCount + ")");
	int nMode = _Map.getInt("mode");
	// 0 = wall mode
	// 1 = panel mode

// get properties by index
	int bAutoGapMode = sAutoGapModes.find(sAutoGapMode,0);

//// control color on insert and settings load
//	if (mapSetting.hasInt("Color") && (_bOnDbCreated || _kExecuteKey==sLoadSettingsTrigger))// || _bOnDebug)
//	{
//		nColor = mapSetting.getInt("Color");
//		_ThisInst.setColor(nColor);	
//	}
	
// the default colors of the gap visualisations	
	int nColorRef= nColor;
	int nColorOpp= nColor;
	// HSB-15474:
	//if (bLog)reportMessage("\n	before mode statement - Mode: " + nMode);
// mode 1: panel mode
	if (nMode==1)
	{
//		return;
	// validate referenced sips
		if (_Sip.length()<2)
		{
			reportMessage("\n" + scriptName() + " "+ T("|requires at least 2 panels|"));
			eraseInstance();
			return;	
		}
	
	// set copy behavior
		setEraseAndCopyWithBeams(_kBeam0);
	
	// TriggerAddPanel
		String sTriggerAddPanel = T("|Add Panel(s)|");
		addRecalcTrigger(_kContext, sTriggerAddPanel);
		if (_bOnRecalc && _kExecuteKey==sTriggerAddPanel)
		{
		// get selection set
			PrEntity ssE(T("|Select panel(s)|"), Sip());
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
		String sTriggerRemovePanel = T("|Remove Panel(s)|");
		addRecalcTrigger(_kContext, sTriggerRemovePanel );
		
	// TriggerEditInPlacePanel
		int bEditInPlace=_Map.getInt("directEdit");
		String sTriggerEditInPlaces[] = {T("|Edit in Place|"),T("|Disable Edit in Place|")};
		String sTriggerEditInPlace = sTriggerEditInPlaces[bEditInPlace];
		addRecalcTrigger(_kContext, sTriggerEditInPlace );
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
		}
		
	// the first panel is taken as reference sip
		Sip sipRef = _Sip[0];
		PLine plEnvelope =sipRef.plEnvelope();
		Vector3d vecX,vecY,vecZ;
		vecX = sipRef.vecX();
		vecY = sipRef.vecY();
		vecZ = sipRef.vecZ();
		Point3d ptCen = sipRef.ptCenSolid();
		vecX.vis(ptCen ,1);
		vecY.vis(ptCen ,3);
		vecZ.vis(ptCen ,150);
		double dZ = sipRef.dH();
		CoordSys cs(ptCen ,vecX, vecY, vecZ);
		
	// set depth
		double dThisDepth = dDepth;
		int bAutoDepth = (dDepth <= 0 || dDepth >= dZ);
		if (bAutoDepth)	dThisDepth = .5*dZ;
		
	// build a default map if no settings are found and gap mode is activated
		int bExportDefaultSetting;
		if (mapSetting.length()<1 && bAutoGapMode)
		{ 
			SurfaceQualityStyle sqStyles[] = SurfaceQualityStyle().getAllEntries();
			Map mapRule,mapRules;
			for (int i=0;i<sqStyles.length();i++) 
			{ 
				mapRule.setString("SurfaceQuality",sqStyles[i].entryName());
				mapRule.setInt("Color",i+1);
				mapRule.setDouble("Gap",U(2)); 
				mapRules.appendMap("SurfaceQualityGapRule", mapRule);
			}
			if (mapRules.length()>0)
				mapSetting.appendMap("SurfaceQualityGapRule[]", mapRules);
			bExportDefaultSetting = true;
		}
		
	// version dependent property control
		int nPreviousVersion = _Map.getInt("previousVersion");
		int nVersion = _ThisInst.version();
		if (nPreviousVersion<30002 && !_bOnDebug)
		{
		// swap gap properties for existing instances with version below 3.2
			if (_Map.getInt("flipSide") && (dGapRef>0 || dGapOpp>0))
			{
				double d = dGapRef;
				dGapRef.set(dGapOpp);
				dGapOpp.set(d);
	
			// alert user
				reportNotice("\n\n***************** " + T("|NOTE|") + " *****************");
				reportNotice("\n" + T("|Gap properties have been swaped due to code improvements.|") + "\n"+
				T("|Panel|") + " " + sipRef.posnum() + " " + sipRef.label()+"\n" + 
				T("|Please validate your construction or revert the update of the tsl.|"));
				
			}		
		// previously not existing
			dEndExtensionRef.set(0);
			
			_Map.setInt("previousVersion", nVersion);
			setExecutionLoops(2);
			return;
		}
	
	// set surface gaps in dependency of surface gap mapping
		Map mapRules = mapSetting.getMap("SurfaceQualityGapRule[]");
		if (bAutoGapMode)
		{

		// get style
			SipStyle style(sipRef.style());
		// get current surface qualities
			String sQualityTop=style.surfaceQualityTop();	
			String sQualityBottom=style.surfaceQualityBottom();	
			String sOverrideTop=sipRef.surfaceQualityOverrideTop();	
			String sOverrideBottom=sipRef.surfaceQualityOverrideBottom();	
			if (sOverrideTop.length()>0)sQualityTop=sOverrideTop;
			if (sOverrideBottom.length()>0)sQualityBottom=sOverrideBottom;
			sQualityTop.makeUpper();
			sQualityBottom.makeUpper();
		
		// get mapped surface quality names and its gap values
			String sSettingQualities[0];
			double dSettingGaps[0];
			int nSettingColors[0];
			
			for (int i=0;i<mapRules.length();i++) // loop rules
			{
				Map mapRule = mapRules.getMap(i);
				String sSettingQuality = mapRule.getString("SurfaceQuality").makeUpper();
				double dSettingGap = mapRule.getDouble("Gap");
				if (mapRule.hasDouble("GapEquiLateral") && sQualityTop==sQualityBottom)
					dSettingGap = mapRule.getDouble("GapEquiLateral");	
				int nSettingColor = mapRule.getInt("Color");
			// append unique entries
				if (sSettingQuality.length()>0 && sSettingQualities.find(sSettingQuality)<0)
				{
					sSettingQualities.append(sSettingQuality);
					dSettingGaps.append(dSettingGap);	
					nSettingColors.append(nSettingColor);				
				}
			}
		
		// set gaps if corresponding property is found
			int nQualityTop = sSettingQualities.find(sQualityTop);
			if (nQualityTop>-1)
			{
				dGapOpp.set(dSettingGaps[nQualityTop]);
				dGapOpp.setReadOnly(true);	
				nColorOpp = nSettingColors[nQualityTop];			
			}

			int nQualityBottom = sSettingQualities.find(sQualityBottom);
			if (nQualityBottom >-1)
			{
				dGapRef.set(dSettingGaps[nQualityBottom]);
				dGapRef.setReadOnly(true);
				nColorRef = nSettingColors[nQualityBottom];
			}
		
		// add trigger to write settings if not found
			if (mapRules.length()<1)
			{
				Map mapRule;
				if (sQualityTop.length()>0)
				{
					mapRule.setString("SurfaceQuality",sQualityTop);
					mapRule.setDouble("Gap", dGapOpp);
					mapRule.setInt("Color", nColorOpp);
					mapRules.appendMap("SurfaceQualityGapRule", mapRule);
				}
				if (sQualityBottom.length()>0 && sQualityTop!=sQualityBottom)
				{
					mapRule.setString("SurfaceQuality",sQualityBottom);
					mapRule.setDouble("Gap", dGapRef);
					mapRule.setInt("Color", nColorRef );
					mapRules.appendMap("SurfaceQualityGapRule", mapRule);	
				}	
			// alert user, still nothing appended			
				if (mapRules.length()<1)
				{
					reportNotice("\n******************** " + scriptName() + " ********************");
					reportNotice("\n" + T("|Panel|") + sipRef.posnum() + " " + sipRef.name() + "\n" +
									T("|Neither the style. nor the overwritings are containing\nsurface quality definitions.|") + "\n" + 
									T("|Please check the following setting in style manager:|") + "\n\n   " + 
									T("|hsbcad Objects|") + "\n	" + T("|hsbcad Surface Quality Style|") + "\n	" +
									T("|hsbcad panel styles|")+" - "+ T("|Surface quality style|")+"\n\n" +
									T("|If you don't want to use surface quality styles\nplease disable the option|") + " " + sAutoGapModeName);
					reportNotice("\n**************************************************************");
				}
			}
			if (nQualityBottom >-1)dGapRef.set(dSettingGaps[nQualityBottom]);
			if (nQualityTop >-1)dGapOpp.set(dSettingGaps[nQualityTop]);
		}			
		
	// set the connection vector, it points from the male to the female panel
		Vector3d vecDir = _Map.getVector3d("vecDir");
		vecDir = vecDir .crossProduct(vecZ).crossProduct(-vecZ);vecDir .normalize();
		vecDir.vis(_Pt0,2);
		Vector3d vecPerp = vecDir.crossProduct(-vecZ);

	// remove duplicates of this scriptinstance
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
						for (int p=0;p<5;p++)	if(tsl.propDouble(p)!=_ThisInst.propDouble(p)){bMatch=false;break;}
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


	// TriggerFlipDirection 
		int bFlipSide = _Map.getInt("flipSide");
		String sTriggerFlipSide = T("|Flip Alignment|");
		addRecalcTrigger(_kContext, sTriggerFlipSide );
		if (_bOnRecalc && (_kExecuteKey==sTriggerFlipSide || _kExecuteKey==sDoubleClick))
		{
			if (bFlipSide)bFlipSide=false;
			else bFlipSide=true;
			_Map.setInt("flipSide",bFlipSide);	
		}	
		Vector3d vecZFace = vecZ;
		if (bFlipSide)vecZFace *=-1;

	// TriggerSwapDepth
		if (!bAutoDepth)
		{ 
			String sTriggerSwapDepth = T("|Swap Depth|");
			addRecalcTrigger(_kContext, sTriggerSwapDepth );
			if (_bOnRecalc && _kExecuteKey==sTriggerSwapDepth)
			{
			// swap properties		
				dDepth.set(dZ-dDepth);
				setExecutionLoops(2);
				return;
			}				
		}


	// assignment
		//assignToGroups(sipRef);	
		Point3d ptMinMaxThis[] = {ptCen-vecZ*.5*dZ,ptCen+vecZ*.5*dZ};
		
	// remove every panel from _Sip array if not coplanar and of same thickness
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
				reportMessage("\n" + sipOther.posnum()+ " " + T("|removed from sset|"));
				_Sip.removeAt(i);
			}		
		}
		
	// get the overall profile
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
			if (bDebug)reportMessage("\n	panel i:" +i + " adding openings " + plOpenings.length());
			for (int o=0;o<plOpenings.length();o++)
				ppContour.joinRing(plOpenings[o],_kSubtract);	
		}	
		//ppContour.vis(2);
		
	// get openings from contour
		int bReconstructOpening; // a flag to reconstruct the openings, true if any tslinst property  changes but false if the user modifies the vertices
		PLine plOpenings[0];
		PlaneProfile ppOpening(cs);
		PLine plRings[] = ppContour.allRings();
		int bIsOp[] = ppContour.ringIsOpening();
		for (int r=0;r<plRings.length();r++) 
			if (bIsOp[r]) 
			{
				plOpenings.append(plRings[r]);	
				ppOpening.joinRing(plRings[r], _kAdd);	
			}
		
		
	// set the ref point
		_Pt0.transformBy(vecZ*vecZ.dotProduct(ptCen-_Pt0));
		Point3d ptRef = _Pt0;
	
	// in case _Pt0 has been dragged
		if (_Map.hasVector3d("vecRef") && _kNameLastChangedProp=="_Pt0")
		{
			ptRef =_PtW+_Map.getVector3d("vecRef");
			bReconstructOpening=true;
		}	
		//)vecZFace.vis(ptRef,151);
//		vecPerp .vis(ptRef ,3);
		Line lnPerp(ptRef, vecPerp);
	ptRef.vis(1);
	// on the event of changing the width property
		double dWidthRef = dWidth;
		if (_kNameLastChangedProp==sWidthName)
		{
			double dPerviousWidth = _Map.getDouble("previousWidth");
			Point3d ptRefThis = ptRef-vecDir*dPerviousWidth;
			dWidthRef =dPerviousWidth ;
			bReconstructOpening=true;
		}		

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
				double dDist = vecDir.dotProduct(edge.ptMid()-ptRef);
				double dDist2 = abs(dWidthRef+dDist);
				int bIsParallel = vecDir.isParallelTo(vecNormal) || 1-abs(vecNormal.dotProduct(vecDir))<0.0001;

				if (!bIsParallel || (abs(dDist)>dEps &&  abs(dWidthRef+dDist)>dEps))
				{
					//vecNormal.vis(edge.ptMid(),i+1);
					edges.removeAt(e);
					continue;
				}
//				vecNormal.vis(edge.ptMid(),32);
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
//				vecNormal.vis(edges[e].ptMid(),bIsMale);
				if (bIsMale)
				{
					edgesMales.append(edges[e]);
				// append if not in list	// version 3.7
					if (sipsMales.find(sip)<0)
						sipsMales.append(sip);	
				}	
				else
				{
					edgesFemales.append(edges[e]);	
				// append if not in list // version 3.7	
					if (sipsFemales.find(sip)<0)
						sipsFemales.append(sip);		
				}
			}		
		}
		
	// erase male only connections
		if (sipsMales.length()>1 && sipsFemales.length()<1)
		{
			reportMessage("\n" + T("|Two male panels cannot be connected.|") + " " + T("|Tool will be deleted.|"));
			eraseInstance();
			return;	
		}
		
	// TriggerStaticTool
		String sTriggerStaticTool = T("|Convert to static|");
		addRecalcTrigger(_kContext, sTriggerStaticTool);
		int bAddStatic;
		if (_bOnRecalc && _kExecuteKey==sTriggerStaticTool)
		{
			bAddStatic=true;
		}

	// TriggerResetAndErase
		String sTriggerResetAndErase = T("|Reset + Erase|");
		addRecalcTrigger(_kContext, sTriggerResetAndErase );
		if (_bOnRecalc && _kExecuteKey==sTriggerResetAndErase)
		{	
			Point3d ptRefThis = _Pt0-vecDir*dWidth ;
		// find edges of female panels
			for (int i= 0;i<sipsFemales.length();i++)
			{
				Sip sipThis = sipsFemales[i];
				SipEdge edges[] = sipThis.sipEdges();
				SipEdge edge;
				int bOk;
				for (int e= edges.length()-1;e>=0;e--)
				{
					SipEdge edge = edges[e];
					Vector3d vecYSeg = edge.vecNormal().crossProduct(vecZ).crossProduct(-vecZ);
					if (vecDir.isCodirectionalTo(-vecYSeg) || abs(vecDir.dotProduct(edge.ptMid()-(ptRef-vecDir*dWidth)))<dEps)
					{
						sipThis.stretchEdgeTo(edge.ptMid(),Plane(_Pt0,-vecDir));	
					}
				}// next e
			}// next s				
			
			eraseInstance();
			return;
		}	

	// assigning	
		if (sipsMales.length()>0)assignToGroups(sipsMales[0]);		


	// TriggerRemovePanel: remove the panel from _Sip and reset the panel edge if applicable
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
		
	// common contour
		PlaneProfile ppCommonContour(cs);
		for (int e=0; e<_Sip.length();e++)	
			ppCommonContour.joinRing(_Sip[e].plEnvelope(),_kAdd);	
		//ppCommonContour.transformBy(vecZ*U(300));
		//ppCommonContour.vis(251);

//		return;
	// get common range
		PlaneProfile ppCommon(cs);
		{
			PlaneProfile pp(cs), ppMale(cs), ppFemale(cs);
			Sip sips[0]; sips=sipsMales;
			Vector3d vec = vecDir;
			double dThisGap = dGapRef;
			Point3d ptStretch = ptRef;
			for (int x=0;x<2;x++)
			{
				//ptStretch .vis(x);
				for (int i=0;i<sips.length();i++)
				{
					PlaneProfile pp(sips[i].plShadow());
//					pp.vis(4);
				// stretch at least slightly to detect common range // version  value="2.5"
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
//								pts[p].vis(4);
								b=true;
							}
							bs.append(b);
						}
						for (int p=0;p<bs.length();p++)
							if (bs[p])
							{
//								pts[p].vis(5);
								pp.moveGripEdgeMidPointAt(p, vec*dThisGap);
							}
					}
					pp.vis(5);
				// resolve rings
					plRings = pp.allRings();
					bIsOp=pp.ringIsOpening();
					for (int r=0;r<plRings .length();r++)
					{
						if (!bIsOp[r] && x==0)	
							ppMale.joinRing(plRings[r], _kAdd);
						else if (!bIsOp[r] && x==1)	
							ppFemale.joinRing(plRings[r], _kAdd);
					}						


				}// next i sip
				//pps=ppFemales;
				vec*=-1;				
				ptStretch.transformBy(vec*dWidth);
				sips=sipsFemales;
				dThisGap = dGapOpp;
			}// next x

			ppCommon = ppMale;
			ppCommon.intersectWith(ppFemale);
			ppCommon.transformBy(vecZ*U(400));
			ppCommon.vis(20);
			ppCommon.transformBy(-vecZ*U(400));
		}
		LineSeg segCommon = ppCommon.extentInDir(vecPerp);	//segCommon.vis(2);
		
		
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
			segCommon.vis(1);
			PLine plRec;
			plRec.createRectangle(segCommon, vecPerp, vecDir);
			PlaneProfile pp(plRec);
			ppCommon.intersectWith(pp);
		}	
		//ppCommon.transformBy(vecZ*U(300));
		//ppCommon.vis(6);
		//segCommon .vis(40);
	
	// remove any segment which is not intersecting the common range
		Point3d ptsCommon[] = {segCommon.ptStart(), segCommon.ptEnd()};
		ptsCommon = lnPerp.orderPoints(ptsCommon);
		
	// validate common range
		if (ptsCommon.length()<2)
		{
//			reportMessage("\nno common range");
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
//return;
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
			}
			if (x==1) 
			{
				sips= sipsFemales;
				edges=edgesFemales;
				ptStretch.transformBy(-vecDir*dWidth);	
			}
			
			for (int e=0; e<edges.length();e++)
			{
//				if (sips.length()>e)
				// HSB-11596
				if (sips.length()>0)
				{
					Plane pnStretch(ptStretch,vecDir);
//					Sip sip = sips[e];
					// HSB-11596
					Sip sip = sips[0];
//					edges[e].vecNormal().vis(edges[e].ptMid(), x);
					sip.stretchEdgeTo(edges[e].ptMid(),pnStretch);
					//edges[e].vecNormal().vis(edges[e].ptMid(), x);
					
				// reconstruct the opeings if flagged
					if (bReconstructOpening)
					{
						for (int o=0; o<plOpenings.length();o++)
						{
							PLine plOpening = plOpenings[o];
						// test if this opening is intersected by the edge
							Point3d ptsInt[] = plOpening.intersectPoints(pnStretch);
							pnStretch.transformBy(vecDir*dWidth);
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
			setExecutionLoops(2);
			return;
		}//end if(_kNameLastChangedProp=="_Pt0")

	//// snap grips to edge
		//for (int i=0;i<_PtG.length();i++)
			//_PtG[i] = lnPerp.closestPointTo(_PtG[i]);	

	//region TOOLING
	// add beamcuts and chamfers
		//if (1)
		double dChamfers[] = {dChamferRef,dChamferOpp};
		double dGaps[] = {dGapRef,dGapOpp};
		double dTotalLength;
		plRings = ppCommon.allRings(true,false);
		int nNumAllowedGrips;
		for (int r=0; r<plRings.length();r++)
		{
		//region Collect parameters
			nNumAllowedGrips+=2;
			LineSeg seg = PlaneProfile(plRings[r]).extentInDir(vecPerp);
			Point3d pts[] = {seg.ptStart(), seg.ptEnd()};
			pts= lnPerp.orderPoints(pts);
			
		// create grips on this edge
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
			
			Point3d ptBc;
			ptBc.setToAverage(pts);
			ptBc.transformBy(vecZFace*(vecZFace.dotProduct(ptCen-ptBc)-.5*dZ));
			ptBc.transformBy(vecDir*vecDir.dotProduct(ptRef-ptBc));
			//ptBc.vis(4);
	
			double dXBc = abs(vecPerp.dotProduct(pts[0]-pts[pts.length()-1])) + 2*dEndExtensionRef;	
			double dYBc = dWidth+dGapRef+dGapOpp+dEps;
			double dZBc = bAutoDepth?dThisDepth+.5*dGapCen:dThisDepth+dGapCen;
			
			Vector3d vecXBc = vecDir.crossProduct(vecZFace);
			int bDoBeamcut = dRadius == 0;
		//End Collect parameters//endregion 
			
		//region Female Beamcut or Mortise
			if (dXBc>dEps && dYBc>dEps && dZBc>dEps)
			{
				dTotalLength += dXBc;
				Point3d pt = ptBc;
				if (!bFlipSide)			pt.transformBy(vecDir*dGapRef);
				else					pt.transformBy(vecDir*dGapOpp);
				Body bdTool; BeamCut bc,bc2,bc3; Mortise ms;Drill dr;
				int iDr, iBc2, iBc3,iMs, iBc;
			//region Beamcut
//				if (bDoBeamcut)
				if (bDoBeamcut || bMortiseCornerCleanupAsDrill)
				{
					// HSB-22813
					if(!bMortiseCornerCleanupAsDrill || (bMortiseCornerCleanupAsDrill && dRadius<0))
					{ 
						bc = BeamCut(pt, vecXBc , vecDir, vecZFace, dXBc, dYBc, dZBc*2,0,-1, 0);	
						bdTool=bc.cuttingBody();
						if (!bAddStatic)bc.addMeToGenBeamsIntersect(sipsFemales);
						iBc = true;
					}
					else if(bMortiseCornerCleanupAsDrill)
					{ 
						bc = BeamCut(pt, vecXBc , vecDir, vecZFace, dXBc-2*dRadius, dYBc, dZBc*2,0,-1, 0);	
						bdTool=bc.cuttingBody();
						bdTool.vis(2);
						if (!bAddStatic)bc.addMeToGenBeamsIntersect(sipsFemales);
						iBc = true;
					}
					if(bMortiseCornerCleanupAsDrill)
					{ 
						double _dXBc = dXBc;
						double _dYBc = abs(dRadius) + dYBc;
						Point3d ptDrills[2];
						Vector3d vecs[2];
						int iDrills[2];
						for (int lr=0;lr<2;lr++) 
						{ 
							Vector3d vec = (lr == 0 ?- 1 : 1) * vecXBc;
							Point3d ptX = pt +vec * (_dXBc * .5+dEps); 
							ptDrills[lr]=ptX;
							vecs[lr]=vec;
							int bInside;
							for (int j=0;j<sipsFemales.length();j++) 
							{ 
								PlaneProfile pp(sipsFemales[j].plShadow());
								if (pp.pointInProfile(ptX)==_kPointInProfile)
								{ 
									bInside = true;
									iDrills[lr] = true;
									break;
								}
								 
							}//next j
						// extend mortise length to mill the end completely
							if (!bInside)
							{
								_dXBc += abs(dRadius);
								pt += vec * .5*abs(dRadius);
							}
						}//next lr	
						
						pt.vis(4);
						vecXBc.vis(pt, 1);
						Vector3d vecDir_=-vecDir;
						vecDir.vis(pt, 3);
						vecZFace.vis(pt, 5);
						
						// add drills
						for (int ipt=0;ipt<ptDrills.length();ipt++) 
						{ 
							// find the center point of the drill
							Vector3d vecToCenter=pt-ptDrills[ipt];
							vecToCenter.normalize();
							if(iDrills[ipt])
							{ 
								Vector3d vecDrillMove;
								if(dRadius>0)
								{ 
									vecDrillMove= vecDir_*dRadius + vecToCenter*dRadius;
									Point3d ptDrill=ptDrills[ipt]+vecDrillMove;
									ptDrill.vis(2);
									vecToCenter.vis(ptDrill,1);
									dr=Drill (ptDrill,ptDrill+vecZFace*dZBc,dRadius);
									dr.cuttingBody().vis(6);
									if (!bAddStatic)dr.addMeToGenBeamsIntersect(sipsFemales);
									bdTool.addPart(dr.cuttingBody());
									iDr = true;
									// add beamcut 
									bc2=BeamCut (ptDrill-vecToCenter*dRadius,vecToCenter,vecDir_,vecZFace,
										2*abs(dRadius), dYBc-dRadius, dZBc, 1, 1, 1);
									bc2.cuttingBody().vis(3);
									if (!bAddStatic)bc2.addMeToGenBeamsIntersect(sipsFemales);
									bdTool.addPart(bc2.cuttingBody());
									iBc2 = true;
									// freeprofile
									PLine pl(vecZFace);
									pl.addVertex(ptDrills[ipt] + vecDir_ * _dYBc);
									pl.addVertex(ptDrills[ipt] + vecDir_ * abs(dRadius));
									pl.addVertex(ptDrills[ipt] - vecs[ipt] * abs(dRadius), (ipt==0?-1:1)*tan(22.5));
									pl.addVertex(ptDrills[ipt] - vecs[ipt] * _dYBc);								//pl.vis(4);
									FreeProfile fp(pl,ptDrills[ipt] + (vecs[ipt] - vecDir_) * abs(dRadius));			//fp.cuttingBody().vis(4);
									fp.cuttingBody().vis(3);
									if (!bAddStatic)fp.addMeToGenBeamsIntersect(sipsMales);
								}
								else if(dRadius<0)
								{ 
									vecDrillMove= vecDir_ + vecToCenter;
									vecDrillMove.normalize();
									Point3d ptDrill=ptDrills[ipt]+vecDrillMove*-dRadius;
									ptDrill.vis(2);
									dr=Drill (ptDrill,ptDrill+vecZFace*dZBc,-dRadius);
									if (!bAddStatic)dr.addMeToGenBeamsIntersect(sipsFemales);
									bdTool.addPart(dr.cuttingBody());
									iDr = true;
								}
							}
							else
							{ 
								if (dRadius != 0)
								{
									bc3=BeamCut (ptDrills[ipt],vecXBc,vecDir_,vecZFace,
											4*abs(dRadius), dYBc, dZBc, 0, 1, 1);
									
									if (!bAddStatic)bc3.addMeToGenBeamsIntersect(sipsFemales);
									bdTool.addPart(bc3.cuttingBody());
									iBc3 = true;
								}
							}
						}//next ipt
					}
				}					
			//End Beamcut//endregion 
			
			//region Mortise
				else
				{ 
				// test left and right end of lapJoint if on free end
					double _dXBc=dXBc;
					double _dYBc=abs(dRadius)+dYBc;
					for (int lr=0;lr<2;lr++) 
					{
						Vector3d vec=(lr==0?-1:1)*vecXBc;
						Point3d ptX=pt+vec*(_dXBc*.5); 
						ptX.vis(3);
						int bInside;
						for (int j=0;j<sipsFemales.length();j++) 
						{ 
							PlaneProfile pp(sipsFemales[j].plShadow());
							if (pp.pointInProfile(ptX+vec*dEps)==_kPointInProfile)
							{ 
								bInside = true;
								break;
							}
						}//next j
						
					// extend mortise length to mill the end completely
						if (!bInside)
						{
							_dXBc += abs(dRadius);
							pt += vec * .5*abs(dRadius);
						}
					// add a free profile to the edge of the male beams to make them fit into the female mortise shape	
						else if (dRadius>0)
						{ 
							PLine pl(vecZFace);
							pl.addVertex(ptX - vecDir * _dYBc);
							pl.addVertex(ptX - vecDir * abs(dRadius));
							pl.addVertex(ptX - vec * abs(dRadius), (lr==0?-1:1)*tan(22.5));
							pl.addVertex(ptX - vec * _dYBc);								//pl.vis(3);
							FreeProfile fp(pl,ptX + (vec + vecDir) * abs(dRadius));			fp.cuttingBody().vis(3);
							if (!bAddStatic)fp.addMeToGenBeamsIntersect(sipsMales);
						}
					}//next lr
					
					// HSB-22548: make sure the other side of mortise doesnt cut
					// rounds at panel
					// HSB-22548
					double _dYBcMortise=_dYBc+=U(500);

					ms=Mortise (pt, vecXBc , vecDir, vecZFace, _dXBc,_dYBcMortise , dZBc*2,0,-1,0);
					ms.setRoundType(_kExplicitRadius);
					ms.setExplicitRadius (dRadius);
					bdTool=ms.cuttingBody();
					bdTool.vis(3);
					if (!bAddStatic)
					{
						ms.addMeToGenBeamsIntersect(sipsFemales);						
					}
				}					
			//End Mortise//endregion 	
			
			//region Add as Static
				//bdTool.vis(bDoBeamcut);			
				if (bAddStatic)
				{	
					for(int i=0;i<sipsFemales.length();i++)
					{
						Body bd = sipsFemales[i].envelopeBody();
						if (bd.hasIntersection(bdTool))
						{
							if (bDoBeamcut)sipsFemales[i].addToolStatic(bc);
							else sipsFemales[i].addToolStatic(ms);
						}
					}// next i
				}					
			//End Add as Static//endregion 				
			}//End Female Beamcut or Mortise//endregion 
			
		//region Center or opposite male beamcut
			dZBc = bAutoDepth?dThisDepth+.5*dGapCen:dZ-dThisDepth;
			if(dWidthOpp>0)dZBc-=dDepthOpp;
			if (dXBc>dEps && dYBc>dEps && dZBc>dEps)
			{
				Point3d pt = ptBc+vecZFace*(dThisDepth)-vecDir*(dWidth);
				if (bAutoDepth)pt -= vecZFace * .5*dGapCen;
				if (bFlipSide)			pt.transformBy(-vecDir*dGapRef);
				else					pt.transformBy(-vecDir*(dGapOpp));
				
				Body bdTool; BeamCut bc, bc2, bc3; Mortise ms;Drill dr;
				int iDr, iBc2, iBc3,iMs, iBc;
				
			//region Beamcut
				if (bDoBeamcut || bMortiseCornerCleanupAsDrill)
				{
					if(!bMortiseCornerCleanupAsDrill || (bMortiseCornerCleanupAsDrill && dRadius<0))
					{ 
						bc=BeamCut(pt,-vecXBc,vecDir,-vecZFace,dXBc,dYBc,dZBc,0,1,-1);
						bdTool=bc.cuttingBody();
						if (!bAddStatic)bc.addMeToGenBeamsIntersect(sipsMales);
						iBc = true;
					}
					else if(bMortiseCornerCleanupAsDrill)
					{ 
						bc=BeamCut(pt,-vecXBc,vecDir,-vecZFace,dXBc-2*dRadius,dYBc,dZBc,0,1,-1);
						bdTool=bc.cuttingBody();
						if (!bAddStatic)bc.addMeToGenBeamsIntersect(sipsMales);
						iBc = true;
					}
					
					if(bMortiseCornerCleanupAsDrill)
					{ 
						double _dXBc = dXBc;
						double _dYBc = abs(dRadius) + dYBc;
						Point3d ptDrills[2];
						Vector3d vecs[2];
						int iDrills[2];
						for (int lr=0;lr<2;lr++) 
						{ 
							Vector3d vec = (lr == 0 ?- 1 : 1) * vecXBc;
							Point3d ptX = pt +vec * (_dXBc * .5+dEps); 
							ptDrills[lr]=ptX;
							vecs[lr]=vec;
							int bInside;
							for (int j=0;j<sipsMales.length();j++) 
							{ 
								PlaneProfile pp(sipsMales[j].plShadow());
								if (pp.pointInProfile(ptX)==_kPointInProfile)
								{ 
									bInside = true;
									iDrills[lr] = true;
									break;
								}
								 
							}//next j
						// extend mortise length to mill the end completely
							if (!bInside)
							{
								_dXBc += abs(dRadius);
								pt += vec * .5*abs(dRadius);
							}
						}//next lr	
						
						pt.vis(4);
						vecXBc.vis(pt, 1);
						vecDir.vis(pt, 3);
						vecZFace.vis(pt, 5);
						
						// add drills
						for (int ipt=0;ipt<ptDrills.length();ipt++) 
						{ 
							// find the center point of the drill
							Vector3d vecToCenter=pt-ptDrills[ipt];
							vecToCenter.normalize();
							if(iDrills[ipt])
							{ 
								Vector3d vecDrillMove;
								if(dRadius>0)
								{ 
									vecDrillMove= vecDir*dRadius + vecToCenter*dRadius;
									Point3d ptDrill=ptDrills[ipt]+vecDrillMove;
									ptDrill.vis(2);
									vecToCenter.vis(ptDrill,1);
									dr=Drill (ptDrill,ptDrill+vecZFace*U(1000),dRadius);
//									dr.cuttingBody().vis(6);
									if (!bAddStatic)dr.addMeToGenBeamsIntersect(sipsMales);
									bdTool.addPart(dr.cuttingBody());
									iDr = true;
									// add beamcut 
									bc2=BeamCut (ptDrill-vecToCenter*dRadius,vecToCenter,vecDir,vecZFace,
										2*abs(dRadius), dYBc-dRadius, dZBc, 1, 1, 1);
									bc2.cuttingBody().vis(3);
									if (!bAddStatic)bc2.addMeToGenBeamsIntersect(sipsMales);
									bdTool.addPart(bc2.cuttingBody());
									iBc2 = true;
									// freeprofile
									PLine pl(vecZFace);
									pl.addVertex(ptDrills[ipt] + vecDir * _dYBc);
									pl.addVertex(ptDrills[ipt] + vecDir * abs(dRadius));
									pl.addVertex(ptDrills[ipt] - vecs[ipt] * abs(dRadius), (ipt==0?1:-1)*tan(22.5));
									pl.addVertex(ptDrills[ipt] - vecs[ipt] * _dYBc);								//pl.vis(4);
									FreeProfile fp(pl,ptDrills[ipt] + (vecs[ipt] - vecDir) * abs(dRadius));			//fp.cuttingBody().vis(4);
									if (!bAddStatic)fp.addMeToGenBeamsIntersect(sipsFemales);
								}
								else if(dRadius<0)
								{ 
									vecDrillMove= vecDir + vecToCenter;
									vecDrillMove.normalize();
									Point3d ptDrill=ptDrills[ipt]+vecDrillMove*-dRadius;
									ptDrill.vis(2);
									dr=Drill (ptDrill,ptDrill+vecZFace*U(1000),-dRadius);
									if (!bAddStatic)dr.addMeToGenBeamsIntersect(sipsMales);
									bdTool.addPart(dr.cuttingBody());
									iDr = true;
								}
							}
							else
							{ 
								if (dRadius != 0)
								{
									bc3=BeamCut (ptDrills[ipt],vecXBc,vecDir,vecZFace,
											4*abs(dRadius), dYBc, dZBc, 0, 1, 1);
									
									if (!bAddStatic)bc3.addMeToGenBeamsIntersect(sipsMales);
									bdTool.addPart(bc3.cuttingBody());
									iBc3 = true;
								}
							}
						}//next ipt
							
					}
				}
			//End Beamcut//endregion 	
			
			//region Mortise
				else
				{ 
				// test left and right end of lapJoint if on free end
					double _dXBc = dXBc;
					double _dYBc = abs(dRadius) + dYBc;
					for (int lr=0;lr<2;lr++) 
					{ 
						Vector3d vec = (lr == 0 ?- 1 : 1) * vecXBc;
						Point3d ptX = pt +vec * (_dXBc * .5+dEps); 
						ptX.vis(4);
						int bInside;
						for (int j=0;j<sipsMales.length();j++) 
						{ 
							PlaneProfile pp(sipsMales[j].plShadow());
							if (pp.pointInProfile(ptX)==_kPointInProfile)
							{ 
								bInside = true;
								break;
							}
							 
						}//next j
					// extend mortise length to mill the end completely
						if (!bInside)
						{
							_dXBc += abs(dRadius);
							pt += vec * .5*abs(dRadius);
						}
					// add a free profile to the edge of the male beams to make them fit into the female mortise shape	
						else if (dRadius>0)
						{ 
							PLine pl(vecZFace);
							pl.addVertex(ptX + vecDir * _dYBc);
							pl.addVertex(ptX + vecDir * abs(dRadius));
							pl.addVertex(ptX - vec * abs(dRadius), (lr==0?1:-1)*tan(22.5));
							pl.addVertex(ptX - vec * _dYBc);								//pl.vis(4);
							FreeProfile fp(pl,ptX + (vec - vecDir) * abs(dRadius));			//fp.cuttingBody().vis(4);
							if (!bAddStatic)fp.addMeToGenBeamsIntersect(sipsFemales);
						}			
					}//next lr		

					ms=Mortise (pt, -vecXBc , vecDir,-vecZFace, _dXBc, _dYBc, dZBc,0,1, -1);
					ms.setRoundType(_kExplicitRadius);
					ms.setExplicitRadius (dRadius);
					bdTool=ms.cuttingBody();
					bdTool.vis(1);
					if (!bAddStatic)ms.addMeToGenBeamsIntersect(sipsMales);
					iMs = true;
				}					
			//End Mortise//endregion 
			
			//region Add as Static
				bdTool.vis(bDoBeamcut+2);			
				if (bAddStatic)
				{	
					for(int i=0;i<sipsMales.length();i++)
					{
						Body bd = sipsMales[i].envelopeBody();
						if (bd.hasIntersection(bdTool))
						{
//							if (bDoBeamcut)sipsMales[i].addToolStatic(bc);
//							else sipsMales[i].addToolStatic(ms);
							if(iBc)sipsMales[i].addToolStatic(bc);
							if(iMs)sipsMales[i].addToolStatic(ms);
							if(iBc2)sipsMales[i].addToolStatic(bc2);
							if(iBc3)sipsMales[i].addToolStatic(bc3);
							if(iDr)sipsMales[i].addToolStatic(dr);
						}
					}// next i
				}					
			//End Add as Static//endregion 

			}					
		//End //center or opposite male beamcut//endregion 
		 
		//region Gap opposite female
			dZBc = dDepthOpp;
			//if (dZBc>0)dZBc+=dGapCen;		
			if (dXBc>dEps && dYBc>dEps && dZBc>dEps && dWidthOpp>dEps && dDepthOpp>dEps)
			{
				Point3d pt = ptBc-vecDir*(dWidth-dWidthOpp)+vecZFace*dZ;	//pt.vis(4);
				//pt.transformBy(vecZ*(vecZ.dotProduct(ptOrg-ptBc)+.5*dZ));
			//region Beamcut
//				if (dRadius == 0)
				{
					BeamCut bc(pt, vecXBc , vecDir, vecZFace, dXBc, dYBc, dZBc*2,0,-1, 0);		//bc.cuttingBody().vis(4);				
					if (bAddStatic)
					{
						Body bdBc = bc.cuttingBody();
						for(int i=0;i<sipsFemales.length();i++)
						{
							Body bd = sipsFemales[i].envelopeBody();
							if (bd.hasIntersection(bdBc))
								sipsFemales[i].addToolStatic(bc);
						}// next i
					}				
					else	
						bc.addMeToGenBeamsIntersect(sipsFemales);					
				}
			//End Beamcut//endregion 	
			}				
		//End Gap opposite female//endregion 

		//region Gap opposite male
			dZBc = dDepthOpp;
			//dYBc = U(10e2);			
			if (dXBc>dEps && dYBc>dEps && dZBc>dEps && abs(dWidth-dWidthOpp)>dEps)//dWidthOpp>dEps && dDepthOpp>dEps)
			{
				Point3d pt = ptBc;
				pt.transformBy(vecZFace*(vecZFace.dotProduct(ptCen-ptBc)+.5*dZ));
				BeamCut bc(pt-vecDir*(dWidth-dWidthOpp+dGapOpp), vecXBc , vecDir, vecZFace, dXBc, dYBc, dZBc*2,0,1, 0);
				//if (bDebug)bc.cuttingBody().vis(5);	
				if (bAddStatic)
				{
					Body bdBc = bc.cuttingBody();
					bdBc.vis(6);
					Sip s[0];s = sipsMales;
					for(int i=0;i<s.length();i++)
					{
						Body bd = s[i].envelopeBody();
						if (bd.hasIntersection(bdBc))
						{
							s[i].addToolStatic(bc);
						}
					}// next i
				}				
				else	
					bc.addMeToGenBeamsIntersect(sipsMales);
			}				
		//End Gap opposite male//endregion 
				
		//region Chamfer
			int nDir=-1;
			Vector3d vecDirChamf = vecDir;
			if (bFlipSide)
			{
				vecDirChamf *=-1;
				ptBc.transformBy(vecDirChamf*dWidth);
			}	
			vecXBc= vecZ.crossProduct(vecDirChamf);	
			for (int c=0; c<dChamfers.length(); c++)
			{
				double dChamfer = dChamfers[c];
				double dGap = dGaps[c];
				if (dChamfer<=dEps)
				{
					ptBc.transformBy(-vecDirChamf*dWidth);
					nDir*=-1;
					continue;
				}
				
				Point3d pt = ptBc;
				pt.transformBy(vecZ * (vecZ.dotProduct(ptCen-pt)+nDir*.5*dZ));
				
				double dCGap = .5 * dGap / sin(45); // the extension of the hypotenuse (the chamfer) by the gap
				double dA = sqrt(pow((dChamfer+dCGap),2)/2);
				pt.transformBy(vecZ*-nDir*dA);
				pt.transformBy(vecDirChamf*-nDir*.5* dGap);
				//pt.vis(6);
				CoordSys csRot;
				csRot.setToRotation(-45,vecXBc ,pt);
				
				BeamCut bc(pt ,vecXBc ,vecDirChamf, vecZ, dXBc, dChamfer*2 , dChamfer*2 ,0,nDir,nDir);
				bc.transformBy(csRot);
				bc.cuttingBody().vis(0);
				
				
				if (bAddStatic)
				{
					Body bdBc = bc.cuttingBody();
					Sip s[0];s = _Sip;
					for(int i=0;i<s.length();i++)
					{
						Body bd = s[i].envelopeBody();
						if (bd.hasIntersection(bdBc))
						{
							s[i].addToolStatic(bc);
						}
					}// next i
				}				
				else
					bc.addMeToGenBeamsIntersect(_Sip);
				
				ptBc.transformBy(-vecDirChamf*dWidth);
				
				nDir*=-1;
			}// next c			
							
		//End Chamfer//endregion 

		}// next r of rings END beamcuts

	// erase if triggered to static
		if (bAddStatic)
		{
			eraseInstance();
			return;
		}		
	//End TOOLING//endregion 	


	// Display
		int nThisColor = _ThisInst.color();
		Display dpModel(nThisColor ), dpPlan(nThisColor);
		dpModel.addHideDirection(vecZ);
		dpModel.addHideDirection(-vecZ);
		dpModel.showInDxa(true);// HSB-23002
		dpPlan.addViewDirection(vecZ);
		dpPlan.addViewDirection(-vecZ);
		dpPlan.showInDxa(true);// HSB-23002
		
	// symbols
		Point3d ptSym = _Pt0+vecZFace*(vecZFace.dotProduct(ptCen-_Pt0)-.5*dZ);
		PLine plSym(vecDir.crossProduct(-vecZFace));
		PLine plSymbols[0], plFilled[0];
		int nPLineColors[0];
		
	// swap gap values on flipped side
		double dGapsSym[0]; dGapsSym=dGaps;
		if (bFlipSide)dGapsSym.swap(0,1);
		
		double dDepthOppThis;
		if (dWidthOpp>dEps) dDepthOppThis = dDepthOpp;
		Point3d ptsSym[] = {ptSym};//ptSym.vis(6);
		{ 
			Point3d pt = ptsSym[ptsSym.length() - 1]+vecDir*dGapsSym[0];
			ptsSym.append(pt);	//pt.vis(1);	
			pt = ptsSym[ptsSym.length()-1]+vecZFace*(dThisDepth+(bAutoDepth?.5:1)*dGapCen);
			ptsSym.append(pt);	//pt.vis(2);
			pt = ptsSym[ptsSym.length()-1]-vecDir*(dWidth+dGapsSym[0]);
			ptsSym.append(pt);	//pt.vis(3);
			pt += vecZFace * (vecZFace.dotProduct(ptSym - pt) + dZ);
			ptsSym.append(pt);	//pt.vis(4);
			pt += -vecDir*(dGapsSym[1]);
			ptsSym.append(pt);	//pt.vis(5);
			pt += -vecZFace*(dZ-dThisDepth-dDepthOppThis+(bAutoDepth?.5*dGapCen:0));
			ptsSym.append(pt);	//pt.vis(6);	
			pt += vecDir*(dWidth+dGapsSym[1]);
			ptsSym.append(pt);	//pt.vis(7);				
			ptsSym.append(ptSym);			
		}

			
		for (int i=0;i<ptsSym.length();i++)
		{
			plSym.addVertex(ptsSym[i]);
			//ptsSym[i].vis(i);
		}

		//plSym.vis(6);
		//plSym.close();	
		plSymbols.append(plSym);	
		dpModel.draw(plSym);
	
	// the default size of the ref symbol
		double dSize = dWidth/3;
		PLine plGaps[0];
		plSym.createRectangle(LineSeg(ptsSym[0], ptsSym[2]),vecDir,vecZ);
		plGaps.append(plSym);
		plSym.createRectangle(LineSeg(ptsSym[4], ptsSym[6]),vecDir,vecZ);
		plGaps.append(plSym);
		
		
	// create and draw the gap rectangle
		if (dGapRef>0)
		{
			int c = nColorRef;
			dpModel.color(c);
			plSym = plGaps[bFlipSide?1:0];
			plFilled.append(plSym);
			nPLineColors.append(c);
			dpModel.draw(PlaneProfile(plSym),_kDrawFilled);
			dSize = dGapRef;
		}	
	
	// create and draw the other gap rectangle
		if (dGapOpp>0)
		{
			int c = nColorOpp;
			dpModel.color(c);
			plSym = plGaps[bFlipSide?0:1];
			plFilled.append(plSym);
			nPLineColors.append(c);
			dpModel.draw(PlaneProfile(plSym),_kDrawFilled);	
		}	
		dpModel.color(nColor);
		
	// create and draw the other gap rectangle
		if (dGapCen>0)
		{
			plSym.createRectangle(LineSeg(ptsSym[2], ptsSym[6]),vecDir,vecZ);
			//plSym.vis(3);
			plFilled.append(plSym);
			nPLineColors.append(nColor);
			dpModel.draw(PlaneProfile(plSym),_kDrawFilled);		
		}	
	
	// display the main ref	
		Point3d pt = (ptsSym[4]+ptsSym[3])/2;
		//pt.vis(4);
		{ 
			double dDelta = bAutoDepth ? .5 * dGapCen : dGapCen;
			plSym = PLine(vecPerp);
			plSym.addVertex(pt);	
			plSym.addVertex(pt+vecZFace*(dZ-dThisDepth-dDelta)/2+vecDir*dWidth);
			plSym.addVertex(pt-vecZFace*(dZ-dThisDepth-dDelta)/2+vecDir*dWidth);
			plSym.close();
			plSymbols.append(plSym);			
		}

		dpModel.draw(plSym);	
	
	//// draw triangle 
		//double dTriangle = U(25);
		//plSym = PLine(ptSym, ptSym-(vecZ+vecDir)*dTriangle,ptSym-(vecZ-vecDir)*dTriangle);
		//plSym.close();
		//dpModel.draw(PlaneProfile(plSym),_kDrawFilled);
	
	// the base ref line
		plSym = PLine(ptSym, ptSym-vecDir*dWidth);
		plSym.transformBy(vecZ*vecZ.dotProduct((ptCen-vecZ*.5*dZ)-ptSym)); // base ref always on same side
		plSymbols.append(plSym);
		
	// transform for plan view
		CoordSys csRot;
		csRot.setToRotation(90,vecDir,_Pt0);
		for (int i=0;i<plFilled.length();i++)
		{
			PLine pl = plFilled[i];
			pl.transformBy(csRot);
			dpPlan.color(nPLineColors[i]);
			dpPlan.draw(PlaneProfile(pl),_kDrawFilled);	
		}	
		dpPlan.color(nColor);
		for (int i=0;i<plSymbols.length();i++)
		{
			if (i==plSymbols.length()-1)
				dpPlan.color(5);
			PLine pl = plSymbols[i];
			pl.transformBy(csRot);
			dpPlan.draw(pl);	
		}	



	// make sure _Pt0 is always within range
		PlaneProfile ppRange(cs);
		PLine plRange; plRange.createRectangle(segCommon, vecPerp, vecDir);
		ppRange.joinRing(plRange, _kAdd);
		if (_kNameLastChangedProp!="_Pt0" && ppRange.pointInProfile(_Pt0)==_kPointOutsideProfile)
			_Pt0.transformBy(vecPerp*vecPerp.dotProduct(segCommon.ptMid()-_Pt0));


	// Hardware//region
	// collect existing hardware
		HardWrComp hwcs[] = _ThisInst.hardWrComps();
		
	// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
		for (int i=hwcs.length()-1; i>=0 ; i--) 
			if (hwcs[i].repType() == _kRTTsl)
				hwcs.removeAt(i); 
	
	// declare the groupname of the hardware components
		String sHWGroupName;
		// set group name
		{ 
		// element
			// try to catch the element from the parent entity
			Element elHW =sipRef.element(); 
			// check if the parent entity is an element
			if (!elHW.bIsValid())	elHW = (Element)sipRef;
			if (elHW.bIsValid()) 	sHWGroupName=elHW.elementGroup().name();
		// loose
			else
			{
				Group groups[] = _ThisInst.groups();
				if (groups.length()>0)	sHWGroupName=groups[0].name();
			}		
		}
		
	// add main componnent
		{ 
			HardWrComp hwc(scriptName(), 1); // the articleNumber and the quantity is mandatory
			hwc.setModel(scriptName());
			hwc.setGroup(sHWGroupName);
			hwc.setLinkedEntity(sipRef);	
			hwc.setCategory(T("|Tool|"));
			hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
			
			hwc.setDScaleX(dTotalLength);
			hwc.setDScaleY(dWidth);
			hwc.setDScaleZ(dThisDepth);
			
		// apppend component to the list of components
			hwcs.append(hwc);
		}
	
	
	
	// make sure the hardware is updated
		if (_bOnDbCreated)	setExecutionLoops(2);				
		_ThisInst.setHardWrComps(hwcs);	
		//endregion






//	// EXPORT/UPDATE
		if (bExportDefaultSetting && sFile.length()<1)
		{ 
			String sExportSettingsTrigger = T("|export Settings|");
			addRecalcTrigger(_kContext,sExportSettingsTrigger );				
			if (_bOnRecalc && _kExecuteKey == sExportSettingsTrigger )
			{
				mapSetting.writeToXmlFile(sFullPath);	
				reportNotice("\n" + scriptName()  +TN("|A settings default file is written to|") + "\n\n" + sFile + "\n\n" + T("|You can now adjust your settings and reload them into the drawing.|") );
				
			}
		}


	
	// store previous location
		_Map.setVector3d("vecRef", _Pt0-_PtW);
		_Map.setDouble("previousWidth", dWidth);
		//if(bDebug)reportMessage("\n" + _ThisInst.handle() + " ended " + _kExecutionLoopCount);
		vecDir.vis(_Pt0,30);
		
	// store current version to keep dwg properties consistant with version prior 3.1
		_Map.setInt("previousVersion",nVersion);
		
		
	}
// END IF PANEL MODE  ___________  END IF PANEL MODE  ___________  END IF PANEL MODE  ___________  END IF PANEL MODE  ___________  END IF PANEL MODE  
	
		
// start wall mode	
	else if (nMode==0)
	{
		//String sOpmName="Wall";
		//setOPMKey(sOpmName);
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

	// set depth
		double dThisDepth =dDepth;
		int bAutoDepth = (dDepth <= 0 || dDepth > dZ - dGapCen);
		if (bAutoDepth)	dThisDepth = .5*dZ;
		
	// on creation
		if (_bOnDbCreated)
		{
			_Pt0.transformBy(vecZ*vecZ.dotProduct(ptOrg-_Pt0));
			
			
		// set catalog properties if specified
			if (_kExecuteKey.length()>0)
			{
				
				String sEntries[] = TslInst().getListOfCatalogNames(scriptName());//+"-"+sOpmName);
				if (sEntries.find(_kExecuteKey)<0)
				{
					//reportNotice("\n***************** " + scriptName()+"-"+sOpmName + " *****************");
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
		addRecalcTrigger(_kContext, sFlipTrigger);
		if (_bOnRecalc && (_kExecuteKey==sFlipTrigger || _kExecuteKey==sDoubleClick)) 
		{
			nSide*=-1;
			_Pt0.transformBy(nSide*vecZ*U(10e2));
			
			return;					
		}

	// TriggerFlipSide
		int bFlipDir = _Map.getInt("flipDirection");
		String sTriggerFlipDirection = T("|Flip Direction|");
		addRecalcTrigger(_kContext, sTriggerFlipDirection );
		if (_bOnRecalc && _kExecuteKey==sTriggerFlipDirection)
		{
			if (bFlipDir)bFlipDir=false;
			else bFlipDir=true;
			_Map.setInt("flipDirection",bFlipDir);	
		}	
		Vector3d vecZFace = vecZ;
		if (bFlipDir)vecZFace *=-1;

//	// add update settings trigger
//		addRecalcTrigger(_kContext, sLoadSettingsTrigger);
			
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
		dpPlan.showInDxa(true);// HSB-23002
		if (bShow)
		{
		// build plan symbol
			Point3d ptSym = _Pt0+vecZFace *(vecZFace .dotProduct(ptOrg-_Pt0)-dZ);
			Vector3d vecDir = vecX;
			double dDepthOppThis;
			if (dWidthOpp>dEps) dDepthOppThis = dDepthOpp;
			Point3d ptsSym[] = {ptSym};
			ptsSym.append(ptsSym[ptsSym.length()-1]+vecDir*dGapRef);
			ptsSym.append(ptsSym[ptsSym.length()-1]+vecZFace *(dThisDepth+dGapCen));
			ptsSym.append(ptsSym[ptsSym.length()-1]-vecDir*(dWidth+dGapRef));
			ptsSym.append(ptsSym[ptsSym.length()-1]+vecZFace *(dZ-dThisDepth-dDepthOppThis-dGapCen));		
			ptsSym.append(ptsSym[ptsSym.length()-1]-vecDir*(dGapOpp));
			ptsSym.append(ptsSym[ptsSym.length()-1]-vecZFace *(dZ-dThisDepth-dDepthOppThis));
			ptsSym.append(ptsSym[ptsSym.length()-1]+vecDir*(dWidth+dGapOpp));	
			ptsSym.append(ptSym);
			
			PLine plSym(vecY);	
			for (int i=0;i<ptsSym.length();i++)
				plSym.addVertex(ptsSym[i]);
			//plSym.vis(6);
			dpPlan.draw(plSym);	
			dpPlan.draw(PLine(_Pt0, _Pt0-nSide*vecZ*el.dBeamWidth()));	
		}
		
		if ((_bOnDbCreated ||_bOnElementConstructed || _bOnDebug) && sipsAll.length()>0)
		{
			setExecutionLoops(2);
		// prepare tsl cloning
			TslInst tslNew;
			Vector3d vecUcsX = vecX;
			Vector3d vecUcsY= -vecZ;
			GenBeam gbs[0];
			Entity ents[0];
			Point3d pts[1];
			int nProps[]={};
			double dProps[]={dWidth, dDepth, dGapRef,dGapOpp, dGapCen,dChamferRef,dChamferOpp,dEndExtensionRef,dRadius};

			String sProps[]={sAutoGapMode};
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
					sipSplit= sip.dbSplit(pnSplit,0);//-dWidth);	
					gbs.setLength(0);
					gbs.append(sip);
					for (int s=0;s<sipSplit.length();s++)	
						gbs.append(sipSplit[s]);						
					pts[0] = _Pt0+vecY*U(100);
					mapTsl.setInt("mode",1);
					mapTsl.setVector3d("vecDir", vecX);	
					tslNew.dbCreate(scriptName(), vecUcsX ,vecUcsY ,gbs, ents, pts, 
						nProps, dProps, sProps,_kModelSpace, mapTsl);
						
					//if (tslNew.bIsValid())
						//tslNew.recalcNow();
					break;	
				}
			}// next i	
		}// END IF ((_bOnDbCre...
	}// END else if (nMode==0)		
		






#End
#BeginThumbnail
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
,265&R,UNT44`?__9
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
        <int nm="BreakPoint" vl="1855" />
        <int nm="BreakPoint" vl="1894" />
        <int nm="BreakPoint" vl="1902" />
        <int nm="BreakPoint" vl="471" />
        <int nm="BreakPoint" vl="464" />
        <int nm="BreakPoint" vl="1796" />
        <int nm="BreakPoint" vl="1800" />
        <int nm="BreakPoint" vl="1797" />
        <int nm="BreakPoint" vl="1627" />
        <int nm="BreakPoint" vl="1628" />
        <int nm="BreakPoint" vl="1641" />
        <int nm="BreakPoint" vl="1707" />
        <int nm="BreakPoint" vl="1700" />
        <int nm="BreakPoint" vl="1718" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23002: save graphics in file for render in hsbView and make" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="13" />
      <str nm="Date" vl="12/5/2024 9:37:03 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22813: Fix when applying drills at corners" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="12" />
      <str nm="Date" vl="10/21/2024 2:04:15 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22548: make sure the other side of mortise doesnt cut rounds at panel; increase width of mortise" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="11" />
      <str nm="Date" vl="8/19/2024 2:47:08 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15474: Add flag &quot;MortiseCornerCleanupAsDrill&quot; to control corner rounding by mortise or drill" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="10" />
      <str nm="Date" vl="5/13/2022 10:35:17 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11596: fix bug when joining multiple panels with openings" />
      <int nm="MajorVersion" vl="4" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="9/14/2021 3:44:29 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End