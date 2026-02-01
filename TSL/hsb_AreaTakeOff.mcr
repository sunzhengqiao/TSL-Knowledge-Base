#Version 8
#BeginDescription
Export the perimeter, area, number of corners and opening perimeter to the data base.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 06.08.2010 - version 1.2


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
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

* REVISION HISTORY
* -------------------------
*
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 23.07.2010
* version 1.0: Release Version
*
* date: 26.07.2010
* version 1.1: Export to DBase Implement
*
* date: 06.08.2010
* version 1.2: Remove opening export
*/

Unit(1,"mm"); // script uses mm

//Read Sheeting Information

String sPathXMLSh=_kPathPersonalTemp+"\\Inv_Sheet.xml";

Map mapSh;
mapSh.readFromXmlFile(sPathXMLSh);

if (!mapSh.hasString("Result"))
{
	reportNotice("No Valid dll or path not found");
}
else if (mapSh.hasString("Result"))
{
	String sMes=mapSh.getString("Result");
	if (sMes!="")
	{
		//reportNotice("\n"+sMes);
	}
}

String sSheetingName[0];
int nSheetingPartNo[0];
String sSheetingMaterial[0];
double dSheetingWidth[0];
double dSheetingHeight[0];
double dSheetingThickness[0];

if (mapSh.hasMap("Sheet"))
{
	for (int i=0; i<mapSh.length(); i++)
	{
		if (mapSh.keyAt(i)=="Sheet")
		{
			Map mp=mapSh.getMap(i);
			sSheetingName.append(mp.getString("Description"));
			nSheetingPartNo.append(mp.getInt("PartNumber"));
			
			String sAuxMaterial=mp.getString("Material");
			sAuxMaterial.makeUpper();
			sAuxMaterial.trimLeft();
			sAuxMaterial.trimRight();
			sSheetingMaterial.append(sAuxMaterial);
			
			dSheetingWidth.append(mp.getDouble("Width"));
			dSheetingHeight.append(mp.getDouble("Length"));
			dSheetingThickness.append(mp.getDouble("Height"));
		}
	}
}



PropString sDispRep(0, "", T("Show in Disp Rep"));
PropString sLineType(1, _LineTypes, T("Line Type"));
PropString sDimStyle(2, _DimStyles, T("Dim style"));
PropInt nColor(0, 3, T("Color Foundation Lines"));

PropString psExtType(3, "A;B;",  T("Code External Walls"));
psExtType.setDescription(T("Please type the codes of the external walls separate by ; "));

PropString sSheetType(4, sSheetingName, "Floor Sheet Type");

PropDouble dToleranceCavityCloser(0, 15, "% Extra for Cavity Closer");

// Load the values from the catalog
if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

String sArrExtCode[0];
String sExtType=psExtType;
sExtType.trimLeft();
sExtType.trimRight();
sExtType=sExtType+";";
for (int i=0; i<sExtType.length(); i++)
{
	String str=sExtType.token(i);
	str.trimLeft();
	str.trimRight();
	if (str.length()>0)
		sArrExtCode.append(str);
}


if(_bOnInsert)
{
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	if (_kExecuteKey=="")
		showDialogOnce();

	PrEntity ssE (T("Please select Walls"),ElementWall());
	if (ssE.go())
	{
		Entity ents[0];
		ents = ssE.set();
	
 		for (int i = 0; i < ents.length(); i++ )
		{
 			Element el = (Element) ents[i];
			if (el.bIsValid())
			{
 					_Element.append(el);
			}	
 		}
	}
	return;
}

Display dp(nColor);
dp.lineType(sLineType);
dp.dimStyle(sDimStyle);

if (sDispRep!="")
	dp.showInDispRep(sDispRep);


//Segregate Walls
ElementWall eWalls[0];
for (int i=0; i<_Element.length(); i++) {
	ElementWall ewTemp=(ElementWall) _Element[i];
	if (ewTemp.bIsValid()) {
		eWalls.append(ewTemp);
	} 
}

if (eWalls.length()==0)
{
	eraseInstance();
	return;
}

CoordSys wcs(eWalls[0].ptOrg(), _XW, _YW, _ZW);
PlaneProfile ppExternalTemp(wcs);

ElementWall elExternal[0];
Opening opAll[0];

for (int i=0; i<eWalls.length(); i++)
{
	ElementWall el=eWalls[i];
	PLine plOutWall=eWalls[i].plOutlineWall();
	PlaneProfile ppOutEl(plOutWall);
	//ppOutEl.joinRing(plOutWall, FALSE);
	ppOutEl.shrink(-U(15));
	
	String sCode = el.code();
	if( sArrExtCode.find(sCode) != -1 )
	{
		elExternal.append(el);
		ppExternalTemp.unionWith(ppOutEl);
		opAll.append(el.opening());
	}
}

if (elExternal.length()<1)
{
	eraseInstance();
	return;
}

//ppExternalTemp.shrink(U(5));
//ppExternalTemp.vis(1);

PlaneProfile ppExternal(wcs);

PLine plAllRingsExternal[]=ppExternalTemp.allRings();
int nIsOpeningExternal[]=ppExternalTemp.ringIsOpening();

double dArea=0;
double dPerimeter=0;
PLine plArea;

for (int n=0; n<plAllRingsExternal.length(); n++)
{
	PLine pl=plAllRingsExternal[n];
	if ((pl.area()/U(1)*U(1))>dArea)
	{
		plArea=pl;
		dArea=(plArea.area()/U(1)*U(1));
		dPerimeter=plArea.length();
	}
}

PLine plOutlineElements(_ZW);

Point3d arPtAll[] = plArea.vertexPoints(FALSE);

if( arPtAll.length() > 2 )
{
	plOutlineElements.addVertex(arPtAll[0]);
	for (int i=1; i<arPtAll.length()-1; i++)
	{
		//Analyze initial point with last point and next point
		Vector3d v1(arPtAll[i-1] - arPtAll[i]);
		v1.normalize();
		Vector3d v2(arPtAll[i] - arPtAll[i+1]);
		v2.normalize();
	
		if( abs(v1.dotProduct(v2)) <0.99 ) 
		{
			plOutlineElements.addVertex(arPtAll[i]);
		}
	}
}

plOutlineElements.close();

Point3d arPtAllVertex[] = plOutlineElements.vertexPoints(TRUE);

dp.draw(plOutlineElements);


String sOpWindowDesc[0];
int nOpWindowQty[0];
double dOpWindowPer;

String sOpDoorDesc[0];
int nOpDoorQty[0];
double dOpDoorPer;

String sOpOpeningDesc[0];
int nOpOpeningQty[0];
double dOpOpeningPer;

for (int o=0; o<opAll.length();o++)
{
	OpeningSF op=(OpeningSF) opAll[o];
	if (!op.bIsValid()) continue;
	int nOpType=op.openingType();
	String sDesc = op.openingDescr();
	
	double dOpWidth=op.width();
	double dOpHeight=op.height();
	
	if (nOpType==_kWindow)
	{
		int nLoc=sOpWindowDesc.find(sDesc, -1);
		if ( nLoc == -1 )
		{
			sOpWindowDesc.append(sDesc);
			nOpWindowQty.append(1);
		}
		else
		{
			nOpWindowQty[nLoc]++;
		}
		dOpWindowPer+=dOpWidth*2+dOpHeight*2;
	}
	if (nOpType==_kDoor)
	{
		int nLoc=sOpDoorDesc.find(sDesc, -1);
		if ( nLoc == -1 )
		{
			sOpDoorDesc.append(sDesc);
			nOpDoorQty.append(1);
		}
		else
		{
			nOpDoorQty[nLoc]++;
		}
		dOpDoorPer+=dOpWidth+dOpHeight*2;
	}
	if (nOpType==_kOpening)
	{
		int nLoc=sOpOpeningDesc.find(sDesc, -1);
		if ( nLoc == -1 )
		{
			sOpOpeningDesc.append(sDesc);
			nOpOpeningQty.append(1);
		}
		else
		{
			nOpOpeningQty[nLoc]++;
		}
		dOpOpeningPer+=dOpWidth*2+dOpHeight*2;
	}
}

double dExtraPercent=1+(dToleranceCavityCloser/100);

dOpWindowPer=dOpWindowPer*dExtraPercent;
dOpDoorPer=dOpDoorPer*dExtraPercent;
dOpOpeningPer=dOpOpeningPer*dExtraPercent;

dPerimeter=dPerimeter/1000;
dOpWindowPer=dOpWindowPer/1000;
dOpDoorPer=dOpDoorPer/1000;
dOpOpeningPer=dOpOpeningPer/1000;

double dOpPerimeter=dOpWindowPer+dOpDoorPer+dOpOpeningPer;

//dp.draw("Test", _Pt0, _XW, _YW, 0, 0);

String sHandle = _ThisInst.handle();

String sCompareKey = (String) sHandle;
setCompareKey(sCompareKey);

dArea=dArea/1000000;
String sArea=(String) dArea;
String sPerimeter=(String) dPerimeter;

exportToDxi(TRUE);
dxaout("U_AREA", sArea);
dxaout("U_PERIMETER", sPerimeter);
dxaout("U_CORNERS", arPtAllVertex.length());

//Export Floor Sheeting
int nLoc=sSheetingName.find(sSheetType);
String sPartNumber=nSheetingPartNo[nLoc];

dxaout("U_SHEET", sPartNumber);



if (dOpPerimeter)
{
	dxaout("U_OPPERIMETER", dOpPerimeter);
}

if (dOpWindowPer>0)
{
	for (int i=0; i<sOpWindowDesc.length(); i++)
	{
		dxaout("U_OPWINDOWDESC"+i, sOpWindowDesc[i]);
		dxaout("U_OPWINDOWQTY"+i, nOpWindowQty[i]);
	}
	dxaout("U_OPWINDOWPER", dOpWindowPer);
}

if (dOpDoorPer>0)
{
	for (int i=0; i<sOpDoorDesc.length(); i++)
	{
		dxaout("U_OPDOORDESC"+i, sOpDoorDesc[i]);
		dxaout("U_OPDOORQTY"+i, nOpDoorQty[i]);
	}
	dxaout("U_OPDOORPER", dOpDoorPer);
}

if (dOpOpeningPer)
{
	for (int i=0; i<sOpOpeningDesc.length(); i++)
	{
		dxaout("U_OPOPENINGDESC"+i, sOpOpeningDesc[i]);
		dxaout("U_OPOPENINGQTY"+i, nOpOpeningQty[i]);
	}	
	dxaout("U_OPOPENINGPER", dOpOpeningPer);
}


_Pt0=elExternal[0].ptOrg();
assignToElementFloorGroup(elExternal[0], TRUE);





#End
#BeginThumbnail





#End
