#Version 8
#BeginDescription
Creates a bill of materials in the Layout for Stickframe Walls in predefined groups

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 07.08.2012  -  version 1.20









#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 20
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
* date: 28.08.2009
* version 1.0: Release Version 
*
* date: 01.09.2009
* version 1.1: Order reset to include Locating plate 
*
* date: 14.09.2009
* version 1.2: Add the option to filter materials
*
* date: 01.10.2009
* version 1.3: Sort the timbers by length and height
*
* date: 29.10.2009
* version 1.4: Add the Grade Column
*
* date: 29.10.2009
* version 1.5: Add the Label Column
*
* date: 01.07.2010
* version 1.6: Addition of Label Column & Addition of BoxBlocking data
*
* date: 28.07.2010
* version 1.7: Support Imperial and Add Nominal values for the beams
*
* date: 05.08.2010
* version 1.8: Add Vent Beam Type and Group
*
* date: 05.08.2010
* version 1.9: Bugfix with the width and height been mix
*
* v1.10: 20-Jan-2010: David Rueda (dr@hsb-cad.com): Tsl can now work with shop drawings
*
* date: 11.02.2011
* version 1.11: Add a new Group just for the Cripples
*
* date: 23.03.2011
* version 1.12: Add the option to make the groups visible or imbisible
*
* date: 04.04.2011
* version 1.13: Add the way to show space studs as one group
*
* date: 13.04.2011
* version 1.14: Integrate the display of Posnum in this TSL checking interference
*
* date: 27.04.2011
* version 1.15: Show Complementary angles
*
* date: 06.06.2011
* version 1.16: Fix issue with the filter by material
*
* date: 07.06.2011
* version 1.17: Add property to exclude all sheetings
*
* date: 07.06.2011
* version 1.18: Add property to exclude all beams
*
* date: 07.06.2011
* version 1.19: Add property to exclude all beams
*
* date: 07.08.2020
* version 1.20: Fix issue with some angle cuts not showing on the table
*/

int nLunit = 2; // architectural (only used for beam length, others depend on hsb_settings)
int nPrec = 1; // precision (only used for beam length, others depend on hsb_settings)

double dOffset=U(3, 0.15);

String sArNY[] = {T("No"), T("Yes")};

String sPaperSpace = T("|paper space|");
String sShopdrawSpace = T("|shopdraw multipage|");
String sArSpace[] = { sPaperSpace , sShopdrawSpace };
PropString sSpace(2,sArSpace,T("|Drawing space|"));

PropString sDimStyle(0,_DimStyles, "Dim Style");
//PropString propHeader(1,"Text can be changed in the OPM","Table header");
PropInt nColor(0,3,"Color");

PropString strMaterial (1,"",T("Materials to exclude from the BOM"));
strMaterial.setDescription(T("Please fill the materials that you dont need to be list on the BOM, use ';' if you want to filter more that 1 material"));

PropString sCompAngle(5, sArNY, T("|Switch to Complementary Angle|"), 0);
int nCompAngle= sArNY.find(sCompAngle,0);

PropString sDoSheets(6, sArNY, T("|Show Sheets in the BOM|"), 1);
int nDoSheets= sArNY.find(sDoSheets,0);

PropString sDoBeams(7, sArNY, T("|Show Beams in the BOM|"), 1);
int nDoBeams= sArNY.find(sDoBeams,0);

PropString sDimStylePosnum(3,_DimStyles, "Dim Style Posnum");
PropInt nColorPosnum(1,3,"Color Posnum");

PropString sShowBmPosnum (4, sArNY, T("Show Beam Posnum"));
sShowBmPosnum.setDescription("");
int bShowBmPosnum = sArNY.find(sShowBmPosnum, 0);

int nValidZones[]={0,1,2,3,4,5,6,7,8,9,10};
int nRealZones[]={0,1,2,3,4,5,-1,-2,-3,-4,-5};
PropInt nZones (2, nValidZones, T("Show Posnum Zone, 0=none"), 0);
int nZone=nRealZones[nValidZones.find(nZones, 0)];

PropString strShowLabel(8,sArNY,T("Show Label Column"),1);
int bShowLabel = sArNY.find(strShowLabel, 0);


int bShowShPosnum=false;
if (nZone!=0)
	bShowShPosnum=true;

String sArrMaterials[0];
String sExtType=strMaterial;
sExtType.trimLeft();
sExtType.trimRight();
sExtType=sExtType+";";
for (int i=0; i<sExtType.length(); i++)
{
	String str=sExtType.token(i);
	str.trimLeft();
	str.trimRight();
	str.makeUpper();
	if (str.length()>0)
		sArrMaterials.append(str);
}//End OPM

if (_bOnInsert)
{
	showDialog();
	//int nSpace = sArSpace.find(sSpace);
	
	_Pt0=getPoint(T("Pick a point where the bottom horizontal dim will reference to"));
	if (sSpace == sPaperSpace)
	{	//Paper Space
  		Viewport vp = getViewport(T("Select the viewport from which the element is taken")); // select viewport
		_Viewport.append(vp);
	}
	else if (sSpace == sShopdrawSpace)
	{	//Shopdraw Space
		Entity ent = getShopDrawView(T("|Select the view entity from which the module is taken|")); // select ShopDrawView
		_Entity.append(ent);
	}

	return;
}//end bOnInsert

setMarbleDiameter(U(5, 0.2));

int nBeamType[0];
int nLevel[0];

nBeamType.append(_kSFJackOverOpening);			nLevel.append(4);
nBeamType.append(_kSFJackUnderOpening);			nLevel.append(4);
nBeamType.append(_kCrippleStud);						nLevel.append(4);
nBeamType.append(_kSFTransom);						nLevel.append(6);
nBeamType.append(_kKingStud);							nLevel.append(4);
nBeamType.append(_kSill);								nLevel.append(6);
nBeamType.append(_kBrace);								nLevel.append(6);
nBeamType.append(_kSFAngledTPLeft);					nLevel.append(3);
nBeamType.append(_kSFAngledTPRight);				nLevel.append(3);
nBeamType.append(_kSFBlocking);						nLevel.append(8);
nBeamType.append(_kBlocking);							nLevel.append(8);
nBeamType.append(_kSFSupportingBeam);				nLevel.append(5);
nBeamType.append(_kStud);								nLevel.append(4);
nBeamType.append(_kSFStudLeft);						nLevel.append(4);
nBeamType.append(_kSFStudRight);						nLevel.append(4);
nBeamType.append(_kSFTopPlate);						nLevel.append(3);
nBeamType.append(_kTopPlate);							nLevel.append(3);
nBeamType.append(_kSFBottomPlate);					nLevel.append(2);
nBeamType.append(_kHeader);							nLevel.append(7);
nBeamType.append(_kLocatingPlate);					nLevel.append(1);
nBeamType.append(_kSFVent);							nLevel.append(9);
nBeamType.append(_kTypeNotSet);						nLevel.append(8);
nBeamType.append(_kLog);								nLevel.append(8);
nBeamType.append(_kLath);								nLevel.append(10);
nBeamType.append(_kDakFrontEdge);					nLevel.append(11);
nBeamType.append(_kDakCenterJoist);					nLevel.append(12);


int nBeamTypeToAvoid[0];
//nBeamTypeToAvoid.append(_kBlocking);

int nVisible[0];
String sLevelName[0];
sLevelName.append("Space Stud"); /*0*/				nVisible.append(true);	
sLevelName.append("Locating Plate"); /*1*/			nVisible.append(true);	
sLevelName.append("Bottom Plate"); /*2*/			nVisible.append(true);
sLevelName.append("Top Plate"); /*3*/				nVisible.append(true);
sLevelName.append("Stud"); /*4*/					nVisible.append(true);
sLevelName.append("Cripple"); /*5*/					nVisible.append(true);
sLevelName.append("Transom"); /*6*/				nVisible.append(true);
sLevelName.append("Lintel"); /*7*/					nVisible.append(true);
sLevelName.append("Blocking"); /*8*/				nVisible.append(true);
sLevelName.append("Vent"); /*9*/					nVisible.append(true);
sLevelName.append("Service Battens"); /*10*/		nVisible.append(true);
sLevelName.append("Battens"); /*11*/			nVisible.append(true);
sLevelName.append("Connectors"); /*12*/		nVisible.append(true);
sLevelName.append("Generic");						nVisible.append(true);
//Generic should be always the last one in this array

String sActualValue[0];				String sNominal[0];		

String sAux; 
sAux.formatUnit(0.75, sDimStyle);
sActualValue.append(sAux);			sNominal.append("1");
sAux.formatUnit(1.5, sDimStyle);
sActualValue.append(sAux);			sNominal.append("2");
sAux.formatUnit(2.5, sDimStyle);
sActualValue.append(sAux);			sNominal.append("3");
sAux.formatUnit(3.5, sDimStyle);
sActualValue.append(sAux);			sNominal.append("4");
sAux.formatUnit(5.5, sDimStyle);
sActualValue.append(sAux);			sNominal.append("6");
sAux.formatUnit(7.25, sDimStyle);
sActualValue.append(sAux);			sNominal.append("8");
sAux.formatUnit(9.25, sDimStyle);
sActualValue.append(sAux);			sNominal.append("10");
sAux.formatUnit(11.25, sDimStyle);
sActualValue.append(sAux);			sNominal.append("12");
sAux.formatUnit(13.25, sDimStyle);
sActualValue.append(sAux);			sNominal.append("14");
sAux.formatUnit(15.25, sDimStyle);
sActualValue.append(sAux);			sNominal.append("16");


Display dp(nColor); // use color of entity for frame
dp.dimStyle(sDimStyle); // dimstyle was adjusted for display in paper space, sets textHeight

Element el;
int nZoneIndex;
Entity entAll[0];	

//coordSys
CoordSys ms2ps, ps2ms;	

//paperspace
if ( sSpace == sPaperSpace ){
	Viewport vp;
	if (_Viewport.length()==0) 
	{
		eraseInstance();
		return; // _Viewport array has some elements
	}
		
	vp = _Viewport[_Viewport.length()-1]; // take last element of array
	_Viewport[0] = vp; // make sure the connection to the first one is lost

	// check if the viewport has hsb data
	if (!vp.element().bIsValid()) 
		return;

	ms2ps = vp.coordSys();
	ps2ms = ms2ps;
	ps2ms.invert();
	el = vp.element();
	nZoneIndex = vp.activeZoneIndex();
}

//shopdrawspace
else if (sSpace == sShopdrawSpace ) {
	
	if (_Entity.length()==0)
	{
		eraseInstance();
		return; // _Entity array has some elements
	}
	
	ShopDrawView sv = (ShopDrawView)_Entity[0];
	
	if (!sv.bIsValid()) 
		return;
	
	// interprete the list of ViewData in my _Map
	ViewData arViewData[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets,0); // 2 means verbose
	int nIndFound = ViewData().findDataForViewport(arViewData, sv);// find the viewData for my view
	if (nIndFound<0) 
		return; // no viewData found
	
	ViewData vwData = arViewData[nIndFound];
	Entity arEnt[] = vwData.showSetEntities();
	
	ms2ps = vwData.coordSys();
	ps2ms = ms2ps;
	ps2ms.invert();
	
	for (int i = 0; i < arEnt.length(); i++)
	{
		Entity ent = arEnt[i];
		if (arEnt[i].bIsKindOf(Element()))
		{
			el=(Element) ent;
			break;
		}
	}
}
sSpace.setReadOnly(1);
if( !el.bIsValid() )return;


//Beam bmToStart[]=el.beam();
GenBeam gb[]=el.genBeam();

GenBeam gbAll[]=GenBeam().filterGenBeamsNotInSubAssembly(gb);

Beam bmAll[0];

for (int i=0; i<gbAll.length(); i++)
{
	Beam bm=(Beam) gbAll[i];
	if (bm.bIsValid())
	{
		bmAll.append(bm);
	}
}

String strAllKeys[0];
int nQtyThisSA[0];
Beam bmMainSA[0];
String sPosNumSA[0];
double dWidthSA[0];
double dHeightSA[0];
double dLengthSA[0];


Point3d ptLocation[0];
String sPosNumToShow[0];

TslInst tslAll[]=el.tslInst();

for (int i=0; i<tslAll.length(); i++)
{
	TslInst tsl=tslAll[i];
	if (tsl.scriptName()=="hsb_SpaceStudAssembly")
	{
		Map mp=tsl.map();
		if (mp.hasString("SpaceStudAssembly"))
		{
			String sThisKey=mp.getString("SpaceStudAssembly");
			int nLoc=strAllKeys.find(sThisKey, -1);
			if (nLoc != -1)
			{
				nQtyThisSA[nLoc]++;
				if (bShowBmPosnum)
				{
					ptLocation.append(tsl.ptOrg());
					sPosNumToShow.append(tsl.posnum());
				}
			}
			else
			{
				strAllKeys.append(sThisKey);
				nQtyThisSA.append(1);
				Beam bmThisTSL[]=tsl.beam();
				bmMainSA.append(bmThisTSL[0]);
				sPosNumSA.append(tsl.posnum());
				dWidthSA.append(mp.getDouble("Width"));
				dHeightSA.append(mp.getDouble("Height"));
				dLengthSA.append(mp.getDouble("Length"));
				if (bShowBmPosnum)
				{
					ptLocation.append(tsl.ptOrg());
					sPosNumToShow.append(tsl.posnum());
				}
			}
		}
	}
}

Point3d ptDraw=_Pt0;
String sTitle="Prefabricated Cuts";
double dTxtH=dp.textHeightForStyle(sTitle, sDimStyle);

Map mpBeams;
if (nDoBeams)
{
for (int i=0; i<bmAll.length(); i++)
{
	Beam bm=bmAll[i];
	int nBmType=bm.type();
	
	int nAvoid=nBeamTypeToAvoid.find(nBmType, -1);
	if (nAvoid!=-1)
		continue;
	
	int nLocation=nBeamType.find(nBmType, -1);
	if (nLocation!=-1)
	{
		//It's one of the groups from above
		int nLevelValue=nLevel[nLocation];
		if (nVisible[nLevelValue])
		{
			String sBeamCategory=sLevelName[nLevelValue];
			mpBeams.appendEntity(sBeamCategory, bm);
		}
	}
	else
	{
		//Generic Beam
		mpBeams.appendEntity("Generic", bm);
	}
}



dp.draw(sTitle,ptDraw,_XW,_YW,1,-1);
ptDraw=ptDraw-_YW*(dTxtH*1.5);

for (int t=0; t<sLevelName.length(); t++)
{
	String sGroupName=sLevelName[t];
	Beam arBeam[0];

	// build lists of items to display
	int nNum = 0; // number of different items; make sure nNum is always the size of the arrays
	int arCount[0]; // counter of equal

	String arPos[0]; // posnum
	String arW[0]; // width
	String arH[0]; // height
	String arL[0]; // length or height
	String arWToShow[0];
	String arHToShow[0];
	double arDLength[0];
	String arCN[0];
	String arCP[0];
	String arGrade[0];
	String arLabel[0];
	
	double dTxtLCount=0;
	double dTxtLPos=0;
	double dTxtLW=0;
	double dTxtLL=0;
	double dTxtLCN=0;
	double dTxtLGrade=0;
	double dTxtLLabel=0;

	//ptLocation
	//sPosNumToShow

	for (int m=0; m<mpBeams.length(); m++)
	{
		if (mpBeams.keyAt(m)==sGroupName)
		{
			Entity ent=mpBeams.getEntity(m);
			Beam bmFromMp=(Beam) ent;
			if (bmFromMp.bIsValid())
				arBeam.append(bmFromMp);
			
		}
	}// End Map Beams Loop
	
	//Add the information from the space stud instead of from the beams
	
	//String strAllKeys[0];
	//int nQtyThisSA[0];
	//Beam bmMainSA[0];
	//String sPosNumSA[0];
	//double dWidthSA[0];
	//double dHeightSA[0];
	//double dLengthSA[0];
	
	int nStud=false;
	if (sGroupName=="Space Stud")
	{
		for (int i=0; i<strAllKeys.length(); i++)
		{
			// a new item for the list is found
			String strPos = String(sPosNumSA[i]);
			String sSubLabel2 = bmMainSA[i].subLabel2();
			sSubLabel2.trimLeft(); sSubLabel2.trimRight();
			sSubLabel2.makeUpper();
			if (strPos=="-1") strPos = "";
	
			double dLength1=dLengthSA[i];
			String strLength; strLength.formatUnit(dLength1, sDimStyle);
	
			String strWidth; strWidth.formatUnit(dWidthSA[i], sDimStyle);
			int nLocation=sActualValue.find(strWidth, -1);
			if (nLocation!=-1 && sSubLabel2!="EWP")
				arWToShow.append(sNominal[nLocation]);
			else
				arWToShow.append(strWidth);
			
			String strHeight; strHeight.formatUnit(dHeightSA[i], sDimStyle);
			nLocation=sActualValue.find(strHeight, -1);
			if (nLocation!=-1&& sSubLabel2!="EWP")
				arHToShow.append(sNominal[nLocation]);
			else
				arHToShow.append(strHeight);
	
			arCount.append(nQtyThisSA[i]);
			arW.append(strWidth);
			arL.append(strLength);
			arDLength.append(dLength1);
			arPos.append(strPos);
			arH.append(strHeight);
			//arCN.append(bmMainSA[i].strCutN());
			//arCP.append(bmMainSA[i].strCutP());

			// AJ 27.04.2011				
			String sCutN=bmMainSA[i].strCutN(); 
			
					
			String sCutP=bmMainSA[i].strCutP(); 			
			String sCutNC=bmMainSA[i].strCutNC(); 			
			String sCutPC=bmMainSA[i].strCutPC(); 			
			String sNewCutN=sCutN; 			
			String sNewCutP=sCutP; 			
			String sNewCutNC=sCutNC; 			
			String sNewCutPC=sCutPC; 
			
			//CutN 
			double dValueN;
			String sValueN;
			String sNewValueN;
			
			sValueN=sCutN.token(0, ">"); 
			dValueN=sValueN.atof(); 	
			sNewValueN.format("%2.0f", dValueN);
			sNewCutN=sNewValueN; 
			sNewCutN+=">"; 
			sValueN=sCutN.token(1, ">"); 
			dValueN=sValueN.atof(); 
			sNewValueN.formatUnit(dValueN, 2, 0);
			sNewCutN+=sNewValueN;
			
			//CutP
			double dValueP;
			String sValueP;
			String sNewValueP;
			
			sValueP=sCutP.token(0, ">"); 
			dValueP=sValueP.atof(); 	
			sNewValueP.format("%2.0f", dValueP);
			sNewCutP=sNewValueP; 
			sNewCutP+=">"; 
			sValueP=sCutN.token(1, ">"); 
			dValueP=sValueP.atof(); 
			sNewValueP.formatUnit(dValueP, 2, 0);
			sNewCutP+=sNewValueP;	
			if (nCompAngle) 			
			{   				
				//CutN 
				double dValue;
				String sValue;
				String sNewValue; 
				
				sValue=sCutN.token(0, ">"); 
				dValue=sValue.atof(); 	
				if (dValue<0) 
					dValue=-90-dValue; 
				else 
					dValue=90-dValue; 
				sNewValue.format("%2.0f", dValue);
				sNewCutN=sNewValue; 
				sNewCutN+=">"; 
				sValue=sCutN.token(1, ">"); 
				dValue=sValue.atof(); 
				if (dValue<0) 
					dValue=-90-dValue; 
				else 
					dValue=90-dValue; 
				sNewValue.format("%2.0f", dValue);
				sNewCutN+=sNewValue; 
				
				//CutP
				sValue=sCutP.token(0, ">"); 
				dValue=sValue.atof(); 	
				if (dValue<0) 
					dValue=-90-dValue; 
				else 
					dValue=90-dValue; 
				sNewValue.format("%2.0f", dValue);
				sNewCutP=sNewValue; 
				sNewCutP+=">"; 
				sValue=sCutP.token(1, ">"); 
				dValue=sValue.atof(); 
				if (dValue<0) 
					dValue=-90-dValue; 
				else 
					dValue=90-dValue; 
				sNewValue.format("%2.0f", dValue);
				sNewCutP+=sNewValue; 

				//CutNC
				sValue=sCutNC.token(0, ">"); 
				dValue=sValue.atof(); 	
				if (dValue<0) 
					dValue=-90-dValue; 
				else 
					dValue=90-dValue; 
				sNewValue.format("%2.0f", dValue);
				sNewCutNC=sNewValue; 
				sNewCutNC+=">"; 
				sValue=sCutNC.token(1, ">"); 
				dValue=sValue.atof(); 
				if (dValue<0) 
					dValue=-90-dValue; 
				else 
					dValue=90-dValue; 
				sNewValue.format("%2.0f", dValue);
				sNewCutNC+=sNewValue; 
				
				//CutPC
				sValue=sCutPC.token(0, ">"); 
				dValue=sValue.atof(); 	
				if (dValue<0) 
					dValue=-90-dValue; 
				else 
					dValue=90-dValue; 
				sNewValue.format("%2.0f", dValue);
				sNewCutPC=sNewValue; 
				sNewCutPC+=">"; 
				sValue=sCutPC.token(1, ">"); 
				dValue=sValue.atof(); 
				if (dValue<0) 
					dValue=-90-dValue; 
				else 
					dValue=90-dValue; 
				sNewValue.format("%2.0f", dValue);
				sNewCutPC+=sNewValue; 

			} 
			
			arCN.append(sNewCutN);
			arCP.append(sNewCutP);
			
			arGrade.append(bmMainSA[i].grade());
			arLabel.append(bmMainSA[i].label());
	
			//Check the space needed for the table
			double dAux=dp.textLengthForStyle("Amount", sDimStyle);
			if (dTxtLCount < dAux)
				dTxtLCount = dAux;
				
			dAux=dp.textLengthForStyle(strPos, sDimStyle);
			if (dTxtLPos < dAux)
				dTxtLPos= dAux;
	
			dAux=dp.textLengthForStyle(arWToShow[arWToShow.length()-1]+ " x " +arHToShow[arHToShow.length()-1], sDimStyle);
			if (dTxtLW < dAux)
				dTxtLW= dAux;
	
			dAux=dp.textLengthForStyle(strLength, sDimStyle);
			if (dTxtLL< dAux)
				dTxtLL= dAux;
				
//			dAux=dp.textLengthForStyle(bmMainSA[i].strCutN()+" - "+bmMainSA[i].strCutP(), sDimStyle);
			dAux=dp.textLengthForStyle(sNewCutN+" - "+sNewCutP, sDimStyle);			
			if (dTxtLCN< dAux)
				dTxtLCN= dAux;
				
			dAux=dp.textLengthForStyle(bmMainSA[i].grade(), sDimStyle);
			if (dTxtLGrade < dAux)
				dTxtLGrade= dAux;
	
			dAux=dp.textLengthForStyle(bmMainSA[i].label(), sDimStyle);
			if (dTxtLLabel < dAux)
				dTxtLLabel= dAux;
			
			nStud=true;
		}
		
	}
	
	//reportNotice("\n"+sGroupName+" "+arBeam.length());
	
	for (int i=0; i<arBeam.length(); i++)
	{
		// loop over list items
		int bNew = TRUE;
		Beam bm = arBeam[i];
		if (bShowBmPosnum)
		{
			ptLocation.append(bm.ptCen());
			sPosNumToShow.append(String(bm.posnum()));
		}
		
		for (int l=0; l<nNum; l++)
		{
			String strPos = String(bm.posnum());
			if (strPos=="-1") strPos = "";

			//String strLength; strLength.formatUnit(bm.solidLength(), nLunit, nPrec);
			String strLength; strLength.formatUnit(bm.solidLength(), sDimStyle);
			String strWidth; strWidth.formatUnit(bm.dW(),sDimStyle);
			String strHeight; strHeight.formatUnit(bm.dH(),sDimStyle);
			if ( (strHeight==arH[l]) && (strPos==arPos[l]) && (strWidth==arW[l]) && (strLength==arL[l]))
			{
				bNew = FALSE;
				arCount[l]++;
				break; // out of inner for loop, we have found the equal one
			}
		}
		if (bNew)
		{ // a new item for the list is found
			String strPos = String(bm.posnum());
			String sSubLabel2 = bm.subLabel2();
			sSubLabel2.trimLeft(); sSubLabel2.trimRight();
			sSubLabel2.makeUpper();
			if (strPos=="-1") strPos = "";

			double dLength1=bm.solidLength();
			//String strLength; strLength.formatUnit(dLength1, nLunit, nPrec);
			String strLength; strLength.formatUnit(dLength1, sDimStyle);

			String strWidth; strWidth.formatUnit(bm.dW(), sDimStyle);
			int nLocation=sActualValue.find(strWidth, -1);
			if (nLocation!=-1 && sSubLabel2!="EWP")
				arWToShow.append(sNominal[nLocation]);
			else
				arWToShow.append(strWidth);
			
			String strHeight; strHeight.formatUnit(bm.dH(), sDimStyle);
			nLocation=sActualValue.find(strHeight, -1);
			if (nLocation!=-1&& sSubLabel2!="EWP")
				arHToShow.append(sNominal[nLocation]);
			else
				arHToShow.append(strHeight);

			arCount.append(1);
			arW.append(strWidth);
			arL.append(strLength);
			arDLength.append(dLength1);
			arPos.append(strPos);
			arH.append(strHeight);
			//arCN.append(bm.strCutN());
			//arCP.append(bm.strCutP());
			
			// AJ 27.04.2011				
			String sCutN=bm.strCutN(); 			
			String sCutP=bm.strCutP(); 			
			String sCutNC=bm.strCutNC(); 			
			String sCutPC=bm.strCutPC(); 			
			String sNewCutN=sCutN; 			
			String sNewCutP=sCutP; 			
			String sNewCutNC=sCutNC; 			
			String sNewCutPC=sCutPC; 
			
			//CutN
			double dValueN;
			String sValueN;
			String sNewValueN;
			
			sValueN=sCutN.token(0, ">"); 
			dValueN=sValueN.atof(); 	
			sNewValueN.format("%2.0f", dValueN);
			sNewCutN=sNewValueN; 
			sNewCutN+=">"; 
			sValueN=sCutN.token(1, ">"); 
			dValueN=sValueN.atof();
			sNewValueN.formatUnit(dValueN, 2, 0);
			sNewCutN+=sNewValueN;
			
			//CutP
			double dValueP;
			String sValueP;
			String sNewValueP;
			
			sValueP=sCutP.token(0, ">"); 
			dValueP=sValueP.atof(); 	
			sNewValueP.format("%2.0f", dValueP);
			sNewCutP=sNewValueP; 
			sNewCutP+=">"; 
			sValueP=sCutN.token(1, ">"); 
			dValueP=sValueP.atof();
			sNewValueP.formatUnit(dValueP, 2, 0);
			sNewCutP+=sNewValueP;	
									
			if (nCompAngle) 			
			{   				
				//CutN 
				double dValue;
				String sValue;
				String sNewValue; 
				
				sValue=sCutN.token(0, ">"); 
				dValue=sValue.atof(); 	
				if (dValue<0) 
					dValue=-90-dValue; 
				else 
					dValue=90-dValue; 
				sNewValue.format("%2.0f", dValue);
				sNewCutN=sNewValue; 
				sNewCutN+=">"; 
				sValue=sCutN.token(1, ">"); 
				dValue=sValue.atof(); 
				if (dValue<0) 
					dValue=-90-dValue; 
				else 
					dValue=90-dValue; 
				sNewValue.format("%2.0f", dValue);
				sNewCutN+=sNewValue; 
				
				//CutP
				sValue=sCutP.token(0, ">"); 
				dValue=sValue.atof(); 	
				if (dValue<0) 
					dValue=-90-dValue; 
				else 
					dValue=90-dValue; 
				sNewValue.format("%2.0f", dValue);
				sNewCutP=sNewValue; 
				sNewCutP+=">"; 
				sValue=sCutP.token(1, ">"); 
				dValue=sValue.atof(); 
				if (dValue<0) 
					dValue=-90-dValue; 
				else 
					dValue=90-dValue; 
				sNewValue.format("%2.0f", dValue);
				sNewCutP+=sNewValue; 

				//CutNC
				sValue=sCutNC.token(0, ">"); 
				dValue=sValue.atof(); 	
				if (dValue<0) 
					dValue=-90-dValue; 
				else 
					dValue=90-dValue; 
				sNewValue.format("%2.0f", dValue);
				sNewCutNC=sNewValue; 
				sNewCutNC+=">"; 
				sValue=sCutNC.token(1, ">"); 
				dValue=sValue.atof(); 
				if (dValue<0) 
					dValue=-90-dValue; 
				else 
					dValue=90-dValue; 
				sNewValue.format("%2.0f", dValue);
				sNewCutNC+=sNewValue; 
				
				//CutPC
				sValue=sCutPC.token(0, ">"); 
				dValue=sValue.atof(); 	
				if (dValue<0) 
					dValue=-90-dValue; 
				else 
					dValue=90-dValue; 
				sNewValue.format("%2.0f", dValue);
				sNewCutPC=sNewValue; 
				sNewCutPC+=">"; 
				sValue=sCutPC.token(1, ">"); 
				dValue=sValue.atof(); 
				if (dValue<0) 
					dValue=-90-dValue; 
				else 
					dValue=90-dValue; 
				sNewValue.format("%2.0f", dValue);
				sNewCutPC+=sNewValue; 

			} 
			
			arCN.append(sNewCutN);
			arCP.append(sNewCutP);
			
			
			
			
			arGrade.append(bm.grade());
			arLabel.append(bm.label());

			//Check the space needed for the table
			double dAux=dp.textLengthForStyle("Amount", sDimStyle);
			if (dTxtLCount < dAux)
				dTxtLCount = dAux;
				
			dAux=dp.textLengthForStyle(strPos, sDimStyle);
			if (dTxtLPos < dAux)
				dTxtLPos= dAux;

			dAux=dp.textLengthForStyle(arWToShow[arWToShow.length()-1]+ " x " +arHToShow[arHToShow.length()-1], sDimStyle);
			if (dTxtLW < dAux)
				dTxtLW= dAux;

			dAux=dp.textLengthForStyle(strLength, sDimStyle);
			if (dTxtLL< dAux)
				dTxtLL= dAux;
				
//			dAux=dp.textLengthForStyle(bm.strCutN()+" - "+bm.strCutP(), sDimStyle);
			dAux=dp.textLengthForStyle(sNewCutN+" - "+sNewCutP, sDimStyle);			
			if (dTxtLCN< dAux)
				dTxtLCN= dAux;
				
			dAux=dp.textLengthForStyle(bm.grade(), sDimStyle);
			if (dTxtLGrade < dAux)
				dTxtLGrade= dAux;

			dAux=dp.textLengthForStyle(bm.label(), sDimStyle);
			if (dTxtLLabel < dAux)
				dTxtLLabel= dAux;

			nNum++;
		}
	}	



	if (arBeam.length()>0 || nStud)
	{
		//The information of that Group is ready to display
		//Display the Title of the Group
		dp.draw(sGroupName,ptDraw,_XW,_YW,1,-1);
		ptDraw=ptDraw-_YW*(dTxtH*1.5);
		Point3d ptBaseLine=ptDraw;
		//Check if the title is not bigger than the text on the columns
		
		double dAux=dp.textLengthForStyle("Posnum", sDimStyle);
		if (dTxtLPos < dAux)
			dTxtLPos= dAux;
		
		dAux=dp.textLengthForStyle("Dimension", sDimStyle);
		if ( (dTxtLW) < dAux)
			dTxtLW= dAux;

		dAux=dp.textLengthForStyle("Length", sDimStyle);
		if (dTxtLL< dAux)
			dTxtLL= dAux;
		
		dAux=dp.textLengthForStyle("Angle", sDimStyle);
		if (dTxtLCN< dAux)
			dTxtLCN= dAux;
		
		dAux=dp.textLengthForStyle("Grade", sDimStyle);
		if (dTxtLGrade< dAux)
			dTxtLGrade= dAux;
			
		dAux=dp.textLengthForStyle("Label", sDimStyle);
		if (dTxtLLabel< dAux)
			dTxtLLabel= dAux;

		//Display the Title of each column
		dp.draw("Posnum",ptBaseLine,_XW,_YW,1,-1);
		ptBaseLine=ptBaseLine+_XW*(dTxtLPos+dOffset);
		
		if(bShowLabel)
		{
			dp.draw("Label",ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLLabel+dOffset);
		}

		dp.draw("Dimension",ptBaseLine,_XW,_YW,1,-1);
		ptBaseLine=ptBaseLine+_XW*(dTxtLW+dOffset);

		dp.draw("Length",ptBaseLine,_XW,_YW,1,-1);
		ptBaseLine=ptBaseLine+_XW*(dTxtLL+dOffset);
		
		dp.draw("Angle",ptBaseLine+_XW*(dTxtLCN*0.3),_XW,_YW,1,-1);
		ptBaseLine=ptBaseLine+_XW*(dTxtLCN+dOffset);

		dp.draw("Amount",ptBaseLine,_XW,_YW,1,-1);
		ptBaseLine=ptBaseLine+_XW*(dTxtLCount+dOffset);

		dp.draw("Grade",ptBaseLine,_XW,_YW,1,-1);
		ptBaseLine=ptBaseLine+_XW*(dTxtLGrade+dOffset);
		

		ptDraw=ptDraw-_YW*(dTxtH*1.5);
		
		
		//Replace the width and height with their nominal values
		//reportNotice("\n"+);
				
		//Sort the Arrays to Display
		
		int nNrOfRows=arPos.length();
		int bAscending=TRUE;
		
		for(int s1=1; s1<nNrOfRows; s1++)
		{
			int s11 = s1;
			for(int s2=s1-1; s2>=0; s2--)
			{
				int bSort = arDLength[s11] > arDLength[s2];
				if( bAscending )
				{
					bSort = arDLength[s11] < arDLength[s2];
				}
				if( bSort )
				{
					arPos.swap(s2, s11);
					arLabel.swap(s2, s11);
					arW.swap(s2, s11);
					arH.swap(s2, s11);
					arL.swap(s2, s11);
					arDLength.swap(s2, s11);
					arCN.swap(s2, s11);
					arCP.swap(s2, s11);
					arCount.swap(s2, s11);
					arGrade.swap(s2, s11);
					arWToShow.swap(s2, s11);
					arHToShow.swap(s2, s11);
					
		
					s11=s2;
				}
			}
		}
		
		
		for(int s1=1; s1<nNrOfRows; s1++)
		{
			int s11 = s1;
			for(int s2=s1-1; s2>=0; s2--)
			{
				int bSort = arH[s11] < arH[s2];
				if( bAscending )
				{
					bSort = arH[s11] > arH[s2];
				}
				if( bSort )
				{
					arPos.swap(s2, s11);
					arLabel.swap(s2, s11);
					arW.swap(s2, s11);
					arH.swap(s2, s11);
					arL.swap(s2, s11);
					arDLength.swap(s2, s11);
					arCN.swap(s2, s11);
					arCP.swap(s2, s11);
					arCount.swap(s2, s11);
					arGrade.swap(s2, s11);
					arWToShow.swap(s2, s11);
					arHToShow.swap(s2, s11);

					s11=s2;
				}
			}
		}
		//End of the sorting
		
		
		
		for (int d=0; d<arPos.length(); d++)
		{
			//reportNotice("\n"+arW[d]);

			ptBaseLine=ptDraw;

			//Display the Values of each row
			dp.draw(arPos[d],ptBaseLine,_XW,_YW,1,-1);//+_XW*(dTxtLPos*.3)
			ptBaseLine=ptBaseLine+_XW*(dTxtLPos+dOffset);

			if(bShowLabel)
			{	
				dp.draw(arLabel[d],ptBaseLine,_XW,_YW,1,-1);//+_XW*(dTxtLGrade*.45)
				ptBaseLine=ptBaseLine+_XW*(dTxtLLabel+dOffset);
			}
			
			dp.draw(arWToShow[d]+" x "+arHToShow[d],ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLW+dOffset);
	
			dp.draw(arL[d],ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLL+dOffset);
	
			dp.draw(arCN[d]+" - "+arCP[d],ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLCN+dOffset);
	
			dp.draw(arCount[d],ptBaseLine+_XW*(dTxtLCount*.45),_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLCount+dOffset);
	
			dp.draw(arGrade[d],ptBaseLine,_XW,_YW,1,-1);//+_XW*(dTxtLGrade*.45)
			ptBaseLine=ptBaseLine+_XW*(dTxtLGrade+dOffset);

			ptDraw=ptDraw-_YW*(dTxtH*1.5);

		}
		ptDraw=ptDraw-_YW*(dTxtH*0.5);
	}
}//End loop throw all levels

}

if (nDoSheets)
{
	//BOM for Sheetings
	Sheet shAll[]=el.sheet();
	
	Map mpSheet;
	
	String strSheetNames[0];
	for (int i=0; i<shAll.length(); i++)
	{
		Sheet sh=shAll[i];
		String sName=sh.material();
		String sMaterial=sh.material();
		sMaterial.makeUpper();
		int nLocation=strSheetNames.find(sName, -1);
		if (sArrMaterials.find(sMaterial, -1)==-1)//Filter the material Names
		{
			if (nLocation==-1)
			{
				strSheetNames.append(sName);
			}
		}
		if (bShowShPosnum)
		{
			int nThisZone=sh.myZoneIndex();
			if (nThisZone==nZone)
			{
				ptLocation.append(sh.ptCenSolid());
				sPosNumToShow.append(String(sh.posnum()));
			}
		}
	}
	
	sTitle="Wallboard";
	dp.draw(sTitle,ptDraw,_XW,_YW,1,-1);
	ptDraw=ptDraw-_YW*(dTxtH*1.5);
	
	
	for (int t=0; t<strSheetNames.length(); t++)
	{
		String sGroupName=strSheetNames[t];
		Sheet arSheet[0];
	
		// build lists of items to display
		int nNum = 0; // number of different items; make sure nNum is always the size of the arrays
		int arCount[0]; // counter of equal
	
		String arPos[0]; // posnum
		String arW[0]; // width
		String arT[0]; // thickness
		String arL[0]; // length or height
		
		double dTxtLCount=0;
		double dTxtLPos=0;
		double dTxtLW=0;
		double dTxtLT=0;
	
		for (int m=0; m<shAll.length(); m++)
		{
			if (shAll[m].material()==sGroupName)
			{
				arSheet.append(shAll[m]);
			}
		}// End Map Beams Loop
		
		//reportNotice("\n"+sGroupName+" "+arSheet.length());
		
		for (int i=0; i<arSheet.length(); i++)
		{
			// loop over list items
			int bNew = TRUE;
			Sheet sh = arSheet[i];
			for (int l=0; l<nNum; l++)
			{
				String strPos = String(sh.posnum());
				if (strPos=="-1") strPos = "";
	
				//String strLength; strLength.formatUnit(sh.dL(), nLunit, nPrec);
				String strLength; strLength.formatUnit(sh.dL(), sDimStyle);
				String strWidth; strWidth.formatUnit(sh.dW(),sDimStyle);
				String strThick; strThick.formatUnit(sh.dH(),sDimStyle);
				if ( (strThick==arT[l]) && (strPos==arPos[l]) && (strWidth==arW[l]) && (strLength==arL[l]))
				{
					bNew = FALSE;
					arCount[l]++;
					break; // out of inner for loop, we have found the equal one
				}
			}
			if (bNew)
			{ // a new item for the list is found
				String strPos = String(sh.posnum());
				if (strPos=="-1") strPos = "";
				
				//String strLength; strLength.formatUnit(sh.dL(), nLunit, nPrec);
				String strLength; strLength.formatUnit(sh.dL(), sDimStyle);
				String strWidth; strWidth.formatUnit(sh.dW(), sDimStyle);
				String strThick; strThick.formatUnit(sh.dH(), sDimStyle);
				arCount.append(1);
				arW.append(strWidth);
				arL.append(strLength);
				arPos.append(strPos);
				arT.append(strThick);
	
				//Check the space needed for the table
				double dAux=dp.textLengthForStyle("Amount", sDimStyle);
				if (dTxtLCount < dAux)
					dTxtLCount = dAux;
				dAux=dp.textLengthForStyle(strPos, sDimStyle);
				if (dTxtLPos < dAux)
					dTxtLPos= dAux;
				dAux=dp.textLengthForStyle(strWidth+ " x " +strLength, sDimStyle);
				if (dTxtLW < dAux)
					dTxtLW= dAux;
	
				dAux=dp.textLengthForStyle(strThick, sDimStyle);
				if (dTxtLT< dAux)
					dTxtLT= dAux;
	
				nNum++;
			}
		}	
		
		if (arSheet.length()>0)
		{
			//The information of that Group is ready to display
			//Display the Title of the Group
			dp.draw(sGroupName,ptDraw,_XW,_YW,1,-1);
			ptDraw=ptDraw-_YW*(dTxtH*1.5);
			Point3d ptBaseLine=ptDraw;
			//Check if the title is not bigger than the text on the columns
			
			double dAux=dp.textLengthForStyle("PosNum", sDimStyle);
			if (dTxtLPos < dAux)
				dTxtLPos= dAux;
			
			dAux=dp.textLengthForStyle("Dimension", sDimStyle);
			if ( (dTxtLW) < dAux)
				dTxtLW= dAux;
	
			dAux=dp.textLengthForStyle("Thickness", sDimStyle);
			if (dTxtLT< dAux)
				dTxtLT= dAux;
			
	
			//Display the Title of each column
			dp.draw("Posnum",ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLPos+dOffset);
	
			dp.draw("Dimension",ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLW+dOffset);
	
			dp.draw("Thickness",ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLT+dOffset);
			
	
			dp.draw("Amount",ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLCount+dOffset);
	
			ptDraw=ptDraw-_YW*(dTxtH*1.5);
					
			for (int d=0; d<arPos.length(); d++)
			{
				ptBaseLine=ptDraw;
	
				//Display the Values of each row
				dp.draw(arPos[d],ptBaseLine+_XW*(dTxtLPos*.3),_XW,_YW,1,-1);
				ptBaseLine=ptBaseLine+_XW*(dTxtLPos+dOffset);
		
				dp.draw(arW[d]+" x "+arL[d],ptBaseLine,_XW,_YW,1,-1);
				ptBaseLine=ptBaseLine+_XW*(dTxtLW+dOffset);
		
				dp.draw(arT[d],ptBaseLine+_XW*(dTxtLT*.45),_XW,_YW,1,-1);
				ptBaseLine=ptBaseLine+_XW*(dTxtLT+dOffset);
				
		
				dp.draw(arCount[d],ptBaseLine+_XW*(dTxtLCount*.45),_XW,_YW,1,-1);
				ptBaseLine=ptBaseLine+_XW*(dTxtLCount+dOffset);
		
				ptDraw=ptDraw-_YW*(dTxtH*1.5);
	
			}
			ptDraw=ptDraw-_YW*(dTxtH*0.5);
			
		}
	}//End loop throw all levels
}

//Display the Posnum
//ptLocation
//sPosNumToShow

CoordSys csEl = el.coordSys();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();
Point3d ptEl = csEl.ptOrg();

Vector3d vXTxt = vx; vXTxt.transformBy(ms2ps);
Vector3d vYTxt = vy; vYTxt.transformBy(ms2ps);


Display dpPos(nColorPosnum);
dpPos.dimStyle(sDimStylePosnum);

//Display dpBox(nColor2);
Vector3d vOffset=vz;
if (nZone<0)
	vOffset=-vOffset;

PlaneProfile ppAllPosNum;
Vector3d vMove=_XW;
vMove.transformBy(ps2ms);
vMove.normalize();

//double dTxtLengthStyle =  dpPos.textLengthForStyle(sDpTxt ,sDimStylePosNum);
//double dTxtHeightStyle =  dpPos.textHeightForStyle(sDpTxt ,sDimStylePosNum);	

for (int i=0; i<ptLocation.length(); i++)
{
	String sPos=sPosNumToShow[i];
	Point3d ptPosNum=ptLocation[i];
	//ptPosNum=ptPosNum+vOffset*(dTextHeight);
	ptPosNum.transformBy(ms2ps);
	double dTxtLengthStyle = dp.textLengthForStyle(sPos, sDimStyle);
	double dTxtHeightStyle =  dp.textHeightForStyle(sPos, sDimStyle);

	dp.textHeight(0.9 * dTxtHeightStyle);

	// createposnum mask
	PLine plPosNum(_ZW);
	plPosNum.addVertex(ptPosNum- 0.6 *(_XW * dTxtLengthStyle +  _YW * dTxtHeightStyle)); 	
	plPosNum.addVertex(ptPosNum- 0.6 *(_XW * dTxtLengthStyle -  _YW * dTxtHeightStyle));
	plPosNum.addVertex(ptPosNum+ 0.6 *(_XW * dTxtLengthStyle +  _YW * dTxtHeightStyle));
	plPosNum.addVertex(ptPosNum+ 0.6 *(_XW * dTxtLengthStyle -  _YW * dTxtHeightStyle));	
	plPosNum.close();	
	PlaneProfile ppPosNum(plPosNum);
	ppPosNum.shrink(-.1 * dTxtHeightStyle);
	ppPosNum.vis(3);
	
	// ensure posnums do not intersect
	int m,d;
	d = 1;
	PlaneProfile pp0 = PlaneProfile(plPosNum);
	
	pp0.intersectWith(ppAllPosNum);

	while (m < 20 && pp0.area() > 0){	
		ptPosNum.transformBy(vMove * d * dTxtHeightStyle * 1);
		plPosNum.transformBy(vMove * d * dTxtHeightStyle * 1);
		m++;
		if (d<0)
			d = m+1;
		else
			d = -m-1;
		
		pp0 = PlaneProfile(plPosNum);
		pp0.shrink(-.01 * dTxtHeightStyle);	
		pp0.intersectWith(ppAllPosNum);
	}
	ppAllPosNum.joinRing(plPosNum,_kAdd);
	ppPosNum.shrink(-.1 * dTxtHeightStyle);

	dpPos.draw(sPos, ptPosNum - vMove * 0.05 * dTxtHeightStyle, _XW, _YW, 0,0);
	//dp.draw (sPos, , _XW, _YW, 0, 0);
	//dpBox.draw(plPosNum);//, nDrawFilled
}










































#End
#BeginThumbnail























#End
