#Version 8
#BeginDescription
Creates a List of Loose Items based on the inventory and they can be export to BOMLink or Excel.

Modified by: Alberto Jena
Date: 20.09.2018 - version 1.17


























#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
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
* Revised: Allberto Jena 05072013 (v1.13)
* Change: Change the name of the argument for the loosematerial.
*
* Revised: Allberto Jena 15042015 (v1.14)
* Change: Change the location of the loosematerial exe to custom\century
*/

Unit (1,"mm");//script uses mm

int bIsMetricDwg = U(1, "mm") == 1;
double dVolumeConversionFactor =  bIsMetricDwg ? .000000001 : .000016387;
double dLengthConversionFactor = bIsMetricDwg ? 1 : 25.4;

//Properties
//Select dimstyle
PropString sDimStyle(0,_DimStyles,"Dimension style");

//Select line color
PropInt nColorLine(0, -1, "Line color");
PropInt nColorHeader(1, -1, "Text color: Header"); 
PropInt nColorGroup(2, -1, "Text color: Groups");
PropInt nColorContent(3, -1, "Text color: Content");

int arBShowColumn[0];
int arBTrueFalse[] = {TRUE, FALSE};
String arSTrueFalse[] = {"Yes", "No"};
PropString sShowArticleHSB(1, arSTrueFalse, "Show article HSB");
if( arBTrueFalse[arSTrueFalse.find(sShowArticleHSB,0)] ) arBShowColumn.append(0);
PropString sShowArticleNr(2, arSTrueFalse, "Show article number");
if( arBTrueFalse[arSTrueFalse.find(sShowArticleNr,0)] ) arBShowColumn.append(1);
PropString sShowDescription01(3, arSTrueFalse, "Show description");
if( arBTrueFalse[arSTrueFalse.find(sShowDescription01,0)] ) arBShowColumn.append(2);
PropString sShowMaterial(4, arSTrueFalse, "Show material");
if( arBTrueFalse[arSTrueFalse.find(sShowMaterial,0)] ) arBShowColumn.append(3);
PropString sShowHeight(5, arSTrueFalse, "Show height");
if( arBTrueFalse[arSTrueFalse.find(sShowHeight,0)] ) arBShowColumn.append(4);
PropString sShowWidth(6, arSTrueFalse, "Show width");
if( arBTrueFalse[arSTrueFalse.find(sShowWidth,0)] ) arBShowColumn.append(5);
PropString sShowThickness(7, arSTrueFalse, "Show length/thickness");
if( arBTrueFalse[arSTrueFalse.find(sShowThickness,0)] ) arBShowColumn.append(6);
PropString sShowLabel(9, arSTrueFalse, "Show label");
if( arBTrueFalse[arSTrueFalse.find(sShowLabel,0)] ) arBShowColumn.append(7);
PropString sShowFunction(10, arSTrueFalse, "Show function");
if( arBTrueFalse[arSTrueFalse.find(sShowFunction,0)] ) arBShowColumn.append(8);
PropString sShowUnits(11, arSTrueFalse, "Show units");
if( arBTrueFalse[arSTrueFalse.find(sShowUnits,0)] ) arBShowColumn.append(9);
PropString sShowQuantity(12, arSTrueFalse, "Show quantity");
if( arBTrueFalse[arSTrueFalse.find(sShowQuantity,0)] ) arBShowColumn.append(10);

int arNSortKeys[] = {0,1,2,3,4,5,6,7,8,9,10,11};
String arSSortKeys[] = {
	"Article HSB",
	"Article Number",
	"Description",
	"Material",
	"Height",
	"Width",
	"Length",
	"Label",
	"Function",
	"Units",
	"Quantity"
};
PropString sSortKey(14, arSSortKeys, "Sort column");
int nSortKey = arNSortKeys[ arSSortKeys.find(sSortKey,0) ];

String arSSortMode[] = {"Ascending", "Descending"};
PropString sSortMode(15, arSSortMode, "Sort mode",0);
int bAscending = arBTrueFalse[arSSortMode.find(sSortMode,0)];

String arSAlign[] = {T("Left"), T("Center"), T("Right")};
int arNAlign[] = {1, 0, -1};
PropString sAlignHeader(16, arSAlign, T("Align header"));
int nAlignHeader = arNAlign[arSAlign.find(sAlignHeader,0)];
PropString sAlignContent(17, arSAlign, T("Align content"));
int nAlignContent = arNAlign[arSAlign.find(sAlignContent,0)];

Group grpCurrent = _kCurrentGroup;

//Collect data
String strAssemblyPathProject=_kPathHsbInstall+"\\Utilities\\hsbLooseMaterials\\hsbLooseMaterialsUI.dll";
String strTypeProject="hsbCad.LooseMaterials.UI.MapTransaction";
String strFunctionProject="ShowLooseMaterialsDialog";


Map mpOut;

if (_bOnDbCreated || _bOnInsert) setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert ){
	if( insertCycleCount()>1 )
	{
		eraseInstance();
		return;
	}

	String sAvailableCatalog[] = TslInst().getListOfCatalogNames(scriptName());

	if (sAvailableCatalog.find(_kExecuteKey, -1) == -1)
	{
		showDialogOnce();
	}
	
	_Pt0 = getPoint("Select upper left corner of bill of material.");
	Map mpIn;
	mpOut = callDotNetFunction2(strAssemblyPathProject, strTypeProject, strFunctionProject, mpIn);
	
	_Map=Map();
	_Map=mpOut;
	
	return;

}

String strChangeEntity = T("|Update Loose Materials|");

addRecalcTrigger(_kContext, strChangeEntity );

if (_bOnRecalc && _kExecuteKey==strChangeEntity)
{
	Map mpIn=_Map;
	mpOut=Map();
      mpOut = callDotNetFunction2(strAssemblyPathProject, strTypeProject, strFunctionProject, mpIn);
	if (mpOut.hasMap("Result"))
	{
		Map mpResult=mpOut.getMap("Result");
		
		int n=mpResult.getInt("DialogResult");
		if (n==true)
		{
			_Map=Map();
			_Map=mpOut;
		}
	}
}

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
String arSArticleHSB[0];
String arSArticleNumber[0];
String arSGrade[0];
String arSDescription01[0];
String arSMaterial[0];
double arDHeight[0];
double arDWidth[0];
double arDLength[0];
String arSLabel[0];
String arSFunction[0];
String arSUnits[0];
double arDQuantity[0];
String arSQuantity[0];

//Nr of rows
int nNrOfRows = 0;


Map hsbMap = _Map;
Map mpItems;
if (hsbMap.hasMap("ITEM[]"))
{
	mpItems=hsbMap.getMap("ITEM[]");
}
else
{
	eraseInstance();
	return;
}

while ( TRUE )
{
	if ( mpItems.hasMap(nNrOfRows) )
	{
		Map articleMap = mpItems.getMap( nNrOfRows );
		arSGroup.append(articleMap.getString("MinorGroup"));
		
		String sUsage = "";
		if (articleMap.hasMap("Responsibility"))
		{
			Map mpUsage = articleMap.getMap("Responsibility");
			sUsage = mpUsage.getString("Description");
		}
		String sThisArticleHSB = articleMap.getString("InventoryNumber");
		arSTSLGroup.append(articleMap.getString("MinorGroup") + " (" + sUsage + ")");
		arSArticleHSB.append(sThisArticleHSB);
		arSArticleNumber.append(articleMap.getString("SupplierNumber"));
		arSDescription01.append(articleMap.getString("Description"));
		arSMaterial.append(articleMap.getString("Material"));
		arSGrade.append(articleMap.getString("Grade"));
		double dAuxHeight = articleMap.getDouble("Height");
		double dAuxWidth = articleMap.getDouble("Width");
		double dAuxLength = articleMap.getDouble("Length");
		if ( ! bIsMetricDwg) //mm
		{
			dAuxHeight *= dLengthConversionFactor;
			dAuxWidth *= dLengthConversionFactor;
			dAuxLength *= dLengthConversionFactor;
		}
		arDHeight.append(dAuxHeight);
		arDWidth.append(dAuxWidth);
		arDLength.append(dAuxLength);
		
		arSLabel.append(articleMap.getString("Label"));
		arSFunction.append(articleMap.getString("Usage"));
		Map mpUnits = articleMap.getMap("UnitType");
		arSUnits.append(mpUnits.getString("ShortName"));
		double dQuantity = articleMap.getDouble("Quantity");
		arDQuantity.append(dQuantity);
		String sQuantity = dQuantity;
		arSQuantity.append(sQuantity);
		String sSortQuantity;
		if ( dQuantity < 10 ) {
			sSortQuantity = "000000" + sQuantity;
		}
		else if ( dQuantity < 100 ) {
			sSortQuantity = "00000" + sQuantity;
		}
		else if ( dQuantity < 1000 ) {
			sSortQuantity = "0000" + sQuantity;
		}
		else if ( dQuantity < 10000 ) {
			sSortQuantity = "000" + sQuantity;
		}
		else if ( dQuantity < 100000 ) {
			sSortQuantity = "00" + sQuantity;
		}
		else if ( dQuantity < 1000000 ) {
			sSortQuantity = "0" + sQuantity;
		}
		else {
			reportWarning("Increase maximum quantity in TSL.");
		}
		
		int nQty = dQuantity;
		//__also save to HardwareComp for Excel exporter if needed
		HardWrComp hwc(sThisArticleHSB, nQty);
		hwc.setManufacturer(articleMap.getString("SupplierNumber"));
		hwc.setName("");
		hwc.setMaterial(articleMap.getString("Material"));
		hwc.setDescription(articleMap.getString("Description"));
		hwc.setModel("");
		hwc.setCategory(articleMap.getString("MinorGroup"));
		hwc.setGroup(sUsage);
		hwc.setNotes(mpUnits.getString("ShortName"));
		hwc.setDScaleX(dAuxLength);
		hwc.setDScaleY(dAuxWidth);
		hwc.setDScaleZ(dAuxHeight);
		
		HardWrComp hwcStored[] = _ThisInst.hardWrComps();
		HardWrComp hwcNew[0];
		hwcNew.append(hwc);
		
		for (int k = 0; k < hwcStored.length(); k++)
		{
			hwc = hwcStored[k];
			if (hwc.articleNumber() == sThisArticleHSB) continue;
			hwcNew.append(hwc);
		}
		
		_ThisInst.setHardWrComps(hwcNew);
		
		
		
		arSSort.append(	articleMap.getString("ArticleHSB") + ";" +
		articleMap.getString("SupplierNumber") + ";" +
		articleMap.getString("Description01") + ";" +
		articleMap.getString("Material") + ";" +
		articleMap.getDouble("Height") + ";" +
		articleMap.getDouble("Width") + ";" +
		articleMap.getDouble("Length") + ";" +
		articleMap.getString("Label") + ";" +
		articleMap.getString("Function") + ";" +
		articleMap.getString("Units") + ";" +
		sSortQuantity);
	}
	else
	{
		break;
	}
	nNrOfRows++;
}

//Draw header and outline
double dRH = 2*dpContent.textHeightForStyle("DESCRIPTION", sDimStyle);

Point3d ptTxtSt = _Pt0 - _YW * 0.5 * dRH;

String arSHeader[0];
arSHeader.append("ARTICLE HSB");
arSHeader.append("SUPPLIER NUMBER");
arSHeader.append("DESCRIPTION");
arSHeader.append("MATERIAL");
arSHeader.append("HEIGHT");
arSHeader.append("WIDTH");
arSHeader.append("LENGTH");
arSHeader.append("LABEL");
arSHeader.append("FUNCTION");
arSHeader.append("UNITS");
arSHeader.append("QUANTITY");

double dCWArticleHSB = dpContent.textLengthForStyle("ARTICLE HSB", sDimStyle);
double dCWArticleNumber = dpContent.textLengthForStyle("SUPPLIER NUMBER", sDimStyle);
double dCWDescription01 = dpContent.textLengthForStyle("DESCRIPTION", sDimStyle);
double dCWMaterial = dpContent.textLengthForStyle("MATERIAL", sDimStyle);
double dCWHeight = dpContent.textLengthForStyle("HEIGHT", sDimStyle);
double dCWWidth = dpContent.textLengthForStyle("WIDTH", sDimStyle);
double dCWLength = dpContent.textLengthForStyle("LENGTH", sDimStyle);
double dCWLabel = dpContent.textLengthForStyle("LABEL", sDimStyle);
double dCWFunction = dpContent.textLengthForStyle("FUNCTION", sDimStyle);
double dCWUnits = dpContent.textLengthForStyle("UNITS", sDimStyle);
double dCWQuantity = dpContent.textLengthForStyle("QUANTITY", sDimStyle);

for(int i=0;i<nNrOfRows;i++){
	double dArticleHSB = dpContent.textLengthForStyle(arSArticleHSB[i], sDimStyle);
	if( dArticleHSB > dCWArticleHSB ) dCWArticleHSB = dArticleHSB;
	double dArticleNumber = dpContent.textLengthForStyle(arSArticleNumber[i], sDimStyle);
	if( dArticleNumber > dCWArticleNumber ) dCWArticleNumber = dArticleNumber;
	double dDescription01 = dpContent.textLengthForStyle(arSDescription01[i], sDimStyle);
	if( dDescription01 > dCWDescription01 ) dCWDescription01 = dDescription01;
	double dMaterial = dpContent.textLengthForStyle(arSMaterial[i], sDimStyle);
	if( dMaterial > dCWMaterial ) dCWMaterial = dMaterial;
	double dHeight = dpContent.textLengthForStyle(arDHeight[i], sDimStyle);
	if( dHeight > dCWHeight ) dCWHeight = dHeight;
	double dWidth = dpContent.textLengthForStyle(arDWidth[i], sDimStyle);
	if( dWidth > dCWWidth ) dCWWidth = dWidth;
	double dLength = dpContent.textLengthForStyle(arDLength[i], sDimStyle);
	if( dLength > dCWLength ) dCWLength = dLength;
	double dLabel = dpContent.textLengthForStyle(arSLabel[i], sDimStyle);
	if( dLabel > dCWLabel ) dCWLabel = dLabel;
	double dFunction = dpContent.textLengthForStyle(arSFunction[i], sDimStyle);
	if( dFunction > dCWFunction ) dCWFunction = dFunction;
	double dUnits = dpContent.textLengthForStyle(arSUnits[i], sDimStyle);
	if( dUnits > dCWUnits ) dCWUnits = dUnits;
	double dQuantity = dpContent.textLengthForStyle(arSQuantity[i], sDimStyle);
	if( dQuantity > dCWQuantity ) dCWQuantity = dQuantity;
}
double dCWExtra = 2*dpContent.textHeightForStyle("ABC", sDimStyle);
double arDColumnWidth[0];
arDColumnWidth.append(dCWArticleHSB + dCWExtra);
arDColumnWidth.append(dCWArticleNumber + dCWExtra);
arDColumnWidth.append(dCWDescription01 + dCWExtra);
arDColumnWidth.append(dCWMaterial + dCWExtra);
arDColumnWidth.append(dCWHeight + dCWExtra);
arDColumnWidth.append(dCWWidth + dCWExtra);
arDColumnWidth.append(dCWLength + dCWExtra);
arDColumnWidth.append(dCWLabel + dCWExtra);
arDColumnWidth.append(dCWFunction + dCWExtra);
arDColumnWidth.append(dCWUnits + dCWExtra);
arDColumnWidth.append(dCWQuantity + dCWExtra);

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
			sSort = arSSort[s2];				arSSort[s2] = arSSort[s11];						arSSort[s11] = sSort;
			
			sSort = arSTSLGroup[s2];			arSTSLGroup[s2] = arSTSLGroup[s11];				arSTSLGroup[s11] = sSort;
			sSort = arSGroup[s2];			arSGroup[s2] = arSGroup[s11];					arSGroup[s11] = sSort;
			sSort = arSArticleHSB[s2];		arSArticleHSB[s2] = arSArticleHSB[s11];			arSArticleHSB[s11] = sSort;
			sSort = arSArticleNumber[s2];		arSArticleNumber[s2] = arSArticleNumber[s11];		arSArticleNumber[s11] = sSort;
			sSort = arSGrade[s2];			arSGrade[s2] = arSGrade[s11];					arSGrade[s11] = sSort;
			sSort = arSDescription01[s2];		arSDescription01[s2] = arSDescription01[s11];		arSDescription01[s11] = sSort;
			sSort = arSMaterial[s2];			arSMaterial[s2] = arSMaterial[s11];				arSMaterial[s11] = sSort;
			dSort = arDHeight[s2];			arDHeight[s2] = arDHeight[s11];					arDHeight[s11] = dSort;
			dSort = arDWidth[s2];			arDWidth[s2] = arDWidth[s11];					arDWidth[s11] = dSort;
			dSort = arDLength[s2];			arDLength[s2] = arDLength[s11];					arDLength[s11] = dSort;
			sSort = arSLabel[s2];				arSLabel[s2] = arSLabel[s11];						arSLabel[s11] = sSort;
			sSort = arSFunction[s2];			arSFunction[s2] = arSFunction[s11];				arSFunction[s11] = sSort;
			sSort = arSUnits[s2];				arSUnits[s2] = arSUnits[s11];						arSUnits[s11] = sSort;
			sSort = arSQuantity[s2];			arSQuantity[s2] = arSQuantity[s11];				arSQuantity[s11] = sSort;
			
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
for (int i = 0; i < nNrOfRows; i++) {
	//if( arSQuantity[i] == "0" )
	//{
	//	nQuantityZero++;
	//	continue;
	//}
	Point3d ptTextContent = ptTextContentOrigin;
	
	if ( i != (nNrOfRows - 1) ) {
		plHor.transformBy(vMoveHor);
		dpLine.draw(plHor);
	}
	
	int bNewGroup = FALSE;
	if ( (i - nQuantityZero) == 0 ) {
		bNewGroup = TRUE;
	}
	else {
		if ( arSTSLGroup[i] != arSTSLGroup[nLastValidIndex] ) {
			bNewGroup = TRUE;
		}
	}
	
	if ( bNewGroup ) {
		nNrOfGroups++;
		
		if ( nAlignContent == 1 ) {//Left
			ptTextContent = ptTextContent;
		}
		else if ( nAlignContent == 0 ) {//Center
			ptTextContent = ptTextContent + _XW * 0.5 * dRowLength;
		}
		else if ( nAlignContent == -1 ) {//Right
			ptTextContent = ptTextContent + _XW * dRowLength;
		}
		
		dpGroup.draw(arSTSLGroup[i], ptTextContent, _XW, _YW, nAlignContent, 0);
		
		plHor.transformBy(vMoveHor);
		dpLine.draw(plHor);
		
		ptTextContentOrigin.transformBy(vMoveHor);
		plVerContentOrigin.transformBy(vMoveHor);
		
		ptTextContent = ptTextContentOrigin;
	}
	
	String arSContent[0];
	arSContent.append(arSArticleHSB[i]);
	arSContent.append(arSArticleNumber[i]);
	arSContent.append(arSDescription01[i]);
	arSContent.append(arSMaterial[i]);
	arSContent.append(arDHeight[i]);
	arSContent.append(arDWidth[i]);
	arSContent.append(arDLength[i]);
	arSContent.append(arSLabel[i]);
	arSContent.append(arSFunction[i]);
	arSContent.append(arSUnits[i]);
	arSContent.append(arSQuantity[i]);
	
	PLine plVerContent;
	plVerContent = plVerContentOrigin;
	plVerContent.transformBy(vMoveHor);
	
	for (int j = 0; j < nNrOfColumns; j++) {
		if ( arBShowColumn.find(j) == -1 )continue;
		
		if ( nAlignContent == 1 ) {//Left
			ptTextContent = ptTextContent;
		}
		else if ( nAlignContent == 0 ) {//Center
			ptTextContent = ptTextContent + _XW * 0.5 * arDColumnWidth[j];
		}
		else if ( nAlignContent == -1 ) {//Right
			ptTextContent = ptTextContent + _XW * arDColumnWidth[j];
		}
		
		dpContent.draw(arSContent[j], ptTextContent, _XW, _YW, nAlignContent, 0);
		Vector3d vMoveVer(_XW * arDColumnWidth[j]);
		plVerContent.transformBy(vMoveVer);
		dpLine.draw(plVerContent);
		
		if ( nAlignContent == 1 ) {//Left
			ptTextContent = ptTextContent + _XW * arDColumnWidth[j];
		}
		else if ( nAlignContent == 0 ) {//Center
			ptTextContent = ptTextContent + _XW * 0.5 * arDColumnWidth[j];
		}
		else if ( nAlignContent == -1 ) {//Right
			ptTextContent = ptTextContent;
		}
	}
	
	ptTextContentOrigin.transformBy(vMoveHor);
	plVerContentOrigin.transformBy(vMoveHor);
	
	dxaout("HSBARTICLENUMBER", arSArticleNumber[i]);
	dxaout("HSBGROUP", arSGroup[i]);
	dxaout("HSBARTICLEHSB", arSArticleHSB[i]);
	dxaout("HSBGRADE", arSGrade[i]);
	dxaout("HSBDESCRIPTION01", arSDescription01[i]);
	dxaout("HSBMATERIAL", arSMaterial[i]);
	dxaout("HSBHEIGHT", arDHeight[i]);
	dxaout("HSBWIDTH", arDWidth[i]);
	dxaout("HSBLENGTH", arDLength[i]);
	dxaout("HSBLABEL", arSLabel[i]);
	dxaout("HSBFUNCTION", arSFunction[i]);
	dxaout("HSBUNITS", arSUnits[i]);
	dxaout("HSBQUANTITY", arSQuantity[i]);
	
	//	Hardware hwArticle(arSName[i], arSDescription[i], arSArticleNumber[i], 0, 0, arDAmount[i], arSGroup[i]);
	nLastValidIndex = i;
}

Point3d ptBR = ptTR - _YW * dRH * (nNrOfRows + 1 + nNrOfGroups - nQuantityZero);
Point3d ptBL = ptBR - _XW * dRowLength;
//outline
PLine plOutline(ptTL, ptTR, ptBR, ptBL); 
plOutline.close();
dpLine.draw(plOutline);



















#End
#BeginThumbnail



#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="mpIDESettings">
    <dbl nm="PREVIEWTEXTHEIGHT" ut="N" vl="1" />
  </lst>
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End