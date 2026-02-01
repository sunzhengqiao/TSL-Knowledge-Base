#Version 8
#BeginDescription
Show element data in PS (one per instance)
- Wall Description
- Information
- Subtype
- Stud Spacing
- Wall Base Height
- Frame Thickness
- Stud Length
- Wall Code
- Wall Code and number
- Length of supporting beam
v1.7: 17.may.2013: David Rueda (dr@hsb-cad.com)
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 7
#KeyWords 
#BeginContents
/*
  COPYRIGHT
  ---------------
  Copyright (C) 2011 by
  hsbSOFT 

  The program may be used and/or copied only with the written
  permission from hsbSOFT, or in accordance with
  the terms and conditions stipulated in the agreement/contract
  under which the program has been supplied.

  All rights reserved.

 REVISION HISTORY
 -------------------------

 v1.0: 19.mar.2013: David Rueda (dr@hsb-cad.com)
	- Copied from Layout_ShowElemData, to keep US content folder naming standards
	- Thumbnail added
 v1.4: 19.mar.2013: David Rueda (dr@hsb-cad.com)
	- Version control from 1.0 to 1.4, to keep updated with Layout_ShowElemData
 v1.5 21.mar.2013: David Rueda (dr@hsb-cad.com)
	- "Show data name" (No/Yes) prop added
	- "Wall code and number" option added
	- TSL will stop inserting after first attempt (if( insertCycleCount()>1 )
 v1.6 07.apr.2013: David Rueda (dr@hsb-cad.com)
	- "Length" and "Width" options added
 v1.7 17.may.2013: David Rueda (dr@hsb-cad.com)
	- Translators added to strings
*/

//Unit(1,"mm"); // script uses mm

PropString pDimStyle(0,_DimStyles,"hsb-Bom");
pDimStyle.setDescription("|Select dimstyle with proper viewport scaling and dimension format|");

String strWallDesc= T("|Description|");
String strInformation = T("|Information|");
String strSubType = T("|Subtype|");
String strSpacing = T("|Stud Spacing|");
String strWallLength = T("|Length|");
String strWallWidth = T("|Width|");
String strWallHeight = T("|Height|");
String strFrameThickness= T("|Frame Thickness|");
String strStudLength= T("|Stud Length|");
String strWallCode= T("|Wall Code|");
String strWallCodeAndNumber= T("|Wall Code and number|");
String strCrippleHeight= T("|Length of supporting beam|");

String strTypes[] = {strWallDesc,strInformation,strSubType,strSpacing,strWallLength,strWallWidth,strWallHeight,strFrameThickness,strStudLength,strWallCode, strWallCodeAndNumber, strCrippleHeight};
PropString pType(1,strTypes,"|Type of data|");
String arNoYes[]={T("|No|"), T("|Yes|")};
PropString pShowDataName(2,arNoYes,T("|Show data name|"));
int nShowDataName=arNoYes.find(pShowDataName,0);

if (_bOnInsert) {

	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	} 
	 
  showDialog();
   _Pt0 = getPoint("|Select location|"); // select point
  Viewport vp = getViewport("|Select the viewport from which the element is taken|"); // select viewport
  _Viewport.append(vp);

  return;
}

// set the diameter of the 3 circles, shown during dragging
setMarbleDiameter(U(4));

// do something for the last appended viewport only
if (_Viewport.length()==0) return; // _Viewport array has some elements
Viewport vp = _Viewport[_Viewport.length()-1]; // take last element of array
_Viewport[0] = vp; // make sure the connection to the first one is lost

// check if the viewport has hsb data
if (!vp.element().bIsValid()) return;
Element el = vp.element();

// text to be displayed
String strText;

if (pType==strInformation) {
	strText = el.information();
	if(nShowDataName)
		strText = strInformation+": "+ strText;		
}
else if (pType==strSubType) {
  strText = el.subType();
	if(nShowDataName)
		strText = strSubType+": "+ strText;		
}
else if (pType==strWallDesc) {
  strText = el.definition();
	if(nShowDataName)
		strText = strWallDesc+": "+ strText;		
}
else if (pType==strSpacing) {
  ElementWallSF elWSF = (ElementWallSF) el;
  	if (elWSF.bIsValid()) 
	{
		strText.formatUnit(elWSF.spacingBeam(),pDimStyle);
		if(nShowDataName)
			strText = strSpacing+": "+ strText;		
	}
}

else if (pType==strWallLength)
{
	if(el.bIsValid())
	{
		Vector3d vx=el.coordSys().vecX();
		PlaneProfile ppEl(el.plOutlineWall());
		LineSeg ls=ppEl.extentInDir(vx);
		double dElLength=abs(vx.dotProduct(ls.ptStart()-ls.ptEnd()));
		strText.formatUnit(dElLength,pDimStyle);
		if(nShowDataName)
			strText = strWallLength+": "+ strText;	
	}
}

else if (pType==strWallWidth)
{
	if(el.bIsValid())
	{
		Vector3d vx=el.coordSys().vecX();
		Vector3d vz=el.coordSys().vecZ();
		PlaneProfile ppEl(el.plOutlineWall());
		LineSeg ls=ppEl.extentInDir(vx);
		double dElLength=abs(vx.dotProduct(ls.ptStart()-ls.ptEnd()));
		ls=ppEl.extentInDir(vz);
		ElemZone elzStart= el.zone(-10);
		ElemZone elzEnd= el.zone(10);
		double dElWidth=abs(vz.dotProduct(elzStart.coordSys().ptOrg()-elzEnd.coordSys().ptOrg()));
		strText.formatUnit(dElWidth,pDimStyle);
		if(nShowDataName)
			strText = strWallWidth+": "+ strText;	
	}
}

else if (pType==strWallHeight) {
  Wall wll = (Wall) el;
  	if (wll.bIsValid()) 
	{
		strText.formatUnit(wll.baseHeight(),pDimStyle);
		if(nShowDataName)
			strText = strWallHeight+": "+ strText;		
	}
}
else if (pType==strFrameThickness) {
  strText.formatUnit(el.dBeamWidth(),pDimStyle);
	if(nShowDataName)
		strText = strFrameThickness+": "+ strText;		
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
  strText.formatUnit(dLen,pDimStyle);
	if(nShowDataName)
		strText = strStudLength+": "+ strText;		
}
else if (pType==strWallCode) {
  if(el.bIsValid())
	{
		strText=el.code();
		if(nShowDataName)
			strText = strWallCode+": "+ strText;
	}
}
else if (pType==strWallCodeAndNumber) {
  if(el.bIsValid())
	{
	  strText=el.code()+"-"+el.number();
		if(nShowDataName)
			strText = strWallCode+": "+ strText;		
	}
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
		sText.formatUnit(dLen[i], pDimStyle);
		if (strText!="")
			strText+=", ";
		strText=strText+sText;
	}
	
	if(nShowDataName)
		strText = strCrippleHeight+": "+ strText;		

}

// when debug is on, and the string is empty, replace it with ...
if ( (_bOnDebug) && (strText=="") ) {
    strText = "...";
}

Display dp(-1); // use color of entity
dp.dimStyle(pDimStyle); 

// draw the text at insert point
dp.draw(strText ,_Pt0,_XW,_YW,1,1);




#End
#BeginThumbnail
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
BHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`/_V8HH
`



#End
