#Version 8
#BeginDescription
#Versions:
1.10 07.11.2022 HSB-16939: Support canceling tsl during insertion jig
HSB-8707: improve prompt in jig, symbol not outside the envelope
HSB-8707: support jig, multiple enhancements
HSB-5536: only one tsl possible for a particular distribution area of an element
HSB-5536: remove openings from all the sheets of the element 
HSB-5536: add property distribution area 
HSB-5536: prompt a click point for each distribution area and generate a TSL for each distribution area
HSB-5536: add display symbol in plan view
HSB-5536: guard if (iTypical < 0)
HSB-5536: working version

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 10
#KeyWords 
#BeginContents
/// <History>//region
/// #Versions:
// 1.10 07.11.2022 HSB-16939: Support canceling tsl during insertion jig Author: Marsel Nakuci
/// <version value="1.9" date="20jan21" author="marsel.nakuci@hsbcad.com"> HSB-8707: improve prompt in jig, symbol not outside the envelope </version>
/// <version value="1.8" date="19jan21" author="marsel.nakuci@hsbcad.com"> HSB-8707: support jig, multiple enhancements </version>
/// <version value="1.7" date="20.09.2019" author="marsel.nakuci@hsbcad.com"> HSB-5536: only one tsl possible for a particular distribution area of an element </version>
/// <version value="1.6" date="19.09.2019" author="marsel.nakuci@hsbcad.com"> HSB-5536: remove openings from all the sheets of the element </version>
/// <version value="1.5" date="19.09.2019" author="marsel.nakuci@hsbcad.com"> HSB-5536: add property distribution area </version>
/// <version value="1.4" date="18.09.2019" author="marsel.nakuci@hsbcad.com"> HSB-5536: prompt a click point for each distribution area and generate a TSL </version>
/// <version value="1.3" date="27.08.2019" author="marsel.nakuci@hsbcad.com"> add display symbol in plan view </version>
/// <version value="1.2" date="26.08.2019" author="marsel.nakuci@hsbcad.com"> guard if (iTypical < 0) </version>
/// <version value="1.1" date="26.08.2019" author="marsel.nakuci@hsbcad.com"> working version </version>
/// <version value="1.0" date="23.08.2019" author="marsel.nakuci@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select tsl, select properties or catalog entry and press OK, select element and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl redistributes sheets of a particular zone of an element
/// on insert one need to select the zone of the element, where the sheets will be redistributed
/// select also the distribution area. If distribution area is 0 then a prompt will show up for each
/// distribution are to click the point
/// if a distribution area > 0 is selected, then the prompt to click the point will only be for this
/// distribution area and the redistribution will be done for this area
/// The point clicked will indicate that at that position a sheet ends and a new one starts
/// </summary>

/// commands
// command to insert a G-connection
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbRedistributeSheets")) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|"))) TSLCONTENT
//endregion
	
	
//region constants
	U(1,"mm");	
	double dEps = U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick = "TslDoubleClick";
	int bDebug = _bOnDebug;
	// read a potential mapObject defined by hsbDebugController
	{ 
		MapObject mo("hsbTSLDev" , "hsbTSLDebugController");
		if (mo.bIsValid()) { Map m = mo.map(); for (int i = 0; i < m.length(); i++) if (m.getString(i) == scriptName()) { bDebug = true; break; }}
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());
	}
	String sDefault = T("|_Default|");
	String sLastInserted = T("|_LastInserted|");
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
//end constants//endregion
	
	
//region properties
	// indicates the number of zone where the sheets are distributed
	String sZoneName = T("|Zone|");
	int nZones[] ={ -5 ,- 4 ,- 3 ,- 2 ,- 1, 1, 2, 3, 4, 5};
//	String sZones[] ={ "MF-5", "MU-4", "MT-3", "MW-2", "MO-1","1","2","3","4","5"};
	String sZones[] ={ "Zone-5", "zOne-4", "zoNe-3", "zonE-2", "ZOne-1","1","2","3","4","5"};
	PropInt nZone(nIntIndex++, nZones, sZoneName, 5);// default zone 1
	nZone.setDescription(T("|Defines the Zone where the sheets are to be redestributed|"));
	nZone.setCategory(category);
	
	// indicates for which distribution area the distribution will be regenerated
	String sDistributionAreaName=T("|Distribution Range|");	
//	int nDistributionAreas[]={1,2,3};
	PropInt nDistributionArea(nIntIndex++, 0, sDistributionAreaName);
	nDistributionArea.setDescription(T("|Defines the Distribution Area|"));
	nDistributionArea.setCategory(category);
	nDistributionArea.setReadOnly(_kHidden);
//End properties//endregion 
	
	String strJigAction1 = "strJigAction1";
	if (_bOnJig && _kExecuteKey==strJigAction1) 
	{ 
		Point3d ptJig = _Map.getPoint3d("_PtJig");
		PlaneProfile ppSheet = _Map.getPlaneProfile("sheet");
		PlaneProfile ppAreasMap[0];
		for (int i=0;i<100;i++) 
		{ 
			if(_Map.hasPlaneProfile("pp"+i))
			{ 
				ppAreasMap.append(_Map.getPlaneProfile("pp"+i));
			}
			else
			{ 
				break;
			}
		}//next i
		if(ppAreasMap.length()==0)
		{ 
			eraseInstance();
			return;
		}
		Entity entEl = _Map.getEntity("element");
		Element el = (Element)entEl;
		Point3d ptOrg = el.ptOrg();
		Vector3d vecX = el.vecX();
		Vector3d vecY = el.vecY();
		Vector3d vecZ = el.vecZ();
		
		PlaneProfile ppAreasMapLarge[0];
		for (int i=0;i<ppAreasMap.length();i++) 
		{ 
			// get extents of profile
			LineSeg seg = ppAreasMap[i].extentInDir(vecX);
			double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
			double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
			PlaneProfile ppLarge(ppAreasMap[i].coordSys());
			PLine plLarge(vecZ);
			{ 
				plLarge.createRectangle(LineSeg(seg.ptMid() - .5 * dX * vecX - U(10e7) * vecY, seg.ptMid() + .5 * dX * vecX + U(10e7) * vecY), vecX, vecY);
				ppLarge.joinRing(plLarge, _kAdd);
				ppAreasMapLarge.append(ppLarge);
			}
		}//next i
		
		int iAreaSelected=-1;
		for (int i=0;i<ppAreasMap.length();i++) 
		{ 
			if(ppAreasMapLarge[i].pointInProfile(ptJig)==_kPointInProfile)
			{ 
				iAreaSelected = i;
				break;
			}
		}//next i
		int iZone = _Map.getInt("iZone");
		// if selected zone exists in the element
		ElemZone eZone = el.zone(iZone);
		if (eZone.dH() == 0 || abs(iZone) > 5)
		{
			// selected zone does not exist
			reportMessage("\n"+scriptName()+" "+T("|selected zone does not exist|"));
			eraseInstance();
			return;
		}
			
		Display dpJig(3);
		if(iAreaSelected>-1)
		{
			PlaneProfile pp = ppAreasMap[iAreaSelected];
			pp.intersectWith(ppSheet);
//			dpJig.draw(pp,_kDrawFilled, 95);
			dpJig.draw(pp);
			// draw from top
		}
		else
		{ 
			dpJig.color(1);
			for (int i=0;i<ppAreasMap.length();i++) 
			{ 
				PlaneProfile pp = ppAreasMap[i];
				pp.intersectWith(ppSheet);
//				dpJig.draw(pp,_kDrawFilled, 60);
				dpJig.draw(pp);
			}//next i
		}
//		
		if (iAreaSelected >- 1)
		{
			//region get planeprofile of all sheets, typical width and ppTypical
		 	// openings in the element
		 	Opening openings[] = el.opening();
		 	
		 	PlaneProfile ppAllOpenings[0];
		 	for (int i = 0; i < openings.length(); i++)
		 	{ 
		 		Opening op = openings[i];
		 		OpeningSF opSf = (OpeningSF)op;
		 		double dGapSide = opSf.dGapSide();
		 		double dGapTop = opSf.dGapTop();
		 		double dGapBottom = opSf.dGapBottom();
		 		
		 		PlaneProfile ppOpi(eZone.coordSys());
		 		PLine pl = op.plShape();
		 		ppOpi.joinRing(pl, _kAdd);
		 		
		 		LineSeg seg = ppOpi.extentInDir(vecX);
		 		seg.vis(2);
		 		Point3d pt1 = seg.ptStart();
		 		Point3d pt2 = seg.ptEnd();
		// 		pt1.vis(2);
		// 		pt2.vis(2);
		 		
		 		pt1 -= dGapSide * vecX;
		 		pt2 += dGapSide * vecX;
		 		
		 		if(pt1.dotProduct(vecY)<pt2.dotProduct(vecY))
		 		{ 
		 			pt1 -= dGapBottom * vecY;
		 			pt2 += dGapTop * vecY;
		 		}
		 		else
		 		{ 
		 			pt2 -= dGapBottom * vecY;
		 			pt1 += dGapTop * vecY;
		 		}
		 		 
		 		LineSeg segOp(pt1,pt2);
		 		PLine plOp;
		 		plOp.createRectangle(segOp, vecX, vecY);
		 		
		 		ppOpi.joinRing(plOp, _kAdd);
		 		ppAllOpenings.append(ppOpi);
		 		 
		 	}//next i
		 	
		 	for (int i=0;i<ppAllOpenings.length();i++) 
		 	{ 
		 		ppAllOpenings[i].vis(2); 
		 	}//next i
		 	
		 	// pp of all the sheets of the wall
		 	PlaneProfile ppAllSheets(eZone.coordSys());
		 	// pp of sheets of only this area 
		 	
		 	Sheet sheets[0];
		 	// Typical plane profile of a sheet without opening
		 	PlaneProfile ppTypical(eZone.coordSys());
		 	// Typical width of a sheet
		 	double dWidthTypical = - 10;
		 	// initialize ptMaxY, ptMinY
		 	// point on the left 
		 	Point3d ptTypicalLeft;
		 	// index of typical sheet
		 	int iTypical = -1;
		 	
			// all sheets of zone nZone
			sheets = el.sheet(nZone);
			if (sheets.length() == 0)
			{ 
				// when element is regenerated, the sheets are deleted
				// TSL will wait until the the element is calculated and sheets are generated
				return;
			}
			
		//	return;
			if (sheets.length() == 0)
			{ 
				// not sheets found for this zone
				reportMessage("\n"+scriptName()+" "+T("|no sheet found for zone|")+", "+ nZone);
				eraseInstance();
				return;
			}
			Point3d ptMaxY;
		 	Point3d ptMinY;
		 	{ 
		 		PLine pl0 = sheets[0].plEnvelope();
		 		PlaneProfile pp0(eZone.coordSys());
			 	pp0.joinRing(pl0, _kAdd);
			 	LineSeg seg = pp0.extentInDir(vecX);
			 	ptMaxY = seg.ptMid();
			 	ptMinY = seg.ptMid();
		 	}
			
		 	{ 
		 		// add all planeprofiles of each sheet into single one
		 		for (int i = 0; i < sheets.length(); i++)
		 		{ 
		// 			sheets[i].envelopeBody().vis(8);
		 			PLine pli = sheets[i].plEnvelope();
		 			ppAllSheets.joinRing(pli, _kAdd);
					// remove openings 
		 			PLine plOp[0];
					for (int o = 0; o < openings.length(); o++)
					{ 
		//				ppAllSheets.joinRing(openings[o].plShape(), _kSubtract); 
					}//next o
					
					// plane profile of sheets[i]
					PlaneProfile ppI(eZone.coordSys());
			 		ppI.joinRing(pli, _kAdd);
			 		
			 		// get extents of profile
		 			LineSeg seg = ppI.extentInDir(vecX);
		 			// get the typical envelope plane profile of a sheet without opening
			 		if (abs((seg.ptStart() - seg.ptEnd()).dotProduct(vecX)) > dWidthTypical)
			 		{ 
			 			dWidthTypical = abs((seg.ptStart() - seg.ptEnd()).dotProduct(vecX));
			 			ppTypical = ppI;
			 			ptTypicalLeft = seg.ptStart();
			 			if (seg.ptStart().dotProduct(vecX) > seg.ptEnd().dotProduct(vecX))
			 			{ 
			 				ptTypicalLeft = seg.ptEnd();
			 			}
			 			PLine pl;
						pl.createRectangle(seg, vecX, vecY);
						PlaneProfile ppTypical2(pl);
						ppTypical = ppTypical2;
			 			iTypical = i;
			 		}
			 		// get ptMaxY, ptMinY from all sheets
		 			{ 
				 		// get extents of profile for this sheet
						LineSeg seg = ppI.extentInDir(vecX);
					 	// get the ptMaxY, ptMinY from each sheet
				 		if (seg.ptStart().dotProduct(vecY) > ptMaxY.dotProduct(vecY))
				 		{ 
				 			ptMaxY = seg.ptStart();
				 		}
				 		if (seg.ptEnd().dotProduct(vecY) > ptMaxY.dotProduct(vecY))
				 		{ 
				 			ptMaxY = seg.ptEnd();
				 		}
				 		if (seg.ptStart().dotProduct(vecY) < ptMinY.dotProduct(vecY))
				 		{ 
				 			ptMinY = seg.ptStart();
				 		}
				 		if (seg.ptEnd().dotProduct(vecY) < ptMinY.dotProduct(vecY))
				 		{ 
				 			ptMinY = seg.ptEnd();
				 		}
			 		}
		 		}//next i
		 		
		 		{ 
		 			// get the ptMaxY, ptMinY from ppAllSheets
		 			LineSeg seg = ppAllSheets.extentInDir(vecX);
			 		if (seg.ptStart().dotProduct(vecY) > ptMaxY.dotProduct(vecY))
			 		{ 
			 			ptMaxY = seg.ptStart();
			 		}
			 		if (seg.ptEnd().dotProduct(vecY) > ptMaxY.dotProduct(vecY))
			 		{ 
			 			ptMaxY = seg.ptEnd();
			 		}
			 		if (seg.ptStart().dotProduct(vecY) < ptMinY.dotProduct(vecY))
			 		{ 
			 			ptMinY = seg.ptStart();
			 		}
			 		if (seg.ptEnd().dotProduct(vecY) < ptMinY.dotProduct(vecY))
			 		{ 
			 			ptMinY = seg.ptEnd();
			 		}
		 		}
		 	}
		 	//End get planeprofile of wall with oppening//endregion
		 
		  //region get ppAllSheetsThis and sheetsThis
	 	
		 	PlaneProfile ppAllSheetsThis(eZone.coordSys());
		 	PlaneProfile ppAreas[0];
		 	Sheet sheetsThis[0];
			{
				PLine plRings[] = ppAllSheets.allRings();
				int bIsOp[] = ppAllSheets.ringIsOpening();
				int iNrRings = 0;
				for (int i = 0; i < bIsOp.length(); i++)
				{
					if ( ! bIsOp[i])
					{
						// not an opening
						iNrRings++;
					}
				}//next i
				if (iNrRings == 0)
				{
					reportMessage("\n"+scriptName()+" "+T("|unexpected error|"));
					eraseInstance();
					return;
				}
				
				// gather all plane profiles
				for (int i = 0; i < bIsOp.length(); i++)
				{
		//			sheets.setLength(0);
		//			sheets.append(el.sheet(nZone));
					if (bIsOp[i])
					{
						// its an opening
						continue;
					}
					PlaneProfile ppThisArea(eZone.coordSys());
					ppThisArea.joinRing(plRings[i], _kAdd);
					ppAreas.append(ppThisArea);
				}
				nDistributionArea.set(iAreaSelected+1);
				if (nDistributionArea > ppAreas.length())
				{ 
					// distribution area does not exist
					eraseInstance();
					return;
				}
				// sort ppAreas
		 		// order alphabetically
				for (int i = 0; i < ppAreas.length(); i++)
				{ 
					for (int j = 0; j < ppAreas.length() - 1; j++)
					{ 
					// get extents of profile
						LineSeg segJ = ppAreas[j].extentInDir(vecX);
						LineSeg segJ1 = ppAreas[j + 1].extentInDir(vecX);
							
						if (segJ.ptMid().dotProduct(vecX) > segJ1.ptMid().dotProduct(vecX))
						{ 
							ppAreas.swap(j, j + 1);
						}
					}
				}
				
				int iAreaCounter = 0;
		//		for (int i = 0; i < bIsOp.length(); i++)
				{
		
					PlaneProfile ppThisArea(eZone.coordSys());
					ppThisArea = ppAreas[nDistributionArea - 1];
					
					for (int j = 0; j < sheets.length(); j++)
					{
						PLine plSheet = sheets[j].plEnvelope();
						PlaneProfile ppSheet(eZone.coordSys());
						ppSheet.joinRing(plSheet, _kAdd);
						
						if (ppSheet.intersectWith(ppThisArea))
						{
							sheetsThis.append(sheets[j]);
						}
					}//next j
				}
				// ppAllSheetsThis here has only the area of sheets without opening
		//		for (int i = 0; i < sheets.length(); i++)
		//		{
		//			PLine pli = sheets[i].plEnvelope();
		//			if (sheetsThis.find(sheets[i]) >- 1)
		//			{
		//				ppAllSheetsThis.joinRing(pli, _kAdd);
		//			}
		//		}
		//		double dArea0 = ppAllSheetsThis.area();
		//		double dArea1 = ppAreas[nDistributionArea - 1].area();
				
		//		if (abs(dArea0 - dArea1) > dEps)
		//		{ 
		//			reportMessage(TN("|unexpected area difference:| ")+abs(dArea0-dArea1));
		//			
		//		}
		
				// envelope planeprofile of this sheets
				ppAllSheetsThis = ppAreas[nDistributionArea - 1];
				// remove openings
				PLine plOp[0];
				for (int o = 0; o < openings.length(); o++)
				{
		//			ppAllSheetsThis.joinRing(openings[o].plShape(), _kSubtract);
				}//next o
			}
			 
			for (int i=0;i<sheetsThis.length();i++) 
			{ 
			 	sheetsThis[i].envelopeBody().vis(3); 
			}//next i
			 
		 //End get ppAllSheetsThis and sheetsThis//endregion 
		 
		 
		//region create a sheet that will serve as a typical sheet
			
			if (iTypical < 0)
			{ 
				// if element is recalculated it can be that tsl is triggered before the sheets
				// tsl is triggered again in the end when element is fully created with sheets
				return;
			}
			double dHmax;
			{ 
				LineSeg lSeg=ppTypical.extentInDir(vecX);
				Point3d pt1 = lSeg.ptStart();
				Point3d pt2 = lSeg.ptEnd();
				pt1 += (ptMinY - pt1).dotProduct(vecY) * vecY;
				pt2 += (ptMaxY - pt2).dotProduct(vecY) * vecY;
				LineSeg lSegMax(pt1, pt2);
				PLine pl;
				pl.createRectangle(lSegMax, vecX, vecY);
				PlaneProfile ppTypical2(pl);
				ppTypical = ppTypical2;
				dHmax = (pt2 - pt1).dotProduct(vecY);
			}
					
		//			reportMessage(TN("|hmax|")+dHmax);
			
//			Sheet shTypical = sheets[iTypical];
			// ppTypical is the envelope of the typical sheet
//			PLine plRings[] = ppTypical.allRings();
//			shTypical.joinRing(plRings[0], _kAdd);
		//	shTypical.envelopeBody().vis(5);
			
		//End create a sheet that will serve as a typical sheet//endregion 
		 
		 	//region draw points on left of every sheet
		 	// distributin points
		 	Point3d ptDistr[0];
	//	 	ptDistr.append(_Pt0);
		 	ptDistr.append(ptJig);
		 	//
		 	// get extents of profile
		//	LineSeg seg = ppAllSheets.extentInDir(vecX);
			LineSeg seg = ppAllSheetsThis.extentInDir(vecX);
			
			// extreme points of all sheets
			Point3d ptLeft = seg.ptStart();
			Point3d ptRight = seg.ptEnd();
			if (ptLeft.dotProduct(vecX) > ptRight.dotProduct(vecX))
			{ 
				ptLeft = seg.ptEnd();
				ptRight = seg.ptStart();
			}
		 	
		 	// points on the left of _Pt0
		 	int iContinue = true;
		 	int ii = 0;
		 	while (iContinue && ii < 1000)
		 	{ 
		 		ii++;
		 		Point3d pt = ptJig - ii * dWidthTypical * vecX;
		 		if ((ptLeft.dotProduct(vecX) - pt.dotProduct(vecX) > dWidthTypical ))
		 		{ 
		 			iContinue = false;
		 		}
		 		if(iContinue)
		 		{ 
		 			ptDistr.append(pt); 			
		 		}
		 	}
		 	
		 	// points on the right of Pt0
		 	iContinue = true;
		 	ii = 0;
		 	while (iContinue && ii < 1000)
		 	{ 
		 		ii++;
		 		Point3d pt = ptJig + ii * dWidthTypical * vecX;
		 		if (ptRight.dotProduct(vecX) < pt.dotProduct(vecX))
		 		{ 
		 			iContinue = false;
		 		}
		 		if(iContinue)
		 		{ 
		 			ptDistr.append(pt); 			
		 		}
		 	}
		 	
		 	// order points in direction of vecX
		 	Line ln(ptJig, vecX);
		 	ptDistr = ln.orderPoints(ptDistr);
		 	ptLeft.vis(2);
		 	ptRight.vis(2);
//		 	for (int i = 0; i < ptDistr.length(); i++)
//		 	{ 
//		 		ptDistr[i].vis(4); 
//		 		dpJig.draw("ptDistr", ptDistr[i], vecX,vecY,0,0, _kDeviceX);
//		 	}//next i
		 	
		 //End draw points on left of every sheet//endregion 
		 
		 	//region create sheets
		 	PLine plRings[] = ppAllSheets.allRings();
		 	// tells if it is an opening at the array of plRings
		 	int bIsOp[] = ppAllSheets.ringIsOpening();
		 	
		 	PLine plRingsThis[] = ppAllSheetsThis.allRings();
	 		int bIsOpThis[] = ppAllSheetsThis.ringIsOpening();
		 	
		 	PlaneProfile ppsNew[0];
		 	dpJig.color(5);
		 	for (int i = 0; i < ptDistr.length(); i++)
			{ 
				PlaneProfile ppNew=ppTypical;
				ppNew.transformBy((ptDistr[i] - ptTypicalLeft).dotProduct(vecX) * vecX);
		//		shNew.envelopeBody().vis(2);
				if(ppNew.area()>pow(dEps,2))
				{
					ppsNew.append(ppNew);
					
				}
			}//next i
			
			for (int i = 0; i < ppsNew.length(); i++)
			{ 
				ppsNew[i].intersectWith(ppAllSheets);
				ppsNew[i].intersectWith(ppAllSheetsThis);
			}
			// remove all openings of ppAllSheets
			
			for (int i = 0; i < ppsNew.length(); i++)
			{
				for (int j = 0; j < plRings.length(); j++)
				{ 
					if (bIsOp[j])
					{
						ppsNew[i].joinRing(plRings[j], _kSubtract);
					}
				}
			}
			for (int i = 0; i < ppsNew.length(); i++)
			{
				for (int j = 0; j < plRingsThis.length(); j++)
				{ 
					if (bIsOpThis[j])
					{
						ppsNew[i].joinRing(plRingsThis[j], _kSubtract);
					}
				}
			}
			
			// remove openings
			for (int i = 0; i < ppsNew.length(); i++)
			{ 
				for (int j = 0; j < openings.length(); j++)
				{ 
					ppsNew[i].joinRing(openings[j].plShape(), _kSubtract);
				}
			}
			dpJig.color(7);
			for (int i=0;i<ppsNew.length();i++) 
			{ 
				dpJig.transparency(0);
				dpJig.color(7);
				dpJig.draw(ppsNew[i]); 
				PlaneProfile ppTop(Plane(ptOrg, vecY));
				{ 
				// get extents of profile
					LineSeg seg = ppsNew[i].extentInDir(vecX);
					double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
					Point3d pt1 = seg.ptStart();
					pt1 += vecY * vecY.dotProduct(ptOrg - pt1);
					pt1 += vecZ * vecZ.dotProduct(eZone.ptOrg() - pt1);
					Point3d pt2 = seg.ptEnd();
					pt2 += vecY * vecY.dotProduct(ptOrg - pt2);
					pt2 += vecZ * vecZ.dotProduct(eZone.ptOrg()+eZone.dH()*eZone.vecZ() - pt2);
					LineSeg lSeg1(pt1, pt2);
					dpJig.draw(lSeg1);
//					dpJig.draw("pt", pt1, vecX, vecY, 0, 0, _kDeviceX);
//					dpJig.draw("pt", pt2, vecX, vecY, 0, 0, _kDeviceX);
					
					
					pt1 += vecZ * vecZ.dotProduct(eZone.ptOrg()+eZone.dH()*eZone.vecZ() - pt1);
					pt2 += vecZ * vecZ.dotProduct(eZone.ptOrg() - pt2);
					LineSeg lSeg2(pt1, pt2);
					dpJig.draw(lSeg2);
					PLine plTop(vecY);
					plTop.createRectangle(lSeg1, vecX, vecZ);
					ppTop.joinRing(plTop, _kAdd);
					Display dpJig2(i);
					dpJig.draw(ppTop);
					dpJig2.draw(ppTop, _kDrawFilled, 15);
				}
//				dpJig.color(2);
//				dpJig.transparency(99);
//				
//				dpJig.draw(ppsNew[i], _kDrawFilled, 98);
				 
			}//next i
		}
		
	// draw inserted TSLs
		{ 
			Map mapNews = _Map.getMap("mapNews");
			dpJig.color(6);
			dpJig.transparency(0);
			for (int i=0;i<mapNews.length();i++) 
			{ 
				Map map = mapNews.getMap(i);
				Point3d pt=map.getPoint3d("PtTsl");
				
				PLine plCirc0(vecZ);
				PLine plCirc1(vecZ);
				plCirc0.createCircle(pt,vecZ, U(50) );
				plCirc1.createCircle(pt,vecZ, U(45) );		
				PlaneProfile ppCirc(plCirc0);
				ppCirc.joinRing(plCirc1,_kSubtract);
				dpJig.draw(ppCirc,_kDrawFilled);
				dpJig.draw(ppCirc);
				PLine plCr(vecZ);
				plCr.addVertex(pt - (vecX + vecY) * U(2.5));
				plCr.addVertex(pt - (vecX - vecY) * U(60));
				plCr.addVertex(pt + (vecX + vecY) * U(2.5));
				plCr.addVertex(pt + (vecX - vecY) * U(60));
				plCr.close();	
				dpJig.draw(PlaneProfile(plCr),_kDrawFilled);
				dpJig.draw(PlaneProfile(plCr));
				CoordSys csRot;
				csRot.setToRotation(90,vecZ,pt);
				plCr.transformBy(csRot);
				dpJig.draw(PlaneProfile(plCr),_kDrawFilled);
				dpJig.draw(PlaneProfile(plCr));
				int iColor = 1;
				Display dpPlan(1);
				dpPlan.color(iColor);
				dpPlan.elemZone(el, nZone, 'I');
				
				dpPlan.addViewDirection(vecY);
				
				CoordSys csTrans;
				csTrans.setToAlignCoordSys(pt, vecX, vecY, vecZ, pt, vecX, - vecZ, vecY);
				plCr.transformBy(csTrans);
				dpPlan.draw(PlaneProfile(plCr),_kDrawFilled);
				dpPlan.draw(PlaneProfile(plCr));
				csRot.setToRotation(90,vecY,pt);
				plCr.transformBy(csRot);
				dpPlan.draw(PlaneProfile(plCr),_kDrawFilled);
				dpPlan.draw(PlaneProfile(plCr));
			}//next i
			
		}
		return
	}
	
// bOnInsert//region
	if (_bOnInsert)
	{
		if (insertCycleCount() > 1) { eraseInstance(); return; }
		
		// prompt selection of element where sheets will be redistributed
		Element el = getElement("Select the element");
		
		int nZonesValid[0];
		// get valid zones
		for (int iZ=0;iZ<nZones.length();iZ++) 
		{ 
			if(el.zone(nZones[iZ]).dH()>0)
			{ 
				// valid zone
				nZonesValid.append(nZones[iZ]);
			}
		}//next iZ
		if (nZonesValid.length() < 1)
		{ 
			// element has only zone 0
			reportMessage("\n"+scriptName()+" "+T("|Element has only zone 0|"));
			eraseInstance();
			return;
		}
		nZone = PropInt (0, nZonesValid, sZoneName);
		nDistributionArea.setReadOnly(_kHidden);
	// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();

		if (sKey.length() > 0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			for (int i = 0; i < sEntries.length(); i++)
				sEntries[i] = sEntries[i].makeUpper();
			if (sEntries.find(sKey) >- 1)
				setPropValuesFromCatalog(sKey);
			else
				setPropValuesFromCatalog(sLastInserted);
		}
		else
			showDialog();
		
		// investigate the element to prompt the point selection
		if ( ! el.bIsValid())
		{ 
			reportMessage("\n"+scriptName()+" "+T("|unexpected error|"));
			eraseInstance();
			return;
		}

//		// some validation
		{ 
			// existing element zones
		// if selected zone exists in the element
			ElemZone eZone = el.zone(nZone);
			if (eZone.dH() == 0 || abs(nZone) > 5)
			{
				// selected zone does not exist
				reportMessage("\n"+scriptName()+" "+T("|selected zone does not exist|"));
				eraseInstance();
				return;
			}
			Point3d ptOrg = el.ptOrg();
			Vector3d vecX = el.vecX();
			Vector3d vecY = el.vecY();
			Vector3d vecZ = el.vecZ();
			
			vecX.vis(ptOrg, 1);
			vecY.vis(ptOrg, 3);
			vecZ.vis(ptOrg, 150);
			
			// openings in the element
		 	Opening openings[] = el.opening();
		 	PlaneProfile ppAllSheets(eZone.coordSys());
		 	Sheet sheets[0];
		 	
			// all sheets of zone nZone
			sheets = el.sheet(nZone);
			if (sheets.length() == 0)
			{ 
				// on insert the element mus always be calculated
				// tsl should not be applied to en element that is not calculated
				// not sheets found for this zone
				reportMessage("\n"+scriptName()+" "+T("|no sheet found for zone|")+", "+ nZone);
				eraseInstance();
				return;
			}
			// 
			PlaneProfile ppSheet(eZone.coordSys());
			Plane pnZone(eZone.coordSys().ptOrg(), eZone.coordSys().vecZ());
			for (int i=0;i<sheets.length();i++) 
			{ 
				PlaneProfile ppI(pnZone);
				ppI.joinRing(sheets[i].plEnvelope(), _kAdd);
				ppI.shrink(-U(20));
				ppSheet.unionWith(ppI);
	//			ppSheet.joinRing(sheets[i].plEnvelope(), _kAdd);
			}//next i
			ppSheet.shrink(U(20));
			for (int i=0;i<sheets.length();i++) 
			{ 
				PLine plOp[] = sheets[i].plOpenings();
				for (int o = 0; o < plOp.length(); o++)
				{
					ppSheet.joinRing(plOp[o], _kSubtract);
				}
			}//next i
		 	{ 
		 		// add all planeprofiles of each sheet into single one
		 		for (int i = 0; i < sheets.length(); i++)
		 		{ 
		 			PLine pli = sheets[i].plEnvelope();
		 			ppAllSheets.joinRing(pli, _kAdd);
		 			// remove openings 
		 			PLine plOp[0];
		
					for (int o = 0; o < openings.length(); o++)
					{ 
						ppAllSheets.joinRing(openings[o].plShape(), _kSubtract); 
					}//next o
		 		}//next i
		 	}
			{ 
		 		// count all nonopening rings
		 		PLine plRings[] = ppAllSheets.allRings();
		 		int bIsOp[] = ppAllSheets.ringIsOpening();
		 		int iNrRings = 0;
		 		for (int i = 0; i < bIsOp.length(); i++)
		 		{ 
		 			if ( ! bIsOp[i])
		 			{ 
		 				// not an opening
		 				iNrRings++;
		 			}
		 		}//next i
		 		// 
		 		if (iNrRings == 0)
		 		{ 
		 			reportMessage("\n"+scriptName()+" "+T("|unexpected error|"));
		 			eraseInstance();
		 			return;
		 		}
		 		
		 		// collect all nonopening planeprofiles
		 		PlaneProfile ppAreas[0];
				for (int i = 0; i < bIsOp.length(); i++)
				{
					sheets.setLength(0);
					sheets.append(el.sheet(nZone));
					if (bIsOp[i])
					{
						// its an opening, not considered
						continue;
					}
					PlaneProfile ppThisArea(eZone.coordSys());
					ppThisArea.joinRing(plRings[i], _kAdd);
					ppAreas.append(ppThisArea);
				}
		 		 
		 		// sort ppAreas in the direction of vecX of the element
		 		// order alphabetically
	 			for (int i = 0; i < ppAreas.length(); i++)
 				{ 
 					for (int j = 0; j < ppAreas.length() - 1; j++)
 					{ 
 					// get extents of profile
						LineSeg segJ = ppAreas[j].extentInDir(vecX);
						LineSeg segJ1 = ppAreas[j + 1].extentInDir(vecX);
 							
 						if (segJ.ptMid().dotProduct(vecX) > segJ1.ptMid().dotProduct(vecX))
 						{ 
 							ppAreas.swap(j, j + 1);
 						}
 					}
 				}
 				PlaneProfile ppAreasLarge[0];
 				for (int i=0;i<ppAreas.length();i++) 
				{ 
					// get extents of profile
					LineSeg seg = ppAreas[i].extentInDir(vecX);
					double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
					double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
					PlaneProfile ppLarge(ppAreas[i].coordSys());
					PLine plLarge(vecZ);
					{ 
						plLarge.createRectangle(LineSeg(seg.ptMid() - .5 * dX * vecX - U(10e7) * vecY, seg.ptMid() + .5 * dX * vecX + U(10e7) * vecY), vecX, vecY);
						ppLarge.joinRing(plLarge, _kAdd);
						ppAreasLarge.append(ppLarge);
					}
				}//next i
				int iAreaSelected=-1;
				
 				// initialise
		 		int iAreaCounter = 0;
		 		Map mapArgs;
		 		String sStringStart = "|Select splitting point for the zone";
		 		String sStringOptions;
		 		int nZonesAll[] ={ -5 ,- 4 ,- 3 ,- 2 ,- 1, 1, 2, 3, 4, 5};
//		 		String sZonesAll[]{ "mFIve", }
		 		
		 		for (int iZ=0;iZ<nZonesValid.length();iZ++) 
		 		{ 
		 			if (nZonesValid[iZ]==nZone)continue;
//		 			sStringOptions += nZonesValid[iZ] + "/";
		 			sStringOptions += sZones[nZones.find(nZonesValid[iZ])] + "/";
		 		}//next iZ
			    sStringOptions.delete(sStringOptions.length() - 1, 1);
		 		
//		 		sStringOptions += "T/Z/";
		 		String sStringPrompt = T(sStringStart+" "+nZone+" ["+sStringOptions+"]|");
		 		Point3d ptLast = _Pt0;
		 		
		 		int iCount;
		 		int iContinue = true;
		 		
		 		for (int i=0;i<ppAreas.length();i++) 
		 		{ 
		 			mapArgs.setPlaneProfile("pp"+i, ppAreas[i]);
		 		}//next i
		 		mapArgs.setEntity("element", el);
		 		mapArgs.setInt("iZone", nZone);
		 		mapArgs.setPlaneProfile("sheet", ppSheet);
		 		// collect existing TSLs
//		 		TslInst tslExistings[0];
//		 		int nZoneExistings[0];
//		 		int nAreaExistings[0];
//		 		Point3d ptExistings[0];
//		 		TslInst tslAttached[] = el.tslInst();
//				for (int i = 0; i<tslAttached.length(); i++)
//				{
//					TslInst tsli = tslAttached[i];
//					if (!tsli.bIsValid())continue;
//					if (tsli.scriptName() != "hsbRedistributeSheets")continue;
//					if(tslExistings.find(tsli)<0)
//					{
//						tslExistings.append(tsli);
//						nZoneExistings.append(tsli.propInt(0));
//						nAreaExistings.append(tsli.propInt(1));
//						ptExistings.append(tsli.ptOrg());
//					}
//				}
				
				TslInst tslNews[0];
		 		while(iCount<100 && iContinue)
		 		{ 
			 		PrPoint ssP(sStringPrompt);
			 		int nGoJig = -1;
			 		
			 		while (nGoJig != _kOk && nGoJig!= _kNone)
			 		{ 
			 			nGoJig = ssP.goJig(strJigAction1, mapArgs); 
			 			if (nGoJig == _kOk)
				        {
				            ptLast = ssP.value(); //retrieve the selected point
				            _Map.setMap("mapJig", mapArgs );
				            for (int i=0;i<ppAreas.length();i++) 
							{ 
								if(ppAreasLarge[i].pointInProfile(ptLast)==_kPointInProfile)
								{ 
									iAreaSelected = i;
									break;
								}
							}//next i
				            // create tsl
				            if(iAreaSelected>-1)
				            { 
				           		TslInst tslNew;	Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
						 	 	GenBeam gbsTsl[] = {}; Entity entsTsl[] = {}; Point3d ptsTsl[] = {ptLast};
						 	 	int nProps[]={}; double dProps[]={}; String sProps[]={};
						 	 	Map mapTsl;
								nProps.append(nZone);
								nProps.append(iAreaSelected+1);
								ptsTsl[0] = ptLast;
								
								Map mapNew;
								String sZone = nZone;
								String sArea=iAreaSelected+1;
								String sMap = sZone + sArea;
								mapNew.setInt("Zone",nZone);
								mapNew.setInt("Area",iAreaSelected+1);
								mapNew.setPoint3d("Pt",ptLast);
								
								{ 
									Point3d ptTsl=ptLast;
									Point3d ptOrgZone = el.zone(nZone).ptOrg();
									ptTsl.transformBy((ptOrgZone-ptTsl).dotProduct(vecZ)*vecZ);
									Sheet sheets[]=el.sheet(nZone);
									PlaneProfile ppSheet(eZone.coordSys());
									Plane pnZone(eZone.coordSys().ptOrg(), eZone.coordSys().vecZ());
									for (int i=0;i<sheets.length();i++) 
									{ 
										PlaneProfile ppI(pnZone);
										ppI.joinRing(sheets[i].plEnvelope(), _kAdd);
										ppI.shrink(-U(20));
										ppSheet.unionWith(ppI);
									}//next i
									ppSheet.shrink(U(20));
									for (int i=0;i<sheets.length();i++) 
									{ 
										PLine plOp[] = sheets[i].plOpenings();
										for (int o = 0; o < plOp.length(); o++)
										{
											ppSheet.joinRing(plOp[o], _kSubtract);
										}
									}//next i
									PlaneProfile ppSheetOuter(ppSheet.coordSys());
									{ 
										PLine pls[] = ppSheet.allRings(true, false);
										for (int i=0;i<pls.length();i++) 
										{ 
											ppSheetOuter.joinRing(pls[i], _kAdd);
										}//next i
									}
									if(ppSheetOuter.pointInProfile(ptTsl)==_kPointOutsideProfile)
										ptTsl = ppSheet.closestPointTo(ptTsl);
									mapNew.setPoint3d("PtTsl",ptTsl);
								}
								Map mapNews = mapArgs.getMap("mapNews");
								mapNews.setMap(sMap, mapNew);
								mapArgs.setMap("mapNews",mapNews);
//							 	entsTsl.append(el);
//						 	 	tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, 
//						 	 		ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
						 	 	
						 	 	// after this TSL the el is modified with new sheets, update the array sheets
						 	 	sheets.setLength(0);
						 	 	sheets.append(el.sheet(nZone));
//						 	 	tslNews.append(tslNew);
				            }
				        }
				        else if (nGoJig == _kKeyWord)
				        { 
				        	// calc ppAreas
				        	for (int i=0;i<100;i++) 
				        	{ 
				        		if(mapArgs.hasPlaneProfile("pp"+i))
				        		{ 
				        			String sKey = "pp"+i;
				        			mapArgs.removeAt(sKey, true);
				        		}
				        		else
				        		{
				        			break;
				        		}
				        	}//next iZ
				        	// build available prompt 
				        	int nZonesThis[0];
				        	String sStringOptionsThis;
				        	for (int iZ=0;iZ<nZonesValid.length();iZ++) 
				        	{ 
				        		if (nZonesValid[iZ] == nZone)continue;
				        		nZonesThis.append(nZonesValid[iZ]);
	//			        		sStringOptionsThis+=nZonesValid[iZ] + "/";
				        		sStringOptionsThis += sZones[nZones.find(nZonesValid[iZ])] + "/";
				        	}//next iZ
				        	sStringOptionsThis.delete(sStringOptionsThis.length() - 1, 1);
//				        	reportMessage("\n"+ scriptName() + " nZonesThis "+nZonesThis);
//				        	reportMessage("\n"+ scriptName() + " ssP.keywordIndex() "+ssP.keywordIndex());
				        	
				        	int iZoneSelected = nZonesThis[ssP.keywordIndex()];
				        	mapArgs.setInt("iZone", iZoneSelected);
//				        	reportMessage("\n"+ scriptName() + " iZoneSelected "+iZoneSelected);
				        	
				        	nZone.set(nZonesValid[nZonesValid.find(iZoneSelected)]);
				        	int nZonesNew[0];
				        	String sStringOptionsNew;
				        	for (int iZ=0;iZ<nZonesValid.length();iZ++) 
				        	{ 
				        		if (nZonesValid[iZ] == iZoneSelected)continue;
				        		nZonesNew.append(nZonesValid[iZ]);
	//			        		sStringOptionsNew+=nZonesValid[iZ] + "/";
				        		sStringOptionsNew += sZones[nZones.find(nZonesValid[iZ])] + "/";
				        	}//next iZ
				        	sStringOptionsNew.delete(sStringOptionsNew.length() - 1, 1);
				        	sStringPrompt=T(sStringStart+" "+iZoneSelected+" ["+sStringOptionsNew+"]|");
//				        	ssP = PrPoint(sStringPrompt, ptLast);
				        	ssP = PrPoint(sStringPrompt);
				        	
				        	//
				        	ElemZone eZone = el.zone(iZoneSelected);
				        	PlaneProfile ppAllSheets(eZone.coordSys());
		 					Sheet sheets[] = el.sheet(iZoneSelected);
		 					PlaneProfile ppSheet(eZone.coordSys());
							Plane pnZone(eZone.coordSys().ptOrg(), eZone.coordSys().vecZ());
							for (int i=0;i<sheets.length();i++) 
							{ 
								PlaneProfile ppI(pnZone);
								ppI.joinRing(sheets[i].plEnvelope(), _kAdd);
								ppI.shrink(-U(20));
								ppSheet.unionWith(ppI);
					//			ppSheet.joinRing(sheets[i].plEnvelope(), _kAdd);
							}//next i
							ppSheet.shrink(U(20));
							for (int i=0;i<sheets.length();i++) 
							{ 
								PLine plOp[] = sheets[i].plOpenings();
								for (int o = 0; o < plOp.length(); o++)
								{
									ppSheet.joinRing(plOp[o], _kSubtract);
								}
							}//next i
		 					for (int i = 0; i < sheets.length(); i++)
					 		{ 
					 			PLine pli = sheets[i].plEnvelope();
					 			ppAllSheets.joinRing(pli, _kAdd);
					 			// remove openings 
					 			PLine plOp[0];
					
								for (int o = 0; o < openings.length(); o++)
								{ 
									ppAllSheets.joinRing(openings[o].plShape(), _kSubtract); 
								}//next o
					 		}//next i
		 					PLine plRings[] = ppAllSheets.allRings();
		 					int bIsOp[] = ppAllSheets.ringIsOpening();
				        	PlaneProfile ppAreas[0];
							for (int i = 0; i < bIsOp.length(); i++)
							{
								sheets.setLength(0);
								sheets.append(el.sheet(iZoneSelected));
								if (bIsOp[i])
								{
									// its an opening, not considered
									continue;
								}
								PlaneProfile ppThisArea(eZone.coordSys());
								ppThisArea.joinRing(plRings[i], _kAdd);
								ppAreas.append(ppThisArea);
							}
							// order alphabetically
				 			for (int i = 0; i < ppAreas.length(); i++)
			 				{ 
			 					for (int j = 0; j < ppAreas.length() - 1; j++)
			 					{ 
			 					// get extents of profile
									LineSeg segJ = ppAreas[j].extentInDir(vecX);
									LineSeg segJ1 = ppAreas[j + 1].extentInDir(vecX);
			 							
			 						if (segJ.ptMid().dotProduct(vecX) > segJ1.ptMid().dotProduct(vecX))
			 						{ 
			 							ppAreas.swap(j, j + 1);
			 						}
			 					}
			 				}
//			 				reportMessage("\n"+ scriptName() + " ppAreas.length()0"+ppAreas.length());
			 				
			 				for (int i=0;i<ppAreas.length();i++) 
					 		{ 
					 			mapArgs.setPlaneProfile("pp"+i, ppAreas[i]);
					 		}//next i
					 		mapArgs.setPlaneProfile("sheet", ppSheet);
				        }
				        else if (nGoJig == _kCancel)
				        { 
				        	reportMessage("\n"+ scriptName() + " canceled");
				        	
				        	// delete inserted TSLs, insert existings
//				        	for (int itsl=tslNews.length()-1; itsl>=0 ; itsl--) 
//				        	{ 
//				        		tslNews[itsl].dbErase();
//				        	}//next itsl
//				        	
//				        	TslInst tslNew;	Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
//					 	 	GenBeam gbsTsl[] = {};
//					 	 	Entity entsTsl[1]; Point3d ptsTsl[] = {ptLast};
//					 	 	int nProps[2]; double dProps[]={}; String sProps[]={};
//					 	 	Map mapTsl;
//					 	 	entsTsl[0]=el;
//							for (int itsl=0;itsl<nZoneExistings.length();itsl++)
//							{ 
//								nProps[0]=nZoneExistings[itsl];
//								nProps[1]=nAreaExistings[itsl];
//								ptsTsl[0]=ptExistings[itsl];
//								tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, 
//					 	 			ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
//							}//next itsl
							
				        	iContinue = false;
				            eraseInstance(); // do not insert this instance
				            return; 
				        }
				        else if(nGoJig==_kNone)
				        { 
				        // insert new TSLs
				        	Map mapNews = mapArgs.getMap("mapNews");
				        	TslInst tslNew;	Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
					 	 	GenBeam gbsTsl[] = {};
					 	 	Entity entsTsl[1]; Point3d ptsTsl[] = {ptLast};
					 	 	int nProps[2]; double dProps[]={}; String sProps[]={};
					 	 	Map mapTsl;
					 	 	entsTsl[0]=el;
							for (int itsl=0;itsl<mapNews.length();itsl++)
							{ 
								Map map = mapNews.getMap(itsl);
								nProps[0]=map.getInt("Zone");
								nProps[1]=map.getInt("Area");
								ptsTsl[0]=map.getPoint3d("PtTsl");
								tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, 
					 	 			ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
							}//next itsl
				        	iContinue = false;
				        	eraseInstance(); // do not insert this instance
				            return; 
				        }
			 		}
		 		}
		 	}
		}
		
		eraseInstance();
		return;
	}
// end on insert	__________________//endregion
	
	addRecalcTrigger(_kGripPointDrag, "_Pt0");
	if (_bOnGripPointDrag && (_kExecuteKey=="_Pt0"))
	{ 
		Element el = _Element[0];
		Point3d ptOrg = el.ptOrg();
		Vector3d vecX = el.vecX();
		Vector3d vecY = el.vecY();
		Vector3d vecZ = el.vecZ();
		PlaneProfile ppAreas[0];
		Sheet sheets[] = el.sheet(nZone);
		ElemZone eZone = el.zone(nZone);
		PlaneProfile ppSheet(eZone.coordSys());
		Plane pnZone(eZone.coordSys().ptOrg(), eZone.coordSys().vecZ());
		for (int i=0;i<sheets.length();i++) 
		{ 
			PlaneProfile ppI(pnZone);
			ppI.joinRing(sheets[i].plEnvelope(), _kAdd);
			ppI.shrink(-U(20));
			ppSheet.unionWith(ppI);
	//			ppSheet.joinRing(sheets[i].plEnvelope(), _kAdd);
		}//next i
		ppSheet.shrink(U(20));
		for (int i=0;i<sheets.length();i++) 
		{ 
			PLine plOp[] = sheets[i].plOpenings();
			for (int o = 0; o < plOp.length(); o++)
			{
				ppSheet.joinRing(plOp[o], _kSubtract);
			}
		}//next i
		PlaneProfile ppAllSheets(eZone.coordSys());
		for (int i = 0; i < sheets.length(); i++)
		{
			// 			sheets[i].envelopeBody().vis(8);
			PLine pli = sheets[i].plEnvelope();
			ppAllSheets.joinRing(pli, _kAdd);
		}
		PLine plRings[] = ppAllSheets.allRings();
		int bIsOp[] = ppAllSheets.ringIsOpening();
		
		for (int i = 0; i < bIsOp.length(); i++)
		{
//			sheets.setLength(0);
//			sheets.append(el.sheet(nZone));
			if (bIsOp[i])
			{
				// its an opening
				continue;
			}
			PlaneProfile ppThisArea(eZone.coordSys());
			ppThisArea.joinRing(plRings[i], _kAdd);
			ppAreas.append(ppThisArea);
		}
		for (int i = 0; i < ppAreas.length(); i++)
		{ 
			for (int j = 0; j < ppAreas.length() - 1; j++)
			{ 
			// get extents of profile
				LineSeg segJ = ppAreas[j].extentInDir(vecX);
				LineSeg segJ1 = ppAreas[j + 1].extentInDir(vecX);
					
				if (segJ.ptMid().dotProduct(vecX) > segJ1.ptMid().dotProduct(vecX))
				{ 
					ppAreas.swap(j, j + 1);
				}
			}
		}
		
		Point3d ptJig = _Pt0;
		int iAreaSelected = nDistributionArea-1;
		PlaneProfile pp = ppAreas[iAreaSelected];
		pp.intersectWith(ppSheet);
		Display dpJig(7);
		dpJig.draw(pp);
		
		Opening openings[] = el.opening();
	 	PlaneProfile ppAllOpenings[0];
	 	for (int i = 0; i < openings.length(); i++)
	 	{ 
	 		Opening op = openings[i];
	 		OpeningSF opSf = (OpeningSF)op;
	 		double dGapSide = opSf.dGapSide();
	 		double dGapTop = opSf.dGapTop();
	 		double dGapBottom = opSf.dGapBottom();
	 		
	 		PlaneProfile ppOpi(eZone.coordSys());
	 		PLine pl = op.plShape();
	 		ppOpi.joinRing(pl, _kAdd);
	 		
	 		LineSeg seg = ppOpi.extentInDir(vecX);
	 		seg.vis(2);
	 		Point3d pt1 = seg.ptStart();
	 		Point3d pt2 = seg.ptEnd();
	// 		pt1.vis(2);
	// 		pt2.vis(2);
	 		pt1 -= dGapSide * vecX;
	 		pt2 += dGapSide * vecX;
	 		
	 		if(pt1.dotProduct(vecY)<pt2.dotProduct(vecY))
	 		{ 
	 			pt1 -= dGapBottom * vecY;
	 			pt2 += dGapTop * vecY;
	 		}
	 		else
	 		{ 
	 			pt2 -= dGapBottom * vecY;
	 			pt1 += dGapTop * vecY;
	 		}
	 		 
	 		LineSeg segOp(pt1,pt2);
	 		PLine plOp;
	 		plOp.createRectangle(segOp, vecX, vecY);
	 		
	 		ppOpi.joinRing(plOp, _kAdd);
	 		ppAllOpenings.append(ppOpi);
	 		 
	 	}//next i
	 	
	 	for (int i=0;i<ppAllOpenings.length();i++) 
	 	{ 
	 		ppAllOpenings[i].vis(2); 
	 	}//next i
	 	
	 	// pp of all the sheets of the wall
//	 	PlaneProfile ppAllSheets(eZone.coordSys());
	 	// pp of sheets of only this area 
	 	
//	 	Sheet sheets[0];
	 	// Typical plane profile of a sheet without opening
	 	PlaneProfile ppTypical(eZone.coordSys());
	 	// Typical width of a sheet
	 	double dWidthTypical = - 10;
	 	// initialize ptMaxY, ptMinY
	 	
	 	// point on the left 
	 	Point3d ptTypicalLeft;
	 	// index of typical sheet
	 	int iTypical = -1;
	 	
		// all sheets of zone nZone
//		sheets = el.sheet(nZone);
//		if (sheets.length() == 0)
//		{ 
//			// when element is regenerated, the sheets are deleted
//			// TSL will wait until the the element is calculated and sheets are generated
//			return;
//		}
//		
//	//	return;
//		if (sheets.length() == 0)
//		{ 
//			// not sheets found for this zone
//			reportMessage(TN("|no sheet found for zone,| ") + nZone);
//			eraseInstance();
//			return;
//		}
		Point3d ptMaxY;
	 	Point3d ptMinY;
	 	{ 
	 		PLine pl0 = sheets[0].plEnvelope();
	 		PlaneProfile pp0(eZone.coordSys());
		 	pp0.joinRing(pl0, _kAdd);
		 	LineSeg seg = pp0.extentInDir(vecX);
		 	ptMaxY = seg.ptMid();
		 	ptMinY = seg.ptMid();
	 	}
		
	 	{ 
	 		// add all planeprofiles of each sheet into single one
	 		for (int i = 0; i < sheets.length(); i++)
	 		{ 
	// 			sheets[i].envelopeBody().vis(8);
	 			PLine pli = sheets[i].plEnvelope();
//	 			ppAllSheets.joinRing(pli, _kAdd);
//				// remove openings 
//	 			PLine plOp[0];
//				for (int o = 0; o < openings.length(); o++)
//				{ 
//	//				ppAllSheets.joinRing(openings[o].plShape(), _kSubtract); 
//				}//next o
				
				// plane profile of sheets[i]
				PlaneProfile ppI(eZone.coordSys());
		 		ppI.joinRing(pli, _kAdd);
		 		
		 		// get extents of profile
	 			LineSeg seg = ppI.extentInDir(vecX);
	 			// get the typical envelope plane profile of a sheet without opening
		 		if (abs((seg.ptStart() - seg.ptEnd()).dotProduct(vecX)) > dWidthTypical)
		 		{ 
		 			dWidthTypical = abs((seg.ptStart() - seg.ptEnd()).dotProduct(vecX));
		 			ppTypical = ppI;
		 			ptTypicalLeft = seg.ptStart();
		 			if (seg.ptStart().dotProduct(vecX) > seg.ptEnd().dotProduct(vecX))
		 			{ 
		 				ptTypicalLeft = seg.ptEnd();
		 			}
		 			PLine pl;
					pl.createRectangle(seg, vecX, vecY);
					PlaneProfile ppTypical2(pl);
					ppTypical = ppTypical2;
		 			iTypical = i;
		 		}
		 		// get ptMaxY, ptMinY from all sheets
	 			{ 
			 		// get extents of profile for this sheet
					LineSeg seg = ppI.extentInDir(vecX);
				 	// get the ptMaxY, ptMinY from each sheet
			 		if (seg.ptStart().dotProduct(vecY) > ptMaxY.dotProduct(vecY))
			 		{ 
			 			ptMaxY = seg.ptStart();
			 		}
			 		if (seg.ptEnd().dotProduct(vecY) > ptMaxY.dotProduct(vecY))
			 		{ 
			 			ptMaxY = seg.ptEnd();
			 		}
			 		if (seg.ptStart().dotProduct(vecY) < ptMinY.dotProduct(vecY))
			 		{ 
			 			ptMinY = seg.ptStart();
			 		}
			 		if (seg.ptEnd().dotProduct(vecY) < ptMinY.dotProduct(vecY))
			 		{ 
			 			ptMinY = seg.ptEnd();
			 		}
		 		}
	 		}//next i
	 		
	 		{ 
	 			// get the ptMaxY, ptMinY from ppAllSheets
	 			LineSeg seg = ppAllSheets.extentInDir(vecX);
		 		if (seg.ptStart().dotProduct(vecY) > ptMaxY.dotProduct(vecY))
		 		{ 
		 			ptMaxY = seg.ptStart();
		 		}
		 		if (seg.ptEnd().dotProduct(vecY) > ptMaxY.dotProduct(vecY))
		 		{ 
		 			ptMaxY = seg.ptEnd();
		 		}
		 		if (seg.ptStart().dotProduct(vecY) < ptMinY.dotProduct(vecY))
		 		{ 
		 			ptMinY = seg.ptStart();
		 		}
		 		if (seg.ptEnd().dotProduct(vecY) < ptMinY.dotProduct(vecY))
		 		{ 
		 			ptMinY = seg.ptEnd();
		 		}
	 		}
	 	}
	// 	ppAllSheets.vis(2);
		
	 	//End get planeprofile of wall with oppening//endregion
	 
	  //region get ppAllSheetsThis and sheetsThis
 	
	 	PlaneProfile ppAllSheetsThis(eZone.coordSys());
//	 	PlaneProfile ppAreas[0];
	 	Sheet sheetsThis[0];
		{
			PLine plRings[] = ppAllSheets.allRings();
			int bIsOp[] = ppAllSheets.ringIsOpening();
			int iNrRings = 0;
			for (int i = 0; i < bIsOp.length(); i++)
			{
				if ( ! bIsOp[i])
				{
					// not an opening
					iNrRings++;
				}
			}//next i
			if (iNrRings == 0)
			{
				reportMessage("\n"+scriptName()+" "+T("|unexpected error|"));
				eraseInstance();
				return;
			}
			
			// gather all plane profiles
//			for (int i = 0; i < bIsOp.length(); i++)
//			{
//	//			sheets.setLength(0);
//	//			sheets.append(el.sheet(nZone));
//				if (bIsOp[i])
//				{
//					// its an opening
//					continue;
//				}
//				PlaneProfile ppThisArea(eZone.coordSys());
//				ppThisArea.joinRing(plRings[i], _kAdd);
//				ppAreas.append(ppThisArea);
//			}
//			nDistributionArea.set(iAreaSelected+1);
//			if (nDistributionArea > ppAreas.length())
//			{ 
//				// distribution area does not exist
//				eraseInstance();
//				return;
//			}
			// sort ppAreas
	 		// order alphabetically
//			for (int i = 0; i < ppAreas.length(); i++)
//			{ 
//				for (int j = 0; j < ppAreas.length() - 1; j++)
//				{ 
//				// get extents of profile
//					LineSeg segJ = ppAreas[j].extentInDir(vecX);
//					LineSeg segJ1 = ppAreas[j + 1].extentInDir(vecX);
//						
//					if (segJ.ptMid().dotProduct(vecX) > segJ1.ptMid().dotProduct(vecX))
//					{ 
//						ppAreas.swap(j, j + 1);
//					}
//				}
//			}
			
			int iAreaCounter = 0;
	//		for (int i = 0; i < bIsOp.length(); i++)
			{
	
				PlaneProfile ppThisArea(eZone.coordSys());
				ppThisArea = ppAreas[nDistributionArea - 1];
				
				for (int j = 0; j < sheets.length(); j++)
				{
					PLine plSheet = sheets[j].plEnvelope();
					PlaneProfile ppSheet(eZone.coordSys());
					ppSheet.joinRing(plSheet, _kAdd);
					
					if (ppSheet.intersectWith(ppThisArea))
					{
						sheetsThis.append(sheets[j]);
					}
				}//next j
			}
			// ppAllSheetsThis here has only the area of sheets without opening
	//		for (int i = 0; i < sheets.length(); i++)
	//		{
	//			PLine pli = sheets[i].plEnvelope();
	//			if (sheetsThis.find(sheets[i]) >- 1)
	//			{
	//				ppAllSheetsThis.joinRing(pli, _kAdd);
	//			}
	//		}
	//		double dArea0 = ppAllSheetsThis.area();
	//		double dArea1 = ppAreas[nDistributionArea - 1].area();
			
	//		if (abs(dArea0 - dArea1) > dEps)
	//		{ 
	//			reportMessage(TN("|unexpected area difference:| ")+abs(dArea0-dArea1));
	//			
	//		}
	
			// envelope planeprofile of this sheets
			ppAllSheetsThis = ppAreas[nDistributionArea - 1];
			// remove openings
			PLine plOp[0];
			for (int o = 0; o < openings.length(); o++)
			{
	//			ppAllSheetsThis.joinRing(openings[o].plShape(), _kSubtract);
			}//next o
		}
		 
		for (int i=0;i<sheetsThis.length();i++) 
		{ 
		 	sheetsThis[i].envelopeBody().vis(3); 
		}//next i
		 
	 //End get ppAllSheetsThis and sheetsThis//endregion 
	 
	 
	//region create a sheet that will serve as a typical sheet
		
		if (iTypical < 0)
		{ 
			// if element is recalculated it can be that tsl is triggered before the sheets
			// tsl is triggered again in the end when element is fully created with sheets
			return;
		}
		double dHmax;
		{ 
			LineSeg lSeg=ppTypical.extentInDir(vecX);
			Point3d pt1 = lSeg.ptStart();
			Point3d pt2 = lSeg.ptEnd();
			pt1 += (ptMinY - pt1).dotProduct(vecY) * vecY;
			pt2 += (ptMaxY - pt2).dotProduct(vecY) * vecY;
			LineSeg lSegMax(pt1, pt2);
			PLine pl;
			pl.createRectangle(lSegMax, vecX, vecY);
			PlaneProfile ppTypical2(pl);
			ppTypical = ppTypical2;
			dHmax = (pt2 - pt1).dotProduct(vecY);
		}
				
	//			reportMessage(TN("|hmax|")+dHmax);
		
//			Sheet shTypical = sheets[iTypical];
		// ppTypical is the envelope of the typical sheet
//			PLine plRings[] = ppTypical.allRings();
//			shTypical.joinRing(plRings[0], _kAdd);
	//	shTypical.envelopeBody().vis(5);
		
	//End create a sheet that will serve as a typical sheet//endregion 
	 
	 	//region draw points on left of every sheet
	 	// distributin points
	 	Point3d ptDistr[0];
//	 	ptDistr.append(_Pt0);
	 	ptDistr.append(ptJig);
	 	//
	 	// get extents of profile
	//	LineSeg seg = ppAllSheets.extentInDir(vecX);
		LineSeg seg = ppAllSheetsThis.extentInDir(vecX);
		
		// extreme points of all sheets
		Point3d ptLeft = seg.ptStart();
		Point3d ptRight = seg.ptEnd();
		if (ptLeft.dotProduct(vecX) > ptRight.dotProduct(vecX))
		{ 
			ptLeft = seg.ptEnd();
			ptRight = seg.ptStart();
		}
	 	
	 	// points on the left of _Pt0
	 	int iContinue = true;
	 	int ii = 0;
	 	while (iContinue && ii < 1000)
	 	{ 
	 		ii++;
	 		Point3d pt = ptJig - ii * dWidthTypical * vecX;
	 		if ((ptLeft.dotProduct(vecX) - pt.dotProduct(vecX) > dWidthTypical ))
	 		{ 
	 			iContinue = false;
	 		}
	 		if(iContinue)
	 		{ 
	 			ptDistr.append(pt); 			
	 		}
	 	}
	 	
	 	// points on the right of Pt0
	 	iContinue = true;
	 	ii = 0;
	 	while (iContinue && ii < 1000)
	 	{ 
	 		ii++;
	 		Point3d pt = ptJig + ii * dWidthTypical * vecX;
	 		if (ptRight.dotProduct(vecX) < pt.dotProduct(vecX))
	 		{ 
	 			iContinue = false;
	 		}
	 		if(iContinue)
	 		{ 
	 			ptDistr.append(pt); 			
	 		}
	 	}
	 	
	 	// order points in direction of vecX
	 	Line ln(ptJig, vecX);
	 	ptDistr = ln.orderPoints(ptDistr);
	 	ptLeft.vis(2);
	 	ptRight.vis(2);
//		 	for (int i = 0; i < ptDistr.length(); i++)
//		 	{ 
//		 		ptDistr[i].vis(4); 
//		 		dpJig.draw("ptDistr", ptDistr[i], vecX,vecY,0,0, _kDeviceX);
//		 	}//next i
	 	
	 //End draw points on left of every sheet//endregion 
	 
	 	//region create sheets
//	 	PLine plRings[] = ppAllSheets.allRings();
	 	// tells if it is an opening at the array of plRings
//	 	int bIsOp[] = ppAllSheets.ringIsOpening();
	 	
	 	PLine plRingsThis[] = ppAllSheetsThis.allRings();
 		int bIsOpThis[] = ppAllSheetsThis.ringIsOpening();
	 	
	 	PlaneProfile ppsNew[0];
	 	dpJig.color(5);
	 	for (int i = 0; i < ptDistr.length(); i++)
		{ 
			PlaneProfile ppNew=ppTypical;
			ppNew.transformBy((ptDistr[i] - ptTypicalLeft).dotProduct(vecX) * vecX);
	//		shNew.envelopeBody().vis(2);
			if(ppNew.area()>pow(dEps,2))
			{
				ppsNew.append(ppNew);
				
			}
		}//next i
		
		for (int i = 0; i < ppsNew.length(); i++)
		{ 
			ppsNew[i].intersectWith(ppAllSheets);
			ppsNew[i].intersectWith(ppAllSheetsThis);
		}
		// remove all openings of ppAllSheets
		
		for (int i = 0; i < ppsNew.length(); i++)
		{
			for (int j = 0; j < plRings.length(); j++)
			{ 
				if (bIsOp[j])
				{
					ppsNew[i].joinRing(plRings[j], _kSubtract);
				}
			}
		}
		for (int i = 0; i < ppsNew.length(); i++)
		{
			for (int j = 0; j < plRingsThis.length(); j++)
			{ 
				if (bIsOpThis[j])
				{
					ppsNew[i].joinRing(plRingsThis[j], _kSubtract);
				}
			}
		}
		
		// remove openings
		for (int i = 0; i < ppsNew.length(); i++)
		{ 
			for (int j = 0; j < openings.length(); j++)
			{ 
				ppsNew[i].joinRing(openings[j].plShape(), _kSubtract);
			}
		}
		dpJig.color(7);
		for (int i=0;i<ppsNew.length();i++) 
		{ 
			dpJig.transparency(0);
			dpJig.color(7);
			dpJig.draw(ppsNew[i]); 
			PlaneProfile ppTop(Plane(ptOrg, vecY));
			{ 
			// get extents of profile
				LineSeg seg = ppsNew[i].extentInDir(vecX);
				double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
				Point3d pt1 = seg.ptStart();
				pt1 += vecY * vecY.dotProduct(ptOrg - pt1);
				pt1 += vecZ * vecZ.dotProduct(eZone.ptOrg() - pt1);
				Point3d pt2 = seg.ptEnd();
				pt2 += vecY * vecY.dotProduct(ptOrg - pt2);
				pt2 += vecZ * vecZ.dotProduct(eZone.ptOrg()+eZone.dH()*eZone.vecZ() - pt2);
				LineSeg lSeg1(pt1, pt2);
				dpJig.draw(lSeg1);
//					dpJig.draw("pt", pt1, vecX, vecY, 0, 0, _kDeviceX);
//					dpJig.draw("pt", pt2, vecX, vecY, 0, 0, _kDeviceX);
				
				
				pt1 += vecZ * vecZ.dotProduct(eZone.ptOrg()+eZone.dH()*eZone.vecZ() - pt1);
				pt2 += vecZ * vecZ.dotProduct(eZone.ptOrg() - pt2);
				LineSeg lSeg2(pt1, pt2);
				dpJig.draw(lSeg2);
				PLine plTop(vecY);
				plTop.createRectangle(lSeg1, vecX, vecZ);
				ppTop.joinRing(plTop, _kAdd);
				Display dpJig2(i);
				dpJig.draw(ppTop);
				dpJig2.draw(ppTop, _kDrawFilled, 15);
			}
		}//next i
		return;
	}
	
if(!_bOnJig)
{ 
	//region validation
//	reportMessage("\n"+ scriptName() + " enters calculation");
	if (_Element.length() < 1)
	{ 
		reportMessage("\n"+scriptName()+" "+T("|no element found|"));
		reportMessage("\n"+scriptName()+" "+T("|TSL is being deleted|"));
		eraseInstance();
		return;
	}
	Element el = _Element[0];
	int nZonesValid[0];
		// get valid zones
	for (int iZ=0;iZ<nZones.length();iZ++) 
	{ 
		if(el.zone(nZones[iZ]).dH()>0)
		{ 
			// valid zone
			nZonesValid.append(nZones[iZ]);
		}
	}//next iZ
	if (nZonesValid.length() < 1)
	{ 
		// element has only zone 0
		reportMessage("\n"+scriptName()+" "+T("|Element has only zone 0|"));
		eraseInstance();
		return;
	}
	int iSelected = nZonesValid.find(nZone);
	if(iSelected>-1)
	{ 
		nZone = PropInt (0, nZonesValid, sZoneName, iSelected);
	}
	else
	{ 
		nZone = PropInt (0, nZonesValid, sZoneName, 0);
	}
	nDistributionArea.setReadOnly(true);
	nDistributionArea.setReadOnly(_kHidden);
	
	if (nDistributionArea < 1)
	{ 
		// 
		reportMessage("\n"+scriptName()+" "+T("|distribution area must be a positiv integer number|"));
		nDistributionArea.set(1);
	}
//End validation//endregion
	
	
//region check validity of zone
// if selected zone exists in the element
	ElemZone eZone = el.zone(nZone);
	if (eZone.dH() == 0 || abs(nZone) > 5)
	{
		// selected zone does not exist
		reportMessage("\n"+scriptName()+" "+T("|selected zone does not exist|"));
		eraseInstance();
		return;
	}
//End check validity of zone//endregion

//region guard to not have multiple TSL for this area for this element
	TslInst tslAttached[] = el.tslInst();
	for (int i = 0; i < tslAttached.length(); i++)
	{ 
		TslInst tsli = tslAttached[i];
		String ss = tsli.scriptName();
		String sss = scriptName();
//		if (tsli.scriptName() != scriptName())
		if (tsli.scriptName() != "hsbRedistributeSheets")
		{ 
			continue;
		}
		if (tsli.propInt(1) != nDistributionArea || tsli.propInt(0) != nZone)
		{ 
			// other distribution area
			continue;
		}
		if (tsli == _ThisInst)
		{ 
			// is this tsl
			continue;
		}
		tsli.dbErase();
	}//next i
//End guard to not have multiple TSL for this area for this element//endregion 
	
	
//region element information
	Point3d ptOrg = el.ptOrg();
	Vector3d vecX = el.vecX();
	Vector3d vecY = el.vecY();
	Vector3d vecZ = el.vecZ();
	
	vecX.vis(ptOrg, 1);
	vecY.vis(ptOrg, 3);
	vecZ.vis(ptOrg, 150);
//End element information//endregion

//region move pt0 to plane of ptorg of eZone
	Point3d ptOrgZone = eZone.ptOrg();
	_Pt0.transformBy((ptOrgZone - _Pt0).dotProduct(vecZ) * vecZ);
 	
//End move pt0 to ptorg of eZone//endregion 
	Sheet sheets[0];
	// all sheets of zone nZone
	sheets = el.sheet(nZone);
	if (sheets.length() == 0)
	{ 
		// when element is regenerated, the sheets are deleted
		// TSL will wait until the the element is calculated and sheets are generated
		return;
	}
	
//	return;
	PlaneProfile ppSheet(eZone.coordSys());
	Plane pnZone(eZone.coordSys().ptOrg(), eZone.coordSys().vecZ());
	for (int i=0;i<sheets.length();i++) 
	{ 
		PlaneProfile ppI(pnZone);
		ppI.joinRing(sheets[i].plEnvelope(), _kAdd);
		ppI.shrink(-U(20));
		ppSheet.unionWith(ppI);
//			ppSheet.joinRing(sheets[i].plEnvelope(), _kAdd);
	}//next i
	ppSheet.shrink(U(20));
	for (int i=0;i<sheets.length();i++) 
	{ 
		PLine plOp[] = sheets[i].plOpenings();
		for (int o = 0; o < plOp.length(); o++)
		{
			ppSheet.joinRing(plOp[o], _kSubtract);
		}
	}//next i
	
	PlaneProfile ppSheetOuter(ppSheet.coordSys());
	{ 
		PLine pls[] = ppSheet.allRings(true, false);
		for (int i=0;i<pls.length();i++) 
		{ 
			ppSheetOuter.joinRing(pls[i], _kAdd);
		}//next i
	}
	if(ppSheetOuter.pointInProfile(_Pt0)==_kPointOutsideProfile)
		_Pt0 = ppSheet.closestPointTo(_Pt0);
 //region get planeprofile of all sheets, typical width and ppTypical
	 
 	// openings in the element
 	Opening openings[] = el.opening();
 	
 	PlaneProfile ppAllOpenings[0];
 	for (int i = 0; i < openings.length(); i++)
 	{ 
 		Opening op = openings[i];
 		OpeningSF opSf = (OpeningSF)op;
 		double dGapSide = opSf.dGapSide();
 		double dGapTop = opSf.dGapTop();
 		double dGapBottom = opSf.dGapBottom();
 		
 		PlaneProfile ppOpi(eZone.coordSys());
 		PLine pl = op.plShape();
 		ppOpi.joinRing(pl, _kAdd);
 		
 		LineSeg seg = ppOpi.extentInDir(vecX);
 		seg.vis(2);
 		Point3d pt1 = seg.ptStart();
 		Point3d pt2 = seg.ptEnd();
// 		pt1.vis(2);
// 		pt2.vis(2);
 		
 		pt1 -= dGapSide * vecX;
 		pt2 += dGapSide * vecX;
 		
 		if(pt1.dotProduct(vecY)<pt2.dotProduct(vecY))
 		{ 
 			pt1 -= dGapBottom * vecY;
 			pt2 += dGapTop * vecY;
 		}
 		else
 		{ 
 			pt2 -= dGapBottom * vecY;
 			pt1 += dGapTop * vecY;
 		}
 		 
 		LineSeg segOp(pt1,pt2);
 		PLine plOp;
 		plOp.createRectangle(segOp, vecX, vecY);
 		
 		ppOpi.joinRing(plOp, _kAdd);
 		ppAllOpenings.append(ppOpi);
 	}//next i
 	
 	for (int i=0;i<ppAllOpenings.length();i++) 
 	{ 
 		ppAllOpenings[i].vis(2); 
 	}//next i
 	
 	// pp of all the sheets of the wall
 	PlaneProfile ppAllSheets(eZone.coordSys());
 	// pp of sheets of only this area 
 	
 	// Typical plane profile of a sheet without opening
 	PlaneProfile ppTypical(eZone.coordSys());
 	// Typical width of a sheet
 	double dWidthTypical = - 10;
 	// initialize ptMaxY, ptMinY
 	
 	// point on the left 
 	Point3d ptTypicalLeft;
 	// index of typical sheet
 	int iTypical = -1;
	
	Point3d ptMaxY;
 	Point3d ptMinY;
 	{ 
 		PLine pl0 = sheets[0].plEnvelope();
 		PlaneProfile pp0(eZone.coordSys());
	 	pp0.joinRing(pl0, _kAdd);
	 	LineSeg seg = pp0.extentInDir(vecX);
	 	ptMaxY = seg.ptMid();
	 	ptMinY = seg.ptMid();
 	}
	
 	{ 
 		// add all planeprofiles of each sheet into single one
 		for (int i = 0; i < sheets.length(); i++)
 		{ 
// 			sheets[i].envelopeBody().vis(8);
 			PLine pli = sheets[i].plEnvelope();
 			ppAllSheets.joinRing(pli, _kAdd);
			// remove openings 
 			PLine plOp[0];
			for (int o = 0; o < openings.length(); o++)
			{ 
//				ppAllSheets.joinRing(openings[o].plShape(), _kSubtract); 
			}//next o
			
			// plane profile of sheets[i]
			PlaneProfile ppI(eZone.coordSys());
	 		ppI.joinRing(pli, _kAdd);
	 		
	 		// get extents of profile
 			LineSeg seg = ppI.extentInDir(vecX);
 			// get the typical envelope plane profile of a sheet without opening
	 		if (abs((seg.ptStart() - seg.ptEnd()).dotProduct(vecX)) > dWidthTypical)
	 		{ 
	 			dWidthTypical = abs((seg.ptStart() - seg.ptEnd()).dotProduct(vecX));
	 			ppTypical = ppI;
	 			ptTypicalLeft = seg.ptStart();
	 			if (seg.ptStart().dotProduct(vecX) > seg.ptEnd().dotProduct(vecX))
	 			{ 
	 				ptTypicalLeft = seg.ptEnd();
	 			}
	 			PLine pl;
				pl.createRectangle(seg, vecX, vecY);
				PlaneProfile ppTypical2(pl);
				ppTypical = ppTypical2;
	 			iTypical = i;
	 		}
	 		// get ptMaxY, ptMinY from all sheets
 			{ 
		 		// get extents of profile for this sheet
				LineSeg seg = ppI.extentInDir(vecX);
			 	// get the ptMaxY, ptMinY from each sheet
		 		if (seg.ptStart().dotProduct(vecY) > ptMaxY.dotProduct(vecY))
		 		{ 
		 			ptMaxY = seg.ptStart();
		 		}
		 		if (seg.ptEnd().dotProduct(vecY) > ptMaxY.dotProduct(vecY))
		 		{ 
		 			ptMaxY = seg.ptEnd();
		 		}
		 		if (seg.ptStart().dotProduct(vecY) < ptMinY.dotProduct(vecY))
		 		{ 
		 			ptMinY = seg.ptStart();
		 		}
		 		if (seg.ptEnd().dotProduct(vecY) < ptMinY.dotProduct(vecY))
		 		{ 
		 			ptMinY = seg.ptEnd();
		 		}
	 		}
 		}//next i
 		
 		{ 
 			// get the ptMaxY, ptMinY from ppAllSheets
 			LineSeg seg = ppAllSheets.extentInDir(vecX);
	 		if (seg.ptStart().dotProduct(vecY) > ptMaxY.dotProduct(vecY))
	 		{ 
	 			ptMaxY = seg.ptStart();
	 		}
	 		if (seg.ptEnd().dotProduct(vecY) > ptMaxY.dotProduct(vecY))
	 		{ 
	 			ptMaxY = seg.ptEnd();
	 		}
	 		if (seg.ptStart().dotProduct(vecY) < ptMinY.dotProduct(vecY))
	 		{ 
	 			ptMinY = seg.ptStart();
	 		}
	 		if (seg.ptEnd().dotProduct(vecY) < ptMinY.dotProduct(vecY))
	 		{ 
	 			ptMinY = seg.ptEnd();
	 		}
 		}
 	}
// 	ppAllSheets.vis(2);
	
 //End get planeprofile of wall with oppening//endregion
 
 //region get ppAllSheetsThis and sheetsThis
 	
 	PlaneProfile ppAllSheetsThis(eZone.coordSys());
 	PlaneProfile ppAreas[0];
 	Sheet sheetsThis[0];
	{
		PLine plRings[] = ppAllSheets.allRings();
		int bIsOp[] = ppAllSheets.ringIsOpening();
		int iNrRings = 0;
		for (int i = 0; i < bIsOp.length(); i++)
		{
			if ( ! bIsOp[i])
			{
				// not an opening
				iNrRings++;
			}
		}//next i
		if (iNrRings == 0)
		{
			reportMessage("\n"+scriptName()+" "+T("|unexpected error|"));
			eraseInstance();
			return;
		}
		
		// gather all plane profiles
		for (int i = 0; i < bIsOp.length(); i++)
		{
//			sheets.setLength(0);
//			sheets.append(el.sheet(nZone));
			if (bIsOp[i])
			{
				// its an opening
				continue;
			}
			PlaneProfile ppThisArea(eZone.coordSys());
			ppThisArea.joinRing(plRings[i], _kAdd);
			ppAreas.append(ppThisArea);
		}
		
		if (nDistributionArea > ppAreas.length())
		{ 
			// distribution area does not exist
			eraseInstance();
			return;
		}
		// sort ppAreas
 		// order alphabetically
		for (int i = 0; i < ppAreas.length(); i++)
		{ 
			for (int j = 0; j < ppAreas.length() - 1; j++)
			{ 
			// get extents of profile
				LineSeg segJ = ppAreas[j].extentInDir(vecX);
				LineSeg segJ1 = ppAreas[j + 1].extentInDir(vecX);
					
				if (segJ.ptMid().dotProduct(vecX) > segJ1.ptMid().dotProduct(vecX))
				{ 
					ppAreas.swap(j, j + 1);
				}
			}
		}
		
		int iAreaCounter = 0;
//		for (int i = 0; i < bIsOp.length(); i++)
		{
			PlaneProfile ppThisArea(eZone.coordSys());
			ppThisArea = ppAreas[nDistributionArea - 1];
			
			for (int j = 0; j < sheets.length(); j++)
			{
				PLine plSheet = sheets[j].plEnvelope();
				PlaneProfile ppSheet(eZone.coordSys());
				ppSheet.joinRing(plSheet, _kAdd);
				
				if (ppSheet.intersectWith(ppThisArea))
				{
					sheetsThis.append(sheets[j]);
				}
			}//next j
		}
		// ppAllSheetsThis here has only the area of sheets without opening
//		for (int i = 0; i < sheets.length(); i++)
//		{
//			PLine pli = sheets[i].plEnvelope();
//			if (sheetsThis.find(sheets[i]) >- 1)
//			{
//				ppAllSheetsThis.joinRing(pli, _kAdd);
//			}
//		}
//		double dArea0 = ppAllSheetsThis.area();
//		double dArea1 = ppAreas[nDistributionArea - 1].area();
		
//		if (abs(dArea0 - dArea1) > dEps)
//		{ 
//			reportMessage(TN("|unexpected area difference:| ")+abs(dArea0-dArea1));
//			
//		}

		// envelope planeprofile of this sheets
		ppAllSheetsThis = ppAreas[nDistributionArea - 1];
		// remove openings
		PLine plOp[0];
		for (int o = 0; o < openings.length(); o++)
		{
//			ppAllSheetsThis.joinRing(openings[o].plShape(), _kSubtract);
		}//next o
	}
	
	for (int i=0;i<sheetsThis.length();i++) 
	{ 
		sheetsThis[i].envelopeBody().vis(3); 
	}//next i
	 
 //End get ppAllSheetsThis and sheetsThis//endregion 
 
 
//region create a sheet that will serve as a typical sheet
	
	if (iTypical < 0)
	{ 
		// if element is recalculated it can be that tsl is triggered before the sheets
		// tsl is triggered again in the end when element is fully created with sheets
		return;
	}
	
	double dHmax;
	{ 
		LineSeg lSeg=ppTypical.extentInDir(vecX);
		Point3d pt1 = lSeg.ptStart();
		Point3d pt2 = lSeg.ptEnd();
		pt1 += (ptMinY - pt1).dotProduct(vecY) * vecY;
		pt2 += (ptMaxY - pt2).dotProduct(vecY) * vecY;
		LineSeg lSegMax(pt1, pt2);
		PLine pl;
		pl.createRectangle(lSegMax, vecX, vecY);
		PlaneProfile ppTypical2(pl);
		ppTypical = ppTypical2;
		dHmax = (pt2 - pt1).dotProduct(vecY);
	}
			
//			reportMessage(TN("|hmax|")+dHmax);
	Sheet shTypical = sheets[iTypical];
	// ppTypical is the envelope of the typical sheet
	PLine plRings[] = ppTypical.allRings();
	shTypical.joinRing(plRings[0], _kAdd);
//	shTypical.envelopeBody().vis(5);
//End create a sheet that will serve as a typical sheet//endregion 
	 
	 
 //region draw points on left of every sheet
 	// distributin points
 	Point3d ptDistr[0];
 	ptDistr.append(_Pt0);
 	//
 	// get extents of profile
//	LineSeg seg = ppAllSheets.extentInDir(vecX);
	LineSeg seg = ppAllSheetsThis.extentInDir(vecX);
	
	// extreme points of all sheets
	Point3d ptLeft = seg.ptStart();
	Point3d ptRight = seg.ptEnd();
	if (ptLeft.dotProduct(vecX) > ptRight.dotProduct(vecX))
	{ 
		ptLeft = seg.ptEnd();
		ptRight = seg.ptStart();
	}
 	
 	// points on the left of _Pt0
 	int iContinue = true;
 	int ii = 0;
 	while (iContinue && ii < 1000)
 	{ 
 		ii++;
 		Point3d pt = _Pt0 - ii * dWidthTypical * vecX;
 		if ((ptLeft.dotProduct(vecX) - pt.dotProduct(vecX) > dWidthTypical ))
 		{ 
 			iContinue = false;
 		}
 		if(iContinue)
 		{ 
 			ptDistr.append(pt); 			
 		}
 	}
 	
 	// points on the right of Pt0
 	iContinue = true;
 	ii = 0;
 	while (iContinue && ii < 1000)
 	{ 
 		ii++;
 		Point3d pt = _Pt0 + ii * dWidthTypical * vecX;
 		if (ptRight.dotProduct(vecX) < pt.dotProduct(vecX))
 		{ 
 			iContinue = false;
 		}
 		if(iContinue)
 		{ 
 			ptDistr.append(pt); 			
 		}
 	}
 	
 	// order points in direction of vecX
 	Line ln(_Pt0, vecX);
 	ptDistr = ln.orderPoints(ptDistr);
 	ptLeft.vis(2);
 	ptRight.vis(2);
 	for (int i = 0; i < ptDistr.length(); i++)
 	{ 
 		ptDistr[i].vis(4); 
 	}//next i
 	
 //End draw points on left of every sheet//endregion 
// shTypical.envelopeBody().vis(2);
// ptTypicalLeft.vis(2);
//reportMessage(TN("|ptLeft.X():| ")+ptLeft.X());

	ppAllSheetsThis.vis(3);
//	return;
//region create sheets
	plRings = ppAllSheets.allRings();
 	// tells if it is an opening at the array of plRings
 	int bIsOp[] = ppAllSheets.ringIsOpening();
 	
// 	PLine plRingsThis[] = ppAreas[iAreaNr - 1].allRings();
 		
 	PLine plRingsThis[] = ppAllSheetsThis.allRings();
 	int bIsOpThis[] = ppAllSheetsThis.ringIsOpening();
// 	int bIsOpThis[] = ppAreas[iAreaNr - 1].ringIsOpening();
 	
 	// draw sheets as full 
	Sheet sheetsNew[0];
	for (int i = 0; i < ptDistr.length(); i++)
	{ 
		Sheet shNew;
		shNew = shTypical.dbCopy();
		shNew.transformBy((ptDistr[i] - ptTypicalLeft).dotProduct(vecX) * vecX);
//		shNew.envelopeBody().vis(2);
		
		if (shNew.bIsValid())
 		{ 
			sheetsNew.append(shNew);
 		}
	}//next i
	
	// remove all openings of ppAllSheets
	Sheet sheetsNew2[0];
	for (int i=0;i<sheetsNew.length();i++) 
	{ 
		// add/subtract the ppAllSheets
 		for (int j = 0; j < plRings.length(); j++)
 		{ 
 			 if (bIsOp[j])
 			 { 
 			 	// subtract opening
 			 	Sheet sheetsMod[] = sheetsNew[i].joinRing(plRings[j], _kSubtract);
 			 	// append to sheetsNew2
 			 	for (int k = 0; k < sheetsMod.length(); k++)
 			 	{ 
 			 		if (sheetsNew2.find(sheetsMod[k]) < 0)
 			 		{ 
 			 			// not found, append it
 			 			sheetsNew2.append(sheetsMod[k]);
 			 		}
 			 	}//next k
 			 }
 		}//next j
	}//next i
// 		PLine plRingsThis[] = ppAllSheetsThis.allRings();
 	
// 	reportMessage(TN("|sheetsNew2.length()|") + sheetsNew2.length());
 	
 	for (int i=0;i<sheetsNew2.length();i++) 
 	{ 
 		if (sheetsNew.find(sheetsNew2[i]) < 0)
 		{ 
 			sheetsNew.append(sheetsNew2[i]);
 		}
 	}//next i
 	
 	// remove all openings of ppAllSheetsThis
 	sheetsNew2.setLength(0);
 	for (int i = 0; i < sheetsNew.length(); i++)
 	{ 
 		for (int j = 0; j < plRingsThis.length(); j++)
 		{ 
 			if (bIsOpThis[j])
 			{ 
 				// subtract opening
// 			 	shNew.joinRing(plRingsThis[j], _kSubtract);
 			 	Sheet sheetsMod[] = sheetsNew[i].joinRing(plRingsThis[j], _kSubtract);
 			 	// append to sheetsNew2
 			 	for (int k = 0; k < sheetsMod.length(); k++)
 			 	{ 
 			 		if (sheetsNew2.find(sheetsMod[k]) < 0)
 			 		{ 
 			 			// not found, append it
 			 			sheetsNew2.append(sheetsMod[k]);
 			 		}
 			 	}//next k
 			}
 			else
 			{ 
// 				shNew.envelopeBody().vis(3);
 			 	// intersect with the outer plane profile
 			 	// outer profile
 			 	PlaneProfile pp1(eZone.coordSys());
 			 	pp1.joinRing(plRingsThis[j], _kAdd);
 			 	// sheet profile
 			 	PlaneProfile ppSheet(eZone.coordSys());
 			 	PLine plSheet;
// 			 	shNew.envelopeBody().vis(10);
// 			 	plSheet = shNew.plEnvelope();
 			 	plSheet = sheetsNew[i].plEnvelope();
 			 	ppSheet.joinRing(plSheet, _kAdd);
 			 	// intersect with typical plane profile
 			 	pp1.intersectWith(ppSheet);
 			 	
 			 	PlaneProfile ppSubtract = ppSheet;
 			 	ppSubtract.subtractProfile(pp1);
 			 	double dArea00 = ppSubtract.area();
 			 	
 			 	if (ppSubtract.area() < pow(dEps, 2))
 			 	{ 
 			 		continue;
 			 	}
// 			 	ppSheet.vis(8);
// 			 	pp1.vis(6);
 			 	PLine plRingsSh[0];
 			 	plRingsSh = ppSubtract.allRings();
 			 	double dArea0 = plRingsSh[0].area();
 			 	
 			 	for (int k = 0; k < plRingsSh.length(); k++)
 			 	{ 
// 			 		shNew.joinRing(plRingsSh[k], _kSubtract); 
 			 		Sheet sheetsMod[] = sheetsNew[i].joinRing(plRingsSh[k], _kSubtract);
 			 		for (int l = 0; l < sheetsMod.length(); l++)
	 			 	{ 
	 			 		if (sheetsNew2.find(sheetsMod[l]) < 0)
	 			 		{ 
	 			 			// not found, append it
	 			 			sheetsNew2.append(sheetsMod[l]);
	 			 		}
	 			 	}//next k
 			 	}//next k
 			}
 		}//next j
	}//next i
	
	for (int i=0;i<sheetsNew2.length();i++) 
 	{ 
 		if (sheetsNew.find(sheetsNew2[i]) < 0)
 		{ 
 			sheetsNew.append(sheetsNew2[i]);
 		}
 	}//next i
	
	// remove openings
	sheetsNew2.setLength(0);
	for (int i = 0; i < sheetsNew.length(); i++)
	{ 
		for (int j = 0; j < openings.length(); j++)
		{ 
			// subtract opening
			Sheet sheetsMod[] = sheetsNew[i].joinRing(openings[j].plShape(), _kSubtract);
			for (int l = 0; l < sheetsMod.length(); l++)
		 	{ 
		 		if (sheetsNew2.find(sheetsMod[l]) < 0)
		 		{ 
		 			// not found, append it
		 			sheetsNew2.append(sheetsMod[l]);
		 		}
		 	}//next k
		}//next j
	}//n
	
	for (int i=0;i<sheetsNew2.length();i++) 
 	{ 
 		if (sheetsNew.find(sheetsNew2[i]) < 0)
 		{ 
 			sheetsNew.append(sheetsNew2[i]);
 		}
 	}//next i

//End create sheets//endregion 
	
	
//region modify for all the sheets
	
	sheetsNew2.setLength(0);
	Sheet sheetsLast[] = el.sheet();
	
	for (int i = 0; i < sheetsLast.length(); i++)
	{ 
		for (int j = 0; j < openings.length(); j++)
		{ 
			// subtract opening
			Sheet sheetsMod[] = sheetsLast[i].joinRing(openings[j].plShape(), _kSubtract);
			for (int l = 0; l < sheetsMod.length(); l++)
		 	{ 
		 		if (sheetsNew2.find(sheetsMod[l]) < 0)
		 		{ 
		 			// not found, append it
		 			sheetsNew2.append(sheetsMod[l]);
		 		}
		 	}//next k
		}//next j
	}//n
	
	for (int i=0;i<sheetsNew2.length();i++) 
 	{ 
 		if (sheetsNew.find(sheetsNew2[i]) < 0)
 		{ 
 			sheetsNew.append(sheetsNew2[i]);
 		}
 	}//next i
	
	sheetsNew2.setLength(0);
	Sheet _sheetsLast[] = el.sheet();
	
	for (int i = 0; i < _sheetsLast.length(); i++)
	{ 
		for (int j = 0; j < ppAllOpenings.length(); j++)
		{ 
			// subtract opening
			PLine pl[] = ppAllOpenings[j].allRings();
			Sheet sheetsMod[] = _sheetsLast[i].joinRing(pl[0], _kSubtract);
			for (int l = 0; l < sheetsMod.length(); l++)
		 	{ 
		 		if (sheetsNew2.find(sheetsMod[l]) < 0)
		 		{ 
		 			// not found, append it
		 			sheetsNew2.append(sheetsMod[l]);
		 		}
		 	}//next k
		}//next j
	}//n
	
	
	for (int i=0;i<sheetsNew2.length();i++) 
 	{ 
 		if (sheetsNew.find(sheetsNew2[i]) < 0)
 		{ 
 			sheetsNew.append(sheetsNew2[i]);
 		}
 	}//next i
 	
 	for (int i = 0; i < sheetsNew.length(); i++)
	{ 
		sheetsNew[i].envelopeBody().vis(7); 
		sheetsNew[i].assignToElementGroup(el,true, nZone, 'E');
	}//next i
	
 	
 	for (int i = 0; i < openings.length(); i++)
	{
		openings[i].plShape().vis(3);
	}

//End modify for all the sheets//endregion 
	
	
	for (int i=sheets.length()-1; i>=0 ; i--) 
	{ 
		if (sheetsThis.find(sheets[i]) >- 1)
		{ 
			// delete
			Sheet sh = sheets[i];
			sheets.removeAt(i);
			sh.dbErase();
		} 
	}//next i
	
//region TSL Display
	// draw circle
	int iColor;
	if(sheets.length()>0)
		iColor= sheets[0].color();
	else if(sheetsThis.length()>0)
		iColor= sheetsThis[0].color();
	Display dp(1);
	dp.elemZone(el, nZone, 'I');
	dp.color(iColor);
	PLine plCirc0(vecZ);
	PLine plCirc1(vecZ);
	plCirc0.createCircle(_Pt0,vecZ, U(50) );
	plCirc1.createCircle(_Pt0,vecZ, U(45) );		
	PlaneProfile ppCirc(plCirc0);
	ppCirc.joinRing(plCirc1,_kSubtract);
	dp.draw(ppCirc,_kDrawFilled);
	
	// add the X sign
	// first leg
	PLine plCr(vecZ);
	plCr.addVertex(_Pt0 - (vecX + vecY) * U(2.5));
	plCr.addVertex(_Pt0 - (vecX - vecY) * U(60));
	plCr.addVertex(_Pt0 + (vecX + vecY) * U(2.5));
	plCr.addVertex(_Pt0 + (vecX - vecY) * U(60));
	plCr.close();	
	dp.draw(PlaneProfile(plCr),_kDrawFilled);
	// second leg
	CoordSys csRot;
	csRot.setToRotation(90,vecZ,_Pt0);
	plCr.transformBy(csRot);
	dp.draw(PlaneProfile(plCr),_kDrawFilled);
	
	// display in plan view
	Display dpPlan(1);
	dpPlan.color(iColor);
	dpPlan.elemZone(el, nZone, 'I');
	
	dpPlan.addViewDirection(vecY);
	CoordSys csTrans;
	csTrans.setToAlignCoordSys(_Pt0, vecX, vecY, vecZ, _Pt0, vecX, - vecZ, vecY);
	plCr.transformBy(csTrans);
	dpPlan.draw(PlaneProfile(plCr),_kDrawFilled);
	csRot.setToRotation(90,vecY,_Pt0);
	plCr.transformBy(csRot);
	dpPlan.draw(PlaneProfile(plCr),_kDrawFilled);
	
//End Display//endregion 

	assignToElementGroup(el, true, nZone, 'E');

	_ThisInst.recalc();
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
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16939: Support canceling tsl during insertion jig" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="10" />
      <str nm="Date" vl="11/7/2022 1:48:54 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-8707: improve prompt in jig, symbol not outside the envelope" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="1/20/2021 10:05:44 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-8707: support jig, multiple enhancements" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="1/19/2021 5:58:33 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End