#Version 8
#BeginDescription
V1.0 09/10/2021 TSL to display wall info, Zone 1 location and element vector X direction
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
//__Script uses inchs
	Unit (1,"inch");
	
//__Variables
	int dSwitchAngle = 58;
	double dMinOffsetFromWall = U(6);
	
//__Properties
	int sProp=0,nProp=0,dProp=0;
	String arYN[]={T("Yes"),T("No")};
	String sDisplay = T("Display");
	int iDisplay = _DimStyles.find("ARIAL");
	if (iDisplay < 0) {
		iDisplay = 0;
		reportMessage("\n " + scriptName() + " " + T("ARIAL dimstyle not found"));
	}
	PropString stDimStyle(sProp++,_DimStyles,T("DimStyle"), iDisplay);
	stDimStyle.setCategory(sDisplay);	
	PropDouble dTH(dProp++,U(3.75),T("Text Height. If 0 uses DimStyle"));
	dTH.setCategory(sDisplay);
	int iStyles[] = { 1, 2};
	PropInt iStyleToUse(nProp++, iStyles, T("Style"), 0);
	iStyleToUse.setCategory(sDisplay);
	
	String arTextOptions[]={T("Nothing"), T("Code"),T("Number"),T("Description"),T("SubType"),T("Information")};
	String arStTextTake[arTextOptions.length()];	
	String sInfo = T("Info");	
	PropString strDispCod(sProp++,arTextOptions,T("Info Left"),1);
	strDispCod.setCategory(sInfo);
	PropString strDispNumber(sProp++,arTextOptions,T("Info Right"),2);
	strDispNumber.setCategory(sInfo);
	PropString stSeperator(sProp++,"",T("Seperator"));
	stSeperator.setCategory(sInfo);
	
	
	

//__bOnInsert OR Element split
	if (_bOnInsert || _bOnElementListModified){
	
		ElementWall arEl[0];
		if(_bOnInsert)
		{
			showDialogOnce("");
			
			_Map.setMap("mpProps", mapWithPropValues());
			
			
			PrEntity ssE("\nSelect a set of elements",ElementWall());
			if (ssE.go())
			{
				Entity ents[0]; 
				ents = ssE.set(); 
				// turn the selected set into an array of elements
				for (int i=0; i<ents.length(); i++)
				{
					if (ents[i].bIsKindOf(ElementWall()))
					{
						arEl.append((ElementWall) ents[i]);
					}
				}
			}
		}
		else
		{
			for (int i=0; i<_Element.length(); i++)
			{
				ElementWall el = (ElementWall)_Element[i];
				
				if(el.bIsValid())arEl.append(el);
			}
		}
		
		//PREPARE TO CLONE
		TslInst tsl;
		String sScriptName = scriptName();
	
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		Beam lstBeams[0];
		Entity lstEnts[1];
		Point3d lstPoints[2];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
			
		for(int i=0; i<arEl.length();i++){
			lstEnts[0] = arEl[i];
			Point3d ptTag = arEl[i].ptArrow();
			ptTag.transformBy(2*dTH*arEl[i].vecZ());
			lstPoints[0] = ptTag;
			lstPoints[1] = ptTag;
			
			tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString,1,_Map );
		}
		eraseInstance();
		return;	
		
	}//END if (_bOnInsert)
	
//__set properties from map
	if(_Map.hasMap("mpProps")){
		setPropValuesFromMap(_Map.getMap("mpProps"));
		_Map.removeAt("mpProps",0);
	}

//__Element Safety
	if(_Element.length()==0){
		eraseInstance();
		return;
	}

	ElementWall el = (ElementWall) _Element[0];
	if(!el.bIsValid()){
		eraseInstance();
		return;
	}

Entity entXref = el.blockRef();
BlockRef bkXref = (BlockRef) entXref;
String stXrefDefinition = bkXref.definition();
int bInXref = FALSE;
if (stXrefDefinition != "" && bkXref.bIsValid()) {
	Group gpEl("Wall_labels\\"+stXrefDefinition);
	gpEl.addEntity(_ThisInst, TRUE, 0, 'E');
	bInXref = TRUE;
}
else {
	setDependencyOnEntity(el);
	assignToElementGroup(el, TRUE, 0, 'E');
}
_ThisInst.setAllowGripAtPt0(false);

//__Populate information
	//String arTextOptions[]={T("Nothing"), T("Code"),T("Number"),T("Description"),T("SubType")};
	arStTextTake[0] = "";
	arStTextTake[1] = el.code();
	arStTextTake[2] = el.number();
	arStTextTake[3] = el.definition();
	arStTextTake[4] = el.subType();
	arStTextTake[5] = el.information();
	
	String st1 = arStTextTake[arTextOptions.find(strDispCod)];
	String st2 = arStTextTake[arTextOptions.find(strDispNumber)];
	
	String stToDisplay = st1;
	if(st1.length() > 0 && st2.length() >0)
	{
		if(stSeperator.length() > 0)stToDisplay += stSeperator;
		else stToDisplay += " ";
	}
	stToDisplay += st2;
	//__Default to number
	if(stToDisplay.length() == 0)stToDisplay = arStTextTake[2];

Vector3d elX=el.vecX();
Vector3d elZ=el.vecZ();
ElemZone elZoneOne = el.zone(1);
ElementWallSF wSF=(ElementWallSF)el;
Point3d ptElCen = (wSF.ptStartOutline() + wSF.ptEndOutline()) * 0.5;
Vector3d vcZone1 = elZoneOne.ptOrg() - ptElCen;
if (elZ.dotProduct(vcZone1) > 0) elZ = -elZ;
double dElzH = elZoneOne.dH();
double dWallThickness = 2 * abs(vcZone1.dotProduct(elZ));
Display dp(1);
dp.showInDispRep("Model");
dp.layer("Wall_labels");
dp.dimStyle(stDimStyle);
double dLabelHeight = U(3.75);
if (dTH == 0) dp.textHeight(dLabelHeight);
else dp.textHeight(dTH);

Vector3d vcTextX = elX;
Vector3d vcTextY = -el.vecZ();
int iText = 1;
{
	Vector3d vTest(_YW-(_XW*0.8));
	double dAngleTest = vcTextY.angleTo(vTest);
	if (dAngleTest>90)
	{
		vcTextX = -elX;
		vcTextY = el.vecZ();
	}
	vcTextX = vcTextY.crossProduct(_ZW);
	iText=-1;
}
double dCharL = 0.5 * dp.textLengthForStyle("OK", stDimStyle);
double dHeightScale = dLabelHeight / (dp.textHeightForStyle("OK", stDimStyle));

if (iStyleToUse == iStyles[1]) {	
	double dLabelLength=dp.textLengthForStyle(stToDisplay, stDimStyle)*dHeightScale;
	Vector3d vcX = elX;
	if ( (wSF.ptEndOutline() - wSF.ptStartOutline()).dotProduct(elX) < 0 ) vcX = - elX;
	Point3d ptZone1[] = { wSF.ptStartOutline() - (U(5.625) + 0.5 * dWallThickness) * elZ, wSF.ptEndOutline() - (U(5.625) + 0.5 * dWallThickness) * elZ};
	PLine plLimitsZone1(_ZW);
	plLimitsZone1.addVertex(ptZone1[0]);
	plLimitsZone1.addVertex(ptZone1[1]);
	Point3d ptZone6[] = { wSF.ptStartOutline() + (U(5.625) + 0.5 * dWallThickness) * elZ,wSF.ptEndOutline()+(U(5.625)+0.5*dWallThickness)*elZ};
	PLine plLimitsZone6(_ZW);
	plLimitsZone6.addVertex(ptZone6[0]);
	plLimitsZone6.addVertex(ptZone6[1]);
	double distToplZone1 = abs((_PtG[0] - plLimitsZone1.closestPointTo(_PtG[0])).length());
	double distToplZone6 = abs((_PtG[0] - plLimitsZone6.closestPointTo(_PtG[0])).length());
	if (distToplZone1 <= distToplZone6)
	{
		_PtG[0] = plLimitsZone1.closestPointTo(_PtG[0]);
		if (plLimitsZone1.isOn(_PtG[0])==FALSE && plLimitsZone6.isOn(_PtG[0])==FALSE)
		{
			double dist0 = abs((ptZone1[0] - _PtG[0]).length());
			double dist1 = abs((ptZone1[1] - _PtG[0]).length());
			if (dist0 < dist1) _PtG[0] = ptZone1[0];
			else _PtG[0] = ptZone1[1];
		}
	}
	else
	{
		_PtG[0] = plLimitsZone6.closestPointTo(_PtG[0]);
		if (plLimitsZone6.isOn(_PtG[0])==FALSE && plLimitsZone6.isOn(_PtG[0])==FALSE)
		{
			double dist0 = abs((ptZone6[0] - _PtG[0]).length());
			double dist1 = abs((ptZone6[1] - _PtG[0]).length());
			if (dist0 < dist1) _PtG[0] = ptZone6[0];
			else _PtG[0] = ptZone6[1];
		}
	}
	Point3d ptText=_PtG[0];
	if (bInXref == FALSE) dp.color(201);
	else dp.color(203);
	dp.draw(stToDisplay, ptText, vcTextX, vcTextY, 0, 0);
	PLine plOutline;
	plOutline.createRectangle(LineSeg(ptText + 0.75 * dLabelHeight * elZ + (0.5 * dLabelLength + 0.25 * dLabelHeight) * elX, ptText - 0.75 * dLabelHeight * elZ - (0.5 * dLabelLength + 0.25 * dLabelHeight) * elX), elX, elZ);
	dp.draw(plOutline);
	Point3d ptArow = ptText + (0.5 * dLabelLength + 1.5 * dLabelHeight) * elX;
	PLine plArrow;
	plArrow.addVertex(ptArow);
	ptArow += 0.5 * dLabelHeight * elZ - 0.75*dLabelHeight * elX;
	plArrow.addVertex(ptArow);
	ptArow += -0.5 * dLabelHeight * elZ + 0.5 * dLabelHeight * elX;
	plArrow.addVertex(ptArow);
	ptArow += -0.5*dLabelHeight * elZ - 0.5 * dLabelHeight * elX;
	plArrow.addVertex(ptArow);
	plArrow.close();
	dp.draw(plArrow);

}
else
{	
	double dLabelLength=dp.textLengthForStyle(stToDisplay, stDimStyle)*dHeightScale;
	Vector3d vcX = elX;
	if ( (wSF.ptEndOutline() - wSF.ptStartOutline()).dotProduct(elX) < 0 ) vcX = - elX;
	Point3d ptZone1[] = { wSF.ptStartOutline() - (U(5.625) + 0.5 * dWallThickness) * elZ, wSF.ptEndOutline() - (U(5.625) + 0.5 * dWallThickness) * elZ};
	PLine plLimitsZone1(_ZW);
	plLimitsZone1.addVertex(ptZone1[0]);
	plLimitsZone1.addVertex(ptZone1[1]);
	Point3d ptZone6[] = { wSF.ptStartOutline() + (U(5.625) + 0.5 * dWallThickness) * elZ,wSF.ptEndOutline()+(U(5.625)+0.5*dWallThickness)*elZ};
	PLine plLimitsZone6(_ZW);
	plLimitsZone6.addVertex(ptZone6[0]);
	plLimitsZone6.addVertex(ptZone6[1]);
	double distToplZone1 = abs((_PtG[0] - plLimitsZone1.closestPointTo(_PtG[0])).length());
	double distToplZone6 = abs((_PtG[0] - plLimitsZone6.closestPointTo(_PtG[0])).length());
	if (distToplZone1 <= distToplZone6)
	{
		_PtG[0] = plLimitsZone1.closestPointTo(_PtG[0]);
		if (plLimitsZone1.isOn(_PtG[0])==FALSE && plLimitsZone6.isOn(_PtG[0])==FALSE)
		{
			double dist0 = abs((ptZone1[0] - _PtG[0]).length());
			double dist1 = abs((ptZone1[1] - _PtG[0]).length());
			if (dist0 < dist1) _PtG[0] = ptZone1[0];
			else _PtG[0] = ptZone1[1];
		}
	}
	else
	{
		_PtG[0] = plLimitsZone6.closestPointTo(_PtG[0]);
		if (plLimitsZone6.isOn(_PtG[0])==FALSE && plLimitsZone6.isOn(_PtG[0])==FALSE)
		{
			double dist0 = abs((ptZone6[0] - _PtG[0]).length());
			double dist1 = abs((ptZone6[1] - _PtG[0]).length());
			if (dist0 < dist1) _PtG[0] = ptZone6[0];
			else _PtG[0] = ptZone6[1];
		}
	}
	Point3d ptText=_PtG[0];
	if (bInXref == FALSE) dp.color(100);
	else dp.color(101);
	dp.draw(stToDisplay, ptText, vcTextX, vcTextY, 0, 0);
	PLine plOutline;
	ptText+=-0.75*dLabelHeight*elZ-(0.5*dLabelLength+0.25*dLabelHeight)*elX;
	plOutline.addVertex(ptText);
	ptText+=(dLabelLength+0.275*dLabelHeight)*elX;
	plOutline.addVertex(ptText);
	ptText+=0.75*dLabelHeight*elZ+0.5*dLabelHeight*elX;
	plOutline.addVertex(ptText);
	ptText+=0.75*dLabelHeight*elZ-0.5*dLabelHeight*elX;
	plOutline.addVertex(ptText);
	ptText-=(dLabelLength+0.275*dLabelHeight)*elX;
	plOutline.addVertex(ptText);
	plOutline.close();
	dp.draw(plOutline);
}
Point3d ptZone = Line(ptElCen - (0.5*dWallThickness + U(1.15625)+dElzH) * elZ, elX).closestPointTo(_PtG[0]);
dp.textHeight(U(1));
dp.draw("Zone 1", ptZone, vcTextX, vcTextY, 0, 0);
dp.color(4);
PLine plWallOutline = el.plOutlineWall();
dp.draw(plWallOutline);
Point3d ptElStart = Line(ptElCen, elX).closestPointTo(el.ptOrg());
Point3d ptOutline[] = { ptElStart +0.5*dWallThickness*elZ, ptElStart  -0.5*dWallThickness*elZ};
Point3d ptArrowWallStart =  ptElStart+2*dWallThickness*elX;

PLine plWallStart(ptOutline[0], ptArrowWallStart, ptOutline[1]);
plWallStart.close();
dp.draw(plWallStart);
PLine plWallStart2(ptOutline[0], ptArrowWallStart-0.25*dWallThickness*elX, ptOutline[1]);
dp.draw(plWallStart2);





#End
#BeginThumbnail
begin 644 tag.jpg
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
)`!0`4`%`'__9
`
end
16839














#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="0.03937008" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End