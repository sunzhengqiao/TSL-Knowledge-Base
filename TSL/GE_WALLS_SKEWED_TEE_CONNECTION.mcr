#Version 8
#BeginDescription
Creates structural skewed angled connection between 2 walls. 
Available configurations: Simple, Simple L, Ladder, 3 Studs
v1.12: 21.jul.2012: David Rueda (dr@hsb-cad.com)

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

* v1.12: 21.jul.2012: David Rueda (dr@hsb-cad.com)
	- Description updated
	- Thumbnail updated
v1.11: 04-may-2011: David Rueda (dr@hsb-cad.com)	- Changed default value for props.
v1.10: 28-Feb-2011: David Rueda (dr@hsb-cad.com)	- Added chance to cut or not sheetong on female wall
v1.9: 14-Dic-2010: David Rueda (dr@hsb-cad.com):		- Work with blocking added
v1.8: 08-Dic-2010: David Rueda (dr@hsb-cad.com): 		- Tsl inserts GE_WDET_AUTOLADDER for ladder type
															- Display upgrated
															- Prop. indexes updated
v1.7: 30-Nov-2010: David Rueda (dr@hsb-cad.com): 	- Bug Fix
v1.6: 28-Nov-2010: David Rueda (dr@hsb-cad.com): 	- Ladder options does not create ladder anymore, it just clones GE_WDET_AUTOLADDER tsl															
v1.5: 23-Nov-2010: David Rueda (dr@hsb-cad.com): 	- Rename tsl from hsb_NonStandardConnection_Skewed to GE_WALLS_SKEWED_TEE_CONNECTION
v1.4: 18-Nov-2010: David Rueda (dr@hsb-cad.com): 	- Rename tsl from hsb_NonStandardConnection_Skewed hsb_NonStandardConnection_Skewed_T
															- Added property "Lap VTP's" (Yes,No)
															- Properties updated
v1.3: 15-Nov-2010: David Rueda (dr@hsb-cad.com): 	- Bugfix
v1.2: 12-Nov-2010: David Rueda (dr@hsb-cad.com): 	- Bugfix
v1.1: 12-Nov-2010: David Rueda (dr@hsb-cad.com): 	- Tsl will erase itself if found previous connection between walls
v1.0: 05-Nov-2010: David Rueda (dr@hsb-cad.com)		- Release
*/

String sArNoYes[] = {T("No"), T("Yes")};
String sT[] = {T("|Simple|"), T("|Simple L|"), T("|Ladder|"), "3 "+T("|studs|")};
PropString sType (0, sT, T("|Connection type|"));
int nType=sT.find(sType,0);
PropString sDummy0(7,""," ");
sDummy0.setReadOnly(1);
PropString sCutSh (8, sArNoYes, T("|Cut sheeting on female wall|"),1);
int nCutShOnFemaleWall=sArNoYes.find(sCutSh,1);
PropDouble dSheetingLimits(0,U(3.175,0.125),T("|Sheeting limits|"));
PropString sLapVTP(1,sArNoYes,T("|Lap|"+" VTP's"),1);
int nLapVTPs=sArNoYes.find(sLapVTP);
PropDouble dEndGapVTP(1,U(3.175,0.125),T("|End gap|"+" (VTP)"));
PropDouble dSideGapVTP(2,U(3.175,0.125),T("|Side gap|"+" (VTP)"));
PropDouble dEndGapBtmTopPlt(3,U(0,0),T("|End gap|"+" (BtmP, TP)"));
PropString sDummy1(2,"","  ");
PropString sDummy2(3,"",T("|All new beams info|"));
sDummy1.setReadOnly(1);
sDummy2.setReadOnly(1);
PropString sNewBeamsName(4,"SYP #2 2x4",T("|Name|"));
PropString sNewBeamsMaterial(5,"SYP",T("|Material|"));
PropString sNewBeamsGrade(6,"#2",T("|Grade|"));
PropInt nBmColor(0,3,T("|Beam color|"));

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

/*Checking this is a skewed connection; these are the conditions to be accomplished: 
	-	2 points must result when 2 outlines of walls intersect. If it's only one point resulting then is one of this situations: 
			T connection with only one contact point (open angle). User must use "stretch to wall(s) or roof(s)" tool.
			End to end wall connection (open angle). Depending on angle (obtuse or acute) user must select another tsl for 
			angled wall connection 
	- 	One element must have 2 coincident vertex with the 2 resulting points on intersection of both element's outlines, 
		while other element must NOT have ANY coincident vertex, otherwise it's a corner or a non cleaned up connection
*/

PLine plEl1=el1.plOutlineWall();
PLine plEl2=el2.plOutlineWall();
Point3d ptAllInt[]=plEl1.intersectPLine(plEl2);
if(ptAllInt.length()!=2)
{
	reportMessage("\n"+T("|ERROR: This is not a skewed connection or the connection is not cleaned up, cannot apply this tsl on this type of connection|"));
	eraseInstance();
	return;
}
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

//Check that connection accomplish second condition and define which wall is male and which is female
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

ElementWall elMale, elFemale;
if(nEl1IsMale&&nEl2IsMale)//It's not a skewed connection, but an angled end to end connection
{
		reportMessage("\n"+T("|ERROR: This is not a skewed connection, cannot apply this tsl on this type of connection|"));
		eraseInstance();
		return;
}
else if(nEl1IsMale)
{
	elMale=el1 ;
	elFemale=el2;
}
else if(nEl2IsMale)
{
	elMale=el2;
	elFemale=el1;
	
}
else //None of elements has 2 coinident points
{
		reportMessage("\n"+T("|ERROR: This is not a skewed connection, cannot apply this tsl on this type of connection|"));
		eraseInstance();
		return;
}

assignToElementGroup(elMale);
assignToElementGroup(elFemale);

//Getting Info from elements
CoordSys csElMale=elMale.coordSys();
Point3d ptElMaleOrg=csElMale.ptOrg();
Vector3d vxMale=csElMale.vecX();
Vector3d vyMale=csElMale.vecY();
Vector3d vzMale=csElMale.vecZ();
//Getting wall width, ptStart, ptEnd, ptMid from Male wall
PlaneProfile ppMaleEl(elMale.plOutlineWall());
LineSeg lsMale=ppMaleEl.extentInDir(vxMale);
double dMaleLength=abs(vxMale.dotProduct(lsMale.ptStart()-lsMale.ptEnd()));
double dMaleWidth=elMale.dBeamWidth();
Point3d ptMaleStart=csElMale.ptOrg();
Point3d ptMaleEnd=ptMaleStart+vxMale*dMaleLength;
Point3d ptMaleMid=ptMaleStart+vxMale*dMaleLength*.5-vzMale*dMaleWidth*.5;		

CoordSys csElFemale=elFemale.coordSys();
Point3d ptElFemaleOrg=csElFemale.ptOrg();
Vector3d vxFemale=csElFemale.vecX();
Vector3d vyFemale=csElFemale.vecY();
Vector3d vzFemale=csElFemale.vecZ();
//Getting wall width, ptStart, ptEnd, ptMid from Male wall
PlaneProfile ppFemaleEl(elFemale.plOutlineWall());
LineSeg lsFemale=ppFemaleEl.extentInDir(vxFemale);
double dFemaleLength=abs(vxFemale.dotProduct(lsFemale.ptStart()-lsFemale.ptEnd()));
double dFemaleWidth=elFemale.dBeamWidth();
Point3d ptFemaleStart=csElFemale.ptOrg();
Point3d ptFemaleEnd=ptFemaleStart+vxFemale*dFemaleLength;
Point3d ptFemaleMid=ptFemaleStart+vxFemale*dFemaleLength*.5-vzFemale*dFemaleWidth*.5;		

//Getting contact point
Plane plnEl2Mid(ptFemaleMid,vzFemale);
Line lnEl1Mid(ptMaleMid,vxMale);
Point3d ptIntersection=lnEl1Mid.intersect(plnEl2Mid,0);
Vector3d vCheckContact=vxFemale;
Point3d ptContact;// DO NOT MOVE ptContact
Point3d ptProyected;// Second contact point

if(vCheckContact.dotProduct(ptIntersection-ptMaleMid)<0)//Making always ponting from inner contact to outter contact point
{
	vCheckContact=-vCheckContact;
}
if(vCheckContact.dotProduct(ptCon1-ptCon2)>0){
	ptContact=ptCon2;
	ptProyected=ptCon1;
}
else
{
	ptContact=ptCon1;
	ptProyected=ptCon2;
}
_Pt0=ptContact;
																																						//ptContact.vis();ptProyected.vis();
//Finding other contact point, ptContact is one point of male wall (at the corner). Now we need to find the point in the next corner 
Vector3d vOut=vzMale; //vector normal to male wall but always pointing out from female wall
if(vOut.dotProduct(ptMaleMid-ptContact)<0)
{
	vOut=-vOut;
}
Point3d ptElMaleFront=ptContact;
Point3d ptElMaleBack=ptContact+vOut*elMale.dBeamWidth();

//Now we need to know which of both points is contact point
Point3d ptToProyect;
if((ptElMaleFront-ptContact).length()<(ptElMaleBack-ptContact).length())
{
	ptToProyect=ptElMaleBack;
}
else
{
	ptToProyect=ptElMaleFront;
}

//Checking if male wall contacts inside female wall
//ptContact and ptToProyect must be both between ends of female wall
if(vxFemale.dotProduct(ptContact-ptFemaleStart)<=0
	||
	vxFemale.dotProduct(ptFemaleEnd-ptContact)<=0 
	|| 
	vxFemale.dotProduct(ptProyected-ptFemaleStart)<=0
	||
	vxFemale.dotProduct(ptFemaleEnd-ptProyected)-dTol<0)
{
		reportMessage("\n"+T("|ERROR: This is not a skewed connection, cannot apply this tsl on this type of connection|"));
		eraseInstance();
		return;
}

//This will be useful to define what plates are to be to stretched
double dShrink=U(10,0.4);
//Body bdMaleBigger(ptMaleMid, vxMale, vyMale, vzMale, dMaleLength+dShrink, U(4000,160), dMaleWidth+dShrink, 0, 1, 0);
Vector3d vTmp(ptProyected-ptContact); vTmp.normalize();
Point3d ptMaleBodyCenter=ptContact+vTmp*vTmp.dotProduct(ptProyected-ptContact)*.5;
ptMaleBodyCenter+=vzFemale*vzFemale.dotProduct(ptFemaleMid-ptMaleBodyCenter);ptMaleBodyCenter.vis();
Body bdMaleBigger(ptMaleBodyCenter, vxFemale, vyFemale, vzFemale, (ptProyected-ptContact).length()+dShrink+elFemale.dBeamWidth()*2, U(4000,160), dFemaleWidth+dShrink, 0, 1, 0);
Body bdFemaleBigger(ptFemaleMid, vxFemale, vyFemale, vzFemale, dFemaleLength+dShrink, U(4000,160), dFemaleWidth+dShrink, 0, 1, 0);
bdMaleBigger.vis(1);
//Finding top, very top, and bottom plates on male wall
Beam bmAllMale[]=elMale.beam();
Beam bmAllMaleHorizontal[0], bmAllMaleVertical[0], bmAllMaleVTP[0], bmAllMaleTP[0], bmAllMaleBtm[0];
bmAllMaleHorizontal=vxMale.filterBeamsParallel(bmAllMale);
bmAllMaleVertical=vyMale.filterBeamsParallel(bmAllMale);
Beam bmMaleLowerTP;//Reference to create ladder in necessary case
Point3d ptMaleLowerTPCen=ptMaleStart+vyMale*U(10000, 400);//Used to find bmMaleLowerTP
Beam bmAnyMaleBottomPlate;//Reference to create ladder in necessary case
for(int b=0;b<bmAllMaleHorizontal.length();b++)
{
	Beam bm=bmAllMaleHorizontal[b];																									//bm.envelopeBody().vis(32);	
	if(bm.type()==_kSFTopPlate || bm.type()==_kTopPlate || bm.type()==_kSFBottomPlate)//Bottom, Top and Very Top Plates
	{		
		//Must be closer enough to point to be splitted
		if(bm.envelopeBody().intersectWith(bdFemaleBigger))
		{
			//Clasifying, top and very top
			if(bm.beamCode().token(0).makeUpper()=="V")//VTP
			{
				bmAllMaleVTP.append(bm);
																																			//bm.envelopeBody().vis(2);
			}
			else if(bm.type()==_kSFTopPlate || bm.type()==_kTopPlate)//TP
			{
				bmAllMaleTP.append(bm);
				//Finding lower TopPlate
				if(bm.ptCen().Z()<ptMaleLowerTPCen.Z())
				{
					ptMaleLowerTPCen=bm.ptCen();
					bmMaleLowerTP=bm;
				}
																																			//bm.envelopeBody().vis(1);
			}
	
			else if(bm.type()==_kSFBottomPlate)//Bottom Plates
			{
				bmAllMaleBtm.append(bm);
				bmAnyMaleBottomPlate=bm;	
																																			//bm.envelopeBody().vis(1);
			}
		}
	}
}

//Finding top, very top, and bottom plates on female wall
Beam bmAllFemale[]=elFemale.beam();
Beam bmAllFemaleHorizontal[0], bmAllFemaleVertical[0], bmAllFemaleVTP[0], bmAllFemaleTP[0], bmAllFemaleBtm[0], bmAllFemaleNonPlates;
bmAllFemaleHorizontal=vxFemale.filterBeamsParallel(bmAllFemale);
bmAllFemaleVertical=vyFemale.filterBeamsParallel(bmAllFemale);
Beam bmFemaleLowerTP;//Reference to create ladder in necessary case
Beam bmAnyFemaleBottomPlate;//Reference to create ladder in necessary case
Point3d ptFemLowerTPCen=ptFemaleStart+vyFemale*U(10000, 400);//Used to find bmFemaleLowerTP
Beam bmFemaleBlockingToBeStretched[0];
for(int b=0;b<bmAllFemaleHorizontal.length();b++)
{
	Beam bm=bmAllFemaleHorizontal[b];																								//bm.envelopeBody().vis(32);	
	if(bm.type()==_kSFTopPlate || bm.type()==_kTopPlate || bm.type()==_kSFBottomPlate)//Bottom, Top and Very Top Plates
	{		
		//Must be closer enough to point to be splitted
		if(bm.envelopeBody().intersectWith(bdMaleBigger))
		{
			//Clasifying, top and very top
			if(bm.beamCode().token(0).makeUpper()=="V")//VTP
			{
				bmAllFemaleVTP.append(bm);																							//bm.envelopeBody().vis(2);
			}
			else if(bm.type()==_kSFTopPlate || bm.type()==_kTopPlate)//TP
			{
				bmAllFemaleTP.append(bm);																								//bm.envelopeBody().vis(1);
				//Finding lower TopPlate
				if(bm.ptCen().Z()<ptFemLowerTPCen.Z())
				{
					ptFemLowerTPCen=bm.ptCen();
					bmFemaleLowerTP=bm;
				}
			}
			else if(bm.type()==_kSFBottomPlate)//Bottom Plates
			{
				bmAllFemaleBtm.append(bm);																							//bm.envelopeBody().vis(1);
				bmAnyFemaleBottomPlate=bm;//Assuming there will be only one level for bottom plates
			}
		}
	}
	else if(bm.type()==_kSFBlocking || bm.type()==_kBlocking)//Blocking
	{bm.envelopeBody().vis();
		//Must be closer enough to point to be cut
		if(bm.envelopeBody().intersectWith(bdMaleBigger))
		{
			bmFemaleBlockingToBeStretched.append(bm);bm.envelopeBody().vis();
		}
	}	
}

//Get normal vector to female wall (always away from connection)
Vector3d vzFemaleOut=vzFemale;
if((ptFemaleMid-ptMaleMid).dotProduct(vzFemaleOut)<0)//Making sure it always points away from conection
{
	vzFemaleOut=-vzFemaleOut;																								
 																																			vzFemaleOut.vis(ptFemaleMid);
}
Vector3d vxMaleOutCon=vxMale;// Paralell to male's vecX, but pointing always out of connection
if(vxMaleOutCon.dotProduct(ptContact-ptMaleMid)>0)
{
	vxMaleOutCon=-vxMaleOutCon;
}
																																			vxMaleOutCon.vis(ptMaleMid);
int nExecutionMode;
if( _Map.hasInt("ExecutionMode") )
{
	nExecutionMode = _Map.getInt("ExecutionMode");
}

if(!nExecutionMode || _bOnElementConstructed||1){

	Beam bmAllBeamsCreated[0];//To apply common props. like grade, material, etc..
		
	//Define if male wall is at icon side or not of female wall
	int nSide=0;
 																																			vzFemale.vis(ptFemaleMid);(ptFemaleMid-ptMaleMid).vis(ptFemaleMid);
	if((ptFemaleMid-ptMaleMid).dotProduct(vzFemale)<0)//Male wall is at icon side of female wall
	{
		nSide=1;
	}
	else
	{
		nSide=-1;
	}
	ElemZone elZn=elFemale.zone(nSide*5);
	Point3d ptMax=elZn.ptOrg();
	//Find cut point for TP and BtmP
	double dSheetingTotalThickness=0;
	if(!nCutShOnFemaleWall)
	{
		dSheetingTotalThickness=abs(vzFemale.dotProduct(ptContact-ptMax))+elZn.dH();
	}

	Point3d ptCt=ptContact-vzFemaleOut*(dSheetingTotalThickness+dEndGapBtmTopPlt);
	Cut ct1(ptCt,vzFemaleOut);

	//Stretching all TP and Bottoms
	//TP's
	for(int b=0;b<bmAllMaleTP.length();b++)
	{
		Beam bm=bmAllMaleTP[b];
		bm.addToolStatic(ct1, 1);
	}
	//Bottoms
	for(int b=0;b<bmAllMaleBtm.length();b++)
	{
		Beam bm=bmAllMaleBtm[b];
		bm.addToolStatic(ct1, 1);
	}
	
	//Created beam(s) and clear body must be offset from female wall sheeting width + offset in prop
	Vector3d vTmp=-vzFemaleOut;
	double dAngle=vTmp.angleTo(vxMaleOutCon);
	double dDistanceToMoveAlongMaleX=0;
	if(cos(dAngle)!=0)
	{
		dDistanceToMoveAlongMaleX=(dSheetingTotalThickness+dEndGapBtmTopPlt)/cos(dAngle);
	}

	//Clean area (for male element's beams only)
	//Defining parameters for clean area
	Vector3d vxClean,vyClean,vzClean;
	vxClean=vxMale;
	if((ptContact-ptMaleMid).dotProduct(vxClean)<0)//Need vx from male element but always pointing to connection
	{
		vxClean=-vxClean;
	}
	vyClean=vyMale;
	vzClean=vxClean.crossProduct(vyClean);
	double dCleanLenght, dCleanWidth, dCleanHeight;
	Point3d ptCleanTop=bmMaleLowerTP.ptCen()-vyMale*bmMaleLowerTP.dD(vyMale)*.5;
	Point3d ptCleanBtm=bmAnyMaleBottomPlate.ptCen()+vyMale*bmAnyMaleBottomPlate.dD(vyMale)*.5;
	dCleanLenght=abs(vyClean.dotProduct(ptCleanTop-ptCleanBtm));
	Point3d ptCleanWidthStart=ptProyected+vyClean*vyClean.dotProduct(ptCleanBtm-ptProyected);
	Point3d ptCleanWidthEnd=ptContact-vxClean*(elMale.dBeamHeight()+dDistanceToMoveAlongMaleX);
	dCleanWidth=abs(vxClean.dotProduct(ptCleanWidthEnd-ptCleanWidthStart));
	dCleanHeight=elMale.dBeamWidth();
	Point3d ptCleanCenter=ptCleanWidthStart-vxClean*dCleanWidth*.5-vOut*dCleanHeight*.5;
	ptCleanWidthStart.vis();ptCleanWidthEnd.vis();
	//ptCleanCenter+=vxMaleOutCon*dDistanceToMoveAlongMaleX;
	
	if(dCleanLenght==0 || dCleanWidth==0 || dCleanHeight==0)//Won't be able to generate body
	{
		return;	
	}
	Body bdClean(ptCleanCenter, vxClean, vyClean, vzClean, dCleanWidth, dCleanLenght, dCleanHeight, 0, 1, 0);
																																		bdClean.vis(3);ptCleanCenter.vis();
	//Cleaning interfering beams
	for(int b=0;b<bmAllMaleVertical.length();b++){
		Beam bm=bmAllMaleVertical[b];
		Body bdBm=bm.envelopeBody();
		if(bdBm.intersectWith(bdClean))
		{
				bm.dbErase();
		}
	}
	
	//Create new beam (will be like if beam erased in last step is "moved")
	Point3d ptNewBmCen=ptContact+vOut*dMaleWidth*.5-vxClean*elMale.dBeamHeight()*.5;
	ptNewBmCen+=vyMale*vyMale.dotProduct(ptCleanBtm-ptNewBmCen);
	ptNewBmCen+=vxMaleOutCon*dDistanceToMoveAlongMaleX;

	Vector3d vxBmMale=vyMale;
	Vector3d vyBmMale=vOut;
	Vector3d vzBmMale=vyMale.crossProduct(vOut);
	Beam bmNewBmMale;
	bmNewBmMale.dbCreate(ptNewBmCen, vxBmMale, vyBmMale, vzBmMale, dCleanLenght, elMale.dBeamWidth(), elMale.dBeamHeight(), 1, 0, 0);
	bmAllBeamsCreated.append(bmNewBmMale);
	bmNewBmMale.assignToElementGroup(elMale,1, 0, 'z');
	
	if(nLapVTPs)//User wants to lap VTP's
	{
		Cut ctContact(ptContact-vOut*dSideGapVTP, vOut);
		Cut ctProyected(ptProyected+vOut*dSideGapVTP, -vOut);
		Cut ctMaleVTP(ptContact+vzFemaleOut*(dFemaleWidth-dEndGapVTP),vzFemaleOut);

		//Split female VTP's
		for(int b=0;b<bmAllFemaleVTP.length();b++)
		{	
			//Split VTP's on female wall
			Beam bm1=bmAllFemaleVTP[b];
			Beam bm2=bm1.dbSplit(ptContact,ptContact);
			//Applying cuts to splitted beams
			//Need to find which cut apply to which beam
			if((ptProyected-ptContact).dotProduct(ptContact-bm1.ptCen())>0)
			{
				bm1.addToolStatic(ctContact,2);
				bm2.addToolStatic(ctProyected,2);
			}
			else
			{
				bm1.addToolStatic(ctProyected,2);
				bm2.addToolStatic(ctContact,2);
			}				
		}	
		
		//Extend VTP's on male wall
		for(int b=0;b<bmAllMaleVTP.length();b++)
		{
			Beam bm=bmAllMaleVTP[b];
			bm.addToolStatic(ctMaleVTP,2);
		}	
	}
	else//User doesn't want to lap VTP's
	{
		Cut ctMaleVTP(ptContact,vzFemaleOut);
		//Extend VTP's on male wall
		for(int b=0;b<bmAllMaleVTP.length();b++)
		{
			Beam bm=bmAllMaleVTP[b];
			bm.addToolStatic(ctMaleVTP,2);
		}	
	}
		
	//Start connection types
	if(nType==1)//Simple L: must create extra beam
	{
		Point3d ptNewBeamTop=bmMaleLowerTP.ptCen()-vyMale*bmMaleLowerTP.dD(vyMale)*.5;
		ptNewBeamTop+=vxMale*vxMale.dotProduct(ptToProyect-ptNewBeamTop)+vzMale*vzMale.dotProduct(ptToProyect-ptNewBeamTop);
		Point3d ptNewBeamBtm=bmAnyMaleBottomPlate.ptCen()+vyMale*bmAnyMaleBottomPlate.dD(vyMale)*.5;
		ptNewBeamBtm+=vxMale*vxMale.dotProduct(ptToProyect-ptNewBeamBtm)+vzMale*vzMale.dotProduct(ptToProyect-ptNewBeamBtm);
		ptNewBeamBtm+=vxMaleOutCon*dDistanceToMoveAlongMaleX;
		double dNewBmLength=abs(vyMale.dotProduct(ptNewBeamTop-ptNewBeamBtm));
		double dNewBmWidht=U(38.1,1.5);
		double dNewBmHeight=abs(vxMale.dotProduct(ptProyected-ptToProyect));
		if(dNewBmLength<=0.001|| dNewBmHeight<=0.001)//Won't be able to body generation				
			return;
		Vector3d vxBm, vyBm, vzBm;
		vxBm=vyMale;
		vyBm=-vOut;
		vzBm=vxBm.crossProduct(vyBm);
		int nOrientation=1;
		if(vzBm.dotProduct(ptProyected-ptToProyect)<0)
			nOrientation=-1;

		Beam bmCavityFiller;
		bmCavityFiller.dbCreate(ptNewBeamBtm, vxBm, vyBm, vzBm, dNewBmLength, dNewBmWidht, dNewBmHeight, 1, 1, nOrientation);
		//Add cut
		Point3d ptCt=ptContact;
		ptCt=ptContact-vzFemaleOut*(dSheetingTotalThickness+dEndGapBtmTopPlt);

		Cut ctNewBeam(ptCt,vzFemaleOut);
		bmCavityFiller.addToolStatic(ctNewBeam);
		bmAllBeamsCreated.append(bmCavityFiller);
		bmCavityFiller.assignToElementGroup(elMale,1, 0, 'z');
	}
	else if(nType==2)//Ladder
	{

		Vector3d vTmp(ptContact-ptProyected);vTmp.normalize();
		Point3d ptLadderCenter=ptContact-vTmp*(ptContact-ptProyected).length()*.5;									
		//Clone GE_WDET_AUTOLADDER tsl
		//PREPARE TO CLONING - MUST ALWAYS CLONE, TSL will erase itself
		// declare tsl props 
		TslInst tsl;
		String sScriptName = "GE_WDET_AUTOLADDER";
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		Beam lstBeams[0];
		Entity lstEnts[0];
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		lstPoints.append(ptLadderCenter);
		lstPropDouble.append(elMale.dBeamWidth());
		lstPropString.append("");
		lstPropString.append("");
		lstPropString.append(sNewBeamsName);
		lstPropString.append(sNewBeamsMaterial);
		lstPropString.append(sNewBeamsGrade);
		lstPropInt.append(nBmColor);
		lstEnts.append(elFemale);
		tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString );
	}
	else if(nType==3)//3 Studs
	{

		//Pre steps to create studs
		Point3d ptStudsTop=bmFemaleLowerTP.ptCen()-vyFemale*bmFemaleLowerTP.dD(vyFemale)*.5;
		Point3d ptStudsBtm=bmAnyFemaleBottomPlate.ptCen()+vyFemale*bmAnyFemaleBottomPlate.dD(vyFemale)*.5;

		//Studs (vertical beams, AT SIDES, NOT CENTRAL)
		double dStudLength=abs(vyFemale.dotProduct(ptStudsTop-ptStudsBtm));
		double dStudWidth=U(38.1,1.5);
		double dStudHeight=elFemale.dBeamWidth();

		//Define which beam must use for 3rd. stud
		double dCentralStudHeight=0;
		if(abs(elMale.dBeamWidth()-U(88.9,3.5))<dTol)//2x4
			dCentralStudHeight=U(139.7,5.5);
		else if(abs(elMale.dBeamWidth()-U(139.7,5.5))<dTol)////2x6
			dCentralStudHeight=U(184.15,7,25);
		else if(abs(elMale.dBeamWidth()-U(184.15,7.25))<dTol)////2x8
			dCentralStudHeight=U(234.95,9.25);
		else if(abs(elMale.dBeamWidth()-U(234.95,9.25))<dTol)////2x10
			dCentralStudHeight=U(285.75,11.25);
		else if(abs(elMale.dBeamWidth()-U(285.75,11.25))<dTol)////2x12
			dCentralStudHeight=U(336.55,13.25);
		else if(abs(elMale.dBeamWidth()-U(336.55,13.25))<dTol)////2x14
			dCentralStudHeight=U(387.35,15.25);
		else if(abs(elMale.dBeamWidth()-U(387.35,15.25))<dTol)////2x16
			dCentralStudHeight=U(387.35,15.25);
		else
			dCentralStudHeight=U(139.7,5.5);

		//Create 3 studs
		Vector3d vxLR=vxFemale;//Set what is left and right
		if(vxLR.dotProduct(ptProyected-ptContact)<0)
		{
			vxLR=-vxLR;
		}
		Vector3d vxStud=vyFemale;
		Vector3d vyStud=vzFemaleOut;
		Vector3d vzStud=vxStud.crossProduct(vyStud);

		//Calc. starting point 
		Point3d ptCenterBeamMid=ptContact;//Center point of ladder, creation reference.
		Vector3d v1=(ptProyected-ptContact);v1.normalize();
		ptCenterBeamMid+=v1*abs((ptProyected-ptContact).length())*.5+vyFemale*vyFemale.dotProduct(ptStudsBtm-ptCenterBeamMid);	

		//Studs (bodys only)
		//Central
		Point3d ptStud=ptCenterBeamMid;
		if(dStudLength<=0)//Won't be able to generate body
			return;
		Body bdBmCenter (ptStud, vxStud, vyStud, vzStud, dStudLength, dStudWidth, dCentralStudHeight, 1, 1, 0);
		//Left and right is taken viewing contact point as a male beam
		//Left
		ptStud=ptCenterBeamMid;
		ptStud-=vxLR*(dCentralStudHeight+dStudWidth)*.5;
		Body bdBmLeft (ptStud, vxStud, vyStud, vzStud, dStudLength, dStudHeight, dStudWidth, 1, 1, 0);
		//Right
		ptStud=ptCenterBeamMid;
		ptStud+=vxLR*(dCentralStudHeight+dStudWidth)*.5;
		Body bdBmRight (ptStud, vxStud, vyStud, vzStud, dStudLength, dStudHeight, dStudWidth, 1, 1, 0);

		//Clean area of created beams
		Body bdClean();
		bdClean.addPart(bdBmCenter);
		bdClean.addPart(bdBmLeft);
		bdClean.addPart(bdBmRight);
		//Search all interfering beams. Must be erased
		for(int b=0;b<bmAllFemaleVertical.length();b++)
		{
			Beam bm=bmAllFemaleVertical[b];
			Body bdBm=bm.envelopeBody();		//bdBm.vis(3);																						
			if(bdBm.intersectWith(bdClean))
			{
				bm.dbErase();
			}
		}	

		//Create beams
		//Center 
		Beam bmCenter;
		bmCenter.dbCreate(bdBmCenter);
		bmAllBeamsCreated.append(bmCenter);
		bmCenter.assignToElementGroup(elFemale,1, 0, 'z');
		//Left
		Beam bmLeft;
		bmLeft.dbCreate(bdBmLeft);
		bmAllBeamsCreated.append(bmLeft);
		bmLeft.assignToElementGroup(elFemale,1, 0, 'z');
		//Right
		Beam bmRight;
		bmRight.dbCreate(bdBmRight);
		bmAllBeamsCreated.append(bmRight);
		bmRight.assignToElementGroup(elFemale,1, 0, 'z');
	
		//Work on blocking 
		//3 possible situations: stretch to left created stud, stretch to right created stud, be erased (when is in contact with bot created studs)
		for(int b=0;b<bmFemaleBlockingToBeStretched.length();b++)
		{
			int bIntersectsLeft, bIntersectsRight;
			bIntersectsLeft=bIntersectsRight=false;
			Beam bm=bmFemaleBlockingToBeStretched[b];	
			Body bdBm=bm.envelopeBody();
			Body bdBmLeft=bmLeft.envelopeBody();
			Body bdBmRight=bmRight.envelopeBody();
			bdBm.transformBy(vzFemale*U(2,0.08));			
			bdBm.vis(1);bmLeft.envelopeBody().vis();bmRight.envelopeBody().vis();
			if(bdBm.hasIntersection(bdBmLeft))
			{
				bIntersectsLeft=true;
			}
			if(bdBm.hasIntersection(bdBmRight))
			{
				bIntersectsRight=true;
			}
			if(bIntersectsLeft && bIntersectsRight)
			{
				bm.dbErase();
				continue;
			}
			if(bIntersectsLeft)
			{
				bm.stretchDynamicTo(bmLeft);
			}
			if(bIntersectsRight)
			{
				bm.stretchDynamicTo(bmRight);
			}
		}
	}

	//Asigning common properties to created beams
	for(int b=0;b<bmAllBeamsCreated.length();b++)
	{
		Beam bm=bmAllBeamsCreated[b];
		bm.setColor(nBmColor);
		bm.setName(sNewBeamsName);
		bm.setMaterial(sNewBeamsMaterial);
		bm.setGrade(sNewBeamsGrade);
	}

	//////////////////////////////////////////////////////////////////////////////////////////////// SHEETING WORK //////////////////////////////////////////////////////////////////////////////////////////////// 
	//Find middle line in ptContact
	Vector3d vxFemaleOutCon(ptContact-ptProyected);// Paralell to male's vecX, but pointing always from ptProyected to ptContact paralell x axis of female wall
	vxFemaleOutCon.normalize();
	double dInternalAngle=vxMaleOutCon.angleTo(vxFemaleOutCon);
	Vector3d vInternalMidLine=vxFemaleOutCon.rotateBy((dInternalAngle*.5),vyFemale);
	if(vInternalMidLine.angleTo(vxMaleOutCon)>dInternalAngle)
	{
		vInternalMidLine=vxFemaleOutCon.rotateBy((-dInternalAngle*.5),vyFemale);
	}

	//Find middle line in ptProyected
	Vector3d vxFemaleToCon=-vxFemaleOutCon;// Paralell to male's vecX, but pointing always from ptContact to ptProyected paralell x axis of female wall
	//Find middle line in ptContact
	double dExternalAngle=vxMaleOutCon.angleTo(vxFemaleToCon);
	Vector3d vExternalMidLine=vxFemaleToCon.rotateBy((dExternalAngle*.5),vyFemale);
	if(vExternalMidLine.angleTo(vxMaleOutCon)>dExternalAngle)
	{
		vExternalMidLine=vxFemaleToCon.rotateBy((-dExternalAngle*.5),vyFemale);
	}

																						//FEMALE WALL
	if(nCutShOnFemaleWall)
	{
		//Splitting sheetings on ptContact
		Sheet shAllFemale[]=elFemale.sheet();
		Plane plnPtContactShSplit(ptContact,vxFemale);
		for(int s=0;s<shAllFemale.length();s++)
		{
			Sheet sh=shAllFemale[s];
			Body bdSh=sh.envelopeBody();
			Line lnContact (ptContact+vyFemale*vyFemale.dotProduct(sh.ptCen()-ptContact) ,vzFemale);
			Point3d ptIntersects[]=bdSh.intersectPoints(lnContact);
			if((sh.ptCen()-ptContact).dotProduct(vzFemaleOut)<0//Filtering sheeting at same side of connection
			&&ptIntersects.length()>0)//Sheeting is aligned with ptContact
			{
				shAllFemale.append(sh.dbSplit(plnPtContactShSplit,0));
			}
		}
	
		//Splitting sheetings in ptProyected
		Plane plnPtProyectedShSplit(ptProyected,vxFemale);
		for(int s=0;s<shAllFemale.length();s++)
		{
			Sheet sh=shAllFemale[s];
			Body bdSh=sh.envelopeBody();
			Line lnProyected (ptProyected+vyFemale*vyFemale.dotProduct(sh.ptCen()-ptProyected) ,vzFemale);
			Point3d ptIntersects2[]=bdSh.intersectPoints(lnProyected);
			if((sh.ptCen()-ptContact).dotProduct(vzFemaleOut)<0//Filtering sheeting at same side of connection
			&&ptIntersects2.length()>0)//Sheeting is aligned with ptContact
			{			
				shAllFemale.append(sh.dbSplit(plnPtProyectedShSplit,0));
			}
		}
		
		//Clear useless sheetings (remains) on female wall
		Point3d ptBdCleanShCen=ptContact+vxFemale*vxFemale.dotProduct(ptProyected-ptContact)*.5-vzFemaleOut*U(1,0.04);
		double dCleanShWidth=abs(vxFemale.dotProduct(ptProyected-ptContact))-U(1,0.04);
		double dCleanShHeight=U(5000,200);
		double dCleanShLength=U(100,4);
		Vector3d vxCleanSh=-vzFemaleOut;
		Vector3d vyCleanSh=vyFemale;
		Vector3d vzCleanSh=vxCleanSh.crossProduct(vyFemale);
		Body bdCleanSh(ptBdCleanShCen,vxCleanSh,vyCleanSh,vzCleanSh,dCleanShLength,dCleanShHeight,dCleanShWidth,1,1,0);
		for(int s=0;s<shAllFemale.length();s++)
		{
			Sheet sh=shAllFemale[s];
			Body bdSh=sh.envelopeBody();
			if((sh.ptCen()-ptContact).dotProduct(vzFemaleOut)<0//Filtering sheeting at same side of connection
			&& bdSh.intersectWith(bdCleanSh))//Has intersection with area to clean
			{
				sh.dbErase();
			}
		}
	
		//Cut sheetings ends where needed
		//on ptContact
		for(int s=0;s<shAllFemale.length();s++)
		{
			Sheet sh=shAllFemale[s];
			Body bdSh=sh.envelopeBody();
			Vector3d vOff=	vInternalMidLine.rotateBy(90, vyFemale);
			if(vOff.dotProduct(vxMaleOutCon)>0)
			{
				vOff=-vOff;
			}
			vOff.normalize();
			Point3d ptOff=ptContact+vyFemale*vyFemale.dotProduct(sh.ptCen()-ptContact);//Realign to sheeting center height
			ptOff+=vOff*dSheetingLimits*.5;//Setting sheeting offset
			Line lnInternalMidLine (ptOff,vInternalMidLine);
			Point3d ptIntersects[]=bdSh.intersectPoints(lnInternalMidLine);
			if((sh.ptCen()-ptContact).dotProduct(vzFemaleOut)<0//Filtering sheeting at same side of connection
			&&ptIntersects.length()>0)//Sheeting is aligned with ptContact
			{
				double dDist=0;
				Point3d ptCut;
				for(int p=0;p<ptIntersects.length();p++)
				{
					Point3d ptInt=ptIntersects[p];
					if(vzFemaleOut.dotProduct(ptContact-ptInt)>dDist)
					{
						ptCut=ptInt;	
					}
				}	
				Cut ctSh(ptCut,(ptProyected-ptContact));
				sh.addToolStatic(ctSh);
			}
		}
		
		//on ptProyected
		for(int s=0;s<shAllFemale.length();s++)
		{
			Sheet sh=shAllFemale[s];
			Body bdSh=sh.envelopeBody();
			Vector3d vOff=	vExternalMidLine.rotateBy(90, vyFemale);
			if(vOff.dotProduct(vxMaleOutCon)>0)
			{
				vOff=-vOff;
			}
			vOff.normalize();
			Point3d ptOff=ptProyected+vyFemale*vyFemale.dotProduct(sh.ptCen()-ptProyected);//Realign to sheeting center height
			ptOff+=vOff*dSheetingLimits*.5;//Setting sheeting offset
			Line lnExternalMidLine(ptOff,vExternalMidLine);
			Point3d ptIntersects[]=bdSh.intersectPoints(lnExternalMidLine);
			if((sh.ptCen()-ptContact).dotProduct(vzFemaleOut)<0//Filtering sheeting at same side of connection
			&&ptIntersects.length()>0)//Sheeting is aligned with ptContact
			{
				double dDist=0;
				Point3d ptCut;
				for(int p=0;p<ptIntersects.length();p++)
				{
					Point3d ptInt=ptIntersects[p];
					if(vzFemaleOut.dotProduct(ptProyected-ptInt)>dDist)
					{
						ptCut=ptInt;	
					}
				}	
				Cut ctSh(ptCut,(ptContact-ptProyected));
				sh.addToolStatic(ctSh);
			}
		}
	}
	
																							//MALE WALL
	//Cut sheetings ends where needed
	//on ptContact
	Sheet shAllMale[]=elMale.sheet();
	for(int s=0;s<shAllMale.length();s++)
	{
		Sheet sh=shAllMale[s];
		Body bdSh=sh.envelopeBody();
		Vector3d vOff=	vInternalMidLine.rotateBy(90, vyFemale);
		if(vOff.dotProduct(vxMaleOutCon)<0)
		{
			vOff=-vOff;	
		}		
		vOff.normalize();
		Point3d ptOff=ptContact+vyMale*vyMale.dotProduct(sh.ptCen()-ptContact);//Realign to sheeting center height
		ptOff+=vOff*dSheetingLimits*.5;//Setting sheeting offset
		Line lnInternalMidLine (ptOff,vInternalMidLine);
		Point3d ptIntersects[]=bdSh.intersectPoints(lnInternalMidLine);
		if((sh.ptCen()-ptContact).dotProduct(vzFemaleOut)<0//Filtering sheeting at same side of connection
		&&ptIntersects.length()>0)//Sheeting is aligned with ptContact
		{
			double dDist=0;
			Point3d ptCut;
			for(int p=0;p<ptIntersects.length();p++)
			{
				Point3d ptInt=ptIntersects[p];
				if(vzFemaleOut.dotProduct(ptContact-ptInt)>dDist)
				{
					ptCut=ptInt;	
				}
			}	
			Cut ctSh(ptCut,-vxMaleOutCon);			
			if(nCutShOnFemaleWall)
			{
				sh.addToolStatic(ctSh); 
			}
			else
			{
				sh.addToolStatic(ct1); 
			}
		}
	}
	
	//on ptProyected
	for(int s=0;s<shAllMale.length();s++)
	{
		Sheet sh=shAllMale[s];
		Body bdSh=sh.envelopeBody();
		Vector3d vOff=	vExternalMidLine.rotateBy(90, vyFemale);
		if(vOff.dotProduct(vxMaleOutCon)<0)
		{
			vOff=-vOff;	
		}		
		vOff.normalize();
		Point3d ptOff=ptProyected+vyMale*vyMale.dotProduct(sh.ptCen()-ptProyected);//Realign to sheeting center height
		ptOff+=vOff*dSheetingLimits*.5;//Setting sheeting offset
		Line lnExternalMidLine(ptOff,vExternalMidLine);
		Point3d ptIntersects[]=bdSh.intersectPoints(lnExternalMidLine);
		if((sh.ptCen()-ptContact).dotProduct(vzFemaleOut)<0//Filtering sheeting at same side of connection
		&&ptIntersects.length()>0)//Sheeting is aligned with ptContact
		{
			double dDist=0;
			Point3d ptCut;
			for(int p=0;p<ptIntersects.length();p++)
			{
				Point3d ptInt=ptIntersects[p];
				if(vzFemaleOut.dotProduct(ptProyected-ptInt)>dDist)
				{
					ptCut=ptInt;	
				}
			}	
			Cut ctSh(ptCut,-vxMaleOutCon);
			if(nCutShOnFemaleWall)
			{
				sh.addToolStatic(ctSh); 
			}
			else
			{
				sh.addToolStatic(ct1); 
			}
		}
	}																																
	_Map.setInt("ExecutionMode", 1);
	_Map.setString("sConCode", sConCode1);
}

//Display
double dOffset=U(25,2);
Plane plnExternalFemaleFace(ptFemaleMid+vzFemaleOut*dFemaleWidth*.5,vzFemaleOut);
Point3d ptIntersectionDisp=lnEl1Mid.intersect(plnExternalFemaleFace,0);
ptIntersectionDisp+=vzFemaleOut*dOffset;
PLine plDisp(vyFemale);
Point3d ptDisp=ptIntersectionDisp;
plDisp.addVertex(ptDisp);
plDisp.addVertex(ptDisp-vxFemale*U(50,1));
plDisp.addVertex(ptDisp);
plDisp.addVertex(ptDisp+vxMaleOutCon*U(25,1));
plDisp.addVertex(ptDisp);
plDisp.addVertex(ptDisp+vxFemale*U(25,1));
Display dp(-1);
dp.draw(plDisp);




#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`$L`9`#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#W^BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"LC7+ZXLU@$#!"Y;)P">,>OUK7K`\3?\NO\`P/\`I7FYO4G3P<Y0=GIM
MZHF6Q3?5-7CC61WD5&Z,8@`?QQ71V-S]KLHI\8+#D>XX/ZUD:K_R+UE_VS_]
M`-7]$_Y!$'_`O_0C7#ESJT\8Z,YN2<4]7?73_,4=S0HHHKZ`L****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`,S4M7&GS)%Y)D9
MEW'YL`#_`"#6'J>I_P!H^5^Y\OR\_P`6<YQ[>U;>KZ7]N02Q'$Z#`!/##TK*
MTNYMHI/LU[;Q8S@.\8RI]&_SQ_+Y;,Y8J5=X>K/EIRVT5OOWW_JQG*][%K5%
M)\.V9`)"B,G`Z#;5>RUW['9QV_V;?LS\V_&<DGT]ZZ"[N(;:V>2XQY>,;2,[
MO;'>N7B@DU>^/E11PQCKL7"H/ZG_`#TZ/,(U</B8O#3_`'C2C:UW;OKML#T>
MATUC>QWUL)D!'.&4]CZ59J&UM8K2!885PHZGN3ZFIJ^CHJHJ<?:_%;6W<T04
M445J`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%0
M7%Y!:;?/DV[LXX)SCZ5/6)XA_P"7;_@7]*N$5*5F95IN$')%W^V+#_GO_P".
M-_A1_;%A_P`]_P#QQO\`"JEOHEM+;12,\H+H&.".X^E2?V!:_P#/2;\Q_A5V
MI]V9*6(:O9$_]L6'_/?_`,<;_"C^V+#_`)[_`/CC?X5!_8%K_P`])OS'^%']
M@6O_`#TF_,?X4K4N['?$=D3_`-L6'_/?_P`<;_"C^V+#_GO_`..-_A4']@6O
M_/2;\Q_A1_8%K_STF_,?X46I=V%\1V1/_;%A_P`]_P#QQO\`"C^V+#_GO_XX
MW^%0?V!:_P#/2;\Q_A1_8%K_`,])OS'^%%J7=A?$=D3_`-L6'_/?_P`<;_"C
M^V+#_GO_`..-_A4']@6O_/2;\Q_A1_8%K_STF_,?X46I=V%\1V1/_;%A_P`]
M_P#QQO\`"C^V+#_GO_XXW^%0?V!:_P#/2;\Q_A1_8%K_`,])OS'^%%J7=A?$
M=D3_`-L6'_/?_P`<;_"C^V+#_GO_`..-_A4']@6O_/2;\Q_A1_8%K_STF_,?
MX46I=V%\1V1/_;%A_P`]_P#QQO\`"C^V+#_GO_XXW^%0?V!:_P#/2;\Q_A1_
M8%K_`,])OS'^%%J7=A?$=D3_`-L6'_/?_P`<;_"C^V+#_GO_`..-_A4']@6O
M_/2;\Q_A1_8%K_STF_,?X46I=V%\1V1/_;%A_P`]_P#QQO\`"C^V+#_GO_XX
MW^%0?V!:_P#/2;\Q_A1_8%K_`,])OS'^%%J7=A?$=D3_`-L6'_/?_P`<;_"L
MO5CI]XIFAF`N`/[C8<>AXZ^_^1=_L"U_YZ3?F/\`"C^P+7_GI-^8_P`*QQ&&
MPV(ING4NTQ-XA]$<ZKR73Q13SE8XQM!;)"#Z?Y[5T=K?:7:0+##+A1U.QLD^
MIXI/[`M?^>DWYC_"C^P+7_GI-^8_PKCP&64,)>3DY2?7R[=0_?K9(G_MBP_Y
M[_\`CC?X4?VQ8?\`/?\`\<;_``J#^P+7_GI-^8_PH_L"U_YZ3?F/\*]*U+NQ
MWQ'9$_\`;%A_SW_\<;_"C^V+#_GO_P".-_A4']@6O_/2;\Q_A1_8%K_STF_,
M?X46I=V%\1V1/_;%A_SW_P#'&_PH_MBP_P">_P#XXW^%0?V!:_\`/2;\Q_A1
M_8%K_P`])OS'^%%J7=A?$=D3_P!L6'_/?_QQO\*/[8L/^>__`(XW^%0?V!:_
M\])OS'^%']@6O_/2;\Q_A1:EW87Q'9$_]L6'_/?_`,<;_"C^V+#_`)[_`/CC
M?X5!_8%K_P`])OS'^%']@6O_`#TF_,?X46I=V%\1V1/_`&Q8?\]__'&_PH_M
MBP_Y[_\`CC?X5!_8%K_STF_,?X4?V!:_\])OS'^%%J7=A?$=D3_VQ8?\]_\`
MQQO\*/[8L/\`GO\`^.-_A4']@6O_`#TF_,?X4?V!:_\`/2;\Q_A1:EW87Q'9
M$_\`;%A_SW_\<;_"C^V+#_GO_P".-_A4']@6O_/2;\Q_A1_8%K_STF_,?X46
MI=V%\1V1/_;%A_SW_P#'&_PH_MBP_P">_P#XXW^%0?V!:_\`/2;\Q_A1_8%K
M_P`])OS'^%%J7=A?$=D3_P!L6'_/?_QQO\*/[8L/^>__`(XW^%0?V!:_\])O
MS'^%']@6O_/2;\Q_A1:EW87Q'9$_]L6'_/?_`,<;_"C^V+#_`)[_`/CC?X5!
M_8%K_P`])OS'^%9VJV$5CY7E,YWYSN([8]O>JC&G)V39,ZE>$>9I'2(ZR1JZ
M'*L`0?:G5!9?\>-O_P!<E_E4]8O<ZHNZ3"L3Q#_R[?\``OZ5MUB>(?\`EV_X
M%_2KI?&C'$_PG_74U++_`(\;?_KDO\JGJ"R_X\;?_KDO\JGJ'N:P^%!1112*
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*Q/$/_+M_P+^E
M;=8GB'_EV_X%_2M*7QHPQ/\`"?\`74U++_CQM_\`KDO\JGJ"R_X\;?\`ZY+_
M`"J>H>YK#X4%8GB'_EV_X%_2MNH+BS@N]OGQ[MN<<D8S]*J$E&5V16@YP<49
MMOK=M%;11LDI*(%.`.P^M2?V_:_\\YOR'^-3_P!CV'_/#_Q]O\:/['L/^>'_
M`(^W^-7>GV9DHXA*UT0?V_:_\\YOR'^-']OVO_/.;\A_C4_]CV'_`#P_\?;_
M`!H_L>P_YX?^/M_C2O2[,=L1W1!_;]K_`,\YOR'^-']OVO\`SSF_(?XU/_8]
MA_SP_P#'V_QH_L>P_P">'_C[?XT7I=F%L1W1!_;]K_SSF_(?XT?V_:_\\YOR
M'^-3_P!CV'_/#_Q]O\:/['L/^>'_`(^W^-%Z79A;$=T0?V_:_P#/.;\A_C1_
M;]K_`,\YOR'^-3_V/8?\\/\`Q]O\:/['L/\`GA_X^W^-%Z79A;$=T0?V_:_\
M\YOR'^-']OVO_/.;\A_C4_\`8]A_SP_\?;_&C^Q[#_GA_P"/M_C1>EV86Q'=
M$']OVO\`SSF_(?XT?V_:_P#/.;\A_C4_]CV'_/#_`,?;_&C^Q[#_`)X?^/M_
MC1>EV86Q'=$']OVO_/.;\A_C1_;]K_SSF_(?XU4U/21"IGME/E@?,G7;[_3_
M`#],R""2YD\N)0SXR!D#/YUI&G3DKHYYUJ\)<K-[^W[7_GG-^0_QH_M^U_YY
MS?D/\:R_['O_`/GA_P"/K_C1_8]__P`\/_'U_P`:?)2[A[;$=OP-3^W[7_GG
M-^0_QH_M^U_YYS?D/\:R_P"Q[_\`YX?^/K_C42QBSN@E[;EEQRN<<>H(-'LZ
M;V!UZZ^+3Y&S_;]K_P`\YOR'^-']OVO_`#SF_(?XU+%IFFS1K)'$&1AD$.W^
M-._L>P_YX?\`C[?XUE>GV9O;$/JB#^W[7_GG-^0_QH_M^U_YYS?D/\:G_L>P
M_P">'_C[?XT?V/8?\\/_`!]O\:+TNS';$=T0?V_:_P#/.;\A_C1_;]K_`,\Y
MOR'^-3_V/8?\\/\`Q]O\:/['L/\`GA_X^W^-%Z79A;$=T0?V_:_\\YOR'^-'
M]OVO_/.;\A_C4_\`8]A_SP_\?;_&C^Q[#_GA_P"/M_C1>EV86Q'=$']OVO\`
MSSF_(?XT?V_:_P#/.;\A_C4_]CV'_/#_`,?;_&C^Q[#_`)X?^/M_C1>EV86Q
M'=$']OVO_/.;\A_C1_;]K_SSF_(?XU/_`&/8?\\/_'V_QH_L>P_YX?\`C[?X
MT7I=F%L1W1!_;]K_`,\YOR'^-']OVO\`SSF_(?XU/_8]A_SP_P#'V_QH_L>P
M_P">'_C[?XT7I=F%L1W1!_;]K_SSF_(?XT?V_:_\\YOR'^-3_P!CV'_/#_Q]
MO\:/['L/^>'_`(^W^-%Z79A;$=T0?V_:_P#/.;\A_C1_;]K_`,\YOR'^-3_V
M/8?\\/\`Q]O\:/['L/\`GA_X^W^-%Z79A;$=T0?V_:_\\YOR'^-']OVO_/.;
M\A_C4_\`8]A_SP_\?;_&C^Q[#_GA_P"/M_C1>EV86Q'=$']OVO\`SSF_(?XT
M?V_:_P#/.;\A_C4_]CV'_/#_`,?;_&C^Q[#_`)X?^/M_C1>EV86Q'=$']OVO
M_/.;\A_C1_;]K_SSF_(?XU/_`&/8?\\/_'V_QH_L>P_YX?\`C[?XT7I=F%L1
MW1!_;]K_`,\YOR'^-9VJW\5]Y7E*XV9SN`[X]_:MC^Q[#_GA_P"/M_C1_8]A
M_P`\/_'V_P`:J,J<7=)DSIUYQY6T3V7_`!XV_P#UR7^53TU$6.-40850`![4
MZL7N=459)!1112&%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!6#J>F&!
MC=6H(4'<RK_#[CV_E_+>HJH3<7=&=2FJBLS-TS4Q=J(I2!.!_P!]^_UK2K!U
M/3#`QNK4$*#N95_A]Q[?R_E<TS4Q=J(I2!.!_P!]^_UJYP37-'8RIU'%^SJ;
M_F:55KVRCO8=C\,/NL.JFK-%9IM.Z.B45)69S5O<3Z/=-#,I,9/S*._^T*Z*
M*5)HUDC8,C#((J&]LH[V'8_##[K#JIK#M[B?1[IH9E)C)^91W_VA6K2J*ZW.
M5-T'9_#^1TM%,BE2:-9(V#(PR"*?6)U[A1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!6#J>F&!C=6H(4'<RK_#[CV_E_+>HJH3<7=&
M=2FJBLS-TS4Q=J(I2!.!_P!]^_UK2K!U/3#`QNK4$*#N95_A]Q[?R_E<TS4Q
M=J(I2!.!_P!]^_UJYP37-'8RIU'%^SJ;_F:55KVRCO8=C\,/NL.JFK-%9IM.
MZ.B45)69S5O<3Z/=-#,I,9/S*._^T*Z**5)HUDC8,C#((J&]LH[V'8_##[K#
MJIK#M[B?1[IH9E)C)^91W_VA6K2J*ZW.5-T'9_#^1TM%,BE2:-9(V#(PR"*?
M6)U[A1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!6#J
M>F&!C=6H(4'<RK_#[CV_E_+>HJH3<7=&=2FJBLS-TS4Q=J(I2!.!_P!]^_UK
M2K!U/3#`QNK4$*#N95_A]Q[?R_E<TS4Q=J(I2!.!_P!]^_UJYP37-'8RIU'%
M^SJ;_F:55KVRCO8=C\,/NL.JFK-%9IM.Z.B45)69S5O<3Z/=-#,I,9/S*._^
MT*Z**5)HUDC8,C#((J&]LH[V'8_##[K#JIK#M[B?1[IH9E)C)^91W_VA6K2J
M*ZW.5-T'9_#^1TM%,BE2:-9(V#(PR"*?6)U[A1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!6#J>F&!C=6H(4'<RK_#[CV_E_+>HJH3
M<7=&=2FJBLS-TS4Q=J(I2!.!_P!]^_UK2K!U/3#`QNK4$*#N95_A]Q[?R_E<
MTS4Q=J(I2!.!_P!]^_UJYP37-'8RIU'%^SJ;_F:55KVRCO8=C\,/NL.JFK-%
M9IM.Z.B45)69S5O<3Z/=-#,I,9/S*._^T*Z**5)HUDC8,C#((J&]LH[V'8_#
M#[K#JIK!BN+K1[AHF4%2<E3T/N#_`)_2MK*HKK<Y$WAW9ZQ_(Z>BHK>XCNH1
M+$V5/Y@^AJ6L&K'6FFKH****!A1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110!S+>)+HL=L4(7/`()./SI/^$CO/^><'_?)_P`:EU;23;L;NT!"@[F5
M>J'U'M_+^5[2-4^W(8I1B=!DD#AAZU\I36->(>'K5W&732Z?IL9ZWLV9G_"1
MWG_/.#_OD_XU0$[RW)=(PC?>`C!&W'.1Z5VU<Q9_\C0W_763^35U5%C,%6I-
MUG)2DDU:VE_F34IJ2LS5TS4Q=J(I2!.!_P!]^_UK2K!U/3#`QNK4$*#N95_A
M]Q[?R_E<TS4Q=J(I2!.!_P!]^_UKZ:<$US1V(IU'%^SJ;_F:55KVRCO8=C\,
M/NL.JFK-%9IM.Z.B45)69RT<ESI%X58?[R]G'J/\:Z2WN([J$2Q-E3^8/H:C
MO;*.]AV/PP^ZPZJ:Y^.2YTB\*L/]Y>SCU'^-;:55YG&G+#RL]8O\#J:*BM[B
M.ZA$L394_F#Z&I:P:L=B::N@HHHH&%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4C,$4LQ`4#))/`%+6!XCN)5,5N-RQ,-Q/9CGI^']17)C<4L+0=5J]A-V17U'
M49=3G%I:*QB)P`.KGU/M_P#K/M9_<:!:_P`,M[(/R_\`K?S_`)0VEW9:;I_F
MPD37<@P<C&T^GT'Z_P`F:=ITNISF[NV8Q$Y)/5SZ#V__`%#V^;A.I.HI1:G7
MG]T%_G^7YQ^9IZ7JZWW[J4*DXY`'1A[5F6?_`"-#?]=9/Y-4NK:2;=C=V@(4
M'<RKU0^H]OY?RJZ.TDVMI*V68EF<@>H//YFJK5L1[>CA\0O>C):]U?<&W=)G
M65@ZGIA@8W5J"%!W,J_P^X]OY?RWJ*^OA-Q=T%2FJBLS-TS4Q=J(I2!.!_WW
M[_6M*L'4],,#&ZM00H.YE7^'W'M_+^5S3-3%VHBE($X'_??O]:N<$US1V,J=
M1Q?LZF_YFE5>[LX;V,)*#P<AAU%6**S3:U1T-)JS.9_TG1;S^\C?DX_H:Z&W
MN([J$2Q-E3^8/H:+BWCNH3%*N5/Y@^HKGO\`2=%O/[R-^3C^AK;2HO,Y=<._
M[OY'345%;W$=U")8FRI_,'T-2U@U8ZDTU=!1110,****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"HKBVANHO+F0.F<X/K4M%3*,9)QDKI@8:>&XEG#/.S1`YV;<$CTSFMM
M5"*%4`*!@`#@"EHK##X.AAK^QC:XDD@ID<4<*[8HT12<X50!FGT5T65[C"BB
MBF`5@ZGIA@8W5J"%!W,J_P`/N/;^7\MZBJA-Q=T9U*:J*S,W3-3%VHBE($X'
M_??O]:TJP=3TPP,;JU!"@[F5?X?<>W\OY7-,U,7:B*4@3@?]]^_UJYP37-'8
MRIU'%^SJ;_F:517%O'=0F*5<J?S!]14M%9)V.AI-69S/^DZ+>?WD;\G']#70
MV]Q'=0B6)LJ?S!]#1<6\=U"8I5RI_,'U%<]_I.BWG]Y&_)Q_0UOI47F<NN'?
M]W\CIJ*BM[B.ZA$L394_F#Z&I:P:L=2::N@HHHH&%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`5@ZGIA@8W5J"%!W,J_P`/N/;^7\MZBJA-
MQ=T9U*:J*S,W3-3%VHBE($X'_??O]:TJP=3TPP,;JU!"@[F5?X?<>W\OY7-,
MU,7:B*4@3@?]]^_UJYP37-'8RIU'%^SJ;_F:517%O'=0F*5<J?S!]14M%9)V
M.AI-69S/^DZ+>?WD;\G']#70V]Q'=0B6)LJ?S!]#1<6\=U"8I5RI_,'U%<]_
MI.BWG]Y&_)Q_0UOI47F<NN'?]W\CIJ*BM[B.ZA$L394_F#Z&I:P:L=2::N@H
MHHH&%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`5@ZGIA@8W
M5J"%!W,J_P`/N/;^7\MZBJA-Q=T9U*:J*S,W3-3%VHBE($X'_??O]:TJP=3T
MPP,;JU!"@[F5?X?<>W\OY7-,U,7:B*4@3@?]]^_UJYP37-'8RIU'%^SJ;_F:
M517%O'=0F*5<J?S!]14M%9)V.AI-69S/^DZ+>?WD;\G']#70V]Q'=0B6)LJ?
MS!]#1<6\=U"8I5RI_,'U%<]_I.BWG]Y&_)Q_0UOI47F<NN'?]W\CIJ*BM[B.
MZA$L394_F#Z&I:P:L=2::N@HHHH&%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`5A:EI3Q2?:+-6QG)1.JGU'^>/Y;M%5&;B[HSJ4XU%9G.+
MKUV%`*Q$@=2IY_6E_M^Z_P"></Y'_&NBHJ_:1_E,O8U/YSG?[?NO^></Y'_&
MH;C5IKJ$Q2Q0E3['(/J.:ZBBFJD5]D3H5&K.?X'*Z7/-%?1K%DB1@K+C.1Z_
MA75445$Y\[O8THTO9QM>X4445!L%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
40`4444`%%%%`!1110`4444`?_]E1
`

#End
