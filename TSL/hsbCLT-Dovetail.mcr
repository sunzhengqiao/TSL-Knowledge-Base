#Version 8
#BeginDescription
version value="1.4" date="12dec17" author="thorsten.huck@hsbcad.com"
helper beamcuts do not export to any machine


/// This tsl defines a dove tail connection or a butterfly spline on an edge between at least two panels. On insert it may create a split if only one panel was selected.
/// The closest point to the main contour in relation to the reference point (_Pt0) defines the edge where the joint is 
/// assigned to.

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords 
#BeginContents
/// <History>//region
///<version value="1.4" date="12dec17" author="thorsten.huck@hsbcad.com"> helper beamcuts do not export to any machine </version>
///<version value="1.3" date="24may17" author="thorsten.huck@hsbcad.com"> article name of hardware changed to X-fix L </version>
/// </History>

/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates a dove tail connection between two panels
/// </summary>//endregion






//constants
	Unit(1,"mm"); // script uses mm
	double dEps=U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;		
	String sDoubleClick= "TslDoubleClick";	
	int bDebug;//_bOnDebug;//=true;
	int bLog;//=true;
	int bDebugMapIO;//=true;
	if (bLog)reportMessage("\n\n***" + scriptName() + " starting");
	
// geometry
	String sCategoryGeo = T("|Geometry|");
		
	String sWidthName="(A)  " + T("|Width|");	
	PropDouble dXWidth(nDoubleIndex++, U(50), sWidthName);
	dXWidth.setDescription(T("|Defines the depth of the lap joint seen from reference side|") + " " + T("|0 = 50% of thickness|"));
	dXWidth.setCategory(sCategoryGeo );		
	
	String sZDepthName="(B)  " + T("|Depth|");
	PropDouble dZDepth(nDoubleIndex++, U(28),sZDepthName);
	dZDepth.setDescription(T("|Defines the width of the lap joint of the main panel|"));
	dZDepth.setCategory(sCategoryGeo );

	String sNameAlfa="(C)  " + T("|Angle|");
	PropDouble dAlfa(nDoubleIndex++, U(0),sNameAlfa,_kAngle);
	dAlfa.setDescription(T("|Defines the angle dovetail.|"));
	dAlfa.setCategory(sCategoryGeo );

	String sNameGap="(D)  " + T("|Gap|") + " X";
	PropDouble dGap(nDoubleIndex++,U(1), sNameGap);
	dGap.setDescription(T("|Defines the gap in depth.|"));
	dGap.setCategory(sCategoryGeo );
	
// Alignment	
	String sCategoryAlignment = T("|Alignment|");
	String sNameAxisOffset="(E)  " + T("|Axis Offset|") + " X";
	PropDouble dAxisOffset(nDoubleIndex++,U(0), sNameAxisOffset);
	dAxisOffset.setDescription(T("|Defines horizontal offset of the tool.|"));
	dAxisOffset.setCategory(sCategoryAlignment);

	String sNameBottomOffset="(F)  " + T("|Bottom Offset|");
	PropDouble dBottomOffset(nDoubleIndex++,U(0), sNameBottomOffset);
	dBottomOffset.setDescription(T("|Defines bottom offset of the tool.|") + " " + T("|0 = complete through|"));
	dBottomOffset.setCategory(sCategoryAlignment);
	
// general
	String sDoveModeName="(G)  " + T("|Connection Type|");	
	String sDoveModes[] = {T("|Dovetail|"), T("|Butterfly Spline|")};
	PropString sDoveMode(nStringIndex++, sDoveModes, sDoveModeName,0);	
	sDoveMode.setDescription(T("|Specifies if the dove is added to the male set or if two female doves are added"));

// chamfer
	String sCategoryRef = T("|Reference Side|");
	String sChamferRefName="(H)  "+T("|Chamfer|");
	PropDouble dChamferRef(nDoubleIndex++, U(0), sChamferRefName);
	dChamferRef.setCategory(sCategoryRef);

	String sCategoryOpp = T("|opposite side|");
	String sChamferOppName="(I)  "+T("|Chamfer|");
	PropDouble dChamferOpp(nDoubleIndex++, U(0), sChamferOppName);
	dChamferOpp.setCategory(sCategoryOpp );


// on mapIO
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
//_______________________________________________________________
//_______________________________________________________________



// on insert
	if (_bOnInsert)
	{
			
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
				setPropValuesFromCatalog(T("|_LastInserted|"));					
		}
		else
			showDialogOnce();		

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
			return	
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
			double dProps[]={dXWidth,dZDepth ,dAlfa ,dGap ,dAxisOffset ,dBottomOffset ,dChamferRef ,dChamferOpp};
			String sProps[]={sDoveMode};
			Map mapTsl;
			mapTsl.setInt("mode", 1);// panel mode
			String sScriptname = scriptName();		
		
		// retrieve connection data		
			Map mapIO;
			mapIO.setDouble("XRange",dZDepth);
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
// end on insert_______________________________________________________________________________________________________________
// ____________________________________________________________________________________________________________________________

// get mode
	if (bLog)reportMessage("\n	" + _ThisInst.handle() + "(" + _kExecutionLoopCount + ")");
	int nMode = _Map.getInt("mode");
	// 0 = wall mode
	// 1 = panel mode

	int nDoveMode=sDoveModes.find(sDoveMode,0);
	// 0 = Dovetail
	// 1 = Butterfly Spline

// mode 1: panel mode
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
		if (nDoveMode==0) // dovetail mode
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
		if (nDoveMode==1)dOverlap=0;// 1 = Butterfly Spline
		
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
		if (_bOnRecalc && _kExecuteKey==sTriggerFlipDirection )
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
		ppContour.vis(2);		

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
		if (_kNameLastChangedProp==sZDepthName || _kNameLastChangedProp==sDoveModeName)
		{
			double dPervious = _Map.getDouble("previousZDepth");
			Point3d ptRefThis = ptRef-vecDir*dPervious ;
			dZDepthRef =dPervious ;
			bReconstructOpening=true;
		}		

	// update graphics
	 	if(_kNameLastChangedProp==sDoveModeName)
			setExecutionLoops(2);


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
				int bMaleTest = abs(dDist-dZDepthRef)<dEps;
				int bFemaleTest = abs(dDist)<dEps;
				
				int bIsParallel = vecDir.isParallelTo(vecNormal) || 1-abs(vecNormal.dotProduct(vecDir))<0.0001;
				
				if (!bIsParallel || (!bMaleTest && !bFemaleTest))
				{
					//vecNormal.vis(edge.ptMid(),i+1);
					edges.removeAt(e);
					continue;
				}					
				
				
				//double dDist = vecDir.dotProduct(edge.ptMid()-ptRef);
				//double dDist2 = abs(dZDepthRef +dDist);
				//int bIsParallel = vecDir.isParallelTo(vecNormal) || 1-abs(vecNormal.dotProduct(vecDir))<0.0001;

				//if (!bIsParallel || (abs(dDist)>dEps &&  abs(dZDepthRef +dDist)>dEps))
				//{
					//vecNormal.vis(edge.ptMid(),i+1);
					//edges.removeAt(e);
					//continue;
				//}
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
		
	// erase male only connections
		if (sipsMales.length()>1 && sipsFemales.length()<1)
		{
			reportMessage("\n" + T("|Two male panels cannot be connected.|") + " " + T("|Tool will be deleted.|"));
			//eraseInstance();
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
		if (nDoveMode==0)// male/female dove
		{
			PlaneProfile pp(cs), ppMale(cs), ppFemale(cs);
			Sip sips[0]; sips=sipsMales;
			Vector3d vec = vecDir;
			double dThisGap= 0;//dZDepth+dGap;
			Point3d ptStretch = ptRef;//+vec*dOverlap;
			for (int x=0;x<2;x++)
			{
				ptStretch .vis(x);
				for (int i=0;i<sips.length();i++)
				{
					PlaneProfile pp(sips[i].plShadow());
					
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
				ptStretch.transformBy(vec*dOverlap);
				sips=sipsFemales;
				dThisGap = 0;//dZDepth+dGap;;
			}// next x

			ppCommon = ppMale;
			ppCommon.intersectWith(ppFemale);
			//ppCommon.transformBy(vecZ*U(400));
			ppCommon.vis(20);
		}
		else if (nDoveMode==1)// butterfly dove
		{
			double dX = dZDepth+dGap;
			double dY = U(10e4);
			PLine pl;
			pl.createRectangle(LineSeg(_Pt0-vecDir*dX- vecPerp*dY,_Pt0+vecDir*dX+vecPerp*dY), vecDir, vecPerp);	
			ppCommon = ppContour;
			ppCommon.intersectWith(PlaneProfile(pl));
			
		}
		LineSeg segCommon = ppCommon.extentInDir(vecPerp);	segCommon.vis(6);

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
		if (bResetOverlap)	dOverlap=0;

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
					Plane pnStretch(ptStretch,-vecDir);
					Sip sip = sips[e];
					if (bDebug)reportMessage("\n" + sip.handle() + ": " +T("|stretch edge|") + " " + e+ " to plane " +pnStretch);
					sip.stretchEdgeTo(edges[e].ptMid(),pnStretch);
					edges[e].vecNormal().vis(edges[e].ptMid(), x);
					edges[e].vecNormal().vis(sip.ptCen(), x);
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

// START TOOL ____________________________________________________________________________________________________ START TOOL	
	// add doves and chamfers
		double dChamfers[] = {dChamferRef,dChamferOpp};
		double dGaps[] = {0,0};

		Vector3d vecXDv = vecPerp.crossProduct(-vecDir);
		Vector3d vecYDv = vecPerp;
		Vector3d vecZDv = vecDir;	
		double dYHeight = abs(vecPerp.dotProduct(segCommon.ptStart()-segCommon.ptEnd()));
		//vecXDv.vis(_Pt0,1);vecYDv.vis(_Pt0,3);vecZDv.vis(_Pt0,150);	 
		
		double dTotalToolLength; // collector for the total tool length to quantify the butterfly spline
		
	// add male dove over entire edge 
		if (nDoveMode==0 && dOverlap >0)
		{
			Point3d pts[] = {segCommon.ptStart(),segCommon.ptEnd()};
			Point3d ptTool;
			ptTool.setToAverage(pts);
			ptTool.transformBy(vecZ*(vecZ.dotProduct(ptCen-ptTool)+dAxisOffset));
			ptTool.transformBy(vecDir*vecDir.dotProduct(ptRef-ptTool));
			ptTool.transformBy(vecPerp*(.5*dYHeight));//+vecDir*dOverlap);//XX -vecDir*dOverlap
			dYHeight -=dBottomOffset;
			ptTool.vis(3);
			if (dAlfa<dEps && dBottomOffset<dEps)	dYHeight*=2;
			
		// add temporarly a beamcut until copyEraseWithBeams honours dove tools	
			BeamCut bc(ptTool,vecXDv,vecYDv,-vecZDv,dXWidth,dYHeight,dZDepth+dGap,1,-1,-1);
			bc.transformBy(vecXDv*.8*dXWidth);
			bc.excludeMachineForCNC(_kAnyMachine);
			//bc.cuttingBody().vis(40);			
			
			Dove dvMale(ptTool,vecXDv,vecYDv,vecZDv,dXWidth,dYHeight,dZDepth, dAlfa,_kMaleEnd);
			if (dAlfa<dEps && dBottomOffset<dEps)dvMale.setContinuousMortise(true);
			for (int s=0;s<sipsMales.length();s++)
			{
				sipsMales[s].addTool(dvMale);			
				sipsMales[s].addTool(bc);					
			}
		}
	
	// add tools per ring
		plRings = ppCommon.allRings();
		bIsOp = ppCommon.ringIsOpening();
		int nNumAllowedGrips;
		for (int r=0; r<plRings.length();r++)
		{
			if (bIsOp[r])continue;
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
			
	
			Point3d ptTool;
			ptTool.setToAverage(pts);
			ptTool.transformBy(vecZ*(vecZ.dotProduct(ptCen-ptTool)+dAxisOffset));
			ptTool.transformBy(vecDir*vecDir.dotProduct(ptRef-ptTool));

	
			double dXBc = abs(vecPerp.dotProduct(pts[0]-pts[pts.length()-1]));	
			double dYBc = dOverlap+dEps;		
			double dZBc = dXWidth;
			dYHeight = dXBc-dBottomOffset;
			dTotalToolLength +=dXBc;

			ptTool.transformBy(vecPerp*(.5*dXBc));//+vecDir*dOverlap);//;;
			ptTool.vis(4);
			Vector3d vecXBc = vecDir.crossProduct(vecZ);
		
		// add temporarly a beamcut until copyEraseWithBeams honours dove tools
			BeamCut bc(ptTool,vecXDv,vecYDv,-vecZDv,dXWidth,dYHeight,dZDepth+dGap,0,-1,0);
			bc.excludeMachineForCNC(_kAnyMachine);
			//bc.cuttingBody().vis(4);
	
		// male and female dove	
			if (nDoveMode==0 && dXWidth>dEps && dYHeight>dEps && dZDepth>dEps &&  dOverlap >0)
			{
				
								
				//if (dAlfa<dEps && dBottomOffset<dEps)	dYHeight*=2;
				//Dove dvMale(ptTool,vecXDv,vecYDv,vecZDv,dXWidth,dYHeight,dZDepth, dAlfa,_kMaleEnd);
				//if (dAlfa<dEps && dBottomOffset<dEps)dvMale.setContinuousMortise(true);
				//for (int s=0;s<sipsMales.length();s++)
					//sipsMales[s].addTool(dvMale);

				Dove dvFemale(ptTool,vecXDv,vecYDv,vecZDv,dXWidth,dYHeight,dZDepth+dGap, dAlfa,_kFemaleEnd);
				if (dAlfa<dEps && dBottomOffset<dEps)dvFemale.setContinuousMortise(true);
				for (int s=0;s<sipsFemales.length();s++)
				{
					sipsFemales[s].addTool(dvFemale);
					sipsFemales[s].addTool(bc);					
				}

			}	
		// butterfly dove
			if (nDoveMode==1 && dXWidth>dEps && dYHeight>dEps && dZDepth>dEps)
			{
				Dove dvMale(ptTool,vecXDv,vecYDv,-vecZDv,dXWidth,dYHeight,dZDepth+dGap, dAlfa,_kFemaleEnd);
				if (dAlfa<dEps && dBottomOffset<dEps)
				{
					dvMale.setContinuousMortise(true);
				}
				for (int s=0;s<sipsMales.length();s++)
				{
					sipsMales[s].addTool(dvMale);
					sipsMales[s].addTool(bc);					
				}

				Dove dvFemale(ptTool,vecXDv,vecYDv,vecZDv,dXWidth,dYHeight,dZDepth+dGap, dAlfa,_kFemaleEnd);
				if (dAlfa<dEps && dBottomOffset<dEps)dvFemale.setContinuousMortise(true);
				for (int s=0;s<sipsFemales.length();s++)
				{
					sipsFemales[s].addTool(dvFemale);
					sipsFemales[s].addTool(bc);					
				}					
					
			}	
					
		// add chamfers
			int nDir=-1;
			Vector3d vecDirChamf = vecDir;
			//if (bFlipSide)
			//{
				//vecDirChamf *=-1;
				//ptTool.transformBy(vecDirChamf*dWidth);
			//}	
			vecXBc= vecZ.crossProduct(vecDirChamf);	
			for (int i=0; i<dChamfers.length(); i++)
			{
				double dChamfer = dChamfers[i];
				double dGap = dGaps[i];
				if (dChamfer<=dEps)
				{
					//ptTool.transformBy(-vecDirChamf*dOverlap);
					nDir*=-1;
					continue;
				}
				
				Point3d pt = ptTool;
				pt.transformBy(vecZ * (vecZ.dotProduct(ptCen-pt)+nDir*.5*dZ));
				double dA = sqrt(pow((dChamfer+.5*dGap),2)/2);
				pt.transformBy(vecZ*-nDir*dA);
				pt.transformBy(vecDirChamf*-nDir*.5* dGap);
				pt.vis(7);
				CoordSys csRot;
				csRot.setToRotation(-45,vecXBc ,pt);
				
				BeamCut bc(pt ,vecXBc ,vecDirChamf, vecZ, dXBc, dChamfer*2 , dChamfer*2 ,-1,nDir,nDir);
				bc.transformBy(csRot);
				//bc.cuttingBody().vis(0);
				bc.excludeMachineForCNC(_kAnyMachine);
				bc.addMeToGenBeamsIntersect(_Sip);
				
				//ptTool.transformBy(-vecDirChamf*dOverlap);
				pt.vis(6);
				nDir*=-1;
			}// next i			
			
		}// next r of rings END beamcuts
// END TOOL ____________________________________________________________________________________________________END TOOL

	// display
		Display dpModel(_ThisInst.color()), dpPanel(_ThisInst.color());
		dpModel.addHideDirection(vecZ);
		dpModel.addHideDirection(-vecZ);
		dpPanel.addViewDirection(vecZ);
		dpPanel.addViewDirection(-vecZ);
		
	// SYMBOL draw plan view symbol
		Vector3d vecXS = vecZ, vecYS=vecDir;
		double dD = U(2);
		Point3d ptRefSym = _Pt0;
		//if (nDoveMode==0)ptRefSym .transformBy(-vecDir*dZDepth);
		if (bDebug)reportMessage("\n" + scriptName() + " vecPerp " + vecPerp + " vecDir: " +vecDir);
	// some more vecs
		CoordSys csRot;
		csRot.setToRotation(14.99, vecPerp, ptRefSym);
		Vector3d vecAlfa1=vecDir ;
		vecAlfa1.transformBy(csRot);	vecAlfa1.vis(ptRefSym,4);
		csRot.setToRotation(-14.99, vecPerp, ptRefSym);
		Vector3d vecAlfa2=vecDir ;
		vecAlfa2.transformBy(csRot);	vecAlfa2.vis(ptRefSym,4);	

		Plane pnZ(ptRefSym,vecDir);
		PLine plSymbol;
		Point3d ptX;

		ptX = ptRefSym-vecXS*.5*dXWidth;						plSymbol.addVertex(ptX);
		if (Line(ptX, vecAlfa1).hasIntersection(pnZ))	plSymbol.addVertex(Line(ptX, vecAlfa1).intersect(pnZ, dZDepth));
		ptX = ptRefSym+vecXS*.5*dXWidth;
		if (Line(ptX, vecAlfa2).hasIntersection(pnZ))	plSymbol.addVertex(Line(ptX, vecAlfa2).intersect(pnZ, dZDepth));
		ptX = ptRefSym+vecXS*.5*dXWidth;						plSymbol.addVertex(ptX);

		// offseted symbol
		ptX = ptRefSym+vecXS*(.5*dXWidth-dD);				plSymbol.addVertex(ptX);//plSymbol.vis(3);
		plSymbol.addVertex(Line(ptX, vecAlfa2).intersect(pnZ, dZDepth-dD));
		ptX = ptRefSym-vecXS*(.5*dXWidth-dD);				plSymbol.addVertex(Line(ptX, vecAlfa1).intersect(pnZ, dZDepth-dD));
		plSymbol.addVertex(ptX);
		plSymbol.close();
	
		PlaneProfile ppSymbol(plSymbol);		
		if (nDoveMode==1)
		{
			CoordSys	csMirr;
			csMirr.setToMirroring(pnZ);	
			PlaneProfile pp = ppSymbol;
			pp.transformBy(csMirr);
			ppSymbol.unionWith(pp);
			ppSymbol.shrink(-dEps);
			ppSymbol.shrink(dEps);
			
		// rebuild from vertices to get filled symbol
			PLine plRings[] = ppSymbol.allRings();
			int bIsOp[] = ppSymbol.ringIsOpening();
			for (int r=0;r<plRings.length();r++)
				if(!bIsOp[r])
				{
					ppSymbol=PlaneProfile(plRings[r]);
					break;	
				}	
			
		// subtract inner
			PlaneProfile ppSub = ppSymbol;
			ppSub.shrink(dD);
			ppSymbol.subtractProfile(ppSub);	
				
		}
		ppSymbol.transformBy(vecZ*dAxisOffset);
		dpModel.draw(ppSymbol,_kDrawFilled);	
		
		CoordSys	cs2Panel;
		cs2Panel.setToAlignCoordSys(ptRefSym, vecXS, vecYS, vecXS.crossProduct(vecYS),ptRefSym, vecPerp, vecDir, -vecZ);
		ppSymbol.transformBy(cs2Panel);
		dpPanel.draw(ppSymbol,_kDrawFilled);

	// draw reference and opposite side with optional chamfers
		int nDir=1;
		double dDir=dZDepth+dGap;
		for (int i=0;i<dChamfers.length();i++)
		{
			double dChamfer = dChamfers[i];
			double dA = sqrt(pow((dChamfer),2)/2);
			PLine pl(vecPerp);
		// draw panel edges and close symbol contour
			if (i==1)pl.addVertex(ptRefSym+nDir*vecZ*.5*dZ+vecDir*(dZDepth+dGap));			
			pl.addVertex(ptRefSym-nDir*vecZ*.5*dZ+vecDir*(dZDepth+dGap));
			
			if (dChamfer >dEps)
			{
				pl.addVertex(ptRefSym-nDir*vecZ*.5*dZ+vecDir*dA);
				pl.addVertex(ptRefSym-nDir*vecZ*(.5*dZ-dA));
				pl.addVertex(ptRefSym-nDir*vecZ*.5*dZ-vecDir*dA);
			}
			if (nDoveMode==0)dDir=dA ;
			pl.addVertex(ptRefSym-nDir*vecZ*.5*dZ-vecDir*dDir);
		// draw panel edges and close symbol contour
			if (i==1)pl.addVertex(ptRefSym+nDir*vecZ*.5*dZ-vecDir*dDir);			
			
			pl.transformBy(cs2Panel);
			if (i==0)dpPanel.color(5);
			else dpPanel.color(_ThisInst.color());	
			dpPanel.draw(pl);
			nDir*=-1;	
		}

	// set hardware when butterfly spline is selected
		if (nDoveMode==1)
		{		
			HardWrComp hwComps[0];
			String sArticle=T("|X-fix L|");

			HardWrComp hw(sArticle, 1);	
			hw.setCategory(T("|Connector|"));
			hw.setManufacturer("Greenethic");
			hw.setModel(sArticle + dZDepth + " x " + dXWidth);
			hw.setMaterial("");
			hw.setDescription(sArticle);
			hw.setDScaleX(dTotalToolLength);
			hw.setDScaleY(dXWidth);
			hw.setDScaleZ(dZDepth*2);	
			hwComps.append(hw);
	
			_ThisInst.setHardWrComps(hwComps);		
		}
	// reset any hardware entry for regular dovetails
		else if (_ThisInst.hardWrComps().length()>0)
		{
			HardWrComp hwComps[0];
			_ThisInst.setHardWrComps(hwComps);
		}

//XX
		//if (_bOnRecalc && _kExecuteKey==sTriggerFlipDirection )
		//{
			//vecDir*=-1;
			//_Map.setVector3d("vecDir", vecDir);
			//setExecutionLoops(2);
			//dOverlap=_Map.getDouble("previousZDepth");
		//}


	// store previous location
		_Map.setVector3d("vecRef", _Pt0-_PtW);
		_Map.setDouble("previousZDepth", dOverlap);
		//if(bDebug)reportMessage("\n" + _ThisInst.handle() + " ended " + _kExecutionLoopCount);
		//vecDir.vis(_Pt0,30);		
	}


// END IF PANEL MODE  ___________  END IF PANEL MODE  ___________  END IF PANEL MODE  ___________  END IF PANEL MODE  ___________  END IF PANEL MODE  
	
		
// start wall mode	
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
			double dProps[]={dXWidth,dZDepth ,dAlfa ,dGap ,dAxisOffset ,dBottomOffset ,dChamferRef ,dChamferOpp};
			String sProps[]={sDoveMode};
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
#End
#BeginThumbnail
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
6!A6GAP0WD=W/=R2RHV1D5NT44`?_V3C*
`




#End