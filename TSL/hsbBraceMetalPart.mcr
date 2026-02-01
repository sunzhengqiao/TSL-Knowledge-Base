#Version 8
#BeginDescription
version value="1.0" date="27ene2019" author="david.rueda@hsbcad.com"

Creates a brace metalpart for 2 beams

#End
#Type O
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
//region history
/// <History>
/// <version value="1.0" date="27ene2019" author="david.rueda@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select 2 perpendicular beams(s)
/// </insert>

/// <summary Lang=en>
/// Creates a brace metalpart for 2 beams
/// </summary>
//endregion

{
	// constants //region
	U(1, "mm");
	double dEps = U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick = "TslDoubleClick";
	int bDebug = _bOnDebug;
	// read a potential mapObject defined by hsbDebugController
	{
		MapObject mo("hsbTSLDev" , "hsbTSLDebugController");
			if (mo.bIsValid()) { Map m = mo.map(); for (int i = 0; i < m.length(); i++) if (m.getString(i) == scriptName()) { bDebug = true; 	break; }}
		if (bDebug)reportMessage("\n" + scriptName() + " starting " + _ThisInst.handle());
	}
	String sDefault = T("|_Default|");
	String sLastInserted = T("|_LastInserted|");
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	String sReferencePoint = "ReferencePoint";
	String sFirstRun = "sFirstRun";
	double dRegionW = U (5000); //initial value for searching region
	//endregion
	
	//region properties
	String sSizeName = T("|Size|");
	PropDouble dSize(nDoubleIndex++, U(600), sSizeName);
	dSize.setDescription(T("|Defines the Size|"));
	dSize.setCategory(category);
	
	String sMakerName = T("|Maker|");
	PropString sMaker(nStringIndex++, "", sMakerName);
	sMaker.setDescription(T("|Defines the Maker|"));
	sMaker.setCategory(category);
	
	String sProductNameName = T("|Product Name|");
	PropString sProductName(nStringIndex++, "", sProductNameName);
	sProductName.setDescription(T("|Defines the Product Name|"));
	sProductName.setCategory(category);
	
	double dWidth = U(71), dLength = dWidth * 1.5, dThickness = U(1.6), dRadius = dWidth * .25; // plates at bases props.	
	//endregion
	
	// bOnInsert
	if (_bOnInsert)
	{
		if (insertCycleCount() > 1)
		{
			eraseInstance();
			return;
		}
		
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
		else if ( ! bDebug && 0) //TODO : undo
			showDialog();
		
		while (true)
		{
			PrEntity ssE(T("|Select 2 perpendicular beam(s)|"), Beam());
			if (ssE.go() == _kOk)
			{
				_Beam.setLength(0);
				_Beam.append(ssE.beamSet());
				
				// validations
				if (_Beam.length() != 2)
				{
					reportMessage("\n" + scriptName() + T(" |- Error|: ") + T("|wrong number of selected beams (2 are needed)|\n"));
					continue;
				}
				
				Beam bm0 = _Beam[0];
				Vector3d vecX0 = bm0.vecX();
				
				Beam bm1 = _Beam[1];
				Vector3d vecX1 = bm1.vecX();
				
				if ( ! vecX0.isPerpendicularTo(vecX1))
				{
					reportMessage("\n" + scriptName() + T(" |- Error|: ") + T("|beams are not perpendicular|\n"));
					continue;
				}
				
				// basic info
				Point3d ptCen0 = bm0.ptCenSolid();
				Point3d ptCen1 = bm1.ptCenSolid();
				Point3d ptIntersection;
				int bOk = Line(ptCen0, vecX0).hasIntersection(Plane(ptCen1, vecX0), ptIntersection);//at intersection of both beam's axis
				if ( ! bOk)
				{
					eraseInstance();
					return;
				}
				
				if (vecX0.dotProduct(ptIntersection - ptCen0) < 0) //pointing towards connection
					vecX0 *= -1;
				if (vecX1.dotProduct(ptIntersection - ptCen1) < 0) //pointing towards connection
					vecX1 *= -1;
				Vector3d vNormal = vecX0.crossProduct(vecX1); vNormal.normalize();
				
				//region define valid regions at sides of each beam for displaying
				PlaneProfile ppBm0, ppBm1;
				// at sides of bm0
				Plane plnSlice (ptIntersection, vNormal);
				Beam bmCurrent = bm0, bmOther = bm1;
				Vector3d vRef = bmOther.vecX(), vecXCurrent = bmCurrent.vecX(); //vRef used to get extreme points
				PlaneProfile ppCurrent = ppBm0 = bmCurrent.envelopeBody().shadowProfile(plnSlice);
				LineSeg lsCurrent = ppCurrent.extentInDir(vRef);
				Point3d ptStart = lsCurrent.ptStart(), ptEnd = lsCurrent.ptEnd();
				PlaneProfile ppOther = bmOther.envelopeBody().shadowProfile(plnSlice);
				LineSeg lsOther = ppOther.extentInDir(vRef);
				Point3d pt1 = lsOther.ptStart(), pt2 = lsOther.ptEnd();
				int b0A, b0B, b1A, b1B;
				PlaneProfile ppRegion0A, ppRegion0B, ppRegion1A, ppRegion1B, ppRegions[0];
				
				if (vRef.dotProduct(ptStart - pt1) > dEps )
				{
					b0A = true;
					PLine plRegion0A (vNormal);
					plRegion0A.createRectangle(LineSeg(ptStart, ptEnd - vRef * dRegionW), vecXCurrent, vRef);
					ppRegion0A = PlaneProfile (plRegion0A);
				}
				if (vRef.dotProduct(pt2 - ptEnd) > dEps )
				{
					b0B = true;
					PLine plRegion0B (vNormal);
					plRegion0B.createRectangle(LineSeg(ptEnd, ptStart + vRef * dRegionW), vecXCurrent, vRef);
					ppRegion0B = PlaneProfile (plRegion0B);
				}
				// at sides of bm1
				bmCurrent = bm1; bmOther = bm0;
				vRef = bmOther.vecX(); vecXCurrent = bmCurrent.vecX();
				ppCurrent = ppBm1 = bmCurrent.envelopeBody().shadowProfile(plnSlice);
				lsCurrent = ppCurrent.extentInDir(vRef);
				ptStart = lsCurrent.ptStart(); ptEnd = lsCurrent.ptEnd();
				ppOther = bmOther.envelopeBody().shadowProfile(plnSlice);
				lsOther = ppOther.extentInDir(vRef);
				pt1 = lsOther.ptStart(); pt2 = lsOther.ptEnd();
				if (vRef.dotProduct(ptStart - pt1) > dEps )
				{
					b1A = true;
					PLine plRegion1A (vNormal);
					plRegion1A.createRectangle(LineSeg(ptStart, ptEnd - vRef * dRegionW), vecXCurrent, vRef);
					ppRegion1A = PlaneProfile (plRegion1A);
				}
				if (vRef.dotProduct(pt2 - ptEnd) > dEps)
				{
					b1B = true;
					PLine plRegion1B (vNormal);
					plRegion1B.createRectangle(LineSeg(ptEnd, ptStart + vRef * dRegionW), vecXCurrent, vRef);
					ppRegion1B = PlaneProfile (plRegion1B);
				}
				
				//define valid common regions
				int nRegions;
				if (b0A && b1A)
				{
					PlaneProfile pp0A1A = ppRegion0A;
					pp0A1A.intersectWith(ppRegion1A);
					ppRegions.append(pp0A1A);
					nRegions++;
				}
				
				if (b0A && b1B)
				{
					PlaneProfile pp0A1B = ppRegion0A;
					pp0A1B.intersectWith(ppRegion1B);
					ppRegions.append(pp0A1B);
					nRegions++;
				}
				
				if (b0B && b1A)
				{
					PlaneProfile pp0B1A = ppRegion0B;
					pp0B1A.intersectWith(ppRegion1A);
					ppRegions.append(pp0B1A);
					nRegions++;
				}
				
				if (b0B && b1B)
				{
					PlaneProfile pp0B1B = ppRegion0B;
					pp0B1B.intersectWith(ppRegion1B);
					ppRegions.append(pp0B1B);
					nRegions++;
				}
				//endregion
				
				//region prompt for ptRef which define insertion region (if more than 1)
				Point3d ptRef;
				if (nRegions == 1)
				{
					ptRef = (ptCen0 + ptCen1) / 2;
				}
				else
				{
					// display valid regions (using beams as work around to not being able to display lines at _bOnInsert)
					Beam bmRegions[0];
					if (bDebug)
					{
						for (int r = 0; r < ppRegions.length(); r++)
						{
							PlaneProfile ppRegion = ppRegions[r];
							PLine plRings[] = ppRegion.allRings(true, false);
							if (plRings.length() == 0)
								continue;
							
							PLine plRegion = plRings[0];
							Body bdRegion (plRegion, vNormal * U(2), 0);
							Beam bmRegion;
							bmRegion.dbCreate(bdRegion);
							bmRegions.append(bmRegion);
						}//next index
					}
					
					int bCancelled = false;
					PrPoint prP(T("|Select location|"), ptIntersection);
					if (prP.go() == _kOk)
					{
						ptRef = prP.value();
					}
					else
					{
						bCancelled = true;
						if ( bDebug) reportMessage("\n" + scriptName() + ": " + T("|Selection cancelled by user|"));
					}
					
					for (int b = 0; b < bmRegions.length(); b++) //bmRegions will be empty if bDebug
					{
						Beam bm = bmRegions[b];
						if (bm.bIsValid())
							bm.dbErase();
					}//next index
					
					if (bCancelled)
					{
						eraseInstance();
						return;
					}
				}
				//endregion
				//region check if selected region is valid for brace
				if (vecX0.dotProduct(ptIntersection - ptRef) < 0 )
					vecX0 *= -1;
				if (vecX1.dotProduct(ptIntersection - ptRef) < 0)
					vecX1 *= -1;
				
				Point3d ptCorner = ptIntersection - vecX0 * bm1.dD(vecX0) * .5 - vecX1 * bm0.dD(vecX1) * .5;
				Point3d ptExtr0 = ppBm0.extentInDir(vecX0).ptStart();
				Point3d ptExtr1 = ppBm1.extentInDir(vecX1).ptStart();
				ptRef = ptCorner - vecX0 * abs(vecX0.dotProduct(ptCorner - ptExtr0) * .5) - vecX1 * abs(vecX1.dotProduct(ptCorner - ptExtr1) * .5);
				
				int bValidRegion;
				for (int r = 0; r < ppRegions.length(); r++)
				{
					PlaneProfile ppRegion = ppRegions[r];
					if (ppRegion.pointInProfile(ptRef) == _kPointInProfile)
					{
						bValidRegion = true;
						break;
					}
				}//next index
				
				if ( ! bValidRegion)
				{
					reportMessage("\n" + scriptName() + T(" |- Error|: ") + T("|cannot be placed in this location|\n"));
					continue;
				}
				//endregion
				
				// create TSL
				TslInst tslNew; Vector3d vecXTsl = _XW; Vector3d vecYTsl = _YW; GenBeam gbsTsl[] = { _Beam[0], _Beam[1]};
				Entity entsTsl[] = { }; Point3d ptsTsl[] = { ptRef}; int nProps[] ={ }; double dProps[] ={ }; String sProps[] ={ }; Map mapTsl; mapTsl.setPoint3d(sReferencePoint, ptRef);
				tslNew.dbCreate(scriptName() , vecXTsl , vecYTsl, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
			}
			else
				break;
		}
		
		eraseInstance();
		return;
	}
	// end on insert	__________________
	
	// validations
	if (_Beam.length() != 2)
	{
		reportMessage("\n" + scriptName() + T(" |- Error|: ") + T("|2 beams are required|\n"));
		eraseInstance();
		return;
	}
	
	Beam bm0 = _Beam[0];
	Vector3d vecX0 = bm0.vecX();
	
	Beam bm1 = _Beam[1];
	Vector3d vecX1 = bm1.vecX();
	
	if ( ! vecX0.isPerpendicularTo(vecX1))
	{
		reportMessage("\n" + scriptName() + T(" |- Error|: ") + T("|beams must be perpendicular|\n"));
		eraseInstance();
		return;
	}
	
	if ( ! _Map.hasPoint3d(sReferencePoint))
	{
		reportMessage("\n" + scriptName() + T(" |- Error|: ") + T("|not valid reference point set|\n"));
		eraseInstance();
		return;
	}
	
	// basic info
	Point3d ptCen0 = bm0.ptCenSolid();
	Point3d ptCen1 = bm1.ptCenSolid();
	Point3d ptIntersection;
	int bOk = Line(ptCen0, vecX0).hasIntersection(Plane(ptCen1, vecX0), ptIntersection);
	if ( ! bOk)
	{
		eraseInstance();
		return;
	}
	
	Point3d ptRef = _Pt0;
	
	if (vecX0.dotProduct(ptIntersection - ptRef) < 0)
		vecX0 *= -1;
	if (vecX1.dotProduct(ptIntersection - ptRef) < 0)
		vecX1 *= -1;
	Vector3d vNormal = vecX0.crossProduct(vecX1); vNormal.normalize();
	
	//region define valid regions at sides of each beam for displaying
	PlaneProfile ppBm0, ppBm1;
	// at sides of bm0
	Plane plnSlice (ptIntersection, vNormal);
	Beam bmCurrent = bm0, bmOther = bm1;
	Vector3d vRef = bmOther.vecX(), vecXCurrent = bmCurrent.vecX(); //vRef used to get extreme points
	PlaneProfile ppCurrent = ppBm0 = bmCurrent.envelopeBody().shadowProfile(plnSlice);
	LineSeg lsCurrent = ppCurrent.extentInDir(vRef);
	Point3d ptStart = lsCurrent.ptStart(), ptEnd = lsCurrent.ptEnd();
	PlaneProfile ppOther = bmOther.envelopeBody().shadowProfile(plnSlice);
	LineSeg lsOther = ppOther.extentInDir(vRef);
	Point3d pt1 = lsOther.ptStart(), pt2 = lsOther.ptEnd();
	int b0A, b0B, b1A, b1B;
	PlaneProfile ppRegion0A, ppRegion0B, ppRegion1A, ppRegion1B, ppRegions[0];
	
	if (vRef.dotProduct(ptStart - pt1) > dEps )
	{
		b0A = true;
		PLine plRegion0A (vNormal);
		plRegion0A.createRectangle(LineSeg(ptStart, ptEnd - vRef * dRegionW), vecXCurrent, vRef);
		ppRegion0A = PlaneProfile (plRegion0A);
	}
	if (vRef.dotProduct(pt2 - ptEnd) > dEps )
	{
		b0B = true;
		PLine plRegion0B (vNormal);
		plRegion0B.createRectangle(LineSeg(ptEnd, ptStart + vRef * dRegionW), vecXCurrent, vRef);
		ppRegion0B = PlaneProfile (plRegion0B);
	}
	// at sides of bm1
	bmCurrent = bm1; bmOther = bm0;
	vRef = bmOther.vecX(); vecXCurrent = bmCurrent.vecX();
	ppCurrent = ppBm1 = bmCurrent.envelopeBody().shadowProfile(plnSlice);
	lsCurrent = ppCurrent.extentInDir(vRef);
	ptStart = lsCurrent.ptStart(); ptEnd = lsCurrent.ptEnd();
	ppOther = bmOther.envelopeBody().shadowProfile(plnSlice);
	lsOther = ppOther.extentInDir(vRef);
	pt1 = lsOther.ptStart(); pt2 = lsOther.ptEnd();
	if (vRef.dotProduct(ptStart - pt1) > dEps )
	{
		b1A = true;
		PLine plRegion1A (vNormal);
		plRegion1A.createRectangle(LineSeg(ptStart, ptEnd - vRef * dRegionW), vecXCurrent, vRef);
		ppRegion1A = PlaneProfile (plRegion1A);
	}
	if (vRef.dotProduct(pt2 - ptEnd) > dEps)
	{
		b1B = true;
		PLine plRegion1B (vNormal);
		plRegion1B.createRectangle(LineSeg(ptEnd, ptStart + vRef * dRegionW), vecXCurrent, vRef);
		ppRegion1B = PlaneProfile (plRegion1B);
	}
	
	//define valid common regions
	int nRegions;
	if (b0A && b1A)
	{
		PlaneProfile pp0A1A = ppRegion0A;
		pp0A1A.intersectWith(ppRegion1A);
		ppRegions.append(pp0A1A);
		nRegions++;
	}
	
	if (b0A && b1B)
	{
		PlaneProfile pp0A1B = ppRegion0A;
		pp0A1B.intersectWith(ppRegion1B);
		ppRegions.append(pp0A1B);
		nRegions++;
	}
	
	if (b0B && b1A)
	{
		PlaneProfile pp0B1A = ppRegion0B;
		pp0B1A.intersectWith(ppRegion1A);
		ppRegions.append(pp0B1A);
		nRegions++;
	}
	
	if (b0B && b1B)
	{
		PlaneProfile pp0B1B = ppRegion0B;
		pp0B1B.intersectWith(ppRegion1B);
		ppRegions.append(pp0B1B);
		nRegions++;
	}
	//endregion
	
	//region check if selected region is valid for brace
	if (vecX0.dotProduct(ptIntersection - ptRef) < 0 )
		vecX0 *= -1;
	if (vecX1.dotProduct(ptIntersection - ptRef) < 0)
		vecX1 *= -1;
	
	Point3d ptCorner = ptIntersection - vecX0 * bm1.dD(vecX0) * .5 - vecX1 * bm0.dD(vecX1) * .5;
	Point3d ptExtr0 = ppBm0.extentInDir(vecX0).ptStart();
	Point3d ptExtr1 = ppBm1.extentInDir(vecX1).ptStart();
	ptRef = ptCorner - vecX0 * abs(vecX0.dotProduct(ptCorner - ptExtr0) * .5) - vecX1 * abs(vecX1.dotProduct(ptCorner - ptExtr1) * .5);
	
	int bValidRegion;
	for (int r = 0; r < ppRegions.length(); r++)
	{
		PlaneProfile ppRegion = ppRegions[r];
		if (ppRegion.pointInProfile(ptRef) == _kPointInProfile)
		{
			bValidRegion = true;
			break;
		}
	}//next index
	
	if ( ! bValidRegion)
	{
		reportMessage("\n" + scriptName() + T(" |- Error|: ") + T("|cannot be placed in this location|\n"));
		eraseInstance();
		return;
	}
	//endregion
	
	// Start drawing
	Display dp(254);
	double dOffset = dSize * sin(45);
	pt1 = ptIntersection - vecX0 * (bm1.dD(vecX0) * .5 + dOffset) - vecX1 * bm0.dD(vecX1) * .5;
	Point3d pt0 = ptIntersection - vecX1 * (bm0.dD(vecX1) * .5 + dOffset) - vecX0 * bm1.dD(vecX0) * .5;
	Vector3d vMain = pt1 - pt0; vMain.normalize();
	_Pt0 = (pt1 + pt0) / 2;
	
	// main body
	Body bdDrill (pt1 - vMain * U(1000), pt0 + vMain * U(1000), dRadius);
	Cut ct0(pt1, vecX1);
	Cut ct1(pt0, vecX0);
	bdDrill.addTool(ct0);
	bdDrill.addTool(ct1);
	dp.draw(bdDrill);
	
	Vector3d vTmp = vMain.crossProduct(vNormal); vTmp.normalize();
	if ((ptIntersection - _Pt0).dotProduct(vTmp) < 0)
	{
		vTmp *= -1;
	}
	
	Body bdDrillComb(_Pt0, vMain, vNormal, vTmp, (pt0 - pt1).length() * 1.5, dRadius * 2, dLength * .35, 0, 0, 1);
	bdDrillComb.addTool(ct0);
	bdDrillComb.addTool(ct1);
	dp.draw(bdDrillComb);
	
	// plate on bm0
	Body bdPlate0(pt0, vecX1, vecX0.crossProduct(vecX1), vecX0, dLength, dWidth, dThickness, 0, 0, - 1);
	dp.draw(bdPlate0);
	
	Body bdPlate1(pt1, vecX0, vecX1.crossProduct(vecX0), vecX1, dLength, dWidth, dThickness, 0, 0, - 1);
	dp.draw(bdPlate1);
	
	// Hardware//region
	// collect existing hardware
	HardWrComp hwcs[] = _ThisInst.hardWrComps();
	
	// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
	for (int i = hwcs.length() - 1; i >= 0; i--)
		if (hwcs[i].repType() == _kRTTsl)
			hwcs.removeAt(i);
		
		// declare the groupname of the hardware components
		String sHWGroupName;
		// set group name
		{
			// element
			// try to catch the element from the parent entity
			Element elHW = bm0.element();
			// check if the parent entity is an element
			if ( ! elHW.bIsValid())
				elHW = (Element)bm0;
			if (elHW.bIsValid())
				sHWGroupName = elHW.elementGroup().name();
				// loose
			else
			{
				Group groups[] = _ThisInst.groups();
				if (groups.length() > 0)
					sHWGroupName = groups[0].name();
			}
	}
	
	// add main componnent
	{
		String sHWArticleNumber = sMaker;
		if (sProductName != "")
		{
			if (sMaker != "")
				sHWArticleNumber += " - " + sProductName;
			else
				sHWArticleNumber = sProductName;
		}
		if (sHWArticleNumber == "")
			sHWArticleNumber = scriptName();
		
		String sHWName = sProductName;
		if (sHWName == "")
			sHWName = scriptName();
		
		HardWrComp hwc(sHWArticleNumber, 1); //the articleNumber and the quantity is mandatory
		
		hwc.setManufacturer(sMaker);
		
		hwc.setName(sHWName);
		
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(bm0);
		hwc.setCategory(T("|Connector|"));
		hwc.setRepType(_kRTTsl); //the repType is used to distinguish between predefined and custom components
		
		hwc.setDScaleX(dSize);
		hwc.setDScaleY(dRadius * 2);
		hwc.setDScaleZ(0);
		
		// apppend component to the list of components
		hwcs.append(hwc);
	}
	
	// make sure the hardware is updated
	if (_bOnDbCreated)
		setExecutionLoops(2);
	
	_ThisInst.setHardWrComps(hwcs);
	//endregion
	
	if (bDebug)
	{
		_Pt0.vis();
		ptIntersection.vis();
		ptRef.vis();
		vecX0.vis(pt0, 1);
		vecX1.vis(pt1, 3);
		pt1.vis(3);
		pt0.vis(1);
		// Draw Point3d
		for (int r = 0; r < ppRegions.length(); r++)
		{
			PlaneProfile ppRegion = ppRegions[r];
			ppRegion.vis();
		}//next index
	}
}

#End
#BeginThumbnail
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
?%X+TF?0?".C:;=;?M-I:1PR>6<KN50#@^E;5%`'_V0``

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
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End