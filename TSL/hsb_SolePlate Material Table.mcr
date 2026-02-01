#Version 8
#BeginDescription
Modified by: Alberto Jena (aj@hsb-cad.com)
11.02.2011  -  version 1.4







#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2008 by
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
* date: 14.04.2008
* version 1.0: Release Version
*
* date: 00.06.2009
* version 1.1: 	Change the option for the header and row Column
*				Export teh group to each entry
*
* date: 10.05.2010
* version 1.2:	Change the Table and some small fixes on export
*
* date: 22.05.2010
* version 1.3:	Add extra property for the title of the table
*
* date: 11.02.2011
* version 1.4:	Add group for the new data base
*/

Unit (1, "mm");



PropString sDimStyle(0,_DimStyles,T("|Dimstyle|"));
PropInt nLineColor(0, 171, T("|Color Header and Lines|"));
//PropInt nTitleColor (1,141,T("Title Color"));
//PropInt nHeaderColor (2,3,T("Header Color"));
PropInt nColor (1,143,T("|Row Color|"));

PropString sGrpNm1(1, "00_GF-Soleplates", T("House Level group name"));
sGrpNm1.setDescription("");
PropString sGrpNm2(2, "GF-Soleplates", T("Floor Level group name"));
sGrpNm2.setDescription("");
PropString sDispRepOp(3, "", T("Show Table Dim in Disp Rep"));

PropString sTableTitle(4, "SOLEPLATE BOM", T("Table Title"));

//Tsl names
String sTableEntryScriptName="hsb_SolePlate TableEntry";


if( _bOnInsert ){
	if (insertCycleCount()>1) { eraseInstance(); return; }
	
	showDialogOnce();
	_Pt0=getPoint("Pick a Point");
	return;
}

// collect from empty group
Entity ents[] = Group().collectEntities(TRUE,TslInst(),_kModelSpace);
//Erase tsl's
for( int i=0;i<ents.length();i++ ){
	TslInst tsl = (TslInst)ents[i];
	if (!tsl.bIsValid()) continue;
	
	//name of this (ents[i]) tsl
	String sName = tsl.scriptName();
	
	//Erase the table entry instances
	if( sName == sTableEntryScriptName ){
		Map mpTSL=tsl.map();
		if (mpTSL.hasString("sHandle"))
			if (mpTSL.getString("sHandle")==_ThisInst.handle())
				tsl.dbErase();
	}
	
	//Erase any instance with the same name as this one, but is not this one
	//if( sName == scriptName() && tsl.handle() != _ThisInst.handle() ){
	//	tsl.dbErase();
	//}
}

///////////////////////////////////
// display
Display dp(nColor);
dp.dimStyle(sDimStyle);
LineSeg ls(_Pt0-_XW*U(5), _Pt0+_XW*U(5));
LineSeg ls1(_Pt0-_YW*U(5), _Pt0+_YW*U(5));
dp.draw(ls);
dp.draw(ls1);

//Display
Display dpTitle(nLineColor);
dpTitle.dimStyle(sDimStyle);
Display dpHeader(nLineColor);
dpHeader.dimStyle(sDimStyle);
Display dpLine(nLineColor);


//Collect all the information
String sDescription[0];
String sWidth[0];
String sHeight[0];
int nQty[0];
String sUnit[0];

double dColumnWidth1=0;
double dColumnWidth2=0;
double dColumnWidth3=0;
double dColumnWidth4=0;
double dColumnWidth5=0;

String sGroup="";
if (_Map.hasString("Group"))
{
	sGroup=_Map.getString("Group");
}

Map mpTable;
if (_Map.hasMap("mpTable"))
{
	mpTable=_Map.getMap("mpTable");
	for (int i=0; i<mpTable.length(); i++)
	{
		if (mpTable.keyAt(i)=="mpRow")
		{
			Map mpRow=mpTable.getMap(i);
			//Description
			if (mpRow.hasString("sDescription"))
			{
				String sAux=mpRow.getString("sDescription");
				sDescription.append(sAux);
				if ( (1.25 * dpHeader.textLengthForStyle(sAux, sDimStyle)) > dColumnWidth1)
				{
					dColumnWidth1=1.25 * dpHeader.textLengthForStyle(sAux, sDimStyle);
				}
			}
			else
			{
				sDescription.append("");
			}
			//Width
			if (mpRow.hasString("sWidth"))
			{
				String sAux=mpRow.getString("sWidth");
				sWidth.append(sAux);
				if ( (1.25 * dpHeader.textLengthForStyle(sAux, sDimStyle)) > dColumnWidth2)
				{
					dColumnWidth2=1.25 * dpHeader.textLengthForStyle(sAux, sDimStyle);
				}
			}
			else
			{
				sWidth.append("");
			}
			//Height
			if (mpRow.hasString("sHeight"))
			{
				String sAux=mpRow.getString("sHeight");
				sHeight.append(sAux);
				if ( (1.25 * dpHeader.textLengthForStyle(sAux, sDimStyle)) > dColumnWidth3)
				{
					dColumnWidth3=1.25 * dpHeader.textLengthForStyle(sAux, sDimStyle);
				}
			}
			else
			{
				sHeight.append("");
			}
			//Qty/Length			
			if (mpRow.hasInt("nQty"))
			{
				int nAux=mpRow.getInt("nQty");
				nQty.append(nAux);
				if ( (1.25 * dpHeader.textLengthForStyle(nAux, sDimStyle)) > dColumnWidth4)
				{
					dColumnWidth4=1.25 * dpHeader.textLengthForStyle(nAux, sDimStyle);
				}

			}
			else
			{
				nQty.append(0);
			}
			//Unit
			if (mpRow.hasString("sUnit"))
			{
				String sAux=mpRow.getString("sUnit");
				sUnit.append(sAux);
				if ( (1.25 * dpHeader.textLengthForStyle(sAux, sDimStyle)) > dColumnWidth5)
				{
					dColumnWidth5=1.25 * dpHeader.textLengthForStyle(sAux, sDimStyle);
				}
			}
			else
			{
				sUnit.append("");
			}

		}
	}
}
else
{
	eraseInstance();
	return;
}



if ( (1.25 * dpHeader.textLengthForStyle("Description", sDimStyle)) > dColumnWidth1)
{
	dColumnWidth1=1.25 * dpHeader.textLengthForStyle("Description", sDimStyle);
}
if ( (1.25 * dpHeader.textLengthForStyle("Width", sDimStyle)) > dColumnWidth2)
{
	dColumnWidth2=1.25 * dpHeader.textLengthForStyle("Width", sDimStyle);
}
if ( (1.25 * dpHeader.textLengthForStyle("Height", sDimStyle)) > dColumnWidth3)
{
	dColumnWidth3=1.25 * dpHeader.textLengthForStyle("Height", sDimStyle);
}
if ( (1.25 * dpHeader.textLengthForStyle("Length/Qty", sDimStyle)) > dColumnWidth4)
{
	dColumnWidth4=1.25 * dpHeader.textLengthForStyle("Length/Qty", sDimStyle);
}
if ( (1.25 * dpHeader.textLengthForStyle("Unit", sDimStyle)) > dColumnWidth5)
{
	dColumnWidth5=1.25 * dpHeader.textLengthForStyle("Unit", sDimStyle);
}

double dColumnWidthAr[]={dColumnWidth1, dColumnWidth2, dColumnWidth3, dColumnWidth4, dColumnWidth5};


int nNumberOfColumns=5;
//Create table-entries
//Row index
int nRowIndex = 0;
//Row height
double dRowHeight = 1.5 * dpHeader.textHeightForStyle("Hilma Hamma Screws (50no per Box)", sDimStyle);
//Column width
//double dColumnWidth = 1.25 * dpHeader.textLengthForStyle("Hilma Hamma Screws (50no per Box)", sDimStyle);
double dColumnWidth = dColumnWidth1+dColumnWidth2+dColumnWidth3+dColumnWidth4+dColumnWidth5;


//Draw header of table
dpLine.draw( PLine(_Pt0 + _YW * 2 * dRowHeight, _Pt0 + _XW * (dColumnWidth1+dColumnWidth2+dColumnWidth3+dColumnWidth4+dColumnWidth5) + _YW * 2 * dRowHeight) );
dpTitle.textHeight(1.5 * dRowHeight);
dpTitle.draw( sTableTitle, _Pt0 + _XW * .5 * (dColumnWidth1+dColumnWidth2+dColumnWidth3+dColumnWidth4+dColumnWidth5) + _YW * dRowHeight, _XW, _YW, 0, 0);
dpLine.draw( PLine(_Pt0, _Pt0 + _XW *  (dColumnWidth1+dColumnWidth2+dColumnWidth3+dColumnWidth4+dColumnWidth5)) );
PLine plColumnBorder(_Pt0, _Pt0 + _YW * 2 * dRowHeight);
dpLine.draw(plColumnBorder);
plColumnBorder.transformBy(_XW *  (dColumnWidth1+dColumnWidth2+dColumnWidth3+dColumnWidth4+dColumnWidth5));
dpLine.draw(plColumnBorder);
//Draw column-names of table
Point3d ptTxt = _Pt0 - _YW * nRowIndex * dRowHeight - _YW * .5 * dRowHeight;
dpHeader.draw("Description", ptTxt + _XW * .5 * dColumnWidth1, _XW, _YW, 0, 0);
dpHeader.draw("Width", ptTxt + _XW * (dColumnWidth1+ 0.5 * dColumnWidth2), _XW, _YW, 0, 0);
dpHeader.draw("Height", ptTxt + _XW * (dColumnWidth1+dColumnWidth2+ 0.5 * dColumnWidth3), _XW, _YW, 0, 0);
dpHeader.draw("Length/Qty", ptTxt + _XW * (dColumnWidth1+dColumnWidth2+dColumnWidth3+ 0.5 * dColumnWidth4), _XW, _YW, 0, 0);
dpHeader.draw("Unit", ptTxt + _XW * (dColumnWidth1+dColumnWidth2+dColumnWidth3+dColumnWidth4+ 0.5 * dColumnWidth5), _XW, _YW, 0, 0);
//dpHeader.draw("Description of Beam", ptTxt + _XW * 5.5 * dColumnWidth, _XW, _YW, 0, 0);

plColumnBorder = PLine(_Pt0, _Pt0 - _YW * dRowHeight);
dpLine.draw(plColumnBorder);
for( int i=0;i<nNumberOfColumns;i++ ){
	//plColumnBorder.transformBy(_XW * dColumnWidth);
	plColumnBorder.transformBy(_XW * dColumnWidthAr[i]);
	dpLine.draw(plColumnBorder);
}

double dTotalArea;
double dTotalVolume;

nRowIndex++;



String sScriptName = sTableEntryScriptName;
Vector3d vecUcsX = _XW;
Vector3d vecUcsY = _YW;
//Entities
Beam lstBeams[0];
Entity lstEntity[0];
Point3d lstPoints[0];
//Properties
int lstPropInt[0];
lstPropInt.append(nColor);
double lstPropDouble[0];
lstPropDouble.append(dRowHeight);
lstPropDouble.append(dColumnWidth);
String lstPropString[0];
lstPropString.append(sDimStyle);


for (int i=0; i<sDescription.length(); i++)
{
	
	//String strArea;
	//strArea.formatUnit(dArea,2,4);
	//strArea=strArea+ " m2";
	
	//String strVolume;
	//strVolume.formatUnit(dVolume,2,4);
	//strVolume=strVolume+ " m3";
	
	//dp.draw ("Area:", _Pt0, vXTxt, vYTxt, 1, -1);
	//dp.draw (strArea, _Pt0-vYTxt*dOffset, vXTxt, vYTxt, 1, -1);
	
	//if (dVolume!=0)
	//{
	//	dp.draw ("Volume:", _Pt0-vYTxt*(dOffset*2), vXTxt, vYTxt, 1, -1);
	//	dp.draw (strVolume, _Pt0-vYTxt*(dOffset*3), vXTxt, vYTxt, 1, -1);
	//}
	
	//Upper left corner of row
	Point3d ptRow = _Pt0 - _YW * nRowIndex * dRowHeight;
	//Create PLine to draw as border of the row
	
	//PLine plRowBorder(ptRow, ptRow + _XW * nNumberOfColumns * dColumnWidth);
	PLine plRowBorder(ptRow, ptRow + _XW * dColumnWidth);
	
	
	//Row border
	dpLine.draw(plRowBorder);
	//Column borders
	plColumnBorder.transformBy(-_XW * dColumnWidth - _YW * dRowHeight);
	dpLine.draw(plColumnBorder);
	for( int i=0;i<nNumberOfColumns;i++ ){
		//plColumnBorder.transformBy(_XW * dColumnWidth);
		plColumnBorder.transformBy(_XW * dColumnWidthAr[i]);
		dpLine.draw(plColumnBorder);
	}			
	//Display of the arrays o ptRow	
	Point3d ptTxt = ptRow - _YW * .5 * dRowHeight;
	
	//Show here the display
	
	//dp.draw( sDescription[i], ptTxt + _XW * 0.5 * dColumnWidth, _XW, _YW, 0, 0);
	//dp.draw( sWidth[i], ptTxt + _XW * 1.5 * dColumnWidth, _XW, _YW, 0, 0);
	//dp.draw( nQty[i], ptTxt + _XW * 2.5 * dColumnWidth, _XW, _YW, 0, 0);
	//dp.draw( dOpArea, ptTxt + _XW * 3.5 * dColumnWidth, _XW, _YW, 0, 0);
	//dp.draw( dBmVolume, ptTxt + _XW * 4.5 * dColumnWidth, _XW, _YW, 0, 0);
	//dpHeader.draw(nQty[i], ptTxt + _XW * 4.5 * dColumnWidth, _XW, _YW, 0, 0);
	//dpHeader.draw(sDescription[i], ptTxt + _XW * 5.5 * dColumnWidth, _XW, _YW, 0, 0);
	
	//Transform row border and Increase row-index
	plRowBorder.transformBy(-_YW * dRowHeight);
	nRowIndex++;
	
	//Border of last row
	if( nRowIndex > 0 ){
		dpLine.draw(PLine(_Pt0 - _YW * nRowIndex * dRowHeight, _Pt0 - _YW * nRowIndex * dRowHeight + _XW *  dColumnWidth));
	}

	Map mapRow;
	lstEntity.append(_ThisInst);
	mapRow.setPoint3d("ptOrg", ptRow, _kRelative);
	Map mapThisTableObject;
	mapThisTableObject.setString("sDescription", sDescription[i]);
	mapThisTableObject.setString("sWidth", sWidth[i]);
	mapThisTableObject.setString("sHeight", sHeight[i]);
	mapThisTableObject.setInt("nQty", nQty[i]);
	mapThisTableObject.setString("sUnit", sUnit[i]);
	
	mapRow.setMap("mapTableObject",mapThisTableObject);
	Map mapColumnWidth;
	for( int i=0;i<nNumberOfColumns;i++ )
	{
			mapColumnWidth.appendDouble("dColumnWidth", dColumnWidthAr[i]);
	}	
	mapRow.setMap("mapColumnWidth", mapColumnWidth);
	mapRow.setString("Group", "Soleplate");
	//Create tsl
	TslInst tslTableEntry;
	mapRow.setString("sHandle", _ThisInst.handle());
	tslTableEntry.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEntity, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mapRow);
	tslTableEntry.transformBy(_ZW*U(0));

	//Map mp;
	//mp.setString("Name", sDescription[i]);
	//mp.setInt("Qty", nQty[i]);

	//_Map.appendMap("TSLBOM", mp);

}


String sCompareKey = scriptName();
setCompareKey(sCompareKey);
	
//exportToDxi(TRUE);
//dxaout("U_MODEL",sModel);
//dxaout("U_QUANTITY",nQty);





//Upper left corner of row
Point3d ptRow = _Pt0 - _YW * nRowIndex * dRowHeight;
//Create PLine to draw as border of the row
PLine plRowBorder(ptRow, ptRow + _XW * dColumnWidth);


//Row border
dpLine.draw(plRowBorder);
//Column borders
plColumnBorder.transformBy(-_XW *  dColumnWidth - _YW * dRowHeight);
dpLine.draw(plColumnBorder);
for( int i=0;i<nNumberOfColumns;i++ ){
	//plColumnBorder.transformBy(_XW * dColumnWidth);
	plColumnBorder.transformBy(_XW * dColumnWidthAr[i]);
	dpLine.draw(plColumnBorder);
}			
//Display of the arrays o ptRow	
ptTxt = ptRow - _YW * .5 * dRowHeight;

//Show here the display

//String strTotalArea;
//strTotalArea.formatUnit(dTotalArea,2,4);
//strTotalArea=strTotalArea+ " m2";

//String strTotalVolume;
//strTotalVolume.formatUnit(dTotalVolume,2,4);
//strTotalVolume=strTotalVolume+ " m3";



//dpHeader.draw( "Total", ptTxt + _XW * 0.5 * dColumnWidth, _XW, _YW, 0, 0);
//dpHeader.draw( strTotalArea, ptTxt + _XW * 1.5 * dColumnWidth, _XW, _YW, 0, 0);
//dpHeader.draw( strTotalVolume, ptTxt + _XW * 2.5 * dColumnWidth, _XW, _YW, 0, 0);
//dpHeader.draw(nQty[i], ptTxt + _XW * 4.5 * dColumnWidth, _XW, _YW, 0, 0);
//dpHeader.draw(sDescription[i], ptTxt + _XW * 5.5 * dColumnWidth, _XW, _YW, 0, 0);

//Transform row border and Increase row-index
plRowBorder.transformBy(-_YW * dRowHeight);
nRowIndex++;
	
//Border of last row
if( nRowIndex > 0 ){
	dpLine.draw(PLine(_Pt0 - _YW * nRowIndex * dRowHeight, _Pt0 - _YW * nRowIndex * dRowHeight + _XW * dColumnWidth));
}

Group grpSolePlate(sGrpNm1 + "\\" + sGrpNm2);
grpSolePlate.addEntity(_ThisInst, TRUE);







#End
#BeginThumbnail







#End
