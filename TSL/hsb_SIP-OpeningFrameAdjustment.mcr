#Version 8
#BeginDescription

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2012 by
*  ITW Industry 
*  UK
*
*  The program may be used and/or copied only with the written
*  permission from hsbSOFT, or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.

* REVISION HISTORY
* -------------------------
*
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 09.05.2013
* version 1.0: Release Version
*
*/

_ThisInst.setSequenceNumber(-120);

Unit(1,"mm"); // script uses mm

if(_bOnInsert)
{
	if( insertCycleCount()>1 )
	{
		eraseInstance();
		return;
	}

	//if (_kExecuteKey=="")
	//	showDialogOnce();

	PrEntity ssE(T("Select one or More Elements"), ElementWall());
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	return;
}

if (_bOnDbCreated || _bOnInsert){	setPropValuesFromCatalog(_kExecuteKey);}

int nErase=false;

for (int e=0; e<_Element.length(); e++)
{
	Element el=_Element[e];
	
	if (!el.bIsValid()) continue;
	
	CoordSys csEl = el.coordSys();
	Vector3d vx = csEl.vecX();
	Vector3d vy = csEl.vecY();
	Vector3d vz = csEl.vecZ();
	Point3d ptEl = csEl.ptOrg();
	
	Opening opAll[]=el.opening();
	
	Beam bmAll[]=el.beam();
	
	Sip spAll[]=el.sip();
	
	if (bmAll.length()==0 || spAll.length()==0)
		continue;
	
	double dFullThickness=spAll[0].dH();
	
	nErase=true;
	
	Plane plnZ(ptEl-vz*(dFullThickness*0.5), vz);
	
	//Look for all the trimmers and king studs
	Beam bmTrimKing[0];
	Beam bmBottomPlate[0];
	Beam bmTopPlate[0];
	for (int i=0; i<bmAll.length(); i++)
	{
		Beam bm=bmAll[i];
		if (bm.type()==_kTrimmerStud || bm.type()== _kPanelKingStud || bm.type()== _kPanelTrimmerStud)
		{
			bmTrimKing.append(bm);
		}
		if (bm.type()== _kSFBottomPlate || bm.type()== _kPanelBottomPlate)
		{
			bmBottomPlate.append(bm);
		}
		if (bm.type()== _kSFTopPlate || bm.type()== _kPanelTopPlate)
		{
			bmTopPlate.append(bm);
		}
	}
	
	bmTrimKing=vx.filterBeamsPerpendicularSort(bmTrimKing);
	
	//Loop the openings
	
	for (int o=0; o<opAll.length(); o++)
	{
		Opening op=opAll[o];
		PLine plOpShape=op.plShape();
		Point3d ptOpCenter;
		ptOpCenter.setToAverage(plOpShape.vertexPoints(true));
		ptOpCenter=ptOpCenter.projectPoint(plnZ, 0);
		
		//Find bank of studs on the left
		Beam bmPosibleLeft[0];
		bmPosibleLeft=Beam().filterBeamsHalfLineIntersectSort(bmTrimKing, ptOpCenter, -vx);
		
		Beam bmLeft[0];

		for (int i=0; i<bmPosibleLeft.length(); i++)
		{
			Beam bm=bmPosibleLeft[i];
			
			if (i==0)
			{
				bmLeft.append(bm);
			}
			else
			{
				Beam bmPrev=bmLeft[bmLeft.length()-1];
				if (abs(vx.dotProduct(bm.ptCen()-bmPrev.ptCen()))- ((bm.dD(vx)*0.5) + (bmPrev.dD(vx)*0.5) )<U(0.1))
				{
					bmLeft.append(bm);
				}
				else
				{
					break;
				}
			}
		}
		
		//Work with the beam on the left accordingly
		

		if (bmLeft.length()>1)
		{
			Point3d ptSplitTL; int nTL=true;
			Point3d ptSplitTR; int nTR=true;
			Point3d ptSplitBL; int nBL=true;
			Point3d ptSplitBR; int nBR=true;
			for (int i=0; i<bmLeft.length()-1; i++)
			{
				Beam bm=bmLeft[i];
				bm.setD(vz, dFullThickness);
				
				//Find if there is intersection with top plate
				Beam bmIntersectTop[0];
				bmIntersectTop=bm.filterBeamsTConnection(bmTopPlate, U(5), false);
				
				if (bmIntersectTop.length()>0)
				{
					if (nTL)
					{
						ptSplitTL=bm.ptCen()+vx*(bm.dD(vx)*0.5);
						nTL=false;
					}
					ptSplitTR=bm.ptCen()-vx*(bm.dD(vx)*0.5);
					//Cut the vertical beam
					Cut ct(bmIntersectTop[0].ptCen()+vy*(bmIntersectTop[0].dD(vy)*0.5), vy);
					bm.addToolStatic(ct, true);
				}
				
				//Find if there is intersection with bottom plate
				Beam bmIntersectBottom[0];
				bmIntersectBottom=bm.filterBeamsTConnection(bmBottomPlate, U(5), false);
				
				if (bmIntersectBottom.length()>0)
				{
					if (nBL)
					{
						ptSplitBL=bm.ptCen()+vx*(bm.dD(vx)*0.5);
						nBL=false;
					}
					ptSplitBR=bm.ptCen()-vx*(bm.dD(vx)*0.5);
					
					Cut ct(bmIntersectBottom[0].ptCen()-vy*(bmIntersectBottom[0].dD(vy)*0.5), -vy);
					bm.addToolStatic(ct, true);
				}
			}
			
			//Split Top and Bottom plate on the left of the opening
			if (nTL==false)
			{
				Beam bmSplitTop[0];
				bmSplitTop=Beam().filterBeamsHalfLineIntersectSort(bmTopPlate, ptSplitTL, vy);
				for (int i=0; i<bmSplitTop.length(); i++)
				{
					Beam bm=bmSplitTop[i];
					if (bm.vecX().dotProduct(vx)>0)
					{
						bmTopPlate.append(bm.dbSplit(ptSplitTL, ptSplitTR));
					}
					else
					{
						bmTopPlate.append(bm.dbSplit(ptSplitTR, ptSplitTL));
					}
				}
			}

			if (nBL==false)
			{
				Beam bmSplitBottom[0];
				bmSplitBottom=Beam().filterBeamsHalfLineIntersectSort(bmBottomPlate, ptSplitBL, -vy);
				for (int i=0; i<bmSplitBottom.length(); i++)
				{
					Beam bm=bmSplitBottom[i];
					if (bm.vecX().dotProduct(vx)>0)
					{
						bmBottomPlate.append(bm.dbSplit(ptSplitBL, ptSplitBR));
					}
					else
					{
						bmBottomPlate.append(bm.dbSplit(ptSplitBR, ptSplitBL));
					}
				}
			}
		}
		
		//Find bank of studs on the right
		Beam bmPosibleRight[0];
		bmPosibleRight=Beam().filterBeamsHalfLineIntersectSort(bmTrimKing, ptOpCenter, vx);
		
		Beam bmRight[0];

		for (int i=0; i<bmPosibleRight.length(); i++)
		{
			Beam bm=bmPosibleRight[i];
			
			if (i==0)
			{
				bmRight.append(bm);
			}
			else
			{
				Beam bmPrev=bmRight[bmRight.length()-1];
				if (abs(vx.dotProduct(bm.ptCen()-bmPrev.ptCen()))- ((bm.dD(vx)*0.5) + (bmPrev.dD(vx)*0.5) )<U(0.1))
				{
					bmRight.append(bm);
				}
				else
				{
					break;
				}
			}
		}
		
		//Work with the beam on the Right accordingly
		

		if (bmRight.length()>1)
		{
			Point3d ptSplitTL; int nTL=true;
			Point3d ptSplitTR; int nTR=true;
			Point3d ptSplitBL; int nBL=true;
			Point3d ptSplitBR; int nBR=true;
			for (int i=0; i<bmRight.length()-1; i++)
			{
				Beam bm=bmRight[i];
				bm.setD(vz, dFullThickness);
				
				//Find if there is intersection with top plate
				Beam bmIntersectTop[0];
				bmIntersectTop=bm.filterBeamsTConnection(bmTopPlate, U(5), false);
				
				if (bmIntersectTop.length()>0)
				{
					if (nTL)
					{
						ptSplitTL=bm.ptCen()-vx*(bm.dD(vx)*0.5);
						nTL=false;
					}
					ptSplitTR=bm.ptCen()+vx*(bm.dD(vx)*0.5);
					//Cut the vertical beam
					Cut ct(bmIntersectTop[0].ptCen()+vy*(bmIntersectTop[0].dD(vy)*0.5), vy);
					bm.addToolStatic(ct, true);
				}
				
				//Find if there is intersection with bottom plate
				Beam bmIntersectBottom[0];
				bmIntersectBottom=bm.filterBeamsTConnection(bmBottomPlate, U(5), false);
				
				if (bmIntersectBottom.length()>0)
				{
					if (nBL)
					{
						ptSplitBL=bm.ptCen()-vx*(bm.dD(vx)*0.5);
						nBL=false;
					}
					ptSplitBR=bm.ptCen()+vx*(bm.dD(vx)*0.5);
					
					Cut ct(bmIntersectBottom[0].ptCen()-vy*(bmIntersectBottom[0].dD(vy)*0.5), -vy);
					bm.addToolStatic(ct, true);
				}
			}
			
			//Split Top and Bottom plate on the Right of the opening
			if (nTL==false)
			{
				Beam bmSplitTop[0];
				bmSplitTop=Beam().filterBeamsHalfLineIntersectSort(bmTopPlate, ptSplitTL, vy);
				for (int i=0; i<bmSplitTop.length(); i++)
				{
					Beam bm=bmSplitTop[i];
					if (bm.vecX().dotProduct(vx)>0)
					{
						bmTopPlate.append(bm.dbSplit(ptSplitTR, ptSplitTL));
					}
					else
					{
						bmTopPlate.append(bm.dbSplit(ptSplitTL, ptSplitTR));
					}
				}
			}

			if (nBL==false)
			{
				Beam bmSplitBottom[0];
				bmSplitBottom=Beam().filterBeamsHalfLineIntersectSort(bmBottomPlate, ptSplitBL, -vy);
				for (int i=0; i<bmSplitBottom.length(); i++)
				{
					Beam bm=bmSplitBottom[i];
					if (bm.vecX().dotProduct(vx)>0)
					{
						bmBottomPlate.append(bm.dbSplit(ptSplitBR, ptSplitBL));
					}
					else
					{
						bmBottomPlate.append(bm.dbSplit(ptSplitBL, ptSplitBR));
					}
				}
			}
		}
	}
}
//Trimme Stud
//Panel King Stud

if (_bOnElementConstructed || nErase)
{
	eraseInstance();
	return;
}

/*
// check running conditions

if (_Beam.length()==0) return;
if (_Sip.length()==0) return;

Beam bm = _Beam[0];
Sip pnl = _Sip[0];

Point3d ptEdge = bm.ptCen(); // point near the edge of the panel
Vector3d vecEdge = bm.vecD(ptEdge - pnl.ptCen()); // point outwards of panel
PanelStop ps(bm,"", ptEdge, vecEdge );
//ps.setEdgeRecessType(_kSplineIJoist);
ps.setEdgeRecessType(_kSplineCustom);
ps.setEdgeDetailCode("aa");
pnl.addTool(ps);
setDependencyOnBeamLength(bm); // when the beam length changes, this TSL needs to be recalculated.



#End
#BeginThumbnail

#End
