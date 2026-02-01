#Version 8
#BeginDescription
v1.3: 03.nov.2013: David Rueda (dr@hsb-cad.com)
Creates a line of blocking on selected wall
PLEASE NOTICE: This tool can be manually inserted, but some instances of it might be inserted by:
- Cloning process
- GE_WALL_RERUN_BLOCKING_LINES tool

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
//////////////////////////////////		COPYRIGHT				//////////////////////////////////  
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2011 by
*  hsbSOFT 
*  UNITED STATES OF AMERICA
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
* v1.3: 03.nov.2013: David Rueda (dr@hsb-cad.com)
	- Stickframe path added to mapIn when calling dll
* v1.2: 11.oct.2013: David Rueda (dr@hsb-cad.com)
	- New blocking now stretch statically to closer left and right beams
* v1.1: 18.jul.2013: David Rueda (dr@hsb-cad.com)
	- Corrected flags for orientation (swapped edge with flat)
	- Renamed "Upright" to "Edge"
	- Added validation to check if TLS is the same instance
	- Cleaned some empty/commented code
	- Added display when wall is unframed
	- Thumbnail updated
* v1.0: 26.mar.2013: David Rueda (dr@hsb-cad.com)
	- Material and grade and treatment are not combined by tsl anymore to generate hsbMaterial and hsbGrade, now values are taken directly from HSB_MATERIAL and HSB_GRADE functions
	- Selection order changed, now user will select wall first then points
	- Avoided write xml map
* v0.9: 11.jul.2012: David Rueda (dr@hsb-cad.com)
	- Description added
	- Thumbnail added
* v0.8: 14.nov.2011: David Rueda (dr@hsb-cad.com)
	- Problem taking empty values and overloading array indexes on lumber item dropdown solved
* v0.7: 02.nov.2011: David Rueda (dr@hsb-cad.com)
	- Insertion will "remember" last props. changed. This changes are saved to GE_WALL_SECTION_BLOCKING_CUSTOM.XML file stored on
	  company\tsl\catalog folder, and will be loaded only if this tsl instance is cloned by GE_CLONE_MVBLOCKS and once only at insertion.
* v0.6: 01.nov.2011: David Rueda (dr@hsb-cad.com): 	
	- Lumber items brought from inventory
	- Blocking props. set from inventory
	- Fixed lumber item erased
	- Setting catalog from props, and load props from catalog (tricky part to recall insertions)
* V0.5_RL_June24_Adapted to be inserted on Wall object and Walls can be split after this TSL is inserted
* Version 0.4 Adapted to be inserted by a master TSL
* Verison 0.3 Check for touching studs
* Verison 0.2 Added OSB blocking
* Version 0.1 Will insert Wall blocking on the flat from point 1 to point 2
*/

Unit(1,"inch");

String sLumberItemKeys[0];
String sLumberItemNames[0];

// Calling dll to fill item lumber prop.
Map mapIn;
Map mapOut;

//Setting info
String sCompanyPath = _kPathHsbCompany;
mapIn.setString("CompanyPath", sCompanyPath);

String sStickFramePath= _kPathHsbWallDetail;
mapIn.setString("StickFramePath", sStickFramePath);

String sInstallationPath			= 	_kPathHsbInstall;
mapIn.setString("InstallationPath", sInstallationPath);

String sAssemblyFolder			=	"\\Utilities\\hsbFramingDefaultsEditor";
String sAssembly					=	"\\hsbFramingDefaults.Inventory.dll";
String sAssemblyPath 			=	sInstallationPath+sAssemblyFolder+sAssembly;
String sNameSpace				=	"hsbSoft.FramingDefaults.Inventory.Interfaces";
String sClass						=	"InventoryAccessInTSL";
String sClassName				=	sNameSpace+"."+sClass;
String sFunction					=	"GetLumberItems";

mapOut = callDotNetFunction2(sAssemblyPath, sClassName, sFunction, mapIn);

//Blocking choice list
String arName[0];
String arMat[0];
String arGrad[0];
double arDy[0];
double arDz[0];

// filling lumber items
for( int m=0; m<mapOut.length(); m++)
{
	String sKey= mapOut.keyAt(m);
	String sName= mapOut.getString(sKey+"\NAME");
	String sMaterial= mapOut.getString(sKey+"\HSB_MATERIAL");
	String sGrade= mapOut.getString(sKey+"\HSB_GRADE");
	double dWidth= mapOut.getDouble(sKey+"\WIDTH");
	double dHeight= mapOut.getDouble(sKey+"\HEIGHT");

	if( sKey!="" && sName!="")
	{
		sLumberItemKeys.append( sKey );
		sLumberItemNames.append( sName);
		arName.append(sName);
		arMat.append(sMaterial);
		arGrad.append(sGrade);
		arDz.append(dWidth);
		arDy.append(dHeight);
	}
}

double dIconSize=U(.75);
double dBaseLnOff=0.25*dIconSize;
double dWallOffset=U(4);

//Set some Properties

int strProp=0,nProp=0,dProp=0;
String arYN[]={"Yes","No"};

//Start Properties
PropString strEmpty0(strProp,"- - - - - - - - - - - - - - - -",T("BLOCK PROPERTIES"));strProp++;
strEmpty0.setReadOnly(true);

PropString strType1(strProp,arName,T("  Blocking 1"),0);strProp++;
PropString strType2(strProp,arName,T("  Blocking 2"),0);strProp++;
PropString strType3(strProp,arName,T("  Blocking 3"),0);strProp++;
PropString strType4(strProp,arName,T("  Blocking 4"),0);strProp++;

PropDouble dMinLgt(dProp,U(3),T("  Minimum block length"));dProp++;

PropString strEmpty1(strProp,"- - - - - - - - - - - - - - - -",T("BLOCK ELEVATION (0 will not place block)"));strProp++;
strEmpty1.setReadOnly(true);
String arOrientation[]={T("Edge"),T("Flat")};

PropDouble dElev1(dProp,U(36),T("  Elevation of block 1"));dProp++;
PropString strOrient1(strProp,arOrientation,T("  Orientation 1"),0);strProp++;

PropDouble dElev2(dProp,U(84),T("  Elevation of block 2"));dProp++;
PropString strOrient2(strProp,arOrientation,T("  Orientation 2"),0);strProp++;

PropDouble dElev3(dProp,U(0),T("  Elevation of block 3"));dProp++;
PropString strOrient3(strProp,arOrientation,T("  Orientation 3"),0);strProp++;

PropDouble dElev4(dProp,U(0),T("  Elevation of block 4"));dProp++;
PropString strOrient4(strProp,arOrientation,T("  Orientation 4"),0);strProp++;

//Start Properties
PropString strEmpty2(strProp,"- - - - - - - - - - - - - - - -",T("DISPLAY"));strProp++;
strEmpty2.setReadOnly(true);

PropString strDim(strProp,_DimStyles,T("  DimStyle"));strProp++;

// bOnInsert
if (_bOnInsert){
	
	if (insertCycleCount()>1) { eraseInstance(); return; }
		
	_Entity.append(getElement( T("Select Wall")));
	_PtG.append(getPoint(T("\nSelect a start Point")));
	Point3d ptLast=_PtG[0];
	PrPoint ssE(T("\nSelect the end Point"),ptLast);
	if (ssE.go()== _kOk)
	{
		ptLast=ssE.value();
		_PtG.append(ptLast);
		//break;
	}
	_Pt0=getPoint(T("Select Side of Wall"));
	showDialog();	
}//END if (_bOnInsert)

String sCatalogPath=	_kPathHsbCompany+"\\Tsl\\Catalog\\";
String sFileName="GE_WALL_SECTION_BLOCKING_CUSTOM_PROPS";

if( _kNameLastChangedProp!=""){
	_Map.setString("strType1",strType1);
	_Map.setString("strType2",strType2);
	_Map.setString("strType3",strType3);
	_Map.setString("strType4",strType4);
//	_Map.writeToXmlFile(sCatalogPath+sFileName);
}

if(_Map.getInt("SET_PROPS_FROM_CATALOG"))
{
	setCatalogFromPropValues("_Default");
	Map map;
	map.readFromXmlFile(sCatalogPath+sFileName);
	if(map.getString("strType1")!="")
		strType1.set(map.getString("strType1"));
	else
		strType1.set(arName[0]);
	if(map.getString("strType2")!="")
		strType2.set(map.getString("strType2"));
	else
		strType2.set(arName[0]);
	if(map.getString("strType3")!="")
		strType3.set(map.getString("strType3"));
	else
		strType3.set(arName[0]);
	if(map.getString("strType4")!="")
		strType4.set(map.getString("strType4"));
	else
		strType4.set(arName[0]);
	_Map.setInt("SET_PROPS_FROM_CATALOG",0);
}

if(_bOnElementDeleted)
{	
	
	//Display
	Display dpDel(-1);
	dpDel.textHeight(dIconSize);
	dpDel.addViewDirection(_ZW);
	
	Vector3d v01(_PtG[0]-_PtG[1]);
	double dV01L=v01.length();
	v01.normalize();
	
	//Center display
	PLine plC;
	plC.createCircle(_Pt0,_ZW,U(.5));
	PLine plC1(_Pt0 + U(.5)*v01,_Pt0 + (U(.5)+dV01L/8)*v01);
	PLine plC2(_Pt0 - U(.5)*v01,_Pt0 - (U(.5)+dV01L/8)*v01);
	
	dpDel.draw(plC);
	dpDel.draw(plC1);	
	dpDel.draw(plC2);	
		
	dpDel.draw("B",_Pt0,_XW,_YW,0,0);
	return;
}
//Wall being split
if( _bOnElementListModified){
//if(1){//_Element.length()>1){

	TslInst tsl;
	String sScriptName = scriptName();
	
	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	Beam lstBeams[0];
	Entity lstEnts[1];
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
		
	//Copy props		
	String propQty[]=_ThisInst.getListOfPropNames();
	for(int prop=0;prop<propQty.length();prop++){
		if(_ThisInst.hasPropInt(propQty[prop]))lstPropInt.append(_ThisInst.propInt(propQty[prop]));
		else if(_ThisInst.hasPropDouble(propQty[prop]))lstPropDouble.append(_ThisInst.propDouble(propQty[prop]));
		else if(_ThisInst.hasPropString(propQty[prop]))lstPropString.append(_ThisInst.propString(propQty[prop]));
	}
	
	lstPoints.append(_Pt0);
	lstPoints.append(_PtG[0]);
	lstPoints.append(_PtG[1]);
	
	for(int i=_Element.length()-1;i>-1;i--){
		ElementWall elW=(ElementWall)_Element[i];
		if(! elW.bIsValid()){
			_Element.removeAt(i);
			continue;
		}

		lstEnts[0] = _Element[i];
		tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString );

	}	
	eraseInstance();
	return;
}

//Security
if(_Entity.length()!=1){
	reportMessage(T("\nMust have 1 entity selected"));
	eraseInstance();
	return;
}
if(_PtG.length()!=2){
	reportMessage(T("\nMust have 2 grip points"));
	eraseInstance();
	return;
}

//Element info
Entity entWall=_Entity[0];
ElementWallSF el=(ElementWallSF)entWall;
Wall w=(Wall)entWall;
Opening arOp[]=el.opening();
TslInst arTslWall[]=el.tslInst();

//autoprops
Map mpAutoProps=entWall.getAutoPropertyMap();

//CoordSys
CoordSys csEl=entWall.coordSys();
Vector3d vx=csEl.vecX();
Vector3d vy=_ZW;
Vector3d vz=vx.crossProduct(vy);

double dElW=U(3.5);
Point3d arPtElEnds[]={w.ptStart(),w.ptEnd()};

if(el.bIsValid()){
	csEl=el.coordSys();
	vx=csEl.vecX();
	vy=csEl.vecY();
	vz=csEl.vecZ();
	dElW=el.dBeamWidth();
	arPtElEnds[0]=el.ptStartOutline();
	arPtElEnds[1]=el.ptEndOutline();
}
else if(mpAutoProps.hasDouble("Width"))dElW=mpAutoProps.getDouble("Width");
vz.vis(_Pt0,3);

///See if TSL is on wall, move grip points or delete
arPtElEnds=Line(csEl.ptOrg(),vx).orderPoints(arPtElEnds);
double dx1=vx.dotProduct(arPtElEnds[0]-_PtG[0]),dx2=vx.dotProduct(arPtElEnds[1]-_PtG[0]),dx3=vx.dotProduct(arPtElEnds[0]-_PtG[1]),dx4=vx.dotProduct(arPtElEnds[1]-_PtG[1]);
if(dx1*dx2 > 0 && dx3*dx4 > 0){
	//completely off the wall
	eraseInstance();
	return;
}
if(dx1*dx2 > 0){
	if(abs(dx1) < abs(dx2))_PtG[0]=arPtElEnds[0];
	else _PtG[0]=arPtElEnds[1];
}
if(dx3*dx4 > 0){
	if(abs(dx3) < abs(dx4))_PtG[1]=arPtElEnds[0];
	else _PtG[1]=arPtElEnds[1];
}

//Create Context menu
String strCreateBlocks=T("Create Blocking");
String strDeleteBlocks=T("Delete Blocking");

addRecalcTrigger( _kContext,strCreateBlocks);
addRecalcTrigger( _kContext,strDeleteBlocks);

//Move points around
Point3d ptSide1,ptSide2,ptBlockRef;
ptSide1=csEl.ptOrg()+dWallOffset*vz;
ptSide2=csEl.ptOrg()-(dWallOffset+dElW)*vz;
String strNewBlkId="412";

Plane pn1(ptSide1,vz),pn2(ptSide2,vz);
vz.normalize();
if(abs(vz.dotProduct(_Pt0-ptSide1)) < abs(vz.dotProduct(_Pt0-ptSide2))){
	_Pt0=_Pt0.projectPoint(pn1,U(0));
	_PtG[0]=_PtG[0].projectPoint(pn1,U(0));
	_PtG[1]=_PtG[1].projectPoint(pn1,U(0));
	ptBlockRef=csEl.ptOrg();
}
else{
	_Pt0=_Pt0.projectPoint(pn2,U(0));
	_PtG[0]=_PtG[0].projectPoint(pn2,U(0));
	_PtG[1]=_PtG[1].projectPoint(pn2,U(0));
	ptBlockRef=csEl.ptOrg()-dElW*vz;
	vz=- vz;
	strNewBlkId="413";
}		

//See if it needs to be joined to another TSL	
//points in range
Point3d arPtRangeJoin[]={_PtG[0],_PtG[1]};
arPtRangeJoin=Line(csEl.ptOrg(),vx).orderPoints(arPtRangeJoin);
arPtRangeJoin[0].transformBy(-vx*U(10));
arPtRangeJoin[1].transformBy(vx*U(10));

String strCompareString=strType1+"-"+	strType2+"-"+strType3+"-"+strType4+"-"+
		int(dElev1*10)+"-"+int(dElev2*10)+"-"+int(dElev3*10)+"-"+int(dElev4*10)+"-"+
		strOrient1+"-"+strOrient2+"-"+strOrient3+"-"+strOrient4+"-"+strNewBlkId;
	
_Map.setString("strCompareStringBacking",strCompareString);	

for(int itsl=arTslWall.length()-1;itsl>-1;itsl--){
	TslInst tsl=arTslWall[itsl];
	//if(tsl== _ThisInst) // David Rueda 18-jul-2013 (Before - #001)
	if( !tsl.bIsValid() || tsl== _ThisInst || tsl.map().length() == 0) // David Rueda 18-jul-2013 (After - #001)
		continue;
	String sTslName= tsl.scriptName();
	Map mpTsl=tsl.map();
	if(mpTsl.hasString("strCompareStringBacking")){
		String strCompareOther=mpTsl.getString("strCompareStringBacking");
		
		if(strCompareOther == strCompareString){
			Point3d arPtTsl[]={tsl.gripPoint(0),tsl.gripPoint(1)};
			int bNeedsToBeJoined=0;
			
			for(int p=0;p<arPtTsl.length();p++)if(vx.dotProduct(arPtTsl[p]-arPtRangeJoin[0]) * vx.dotProduct(arPtTsl[p]-arPtRangeJoin[1]) <0)bNeedsToBeJoined=1;

			if(bNeedsToBeJoined){
				arPtTsl.append(_PtG[0]);
				arPtTsl.append(_PtG[1]);				
				arPtTsl=Line(csEl.ptOrg(),vx).orderPoints(arPtTsl);
				
				_PtG[0]=arPtTsl[0];
				_PtG[1]=arPtTsl[arPtTsl.length()-1];
				tsl.dbErase();
			}
		}
	}
}

//move _Pt0
LineSeg lnSeg(_PtG[0],_PtG[1]);

Plane pnCenter(lnSeg.ptMid(),vx);
_Pt0=_Pt0.projectPoint(pnCenter,U(0));		
	
//Display
Display dp(-1);
dp.textHeight(dIconSize);
dp.addViewDirection(_ZW);
assignToElementGroup(el,TRUE,0,'Z');

Vector3d v01(_PtG[0]-_PtG[1]);
double dV01L=v01.length();
v01.normalize();
	
//Left display
PLine plL(	_PtG[0]-vz*U(1),_PtG[0],_PtG[0]-dV01L/8*v01);
dp.draw(plL);	

//Right display
PLine plR(_PtG[1]-vz*U(1),_PtG[1],_PtG[1]+dV01L/8*v01);
dp.draw(plR);

//Center display
PLine plC;
plC.createCircle(_Pt0,vy,U(.5));
PLine plC1(_Pt0 + U(.5)*v01,_Pt0 + (U(.5)+dV01L/8)*v01);
PLine plC2(_Pt0 - U(.5)*v01,_Pt0 - (U(.5)+dV01L/8)*v01);

dp.draw(plC);
dp.draw(plC1);	
dp.draw(plC2);	
	
dp.draw("B",_Pt0,_XW,_YW,0,0);	

// If not a valid element STOP HERE ////////////////////////////////////////////////////////////////////////
if(!el.bIsValid())return;
	
//Get the list of blocks
Point3d arPtLine[0];
String arBlkNames[0];
String arBlkMat[0];
String arBlkGrad[0];
String arHsbId[0];
double arBlkY[0];
double arBlkZ[0];

if(dElev1>U(0)){
	int nType=arName.find(strType1,0);
	arBlkNames.append(arName[nType]);
	arBlkMat.append(arMat[nType]);
	arBlkGrad.append(arGrad[nType]);
	
	//if(strOrient1==arOrientation[0]){ 		// David Rueda 18-jul-2013 (Before #002)
	if(strOrient1==arOrientation[1]){ 		// David Rueda 18-jul-2013 (After #002)
	
		//arHsbId.append(strNewBlkId); 	// David Rueda 18-jul-2013 (Before #003)
		arHsbId.append("12"); 			// David Rueda 18-jul-2013 (After #003)

		arBlkY.append(arDy[nType]);
		arBlkZ.append(arDz[nType]);
		
		Point3d ptAdd=ptBlockRef - vz*arDz[nType]/2 + dElev1*vy;
		ptAdd=ptAdd.projectPoint(pnCenter,U(0));
		
		arPtLine.append(ptAdd);
	}
	else{
		//arHsbId.append("12"); 			// David Rueda 18-jul-2013 (Before #003)
		arHsbId.append(strNewBlkId); 	// David Rueda 18-jul-2013 (After #003)
		
		arBlkZ.append(arDy[nType]);
		arBlkY.append(arDz[nType]);
		
		Point3d ptAdd=ptBlockRef - vz*arDy[nType]/2 + dElev1*vy;
		ptAdd=ptAdd.projectPoint(pnCenter,U(0));
		
		arPtLine.append(ptAdd);
	}
}
if(dElev2>U(0)){
	int nType=arName.find(strType2,0);
	arBlkNames.append(arName[nType]);
	arBlkMat.append(arMat[nType]);
	arBlkGrad.append(arGrad[nType]);
	
	//if(strOrient2==arOrientation[0]){		// David Rueda 18-jul-2013 (Before #004)
	if(strOrient2==arOrientation[1]){		// David Rueda 18-jul-2013 (After #004)

		//arHsbId.append(strNewBlkId);	// David Rueda 18-jul-2013 (Before #005)
		arHsbId.append("12");				// David Rueda 18-jul-2013 (After #005)

		arBlkY.append(arDy[nType]);
		arBlkZ.append(arDz[nType]);
		
		Point3d ptAdd=ptBlockRef - vz*arDz[nType]/2 + dElev2*vy;
		ptAdd=ptAdd.projectPoint(pnCenter,U(0));

		arPtLine.append(ptAdd);
	}
	else{
		//arHsbId.append("12");			// David Rueda 18-jul-2013 (Before #005)
		arHsbId.append(strNewBlkId);	// David Rueda 18-jul-2013 (After #005)

		
		arBlkZ.append(arDy[nType]);
		arBlkY.append(arDz[nType]);
		
		Point3d ptAdd=ptBlockRef - vz*arDy[nType]/2 + dElev2*vy;
		ptAdd=ptAdd.projectPoint(pnCenter,U(0));
		
		arPtLine.append(ptAdd);
	}
}
if(dElev3>U(0)){
	int nType=arName.find(strType3,0);
	arBlkNames.append(arName[nType]);
	arBlkMat.append(arMat[nType]);
	arBlkGrad.append(arGrad[nType]);
	
	//if(strOrient3==arOrientation[0]){		// David Rueda 18-jul-2013 (Before #006)
	if(strOrient3==arOrientation[1]){		// David Rueda 18-jul-2013 (After #006)

		//arHsbId.append(strNewBlkId);	// David Rueda 18-jul-2013 (Before #007)
		arHsbId.append("12");				// David Rueda 18-jul-2013 (After #007)
		
		arBlkY.append(arDy[nType]);	
		arBlkZ.append(arDz[nType]);
		
		Point3d ptAdd=ptBlockRef - vz*arDz[nType]/2 + dElev3*vy;
		ptAdd=ptAdd.projectPoint(pnCenter,U(0));
		
		arPtLine.append(ptAdd);
	}
	else{
		//arHsbId.append("12");			// David Rueda 18-jul-2013 (Before #007)
		arHsbId.append(strNewBlkId);	// David Rueda 18-jul-2013 (After #007)
		
		arBlkZ.append(arDy[nType]);
		arBlkY.append(arDz[nType]);
		
		Point3d ptAdd=ptBlockRef - vz*arDy[nType]/2 + dElev3*vy;
		ptAdd=ptAdd.projectPoint(pnCenter,U(0));
		
		arPtLine.append(ptAdd);
	}
}	
if(dElev4>U(0)){
	int nType=arName.find(strType4,0);
	arBlkNames.append(arName[nType]);
	arBlkMat.append(arMat[nType]);
	arBlkGrad.append(arGrad[nType]);
	
	//if(strOrient4==arOrientation[0]){		// David Rueda 18-jul-2013 (Before  #008)
	if(strOrient4==arOrientation[1]){		// David Rueda 18-jul-2013 (After #008)
	
		//arHsbId.append(strNewBlkId);	// David Rueda 18-jul-2013 (Before #009)
		arHsbId.append("12");				// David Rueda 18-jul-2013 (After #009)
		
		arBlkY.append(arDy[nType]);
		arBlkZ.append(arDz[nType]);
		
		Point3d ptAdd=ptBlockRef - vz*arDz[nType]/2 + dElev4*vy;
		ptAdd=ptAdd.projectPoint(pnCenter,U(0));
		
		arPtLine.append(ptAdd);
	}
	else{
		//arHsbId.append("12");			// David Rueda 18-jul-2013 (Before #009)
		arHsbId.append(strNewBlkId);	// David Rueda 18-jul-2013 (After #009)
		
		arBlkZ.append(arDy[nType]);
		arBlkY.append(arDz[nType]);
		
		Point3d ptAdd=ptBlockRef - vz*arDy[nType]/2 + dElev4*el.vecY();
		ptAdd=ptAdd.projectPoint(pnCenter,U(0));
		
		arPtLine.append(ptAdd);
	}
}	
	
//Get the beams points of the wall per blocking
Beam arBm[]=el.beam();
Beam arBmH[]=vy.filterBeamsPerpendicular(arBm);
Beam arBmV[]=vx.filterBeamsPerpendicularSort(arBm);
double dBlockAreaLength=abs(vx.dotProduct(_PtG[0]-_PtG[1]));

//Might need to delete beams and clean out map
if(_kExecuteKey==strCreateBlocks || _kExecuteKey==strDeleteBlocks){
	Map mp;
	if(_Map.hasMap("mpBlocks")){
		mp=_Map.getMap("mpBlocks");
			
		int nCount=0;
		while(1){
			if(mp.hasEntity("Bm"+nCount)){
				Entity ent=mp.getEntity("Bm"+nCount);
				ent.dbErase();		
				nCount++;	
			}
			else{
				break;
			}
		}
		reportMessage("\nDeleted " + nCount + " blocks on wall " + el.number());
		_Map.removeAt("mpBlocks",0);
	}
}

if(_bOnElementConstructed || _kExecuteKey==strCreateBlocks || _bOnInsert || _bOnDbCreated ){
	//Map to store blocking
	
	Body arBdStuds[0];
	
	for(int j1 =0; j1<arBmV.length(); j1++){
		Body bd1=arBmV[j1].envelopeBody();
		bd1.transformBy(vx*U(0.125));
		for(int j2 =j1+1; j2<arBmV.length(); j2++){
			Body bd2=arBmV[j2].envelopeBody();
			
			if(bd1.hasIntersection(bd2)){
				bd1+=bd2;
				arBmV.removeAt(j2);
				j2--;
			}
			else{
				break;
			}
		}
		bd1.transformBy(-vx*U(0.125));
		arBdStuds.append(bd1);
	}

	_Map.removeAt("mpBlocks",0);
	Map mpBlocks;
	
	//make a body of Horizontal beams and opes to ignor block
	Body arBdNoGo[0];
	
	for(int h =0;h<arBmH.length();h++)arBdNoGo.append(arBmH[h].envelopeBody());
	for(int p =0;p<arOp.length();p++){
		PLine pl=arOp[p].plShape();
		Body bdOp(pl,el.vecZ()*U(16),0);
		arBdNoGo.append(bdOp);
	}
	
	int nCount=0;
	
	for(int i =0;i<arBlkNames.length();i++){
		
		//show a round body on debug	
		if(_bOnDebug){
			Body bdTemp(arPtLine[i]-vx*dBlockAreaLength/2,arPtLine[i]+vx*dBlockAreaLength/2,arBlkZ[i]/2);
			dp.draw(bdTemp);
		}

		//make a line in center of blocking
		Line lnBlock(arPtLine[i],vx);
		lnBlock.vis();
		//get a list of points where stud intersect lnBlock
		Point3d arPtStuds[0];
		for(int j =0; j<arBdStuds.length(); j++){
			Body bdStud=arBdStuds[j];bdStud.vis(j);
			arPtStuds.append(bdStud.intersectPoints(lnBlock));
		}
		arPtStuds=lnBlock.orderPoints(arPtStuds);
		
		//less then 4 means you only have 1 stud... no good
		if(arPtStuds.length()<4)continue;
		
		//remove first and last point
		arPtStuds.removeAt(0);
		arPtStuds.removeAt(arPtStuds.length()-1);
		
		//start creating blocking
		for(int j =0; j<arPtStuds.length()-1; j+=2){
			Point3d pt1=arPtStuds[j],pt2=arPtStuds[j+1];
			LineSeg lnSegBlk(pt1,pt2);lnSegBlk.vis(4);
			double dBlkL=vx.dotProduct(pt2-pt1);
			
			//if it touches it cannot be inserted
			Body bdBlock(pt1,pt2,arBlkZ[i]/2);
			int bGoodBlock=1;
			for(int b =0;b<arBdNoGo.length();b++){
				if(bdBlock.hasIntersection(arBdNoGo[b])){
					bGoodBlock=0;
					break;
				}
			}
			//does it have interference
			if(!bGoodBlock)continue;
					
			//is it long enough
			if(dBlkL < dMinLgt)continue
			
			//see if the stud cavity needs blocking
			Vector3d vOrder(_PtG[0]-_PtG[1]); vOrder.normalize();
			Point3d ptE1=_PtG[0]+U(3)*vOrder,ptE2=_PtG[1]-U(3)*vOrder;
			if(vx.dotProduct(lnSegBlk.ptMid()-ptE1) * vx.dotProduct(lnSegBlk.ptMid()-ptE2) >0)continue;
			
			if(arBlkY[i]>0&&arBlkZ[i]>0)
			{
				Beam bm;
				bm.dbCreate(lnSegBlk.ptMid(),vx,vy,vz,dBlkL,arBlkY[i],arBlkZ[i]);
				bm.setMaterial(arBlkMat[i]);
				//bm.setName(arBlkNames[i]);
				bm.setGrade(arBlkGrad[i]);
				bm.setType(_kSFBlocking);
				bm.assignToElementGroup(el,TRUE,0,'Z');
				bm.setHsbId(arHsbId[i]);
				bm.setColor(2);
				mpBlocks.appendEntity("Bm"+nCount,bm);
				Beam bmInt[]=Beam().filterBeamsHalfLineIntersectSort(arBm,bm.ptCen(),vx);
				bm.stretchStaticTo(bmInt[0],1);
				bmInt=Beam().filterBeamsHalfLineIntersectSort(arBm,bm.ptCen(),-vx);
				bm.stretchStaticTo(bmInt[0],1);
			}
			nCount++;
		}
	}
	//reportMessage("\nCreated " + nCount + " blocks on wall " + el.number());
	_Map.appendMap("mpBlocks",mpBlocks);
}

#End
#BeginThumbnail
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
F***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`__]FB
`


#End
