#Version 8
#BeginDescription
v1.9: 03.nov.2013: David Rueda (dr@hsb-cad.com)
Creates structural END TO END angled connection between 2 walls. 
Available configurations:
Mitered End with Assembly - Mitered end without assembly - Squared end - Beveled Edge Stud (Stud length) - Beveled Edge Stud (Wall length) - Beveled stud not split - Beveled stud splitted
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 9
#KeyWords 
#BeginContents
/*
*************************************************************************
 COPYRIGHT
 ---------
 Copyright (C) 2010 by
 hsbSOFT
 ECUADOR

 The program may be used and/or copied only with the written
 permission from hsbSOFT, or in accordance with
 the terms and conditions stipulated in the agreement/contract
 under which the program has been supplied.
 All rights reserved.
*************************************************************************
* v1.9: 03.nov.2013: David Rueda (dr@hsb-cad.com)
	- Stickframe path added to mapIn when calling dll
v1.8: 19.mar.2013: David Rueda (dr@hsb-cad.com)
	- Version control
v1.7: 14.ago.2012: David Rueda (dr@hsb-cad.com)
	- Description added
	- Thumbnail updated
v1.6: 20--oct-2011: David Rueda (dr@hsb-cad.com)		- Set right properties from new beams (taken from a stud that does not belong to a component or assembly)
															- Lap VTP's added
															- Switch side to lap VTP's
v1.5: 14-mar-2011: David Rueda (dr@hsb-cad.com)		- User can set custom properties or pre-defined by wall for new beams created by tsl.
v1.4: 21-dic-2010: David Rueda (dr@hsb-cad.com)		- Bugfix on blocking functionality fixed
v1.3: 10-dic-2010: David Rueda (dr@hsb-cad.com)		- Blocking functionality added
v1.2: 08-dic-2010: David Rueda (dr@hsb-cad.com)		- Name changed from GE_WALLS_MITRE_TO_MITRE_ANGLED to GE_WALLS_MITER_TO_MITER_ANGLED
															- Display upgrated
v1.1: 04-dic-2010: David Rueda (dr@hsb-cad.com)		- Prop. indexes updated
v1.0: 02-dic-2010: David Rueda (dr@hsb-cad.com)		- Created
*/

// Fill Lumber Item dropdown
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

// filling lumber items
for( int m=0; m<mapOut.length(); m++)
{
	String sKey= mapOut.keyAt(m);
	String sName= mapOut.getString(sKey+"\NAME");
	if( sKey!="" && sName!="")
	{
		sLumberItemKeys.append( sKey );
		sLumberItemNames.append( sName);
	}
}

// End fill lumber item dropdown

Unit(25,1);
int strProp=0,nProp=0,dProp=0;
String sArNoYes[] = {T("No"), T("Yes")};

String sT[] = {T("|Mitered End with Assembly|"), T("|Mitered end without assembly|"), T("|Squared end|"), T("|Beveled Edge Stud|")+" ("+T("|Stud length|")+")", T("|Beveled Edge Stud|")+" ("+T("|Wall length|")+")", T("|Beveled stud not split|"),T("|Beveled stud splitted|")};
int nMitre[]={1,1,0,0,0,1,1};
PropString sType (strProp, sT, T("|Connection type|"));strProp++;
int nType=sT.find(sType,0);
PropString sLapTopPlates (strProp, sArNoYes, T("|Lap top plates|"), 1);strProp++;
int nLapTopPlates= sArNoYes.find(sLapTopPlates,0);
PropString sSwitchLap (strProp, sArNoYes, T("|Switch lap side|"),0);strProp++;
int nSwitchLap=sArNoYes.find(sSwitchLap,0);
PropDouble dVTPLapLimits(dProp,U(3.175,0.125),"VTP"+T("|Lap limits|"));dProp++;
PropDouble dSheetingLimits(dProp,U(3.175,0.125),T("|Sheeting limits|"));dProp++;
PropString sDummy1(strProp," "," ");strProp++;
PropString sDummy2(strProp,"","- "+T("|All new beams info|"));strProp++;
sDummy1.setReadOnly(1);
sDummy2.setReadOnly(1);
PropString strCustomProps(strProp,sArNoYes,T("|Apply custom properties to new beams|"),0);strProp++;
strCustomProps.setDescription(T("|If YES, beams will have properties set by user in the next lines. If not, beams will get properties from wall settings|"));
int nSetCustomProps=sArNoYes.find(strCustomProps);
PropString sNewBeamsName(strProp,"SYP #2 2x4",T("|Name|"));strProp++;
PropString sNewBeamsMaterial(strProp,"SYP",T("|Material|"));strProp++;
PropString sNewBeamsGrade(strProp,"#2",T("|Grade|"));strProp++;
PropString sNewBeamsInformation(strProp,"STUD",T("|Information|"));strProp++;
PropString sNewBeamsLabel(strProp,"",T("|Label|"));strProp++;
PropString sNewBeamsSublabel(strProp,"",T("|Sublabel|"));strProp++;
PropString sNewBeamsSublabel2(strProp,"",T("|Sublabel2|"));strProp++;
PropString sNewBeamsCode(strProp,";;;;;;;;;;;;;",T("|Beam code|"));strProp++;
PropInt nBmColor(nProp,3,T("|Beam color|"));nProp++;

double dTol=U(0.01,0.0001);

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if(_bOnInsert){
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	if (_kExecuteKey=="")
		showDialogOnce();
	
	PrEntity ssE("\n"+T("|Select 2 angled elements|"),Element());
	
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}

	//ExecutionMode set to Insert
	_Map.setInt("ExecutionMode",0);
			
	return;
}

if( _Element.length()!=2){
	eraseInstance();
	return;
}

//Defining elemets
ElementWall el1 = (ElementWall) _Element[0];
if (!el1.bIsValid())
{
	eraseInstance();
	return;
}
ElementWall el2 = (ElementWall) _Element[1];
if (!el2.bIsValid())
{
	eraseInstance();
	return;
}


assignToElementGroup(el2,0);
assignToElementGroup(el1,0);


//Search if this tsl was previously inserted
String sEl1Code=el1.code()+el1.number();
String sEl2Code=el2.code()+el2.number();
String sConCode1=sEl1Code+sEl2Code;
String sConCode2=sEl2Code+sEl1Code;
TslInst tslAll[]=el1.tslInstAttached();
for (int i=0; i<tslAll.length(); i++)
{
	TslInst tsl=tslAll[i];
	if ( tsl.scriptName() == scriptName() && tsl.handle() != _ThisInst.handle() )
	{
		Map mpThisInst=tsl.map();
		if (mpThisInst.hasString("sConCode"))
		{
			String sExistingCon=mpThisInst.getString("sConCode");
			if (sExistingCon==sConCode1||sExistingCon==sConCode2)
			{
				eraseInstance();
				return;
			}
		}
	}
}

//Check if both walls have connection
int nHasConnection=false;
Element elAllConected[]=el1.getConnectedElements();
for(int e=0;e<elAllConected.length();e++)
{
	Element elTmp=elAllConected[e];																								
	if(elTmp==el2)
	{
		nHasConnection=true;
																																	
	}
}
if(!nHasConnection)
{
	reportMessage("\n"+T("|ERROR: Selected walls are not in contact|"));
	eraseInstance();
	return;
}

//Checking proper angle between walls
if(el1.vecX().isPerpendicularTo(el2.vecX()) ||
el1.vecX().isParallelTo(el2.vecX()))
{
	reportMessage("\n"+T("|ERROR: Walls cannot be perpendicular or parallel|"));
	eraseInstance();
	return;
}

/*Checking this is a mitre to mitre connection; these are the conditions to be accomplished: 
	-	2 points must result when 2 outlines of walls intersect. If it's only one point resulting then is one of this situations: 
			T connection with only one contact point (open angle). User must use "stretch to wall(s) or roof(s)" tool.
			End to end wall connection (open angle). Depending on angle (obtuse or acute) user must select another tsl for 
			angled wall connection 
	- 	BOTH elementset MUST have 2 coincident vertex with the 2 resulting points on intersection of both element's outlines, 
*/

PLine plEl1=el1.plOutlineWall();
PLine plEl2=el2.plOutlineWall();
Point3d ptAllInt[]=plEl1.intersectPLine(plEl2);
if(ptAllInt.length()!=2)
{
	reportMessage("\n"+T("|ERROR: This is not a miter to miter connection, or the connection is not cleaned up. Tsl will be erased|"));
	eraseInstance();
	return;
}

//Check that connection accomplish second condition and define which wall is male and which is female
Point3d ptCon1=ptAllInt[0];
Point3d ptCon2=ptAllInt[1];
int nEl1HasCon1, nEl1HasCon2, nEl2HasCon1, nEl2HasCon2; 
nEl1HasCon1=nEl1HasCon2=nEl2HasCon1=nEl2HasCon2=false;
//Checking cioncident vertex
//Element 1
Point3d ptAllEl1[]=plEl1.vertexPoints(1);
for(int p=0;p<ptAllEl1.length();p++)
{
	if((ptAllEl1[p]-ptCon1).length()<dTol)
	{
			nEl1HasCon1=true;
	}
	if((ptAllEl1[p]-ptCon2).length()<dTol)
	{
			nEl1HasCon2=true;
	}
}

Point3d ptAllEl2[]=plEl2.vertexPoints(1);
for(int p=0;p<ptAllEl2.length();p++)
{
	if((ptAllEl2[p]-ptCon1).length()<dTol)
	{
			nEl2HasCon1=true;
	}
	if((ptAllEl2[p]-ptCon2).length()<dTol)
	{
			nEl2HasCon2=true;
	}
}

int nEl1IsMale,nEl2IsMale;
nEl1IsMale=nEl2IsMale=false;
if(nEl1HasCon1&&nEl1HasCon2)//el1 has 2 coincident vertexes 
{
	nEl1IsMale=true;
}
//if(!nEl1HasCon1&&!nEl1HasCon2&&nEl2HasCon1&&nEl2HasCon2) //el1 has none and el2 has 2 coincident vertexes 
if(nEl2HasCon1&&nEl2HasCon2) //el2 has 2 coincident vertexes 
{
	nEl2IsMale=true;
}

if(!nEl1IsMale||!nEl2IsMale)//At least one of walls has not 2 coincident vertex with connection points
{
		reportMessage("\n"+T("|ERROR: This is not a miter to miter connection, cannot apply this tsl on this type of connection|"));
		eraseInstance();
		return;
}

assignToElementGroup(el1);
assignToElementGroup(el2);

//Getting Info from elements
CoordSys csEl1=el1.coordSys();
Point3d ptEl1Org=csEl1.ptOrg();
Vector3d vx1=csEl1.vecX();
Vector3d vy1=csEl1.vecY();
Vector3d vz1=csEl1.vecZ();
//Getting wall width, ptStart, ptEnd, ptMid from Male wall
PlaneProfile ppEl1(el1.plOutlineWall());
LineSeg lsEl1=ppEl1.extentInDir(vx1);
double dEl1Length=abs(vx1.dotProduct(lsEl1.ptStart()-lsEl1.ptEnd()));
double dEl1Width=el1.dBeamWidth();
Point3d ptEl1Start=csEl1.ptOrg();
Point3d ptEl1End=ptEl1Start+vx1*dEl1Length;
Point3d ptEl1Mid=ptEl1Start+vx1*dEl1Length*.5-vz1*dEl1Width*.5;		

CoordSys csEl2=el2.coordSys();
Point3d ptEl2Org=csEl2.ptOrg();
Vector3d vx2=csEl2.vecX();
Vector3d vy2=csEl2.vecY();
Vector3d vz2=csEl2.vecZ();
//Getting wall width, ptStart, ptEnd, ptMid from Male wall
PlaneProfile ppEl2(el2.plOutlineWall());
LineSeg lsEl2=ppEl2.extentInDir(vx2);
double dEl2Length=abs(vx2.dotProduct(lsEl2.ptStart()-lsEl2.ptEnd()));
double dEl2Width=el2.dBeamWidth();
Point3d ptEl2Start=csEl2.ptOrg();
Point3d ptEl2End=ptEl2Start+vx2*dEl2Length;
Point3d ptEl2Mid=ptEl2Start+vx2*dEl2Length*.5-vz2*dEl2Width*.5;		

//Getting contact points
Plane plnEl2Mid(ptEl2Mid,vz2);
Line lnEl1Mid(ptEl1Mid,vx1);
Point3d ptIntersection=lnEl1Mid.intersect(plnEl2Mid,0);
Point3d ptContactInt;// DO NOT MOVE ptContactInt
Point3d ptContactExt;// DO NOT MOVE ptContactExt
LineSeg lnMids(ptEl1Mid,ptEl2Mid);
Point3d ptInternal=lnMids.ptMid();
Vector3d vOut2In(ptInternal-ptIntersection);//Vector pointing always from outter to innere part of connection (to angle between)
vOut2In.normalize();
if(vOut2In.dotProduct(ptCon1-ptCon2)>0){
	ptContactInt=ptCon1;
	ptContactExt=ptCon2;
}
else
{
	ptContactInt=ptCon2;
	ptContactExt=ptCon1;
}
_Pt0=ptContactInt;ptContactExt.vis();

Vector3d vx1ToConnection=vx1;
if(vx1ToConnection.dotProduct(ptContactInt-ptEl1Mid)<0)
{
	vx1ToConnection=-vx1ToConnection;
}
Vector3d vx2ToConnection=vx2;
if(vx2ToConnection.dotProduct(ptContactInt-ptEl2Mid)<0)
{
	vx2ToConnection=-vx2ToConnection;
}

//This will be useful to define what plates are to be to stretched
double dShrink=U(10,0.4);
Body bdEl1Bigger(ptEl1Mid, vx1, vy1, vz1, dEl1Length+dShrink, U(4000,160), dEl1Width+dShrink, 0, 1, 0);
Body bdEl2Bigger(ptEl2Mid, vx2, vy2, vz2, dEl2Length+dShrink, U(4000,160), dEl2Width+dShrink, 0, 1, 0);

Vector3d vTmp=vx1ToConnection.crossProduct(vy1);
Body bdEl1SearchBlocking(ptContactInt, vx1ToConnection, vy1, vTmp, el1.dBeamHeight()*2+U(1,0.04) , U(4000,160), dEl1Width*2, -1, 1, 0);

vTmp=vx2ToConnection.crossProduct(vy2);
Body bdEl2SearchBlocking(ptContactInt, vx2ToConnection, vy2, vTmp, el2.dBeamHeight()*2+U(1,0.04) , U(4000,160), dEl2Width*2, -1, 1, 0);
//bdEl1SearchBlocking.vis(1);bdEl2SearchBlocking.vis(1);

//Finding top, very top, and bottom plates on el1
Beam bmAllEl1[]=el1.beam();
Beam bmAllEl1Horizontal[0], bmAllEl1Vertical[0], bmAllEl1VTP[0], bmAllEl1TP[0], bmAllEl1Btm[0];
bmAllEl1Horizontal=vx1.filterBeamsParallel(bmAllEl1);
bmAllEl1Vertical=vy1.filterBeamsParallel(bmAllEl1);
Beam bmEl1LowerTP;//Reference to create ladder in necessary case
Point3d ptEl1LowerTPCen=ptEl1Start+vy1*U(10000, 400);//Used to find bmEl1LowerTP
Beam bmAnyEl1BottomPlate;//Reference to create ladder in necessary case
Beam bmAnyEl1Stud;
Beam bmEl1AllBlockingToBeStretched[0];
for(int b=0;b<bmAllEl1Horizontal.length();b++)
{
	Beam bm=bmAllEl1Horizontal[b];	
	if(bm.type()==_kSFTopPlate || bm.type()==_kTopPlate || bm.type()==_kSFBottomPlate)//Bottom, Top and Very Top Plates
	{		
		//Must be closer enough to point to be cut
		if(bm.envelopeBody().intersectWith(bdEl2Bigger))
		{
			//Clasifying, top and very top
			if(bm.beamCode().token(0).makeUpper()=="V")//VTP
			{
				bmAllEl1VTP.append(bm);
			}
			else if(bm.type()==_kSFTopPlate || bm.type()==_kTopPlate)//TP
			{
				bmAllEl1TP.append(bm);
				//Finding lower TopPlate
				if(bm.ptCen().Z()<ptEl1LowerTPCen.Z())
				{
					ptEl1LowerTPCen=bm.ptCen();
					bmEl1LowerTP=bm;
				}
			}
			else if(bm.type()==_kSFBottomPlate)//Bottom Plates
			{
				bmAllEl1Btm.append(bm);
				bmAnyEl1BottomPlate=bm;	
			}
		}
	}
	else if(bm.type()==_kSFBlocking || bm.type()==_kBlocking)//Blocking
	{
		//Must be closer enough to point to be cut
		if(bm.envelopeBody().intersectWith(bdEl1SearchBlocking))
		{
			bmEl1AllBlockingToBeStretched.append(bm);//bm.envelopeBody().vis();
		}
	}
}

// Getting stud CLOSER TO CONNECTION, this way we know we have a stud that is only from element, not from assembly or connection
double dDistance=U(25000,1000);
for(int b=0;b<bmAllEl1Vertical.length();b++)
{
	Beam bm=bmAllEl1Vertical[b];	
	if(bm.type()==_kStud || bm.type()==53 || bm.type()== 52 ) // 52=left stud, 53=right stud
	{
		Point3d ptBmCenterAtFloor=bm.ptCen();
		ptBmCenterAtFloor+=_ZW*_ZW.dotProduct(_Pt0-ptBmCenterAtFloor);
		double dDistanceToPt0=abs((_Pt0-ptBmCenterAtFloor).length());
		if( dDistance>dDistanceToPt0)
		{
			dDistance=dDistanceToPt0;
			bmAnyEl1Stud=bm;
		}
	}
}

//Finding top, very top, and bottom plates on el2
Beam bmAllEl2[]=el2.beam();
Beam bmAllEl2Horizontal[0], bmAllEl2Vertical[0], bmAllEl2VTP[0], bmAllEl2TP[0], bmAllEl2Btm[0];//, bmAllFemaleNonPlates;
bmAllEl2Horizontal=vx2.filterBeamsParallel(bmAllEl2);
bmAllEl2Vertical=vy2.filterBeamsParallel(bmAllEl2);
Beam bmEl2LowerTP;//Reference to create ladder in necessary case
Beam bmAnyEl2BottomPlate;//Reference to create ladder in necessary case
Beam bmAnyEl2Stud;
Point3d ptEl2LowerTPCen=ptEl2Start+vy2*U(10000, 400);//Used to find bmEl2LowerTP
Beam bmEl2AllBlockingToBeStretched[0];
for(int b=0;b<bmAllEl2Horizontal.length();b++)
{
	Beam bm=bmAllEl2Horizontal[b];																									
	if(bm.type()==_kSFTopPlate || bm.type()==_kTopPlate || bm.type()==_kSFBottomPlate)//Bottom, Top and Very Top Plates
	{		
		//Must be closer enough to point to be cut
		if(bm.envelopeBody().intersectWith(bdEl1Bigger))
		{
			//Clasifying, top and very top
			if(bm.beamCode().token(0).makeUpper()=="V")//VTP
			{
				bmAllEl2VTP.append(bm);																							
			}
			else if(bm.type()==_kSFTopPlate || bm.type()==_kTopPlate)//TP
			{
				bmAllEl2TP.append(bm);																							
				//Finding lower TopPlate
				if(bm.ptCen().Z()<ptEl2LowerTPCen.Z())
				{
					ptEl2LowerTPCen=bm.ptCen();
					bmEl2LowerTP=bm;
				}
			}
			else if(bm.type()==_kSFBottomPlate)//Bottom Plates
			{
				bmAllEl2Btm.append(bm);																							
				bmAnyEl2BottomPlate=bm;//Assuming there will be only one level for bottom plates
			}
		}
	}
	else if(bm.type()==_kSFBlocking || bm.type()==_kBlocking)//Blocking
	{
		//Must be closer enough to point to be cut
		if(bm.envelopeBody().intersectWith(bdEl2SearchBlocking))
		{
			bmEl2AllBlockingToBeStretched.append(bm);//bm.envelopeBody().vis();
		}
	}
}

// Getting stud CLOSER TO CONNECTION, this way we know we have a stud that is only from element, not from assembly or connection
dDistance=U(25000,1000);
for(int b=0;b<bmAllEl2Vertical.length();b++)
{
	Beam bm=bmAllEl2Vertical[b];	
	if(bm.type()==_kStud || bm.type()==53 || bm.type()== 52 ) // 52=left stud, 53=right stud
	{
		Point3d ptBmCenterAtFloor=bm.ptCen();
		ptBmCenterAtFloor+=_ZW*_ZW.dotProduct(_Pt0-ptBmCenterAtFloor);
		double dDistanceToPt0=abs((_Pt0-ptBmCenterAtFloor).length());
		if( dDistance>dDistanceToPt0)
		{
			dDistance=dDistanceToPt0;
			bmAnyEl2Stud=bm;
		}
	}
}

//Get all new beams info before erase beam
//On element 1
String sEl1BmName, sEl1BmMaterial, sEl1BmGrade, sEl1BmInformation, sEl1BmLabel, sEl1BmSublabel,sEl1BmSublabel2, sEl1BmCode;
if(nSetCustomProps) // Custom (from OPM)
{
	sEl1BmName=sNewBeamsName;
	sEl1BmMaterial=sNewBeamsMaterial;
	sEl1BmGrade=sNewBeamsGrade;
	sEl1BmInformation=sNewBeamsInformation;
	sEl1BmLabel=sNewBeamsLabel;
	sEl1BmSublabel=sNewBeamsSublabel;
	sEl1BmSublabel2=sNewBeamsSublabel2;
	sEl1BmCode=sNewBeamsCode;
}
else // From any stud on element 1
{
	sEl1BmName=bmAnyEl1Stud.name();
	sEl1BmMaterial=bmAnyEl1Stud.material();
	sEl1BmGrade=bmAnyEl1Stud.grade();
	sEl1BmInformation=bmAnyEl1Stud.information();
	sEl1BmLabel=bmAnyEl1Stud.label();
	sEl1BmSublabel=bmAnyEl1Stud.subLabel();
	sEl1BmSublabel2=bmAnyEl1Stud.subLabel2();
	sEl1BmCode=bmAnyEl1Stud.beamCode();
}
//On element 2
String sEl2BmName, sEl2BmMaterial, sEl2BmGrade, sEl2BmInformation, sEl2BmLabel, sEl2BmSublabel,sEl2BmSublabel2, sEl2BmCode;
if(nSetCustomProps)
{
	sEl2BmName=sNewBeamsName;
	sEl2BmMaterial=sNewBeamsMaterial; 
	sEl2BmGrade=sNewBeamsGrade;
	sEl2BmInformation=sNewBeamsInformation;
	sEl2BmLabel=sNewBeamsLabel;
	sEl2BmSublabel=sNewBeamsSublabel;
	sEl2BmSublabel2=sNewBeamsSublabel2;
	sEl2BmCode=sNewBeamsCode;
}			
else
{
	sEl2BmName=bmAnyEl2Stud.name();
	sEl2BmMaterial=bmAnyEl2Stud.material();
	sEl2BmGrade=bmAnyEl2Stud.grade();
	sEl2BmInformation=bmAnyEl2Stud.information();
	sEl2BmLabel=bmAnyEl2Stud.label();
	sEl2BmSublabel=bmAnyEl2Stud.subLabel();
	sEl2BmSublabel2=bmAnyEl2Stud.subLabel2();
	sEl2BmCode=bmAnyEl2Stud.beamCode();
}

int nExecutionMode;
if( _Map.hasInt("ExecutionMode"))
{
	nExecutionMode = _Map.getInt("ExecutionMode");
}

if(!nExecutionMode || _bOnElementConstructed){

	Beam bmEl1AllBeamsCreated[0];//To apply common props. like grade, material, etc..
	Beam bmEl2AllBeamsCreated[0];//To apply common props. like grade, material, etc..
	Beam bmToStretchOnEl1, bmToStretchOnEl2;
			
	Vector3d vzEl1In2Out=vz1;
	if(vzEl1In2Out.dotProduct(ptContactExt-ptContactInt)<0)
	{
		vzEl1In2Out=-vzEl1In2Out;	//vector normal to el1 always points from inner angle to external angle of connection
	}
	Vector3d vzEl2In2Out=vz2;
	if(vzEl2In2Out.dotProduct(ptContactExt-ptContactInt)<0)
	{
		vzEl2In2Out=-vzEl2In2Out;	//vector normal to el2 always points from inner angle to external angle of connection
	}

	Point3d ptEl1BmTop=bmEl1LowerTP.ptCen()-vy1*bmEl1LowerTP.dD(vy1)*.5;//Higher point to insert beams
	Point3d ptEl1BmBtm=bmAnyEl1BottomPlate.ptCen()+vy1*bmAnyEl1BottomPlate.dD(vy1)*.5;//Lower point to insert beams
	double dBmEl1Length=abs(vy1.dotProduct(ptEl1BmTop-ptEl1BmBtm));//Distance between higher and lower point to insert beams

	Point3d ptEl2BmTop=bmEl2LowerTP.ptCen()-vy2*bmEl2LowerTP.dD(vy2)*.5;//Higher point to insert beams
	Point3d ptEl2BmBtm=bmAnyEl2BottomPlate.ptCen()+vy2*bmAnyEl1BottomPlate.dD(vy2)*.5;//Lower point to insert beams
	double dBmEl2Length=abs(vy2.dotProduct(ptEl2BmTop-ptEl2BmBtm));//Distance between higher and lower point to insert beams
	
	//Create new beam (will be like if beam erased in last step is "moved")
	if(0<=nType&&nType<=4)
	{
		//On Element 1
		Point3d ptEl1NewBm=ptContactInt+vzEl1In2Out*dEl1Width*.5;																			
		ptEl1NewBm+=vy1*vy1.dotProduct(ptEl1BmBtm-ptEl1NewBm);																		
		Vector3d vxBmEl1=vy1;
		Vector3d vyBmEl1=vx1ToConnection;
		Vector3d vzBmEl1=vxBmEl1.crossProduct(vyBmEl1);
		Beam bmEl1NewBm;
		if(dBmEl1Length==0)
		{
			return;	
		}
		bmEl1NewBm.dbCreate(ptEl1NewBm, vxBmEl1, vyBmEl1, vzBmEl1, dBmEl1Length, el1.dBeamHeight(), el1.dBeamWidth(), 1, -1, 0);
		bmEl1AllBeamsCreated.append(bmEl1NewBm);
		bmEl1NewBm.assignToElementGroup(el1,1, 0, 'z');																						
		bmToStretchOnEl1=bmEl1NewBm;

		//On Element 2
		Point3d ptEl2BmTop=bmEl2LowerTP.ptCen()-vy2*bmEl2LowerTP.dD(vy2)*.5;
		Point3d ptEl2BmBtm=bmAnyEl2BottomPlate.ptCen()+vy2*bmAnyEl2BottomPlate.dD(vy2)*.5;
		Point3d ptEl2NewBm=ptContactInt+vzEl2In2Out*dEl2Width*.5;																			
		ptEl2NewBm+=vy2*vy2.dotProduct(ptEl2BmBtm-ptEl2NewBm);																		
		Vector3d vxBmEl2=vy2;
		Vector3d vyBmEl2=vx2ToConnection;
		Vector3d vzBmEl2=vxBmEl2.crossProduct(vyBmEl2);
		double dBmEl2Length=abs(vy2.dotProduct(ptEl2BmTop-ptEl2BmBtm));
		Beam bmEl2NewBm;
		if(dBmEl2Length==0)
		{
			return;	
		}
		bmEl2NewBm.dbCreate(ptEl2NewBm, vxBmEl2, vyBmEl2, vzBmEl2, dBmEl2Length, el2.dBeamHeight(), el2.dBeamWidth(), 1, -1, 0);
		bmEl2AllBeamsCreated.append(bmEl2NewBm);
		bmEl2NewBm.assignToElementGroup(el2,1, 0, 'z');																	
		bmToStretchOnEl2=bmEl2NewBm;
	}

	//Working on plates
	//Define vector and points for cut plates
	Vector3d vMiterCut(ptContactExt-ptContactInt);
	vMiterCut.normalize();
	vMiterCut=vMiterCut.rotateBy(90,vy1);
	Vector3d vCutTopPlatesOnElement1, vCutTopPlatesOnElement2, vCutVeryTopPlatesOnElement1, vCutVeryTopPlatesOnElement2, vCutBottomPlatesOnElement1, vCutBottomPlatesOnElement2;
	Point3d ptCutTopsOnElement1, ptCutTopsOnElement2, ptCutVeryTopsOnElement1, ptCutVeryTopsOnElement2, ptCutBottomsOnElement1, ptCutBottomsOnElement2;
	ptCutTopsOnElement1= ptCutTopsOnElement2 = ptCutVeryTopsOnElement1 = ptCutVeryTopsOnElement2 = ptCutBottomsOnElement1 = ptCutBottomsOnElement2 = ptContactInt;

	// Vectors on element 1
	if(nMitre[nType])//Mitered connection
	{
		if(vMiterCut.dotProduct(vx1ToConnection)<0)
		{
				vMiterCut=-vMiterCut;
		}
		vCutTopPlatesOnElement1=vMiterCut;
		vCutVeryTopPlatesOnElement1=vMiterCut;
		vCutBottomPlatesOnElement1=vMiterCut;
	}
	else//Simple cut on short point
	{
		vCutTopPlatesOnElement1=vx1ToConnection;
		vCutVeryTopPlatesOnElement1=vx1ToConnection;
		vCutBottomPlatesOnElement1=vx1ToConnection;
	}	

	// Vectors on element 2
	if(nMitre[nType])//Mitered connection
	{
		if(vMiterCut.dotProduct(vx2ToConnection)<0)
		{
				vMiterCut=-vMiterCut;
		}
		vCutTopPlatesOnElement2=vMiterCut;
		vCutVeryTopPlatesOnElement2=vMiterCut;
		vCutBottomPlatesOnElement2=vMiterCut;
	}
	else//Simple cut on short point
	{
		vCutTopPlatesOnElement2=vx2ToConnection;
		vCutVeryTopPlatesOnElement2=vx2ToConnection;
		vCutBottomPlatesOnElement2=vx2ToConnection;
	}	

	Vector3d vCommonLineInToOutAngle(ptContactExt-ptContactInt);
	vCommonLineInToOutAngle.normalize();
	Vector3d vzPointingOutCornerOnEl1=vz1;
	if(vCommonLineInToOutAngle.dotProduct(vzPointingOutCornerOnEl1)<0)
		vzPointingOutCornerOnEl1=-vzPointingOutCornerOnEl1;
	Vector3d vzPointingOutCornerOnEl2=vz2;
	if(vCommonLineInToOutAngle.dotProduct(vzPointingOutCornerOnEl2)<0)
		vzPointingOutCornerOnEl2=-vzPointingOutCornerOnEl2;

	if(nLapTopPlates) // Always lap plates (override last process)
	{
		vCutVeryTopPlatesOnElement1=vzPointingOutCornerOnEl2;
		vCutVeryTopPlatesOnElement2=vzPointingOutCornerOnEl1;
		if(nSwitchLap)
		{
			ptCutVeryTopsOnElement1=ptContactInt-vx1ToConnection*dVTPLapLimits;
			ptCutVeryTopsOnElement2=ptContactExt;
		}
		else
		{
			ptCutVeryTopsOnElement1=ptContactExt;
			ptCutVeryTopsOnElement2=ptContactInt-vx2ToConnection*dVTPLapLimits;
		}
	}

	//Cuts for element 1
	Cut ctTopPlatesOnEl1(ptCutTopsOnElement1,vCutTopPlatesOnElement1);
	Cut ctVeryTopPlatesOnEl1(ptCutVeryTopsOnElement1,vCutVeryTopPlatesOnElement1);
	Cut ctBottomPlatesOnEl1(ptCutBottomsOnElement1,vCutBottomPlatesOnElement1);
	//Cuts for element 2
	Cut ctTopPlatesOnEl2(ptCutTopsOnElement2,vCutTopPlatesOnElement2);
	Cut ctVeryTopPlatesOnEl2(ptCutVeryTopsOnElement2,vCutVeryTopPlatesOnElement2);
	Cut ctBottomPlatesOnEl2(ptCutBottomsOnElement2,vCutBottomPlatesOnElement2);

	//Stretching plates and bottoms on element 1
	//TP's
	for(int b=0;b<bmAllEl1TP.length();b++)
	{
		Beam bm=bmAllEl1TP[b];
		bm.addToolStatic(ctTopPlatesOnEl1, 1);
	}
	//VTP's
	for(int b=0;b<bmAllEl1VTP.length();b++)
	{
		Beam bm=bmAllEl1VTP[b];
		bm.addToolStatic(ctVeryTopPlatesOnEl1,2);
	}	
	//Bottoms
	for(int b=0;b<bmAllEl1Btm.length();b++)
	{
		Beam bm=bmAllEl1Btm[b];
		bm.addToolStatic(ctBottomPlatesOnEl1, 1);
	}

	//Stretching plates and bottoms on element 2
	//TP's
	for(int b=0;b<bmAllEl2TP.length();b++)
	{
		Beam bm=bmAllEl2TP[b];
		bm.addToolStatic(ctTopPlatesOnEl2, 1);
	}
	//VTP's
	for(int b=0;b<bmAllEl2VTP.length();b++)
	{
		Beam bm=bmAllEl2VTP[b];
		bm.addToolStatic(ctVeryTopPlatesOnEl2,2);
	}	
	//Bottoms
	for(int b=0;b<bmAllEl2Btm.length();b++)
	{
		Beam bm=bmAllEl2Btm[b];
		bm.addToolStatic(ctBottomPlatesOnEl2, 1);
	}

	// Creating beams on types
	if(nType==0)//Mitre with assembly
	{
		//Create beams
		//On element 1
		Point3d ptEl1NewBm=ptContactExt+vx1ToConnection*vx1ToConnection.dotProduct(ptContactInt-ptContactExt);																
		ptEl1NewBm+=vy1*vy1.dotProduct(ptEl1BmBtm-ptEl1NewBm);																		
		Vector3d vxBmEl1=vy1;
		Vector3d vyBmEl1=vx1ToConnection;
		Vector3d vzBmEl1=vxBmEl1.crossProduct(vyBmEl1);
		int nZIndex;
		if(vzBmEl1.dotProduct(ptContactExt-ptContactInt)<0)
		{
			nZIndex=1;
		}
		else
		{
			nZIndex=-1;
		}
		Beam bmEl1NewBm;
		bmEl1NewBm.dbCreate(ptEl1NewBm, vxBmEl1, vyBmEl1, vzBmEl1, dBmEl1Length, el1.dBeamWidth(), el1.dBeamHeight(), 1, 1, nZIndex);
		if(vMiterCut.dotProduct(vx1ToConnection)<0)
		{
			vMiterCut=-vMiterCut;
		}
		Cut ct1(ptContactInt,vMiterCut);
		bmEl1NewBm.addToolStatic(ct1, 1);
		bmEl1AllBeamsCreated.append(bmEl1NewBm);
		bmEl1NewBm.assignToElementGroup(el1,1, 0, 'z');				
																				
		//On element 2
		Point3d ptEl2NewBm=ptContactExt+vx2ToConnection*vx2ToConnection.dotProduct(ptContactInt-ptContactExt);																
		ptEl2NewBm+=vy2*vy2.dotProduct(ptEl2BmBtm-ptEl2NewBm);																		
		Vector3d vxBmEl2=vy2;
		Vector3d vyBmEl2=vx2ToConnection;
		Vector3d vzBmEl2=vxBmEl2.crossProduct(vyBmEl2);
		if(vzBmEl2.dotProduct(ptContactExt-ptContactInt)<0)
		{
			nZIndex=1;
		}
		else
		{
			nZIndex=-1;
		}
		Beam bmEl2NewBm;
		bmEl2NewBm.dbCreate(ptEl2NewBm, vxBmEl2, vyBmEl2, vzBmEl2, dBmEl2Length, el2.dBeamWidth(), el2.dBeamHeight(), 1, 1, nZIndex);
		if(vMiterCut.dotProduct(vx2ToConnection)<0)
		{
			vMiterCut=-vMiterCut;
		}
		Cut ct2(ptContactInt,vMiterCut);
		bmEl2NewBm.addToolStatic(ct2, 1);
		bmEl2AllBeamsCreated.append(bmEl2NewBm);
		bmEl2NewBm.assignToElementGroup(el2,1, 0, 'z');			
	
	}
	
	//Beveled edge studs
	if(nType==3 || nType==4)
	{
		//On element 1
		Point3d ptEl1NewBeamTop, ptEl1NewBeamBtm,ptEl1NewBeam;
		if(nType==3)//Stud length
		{
			ptEl1NewBeamTop=bmEl1LowerTP.ptCen()-vy1*bmEl1LowerTP.dD(vy1)*.5;
			ptEl1NewBeamBtm=bmAnyEl1BottomPlate.ptCen()+vy1*bmAnyEl1BottomPlate.dD(vy1)*.5;
		}
		else
		{
			ptEl1NewBeamTop=bmEl1LowerTP.ptCen()+vy1*bmEl1LowerTP.dD(vy1)*.5;
			ptEl1NewBeamBtm=bmAnyEl1BottomPlate.ptCen()-vy1*bmAnyEl1BottomPlate.dD(vy1)*.5;
		}
		ptEl1NewBeam=ptContactInt;
		ptEl1NewBeam+=vy1*vy1.dotProduct(ptEl1NewBeamBtm-ptEl1NewBeam);
		
		double dEl1NewBmLength=abs(vy1.dotProduct(ptEl1NewBeamTop-ptEl1NewBeamBtm));
		double dEl1NewBmWidht=abs(vx1.dotProduct(ptContactExt-ptContactInt));
		double dEl1NewBmHeight=el1.dBeamWidth();
		if(dEl1NewBmLength<=0.001 || dEl1NewBmWidht<=0.001 || dEl1NewBmHeight<=0.001)//Won't be able to body generation				
			return;
		Vector3d vxEl1Bm=vy1;
		Vector3d vyEl1Bm=vx1ToConnection;
		Vector3d vzEl1Bm=vxEl1Bm.crossProduct(vyEl1Bm);
		int nZIndex;
		if(vzEl1Bm.dotProduct(ptContactExt-ptContactInt)<0)
		{
			nZIndex=-1;
		}
		else
		{
			nZIndex=1;
		}
		Beam bmEl1CavityFiller;
		bmEl1CavityFiller.dbCreate(ptEl1NewBeam, vxEl1Bm, vyEl1Bm, vzEl1Bm, dEl1NewBmLength, dEl1NewBmWidht, dEl1NewBmHeight, 1, 1, nZIndex);
		//Add cut
		if(vMiterCut.dotProduct(vx1ToConnection)<0)
		{
			vMiterCut=-vMiterCut;			
		}		
		Cut ctEl1NewBeam(ptContactInt,vMiterCut);
		bmEl1CavityFiller.addToolStatic(ctEl1NewBeam);
		bmEl1AllBeamsCreated.append(bmEl1CavityFiller);
		bmEl1CavityFiller.assignToElementGroup(el1,1, 0, 'z'); 

		//On element 2
		Point3d ptEl2NewBeamTop, ptEl2NewBeamBtm,ptEl2NewBeam;
		if(nType==3)//Stud length
		{
			ptEl2NewBeamTop=bmEl2LowerTP.ptCen()-vy2*bmEl2LowerTP.dD(vy2)*.5;
			ptEl2NewBeamBtm=bmAnyEl2BottomPlate.ptCen()+vy2*bmAnyEl1BottomPlate.dD(vy2)*.5;
		}
		else
		{
			ptEl2NewBeamTop=bmEl2LowerTP.ptCen()+vy2*bmEl2LowerTP.dD(vy2)*.5;
			ptEl2NewBeamBtm=bmAnyEl2BottomPlate.ptCen()-vy2*bmAnyEl2BottomPlate.dD(vy2)*.5;
		}
		ptEl2NewBeam=ptContactInt;
		ptEl2NewBeam+=vy2*vy2.dotProduct(ptEl2NewBeamBtm-ptEl2NewBeam);
		
		double dEl2NewBmLength=abs(vy2.dotProduct(ptEl2NewBeamTop-ptEl2NewBeamBtm));
		double dEl2NewBmWidht=abs(vx2.dotProduct(ptContactExt-ptContactInt));
		double dEl2NewBmHeight=el2.dBeamWidth();
		if(dEl2NewBmLength<=0.001 || dEl2NewBmWidht<=0.001 || dEl2NewBmHeight<=0.001)//Won't be able to body generation				
			return;
		Vector3d vxEl2Bm=vy2;
		Vector3d vyEl2Bm=vx2ToConnection;
		Vector3d vzEl2Bm=vxEl2Bm.crossProduct(vyEl2Bm);
		if(vzEl2Bm.dotProduct(ptContactExt-ptContactInt)<0)
		{
			nZIndex=-1;
		}
		else
		{
			nZIndex=1;
		}
		Beam bmEl2CavityFiller;
		bmEl2CavityFiller.dbCreate(ptEl2NewBeam, vxEl2Bm, vyEl2Bm, vzEl2Bm, dEl2NewBmLength, dEl2NewBmWidht, dEl2NewBmHeight, 1, 1, nZIndex);
		//Add cut
		if(vMiterCut.dotProduct(vx2ToConnection)<0)
		{
			vMiterCut=-vMiterCut;			
		}		
		Cut ctEl2NewBeam(ptContactInt,vMiterCut);
		bmEl2CavityFiller.addToolStatic(ctEl2NewBeam);
		bmEl2AllBeamsCreated.append(bmEl2CavityFiller);
		bmEl2CavityFiller.assignToElementGroup(el2,1, 0, 'z'); 

	}
	
	//Beveled studs not split
	Body bdToCleanOnBeveledStudsType;
	if(nType==5)
	{
		//On element 1
		Point3d ptEl1NewBeamTop, ptEl1NewBeamBtm,ptEl1NewBeam;
		ptEl1NewBeamTop=bmEl1LowerTP.ptCen()-vy1*bmEl1LowerTP.dD(vy1)*.5;
		ptEl1NewBeamBtm=bmAnyEl1BottomPlate.ptCen()+vy1*bmAnyEl1BottomPlate.dD(vy1)*.5;
		ptEl1NewBeam=ptContactInt;
		ptEl1NewBeam+=vy1*vy1.dotProduct(ptEl1NewBeamBtm-ptEl1NewBeam);
		
		double dEl1NewBmLength=abs(vy1.dotProduct(ptEl1NewBeamTop-ptEl1NewBeamBtm));
		double dEl1NewBmWidht=el1.dBeamHeight();
		double dEl1NewBmHeight=el1.dBeamWidth()*3;
		if(dEl1NewBmLength<=0.001 || dEl1NewBmWidht<=0.001 || dEl1NewBmHeight<=0.001)//Won't be able to body generation				
			return;
		Vector3d vxEl1Bm=vy1;
		Vector3d vyEl1Bm=ptContactExt-ptContactInt;vyEl1Bm.normalize();
		Vector3d vzEl1Bm=vxEl1Bm.crossProduct(vyEl1Bm);
		int nZIndex;
		if(vzEl1Bm.dotProduct(vx1ToConnection)<0)
		{
			nZIndex=1;
		}
		else
		{
			nZIndex=-1;
		}
		Beam bmEl1BeveledStud;
		bmEl1BeveledStud.dbCreate(ptEl1NewBeam, vxEl1Bm, vyEl1Bm, vzEl1Bm, dEl1NewBmLength, dEl1NewBmHeight, dEl1NewBmWidht, 1, 0, nZIndex);
		//Add cut
		Cut ctEl1NewBeamInt(ptContactInt,-vzEl1In2Out);
		bmEl1BeveledStud.addToolStatic(ctEl1NewBeamInt);
		Cut ctEl1NewBeamExt(ptContactExt,vzEl1In2Out);
		bmEl1BeveledStud.addToolStatic(ctEl1NewBeamExt);
		bmEl1AllBeamsCreated.append(bmEl1BeveledStud);
		bmEl1BeveledStud.assignToElementGroup(el1,1, 0, 'z'); 
		bmToStretchOnEl1=bmEl1BeveledStud;
		bdToCleanOnBeveledStudsType+=bmEl1BeveledStud.realBody();
		
		//On element 2
		Point3d ptEl2NewBeamTop, ptEl2NewBeamBtm,ptEl2NewBeam;
		ptEl2NewBeamTop=bmEl2LowerTP.ptCen()-vy2*bmEl1LowerTP.dD(vy2)*.5;
		ptEl2NewBeamBtm=bmAnyEl2BottomPlate.ptCen()+vy2*bmAnyEl2BottomPlate.dD(vy2)*.5;
		ptEl2NewBeam=ptContactInt;
		ptEl2NewBeam+=vy2*vy2.dotProduct(ptEl2NewBeamBtm-ptEl2NewBeam);
		
		double dEl2NewBmLength=abs(vy2.dotProduct(ptEl2NewBeamTop-ptEl2NewBeamBtm));
		double dEl2NewBmWidht=el2.dBeamHeight();
		double dEl2NewBmHeight=el2.dBeamWidth()*3;
		if(dEl2NewBmLength<=0.001 || dEl2NewBmWidht<=0.001 || dEl2NewBmHeight<=0.001)//Won't be able to body generation				
			return;
		Vector3d vxEl2Bm=vy2;
		Vector3d vyEl2Bm=ptContactExt-ptContactInt;vyEl2Bm.normalize();
		Vector3d vzEl2Bm=vxEl2Bm.crossProduct(vyEl2Bm);
		if(vzEl2Bm.dotProduct(vx2ToConnection)<0)
		{
			nZIndex=1;
		}
		else
		{
			nZIndex=-1;
		}
		Beam bmEl2BeveledStud;
		bmEl2BeveledStud.dbCreate(ptEl2NewBeam, vxEl2Bm, vyEl2Bm, vzEl2Bm, dEl2NewBmLength, dEl2NewBmHeight, dEl2NewBmWidht, 1, 0, nZIndex);
		//Add cut
		Cut ctEl2NewBeamInt(ptContactInt,-vzEl2In2Out);
		bmEl2BeveledStud.addToolStatic(ctEl2NewBeamInt);
		Cut ctEl2NewBeamExt(ptContactExt,vzEl2In2Out);
		bmEl2BeveledStud.addToolStatic(ctEl2NewBeamExt);
		bmEl2AllBeamsCreated.append(bmEl2BeveledStud);
		bmEl2BeveledStud.assignToElementGroup(el2,1, 0, 'z'); 
		bmToStretchOnEl2=bmEl2BeveledStud;
		bdToCleanOnBeveledStudsType+=bmEl2BeveledStud.realBody();
	}

	//Beveled studs splitted
	if(nType==6)
	{
		//Set split distance
		double dMitredEndsDistance=(ptContactExt-ptContactInt).length();
		double dDistanceToSplit=dMitredEndsDistance/3;
		//On element 1
		//Beam piece on ptContactInt
		Point3d ptEl1NewBeamTop, ptEl1NewBeamBtm,ptEl1NewBeam;
		ptEl1NewBeamTop=bmEl1LowerTP.ptCen()-vy1*bmEl1LowerTP.dD(vy1)*.5;
		ptEl1NewBeamBtm=bmAnyEl1BottomPlate.ptCen()+vy1*bmAnyEl1BottomPlate.dD(vy1)*.5;
		ptEl1NewBeam=ptContactInt;
		ptEl1NewBeam+=vy1*vy1.dotProduct(ptEl1NewBeamBtm-ptEl1NewBeam);
		
		double dEl1NewBmLength=abs(vy1.dotProduct(ptEl1NewBeamTop-ptEl1NewBeamBtm));
		double dEl1NewBmWidht=el1.dBeamHeight();
		double dEl1NewBmHeight=el1.dBeamWidth();
		if(dEl1NewBmLength<=0.001 || dEl1NewBmWidht<=0.001 || dEl1NewBmHeight<=0.001)//Won't be able to body generation				
			return;
		Vector3d vxEl1Bm=vy1;
		Vector3d vyEl1Bm=ptContactExt-ptContactInt;vyEl1Bm.normalize();
		Vector3d vzEl1Bm=vxEl1Bm.crossProduct(vyEl1Bm);
		int nZIndex;
		if(vzEl1Bm.dotProduct(vx1ToConnection)<0)
		{
			nZIndex=1;
		}
		else
		{
			nZIndex=-1;
		}
		Beam bmEl1BeveledStud1;
		bmEl1BeveledStud1.dbCreate(ptEl1NewBeam, vxEl1Bm, vyEl1Bm, vzEl1Bm, dEl1NewBmLength, dEl1NewBmHeight, dEl1NewBmWidht, 1, 0, nZIndex);
		//Add cuts
		//On ptContactInt
		Cut ctEl1NewBeam1ptContactInt(ptContactInt,-vzEl1In2Out);
		bmEl1BeveledStud1.addToolStatic(ctEl1NewBeam1ptContactInt);
		//Inside el1
		Vector3d vFromContactIntToContactExt (ptContactExt-ptContactInt);
		vFromContactIntToContactExt.normalize();
		Point3d ptInnerCutBeamSutd1=ptContactInt+vFromContactIntToContactExt*(dMitredEndsDistance-dDistanceToSplit)*.5;
		Cut ctEl1NewBeam1(ptInnerCutBeamSutd1,vFromContactIntToContactExt );
		bmEl1BeveledStud1.addToolStatic(ctEl1NewBeam1);
		bmEl1AllBeamsCreated.append(bmEl1BeveledStud1);
		bmEl1BeveledStud1.assignToElementGroup(el1,1, 0, 'z'); 
		bmToStretchOnEl1=bmEl1BeveledStud1;
		bdToCleanOnBeveledStudsType+=bmEl1BeveledStud1.realBody();

		//Beam piece on ptContactExt
		Beam bmEl1BeveledStud2;
		ptEl1NewBeam=ptContactExt;
		ptEl1NewBeam+=vy1*vy1.dotProduct(ptEl1NewBeamBtm-ptEl1NewBeam);
		bmEl1BeveledStud2.dbCreate(ptEl1NewBeam, vxEl1Bm, vyEl1Bm, vzEl1Bm, dEl1NewBmLength, dEl1NewBmHeight, dEl1NewBmWidht, 1, 0, nZIndex);
		//Add cuts
		//On ptContactExt
		Cut ctEl1NewBeam2ptContactExt(ptContactExt,vzEl1In2Out);
		bmEl1BeveledStud2.addToolStatic(ctEl1NewBeam2ptContactExt);
		//Inside el1
		Point3d ptInnerCutBeamSutd2=ptContactExt-vFromContactIntToContactExt*(dMitredEndsDistance-dDistanceToSplit)*.5;
		Cut ctEl1NewBeam2(ptInnerCutBeamSutd2,-vFromContactIntToContactExt );
		bmEl1BeveledStud2.addToolStatic(ctEl1NewBeam2);
		bmEl1AllBeamsCreated.append(bmEl1BeveledStud2);
		bmEl1BeveledStud2.assignToElementGroup(el1,1, 0, 'z'); 
		bdToCleanOnBeveledStudsType+=bmEl1BeveledStud2.realBody();

		//On element 2
		Point3d ptEl2NewBeamTop, ptEl2NewBeamBtm,ptEl2NewBeam;
		ptEl2NewBeamTop=bmEl2LowerTP.ptCen()-vy2*bmEl1LowerTP.dD(vy2)*.5;
		ptEl2NewBeamBtm=bmAnyEl2BottomPlate.ptCen()+vy2*bmAnyEl2BottomPlate.dD(vy2)*.5;
		ptEl2NewBeam=ptContactInt;
		ptEl2NewBeam+=vy2*vy2.dotProduct(ptEl2NewBeamBtm-ptEl2NewBeam);
		
		double dEl2NewBmLength=abs(vy2.dotProduct(ptEl2NewBeamTop-ptEl2NewBeamBtm));
		double dEl2NewBmWidht=el2.dBeamHeight();
		double dEl2NewBmHeight=el2.dBeamWidth();
		if(dEl2NewBmLength<=0.001 || dEl2NewBmWidht<=0.001 || dEl2NewBmHeight<=0.001)//Won't be able to body generation				
			return;
		Vector3d vxEl2Bm=vy2;
		Vector3d vyEl2Bm=ptContactExt-ptContactInt;vyEl2Bm.normalize();
		Vector3d vzEl2Bm=vxEl2Bm.crossProduct(vyEl2Bm);
		if(vzEl2Bm.dotProduct(vx2ToConnection)<0)
		{
			nZIndex=1;
		}
		else
		{
			nZIndex=-1;
		}
		Beam bmEl2BeveledStud1;
		bmEl2BeveledStud1.dbCreate(ptEl2NewBeam, vxEl2Bm, vyEl2Bm, vzEl2Bm, dEl2NewBmLength, dEl2NewBmHeight, dEl2NewBmWidht, 1, 0, nZIndex);
		//Add cuts
		//On ptContactInt
		Cut ctEl2NewBeam1ptContactInt(ptContactInt,-vzEl2In2Out);
		bmEl2BeveledStud1.addToolStatic(ctEl2NewBeam1ptContactInt);
		//Inside el2
		bmEl2BeveledStud1.addToolStatic(ctEl1NewBeam1);
		bmEl2AllBeamsCreated.append(bmEl2BeveledStud1);
		bmEl2BeveledStud1.assignToElementGroup(el2,1, 0, 'z'); 
		bmToStretchOnEl2=bmEl2BeveledStud1;
		bdToCleanOnBeveledStudsType+=bmEl2BeveledStud1.realBody();

		//Beam piece on ptContactExt
		Beam bmEl2BeveledStud2;
		ptEl2NewBeam=ptContactExt;
		ptEl2NewBeam+=vy2*vy2.dotProduct(ptEl2NewBeamBtm-ptEl2NewBeam);
		bmEl2BeveledStud2.dbCreate(ptEl2NewBeam, vxEl2Bm, vyEl2Bm, vzEl2Bm, dEl2NewBmLength, dEl2NewBmHeight, dEl2NewBmWidht, 1, 0, nZIndex);
		//Add cuts
		//On ptContactExt
		Cut ctEl2NewBeam2ptContactExt(ptContactExt,vzEl2In2Out);
		bmEl2BeveledStud2.addToolStatic(ctEl2NewBeam2ptContactExt);
		//Inside el2
		bmEl2BeveledStud2.addToolStatic(ctEl1NewBeam2);
		bmEl2AllBeamsCreated.append(bmEl2BeveledStud2);
		bmEl2BeveledStud2.assignToElementGroup(el2,1, 0, 'z'); 
		bdToCleanOnBeveledStudsType+=bmEl2BeveledStud2.realBody();

	}

	//Work with blocking
	//On element 1
	if(bmToStretchOnEl1.bIsValid())
	{
		for(int b=0;b<bmEl1AllBlockingToBeStretched.length();b++)
		{
			if(nType<5)
			{
				bmEl1AllBlockingToBeStretched[b].stretchDynamicTo(bmToStretchOnEl1);
				//bmEl1AllBlockingToBeStretched[b].envelopeBody().vis();
			}
			else
			{
				bmEl1AllBlockingToBeStretched[b].dbErase();				
			}			
		}
	}
	//On element 2
	if(bmToStretchOnEl2.bIsValid())
	{
		for(int b=0;b<bmEl2AllBlockingToBeStretched.length();b++)
		{
			if(nType<5)
			{
				bmEl2AllBlockingToBeStretched[b].stretchDynamicTo(bmToStretchOnEl2);
				//bmEl2AllBlockingToBeStretched[b].envelopeBody().vis();
			}
			else
			{
				bmEl2AllBlockingToBeStretched[b].dbErase();				
			}	
			
		}
	}	
	
	//Clean area 
	//Define area to clean base on connection type
	Body bdToCleanEl1, bdToCleanEl2;
	if(nType<5)
	{
		//On element 1
		//Defining parameters for clean area
		Vector3d vxCleanEl1,vyCleanEl1,vzCleanEl1;
		vxCleanEl1=vx1;
		if((ptContactExt-ptContactInt).dotProduct(vxCleanEl1)<0)//Need vx from element 1 but always pointing to connection
		{
			vxCleanEl1=-vxCleanEl1;
		}
		vyCleanEl1=vy1;
		vzCleanEl1=vxCleanEl1.crossProduct(vyCleanEl1);
		double dCleanLenght, dCleanWidth, dCleanHeight;
		Point3d ptEl1CleanTop=bmEl1LowerTP.ptCen()-vy1*bmEl1LowerTP.dD(vy1)*.5;
		Point3d ptEl1CleanBtm=bmAnyEl1BottomPlate.ptCen()+vy1*bmAnyEl1BottomPlate.dD(vy1)*.5;
		dCleanLenght=abs(vx1.dotProduct(ptContactInt-ptContactExt))+el1.dBeamHeight();
		dCleanHeight=abs(vyCleanEl1.dotProduct(ptEl1CleanTop-ptEl1CleanBtm));
		dCleanWidth=abs(vz1.dotProduct(ptContactExt-ptContactInt));
		Point3d ptEl1CleanCenter=ptContactExt-vzEl1In2Out*dCleanWidth*.5;
		ptEl1CleanCenter+=vy1*(vy1.dotProduct(bmAnyEl1BottomPlate.ptCen()-ptEl1CleanCenter)+bmAnyEl1BottomPlate.dD(vy1)*.5);
		if(dCleanLenght==0 || dCleanWidth==0 || dCleanHeight==0)//Won't be able to generate body
		{
			return;	
		}
		Body bdEl1Clean(ptEl1CleanCenter, vxCleanEl1, vyCleanEl1, vzCleanEl1, dCleanLenght, dCleanHeight, dCleanWidth, -1, 1, 0);	
		bdToCleanEl1=bdEl1Clean;
		
		//Clean area on element 2
		//Defining parameters for clean area
		Vector3d vxCleanEl2,vyCleanEl2,vzCleanEl2;
		vxCleanEl2=vx2;
		if((ptContactExt-ptContactInt).dotProduct(vxCleanEl2)<0)//Need vx from element 2 but always pointing to connection
		{
			vxCleanEl2=-vxCleanEl2;
		}
		vyCleanEl2=vy2;
		vzCleanEl2=vxCleanEl2.crossProduct(vyCleanEl2);
		Point3d ptEl2CleanTop=bmEl2LowerTP.ptCen()-vy2*bmEl2LowerTP.dD(vy2)*.5;
		Point3d ptEl2CleanBtm=bmAnyEl2BottomPlate.ptCen()+vy2*bmAnyEl2BottomPlate.dD(vy2)*.5;
		dCleanLenght=abs(vx2.dotProduct(ptContactInt-ptContactExt))+el2.dBeamHeight();
		dCleanHeight=abs(vyCleanEl2.dotProduct(ptEl2CleanTop-ptEl2CleanBtm));
		dCleanWidth=abs(vz2.dotProduct(ptContactExt-ptContactInt));
		Point3d ptEl2CleanCenter=ptContactExt-vzEl2In2Out*dCleanWidth*.5;
		ptEl2CleanCenter+=vy2*(vy2.dotProduct(bmAnyEl2BottomPlate.ptCen()-ptEl2CleanCenter)+bmAnyEl2BottomPlate.dD(vy2)*.5);
		if(dCleanLenght==0 || dCleanWidth==0 || dCleanHeight==0)//Won't be able to generate body
		{
			return;	
		}
		Body bdEl2Clean(ptEl2CleanCenter, vxCleanEl2, vyCleanEl2, vzCleanEl2, dCleanLenght, dCleanHeight, dCleanWidth, -1, 1, 0);
		bdToCleanEl2=bdEl2Clean;
	}
	else
	{
		bdToCleanEl1=bdToCleanOnBeveledStudsType;
		bdToCleanEl2=bdToCleanOnBeveledStudsType;
	}				
	//bdToCleanEl1.vis(1);
	//bdToCleanEl2.vis(1);
	//ON ELEMENT 1
	//Cleaning interfering studs
	for(int b=0;b<bmAllEl1Vertical.length();b++){
		Beam bm=bmAllEl1Vertical[b];
		Body bdBm=bm.envelopeBody();
		if(bdBm.intersectWith(bdToCleanEl1))
		{
			bm.dbErase();
		}
	}
	
	//bdToCleanEl1.vis(2);
	//bdToCleanEl2.vis(2);
	//Cleaning interfering blockings
	for(int b=0;b<bmEl1AllBlockingToBeStretched.length();b++){
		Beam bm=bmEl1AllBlockingToBeStretched[b];
		Body bdBm=bm.realBody();
		if(bdBm.intersectWith(bdToCleanEl1))
		{
			bm.dbErase();
		}
	}

	//ON ELEMENT 2
	//Cleaning interfering studs
	for(int b=0;b<bmAllEl2Vertical.length();b++){
		Beam bm=bmAllEl2Vertical[b];
		Body bdBm=bm.envelopeBody();
		if(bdBm.intersectWith(bdToCleanEl2))
		{
			bm.dbErase();
		}
	}
	//Cleaning interfering blockings
	for(int b=0;b<bmEl2AllBlockingToBeStretched.length();b++){
		Beam bm=bmEl2AllBlockingToBeStretched[b];
		Body bdBm=bm.realBody();
		if(bdBm.intersectWith(bdToCleanEl2))
		{
			//bdBm.vis(4);
			bm.dbErase();
		}
	}

	//Asigning common properties to created beams
	for(int b=0;b<bmEl1AllBeamsCreated.length();b++)
	{
		Beam bm=bmEl1AllBeamsCreated[b];		
		bm.setColor(nBmColor);		
		bm.setName(sEl1BmName);
		bm.setMaterial(sEl1BmMaterial);
		bm.setGrade(sEl1BmGrade);
		bm.setInformation(sEl1BmInformation);
		bm.setLabel(sEl1BmLabel);
		bm.setSubLabel(sEl1BmSublabel);
		bm.setSubLabel2(sEl1BmSublabel2);
		bm.setBeamCode(sEl1BmCode);
		_Beam.append(bm);
	}


	for(int b=0;b<bmEl2AllBeamsCreated.length();b++)
	{
		Beam bm=bmEl2AllBeamsCreated[b];
		bm.setColor(nBmColor);		
		bm.setName(sEl2BmName);
		bm.setMaterial(sEl2BmMaterial);
		bm.setGrade(sEl2BmGrade);
		bm.setInformation(sEl2BmInformation);
		bm.setLabel(sEl2BmLabel);
		bm.setSubLabel(sEl2BmSublabel);
		bm.setSubLabel2(sEl2BmSublabel2);
		bm.setBeamCode(sEl2BmCode);
		_Beam.append(bm);
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////// SHEETING WORK //////////////////////////////////////////////////////////////////////////////////////////////// 
	//Find middle line in ptContactInt
	Vector3d vInternalMidLine(ptContactInt-ptContactExt);																					
	//Cut sheetings ends where needed
	//On el1
	Sheet shAllEl1[]=el1.sheet();
	for(int s=0;s<shAllEl1.length();s++)
	{
		Sheet sh=shAllEl1[s];
		Body bdSh=sh.envelopeBody();
		Vector3d vOff=	vInternalMidLine.rotateBy(90, vy1);
		if(vOff.dotProduct(vx1ToConnection)>0)
		{
			vOff=-vOff;
		}
		vOff.normalize();																														
		Point3d ptOff=ptContactInt+vy1*vy1.dotProduct(sh.ptCen()-ptContactInt);//Realign to sheeting center height
		ptOff+=vOff*dSheetingLimits*.5;//Setting sheeting offset																					
																																				
		Line lnInternalMidLine (ptOff,vInternalMidLine);			
		Point3d ptIntersects[]=bdSh.intersectPoints(lnInternalMidLine);
		if((sh.ptCen()-ptContactInt).dotProduct(vInternalMidLine)>0//Filtering sheeting at same side of connection
		&&ptIntersects.length()>0)//Sheeting is aligned with ptContact
		{
			double dDist=0;																													
			Point3d ptCut;
			for(int p=0;p<ptIntersects.length();p++)
			{
				Point3d ptInt=ptIntersects[p];																									
				if(vInternalMidLine.dotProduct(ptInt-ptContactInt)>dDist)
				{
					ptCut=ptInt;	
				}
			}	
			Cut ctSh(ptCut,(vx1ToConnection));
			sh.addToolStatic(ctSh);
		}
	}
																															
	//On el2
	Sheet shAllEl2[]=el2.sheet();
	for(int s=0;s<shAllEl2.length();s++)
	{
		Sheet sh=shAllEl2[s];
		Body bdSh=sh.envelopeBody();
		Vector3d vOff=	vInternalMidLine.rotateBy(90, vy1);
		if(vOff.dotProduct(vx2ToConnection)>0)
		{
			vOff=-vOff;
		}
		vOff.normalize();																														
		Point3d ptOff=ptContactInt+vy2*vy2.dotProduct(sh.ptCen()-ptContactInt);//Realign to sheeting center height
		ptOff+=vOff*dSheetingLimits*.5;//Setting sheeting offset																					
																																				
		Line lnInternalMidLine (ptOff,vInternalMidLine);			
		Point3d ptIntersects[]=bdSh.intersectPoints(lnInternalMidLine);
		if((sh.ptCen()-ptContactInt).dotProduct(vInternalMidLine)>0//Filtering sheeting at same side of connection
		&&ptIntersects.length()>0)//Sheeting is aligned with ptContact
		{
			double dDist=0;																													
			Point3d ptCut;
			for(int p=0;p<ptIntersects.length();p++)
			{
				Point3d ptInt=ptIntersects[p];																									
				if(vInternalMidLine.dotProduct(ptInt-ptContactInt)>dDist)
				{
					ptCut=ptInt;	
				}
			}	
			Cut ctSh(ptCut,(vx2ToConnection));
			sh.addToolStatic(ctSh);
		}
	}

	_Map.setInt("ExecutionMode", 1);
	_Map.setString("sConCode", sConCode1);
}

//Display
PLine plDisp(vy2);
Vector3d vDisp(ptContactExt-ptContactInt);
vDisp.normalize();
plDisp.addVertex(ptContactExt);
plDisp.addVertex(ptContactExt+vDisp*U(12,1));
plDisp.addVertex(ptContactExt+vDisp*U(12,1)-vx1ToConnection*U(25,1));
plDisp.addVertex(ptContactExt+vDisp*U(12,1));
plDisp.addVertex(ptContactExt+vDisp*U(12,1)-vx2ToConnection*U(25,1));
Display dp(-1);
dp.draw(plDisp);


#End
#BeginThumbnail
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
MQ\R?4?YQ^-9V@W?WK5S_`+29/YC^OYUJ_?A?JCFC^ZJ\O27YFW1116)U!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!3)HDGA>)QE6
M&#3Z*`:OH<[IDKV&I-;2\!SL/U['I_G-=%6)KUI]VZ0?[+X'Y'^GY5HZ==?:
M[-)"?G'RO]1_G/XUM4]Y*:.6@^23I/Y%JN=U.)[#4EN8N`YWCZ]QU_SFNBJK
MJ-K]KLWC`^<?,GU'^<?C44Y<LM32O3YX:;HGAE2>%)4.589%/K$T&[^]:N?]
MI,G\Q_7\ZVZ4X\LK%4JG/!2"BBBI-`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@!DT23PO$XRK#!K`TR5[#4FMI>`YV'Z]CT_SFNBK
M$UZT^[=(/]E\#\C_`$_*M:3O[KZG-B(M6J1W1MT55TZZ^UV:2$_./E?ZC_.?
MQJU6;5G9G1&2DKHYW4XGL-26YBX#G>/KW'7_`#FM^&5)X4E0Y5AD5!J-K]KL
MWC`^<?,GU'^<?C6=H-W]ZU<_[29/YC^OYUJ_?A?JCFC^ZJ\O27YFW1116)U!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!3)HDGA>)
MQE6&#3Z*`:OH<[IDKV&I-;2\!SL/U['I_G-=%6)KUI]VZ0?[+X'Y'^GY5/#K
M,`LDDF8F7&&11DDCOZ>];37.E)')2DJ3=.3VV-2N7OI([?53/:R*W(?@\9[C
M/?\`^OBGRW5]JK&*)#Y>?N+T[XR?\]*O0Z#"(SY\C,Y'\/`'T]:J*5/XF34E
M*OI36W4U(94GA25#E6&13ZC@@2V@2&/.U1QDU)6#M?0[%>VH4444AA1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`#)HDGA>)QE6&#6%
M::)*;@_:@!$I['[_`/@*Z"BKC-Q5D93HQFTY=!D4,<$82)%1?0"GT45!JE;8
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
B****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@#_V:**
`


#End
