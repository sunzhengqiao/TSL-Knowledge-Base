#Version 8
#BeginDescription
#Versions:
1.6 15.12.2021 HSB-13767: improve segments at lapjoints Author: Marsel Nakuci
1.5 27.10.2021 HSB-12605: group assignment, fix lap joint, add display maps in xml Author: Marsel Nakuci
1.4 05.10.2021 HSB-12605: apply distribution rules;write hardware;write mapXData Author: Marsel Nakuci
1.3 30.09.2021 HSB-12605: keep reference when moving panel; speedup calculation Author: Marsel Nakuci
1.2 30.09.2021 HSB-12605: support arches and multiple faces at one edge Author: Marsel Nakuci
1.1 27.09.2021 HSB-12605: add jigging and dragging Author: Marsel Nakuci
1.0 27.09.2021 HSB-12605: initial working version Author: Marsel Nakuci



This tsl creates Tapes at panel edges.
When multiple panels are included in the selectio set then the TSL
will insert one TSL instance for each panel and add the tapes
at the panel edges according to an "Automatic" mode
When only one panel is included in the selection set then the TSL
will prompt to select edge where the tape will be  "manualy" inserted.
The "Automatic" mode TSL can be "exploded" into multiple TSL instances
for each edge
The TSL requirex an xml file "TapeCatalog.xml"


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 6
#KeyWords Tape;CLT
#BeginContents
//region <History>
// #Versions
// Version 1.6 15.12.2021 HSB-13767: improve segments at lapjoints Author: Marsel Nakuci
// Version 1.5 27.10.2021 HSB-12605: group assignment, fix lap joint, add display maps in xml Author: Marsel Nakuci
// Version 1.4 05.10.2021 HSB-12605: apply distribution rules;write hardware;write mapXData Author: Marsel Nakuci
// Version 1.3 30.09.2021 HSB-12605: keep reference when moving panel; speedup calculation Author: Marsel Nakuci
// Version 1.2 30.09.2021 HSB-12605: support arches and multiple faces at one edge Author: Marsel Nakuci
// Version 1.1 27.09.2021 HSB-12605: add jigging and dragging Author: Marsel Nakuci
// Version 1.0 27.09.2021 HSB-12605: initial working version Author: Marsel Nakuci

/// <insert Lang=en>
/// Select panels, enter TSL
/// </insert>

// <summary Lang=en>
// This tsl creates Tapes at panel edges.
// When multiple panels are included in the selectio set then the TSL
// will insert one TSL instance for each panel and add the tapes
// at the panel edges according to an "Automatic" mode
// When only one panel is included in the selection set then the TSL
// will prompt to select edge where the tape will be  "manualy" inserted.
// The "Automatic" mode TSL can be "exploded" into multiple TSL instances
// for each edge
// The TSL requirex an xml file "TapeCatalog.xml"
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCLT-Tape")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|Edit in Place|"))) TSLCONTENT
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
//end Constants//endregion

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="TapeCatalog";
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

//region Default display parameters
Map mapDisplays = mapSetting.getMap("Display[]");
int iColorDefault = 1;
int iTransparencyDefault = 75;
double dTapeWidthFrontDefault = U(3);

Map mapDisplayDefault;
for (int imap=0;imap<mapDisplays.length();imap++) 
{ 
	Map m = mapDisplays.getMap(imap);
	
	if(m.hasInt("NrTapesEdge") && m.getInt("NrTapesEdge")==0)
	{ 
		{
			
			String k;
			k = "Color";if (m.hasInt(k))iColorDefault = m.getInt(k);
			k = "Transparency";if (m.hasInt(k))iTransparencyDefault = m.getInt(k);
			k = "TapeWidthFront";if (m.hasDouble(k))dTapeWidthFrontDefault = m.getDouble(k);
		}
		break;
	}
}//next imap

//Map mapDisplay = mapSetting.getMap("Display");
//int iColorDefault = mapDisplay.getInt("Color");
//int iTransparencyDefault = mapDisplay.getInt("Transparency");
//double dTapeWidthFront = mapDisplay.getDouble("TapeWidthFront");
//End Default display parameters//endregion 

//region Jig
	String strJigAction1 = "strJigAction1";
	String strJigAction2 = "strJigAction2";
	if (_bOnJig && (_kExecuteKey == strJigAction1 
		|| _kExecuteKey == strJigAction2))
	{
//		//
		Display dpModelHighlight(iColorDefault);
		dpModelHighlight.transparency(iTransparencyDefault);
		Display dpFrontHighlight(iColorDefault);
		dpFrontHighlight.transparency(iTransparencyDefault);
//		//
		Point3d ptJig = _Map.getPoint3d("_PtJig");
		Entity entSip = _Map.getEntity("sip");
		Sip sip = (Sip)entSip;
		Point3d ptCen = sip.ptCen();
		Vector3d vecZ = sip.vecZ();
		Vector3d vecY = sip.vecY();
		Vector3d vecX = sip.vecX();
		dpFrontHighlight.addViewDirection(vecZ);
		dpFrontHighlight.addViewDirection(-vecZ);
		dpFrontHighlight.addHideDirection(vecX);
		dpFrontHighlight.addHideDirection(-vecX);
		dpFrontHighlight.addHideDirection(vecY);
		dpFrontHighlight.addHideDirection(-vecY);
		Vector3d vecView = getViewDirection();
		vecView.normalize();
		Plane pnCen(ptCen, vecZ);
		Line lnView(ptJig, vecView);
		lnView.hasIntersection(pnCen, ptJig);
		Map mapEdges = _Map.getMap("Edges");
		PLine plsAll[0];
		for (int iedge=0;iedge<mapEdges.length();iedge++) 
		{ 
			Map mapEdgeI = mapEdges.getMap(iedge);
			PLine plI = mapEdgeI.getPLine("Pline");
			plsAll.append(plI);
		}//next iedge
		
		int iEdgeClosest = -1;
		double dDistClosest = U(10e6);
		Point3d ptCheck = ptJig;
		for (int ipl=0;ipl<plsAll.length();ipl++) 
		{ 
			Map mapEdgeI = mapEdges.getMap(ipl);
			int iStraight = mapEdgeI.getInt("Straight");
			
			PLine plI = plsAll[ipl];
			Point3d pts[] = plI.vertexPoints(true);
			Point3d pt1 = pts[0];
			Point3d pt2 = pts[1];
			Point3d ptMid = .5 * (pt1 + pt2);
			Vector3d vecDir = pt2 - pt1;
			vecDir.normalize();
			Line ln(ptMid, vecDir);
			Point3d ptClosestLineI = ln.closestPointTo(ptCheck);
			// check that ptClosestI inside the edge
			double dLengthPtI=abs(vecDir.dotProduct(ptClosestLineI-pt1))
				 + abs(vecDir.dotProduct(ptClosestLineI - pt2));
			double dLengthSeg = abs(vecDir.dotProduct(pt1 - pt2));
			if (abs(dLengthPtI - dLengthSeg) > dEps)continue;
			
//			double dDistClosestI = plI.getDistAtPoint(ptJig);
			Point3d ptClosestI = plI.closestPointTo(ptCheck);
			double dDistClosestI = (ptClosestI-ptCheck).length();
			
			if(dDistClosestI<dDistClosest)
			{ 
				dDistClosest = dDistClosestI;
				iEdgeClosest = ipl;
			}
		}//next ipl
		if (iEdgeClosest < 0 )
		{
//			dpHighlight.draw("No Edge found", ptJig, _XW, _YW, 0, 0, _kDeviceX);
			dpModelHighlight.draw("No Edge found", ptJig, _XW, _YW, 0, 0, _kDeviceX);
			return;
		}
		
		Map mapEdgeClosest = mapEdges.getMap(iEdgeClosest);
		Map mapProfilesClosest = mapEdgeClosest.getMap("pps");
		Map mapProfilesClosestTop = mapEdgeClosest.getMap("ppsTop");
		for (int iMapPp=0;iMapPp<mapProfilesClosest.length();iMapPp++) 
		{ 
			Map mapPpI = mapProfilesClosest.getMap(iMapPp);
			if(mapPpI.hasPlaneProfile("pp"))
			{ 
				PlaneProfile ppEdge = mapPpI.getPlaneProfile("pp");
//				dpHighlight.draw(ppEdge, _kDrawFilled);
				dpModelHighlight.draw(ppEdge, _kDrawFilled);
			}
			else
			{ 
				for (int _ipp=0;_ipp<mapPpI.length();_ipp++) 
				{ 
					Map _mapPpI = mapPpI.getMap(_ipp);
					PlaneProfile _ppI = _mapPpI.getPlaneProfile("pp");
//					dpHighlight.draw(_ppI,_kDrawFilled);
					dpModelHighlight.draw(_ppI,_kDrawFilled);
				}//next _ipp
			}
		}//next iMpaPp
		for (int iMapPp=0;iMapPp<mapProfilesClosestTop.length();iMapPp++) 
		{ 
			Map mapPpI = mapProfilesClosestTop.getMap(iMapPp);
			if(mapPpI.hasPlaneProfile("pp"))
			{ 
				PlaneProfile ppEdge = mapPpI.getPlaneProfile("pp");
//				dpHighlight.draw(ppEdge, _kDrawFilled);
				dpFrontHighlight.draw(ppEdge, _kDrawFilled);
			}
			else
			{ 
				for (int _ipp=0;_ipp<mapPpI.length();_ipp++) 
				{ 
					Map _mapPpI = mapPpI.getMap(_ipp);
					PlaneProfile _ppI = _mapPpI.getPlaneProfile("pp");
//					dpHighlight.draw(_ppI,_kDrawFilled);
					dpFrontHighlight.draw(_ppI,_kDrawFilled);
				}//next _ipp
			}
		}//next iMpaPp
		return;
	}
//End Jig//endregion 


//region bOnInsert
if (_bOnInsert)
{
	if (insertCycleCount() > 1) { eraseInstance(); return; }
	
	// silent/dialog
	if (_kExecuteKey.length() > 0)
	{
		String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
		if (sEntries.findNoCase(_kExecuteKey ,- 1) >- 1)
			setPropValuesFromCatalog(_kExecuteKey);
		else
			setPropValuesFromCatalog(sLastInserted);
	}
	// standard dialog	
//	else
//		showDialog();
	
	// select panels
	int iContinue = true;
	while(iContinue)
	{ 
		Entity ents[0];
		PrEntity ssE(T("|Select panels|"), Sip());
		if (ssE.go())
			ents.append(ssE.set());
		Sip sips[0];
		for (int ient=0;ient<ents.length();ient++) 
		{ 
			Sip sipI = (Sip)ents[ient]; 
			if(sipI.bIsValid()&& sips.find(sipI)<0)
			{
				sips.append(sipI);
			}
		}//next ient
		
		if(sips.length()>1)
		{ 
			// distribute
		// create TSL
			TslInst tslNew;		Vector3d vecXTsl= _XW;	Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[1];	Entity entsTsl[] = {};	Point3d ptsTsl[] = {_Pt0};
			int nProps[]={};	double dProps[]={};		String sProps[]={};
			Map mapTsl;	
			
			for (int is=0;is<sips.length();is++) 
			{ 
				gbsTsl[0] = sips[is];
				mapTsl.setInt("Automatic", true);
				tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, 
					ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
			}//next is
		}
		else if (sips.length() == 1)
		{
			// click point 
			// create TSL
			TslInst tslNew;		Vector3d vecXTsl = _XW;	Vector3d vecYTsl = _YW;
			GenBeam gbsTsl[1];	Entity entsTsl[] = { };	Point3d ptsTsl[] = { _Pt0};
			int nProps[] ={ };	double dProps[] ={ };		String sProps[] ={ };
			Map mapTsl;
			// prompt for point input
			gbsTsl[0] = sips[0];
			
			PrPoint ssP(TN("|Select point to select edge or <Enter> to accept automatic generation|"));
			ssP.setSnapMode(TRUE, 0);
			PrPoint ssP2(TN("|Select point to select edge|"));
			ssP2.setSnapMode(TRUE, 0);
			Map mapArgs;
			
			Vector3d vecView = getViewDirection();
			vecView.normalize();
			
			Sip sip = sips[0];
			mapArgs.setEntity("sip", sip);
			// basic information
			Point3d ptCen = sip.ptCen();
			Vector3d vecX = sip.vecX();
			Vector3d vecY = sip.vecY();
			Vector3d vecZ = sip.vecZ();
			//			Plane pnCen(ptCen,vecZ);
			Point3d ptTop = ptCen + vecZ * .5 * sip.dH();
			Point3d ptBottom = ptCen - vecZ * .5 * sip.dH();
			Body bdSip = sip.envelopeBody(true, true);
			AnalysedTool tools[] = sip.analysedTools();
			AnalysedCut cuts[] = AnalysedCut().filterToolsOfToolType(tools);
			AnalysedBeamCut beamcuts[] = AnalysedBeamCut().filterToolsOfToolType(tools);
			AnalysedDrill drills[] = AnalysedDrill().filterToolsOfToolType(tools);
			for (int i = 0; i < cuts.length(); i++)
			{
				AnalysedCut aC = cuts[i];
				Cut cut(aC.ptOrg(), aC.normal());
				bdSip.addTool(cut);
			}//next i
			for (int i = 0; i < beamcuts.length(); i++)
			{
				AnalysedBeamCut aBc = beamcuts[i];
				Quader qdBc = aBc.quader();
				
				BeamCut bc(qdBc.ptOrg(), qdBc.vecX(), qdBc.vecY(), qdBc.vecZ(),
					qdBc.dD(qdBc.vecX()), qdBc.dD(qdBc.vecY()), qdBc.dD(qdBc.vecZ()),
					0, 0, 0);
				bdSip.addTool(bc);
			}
			for (int i=0;i<drills.length();i++) 
			{ 
				AnalysedDrill d = drills[i];
				int bThrough = d.bThrough();
				Vector3d vecDrill = d.ptEndExtreme() - d.ptStartExtreme();
				vecDrill.normalize();
				
				Drill dr(d.ptStartExtreme(), d.ptEndExtreme(), d.dRadius());
				if(bThrough)
					dr = Drill(d.ptStartExtreme() - U(1000) * vecDrill, 
						d.ptEndExtreme() + U(1000) * vecDrill, d.dRadius());
				bdSip.addTool(dr);
			}//next i
			//			if (_Entity.find(sip) < 0)_Entity.append(sip);
			//			setDependencyOnEntity(sip);
			//region Edge Map of the panel
			Plane pnCen(ptCen, vecZ);
			Map mapEdges;
			{
//				PlaneProfile ppSipNet = sip.realBody().getSlice(Plane(ptCen, vecZ));
				PlaneProfile ppSipNet = sip.realBody().shadowProfile(Plane(ptCen,vecZ));
				
				PLine plsOuter[] = ppSipNet.allRings(true, false);
				PLine plsOpenings[] = ppSipNet.allRings(false, true);
				PLine plsAll[0];
				int iNrOutterRings = plsOuter.length();
				plsAll.append(plsOuter);
				plsAll.append(plsOpenings);
				int iEdgeCount=-1;
				for (int ipl=0;ipl<plsAll.length();ipl++) 
				{ 
					PLine plIpl = plsAll[ipl]; 
					int iOutter = true;
					if (ipl > iNrOutterRings-1)iOutter = false;
					Point3d pts[] = plIpl.vertexPoints(false);
					
					PLine plAprox = plIpl;
					plAprox.convertToLineApprox(U(10));
					Point3d ptsAprox[] = plAprox.vertexPoints(false);
					int iStart = 0;
					int iEnd = 1;
					for (int iP = 0; iP < pts.length() - 1; iP++)
					{
						iEdgeCount += 1;
						// straight not arch
						int iStraight = false;
						if ((pts[iP]-ptsAprox[iStart]).length()<dEps && 
						(pts[iP+1]-ptsAprox[iEnd]).length()<dEps)
						{
							iStraight = true;
							iStart = iEnd;
							iEnd = iStart + 1;
						}
						Map mapEdgeI;
						mapEdgeI.setInt("Outter", iOutter);
						double dEdgeThickness;
						if (iStraight)
						{
							mapEdgeI.setInt("Straight", iStraight);
							PLine plI;
							plI.addVertex(pts[iP]);
							plI.addVertex(pts[iP+1]);
							mapEdgeI.setPLine("Pline", plI);
							Map mapProfilesI, mapProfilesItop;
							// Straight lines
							LineSeg lSeg(pts[iP], pts[iP + 1]);
							Point3d ptMid = lSeg.ptMid();
							Vector3d vecDir = pts[iP + 1] - pts[iP];
							vecDir = vecZ.crossProduct(vecDir.crossProduct(vecZ));
							vecDir.normalize();
							
							Vector3d vecEdgeOutter = vecDir.crossProduct(vecZ);
							vecEdgeOutter.normalize();
							Point3d ptTest = ptMid + vecEdgeOutter * dEps;
							if(ppSipNet.pointInProfile(ptTest)==_kPointInProfile)
							{ 
								vecEdgeOutter *= -1;
							}
							mapEdgeI.setVector3d("vecEdgeOutter", vecEdgeOutter);
							mapEdgeI.setPoint3d("ptEdge", ptMid);
							mapEdgeI.setPoint3d("ptEdgeStart", pts[iP]);
							mapEdgeI.setPoint3d("ptEdgeEnd", pts[iP+1]);
							mapEdgeI.setDouble("EdgeLength", plI.length());
							Plane pnCut(ptMid, vecDir);
							Vector3d vecRight = vecDir.crossProduct(vecZ);
							Vector3d vecLeft = - vecRight;
							PlaneProfile ppCut = bdSip.getSlice(pnCut);
							// find the two points that ptInProf is in between
							PLine plCutNoOps[] = ppCut.allRings(true, false);
							if(plCutNoOps.length()==0)
							{ 
								reportMessage("\n"+scriptName()+" "+T("|slice of body failed|"));
								eraseInstance();
								return;
							}
							// find the planeprofile where the ptmid is located
							PLine plRingPtMid=plCutNoOps[0];
							PlaneProfile ppRingPtMid(ppCut.coordSys());
							ppRingPtMid.joinRing(plRingPtMid, _kAdd);
							double dDistMin = (ppRingPtMid.closestPointTo(ptMid) - ptMid).length();
							for (int iPl=0;iPl<plCutNoOps.length();iPl++) 
							{ 
								PlaneProfile ppI(ppCut.coordSys());
								ppI.joinRing(plCutNoOps[iPl], _kAdd);
								double dDistI=(ppI.closestPointTo(ptMid) - ptMid).length();
								if(dDistI<dDistMin)
								{ 
									plRingPtMid = plCutNoOps[iPl];
									dDistMin = dDistI;
								}
							}//next iPl
							
							// get ptTopLeft, ptTopRight, ptBottomLeft, ptBottomRight
							Point3d ptTopLeft, ptTopRight, ptBottomLeft, ptBottomRight;
							
							ppRingPtMid = PlaneProfile(ppCut.coordSys());
							ppRingPtMid.joinRing(plRingPtMid, _kAdd);
							
							Point3d ptsI[] = plRingPtMid.vertexPoints(true);
							ptTopLeft = ptsI[0]+vecRight*U(10e4);
							ptTopRight = ptsI[0]+vecLeft*U(10e4);
							ptBottomLeft = ptsI[0]+vecRight*U(10e4);
							ptBottomRight = ptsI[0]+vecLeft*U(10e4);
							for (int iPi = 0; iPi < ptsI.length(); iPi++)
							{ 
								if(abs(vecZ.dotProduct(ptsI[iPi]-ptTop))<dEps && vecLeft.dotProduct(ptsI[iPi]-ptTopLeft)>0)
								{ 
									ptTopLeft = ptsI[iPi];
								}
								if(abs(vecZ.dotProduct(ptsI[iPi]-ptTop))<dEps && vecRight.dotProduct(ptsI[iPi]-ptTopRight)>0)
								{ 
									ptTopRight = ptsI[iPi];
								}
								if(abs(vecZ.dotProduct(ptsI[iPi]-ptBottom))<dEps && vecLeft.dotProduct(ptsI[iPi]-ptBottomLeft)>0)
								{ 
									ptBottomLeft = ptsI[iPi];
								}
								if(abs(vecZ.dotProduct(ptsI[iPi]-ptBottom))<dEps && vecRight.dotProduct(ptsI[iPi]-ptBottomRight)>0)
								{ 
									ptBottomRight = ptsI[iPi];
								}
							}//next iPi
							
							// from 4 points get 2 points from the right side
							Point3d pt1, pt2, pt1Opp, pt2Opp;
							pt1 = ptTopLeft;
							pt2 = ptBottomLeft;
							pt1Opp = ptTopRight;
							pt2Opp = ptBottomRight;
							Vector3d vecSide = vecLeft;
							Point3d ptLeftAvg = .5 * (ptTopLeft + ptBottomLeft);
							Point3d ptRightAvg = .5 * (ptTopRight + ptBottomRight);
							if((ptLeftAvg-ptMid).length()>(ptRightAvg-ptMid).length())
							{ 
								pt1 = ptTopRight;
								pt2 = ptBottomRight;
								pt1Opp = ptTopLeft;
								pt2Opp = ptBottomLeft;
								vecSide = vecRight;
							}
							
							// get index of pt1 and pt2
							int iIndex1, iIndex2;
							for (int iPi=0;iPi<ptsI.length();iPi++) 
							{ 
								if (ptsI[iPi] == pt1)iIndex1 = iPi;
								if (ptsI[iPi] == pt2)iIndex2 = iPi;
							}//next iPi
							
							if(iIndex1>iIndex2)
							{ 
								Point3d _pt = pt1;
								int _iIndex1 = iIndex1;
								pt1 = pt2;
								iIndex1 = iIndex2;
								pt2 = _pt;
								iIndex2 = _iIndex1;
							}
							// get Points between pt1 and pt2
							// it can be points [index1,index2] or
							// [pt2,ptLast]+[ptFirst,pt1]
							Point3d pts12[0];
							int iOk = true;
							for (int jIndex=iIndex1;jIndex<iIndex2+1;jIndex++) 
							{ 
								Point3d ptJ = ptsI[jIndex];
								if(ptJ==pt1Opp || ptJ==pt2Opp)
								{ 
									iOk = false;
									break;
								}
								pts12.append(ptJ);
							}//next jIndex
							if(!iOk)
							{ 
								// get the second points
								pts12.setLength(0);
								for (int jIndex=iIndex2;jIndex<ptsI.length();jIndex++) 
								{ 
									Point3d ptJ = ptsI[jIndex];
									pts12.append(ptJ);
								}//next jIndex
								for (int jIndex=0;jIndex<iIndex1+1;jIndex++) 
								{ 
									Point3d ptJ = ptsI[jIndex];
									pts12.append(ptJ);
								}//next jIndex
							}
							
							LineSeg lSegs[0];
							for (int iPi=0;iPi<pts12.length()-1;iPi++) 
							{ 
								LineSeg lSegI(pts12[iPi], pts12[iPi + 1]);
								lSegs.append(lSegI);
							}//next iPi
							
							Display dp(3), dpSkew(1);
							for (int is=0;is<lSegs.length();is++) 
							{ 
								dEdgeThickness += lSegs[is].length();
								Vector3d vecXplan = lSegs[is].ptStart() - lSegs[is].ptEnd();
								vecXplan.normalize();
								
								vecXplan = vecDir.crossProduct(vecXplan).crossProduct(vecDir);
								vecXplan.normalize();
								Vector3d vecZplan = vecXplan.crossProduct(vecDir);
								
								double dWidthI = abs(vecXplan.dotProduct(lSegs[is].ptStart() - lSegs[is].ptEnd()));
								double dLengthI=abs(vecDir.dotProduct(pts[iP]- pts[iP + 1]));
								
								Point3d ptOrgI = .5 * (lSegs[is].ptStart() + lSegs[is].ptEnd());
								CoordSys csI(ptOrgI, vecXplan, vecDir, vecZplan);
								PlaneProfile ppI(csI);
								
								PLine plI;
								plI.createRectangle(LineSeg(ptOrgI-vecXplan*.5*dWidthI-vecDir*.5*dLengthI,
									ptOrgI + vecXplan * .5 * dWidthI + vecDir * .5 * dLengthI), vecXplan, vecDir);
								ppI.joinRing(plI,_kAdd);
								
								int iNormal = vecZplan.isPerpendicularTo(vecZ);
								if (iNormal)
								{
									// normal cut
								}
								else if ( ! iNormal)
								{
									// skew cut
								}
								Map mapSegI;
								mapSegI.setPlaneProfile("pp", ppI);
								mapSegI.setInt("Normal", iNormal);
								mapSegI.setVector3d("vecX", vecDir);
								mapSegI.setVector3d("vecY", vecXplan);
								mapSegI.setVector3d("vecZ", vecDir.crossProduct(vecXplan));
								mapProfilesI.setMap(is, mapSegI);
							}
							mapEdgeI.setDouble("EdgeThickness", dEdgeThickness);
							mapEdgeI.setMap("pps", mapProfilesI);
							{ 
								Map mapSegItop;
								Vector3d vecYpn = vecZ.crossProduct(vecDir);
								vecYpn.normalize();
								PLine plRecTop;
								plRecTop.createRectangle(LineSeg(pts[iP]+vecYpn*.5*dTapeWidthFrontDefault, 
									pts[iP + 1] - vecYpn * .5*dTapeWidthFrontDefault), vecDir, vecYpn);
								PlaneProfile ppTop(pnCen);
								ppTop.joinRing(plRecTop, _kAdd);
			//						ppTop.vis(2);
								mapSegItop.setPlaneProfile("pp", ppTop);
								mapSegItop.setVector3d("vecX", vecDir);
								mapSegItop.setVector3d("vecY", vecYpn);
								mapProfilesItop.setMap(0, mapSegItop);
							}
							mapEdgeI.setMap("ppsTop", mapProfilesItop);
							mapEdges.setMap(iEdgeCount, mapEdgeI);
						}//if (iStraight)
						else if(!iStraight)
						{ 
							mapEdgeI.setInt("Straight", iStraight);
							Map mapProfilesI,mapProfilesItop;
							// arch
							// ToDo: skew arches
							// length of arch
							{ 
								PLine plArc(plIpl.coordSys().vecZ());
								plArc.addVertex(pts[iP]);
								Point3d ptMid = .5 * (pts[iP] + pts[iP + 1]);
								
								// get arc from approx points
								PLine plArcApprox;
								int iStartPoints = false;
								for (int iptAprox=0;iptAprox<ptsAprox.length();iptAprox++) 
								{ 
									if(!iStartPoints)
									{ 
										if((ptsAprox[iptAprox]-pts[iP]).length()<dEps)
										{
											iStartPoints = true;
											plArcApprox.addVertex(ptsAprox[iptAprox]);
										}
									}
									else if(iStartPoints)
									{ 
										plArcApprox.addVertex(ptsAprox[iptAprox]);
										if((ptsAprox[iptAprox]-pts[iP+1]).length()<dEps)
										{
											break;
										}
									}
								}//next iptAprox
								Point3d ptsArcApprox[] = plArcApprox.vertexPoints(true);
								int iIndexMid = ptsArcApprox.length() / 2;
								ptMid = ptsArcApprox[iIndexMid];
								Point3d ptOnArc = plArcApprox.closestPointTo(ptMid);
								ptOnArc = plIpl.closestPointTo(ptOnArc);
								plArc.addVertex(pts[iP + 1], ptOnArc);
								mapEdgeI.setPLine("Pline", plArc);
								mapEdgeI.setDouble("EdgeLength", plArc.length());
								mapEdgeI.setPoint3d("ptEdge", ptOnArc);
								mapEdgeI.setPoint3d("ptEdgeStart", pts[iP]);
								mapEdgeI.setPoint3d("ptEdgeEnd", pts[iP+1]);
								
								for (int iptArcApprox=0;iptArcApprox<ptsArcApprox.length()-1;iptArcApprox++) 
								{ 
									double dEdgeThicknessI;
									Map _mapProfilesI, _mapProfilesItop;
									ptMid = .5*(ptsArcApprox[iptArcApprox]+
										ptsArcApprox[iptArcApprox+1]); 
									
									Point3d ptOnArc = plArcApprox.closestPointTo(ptMid);
									ptOnArc = plIpl.closestPointTo(ptOnArc);
									plArc = PLine();
									plArc.addVertex(ptsArcApprox[iptArcApprox]);
									plArc.addVertex(ptsArcApprox[iptArcApprox+1], ptOnArc);
									double dLengthArchI = plArc.length();
									Vector3d vecDir = plArc.getTangentAtPoint(ptOnArc);
									if(abs(vecDir.length()-1)>dEps)
									{ 
										vecDir = ptsArcApprox[iptArcApprox + 1] - ptsArcApprox[iptArcApprox];
										vecDir.normalize();
									}
									Vector3d vecEdgeOutter = vecDir.crossProduct(vecZ);
									vecEdgeOutter.normalize();
									Point3d ptTest = ptOnArc + vecEdgeOutter * dEps;
									if(ppSipNet.pointInProfile(ptTest)==_kPointInProfile)
									{ 
										vecEdgeOutter *= -1;
									}
									mapEdgeI.setVector3d("vecEdgeOutter"+iptArcApprox, vecEdgeOutter);
									mapEdgeI.setDouble("EdgeLength"+iptArcApprox, plArc.length());
									
									mapEdgeI.setPoint3d("ptEdge"+iptArcApprox, ptOnArc);
									Plane pnCut(ptOnArc, vecDir);
									Vector3d vecRight = vecDir.crossProduct(vecZ);
									Vector3d vecLeft = -vecRight;
									PlaneProfile ppCut = bdSip.getSlice(pnCut);
									PLine plCutNoOps[] = ppCut.allRings(true, false);
									if(plCutNoOps.length()==0)
									{ 
										reportMessage("\n"+scriptName()+" "+T("|slice of body failed|"));
										eraseInstance();
										return;
									}
									// find the planeprofile where the ptmid is located
									PLine plRingPtMid = plCutNoOps[0];
									PlaneProfile ppRingPtMid(ppCut.coordSys());
									ppRingPtMid.joinRing(plRingPtMid, _kAdd);
									double dDistMin = (ppRingPtMid.closestPointTo(ptMid) - ptMid).length();
									for (int iPl=0;iPl<plCutNoOps.length();iPl++) 
									{ 
										PlaneProfile ppI(ppCut.coordSys());
										ppI.joinRing(plCutNoOps[iPl], _kAdd);
										double dDistI=(ppI.closestPointTo(ptMid) - ptMid).length();
										if(dDistI<dDistMin)
										{ 
											plRingPtMid = plCutNoOps[iPl];
											dDistMin = dDistI;
										}
									}//next iPl
									// get ptTopLeft, ptTopRight, ptBottomLeft, ptBottomRight
									Point3d ptTopLeft, ptTopRight, ptBottomLeft, ptBottomRight;
									
									ppRingPtMid = PlaneProfile(ppCut.coordSys());
									ppRingPtMid.joinRing(plRingPtMid, _kAdd);
									
									Point3d ptsI[] = plRingPtMid.vertexPoints(true);
									ptTopLeft = ptsI[0]+vecRight*U(10e4);
									ptTopRight = ptsI[0]+vecLeft*U(10e4);
									ptBottomLeft = ptsI[0]+vecRight*U(10e4);
									ptBottomRight = ptsI[0]+vecLeft*U(10e4);
									for (int iPi = 0; iPi < ptsI.length(); iPi++)
									{ 
										if(abs(vecZ.dotProduct(ptsI[iPi]-ptTop))<dEps && vecLeft.dotProduct(ptsI[iPi]-ptTopLeft)>0)
										{ 
											ptTopLeft = ptsI[iPi];
										}
										if(abs(vecZ.dotProduct(ptsI[iPi]-ptTop))<dEps && vecRight.dotProduct(ptsI[iPi]-ptTopRight)>0)
										{ 
											ptTopRight = ptsI[iPi];
										}
										if(abs(vecZ.dotProduct(ptsI[iPi]-ptBottom))<dEps && vecLeft.dotProduct(ptsI[iPi]-ptBottomLeft)>0)
										{ 
											ptBottomLeft = ptsI[iPi];
										}
										if(abs(vecZ.dotProduct(ptsI[iPi]-ptBottom))<dEps && vecRight.dotProduct(ptsI[iPi]-ptBottomRight)>0)
										{ 
											ptBottomRight = ptsI[iPi];
										}
									}//next iPi
									// from 4 points get 2 points from the right side
									Point3d pt1, pt2, pt1Opp, pt2Opp;
									pt1 = ptTopLeft;
									pt2 = ptBottomLeft;
									pt1Opp = ptTopRight;
									pt2Opp = ptBottomRight;
									Vector3d vecSide = vecLeft;
									Point3d ptLeftAvg = .5 * (ptTopLeft + ptBottomLeft);
									Point3d ptRightAvg = .5 * (ptTopRight + ptBottomRight);
									if((ptLeftAvg-ptMid).length()>(ptRightAvg-ptMid).length())
									{ 
										pt1 = ptTopRight;
										pt2 = ptBottomRight;
										pt1Opp = ptTopLeft;
										pt2Opp = ptBottomLeft;
										vecSide = vecRight;
									}
									
									// get index of pt1 and pt2
									int iIndex1, iIndex2;
									for (int iPi=0;iPi<ptsI.length();iPi++) 
									{ 
										if (ptsI[iPi] == pt1)iIndex1 = iPi;
										if (ptsI[iPi] == pt2)iIndex2 = iPi;
									}//next iPi
									
									if(iIndex1>iIndex2)
									{ 
										Point3d _pt = pt1;
										int _iIndex1 = iIndex1;
										pt1 = pt2;
										iIndex1 = iIndex2;
										pt2 = _pt;
										iIndex2 = _iIndex1;
									}
									// get Points between pt1 and pt2
									// it can be points [index1,index2] or
									// [pt2,ptLast]+[ptFirst,pt1]
									Point3d pts12[0];
									int iOk = true;
									for (int jIndex=iIndex1;jIndex<iIndex2+1;jIndex++) 
									{ 
										Point3d ptJ = ptsI[jIndex];
										if(ptJ==pt1Opp || ptJ==pt2Opp)
										{ 
											iOk = false;
											break;
										}
										pts12.append(ptJ);
									}//next jIndex
									if(!iOk)
									{ 
										// get the second points
										pts12.setLength(0);
										for (int jIndex=iIndex2;jIndex<ptsI.length();jIndex++) 
										{ 
											Point3d ptJ = ptsI[jIndex];
											pts12.append(ptJ);
										}//next jIndex
										for (int jIndex=0;jIndex<iIndex1+1;jIndex++) 
										{ 
											Point3d ptJ = ptsI[jIndex];
											pts12.append(ptJ);
										}//next jIndex
									}
									
									LineSeg lSegs[0];
									for (int iPi=0;iPi<pts12.length()-1;iPi++) 
									{ 
										LineSeg lSegI(pts12[iPi], pts12[iPi + 1]);
										lSegs.append(lSegI);
									}//next iPi
									
									Display dp(3), dpSkew(1);
									for (int is = 0; is < lSegs.length(); is++)
									{
										dEdgeThicknessI += lSegs[is].length();
										Vector3d vecXplan = lSegs[is].ptStart() - lSegs[is].ptEnd();
										vecXplan.normalize();
										
										vecXplan = vecDir.crossProduct(vecXplan).crossProduct(vecDir);
										vecXplan.normalize();
										Vector3d vecZplan = vecXplan.crossProduct(vecDir);
										
										double dWidthI = abs(vecXplan.dotProduct(lSegs[is].ptStart() - lSegs[is].ptEnd()));
										
										Point3d ptOrgI = .5 * (lSegs[is].ptStart() + lSegs[is].ptEnd());
										CoordSys csI(ptOrgI, vecXplan, vecDir, vecZplan);
										PlaneProfile ppI(csI);
										
										PLine plI;
										plI.createRectangle(LineSeg(ptOrgI - vecXplan * .5 * dWidthI - vecDir * .5 * dLengthArchI,
										ptOrgI + vecXplan * .5 * dWidthI + vecDir * .5 * dLengthArchI), vecXplan, vecDir);
										ppI.joinRing(plI, _kAdd);
										
										int iNormal = vecZplan.isPerpendicularTo(vecZ);
										if (iNormal)
										{
											// normal cut
			//									dp.draw(ppI, _kDrawFilled);
										}
										else if(!iNormal)
										{ 
			//									dpSkew.draw(ppI, _kDrawFilled);
										}
										Map mapSegI;
										mapSegI.setPlaneProfile("pp", ppI);
										mapSegI.setVector3d("vecX", vecDir);
										mapSegI.setVector3d("vecY", vecXplan);
										mapSegI.setVector3d("vecZ", vecDir.crossProduct(vecXplan));
										mapSegI.setInt("Normal", iNormal);
										_mapProfilesI.setMap(is, mapSegI);
									}// for (int is = 0; is < lSegs.length(); is++)
									if (dEdgeThickness < dEdgeThicknessI)dEdgeThickness = dEdgeThicknessI;
									mapProfilesI.setMap(iptArcApprox, _mapProfilesI);
									{ 
										Map mapSegItop;
										Vector3d vecYpn = vecZ.crossProduct(vecDir);
										vecYpn.normalize();
										PLine plRecTop;
										plRecTop.createRectangle(LineSeg(ptsArcApprox[iptArcApprox]+vecYpn*.5*dTapeWidthFrontDefault, 
											ptsArcApprox[iptArcApprox+1] - vecYpn * .5*dTapeWidthFrontDefault), vecDir, vecYpn);
										PlaneProfile ppTop(pnCen);
										ppTop.joinRing(plRecTop, _kAdd);
			//								ppTop.vis(2);
										mapSegItop.setPlaneProfile("pp", ppTop);
										mapSegItop.setVector3d("vecX", vecDir);
										mapSegItop.setVector3d("vecY", vecYpn);
										_mapProfilesItop.setMap(0, mapSegItop);
									}
									mapProfilesItop.setMap(iptArcApprox, _mapProfilesItop);
								}//next iptArcApprox
								mapEdgeI.setDouble("EdgeThickness", dEdgeThickness);
								mapEdgeI.setMap("pps", mapProfilesI);
								mapEdgeI.setMap("ppsTop", mapProfilesItop);
								mapEdges.setMap(iEdgeCount, mapEdgeI);
							}
							for (int jP=iEnd;jP<ptsAprox.length()-1;jP++) 
							{ 
								if ((pts[iP+1]-ptsAprox[jP]).length()<dEps)
								{ 
									iStart = jP;
									iEnd = jP + 1;
									break;
								}
							}//next jP
						}// else if(!iStraight)
					}//for (int iP = 0; iP < pts.length() - 1; iP++)
				}//next ipl
			}
			_Map.setMap("Edges", mapEdges);
			//End Edge Map of the panel//endregion
			
			mapArgs.setMap("Edges", mapEdges);
			
			int nGoJig = - 1;
			while (nGoJig != _kOk)
			{
				nGoJig = ssP.goJig(strJigAction1, mapArgs);
				if (nGoJig == _kOk)
				{
					Point3d ptJig;
					ptJig = ssP.value();
					Line lnView(ptJig, vecView);
					lnView.hasIntersection(pnCen, ptJig);
					// create TSL
					ptsTsl[0] = ptJig;
					tslNew.dbCreate(scriptName() , vecXTsl , vecYTsl, gbsTsl, entsTsl,
					ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
					int iCount = 0;
					while (iCount < 100)
					{
						int iBreak = false;
						int nGoJig2 = - 1;
						while (nGoJig2 != _kOk)
						{
							nGoJig2 = ssP2.goJig(strJigAction2, mapArgs);
							if (nGoJig2 == _kOk)
							{
								Point3d ptJig;
								ptJig = ssP2.value();
								Line lnView(ptJig, vecView);
								lnView.hasIntersection(pnCen, ptJig);
								// create TSL
								ptsTsl[0] = ptJig;
								tslNew.dbCreate(scriptName() , vecXTsl , vecYTsl, gbsTsl, entsTsl,
								ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
								int nGoJig2 = - 1;
								iCount++;
							}
							else
							{
								nGoJig2 = _kOk;
								iBreak = true;
							}
						}
						if (iBreak)break;
					}
				}
				else if (nGoJig == _kCancel)
				{
					break;
				}
				else
				{
					// automatic
					gbsTsl[0] = sips[0];
					mapTsl.setInt("Automatic", true);
					tslNew.dbCreate(scriptName() , vecXTsl , vecYTsl, gbsTsl, entsTsl,
					ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
					nGoJig = _kOk;
				}
			}
		}
		else if(sips.length()==0)
		{ 
			break;
		}
	}
	
	eraseInstance();
	return;
}
// end on insert	__________________//endregion

//region validation
if(_Sip.length()!=1)
{ 
	reportMessage("\n"+scriptName()+" "+T("|one panel needed|"));
	eraseInstance();
	return;
}

Sip sip = _Sip[0]; 
// basic information
Point3d ptCen = sip.ptCen();
Vector3d vecX = sip.vecX();
Vector3d vecY = sip.vecY();
Vector3d vecZ = sip.vecZ();
Point3d ptTop = ptCen + vecZ * .5 * sip.dH();
Point3d ptBottom = ptCen - vecZ * .5 * sip.dH();
Body bdSip = sip.envelopeBody(true, true);

String sQualityStyles[] = SurfaceQualityStyle().getAllEntryNames(); // list of all available SurfaceQualityStyles
int nQualities[0];	
for (int s=0; s<sQualityStyles.length(); s++) 
{
	SurfaceQualityStyle sqs(sQualityStyles[s]);
	nQualities.append(sqs.quality());
}
assignToGroups(sip);
Element el = sip.element();
if(el.bIsValid())
{ 
	assignToElementGroup(el, false);
}
// order by quality
for (int i=0;i<sQualityStyles.length();i++)
	for (int j=0;j<sQualityStyles.length()-1;j++)
		if (nQualities[j]>nQualities[j+1])
		{
			nQualities.swap(j,j+1);
			sQualityStyles.swap(j,j+1);	
		}
String styleName = sip.style();
SipStyle style(styleName);
String sSQTop = style.surfaceQualityTop();
String sSQTopOverride = sip.surfaceQualityOverrideTop();
if (sSQTopOverride!="")sSQTop=sip.surfaceQualityOverrideTop();
String sSQBottom = style.surfaceQualityBottom();
String sSQBottomOverride = sip.surfaceQualityOverrideBottom();
if (sSQBottomOverride!="")sSQBottom=sip.surfaceQualityOverrideBottom();
//
AnalysedTool tools[] = sip.analysedTools();
AnalysedCut cuts[] = AnalysedCut().filterToolsOfToolType(tools);
AnalysedBeamCut beamcuts[] = AnalysedBeamCut().filterToolsOfToolType(tools);
AnalysedDrill drills[] = AnalysedDrill().filterToolsOfToolType(tools);

for (int i=0;i<cuts.length();i++) 
{ 
	AnalysedCut aC = cuts[i];
	Cut cut(aC.ptOrg(), aC.normal());
	bdSip.addTool(cut);
}//next i
for (int i = 0; i < beamcuts.length(); i++)
{
	AnalysedBeamCut aBc = beamcuts[i];
	Quader qdBc = aBc.quader();
	
	BeamCut bc(qdBc.ptOrg(), qdBc.vecX(), qdBc.vecY(), qdBc.vecZ(),
		qdBc.dD(qdBc.vecX()), qdBc.dD(qdBc.vecY()), qdBc.dD(qdBc.vecZ()),
		0, 0, 0);
	bdSip.addTool(bc);
}
for (int i=0;i<drills.length();i++) 
{ 
	AnalysedDrill d = drills[i];
	int bThrough = d.bThrough();
	Vector3d vecDrill = d.ptEndExtreme() - d.ptStartExtreme();
	vecDrill.normalize();
	
	Drill dr(d.ptStartExtreme(), d.ptEndExtreme(), d.dRadius());
	if(bThrough)
		dr = Drill(d.ptStartExtreme() - U(1000) * vecDrill, 
			d.ptEndExtreme() + U(1000) * vecDrill, d.dRadius());
//	dr.cuttingBody().vis(1);
	bdSip.addTool(dr);
	
}//next i
bdSip.vis(1);
if (_Entity.find(sip) < 0)_Entity.append(sip);
setDependencyOnEntity(sip);
setKeepReferenceToGenBeamDuringCopy(_kBeam01);
//End validation//endregion

//region Edge Map of the panel
int iMoved;
if(!_Map.hasPoint3d("Position"))
{ 
	_Map.setPoint3d("Position", ptCen, _kAbsolute);
	_Map.setVector3d("vecX", vecX, _kAbsolute);
	_Map.setVector3d("vecY", vecY, _kAbsolute);
	_Map.setVector3d("vecZ", vecZ, _kAbsolute);
}
else if(_Map.hasPoint3d("Position"))
{ 
	if((ptCen-_Map.getPoint3d("Position")).length()>dEps)
	{ 
		iMoved = true;
	}
	if(abs(abs(vecX.dotProduct(_Map.getVector3d("vecX")))-1)>dEps)
	{ 
		iMoved = true;
	}
	if(abs(abs(vecY.dotProduct(_Map.getVector3d("vecY")))-1)>dEps)
	{ 
		iMoved = true;
	}
	if(abs(abs(vecZ.dotProduct(_Map.getVector3d("vecZ")))-1)>dEps)
	{ 
		iMoved = true;
	}
	if(iMoved)
	{ 
		_Map.setPoint3d("Position", ptCen, _kAbsolute);
		_Map.setVector3d("vecX", vecX, _kAbsolute);
		_Map.setVector3d("vecY", vecY, _kAbsolute);
		_Map.setVector3d("vecZ", vecZ, _kAbsolute);
	}
}
String sTriggergenerateSingleInstances = T("|Edit in Place|");
int iUpdateMap = true;
int iHasMapEdge = _Map.hasMap("Edges");
if(_bOnGripPointDrag && 	
		((_kExecuteKey == "_PtG0") || (_kExecuteKey == "_PtG1")))
{ 
	iUpdateMap = false;
}
if(_bOnDbCreated && iHasMapEdge)
{ 
	iUpdateMap = false;
}
if(_kExecuteKey==sTriggergenerateSingleInstances && iHasMapEdge)
{ 
	iUpdateMap = false;
}
if (iMoved)
{ 
	iUpdateMap = true;
}
if(iUpdateMap || _bOnDebug)
{ 
	Map mapEdges;
//		PlaneProfile ppSipNet = sip.realBody().getSlice(Plane(ptCen-vecZ *(.5*sip.dH()-dEps),vecZ));
//	PlaneProfile ppSipNet = sip.realBody().getSlice(Plane(ptCen,vecZ));
	PlaneProfile ppSipNet = sip.realBody().shadowProfile(Plane(ptCen,vecZ));
//	ppSipNet.transformBy(_XW * U(2000));
//	ppSipNet.vis(2);
//	ppSipNet.transformBy(-_XW * U(2000));
	
	Plane pnCen(ptCen,vecZ);
	PLine plsOuter[] = ppSipNet.allRings(true, false);
	PLine plsOpenings[] = ppSipNet.allRings(false, true);
	PLine plsAll[0];
	int iNrOutterRings = plsOuter.length();
	plsAll.append(plsOuter);
	plsAll.append(plsOpenings);
	int iEdgeCount=-1;
	for (int ipl=0;ipl<plsAll.length();ipl++) 
	{ 
		
		PLine plIpl = plsAll[ipl]; 
		int iOutter = true;
		if (ipl > iNrOutterRings-1)iOutter = false;
		Point3d pts[] = plIpl.vertexPoints(false);
		plIpl.transformBy(vecZ*U(400));
		plIpl.vis(1);
		plIpl.transformBy(-vecZ*U(400));
		
		PLine plAprox = plIpl;
		plAprox.convertToLineApprox(U(10));
		Point3d ptsAprox[] = plAprox.vertexPoints(false);
		int iStart = 0;
		int iEnd = 1;
		for (int iP = 0; iP < pts.length() - 1; iP++)
		{
			iEdgeCount += 1;
			// straight not arch
			int iStraight = false;
			if ((pts[iP]-ptsAprox[iStart]).length()<dEps && 
			(pts[iP+1]-ptsAprox[iEnd]).length()<dEps)
			{
				iStraight = true;
				iStart = iEnd;
				iEnd = iStart + 1;
			}
			Map mapEdgeI;
			mapEdgeI.setInt("Outter", iOutter);
			double dEdgeThickness;
			if (iStraight)
			{
				mapEdgeI.setInt("Straight", iStraight);
				PLine plI;
				plI.addVertex(pts[iP]);
				plI.addVertex(pts[iP+1]);
				mapEdgeI.setPLine("Pline", plI);
				Map mapProfilesI, mapProfilesItop;
				// Straight lines
				LineSeg lSeg(pts[iP], pts[iP + 1]);
				pts[iP].vis(1);
				pts[iP+1].vis(1);
				Point3d ptMid = lSeg.ptMid();
				Vector3d vecDir = pts[iP + 1] - pts[iP];
				vecDir = vecZ.crossProduct(vecDir.crossProduct(vecZ));
				vecDir.normalize();
				
				Vector3d vecEdgeOutter = vecDir.crossProduct(vecZ);
				vecEdgeOutter.normalize();
				Point3d ptTest = ptMid + vecEdgeOutter * dEps;
				if(ppSipNet.pointInProfile(ptTest)==_kPointInProfile)
				{ 
					vecEdgeOutter *= -1;
				}
				mapEdgeI.setVector3d("vecEdgeOutter", vecEdgeOutter);
				mapEdgeI.setPoint3d("ptEdge", ptMid);
				mapEdgeI.setPoint3d("ptEdgeStart", pts[iP]);
				mapEdgeI.setPoint3d("ptEdgeEnd", pts[iP+1]);
				mapEdgeI.setDouble("EdgeLength", plI.length());
				Plane pnCut(ptMid, vecDir);
				Vector3d vecRight = vecDir.crossProduct(vecZ);
				Vector3d vecLeft = - vecRight;

				PlaneProfile ppCut = bdSip.getSlice(pnCut);
				// find the two points that ptInProf is in between
				ppCut.vis(1);
				PLine plCutNoOps[] = ppCut.allRings(true, false);
				if(plCutNoOps.length()==0)
				{ 
					reportMessage("\n"+scriptName()+" "+T("|slice of body failed|"));
					eraseInstance();
					return;
				}
				// find the planeprofile where the ptmid is located
				PLine plRingPtMid=plCutNoOps[0];
				PlaneProfile ppRingPtMid(ppCut.coordSys());
				ppRingPtMid.joinRing(plRingPtMid, _kAdd);
				double dDistMin = (ppRingPtMid.closestPointTo(ptMid) - ptMid).length();
				for (int iPl=0;iPl<plCutNoOps.length();iPl++) 
				{ 
					PlaneProfile ppI(ppCut.coordSys());
					ppI.joinRing(plCutNoOps[iPl], _kAdd);
					double dDistI=(ppI.closestPointTo(ptMid) - ptMid).length();
					if(dDistI<dDistMin)
					{ 
						plRingPtMid = plCutNoOps[iPl];
						dDistMin = dDistI;
					}
				}//next iPl
				
				// get ptTopLeft, ptTopRight, ptBottomLeft, ptBottomRight
				Point3d ptTopLeft, ptTopRight, ptBottomLeft, ptBottomRight;
				
				ppRingPtMid = PlaneProfile(ppCut.coordSys());
				ppRingPtMid.joinRing(plRingPtMid, _kAdd);
				Point3d ptsI[] = plRingPtMid.vertexPoints(true);
				ptTopLeft = ptsI[0]+vecRight*U(10e4);
				ptTopRight = ptsI[0]+vecLeft*U(10e4);
				ptBottomLeft = ptsI[0]+vecRight*U(10e4);
				ptBottomRight = ptsI[0]+vecLeft*U(10e4);
				for (int iPi = 0; iPi < ptsI.length(); iPi++)
				{ 
					if(abs(vecZ.dotProduct(ptsI[iPi]-ptTop))<dEps && vecLeft.dotProduct(ptsI[iPi]-ptTopLeft)>0)
					{ 
						ptTopLeft = ptsI[iPi];
					}
					if(abs(vecZ.dotProduct(ptsI[iPi]-ptTop))<dEps && vecRight.dotProduct(ptsI[iPi]-ptTopRight)>0)
					{ 
						ptTopRight = ptsI[iPi];
					}
					if(abs(vecZ.dotProduct(ptsI[iPi]-ptBottom))<dEps && vecLeft.dotProduct(ptsI[iPi]-ptBottomLeft)>0)
					{ 
						ptBottomLeft = ptsI[iPi];
					}
					if(abs(vecZ.dotProduct(ptsI[iPi]-ptBottom))<dEps && vecRight.dotProduct(ptsI[iPi]-ptBottomRight)>0)
					{ 
						ptBottomRight = ptsI[iPi];
					}
				}//next iPi
				
				// from 4 points get 2 points from the right side
				Point3d pt1, pt2, pt1Opp, pt2Opp;
				pt1 = ptTopLeft;
				pt2 = ptBottomLeft;
				pt1Opp = ptTopRight;
				pt2Opp = ptBottomRight;
				Vector3d vecSide = vecLeft;
				Point3d ptLeftAvg = .5 * (ptTopLeft + ptBottomLeft);
				Point3d ptRightAvg = .5 * (ptTopRight + ptBottomRight);
				if((ptLeftAvg-ptMid).length()>(ptRightAvg-ptMid).length())
				{ 
					pt1 = ptTopRight;
					pt2 = ptBottomRight;
					pt1Opp = ptTopLeft;
					pt2Opp = ptBottomLeft;
					vecSide = vecRight;
				}
				// get index of pt1 and pt2
				int iIndex1, iIndex2;
				for (int iPi=0;iPi<ptsI.length();iPi++) 
				{ 
					if (ptsI[iPi] == pt1)iIndex1 = iPi;
					if (ptsI[iPi] == pt2)iIndex2 = iPi;
				}//next iPi
				
				if(iIndex1>iIndex2)
				{ 
					Point3d _pt1 = pt1;
					int _iIndex1 = iIndex1;
					pt1 = pt2;
					iIndex1 = iIndex2;
					pt2 = _pt1;
					iIndex2 = _iIndex1;
				}
				// get Points between pt1 and pt2
				// it can be points [index1,index2] or
				// [pt2,ptLast]+[ptFirst,pt1]
				Point3d pts12[0];
				int iOk = true;
				for (int jIndex=iIndex1;jIndex<iIndex2+1;jIndex++) 
				{ 
					Point3d ptJ = ptsI[jIndex];
					if(ptJ==pt1Opp || ptJ==pt2Opp)
					{ 
						iOk = false;
						break;
					}
					pts12.append(ptJ);
				}//next jIndex
				if(!iOk)
				{ 
					// get the second points
					pts12.setLength(0);
					for (int jIndex=iIndex2;jIndex<ptsI.length();jIndex++) 
					{ 
						Point3d ptJ = ptsI[jIndex];
						pts12.append(ptJ);
					}//next jIndex
					for (int jIndex=0;jIndex<iIndex1+1;jIndex++) 
					{ 
						Point3d ptJ = ptsI[jIndex];
						pts12.append(ptJ);
					}//next jIndex
				}
				LineSeg lSegs[0];
				for (int iPi=0;iPi<pts12.length()-1;iPi++) 
				{ 
					LineSeg lSegI(pts12[iPi], pts12[iPi + 1]);
					lSegs.append(lSegI);
				}//next iPi
				
				Display dp(3), dpSkew(1);
				for (int is=0;is<lSegs.length();is++) 
				{ 
					lSegs[is].vis(4);
					dEdgeThickness += lSegs[is].length();
					Vector3d vecXplan = lSegs[is].ptStart() - lSegs[is].ptEnd();
					vecXplan.normalize();
					
					vecXplan = vecDir.crossProduct(vecXplan).crossProduct(vecDir);
					vecXplan.normalize();
					Vector3d vecZplan = vecXplan.crossProduct(vecDir);
					
					double dWidthI = abs(vecXplan.dotProduct(lSegs[is].ptStart() - lSegs[is].ptEnd()));
					double dLengthI=abs(vecDir.dotProduct(pts[iP]- pts[iP + 1]));
					
					Point3d ptOrgI = .5 * (lSegs[is].ptStart() + lSegs[is].ptEnd());
					CoordSys csI(ptOrgI, vecXplan, vecDir, vecZplan);
					PlaneProfile ppI(csI);
					
					PLine plI;
					plI.createRectangle(LineSeg(ptOrgI-vecXplan*.5*dWidthI-vecDir*.5*dLengthI,
						ptOrgI + vecXplan * .5 * dWidthI + vecDir * .5 * dLengthI), vecXplan, vecDir);
					ppI.joinRing(plI,_kAdd);
					
					int iNormal = vecZplan.isPerpendicularTo(vecZ);
					if (iNormal)
					{
						// normal cut
					}
					else if ( ! iNormal)
					{
						// skew cut
					}
					Map mapSegI;
					mapSegI.setPlaneProfile("pp", ppI);
					mapSegI.setInt("Normal", iNormal);
					mapSegI.setVector3d("vecX", vecDir);
					mapSegI.setVector3d("vecY", vecXplan);
					mapSegI.setVector3d("vecZ", vecDir.crossProduct(vecXplan));
					mapProfilesI.setMap(is, mapSegI);
				}
				mapEdgeI.setDouble("EdgeThickness", dEdgeThickness);
				mapEdgeI.setMap("pps", mapProfilesI);
				{ 
					Map mapSegItop;
					Vector3d vecYpn = vecZ.crossProduct(vecDir);
					vecYpn.normalize();
					PLine plRecTop;
					plRecTop.createRectangle(LineSeg(pts[iP]+vecYpn*.5*dTapeWidthFrontDefault, 
						pts[iP + 1] - vecYpn * .5*dTapeWidthFrontDefault), vecDir, vecYpn);
					PlaneProfile ppTop(pnCen);
					ppTop.joinRing(plRecTop, _kAdd);
//						ppTop.vis(2);
					mapSegItop.setPlaneProfile("pp", ppTop);
					mapSegItop.setVector3d("vecX", vecDir);
					mapSegItop.setVector3d("vecY", vecYpn);
					mapProfilesItop.setMap(0, mapSegItop);
				}
				mapEdgeI.setMap("ppsTop", mapProfilesItop);
				mapEdges.setMap(iEdgeCount, mapEdgeI);
			}//if (iStraight)
			else if(!iStraight)
			{ 
				mapEdgeI.setInt("Straight", iStraight);
				Map mapProfilesI,mapProfilesItop;
				// arch
				// ToDo: skew arches
				// length of arch
				{ 
					PLine plArc(plIpl.coordSys().vecZ());
					plArc.addVertex(pts[iP]);
					Point3d ptMid = .5 * (pts[iP] + pts[iP + 1]);
					
					// get arc from approx points
					PLine plArcApprox;
					int iStartPoints = false;
					for (int iptAprox=0;iptAprox<ptsAprox.length();iptAprox++) 
					{ 
						if(!iStartPoints)
						{ 
							if((ptsAprox[iptAprox]-pts[iP]).length()<dEps)
							{
								iStartPoints = true;
								plArcApprox.addVertex(ptsAprox[iptAprox]);
							}
						}
						else if(iStartPoints)
						{ 
							plArcApprox.addVertex(ptsAprox[iptAprox]);
							if((ptsAprox[iptAprox]-pts[iP+1]).length()<dEps)
							{
								break;
							}
						}
					}//next iptAprox
					Point3d ptsArcApprox[] = plArcApprox.vertexPoints(true);
					int iIndexMid = ptsArcApprox.length() / 2;
					ptMid = ptsArcApprox[iIndexMid];
					Point3d ptOnArc = plArcApprox.closestPointTo(ptMid);
					ptOnArc = plIpl.closestPointTo(ptOnArc);
					plArc.addVertex(pts[iP + 1], ptOnArc);
					mapEdgeI.setPLine("Pline", plArc);
					mapEdgeI.setDouble("EdgeLength", plArc.length());
					mapEdgeI.setPoint3d("ptEdge", ptOnArc);
					mapEdgeI.setPoint3d("ptEdgeStart", pts[iP]);
					mapEdgeI.setPoint3d("ptEdgeEnd", pts[iP+1]);
					
					for (int iptArcApprox=0;iptArcApprox<ptsArcApprox.length()-1;iptArcApprox++) 
					{ 
						double dEdgeThicknessI;
						Map _mapProfilesI, _mapProfilesItop;
						ptMid = .5*(ptsArcApprox[iptArcApprox]+
							ptsArcApprox[iptArcApprox+1]); 
						
						Point3d ptOnArc = plArcApprox.closestPointTo(ptMid);
						ptOnArc = plIpl.closestPointTo(ptOnArc);
						plArc = PLine();
						plArc.addVertex(ptsArcApprox[iptArcApprox]);
						plArc.addVertex(ptsArcApprox[iptArcApprox+1], ptOnArc);
						double dLengthArchI = plArc.length();
						Vector3d vecDir = plArc.getTangentAtPoint(ptOnArc);
						if(abs(vecDir.length()-1)>dEps)
						{ 
							vecDir = ptsArcApprox[iptArcApprox + 1] - ptsArcApprox[iptArcApprox];
							vecDir.normalize();
						}
						Vector3d vecEdgeOutter = vecDir.crossProduct(vecZ);
						vecEdgeOutter.normalize();
						Point3d ptTest = ptOnArc + vecEdgeOutter * dEps;
						if(ppSipNet.pointInProfile(ptTest)==_kPointInProfile)
						{ 
							vecEdgeOutter *= -1;
						}
						mapEdgeI.setVector3d("vecEdgeOutter"+iptArcApprox, vecEdgeOutter);
						mapEdgeI.setDouble("EdgeLength"+iptArcApprox, plArc.length());
						
						mapEdgeI.setPoint3d("ptEdge"+iptArcApprox, ptOnArc);
						Plane pnCut(ptOnArc, vecDir);
						Vector3d vecRight = vecDir.crossProduct(vecZ);
						Vector3d vecLeft = -vecRight;
						PlaneProfile ppCut = bdSip.getSlice(pnCut);
						PLine plCutNoOps[] = ppCut.allRings(true, false);
						if(plCutNoOps.length()==0)
						{ 
							reportMessage("\n"+scriptName()+" "+T("|slice of body failed|"));
							eraseInstance();
							return;
						}
						// find the planeprofile where the ptmid is located
						PLine plRingPtMid = plCutNoOps[0];
						PlaneProfile ppRingPtMid(ppCut.coordSys());
						ppRingPtMid.joinRing(plRingPtMid, _kAdd);
						double dDistMin = (ppRingPtMid.closestPointTo(ptMid) - ptMid).length();
						for (int iPl=0;iPl<plCutNoOps.length();iPl++) 
						{ 
							PlaneProfile ppI(ppCut.coordSys());
							ppI.joinRing(plCutNoOps[iPl], _kAdd);
							double dDistI=(ppI.closestPointTo(ptMid) - ptMid).length();
							if(dDistI<dDistMin)
							{ 
								plRingPtMid = plCutNoOps[iPl];
								dDistMin = dDistI;
							}
						}//next iPl
						// get ptTopLeft, ptTopRight, ptBottomLeft, ptBottomRight
						Point3d ptTopLeft, ptTopRight, ptBottomLeft, ptBottomRight;
						
						ppRingPtMid = PlaneProfile(ppCut.coordSys());
						ppRingPtMid.joinRing(plRingPtMid, _kAdd);
						
						Point3d ptsI[] = plRingPtMid.vertexPoints(true);
						ptTopLeft = ptsI[0]+vecRight*U(10e4);
						ptTopRight = ptsI[0]+vecLeft*U(10e4);
						ptBottomLeft = ptsI[0]+vecRight*U(10e4);
						ptBottomRight = ptsI[0]+vecLeft*U(10e4);
						for (int iPi = 0; iPi < ptsI.length(); iPi++)
						{ 
							if(abs(vecZ.dotProduct(ptsI[iPi]-ptTop))<dEps && vecLeft.dotProduct(ptsI[iPi]-ptTopLeft)>0)
							{ 
								ptTopLeft = ptsI[iPi];
							}
							if(abs(vecZ.dotProduct(ptsI[iPi]-ptTop))<dEps && vecRight.dotProduct(ptsI[iPi]-ptTopRight)>0)
							{ 
								ptTopRight = ptsI[iPi];
							}
							if(abs(vecZ.dotProduct(ptsI[iPi]-ptBottom))<dEps && vecLeft.dotProduct(ptsI[iPi]-ptBottomLeft)>0)
							{ 
								ptBottomLeft = ptsI[iPi];
							}
							if(abs(vecZ.dotProduct(ptsI[iPi]-ptBottom))<dEps && vecRight.dotProduct(ptsI[iPi]-ptBottomRight)>0)
							{ 
								ptBottomRight = ptsI[iPi];
							}
						}//next iPi
						// from 4 points get 2 points from the right side
						Point3d pt1, pt2, pt1Opp, pt2Opp;
						pt1 = ptTopLeft;
						pt2 = ptBottomLeft;
						pt1Opp = ptTopRight;
						pt2Opp = ptBottomRight;
						Vector3d vecSide = vecLeft;
						Point3d ptLeftAvg = .5 * (ptTopLeft + ptBottomLeft);
						Point3d ptRightAvg = .5 * (ptTopRight + ptBottomRight);
						if((ptLeftAvg-ptMid).length()>(ptRightAvg-ptMid).length())
						{ 
							pt1 = ptTopRight;
							pt2 = ptBottomRight;
							pt1Opp = ptTopLeft;
							pt2Opp = ptBottomLeft;
							vecSide = vecRight;
						}
						
						// get index of pt1 and pt2
						int iIndex1, iIndex2;
						for (int iPi=0;iPi<ptsI.length();iPi++) 
						{ 
							if (ptsI[iPi] == pt1)iIndex1 = iPi;
							if (ptsI[iPi] == pt2)iIndex2 = iPi;
						}//next iPi
						
						if(iIndex1>iIndex2)
						{ 
							Point3d _pt = pt1;
							int _iIndex1 = iIndex1;
							pt1 = pt2;
							iIndex1 = iIndex2;
							pt2 = _pt;
							iIndex2 = _iIndex1;
						}
						// get Points between pt1 and pt2
						// it can be points [index1,index2] or
						// [pt2,ptLast]+[ptFirst,pt1]
						Point3d pts12[0];
						int iOk = true;
						for (int jIndex=iIndex1;jIndex<iIndex2+1;jIndex++) 
						{ 
							Point3d ptJ = ptsI[jIndex];
							if(ptJ==pt1Opp || ptJ==pt2Opp)
							{ 
								iOk = false;
								break;
							}
							pts12.append(ptJ);
						}//next jIndex
						if(!iOk)
						{ 
							// get the second points
							pts12.setLength(0);
							for (int jIndex=iIndex2;jIndex<ptsI.length();jIndex++) 
							{ 
								Point3d ptJ = ptsI[jIndex];
								pts12.append(ptJ);
							}//next jIndex
							for (int jIndex=0;jIndex<iIndex1+1;jIndex++) 
							{ 
								Point3d ptJ = ptsI[jIndex];
								pts12.append(ptJ);
							}//next jIndex
						}
						LineSeg lSegs[0];
						for (int iPi=0;iPi<pts12.length()-1;iPi++) 
						{ 
							LineSeg lSegI(pts12[iPi], pts12[iPi + 1]);
							lSegs.append(lSegI);
						}//next iPi
						Display dp(3), dpSkew(1);
						for (int is = 0; is < lSegs.length(); is++)
						{
							dEdgeThicknessI += lSegs[is].length();
							Vector3d vecXplan = lSegs[is].ptStart() - lSegs[is].ptEnd();
							vecXplan.normalize();
							
							vecXplan = vecDir.crossProduct(vecXplan).crossProduct(vecDir);
							vecXplan.normalize();
							Vector3d vecZplan = vecXplan.crossProduct(vecDir);
							
							double dWidthI = abs(vecXplan.dotProduct(lSegs[is].ptStart() - lSegs[is].ptEnd()));
							
							Point3d ptOrgI = .5 * (lSegs[is].ptStart() + lSegs[is].ptEnd());
							CoordSys csI(ptOrgI, vecXplan, vecDir, vecZplan);
							PlaneProfile ppI(csI);
							
							PLine plI;
							plI.createRectangle(LineSeg(ptOrgI - vecXplan * .5 * dWidthI - vecDir * .5 * dLengthArchI,
							ptOrgI + vecXplan * .5 * dWidthI + vecDir * .5 * dLengthArchI), vecXplan, vecDir);
							ppI.joinRing(plI, _kAdd);
							
							int iNormal = vecZplan.isPerpendicularTo(vecZ);
							if (iNormal)
							{
								// normal cut
//									dp.draw(ppI, _kDrawFilled);
							}
							else if(!iNormal)
							{ 
//									dpSkew.draw(ppI, _kDrawFilled);
							}
							Map mapSegI;
							mapSegI.setPlaneProfile("pp", ppI);
							mapSegI.setVector3d("vecX", vecDir);
							mapSegI.setVector3d("vecY", vecXplan);
							mapSegI.setVector3d("vecZ", vecDir.crossProduct(vecXplan));
							mapSegI.setInt("Normal", iNormal);
							_mapProfilesI.setMap(is, mapSegI);
						}// for (int is = 0; is < lSegs.length(); is++)
						if (dEdgeThickness < dEdgeThicknessI)dEdgeThickness = dEdgeThicknessI;
						mapProfilesI.setMap(iptArcApprox, _mapProfilesI);
						{ 
							Map mapSegItop;
							Vector3d vecYpn = vecZ.crossProduct(vecDir);
							vecYpn.normalize();
							PLine plRecTop;
							plRecTop.createRectangle(LineSeg(ptsArcApprox[iptArcApprox]+vecYpn*.5*dTapeWidthFrontDefault, 
								ptsArcApprox[iptArcApprox+1] - vecYpn *.5*dTapeWidthFrontDefault), vecDir, vecYpn);
							PlaneProfile ppTop(pnCen);
							ppTop.joinRing(plRecTop, _kAdd);
//								ppTop.vis(2);
							mapSegItop.setPlaneProfile("pp", ppTop);
							mapSegItop.setVector3d("vecX", vecDir);
							mapSegItop.setVector3d("vecY", vecYpn);
							_mapProfilesItop.setMap(0, mapSegItop);
						}
						mapProfilesItop.setMap(iptArcApprox, _mapProfilesItop);
					}//next iptArcApprox
					mapEdgeI.setDouble("EdgeThickness", dEdgeThickness);
					mapEdgeI.setMap("pps", mapProfilesI);
					mapEdgeI.setMap("ppsTop", mapProfilesItop);
					mapEdges.setMap(iEdgeCount, mapEdgeI);
				}
				for (int jP=iEnd;jP<ptsAprox.length()-1;jP++) 
				{ 
					if ((pts[iP+1]-ptsAprox[jP]).length()<dEps)
					{ 
						iStart = jP;
						iEnd = jP + 1;
						break;
					}
				}//next jP
			}// else if(!iStraight)
		}//for (int iP = 0; iP < pts.length() - 1; iP++)
	}//next ipl
	_Map.setMap("Edges", mapEdges);
}
//End Edge Map of the panel//endregion 

//region Display objects
Display dpModel(iColorDefault);
dpModel.transparency(iTransparencyDefault);
Display dpFront(iColorDefault);
dpFront.transparency(iTransparencyDefault);
dpFront.addViewDirection(vecZ);
dpFront.addViewDirection(-vecZ);
dpFront.addHideDirection(vecX);
dpFront.addHideDirection(-vecX);
dpFront.addHideDirection(vecY);
dpFront.addHideDirection(-vecY);		
//End Display objects//endregion 


int iAutomatic = _Map.getInt("Automatic");
if(iAutomatic)
{ 
//	Display dpEdge(1);
	_ThisInst.setAllowGripAtPt0(false);
	
	// collect existing hardware
	HardWrComp hwcs[] = _ThisInst.hardWrComps();
	
// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
	for (int i=hwcs.length()-1; i>=0 ; i--) 
		if (hwcs[i].repType() == _kRTTsl)
			hwcs.removeAt(i); 
	
	String sHWArticleNumber = "";
	HardWrComp hwc(sHWArticleNumber, 1);
	hwc.setCategory(T("|Tooling|"));
	hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
	
	// declare the groupname of the hardware components
	String sHWGroupName;
	{ 
	// element
		// try to catch the element from the parent entity
		Element elHW =sip.element(); 
		// check if the parent entity is an element
		if (!elHW.bIsValid())	elHW = (Element)sip;
		if (elHW.bIsValid()) 	sHWGroupName=elHW.elementGroup().name();
	// loose
		else
		{
			Group groups[] = _ThisInst.groups();
			if (groups.length()>0)	sHWGroupName=groups[0].name();
		}		
	}
	hwc.setGroup(sHWGroupName);
	hwc.setLinkedEntity(sip);
	// 
	Map mapRequests;
	Map mapRequestPlaneProfile;
	mapRequestPlaneProfile.setInt("Transparency", iTransparencyDefault);
	
	_Pt0 = ptCen;
//	PlaneProfile ppSipNet = sip.realBody().getSlice(Plane(ptCen,vecZ));
	PlaneProfile ppSipNet = sip.realBody().shadowProfile(Plane(ptCen,vecZ));
	Plane pnCen(ptCen,vecZ);
	PLine plsOuter[] = ppSipNet.allRings(true, false);
	PLine plOutter = plsOuter[0];
	PLine plOutterAprox = plOutter;
	plOutterAprox.convertToLineApprox(U(10));
	Point3d ptsOutter[] = plOutterAprox.vertexPoints(true);
	PLine plConvexHull;
	plConvexHull.createConvexHull(pnCen, ptsOutter);
	plConvexHull.vis(1);
	PlaneProfile ppConvex(pnCen);
	ppConvex.joinRing(plConvexHull, _kAdd);
	ppConvex.shrink(dEps);
	
	//Trigger generateSingleInstances
	addRecalcTrigger(_kContextRoot, sTriggergenerateSingleInstances );
	
	Map mapXextendedProperties = sip.subMapX("ExtendedProperties");
	int iFloor;
	Vector3d vecWall=_ZW;
	if(mapXextendedProperties.hasInt("IsFloor"))
	{ 
		iFloor = mapXextendedProperties.getInt("IsFloor");
		if(sip.element().bIsValid())
		{ 
			vecWall = sip.element().vecY();
		}
//		vecWall = vecY;
	}
	else
	{ 
		iFloor = true;
		if(vecZ.isPerpendicularTo(_ZW))
		{ 
			iFloor = false;
		}
	}
	
	// get edge information
	Map mapEdges = _Map.getMap("Edges");
	String sFloorWall = "Floor";
	if ( !iFloor)sFloorWall = "Wall";
	if(iFloor)
	{ 
		Map mapManufacturers = mapSetting.getMap("Manufacturer[]");
		Map mapProduct150, mapProduct60;
		int iProduct150Found, iProduct60Found;
		for (int iM=0;iM<mapManufacturers.length();iM++) 
		{ 
			Map mapManufacturerI= mapManufacturers.getMap(iM);
			if (mapManufacturerI.getString("Name") != "Siga")continue;
			Map mapFamilies = mapManufacturerI.getMap("Family[]");
			for (int iF=0;iF<mapFamilies.length();iF++) 
			{ 
				Map mapFamilyI = mapFamilies.getMap(iF);
				if (mapFamilyI.getString("Name") != "Wigluv")continue;
				Map mapProducts = mapFamilyI.getMap("Product[]");
				for (int iP=0;iP<mapProducts.length();iP++) 
				{ 
					Map mapProductI = mapProducts.getMap(iP);
					if(mapProductI.getDouble("Width")==0.15)
					{ 
						mapProduct150 = mapProductI;
						iProduct150Found = true;
					}
					if(mapProductI.getDouble("Width")==0.06)
					{ 
						mapProduct60 = mapProductI;
						iProduct60Found = true;
					}
					if (iProduct150Found && iProduct60Found)break;
				}//next iP
				if (iProduct150Found && iProduct60Found)break;
			}//next iF
			if (iProduct150Found && iProduct60Found)break;
		}//next iM
		
		// draw all edges
		for (int iedge=0;iedge<mapEdges.length();iedge++) 
		{ 
			Map mapEdgeI = mapEdges.getMap(iedge);
			int iStraight = mapEdgeI.getInt("Straight");
			int iOutter = mapEdgeI.getInt("Outter");
			String sOuterEdge="Outter Edge";
			if ( ! iOutter)sOuterEdge = "Inner Edge";
			
			PLine plI = mapEdgeI.getPLine("Pline");
//			plI.vis(2);
			Map mapProfilesI = mapEdgeI.getMap("pps");
			Map mapProfilesTopI = mapEdgeI.getMap("ppsTop");
			double dLengthEdge = mapEdgeI.getDouble("EdgeLength");
			double dWidthEdge = mapEdgeI.getDouble("EdgeThickness");
			
			// find the product
			Map mapProduct;
			int iProductFound;
			int iSingleTape;
			int iNrTapes=1;
			for (int iM=0;iM<mapManufacturers.length();iM++) 
			{ 
				Map mapManufacturerI= mapManufacturers.getMap(iM);
				if (mapManufacturerI.getString("Name") != "Siga")continue;
				Map mapFamilies = mapManufacturerI.getMap("Family[]");
				for (int iF=0;iF<mapFamilies.length();iF++) 
				{ 
					Map mapFamilyI = mapFamilies.getMap(iF);
					if (mapFamilyI.getString("Name") != "Wigluv")continue;
					Map mapProducts = mapFamilyI.getMap("Product[]");
					for (int iP=0;iP<mapProducts.length();iP++) 
					{ 
						Map mapProductI = mapProducts.getMap(iP);
						// 35 mm on each side
						if(1000*mapProductI.getDouble("Width")>(dWidthEdge+U(70)))
						{ 
							mapProduct = mapProductI;
							iProductFound = true;
							iSingleTape = true;
							iNrTapes = 1;
							break;
						}
					}//next iP
					if (iProductFound)break;
				}//next iF
				if (iProductFound)break;
			}//next iM
			int iNr150;
			if(!iSingleTape)
			{ 
				for (int iCount=0;iCount<5;iCount++) 
				{ 
					double dWidthCovered = U(150) * (iCount + 1);
					iNr150 = iCount + 1;
					iNrTapes += 1;
					// get the other tape 
					for (int iM=0;iM<mapManufacturers.length();iM++) 
					{ 
						Map mapManufacturerI= mapManufacturers.getMap(iM);
						if (mapManufacturerI.getString("Name") != "Siga")continue;
						Map mapFamilies = mapManufacturerI.getMap("Family[]");
						for (int iF=0;iF<mapFamilies.length();iF++) 
						{ 
							Map mapFamilyI = mapFamilies.getMap(iF);
							if (mapFamilyI.getString("Name") != "Wigluv")continue;
							Map mapProducts = mapFamilyI.getMap("Product[]");
							for (int iP=0;iP<mapProducts.length();iP++) 
							{ 
								Map mapProductI = mapProducts.getMap(iP);
								if(1000*mapProductI.getDouble("Width")>(dWidthEdge-iNr150*U(150)+U(70)))
								{ 
									mapProduct = mapProductI;
									iProductFound = true;
									break;
								}
							}//next iP
							if (iProductFound)break;
						}//next iF
						if (iProductFound)break;
					}//next iM
					if (iProductFound)break;
				}//next iCount
			}
			//
			int iColor=iColorDefault;
			int iTransparency=iTransparencyDefault;
			double dTapeWidthFront = dTapeWidthFrontDefault;
			Map mapDisplayFound;
			int iMapDisplayFound;
			for (int imap=0;imap<mapDisplays.length();imap++) 
			{ 
				Map m = mapDisplays.getMap(imap);
				if(m.hasInt("NrTapesEdge") && m.getInt("NrTapesEdge")==iNrTapes)
				{ 
					iMapDisplayFound = true;
					mapDisplayFound = m;
					{ 
						String k;
						k = "Color";if (m.hasInt(k))iColor = m.getInt(k);
						k = "Transparency";if (m.hasInt(k))iTransparency = m.getInt(k);
						k = "TapeWidthFront";if (m.hasDouble(k))dTapeWidthFront = m.getDouble(k);
					}
					break;
				}
			}//next imap
			
			dpModel.color(iColor);
			dpModel.transparency(iTransparency);
			dpFront.color(iColor);
			dpFront.transparency(iTransparency);
			
//			int iColor;
//			if (iSingleTape)
//			{
//				iColor = 1;
////				dpEdge.color(1);
//				// default colors
//				dpModel.color(iColor);
//				dpFront.color(iColor);
//			}
//			else if(!iSingleTape)
//			{
//				iColor = 5;
////				dpEdge.color(5);
//				dpModel.color(5);
//				dpFront.color(5);
//			}
			for (int ipp=0;ipp<mapProfilesI.length();ipp++) 
			{ 
				Map mapPpI = mapProfilesI.getMap(ipp);
				if(mapPpI.hasPlaneProfile("pp"))
				{ 
					PlaneProfile ppI = mapPpI.getPlaneProfile("pp");
//					dpEdge.draw(ppI,_kDrawFilled);
					dpModel.draw(ppI,_kDrawFilled);
				}
				else
				{ 
					Map _mapProfilesI = mapProfilesI.getMap(ipp);
					for (int _ipp=0;_ipp<_mapProfilesI.length();_ipp++) 
					{ 
						Map _mapPpI = _mapProfilesI.getMap(_ipp);
						PlaneProfile _ppI = _mapPpI.getPlaneProfile("pp");
//						dpEdge.draw(_ppI,_kDrawFilled);
						dpModel.draw(_ppI,_kDrawFilled);
					}//next _ipp
				}
			}//next ipp
			for (int ipp=0;ipp<mapProfilesTopI.length();ipp++) 
			{ 
				Map mapPpI = mapProfilesTopI.getMap(ipp);
				if(mapPpI.hasPlaneProfile("pp"))
				{ 
					Vector3d vecXpp = mapPpI.getVector3d("vecX");
					Vector3d vecYpp = mapPpI.getVector3d("vecY");
					PlaneProfile ppI = mapPpI.getPlaneProfile("pp");
					PlaneProfile ppNew(ppI.coordSys());
					{ 
					// get extents of profile
						LineSeg segpp = ppI.extentInDir(vecXpp);
						double dXpp = abs(vecXpp.dotProduct(segpp.ptStart()-segpp.ptEnd()));
						double dYpp = abs(vecYpp.dotProduct(segpp.ptStart()-segpp.ptEnd()));
						PLine plNew;
						plNew.createRectangle(LineSeg(segpp.ptMid()-vecYpp*.5*dTapeWidthFront-vecXpp*.5*dXpp,
						segpp.ptMid() + vecYpp * .5 * dTapeWidthFront + vecXpp * .5 * dXpp), vecXpp, vecYpp);
						ppNew.joinRing(plNew, _kAdd);
					}
					
//					dpEdge.draw(ppI,_kDrawFilled);
//					dpFront.draw(ppI,_kDrawFilled);
					dpFront.draw(ppNew,_kDrawFilled);
					// maprequest for shopdrawing
					Map mapRequestPlaneProfileI = mapRequestPlaneProfile;
					mapRequestPlaneProfileI.setString("Stereotype", "PlaneProfileTape");
					mapRequestPlaneProfileI.setPlaneProfile("PlaneProfile", ppI);
					mapRequestPlaneProfileI.setVector3d("AllowedView", -vecZ);
					mapRequestPlaneProfileI.setInt("AlsoReverseDirection", true); 
					mapRequestPlaneProfileI.setInt("Color", iColor);
			        mapRequestPlaneProfileI.setInt("DrawFilled", _kDrawFilled);
			        mapRequestPlaneProfileI.setInt("ShowForDirOfView", true);
			        mapRequestPlaneProfileI.setInt("ShowForOppositeDirOfView", true);
			        mapRequests.appendMap("DimRequest", mapRequestPlaneProfileI);
				}
				else
				{ 
					Map _mapProfilesI = mapProfilesTopI.getMap(ipp);
					for (int _ipp=0;_ipp<_mapProfilesI.length();_ipp++) 
					{ 
						Map _mapPpI = _mapProfilesI.getMap(_ipp);
						PlaneProfile _ppI = _mapPpI.getPlaneProfile("pp");
						Vector3d vecXpp = _mapPpI.getVector3d("vecX");
						Vector3d vecYpp = _mapPpI.getVector3d("vecY");
						PlaneProfile ppNew(_ppI.coordSys());
						{ 
						// get extents of profile
							LineSeg segpp = _ppI.extentInDir(vecXpp);
							double dXpp = abs(vecXpp.dotProduct(segpp.ptStart()-segpp.ptEnd()));
							double dYpp = abs(vecYpp.dotProduct(segpp.ptStart()-segpp.ptEnd()));
							PLine plNew;
							plNew.createRectangle(LineSeg(segpp.ptMid()-vecYpp*.5*dTapeWidthFront-vecXpp*.5*dXpp,
							segpp.ptMid() + vecYpp * .5 * dTapeWidthFront + vecXpp * .5 * dXpp), vecXpp, vecYpp);
							ppNew.joinRing(plNew, _kAdd);
						}
//						dpEdge.draw(_ppI,_kDrawFilled);
//						dpFront.draw(_ppI,_kDrawFilled);
						dpFront.draw(ppNew,_kDrawFilled);
						// maprequest for shopdrawing
						Map mapRequestPlaneProfileI = mapRequestPlaneProfile;
						mapRequestPlaneProfileI.setString("Stereotype", "PlaneProfileTape");
						mapRequestPlaneProfileI.setPlaneProfile("PlaneProfile", _ppI);
						mapRequestPlaneProfileI.setVector3d("AllowedView", -vecZ);
						mapRequestPlaneProfileI.setInt("AlsoReverseDirection", true); 
						mapRequestPlaneProfileI.setInt("Color", iColor);
				        mapRequestPlaneProfileI.setInt("DrawFilled", _kDrawFilled);
				        mapRequestPlaneProfileI.setInt("ShowForDirOfView", true);
				        mapRequestPlaneProfileI.setInt("ShowForOppositeDirOfView", true);
				        mapRequests.appendMap("DimRequest", mapRequestPlaneProfileI);
					}//next _ipp
				}
			}//next ipp
			
			// collect hardware
			HardWrComp hwcI = hwc;
			String sPosnum = sip.posnum();
			String sPanelName = sip.name();
			String sPanelInfo = sip.information();
			String sHWDescription = sPosnum+";"+sPanelName + ";" 
				+ sPanelInfo+";";
			
			// edge
			String sHWDescriptionI = sHWDescription + sOuterEdge+";"+sFloorWall+";";
			hwcI.setDescription(sHWDescriptionI);
			hwcI.setDScaleX(dLengthEdge+U(20));
			hwcI.setDScaleY(mapProduct.getDouble("Width")*1000);
			hwcI.setArticleNumber(mapProduct.getString("ArticleNumber"));
			hwcs.append(hwcI);
			// apply on top side the 60
			hwcI.setDescription(sHWDescriptionI);
			hwcI.setDScaleX(dLengthEdge);
			hwcI.setDScaleY(mapProduct60.getDouble("Width")*1000);
			hwcI.setArticleNumber(mapProduct60.getString("ArticleNumber"));
			hwcs.append(hwcI);
			if(!iSingleTape)
			{ 
				// 150
				String sHWDescriptionI = sHWDescription + sOuterEdge+";"+sFloorWall+";";
				hwcI.setQuantity(iNr150);
				hwcI.setDescription(sHWDescriptionI);
				hwcI.setDScaleX(dLengthEdge+U(20));
				hwcI.setDScaleY(mapProduct150.getDouble("Width")*1000);
				hwcI.setArticleNumber(mapProduct150.getString("ArticleNumber"));
				hwcs.append(hwcI);
			}
			if (_bOnRecalc && _kExecuteKey==sTriggergenerateSingleInstances)
			{
				// create TSL
	        	TslInst tslNew;		Vector3d vecXTsl= _XW;	Vector3d vecYTsl= _YW;
	        	GenBeam gbsTsl[1];	Entity entsTsl[] = {};	Point3d ptsTsl[1];
	        	int nProps[]={};	double dProps[]={};		String sProps[]={};
	        	Map mapTsl;	
	        	
	        	Point3d ptEdge = mapEdgeI.getPoint3d("ptEdge");
	        	Point3d ptEdge1 = mapEdgeI.getPoint3d("ptEdgeStart");
	        	Point3d ptEdge2 = mapEdgeI.getPoint3d("ptEdgeEnd");
//	        	Vector3d vecClosest = ptMid - ptCen;
//				double dXclosest = vecX.dotProduct(vecClosest);
//				double dYclosest = vecY.dotProduct(vecClosest);
//				mapTsl.setDouble("dXclosest", dXclosest);
//				mapTsl.setDouble("dYclosest", dYclosest);
	        	mapTsl.setInt("Automatic", false);
	        	mapTsl.setMap("Edges", mapEdges);
	        	gbsTsl[0] = sip;
	        	
				// generate single instance
				ptsTsl[0] = ptEdge;
//				ptsTsl[1] = ptEdge1;
//				ptsTsl[2] = ptEdge2;
				tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, 
					ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
			}
		}//next iedge
		if (mapRequests.length() > 0)
		{
			_Map.setMap("DimRequest[]", mapRequests);
		}
		else
		{
			_Map.removeAt("DimRequest[]", true);
		}
	}
	else if(!iFloor)
	{ 
		Map mapManufacturers = mapSetting.getMap("Manufacturer[]");
		Map mapProduct150;
		int iProduct150Found;
		for (int iM=0;iM<mapManufacturers.length();iM++) 
		{ 
			Map mapManufacturerI= mapManufacturers.getMap(iM);
			if (mapManufacturerI.getString("Name") != "Siga")continue;
			Map mapFamilies = mapManufacturerI.getMap("Family[]");
			for (int iF=0;iF<mapFamilies.length();iF++) 
			{ 
				Map mapFamilyI = mapFamilies.getMap(iF);
				if (mapFamilyI.getString("Name") != "Wigluv")continue;
				Map mapProducts = mapFamilyI.getMap("Product[]");
				for (int iP=0;iP<mapProducts.length();iP++) 
				{ 
					Map mapProductI = mapProducts.getMap(iP);
					if(mapProductI.getDouble("Width")==0.15)
					{ 
						mapProduct150 = mapProductI;
						iProduct150Found = true;
					}
					if (iProduct150Found )break;
				}//next iP
				if (iProduct150Found)break;
			}//next iF
			if (iProduct150Found)break;
		}//next iM
//		Display dpEdgeWall(1);
		for (int iedge=0;iedge<mapEdges.length();iedge++) 
		{ 
			Map mapEdgeI = mapEdges.getMap(iedge);
			int iStraight = mapEdgeI.getInt("Straight");
			int iOutter = mapEdgeI.getInt("Outter");
			
			String sOuterEdge="Outter Edge";
			if ( ! iOutter)sOuterEdge = "Inner Edge";
			PLine plI = mapEdgeI.getPLine("Pline");
			plI.vis(2);
			Map mapProfilesI = mapEdgeI.getMap("pps");
			Map mapProfilesTopI = mapEdgeI.getMap("ppsTop");
			double dLengthEdge, dWidthEdge;
			int iTapeEdge;
			int iVertical;
			int iTop;
			PlaneProfile ppsDraw[0], ppsTopDraw[0];
			Vector3d vecXtopDraw[0],vecYtopDraw[0];
			if(iStraight)
			{ 
				Vector3d vecEdgeOutter = mapEdgeI.getVector3d("vecEdgeOutter");
				Point3d ptEdge = mapEdgeI.getPoint3d("ptEdge");
				if(abs(vecEdgeOutter.dotProduct(vecWall))<.1*dEps)
				{ 
					// vertical edge
					iVertical = true;
					continue;
				}
				
				if(!iOutter)
				{ 
					// opening
					if(vecEdgeOutter.dotProduct(vecWall)<0)
					{ 
						// downward edges at openings not to be considered
						continue;
					}
				}
				
				if(ppConvex.pointInProfile(ptEdge)== _kPointInProfile)
				{ 
					if(vecEdgeOutter.dotProduct(vecWall)<0)
					{ 
						// downward edges inside convex
						continue;
					}
					if(abs(vecEdgeOutter.dotProduct(vecWall))<.1*dEps)
					{ 
						// vertical edge inside convex
						continue;
					}
				}
				if (vecEdgeOutter.dotProduct(vecWall) > 0)iTop = true;
				for (int ipp=0;ipp<mapProfilesI.length();ipp++) 
				{ 
					Map mapPpI = mapProfilesI.getMap(ipp);
					Map mapPpTopI = mapProfilesTopI.getMap(ipp);
					if(mapPpI.hasPlaneProfile("pp"))
					{ 
						Vector3d vecXpp = mapPpTopI.getVector3d("vecX");
						Vector3d vecYpp = mapPpTopI.getVector3d("vecY");
						PlaneProfile ppI = mapPpI.getPlaneProfile("pp");
						PlaneProfile ppTopI = mapPpTopI.getPlaneProfile("pp");
						ppsDraw.append(ppI);
						ppsTopDraw.append(ppTopI);
						vecXtopDraw.append(vecXpp);
						vecYtopDraw.append(vecYpp);
//						dpEdge.draw(ppI,_kDrawFilled);
//						dpEdge.draw(ppTopI,_kDrawFilled);
//						// maprequest for shopdrawing
//						Map mapRequestPlaneProfileI = mapRequestPlaneProfile;
//						mapRequestPlaneProfileI.setString("Stereotype", "PlaneProfileTape");
//						mapRequestPlaneProfileI.setPlaneProfile("PlaneProfile", ppTopI);
//						mapRequestPlaneProfileI.setVector3d("AllowedView", -vecZ);
//						mapRequestPlaneProfileI.setInt("AlsoReverseDirection", true); 
//						mapRequestPlaneProfileI.setInt("Color", 1);
//				        mapRequestPlaneProfileI.setInt("DrawFilled", _kDrawFilled);
//				        mapRequestPlaneProfileI.setInt("ShowForDirOfView", true);
//				        mapRequestPlaneProfileI.setInt("ShowForOppositeDirOfView", true);
//				        mapRequests.appendMap("DimRequest", mapRequestPlaneProfileI);
					}
				}//next ipp
				dLengthEdge = mapEdgeI.getDouble("EdgeLength");
				dWidthEdge = mapEdgeI.getDouble("EdgeThickness");
				iTapeEdge = true;
			}
			else if(!iStraight)
			{ 
				for (int ipp=0;ipp<mapProfilesI.length();ipp++) 
				{ 
					Map mapPpI = mapProfilesI.getMap(ipp);
					Map mapPpTopI = mapProfilesTopI.getMap(ipp);
					if(!mapPpI.hasPlaneProfile("pp"))
					{ 
						Map _mapProfilesI = mapProfilesI.getMap(ipp);
						Map _mapProfilesTopI = mapProfilesTopI.getMap(ipp);
						for (int _ipp=0;_ipp<_mapProfilesI.length();_ipp++) 
						{ 
							Map _mapPpI = _mapProfilesI.getMap(_ipp);
							Map _mapPpTopI = _mapProfilesTopI.getMap(_ipp);
							Vector3d vecEdgeOutter = mapEdgeI.getVector3d("vecEdgeOutter"+ipp);
							Point3d ptEdge = mapEdgeI.getPoint3d("ptEdge"+ipp);
							
							if(ppConvex.pointInProfile(ptEdge)== _kPointInProfile)
							{ 
								if(vecEdgeOutter.dotProduct(vecWall)<0)
								{ 
									continue;
								}
							}
							dLengthEdge += mapEdgeI.getDouble("EdgeLength"+ipp);
							
							
							PlaneProfile _ppI = _mapPpI.getPlaneProfile("pp");
							PlaneProfile _ppTopI = _mapPpTopI.getPlaneProfile("pp");
							Vector3d vecXpp = _mapPpTopI.getVector3d("vecX");
							Vector3d vecYpp = _mapPpTopI.getVector3d("vecY");
//							vecEdgeOutter.vis(_ppI.coordSys().ptOrg());
							if(abs(vecEdgeOutter.dotProduct(vecWall))<.1*dEps)
							{ 
								vecEdgeOutter.vis(_ppI.coordSys().ptOrg());
								// vertical edge
								continue;
							}
							
							if(!iOutter)
							{ 
								// opening
								if(vecEdgeOutter.dotProduct(vecWall)<0)
								{ 
									// downward edges at openings not to be considered
									continue;
								}
							}
							iTapeEdge = true;
							ppsDraw.append(_ppI);
							ppsTopDraw.append(_ppTopI);
							vecXtopDraw.append(vecXpp);
							vecYtopDraw.append(vecYpp);
//							dpEdge.draw(_ppI,_kDrawFilled);
//							dpEdge.draw(_ppTopI,_kDrawFilled);
//							// maprequest for shopdrawing
//							Map mapRequestPlaneProfileI = mapRequestPlaneProfile;
//							mapRequestPlaneProfileI.setString("Stereotype", "PlaneProfileTape");
//							mapRequestPlaneProfileI.setPlaneProfile("PlaneProfile", _ppTopI);
//							mapRequestPlaneProfileI.setVector3d("AllowedView", -vecZ);
//							mapRequestPlaneProfileI.setInt("AlsoReverseDirection", true); 
//							mapRequestPlaneProfileI.setInt("Color", 1);
//					        mapRequestPlaneProfileI.setInt("DrawFilled", _kDrawFilled);
//					        mapRequestPlaneProfileI.setInt("ShowForDirOfView", true);
//					        mapRequestPlaneProfileI.setInt("ShowForOppositeDirOfView", true);
//					        mapRequests.appendMap("DimRequest", mapRequestPlaneProfileI);
						}//next _ipp
					}
				}//next ipp
				dWidthEdge = mapEdgeI.getDouble("EdgeThickness");
			}
			
			if(iTapeEdge)
			{ 
				// collect hardware
				HardWrComp hwcI = hwc;
				String sPosnum = sip.posnum();
				String sPanelName = sip.name();
				String sPanelInfo = sip.information();
				String sHWDescription = sPosnum+";"+sPanelName + ";" 
					+ sPanelInfo+";";
				if(iVertical)
				{ 
					double dExtraWidth = U(80);
					if (sSQTop == "VQ")dExtraWidth -= U(40);
					if (sSQBottom == "VQ")dExtraWidth -= U(40);
					// find the product
					Map mapProduct;
					int iProductFound;
					int iSingleTape;
					int iNrTapes = 1;
					for (int iM=0;iM<mapManufacturers.length();iM++) 
					{ 
						Map mapManufacturerI= mapManufacturers.getMap(iM);
						if (mapManufacturerI.getString("Name") != "Siga")continue;
						Map mapFamilies = mapManufacturerI.getMap("Family[]");
						for (int iF=0;iF<mapFamilies.length();iF++) 
						{ 
							Map mapFamilyI = mapFamilies.getMap(iF);
							if (mapFamilyI.getString("Name") != "Wigluv")continue;
							Map mapProducts = mapFamilyI.getMap("Product[]");
							for (int iP=0;iP<mapProducts.length();iP++) 
							{ 
								Map mapProductI = mapProducts.getMap(iP);
								// 35 mm on each side
								if(1000*mapProductI.getDouble("Width")>(dWidthEdge+dExtraWidth))
								{ 
									mapProduct = mapProductI;
									iProductFound = true;
									iSingleTape = true;
									iNrTapes = 1;
									break;
								}
							}//next iP
							if (iProductFound)break;
						}//next iF
						if (iProductFound)break;
					}//next iM
					int iNr150;
					if(!iSingleTape)
					{ 
						for (int iCount=0;iCount<5;iCount++) 
						{ 
							double dWidthCovered = U(150) * (iCount + 1);
							iNr150 = iCount + 1;
							iNrTapes += 1;
							// get the other tape 
							for (int iM=0;iM<mapManufacturers.length();iM++) 
							{ 
								Map mapManufacturerI= mapManufacturers.getMap(iM);
								if (mapManufacturerI.getString("Name") != "Siga")continue;
								Map mapFamilies = mapManufacturerI.getMap("Family[]");
								for (int iF=0;iF<mapFamilies.length();iF++) 
								{ 
									Map mapFamilyI = mapFamilies.getMap(iF);
									if (mapFamilyI.getString("Name") != "Wigluv")continue;
									Map mapProducts = mapFamilyI.getMap("Product[]");
									for (int iP=0;iP<mapProducts.length();iP++) 
									{ 
										Map mapProductI = mapProducts.getMap(iP);
										if(1000*mapProductI.getDouble("Width")>(dWidthEdge-iNr150*U(150)+dExtraWidth))
										{ 
											mapProduct = mapProductI;
											iProductFound = true;
											break;
										}
									}//next iP
									if (iProductFound)break;
								}//next iF
								if (iProductFound)break;
							}//next iM
							if (iProductFound)break;
						}//next iCount
					}
					int iColor=iColorDefault;
					int iTransparency=iTransparencyDefault;
					double dTapeWidthFront = dTapeWidthFrontDefault;
					Map mapDisplayFound;
					int iMapDisplayFound;
					for (int imap=0;imap<mapDisplays.length();imap++) 
					{ 
						Map m = mapDisplays.getMap(imap);
						if(m.hasInt("NrTapesEdge") && m.getInt("NrTapesEdge")==iNrTapes)
						{ 
							iMapDisplayFound = true;
							mapDisplayFound = m;
							{ 
								String k;
								k = "Color";if (m.hasInt(k))iColor = m.getInt(k);
								k = "Transparency";if (m.hasInt(k))iTransparency = m.getInt(k);
								k = "TapeWidthFront";if (m.hasDouble(k))dTapeWidthFront = m.getDouble(k);
							}
							break;
						}
					}//next imap
					
					dpModel.color(iColor);
					dpModel.transparency(iTransparency);
					dpFront.color(iColor);
					dpFront.transparency(iTransparency);
					
//					int iColor;
//					if (iSingleTape)
//					{
//						iColor = iColorDefault;
////						dpEdge.color(1);
//						// keep default parameters
//						iColor = iColorDefault;
//						dpModel.color(iColorDefault);
//						dpFront.color(iColorDefault);
//					}
//					else if(!iSingleTape)
//					{
//						iColor = 5;
////						dpEdge.color(5);
//						dpModel.color(5);
//						dpFront.color(5);
//					}
					for (int ipp=0;ipp<ppsDraw.length();ipp++) 
					{ 
//						dpEdge.draw( ppsDraw[ipp],_kDrawFilled);
						dpModel.draw( ppsDraw[ipp],_kDrawFilled);
					}//next ipp
					for (int ipp=0;ipp<ppsTopDraw.length();ipp++) 
					{ 
//						dpEdge.draw( ppsTopDraw[ipp],_kDrawFilled);
						PlaneProfile pp = ppsTopDraw[ipp];
						PlaneProfile ppNew(pp.coordSys());
						{ 
						// get extents of profile
							Vector3d vecXpp = vecXtopDraw[ipp];
							Vector3d vecYpp = vecYtopDraw[ipp];
							LineSeg segpp = pp.extentInDir(vecXpp);
							double dXpp = abs(vecXpp.dotProduct(segpp.ptStart()-segpp.ptEnd()));
							double dYpp = abs(vecYpp.dotProduct(segpp.ptStart()-segpp.ptEnd()));
							PLine plNew;
							plNew.createRectangle(LineSeg(segpp.ptMid()-vecYpp*.5*dTapeWidthFront-vecXpp*.5*dXpp,
							segpp.ptMid() + vecYpp * .5 * dTapeWidthFront + vecXpp * .5 * dXpp), vecXpp, vecYpp);
							
							ppNew.joinRing(plNew, _kAdd);
						}
						dpFront.draw( ppNew,_kDrawFilled);
//						dpFront.draw( ppsTopDraw[ipp],_kDrawFilled);
						// maprequest for shopdrawing
						Map mapRequestPlaneProfileI = mapRequestPlaneProfile;
						mapRequestPlaneProfileI.setInt("Transparency", iTransparency);
						mapRequestPlaneProfileI.setString("Stereotype", "PlaneProfileTape");
						mapRequestPlaneProfileI.setPlaneProfile("PlaneProfile", ppNew);
						mapRequestPlaneProfileI.setVector3d("AllowedView", -vecZ);
						mapRequestPlaneProfileI.setInt("AlsoReverseDirection", true); 
						mapRequestPlaneProfileI.setInt("Color", iColor);
				        mapRequestPlaneProfileI.setInt("DrawFilled", _kDrawFilled);
				        mapRequestPlaneProfileI.setInt("ShowForDirOfView", true);
				        mapRequestPlaneProfileI.setInt("ShowForOppositeDirOfView", true);
				        mapRequests.appendMap("DimRequest", mapRequestPlaneProfileI);
					}//next ipp
					
					// vertical edge same length
					String sHWDescriptionI = sHWDescription + sOuterEdge+";"+sFloorWall+";";;
					hwcI.setDescription(sHWDescriptionI);
					hwcI.setDScaleX(dLengthEdge);
					hwcI.setDScaleY(mapProduct.getDouble("Width")*1000);
					hwcI.setArticleNumber(mapProduct.getString("ArticleNumber"));
					hwcs.append(hwcI);
					if(!iSingleTape)
					{ 
						// 150
						String sHWDescriptionI = sHWDescription + sOuterEdge+";"+sFloorWall+";";
						hwcI.setQuantity(iNr150);
						hwcI.setDescription(sHWDescriptionI);
						hwcI.setDScaleX(dLengthEdge+U(20));
						hwcI.setDScaleY(mapProduct150.getDouble("Width")*1000);
						hwcI.setArticleNumber(mapProduct150.getString("ArticleNumber"));
						hwcs.append(hwcI);
					}
				}
				else if (!iVertical)
				{ 
					// top or bottom
					if(iTop)
					{ 
						// top edge
						double dExtraWidth = U(0);
						// find the product
						Map mapProduct;
						int iProductFound;
						int iSingleTape;
						int iNrTapes = 1;
						for (int iM=0;iM<mapManufacturers.length();iM++) 
						{ 
							Map mapManufacturerI= mapManufacturers.getMap(iM);
							if (mapManufacturerI.getString("Name") != "Siga")continue;
							Map mapFamilies = mapManufacturerI.getMap("Family[]");
							for (int iF=0;iF<mapFamilies.length();iF++) 
							{ 
								Map mapFamilyI = mapFamilies.getMap(iF);
								if (mapFamilyI.getString("Name") != "Wigluv")continue;
								Map mapProducts = mapFamilyI.getMap("Product[]");
								for (int iP=0;iP<mapProducts.length();iP++) 
								{ 
									Map mapProductI = mapProducts.getMap(iP);
									// 35 mm on each side
									if(1000*mapProductI.getDouble("Width")>(dWidthEdge+dExtraWidth))
									{ 
										mapProduct = mapProductI;
										iProductFound = true;
										iSingleTape = true;
										iNrTapes = 1;
										break;
									}
								}//next iP
								if (iProductFound)break;
							}//next iF
							if (iProductFound)break;
						}//next iM
						int iNr150;
						
						if(!iSingleTape)
						{ 
							for (int iCount = 0; iCount < 5; iCount++)
							{
								double dWidthCovered = U(150) * (iCount + 1);
								iNr150 = iCount + 1;
								iNrTapes += 1;
								// get the other tape
								for (int iM = 0; iM < mapManufacturers.length(); iM++)
								{
									Map mapManufacturerI = mapManufacturers.getMap(iM);
									if (mapManufacturerI.getString("Name") != "Siga")continue;
									Map mapFamilies = mapManufacturerI.getMap("Family[]");
									for (int iF = 0; iF < mapFamilies.length(); iF++)
									{
										Map mapFamilyI = mapFamilies.getMap(iF);
										if (mapFamilyI.getString("Name") != "Wigluv")continue;
										Map mapProducts = mapFamilyI.getMap("Product[]");
										for (int iP = 0; iP < mapProducts.length(); iP++)
										{
											Map mapProductI = mapProducts.getMap(iP);
											if (1000 * mapProductI.getDouble("Width") > (dWidthEdge - iNr150*U(150)))
											{
												mapProduct = mapProductI;
												iProductFound = true;
												break;
											}
										}//next iP
										if (iProductFound)break;
									}//next iF
									if (iProductFound)break;
								}//next iM
								if (iProductFound)break;
							}
						}
						int iColor=iColorDefault;
						int iTransparency=iTransparencyDefault;
						double dTapeWidthFront = dTapeWidthFrontDefault;
						Map mapDisplayFound;
						int iMapDisplayFound;
						for (int imap=0;imap<mapDisplays.length();imap++) 
						{ 
							Map m = mapDisplays.getMap(imap);
							if(m.hasInt("NrTapesEdge") && m.getInt("NrTapesEdge")==iNrTapes)
							{ 
								iMapDisplayFound = true;
								mapDisplayFound = m;
								{ 
									String k;
									k = "Color";if (m.hasInt(k))iColor = m.getInt(k);
									k = "Transparency";if (m.hasInt(k))iTransparency = m.getInt(k);
									k = "TapeWidthFront";if (m.hasDouble(k))dTapeWidthFront = m.getDouble(k);
								}
								break;
							}
						}//next imap
						
						dpModel.color(iColor);
						dpModel.transparency(iTransparency);
						dpFront.color(iColor);
						dpFront.transparency(iTransparency);
//						int iColor;
//						if (iSingleTape)
//						{
////							iColor = 1;
////							dpEdge.color(1);
//							iColor = iColorDefault;
//							dpModel.color(iColor);
//							dpFront.color(iColor);
//						}
//						else if(!iSingleTape)
//						{
//							iColor = 5;
////							dpEdge.color(5);
//							dpModel.color(5);
//							dpFront.color(5);
//						}
						for (int ipp=0;ipp<ppsDraw.length();ipp++) 
						{ 
//							dpEdge.draw( ppsDraw[ipp],_kDrawFilled);
							dpModel.draw( ppsDraw[ipp],_kDrawFilled);
						}//next ipp
						for (int ipp=0;ipp<ppsTopDraw.length();ipp++) 
						{ 
//							dpEdge.draw( ppsTopDraw[ipp],_kDrawFilled);
//							dpFront.draw( ppsTopDraw[ipp],_kDrawFilled);
							PlaneProfile pp = ppsTopDraw[ipp];
							PlaneProfile ppNew(pp.coordSys());
							{ 
							// get extents of profile
								Vector3d vecXpp = vecXtopDraw[ipp];
								Vector3d vecYpp = vecYtopDraw[ipp];
								LineSeg segpp = pp.extentInDir(vecXpp);
								double dXpp = abs(vecXpp.dotProduct(segpp.ptStart()-segpp.ptEnd()));
								double dYpp = abs(vecYpp.dotProduct(segpp.ptStart()-segpp.ptEnd()));
								PLine plNew;
								plNew.createRectangle(LineSeg(segpp.ptMid()-vecYpp*.5*dTapeWidthFront-vecXpp*.5*dXpp,
								segpp.ptMid() + vecYpp * .5 * dTapeWidthFront + vecXpp * .5 * dXpp), vecXpp, vecYpp);
								
								ppNew.joinRing(plNew, _kAdd);
							}
							dpFront.draw( ppNew,_kDrawFilled);
							// maprequest for shopdrawing
							Map mapRequestPlaneProfileI = mapRequestPlaneProfile;
							mapRequestPlaneProfileI.setInt("Transparency", iTransparency);
							mapRequestPlaneProfileI.setString("Stereotype", "PlaneProfileTape");
							mapRequestPlaneProfileI.setPlaneProfile("PlaneProfile", ppNew);
							mapRequestPlaneProfileI.setVector3d("AllowedView", -vecZ);
							mapRequestPlaneProfileI.setInt("AlsoReverseDirection", true); 
							mapRequestPlaneProfileI.setInt("Color", iColor);
					        mapRequestPlaneProfileI.setInt("DrawFilled", _kDrawFilled);
					        mapRequestPlaneProfileI.setInt("ShowForDirOfView", true);
					        mapRequestPlaneProfileI.setInt("ShowForOppositeDirOfView", true);
					        mapRequests.appendMap("DimRequest", mapRequestPlaneProfileI);
						}//next ipp
						// top edge 
						String sHWDescriptionI = sHWDescription + sOuterEdge+";"+sFloorWall+";";;
						hwcI.setDescription(sHWDescriptionI);
						hwcI.setDScaleX(dLengthEdge+U(80));
						hwcI.setDScaleY(mapProduct.getDouble("Width")*1000);
						hwcI.setArticleNumber(mapProduct.getString("ArticleNumber"));
						hwcs.append(hwcI);
						if(!iSingleTape)
						{ 
							// 150
							String sHWDescriptionI = sHWDescription + sOuterEdge+";"+sFloorWall+";";
							hwcI.setQuantity(iNr150);
							hwcI.setDescription(sHWDescriptionI);
							hwcI.setDScaleX(dLengthEdge+U(80));
							hwcI.setDScaleY(mapProduct150.getDouble("Width")*1000);
							hwcI.setArticleNumber(mapProduct150.getString("ArticleNumber"));
							hwcs.append(hwcI);
						}
					}
					else if(!iTop)
					{ 
						// bottom edge
//						double dExtraWidth = U(200);
						double dExtraWidth = U(100);
						// visible quality only 4 cm each side
						if (sSQTop == "VQ")dExtraWidth -= U(60);
						if (sSQBottom == "VQ")dExtraWidth -= U(60);
						// find the product
						Map mapProduct;
						int iProductFound;
						int iSingleTape;
						int iNrTapes=1;
						for (int iM=0;iM<mapManufacturers.length();iM++) 
						{ 
							Map mapManufacturerI= mapManufacturers.getMap(iM);
							if (mapManufacturerI.getString("Name") != "Siga")continue;
							Map mapFamilies = mapManufacturerI.getMap("Family[]");
							for (int iF=0;iF<mapFamilies.length();iF++) 
							{ 
								Map mapFamilyI = mapFamilies.getMap(iF);
								if (mapFamilyI.getString("Name") != "Wigluv")continue;
								Map mapProducts = mapFamilyI.getMap("Product[]");
								for (int iP=0;iP<mapProducts.length();iP++) 
								{ 
									Map mapProductI = mapProducts.getMap(iP);
									// 35 mm on each side
									if(1000*mapProductI.getDouble("Width")>(dWidthEdge+dExtraWidth))
									{ 
										mapProduct = mapProductI;
										iProductFound = true;
										iSingleTape = true;
										iNrTapes = 1;
										break;
									}
								}//next iP
								if (iProductFound)break;
							}//next iF
							if (iProductFound)break;
						}//next iM
						int iNr150;
						if(!iSingleTape)
						{ 
							for (int iCount = 0; iCount < 5; iCount++)
							{
								double dWidthCovered = U(150) * (iCount + 1);
								iNr150 = iCount + 1;
								iNrTapes += 1;
								// get the other tape
								for (int iM = 0; iM < mapManufacturers.length(); iM++)
								{
									Map mapManufacturerI = mapManufacturers.getMap(iM);
									if (mapManufacturerI.getString("Name") != "Siga")continue;
									Map mapFamilies = mapManufacturerI.getMap("Family[]");
									for (int iF = 0; iF < mapFamilies.length(); iF++)
									{
										Map mapFamilyI = mapFamilies.getMap(iF);
										if (mapFamilyI.getString("Name") != "Wigluv")continue;
										Map mapProducts = mapFamilyI.getMap("Product[]");
										for (int iP = 0; iP < mapProducts.length(); iP++)
										{
											Map mapProductI = mapProducts.getMap(iP);
											if (1000 * mapProductI.getDouble("Width") > (dWidthEdge - iNr150*U(150)+dExtraWidth))
											{
												mapProduct = mapProductI;
												iProductFound = true;
												break;
											}
										}//next iP
										if (iProductFound)break;
									}//next iF
									if (iProductFound)break;
								}//next iM
								if (iProductFound)break;
							}
						}
						int iColor=iColorDefault;
						int iTransparency=iTransparencyDefault;
						double dTapeWidthFront = dTapeWidthFrontDefault;
						Map mapDisplayFound;
						int iMapDisplayFound;
						for (int imap=0;imap<mapDisplays.length();imap++) 
						{ 
							Map m = mapDisplays.getMap(imap);
							if(m.hasInt("NrTapesEdge") && m.getInt("NrTapesEdge")==iNrTapes)
							{ 
								iMapDisplayFound = true;
								mapDisplayFound = m;
								{ 
									String k;
									k = "Color";if (m.hasInt(k))iColor = m.getInt(k);
									k = "Transparency";if (m.hasInt(k))iTransparency = m.getInt(k);
									k = "TapeWidthFront";if (m.hasDouble(k))dTapeWidthFront = m.getDouble(k);
								}
								break;
							}
						}//next imap
						
						dpModel.color(iColor);
						dpModel.transparency(iTransparency);
						dpFront.color(iColor);
						dpFront.transparency(iTransparency);
//						int iColor;
//						if (iSingleTape)
//						{
////							iColor = 1;
////							dpEdge.color(1);
//							iColor = iColorDefault;
//							dpModel.color(iColor);
//							dpFront.color(iColor);
//						}
//						else if(!iSingleTape)
//						{
//							iColor = 5;
////							dpEdge.color(5);
//							dpModel.color(iColor);
//							dpFront.color(iColor);
//						}
						for (int ipp=0;ipp<ppsDraw.length();ipp++) 
						{ 
//							dpEdge.draw( ppsDraw[ipp],_kDrawFilled);
							dpModel.draw( ppsDraw[ipp],_kDrawFilled);
						}//next ipp
						for (int ipp=0;ipp<ppsTopDraw.length();ipp++) 
						{ 
//							dpEdge.draw( ppsTopDraw[ipp],_kDrawFilled);
//							dpFront.draw( ppsTopDraw[ipp],_kDrawFilled);
							PlaneProfile pp = ppsTopDraw[ipp];
							PlaneProfile ppNew(pp.coordSys());
							{ 
							// get extents of profile
								Vector3d vecXpp = vecXtopDraw[ipp];
								Vector3d vecYpp = vecYtopDraw[ipp];
								LineSeg segpp = pp.extentInDir(vecXpp);
								double dXpp = abs(vecXpp.dotProduct(segpp.ptStart()-segpp.ptEnd()));
								double dYpp = abs(vecYpp.dotProduct(segpp.ptStart()-segpp.ptEnd()));
								PLine plNew;
								plNew.createRectangle(LineSeg(segpp.ptMid()-vecYpp*.5*dTapeWidthFront-vecXpp*.5*dXpp,
								segpp.ptMid() + vecYpp * .5 * dTapeWidthFront + vecXpp * .5 * dXpp), vecXpp, vecYpp);
								
								ppNew.joinRing(plNew, _kAdd);
							}
							ppNew.vis(4);
							dpFront.draw( ppNew,_kDrawFilled);
							// maprequest for shopdrawing
							Map mapRequestPlaneProfileI = mapRequestPlaneProfile;
							mapRequestPlaneProfileI.setInt("Transparency", iTransparency);
							mapRequestPlaneProfileI.setString("Stereotype", "PlaneProfileTape");
							mapRequestPlaneProfileI.setPlaneProfile("PlaneProfile", ppNew);
							mapRequestPlaneProfileI.setVector3d("AllowedView", -vecZ);
							mapRequestPlaneProfileI.setInt("AlsoReverseDirection", true); 
							mapRequestPlaneProfileI.setInt("Color", iColor);
					        mapRequestPlaneProfileI.setInt("DrawFilled", _kDrawFilled);
					        mapRequestPlaneProfileI.setInt("ShowForDirOfView", true);
					        mapRequestPlaneProfileI.setInt("ShowForOppositeDirOfView", true);
					        mapRequests.appendMap("DimRequest", mapRequestPlaneProfileI);
						}//next ipp
						// bottom edge 
						String sHWDescriptionI = sHWDescription + sOuterEdge+";"+sFloorWall+";";;
						hwcI.setDescription(sHWDescriptionI);
						hwcI.setDScaleX(dLengthEdge+U(200));
						hwcI.setDScaleY(mapProduct.getDouble("Width")*1000);
						hwcI.setArticleNumber(mapProduct.getString("ArticleNumber"));
						hwcs.append(hwcI);
						if(!iSingleTape)
						{ 
							// 150
							String sHWDescriptionI = sHWDescription + sOuterEdge+";"+sFloorWall+";";
							hwcI.setDescription(sHWDescriptionI);
							hwcI.setDScaleX(dLengthEdge+U(200));
							hwcI.setDScaleY(mapProduct150.getDouble("Width")*1000);
							hwcI.setArticleNumber(mapProduct150.getString("ArticleNumber"));
							hwcs.append(hwcI);
						}
					}
				}
			}
			if(iTapeEdge)
			{ 
				if (_bOnRecalc && _kExecuteKey==sTriggergenerateSingleInstances)
				{
					// create TSL
		        	TslInst tslNew;		Vector3d vecXTsl= _XW;	Vector3d vecYTsl= _YW;
		        	GenBeam gbsTsl[1];	Entity entsTsl[] = {};	Point3d ptsTsl[1];
		        	int nProps[]={};	double dProps[]={};		String sProps[]={};
		        	Map mapTsl;	
		        	
		        	Point3d ptEdge = mapEdgeI.getPoint3d("ptEdge");
		        	Point3d ptEdge1 = mapEdgeI.getPoint3d("ptEdgeStart");
		        	Point3d ptEdge2 = mapEdgeI.getPoint3d("ptEdgeEnd");
		        	
	//	        	Vector3d vecClosest = ptMid - ptCen;
	//				double dXclosest = vecX.dotProduct(vecClosest);
	//				double dYclosest = vecY.dotProduct(vecClosest);
	//				mapTsl.setDouble("dXclosest", dXclosest);
	//				mapTsl.setDouble("dYclosest", dYclosest);
		        	mapTsl.setInt("Automatic", false);
		        	mapTsl.setMap("Edges", mapEdges);
		        	gbsTsl[0] = sip;
		        	
					// generate single instance
					ptsTsl[0] = ptEdge;
//					ptsTsl[1] = ptEdge1;
//					ptsTsl[2] = ptEdge2;
					tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, 
						ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
				}
			}
		}//next iedge
		if (mapRequests.length() > 0)
		{
			_Map.setMap("DimRequest[]", mapRequests);
		}
		else
		{
			_Map.removeAt("DimRequest[]", true);
		}
	}
	
	if (_bOnRecalc && _kExecuteKey==sTriggergenerateSingleInstances)
	{
		// delete instance
		eraseInstance();
		return;
	}
	
	// make sure the hardware is updated
	if (_bOnDbCreated) setExecutionLoops(2);				
	_ThisInst.setHardWrComps(hwcs);	
	
	double dLengthSums[0];
	double dWidths[0];
	for (int i=0;i<hwcs.length();i++) 
	{ 
		int iIndexWidth = dWidths.find(hwcs[i].dScaleY());
		if (iIndexWidth < 0)
		{ 
			dWidths.append(hwcs[i].dScaleY());
			dLengthSums.append(hwcs[i].dScaleX());
		}
		else
		{ 
			dLengthSums[iIndexWidth] += hwcs[i].dScaleX();
		}
	}//next i
	Map mapXtape;
	for (int i=0;i<dWidths.length();i++) 
	{ 
		mapXtape.setDouble("TotalLength"+i, dLengthSums[i]);
		mapXtape.setDouble("Width"+i, dWidths[i]);
		 
	}//next i
	
//	mapXtape.setDouble("TotalLength", dLengthSum);
	sip.setSubMapX("Tape", mapXtape);
}
else if(!iAutomatic)
{ 
	// manual mode
	_Pt0.vis(3);
	HardWrComp hwcs[] = _ThisInst.hardWrComps();
	
// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
	for (int i=hwcs.length()-1; i>=0 ; i--) 
		if (hwcs[i].repType() == _kRTTsl)
			hwcs.removeAt(i); 
	
	String sHWArticleNumber = "";
	HardWrComp hwc(sHWArticleNumber, 1);
	hwc.setCategory(T("|Tooling|"));
	hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
	// 
	
	// hardware group
	// set group name
	// declare the groupname of the hardware components
	String sHWGroupName;
	{ 
	// element
		// try to catch the element from the parent entity
		Element elHW =sip.element(); 
		// check if the parent entity is an element
		if (!elHW.bIsValid()) elHW = (Element)sip;
		if (elHW.bIsValid()) sHWGroupName=elHW.elementGroup().name();
	// loose
		else
		{
			Group groups[] = _ThisInst.groups();
			if (groups.length()>0)	sHWGroupName=groups[0].name();
		}
	}
	hwc.setGroup(sHWGroupName);
	hwc.setLinkedEntity(sip);
	//
	Map mapRequests;
	Map mapRequestPlaneProfile;
	mapRequestPlaneProfile.setInt("Transparency", iTransparencyDefault);
	
	Map mapXextendedProperties = sip.subMapX("ExtendedProperties");
	int iFloor;
	Vector3d vecWall=_ZW;
	if(mapXextendedProperties.hasInt("IsFloor"))
	{ 
		iFloor = mapXextendedProperties.getInt("IsFloor");
		vecWall = vecY;
	}
	else
	{ 
		iFloor = true;
		if(vecZ.isPerpendicularTo(_ZW))
		{ 
			iFloor = false;
		}
	}
	String sFloorWall = "Floor";
	if ( !iFloor)sFloorWall = "Wall";
	
	Map mapEdges = _Map.getMap("Edges");
	PLine plsAll[0];
	for (int iedge=0;iedge<mapEdges.length();iedge++) 
	{ 
		Map mapEdgeI = mapEdges.getMap(iedge);
		PLine plI = mapEdgeI.getPLine("Pline");
		plsAll.append(plI);
	}//next iedge
	
	Plane pnCen(ptCen,vecZ);
	_Pt0 = pnCen.closestPointTo(_Pt0);
	if(_PtG.length()<2)
	{ 
		int iEdgeClosest = -1;
		double dDistClosest = U(10e6);
		
		Point3d ptCheck = _Pt0;
		for (int ipl = 0; ipl < plsAll.length(); ipl++)
		{
			Map mapEdgeI = mapEdges.getMap(ipl);
			int iStraight = mapEdgeI.getInt("Straight");
			
			PLine plI = plsAll[ipl];
			Point3d pts[] = plI.vertexPoints(true);
			Point3d pt1 = pts[0];
			Point3d pt2 = pts[1];
			Point3d ptMid = .5 * (pt1 + pt2);
			Vector3d vecDir = pt2 - pt1;
			vecDir.normalize();
			Line ln(ptMid, vecDir);
			Point3d ptClosestLineI = ln.closestPointTo(ptCheck);
			// check that ptClosestI inside the edge
			double dLengthPtI=abs(vecDir.dotProduct(ptClosestLineI-pt1))
				 + abs(vecDir.dotProduct(ptClosestLineI - pt2));
			double dLengthSeg = abs(vecDir.dotProduct(pt1 - pt2));
			if (abs(dLengthPtI - dLengthSeg) > dEps)continue;
			
//			double dDistClosestI = plI.getDistAtPoint(ptJig);
			Point3d ptClosestI = plI.closestPointTo(ptCheck);
			double dDistClosestI = (ptClosestI-ptCheck).length();
			
			if(dDistClosestI<dDistClosest)
			{ 
				dDistClosest = dDistClosestI;
				iEdgeClosest = ipl;
			}
		}
		if(iEdgeClosest < 0 )
		{ 
			reportMessage("\n"+scriptName()+" "+T("|unexpected error|"));
			reportMessage("\n"+scriptName()+" "+T("|no edge could be found|"));
			eraseInstance();
			return;
		}
		
		Map mapEdgeClosest = mapEdges.getMap(iEdgeClosest);
		PLine plClosest = mapEdgeClosest.getPLine("Pline");
		Point3d ptsClosest[] = plClosest.vertexPoints(true);
		Point3d ptMidClosest = plClosest.closestPointTo(ptCheck);
		_Pt0 = ptMidClosest;
		if(_PtG.length()==0)
		{ 
			_PtG.append(ptsClosest[0]);
			_PtG.append(ptsClosest[1]);
		}
		else if(_PtG.length()==1)
		{ 
			_PtG[0] = ptsClosest[0];
			_PtG.append(ptsClosest[1]);
		}
		
		Vector3d vecClosest = ptMidClosest - ptCen;
		double dXclosest = vecX.dotProduct(vecClosest);
		double dYclosest = vecY.dotProduct(vecClosest);
		_Map.setDouble("dXclosest", dXclosest);
		_Map.setDouble("dYclosest", dYclosest);
		Vector3d vecClosestPtg0 = _PtG[0] - ptCen;
		double dXclosestPtg0 = vecX.dotProduct(vecClosestPtg0);
		double dYclosestPtg0 = vecY.dotProduct(vecClosestPtg0);
		_Map.setDouble("dXclosestPtg0", dXclosestPtg0);
		_Map.setDouble("dYclosestPtg0", dYclosestPtg0);
		Vector3d vecClosestPtg1 = _PtG[1] - ptCen;
		double dXclosestPtg1 = vecX.dotProduct(vecClosestPtg1);
		double dYclosestPtg1 = vecY.dotProduct(vecClosestPtg1);
		_Map.setDouble("dXclosestPtg1", dXclosestPtg1);
		_Map.setDouble("dYclosestPtg1", dYclosestPtg1);
		setExecutionLoops(2);
		return;
	}
	else if(_PtG.length()==2)
	{ 
		double dXclosestRef = _Map.getDouble("dXclosest");
		double dYclosestRef = _Map.getDouble("dYclosest");
		Vector3d vecClosestRef = vecX * dXclosestRef + vecY * dYclosestRef;
		Point3d ptMidClosestRef = ptCen + vecClosestRef;
		
		Point3d Ptg0Ref, Ptg1Ref;
		if(iMoved)
		{ 
			double dXclosestPtg0Ref = _Map.getDouble("dXclosestPtg0");
			double dYclosestPtg0Ref = _Map.getDouble("dYclosestPtg0");
			Vector3d vecClosestPtg0Ref = vecX * dXclosestPtg0Ref + vecY * dYclosestPtg0Ref;
			Ptg0Ref = ptCen + vecClosestPtg0Ref;
			double dXclosestPtg1Ref = _Map.getDouble("dXclosestPtg1");
			double dYclosestPtg1Ref = _Map.getDouble("dYclosestPtg1");
			Vector3d vecClosestPtg1Ref = vecX * dXclosestPtg1Ref + vecY * dYclosestPtg1Ref;
			Ptg1Ref = ptCen + vecClosestPtg1Ref;
		}
		Point3d ptCheck = ptMidClosestRef;
//		ptCheck.vis(4);
		int iEdgeClosest = -1;
		double dDistClosest = U(10e6);
//		Display dpEdge(1);
		for (int ipl = 0; ipl < plsAll.length(); ipl++)
		{
			Map mapEdgeI = mapEdges.getMap(ipl);
			int iStraight = mapEdgeI.getInt("Straight");
			
			PLine plI = plsAll[ipl];
			Point3d pts[] = plI.vertexPoints(true);
			Point3d pt1 = pts[0];
			Point3d pt2 = pts[1];
			Point3d ptMid = .5 * (pt1 + pt2);
			Vector3d vecDir = pt2 - pt1;
			vecDir.normalize();
			Line ln(ptMid, vecDir);
			Point3d ptClosestLineI = ln.closestPointTo(ptCheck);
			// check that ptClosestI inside the edge
			double dLengthPtI=abs(vecDir.dotProduct(ptClosestLineI-pt1))
				 + abs(vecDir.dotProduct(ptClosestLineI - pt2));
			double dLengthSeg = abs(vecDir.dotProduct(pt1 - pt2));
			if (abs(dLengthPtI - dLengthSeg) > dEps)continue;
			
//			double dDistClosestI = plI.getDistAtPoint(ptJig);
			Point3d ptClosestI = plI.closestPointTo(ptCheck);
			double dDistClosestI = (ptClosestI-ptCheck).length();
			
			if(dDistClosestI<dDistClosest)
			{ 
				dDistClosest = dDistClosestI;
				iEdgeClosest = ipl;
			}
		}
		if(iEdgeClosest < 0 )
		{ 
			reportMessage("\n"+scriptName()+" "+T("|unexpected error|"));
			reportMessage("\n"+scriptName()+" "+T("|no edge could be found|"));
			eraseInstance();
			return;
		}
		
		Map mapEdgeClosest = mapEdges.getMap(iEdgeClosest);
		int iStraight = mapEdgeClosest.getInt("Straight");
		
		int iOutter = mapEdgeClosest.getInt("Outter");
		String sOuterEdge="Outter Edge";
		if ( ! iOutter)sOuterEdge = "Inner Edge";
		PLine plClosest = mapEdgeClosest.getPLine("Pline");
		Point3d ptsClosest[] = plClosest.vertexPoints(true);
		Point3d ptMidClosest = plClosest.closestPointTo(ptCheck);
		_Pt0 = ptMidClosest;
		Vector3d vecClosest = ptMidClosest - ptCen;
		double dXclosest = vecX.dotProduct(vecClosest);
		double dYclosest = vecY.dotProduct(vecClosest);
		_Map.setDouble("dXclosest", dXclosest);
		_Map.setDouble("dYclosest", dYclosest);
		
//		plClosest.vis(6);
		_ThisInst.setAllowGripAtPt0(false);
		if(iMoved)
		{ 
			_PtG[0] = plClosest.closestPointTo(Ptg0Ref);
			_PtG[1] = plClosest.closestPointTo(Ptg1Ref);
		}
		else
		{
			_PtG[0] = plClosest.closestPointTo(_PtG[0]);
			_PtG[1] = plClosest.closestPointTo(_PtG[1]);
		}

		Vector3d vecClosestPtg0 = _PtG[0] - ptCen;
		double dXclosestPtg0 = vecX.dotProduct(vecClosestPtg0);
		double dYclosestPtg0 = vecY.dotProduct(vecClosestPtg0);
		_Map.setDouble("dXclosestPtg0", dXclosestPtg0);
		_Map.setDouble("dYclosestPtg0", dYclosestPtg0);
		Vector3d vecClosestPtg1 = _PtG[1] - ptCen;
		double dXclosestPtg1 = vecX.dotProduct(vecClosestPtg1);
		double dYclosestPtg1 = vecY.dotProduct(vecClosestPtg1);
		_Map.setDouble("dXclosestPtg1", dXclosestPtg1);
		_Map.setDouble("dYclosestPtg1", dYclosestPtg1);
//		
		Map mapProfilesClosest = mapEdgeClosest.getMap("pps");
		Map mapProfilesTopClosest = mapEdgeClosest.getMap("ppsTop");
		
		addRecalcTrigger(_kGripPointDrag, "_PtG0");
		addRecalcTrigger(_kGripPointDrag, "_PtG1");
		if (_bOnGripPointDrag && 	
			((_kExecuteKey == "_PtG0") || (_kExecuteKey == "_PtG1")))
		{ 
			Display dpModelDrag(4);
			Display dpFrontDrag(4);
			dpFrontDrag.addViewDirection(vecZ);
			dpFrontDrag.addViewDirection(-vecZ);
			dpFrontDrag.addHideDirection(vecX);
			dpFrontDrag.addHideDirection(-vecX);
			dpFrontDrag.addHideDirection(vecY);
			dpFrontDrag.addHideDirection(-vecY);
			_PtG[0] = plClosest.closestPointTo(_PtG[0]);
			_PtG[1] = plClosest.closestPointTo(_PtG[1]);
			
			for (int iMapPp=0;iMapPp<mapProfilesClosest.length();iMapPp++) 
			{ 
				Map mapPpI = mapProfilesClosest.getMap(iMapPp);
				if(mapPpI.hasPlaneProfile("pp"))
				{ 
					PlaneProfile ppEdge = mapPpI.getPlaneProfile("pp");
					Vector3d vecXpp = mapPpI.getVector3d("vecX");
					Vector3d vecYpp = mapPpI.getVector3d("vecY");
					Vector3d vecZpp = mapPpI.getVector3d("vecZ");
					
					// get extents of profile
					LineSeg seg = ppEdge.extentInDir(vecXpp);
					Point3d pt1Pp = seg.ptStart();
					pt1Pp = plClosest.closestPointTo(pt1Pp);
					Point3d pt2Pp = seg.ptEnd();
					pt2Pp = plClosest.closestPointTo(pt2Pp);
					Vector3d vecDir = _PtG[1] - _PtG[0];
					vecDir.normalize();
					{ 
						// intersect
						PLine plRecRight;
						plRecRight.createRectangle(LineSeg(_PtG[1]-vecYpp*U(4000),
							_PtG[1] + vecDir * U(40000) + vecYpp * U(4000)), vecDir, vecYpp);
						PlaneProfile ppRecRight(Plane(_PtG[1], vecZpp));
						ppRecRight.joinRing(plRecRight, _kAdd);
						
						PLine plRecLeft;
						plRecLeft.createRectangle(LineSeg(_PtG[0]-vecYpp*U(4000),
							_PtG[0] - vecDir * U(40000) + vecYpp * U(4000)), vecDir, vecYpp);
						PlaneProfile ppRecLeft(Plane(_PtG[0], vecZpp));
						ppRecLeft.joinRing(plRecLeft, _kAdd);
						
						ppEdge.subtractProfile(ppRecRight);
						ppEdge.subtractProfile(ppRecLeft);
//						dpDrag.draw(ppEdge,_kDrawFilled);
						dpModelDrag.draw(ppEdge,_kDrawFilled);
					}	
				}
				else
				{ 
					for (int _ipp=0;_ipp<mapPpI.length();_ipp++) 
					{ 
						Map _mapPpI = mapPpI.getMap(_ipp);
						PlaneProfile _ppI = _mapPpI.getPlaneProfile("pp");
						Vector3d vecXpp = _mapPpI.getVector3d("vecX");
						Vector3d vecYpp = _mapPpI.getVector3d("vecY");
						Vector3d vecZpp = _mapPpI.getVector3d("vecZ");
	
						// get extents of profile
						LineSeg seg = _ppI.extentInDir(vecXpp);
						Point3d pt1Pp = seg.ptStart();
						pt1Pp = plClosest.closestPointTo(pt1Pp);
						Point3d pt2Pp = seg.ptEnd();
						pt2Pp = plClosest.closestPointTo(pt2Pp);
						Vector3d vecDir = _PtG[1] - _PtG[0];
						vecDir.normalize();
						// point ptInside inside 2 points pt1 and pt2
						int iInside1=true;
						{ 
							double dLengthPtI=abs(vecDir.dotProduct(pt1Pp-_PtG[0]))
								 + abs(vecDir.dotProduct(pt1Pp - _PtG[1]));
							double dLengthSeg = abs(vecDir.dotProduct(_PtG[0] - _PtG[1]));
							if (abs(dLengthPtI - dLengthSeg) > dEps)iInside1=false;
						}
						int iInside2=true;
						{ 
							double dLengthPtI=abs(vecDir.dotProduct(pt2Pp-_PtG[0]))
								 + abs(vecDir.dotProduct(pt2Pp - _PtG[1]));
							double dLengthSeg = abs(vecDir.dotProduct(_PtG[0] - _PtG[1]));
							if (abs(dLengthPtI - dLengthSeg) > dEps)iInside2=false;
						}
						if ( ! iInside1 && !iInside2)
						{
							continue;
						}
						else if(iInside1 && iInside2)
						{ 
//							_ppI.vis(3);
//							dpDrag.draw(_ppI,_kDrawFilled);
							dpModelDrag.draw(_ppI,_kDrawFilled);
						}
						else if(iInside1 || iInside2)
						{ 
							// intersect
							Vector3d vecXsubtract = vecXpp;
							if (vecXsubtract.dotProduct(vecXpp) < 0)vecXsubtract *= -1;
							vecXsubtract.normalize();
							PLine plRecRight;
							plRecRight.createRectangle(LineSeg(_PtG[1]-vecYpp*U(4000),
								_PtG[1] + vecXsubtract * U(40000) + vecYpp * U(4000)), vecXsubtract, vecYpp);
							PlaneProfile ppRecRight(Plane(_PtG[1], vecZpp));
							ppRecRight.joinRing(plRecRight, _kAdd);
							
							PLine plRecLeft;
							plRecLeft.createRectangle(LineSeg(_PtG[0]-vecYpp*U(4000),
								_PtG[0] - vecXsubtract * U(40000) + vecYpp * U(4000)), vecXsubtract, vecYpp);
							
							PlaneProfile ppRecLeft(Plane(_PtG[0], vecZpp));
							ppRecLeft.joinRing(plRecLeft, _kAdd);
							
							_ppI.subtractProfile(ppRecRight);
							_ppI.subtractProfile(ppRecLeft);
//							_ppI.vis(3);
//							dpDrag.draw(_ppI,_kDrawFilled);
							dpModelDrag.draw(_ppI,_kDrawFilled);
						}
					}//next _ipp
				}
			}//next iMpaPp
			for (int iMapPp=0;iMapPp<mapProfilesTopClosest.length();iMapPp++) 
			{ 
				Map mapPpI = mapProfilesTopClosest.getMap(iMapPp);
				if(mapPpI.hasPlaneProfile("pp"))
				{ 
					PlaneProfile ppEdge = mapPpI.getPlaneProfile("pp");
					Vector3d vecXpp = mapPpI.getVector3d("vecX");
					Vector3d vecYpp = mapPpI.getVector3d("vecY");
					Vector3d vecZpp = vecZ;
					
					// get extents of profile
					LineSeg seg = ppEdge.extentInDir(vecXpp);
					Point3d pt1Pp = seg.ptStart();
					pt1Pp = plClosest.closestPointTo(pt1Pp);
					Point3d pt2Pp = seg.ptEnd();
					pt2Pp = plClosest.closestPointTo(pt2Pp);
					Vector3d vecDir = _PtG[1] - _PtG[0];
					vecDir.normalize();
					{ 
						// intersect
						PLine plRecRight;
						plRecRight.createRectangle(LineSeg(_PtG[1]-vecYpp*U(4000),
							_PtG[1] + vecDir * U(40000) + vecYpp * U(4000)), vecDir, vecYpp);
						PlaneProfile ppRecRight(Plane(_PtG[1], vecZpp));
						ppRecRight.joinRing(plRecRight, _kAdd);
						
						PLine plRecLeft;
						plRecLeft.createRectangle(LineSeg(_PtG[0]-vecYpp*U(4000),
							_PtG[0] - vecDir * U(40000) + vecYpp * U(4000)), vecDir, vecYpp);
						PlaneProfile ppRecLeft(Plane(_PtG[0], vecZpp));
						ppRecLeft.joinRing(plRecLeft, _kAdd);
						
						ppRecLeft.vis(3);
						ppRecRight.vis(3);
						ppEdge.vis(3);
						ppEdge.subtractProfile(ppRecRight);
						ppEdge.subtractProfile(ppRecLeft);
//						dpDrag.draw(ppEdge,_kDrawFilled);
						dpFrontDrag.draw(ppEdge,_kDrawFilled);
					}	
				}
				else
				{ 
					for (int _ipp=0;_ipp<mapPpI.length();_ipp++) 
					{ 
						Map _mapPpI = mapPpI.getMap(_ipp);
						PlaneProfile _ppI = _mapPpI.getPlaneProfile("pp");
						Vector3d vecXpp = _mapPpI.getVector3d("vecX");
						Vector3d vecYpp = _mapPpI.getVector3d("vecY");
						Vector3d vecZpp = vecZ;
						// get extents of profile
						LineSeg seg = _ppI.extentInDir(vecXpp);
						Point3d pt1Pp = seg.ptStart();
						pt1Pp = plClosest.closestPointTo(pt1Pp);
						Point3d pt2Pp = seg.ptEnd();
						pt2Pp = plClosest.closestPointTo(pt2Pp);
						Vector3d vecDir = _PtG[1] - _PtG[0];
						vecDir.normalize();
						// point ptInside inside 2 points pt1 and pt2
						int iInside1=true;
						{ 
							double dLengthPtI=abs(vecDir.dotProduct(pt1Pp-_PtG[0]))
								 + abs(vecDir.dotProduct(pt1Pp - _PtG[1]));
							double dLengthSeg = abs(vecDir.dotProduct(_PtG[0] - _PtG[1]));
							if (abs(dLengthPtI - dLengthSeg) > dEps)iInside1=false;
						}
						int iInside2=true;
						{ 
							double dLengthPtI=abs(vecDir.dotProduct(pt2Pp-_PtG[0]))
								 + abs(vecDir.dotProduct(pt2Pp - _PtG[1]));
							double dLengthSeg = abs(vecDir.dotProduct(_PtG[0] - _PtG[1]));
							if (abs(dLengthPtI - dLengthSeg) > dEps)iInside2=false;
						}
						if ( ! iInside1 && !iInside2)
						{
							continue;
						}
						else if(iInside1 && iInside2)
						{ 
//							_ppI.vis(3);
//							dpDrag.draw(_ppI,_kDrawFilled);
							dpFrontDrag.draw(_ppI,_kDrawFilled);
						}
						else if(iInside1 || iInside2)
						{ 
							// intersect
							Vector3d vecXsubtract = vecXpp;
							if (vecXsubtract.dotProduct(vecXpp) < 0)vecXsubtract *= -1;
							vecXsubtract.normalize();
							PLine plRecRight;
							plRecRight.createRectangle(LineSeg(_PtG[1]-vecYpp*U(4000),
								_PtG[1] + vecXsubtract * U(40000) + vecYpp * U(4000)), vecXsubtract, vecYpp);
							PlaneProfile ppRecRight(Plane(_PtG[1], vecZpp));
							ppRecRight.joinRing(plRecRight, _kAdd);
							PLine plRecLeft;
							plRecLeft.createRectangle(LineSeg(_PtG[0]-vecYpp*U(4000),
								_PtG[0] - vecXsubtract * U(40000) + vecYpp * U(4000)), vecXsubtract, vecYpp);
							
							PlaneProfile ppRecLeft(Plane(_PtG[0], vecZpp));
							ppRecLeft.joinRing(plRecLeft, _kAdd);
							_ppI.subtractProfile(ppRecRight);
							_ppI.subtractProfile(ppRecLeft);
//							dpDrag.draw(_ppI,_kDrawFilled);
							dpFrontDrag.draw(_ppI,_kDrawFilled);
						}
					}//next _ipp
				}
			}//next iMpaPp
			return
		}
		
		double dLengthEdge, dWidthEdge;
		PlaneProfile ppsDraw[0], ppsTopDraw[0];
		Vector3d vecXtopDraw[0],vecYtopDraw[0];
		for (int iMapPp=0;iMapPp<mapProfilesClosest.length();iMapPp++) 
		{ 
			Map mapPpI = mapProfilesClosest.getMap(iMapPp);
			if(mapPpI.hasPlaneProfile("pp"))
			{ 
				PlaneProfile ppEdge = mapPpI.getPlaneProfile("pp");
				Vector3d vecXpp = mapPpI.getVector3d("vecX");
				Vector3d vecYpp = mapPpI.getVector3d("vecY");
				Vector3d vecZpp = mapPpI.getVector3d("vecZ");
				
				// get extents of profile
				LineSeg seg = ppEdge.extentInDir(vecXpp);
				Point3d pt1Pp = seg.ptStart();
				pt1Pp = plClosest.closestPointTo(pt1Pp);
				Point3d pt2Pp = seg.ptEnd();
				pt2Pp = plClosest.closestPointTo(pt2Pp);
				Vector3d vecDir = _PtG[1] - _PtG[0];
				vecDir.normalize();
				{ 
					// intersect
					PLine plRecRight;
					plRecRight.createRectangle(LineSeg(_PtG[1]-vecYpp*U(4000),
						_PtG[1] + vecDir * U(40000) + vecYpp * U(4000)), vecDir, vecYpp);
					PlaneProfile ppRecRight(Plane(_PtG[1], vecZpp));
					ppRecRight.joinRing(plRecRight, _kAdd);
					
					PLine plRecLeft;
					plRecLeft.createRectangle(LineSeg(_PtG[0]-vecYpp*U(4000),
						_PtG[0] - vecDir * U(40000) + vecYpp * U(4000)), vecDir, vecYpp);
					PlaneProfile ppRecLeft(Plane(_PtG[0], vecZpp));
					ppRecLeft.joinRing(plRecLeft, _kAdd);
					
					ppEdge.subtractProfile(ppRecRight);
					ppEdge.subtractProfile(ppRecLeft);
					ppsDraw.append(ppEdge);
//					dpEdge.draw(ppEdge,_kDrawFilled);
				}
				dLengthEdge = abs(vecDir.dotProduct(_PtG[1] - _PtG[0]));
			}
			else
			{ 
				for (int _ipp=0;_ipp<mapPpI.length();_ipp++) 
				{ 
					Map _mapPpI = mapPpI.getMap(_ipp);
					PlaneProfile _ppI = _mapPpI.getPlaneProfile("pp");
					Vector3d vecXpp = _mapPpI.getVector3d("vecX");
					Vector3d vecYpp = _mapPpI.getVector3d("vecY");
					Vector3d vecZpp = _mapPpI.getVector3d("vecZ");
//					vecXpp.vis(_ppI.coordSys().ptOrg());
//					vecYpp.vis(_ppI.coordSys().ptOrg());
//					vecZpp.vis(_ppI.coordSys().ptOrg());

					// get extents of profile
					LineSeg seg = _ppI.extentInDir(vecXpp);
					Point3d pt1Pp = seg.ptStart();
					pt1Pp = plClosest.closestPointTo(pt1Pp);
					Point3d pt2Pp = seg.ptEnd();
					pt2Pp = plClosest.closestPointTo(pt2Pp);
					Vector3d vecDir = _PtG[1] - _PtG[0];
					vecDir.normalize();
					// point ptInside inside 2 points pt1 and pt2
					int iInside1=true;
					{ 
						double dLengthPtI=abs(vecDir.dotProduct(pt1Pp-_PtG[0]))
							 + abs(vecDir.dotProduct(pt1Pp - _PtG[1]));
						double dLengthSeg = abs(vecDir.dotProduct(_PtG[0] - _PtG[1]));
						if (abs(dLengthPtI - dLengthSeg) > dEps)iInside1=false;
					}
					int iInside2=true;
					{ 
						double dLengthPtI=abs(vecDir.dotProduct(pt2Pp-_PtG[0]))
							 + abs(vecDir.dotProduct(pt2Pp - _PtG[1]));
						double dLengthSeg = abs(vecDir.dotProduct(_PtG[0] - _PtG[1]));
						if (abs(dLengthPtI - dLengthSeg) > dEps)iInside2=false;
					}
					if ( ! iInside1 && !iInside2)
					{
						continue;
					}
					else if(iInside1 && iInside2)
					{ 
						_ppI.vis(3);
//						dpEdge.draw(_ppI,_kDrawFilled);
						ppsDraw.append(_ppI);
						dLengthEdge += mapEdgeClosest.getDouble("EdgeLength"+iMapPp);
						
					}
					else if(iInside1 || iInside2)
					{ 
						// intersect
						Vector3d vecXsubtract = vecXpp;
						if (vecXsubtract.dotProduct(vecXpp) < 0)vecXsubtract *= -1;
						vecXsubtract.normalize();
						vecXsubtract.vis(_PtG[1]);
						PLine plRecRight;
//						if (vecYpp.dotProduct(_PtG[1] - _PtG[0]) > 0)vecYpp *= -1;
						plRecRight.createRectangle(LineSeg(_PtG[1]-vecYpp*U(4000),
							_PtG[1] + vecXsubtract * U(40000) + vecYpp * U(4000)), vecXsubtract, vecYpp);
						PlaneProfile ppRecRight(Plane(_PtG[1], vecZpp));
						ppRecRight.joinRing(plRecRight, _kAdd);
						
						PLine plRecLeft;
						plRecLeft.createRectangle(LineSeg(_PtG[0]-vecYpp*U(4000),
							_PtG[0] - vecXsubtract * U(40000) + vecYpp * U(4000)), vecXsubtract, vecYpp);
						
						PlaneProfile ppRecLeft(Plane(_PtG[0], vecZpp));
						ppRecLeft.joinRing(plRecLeft, _kAdd);
//						ppRecRight.vis(2);
//						ppRecLeft.vis(2);
//						_ppI.vis(5);
						_ppI.subtractProfile(ppRecRight);
						_ppI.subtractProfile(ppRecLeft);
//						_ppI.vis(3);
//						dpEdge.draw(_ppI,_kDrawFilled);
						ppsDraw.append(_ppI);
						// get extents of profile
						LineSeg _segPpI = _ppI.extentInDir(vecXpp);
						dLengthEdge +=  abs(vecXpp.dotProduct(_segPpI.ptStart()-_segPpI.ptEnd()));
					}
				}//next _ipp
			}
		}//next iMpaPp
		for (int iMapPp=0;iMapPp<mapProfilesTopClosest.length();iMapPp++) 
		{ 
			Map mapPpI = mapProfilesTopClosest.getMap(iMapPp);
			if(mapPpI.hasPlaneProfile("pp"))
			{ 
				PlaneProfile ppEdge = mapPpI.getPlaneProfile("pp");
				Vector3d vecXpp = mapPpI.getVector3d("vecX");
				Vector3d vecYpp = mapPpI.getVector3d("vecY");
				Vector3d vecZpp = vecZ;
				
				// get extents of profile
				LineSeg seg = ppEdge.extentInDir(vecXpp);
				Point3d pt1Pp = seg.ptStart();
				pt1Pp = plClosest.closestPointTo(pt1Pp);
				Point3d pt2Pp = seg.ptEnd();
				pt2Pp = plClosest.closestPointTo(pt2Pp);
				Vector3d vecDir = _PtG[1] - _PtG[0];
				vecDir.normalize();
				{ 
					// intersect
					PLine plRecRight;
					plRecRight.createRectangle(LineSeg(_PtG[1]-vecYpp*U(4000),
						_PtG[1] + vecDir * U(40000) + vecYpp * U(4000)), vecDir, vecYpp);
					PlaneProfile ppRecRight(Plane(_PtG[1], vecZpp));
					ppRecRight.joinRing(plRecRight, _kAdd);
					
					PLine plRecLeft;
					plRecLeft.createRectangle(LineSeg(_PtG[0]-vecYpp*U(4000),
						_PtG[0] - vecDir * U(40000) + vecYpp * U(4000)), vecDir, vecYpp);
					PlaneProfile ppRecLeft(Plane(_PtG[0], vecZpp));
					ppRecLeft.joinRing(plRecLeft, _kAdd);
					
					ppRecLeft.vis(3);
					ppRecRight.vis(3);
					ppEdge.vis(3);
					ppEdge.subtractProfile(ppRecRight);
					ppEdge.subtractProfile(ppRecLeft);
//					dpEdge.draw(ppEdge,_kDrawFilled);
					ppsTopDraw.append(ppEdge);
					vecXtopDraw.append(vecXpp);
					vecYtopDraw.append(vecYpp);
				}	
			}
			else
			{ 
				for (int _ipp=0;_ipp<mapPpI.length();_ipp++) 
				{ 
					Map _mapPpI = mapPpI.getMap(_ipp);
					PlaneProfile _ppI = _mapPpI.getPlaneProfile("pp");
					Vector3d vecXpp = _mapPpI.getVector3d("vecX");
					Vector3d vecYpp = _mapPpI.getVector3d("vecY");
					Vector3d vecZpp = vecZ;
//					vecXpp.vis(_ppI.coordSys().ptOrg());
//					vecYpp.vis(_ppI.coordSys().ptOrg());
//					vecZpp.vis(_ppI.coordSys().ptOrg());

					// get extents of profile
					LineSeg seg = _ppI.extentInDir(vecXpp);
					Point3d pt1Pp = seg.ptStart();
					pt1Pp = plClosest.closestPointTo(pt1Pp);
					Point3d pt2Pp = seg.ptEnd();
					pt2Pp = plClosest.closestPointTo(pt2Pp);
					Vector3d vecDir = _PtG[1] - _PtG[0];
					vecDir.normalize();
					// point ptInside inside 2 points pt1 and pt2
					double dDist1, dDist2;
					int iInside1=true;
					{ 
						double dLengthPtI=abs(vecDir.dotProduct(pt1Pp-_PtG[0]))
							 + abs(vecDir.dotProduct(pt1Pp - _PtG[1]));
						double dLengthSeg = abs(vecDir.dotProduct(_PtG[0] - _PtG[1]));
						if (abs(dLengthPtI - dLengthSeg) > .1*dEps)iInside1=false;
						dDist1 = abs(dLengthPtI - dLengthSeg);
					}
					int iInside2=true;
					{ 
						double dLengthPtI=abs(vecDir.dotProduct(pt2Pp-_PtG[0]))
							 + abs(vecDir.dotProduct(pt2Pp - _PtG[1]));
						double dLengthSeg = abs(vecDir.dotProduct(_PtG[0] - _PtG[1]));
						if (abs(dLengthPtI - dLengthSeg) > .1*dEps)iInside2=false;
						dDist2 = abs(dLengthPtI - dLengthSeg);
						
					}
					if ( ! iInside1 && !iInside2)
					{
						continue;
					}
					else if(iInside1 && iInside2)
					{ 
						_ppI.vis(3);
//						dpEdge.draw(_ppI,_kDrawFilled);
						ppsTopDraw.append(_ppI);
						vecXtopDraw.append(vecXpp);
						vecYtopDraw.append(vecYpp);
					}
					else if(iInside1 || iInside2)
					{ 
						// intersect
						Vector3d vecXsubtract = vecXpp;
						if (vecXsubtract.dotProduct(vecXpp) < 0)vecXsubtract *= -1;
						vecXsubtract.normalize();
						PLine plRecRight;
						plRecRight.createRectangle(LineSeg(_PtG[1]-vecYpp*U(4000),
							_PtG[1] + vecXsubtract * U(40000) + vecYpp * U(4000)), vecXsubtract, vecYpp);
						PlaneProfile ppRecRight(Plane(_PtG[1], vecZpp));
						ppRecRight.joinRing(plRecRight, _kAdd);
						
						PLine plRecLeft;
						plRecLeft.createRectangle(LineSeg(_PtG[0]-vecYpp*U(4000),
							_PtG[0] - vecXsubtract * U(40000) + vecYpp * U(4000)), vecXsubtract, vecYpp);
						
						PlaneProfile ppRecLeft(Plane(_PtG[0], vecZpp));
						ppRecLeft.joinRing(plRecLeft, _kAdd);
						_ppI.subtractProfile(ppRecRight);
						_ppI.subtractProfile(ppRecLeft);
//						_ppI.vis(5);
//						dpEdge.draw(_ppI,_kDrawFilled);
						ppsTopDraw.append(_ppI);
						vecXtopDraw.append(vecXpp);
						vecYtopDraw.append(vecYpp);
					}
				}//next _ipp
			}
		}//next iMpaPp
		dWidthEdge = mapEdgeClosest.getDouble("EdgeThickness");
		int iSingleTape;
		int iNrTapes=1;
		if (dWidthEdge > 0)
		{ 
			HardWrComp hwcI = hwc;
			String sPosnum = sip.posnum();
			String sPanelName = sip.name();
			String sPanelInfo = sip.information();
			String sHWDescription = sPosnum+";"+sPanelName + ";" 
				+ sPanelInfo+";";
			
			if(iFloor)
			{ 
				Map mapManufacturers = mapSetting.getMap("Manufacturer[]");
				Map mapProduct150, mapProduct60;
				int iProduct150Found, iProduct60Found;
				for (int iM=0;iM<mapManufacturers.length();iM++) 
				{ 
					Map mapManufacturerI= mapManufacturers.getMap(iM);
					if (mapManufacturerI.getString("Name") != "Siga")continue;
					Map mapFamilies = mapManufacturerI.getMap("Family[]");
					for (int iF=0;iF<mapFamilies.length();iF++) 
					{ 
						Map mapFamilyI = mapFamilies.getMap(iF);
						if (mapFamilyI.getString("Name") != "Wigluv")continue;
						Map mapProducts = mapFamilyI.getMap("Product[]");
						for (int iP=0;iP<mapProducts.length();iP++) 
						{ 
							Map mapProductI = mapProducts.getMap(iP);
							if(mapProductI.getDouble("Width")==0.15)
							{ 
								mapProduct150 = mapProductI;
								iProduct150Found = true;
							}
							if(mapProductI.getDouble("Width")==0.06)
							{ 
								mapProduct60 = mapProductI;
								iProduct60Found = true;
							}
							if (iProduct150Found && iProduct60Found)break;
						}//next iP
						if (iProduct150Found && iProduct60Found)break;
					}//next iF
					if (iProduct150Found && iProduct60Found)break;
				}//next iM
				
				Map mapProduct;
				int iProductFound;
				
				for (int iM=0;iM<mapManufacturers.length();iM++) 
				{ 
					Map mapManufacturerI= mapManufacturers.getMap(iM);
					if (mapManufacturerI.getString("Name") != "Siga")continue;
					Map mapFamilies = mapManufacturerI.getMap("Family[]");
					for (int iF=0;iF<mapFamilies.length();iF++) 
					{ 
						Map mapFamilyI = mapFamilies.getMap(iF);
						if (mapFamilyI.getString("Name") != "Wigluv")continue;
						Map mapProducts = mapFamilyI.getMap("Product[]");
						for (int iP=0;iP<mapProducts.length();iP++) 
						{ 
							Map mapProductI = mapProducts.getMap(iP);
							// 35 mm on each side
							if(1000*mapProductI.getDouble("Width")>(dWidthEdge+U(70)))
							{ 
								mapProduct = mapProductI;
								iProductFound = true;
								iSingleTape = true;
								iNrTapes = 1;
								break;
							}
						}//next iP
						if (iProductFound)break;
					}//next iF
					if (iProductFound)break;
				}//next iM
				int iNr150;
				if(!iSingleTape)
				{ 
					for (int iCount = 0; iCount < 5; iCount++)
					{
						double dWidthCovered = U(150) * (iCount + 1);
						iNr150 = iCount + 1;
						iNrTapes += 1;
						// get the other tape
						for (int iM = 0; iM < mapManufacturers.length(); iM++)
						{
							Map mapManufacturerI = mapManufacturers.getMap(iM);
							if (mapManufacturerI.getString("Name") != "Siga")continue;
							Map mapFamilies = mapManufacturerI.getMap("Family[]");
							for (int iF = 0; iF < mapFamilies.length(); iF++)
							{
								Map mapFamilyI = mapFamilies.getMap(iF);
								if (mapFamilyI.getString("Name") != "Wigluv")continue;
								Map mapProducts = mapFamilyI.getMap("Product[]");
								for (int iP = 0; iP < mapProducts.length(); iP++)
								{
									Map mapProductI = mapProducts.getMap(iP);
									if (1000 * mapProductI.getDouble("Width") > (dWidthEdge - iNr150*U(150) + U(70)))
									{
										mapProduct = mapProductI;
										iProductFound = true;
										break;
									}
								}//next iP
								if (iProductFound)break;
							}//next iF
							if (iProductFound)break;
						}//next iM
						if (iProductFound)break;
					}
				}
				
				// edge
				String sHWDescriptionI = sHWDescription + sOuterEdge+";"+sFloorWall+";";
				hwcI.setDescription(sHWDescriptionI);
				hwcI.setDScaleX(dLengthEdge+U(20));
				hwcI.setDScaleY(mapProduct.getDouble("Width")*1000);
				hwcI.setArticleNumber(mapProduct.getString("ArticleNumber"));
				hwcs.append(hwcI);
				// apply on top side the 60
				hwcI.setDescription(sHWDescriptionI);
				hwcI.setDScaleX(dLengthEdge);
				hwcI.setDScaleY(mapProduct60.getDouble("Width")*1000);
				hwcI.setArticleNumber(mapProduct60.getString("ArticleNumber"));
				hwcs.append(hwcI);
				if(!iSingleTape)
				{ 
					// 150
					String sHWDescriptionI = sHWDescription + sOuterEdge+";"+sFloorWall+";";
					hwcI.setQuantity(iNr150);
					hwcI.setDescription(sHWDescriptionI);
					hwcI.setDScaleX(dLengthEdge+U(20));
					hwcI.setDScaleY(mapProduct150.getDouble("Width")*1000);
					hwcI.setArticleNumber(mapProduct150.getString("ArticleNumber"));
					hwcs.append(hwcI);
				}
			}
			else if(!iFloor)
			{ 
				int iVertical;
				int iTop;
				//
				Map mapManufacturers = mapSetting.getMap("Manufacturer[]");
				Map mapProduct150;
				int iProduct150Found;
				for (int iM=0;iM<mapManufacturers.length();iM++) 
				{ 
					Map mapManufacturerI= mapManufacturers.getMap(iM);
					if (mapManufacturerI.getString("Name") != "Siga")continue;
					Map mapFamilies = mapManufacturerI.getMap("Family[]");
					for (int iF=0;iF<mapFamilies.length();iF++) 
					{ 
						Map mapFamilyI = mapFamilies.getMap(iF);
						if (mapFamilyI.getString("Name") != "Wigluv")continue;
						Map mapProducts = mapFamilyI.getMap("Product[]");
						for (int iP=0;iP<mapProducts.length();iP++) 
						{ 
							Map mapProductI = mapProducts.getMap(iP);
							if(mapProductI.getDouble("Width")==0.15)
							{ 
								mapProduct150 = mapProductI;
								iProduct150Found = true;
							}
							if (iProduct150Found )break;
						}//next iP
						if (iProduct150Found)break;
					}//next iF
					if (iProduct150Found)break;
				}//next iM
				
				if(iStraight)
				{ 
					Vector3d vecEdgeOutter = mapEdgeClosest.getVector3d("vecEdgeOutter");
					if(abs(vecEdgeOutter.dotProduct(vecWall))<.1*dEps)
					{ 
						// vertical edge
						iVertical = true;
	//					continue;
					}
					if(!iVertical)
					{ 
						//not vertical; top or bottom
						if (vecEdgeOutter.dotProduct(vecWall) > 0)iTop = true;
					}
				}
//				else
//				{ 
//					// arch
//					iTop = true;
//				}
				// hardware
				if(iVertical)
				{ 
					double dExtraWidth = U(80);
					if (sSQTop == "VQ")dExtraWidth -= U(40);
					if (sSQBottom == "VQ")dExtraWidth -= U(40);
					// find the product
					Map mapProduct;
					int iProductFound;
					for (int iM=0;iM<mapManufacturers.length();iM++) 
					{ 
						Map mapManufacturerI= mapManufacturers.getMap(iM);
						if (mapManufacturerI.getString("Name") != "Siga")continue;
						Map mapFamilies = mapManufacturerI.getMap("Family[]");
						for (int iF=0;iF<mapFamilies.length();iF++) 
						{ 
							Map mapFamilyI = mapFamilies.getMap(iF);
							if (mapFamilyI.getString("Name") != "Wigluv")continue;
							Map mapProducts = mapFamilyI.getMap("Product[]");
							for (int iP=0;iP<mapProducts.length();iP++) 
							{ 
								Map mapProductI = mapProducts.getMap(iP);
								// 35 mm on each side
								if(1000*mapProductI.getDouble("Width")>(dWidthEdge+dExtraWidth))
								{ 
									mapProduct = mapProductI;
									iProductFound = true;
									iSingleTape = true;
									iNrTapes = 1;
									break;
								}
							}//next iP
							if (iProductFound)break;
						}//next iF
						if (iProductFound)break;
					}//next iM
					int iNr150;
					if(!iSingleTape)
					{ 
						for (int iCount=0;iCount<5;iCount++) 
						{ 
							double dWidthCovered = U(150) * (iCount + 1);
							iNr150 = iCount + 1;
							iNrTapes += 1;
							// get the other tape 
							for (int iM=0;iM<mapManufacturers.length();iM++) 
							{ 
								Map mapManufacturerI= mapManufacturers.getMap(iM);
								if (mapManufacturerI.getString("Name") != "Siga")continue;
								Map mapFamilies = mapManufacturerI.getMap("Family[]");
								for (int iF=0;iF<mapFamilies.length();iF++) 
								{ 
									Map mapFamilyI = mapFamilies.getMap(iF);
									if (mapFamilyI.getString("Name") != "Wigluv")continue;
									Map mapProducts = mapFamilyI.getMap("Product[]");
									for (int iP=0;iP<mapProducts.length();iP++) 
									{ 
										Map mapProductI = mapProducts.getMap(iP);
										if(1000*mapProductI.getDouble("Width")>(dWidthEdge-iNr150*U(150)+dExtraWidth))
										{ 
											mapProduct = mapProductI;
											iProductFound = true;
											break;
										}
									}//next iP
									if (iProductFound)break;
								}//next iF
								if (iProductFound)break;
							}//next iM
							if (iProductFound)break;
						}//next iCount
					}
					// vertical edge same length
					String sHWDescriptionI = sHWDescription + sOuterEdge+";"+sFloorWall+";";;
					hwcI.setDescription(sHWDescriptionI);
					hwcI.setDScaleX(dLengthEdge);
					hwcI.setDScaleY(mapProduct.getDouble("Width")*1000);
					hwcI.setArticleNumber(mapProduct.getString("ArticleNumber"));
					hwcs.append(hwcI);
					if(!iSingleTape)
					{ 
						// 150
						String sHWDescriptionI = sHWDescription + sOuterEdge+";"+sFloorWall+";";
						hwcI.setQuantity(iNr150);
						hwcI.setDescription(sHWDescriptionI);
						hwcI.setDScaleX(dLengthEdge+U(20));
						hwcI.setDScaleY(mapProduct150.getDouble("Width")*1000);
						hwcI.setArticleNumber(mapProduct150.getString("ArticleNumber"));
						hwcs.append(hwcI);
					}
				}
				else if(!iVertical)
				{ 
					if(iTop)
					{ 
						// top edge
						double dExtraWidth = U(0);
						// find the product
						Map mapProduct;
						int iProductFound;
						for (int iM=0;iM<mapManufacturers.length();iM++) 
						{ 
							Map mapManufacturerI= mapManufacturers.getMap(iM);
							if (mapManufacturerI.getString("Name") != "Siga")continue;
							Map mapFamilies = mapManufacturerI.getMap("Family[]");
							for (int iF=0;iF<mapFamilies.length();iF++) 
							{ 
								Map mapFamilyI = mapFamilies.getMap(iF);
								if (mapFamilyI.getString("Name") != "Wigluv")continue;
								Map mapProducts = mapFamilyI.getMap("Product[]");
								for (int iP=0;iP<mapProducts.length();iP++) 
								{ 
									Map mapProductI = mapProducts.getMap(iP);
									// 35 mm on each side
									if(1000*mapProductI.getDouble("Width")>(dWidthEdge+dExtraWidth))
									{ 
										mapProduct = mapProductI;
										iProductFound = true;
										iSingleTape = true;
										iNrTapes = 1;
										break;
									}
								}//next iP
								if (iProductFound)break;
							}//next iF
							if (iProductFound)break;
						}//next iM
						int iNr150;
						if(!iSingleTape)
						{ 
							for (int iCount = 0; iCount < 5; iCount++)
							{
								double dWidthCovered = U(150) * (iCount + 1);
								iNr150 = iCount + 1;
								iNrTapes += 1;
								// get the other tape
								for (int iM = 0; iM < mapManufacturers.length(); iM++)
								{
									Map mapManufacturerI = mapManufacturers.getMap(iM);
									if (mapManufacturerI.getString("Name") != "Siga")continue;
									Map mapFamilies = mapManufacturerI.getMap("Family[]");
									for (int iF = 0; iF < mapFamilies.length(); iF++)
									{
										Map mapFamilyI = mapFamilies.getMap(iF);
										if (mapFamilyI.getString("Name") != "Wigluv")continue;
										Map mapProducts = mapFamilyI.getMap("Product[]");
										for (int iP = 0; iP < mapProducts.length(); iP++)
										{
											Map mapProductI = mapProducts.getMap(iP);
											if (1000 * mapProductI.getDouble("Width") > (dWidthEdge -iNr150*U(150)+dExtraWidth))
											{
												mapProduct = mapProductI;
												iProductFound = true;
												break;
											}
										}//next iP
										if (iProductFound)break;
									}//next iF
									if (iProductFound)break;
								}//next iM
								if (iProductFound)break;
							}
						}
						
						// top edge 
						String sHWDescriptionI = sHWDescription + sOuterEdge+";"+sFloorWall+";";;
						hwcI.setDescription(sHWDescriptionI);
						hwcI.setDScaleX(dLengthEdge+U(80));
						hwcI.setDScaleY(mapProduct.getDouble("Width")*1000);
						hwcI.setArticleNumber(mapProduct.getString("ArticleNumber"));
						hwcs.append(hwcI);
						if(!iSingleTape)
						{ 
							// 150
							String sHWDescriptionI = sHWDescription + sOuterEdge+";"+sFloorWall+";";
							hwcI.setDescription(sHWDescriptionI);
							hwcI.setDScaleX(dLengthEdge+U(80));
							hwcI.setDScaleY(mapProduct150.getDouble("Width")*1000);
							hwcI.setArticleNumber(mapProduct150.getString("ArticleNumber"));
							hwcs.append(hwcI);
						}
					}
					else if(!iTop)
					{ 
						// bottom edge
//						double dExtraWidth = U(200);
						double dExtraWidth = U(100);
						// visible quality only 4 cm each side
						if (sSQTop == "VQ")dExtraWidth -= U(60);
						if (sSQBottom == "VQ")dExtraWidth -= U(60);
						// find the product
						Map mapProduct;
						int iProductFound;
						for (int iM=0;iM<mapManufacturers.length();iM++) 
						{ 
							Map mapManufacturerI= mapManufacturers.getMap(iM);
							if (mapManufacturerI.getString("Name") != "Siga")continue;
							Map mapFamilies = mapManufacturerI.getMap("Family[]");
							for (int iF=0;iF<mapFamilies.length();iF++) 
							{ 
								Map mapFamilyI = mapFamilies.getMap(iF);
								if (mapFamilyI.getString("Name") != "Wigluv")continue;
								Map mapProducts = mapFamilyI.getMap("Product[]");
								for (int iP=0;iP<mapProducts.length();iP++) 
								{ 
									Map mapProductI = mapProducts.getMap(iP);
									// 35 mm on each side
									if(1000*mapProductI.getDouble("Width")>(dWidthEdge+dExtraWidth))
									{ 
										mapProduct = mapProductI;
										iProductFound = true;
										iSingleTape = true;
										iNrTapes = 1;
										break;
									}
								}//next iP
								if (iProductFound)break;
							}//next iF
							if (iProductFound)break;
						}//next iM
						int iNr150;
						if(!iSingleTape)
						{ 
							for (int iCount = 0; iCount < 5; iCount++)
							{
								double dWidthCovered = U(150) * (iCount + 1);
								iNr150 = iCount + 1;
								iNrTapes += 1;
								// get the other tape
								for (int iM = 0; iM < mapManufacturers.length(); iM++)
								{
									Map mapManufacturerI = mapManufacturers.getMap(iM);
									if (mapManufacturerI.getString("Name") != "Siga")continue;
									Map mapFamilies = mapManufacturerI.getMap("Family[]");
									for (int iF = 0; iF < mapFamilies.length(); iF++)
									{
										Map mapFamilyI = mapFamilies.getMap(iF);
										if (mapFamilyI.getString("Name") != "Wigluv")continue;
										Map mapProducts = mapFamilyI.getMap("Product[]");
										for (int iP = 0; iP < mapProducts.length(); iP++)
										{
											Map mapProductI = mapProducts.getMap(iP);
											double ddd = 1000 * mapProductI.getDouble("Width");
											dWidthEdge - iNr150 * U(150) + dExtraWidth;
											double dDif = dWidthEdge - iNr150 * U(150) + dExtraWidth;
											if (1000 * mapProductI.getDouble("Width") > (dWidthEdge - iNr150*U(150)+dExtraWidth))
											{
												mapProduct = mapProductI;
												iProductFound = true;
												break;
											}
										}//next iP
										if (iProductFound)break;
									}//next iF
									if (iProductFound)break;
								}//next iM
								if (iProductFound)break;
							}
						}
						// top edge 
						String sHWDescriptionI = sHWDescription + sOuterEdge+";"+sFloorWall+";";;
						hwcI.setDescription(sHWDescriptionI);
						hwcI.setDScaleX(dLengthEdge+U(200));
						hwcI.setDScaleY(mapProduct.getDouble("Width")*1000);
						hwcI.setArticleNumber(mapProduct.getString("ArticleNumber"));
						hwcs.append(hwcI);
						if(!iSingleTape)
						{ 
							// 150
							String sHWDescriptionI = sHWDescription + sOuterEdge+";"+sFloorWall+";";
							hwcI.setDescription(sHWDescriptionI);
							hwcI.setDScaleX(dLengthEdge+U(200));
							hwcI.setDScaleY(mapProduct150.getDouble("Width")*1000);
							hwcI.setArticleNumber(mapProduct150.getString("ArticleNumber"));
							hwcs.append(hwcI);
						}
					}
				}
			}
		}
		int iColor=iColorDefault;
		int iTransparency=iTransparencyDefault;
		double dTapeWidthFront = dTapeWidthFrontDefault;
		Map mapDisplayFound;
		int iMapDisplayFound;
		for (int imap=0;imap<mapDisplays.length();imap++) 
		{ 
			Map m = mapDisplays.getMap(imap);
			if(m.hasInt("NrTapesEdge") && m.getInt("NrTapesEdge")==iNrTapes)
			{ 
				iMapDisplayFound = true;
				mapDisplayFound = m;
				{ 
					String k;
					k = "Color";if (m.hasInt(k))iColor = m.getInt(k);
					k = "Transparency";if (m.hasInt(k))iTransparency = m.getInt(k);
					k = "TapeWidthFront";if (m.hasDouble(k))dTapeWidthFront = m.getDouble(k);
				}
				break;
			}
		}//next imap
		
		dpModel.color(iColor);
		dpModel.transparency(iTransparency);
		dpFront.color(iColor);
		dpFront.transparency(iTransparency);
//		int iColor;
//		if (iSingleTape)
//		{
//			iColor = iColorDefault;
////			dpEdge.color(1);
//			dpModel.color(iColor);
//			dpFront.color(iColor);
//		}
//		else if(!iSingleTape)
//		{
//			iColor = 5;
////			dpEdge.color(5);
//			dpModel.color(5);
//			dpFront.color(5);
//		}
		
		for (int ipp=0;ipp<ppsDraw.length();ipp++) 
		{ 
//			dpEdge.draw( ppsDraw[ipp],_kDrawFilled);
			dpModel.draw( ppsDraw[ipp],_kDrawFilled);
		}//next ipp
		for (int ipp=0;ipp<ppsTopDraw.length();ipp++) 
		{ 
//			dpEdge.draw( ppsTopDraw[ipp],_kDrawFilled);
			// update width of the top view of edge
			PlaneProfile pp = ppsTopDraw[ipp];
			PlaneProfile ppNew(pp.coordSys());
			{ 
			// get extents of profile
				Vector3d vecXpp = vecXtopDraw[ipp];
				Vector3d vecYpp = vecYtopDraw[ipp];
				LineSeg segpp = pp.extentInDir(vecXpp);
				double dXpp = abs(vecXpp.dotProduct(segpp.ptStart()-segpp.ptEnd()));
				double dYpp = abs(vecYpp.dotProduct(segpp.ptStart()-segpp.ptEnd()));
				PLine plNew;
				plNew.createRectangle(LineSeg(segpp.ptMid()-vecYpp*.5*dTapeWidthFront-vecXpp*.5*dXpp,
				segpp.ptMid() + vecYpp * .5 * dTapeWidthFront + vecXpp * .5 * dXpp), vecXpp, vecYpp);
				
				ppNew.joinRing(plNew, _kAdd);
			}
//			dpFront.draw( ppsTopDraw[ipp],_kDrawFilled);
ppNew.vis(2);
			dpFront.draw( ppNew,_kDrawFilled);
			
			// maprequest for shopdrawing
			Map mapRequestPlaneProfileI = mapRequestPlaneProfile;
			mapRequestPlaneProfileI.setInt("Transparency", iTransparency);
			mapRequestPlaneProfileI.setString("Stereotype", "PlaneProfileTape");
			mapRequestPlaneProfileI.setPlaneProfile("PlaneProfile", ppNew);
			mapRequestPlaneProfileI.setVector3d("AllowedView", -vecZ);
			mapRequestPlaneProfileI.setInt("AlsoReverseDirection", true); 
			mapRequestPlaneProfileI.setInt("Color", iColor);
	        mapRequestPlaneProfileI.setInt("DrawFilled", _kDrawFilled);
	        mapRequestPlaneProfileI.setInt("ShowForDirOfView", true);
	        mapRequestPlaneProfileI.setInt("ShowForOppositeDirOfView", true);
	        mapRequests.appendMap("DimRequest", mapRequestPlaneProfileI);
		}//next ipp
		
		
		if (mapRequests.length() > 0)
		{
			_Map.setMap("DimRequest[]", mapRequests);
		}
		else
		{
			_Map.removeAt("DimRequest[]", true);
		}
	}
	
	// make sure the hardware is updated
	if (_bOnDbCreated) setExecutionLoops(2);				
	_ThisInst.setHardWrComps(hwcs);	
	
	double dLengthSum;
//	
// make sure the hardware is updated
	if (_bOnDbCreated)	setExecutionLoops(2);				
	_ThisInst.setHardWrComps(hwcs);	
	
	// collect all hardwares
	TslInst tslTapes[0];
	Entity entsConnected[] = sip.eToolsConnected();
	for (int ient=0;ient<entsConnected.length();ient++) 
	{ 
		TslInst t = (TslInst)entsConnected[ient];
		String sTslName = scriptName();
		if (_bOnDebug)sTslName = "hsbCLT-Tape";
		if ( ! t.bIsValid() || t.scriptName() != sTslName)continue;
		if (tslTapes.find(t) < 0)
		{ 
			// new found
			tslTapes.append(t);
		}
		
	}//next ient
	
	// collect existing hardware
	HardWrComp hwcsAll[0];
	for (int itsl=0;itsl<tslTapes.length();itsl++) 
	{ 
		hwcsAll.append(tslTapes[itsl].hardWrComps());
	}//next itsl
	
	
// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
//	for (int i=hwcsAll.length()-1; i>=0 ; i--) 
//		if (hwcsAll[i].repType() == _kRTTsl)
//			hwcsAll.removeAt(i); 
	
	double dLengthSums[0];
	double dWidths[0];
	for (int i=0;i<hwcsAll.length();i++) 
	{ 
		int iIndexWidth = dWidths.find(hwcsAll[i].dScaleY());
		if (iIndexWidth < 0)
		{ 
			dWidths.append(hwcsAll[i].dScaleY());
			dLengthSums.append(hwcsAll[i].dScaleX());
		}
		else
		{ 
			dLengthSums[iIndexWidth] += hwcsAll[i].dScaleX();
		}
	}//next i
	Map mapXtape;
	for (int i=0;i<dWidths.length();i++) 
	{ 
		mapXtape.setDouble("TotalLength"+i, dLengthSums[i]);
		mapXtape.setDouble("Width"+i, dWidths[i]);
		 
	}//next i
	sip.setSubMapX("Tape", mapXtape);
}

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
        <int nm="BreakPoint" vl="1879" />
        <int nm="BreakPoint" vl="1877" />
        <int nm="BreakPoint" vl="1876" />
        <int nm="BreakPoint" vl="2668" />
        <int nm="BreakPoint" vl="3981" />
        <int nm="BreakPoint" vl="3949" />
        <int nm="BreakPoint" vl="4039" />
        <int nm="BreakPoint" vl="2694" />
        <int nm="BreakPoint" vl="2500" />
        <int nm="BreakPoint" vl="1411" />
        <int nm="BreakPoint" vl="2174" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13767: improve segpents at lapjoints" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="12/15/2021 5:27:08 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12605: group assignment, fix lap joint, add display maps in xml" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="10/27/2021 8:32:28 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12605: apply distribution rules;write hardware;write mapXData" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="10/5/2021 11:48:15 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12605: keep reference when moving panel; speedup calculation" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="9/30/2021 8:25:14 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12605: support arches and multiple faces at one edge" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="9/30/2021 12:53:55 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12605: add jigging and dragging" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="9/27/2021 9:42:02 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12605: initial working version" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="9/27/2021 3:54:50 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End