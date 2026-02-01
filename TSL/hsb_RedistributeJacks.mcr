#Version 8
#BeginDescription
Redistributes Jacks under and above openings from Left, Centre & Right of the opening
1.12 27/02/2025 Change sequence number. AJ
1.11 22/08/2024 Add property for spacing. AJ

Last modified by: Chirag Sawjani (csawjani@itw-industry.com)
Date: 13.11.2012  -  version 1.10


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 12
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
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 12.01.2011
* version 1.0: Release Version
*
* date: 13.01.2011
* version 1.1: Change Jacks Distribution
*
* date: 18.01.2011
* version 1.3: Analise if the top beam it's not cover by a flat beam on top of the panel
*
* date: 09.02.2011
* version 1.4: Fix issue witn module information not going to some of the Jacks
*
* date: 04.04.2011
* version 1.5: Added functionality for distributing from left, right and centre
*
* date: 04.04.2011
* version 1.6: Extra Jacks Bugfix when size is set to 0
*
* date: 23.08.2011
* version 1.7: Added check for beam array
*
* date: 06.02.2012
* version 1.8: Bugfix issue when there was a packer overlaping the header
*
* date: 16.02.2012
* version 1.9: Bugfix with the tolerance around the openings
*
* date: 13.11.2012
* version 1.10: Remove blocking that could be between jacks
*/

_ThisInst.setSequenceNumber(-90);

Unit(1,"mm"); // script uses mm

String sJackDistribution[]={"From Left", "Even","From Right"};
PropString sDistribution(0,sJackDistribution,"Select Distribution");
int nDistribution=sJackDistribution.find(sDistribution,0);

PropDouble dNewSpacing(0, 0, T("Spacing"));
dNewSpacing.setDescription(T("Spacing between jacks. If set to 0 the wall spacing will be used."));

int nBmTypeBottom[0];
int nBmTypeTop[0];
//nBmTypeBottom.append(_kBrace);
nBmTypeBottom.append(_kSFJackUnderOpening);
nBmTypeTop.append(_kSFJackOverOpening);
//nBmTypeBottom.append(_kSill);

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if(_bOnInsert)
{
	if(_kExecuteKey==""){ showDialogOnce();}
	
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

for (int e=0; e<_Element.length(); e++)
{
	Element el=_Element[e];
	
	CoordSys csEl = el.coordSys();
	Vector3d vx = csEl.vecX();
	Vector3d vy = csEl.vecY();
	Vector3d vz = csEl.vecZ();
	_Pt0=csEl.ptOrg();
	
	Plane pln (csEl.ptOrg(), vz);
	
	Opening opAll[]=el.opening();
	Opening opWindows[0];
	
	for (int i=0; i<opAll.length(); i++)
	{
	//	if (opAll[i].openingType()==_kWindow || opAll[i].openingType()==_kOpening)
			opWindows.append(opAll[i]);
	}
	
	if (opWindows.length()<1)
		continue;
	
	Beam bmAll[]=el.beam();
	if(bmAll.length()==0)continue;
	
	Beam bmHor[]=vy.filterBeamsPerpendicularSort(bmAll);

	Beam bmToCheckBottom[0];
	Beam bmToCheckTop[0];
	Beam bmBlocking[0];
		
	for (int i=0; i<bmAll.length(); i++)
	{
		int nBeamType=bmAll[i].type();
		//Append all angle top and bottom planes into bmHor
		
		if (nBmTypeBottom.find(nBeamType, -1) != -1)
		{
			bmToCheckBottom.append(bmAll[i]);
		}
		else if (nBmTypeTop.find(nBeamType, -1) != -1)
		{
			bmToCheckTop.append(bmAll[i]);
		}
		else if(nBeamType==_kSFAngledTPLeft || nBeamType==_kSFAngledTPRight)
		{
			bmHor.append(bmAll[i]);
		}
		else if (nBeamType==_kSFBlocking)
		{
			bmBlocking.append(bmAll[i]);
		}
	}

	for (int i=0; i<bmHor.length(); i++)
	{
		if (bmHor[i].beamCode().token(0)=="H")
		{
			bmHor.removeAt(i);
			i--;
		}

	}
	
	PlaneProfile ppToCheck(pln);
	
	for (int i=0; i<bmHor.length(); i++)
	{
		PlaneProfile ppBm(pln);
		ppBm=bmHor[i].realBody().shadowProfile(pln);
		ppToCheck.unionWith(ppBm);
	}
	
	Sheet shAll[]=el.sheet();
	
	ElementWallSF elSF=(ElementWallSF)el;
	double dSpacing=elSF.spacingBeam();
	if (dNewSpacing>0)
		dSpacing = dNewSpacing;
	
	for (int o=0; o<opWindows.length(); o++)
	{
		Opening op=opWindows[o];
		PLine plOp=op.plShape();
		PlaneProfile ppOp(csEl);
		ppOp.joinRing(plOp, FALSE);
		LineSeg ls=ppOp.extentInDir(vx);
		
					
		//Find spacing from the element

		
		//Check if there is an extra jack at bottom and top
		OpeningSF opSF=(OpeningSF) op;
		int nExtraJackTop=opSF.bExtraBeamsTop();
		int nExtraJackBottom=opSF.bExtraBeamsBottom();
		double dExtraJackTop=opSF.dSideBeamTop();
		double dExtraJackBottom=opSF.dSideBeamBottom();
		double dGapSideOp=opSF.dGapSide();
		
		
		Point3d ptLeftOp=ls.ptStart()-(dGapSideOp*vx);
		Point3d ptRightOp=ls.ptEnd()+(dGapSideOp*vx);
		Point3d ptNewJacks[0];
		Point3d ptExtraJacks[0];
		
		PlaneProfile ppBottom;
		ppBottom=ppOp;
		ppBottom.transformBy(vy*U(-300));
		PlaneProfile ppTop;
		ppTop=ppOp;
		ppTop.transformBy(vy*U(300));

		ppOp.unionWith(ppBottom);
		ppOp.unionWith(ppTop);
		
		//Remove blocking that is above or below the openings
		LineSeg lsOpening(ptLeftOp-vy*U(5000), ptRightOp+vy*U(5000));
		PlaneProfile ppBigOpening(pln);
		PLine plOpeningRectangle(vz);
		plOpeningRectangle.createRectangle(lsOpening, vx, vy);
		ppBigOpening.joinRing(plOpeningRectangle, false);
		
		for (int k=0; k<bmBlocking.length(); k++)
		{
			PlaneProfile ppThisBeam(pln);
			ppThisBeam=bmBlocking[k].realBody().shadowProfile(pln);
			ppThisBeam.intersectWith(ppBigOpening);
			if ( ppThisBeam.area()/U(1)*U(1) > U(2)*U(2) )
			{
				bmBlocking[k].dbErase();
			}
		}
		
		
		//Remove the Existing Jacks and replace them with the new rules
		int nFlag=false;
		Point3d ptCenter;
		
		double dWidthJ;
		double dHeightJ;
		double dLengthJAbove=U(5);
		double dLengthJBelow=U(5);
		if(el.dBeamHeight()<el.dBeamWidth())
		{
			dWidthJ=el.dBeamHeight();
			dHeightJ=el.dBeamWidth();
		}
		else
		{
			dWidthJ=el.dBeamWidth();
			dHeightJ=el.dBeamHeight();
		}
		String sModule="";
		int nColor=32;
		
		int nFoundJacksBelowOpening=false;
		for (int i=0; i<bmToCheckBottom.length(); i++)
		{
			Beam bm=bmToCheckBottom[i];
			PlaneProfile ppBm(csEl);
			ppBm=bm.realBody().shadowProfile(pln);
			double dArea=ppBm.area();
			dArea=dArea/(U(1)*U(1));
			int nResult=ppBm.intersectWith(ppOp);
			
			if (nResult)
			{
				double dAreaResult=ppBm.area();
				dAreaResult=dAreaResult/(U(1)*U(1));
				if (dAreaResult>(dArea*.1))
				{
					ptCenter=bm.ptCen();
					dLengthJBelow=bm.solidLength();
					//dWidthJ=bm.dW();
					//dHeightJ=bm.dH();
					sModule=bm.module();
					nColor=bm.color();
					
					//Remove the blocking that was in contack with the existing Jaks
					//Beam bmBlockingToErase[]=bm.filterBeamsCapsuleIntersect(bmBlocking);
					//for (int k=0; k<bmBlockingToErase.length(); k++)
					//{
					//	bmBlockingToErase[k].dbErase();
					//}
					
					bm.dbErase();
					nFlag=true;
					nFoundJacksBelowOpening=true;
				}
			}
		}

		if(nFoundJacksBelowOpening==false)
		{
			for (int i=0; i<bmToCheckTop.length(); i++)
			{
				Beam bm=bmToCheckTop[i];
				PlaneProfile ppBm(csEl);
				ppBm=bm.realBody().shadowProfile(pln);
				double dArea=ppBm.area();
				dArea=dArea/(U(1)*U(1));
				int nResult=ppBm.intersectWith(ppOp);
				
				if (nResult)
				{
					double dAreaResult=ppBm.area();
					dAreaResult=dAreaResult/(U(1)*U(1));
					if (dAreaResult>(dArea*.1))
					{
						ptCenter=bm.ptCen();
						dLengthJAbove=bm.solidLength();
						//dWidthJ=bm.dW();
						//dHeightJ=bm.dH();
						sModule=bm.module();
						nColor=bm.color();
						nFlag=true;
					}
				}
			}
		}
		if (nFlag)
		{

			Line ln(ptCenter, vx);

			//Check if there's any extra studs required and shift points for distribution to cater for extras
			if(opSF.bExtraBeamsBottom())
			{
				if(dExtraJackBottom>0)
				{
						
					ptLeftOp=ln.closestPointTo(ptLeftOp);
					ptLeftOp=ptLeftOp+vx*(dExtraJackBottom*0.5);
					ptRightOp=ln.closestPointTo(ptRightOp);
					ptRightOp=ptRightOp-vx*(dExtraJackBottom*0.5);
					
					ptExtraJacks.append(ptLeftOp);
					ptExtraJacks.append(ptRightOp);
				}
				else
				{
					ptLeftOp=ln.closestPointTo(ptLeftOp);
					ptLeftOp=ptLeftOp+vx*(dWidthJ*0.5);
					ptRightOp=ln.closestPointTo(ptRightOp);
					ptRightOp=ptRightOp-vx*(dWidthJ*0.5);
					
					ptExtraJacks.append(ptLeftOp);
					ptExtraJacks.append(ptRightOp);
				}
		
			}
			else
			{
				ptLeftOp=ln.closestPointTo(ptLeftOp);
				ptRightOp=ln.closestPointTo(ptRightOp);
			}


			double dDist=abs(vx.dotProduct(ptLeftOp-ptRightOp));
			LineSeg lsJacks(ptLeftOp, ptRightOp);
			int nNumberOfNewStuds=int(dDist/dSpacing);
			
			if (dDist>dSpacing && nDistribution==0) // Left Distribution
			{
				//Check if there will be an overlapping beam
				int nOverlap=FALSE;
				double dOverlapCheck;
				double dOverlap;

				if(opSF.bExtraBeamsBottom())
				{				
					dOverlapCheck=(dSpacing*nNumberOfNewStuds)+(dWidthJ*0.5);
					dOverlap=dDist-dOverlapCheck;
					if(dOverlap<dWidthJ*0.5)
					{
						nOverlap=TRUE;
					}
				}
				else
				{
					dOverlapCheck=(dSpacing*nNumberOfNewStuds)+(dWidthJ*0.5);
					dOverlap=dOverlapCheck-dDist;
					if(dOverlap>0)
					{
						nOverlap=TRUE;
					}
				}
				/*
				reportNotice("\n"+nNumberOfNewStuds);
				reportNotice("\n"+dDist);
				reportNotice("\n"+dOverlapCheck);
				reportNotice("\n"+dOverlap);
				reportNotice("\n"+nOverlap);								
				*/
				for(int x=0;x<nNumberOfNewStuds;x++)
				{
					//Check if there are any extra jacks on the side of the opening as the cases for the offset are different
					if(opSF.bExtraBeamsBottom())
					{
						if(x==nNumberOfNewStuds-1 && nOverlap==TRUE)
						{
							ptNewJacks.append((ptLeftOp+vx*dSpacing*(x+1))-vx*((dWidthJ*0.5)-dOverlap));
						}
						else
						{
							ptNewJacks.append(ptLeftOp+vx*dSpacing*(x+1));
						}
					}
					else
					{
						if(x==nNumberOfNewStuds-1 && nOverlap==TRUE)
						{
//							ptNewJacks.append((ptLeftOp+vx*dSpacing*(x+1))-vx*(dOverlap-(dWidthJ*0.5)));
							ptNewJacks.append((ptLeftOp+vx*dSpacing*(x+1))-vx*(abs(dOverlap)));
						}
						else
						{
							ptNewJacks.append(ptLeftOp+vx*dSpacing*(x+1));
						}
					}
				}				
			}			

			if (dDist>dSpacing && nDistribution==2) // Right Distribution
			{
				//Check if there will be an overlapping beam
				int nOverlap=FALSE;
				double dOverlapCheck;
				double dOverlap;

				if(opSF.bExtraBeamsBottom())
				{				
					dOverlapCheck=(dSpacing*nNumberOfNewStuds)+(dWidthJ*0.5);
					dOverlap=dDist-dOverlapCheck;
					if(dOverlap<dWidthJ*0.5)
					{
						nOverlap=TRUE;
					}
				}
				else
				{
					dOverlapCheck=(dSpacing*nNumberOfNewStuds)+(dWidthJ*0.5);
					dOverlap=dOverlapCheck-dDist;
					if(dOverlap>0)
					{
						nOverlap=TRUE;
					}
				}			
				//reportNotice(nOverlap);
				for(int x=0;x<nNumberOfNewStuds;x++)
				{
					//Check if there are any extra jacks on the side of the opening as the cases for the offset are different
					if(opSF.bExtraBeamsBottom())
					{
						if(x==nNumberOfNewStuds-1 && nOverlap==TRUE)
						{
							ptNewJacks.append((ptRightOp-vx*dSpacing*(x+1))+vx*((dWidthJ*0.5)-dOverlap));

						}
						else
						{
							ptNewJacks.append(ptRightOp-vx*dSpacing*(x+1));
						}
					}
					else
					{
						if(x==nNumberOfNewStuds-1 && nOverlap==TRUE)
						{
							ptNewJacks.append((ptRightOp-vx*dSpacing*(x+1))+vx*(abs(dOverlap)));
						}
						else
						{
							ptNewJacks.append(ptRightOp-vx*dSpacing*(x+1));
						}
					}
				}				
			}
			
			if (dDist>dSpacing && nDistribution==1) // Even Distribution
			{
				int nEven=FALSE;  //Default Odd
				double test=nNumberOfNewStuds*0.5;
				double dEvenCheck=(nNumberOfNewStuds*0.5)-int(nNumberOfNewStuds*0.5);
				if(dEvenCheck==0) {nEven=TRUE;}
				
				Point3d ptOpCen=ptLeftOp+vx*(dDist/2);
				//reportNotice("\n"+nNumberOfNewStuds+" "+test+" "+dEvenCheck+" "+nEven);
							
					//Check if there are any extra jacks on the side of the opening as the cases for the offset are different
				if(nEven==TRUE)
				{
					for(int x=0;x<nNumberOfNewStuds/2;x++)
					{
							if(x==0)
							{
								ptNewJacks.append(ptOpCen+vx*(dSpacing*0.5)*(x+1));
								ptNewJacks.append(ptOpCen-vx*(dSpacing*0.5)*(x+1));
							}
							else
							{
								ptNewJacks.append(ptOpCen+vx*((dSpacing*0.5)+dSpacing*(x)));
								ptNewJacks.append(ptOpCen-vx*((dSpacing*0.5)+dSpacing*(x)));
							}
					}
				}
				else
				{
					for(int x=0;x<int(nNumberOfNewStuds*0.5)+1;x++)
					{	
						if(x==0)
						{
							ptNewJacks.append(ptOpCen);
						}
						else
						{
							ptNewJacks.append(ptOpCen+vx*(dSpacing*(x)));
							ptNewJacks.append(ptOpCen-vx*(dSpacing*(x)));
						}
					}
				}				
			}					

			if(nFoundJacksBelowOpening==true)
			{
				for (int j=0; j<ptNewJacks.length(); j++)
				{
					nErase=TRUE;
	
					Point3d pt=ptNewJacks[j];
					if (ppToCheck.pointInProfile(pt)==_kPointInProfile)
						continue;
					Beam bmNew; 
					bmNew.dbCreate(pt, vy, vx, -vz, dLengthJBelow, dWidthJ, dHeightJ);
					bmNew.setType(_kSFJackUnderOpening);
					bmNew.setName("JACKS");
					bmNew.setMaterial(bmAll[0].material());
					bmNew.setGrade(bmAll[0].grade());
					bmNew.setColor(nColor);
					bmNew.assignToElementGroup(el, TRUE, 0, 'Z');
					bmNew.setModule(sModule);
				}
				for (int j=0;j<ptExtraJacks.length();j++)
				{
					nErase=TRUE;
	
					Point3d pt=ptExtraJacks[j];
					if (ppToCheck.pointInProfile(pt)==_kPointInProfile)
						continue;
					
					Beam bmNewExtra;
					
					if(dExtraJackTop>0)
					{
						bmNewExtra.dbCreate(pt, vy, vx, -vz, dLengthJBelow, dExtraJackTop, dHeightJ);
					}
					else 
					{
						bmNewExtra.dbCreate(pt, vy, vx, -vz, dLengthJBelow, dWidthJ, dHeightJ);
					}
					bmNewExtra.setType(_kSFJackUnderOpening);
					bmNewExtra.setName("JACKS");
					bmNewExtra.setMaterial(bmAll[0].material());
					bmNewExtra.setGrade(bmAll[0].grade());
					bmNewExtra.setColor(nColor);
					bmNewExtra.assignToElementGroup(el, TRUE, 0, 'Z');
					bmNewExtra.setModule(sModule);
				}
			}
		}
		
		//Jacks over opening
		ppOp.transformBy(vy*U(800));
		nFlag=false;
		for (int i=0; i<bmToCheckTop.length(); i++)
		{
			Beam bm=bmToCheckTop[i];
			PlaneProfile ppBm(csEl);
			ppBm=bm.realBody().shadowProfile(pln);
			double dArea=ppBm.area();
			dArea=dArea/(U(1)*U(1));
			int nResult=ppBm.intersectWith(ppOp);
			
			if (nResult)
			{
				double dAreaResult=ppBm.area();
				dAreaResult=dAreaResult/(U(1)*U(1));
				if (dAreaResult>(dArea*.1))
				{
					ptCenter=bm.ptCen();
					dLengthJAbove=bm.solidLength();
					//dWidthJ=bm.dW();
					//dHeightJ=bm.dH();
					sModule=bm.module();
					nColor=bm.color();
					
					//Remove the blocking that was in contack with the existing Jaks
					//Beam bmBlockingToErase[]=bm.filterBeamsCapsuleIntersect(bmBlocking);
					//for (int k=0; k<bmBlockingToErase.length(); k++)
					//{
					//	bmBlockingToErase[k].dbErase();
					//}
					
					bm.dbErase();
					nFlag=true;
				}
			}
		}
		if (nFlag)
		{
			//Project points to line of centre point of jacks above opening
			Line lnJacksAboveOpeningCen(ptCenter,vx);
			Point3d ptJacksAboveOpening[]=lnJacksAboveOpeningCen.projectPoints(ptNewJacks);
			Point3d ptJacksAboveOpeningExtra[]=lnJacksAboveOpeningCen.projectPoints(ptExtraJacks);

			for (int j=0; j<ptJacksAboveOpeningExtra.length(); j++)
			{
				nErase=TRUE;

				Point3d pt=ptJacksAboveOpeningExtra[j];
				if (ppToCheck.pointInProfile(pt)==_kPointInProfile)
					continue;
				Beam bmNewExtra;
				if(dExtraJackTop>0)
				{
					bmNewExtra.dbCreate(pt, vy, vx, -vz, dLengthJAbove, dExtraJackTop, dHeightJ);
				}
				else 
				{
					bmNewExtra.dbCreate(pt, vy, vx, -vz, dLengthJAbove, dWidthJ, dHeightJ);
				}

				bmNewExtra.setType(_kSFJackOverOpening);
				bmNewExtra.setName("JACKS");
				bmNewExtra.setMaterial(bmAll[0].material());
				bmNewExtra.setGrade(bmAll[0].grade());
				bmNewExtra.setColor(nColor);
				bmNewExtra.assignToElementGroup(el, TRUE, 0, 'Z');
				bmNewExtra.setModule(sModule);
			}
			
			for (int j=0; j<ptJacksAboveOpening.length(); j++)
			{
				nErase=TRUE;

				Point3d pt=ptJacksAboveOpening[j];
				if (ppToCheck.pointInProfile(pt)==_kPointInProfile)
					continue;
				Beam bmNew; 
				bmNew.dbCreate(pt, vy, vx, -vz, dLengthJAbove, dWidthJ, dHeightJ);
				bmNew.setType(_kSFJackOverOpening);
				bmNew.setName("JACKS");
				bmNew.setMaterial(bmAll[0].material());
				bmNew.setGrade(bmAll[0].grade());
				bmNew.setColor(nColor);
				bmNew.assignToElementGroup(el, TRUE, 0, 'Z');
				bmNew.setModule(sModule);

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
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Add property for spacing." />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="11" />
      <str nm="DATE" vl="8/22/2024 9:58:46 AM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End