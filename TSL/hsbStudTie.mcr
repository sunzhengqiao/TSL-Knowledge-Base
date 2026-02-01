#Version 8
#BeginDescription
#Versions
Version 1.4 10.05.2023 HSB-18650 standard display published for share and make , Author Thorsten Huck
version value="1.3" date="10dec20" author="marsel.nakuci@hsbcad.com"

HSB-9045: distinguish between studs attached to top plate and those attached at bottom plate
HSB-9045: if beams are part of an element then use zone of the element for the side
HSB-9045: implement beam mode to allow insertion at male-female beams
HSB-9045: initial

This tsl creates single sided stud tie connectors.

#End
#Type O
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords Stud,Tie,StudTie
#BeginContents
/// <History>//region
//#Versions
// 1.4 10.05.2023 HSB-18650 standard display published for share and make , Author Thorsten Huck
/// <version value="1.3" date="10dec20" author="marsel.nakuci@hsbcad.com"> HSB-9045: distinguish between studs attached to top plate and those attached at bottom plate</version>
/// <version value="1.2" date="04dec20" author="marsel.nakuci@hsbcad.com"> HSB-9045: if beams are part of an element then use zone of the element for the side</version>
/// <version value="1.1" date="03dec20" author="marsel.nakuci@hsbcad.com"> HSB-9045: implement beam mode to allow insertion at male-female beams</version>
/// <version value="1.0" date="01dec20" author="marsel.nakuci@hsbcad.com"> HSB-9045: initial </version>
/// </History>

/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates VUETRADE single sided stud tie connectors.
/// https://vuetrade.com/product/single-sided-stud-ties/

/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbStudTie")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Swap Side|") (_TM "|Select hsbStudTie TSL|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Swap Zone|") (_TM "|Select hsbStudTie TSL|"))) TSLCONTENT
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
	
//region properties
	// distribution in studs
	category = T("|Distribution|");
	String sDistributionsStud[] ={ T("|Every Stud|"), T("|Every odd Stud|"), T("|Every even Stud|")};
	String sDistributionStudName=T("|Stud Tie|");	
	PropString sDistributionStud(nStringIndex++, sDistributionsStud, sDistributionStudName);	
	sDistributionStud.setDescription(T("|Defines the Distribution of the Stud ties|"));
	sDistributionStud.setCategory(category);
	
	// position of the tie top, bottom, both
	String sPositionName=T("|Plates|");	
	String sPositions[] ={ T("|Both|"), T("|Top Plate|"), T("|Bottom Plate|")};
	PropString sPosition(nStringIndex++, sPositions, sPositionName);	
	sPosition.setDescription(T("|Defines the Position with respect to the top plate and the bottom plate|"));
	sPosition.setCategory(category);
	
	category = T("|Alignment|");
	// side of tie in wall left, right, both
	String sSideName=T("|Side|");
	String sSides[] ={ T("|Left|"), T("|Right|"), T("|Both|")};
	PropString sSide(nStringIndex++, sSides, sSideName);
	sSide.setDescription(T("|Defines the Side|"));
	sSide.setCategory(category);
	
	String sZones[] ={ "1", "-1", T("|Both|")};
	String sZoneName=T("|Zone|");	
	PropString sZone(nStringIndex++, sZones, sZoneName);	
	sZone.setDescription(T("|Defines the Zone|"));
	sZone.setCategory(category);
//End properties//endregion 
	
//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
	// silent/dialog
		if (_kExecuteKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());	
			if (sEntries.findNoCase(_kExecuteKey,-1)>-1)
				setPropValuesFromCatalog(_kExecuteKey);
			else
				setPropValuesFromCatalog(sLastInserted);
		}
	// standard dialog	
		else
		{ 
			String sOptions[] ={ T("|Element|"), T("|Beams|")};
			// prompt mode element or beams
			String sInsertChoice = getString(T("|Select insertion mode| => " + " [" + T("|Element|") + "/" + T("|Beams|") + "] "));
			if(sInsertChoice=="" || sInsertChoice=="E")
			{ 
				// element mode
				showDialog();
		
				// prompt to select walls
				int iCount = 0;
		//		while(iCount<100)
				{ 
				// prompt for elements
					Element elements[0];
					PrEntity ssE(T("|Select elements|"), ElementWall());
				  	if (ssE.go())
						elements.append(ssE.elementSet());
				// break loop if no element selected
		//			if (elements.length() == 0)break;
				// create TSL
					TslInst tslNew;			Vector3d vecXTsl= _XW;	Vector3d vecYTsl= _YW;
					GenBeam gbsTsl[] = {};	Entity entsTsl[1];		Point3d ptsTsl[] = {_Pt0};
					int nProps[]={};
					double dProps[]={};		
					String sProps[]={sDistributionStud, sPosition, sSide, sZone};
					Map mapTsl;	
					
					for (int i=0;i<elements.length();i++) 
					{ 
						ElementWall e = (ElementWall)elements[i];
						if ( ! e.bIsValid())continue;
						entsTsl[0] = e;
						mapTsl.setInt("mode", 0);
						tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
					}//next i
				}
			}
			else
			{ 
				sDistributionStud = PropString (0, sDistributionsStud, sDistributionStudName,0);
				sDistributionStud.set(T("<|Disabled|>"));
				sDistributionStud.setReadOnly(true);
				
				sPosition = PropString (1, sPositions, sPositionName,0);
				sPosition.set(T("<|Disabled|>"));
				sPosition.setReadOnly(true);
				
				sSide.setReadOnly(false);
				sSide = PropString (2, sSides, sSideName,0);
				sSide.set(sSides[0]);
				
				sZone.setReadOnly(false);
				sZone = PropString (3, sZones, sZoneName, 0);
				sZone.set(sZones[0]);
				
//				showDialog("---");
				showDialog();
				// beam mode
				
				int iCount = 0;
				String sPromptMale = T("|Select male beams|");
				String sPromptFemale = T("|Select female beams|");
				while (iCount < 100)
				{ 
					Beam beamsMale[0];
					PrEntity ssMale(sPromptMale, Beam());
					if (ssMale.go())
						beamsMale.append(ssMale.beamSet());
						
					if (beamsMale.length() == 0)break;
					
					Beam beamsFemale[0];
					PrEntity ssFemale(sPromptFemale, Beam());
					if (ssFemale.go())
						beamsFemale.append(ssFemale.beamSet());
					
					if (beamsFemale.length() == 0)break;
					
					// remove those already in beamsMale
					for (int i = beamsFemale.length() - 1; i >= 0; i--)
					{ 
						if (beamsMale.find(beamsFemale[i]) >- 1)
						{ 
							// remove if already included at male beam selection
							beamsFemale.removeAt(i);
						}
					}//next i
					
				// create TSL
					TslInst tslNew;		Vector3d vecXTsl = _XU;	Vector3d vecYTsl = _YU;
					GenBeam gbsTsl[2];	Entity entsTsl[0];		Point3d ptsTsl[0];
					int nProps[0];		double dProps[0];		String sProps[0];
					Map mapTsl;
					
					// create a tsl instance for each valid male-female connection
					for (int i = 0; i < beamsMale.length(); i++)
					{ 
						Beam bmMale = beamsMale[i];
						gbsTsl[0] = bmMale;
						Vector3d vxMale = bmMale.vecX();
						// loop females
						for (int j = 0; j < beamsFemale.length(); j++)
						{ 
							Beam bmFemale = beamsFemale[j];
							Vector3d vxFemale = bmFemale.vecX();
							if (vxMale.isParallelTo(vxFemale))
							{
								// parallel, not allowed
								continue;
							}
							LineBeamIntersect lbi(bmMale.ptCen(), vxMale, bmFemale);
							Point3d ptI = lbi.pt1();
							Point3d ptImin = bmFemale.ptCen();
							Point3d ptImax = bmFemale.ptCen();
							ptImin.transformBy(-vxFemale * bmFemale.solidLength() * .5);
							ptImax.transformBy(vxFemale * bmFemale.solidLength() * .5);
							double dInt = vxFemale.dotProduct(ptI - bmFemale.ptCen());
							double dIntMin = vxFemale.dotProduct(ptImin - bmFemale.ptCen());
							double dIntMax = vxFemale.dotProduct(ptImax - bmFemale.ptCen());
							// intersection outside the female length
							if (dInt <= dIntMin || dInt >= dIntMax)
							{
								continue;
							}
							// no contact can be found
							if ( ! lbi.bHasContact())
							{
								// create TSL also if the vecX of male does not intersect the female
		//						continue;
							}
							gbsTsl[1] = bmFemale;
							// properties
							sProps.setLength(0);
							sProps.append(sSide);
							sProps.append(sZone);
							// map 
							mapTsl.setInt("mode", 2);
							// create TSL
							tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
											nProps, dProps, sProps,_kModelSpace, mapTsl);
						}//next j
					}//next i
				}
			}
		}
		eraseInstance();
		return;
	}
// end on insert	__________________//endregion
	
//region mapIO: support property dialog input via map on element creation
	{
//		int bHasPropertyMap = _Map.hasMap("PROPSTRING[]") && _Map.hasMap("PROPINT[]") && _Map.hasMap("PROPDOUBLE[]");
		int bHasPropertyMap = _Map.hasMap("PROPSTRING[]");
		if (_bOnMapIO)
		{ 
			if (bHasPropertyMap)
				setPropValuesFromMap(_Map);	
			showDialog();
			_Map = mapWithPropValues();
			return;
		}
		if (_bOnElementDeleted)
		{
			eraseInstance();
			return;
		}
		else if (_bOnElementConstructed && bHasPropertyMap)
		{ 
			setPropValuesFromMap(_Map);
			_Map = Map();
		}	
	}		
	//End mapIO: support property dialog input via map on element creation//endregion 
	
	String sURL = "https://vuetrade.com/product/single-sided-stud-ties/";
	_ThisInst.setHyperlink(sURL);
	
int iMode = _Map.getInt("mode");
//return;
if(iMode==0)
{ 
	// create all instances for the element
	if(_Element.length()==0)
	{ 
		reportMessage(TN("|no element found|"));
		eraseInstance();
		return;
	}
	
	ElementWall eW = (ElementWall)_Element[0];
	if(!eW.bIsValid())
	{ 
		reportMessage(TN("|no an ElementWall|"));
		eraseInstance();
		return;
	}
	
	Point3d ptOrg = eW.ptOrg();
	Vector3d vecX = eW.vecX();
	Vector3d vecY = eW.vecY();
	Vector3d vecZ = eW.vecZ();
	
	_Pt0 = ptOrg;
	
	Display dp(1);
	dp.showInDxa(true);//HSB-18650 standard display published for share and make
//	dp.draw(scriptName(), _Pt0, vecX, vecY, 0, 0, _kDeviceX);
//	reportMessage("\n"+ scriptName() + " OK..");
	
	//get all studs
	Beam beams[] = eW.beam();
	if (beams.length() == 0)return;
	Beam beamStuds[] = vecX.filterBeamsPerpendicularSort(beams);
	// horizontal beams
	Beam beamsHor[] = vecY.filterBeamsPerpendicularSort(beams);
	
//	int i
	int iDistributionStud = sDistributionsStud.find(sDistributionStud);
	int iPosition = sPositions.find(sPosition);
	// create TSL
	TslInst tslNew;		Vector3d vecXTsl= _XW;	Vector3d vecYTsl= _YW;
	GenBeam gbsTsl[2];	Entity entsTsl[] = {};	Point3d ptsTsl[] = {_Pt0};
	int nProps[]={};	
	double dProps[]={};		
	String sProps[] ={ sDistributionStud, sPosition, sSide, sZone};
	Map mapTsl;	
	mapTsl.setInt("mode", 1);
	//
	Beam bmStudsTop[0], bmStudsBottom[0];
	
	// top plates and bottom plates
	Beam bmTops[0], bmBottoms[0];
	for (int i=0;i<beamStuds.length();i++) 
	{ 
		Beam beamsAbove[] = Beam().filterBeamsHalfLineIntersectSort(beamsHor, beamStuds[i].ptCen(), vecY);
		Beam beamsBelow[] = Beam().filterBeamsHalfLineIntersectSort(beamsHor, beamStuds[i].ptCen(), -vecY);
		
		if(beamsAbove.length()>0)
			if(bmTops.find(beamsAbove[beamsAbove.length() - 1])<0)
				bmTops.append(beamsAbove[beamsAbove.length() - 1]);
		
		if(beamsBelow.length()>0)
			if(bmBottoms.find(beamsBelow[beamsBelow.length() - 1])<0)
				bmBottoms.append(beamsBelow[beamsBelow.length() - 1]);
	}//next i
	// get bmStudsTop and bmStudsBottom
	for (int i=0;i<bmTops.length();i++) 
	{ 
		Beam bmStudsT[]=Beam().filterBeamsHalfLineIntersectSort(beamStuds, 
						bmTops[i].ptCen()-vecY*(.5*bmTops[i].dD(vecY)+dEps), vecX);
		for (int ii=0;ii<bmStudsT.length();ii++) 
		{ 
			if(bmStudsTop.find(bmStudsT[ii])<0)
				bmStudsTop.append(bmStudsT[ii]);
		}//next ii
		bmStudsT.setLength(0);
		bmStudsT=Beam().filterBeamsHalfLineIntersectSort(beamStuds, 
						bmTops[i].ptCen()-vecY*(.5*bmTops[i].dD(vecY)+dEps), -vecX);
		for (int ii=0;ii<bmStudsT.length();ii++) 
		{ 
			if(bmStudsTop.find(bmStudsT[ii])<0)
				bmStudsTop.append(bmStudsT[ii]);
		}//next ii
	}//next i
	
	for (int i=0;i<bmBottoms.length();i++) 
	{ 
		Beam bmStudsB[]=Beam().filterBeamsHalfLineIntersectSort(beamStuds, 
						bmBottoms[i].ptCen()+vecY*(.5*bmBottoms[i].dD(vecY)+dEps), vecX);
		for (int ii=0;ii<bmStudsB.length();ii++) 
		{ 
			if(bmStudsBottom.find(bmStudsB[ii])<0)
				bmStudsBottom.append(bmStudsB[ii]);
		}//next ii
		bmStudsB.setLength(0);
		bmStudsB=Beam().filterBeamsHalfLineIntersectSort(beamStuds, 
						bmBottoms[i].ptCen()+vecY*(.5*bmBottoms[i].dD(vecY)+dEps), -vecX);
		for (int ii=0;ii<bmStudsB.length();ii++) 
		{ 
			if(bmStudsBottom.find(bmStudsB[ii])<0)
				bmStudsBottom.append(bmStudsB[ii]);
		}//next ii
	}//next i
	
	// generate tsls with mode 2 for each couple stud-kopfplatte or stud-fussplatte
	for (int i = 0; i < bmStudsTop.length(); i++)
	{ 
		// get kopf and fussplate
		Beam bmKopf, bmFuss;
		Beam beamsAbove[] = Beam().filterBeamsHalfLineIntersectSort(beamsHor, bmStudsTop[i].ptCen(), vecY);
		if(beamsAbove.length()>0)
		{ 
			bmKopf = beamsAbove[beamsAbove.length() - 1];
		}
		if ( ! bmKopf.bIsValid())continue;
		int iHalf = (i+1) / 2;
		if (((i+1) - 2 * iHalf) > dEps)
		{ 
			// odd
			// every or odd distribution
			if(iDistributionStud==0 || iDistributionStud==1)
			{ 
				gbsTsl[0] = bmStudsTop[i];
				if(iPosition==0 || iPosition==1)
				{ 
					// both or top, kopfplatte
					gbsTsl[1] = bmKopf;
					// create tsl
					tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
													nProps, dProps, sProps,_kModelSpace, mapTsl);
				}
			}
		}
		else 
		{ 
			// even
			// every or even distribution
			if(iDistributionStud==0 || iDistributionStud==2)
			{ 
				gbsTsl[0] = bmStudsTop[i];
				if(iPosition==0 || iPosition==1)
				{ 
					// both or top, kopfplatte
					gbsTsl[1] = bmKopf;
					// create tsl
					tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
													nProps, dProps, sProps,_kModelSpace, mapTsl);
				}
			}
		}
	}//next i
	
	for (int i = 0; i < bmStudsBottom.length(); i++)
	{ 
		// get kopf and fussplate
		Beam bmKopf, bmFuss;
		Beam beamsBelow[] = Beam().filterBeamsHalfLineIntersectSort(beamsHor, bmStudsBottom[i].ptCen(), -vecY);
		if(beamsBelow.length()>0)
		{ 
			bmFuss = beamsBelow[beamsBelow.length() - 1];
		}
		if ( ! bmFuss.bIsValid())continue;
		int iHalf = (i+1) / 2;
		if (((i+1) - 2 * iHalf) > dEps)
		{ 
			// odd
			// every or odd distribution
			if(iDistributionStud==0 || iDistributionStud==1)
			{ 
				gbsTsl[0] = bmStudsBottom[i];
				if(iPosition==0 || iPosition==2)
				{ 
					// both or bottom
					gbsTsl[1] = bmFuss;
					// create tsl
					tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
													nProps, dProps, sProps,_kModelSpace, mapTsl);
				}
			}
		}
		else 
		{ 
			// even
			// every or even distribution
			if(iDistributionStud==0 || iDistributionStud==2)
			{ 
				gbsTsl[0] = bmStudsBottom[i];
				if(iPosition==0 || iPosition==2)
				{ 
					// both or bottom
					gbsTsl[1] = bmFuss;
					// create tsl
					tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
													nProps, dProps, sProps,_kModelSpace, mapTsl);
				}
			}
		}
	}//next i
	
	// generate tsls with mode 2 for each couple stud-kopfplatte or stud-fussplatte
//	for (int i = 0; i < beamStuds.length(); i++)
//	{ 
//		// get kopf and fussplate
//		Beam bmKopf, bmFuss;
//		Beam beamsAbove[] = Beam().filterBeamsHalfLineIntersectSort(beamsHor, beamStuds[i].ptCen(), vecY);
//		Beam beamsBelow[] = Beam().filterBeamsHalfLineIntersectSort(beamsHor, beamStuds[i].ptCen(), -vecY);
//		if(beamsAbove.length()>0)
//		{ 
//			bmKopf = beamsAbove[beamsAbove.length() - 1];
//		}
//		if(beamsBelow.length()>0)
//		{ 
//			bmFuss = beamsBelow[beamsBelow.length() - 1];
//		}
//		int iHalf = (i+1) / 2;
//		if (((i+1) - 2 * iHalf) > dEps)
//		{ 
//			// odd
//			// every or odd distribution
//			if(iDistributionStud==0 || iDistributionStud==1)
//			{ 
//				gbsTsl[0] = beamStuds[i];
//				if(iPosition==0 || iPosition==1)
//				{ 
//					// both or top, kopfplatte
//					gbsTsl[1] = bmKopf;
//					// create tsl
//					tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
//													nProps, dProps, sProps,_kModelSpace, mapTsl);
//				}
//				if(iPosition==0 || iPosition==2)
//				{ 
//					// both or bottom
//					gbsTsl[1] = bmFuss;
//					// create tsl
//					tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
//													nProps, dProps, sProps,_kModelSpace, mapTsl);
//				}
//			}
//		}
//		else 
//		{ 
//			// even
//			// every or even distribution
//			if(iDistributionStud==0 || iDistributionStud==2)
//			{ 
//				gbsTsl[0] = beamStuds[i];
//				if(iPosition==0 || iPosition==1)
//				{ 
//					// both or top, kopfplatte
//					gbsTsl[1] = bmKopf;
//					// create tsl
//					tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
//													nProps, dProps, sProps,_kModelSpace, mapTsl);
//				}
//				if(iPosition==0 || iPosition==2)
//				{ 
//					// both or bottom
//					gbsTsl[1] = bmFuss;
//					// create tsl
//					tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
//													nProps, dProps, sProps,_kModelSpace, mapTsl);
//				}
//			}
//		}
//	}//next i
	eraseInstance();
	return;
}
else if(iMode==1)
{ 
	// single instance at two beams and element
	// set irrelevant properties
	sDistributionStud.set(T("<|Disabled|>"));
	sDistributionStud.setReadOnly(true);
	sPosition.set(T("<|Disabled|>"));
	sPosition.setReadOnly(true);
	// mode with 2 beams, T connection
	if(_Beam.length()!=2)
	{ 
		reportMessage(TN("|two beams needed|"));
		eraseInstance();
		return;
	}
	Beam bm0 = _Beam[0];
	Vector3d vecX0 = bm0.vecX();
	Vector3d vecY0 = bm0.vecY();
	Vector3d vecZ0 = bm0.vecZ();
	Point3d ptCen0 = bm0.ptCen();
	
	Beam bm1 = _Beam[1];
	Vector3d vecX1 = bm1.vecX();
	Vector3d vecY1 = bm1.vecY();
	Vector3d vecZ1 = bm1.vecZ();
	Point3d ptCen1 = bm1.ptCen();
	
	if(!vecX0.isPerpendicularTo(vecX1))
	{ 
		reportMessage(TN("|beams not perpendicular|"));
		eraseInstance();
		return;
	}
	
	// get the element from the beams
	Element el = bm0.element();
	Element el1 = bm1.element();
	if(el!=el1)
	{ 
		reportMessage(TN("|invalid beams. beams belonging to different elements|"));
		eraseInstance();
		return;
	}
	
	ElementWall eW = (ElementWall)el;
	Vector3d vecX = eW.vecX();
	Vector3d vecY = eW.vecY();
	Vector3d vecZ = eW.vecZ();
	Point3d ptOrg = eW.ptOrg();
	
	_Pt0 = Line(ptCen1, vecX1).intersect(Plane(ptCen0, vecX1), 0.001);
	Display dp(3);
//	dp.draw(scriptName(), _Pt0, vecX0, vecY0, 0, 0, _kDeviceX);
	
	// prepare left and right body
	// left one is placed at left of stud, right one is placed at right of stud
	Body bdLeft, bdRight;
	ptOrg.vis(3);
	_XW.vis(ptOrg, 1);
	_YW.vis(ptOrg, 2);
	_ZW.vis(ptOrg, 3);
	
	
	double dThickness = U(3);
	Body bdTopPlate(_Pt0, _XW, _YW, _ZW, U(32), U(60) + dThickness, dThickness, - 1 ,- 1 , 1);
	bdTopPlate.transformBy(_YW * dThickness);
	bdTopPlate.vis(3);
	
	Body bdFrontPlate;
	PLine plFrontPlate(_YW);
	Point3d pt = _Pt0;
	plFrontPlate.addVertex(pt);
	pt = pt - _XW * U(32);
	plFrontPlate.addVertex(pt);
	pt = pt - _ZW * U(80);
	plFrontPlate.addVertex(pt);
	pt = pt - _ZW * U(66) + _XW * U(32);
	plFrontPlate.addVertex(pt);
	plFrontPlate.close();
	plFrontPlate.vis(4);
	bdFrontPlate = Body(plFrontPlate, _YW * dThickness);
	bdFrontPlate.vis(3);
	
	Body bdSidePlate;
	PLine plSidePlate(_XW);
	pt = _Pt0 - _ZW * U(80);
	plSidePlate.addVertex(pt);
	pt = pt - _ZW * U(158);
	plSidePlate.addVertex(pt);
	pt = pt - _YW * U(32);
	plSidePlate.addVertex(pt);
	pt = pt + _ZW * U(92);
	plSidePlate.addVertex(pt);
	pt = pt + _YW * U(32) + _ZW * U(66);
	plSidePlate.addVertex(pt);
	plSidePlate.vis(4);
	bdSidePlate = Body(plSidePlate, _XW * dThickness);
	bdSidePlate.vis(3);
	
	bdLeft.addPart(bdTopPlate);
	bdLeft.addPart(bdFrontPlate);
	bdLeft.addPart(bdSidePlate);
	
	CoordSys csMirror;
	csMirror.setToMirroring(Plane(_Pt0, _XW));
	bdRight = bdLeft;
	bdRight.transformBy(csMirror);
	
//	bdRight.vis(5);
	
	// group assignment
	assignToElementGroup(el, true, 0, 'Z');
//	assignToLayer('i');
	
//	sSide
//	nZone
	int iSide = sSides.find(sSide);
	int iZone = sZones.find(sZone);
	int nZone;
	int nZones[] ={ 1 ,- 1};
	for (int iZ=0;iZ<2;iZ++) 
	{ 
		if (iZone == iZ || iZone == 2)
			nZone = nZones[iZ];
		else 
			continue;
		ElemZone eZone = el.zone(nZone);
		Vector3d vecYpart = el.zone(nZone).vecZ();
		
		
		// insertion point of the part
		Point3d ptInsertion = ptCen0 + vecYpart * .5 * bm0.dD(vecYpart);
	//	vector pointing toward female beam
		Vector3d vecX01 = vecX0;
		if (vecX01.dotProduct(ptCen1 - ptCen0) < 0)vecX01 *= -1;
		Vector3d vecZpart = vecX01;
		Vector3d vecXpart = vecYpart.crossProduct(vecZpart);
		vecXpart.vis(_Pt0, 6);
		vecYpart.vis(_Pt0,3);
		vecZpart.vis(_Pt0, 4);
		
		ptInsertion += vecX01 * vecX01.dotProduct(bm1.ptCen() + .5 * vecX01 * bm1.dD(vecX01)-ptInsertion);
		Point3d ptInsertionMiddle=ptInsertion;
		Display dpPart(252);
		if(iSide==0 || iSide==2)
		{ 
			// left or both
			ptInsertion = ptInsertionMiddle + vecXpart * (.5 * bm0.dD(vecXpart) );
			Body bd = bdLeft;
			CoordSys csPart;
			csPart.setToAlignCoordSys(_Pt0, _XW, _YW, _ZW, ptInsertion, vecXpart, vecYpart, vecZpart);
			bd.transformBy(csPart);
			bd.vis(4);
			dpPart.draw(bd);
		}
		if(iSide==1 || iSide==2)
		{ 
			// right or both
			ptInsertion = ptInsertionMiddle - vecXpart * (.5 * bm0.dD(vecXpart) );
			Body bd = bdRight;
			CoordSys csPart;
			csPart.setToAlignCoordSys(_Pt0, _XW, _YW, _ZW, ptInsertion, vecXpart, vecYpart, vecZpart);
			bd.transformBy(csPart);
			bd.vis(4);
			dpPart.draw(bd);
		}
		ptInsertion.vis(3);
	}//next iZ
	
	
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
		Element elHW =eW; 
		// check if the parent entity is an element
		if (!elHW.bIsValid())	elHW = (Element)eW;
		if (elHW.bIsValid()) 	sHWGroupName=elHW.elementGroup().name();
	// loose
		else
		{
			Group groups[] = _ThisInst.groups();
			if (groups.length()>0)	sHWGroupName=groups[0].name();
		}		
	}
	int iNrHardwareLeft, iNrHardwareRight;
	if (iZone == 0 || iZone == 1)
	{
		if(iSide==0 || iSide==2)
			iNrHardwareLeft = 1;
		if(iSide==1 || iSide==2)
			iNrHardwareRight = 1;
	}
	else if(iZone == 2)
	{ 
		if(iSide==0 || iSide==2)
			iNrHardwareLeft = 2;
		if(iSide==1 || iSide==2)
			iNrHardwareRight = 2;
	}
		
// add main componnent
	// left
	if(iNrHardwareLeft>0)
	{ 
		HardWrComp hwc("SingleSided STUD TIES", iNrHardwareLeft); // the articleNumber and the quantity is mandatory
		
		hwc.setManufacturer("Vuetrade");
		
		hwc.setModel("VTSTLH");
//		hwc.setName(sHWName);
//		hwc.setDescription(sHWDescription);
		hwc.setMaterial("G300 Z275 Galvanised Steel");
//		hwc.setNotes(sHWNotes);
		
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(eW);	
		hwc.setCategory(T("|Connector|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		
		hwc.setDScaleX(U(240));
		hwc.setDScaleY(U(60));
		hwc.setDScaleZ(U(32));
		
	// apppend component to the list of components
		hwcs.append(hwc);
	}
	// right
	if(iNrHardwareRight>0)
	{ 
		HardWrComp hwc("SingleSided STUD TIES", iNrHardwareRight); // the articleNumber and the quantity is mandatory
		
		hwc.setManufacturer("Vuetrade");
		
		hwc.setModel("VTSTRH");
//		hwc.setName(sHWName);
//		hwc.setDescription(sHWDescription);
		hwc.setMaterial("G300 Z275 Galvanised Steel");
//		hwc.setNotes(sHWNotes);
		
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(eW);	
		hwc.setCategory(T("|Connector|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		
		hwc.setDScaleX(U(240));
		hwc.setDScaleY(U(60));
		hwc.setDScaleZ(U(32));
		
	// apppend component to the list of components
		hwcs.append(hwc);
	}

// make sure the hardware is updated
	if (_bOnDbCreated)	setExecutionLoops(2);				
	_ThisInst.setHardWrComps(hwcs);	
	//endregion
}
else if(iMode==2)
{ 
	setKeepReferenceToGenBeamDuringCopy(_kAllBeams);
	// single instance at 2 arbitrary beams male, female
	if (_Beam.length() != 2)
	{ 
		reportMessage(TN("|2 beams needed|"));
		eraseInstance();
		return;
	}
	
//	Display dp(1);
//	dp.draw("mode 2", _Pt0, _XW, _YW, 0, 0, _kDeviceX);
	
	Beam bm0 = _Beam[0];
	Vector3d vecX0 = bm0.vecX();
	Vector3d vecY0 = bm0.vecY();
	Vector3d vecZ0 = bm0.vecZ();
	Point3d ptCen0 = bm0.ptCen();
	
	Beam bm1 = _Beam[1];
	Vector3d vecX1 = bm1.vecX();
	Vector3d vecY1 = bm1.vecY();
	Vector3d vecZ1 = bm1.vecZ();
	Point3d ptCen1 = bm1.ptCen();
	
	Element el = bm0.element();
	Element el1 = bm1.element();
	
	if(!vecX0.isPerpendicularTo(vecX1))
	{ 
		reportMessage(TN("|beams not perpendicular|"));
		eraseInstance();
		return;
	}
	assignToLayer("i");
	assignToGroups(Entity(bm0));
	assignToGroups(Entity(bm1));
	_Pt0 = Line(ptCen1, vecX1).intersect(Plane(ptCen0, vecX1), 0.001);

	Body bdLeft, bdRight;
	
	double dThickness = U(3);
	Body bdTopPlate(_Pt0, _XW, _YW, _ZW, U(32), U(60) + dThickness, dThickness, - 1 ,- 1 , 1);
	bdTopPlate.transformBy(_YW * dThickness);
//	bdTopPlate.vis(3);
	
	Body bdFrontPlate;
	PLine plFrontPlate(_YW);
	Point3d pt = _Pt0;
	plFrontPlate.addVertex(pt);
	pt = pt - _XW * U(32);
	plFrontPlate.addVertex(pt);
	pt = pt - _ZW * U(80);
	plFrontPlate.addVertex(pt);
	pt = pt - _ZW * U(66) + _XW * U(32);
	plFrontPlate.addVertex(pt);
	plFrontPlate.close();
//	plFrontPlate.vis(4);
	bdFrontPlate = Body(plFrontPlate, _YW * dThickness);
//	bdFrontPlate.vis(3);
	
	Body bdSidePlate;
	PLine plSidePlate(_XW);
	pt = _Pt0 - _ZW * U(80);
	plSidePlate.addVertex(pt);
	pt = pt - _ZW * U(158);
	plSidePlate.addVertex(pt);
	pt = pt - _YW * U(32);
	plSidePlate.addVertex(pt);
	pt = pt + _ZW * U(92);
	plSidePlate.addVertex(pt);
	pt = pt + _YW * U(32) + _ZW * U(66);
	plSidePlate.addVertex(pt);
//	plSidePlate.vis(4);
	bdSidePlate = Body(plSidePlate, _XW * dThickness);
//	bdSidePlate.vis(3);
	
	bdLeft.addPart(bdTopPlate);
	bdLeft.addPart(bdFrontPlate);
	bdLeft.addPart(bdSidePlate);
	
	CoordSys csMirror;
	csMirror.setToMirroring(Plane(_Pt0, _XW));
	bdRight = bdLeft;
	bdRight.transformBy(csMirror);
	
	int iSide = sSides.find(sSide);
	int iZone = sZones.find(sZone);
	int nZone;
	int nZones[] ={ 1 ,- 1};
	for (int iZ=0;iZ<2;iZ++) 
	{ 
		if (iZone == iZ || iZone == 2)
			nZone = nZones[iZ];
		else 
			continue;
			
		Vector3d vecYpart = vecX0.crossProduct(vecX1);
		
		if (nZone == 1)
		{
			if(!_ZU.isPerpendicularTo(vecYpart))
			{ 
				if (vecYpart.dotProduct(_ZU) < 0)vecYpart *= -1;
			}
//			else
//			{ 
//				// do nothing
//			}
		}
		else if(nZone==-1)
		{
			if(!_ZU.isPerpendicularTo(vecYpart))
			{ 
				if (vecYpart.dotProduct(_ZU) > 0)vecYpart *= -1;
			}
			else
			{ 
				vecYpart *= -1;
			}
		}
		
		if(el.bIsValid() && el1.bIsValid() && el==el1)
		{ 
			ElemZone eZone = el.zone(nZone);
			vecYpart = el.zone(nZone).vecZ();
		}
//		vecYpart.vis(_Pt0);
		// insertion point of the part
		Point3d ptInsertion = ptCen0 + vecYpart * .5 * bm0.dD(vecYpart);
	//	vector pointing toward female beam
		Vector3d vecX01 = vecX0;
		if (vecX01.dotProduct(ptCen1 - ptCen0) < 0)vecX01 *= -1;
		Vector3d vecZpart = vecX01;
		Vector3d vecXpart = vecYpart.crossProduct(vecZpart);
//		vecXpart.vis(_Pt0, 6);
//		vecYpart.vis(_Pt0,3);
//		vecZpart.vis(_Pt0, 4);
		
		ptInsertion += vecX01 * vecX01.dotProduct(bm1.ptCen() + .5 * vecX01 * bm1.dD(vecX01)-ptInsertion);
		Point3d ptInsertionMiddle=ptInsertion;
		Display dpPart(252);
		if(iSide==0 || iSide==2)
		{ 
			// left or both
			ptInsertion = ptInsertionMiddle + vecXpart * (.5 * bm0.dD(vecXpart) );
			Body bd = bdLeft;
			CoordSys csPart;
			csPart.setToAlignCoordSys(_Pt0, _XW, _YW, _ZW, ptInsertion, vecXpart, vecYpart, vecZpart);
			bd.transformBy(csPart);
			bd.vis(4);
			dpPart.draw(bd);
		}
		if(iSide==1 || iSide==2)
		{ 
			// right or both
			ptInsertion = ptInsertionMiddle - vecXpart * (.5 * bm0.dD(vecXpart) );
			Body bd = bdRight;
			CoordSys csPart;
			csPart.setToAlignCoordSys(_Pt0, _XW, _YW, _ZW, ptInsertion, vecXpart, vecYpart, vecZpart);
			bd.transformBy(csPart);
			bd.vis(4);
			dpPart.draw(bd);
		}
		ptInsertion.vis(3);
	}//next iZ

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
			Element elHW =bm0.element(); 
			// check if the parent entity is an element
			if (!elHW.bIsValid())	elHW = (Element)elHW;
			if (elHW.bIsValid()) 	sHWGroupName=elHW.elementGroup().name();
		// loose
			else
			{
				Group groups[] = _ThisInst.groups();
				if (groups.length()>0)	sHWGroupName=groups[0].name();
			}		
		}
		int iNrHardwareLeft, iNrHardwareRight;
		if (iZone == 0 || iZone == 1)
		{
			if(iSide==0 || iSide==2)
				iNrHardwareLeft = 1;
			if(iSide==1 || iSide==2)
				iNrHardwareRight = 1;
		}
		else if(iZone == 2)
		{ 
			if(iSide==0 || iSide==2)
				iNrHardwareLeft = 2;
			if(iSide==1 || iSide==2)
				iNrHardwareRight = 2;
		}
			
	// add main componnent
		// left
		if(iNrHardwareLeft>0)
		{ 
			HardWrComp hwc("SingleSided STUD TIES", iNrHardwareLeft); // the articleNumber and the quantity is mandatory
			
			hwc.setManufacturer("Vuetrade");
			
			hwc.setModel("VTSTLH");
	//		hwc.setName(sHWName);
	//		hwc.setDescription(sHWDescription);
			hwc.setMaterial("G300 Z275 Galvanised Steel");
	//		hwc.setNotes(sHWNotes);
			
			hwc.setGroup(sHWGroupName);
			hwc.setLinkedEntity(bm0);	
			hwc.setCategory(T("|Connector|"));
			hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
			
			hwc.setDScaleX(U(240));
			hwc.setDScaleY(U(60));
			hwc.setDScaleZ(U(32));
			
		// apppend component to the list of components
			hwcs.append(hwc);
		}
		// right
		if(iNrHardwareRight>0)
		{ 
			HardWrComp hwc("SingleSided STUD TIES", iNrHardwareRight); // the articleNumber and the quantity is mandatory
			
			hwc.setManufacturer("Vuetrade");
			
			hwc.setModel("VTSTRH");
	//		hwc.setName(sHWName);
	//		hwc.setDescription(sHWDescription);
			hwc.setMaterial("G300 Z275 Galvanised Steel");
	//		hwc.setNotes(sHWNotes);
			
			hwc.setGroup(sHWGroupName);
			hwc.setLinkedEntity(bm0);	
			hwc.setCategory(T("|Connector|"));
			hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
			
			hwc.setDScaleX(U(240));
			hwc.setDScaleY(U(60));
			hwc.setDScaleZ(U(32));
			
		// apppend component to the list of components
			hwcs.append(hwc);
		}
	
	// make sure the hardware is updated
		if (_bOnDbCreated)	setExecutionLoops(2);				
		_ThisInst.setHardWrComps(hwcs);	
		//endregion
}

// triggers for side and zone
// Trigger sideSwap//region
	String sTriggersideSwap = T("|Swap Side|");
	int iSide = sSides.find(sSide);
	if(iSide!=2)
		addRecalcTrigger(_kContextRoot, sTriggersideSwap );
	if (_bOnRecalc && _kExecuteKey==sTriggersideSwap)
	{
		if(iSide==0)
			sSide.set(sSides[1]);
		else
			sSide.set(sSides[0]);
		//
		setExecutionLoops(2);
		return;
	}//endregion	

		
// Trigger zoneSwap//region
	String sTriggerzoneSwap = T("|Swap Zone|");
	int iZone = sZones.find(sZone);
	if (iZone != 2)
		addRecalcTrigger(_kContextRoot, sTriggerzoneSwap );
	if (_bOnRecalc && _kExecuteKey==sTriggerzoneSwap)
	{
		if(iZone==0)		
			sZone.set(sZones[1]);
		else
			sZone.set(sZones[0]);
		//	
		setExecutionLoops(2);
		return;
	}//endregion	
		

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
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18650 standard display published for share and make" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="5/10/2023 1:13:11 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End