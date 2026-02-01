#Version 8
#BeginDescription
#Versions:
1.12 05.09.2022 HSB-16425: Add filter for wall comments Author: Marsel Nakuci
Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 17.07.2020  -  version 1.11


Shows various information from an element for the layout

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
* --------------------------------
*
* #Versions:
// 1.12 05.09.2022 HSB-16425: Add filter for wall comments Author: Marsel Nakuci
* Modified by: Alberto Jena (aj@hsb-cad.com)
* date: 14.03.2012
* version 1.0: Release version
*
* date: 21.05.2012
* version 1.1: Add floorplan numbers for viewport
*
* date: 01.05.2013
* version 1.2: Add wall height base on timbers
*
* ........
*
* date: 17.04.2020
* version 1.10: Add support for new comment format
*/


//Units
U(1,"mm");


String sPaperSpace = T("|Paper space|");
String sModelSpace = T("|Model space|");
String sArSpace[] = { sPaperSpace, sModelSpace };

PropString sSpace(2,sArSpace,T("|Drawing space|"));

PropString sDimLayout(0,_DimStyles,T("Dim Style"));
sDimLayout.setDescription("Select dimstyle with proper viewport scaling and dimension format.");

PropDouble pdTextHeight (0, 0, T("Text Height"));

String strWallDesc= T("Wall Description");
String strInformation = T("Information");
String strSubType = T("Subtype");
String strSpacing = T("Wall Stud Spacing");
String strBaseHeight = T("Wall Base Height");
String strFrameThickness= T("Wall Frame Thickness");
String strStudLength= T("Wall Stud Length");
String strWallCode= T("Wall Code");
String strWallNumber= T("Wall Number");
String strCrippleHeight= T("Length of supporting beam in Walls");
String strMultiwallNumber=T("Multiwall Number");
String strFloorPlanNumber=T("Floorplan Element Numbers");
String strWallHeight=T("Wall Height");
String strWallExtraInfo=T("Wall Extra Info by TSL");
String strComments=T("Wall Comments");
String strWallAreaGross=T("Wall Area Gross");
String strWallGroupLevel1=T("Group Level 1");
String strWallGroupLevel2=T("Group Level 2");

String strTypes[] = {strWallDesc,strInformation,strSubType,strSpacing,strBaseHeight,strFrameThickness,strStudLength,strWallCode, strCrippleHeight,strMultiwallNumber, strFloorPlanNumber, strWallHeight, strWallNumber, strWallExtraInfo, strComments, strWallAreaGross, strWallGroupLevel1, strWallGroupLevel2};

PropString pType(1,strTypes,"Type of data");
String category=T("|Display filters for wall comments|");
// HSB-16425: filter display
String sDisplayFilterName=T("|Show|");
String sDisplayFilters[]={T("|All|"), T("|No location|")};
PropString sDisplayFilter(3,sDisplayFilters, sDisplayFilterName);	
sDisplayFilter.setDescription(T("|Defines the Display Filter|"));
sDisplayFilter.setCategory(category);

if (_bOnInsert)
{
	if (insertCycleCount() > 1)	{		eraseInstance(); return; 	}
	
	// show the dialog if no catalog in use
	if (_kExecuteKey == "")
		showDialog();
		// set properties from catalog		
	else
		setPropValuesFromCatalog(_kExecuteKey);
	
	int nSpace = sArSpace.find(sSpace);
	
	
	
	if (sSpace == sModelSpace)
	{
		PrEntity sset(T("Select Elements"), Element());
		if (sset.go()) {
			Entity ents[0];
			ents = sset.set();
			for (int i = 0; i < ents.length(); i++)
			{
				//Clonning TSL
				TslInst tsl;
				String sScriptName = scriptName(); //name of the script
				Vector3d vecUcsX = _XW;
				Vector3d vecUcsY = _YW;
				Entity lstEnts[0];
				Beam lstBeams[0];
				Point3d lstPoints[0];
				int lstPropInt[0];
				double lstPropDouble[0];
				String lstPropString[0];
				
				lstPropString.append(sDimLayout);
				lstPropString.append(pType);
				lstPropString.append(sSpace);
				
				for (int i = 0; i < ents.length(); i++)
				{
					Element el = (Element) ents[i];
					if ( ! el.bIsValid() ) continue;
					lstEnts.setLength(0);
					lstPoints.setLength(0);
					lstEnts.append(el);
					lstPoints.append(el.ptOrg() + el.vecZ() * U(100));
					tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString);
				}
				eraseInstance();
				return;
			}
		}
	}//end space 0
	else if (sSpace == sPaperSpace)
	{
		_Pt0 = getPoint(T("Pick a point where the the information is going to be shown"));
		Viewport vp = getViewport(T("Select the viewport from which the element is taken")); //select viewport
		_Viewport.append(vp);
	}
	
	return;
	
}//end bOnInsert

setMarbleDiameter(U(0.1));

int nSpace = sArSpace.find(sSpace);
int nDisplayFilter=sDisplayFilters.find(sDisplayFilter);
if(pType!=strComments)
{ 
	sDisplayFilter.setReadOnly(_kHidden);
}
else
{ 
	sDisplayFilter.setReadOnly(false);
}

Element el;
CoordSys ms2ps;
if (nSpace == 0) //paper
{
	if ( _Viewport.length() == 0 ) {
		eraseInstance();
		return;
	}

	Viewport vp = _Viewport[0];
	ms2ps = vp.coordSys();
	
	CoordSys ps2ms = ms2ps; ps2ms.invert();
	
	 el = vp.element();
	if ( ! el.bIsValid() )return;
}
else if (nSpace == 1) //model
{ 
	 el = (Element) _Entity[0];
	 if ( ! el.bIsValid() )
	{
		eraseInstance();
		return;
	}
}

//Element vectors
CoordSys csEl=el.coordSys();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();

Point3d ptOrgEl=csEl.ptOrg();

//CoordSys coordvp = vp.coordSys();
//Vector3d VecX = coordvp.vecX();
//Vector3d VecY = coordvp.vecY();
//Vector3d VecZ = coordvp.vecZ();


Display dp(-1); // use color of entity
dp.dimStyle(sDimLayout); 
if (pdTextHeight>0)
{
	dp.textHeight(pdTextHeight);
}

// text to be displayed
String strText;

String sLines[0];

int nDisplay=true;

if (pType==strInformation) {
  strText = el.information();
}
else if (pType==strSubType) {
  strText = el.subType();
}
else if (pType==strWallDesc) {
  strText = el.definition();
}
else if (pType==strSpacing) {
  ElementWallSF elWSF = (ElementWallSF) el;
  if (elWSF.bIsValid()) strText.formatUnit(elWSF.spacingBeam(),sDimLayout);
}
else if (pType==strBaseHeight) {
  Wall wll = (Wall) el;
  if (wll.bIsValid()) strText.formatUnit(wll.baseHeight(),sDimLayout);
}
else if (pType==strFrameThickness) {
  strText.formatUnit(el.dBeamWidth(),sDimLayout);
}
else if (pType==strStudLength) {
  Beam bms[0]; // declare new array of beams with arraylength 0
  bms = el.beam(); // get all beams of element
  double dLen = 0; // declare variable dLen
  for (int b=0; b<bms.length(); b++) { // loop over all beams
    //if (bms[b].name("hsbId")=="99") { // take only hsbid 99
    if (bms[b].type()==_kStud) { // take only stud
      dLen = bms[b].dL(); // this length is without the end tools, eg tenon
      break; // stop for loop, we have found one
    }
  }
  strText.formatUnit(dLen,sDimLayout);
}
else if (pType==strWallCode) {
  strText=el.code();
}
else if (pType==strWallNumber) {
  strText=el.number();
}
else if (pType==strCrippleHeight)
{
	Beam bms[0]; // declare new array of beams with arraylength 0
	bms = el.beam(); // get all beams of element
	double dLen[0]; // declare variable dLen
	for (int b=0; b<bms.length(); b++)
	{
		Beam bm=bms[b];
		if (bm.type()==_kSFSupportingBeam)
		{
			double dBmLength=bm.dL();
			int nNew=true;
			for (int i=0; i<dLen.length(); i++)
			{
				if (abs(dLen[i]-dBmLength)<U(1))
					nNew=false;
			}
			if (nNew==true)
			{
				dLen.append(dBmLength);
			}
		}
	}
	
	for (int i=0; i<dLen.length(); i++)
	{
		String sText;
		sText.formatUnit(dLen[i], sDimLayout);
		if (strText!="")
			strText+=", ";
		strText=strText+sText;
	}
}
else if(pType==strMultiwallNumber)
{
	Map mp=el.subMapX("hsb_Multiwall");
	
	if ( mp.hasString("Number"))
	{
		strText=mp.getString("Number");
	}

	//TslInst tsls[]=el.tslInstAttached();

	//for(int t=0;t<tsls.length();t++)
	//{
		//TslInst tslCurr=tsls[t];
		//String sSubMapXKeys[]=tslCurr.subMapXKeys();
		//if(sSubMapXKeys.find("hsb_Multiwall")!=-1)
		//{
			////Multiwall found
			//Map mpMultiwall=tslCurr.subMapX("hsb_Multiwall");
			//strText=mpMultiwall.getString("Number")+" - "+mpMultiwall.getInt("Sequence");
		//}
	//}
}
else if(pType==strWallExtraInfo)
{
	
	TslInst allTSL[]=el.tslInst();
	for (int i=0; i<allTSL.length(); i++)
	{
		TslInst tsl=allTSL[i];
		if (tsl.scriptName()=="Input Text onto a Wall")
		{
			String sLine1=tsl.propString(1);
			String sLine2=tsl.propString(2);
			String sLine3=tsl.propString(3);
			String sLine4=tsl.propString(4);
			String sLine5=tsl.propString(5);
			sLine1.trimLeft(); sLine1.trimRight();
			sLine2.trimLeft(); sLine2.trimRight();
			sLine3.trimLeft(); sLine3.trimRight();
			sLine4.trimLeft(); sLine4.trimRight();
			sLine5.trimLeft(); sLine5.trimRight();
			
			if (sLine1.length()>0) sLines.append(sLine1);
			if (sLine2.length()>0) sLines.append(sLine2);
			if (sLine3.length()>0) sLines.append(sLine3);
			if (sLine4.length()>0) sLines.append(sLine4);
			if (sLine5.length()>0) sLines.append(sLine5);
		}
	}
	
	//TslInst tsls[]=el.tslInstAttached();

	//for(int t=0;t<tsls.length();t++)
	//{
		//TslInst tslCurr=tsls[t];
		//String sSubMapXKeys[]=tslCurr.subMapXKeys();
		//if(sSubMapXKeys.find("hsb_Multiwall")!=-1)
		//{
			////Multiwall found
			//Map mpMultiwall=tslCurr.subMapX("hsb_Multiwall");
			//strText=mpMultiwall.getString("Number")+" - "+mpMultiwall.getInt("Sequence");
		//}
	//}
}
else if(pType==strFloorPlanNumber)
{
	Group gp=el.elementGroup();
	Group gr(gp.namePart(0)+"\\"+gp.namePart(1));

	Entity ent[]=gr.collectEntities(true, Element(), _kModelSpace);
	
	nDisplay=false;
	
	for (int i=0; i<ent.length(); i++)
	{
		Element el=(Element) ent[i];
		
		PLine plEnv=el.plEnvelope();
		Point3d ptVertex[]=plEnv.vertexPoints(true);
		Point3d ptCenEl;
		ptCenEl.setToAverage(ptVertex);
		
		String sNumber=el.number();
		
		Point3d ptDisplay=ptCenEl;
		ptDisplay.transformBy(ms2ps);
		
		Vector3d vxDir=el.vecY();
		Vector3d vyDir=-el.vecX();
		vxDir.transformBy(ms2ps);
		vyDir.transformBy(ms2ps);
		
		dp.draw(sNumber, ptDisplay,  vxDir, vyDir, 0, 0);
	}
}
else if(pType==strWallHeight)
{
	// use the beams for this job  
	Beam arBeams[] = el.beam(); // collect all beams
	Point3d ptMinD, ptMaxD;
	Point3d ptMinO, ptMaxO;
	double dMinD, dMaxD;
	double dMinO, dMaxO;
	int bSetD = FALSE;
	int bSetO = FALSE;

	for (int b=0; b<arBeams.length(); b++)
	{
		Body bd = arBeams[b].realBody();
		Point3d ptsD[] = bd.extremeVertices(vy);
		for (int p=0; p<ptsD.length(); p++)
		{
			double dDD = ptsD[p].dotProduct(vy);
			if (!bSetD)
			{
				bSetD = TRUE;
				dMinD = dDD; dMaxD = dDD;
				ptMinD = ptsD[p]; ptMaxD = ptsD[p];
			}
			else
			{
				if (dDD<dMinD) { dMinD=dDD; ptMinD = ptsD[p]; }
				if (dDD>dMaxD) { dMaxD=dDD; ptMaxD = ptsD[p]; }
			}
		}
		
		Point3d ptsO[] = bd.extremeVertices(-vy);
		
		for (int p=0; p<ptsO.length(); p++)
		{
			double dDD = ptsO[p].dotProduct(-vy);
			if (!bSetO)
			{
				bSetO = TRUE;
				dMinO = dDD; dMaxO = dDD;
				ptMinO = ptsO[p]; ptMaxO = ptsO[p];
			}
			else
			{
				if (dDD<dMinO) { dMinO=dDD; ptMinO = ptsO[p]; }
				if (dDD>dMaxO) { dMaxO=dDD; ptMaxO = ptsO[p]; }
			}
		}
	}
	double dHeight=abs(vy.dotProduct(ptMinD-ptMaxD));
	
	String sText;
	sText.formatUnit(dHeight, sDimLayout);
	strText=sText;
}
else if (pType==strComments)
{
	Map mp = el.subMapX("Hsb_Comment");
	for (int i=0; i<mp.length(); i++)
	{
		Map mpAllComments = mp.getMap(i);
		for (int j = 0; j < mpAllComments.length(); j++)
		{
			Map comment = mpAllComments.getMap(j);
		// HSB-16425: check the display filter
			if (nDisplayFilter == 1)
			{
				if (comment.hasMap("LOCATION"))
				{
					continue;
				}
			}
			if (comment.hasString("COMMENTTEXT"))
			{
				sLines.append(comment.getString("COMMENTTEXT"));
			}
			
			Map commentLines = comment.getMap("Comment[]");
			String linesToDisplay[0];
			for (int l = 0; l < commentLines.length(); l++)
			{
				String s = commentLines.keyAt(l).makeLower();
				if ( commentLines.keyAt(l).makeLower() != "Comment".makeLower()) continue;
				sLines.append(commentLines.getString(l));
			}
		}
	}
}
else if (pType==strWallAreaGross)
{
	//double dArea=el.profBrutto(0).area()/(U(1000)*U(1000));
	double dArea = el.plEnvelope().area()/(U(1000)*U(1000));; //AJ Added because a customer was having an issue with the TSL not calculation the right area.
	
	String sText;
	sText.formatUnit(dArea, 2, 2);
	strText=sText;
}
else if(pType==strWallGroupLevel1)
{
	Group gp = el.elementGroup();
	strText = gp.namePart(0);
}
else if (pType==strWallGroupLevel2)
{
	Group gp = el.elementGroup();
	strText = gp.namePart(1);
}
// when debug is on, and the string is empty, replace it with ...
if ( (_bOnDebug) && (strText=="") ) {
    strText = "...";
}

if (nDisplay)
{
	Vector3d vxDisp = _XW;
	Vector3d vyDisp = _YW;
	if (sSpace == sModelSpace)
	{ 
		vxDisp = el.vecX();
		vyDisp = -el.vecZ();
		
	}
	
	//ptDefi.transformBy(ms2ps);
	dp.draw(strText, _Pt0,  vxDisp, vyDisp, 1,1);
	double textSize = dp.textHeightForStyle("hsb", sDimLayout);
	for (int i=0; i<sLines.length(); i++)
	{
		dp.draw(sLines[i], _Pt0-vyDisp*(1.2 * textSize*i),  vxDisp, vyDisp, 1,1);
	}
}

if (sSpace == sModelSpace)
{ 
	assignToElementGroup(el, true, 0, 'I');
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
  <lst nm="TslInfo">
    <lst nm="TSLINFO" />
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-16425: Add filter for wall comments" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="12" />
      <str nm="DATE" vl="9/5/2022 2:03:33 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End