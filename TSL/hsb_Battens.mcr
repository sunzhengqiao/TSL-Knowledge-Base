#Version 8
#BeginDescription
Create horizontal battens in openings, it will take in consideration if they are opening assemblies too if the TSL "hsb_SetModuleOnWindowDoorAssembly" is used prior to this one..

version value="2.3" date="19jan2022" author="alberto.jena@hsbcad.com"

HSB-12591: add properties for gap top and bottom
HSB-5278 for H<200 battens were not generated 
additional area check appended


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 3
#KeyWords 
#BeginContents
/// <History>//region
/// <version value="2.3" date="13jul2021" author="alberto.jena@hsbcad.com"> add a property to exclude a zone </version>
/// <version value="2.2" date="13jul2021" author="marsel.nakuci@hsbcad.com"> HSB-12591: add properties for gap top and bottom </version>
/// <version value="2.1" date="28.10.2019" author="marsel.nakuci@hsbcad.com"> HSB-5278 for H<200 battens were not generated </version>
/// <version value="2.0" date="02sept2019" author="thorsten.huck@hsbcad.com"> additional area check appended </version>
/// </History>

/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates battens around openings
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsb_Battens")) TSLCONTENT
//endregion



/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2009 by
*  hsbSOFT
*  IRELAND
*
*  The program may be used and/or copied only with the written
*  permission from hsbSOFT, or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
* REVISION HISTORY
* -------------------------
*
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 22.01.2013
* version 1.0: Release Version
*
* date: 14.02.2013
* version 1.1: Fix issue when the TSL was part of the wall TSLs
* version 1.0: Release Version
*
* date: 21.02.2019
* version 1.8: Genbeams of element where not valid in first executionloop of tsl
*
* date: 30.06.2019
* version 1.9: Add a property for a Gap of the horizontal battens above an below the opening.
*/

_ThisInst.setSequenceNumber(-60);

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

String executeKey = "ManualInsert";

PropString sYesNoExtraBattensAboveOpening (0, sNoYes,T("|Create extra battens above opening|"),1);
int nYesNoExtraBattensAboveOpening = sNoYes.find(sYesNoExtraBattensAboveOpening, 0);

PropString sYesNoExtraBattensBelowOpening (1, sNoYes,T("|Create extra battens below opening|"),1);
int nYesNoExtraBattensBelowOpening = sNoYes.find(sYesNoExtraBattensBelowOpening, 0);

PropDouble dSideGap(0, U(0), T("|Side Gap|"));

PropInt dZoneToExclude(0, 0, T("|Zone index to exclude|"));

// HSB-12591: new property set
category = T("|Vertical batten Gap|");
String sGapTopName=T("|Top|");	
PropDouble dGapTop(1, U(0), sGapTopName);	
dGapTop.setDescription(T("|Defines the Top Gap of the Batten|"));
dGapTop.setCategory(category);

String sGapBottomName=T("|Bottom|");	
PropDouble dGapBottom(2, U(0), sGapBottomName);	
dGapBottom.setDescription(T("|Defines the Bottom Gap of the Batten|"));
dGapBottom.setCategory(category);


if (dSideGap<0)
{ 
	dSideGap.set(0);
}

//region mapIO: support property dialog input via map on element creation
	{
		int bHasPropertyMap = _Map.hasMap("PROPSTRING[]") && _Map.hasMap("PROPDOUBLE[]");
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

// bOnInsert
if(_bOnInsert)
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
				
// silent/dialog
	String sKey = _kExecuteKey;
	sKey.makeUpper();

	if (sKey.length()>0)
	{
		String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
		for(int i=0;i<sEntries.length();i++)
		{
			sEntries[i] = sEntries[i].makeUpper();	
		}
		
		if (sEntries.find(sKey)>-1)
		{
			setPropValuesFromCatalog(sKey);
			setCatalogFromPropValues(sLastInserted); // use because lastinserted was not set (should not be needed)
		}
		else
		{
			setPropValuesFromCatalog(sKey);
			setCatalogFromPropValues(sLastInserted); // use because lastinserted was not set (should not be needed)
		}
	}	
	else	
	{
		showDialog();
		setCatalogFromPropValues(sLastInserted); // use because lastinserted was not set (should not be needed)
	}
	
	// prompt for elements
	PrEntity ssE(T("|Select element(s)|"), Element());
  	if (ssE.go())
  	{
		_Element.append(ssE.elementSet());
  	}
	
	for (int e=0;e<_Element.length();e++) 
	{
		// prepare tsl cloning
		TslInst tslNew;
		Vector3d vecXTsl= _XE;
		Vector3d vecYTsl= _YE;
		GenBeam gbsTsl[] = {};
		Entity entsTsl[0];
		entsTsl.append(_Element[e]);
		Point3d ptsTsl[] = {};
		int nProps[]={};
		double dProps[]={};
		String sProps[]={};
		Map mapTsl;	
		String sScriptname = scriptName();
		
		ptsTsl.append(_Element[e].coordSys().ptOrg());
		
		tslNew.dbCreate(scriptName(),vecXTsl, vecYTsl, gbsTsl, entsTsl, ptsTsl, sLastInserted, true, mapTsl, executeKey, "");
	}
	
	eraseInstance();		
	return;
}	
// end on insert	__________________
	
//return;
// validate and declare element variables
if (_Element.length()<1)
{
	reportMessage(TN("|Element reference not found.|"));
	eraseInstance();
	return;	
}

ElementWall el = (ElementWall) _Element[0];
if (!el.bIsValid())
{
	reportMessage(TN("|Element not valid|."));
	eraseInstance();
	return;
}

if (_kExecuteKey == executeKey || _bOnElementConstructed || _bOnDebug)
{
	CoordSys cs = el.coordSys();
	Vector3d vx = cs.vecX();
	Vector3d vy = cs.vecY();
	Vector3d vz = cs.vecZ();
	Point3d ptOrgEl = cs.ptOrg();
	_Pt0 = ptOrgEl;
	
////return////////////
	String sOpHandle[0];
	int nPLineLocation[0];
	PLine plOpShape[0];
	
	Map mpElement = el.subMapX("OPENINGASSEMBLY[]");
	if (mpElement.length() > 0)
	{
		for (int i = 0; i < mpElement.length(); i++)
		{
			if (mpElement.keyAt(i) == "OPENINGASSEMBLY")
			{
				Map mpThisAssembly = mpElement.getMap("OPENINGASSEMBLY");
				for (int j = 0; j < mpThisAssembly.length(); j++)
				{
					if (mpThisAssembly.keyAt(j) == "PLSHAPE")
					{
						plOpShape.append(mpThisAssembly.getPLine(j));
					}
				}
				for (int j = 0; j < mpThisAssembly.length(); j++)
				{
					if (mpThisAssembly.keyAt(j) == "HANDLE")
					{
						nPLineLocation.append(plOpShape.length() - 1);
						sOpHandle.append(mpThisAssembly.getString(j));
					}
				}
			}
		}
	}
	
	if (_bOnDebug)
	{
		Beam bmAll[] = el.beam();
		for (int i = 0; i < bmAll.length(); i++)
		{
//			bmAll[i].realBody().vis(32);
		}
	}
	Opening opAll[] = el.opening();
	
	GenBeam gbm[] = el.genBeam(0);
	
	if (gbm.length() < 1)
	{
		reportMessage(TN("|No genbeams found|."));
		eraseInstance();
		return;
	}
	
	int nRealZones[] ={ 1, 2, 3, 4, 5 ,- 1 ,- 2 ,- 3 ,- 4 ,- 5};
	
	for (int x = 0; x < nRealZones.length(); x++)
	{
		int nZone = nRealZones[x];
		ElemZone elZ = el.zone(nZone);
		
		String sDistribution = elZ.code();
		//Ensure the TSL only works on vertical sheets and no other type of distribution
		//reportNotice("\n"+sDistribution);
		if (sDistribution != "HSB-PL09") continue;
		
		if (dZoneToExclude == nZone) continue;
		
		Vector3d vzZone = vz;
		int nBack = nZone < 0;
		double dBattenWidth = elZ.dVar("width");
		double dBattenThickness = elZ.dH();
		
		//Some values and point needed after
		Point3d ptFront = nBack ?
		el.zone(nZone).coordSys().ptOrg() - dBattenThickness * vz :
		el.zone(nZone).coordSys().ptOrg();
		ptFront.vis(1);
		
		Plane plnZ (ptFront, vzZone);
		
		Sheet shCreated[0];
		
		Sheet shAll[] = el.sheet(nZone);
		
		String sMaterial = elZ.material();
		int nColor = elZ.color();
		
		
		if (dBattenThickness == 0) { continue; }
		//reportNotice("\nwidth"+dBattenWidth);
		//reportNotice(" thickness" +dBattenThickness);
		
		CoordSys csRotation;
		csRotation.setToRotation(-90, vz, cs.ptOrg());
		
		CoordSys csRingNew = cs;
		csRingNew.transformBy(csRotation);
		
		//		if (nZone<0)
		//		{
		//			CoordSys csRotationY;
		//			csRotationY.setToRotation(180,vy,cs.ptOrg());
		//			csRingNew.transformBy(csRotationY);
		//		}
		//
		csRingNew.transformBy(ptFront - cs.ptOrg());
		
		CoordSys csVerticalRotation;
		csVerticalRotation.setToRotation(90, vz, cs.ptOrg());
		
		CoordSys csVerticalBattens = csRingNew;
		csVerticalBattens.transformBy(csVerticalRotation);
		
		//Find the extreme points for the zone
		PlaneProfile ppThisZone(plnZ);
		
		Point3d ptZoneAllVertex[0];
		for (int s = 0; s < shAll.length(); s++)
		{
			ppThisZone.joinRing(shAll[s].plEnvelope(), false);
			
			ptZoneAllVertex.append(shAll[s].plEnvelope().vertexPoints(true));
		}
		
		Point3d ptCenZone;
		ptCenZone.setToAverage(ptZoneAllVertex);
		
		Point3d ptZoneTL = ptCenZone;
		Point3d ptZoneBL = ptCenZone;
		Point3d ptZoneTR = ptCenZone;
		Point3d ptZoneBR = ptCenZone;
		
		for (int i = 0; i < ptZoneAllVertex.length(); i++)
		{
			Point3d pt = ptZoneAllVertex[i];
			//pt.vis();
			if ( (vx.dotProduct(pt - ptCenZone) <= 0 && vy.dotProduct(pt - ptCenZone) >= 0) && ((ptZoneTL - ptCenZone).length() < (pt - ptCenZone).length()))
			{
				ptZoneTL = pt;
			}
			
			if ( (vx.dotProduct(pt - ptCenZone) <= 0 && vy.dotProduct(pt - ptCenZone) <= 0) && ((ptZoneBL - ptCenZone).length() < (pt - ptCenZone).length()))
			{
				ptZoneBL = pt;
			}
			
			if ( (vx.dotProduct(pt - ptCenZone) >= 0 && vy.dotProduct(pt - ptCenZone) >= 0) && ((ptZoneTR - ptCenZone).length() < (pt - ptCenZone).length()))
			{
				ptZoneTR = pt;
			}
			
			if ( (vx.dotProduct(pt - ptCenZone) >= 0 && vy.dotProduct(pt - ptCenZone) <= 0) && ((ptZoneBR - ptCenZone).length() < (pt - ptCenZone).length()))
			{
				ptZoneBR = pt;
			}
		}
		
		ptZoneTL.vis(1);
		ptZoneBL.vis(1);
		ptZoneTR.vis(1);
		ptZoneBR.vis(1);
		
		
		//Get the maximum point for the top of the zone
		Point3d ptTopZone = vy.dotProduct(ptZoneTL - ptOrgEl) > vy.dotProduct(ptZoneTR - ptOrgEl) ? ptZoneTL : ptZoneTR;
		Point3d ptBottomZone = ptZoneBL;
		
		if (vz.dotProduct(ptTopZone - ptZoneTR) < 0)
		{
			ptTopZone = ptZoneTR;
		}
		
		if (vz.dotProduct(ptZoneBR - ptBottomZone) < 0)
		{
			ptBottomZone = ptZoneBR;
		}
		
		Line lnTopZone(ptZoneTL, vx);
		Line lnBottomZone(ptZoneBL, vx);
		
		
		//Loop through all the openings
		
		for (int n = 0; n < opAll.length(); n++)
		{
			OpeningSF op = (OpeningSF)opAll[n];
			if ( ! op.bIsValid())
			{
				continue;
			}
			
			int nDoor = FALSE;
			if (op.openingType() == _kDoor)
				nDoor = TRUE;
			
			PLine plOp;
			
			String sHandle = op.handle();
			if (sOpHandle.find(sHandle) != -1)
			{
				plOp = plOpShape[nPLineLocation[sOpHandle.find(sHandle)]];
			}
			else
			{
				plOp = op.plShape();
			}
			
			plOp.vis();
			Point3d ptOpAllVertex[] = plOp.vertexPoints(true);
			ptOpAllVertex = plnZ.projectPoints(ptOpAllVertex);
			
			Point3d ptCenOp;
			ptCenOp.setToAverage(ptOpAllVertex);
			// HSB-5278 
			ptCenOp = ptCenOp;//+ vy * U(100);
			ptCenOp.vis(3);
			Point3d ptOpTL = ptCenOp;
			Point3d ptOpBL = ptCenOp;
			Point3d ptOpTR = ptCenOp;
			Point3d ptOpBR = ptCenOp;
			
			for (int i = 0; i < ptOpAllVertex.length(); i++)
			{
				Point3d pt = ptOpAllVertex[i];
				pt.vis();
				if ( (vx.dotProduct(pt - ptCenOp) <= 0 && vy.dotProduct(pt - ptCenOp) >= 0) && ((ptOpTL - ptCenOp).length() < (pt - ptCenOp).length()))
				{
					ptOpTL = pt;
					continue;
				}
				
				if ( (vx.dotProduct(pt - ptCenOp) <= 0 && vy.dotProduct(pt - ptCenOp) <= 0) && ((ptOpBL - ptCenOp).length() < (pt - ptCenOp).length()))
				{
					ptOpBL = pt;
					continue;
				}
				
				if ( (vx.dotProduct(pt - ptCenOp) >= 0 && vy.dotProduct(pt - ptCenOp) >= 0) && ((ptOpTR - ptCenOp).length() < (pt - ptCenOp).length()))
				{
					ptOpTR = pt;
					continue;
				}
				
				if ( (vx.dotProduct(pt - ptCenOp) >= 0 && vy.dotProduct(pt - ptCenOp) <= 0) && ((ptOpBR - ptCenOp).length() < (pt - ptCenOp).length()))
				{
					ptOpBR = pt;
					continue;
				}
			}
			
			//Adjust for tolerances
			ptOpTL = ptOpTL - vx * op.dGapSide() + vy * op.dGapTop();
			ptOpTR = ptOpTR + vx * op.dGapSide() + vy * op.dGapTop();
			ptOpBL = ptOpBL - vx * op.dGapSide() - vy * op.dGapTop();
			ptOpBR = ptOpBR + vx * op.dGapSide() - vy * op.dGapTop();
			ptOpTL.vis(1);
			ptOpBL.vis(1);
			ptOpTR.vis(1);
			ptOpBR.vis(1);
			
			ptCenOp.vis(2);
			
			//Create the OSB Around the Opening
			//Create plane profile
			
			if (vy.dotProduct(ptTopZone - (ptOpTR + vy * dBattenWidth)) > 0)
			{
				//Top of opening
				LineSeg lsTop(ptOpTL + vx * dSideGap, ptOpTR + vy * dBattenWidth - vx * dSideGap);
				
				//double dAux1=vx.dotProduct(lsTop.ptStart()-lsTop.ptEnd());
				//reportNotice("\nLength"+dAux);
				
				PLine plTop(vzZone);
				plTop.createRectangle(lsTop, vx, vy);
				
				PlaneProfile ppShTop(csRingNew);
				ppShTop.joinRing(plTop, false);
				
				
				
			// version value="2.0" date="02sept2019" author="thorsten.huck@hsbcad.com"> additional area check appended
				if (ppShTop.area()>pow(dEps,2))
				{ 
					Sheet sh;
					sh.dbCreate(ppShTop, dBattenThickness, 1);
					sh.setMaterial(sMaterial);
					sh.setColor(nColor);
					sh.assignToElementGroup(el, TRUE, nZone, 'Z');
					shCreated.append(sh);
				}

				if (nYesNoExtraBattensAboveOpening)
				{
					//Extra sheet Top Left
					Point3d ptAuxTL = lnTopZone.closestPointTo(ptOpTL);
					ptAuxTL = ptAuxTL + vx * dBattenWidth;
					LineSeg lsTLBatten(ptOpTL+vy*dBattenWidth, ptAuxTL);
					PLine plTLBatten(vzZone);
					plTLBatten.createRectangle(lsTLBatten, vx, vy);
					csVerticalBattens.vis();
					PlaneProfile ppShTLBatten(csVerticalBattens);
					ppShTLBatten.joinRing(plTLBatten, false);
					ppShTLBatten.subtractProfile(ppThisZone);
					//reportNotice("\nTopLeft Area: "+ppShTLBatten.area());
					
					
					//Extra sheet Top Right
					Point3d ptAuxTR = lnTopZone.closestPointTo(ptOpTR);
					ptAuxTR = ptAuxTR - vx * dBattenWidth;
					LineSeg lsTRBatten(ptOpTR + vy * dBattenWidth, ptAuxTR);
					PLine plTRBatten(vzZone);
					plTRBatten.createRectangle(lsTRBatten, vx, vy);
					PlaneProfile ppShTRBatten(csVerticalBattens);
					ppShTRBatten.joinRing(plTRBatten, false);
					ppShTRBatten.subtractProfile(ppThisZone);
					
					ppShTLBatten.vis(4);
					ppShTRBatten.vis(4);
					// HSB-12591:
					PlaneProfile ppCleanup(ppShTLBatten.coordSys());
					{ 
						// get extents of profile
						LineSeg segL = ppShTLBatten.extentInDir(vx);
						LineSeg segR = ppShTRBatten.extentInDir(vx);
						
						Point3d pt1 = vy.dotProduct(segL.ptEnd() - segL.ptStart()) > 0 ? segL.ptStart() : segL.ptEnd();
						Point3d pt2 = vy.dotProduct(segR.ptEnd() - segR.ptStart()) > 0 ? segR.ptEnd() : segR.ptStart();
						PLine pl;
						pl.createRectangle(LineSeg(pt1, pt2), vx, vy);
						ppCleanup.joinRing(pl, _kAdd);
						ppCleanup.shrink(U(30));
						ppCleanup.vis(6);
					}
					
					// HSB-12591: add gap at top and bottom
					PLine plGapTop;
					if(dGapTop>dEps)
					{ 
					// get extents of profile
						LineSeg seg = ppShTLBatten.extentInDir(vx);
						double dX = abs(vx.dotProduct(seg.ptStart()-seg.ptEnd()));
						double dY = abs(vy.dotProduct(seg.ptStart()-seg.ptEnd()));
						Point3d ptTopGap = vy.dotProduct(seg.ptEnd() - seg.ptStart()) > 0 ? seg.ptEnd() : seg.ptStart();
						//
						plGapTop.createRectangle(LineSeg(ptTopGap - vx * U(10e3)-vy*dGapTop, 
							ptTopGap + vx * 2 * U(10e3)+vy*U(1000)), vx, vy);
					}
					PLine plGapBottom;
					if(dGapBottom>dEps)
					{ 
					// get extents of profile
						LineSeg seg = ppShTLBatten.extentInDir(vx);
						double dX = abs(vx.dotProduct(seg.ptStart()-seg.ptEnd()));
						double dY = abs(vy.dotProduct(seg.ptStart()-seg.ptEnd()));
						Point3d ptBottomGap = vy.dotProduct(seg.ptEnd() - seg.ptStart()) > 0 ? seg.ptStart():seg.ptEnd();
						//
						plGapBottom.createRectangle(LineSeg(ptBottomGap - vx * U(10e3)+vy*dGapBottom, 
							ptBottomGap + vx * 2 * U(10e3)-vy*U(1000)), vx, vy);
					}
					
					// HSB-12591: modify existing sheets
					for (int iSh=shAll.length()-1; iSh>=0 ; iSh--) 
					{ 
						Sheet shI=shAll[iSh];
						PlaneProfile ppSh = shI.profShape();
						if(ppSh.intersectWith(ppCleanup))
						{ 
							if(dGapTop>dEps)
								shI.joinRing(plGapTop, _kSubtract);
							if(dGapBottom>dEps)
								shI.joinRing(plGapBottom, _kSubtract);
						}
					}//next iSh
					
					
					if(dGapTop>dEps)
						ppShTLBatten.joinRing(plGapTop, _kSubtract);
					if(dGapBottom>dEps)
						ppShTLBatten.joinRing(plGapBottom, _kSubtract);
					if (ppShTLBatten.area() > pow(U(3),2))
					{
						//Top left jack
						//						reportNotice("Creating ppShTLBatten\n");
						Sheet shTL;
						shTL.dbCreate(ppShTLBatten, dBattenThickness, 1);
						shTL.setMaterial(sMaterial);
						shTL.setColor(nColor);
						shTL.assignToElementGroup(el, TRUE, nZone, 'Z');
						shAll.append(shTL);
					}
					
					
					if(dGapTop>dEps)
						ppShTRBatten.joinRing(plGapTop, _kSubtract);
					if(dGapBottom>dEps)
						ppShTRBatten.joinRing(plGapBottom, _kSubtract);
					if (ppShTRBatten.area() > pow(U(3),2))
					{
						//Top right jack
						//reportNotice("\nTopRight Area: "+ppShTRBatten.area());
						//						reportNotice("Creating ppShTRBatten\n");
						Sheet shTR;
						shTR.dbCreate(ppShTRBatten, dBattenThickness, 1);
						shTR.setMaterial(sMaterial);
						shTR.setColor(nColor);
						shTR.assignToElementGroup(el, TRUE, nZone, 'Z');
						shAll.append(shTR);
					}
				}
			}
		}
		
		//Look all the sills and create the battens
		//Bottom Opening
		//Look for the sill
		Beam bmAll[] = el.beam();
		Beam bmSill[0];
		for (int i = 0; i < bmAll.length(); i++)
		{
			if (bmAll[i].type() == _kSill)
			{
				bmSill.append(bmAll[i]);
			}
		}
		
		for (int s = 0; s < bmSill.length(); s++)
		{
			Beam bm = bmSill[s];
			Point3d ptCenter = bm.ptCen();
			double dSolidLength = bm.solidLength();
			Point3d ptLeft = ptCenter - vx * dSolidLength * 0.5 + vy * (bm.dD(vy) * 0.5);
			Point3d ptRight = ptCenter + vx * dSolidLength * 0.5 + vy * (bm.dD(vy) * 0.5);
			Point3d ptRightTemp = ptRight - vy * dBattenWidth;
			LineSeg lsSill(ptLeft + vx * dSideGap, ptRightTemp - vx * dSideGap);
			
			if (vy.dotProduct(ptBottomZone - ptRightTemp) < 0)
			{
				PLine plSill(vzZone);
				plSill.createRectangle(lsSill, vx, vy);
				
				PlaneProfile ppShSill(csRingNew);
				ppShSill.joinRing(plSill, false);
				//reportNotice("\nSill Area: "+ppShSill.area());
				ppShSill.vis(s);
				
				{
					//					reportNotice("Creating ppShSill\n");
					
					Sheet sh;
					sh.dbCreate(ppShSill, dBattenThickness, 1);
					sh.setMaterial(sMaterial);
					sh.setColor(nColor);
					sh.assignToElementGroup(el, TRUE, nZone, 'Z');
					shCreated.append(sh);
				}
				
				if (nYesNoExtraBattensBelowOpening)
				{
					//Extra sheet Top Left
					Point3d ptAuxBL = lnBottomZone.closestPointTo(ptLeft);
					ptAuxBL = ptAuxBL + vx * dBattenWidth;
					LineSeg lsBLBatten(ptLeft - vy * dBattenWidth, ptAuxBL);
					PLine plBLBatten(vzZone);
					plBLBatten.createRectangle(lsBLBatten, vx, vy);
					PlaneProfile ppShBLBatten(csVerticalBattens);
					ppShBLBatten.joinRing(plBLBatten, false);
					ppShBLBatten.subtractProfile(ppThisZone);
					if (nBack)
					{
						ppShBLBatten.subtractProfile(ppShSill);
					}
					
					//Extra sheet Top Right
					Point3d ptAuxBR = lnBottomZone.closestPointTo(ptRight);
					ptAuxBR = ptAuxBR - vx * dBattenWidth;
					LineSeg lsBRBatten(ptRight - vy * dBattenWidth, ptAuxBR);
					PLine plBRBatten(vzZone);
					plBRBatten.createRectangle(lsBRBatten, vx, vy);
					PlaneProfile ppShBRBatten(csVerticalBattens);
					ppShBRBatten.joinRing(plBRBatten, false);
					ppShBRBatten.subtractProfile(ppThisZone);
					if (nBack)
					{
						ppShBRBatten.subtractProfile(ppShSill);
					}
					
					PlaneProfile ppCleanup(ppShBRBatten.coordSys());
					{ 
						// get extents of profile
						LineSeg segL = ppShBLBatten.extentInDir(vx);
						LineSeg segR = ppShBRBatten.extentInDir(vx);
						
						Point3d pt1 = vy.dotProduct(segL.ptEnd() - segL.ptStart()) > 0 ? segL.ptStart() : segL.ptEnd();
						Point3d pt2 = vy.dotProduct(segR.ptEnd() - segR.ptStart()) > 0 ? segR.ptEnd() : segR.ptStart();
						PLine pl;
						pl.createRectangle(LineSeg(pt1, pt2), vx, vy);
						ppCleanup.joinRing(pl, _kAdd);
						ppCleanup.shrink(U(30));
						ppCleanup.vis(6);
					}
					
					// add gap at top and bottom
					PLine plGapTop;
					if(dGapTop>dEps)
					{ 
					// get extents of profile
						LineSeg seg = ppShBLBatten.extentInDir(vx);
						double dX = abs(vx.dotProduct(seg.ptStart()-seg.ptEnd()));
						double dY = abs(vy.dotProduct(seg.ptStart()-seg.ptEnd()));
						Point3d ptTopGap = vy.dotProduct(seg.ptEnd() - seg.ptStart()) > 0 ? seg.ptEnd() : seg.ptStart();
						//
						plGapTop.createRectangle(LineSeg(ptTopGap - vx * U(10e3)-vy*dGapTop, 
							ptTopGap + vx * 2 * U(10e3)+vy*U(1000)), vx, vy);
					}
					PLine plGapBottom;
					if(dGapBottom>dEps)
					{ 
					// get extents of profile
						LineSeg seg = ppShBLBatten.extentInDir(vx);
						double dX = abs(vx.dotProduct(seg.ptStart()-seg.ptEnd()));
						double dY = abs(vy.dotProduct(seg.ptStart()-seg.ptEnd()));
						Point3d ptBottomGap = vy.dotProduct(seg.ptEnd() - seg.ptStart()) > 0 ? seg.ptStart():seg.ptEnd();
						//
						plGapBottom.createRectangle(LineSeg(ptBottomGap - vx * U(10e3)+vy*dGapBottom, 
							ptBottomGap + vx * 2 * U(10e3)-vy*U(1000)), vx, vy);
					}
					
					// modify existing sheets
					for (int iSh=shAll.length()-1; iSh>=0 ; iSh--) 
					{ 
						Sheet shI=shAll[iSh];
						PlaneProfile ppSh = shI.profShape();
						if(ppSh.intersectWith(ppCleanup))
						{ 	if(dGapTop>dEps)
								shI.joinRing(plGapTop, _kSubtract);
							if(dGapBottom>dEps)
								shI.joinRing(plGapBottom, _kSubtract);
						}
					}//next iSh
					
					if(dGapTop>dEps)
						ppShBLBatten.joinRing(plGapTop, _kSubtract);
					if(dGapBottom>dEps)
						ppShBLBatten.joinRing(plGapBottom, _kSubtract);
					//reportNotice("\nBottomLeft Area: "+ppShBLBatten.area());
					
					if (ppShBLBatten.area() / U(1) * U(1) > U(3) * U(3))
					{
						//Bottom left jack
						//						reportNotice("Creating ppShBLBatten\n");
						Sheet shBL;
						shBL.dbCreate(ppShBLBatten, dBattenThickness, 1);
						shBL.setMaterial(sMaterial);
						shBL.setColor(nColor);
						shBL.assignToElementGroup(el, TRUE, nZone, 'Z');
						shAll.append(shBL);
					}
					
					
					//reportNotice("\nBottomRight Area: "+ppShBRBatten.area());
					if(dGapTop>dEps)
						ppShBRBatten.joinRing(plGapTop, _kSubtract);
					if(dGapBottom>dEps)
						ppShBRBatten.joinRing(plGapBottom, _kSubtract);
					if (ppShBRBatten.area() / U(1) * U(1) > U(3) * U(3))
					{
						//Bottom right jack
						//						reportNotice("Creating ppShBRBatten\n");
						Sheet shBR;
						shBR.dbCreate(ppShBRBatten, dBattenThickness, 1);
						shBR.setMaterial(sMaterial);
						shBR.setColor(nColor);
						shBR.assignToElementGroup(el, TRUE, nZone, 'Z');
						shAll.append(shBR);
					}
				}
			}
		}
		
		//CHECK THIS PART
		PlaneProfile ppSheetsCreated(plnZ);
		for (int s = 0; s < shCreated.length(); s++)
		{
			Sheet sh = shCreated[s];
			PlaneProfile ppThisSheet(plnZ);
			ppThisSheet = sh.realBody().shadowProfile(plnZ);
			ppSheetsCreated.unionWith(ppThisSheet);
		}
		
		Sheet shToErase[0];
		for (int i = 0; i < shAll.length(); i++)
		{
			
			PlaneProfile ppToCheck(plnZ);
			//if (shAll[i].volume()<U(2)) continue;
			
			ppToCheck = shAll[i].envelopeBody(false, false).shadowProfile(plnZ);
			PlaneProfile ppOriginal = ppToCheck;
			
			ppToCheck.intersectWith(ppSheetsCreated);
			
			double dArea = ppToCheck.area() / U(1) * U(1);
			if (dArea > U(2) * U(2))
			{
				
				ppOriginal.subtractProfile(ppSheetsCreated);
				//					reportNotice("Creating ppOriginal\n");
				ppOriginal.vis(1);
				if (ppOriginal.area() > U(2) * U(2))
				{
					Sheet sh;
					sh.dbCreate(ppOriginal, dBattenThickness, 1);
					sh.setMaterial(sMaterial);
					sh.setColor(nColor);
					sh.assignToElementGroup(el, TRUE, nZone, 'Z');
				}
				shToErase.append(shAll[i]);
			}
		}
		
		for (int i = 0; i < shToErase.length(); i++)
		{
			shToErase[i].dbErase();
		}
	}
}

if (_kExecuteKey == executeKey || _bOnElementConstructed)
{
	eraseInstance();
	return;
}

return;
#End
#BeginThumbnail














#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End