#Version 8
#BeginDescription
#Versions
Version 3.1 21.11.2023 HSB-20692 common range detection on complex triangular shapes

Version 3.0 06.11.2023 HSB-20569 negative reference gap creates gap between panels, requires hsbDesign 26 or higher
Version 2.9 16.10.2023 HSB-20346 extending tongue/groove fixed, edit in place disabled
Version 2.8 23.05.2023 HSB-19015 data for subnesting process published
Version 2.7 12.05.2023 HSB-18962 solid display improved
Version 2.6 10.05.2021HSB-7981 tool will not be splitted by potential envelope intersections, requires 23.4.18 or higher

This tool requires proper definitions of the custom defined milling heads in HH2-Tab of hsbSettings.

/// This tsl defines a tongue-groove connection on one common edge between at least two panels. On insert it may create a split if only one panel was selected.
/// The closest point to the main contour in relation to the reference point (_Pt0) defines the edge where the tool is
/// assigned to.
/// This tsl can also be used in conjunction with the command HSB_PANELTSLSPLITLOCATION







#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 3
#MinorVersion 1
#KeyWords Tongue;Groove;Nut;Feder;CLT;Joinery
#BeginContents
//region Part #1
		
//region <History>
// #Versions
// 3.1 21.11.2023 HSB-20692 common range detection on complex triangular shapes , Author Thorsten Huck
// 3.0 06.11.2023 HSB-20569 negative reference gap creates gap between panels, requires hsbDesign 26 or higher , Author Thorsten Huck
// 2.9 16.10.2023 HSB-20346 extending tongue/groove fixed, edit in place disabled , Author Thorsten Huck
// 2.8 23.05.2023 HSB-19015 data for subnesting process published , Author Thorsten Huck
// 2.7 12.05.2023 HSB-18962 solid display improved , Author Thorsten Huck
// 2.6 10.05.2021 HSB-7981 tool will not be splitted by potential envelope intersections, requires 23.4.18 or higher , Author Thorsten Huck
/// <version value="2.5" date="22jun2020" author="thorsten.huck@hsbcad.com"> HSB-7975 bugfix tool length </version>
/// <version value="2.4" date="09mar2020" author="thorsten.huck@hsbcad.com"> HSB-6913 bugfix chamfer length </version>
/// <version value="2.3" date="25nov19" author="thorsten.huck@hsbcad.com"> HSB-6044 center beamcut replaced by solidsubtract </version>
/// <version value="2.2" date="26nov19" author="thorsten.huck@hsbcad.com"> HSB-6057 tooling completely revised per panel</version>
/// <version value="2.1" date="25nov19" author="thorsten.huck@hsbcad.com"> HSB-6044 center beamcut on double connections excluded from CNC export </version>
/// <version value="2.0" date="25feb19" author="thorsten.huck@hsbcad.com"> tongue/groove extended to max common length if not in edit in place mode  </version>
/// <version value="1.9" date="11oct18" author="thorsten.huck@hsbcad.com"> edge offset at openings increased </version>
/// <version value="1.8" date="18apr18" author="thorsten.huck@hsbcad.com"> flip side fixed </version>
/// <version value="1.7" date="17apr18" author="thorsten.huck@hsbcad.com"> property sequence fixed, odd display on openings fixed </version>
/// <version value="1.6" date="17apr18" author="thorsten.huck@hsbcad.com"> translation issue fixed </version>
/// <version value="1.5" date="22jan18" author="thorsten.huck@hsbcad.com"> properties fixed on creation </version>
/// <version value="1.4" date="23mai17" author="thorsten.huck@hsbcad.com"> male and female axis locations are published for other tools </version>
/// <version value="1.3" date="02mai17" author="thorsten.huck@hsbcad.com"> new property gap (K) to stretch male panel to minimal location </version>
/// <version value="1.2" date="26oct16" author="thorsten.huck@hsbcad.com"> tool path extension honours grip mode </version>
/// <version value="1.1" date="26oct16" author="thorsten.huck@hsbcad.com"> new property 'gap' if twin connection is enabled. property categorization extended, tool path length extended to avoid odd cuttingBody </version>
/// <version value="1.0" date="22sept16" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <summary Lang=en>
/// This tsl defines a tongue-groove connection on one common edge between at least two panels. On insert it may create a split if only one panel was selected.
/// The closest point to the main contour in relation to the reference point (_Pt0) defines the edge where the tool is
/// assigned to.
/// This tsl can also be used in conjunction with the command HSB_PANELTSLSPLITLOCATION
/// </summary>

/// <remark Lang=en>
/// This tool requires proper definitions of the custom defined milling heads in HH2-Tab of hsbSettings.
/// </remark >	

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
/// </insert>//endregion


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

	int bDebugMapIO;// = bDebug;
	int bLog;
//end Constants//endregion


//region Properties
			

// Alignment
	category = T("|Alignment|");
	String sReferenceName= T("(A)  |Reference|");	
	String sReferences[] = {T("|Reference Side|"), T("|Axis|"),T("|Opposite Side|")};
	PropString sReference(nStringIndex++, sReferences, sReferenceName,0);	
	sReference.setDescription(T("|Specifies where the tool is referenced to"));
	sReference.setCategory(category);

// Twin
	category = T("|Twin Connection|");
	String sNameGapCen=T("(C)  |Gap|");
	PropDouble dGapCen(8,U(0), sNameGapCen); // NOTE fixed index!
	dGapCen.setDescription(T("|Defines the depth of the gap inbetween if an interdistance has been set.|"));
	dGapCen.setCategory(category);

	String sNameInterdistance=T("(D)  |Interdistance|") ;
	PropDouble dInterdistance(nDoubleIndex++,U(11), sNameInterdistance);
	dInterdistance.setDescription(T("|Defines the interdistance of a double tongue/groove connection.|") + " " + T("|0 = single|"));
	dInterdistance.setCategory(category);

// Alignment
	category = T("|Alignment|");
	String sNameReferenceOffset="(B)  " + T("|Offset|");
	PropDouble dReferenceOffset(nDoubleIndex++,U(10), sNameReferenceOffset);
	dReferenceOffset.setDescription(T("|Defines offset of the tool to the reference.|") + " " + T("|0 = complete through|"));
	dReferenceOffset.setCategory(category);

// gaps
	category = T("|Reference Side|");
	String sNameGapRef="(E)  " + T("|Gap|");
	PropDouble dGapRef(nDoubleIndex++, U(0),sNameGapRef,_kAngle);
	dGapRef.setDescription(T("|Defines the angle dovetail.|"));
	dGapRef.setCategory(category);


	category = T("|Opposite Side|");
	String sNameGap="(G)  " + T("|Gap|");
	PropDouble dGapOpp(nDoubleIndex++,U(1), sNameGap);
	dGapOpp.setDescription(T("|Defines the gap in depth.|"));
	dGapOpp.setCategory(category);

// chamfer
	category=T("|Reference Side|")	;
	String sChamferRefName="(F)  "+T("|Chamfer|");
	PropDouble dChamferRef(nDoubleIndex++, U(0), sChamferRefName);
	dChamferRef.setCategory(category);

	category = T("|Opposite Side|");
	String sChamferOppName="(H)  "+T("|Chamfer|");
	PropDouble dChamferOpp(nDoubleIndex++, U(0), sChamferOppName);
	dChamferOpp.setCategory(category);

	
// geometry
	category = T("|Geometry|");
	
	String sWidthName="(I)  " + T("|Width|");	
	PropDouble dWidthTongue(nDoubleIndex++, U(19), sWidthName);
	dWidthTongue.setDescription(T("|Defines the depth of the lap joint seen from reference side|") + " " + T("|0 = 50% of thickness|"));
	dWidthTongue.setCategory(category);	
		
	String sZDepthName="(J)  " + T("|Depth|");
	PropDouble dZDepth(nDoubleIndex++, U(15),sZDepthName);
	dZDepth.setDescription(T("|Defines the width of the lap joint of the main panel|"));
	dZDepth.setCategory(category);

//  REMINDER: the twin gap has been added after first release and in order to keep properties 
//  in sequence the index has been set to 8 instead of using the increment of nDoubleIndex
	nDoubleIndex++;
	String sGapTongueName="(K)  " + T("|Gap|");	
	PropDouble dGapTongue(nDoubleIndex++, U(0), sGapTongueName);
	dGapTongue.setDescription(T("|Defines the gap between tongue and dado|"));
	dGapTongue.setCategory(category);		
	String sGapTongueErr = sGapTongueName.right(sGapTongueName.length()-5) + " " + T("|may not be <0 or >|") + " " + sZDepthName.right(sZDepthName.length()-5) + ". " + sGapTongueName.right(sGapTongueName.length()-5)  + " "+T("|has been set to 0|");

//End Properties//endregion 	

//region on mapIO
//bDebugMapIO = true;
	if (_bOnMapIO || (bDebugMapIO && !_bOnInsert)) 
	{
		int nFunction= _Map.getInt("function");
		if (bLog)reportMessage("\n" + " mapIO execution function " + nFunction);
		Sip sips[0];
		bDebug= _Map.getInt("debug");
		double dXRange = _Map.getDouble("XRange");//dXRange =U(50);
		double dGap = _Map.getDouble("Gap");
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
							if (!vecA.isParallelTo(vecB) ||  (vecA.isParallelTo(vecB) && vecA.isCodirectionalTo(vecB))) 
							{
								continue;
							}
							
						// get range offset
							double dRangeXOffset = 	abs(vecA.dotProduct(ptMidA-ptMidB));
							if (dXRange>dEps && abs(dRangeXOffset -dXRange)<dEps)
							{
								bDirectionBySelection =true;// accept intersecting ranges
							}
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


		
//endregion 

//region onInsert
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
		if (sKey.length()>0)
			setPropValuesFromCatalog(sKey);
		else
			showDialogOnce();		
	
	// validate gapTongue value
		if (dGapTongue<0 || dGapTongue>dZDepth-dEps)
		{
			dGapTongue.set(0);	
			reportMessage("\n" + sGapTongueErr);
		}

	
		if (bDebug)reportMessage("\nInserting with key "+ sKey);



	// get selection set
		PrEntity ssE(T("|Select panel(s)|")+ ", " + T("|<Enter> to select a wall|"), Sip());
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
				reportMessage("\n"+ sEntry);
				if (sStyle.find(sEntry,0)>-1)
				{
					reportMessage("\nassigning catalog " + sStyle);
					bOk=setPropValuesFromCatalog(sEntry);
					break;
				}
			}// next i
			
			reportMessage("\nassigning catalog of style based entry = " + bOk);
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
				if (!vecZ.isParallelTo(_ZW) && !vecZ.isCodirectionalTo(_ZW))
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
			double dProps[]={dInterdistance,dReferenceOffset,dGapRef,dGapOpp,dChamferRef,dChamferOpp,dWidthTongue,dZDepth,dGapCen,dGapTongue};
			String sProps[]={sReference};
			Map mapTsl;
			mapTsl.setInt("mode", 1);// panel mode
			String sScriptname = scriptName();		
		
		// retrieve connection data		
			Map mapIO;
			mapIO.setDouble("XRange",dZDepth + (dGapRef<0?abs(dGapRef):0));
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
							gbsTsl[0] = sip0;
							gbsTsl[1] = sip1;
							
							if (bDebug)reportMessage("\n	gbs0 " + sip0.posnum()+ " " + " gbs1 " + sip1.posnum());
							
							ptsTsl[0] = ptMid;
							mapTsl.setVector3d("vecDir", vecDir);
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
// end on insert//endregion 

//Part #1 //endregion 


//region Get Mode
	if (bLog)reportMessage("\n	" + _ThisInst.handle() + "(" + _kExecutionLoopCount + ")");
	int nMode = _Map.getInt("mode");
	// 0 = wall mode
	// 1 = panel mode

	int nReference=sReferences.find(sReference,0);
	if (nReference<0) nReference=0;
	dGapCen.setReadOnly(dInterdistance<=dEps);
	
// validate gapTongue value
	if (dGapTongue<0 || dGapTongue>dZDepth-dEps)
	{
		dGapTongue.set(0);	
		reportMessage("\n" + sGapTongueErr);
	}
	
	
	
	if (_bOnDbCreated)_ThisInst.setColor(252);		
//endregion 

//region Panel Mode
	if (nMode==1)
	{
	// validate referenced sips
		if (_Sip.length()<2)
		{
			reportMessage("\n" + scriptName() + " "+ T("|requires at least 2 panels|"));
			eraseInstance();
			return;	
		}
	
	// set copy behavior
		setEraseAndCopyWithBeams(_kBeam0);


	// TriggerFlipDirection
		String sTriggerFlipDirection = T("|Flip Direction|");
		addRecalcTrigger(_kContext, sTriggerFlipDirection );

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
		vecX.vis(ptCen ,1);	vecY.vis(ptCen ,3);	vecZ.vis(ptCen ,150);
		double dZ = sipRef.dH();
		CoordSys cs(ptCen ,vecX, vecY, vecZ);

	// set the stretch value
		double dOverlap = dZDepth;

	// validate interdistance of millings, may not be <0
		if (dInterdistance<0)
		{
			reportMessage("\n" + scriptName() + ": " +T("|The interdistance may not be < 0|"));
			dInterdistance.set(0);
		}
		
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

	// change overlap value if direction trigger executed
		int bResetOverlap;
		if (_bOnRecalc &&( _kExecuteKey==sTriggerFlipDirection|| _kExecuteKey==sDoubleClick)) 
		{
			if (bDebug)reportMessage("\n" + scriptName() + ": " +T("|executing|") + " " + sTriggerFlipDirection + " loop " + _kExecutionLoopCount + " vecDir: " +vecDir);
			_Map.setInt("revertDirection",1);
			setExecutionLoops(3);
			bResetOverlap=true;
		}

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
			
		
	// remove every panel from _Sip array if not coplanar and of same thickness
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
			if (bLog)reportMessage("\n	panel i:" +i + " adding openings " + plOpenings.length());
			for (int o=0;o<plOpenings.length();o++)
				ppContour.joinRing(plOpenings[o],_kSubtract);	
		}	
		//ppContour.vis(2);		

	// get openings from contour
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

	// on the event of changing the depth property
		double dZDepthRef = dOverlap;
		if (_kNameLastChangedProp==sZDepthName)
		{
			double dPrevious = _Map.getDouble("previousZDepth");
			Point3d ptRefThis = ptRef-vecDir*dPrevious;
			dZDepthRef =dPrevious;
			bReconstructOpening=true;
		}		

		double dZGap = dGapTongue;
		if (_kNameLastChangedProp==sGapTongueName)
		{
			double dPrevious = _Map.getDouble("previousZGap");
			dZGap =dPrevious;
			bReconstructOpening=true;
		}
		
	// stretch females	
		if (_kNameLastChangedProp == sNameGapRef && _Map.getDouble("previousRefGap")<0)
		{ 
			Entity entFemales[] = _Map.getEntityArray("Female[]", "", "Female");
			for (int i=0;i<entFemales.length();i++) 
			{ 
				Sip panel = (Sip)entFemales[i]; 
				int ringIndex = panel.findClosestRingIndex(_Pt0); // (added V26) returns -1 for the envelope, and >=0 for an opening.
				int edgeIndex = panel.findClosestEdgeIndex(_Pt0);

				if (edgeIndex>-1)
				{ 
					SipEdge edges[] = panel.sipEdges();
					SipEdge edge = edges[edgeIndex];
					Plane pnStretch(_Pt0, - vecDir);
					if (dGapRef < 0)pnStretch.transformBy(-vecDir * dGapRef);
					if(bDebug)
					{ 
						PLine (edge.ptMid(), panel.ptCen()).vis(4);
					}	
					else
						panel.stretchEdgeTo(edge.ptMid(), pnStretch);
					
					
				}
				 
			}//next i
			setExecutionLoops(2);
			_ThisInst.recalcNow();
			//return;
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
			
				if (edge.plEdge().length()<U(15) && !vecNormal.isParallelTo(vecDir))
				{
					edges.removeAt(e);
					continue;
				}			
				
				double dDist = vecDir.dotProduct(edge.ptMid()-ptRef);
				int bMaleTest = abs(dDist-dZDepthRef+dZGap)<dEps && vecNormal.dotProduct(vecDir)>0;
				int bFemaleTest = abs(dDist)<(dEps+(dGapRef<0?-dGapRef:0)) && vecNormal.dotProduct(vecDir)<0;// HSB-20569
				
				int bIsParallel = vecDir.isParallelTo(vecNormal) || 1-abs(vecNormal.dotProduct(vecDir))<0.0001;
//				
//				if (e<2)//!bIsParallel)
//				{ 
//					int bg = abs(dDist - dZDepthRef + dZGap)<dEps ;
//					double dd = abs(vecNormal.dotProduct(vecDir));
//				}
//				
				int bAccept =  bIsParallel && (bMaleTest || bFemaleTest);
				if (bIsParallel && abs(dDist)<dEps)
					bAccept = true;
				if (!bAccept)//!bIsParallel || (!bMaleTest && !bFemaleTest))
				{	
					//if (vecDir.isParallelTo(vecNormal))
					vecNormal.vis(edge.ptMid(),6);
//					if(bMaleTest)
//					{
//						
//						Display dp(3); dp.draw(abs(vecNormal.dotProduct(vecDir)), edge.ptMid(), _XW, _YW, 0, 0, _kDeviceX);
//					}
					edges.removeAt(e);
					continue;
				}					
				PLine (_PtW,edge.ptMid(),ptCen).vis(e);

			}			
			for (int e=edges.length()-1;e>=0;e--)
			{
				Vector3d vecNormal = edges[e].vecNormal();
				vecNormal = vecNormal.crossProduct(vecZ).crossProduct(-vecZ);
				Point3d ptMid = edges[e].ptMid();
				
			// ignore segments of openings
				if (0 && plOpenings.length()>0 && (ppOpening.closestPointTo(ptMid)-ptMid).length()<dEps && ppOpening.pointInProfile(ptMid+vecDir*dEps)==_kPointInProfile) 
				{
					ppOpening.vis(30);
					//ptMid.vis(1);
					continue;	
				}
				
				double d=vecNormal.dotProduct(vecDir);
				int bIsMale = vecNormal.dotProduct(vecDir)>0;
				vecNormal.vis(edges[e].ptMid(),bIsMale?1:2);
				if (bIsMale)
				{
					
					edgesMales.append(edges[e]);
					if (sipsMales.find(sip)<0)sipsMales.append(sip);	
				}	
				else
				{
					edgesFemales.append(edges[e]);	
					if (sipsFemales.find(sip)<0)sipsFemales.append(sip);		
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

		
	// get common range
		PlaneProfile ppCommon(cs);
		//if (nProfile==0)// male/female dove
		{
			PlaneProfile pp(cs), ppMale(cs), ppFemale(cs);
			Sip sips[0]; sips=sipsMales;
			Vector3d vec = vecDir;
			double dThisGap= dGapTongue;//dZDepth+dGapOpp;
			Point3d ptStretch = ptRef;//+vec*dOverlap;
			for (int x=0;x<2;x++)
			{
				
				if (x==1 && dGapRef<0) // HSB-20569
					ptStretch -= vecDir * dGapRef;
				
				//ptStretch .vis(x);
				for (int i=0;i<sips.length();i++)
				{
					PlaneProfile pp(sips[i].plShadow());
					pp.createRectangle(pp.extentInDir(vecDir), vecDir, vecPerp);
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
								pts[p].vis(4);
								b=true;
							}
							bs.append(b);
						}
						for (int p=0;p<bs.length();p++)
							if (bs[p])
								pp.moveGripEdgeMidPointAt(p, vec*dThisGap);
					}
					
//					if(x==1)
//					{ Display dp(i); dp.draw(pp,_kDrawFilled,50);}
					
					
					
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
				//pps=ppFemales;
				vec*=-1;			
				ptStretch.transformBy(vec*(dOverlap-dGapTongue));
				sips=sipsFemales;
				dThisGap = 0;//dZDepth+dGapOpp;;
			}// next x

			ppMale.createRectangle(ppMale.extentInDir(vecDir), vecDir, vecPerp);
			ppFemale.createRectangle(ppFemale.extentInDir(vecDir), vecDir, vecPerp);
//			{ Display dp(1); dp.draw(ppMale,_kDrawFilled,50);}
//			{ Display dp(2); dp.draw(ppFemale,_kDrawFilled,50);}

			ppCommon = ppMale;
			
			
			ppCommon.intersectWith(ppFemale);
			//ppCommon.transformBy(vecZ*U(400));
			ppCommon.vis(20);
	
			//{ Display dp(6); dp.draw(ppCommon,_kDrawFilled,80);}
			
			LineSeg segCommon = ppCommon.extentInDir(vecPerp);	segCommon.vis(6);

		// get the extreme range
			segCommon=LineSeg(segCommon.ptMid()-vecPerp*U(10e5)-vecDir*ppCommon.dY(),segCommon.ptMid()+vecPerp*U(10e5)+vecDir*ppCommon.dY());
			{ 
				PlaneProfile pp;
				pp.createRectangle(segCommon, vecDir, vecPerp);
				//pp.vis(3);	
				
				PlaneProfile ppx(cs);
				PlaneProfile ppt = ppMale;
				ppt.intersectWith(pp);
				ppx.unionWith(ppt);
				
				ppt = ppFemale;
				ppt.intersectWith(pp);
				ppx.unionWith(ppt);
				
				ppx.vis(1);
				segCommon = ppx.extentInDir(vecPerp);
			}			
			
			
			
		}
		//else if (XXX==1)// butterfly dove
		//{
			//double dX = dZDepth+dGapOpp;
			//double dY = U(10e4);
			//PLine pl;
			//pl.createRectangle(LineSeg(_Pt0-vecDir*dX- vecPerp*dY,_Pt0+vecDir*dX+vecPerp*dY), vecDir, vecPerp);	
			//ppCommon = ppContour;
			//ppCommon.intersectWith(PlaneProfile(pl));
			
		//}
		LineSeg segCommon = ppCommon.extentInDir(vecPerp);	segCommon.vis(6);
		segCommon.vis(2);

		LineSeg segExtreme = segCommon;










//		{ 
//
//			
//			PLine pl;
//			pl.createRectangle(LineSeg(segCommon.ptStart()-vecPerp*U(10e4),segCommon.ptEnd()+vecPerp*U(10e4)), vecPerp, vecDir);//			pl.vis(3);
//			PlaneProfile ppExtr = ppContour;
//			ppExtr.intersectWith(PlaneProfile(pl));
//			
//		// get extents of profile
//			segExtreme = ppExtr.extentInDir(vecX);
//			double dX = abs(vecX.dotProduct(segExtreme.ptStart()-segExtreme.ptEnd()));
//			double dY = abs(vecY.dotProduct(segExtreme.ptStart()-segExtreme.ptEnd()));
//			ppExtr.vis(3);
//			
//		}








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
		ppCommon.vis(6);
		segCommon .vis(40);
	
	// remove any segment which is not intersecting the common range
		Point3d ptsCommon[] = {segCommon.ptStart(), segCommon.ptEnd()};
		ptsCommon = lnPerp.orderPoints(ptsCommon);
		
	// validate common range
		if (ptsCommon.length()<2)
		{
			reportMessage("\nno common range");
			
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

	// reset the overlap of dove if triggered by flip direction
		if (bResetOverlap)	dOverlap=dGapTongue;

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
				if (bDebug)reportMessage("\n male edges " + dOverlap+" " +dGapTongue);
				ptStretch.transformBy(vecDir*(dOverlap-dGapTongue));//));	//XX
				
				PLine(ptStretch, _PtW).vis(3);
				
			}
			if (x==1) 
			{
				sips= sipsFemales;
				edges=edgesFemales;
				
				if (dGapRef<0)// HSB-20569
					ptStretch.transformBy(-vecDir*dGapRef);
			}	
			
			for (int e=0; e<edges.length();e++)
			{
				SipEdge edge =edges[e];
				Vector3d vecNormal = edge.vecNormal();
				vecNormal = vecNormal.crossProduct(vecZ).crossProduct(-vecZ);

				if (sips.length()>e)
				{
					Plane pnStretch(ptStretch,-vecDir);
					Sip sip = sips[e];
					//if (bDebug)					reportNotice("\n" + sip.handle() + ": " +"stretch edge "+ e+ " to plane " +pnStretch);
					sip.stretchEdgeTo(edges[e].ptMid(),pnStretch);
					if (x==0)
					{ 
						vecNormal.vis(edges[e].ptMid(), 40);
						edges[e].vecNormal().vis(sip.ptCen(), x);						
					}

//					if (x==1)
//						edges[e].vecNormal().vis(edges[e].ptMid(), x);
				// reconstruct the opeings if flagged
					if (bReconstructOpening)
					{
						if (bDebug)reportMessage("\n" + sip.handle() + ": " +"reconstructing "+ plOpenings.length()+ " openings ");
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

	// display
		Display dpModel(_ThisInst.color()), dpPanel(_ThisInst.color());
		dpModel.addHideDirection(vecZ);
		dpModel.addHideDirection(-vecZ);
		dpPanel.addViewDirection(vecZ);
		dpPanel.addViewDirection(-vecZ);


// START TOOL ____________________________________________________________________________________________________ START TOOL	



	// add tongue/grooves, beamcuts and chamfers
		double dChamfers[] = {dChamferRef,dChamferOpp};
		double dGaps[] = {0,0};

		Vector3d vecXT = vecPerp;
		Vector3d vecYT = vecPerp.crossProduct(-vecDir);
		Vector3d vecZT = vecDir;	
		double dLength = abs(vecPerp.dotProduct(segCommon.ptStart()-segCommon.ptEnd()));
		//vecXT.vis(_Pt0,1);vecYT.vis(_Pt0,3);vecZT.vis(_Pt0,150);	 
	
		int nCncModes[] = {-3,-2};
		double dBcGaps[] = {dGapRef, dGapOpp};
		
		double dOffsetZ;
		if (nReference==0)
		{
			dOffsetZ =dZ-.5 * dWidthTongue-dReferenceOffset;// ref side
			dBcGaps.swap(0,1);
		}
		else if (nReference==1)
			dOffsetZ =.5 * dZ +dReferenceOffset;// axis
		else if (nReference==2)
			dOffsetZ =.5 * dWidthTongue+dReferenceOffset;//opp  side			
						
		double dOffsetZ2 =dOffsetZ+dInterdistance+dWidthTongue;
		if (nReference==0)
			dOffsetZ2 =dOffsetZ-dInterdistance-dWidthTongue;
		else if (nReference==1)
		{
			dOffsetZ = dReferenceOffset+.5*(dZ-dInterdistance-dWidthTongue);
			dOffsetZ2 =dOffsetZ+dInterdistance+dWidthTongue;
		}

	//region Display
		segExtreme.transformBy(vecZ * (vecZ.dotProduct(ptCen - segExtreme.ptMid()) + .5 * dZ));
		Point3d ptMidX = segExtreme.ptMid();

	// get splitsegments		
		LineSeg segs[] = ppContour.splitSegments(LineSeg(ptRef-vecPerp*U(10e4),ptRef+vecPerp*U(10e4)), true);
		dpModel.draw(segs);
		dpPanel.draw(segs);					
	//End Display//endregion 

	//region Tools
		PlaneProfile ppTool;
		ppTool.createRectangle(segExtreme, vecPerp, vecDir);
//		if (bDebug)
//		{ 
//			PlaneProfile pp = ppTool; pp.transformBy(vecZ*U(300)); pp.vis(3);
//			//pp = ppCommon;pp.transformBy(vecZ*U(400)); pp.vis(4);
//		}		
		double dXBc;	
		//double dYBc = dOverlap+dEps;		
		//double dZBc = dWidthTongue;	


	//region Tool on male sips
		Map mapSosus;
		for (int i=0;i<sipsMales.length();i++) 
		{ 
			Sip sip = sipsMales[i]; 
			PlaneProfile ppSip(sip.plShadow());
			
//			if (bDebug)
//			{ 
//				PlaneProfile pp = sip.realBody().shadowProfile(Plane(_Pt0, vecZView));
//				Display dp(1);
//				dp.draw(pp);
//				dp.draw(pp, _kDrawFilled, 80);
//			}
	
		// get extents of profile
			LineSeg segSip = ppSip.extentInDir(vecPerp);
			dXBc = abs(vecPerp.dotProduct(segSip.ptStart()-segSip.ptEnd()))+U(100); // HSB-20346

		// get tool location at relevant side
			Point3d pt = sip.ptCen();
			pt += vecDir * vecDir.dotProduct(ptRef - pt)+vecZ * (vecZ.dotProduct(ptCen -pt) + .5 * dZ);
			pt.vis(6);
			PLine(pt, sip.ptCen()).vis(i);
			
		//region Beamcuts
			Point3d ptBc = pt-vecZ*(dOffsetZ+(nReference==0?1:-1)*.5*dWidthTongue);	
			int nDirY = (nReference==0?1:-1);
			
			double dYBc = dZ;
			double dZBc = dZDepth + (dBcGaps[1]>0?dBcGaps[1]:0); // HSB-20569
			BeamCut bc1;
			if (dZBc > dEps && dXBc>dEps && dYBc>dEps && dZBc>dEps)
			{ 
				Point3d pt = ptBc-vecZT*(dBcGaps[1]>0?dBcGaps[1]:0);
				bc1 = BeamCut(pt,vecXT,vecYT,vecZT,dXBc,dYBc,dZBc,0,-nDirY,1);			
				bc1.cuttingBody().vis(i);
				sip.addTool(bc1);
			}
			
			// SolidSubtract	
			Point3d ptSosu = ptBc + nDirY * vecZ * (dWidthTongue + .5 * dInterdistance)-vecZT*dGapCen;
			Body bd2(ptSosu,vecXT,vecYT,vecZT,dXBc,dInterdistance,3*(dZDepth+dGapCen),0,0,1);
			if (!bd2.isNull())
			{ 
				bd2.vis(4);
				SolidSubtract sosu(bd2, _kSubtract);				
				{ 
					Body bdx(ptBc-vecZT*dGapCen,vecXT,vecYT,vecZT,dXBc+ U(200),dInterdistance,3*(dZDepth+dGapCen),0,0,1);
					Map m;
					m.setBody("SolidSubtract", bdx);
					m.setEntity("parent", _ThisInst);
					mapSosus.appendMap("Sosu", m);
				}
				if (dInterdistance>0)sip.addTool(sosu);	
			}

			Point3d ptBc3 = ptBc + nDirY * vecZ * (dWidthTongue + .5 * dInterdistance)-vecZT*dBcGaps[0];
			ptBc.transformBy(nDirY*vecZ *(dWidthTongue+.5*dInterdistance));			
			if (dInterdistance>0)ptBc3.transformBy(nDirY*vecZ *(dWidthTongue+.5*dInterdistance));			
			dZBc = dZDepth+dBcGaps[0];
			if (dXBc>dEps && dYBc>dEps && dZBc>dEps)
			{ 
				BeamCut bc3(ptBc3,vecXT,vecYT,vecZT,dXBc,dYBc,dZBc,0,nDirY,1);			
				bc3.cuttingBody().vis(3);		
				sip.addTool(bc3);				
			}

		//End Beamcuts//endregion 	

		//region Chamfer
		{ 
			int nDir=-1;
			Vector3d vecYC = vecDir;			
			Vector3d vecXC= vecYC.crossProduct(vecZ);	
			for (int c=0; c<dChamfers.length(); c++)
			{
				double dChamfer = dChamfers[c];
				double dThisGap = dGaps[c];
				if (dChamfer>dEps)
				{
					Point3d ptC = pt;
					ptC.transformBy(vecDir*vecDir.dotProduct(ptRef-ptC)+vecZ * (vecZ.dotProduct(ptCen-ptC)+nDir*.5*dZ));
					double dA = sqrt(pow((dChamfer+.5*dThisGap),2)/2);
					if (c==1)
						ptC.transformBy(-vecDir*(dGapOpp-dGapRef));// TODO
					CoordSys csRot;
					csRot.setToRotation(-45,vecXC ,ptC);
					
					BeamCut bc(ptC ,vecXC ,vecYC, vecZ, dXBc+U(100), dChamfer , dChamfer ,0,0,0);
					bc.transformBy(csRot);
					bc.cuttingBody().vis(3);
					sip.addTool(bc);
				}

				nDir*=-1;
			}// next i			
		}		
		//End Chamfer//endregion

		//region Tongue
			double dX = dXBc *.5 +  U(50);//TODO 
			PLine pl(vecZ);
			pl.addVertex(pt-vecPerp*dX);				
			pl.addVertex(pt+vecPerp*dX);
			pl.vis(6);	
		
			Point3d ptsClose[] = { pt + vecPerp * dX + vecDir * U(300), pt - vecPerp * dX + vecDir * U(300)};
			ptsClose[0].vis(1);
			ptsClose[1].vis(2);

			Point3d ptCutAway = pt+vecDir*(30*dZDepth+dEps)	;		 ptCutAway.vis(4);
			FreeProfile fp(pl,ptsClose);// ptCutAway );//HSB-18962
			fp.setDepth(dOffsetZ);
			fp.setCncMode(nCncModes[0]);
			fp. setCutDefiningAsOne(true);
			sip.addTool(fp);
			
		// double tool
			if (dInterdistance>0)
			{ 
				FreeProfile fp2(pl,ptsClose);// ptCutAway );//HSB-18962
				fp2.setDepth(dOffsetZ2);
				fp2.setCncMode(nCncModes[0]);
				fp2. setCutDefiningAsOne(true);
				sip.addTool(fp2);
			}	
		//End Tongue//endregion 
		
		}//next i			
	//End Tool on male sips//endregion 

	//region Tool on female sips
		for (int i = 0; i < sipsFemales.length(); i++)
		{
			Sip sip = sipsFemales[i];
			PlaneProfile ppSip(sip.plShadow());
			// get extents of profile
			LineSeg segSip = ppSip.extentInDir(vecPerp);
			dXBc = abs(vecPerp.dotProduct(segSip.ptStart() - segSip.ptEnd()));
			
			// get tool location at relevant side
			Point3d pt = sip.ptCen();
			pt += vecDir * vecDir.dotProduct(ptRef - pt)+vecZ * (vecZ.dotProduct(ptCen -pt) + .5 * dZ);
			pt.vis(6);
			PLine(pt, sip.ptCen()).vis(i);

			double dX = dXBc *.5 + U(50);// TODO 
			PLine pl(vecZ);
			pl.addVertex(pt-vecPerp*dX);				
			pl.addVertex(pt+vecPerp*dX);
			pl.transformBy(vecDir*dZDepth);
			if(dGapRef<0)pl.transformBy(-vecDir*dGapRef);// HSB-20569
			pl.vis(i);

		//region Chamfer
		{ 
			int nDir=-1;
			Vector3d vecYC = vecDir;			
			Vector3d vecXC= vecYC.crossProduct(vecZ);	
			for (int c=0; c<dChamfers.length(); c++)
			{
				double dChamfer = dChamfers[c];
				if (dChamfer>dEps)
				{
					Point3d ptC = pt;
					ptC.transformBy(vecDir*vecDir.dotProduct(ptRef-ptC)+vecZ * (vecZ.dotProduct(ptCen-ptC)+nDir*.5*dZ));
					ptC.transformBy(-vecDir*(dGapRef));
					double dA = sqrt(pow((dChamfer),2)/2);
					CoordSys csRot;
					csRot.setToRotation(-45,vecXC ,ptC);
					
					BeamCut bc(ptC ,vecXC ,vecYC, vecZ, dXBc+U(100), dChamfer , dChamfer ,0,0,0);
					bc.transformBy(csRot);
					bc.cuttingBody().vis(1);
					sip.addTool(bc);
				}
				

				nDir*=-1;
			}// next i			
		}		
		//End Chamfer//endregion

		//region Groove
			Point3d ptCutAwayFemale = pt-vecDir*(30*dZDepth+dEps)	;		 ptCutAwayFemale .vis(4);
			Point3d ptsClose[] = { pt + vecPerp * dX - vecDir * U(300), pt - vecPerp * dX - vecDir * U(300)};
			ptsClose[0].vis(1);
			ptsClose[1].vis(2);
			
			FreeProfile fp(pl,ptsClose);//ptCutAwayFemale );//HSB-18962
			fp.setDepth(dOffsetZ);
			fp.setCncMode(nCncModes[1]);
			fp. setCutDefiningAsOne(true);
			sip.addTool(fp);
			
			if (dInterdistance>0)
			{ 
				fp.setDepth(dOffsetZ2);
				fp.setCncMode(nCncModes[1]);
				sip.addTool(fp);				
			}				
		//End Groove//endregion 

		}
	//End Tool on female sips//endregion 
	
	//End Tools//endregion 	

// END TOOL ____________________________________________________________________________________________________END TOOL

	
	// declare axis locations for potential steel anchor lifting devices
		Point3d ptsMaleAxis[0], ptsFemaleAxis[0];
		
	
	
	// pline based display
		PLine plSymbol(vecPerp);
		
		Point3d pt=_Pt0+vecZ*(vecZ.dotProduct(ptCen-_Pt0)+.5*dZ);
		plSymbol.addVertex(pt-vecZ*dZ);
		plSymbol.addVertex(pt);
		pt.transformBy(-vecZ*dOffsetZ);
		plSymbol.addVertex(pt);
		pt.transformBy(vecDir*dZDepth);
		plSymbol.addVertex(pt);
		ptsMaleAxis.append(pt);	
		ptsFemaleAxis.append(pt);
		pt.transformBy(-vecDir*dZDepth);
		plSymbol.addVertex(pt);		

		if (dInterdistance>0)
		{
			pt.transformBy((nReference==0?1:-1)*vecZ*(dInterdistance+dWidthTongue));
			plSymbol.addVertex(pt);
			pt.transformBy(vecDir*dZDepth);
			plSymbol.addVertex(pt);pt.vis(4);
			ptsMaleAxis.append(pt);	
			ptsFemaleAxis[0].setToAverage(ptsMaleAxis);
			
			pt.transformBy(-vecDir*dZDepth);
			plSymbol.addVertex(pt);		
		}
		ptsFemaleAxis[0].transformBy(-vecDir*dZDepth);
		ptsFemaleAxis[0].vis(3);
		
		dpModel.draw(plSymbol);
		
		CoordSys	cs2Panel;
		cs2Panel.setToAlignCoordSys(_Pt0, vecDir, vecZ, vecDir.crossProduct(vecZ),_Pt0,  vecDir, vecPerp,vecZ);
		plSymbol.transformBy(cs2Panel);
		dpPanel.draw(plSymbol);//,_kDrawFilled);


	// collect shadow of males
	{ 
		Vector3d vecYS = vecDir.crossProduct(-vecPerp);
		CoordSys csSection(CoordSys(_Pt0, vecDir, vecYS, vecPerp));
		PlaneProfile ppSection(csSection);
		for (int i=0;i<sipsMales.length();i++) 
		{ 
			PlaneProfile pp = sipsMales[i].realBody().shadowProfile(Plane(ptRef,vecPerp)); 
			PLine plRings[] = pp.allRings(true,false);
			for (int r=0;r<plRings.length();r++)
				ppSection.joinRing(plRings[r],_kAdd);
			
		}//next i
		PlaneProfile ppBox;
		ppBox.createRectangle(LineSeg(ptRef + vecYS * dZ, ptRef - vecYS * dZ + vecDir * U(1000)), vecDir, vecYS);
		ppSection.intersectWith(ppBox);
		

		CoordSys csRot;
		csRot.setToRotation(90, vecDir, ptRef);
		ppSection.transformBy(csRot);
		ppSection.vis(2); 	
		for (int i=0;i<ptsCommon.length();i++) 
		{ 
			Point3d pt = ptsCommon[i] + vecDir * vecDir.dotProduct(ptRef - ptsCommon[i]);
			PlaneProfile pp = ppSection;
			
			pp.transformBy(pt - ptRef);
			pp.transformBy(vecPerp * (i==0?1:-1)*.5 * dZ);
			dpPanel.draw(pp, _kDrawFilled, 50);
			 
		}//next i
		
			
		
	}

	// Sectional gap display
	{ 

		Plane pn(_Pt0, vecPerp );
		PlaneProfile ppShadow(CoordSys(_Pt0, vecDir, vecZ, vecDir.crossProduct(vecZ)));
		for (int i=0;i<_Sip.length();i++) 
		{ 
			PlaneProfile pp =_Sip[i].realBody().shadowProfile(pn); 
			ppShadow.unionWith(pp); 
		}//next i
		ppShadow.shrink(-dEps);
		ppShadow.shrink(dEps);
		
		
		PlaneProfile ppBox; ppBox.createRectangle(LineSeg(_Pt0-vecDir*dZDepth-vecZ*U(10e3),_Pt0+vecDir*(2*dZDepth)+vecZ*U(10e3)), vecDir, vecZ); // ppBox.vis(4);
		PlaneProfile ppGap; ppGap.createRectangle(ppShadow.extentInDir(vecDir), vecDir, vecZ);
		ppGap.subtractProfile(ppShadow);
		ppGap.intersectWith(ppBox);
		vecPerp.vis(_Pt0, 1);
		Display dpSection(_ThisInst.color());
		dpSection.addViewDirection(vecPerp);
		dpSection.addViewDirection(-vecPerp);
		dpSection.draw(ppGap, _kDrawFilled, 80);
		dpSection.draw(ppGap);
		
		
		
	}






	// store previous location
		_Map.setVector3d("vecRef", _Pt0-_PtW);
		_Map.setDouble("previousZDepth", dOverlap);
		_Map.setDouble("previousZGap", dGapTongue);
		_Map.setDouble("previousRefGap", dGapRef);
		
		_Map.setPoint3dArray("maleLocations", ptsMaleAxis);
		_Map.setPoint3dArray("femaleLocations", ptsFemaleAxis);
		
		_Map.setEntityArray(sipsMales, true, "Male[]", "", "Male");
		_Map.setEntityArray(sipsFemales, true, "Female[]", "", "Female");
		_Map.setMap("SolidSubtract[]", mapSosus);
		
		//if(bDebug)reportMessage("\n" + _ThisInst.handle() + " ended " + _kExecutionLoopCount);
		//vecDir.vis(_Pt0,30);		
	}

		
// Panel Mode //endregion 

//region Wall Mode
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
			double dProps[]={dInterdistance,dReferenceOffset,dGapRef,dGapOpp,dChamferRef,dChamferOpp,dWidthTongue,dZDepth,dGapCen,dGapTongue};
			String sProps[]={sReference};
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

		
//Wall Mode //endregion 	





#End
#BeginThumbnail
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
27]S<1RWMZK[#D8%=#110!__9
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
        <int nm="BreakPoint" vl="1630" />
        <int nm="BreakPoint" vl="1678" />
        <int nm="BreakPoint" vl="297" />
        <int nm="BreakPoint" vl="269" />
        <int nm="BreakPoint" vl="265" />
        <int nm="BreakPoint" vl="565" />
        <int nm="BreakPoint" vl="1221" />
        <int nm="BreakPoint" vl="1288" />
        <int nm="BreakPoint" vl="1108" />
        <int nm="BreakPoint" vl="1129" />
        <int nm="BreakPoint" vl="1135" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20692 common range detection on complex triangular shapes" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="11/21/2023 4:10:21 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20569 negative reference gap creates gap between panels, requires hsbDesign 26 or higher" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="11/6/2023 3:54:45 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20346 extending tongue/groove fixed, edit in place disabled" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="10/16/2023 9:43:38 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19015 data for subnesting process published" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="5/23/2023 8:49:13 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18962 solid display improved" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="5/12/2023 12:13:53 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-7981 tool will not be splitted by potential envelope intersections, requires 23.4.18 or higher" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="5/10/2021 9:10:39 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End