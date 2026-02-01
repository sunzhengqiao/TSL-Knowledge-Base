#Version 8
#BeginDescription
#Versions:
1.21 27.02.2023 HSB-18011: get sheet properties from sheets that are deleted
1.20 28.06.2022 HSB-15869: set name, material and beamcode of the newly created sheet
1.19 10/01/2022 Add option to combine openings Author: Robert Pol

Distributes the sheet above and below openings depending on width and height of available sheets.







#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 21
#KeyWords 
#BeginContents
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
* # Versions:
* Create by: Chirag Sawjani (csawjani@itw-industry.com)
* date: 20-05-2011
* version 1.0: Release Version
*
* Updated by: Chirag Sawjani (csawjani@itw-industry.com)
* date: 17.06.2011
* version 1.1: Variable bugfix
*
* Updated by: Chirag Sawjani (csawjani@itw-industry.com)
* date: 17.06.2011
* version 1.2: Moved planeprofile to cater for variuos positions of Element Zones.
*
* Updated by: Chirag Sawjani (csawjani@itw-industry.com)
* date: 18.08.2011
* version 1.3: Edge of sheet point redefinition bugfix. Added Property for minimum sheets size.
*
* Updated by: Chirag Sawjani (csawjani@itw-industry.com)
* date: 16.03.2011
* version 1.4: Minimum sheet for no jacks now adhered to
*
* Updated by: Chirag Sawjani (csawjani@itw-industry.com)
* date: 28.03.2011
* version 1.5: Vertical sheet distribution fix and Horizontal sheet splits added
*
* Updated by: Chirag Sawjani (csawjani@itw-industry.com)
* date: 05.04.2011
* version 1.6: Bugfix split tolerance and Splits adjusted
*
* Updated by: Chirag Sawjani (csawjani@itw-industry.com)
* date: 26.04.2012
* version 1.7: Bugfix split tolerance and Splits adjusted
*
* Updated by: Chirag Sawjani (csawjani@itw-industry.com)
* date: 01.05.2012
* version 1.8: Added a new shrink to ppOpEx when checking the sheets that exist above/below opening as previous version introduced a new shrink to the sheets
*
* Updated by: Chirag Sawjani (csawjani@itw-industry.com)
* date: 04.07.2012
* version 1.9: Added property for vertical tolerance and fixed tolerance issues with sheets equaling size of segments
*
* Updated by: Chirag Sawjani (csawjani@itw-industry.com)
* date: 17.09.2012
* version 1.10: Bugfix
*
* Updated by: Chirag Sawjani (csawjani@itw-industry.com)
* date: 18.10.2012
* version 1.11: Bugfix for points lying within a beam
*
* Updated by: Chirag Sawjani (csawjani@itw-industry.com)
* date: 18.10.2012
* version 1.12: Check on union of plane profiles and erasing sheets
*
* date: 13.11.2012
* version 1.13: Add the nErase option because TSL didnt delete when it as insert manualy
*
* date: 08.01.2013
* version 1.14: Locked the TSL to use Vertical Sheet distribution only
*
* date: 06.03.2013
* version 1.15: Fix issue when there was an opening detail that cut back the side of the opening so it wanst finding any sheet.
*/
//#Versions
// 1.21 27.02.2023 HSB-18011: get sheet properties from sheets that are deleted Author: Marsel Nakuci
// 1.20 28.06.2022 HSB-15869: set name, material and beamcode of the newly created sheet Author: Marsel Nakuci
//1.19 10/01/2022 Add option to combine openings Author: Robert Pol
_ThisInst.setSequenceNumber(-80);

Unit(1,"mm"); // script uses mm
double d0_01mm = U(0.01, 0.0003937008);
double d1mm = U(1, 0.0393701);
double d5mm = U(5, 0.19685);
double d10mm = U(10, 0.393701);
double d20mm = U(-20, -0.787402);
double d10000mm = U(10000, 393.7008);
			
int nValidZones[]={1,2,3,4,5,6,7,8,9,10};
int nRealZones[]={1,2,3,4,5,-1,-2,-3,-4,-5};
PropString psZones(0, "1;2", T("Zones to Redistribute the Sheets"));
psZones.setDescription(T("Please type the number of the zones separate by ; (1-10)"));

PropDouble pdMinimumWidthHorizontal(0,100,"Enter a minimum width of sheeting for horizontal distribution");
PropDouble pdMinimumWidthVertical(1,0,"Enter a minimum width of sheeting for vertical distribution");

int nBmTypeBottom[0];
int nBmTypeTop[0];
//nBmTypeBottom.append(_kBrace);
nBmTypeBottom.append(_kSFJackUnderOpening);
nBmTypeTop.append(_kSFJackOverOpening);
//nBmTypeBottom.append(_kSill);


if (_bOnDbCreated) {
	setPropValuesFromCatalog(_kExecuteKey);
}

if(_bOnInsert)
{
	if (_kExecuteKey=="") {showDialog();}
	if (insertCycleCount()>1) { eraseInstance(); return; }
	
	PrEntity ssE("\n"+T("Select a set of elements"),Element());
		
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	return;
}

if (_Element.length()==0)
{
	eraseInstance();
	return;
}

int nErase=FALSE;
int nZones[0];

//Fill the values for the externall Walls
String sZones=psZones;
sZones.trimLeft();
sZones.trimRight();
sZones=sZones+";";
for (int i=0; i<sZones.length(); i++)
{
String str=sZones.token(i);
	str.trimLeft();
	str.trimRight();
	if (str.length()>0)
	{
		int nIndex=nValidZones.find(str.atoi());
		if(nIndex!=-1)
		{
	  		nZones.append(nRealZones[nIndex]);
		}
	}
}

for (int e=0; e<_Element.length(); e++)
{
	Element el=_Element[e];
	
	CoordSys csEl = el.coordSys();
	Vector3d vx = csEl.vecX();
	Vector3d vy = csEl.vecY();
	Vector3d vz = csEl.vecZ();
	_Pt0=csEl.ptOrg();
	
	//Get all the jacks that exist in the element
	Beam bmAll[]=el.beam();
	
	if (bmAll.length()<1) continue;
	
	Beam bmHor[]=vy.filterBeamsPerpendicularSort(bmAll);
	Beam bmToCheckBottom[0];
	Beam bmToCheckTop[0];
		
	for (int i=0; i<bmAll.length(); i++)
	{
		int nBeamType=bmAll[i].type();
		if (nBmTypeBottom.find(nBeamType, -1) != -1)
		{
			bmToCheckBottom.append(bmAll[i]);
		}else if (nBmTypeTop.find(nBeamType, -1) != -1)
		{
			bmToCheckTop.append(bmAll[i]);
		}
	}
	
	Plane pln (csEl.ptOrg(), vz);
	
	nErase=true;
	
	Opening opAll[]=el.opening();
	Opening usedOpenings[0]; 
	for (int o=0; o<opAll.length(); o++)
	{
		Opening op=opAll[o];
		OpeningSF opSF=(OpeningSF )op;
		if (!opSF.bIsValid()) continue;
		if (usedOpenings.find(opSF) != -1) continue;
		PLine plOp=op.plShape();
		PlaneProfile ppOp(csEl);
		ppOp.joinRing(plOp, FALSE);
		ppOp.shrink(-U(10));
		for (int op = 0; op < opAll.length(); op++)
		{
			Opening otherOpening = opAll[op];
			PlaneProfile otherOpeningProfile(otherOpening.plShape());
			PlaneProfile auxProfile = ppOp;
			
			otherOpeningProfile.shrink(-U(10));
			if ( ! auxProfile.intersectWith(otherOpeningProfile) || otherOpening == opSF) continue;
			ppOp.unionWith(otherOpeningProfile);
			usedOpenings.append(otherOpening);
		}
		ppOp.shrink(U(10));
		LineSeg ls=ppOp.extentInDir(vx);
		double dGapSideOp=opSF.dGapSide();
		Point3d ptCenOp=ls.ptMid();
		Point3d ptLeftOp=ls.ptStart()-(dGapSideOp*vx);
		Point3d ptRightOp=ls.ptEnd()+(dGapSideOp*vx);
		PLine plExtendOp;
		LineSeg lsExtendOp(ptLeftOp-(d10000mm*vy),ptRightOp+(d10000mm*vy));
		plExtendOp.createRectangle(lsExtendOp,vx,vy);
		PlaneProfile ppExOp(plExtendOp);
		
		//Add to plane profile the gap of the opening on both left and right
		
		//ppExOp.vis();

		//Find all the Jacks that exist above/below opening
		Point3d ptCenterBelow;
		Point3d ptCenterAbove;
		Beam bmJacksBelowOpening[0];
		Beam bmJacksAboveOpening[0];

		for (int i=0; i<bmToCheckBottom.length(); i++)
		{
			Beam bm=bmToCheckBottom[i];
			PlaneProfile ppBm(csEl);
			ppBm=bm.realBody().shadowProfile(pln);
			double dArea=ppBm.area();
			dArea=dArea/(d1mm*d1mm);
			int nResult=ppBm.intersectWith(ppExOp);
			
			if (nResult)
			{
				double dAreaResult=ppBm.area();
				dAreaResult=dAreaResult/(d1mm*d1mm);
				if (dAreaResult>(dArea*.1))
				{
					ptCenterBelow=bm.ptCen();
					bmJacksBelowOpening.append(bm);
				}
			}
		}
		
		for (int i=0; i<bmToCheckTop.length(); i++)
		{
			Beam bm=bmToCheckTop[i];
			PlaneProfile ppBm(csEl);
			ppBm=bm.realBody().shadowProfile(pln);
			double dArea=ppBm.area();
			dArea=dArea/(d1mm*d1mm);
			int nResult=ppBm.intersectWith(ppExOp);
			
			if (nResult)
			{
				double dAreaResult=ppBm.area();
				dAreaResult=dAreaResult/(d1mm*d1mm);
				if (dAreaResult>(dArea*.1))
				{
					bmJacksAboveOpening.append(bm);
					ptCenterAbove=bm.ptCen();
				}
			}
		}

		
		//Find all sheets coinciding with the opening's plane profile for each zone
		for(int z=0;z<nZones.length();z++)
		{
			PlaneProfile ppOpSheets(csEl);
			int nZone=nZones[z];
			Sheet shAll[]=el.sheet(nZone);
			if(shAll.length()==0)continue;
			Sheet shMuster = shAll[0];
			String sSheetMat = shMuster.material();
		// HSB-15869
			String sSheetName = shMuster.name();
			String sSheetCode = shMuster.beamCode();
//			int nSheetColor = shMuster.color();
			//Check Sheet sizes and tolerance from element for particular zone
			ElemZone ez=el.zone(nZone);
			String sDistribution=ez.distribution();
			//Ensure the TSL only works on vertical sheets and no other type of distribution
			if(sDistribution!=T("Vertical Sheets")) continue;
//			reportNotice("\n"+nZone+" "+sDistribution);
			double dSheetW=ez.dVar("width");
			if (dSheetW - U(0.01, 0.01) < 0) dSheetW = U(12000, 120);
			double dSheetH=ez.dVar("height sheet");
			if (dSheetH - U(0.01, 0.01) < 0) dSheetH = U(12000, 120);
			double dSheetTol=ez.dVar("gap");
			double dVertSheetTol=ez.dVar("Vertical gap");
			if(dSheetTol==0)dSheetTol=0.0001;
			if(dVertSheetTol==0)dVertSheetTol=0.0001;
			double dSheetThickness=ez.dH();
			int nSheetColor=ez.color();
			String sSheetMaterial=ez.material();
			Point3d ptZoneOrig=ez.ptOrg();

			ppExOp.shrink(d20mm);
			for(int s=0;s<shAll.length();s++)
			{
				
				Sheet sh=shAll[s];
				PlaneProfile ppSh(csEl);
				ppSh=sh.realBody().shadowProfile(pln);
				ppSh.shrink(-d10mm);	

				//ppSh.vis(1);
				double dArea=ppSh.area();
				dArea=dArea/(d1mm*d1mm);
				int nResult=ppSh.intersectWith(ppExOp);
				
				if(nResult)
				{
					double dAreaResult=ppSh.area();
					
					dAreaResult=dAreaResult/(d1mm*d1mm);
					
					if (abs(dAreaResult-dArea)<d5mm*d5mm)
					{
						int nUnion=ppOpSheets.unionWith(ppSh);
						if(nUnion)
						{
							sSheetMat=sh.material();
							sSheetName=sh.name();
							sSheetCode=sh.beamCode();
							sh.dbErase();
						}
					}
					
				}
			}
			ppExOp.shrink(d20mm);
			ppOpSheets.shrink(d10mm);
			ppOpSheets.vis(5);
			
			PLine plRings[]=ppOpSheets.allRings();

			for(int r=0;r<plRings.length();r++)
			{
				PLine pl=plRings[r];
				Plane plZone(ptZoneOrig, vz);
				PlaneProfile pp(plZone);
				pp.joinRing(pl,false);	
				LineSeg ls=pp.extentInDir(vx);
				Vector3d vecSeg=ls.ptEnd()-ls.ptStart();
				pp.vis();
								
				//Check if ring is above or below the opening
				Vector3d vecAux=ls.ptStart()-ptCenOp;
				double nResult=vy.dotProduct(vecAux);
				int nRingBelow=true;
				if(nResult>0)
				{
					nRingBelow=false;
				}
				
				//Get the width and height of the segment
				double dSegWidth=vecSeg.dotProduct(vx);
				double dSegHeight=vecSeg.dotProduct(vy);
				
				//Compare with the Width and Height of the sheet defined in the element
				//If the height of the segment is greater than the sheet width defined, then horizontal distribution is not possible
				int nFullSheetProfile=true;
				
				//Check if vertical distribution will be required instead of horizontal
				double dSheetHNew;
				double dSheetWNew;
				if(dSheetW>dSegHeight)
				{
					dSheetHNew=dSheetW;
					dSheetWNew=dSheetH;
					
					//Rotate the coordinate system for horizontal creation of sheets
					CoordSys csRotation=csEl;
					csRotation.setToRotation(-90,vz,csEl.ptOrg());
				
					CoordSys csRingNew=csEl;
					csRingNew.transformBy(csRotation);
					pp=PlaneProfile(csRingNew);
					pp.joinRing(pl,false);	
					
				}
				else
				{
					dSheetHNew=dSheetH;
					dSheetWNew=dSheetW;
				}
				
				//Get Beams to use based on whether ring is below or above
				Line lnJacks;
				Beam bmJacks[0];
				if(nRingBelow)
				{
					bmJacks.append(bmJacksBelowOpening);					
					lnJacks=Line(ptCenterBelow,vx);
				}
				else
				{
					bmJacks.append(bmJacksAboveOpening);
					lnJacks=Line(ptCenterAbove,vx);
				}

				//Check distance remaining within segment
				double dDistanceCheck=dSegWidth;
				int nLoops=0;
				Point3d ptSplits[0];
				Point3d ptTempShEnd;

				while((dDistanceCheck-dSheetWNew)>d0_01mm && nLoops<100)
				{
					//Using horizontal distribution create sheeting
					//Find a point to the maximum height of the sheet
					
					if(nLoops==0)
					{
						ptTempShEnd=ls.ptStart()+(dSheetWNew*vx);
					}
					else
					{
						ptTempShEnd=ptTempShEnd+(dSheetWNew*vx);
					}
					//ptTempShEnd.vis(1);
					
					//Project point to centre of wall
					Point3d ptProjected=lnJacks.closestPointTo(ptTempShEnd);
					ptProjected.vis();

					//Check if there are any jacks to work with
					Beam bmAux[0];
					if(bmJacks.length()>0)
					{
						int bmAuxPosition=0;
						Beam bmAuxTemp[]=Beam().filterBeamsHalfLineIntersectSort(bmJacks, ptProjected,-vx);
						bmAux=(-vx).filterBeamsPerpendicularSort(bmAuxTemp);
						if(bmAux.length()>0)
						{
							Beam bmSheetSplit=bmAux[0];
							bmSheetSplit.realBody().vis();
							Plane plProjected(ptProjected,vz);
							PlaneProfile ppBmSheetSplit=bmSheetSplit.realBody().shadowProfile(plProjected);
							//Need to check where the projected point lies as it could be inside a beam and past or on the centre point of the beam
							if(ppBmSheetSplit.pointInProfile(ptProjected)!=_kPointOutsideProfile)
							{
								Vector3d vecDistanceToSheetSplit=bmSheetSplit.ptCen()-ptProjected;
								double dDistToSheetSplit=vecDistanceToSheetSplit.dotProduct(vx);
								//reportNotice("\n"+dDistToSheetSplit);
								
								if(dDistToSheetSplit>d0_01mm)
								{
									if(bmAux.length()>1)
									{
										//Check if new beam found is the same as the previous beam
										if(bmSheetSplit.handle()!=bmAux[1].handle())
										{
											bmSheetSplit=bmAux[1];
											bmAuxPosition+=1;
										}
									}
								}
							}
					

							/*
							//Need to move the point back to avoid cases where the sheeting is on the edge of a beam or just into it
							double dBeamSplitWidth=bmSheetSplit.dD(vx);
							
							Point3d ptProjectCheck=ptProjected-vx*(dBeamSplitWidth*0.5)-vx*(dSheetTol*0.5);
							
							Beam bmAux1[]=Beam().filterBeamsHalfLineIntersectSort(bmAux, ptProjectCheck,-vx);
							if(bmAux1.length()>0)
							{
								//Check if new beam found is the same as the previous beam
								if(bmSheetSplit.handle()!=bmAux1[0].handle())
								{
									bmSheetSplit=bmAux1[0];
								}
							}
							*/
							
							
							
							Point3d ptBmCen=bmSheetSplit.ptCen();
							ptTempShEnd=ptBmCen;
							dDistanceCheck=abs(vx.dotProduct(ls.ptEnd()-ptBmCen));
							//Check if the minimum sheet width criteria is being fulfilled
							if((dDistanceCheck-pdMinimumWidthHorizontal)<d0_01mm)
							{
								//The current position is giving us a result which is less than the minimum width so move to the next position
								bmAuxPosition++;
								int nInnerLoop=0;
	
								while((dDistanceCheck-pdMinimumWidthHorizontal)<d0_01mm && nInnerLoop<100)
								{
									//Move to the next beam and try to split there
									if(bmAux.length()>bmAuxPosition)
									{
											Beam bmProposedSplit=bmAux[bmAuxPosition];
											Point3d ptProposedPoint=bmProposedSplit.ptCen();
											ptBmCen=ptProposedPoint;
											ptTempShEnd=ptBmCen;
											dDistanceCheck=abs(vx.dotProduct(ls.ptEnd()-ptBmCen));
											bmAuxPosition++;
											nInnerLoop++;
									}
									else
									{
										//no more beams to split on
										break;
									}
								}
							}

							ptSplits.append(ptBmCen);
							//reportNotice("\n"+dDistanceCheck);
						}
					}
					else
					{
						Line lnMidProfile(ls.ptMid(),vx);
						dDistanceCheck=abs(vx.dotProduct(ls.ptEnd()-ptTempShEnd));
						Point3d ptSplitPoint=lnMidProfile.closestPointTo(ptTempShEnd);
						if((dDistanceCheck-pdMinimumWidthHorizontal)<d0_01mm)
						{
							double dSetBack=pdMinimumWidthHorizontal-dDistanceCheck;
							ptSplitPoint-=dSetBack*vx;
							dDistanceCheck=abs(vx.dotProduct(ls.ptEnd()-ptSplitPoint));
						}		

												
						ptSplits.append(ptSplitPoint);						
					}
					nLoops++;
				}
				
				//Get any horizontal splits that need to be done
				Point3d ptHorSplits[0];
				double dVertDistanceCheck=dSegHeight;
				int nLoopsV=0;
				Point3d ptTempShEndVert;							
				
				while((dVertDistanceCheck-dSheetHNew)>d0_01mm && nLoopsV<100)
				{
					//Find a point to the maximum height of the sheet
					if(nLoopsV==0)
					{
						ptTempShEndVert=ls.ptStart()+(dSheetHNew*vy);
					}
					else
					{
						ptTempShEndVert=ptTempShEndVert+(dSheetHNew*vy);
					}
					
					//Project point to centre of wall
					Point3d ptProjected=lnJacks.closestPointTo(ptTempShEndVert);
					ptProjected.vis();	
					
					Line lnMidProfile(ls.ptMid(),vy);
					dVertDistanceCheck=abs(vy.dotProduct(ls.ptEnd()-ptTempShEndVert));
					Point3d ptSplitPoint=lnMidProfile.closestPointTo(ptTempShEndVert);
					if(pdMinimumWidthVertical!=0 && dVertDistanceCheck<pdMinimumWidthVertical)
					{
						double dSetBack=pdMinimumWidthVertical-dVertDistanceCheck;
						ptSplitPoint-=dSetBack*vy;
						dVertDistanceCheck=abs(vy.dotProduct(ls.ptEnd()-ptSplitPoint));
					}		

					ptSplitPoint.vis();
					ptHorSplits.append(ptSplitPoint);							
					nLoopsV++;
				}
				
				//Calculate translation vector for planeProile
				Vector3d vecAux1=ptZoneOrig-pp.coordSys().ptOrg();
				double dTranslationMagnitude=vecAux1.dotProduct(vz);
				Vector3d vecTranslation=vz*dTranslationMagnitude;
				pp.transformBy(vecTranslation);
				
				//Create Sheet and split based on array of split points
				Sheet sh;
				Sheet shTemp[0];
				Sheet shNewSheets[0];
			
				if(nZone<0)
				{
					sh.dbCreate(pp,dSheetThickness,-1);
				}
				else
				{
					sh.dbCreate(pp,dSheetThickness,1);					
				}
				sh.realBody().vis(1);
				sh.setColor(nSheetColor);
//				sh.setMaterial(sSheetMaterial);
				sh.setMaterial(sSheetMat);
			// HSB-15869
				sh.setName(sSheetName);
				sh.setBeamCode(sSheetCode);
				sh.assignToElementGroup(el,true,nZone,'Z');
				
				
				//Vertical Splits
				if(ptSplits.length()==0) shNewSheets.append(sh);
				for(int s=0;s<ptSplits.length();s++)
				{
					Point3d pt=ptSplits[s];
					pt.vis(5);
					Plane pl(pt,vx);
					if(s==0)
					{
						shTemp=sh.dbSplit(pl,dSheetTol);
						shTemp.append(sh);
						shNewSheets.append(shTemp);						
					}
					else
					//Check from second point onwards
					{
						for(int t=0;t<shTemp.length();t++)
						{
							Sheet shT=shTemp[t];
					
							PlaneProfile ppT(plZone);
							ppT=shT.realBody().shadowProfile(plZone);
							ppT.vis(5);
							if(ppT.pointInProfile(pt)==_kPointInProfile)
							{
								shTemp.setLength(0);
								shTemp=shT.dbSplit(pl,dSheetTol);
								shNewSheets.append(shTemp);
								shTemp.append(shT);
								continue;
							}
							
						}
					}
					for(int t=0;t<shTemp.length();t++)
					{
						
						shTemp[t].realBody().vis(2);
						shTemp[t].assignToElementGroup(el,true,nZone,'Z');
					}						
				}
				//Horizontal Splits
				for(int s=0;s<ptHorSplits.length();s++)
				{
					Point3d pt=ptHorSplits[s];
		
					//Move point up by half the distance of the tolerance so we can be left with a full board below (as per generation)
					if(s==0)
					{
						pt.transformBy(dVertSheetTol*0.5*vy);		
					}
					else
					{
						double dMovePoint=(dVertSheetTol*s)+(dVertSheetTol*0.5);
						pt.transformBy(dMovePoint*vy);		
					}
						
					pt.vis(5);
					Plane pl(pt,vy);
					for(int t=0;t<shNewSheets.length();t++)
					{
						Sheet shT=shNewSheets[t];
						shT.dbSplit(pl,dVertSheetTol);
					
					}
					
				}	
			}
		}
	}
}

if (_bOnElementConstructed || nErase)
{
	eraseInstance();
	return;
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
      <str nm="Comment" vl="HSB-18011: get sheet properties from sheets that are deleted" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="21" />
      <str nm="Date" vl="2/27/2023 1:04:35 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15869: set name, material and beamcode of the newly created sheet" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="20" />
      <str nm="Date" vl="6/28/2022 10:18:17 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add option to combine openings" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="19" />
      <str nm="Date" vl="1/10/2022 4:45:54 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End