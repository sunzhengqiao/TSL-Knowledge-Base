#Version 8
#BeginDescription
Redistributes sheets that have been set to Vertical Sheets with the a property for minimum width

Modified by: Chirag Sawjani (chirag.sawjani@hsbcad.com)
Date: 16.10.2015: version 1.4





















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2012 by
*  hsbSOFT 
*  
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
* Create by: Chirag Sawjani (csawjani@itw-industry.com)
* date:04.07.2012
* version 1.0: Release Version
*
* Modified by: Chirag Sawjani (csawjani@itw-industry.com)
* date:12.10.2012
* version 1.1: Ignored areas where the union of the profile is not possible and also leave those sheets without erasing
*
* Modified by: Chirag Sawjani (csawjani@itw-industry.com)
* date:15.10.2012
* version 1.2: Bugfix on sheet split near centre point of beam
*
* Modified by: Chirag Sawjani (chirag.sawjani@hsbcad.com)
* Date: 16.10.2015
* version 1.4: Added openings into consideration when sheeting is generated through an opening
*/

_ThisInst.setSequenceNumber(-110);

//Unit(1,"mm"); // script uses mm

int nValidZones[]={1,2,3,4,5,6,7,8,9,10};
int nRealZones[]={1,2,3,4,5,-1,-2,-3,-4,-5};
PropString psZones(0, "1;2", T("Zones to Redistribute the Sheets"));
psZones.setDescription(T("Please type the number of the zones separate by ; (1-10)"));

PropDouble pdMinimumWidthHorizontal(0,100,"Enter a minimum width of sheeting for horizontal distribution");
PropDouble pdMinimumWidthVertical(1,0,"Enter a minimum width of sheeting for vertical distribution");

// filter sheets with material
PropString sMaterialsToIgnore(2,"",T("Materials to ignore"));
sMaterialsToIgnore.setDescription(T("Fill the Materials of the sheets that need to be ignored, use ; to separate them"));
String sMaterials = sMaterialsToIgnore+ ";";

String arSMaterials[0];
int nIndex = 0; 
int sIndex = 0;
while(sIndex < sMaterials .length()-1)
{
	String sToken = sMaterials.token(nIndex);
	nIndex++;
	if(sToken.length()==0)
	{
		sIndex++;
		continue;
	}
	sIndex = sMaterials.find(sToken,0);
	
	arSMaterials.append(sToken.makeUpper());
}

int nBmJacks[0];
//int nBmTypeTop[0];
//nBmTypeBottom.append(_kBrace);
nBmJacks.append(_kSFJackUnderOpening);
nBmJacks.append(_kSFJackOverOpening);
//nBmTypeBottom.append(_kSill);


if (_bOnDbCreated) {
	setPropValuesFromCatalog(_kExecuteKey);
}

if(_bOnInsert)
{
	if (_kExecuteKey=="") {showDialogOnce();}
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
	double dWallDepth=el.dBeamWidth();
	_Pt0=csEl.ptOrg();
	
	//Get all the vertical beams in the element except jacks
	Beam bmAll[]=el.beam();
	Beam bmHor[]=vy.filterBeamsPerpendicularSort(bmAll);
	Beam bmVert[]=vx.filterBeamsPerpendicularSort(bmAll);
	Beam bmVerticals[0];
	Beam bmJacks[0];
	
	for (int i=0; i<bmVert.length(); i++)
	{
		int nBeamType=bmVert[i].type();
	
		if (nBmJacks.find(nBeamType, -1) != -1)
		{
			bmJacks.append(bmVert[i]);
		}
		else
		{
			//Also ignore the beam if its a flat stud
			if(bmVert[i].dD(vx)<bmVert[i].dD(vz))
			{
				bmVerticals.append(bmVert[i]);
			}
		}
	}
	
	Plane pln (csEl.ptOrg(), vz);
				
	//Remove any sheets from above/below the opening
	Opening opAll[]=el.opening();
		
	//Find all sheets coinciding with the opening's plane profile for each zone
	for(int z=0;z<nZones.length();z++)
	{
	
		PlaneProfile ppSheets(pln);
		int nZone=nZones[z];
		Sheet shElementSheets[]=el.sheet(nZone);
		Sheet shAll[0];
		
		//Exclude any sheets that are in the exclusion list
		for(int s=0;s<shElementSheets.length();s++)
		{
			Sheet shCurr=shElementSheets[s];
			String sSheetMaterial=shCurr.material().makeUpper();
			if( arSMaterials.find(sSheetMaterial) == -1 )
			{
				shAll.append(shCurr);
			}
		}
		
		//Check Sheet sizes and tolerance from element for particular zone
		ElemZone ez=el.zone(nZone);

	
		//Ensure it is a vertical distribution else dont do anything
		String sDistribution=ez.distribution();

		if(sDistribution!="Vertical Sheets") continue;
		//Collect zone information
		double dSheetW=ez.dVar("width");
		double dSheetH=ez.dVar("height sheet");
		double dSheetTol=ez.dVar("gap");
		double dVertSheetTol=ez.dVar("Vertical gap");
		if(dSheetTol==0)dSheetTol=0.0001;
		if(dVertSheetTol==0)dVertSheetTol=0.0001;
		double dSheetThickness=ez.dH();
		int nSheetColor=ez.color();
		String sSheetMaterial=ez.material();
		Point3d ptZoneOrig=ez.ptOrg();
		
		//Find all the sheets that exist above/below opening except if the opening is set to to be ignored
		Sheet shNoOpenings[0];
		shNoOpenings=shAll;
		PlaneProfile ppOpeningsNotIgnored[0];
		
		for (int o=0; o<opAll.length(); o++)
		{
			Opening op=opAll[o];
			OpeningSF opSF=(OpeningSF )op;
			if (!opSF.bIsValid()) continue;

			String sContinueSheeting=opSF.continueSheeting();
			//Check if we have to frame through the opening
			int nZonesToIgnore[0];

			//Check if the opening has been marked to ignore framing the sheets around the opening
			String sIgnoreZones=sContinueSheeting;
			sIgnoreZones.trimLeft();
			sIgnoreZones.trimRight();
			sIgnoreZones+=";";
			for (int i=0; i<sIgnoreZones.length(); i++)
			{
				String str=sIgnoreZones.token(i);
				str.trimLeft();
				str.trimRight();
				if (str.length()>0)
				{
					int nIndex=nValidZones.find(str.atoi());
					if(nIndex!=-1)
					{
				  		nZonesToIgnore.append(nRealZones[nIndex]);
					}
				}
			}
			
			PLine plOp=op.plShape();
			PlaneProfile ppOp(csEl);
			ppOp.joinRing(plOp, FALSE);
			LineSeg ls=ppOp.extentInDir(vx);
			double dGapSideOp=opSF.dGapSide();
			Point3d ptCenOp=ls.ptMid();
			Point3d ptLeftOp=ls.ptStart()-(dGapSideOp*vx);
			Point3d ptRightOp=ls.ptEnd()+(dGapSideOp*vx);
			PLine plExtendOp;
			LineSeg lsExtendOp(ptLeftOp-(U(10000)*vy),ptRightOp+(U(10000)*vy));
			plExtendOp.createRectangle(lsExtendOp,vx,vy);
			PlaneProfile ppExOp(plExtendOp);
			
			if(nZonesToIgnore.find(nZone, -1)!=-1)
			{
				//The sheets in front of this opening need to be considered for splitting so we move on 
				//to the next opening i.e. we do not remove sheets that pertain to this opening
				ppOpeningsNotIgnored.append(ppExOp);
				continue;
			}

			
			for (int i=0; i<shAll.length(); i++)
			{
				Sheet sh=shAll[i];
				
				//Beam bm=bmToCheckBottom[i];
				PlaneProfile ppSh(csEl);
				ppSh=sh.realBody().shadowProfile(pln);
				double dArea=ppSh.area();
				dArea=dArea/(U(1)*U(1));
				int nResult=ppSh.intersectWith(ppExOp);
				
				if (nResult)
				{
					double dAreaResult=ppSh.area();
					dAreaResult=dAreaResult/(U(1)*U(1));
					if (dAreaResult>(dArea*.1))
					{
						//Remove Intersecting sheets
						int nFound=shNoOpenings.find(sh);
						shNoOpenings.removeAt(nFound);
					}
				}
			}
		}

		//Add sheets to the single planeprofile				
		for(int s=0;s<shNoOpenings.length();s++)
		{
			
			Sheet sh=shNoOpenings[s];
			sh.coordSys().vis();
			PlaneProfile ppSh(pln);
			ppSh=sh.realBody().shadowProfile(pln);

			//ppSh.vis(2);
			ppSh.shrink(U(-10));		
			int nResult=ppSheets.unionWith(ppSh);
			//ppSheets.vis(1);
			if(nResult) 
			{
				sh.dbErase();
			}
			else
			{
				reportMessage("\nError extracting shape in wall "+ el.number());
			}
			//ppSh.vis(1);
			nErase=true;
		}
		
		//Merge any sheets which may have tolerances
	
		ppSheets.shrink(U(10));
		//ppSheets.vis(5);
		
		PLine plRings[]=ppSheets.allRings();

		//Go through each ring to find all the various split points
		for(int r=0;r<plRings.length();r++)
		{
			PLine pl=plRings[r];
			Plane plZone(ptZoneOrig, vz);
			PlaneProfile pp(plZone);
			pp.joinRing(pl,false);	
			LineSeg ls=pp.extentInDir(vx);
			Vector3d vecSeg=ls.ptEnd()-ls.ptStart();

			//Get the width and height of the segment
			double dSegWidth=abs(vx.dotProduct(vecSeg));
			double dSegHeight=abs(vy.dotProduct(vecSeg));
	
			
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
			
			//Check distance remaining within segment
			Point3d ptElMid=csEl.ptOrg()-(dWallDepth*0.50)*vz;
			Plane plMid(ptElMid,vz);
			Plane plMidY(ls.ptMid(),vy);
			double dDistanceCheck=dSegWidth;
			int nLoops=0;
			Point3d ptSplits[0];
			Point3d ptTempShEnd;

			while((dDistanceCheck-dSheetWNew)>U(0.01) && nLoops<50)
			{
				int bmAuxPosition=0;
				//Using horizontal distribution create sheeting
				//Find a point to the maximum height of the sheet
				
				if(nLoops==0)
				{
	
					ptTempShEnd=ls.ptStart()+(dSheetWNew*vx);
					ptTempShEnd=ptTempShEnd.projectPoint(plMidY,0);
				}
				else
				{
					ptTempShEnd=ptTempShEnd+(dSheetWNew*vx);
					ptTempShEnd=ptTempShEnd.projectPoint(plMidY,0);
				}
				//ptTempShEnd.vis(1);
				
				//Project point to centre of element
				Point3d ptProjected=ptTempShEnd.projectPoint(plMid,0);
				ptProjected.vis();
				
				//Does the point lie within an opening that has the sheeting running throuhg
				int bUseJacks=false;
				for(int p=0; p < ppOpeningsNotIgnored.length();p++)
				{
					PlaneProfile ppOpening=ppOpeningsNotIgnored[p];
					if(ppOpening.pointInProfile(ptProjected)==_kPointOutsideProfile)
					{
						continue;
					}
					bUseJacks = true;
				}
								
				//Check if there are any beams to work with
				Beam beamsToDetermineSplits[0];
				if(bUseJacks)
				{
					beamsToDetermineSplits = bmJacks;
				}
				else
				{
					beamsToDetermineSplits = bmVerticals;
				}
				
				if(beamsToDetermineSplits.length()>0)
				{
					Beam bmAux[0];
					
					if(bUseJacks) 
					{
						Beam sortedBeams[] = (-vx).filterBeamsPerpendicularSort(beamsToDetermineSplits);
						int indexOfBeamsForHalfLine=-1;
						for(int b=0;b<sortedBeams.length();b++)
						{
							Beam bm=sortedBeams[b];
							if(-vx.dotProduct(bm.ptCen() - ptProjected) < U(-0.01))
							{
								continue;
							}
							indexOfBeamsForHalfLine = b;
							break;
						}
						
						if(indexOfBeamsForHalfLine!=-1)
						{
							for(int b = indexOfBeamsForHalfLine; b < sortedBeams.length(); b++)
							{
								bmAux.append(sortedBeams[b]);
							}
						}
					}
					else
					{
						bmAux=Beam().filterBeamsHalfLineIntersectSort(beamsToDetermineSplits, ptProjected,-vx) ;
					}

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
							
							if(dDistToSheetSplit>U(0.01))
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
											
		
						Point3d ptBmCen=bmSheetSplit.ptCen();
						ptTempShEnd=ptBmCen;
						dDistanceCheck=abs(vx.dotProduct(ls.ptEnd()-ptBmCen));
						
						//Check if the minimum sheet width criteria is being fulfilled
						if((dDistanceCheck-pdMinimumWidthHorizontal)<U(0.01))
						{
							//The current position is giving us a result which is less than the minimum width so move to the next position
							bmAuxPosition++;
							int nInnerLoop=0;

							while((dDistanceCheck-pdMinimumWidthHorizontal)<U(0.01) && nInnerLoop<20)
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
						ptBmCen=ptBmCen.projectPoint(plMidY,0);
						ptSplits.append(ptBmCen);
						ptBmCen.vis(2);
						//reportNotice("\n"+dDistanceCheck);
					}
				}
				else if(bUseJacks)
				{
					//No jacks to work with so split at the projected point
					dDistanceCheck=abs(vx.dotProduct(ls.ptEnd()-ptProjected));
					ptSplits.append(ptProjected);
				}
				else
				{
					Line lnMidProfile(ls.ptMid(),vx);
					dDistanceCheck=abs(vx.dotProduct(ls.ptEnd()-ptTempShEnd));
					Point3d ptSplitPoint=lnMidProfile.closestPointTo(ptTempShEnd);
					if((dDistanceCheck-pdMinimumWidthHorizontal)>U(0.01))
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
			
			while((dVertDistanceCheck-dSheetHNew)>U(0.01) && nLoopsV<50)
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
				Point3d ptProjected=ptTempShEndVert.projectPoint(plMid,0);
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
			sh.setMaterial(sSheetMaterial);
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
					//shT.dbSplit(pl,0);
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