#Version 8
#BeginDescription
Last modified by: Alberto Jena (aj@hsb-cad.com)
12.11.2017  -  version 1.6


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 6
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
* date: 18.10.2011
* version 1.0: Prototype
*
* date: 10.02.2012
* version 1.1: Release
*
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 22.10.2011
* version 1.2: Add the option to nest PLines and some improvements to the nester results
*				Needs a MVBlock call ToleranceCheck
*
* date: 22.10.2011
* version 1.3: If the PLines are selected now there is an option to select the labels to add that information to the Sip Panels
*				Needs a Property Set Called PanelInfo
*
* date: 26.01.2015
* version 1.5: Improved the option to pick TEXT when PLines are used for nestin
*
*/

Unit (1,"mm");

String sArNY[] = {T("No"), T("Yes")};

PropString sEmpty (0,"","NESTER INFO",0);
sEmpty.setReadOnly(true);

String sChildPanels = T("|Child Panels|");
String sPLines = T("|Polylines|");
String sObjToNest[] = { sChildPanels, sPLines};
PropString sObjects(11, sObjToNest,T("|Objects To Nest|"));

String strAllSipStyles[] = SipStyle().getAllEntryNames(); // list of all available sipstyles
PropString pSipStyle(12, strAllSipStyles, "Sip style"); // make property

String strAllStyles[] = MasterPanelStyle().getAllEntryNames(); // list of all available MasterPanelStyles
PropString pStyle(1, strAllStyles, "MasterPanel style:"); // make property

PropString sMPName(2, "", "MasterPanel Name:"); // make property

PropString sMP1 (3, sArNY, T("Use 1220x4800"));
PropString sMP8 (13, sArNY, T("Use 1220x4900"));
PropString sMP2 (4, sArNY, T("Use 1220x5100"));
PropString sMP3 (5, sArNY, T("Use 1220x5500"));
PropString sMP4 (6, sArNY, T("Use 1220x6000"));
PropString sMP5 (7, sArNY, T("Use 1220x6250"));
PropString sMP6 (8, sArNY, T("Use 1220x6500"));
PropString sMP7 (9, sArNY, T("Use 1220x7500"));

PropDouble dResuceLength(2, U(0), T("Reduce length by"));
PropDouble dResuceWidth(3, U(0), T("Reduce width by"));

int nMP1=sArNY.find(sMP1);
int nMP2=sArNY.find(sMP2);
int nMP3=sArNY.find(sMP3);
int nMP4=sArNY.find(sMP4);
int nMP5=sArNY.find(sMP5);
int nMP6=sArNY.find(sMP6);
int nMP7=sArNY.find(sMP7);
int nMP8=sArNY.find(sMP8);

PropDouble dAllowedTimeInSeconds(0, 360, T("|Allowed run time in seconds|"));
dAllowedTimeInSeconds.setFormat(_kNoUnit);

PropDouble dMinimumSpacing(1, U(35), T("|Minimum spacing|"));
String sNesters[]={T("|Test|"), T("|V4|"), T("|V5|"), T("|V6|")};
int nNesters[]={_kNTTestNester, _kNTAutoNesterV4, _kNTAutoNesterV5, _kNTAutoNesterV6};

PropString sNester(10,sNesters, "Nester to use",2);

if (_bOnInsert)
{
	if( insertCycleCount()>1 )
	{
		eraseInstance();
		return;
	}
	if (_kExecuteKey=="")
		showDialogOnce();
	
	// Setting nester masters
	
	_Pt0= getPoint(T("|Set point to place master panels|"));
	_Pt0+=_ZW*_ZW.dotProduct(Point3d(0,0,0)-_Pt0);
	
	if(sObjects==sChildPanels)
	{
		PrEntity ssE(T("|Select child panels|"), ChildPanel ());
		if( ssE.go() ) 
		{
			Entity ent[0];
			ent=ssE.set();
			for (int i=0; i<ent.length(); i++)
			{
				ChildPanel cp=(ChildPanel) ent[i];
				if (cp.bIsValid())
				{
					_Entity.append(cp);
				}
			}
		}
	}
	
	if(sObjects==sPLines)
	{
		PrEntity ssE(T("|Select close polylines|"), EntPLine());
		if( ssE.go() ) 
		{
			Entity ent[0];
			ent=ssE.set();
			for (int i=0; i<ent.length(); i++)
			{
				EntPLine epl=(EntPLine) ent[i];
				if (epl.bIsValid())
				{
					ent[i].attachPropSet("PanelInfo");
					_Entity.append(epl);
				}
			}
		}
		//Select all the text to it can be match with the PLines
		
		Entity entAllText[0];
		Point3d ptMiddle[0];
		String sText[0];
		
		PrEntity ssEText(T("|Select labels|"));
		if( ssEText.go() ) 
		{
			Entity entText[0];
			entText=ssEText.set();
			for (int i=0; i<entText.length(); i++)
			{
				if (entText[i].typeDxfName()=="MTEXT" || entText[i].typeDxfName()=="TEXT")
					entAllText.append(entText[i]);
			}
		}
		for (int i=0; i<entAllText.length(); i++)
		{
			//Calculate the center point to check later if this is in the pline
			Point3d ptAll[]=entAllText[i].gripPoints();
			Point3d ptMidT;
			ptMidT.setToAverage(ptAll);
			ptMiddle.append(ptMidT);
			
			//Get the text of the MTEXT Object
			//0.S) Text: \pxqc;AJ\P234x432
			String arKeys[]={T("|Text|")};
			Map mpProp;
			mpProp = entAllText[i].getAutoPropertyMap(arKeys);
			String sValue=mpProp.getString("Text");
			if (sValue.find(";", 0)!=-1)
			{
				sValue=sValue.token(1, ";");
				sValue=sValue.token(0, "\P");
			}
			else
			{
				sValue=sValue.token(0, "\P");
			}
			sText.append(sValue);
		}
		//Assign the relevant value to the PLine
		CoordSys csW(_PtW, _XW, _YW, _ZW);
		for (int e=0; e<_Entity.length(); e++)
		{
			Entity ent=_Entity[e];
			
			CoordSys csW(_PtW, _XW, _YW, _ZW);
			PlaneProfile ppPL(csW);
			EntPLine epl = (EntPLine) ent;

			if (!epl.bIsValid()) continue;

			PLine pl = epl.getPLine();
			ppPL.joinRing(pl, false);
			
			String sValues[]={"PanelCode"};
			
			Map mpProp=ent.getAttachedPropSetMap("PanelInfo", sValues);
			String sValue=mpProp.getString("PanelCode");
			
			String sNewCode="";
			
			for (int i=0; i<ptMiddle.length(); i++)
			{
				Point3d pt=ptMiddle[i];
				if (ppPL.pointInProfile(pt)==_kPointInProfile)
				{
					sNewCode=sText[i];
					break;
				}
			}
			
			
			if (sNewCode!="")
			{
				mpProp.setString("PanelCode", sNewCode);
				ent.setAttachedPropSetFromMap("PanelInfo", mpProp);
			}
		}
	}	
	return;
}

double dWidths[0];
double dHeights[0];
String sOriginatorIDs[0];

if (nMP1)
{
	dWidths.append(U(1222.1)-dResuceWidth);		dHeights.append(U(4800)-dResuceLength);		sOriginatorIDs.append("1");
}
if (nMP8)
{
	dWidths.append(U(1222.1)-dResuceWidth);		dHeights.append(U(4900)-dResuceLength);		sOriginatorIDs.append("8");
}
if (nMP2)
{
	dWidths.append(U(1222.1)-dResuceWidth);		dHeights.append(U(5100)-dResuceLength);		sOriginatorIDs.append("2");
}
if (nMP3)
{
	dWidths.append(U(1222.1)-dResuceWidth);		dHeights.append(U(5500)-dResuceLength);		sOriginatorIDs.append("3");
}
if (nMP4)
{
	dWidths.append(U(1222.1)-dResuceWidth);		dHeights.append(U(6000)-dResuceLength);		sOriginatorIDs.append("4");
}
if (nMP5)
{
	dWidths.append(U(1222.1)-dResuceWidth);		dHeights.append(U(6250)-dResuceLength);		sOriginatorIDs.append("5");
}
if (nMP6)
{
	dWidths.append(U(1222.1)-dResuceWidth);		dHeights.append(U(6500)-dResuceLength);		sOriginatorIDs.append("6");
}
if (nMP7)
{
	dWidths.append(U(1222.1)-dResuceWidth);		dHeights.append(U(7500)-dResuceLength);		sOriginatorIDs.append("7");
}




/*
//Details to clone the block TSL
TslInst tsl;
String sScriptName = "hsb_DrawBlock"; // name of the script
Vector3d vecUcsX = _XW;
Vector3d vecUcsY = _YW;
Entity lstEnts[0];
Beam lstBeams[0];
Point3d lstPoints[0];
int lstPropInt[0];
String lstPropString[0];
double lstPropDouble[0];
lstPropString.append("ToleranceCheck");
lstPropString.append("Tolerance Check Box");
*/

Point3d pt1, pt2; 
int nIndexMasterPanels;
NesterCaller nester;

//Master panels
for (int i=0; i<sOriginatorIDs.length(); i++)
{
	nIndexMasterPanels=0;
	pt1=_Pt0; 
	pt2=pt1+_YW*dWidths[i]+_XW*dHeights[i];
	
	PLine plMaster; 
	plMaster.createRectangle(LineSeg(pt1, pt2),_XW, _YW);
	
	CoordSys csCorrect(_PtW, _XW, _YW, _ZW);
	PlaneProfile ppCorrect(csCorrect);
	ppCorrect.joinRing(plMaster, false);
	
	NesterMaster nm(sOriginatorIDs[i], ppCorrect);
	nm.setIsStockPiece(true);
	nester.addMaster(nm);
}

// Setting nester values
NesterData nd;
nd.setAllowedRunTimeSeconds(dAllowedTimeInSeconds);
//nd.setGenerateDebugOutput(true);

nd.setMinimumSpacing(dMinimumSpacing);
int nNester= nNesters[sNesters.find(sNester,0)];
nd.setNesterToUse(nNester);

// construct a NesterCaller object adding masters and childs
for (int s=0; s<_Entity.length(); s++) 
{
	String sHandle="";
	CoordSys csCP(_PtW, _XW, _YW, _ZW);
	Plane plnCP(_PtW, _ZW);
	PlaneProfile ppCP(csCP);
	
	if(sObjects==sChildPanels)
	{
		ChildPanel cp=(ChildPanel) _Entity[s];
		if (!cp.bIsValid()) continue;
		
		Body bdPanel=cp.realBody();

		//PlaneProfile ppChildPanel(csCP);
		ppCP.unionWith(bdPanel.shadowProfile(plnCP));
		//ppCP.joinRing(cp.plEnvelopeCnc(), false);
		sHandle=cp.handle();
	}
	else if(sObjects==sPLines)
	{
		EntPLine epl = (EntPLine)_Entity[s];
		if (!epl.bIsValid()) continue;
		PLine pl = epl.getPLine();
	
		ppCP.joinRing(pl, false);
		sHandle=epl.handle();
	}

	//CoordSys csCP=cp.coordSys();

	if (ppCP.area()>(U(1)*U(1)))
	{
		NesterChild nc(sHandle, ppCP);
		nester.addChild(nc);
		nc.setRotationAllowance(90);
	}
}

// do the actual nesting
int nSuccess = nester.nest(nd);
if (nSuccess==_kNROk) 
	reportMessage("\nNestResult: "+"OK");

if (nSuccess!=_kNROk) 
{
	reportMessage(T("|Not possible to nest|"));
	if (nSuccess==_kNRNoDongle)
		reportMessage(T("|No dongle present|"));
	eraseInstance();
	return;
}

// loop over the nester masters
double dSpacing=0;
double dOffset=U(250);

double dDistBetweenMP=U(1000);

int arMaster[] = nester.nesterMasterIndexes();

int nHSize[0];
int nWSize[0];
String sSize[0];
Map mpSize;

Point3d ptSipPanels=_Pt0;

_Pt0=_Pt0-_YW*U(2690);

Point3d ptBase=_Pt0;

for (int m=0; m<arMaster.length(); m++) 
{
	NesterMaster nm= nester.masterAt(m);
	
	PlaneProfile ppNm= nm.profShape();
	LineSeg ls1=ppNm.extentInDir(_XW);
	LineSeg ls2=ppNm.extentInDir(_YW);

	int nHeight=abs(_XW.dotProduct(ls1.ptStart()-ls1.ptEnd()));
	int nWidth=abs(_YW.dotProduct(ls2.ptStart()-ls2.ptEnd()));
	//reportNotice("\nHeight "+nHeight);
	//reportNotice("\nWidth "+nWidth);
	
	String sS=nWidth+"x"+nHeight;
	
	int nLoc=sSize.find(sS, -1);
	if (nLoc==-1)
	{
		sSize.append(sS);
		nHSize.append(nHeight);
		nWSize.append(nWidth);
	}
}

int nNumber=1;

String sNameCheckBox="Tolerance Check Box";
Group gpCheckBox(sNameCheckBox);

String sNamePanels="1220mm panels";
Group gpPanels(sNamePanels);

String sNameOffsetRebate="Offset for rebate clearance";
Group gpOffsetRebate(sNameOffsetRebate);


Point3d ptToCheck;

for (int s=0; s<sSize.length(); s++) 
{
	int nCount=0;
	for (int m=0; m<arMaster.length(); m++) 
	{
		int nIndexMaster = arMaster[m];
		NesterMaster nm= nester.masterAt(nIndexMaster);
		nm.transformBy(_Pt0-_PtW);
		
		PlaneProfile ppNm= nm.profShape();
		LineSeg ls1=ppNm.extentInDir(_XW);
		LineSeg ls2=ppNm.extentInDir(_YW);

		int nHeight=abs(_XW.dotProduct(ls1.ptStart()-ls1.ptEnd()));
		int nWidth=abs(_YW.dotProduct(ls2.ptStart()-ls2.ptEnd()));
	
		String sS=nWidth+"x"+nHeight;
		
		if (sS!=sSize[s]) continue;
			
		// Getting width of master
		String sOriginatorID=nm.originatorId();
		//reportNotice("\n"+sOriginatorID);
		
		int nLoc=sOriginatorIDs.find(sOriginatorID);
		
		//double dWidth= dWidths[nLoc];
		//double dWidth= U(4000);
		
		//reportNotice("\n"+ (nCount%2));
		if (nCount%2 < 1)
		{
			//reportNotice("\n yes");
			//First master panel of the pair	
			//nm.transformBy(_Pt0-(_PtW+_XW*dSpacing));
	
			PlaneProfile ppNm= nm.profShape();
			LineSeg ls1=ppNm.extentInDir(_XW);
			Point3d ptA=ls1.ptStart();
			//Point3d ptB=ls1.ptEnd();
			Point3d ptB=ptA+_XW*nHeight+_YW*nWidth;
			
			Point3d ptPanelA=ptA;
			Point3d ptPanelB=ptB;
			
			//ptB=ptB-_YW*U(0.1);
			ptB=ptB+_YW*(nWidth+dOffset);
			
			LineSeg lsNew(ptA, ptB);
			
			PLine plOutline(_ZW);
			plOutline.createRectangle(lsNew, _XW, _YW);

			//Create tolerance check box
			Point3d ptToleranceA=ptA;
			Point3d ptToleranceB=ptB;
			
			ptToleranceA=ptToleranceA-_XW*U(95)-_YW*U(95);
			ptToleranceB=ptToleranceB+_XW*U(95)+_YW*U(95);
			
			LineSeg lsTolerance(ptToleranceA, ptToleranceB);
			
			PLine plOutlineTolerance(_ZW);
			plOutlineTolerance.createRectangle(lsTolerance, _XW, _YW);
			
			EntPLine eplTolerance;
			eplTolerance.dbCreate(plOutlineTolerance);
			gpOffsetRebate.addEntity(eplTolerance, true);
			
			//Create 1220 Panels PLine
			//Panel 1
			Point3d ptPanel1A=ptPanelA;
			Point3d ptPanel1B=ptPanelB;
			
			LineSeg lsPanel1(ptPanel1A, ptPanel1B);
			
			PLine plOutlinePanel1(_ZW);
			plOutlinePanel1.createRectangle(lsPanel1, _XW, _YW);
			
			EntPLine eplPanel1;
			eplPanel1.dbCreate(plOutlinePanel1);
			gpPanels.addEntity(eplPanel1, true);
			
			//Panel 2
			Point3d ptPanel2A=ptPanelA;
			Point3d ptPanel2B=ptPanelB;
			
			ptPanel2A=ptPanel2A+_YW*(nWidth+dOffset);
			ptPanel2B=ptPanel2B+_YW*(nWidth+dOffset);
			
			LineSeg lsPanel2(ptPanel2A, ptPanel2B);
			
			PLine plOutlinePanel2(_ZW);
			plOutlinePanel2.createRectangle(lsPanel2, _XW, _YW);
			
			EntPLine eplPanel2;
			eplPanel2.dbCreate(plOutlinePanel2);
			gpPanels.addEntity(eplPanel2, true);
			
			CoordSys csMP(ptA, _XW, _YW, _ZW);
			
			_Pt0=ptA;
			ptToCheck=ptA;
			
			MasterPanel mp;
			mp.dbCreate(pStyle, csMP, plOutline);
			mp.setNumber(nNumber);
			mp.setName(sMPName);
			nNumber++;
			
			Point3d ptBlock=ptA+(_XW*nHeight);
			
			//lstPoints.setLength(0);
			//lstPoints.append(ptBlock);
			//tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString);

			CoordSys csBlock(ptBlock, _XW, _YW, _ZW);
			//MvBlockRef mvRef;
			//mvRef.dbCreate(csBlock, 1, 1, 1, "ToleranceCheck");
			//gpCheckBox.addEntity(mvRef, true);

		}
		else
		{
			ptToCheck=ptToCheck+_YW*(nWidth+dOffset);
		}
		
		nCount++;
		reportMessage("\nResult "+nIndexMaster +" "+nester.masterOriginatorIdAt(nIndexMaster) );
		
		int arChild[] = nester.childListForMasterAt(nIndexMaster);
		CoordSys arWorldXformIntoMaster[] = nester.childWorldXformIntoMasterAt(nIndexMaster);
		//CoordSys arChildXformIntoMaster[] = nester.childXformWithinMasterAt(nIndexMaster);

		if (arChild.length()!=arWorldXformIntoMaster.length())
		{
			reportNotice("Nester result invalid");
			break;
		}
		//show the childs within the master
		//Point3d ptMostLeft;
		//Point3d ptMostDown;
		Point3d ptBLChild;
		
		ChildPanel allChildPanels[0];
		EntPLine allEntPLines[0];
		Point3d ptAllPointsH[0];
		Point3d ptAllPointsV[0];
		for (int c=0; c<arChild.length(); c++) 
		{
			int nIndexChild = arChild[c];
			String strChild = nester.childOriginatorIdAt(nIndexChild);
			reportMessage("\n Child "+nIndexChild+" "+strChild );
			Entity ent; ent.setFromHandle(strChild);
			
			CoordSys cs = arWorldXformIntoMaster[c];
	
			cs.transformBy((_Pt0+_YW*(dSpacing))-_PtW);
	
			ent.transformBy(cs);
			

			if(sObjects==sChildPanels)
			{
				ChildPanel cp = (ChildPanel)ent;
				if (cp.bIsValid())
				{
					Body bdPanel=cp.realBody();
					//PLine plOut=cp.plEnvelopeCnc();
					ptAllPointsH.append(bdPanel.allVertices());
					//ptAllPointsH.append(plOut.vertexPoints(true));
					allChildPanels.append(cp);
				}
			}
			else if(sObjects==sPLines)
			{
				EntPLine epl = (EntPLine) ent;
				if (epl.bIsValid())
				{
					PLine pl = epl.getPLine();
					pl.setNormal(-_ZW);
					
					PlaneProfile ppThisSip(pl);
					LineSeg lsThisSip=ppThisSip.extentInDir(_XW);
					Vector3d vDirection=_XW;
					if (abs(_XW.dotProduct(lsThisSip.ptStart()-lsThisSip.ptStart())) < abs(_YW.dotProduct(lsThisSip.ptStart()-lsThisSip.ptStart())) )
					{
						vDirection=_YW;
					}
					
					String sValues[]={"PanelCode"};
					Map mpProp=ent.getAttachedPropSetMap("PanelInfo", sValues);
					String sValue=mpProp.getString("PanelCode");
					
					
					
					Sip sp;
					sp.dbCreate(pl, pSipStyle, 1);
					sp.setXAxisDirectionInXYPlane(vDirection);
					sp.setSubLabel(sValue);
					
					_Sip.append(sp);
					
					ChildPanel cp;
					Point3d ptLoc = sp.ptCen();
					//CoordSys csEcs(ptLoc, _XW, _YW, _ZW);
					cp.dbCreate(sp, ptLoc, _XW);
					cp.setBIsFlipped(false);
	
					CoordSys csTrans = cp.sipToMeTransformation();
					csTrans.invert();
					cp.transformBy(csTrans);
					
					if (cp.bIsValid())
					{
						allChildPanels.append(cp);
						allEntPLines.append(epl);
						ptAllPointsH.append(pl.vertexPoints(true));

					}
				}
			}
		}
		
		if (ptAllPointsH.length()>0)
		{
			ptAllPointsV.append(ptAllPointsH);
			//ptAllPointsH=Line(ptToCheck, _XW).projectPoints(ptAllPointsH);
			ptAllPointsH=Line(ptToCheck, _XW).orderPoints(ptAllPointsH);
			//ptMostLeft=ptAllPointsH[0];
					
			//ptAllPointsV=Line(ptToCheck, _YW).projectPoints(ptAllPointsV);
			ptAllPointsV=Line(ptToCheck, _YW).orderPoints(ptAllPointsV);
			//ptMostDown=ptAllPointsV[0];
					
			ptBLChild=Line(ptAllPointsH[0], _YW).closestPointTo(Line(ptAllPointsV[0], _XW));
			
			Vector3d vToMove=ptToCheck-ptBLChild;
			double dDistToMove=abs(vToMove.length());
			
			if (vToMove.length()>U(0.0005))
			{
	
				for (int i=0; i<allChildPanels.length(); i++)
				{
					allChildPanels[i].transformBy(vToMove);
					if(allEntPLines.length()>0)
						allEntPLines[i].transformBy(vToMove);
					//allChildPanels[i].setColor(1);
				}
			}
		}
		
		if (allChildPanels.length()==2)
		{
			Plane pln(_PtW, _ZW);
			Point3d ptBL1;
			PlaneProfile ppPanel1(pln);
			int nValidPane1;
			
			Point3d ptBL2;
			PlaneProfile ppPanel2(pln);
			int nValidPane2;
			
			//Find the extreme points of both panels
			ChildPanel cp1 = allChildPanels[0];
			if (cp1.bIsValid())
			{
				PLine plOut=cp1.plEnvelopeCnc();
				Point3d ptAllPoints[]=plOut.vertexPoints(true);
				ptAllPoints=Line(ptToCheck, _YW).orderPoints(ptAllPoints);
				ptBL1=ptAllPoints[0];
				ppPanel1.joinRing(plOut, false);
				ppPanel1.shrink(dMinimumSpacing*0.5);
				nValidPane1=true;
			}

			ChildPanel cp2 = allChildPanels[1];
			if (cp2.bIsValid())
			{
				PLine plOut=cp2.plEnvelopeCnc();
				Point3d ptAllPoints[]=plOut.vertexPoints(true);
				ptAllPoints=Line(ptToCheck, _YW).orderPoints(ptAllPoints);
				ptBL2=ptAllPoints[0];
				ppPanel2.joinRing(plOut, false);
				ppPanel2.shrink(dMinimumSpacing*0.5);
				nValidPane2=true;
			}
			
			if (nValidPane1 && nValidPane2)
			{
				double dDist1=_YW.dotProduct(ptToCheck-ptBL1);
				//reportNotice("\nDist1 "+dDist1);
				double dDist2=_YW.dotProduct(ptToCheck-ptBL2);
				//reportNotice("\nDist2 "+dDist2+"\n");
				if (abs(dDist1)>U(0.01))
				{
					ppPanel1.transformBy(_YW*dDist1);
					ppPanel1.intersectWith(ppPanel2);
					double dA1=ppPanel1.area();
					//reportNotice("\nArea1 "+dA1);
					if (ppPanel1.area()<(U(0.1)*U(0.1)))
					{
						allChildPanels[0].transformBy(_YW*dDist1);
						if(allEntPLines.length()>0)
							allEntPLines[0].transformBy(_YW*dDist1);
						//reportNotice("\nMove1");
					}
				}
				if (abs(dDist2)>U(0.01))
				{
					ppPanel2.transformBy(_YW*dDist2);
					ppPanel2.intersectWith(ppPanel1);
					double dA2=ppPanel2.area();
					//reportNotice("\nArea1 "+dA2);

					if (ppPanel2.area()<(U(0.1)*U(0.1)))
					{
						allChildPanels[1].transformBy(_YW*dDist2);
						if(allEntPLines.length()>0)
							allEntPLines[1].transformBy(_YW*dDist2);
						//reportNotice("\nMove2");
					}
				}
				//reportNotice("\n");
			}
		}
		
		
		if (nCount%2<0.1)
		{
			dSpacing=0;
			_Pt0=_Pt0-_YW*U(4000);
		}
		else
		{
			dSpacing=dSpacing+nWidth+dOffset;
		}
	
	}
	
	_Pt0=ptBase+_XW*U(8000);
	ptBase=_Pt0;
	dSpacing=0;
}

ptSipPanels=ptSipPanels+_YW*U(10000);

for (int i=0; i<_Sip.length(); i++)
{
	
	Sip sp=_Sip[i];
	
	CoordSys csSip=sp.coordSys();
	CoordSys csEcs(ptSipPanels, _XW, _YW, _ZW);
	
	CoordSys csTransform;
	csTransform.setToAlignCoordSys(sp.ptCen(), csSip.vecX(), csSip.vecY(), csSip.vecZ(), csEcs.ptOrg(), csEcs.vecY(), csEcs.vecZ(), csEcs.vecX());
	sp.transformBy(csTransform);
	
	ptSipPanels=ptSipPanels+_XW*U(1500);
}

// examine the nester result
int arLeftOverMaster[] = nester.leftOverMasterIndexes();
if(arLeftOverMaster.length()==0)
	reportMessage("\nNo left over MasterList" );
else
{
	reportMessage("\nLeft over MasterList" );
	for (int m=0; m<arLeftOverMaster.length() ; m++) 
	{
		reportMessage("\nMaster "+m+" "+nester.masterOriginatorIdAt(m));
	}
}

int arLeftOverChild[] = nester.leftOverChildIndexes();
if(arLeftOverChild.length()==0)
	reportMessage("\nNo left over ChildList" );
else
{
	reportMessage("\nLeft over ChildList" );
	Point3d ptInsertion=_Pt0+_XW*dSpacing;
} 

eraseInstance();
return;










#End
#BeginThumbnail









#End