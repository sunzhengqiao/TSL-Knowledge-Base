#Version 8
#BeginDescription
Splits all the beams inside of a floor that have a code set by the properties if they overlap any beam.

Modified by: Mihai Bercuci (mihai.bercuci@hsbcad.com)
Date: 28.09.2017 - version 2.1






#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 1
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2010 by
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
* date: 10.03.2010
* version 1.0: Release Version
*
* date: 22.03.2010
* version 1.1: 	Fix the issue with the split when the Extrusion Profile was define with the real shape
*				Fix Issue with profile when multiple profiles are used in the same element.
*
* date: 11.11.2010
* version 1.2: Made the spliting process more robust
*
* date: 12.02.2015
* version 1.5: Added array of planes for each beam to split to check against all vertical beams.  
* The reason for this is extract contact face in place wall missing out smaller timbers which were a fair distance away from the top plane.
*
* date: 12.02.2015
* version 1.6: Commented out code that deletes blockings if it intersects with ppShapeBeams as it was deleting blockings that were created because a ridge beam's shadowProfile was shaddowing the new blockings.
*
*
* date: 28.09.2017
* version 2.1: Change the bmIntersect.realBody() with  bmIntersect.envelopeBody(true,true);
*
*/

Unit(1,"mm"); // script uses mm

PropString sBeamCodes(0, "BLOCKING;BATTEN", "Enter beam codes:");

double dMinLength=U(20);

if(_bOnInsert)
{
	//_Map.setInt("nExecutionMode", 1);
	if (insertCycleCount()>1) { eraseInstance(); return; }
	showDialogOnce();
	PrEntity ssE(T("Please select Elements"),Element());
 	if (ssE.go())
	{
 		Entity ents[0];
 		ents = ssE.set();
 		for (int i = 0; i < ents.length(); i++ )
		 {
 			Element el = (Element) ents[i];
 			_Element.append(el);
 		 }
 	}
	return;
}

if (_Element.length()==0)
{
	eraseInstance();
	return;
}

String sCodes[0];
String sList = sBeamCodes;
sList .trimLeft();
sList .trimRight();
sList =sList +";";
for (int i=0; i<sList.length(); i++)
{
	String str=sList .token(i);
	str.trimLeft();
	str.trimRight();
	str.makeUpper();
	if (str.length()>0)
		sCodes.append(str.makeUpper());
}

for (int e=0; e<_Element.length(); e++)
{
	Element el=_Element[e];
	
	CoordSys csEl = el.coordSys();
	Vector3d vx = csEl.vecX();
	Vector3d vy = csEl.vecY();
	Vector3d vz = csEl.vecZ();
	_Pt0=csEl.ptOrg();

	Beam bmAll[]=el.beam();
	Beam bmVer[]=vx.filterBeamsPerpendicularSort(bmAll);
	Beam bmHor[]=vy.filterBeamsPerpendicularSort(bmAll);
	if (bmVer.length()<1)	
	{
		return;
	}
	
	Beam bmToSplit[0];
	Beam bmThatPotentialIntersect[0];
	
	double dBeamWidth=bmVer[0].dD(vx);
	double dBeamHeight=bmVer[0].dD(vz);
	
	Plane plnZ (csEl.ptOrg(), vz);

	
	//Collect all the beams that need split, every other beams is a potential intersection
	for (int b=0; b<bmAll.length(); b++)
	{
		Beam bmAllCurr=bmAll[b];
		String sCode=bmAllCurr.beamCode().token(0);
		sCode.makeUpper();
		if (sCodes.find(sCode) > -1)
		{
			bmToSplit.append(bmAllCurr);
		}
		else
		{
			bmThatPotentialIntersect.append(bmAllCurr);
		}	
	}
	
	for (int i=0; i<bmToSplit.length(); i++)
	{
		PlaneProfile ppShapeBeams(csEl);
		Beam bmS=bmToSplit[i];
		Body bdThisBeam=bmToSplit[i].realBody();

		Vector3d vxSplit=bmS.vecX();
		PlaneProfile pptS(plnZ);
		pptS=bmS.envelopeBody(false, true).shadowProfile(plnZ);
		pptS.shrink(U(1));
		//pptS.vis(i);
		
		Line lnS(bmS.ptCen(), bmS.vecX());
		Point3d ptSplit[0];
		double dSplitSize[0];
		Beam bmIntersection[0];

		for (int j=0; j<bmThatPotentialIntersect.length(); j++)
		{
			Beam bmIntersect=bmThatPotentialIntersect[j];
			Body bdIntersect=bmIntersect.envelopeBody(true,true);
			if (bdIntersect.hasIntersection(bdThisBeam))
			{
				if (abs(bmS.vecX().dotProduct(bmIntersect.vecX()))<0.99)
				{
					bmIntersection.append(bmIntersect);

				}
			}
		}
		

		
		for (int j=0; j<bmIntersection.length(); j++)
		{
			Beam bmIntersect=bmIntersection[j];
			PlaneProfile ppBm(csEl);
			ppBm = bmIntersect.realBody().shadowProfile(plnZ);//, U(dBeamHeight)
			
			ppBm .transformBy(U(0.01)*vy.rotateBy(i*123.456,vz));
			ppBm.shrink(-U(2));
			ppShapeBeams.unionWith(ppBm);
			
			
		}
		
		ppShapeBeams.shrink(U(2));
		ppShapeBeams.vis();

		PlaneProfile ppThisBeam=bmS.envelopeBody(false, true).shadowProfile(plnZ);
		ppThisBeam.intersectWith(ppShapeBeams);
		
		ppThisBeam.vis(1);
		
		PLine plAllRings[]=ppThisBeam.allRings();
		
		for (int k=0; k<plAllRings.length(); k++)
		{
			Point3d ptAll[]=plAllRings[k].vertexPoints(true);
			ptAll=lnS.orderPoints(ptAll, U(2));
			ptAll=plnZ.projectPoints(ptAll);
			
			if (ptAll.length()>1)
			{
				LineSeg ls(ptAll[0], ptAll[ptAll.length()-1]);
				ptSplit.append(lnS.closestPointTo(ls.ptMid()));
				dSplitSize.append(abs(bmS.vecX().dotProduct(ls.ptStart()-ls.ptEnd())));

			}
			else
			{
			
				//Line lnB(bmIntersect.ptCen(), bmIntersect.vecX());
				//ptSplit.append(lnS.closestPointTo(lnB));
				//dSplitSize.append(bmIntersect.dD(bmS.vecX()));
			}
		}
		
		ptSplit=lnS.orderPoints(ptSplit, U(2));
		ptSplit=plnZ.projectPoints(ptSplit);
		
		Beam bmToStretch[0];
		bmToStretch.append(bmS);
		
		for (int p=0; p<ptSplit.length(); p++)
		{
			Point3d pt=ptSplit[p];
			double dGR=dSplitSize[p];
			pt.vis(p);

			if (pptS.pointInProfile(pt)== _kPointInProfile)
			{
				Point3d ptTo=pt+vxSplit*dGR*0.5;
				Point3d ptFrom=pt-vxSplit*dGR*0.5;
				ptTo.vis(1);
				ptFrom.vis(2);
				Vector3d vTool=vxSplit;
				vTool.vis(ptTo, 3);
				pptS.vis(4);
				if (pptS.pointInProfile(ptTo)== _kPointInProfile && pptS.pointInProfile(ptFrom)== _kPointInProfile)
				{
					Beam bmRes=bmS.dbSplit(ptTo, ptFrom);
					bmToStretch.append(bmRes);
					if (bmRes.solidLength()>bmS.solidLength())
					{
						bmS=bmRes;
						vxSplit=bmRes.vecX();
						pptS=bmRes.envelopeBody(false, true).shadowProfile(plnZ);
						pptS.shrink(U(1));
					}
					else
					{
						vxSplit=bmS.vecX();
						pptS=bmS.envelopeBody(false, true).shadowProfile(plnZ);
						pptS.shrink(U(1));
					}
				}
				else if (pptS.pointInProfile(ptTo)== _kPointOutsideProfile)
				{
					Cut ct(ptFrom, vTool);
					bmS.addToolStatic(ct);
				}
				else if (pptS.pointInProfile(ptFrom)== _kPointOutsideProfile)
				{
					Cut ct(ptTo, -vTool);
					bmS.addToolStatic(ct);	
				}
			}
		}
		
		for (int b=0; b<bmToStretch.length(); b++) // Could be added an stretch option here
		{
			for (int nSide=0; nSide<2; nSide++)  // loop for positive and negative side
			{
				Beam bm = bmToStretch[b];
				Point3d ptBm = bm.ptCen();
				Vector3d vecBm = bm.vecX();
				if (nSide==1) vecBm = -vecBm;
				
				Beam arBeamHit[] = Beam().filterBeamsHalfLineIntersectSort(bmIntersection, ptBm ,vecBm );
				if (arBeamHit.length()>0) 
				{
					Beam bmHit = arBeamHit[0]; // take first beam from filtered list because it is closest.
					bm.stretchDynamicTo(bmHit);
				}
			}
		}
	}
}

eraseInstance();
return;















#End
#BeginThumbnail










#End