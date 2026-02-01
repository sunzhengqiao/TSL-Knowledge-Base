#Version 8
#BeginDescription

























1.17 13/10/2021 Add DWeight to table Author: Robert Pol
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 17
#KeyWords BOM, labels in paperspace
#BeginContents
/*
*  COPYRIGHT
*  ---------
*  Copyright (C) 2005 by
*  hsbSOFT N.V.
*  THE NETHERLANDS
*
*  The program may be used and/or copied only with the written
*  permission from hsbSOFT N.V., or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
*
* REVISION HISTORY
* ----------------
*
* Revised: Anno Sportel 051209 (v1.01)
* Change: First revision
*
* Revised: Anno Sportel 051212 (v1.02)
* Change: Add read-write function of map file
*
* Revised: Anno Sportel 051214 (v1.03)
* Change: Allow multiple dxi's
*
* Revised: Anno Sportel 060116 (v1.04)
* Change: Add number of columns
*
* Revised: Anno Sportel 060126 (v1.05)
* Change: Correct database output
*
* Revised: Anno Sportel 060428 (v1.06)
* Change: Extend number of columns: label, function, units
*
* Revised: Anno Sportel 060522 (v1.07)
* Change: Increase quantity, add category to group, correct error while connecting 2 tables to same floorgroup
*
* Revised: Anno Sportel 060620 (v1.08)
* Change: Add housename to xml name.
*
* Revised: Anno Sportel 060620 (v1.09)
* Change: Correct error on grouping items.
*
* Revised: Anno Sportel 060710 (v1.10)
* Change: Only allow editing if floor group where the tsl belongs to is set current.
*
* Revised: Anno Sportel 061019 (v1.11)
* Change: Quantity as double.
*
* Revised: Anno Sportel 061101 (v1.12)
* Change: Assign to original group. _ not allowed in group names.
*
* Revised: Anno Sportel 070328 (v1.13)
* Change: Assign to original group exlusively.
*
* Revised: Anno Sportel 26.06.2009 (v1.14)
* Change: Current floorgroup not needed anymore on update.
*
* Revised: GJ Brandriet 05.02.2015 (v1.15)
* Change: Change or Update are now on rightmouseclick
*
* Revised: Anno Sportel 25.09.2017 (v1.16)
* Change : Fix translation issue with catalogs.

// #Versions
//1.17 13/10/2021 Add DWeight to table Author: Robert Pol
*/

Unit (1,"mm");//script uses mm

//Properties
//Select dimstyle
PropString sDimStyle(0,_DimStyles,"Dimension style");

//Select line color
PropInt nColorLine(0,7, "Line color");
PropInt nColorHeader(1,1, "Text color: Header"); 
PropInt nColorGroup(2,3, "Text color: Groups");
PropInt nColorContent(3,2, "Text color: Content");

int arBShowColumn[0];
int arBTrueFalse[] = {TRUE, FALSE};
String arSTrueFalse[] = {"Yes", "No"};
PropString sShowArticleNr(1, arSTrueFalse, "Show article number");
if( arBTrueFalse[arSTrueFalse.find(sShowArticleNr,0)] ) arBShowColumn.append(0);
PropString sShowDescription01(2, arSTrueFalse, "Show description 01");
if( arBTrueFalse[arSTrueFalse.find(sShowDescription01,0)] ) arBShowColumn.append(1);
PropString sShowDescription02(3, arSTrueFalse, "Show description 02");
if( arBTrueFalse[arSTrueFalse.find(sShowDescription02,0)] ) arBShowColumn.append(2);
PropString sShowHeight(4, arSTrueFalse, "Show height");
if( arBTrueFalse[arSTrueFalse.find(sShowHeight,0)] ) arBShowColumn.append(3);
PropString sShowWidth(5, arSTrueFalse, "Show width");
if( arBTrueFalse[arSTrueFalse.find(sShowWidth,0)] ) arBShowColumn.append(4);
PropString sShowThickness(6, arSTrueFalse, "Show thickness");
if( arBTrueFalse[arSTrueFalse.find(sShowThickness,0)] ) arBShowColumn.append(5);
PropString sShowLength(7, arSTrueFalse, "Show length");
if( arBTrueFalse[arSTrueFalse.find(sShowLength,0)] ) arBShowColumn.append(6);
PropString sShowLabel(8, arSTrueFalse, "Show label");
if( arBTrueFalse[arSTrueFalse.find(sShowLabel,0)] ) arBShowColumn.append(7);
PropString sShowUnits(9, arSTrueFalse, "Show units");
if( arBTrueFalse[arSTrueFalse.find(sShowUnits,0)] ) arBShowColumn.append(8);
PropString sShowQuantity(10, arSTrueFalse, "Show quantity");
if( arBTrueFalse[arSTrueFalse.find(sShowQuantity,0)] ) arBShowColumn.append(9);
PropString sShowDWeight(10, arSTrueFalse, "Show dweight", 1);
if( arBTrueFalse[arSTrueFalse.find(sShowDWeight,0)] ) arBShowColumn.append(10);

int arNSortKeys[] = {0,1,2,3,4,5,6,7,8,9};
String arSSortKeys[] = {
	"Article Number",
	"Description 01",
	"Description 02",
	"Height",
	"Width",
	"Thickness",
	"Length",
	"Label",
	"Units",
	"Quantity",
	"DWeight"
};
PropString sSortKey(11, arSSortKeys, "Sort column");
int nSortKey = arNSortKeys[ arSSortKeys.find(sSortKey,0) ];

String arSSortMode[] = {"Ascending", "Descending"};
PropString sSortMode(12, arSSortMode, "Sort mode",0);
int bAscending = arBTrueFalse[arSSortMode.find(sSortMode,0)];

String arSAlign[] = {T("Left"), T("Center"), T("Right")};
int arNAlign[] = {1, 0, -1};
PropString sAlignHeader(13, arSAlign, T("Align header"));
int nAlignHeader = arNAlign[arSAlign.find(sAlignHeader,0)];
PropString sAlignContent(14, arSAlign, T("Align content"));
int nAlignContent = arNAlign[arSAlign.find(sAlignContent,0)];

//PropString sOnUpdate(15, arSTrueFalse, T("Update bill of material"),1);
//int bOnUpdate = arBTrueFalse[ arSTrueFalse.find(sOnUpdate,1) ];

Group grpCurrent = _kCurrentGroup;

String arSTrigger[] = {
	T("|Change or Update materials|")
};

for( int i=0;i<arSTrigger.length();i++ )
	addRecalcTrigger(_kContext, arSTrigger[i] );


if( _bOnInsert ){
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	_Pt0 = getPoint(TN("|Select upper left corner of bill of material.|"));

	Group arGrp[] = Group().allExistingGroups();

	if( grpCurrent.namePart(0) == ""){
		reportWarning(TN("|No current group selected!\nSet group current at floor level.|"));
		eraseInstance();
		return;
	}
	else if( grpCurrent.namePart(1) == "" || grpCurrent.namePart(2) != "" ){
		reportWarning(TN("|Set group current at floor level.|"));
		eraseInstance();
		return;
	}
	else if( grpCurrent.name().find("_",0) != -1 ){
		reportMessage(TN("|Groupname cannot contain a| '_'"));
		eraseInstance();
		return;
	}		
	else{
		reportMessage(TN("|Hsb-LooseMaterials is part of| ") + grpCurrent.name());
	}
}

String sHouse = grpCurrent.namePart(0);
String sFloor = grpCurrent.namePart(1);

Entity arEnt[] = grpCurrent.collectEntities(FALSE, TslInst(), _kModelSpace);
if( _bOnInsert ){
	for( int i=0;i<arEnt.length();i++ ){
		Entity ent = arEnt[i];
	
		if( ent.bIsKindOf(TslInst()) ){
			TslInst tsl = (TslInst)ent;
			
			if( tsl.propString(T("Floor group")) == sHouse+"_"+sFloor ){
				reportWarning(TN("|There is already a tsl called Hsb-LooseMaterials attached to this floorgroup|!") + TN("|Change this tsl|!"));
				eraseInstance();
				return;
			}
		}
	}
}


PropString sFloorGroup(19, "", T("Floor group"));
if( _bOnInsert  ){
	sFloorGroup.set(sHouse+"_"+sFloor);
	sFloorGroup.setReadOnly(true);
	showDialogOnce(T("|_Default|"));
}
Group grpToAttachTslTo;
grpToAttachTslTo.setName(sFloorGroup.token(0,"_")+"\\"+sFloorGroup.token(1,"_"));
grpToAttachTslTo.addEntity(_ThisInst, true);
sFloorGroup.setReadOnly(TRUE);

//if( sFloorGroup != (sHouse+"_"+sFloor) && bOnUpdate){ 
//	reportWarning(T("Set '"+sFloorGroup+"' current!\n The list belongs to that group."));
//	bOnUpdate = FALSE;
//}

//Export to dxi is TRUE
exportToDxi(TRUE);

Display dpLine(nColorLine);
dpLine.dimStyle(sDimStyle);
Display dpHeader(nColorHeader);
dpHeader.dimStyle(sDimStyle);
Display dpGroup(nColorGroup);
dpGroup.dimStyle(sDimStyle);
Display dpContent(nColorContent);
dpContent.dimStyle(sDimStyle);

//Used for sorting
String arSSort[0];

//Columns
String arSGroup[0];
String arSTSLGroup[0];
String arSArticleNumber[0];
String arSCategory[0];
String arSDescription01[0];
String arSDescription02[0];
double arDHeight[0];
double arDWidth[0];
double arDThickness[0];
double arDLength[0];
String arSLabel[0];
String arSUnits[0];
double arDQuantity[0];
String arSQuantity[0];
double arSDWeight[0];

//Nr of rows
int nNrOfRows = 0;
//Collect data
String sExe = _kPathHsbInstall + "//Utilities//LooseMaterials//hsbCadLooseMaterial.exe";
String sCurDir = dwgFullName();
sCurDir = sCurDir.left( sCurDir.length() - (String(dwgName()).length() + 4) );
String sFile = sCurDir + sFloorGroup + ".xml";

if( _bOnInsert || _kExecuteKey == arSTrigger[0]){
	_Map.readFromXmlFile(sFile);
	if( _Map.length() == 0 );
	{
		_Map.writeToXmlFile(sFile);
	}
	
	reportMessage("Loose materials written to: "+sFile);
	spawn("", sExe, "\""+sFile+"\"", "");
	_Map.readFromXmlFile(sFile);

	if( _bOnInsert ){
		return;
	}
}

Map hsbMap = _Map;
Map mapLooseMaterial = hsbMap.getMap("LooseMaterial");

while( TRUE ){
	if( mapLooseMaterial.hasMap(nNrOfRows) ){
		Map articleMap = mapLooseMaterial.getMap( nNrOfRows );
		arSGroup.append(articleMap.getString("Group"));
		arSTSLGroup.append(articleMap.getString("Group") + " ("+articleMap.getString("Category")+")");
		arSArticleNumber.append(articleMap.getString("ArticleNumber"));
		arSCategory.append(articleMap.getString("Category"));
		arSDescription01.append(articleMap.getString("Description01"));
		arSDescription02.append(articleMap.getString("Description02"));
		arDHeight.append(articleMap.getDouble("Height"));
		arDWidth.append(articleMap.getDouble("Width"));
		arDThickness.append(articleMap.getDouble("Thickness"));
		arDLength.append(articleMap.getDouble("Length"));
		arSLabel.append(articleMap.getString("Label"));
		arSUnits.append(articleMap.getDouble("Units"));
		arSDWeight.append(articleMap.getDouble("DWeight"));
		double dQuantity = articleMap.getDouble("Quantity");
		arDQuantity.append(dQuantity);
		String sQuantity = dQuantity;
		arSQuantity.append(sQuantity);
		String sSortQuantity;
		if( dQuantity < 10 ){
			sSortQuantity = "00000"+sQuantity;
		}
		else if( dQuantity < 100 ){
			sSortQuantity = "0000"+sQuantity;
		}
		else if( dQuantity < 1000 ){
			sSortQuantity = "000"+sQuantity;
		}
		else if( dQuantity < 10000 ){
			sSortQuantity = "00"+sQuantity;
		}
		else if( dQuantity < 100000 ){
			sSortQuantity = "0"+sQuantity;
		}
		else{
			reportWarning("Increase maximum quantity in TSL.");
		}

		arSSort.append(	
			articleMap.getString("ArticleNumber") + ";" +
			articleMap.getString("Description01") + ";" + 
			articleMap.getString("Description02") + ";" +
			articleMap.getDouble("Height") + ";" +
			articleMap.getDouble("Width") + ";" +
			articleMap.getDouble("Thickness") + ";" +
			articleMap.getDouble("Length") + ";" +
			articleMap.getString("Label") + ";" +
			articleMap.getString("Units") + ";" +
			sSortQuantity + ":" + 
			articleMap.getDouble("DWeight")
		);
	}
	else{
		break;
	}
	nNrOfRows++;
}

//Draw header and outline
double dRH = 2*dpContent.textHeightForStyle("DESCRIPTION 01", sDimStyle);

Point3d ptTxtSt = _Pt0 - _YW * 0.5 * dRH;

String arSHeader[0];
arSHeader.append("ARTICLE NUMBER");
arSHeader.append("DESCRIPTION 01");
arSHeader.append("DESCRIPTION 02");
arSHeader.append("HEIGHT");
arSHeader.append("WIDTH");
arSHeader.append("THICKNESS");
arSHeader.append("LENGTH");
arSHeader.append("LABEL");
arSHeader.append("UNITS");
arSHeader.append("QUANTITY");
arSHeader.append("DWEIGHT");

double dCWArticleNumber = dpContent.textLengthForStyle("ARTICLE NUMBER", sDimStyle);
double dCWDescription01 = dpContent.textLengthForStyle("DESCRIPTION 01", sDimStyle);
double dCWDescription02 = dpContent.textLengthForStyle("DESCRIPTION 02", sDimStyle);
double dCWHeight = dpContent.textLengthForStyle("HEIGHT", sDimStyle);
double dCWWidth = dpContent.textLengthForStyle("WIDTH", sDimStyle);
double dCWThickness = dpContent.textLengthForStyle("THICKNESS", sDimStyle);
double dCWLength = dpContent.textLengthForStyle("LENGTH", sDimStyle);
double dCWLabel = dpContent.textLengthForStyle("LABEL", sDimStyle);
double dCWUnits = dpContent.textLengthForStyle("UNITS", sDimStyle);
double dCWQuantity = dpContent.textLengthForStyle("QUANTITY", sDimStyle);
double dCWDWeight = dpContent.textLengthForStyle("DWEIGHT", sDimStyle);

for(int i=0;i<nNrOfRows;i++){
	double dArticleNumber = dpContent.textLengthForStyle(arSArticleNumber[i], sDimStyle);
	if( dArticleNumber > dCWArticleNumber ) dCWArticleNumber = dArticleNumber;
	double dDescription01 = dpContent.textLengthForStyle(arSDescription01[i], sDimStyle);
	if( dDescription01 > dCWDescription01 ) dCWDescription01 = dDescription01;
	double dDescription02 = dpContent.textLengthForStyle(arSDescription02[i], sDimStyle);
	if( dDescription02 > dCWDescription02 ) dCWDescription02 = dDescription02;
	double dHeight = dpContent.textLengthForStyle(arDHeight[i], sDimStyle);
	if( dHeight > dCWHeight ) dCWHeight = dHeight;
	double dWidth = dpContent.textLengthForStyle(arDWidth[i], sDimStyle);
	if( dWidth > dCWWidth ) dCWWidth = dWidth;
	double dThickness = dpContent.textLengthForStyle(arDThickness[i], sDimStyle);
	if( dThickness > dCWThickness ) dCWThickness = dThickness;
	double dLength = dpContent.textLengthForStyle(arDLength[i], sDimStyle);
	if( dLength > dCWLength ) dCWLength = dLength;
	double dLabel = dpContent.textLengthForStyle(arSLabel[i], sDimStyle);
	if( dLabel > dCWLabel ) dCWLabel = dLabel;
	double dUnits = dpContent.textLengthForStyle(arSUnits[i], sDimStyle);
	if( dUnits > dCWUnits ) dCWUnits = dUnits;
	double dQuantity = dpContent.textLengthForStyle(arSQuantity[i], sDimStyle);
	if( dQuantity > dCWQuantity ) dCWQuantity = dQuantity;
	double dDWeight = dpContent.textLengthForStyle(arSDWeight[i], sDimStyle);
	if( dDWeight > dCWDWeight ) dCWDWeight = dDWeight;
}
double dCWExtra = 2*dpContent.textHeightForStyle("ABC", sDimStyle);
double arDColumnWidth[0];
arDColumnWidth.append(dCWArticleNumber + dCWExtra);
arDColumnWidth.append(dCWDescription01 + dCWExtra);
arDColumnWidth.append(dCWDescription02 + dCWExtra);
arDColumnWidth.append(dCWHeight + dCWExtra);
arDColumnWidth.append(dCWWidth + dCWExtra);
arDColumnWidth.append(dCWThickness + dCWExtra);
arDColumnWidth.append(dCWLength + dCWExtra);
arDColumnWidth.append(dCWLabel + dCWExtra);
arDColumnWidth.append(dCWUnits + dCWExtra);
arDColumnWidth.append(dCWQuantity + dCWExtra);
arDColumnWidth.append(dCWDWeight + dCWExtra);

int nNrOfColumns = arSHeader.length();
double dRowLength = 0;
for(int i=0;i<arDColumnWidth.length();i++){
	if( arBShowColumn.find(i) == -1 )continue;
	dRowLength = dRowLength + arDColumnWidth[i];
}

//Draw header and outline of table.
Point3d ptTL = _Pt0;
Point3d ptTR = ptTL + _XW * dRowLength;

//header
PLine plHor(ptTL, ptTR);
Vector3d vMoveHor(-_YW * 0.9 * dRH);
plHor.transformBy(vMoveHor);
dpLine.draw(plHor);
vMoveHor = -_YW * 0.1 * dRH;
plHor.transformBy(vMoveHor);
dpLine.draw(plHor);
vMoveHor = -_YW * dRH;

PLine plVer(ptTL, ptTL -_YW * dRH);
dpLine.draw(plVer);

Point3d ptTextHeader = ptTL - _YW * 0.5 * dRH + nAlignHeader * _XW * 0.5 * dCWExtra;
for(int i=0;i<nNrOfColumns;i++){
	if( arBShowColumn.find(i) == -1 )continue;
	
	if( nAlignHeader == 1 ){//Left
		ptTextHeader = ptTextHeader;
	}
	else if( nAlignHeader == 0 ){//Center
		ptTextHeader = ptTextHeader + _XW * 0.5 * arDColumnWidth[i];
	}
	else if( nAlignHeader == -1 ){//Right
		ptTextHeader = ptTextHeader + _XW * arDColumnWidth[i];
	}
	
	dpHeader.draw(arSHeader[i],ptTextHeader, _XW, _YW, nAlignHeader, 0);
	Vector3d vMoveVer(_XW*arDColumnWidth[i]);
	plVer.transformBy(vMoveVer);
	dpLine.draw(plVer);
	
	if( nAlignHeader == 1 ){//Left
		ptTextHeader = ptTextHeader + _XW * arDColumnWidth[i];
	}
	else if( nAlignHeader == 0 ){//Center
		ptTextHeader = ptTextHeader + _XW * 0.5 * arDColumnWidth[i];
	}
	else if( nAlignHeader == -1 ){//Right
		//Do nothing
	}
}

//Time to sort
for(int i=0;i<nNrOfRows;i++){
	arSSort[i] = arSTSLGroup[i] + arSSort[i].token(nSortKey);
}
String sSort;
double dSort;
for(int s1=1;s1<nNrOfRows;s1++){
	int s11 = s1;
	for(int s2=s1-1;s2>=0;s2--){
		int bSort = arSSort[s11] > arSSort[s2];
		if( bAscending ){
			bSort = arSSort[s11] < arSSort[s2];
		}
		if( bSort ){
			arSSort.swap(s2,s11);
			
			arSTSLGroup.swap(s2, s11);
			arSGroup.swap(s2, s11);
			arSArticleNumber.swap(s2, s11);
			arSCategory.swap(s2, s11);
			arSDescription01.swap(s2, s11);
			arSDescription02.swap(s2, s11);
			arDHeight.swap(s2, s11);
			arDWidth.swap(s2, s11);
			arDThickness.swap(s2, s11);
			arDLength.swap(s2, s11);
			arSLabel.swap(s2, s11);
			arSUnits.swap(s2, s11);
			arSQuantity.swap(s2, s11);
			
			s11=s2;
		}
	}
}

//Draw conent
int nNrOfGroups = 0;
int nQuantityZero = 0;
int nLastValidIndex = 0;
Point3d ptTextContentOrigin = ptTL - _YW * 1.5 * dRH + nAlignContent * _XW * 0.5 * dCWExtra;
PLine plVerContentOrigin(ptTL, ptTL - _YW * dRH);
for(int i=0;i<nNrOfRows;i++){
	if( arSQuantity[i] == "0" ){
		nQuantityZero++;
		continue;
	}
	Point3d ptTextContent = ptTextContentOrigin;
	
	if( i != (nNrOfRows-1) ){
		plHor.transformBy(vMoveHor);
		dpLine.draw(plHor);
	}
	
	int bNewGroup = FALSE;
	if( (i-nQuantityZero) == 0 ){
		bNewGroup = TRUE;
	}
	else{
		if( arSTSLGroup[i] != arSTSLGroup[nLastValidIndex] ){
			bNewGroup = TRUE;
		}
	}
	
	if( bNewGroup ){
		nNrOfGroups++;
		
		if( nAlignContent == 1 ){//Left
			ptTextContent = ptTextContent;
		}
		else if( nAlignContent == 0 ){//Center
			ptTextContent = ptTextContent + _XW * 0.5 * dRowLength;
		}	
		else if( nAlignContent == -1 ){//Right
			ptTextContent = ptTextContent + _XW * dRowLength;
		}

		dpGroup.draw(arSTSLGroup[i],ptTextContent, _XW, _YW, nAlignContent, 0);
		
		plHor.transformBy(vMoveHor);
		dpLine.draw(plHor);
					
		ptTextContentOrigin.transformBy(vMoveHor);
		plVerContentOrigin.transformBy(vMoveHor);
	
		ptTextContent = ptTextContentOrigin;
	}
	
	String arSContent[0];
	arSContent.append(arSArticleNumber[i]);
	arSContent.append(arSDescription01[i]);
	arSContent.append(arSDescription02[i]);
	arSContent.append(arDHeight[i]);
	arSContent.append(arDWidth[i]);
	arSContent.append(arDThickness[i]);
	arSContent.append(arDLength[i]);
	arSContent.append(arSLabel[i]);
	arSContent.append(arSUnits[i]);
	arSContent.append(arSQuantity[i]);
	arSContent.append(arSDWeight[i]);
	
	PLine plVerContent;
	plVerContent = plVerContentOrigin;
	plVerContent.transformBy(vMoveHor);

	for(int j=0;j<nNrOfColumns;j++){
		if( arBShowColumn.find(j) == -1 )continue;
		
		if( nAlignContent == 1 ){//Left
			ptTextContent = ptTextContent;
		}
		else if( nAlignContent == 0 ){//Center
			ptTextContent = ptTextContent + _XW * 0.5 * arDColumnWidth[j];
		}	
		else if( nAlignContent == -1 ){//Right
			ptTextContent = ptTextContent + _XW * arDColumnWidth[j];
		}
		
		dpContent.draw(arSContent[j],ptTextContent, _XW, _YW, nAlignContent, 0);
		Vector3d vMoveVer(_XW*arDColumnWidth[j]);
		plVerContent.transformBy(vMoveVer);
		dpLine.draw(plVerContent);

		if( nAlignContent == 1 ){//Left
			ptTextContent = ptTextContent + _XW * arDColumnWidth[j];
		}
		else if( nAlignContent == 0 ){//Center
			ptTextContent = ptTextContent + _XW * 0.5 * arDColumnWidth[j];
		}	
		else if( nAlignContent == -1 ){//Right
			ptTextContent = ptTextContent;
		}
	}

	ptTextContentOrigin.transformBy(vMoveHor);
	plVerContentOrigin.transformBy(vMoveHor);
	
//	dxaout("HSBARTICLENUMBER", arSArticleNumber[i]);
//	dxaout("HSBGROUP",arSGroup[i]);
//	dxaout("HSBCATEGORY", arSCategory[i]);
//	dxaout("HSBDESCRIPTION01",arSDescription01[i]);
//	dxaout("HSBDESCRIPTION02",arSDescription02[i]);
//	dxaout("HSBHEIGHT",arDHeight[i]);
//	dxaout("HSBWIDTH",arDWidth[i]);
//	dxaout("HSBTHICKNESS",arDThickness[i]);
//	dxaout("HSBLENGTH",arDLength[i]);
//	dxaout("HSBLABEL",arSLabel[i]);
//	dxaout("HSBUNITS",arSUnits[i]);
//	dxaout("HSBQUANTITY",arSQuantity[i]);
//
//	Hardware hwArticle(arSName[i], arSDescription[i], arSArticleNumber[i], 0, 0, arDAmount[i], arSGroup[i]);
	nLastValidIndex = i;
}

Point3d ptBR = ptTR - _YW * dRH * (nNrOfRows + 1 + nNrOfGroups - nQuantityZero);
Point3d ptBL = ptBR - _XW * dRowLength;
//outline
PLine plOutline(ptTL, ptTR, ptBR, ptBL); 
plOutline.close();
dpLine.draw(plOutline);

//sOnUpdate.set("No");
















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
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Add DWeight to table" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="17" />
      <str nm="Date" vl="10/13/2021 9:54:16 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End