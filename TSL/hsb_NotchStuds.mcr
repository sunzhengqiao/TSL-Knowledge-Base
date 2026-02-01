#Version 8
#BeginDescription
Last modified by: Alberto Jena (aj@hsb-cad.com)
23.01.2014  -  version 1.13























#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 13
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
* version 1.1: Add Property to filter beams with beam codes
*
* date: 02.02.2011
* version 1.3: Increased size of beamcut to allow some tolerance, in cutting the header beam
*
* date: 23.02.2011
* version 1.4: Add the label N to the beams that are notch
*
* date: 21.03.2011
* version 1.5: Set the flat stud that is fully noth a code X and set the color to red
*
* date: 04.04.2011
* version 1.6: Add the option to rip any horizontal beam that overlap the headers
*
* date: 23.09.2011
* version 1.7: Filter the beams that are completely cut and not put the N label
*
* date: 30.01.2012
* version 1.8: 	Add tolerance when there is one or two headers
*				Set the beams that are notch as a module.
*
* date: 03.02.2012
* version 1.9: 	Set the beams that are notch to color 6.
*
* date: 03.04.2012
* version 1.10: Remove the option to cut horizontal beams that was add in version 1.6
*
* date: 16.05.2012
* version 1.11: Increase the size of the tool so it notch all the studs
*
* date: 10.07.2013
* version 1.12: Add Property for Beam Code
*/

_ThisInst.setSequenceNumber(-100);

Unit(1,"mm"); // script uses mm

PropString sCode(1, "H", T("|Beam Code|"));

PropDouble dOffset (0, 1, T("|Tolerance|"));

PropString sFilterBeams(0, "", T("|Exclude studs with beam code|"));
sFilterBeams.setDescription(T("|Separate multiple entries by|") +" ';'");

String sArNY[] = {T("No"), T("Yes")};
PropString sModules(2,sArNY,T("Set notch beams as modules"), 0);
sModules.setDescription(T("|This will set all the beams that are notch as a module and will add the Label 'N' to them.|"));
int bModule = sArNY.find(sModules,0);

//String sArNY[] = {T("No"), T("Yes")};
//PropString sModules(3,sArNY,T("Set notch beams as modules"), 0);
//int bModule = sArNY.find(sModules,0);

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if(_bOnInsert)
{
	//_Map.setInt("nExecutionMode", 1);
	//showDialogOnce();
	if (insertCycleCount()>1) { eraseInstance(); return; }
	
	if (_kExecuteKey=="")
		showDialogOnce();
	
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


// transform filter tsl property into array
String sBeamFilter[0];
String sList = sFilterBeams;
int bBmFilter;

while (sList.length()>0 || sList.find(";",0)>-1)
{
	String sToken = sList.token(0);	
	sToken.trimLeft();
	sToken.trimRight();		
	sToken.makeUpper();
	sBeamFilter.append(sToken);
	//double dToken = sToken.atof();
	//int nToken = sToken.atoi();
	int x = sList.find(";",0);
	sList.delete(0,x+1);
	sList.trimLeft();	
	if (x==-1)
		sList = "";	
}

if (sBeamFilter.length() > 0)
	bBmFilter=TRUE;

int nErase=FALSE;

for (int e=0; e<_Element.length(); e++)
{
	Element el=_Element[e];
	
	CoordSys csEl = el.coordSys();
	Vector3d vx = csEl.vecX();
	Vector3d vy = csEl.vecY();
	Vector3d vz = csEl.vecZ();
	_Pt0=csEl.ptOrg();

	Beam bmAll[]=el.beam();

	Beam bmWithTool[0];
	
	Beam bmNoBlocking[0];
	for (int i=0; i<bmAll.length(); i++)
	{
		Beam bm=bmAll[i];
		if (bm.beamCode().token(0)==sCode)
		{
			bmWithTool.append(bm);
		}
		else
		{
			if (bBmFilter)
			{
				if (sBeamFilter.find(bm.beamCode().token(0), -1) == -1)
					bmNoBlocking.append(bm);
			}
			else
			{
				bmNoBlocking.append(bm);
			}
		}
	}
	
	Beam bmVer[]=vx.filterBeamsPerpendicularSort(bmNoBlocking);
	Beam bmHor[]=vy.filterBeamsPerpendicularSort(bmNoBlocking);
	
	if (bmVer.length()<1)	
	{
		continue;
	}
	else
	{
		nErase=TRUE;
	}
	
	Beam bmNotch[0];

	//Collect the number of headers that are in the panel
	double dExtraOffset=dOffset;
	Point3d ptAllCenters[0];
	for (int i=0; i<bmWithTool.length(); i++)
	{
		ptAllCenters.append(bmWithTool[i].ptCen());
	}
	
	if(ptAllCenters.length()>0)
	{
		Line ln1(ptAllCenters[0], vz);
		ptAllCenters=ln1.projectPoints(ptAllCenters);
		ptAllCenters=ln1.orderPoints(ptAllCenters, U(2));
		if (ptAllCenters.length()==1)
		{
			dExtraOffset=dOffset;
		}
		else
		{
			dExtraOffset=dOffset*2;
		}
	}

	for (int i=0; i<bmWithTool.length(); i++)
	{
		Beam bm=bmWithTool[i];
		Body bdCut=bm.realBody();
		
		Beam bmToCut[0];
		bmToCut=bdCut.filterGenBeamsIntersect(bmVer);
		//Point3d ptShiftedCentre=bm.ptCen()+((U(5))*bm.vecY())+(U(5)*bm.vecZ());
		Point3d ptShiftedCentre=bm.ptCen();
		ptShiftedCentre.vis(1);
		//BeamCut bmCut(ptShiftedCentre, bm.vecX(), bm.vecY(), bm.vecZ(), U(50000), (bm.dD(bm.vecY())+U(10)+(dExtraOffset*2)), (bm.dD(bm.vecZ())+U(10)+(dExtraOffset*2)));
		BeamCut bmCut(ptShiftedCentre, bm.vecX(), bm.vecY(), bm.vecZ(), U(50000), (bm.dD(bm.vecY())+(dExtraOffset*2)), (bm.dD(bm.vecZ())+(dExtraOffset*2))); 
		for(int j=0; j<bmToCut.length(); j++)
		{
			bmToCut[j].addToolStatic(bmCut);
			bmNotch.append(bmToCut[j]);

			if (bmToCut[j].dD(vz)<bmToCut[j].dD(vx))
			{
				String sCode=bmToCut[j].beamCode();
				String sCodeNew;
				bmToCut[j].setColor(1);
				String sLeft=sCode.token(0);
				if (sLeft!="")
				{
					String sRight=sCode.right(sLeft.length());
					sCodeNew="X"+sRight;
				}
				else
				{
					sCodeNew="X"+sCode;
				}
				bmToCut[j].setBeamCode(sCodeNew);
			}
		}
	}
	
	
	int nModCode=1;
	if (bModule)
	{
		for(int j=0; j<bmNotch.length(); j++)
		{
			Beam bm=bmNotch[j];
			AnalysedTool tls[] = bm.analysedTools(1);
			
			int nLabel=false;
			
			for (int i=0; i<tls.length(); i++)
			{
				AnalysedTool at = tls[i];
				if (at.toolType()=="AnalysedBeamCut")
				{
					nLabel=true;
				}
			}
			if (nLabel)
			{
				String sModule=bm.module();
				if (sModule=="")
				{
					String sHandle=_ThisInst.handle();
					sHandle=sHandle+nModCode;
					bm.setModule(sHandle);
					bm.setColor(6);
					nModCode++;
				}
				
				bm.setLabel("N");
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
