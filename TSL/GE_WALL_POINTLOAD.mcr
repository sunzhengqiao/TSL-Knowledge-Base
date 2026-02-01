#Version 8
#BeginDescription
v1.13: 03.nov.2013: David Rueda (dr@hsb-cad.com)
Creates point load on selected wall(s), with a given number of studs to be created.

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 13
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
* v1.13: 03.nov.2013: David Rueda (dr@hsb-cad.com)
	- Stickframe path added to mapIn when calling dll
* v1.12: 26.mar.2013: David Rueda (dr@hsb-cad.com)
	- Beam width, height, grade and material set from defaults editor
	- Added color restriction for new beams
* v1.11: 05.ago.2012: David Rueda (dr@hsb-cad.com)
	- Description added
* v1.10: 23.jan.2012: David Rueda (dr@hsb-cad.com)
	-Problem of splitted top plates solved
* v1.9: 19.jan.2012: David Rueda (dr@hsb-cad.com)
	- Set created studs properties from any adjacent stud that is not part of an assembly
* v1.8 _RL_March 22 2011_Will stay within wall
* v1.7 Bug Fix on element construction
* v1.6 Adapted for plate with Id 31
* v1.5 Redesigned with faster easier functionality (No author, asume Randy)
* v1.4 Will display Red if on opening (No author, asume Randy)
* v1.3 Insert has changed (No author, asume Randy)
* v1.2 Should not recalc on DWG in. (No author, asume Randy)
* v1.1 Added a check for top and bottom plates (No author, asume Randy)
* v1.0; (No author, asume Randy)
*/

Unit(1,"inch"); // script uses inch

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

int arNumberBm [] = {1,2,3,4,5,6};
PropInt pBm (0,arNumberBm,T("Number of Beams in Point Load"));

PropString sBmLumberItem(2, sLumberItemNames, T("|Lumber item|"),0);

PropInt nColor (1,2,T("Color for new Beams"));

String arDisplay[] = {T("Identify with Text"),T("Mark Location with an X")};
PropString pDis (0,arDisplay,T("What display to use"),1);

PropString pDisplay (1,_DimStyles, T("DimStyle"));

PropDouble pTextOff (0,U(7),T("Offset text from wall"));

//Display, use Dim
Display dp(-1);
dp.dimStyle(pDisplay);

// bOnInsert
if (_bOnInsert){
	
	//showDialogOnce("_Default");
	PrEntity ssE("\nSelect a set of Walls",Element());
	if (ssE.go())
	{
		Entity ents[0]; 
		ents = ssE.set(); 
		// turn the selected set into an array of elements
		for (int i=0; i<ents.length(); i++)
		{
			if (ents[i].bIsKindOf(Wall()))
			{
				_Element.append((Element) ents[i]);
			}
		}
	}
	
	_Pt0 = getPoint("\nSelect an insertion point");
	
	/*int nQTY=getInt("\nQTY of Studs then enter"); 
	if(nQTY>6){
		reportMessage("\nThere is a maximum of 6 studs");
		nQTY=6;
	}*/ 
	
	showDialogOnce();
	
	//PREPARE TO CLONING
	// declare tsl props 
	TslInst tsl;
	String sScriptName = scriptName();

	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	Beam lstBeams[0];
	Entity lstEnts[1];
	Point3d lstPoints[0];
	lstPoints.append(_Pt0);
	int lstPropInt[0];
	lstPropInt.append(pBm);
	lstPropInt.append(nColor);

	double lstPropDouble[0];
	String lstPropString[0];
		
	for(int i=0; i<_Element.length();i++){
		lstEnts[0] = _Element[i];
		tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString );
	}
	eraseInstance();
	return;	
	
}//END if (_bOnInsert)

// check implementation requirements
if (_Element.length()==0) { eraseInstance();return;} // not attached to an element

//Assign selected element to el.
ElementWall el = (ElementWall)_Element[0];
// name your vectors
Vector3d vx = el.vecX();vx.vis(el.ptOrg(),1);
Vector3d vy = el.vecY();vy.vis(el.ptOrg(),3);
Vector3d vz = el.vecZ();vz.vis(el.ptOrg(),5);

//Check to see if it is on end of panel
Point3d ptEnds[]={el.ptEndOutline(),el.ptStartOutline()};
if(el.vecX().dotProduct(ptEnds[0]-ptEnds[1])>0)ptEnds.swap(0,1);
ptEnds[0].vis(3);
double dSizeEndCheck=pBm*U(1.5);

LineSeg lnSegEl(ptEnds[0]+el.vecX()*dSizeEndCheck/2 , ptEnds[1]-el.vecX()*dSizeEndCheck/2);
_Pt0=lnSegEl.closestPointTo(_Pt0);

double dStart=el.vecX().dotProduct(_Pt0-ptEnds[0]);
double dEnd=el.vecX().dotProduct(ptEnds[1]-_Pt0);


//Add a right click command
String strRedo="Re-Create Point Load";
addRecalcTrigger(_kContext,strRedo);


assignToElementGroup(_Element[0],TRUE,0,'E');

//This will make a display and return to drawing
int bDoDisplayOnly=FALSE;

//Make array of beams and opes
Beam arBmAll[] = el.beam();
if(arBmAll.length()==0)bDoDisplayOnly=TRUE;//If =0, quit.
//Count the amount of panhands
int nPanHandCount=0;
for(int i=0; i<arBmAll.length(); i++) {
	Entity ent=arBmAll[i].panhand();
	if(ent.bIsValid())nPanHandCount++;
}
if(arBmAll.length()-nPanHandCount<1)bDoDisplayOnly=TRUE;

//Find doubles
double dW = el.dBeamHeight();
double dT = el.dBeamWidth();
double dL = U(10);
double dBm = U(1);
//Unique value for Module creation
double dModule = abs(el.vecX().dotProduct(el.ptOrg()-_Pt0));


//For Checking
double dPLW=pBm*U(1.5);
String strBalkCode=pBm+"S";

	
//set some usefull points
Point3d ptMidBot = el.ptOrg()-0.5*dT*vz;ptMidBot.vis(1);
Point3d ptMidMid = ptMidBot +0.5*dL*vy;ptMidMid.vis(2);
double dInsert = vx.dotProduct(_Pt0-ptMidMid);
Point3d ptInsert = ptMidMid + dInsert*vx;ptInsert.vis(1);
Point3d ptTextInsert = ptMidBot + dInsert*vx;ptTextInsert.vis(1);

_Pt0=ptTextInsert;

Point3d ptLeft = ptTextInsert - 0.5*dPLW*vx;ptLeft.vis(2);
Point3d ptRight = ptTextInsert + 0.5*dPLW*vx;ptRight.vis(2);

//Display where the studs would be located
if(bDoDisplayOnly)
{
	Point3d ptR1=ptLeft-0.5*dT*vz,ptR2=ptR1+U(1.5)*vx+dT*el.vecZ();
	for(int i =0;i<pBm;i++)
	{
		PLine plRec;
		plRec.createRectangle(LineSeg(ptR1,ptR2),vx,el.vecZ());
		LineSeg ln1(ptR1,ptR2),ln2(ptR1+U(1.5)*vx,ptR2-U(1.5)*vx);
		dp.draw(plRec);
		dp.draw(ln1);
		dp.draw(ln2);
		
		ptR1.transformBy(U(1.5)*vx);
		ptR2.transformBy(U(1.5)*vx);
	}
	return;
}

//Do other display
Point3d ptText = ptTextInsert - pTextOff*vz;
PLine pl1;
pl1.addVertex(ptLeft-dT*0.5*el.vecZ());
pl1.addVertex(ptRight+dT*0.5*el.vecZ());
PLine pl2;
pl2.addVertex(ptLeft+dT*0.5*el.vecZ());
pl2.addVertex(ptRight-dT*0.5*el.vecZ());

if(pDis=="Identify with Text"){
	dp.draw(pBm+"x",ptText,_XW,_YW,0,0);
	_Pt0=ptText;
}
else{
	
	dp.draw(pl1);
	dp.draw(pl2);
	
	
	_Pt0=ptTextInsert;
}


//Set some groups
Beam bmToCheck[0];
Beam bmWrong[0];
Beam bmPlates[0];
int arNPlateTypes[]={ _kSFBottomPlate, _kSFTopPlate, _kSFAngledTPLeft, _kSFAngledTPRight, _kSFVeryTopPlate, _kTopPlate, _kBottom};
String arIdBPlates[]={"31","32","4"};
	
for(int i =0;i<arBmAll.length();i++){
	Beam bm = arBmAll[i];
	double dDist = vy.dotProduct(bm.ptCen()-el.ptOrg());

	if (arNPlateTypes.find(bm.type())>-1 || arIdBPlates.find(bm.hsbId())>-1)bmPlates.append(bm);
	
	else if (bm.type()==_kHeader)bmWrong.append(bm);
	
	else bmToCheck.append(bm);

	
}

	
if(bmPlates.length()==0){
	reportMessage("\nNo Plates found");
	return;
}
	
	
	
//Check for headers
for(int h =0;h<bmWrong.length();h++){
	//Beam bm = bmWrong[h];
	Point3d pt1a= bmWrong[h].ptCen()-0.5*bmWrong[h].dL()*bmWrong[h].vecX();pt1a.vis(3);
	Point3d pt1b= bmWrong[h].ptCen()+0.5*bmWrong[h].dL()*bmWrong[h].vecX();pt1b.vis(3);
	double dHdrSide1 =vx.dotProduct(pt1a-ptRight);
	double dHdrSide2 =vx.dotProduct(pt1a-ptLeft);
	double dHdrSide3 =vx.dotProduct(pt1b-ptRight);
	double dHdrSide4 =vx.dotProduct(pt1b-ptLeft);
	if (dHdrSide1*dHdrSide2<0||dHdrSide3*dHdrSide4<0){
		reportWarning("\nToo close to opening. Cannot position PointLoad on Opening on wall " +  el.number()); 
		dp.color(1);
		Point3d ptR1=ptLeft-0.5*dT*vz,ptR2=ptR1+U(1.5)*vx+dT*el.vecZ();
		for(int i =0;i<pBm;i++)
		{
			PLine plRec;
			plRec.createRectangle(LineSeg(ptR1,ptR2),vx,el.vecZ());
			LineSeg ln1(ptR1,ptR2),ln2(ptR1+U(1.5)*vx,ptR2-U(1.5)*vx);
			dp.draw(plRec);
			dp.draw(ln1);
			dp.draw(ln2);

			
			ptR1.transformBy(U(1.5)*vx);
			ptR2.transformBy(U(1.5)*vx);
		}
		return;
	}
}

if (nColor > 255 || nColor < -1) 
	nColor.set(-1);

if(_bOnElementConstructed || _bOnDbCreated || _kExecuteKey==strRedo){

	//Check intefering beams///////////////////////////////////////////////////////////////
	//bodies per side
	Body arBd[]={Body(_Pt0-dPLW/2*vx,vx,vz,vy,U(0.25),U(10),U(2000),1,0,1),Body(_Pt0+dPLW/2*vx,vx,vz,vy,U(0.25),U(10),U(2000),-1,0,1)};
	Body bdMain(_Pt0,vx,vz,vy,dPLW,U(10),U(2000),1,0,1);
	String arCutHandles[0];
	Beam arBmCutL[0],arBmCutR[0];
	Cut ct1(_Pt0-dPLW/2*vx,vx),ct2(_Pt0+dPLW/2*vx,-vx);
	
	for(int i =0;i<bmToCheck.length();i++){
		Beam bm=bmToCheck[i];
		
		//if(_bOnElementConstructed && _Beam.find(bm))continue;
		
		double dHalf=dPLW*0.5;
		
		if(bm.vecX().isParallelTo(el.vecY())){
			double dCheckBm=el.vecX().dotProduct(bm.ptCen()-_Pt0);
			if(abs(dCheckBm)<dHalf){
				bm.dbErase();
			}
			if((abs(dCheckBm)>dHalf) && (abs(dCheckBm)<(dHalf+U(0.75)))){
				double dMove = el.vecX().dotProduct(bm.ptCen()-_Pt0);
				double dMove1 = ((dHalf+U(0.75)-abs(dMove)));
				double dMove2;
				if(dMove<0){dMove2=dMove1*-1;}
				else{dMove2=dMove1;}
				Point3d ptBm2=bm.ptCen()-dMove2*el.vecX();
				Vector3d vMove(bm.ptCen()-ptBm2);
				bm.transformBy(vMove);
			}
		}
		else{
			Body bdBm=bm.realBody();
	
			
			if(bdBm.hasIntersection(arBd[0]) && bdBm.hasIntersection(arBd[1])){
				Beam bm2=bm.dbCopy();
				bm.addToolStatic(ct1,TRUE);
				bm2.addToolStatic(ct2,TRUE);
				arCutHandles.append(bm.handle());
				arCutHandles.append(bm2.handle());
				arBmCutL.append(bm);
				arBmCutR.append(bm2);
			}
			else if(bdBm.hasIntersection(arBd[0])){
				bm.addToolStatic(ct1,TRUE);
				arCutHandles.append(bm.handle());
				arBmCutL.append(bm);
			}
			else if(bdBm.hasIntersection(arBd[1])){
				bm.addToolStatic(ct2,TRUE);
				arCutHandles.append(bm.handle());
				arBmCutR.append(bm);
			}
		}
	}
	
	//Clean up some that were cut before and clean map
	for(int i = _Map.length()-1; i >-1; i--){
		if(_Map.keyAt(i)=="BlockL"){
			Entity ent=_Map.getEntity(i);
			Beam bm=(Beam)ent;
			
			if(!bm.bIsValid()){
				_Map.removeAt(i,0);
				continue;
			}
			
			if(arCutHandles.find(bm.handle())==-1 && bm.realBody().hasIntersection(bdMain))bm.addToolStatic(ct1,TRUE);
			else _Map.removeAt(i,0);
		}
		if(_Map.keyAt(i)=="BlockR"){
			Entity ent=_Map.getEntity(i);
			Beam bm=(Beam)ent;
			
			if(!bm.bIsValid()){
				_Map.removeAt(i,0);
				continue;
			}
			if(arCutHandles.find(bm.handle())==-1 && bm.realBody().hasIntersection(bdMain))bm.addToolStatic(ct2,TRUE);
			else _Map.removeAt(i,0);
		}	
	}
	
	//add the cut beams to the map		
	for(int i =0;i<arBmCutL.length();i++)_Map.appendEntity("BlockL",arBmCutL[i]);
	for(int i =0;i<arBmCutR.length();i++)_Map.appendEntity("BlockR",arBmCutR[i]);
}

Beam arBmToStretch[0];
arBmToStretch.append(_Beam);

if(_bOnDbCreated || _kExecuteKey==strRedo || _bOnElementConstructed ){
	
	arBmToStretch.setLength(0);
	
	//loop of all the ceated beams and Clear _Map
	Map mpStud=_Map.getMap("Studs");
	for(int i=1; i<7; i++) {
		if(mpStud.hasEntity("bm"+i)){
			Entity ent=mpStud.getEntity("bm"+i);
			ent.dbErase();
		}
		else{
			break;
		}
	}
	
	mpStud=Map();

	//Create Studs
	// Get props from ANY stud (not part of an assembly) to set them on created STUDS
	Beam bmAny;
	for( int b=0; b< arBmAll.length(); b++)
	{
		Beam bm= arBmAll[b];
		if( bm.type() == _kStud && bm.information() == "")
		{
			bmAny=bm;
			break;
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////

	// Define lumber item values
	String sBeamMaterial, sBeamGrade;
	double dBeamWidth, dBeamHeight;
	
	// Getting values from selected item lumber for SIDE POST
	int nLumberItemIndex=sLumberItemNames.find(sBmLumberItem,-1);
	for( int m=0; m<mapOut.length(); m++)
	{
		String sSelectedKey= sLumberItemKeys[nLumberItemIndex];
		String sKey= mapOut.keyAt(m);
		if( sKey==sSelectedKey)
		{
			dBeamWidth= mapOut.getDouble(sKey+"\WIDTH");
			dBeamHeight= mapOut.getDouble(sKey+"\HEIGHT");
			sBeamMaterial= mapOut.getString(sKey+"\HSB_MATERIAL");
			sBeamGrade= mapOut.getString(sKey+"\HSB_GRADE");
			break;
		}
	}
	if( dBeamWidth<=0 || dBeamHeight<=0)
	{
		reportNotice("\n"+T("|Data incomplete, check values for selected lumber item|")
			+"\n"+T("|Material|")+": "+ sBeamMaterial
			+"\n"+T("|Grade|")+": "+ sBeamGrade
			+"\n"+T("|Width|")+": "+ dBeamWidth
			+"\n"+T("|Height|")+": "+ dBeamHeight);
		eraseInstance();
	}
	///////////////////////////////////////////////////////////////////////////
	String sNewStudLabel;
	String sNewStudSubLabel;
	String sNewStudSubLabel2;
	String sNewStudGrade;
	String sNewStudMaterial;
	String sNewStudInformation;
	String sNewStudBeamCode;
	String sNewStudName;
	

	/*if(bmAny.bIsValid())
	{
		sNewStudLabel= bmAny.label();
		sNewStudSubLabel= bmAny.subLabel();
		sNewStudSubLabel2= bmAny.subLabel2();
		sNewStudGrade= bmAny.grade();
		sNewStudMaterial= bmAny.material();
		sNewStudBeamCode= bmAny.beamCode();
		sNewStudName= bmAny.name();
		sNewStudInformation= "";
	}*/ 

	Point3d ptCreate=ptInsert-(dPLW-dW)/2*vx;
	
	for(int i = 0; i < pBm; i++){
		Beam bm;
		bm.dbCreate(ptCreate,vy, vx, vz, dBm, dBeamWidth, dBeamHeight,0,0,0);
//		bm.dbCreate(ptCreate,vy, vx, vz, dBm, dW, ,0,0,0);
		bm.setColor(nColor);
//		bm.setHsbId("138");
		bm.setType(_kStud);
		bm.setModule("PL-"+dModule);
		bm.setInformation("");
		bm.setMaterial(sBeamMaterial);
		bm.setGrade(sBeamGrade);

/*		bm.setName(sNewStudName);	
		bm.setMaterial(sNewStudMaterial);
		bm.setGrade(sNewStudGrade);
		bm.setLabel(sNewStudLabel);
		bm.setSubLabel(sNewStudSubLabel);
		bm.setSubLabel2(sNewStudSubLabel2);
		bm.setBeamCode(sNewStudBeamCode);
*/ 		
		
		bm.setPanhand(el);
		bm.assignToElementGroup(el,true,0,'Z');

		mpStud.setEntity("bm"+(i+1),bm);	
		arBmToStretch.append(bm);
		ptCreate.transformBy(dW*vx);
	}
	_Map.setMap("Studs",mpStud);

}



for (int b=0; b<arBmToStretch.length(); b++) {
	Beam bm=arBmToStretch[b];
	for (int nSide=0; nSide<2; nSide++) { // loop for positive and negative side
				
		Point3d ptBm = bm.ptCen();
		Vector3d vecBm = bm.vecX();
		if (nSide==1) vecBm = -vecBm;
		Beam arBeamHit[] = bm.filterBeamsHalfLineIntersectSort(bmPlates, ptBm ,vecBm );
		// loop over the hit beams, and find the first top or bottom plate
		for (int i=0; i<arBeamHit.length(); i++) {
						
			Beam bmHit = arBeamHit[i]; // take first beam from filtered list because it is closest.
			bm.stretchDynamicTo(bmHit);
			break;
		}
	}
}

/*
//insert another TSL to set the module name
	TslInst tsl;

	String sScriptName = "_COMPONENT_CODING";

	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	Beam lstBeams[0];
	Entity lstEnts[0];
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	
	lstEnts.append(el);
	
	//tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString );	

*/ 

#End
#BeginThumbnail
M_]C_X``02D9)1@`!``$`8`!@``#__@`?3$5!1"!496-H;F]L;V=I97,@26YC
M+B!6,2XP,0#_VP"$``@%!@<&!0@'!@<)"`@)#!0-#`L+#!@1$@X4'1D>'AP9
M'!L@)"XG("(K(AL<*#8H*R\Q,S0S'R8X/#@R/"XR,S$!"`D)#`H,%PT-%S$A
M'"$Q,3$Q,3$Q,3$Q,3$Q,3$Q,3$Q,3$Q,3$Q,3$Q,3$Q,3$Q,3$Q,3$Q,3$Q
M,3$Q,3$Q,?_$`:(```$%`0$!`0$!```````````!`@,$!08'"`D*"P$``P$!
M`0$!`0$!`0````````$"`P0%!@<("0H+$``"`0,#`@0#!04$!````7T!`@,`
M!!$%$B$Q008346$'(G$4,H&1H0@C0K'!%5+1\"0S8G*""0H6%Q@9&B4F)R@I
M*C0U-C<X.3I#1$5&1TA)2E-455976%E:8V1E9F=H:6IS='5V=WAY>H.$A8:'
MB(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4U=;7
MV-G:X>+CY.7FY^CIZO'R\_3U]O?X^?H1``(!`@0$`P0'!00$``$"=P`!`@,1
M!`4A,08205$'87$3(C*!"!1"D:&QP0DC,U+P%6)RT0H6)#3A)?$7&!D:)B<H
M*2HU-C<X.3I#1$5&1TA)2E-455976%E:8V1E9F=H:6IS='5V=WAY>H*#A(6&
MAXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&Q\C)RM+3U-76
MU]C9VN+CY.7FY^CIZO+S]/7V]_CY^O_``!$(`4@!A0,!$0`"$0$#$0'_V@`,
M`P$``A$#$0`_`/1YY9!*P#'B@"/SI/[U`!YTG]Z@"*>:3S;?YC_K#_Z"U1+>
M/K^C+CL_ZZHE\Z3^]5D!YTG]Z@`\Z3^]0`>=)_>H`/.D_O4`'G2?WJ`#SI/[
MU`!YTG]Z@`\Z3^]0`>=)_>H`/.D_O4`12S2?:8/F/\7\JB7Q+YEKX62^=)_>
MJR`\Z3^]0`>=)_>H`YOXESS+X'U(I(R'$>"O!'[U*`,34+^>TN7FOKB9&69[
M>"6`A4)#$?."?]DGGBO)E3:DX0UL>C&5XJ3+1N[J,)+=R&&0*,75N<ICT8'M
M]<CZ5SO71&NVK+T>KSQ*/MK80]+B/[A'N.J_J/>L)4W]EEIKJBW))]HB`9O,
MC;!&#P?0@C^=9*<HNZ=F4XQ:LT20:E?6F%9FNX!ZD>:@]C_%^//N:]2AF'2K
M]YQ5,+U@:=IJ"7<9>WFW`'##&&4^A!Y%>I&2DKQ>AQ-.+LR7SI/[U4(/.D_O
M4`'G2?WJ`#SI/[U`!YTG]Z@`\Z3^]0`>=)_>H`/.D_O4`'G2?WJ`#SI/[U`!
MYTG]Z@`\Z3^]0`>=)_>H`/.D_O4`'G2?WJ`#SI/[U`!YTG]Z@`\Z3^]0`>=)
M_>H`/.D_O4`'G2?WJ`#SI/[U`$L,TG/S4`1S_P"N:@".@`H`AG_UMO\`]=#_
M`.@M42WCZ_HRX[/^NJ)JL@*`"@`H`*`"@`H`*`.+UCQ'J5IJ5S##*@CB<A1Y
M8/%?8X;*L+4PT:DHZM7W9\QBLQQ%*O*G%Z)]D;_AG6!K>F)>*GE[N,5\<?3H
MU:`(9?\`CY@_X%_*HE\2^9:^%DU60%`!0!YYXKU2ZNTO].NG#VF\@H%`.%;(
MYZ]0*^QAE.%>%51QUY;[O>Q\O6S+$0Q#IIZ)VV7<IWU^-2T>"["[!-?2/CTS
MYA_K7PF'TQ;]#[5?PD5;6^N=-!:T<!,C,3\H<GMZ?A7;B,)3JINUF2JCAL:T
M%R\$J(I\B]N!O2U"_N6'<AC]>2,'V->"XW5^BZG2G;U))M2:QD(MD\F7)\R+
M<&C/N/0_3'O7T^5\-/&05;$NT7M;=_Y(\#,<[CA9.E15Y=>R_P""59-<OB_-
MR$)Z*`!7U$>'<J@N5TT_5N_YGSLLZQ\W=3MZ)?Y$L&M3K*KS9WJ,"6/Y)`/3
M/0CV/%>?B^%Z<4YX&3C+L]4_\CLPV?U+J.*7,N^S1U.FZ\)(0]R`\?\`SWB4
M\?[Z]1]1D?2OD%B>2;I5ERR6A]/[)3@JE)WBS9C=)(UDB=71AE64Y!^AKK,3
MD_$'B.\MM3DM[&15CBPIR@.6[]?RKZ[+LHH5,/&I66KUW>W0^;Q^95:59PI/
M1?F6/#?B5[Z[%C>`";;N5P,!A]*\7-,''"5^6"]UJZ/2R[%/$TKSW1TU>6>D
M<OXIUJ^T[45AM)51#&&P4!YR?6OJ,JR[#XFASU%=W?5G@9ECJV&JJ--Z6[&1
M_P`)3JW_`#W3_OTO^%>K_8F"_E?WL\S^UL5_-^")(?%FIQMF0Q2KZ,F/Y5E4
MR+"R7NW3]?\`,N&<8B+UL_E_D=+HNOVVI_)CRIP.4)_E7RN-P-3!3Y9ZI[/N
M?1X3&0Q4+QT:W1K5PG8%`!0`4`%`!0`4`%`!0`4`%`!0`4`2P=Z`$G_US4`1
MT`%`$,_^MM_^NA_]!:HEO'U_1EQV?]=4359`4`%`!0`4`%`!0`4`>:^(_P#D
M,7P'_/1J_1<$KX."7\I\/CO]ZGZDGAC6Y]$T6*T2W1I!RQ<G`]N*\+#</MQ3
MKRL^R_S/7KYTHOEI1OYLWM/\81NX2_@$(/\`RT0Y`^H-88[)'AX.I2E=+=/<
MUPF;JK-0J*S?4W+J[@B$-T\@$*JS%O;%?/TZ4ZU6%."NV>Y*<:=.4Y.R1SMU
MXSDWD6EH@0'@R$DG\!TKZREP]&W[R;OY?\$^;JYV[_NX:>86WC.0.!=6B;?6
M-B"/P-*MP\K7I3U\_P#@!2SMW_>0T\CIK"^M[^`36SAE_45\M4A*E)PDK-'T
M-.<:D5.+T9YQX@!;4+]5&29'`'YU^AT8N6"BE_+^A\3B7;%R;_F_4IVBM'HU
MM92+AHI#(6![G=Q_X]7SV$X;Y9^UK3U[+I\SW:^?\JY*,-%U?^1#>*4@8@9`
M(SCMR*>.RJ="FYTW=?B;83.85W[.HN5O[C3UH)+<6.0&7[+GU'45\[D%!5J[
M@]KZ_B>UF5;V%!U%ND9.L74MO:_N.9YG")]3WK[O-L8\%AG*&C>B\CX7+\.L
M5749[;L?I'AR,NWVB-KN=`?M$<QV,AZ\$]?Y>]?E]7%RJ/GYOGN?H-&A",;1
M6G8MW4=M:6OF6;331C_ED1ET_#T]^1[U]7E'$"HTG3Q;;:V>^G_`/G\SR;VL
MU4PR2OOT+'@N\N9-4F7[/)#"R@E7/(/KBOG,]Q%'%UO;4U:YZ^48>KA:7LIN
MYUDSG3XY;JUD,!4;F7JCGW7IGW&#7'E/M:^)AAXZIO[EU_`[,=[.E1E6ET1P
M6I7WD/&\GS//*%/OD\FOUO%8J&#C!/9M+Y?\`_.,/AYXN<N]F_F3K.UE=P7B
M<-`X)_W3P:XL[P_M</SK>.ORZG3E5?V.(Y7M+3_(]4MIEGMXY4.5=017PQ]@
M<7XY_P"0PG_7%?YFON,A_P!U^;/D\Z_CKT_S.?\`"&A6>M:YJ"WH9@C<`-CM
M7S&92DL74L^I[F717U6&G3]3JKKP3:V\#-ITDB,HSL9L@U>7YA5PU5)RO'JA
MXO!4\1!Z6ET9R;W$EEBZB)5X#OX]NH_*OK,WH*MA)/JM5_7H?,9=5='$Q\]&
M>HZ7=K>V$-PG210:_/S[8LT`%`!0`4`%`!0`4`%`!0`4`%`!0!+!WH`2?_7-
M0!'0`4`0S_ZVW_ZZ'_T%JB6\?7]&7'9_UU1-5D!0`4`%`!0`4`%`!0!YMXA.
M-:O3Z2&OT;`/EPE-^2/A\?\`[U/U*W@?PPNOQR:EJ4LA4L?+56(V_2O@JV*J
MUJCJ.3OZ[>A]?0PU.E34%%?YCM7M5M+RYME)98R5!/I7W^'FZV$C*6[CK]Q\
M=BH*CB91CLF7-/EGO/`UMDES&YS_`+HKXW)JD*>,BI=4TO4^JS*$IX.7+Y,P
MKBPANKF*2Y:0Q1]8E;`;_P"O7U.8Y=+&6<9N-NG0^:P.-6%O>"=_O-2:TTTV
MH329I+27/W;@;E_.O+A0S/`0<:=I+[[>B/2G6P&,DG4O%_<=)X*T2]TPR375
MXDZS`'"8Q^E?-XBM4K5'.K\7W'NT*5.C!1I[?><UKK"/4[YST65S^IK]!P\^
M3"1D^D5^1\7BUS8F:\_U.9M-/EO;./4[J:3=+/L4!B-HPQX_*OSQXVK7Q5Y2
M=]]]O0^YH8*E2HJ*BK?F;,0/E*'.XXP2>]?H.`K/$8=2GOLSXO,L/'#8AQAM
MNBK8W+23^0QR;='C'TW#%?+Y/1CA\RJ07F>_CZLJV6QF]]`OUSJ&E<<"Z&?R
M-=G%*?U5/S_0\S(W^_DO+]3O-?MXIM!E$B`D:@`&'!`)&<&ORO`:XJ*>UOT/
ML)-I71CRW"I$!J*"6*,?+/&-KQCZ#^GY5[E3!35Y4M32.)CHJA)%<++#YY4S
MV:?ZN[C(21?P'/XC&?0UP./3KV.J_7H,U>^=[1(!<)<(YW!UX;`[-VSGZ=.E
M?9\)X!*<\4UY+]3YCB+%VIQPZ>^K_0YR&V^V>(;<7*[+2!<EG^ZQ/6NKB*EB
M\1-1HTVTET75G)DE3#T8N56:3??LC3U.*!;J1(&5X6Z;3Q@]J^BRV56M@H+$
MQ:E:S3^[\3Q\PC3IXJ3H23C>ZL=1X`U-;BP;3Y)`;BU.W:>I7L:^$Q-%X>M*
MD^C_`.&/KL/65:E&HNIG^.?^0PG_`%Q7^9K['(?]U^;/FLZ_CKT_S*7PT_Y#
MVJ?[W]!7R^9?[W4]3W<N_P!UAZ?J>BUP+<[SR34R/(NCVVO_`"-?I.)TPL[_
M`,K_`"/@J?\`O"MW_4[OP`[/X7M"QY"U^:GWIT%`!0`4`%`!0`4`%`!0`4`%
M`!0`4`2P=Z`$G_US4`1T`%`$,_\`K;?_`*Z'_P!!:HEO'U_1EQV?]=4359`4
M`%`!0`4`%`!0`4`>:^)/^0Q??]=&K]%P?^Y0_P`/Z'Q&._WN?J;_`,,/^18B
M^IK\Y6Q]NC!\2?\`(9O?]\U^BX'_`'*'^$^(Q_\`O4_4N>#KRWL?"MK)=H[Q
M,[H0HSU%?"X3!5,94Y:;2:UU/KZ^*AA:7--.SML4C8PW]T1I=P8&8_+#<`$'
MZ$5[U:OF&6<JG)3CZ?KN>-2I8+'M\L>5_P!="&[TZ^T]MM_%&F?NE'SG\*]7
M+<REC;IPM;KT//Q^7QPB34KWZ=2[X1U>:W\0)IP8M#+'NV_W3FO`SZ$8XE..
M[6IZV2RDZ+3V3T*FNJ'U.^0]&E<?J:^JP\.?"1CWBOR/`Q;Y<3-^?ZF?:YC\
M/6MLXVR179!'_`7P:_-OJ]3#XYTYJS_K8^_P]>%;#J<'I^1-]U0#Q@<U^C9?
M2=##I3T>Y\/FM>-?$MPU2T,71G+WLUP/NR%R/<;J^.P^+4<=*NMK_@[GU4<+
MSX-4'V_'_AS6EC$H1E/S1N)$/N*^OQ^$AF.%=-/?5,^/P]6>"Q',UJM&CJ+C
M5+>Z\/,K2!)S>K(8SUVY'/TK\NH9#F&'QL4Z3:2W6WWGUZS+"SI\W.EZ[F)>
MSB9@J?=7]37Z9E>`>$IMS^)[_P"1\QF6-6)FE#X484&I32ZV#:$!(<A7(W!B
M,=0>#CMWKY+,HT<5BY1IK1::::]SZ;*8U:5!.;U>NO1&OJ%V9#)<W&U2JY;:
M,#@<U]E@\/#+L&H=(J[_`#9\KC:\L;BG)=79?D9D6J/+")DL+GRC_'QC_P"M
M7DOB7#IVY7^'^9WK(*_\R_$M0RSN^);*>!<9#MC!_*NS`YW0QM7V4$T_,YL7
ME-;"4_:2::\BQISQV^LP/*O[N;Y">A5NQ![&O!XJPLH\N)IZ/9_H>KP]B%>6
M'GZK]34\3>9]N3S9FF/EC#.!G&3UQU^M>GPO5E5P/-+>[.3B"FJ>*279?J0^
M`)8['6=0EO'6".0_(SG`;CM7EX_!8F>*G*%-M-G=@,50AAX1E-)G6:QXDL;>
MTD6UG6>=E(0)R!GN358'**]2JG5CRQ7<K%9G1IP?)*\NECS36Y2MIY$?,MR?
M+4=_<U[^<XE4<,X=9:?YG@Y70=;$)](ZGJ?A>S-AH=K`PPRH,BOA#[,U*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`E@[T`)/_`*YJ`(Z`"@"&?_6V_P#UT/\`Z"U1
M+>/K^C+CL_ZZHFJR`H`*`"@`H`*`"@`H`\[\5V5]'JUPT-E+<+,2P:/H,U]1
M0SJE2H1I.+NE;H?/XC*:E6M*HI+5^9T'P]LY['P]'#=1F.0'[IKY<^@.?\66
M=]'J\[0V4MPDI+!H^@KZC#YU2HT(TG%Z*W0^?Q.55*U:5122OZFCX5T:0^'+
M>QOHS&[%S@]CCBOFJ5>>'K1J4W9JY[TZ4:M*5.:T=C&U+2]0TZ5@]I+(@Z/%
MSFOK:7$%*4;58-/RU1\U5R6I%WI25O/0S'DU"5MMMIES)(>AD&T"BKG]&,;4
MH-OST%3R6K)_O))+[SIO`GA:ZL[M]4U8_P"DO]U?[HKY6O6G7FZDWJSZ.C1A
M0@H06B,GQU%=Z7+>W`@D:-R6$J=$+'`SGW(KZ&.=PAAU2C%J25KZ;V/$J93.
M==U')6;O;78S99KFRM4DU"U<$NT>8QGY@2#QVZ&KPW$5&;Y*T7S+L37R*JO>
MHRT?<RM0O[N]C:"T@>&-N&D?J1[>E88_-YUX.G15EU?4WP>3^QE[2J[M=.AN
M7%@FG)8PQCK;%C]217S&`GSRF_0^HG'E21##%<2:C:6MIM)NI?+VMTSM9LCT
M^[7M+-JN6TG/>*Z?Y'D8W+J6*U>DNY-?)?6(<SZ=,0DGE%E((W5Z%#BS#5K)
M0=WZ'ARR*JMIJWS,RY&K7L+K'!]DB"DLQ.6(_I7/B\ZK5XN%-<J_$[,-E%.C
M+FJ/F?X&A_9T.DV>FF,%F>%W;'<_)7AY57C'%.<U=(]_%492H<E-V;1GSRW&
MJLNGVMI*KSOMR<8P.3_*OH\PS=8B@Z4(M7[GSN$RB>'JJI.2:1Z78^&EL]-A
M2Q<0RJ@W1OS&Y[^ZGW'Y5\E5P\:FNS/HZ=:5/3H8=Y$\4TUK'$MILR)5E;]R
MQQG"'UP0>,>XKGPU:6"Q,:CU<7?3>W_!-:L88FE*GW1RMS<SR'R!8SK,?FC)
MP,D'J/45]?CL\PN,P\J3B]?31_>?,87)\1AJT:BDM/4V-4NKB9+9VM)?/,80
MQ8P21W!Z'^=<&39U1R[#NC.+>K=U;J=V:975QM55(M+2VI1W7O\`T"[G]*]G
M_6K"_P`K_#_,\G_5[$?S+\2.:341Q'IDJ#^_*<*OUQ6<^*:+TI1U\V7#A^HM
M9RT\D=%X3\&3O>1ZIK,BR/C,:KRH'M[5X6(Q%3$S]I4=V>U0P]/#PY*:T/0`
M,#`X`KG-PH`*`"@`H`*`"@`H`*`"@`H`*`"@"6#O0`D_^N:@".@`H`AG_P!;
M;_\`70_^@M42WCZ_HRX[/^NJ)JL@*`"@`H`*`"@`H`*`#%`!0`8H`AE_X^8/
M^!?RJ)?$OF6OA9,0.A%60(%4=%`_"@!:`.:^)G_(CZE_VR_]&I0!@^*/]1_W
M$9OYRURX?_>V=O\`RZ1@3@"$X&.1_,5Z\_A9E+8U->_X^+'_`*]?ZBO+RW[9
MO5Z$.A_\C1HG_7Y_[3DJ\V_W.?\`74P?0[+7O^01<_\`83'\Q7S.6_[U#T_0
M4_A.=OO^/*?_`*YM_*OK3G*FL?\`'OI/_7NW\HZY,O\`XL_ZZGH3^&)+X2_Y
M&:P_WI/_`$6]>E5^$YI['I5<IB8]Y#%/;ZA#/&LD;ZA;AE89!'[FOF<R;CB[
MK^7]&;0^$QM:TS[,E_=<WMM;3)$EK,QRNY4Y#=SE^_('0U.&KRJ2C3ZOK]_^
M1NJMOBU*EF"]IY:R)?QK]^&08DC]AGGC_:Y]Z[9Q<)6:LS>+36CN7+2ZD0$0
M,;A$^]#+Q-'^?7\?SKGG33\OR-%*QH6US#<`^2V&7[R,-K+]1U%<\HN.YHFG
ML.C22U<O8R>22<M&>8V_X#V/N/UKJH8NI2TW1A4H1GKLR_:ZI%(ZPW*_99V.
M%5CE7_W6Z'Z<'VKV:.(IUE[KU['GU*4J>Y?KH,@H`*`"@`H`*`"@`H`*`"@`
MH`*`)8.]`"3_`.N:@".@`H`AG_UMO_UT/_H+5$MX^OZ,N.S_`*ZHFJR`H`*`
M"@`H`*`"@`H`*`"@`H`AE_X^8/\`@7\JB7Q+YEKX6359`4`%`'-?$S_D1]2_
M[9?^C4H`PO$_^I_[B,W\Y:Y</_O;.W_ETCG[C_4GZC^8KUY_"S*6QJ:]_P`?
M%C_UZ_U%>7EOVS>KT(=#_P"1HT3_`*_/_:<E7FW^YS_KJ8/H=EKW_('N?^PF
M/YBOF<M_WJ'I^@I_"<[??\>4_P#US;^5?6G.5-8_X]])_P"O=OY1UR9?_%G_
M`%U/0G\,2;PE_P`C-8?[TG_HMZ]*K\)S3V/2:Y3$RI?NWO\`V$;?_P!HU\QF
M?^]?]N_HS:'PE;7O^07K'_7Y!_*&N?`?[S2_KN.6S.:NE'E-*I*2QJ2KJ<,.
M/7^E?83A&:M)&,9.+NC8N=,N%MH9YE:X78&$\`VRQY'=1U'T_*O,J85QUIZ^
M1V0Q">DRHQ;:LLN9T'W+JW^5T^H']/RKC:Z?@=/F6X+^1(U>;%S`>D\(Z#_:
M7^H_*L)4OY2U+N75:&Z@RI2:%QVPRFL-8OLR]&A\$UU98$+?:(1_RQE;!4?[
M+?T/YBO2HX^4=*FJ_$Y*F%3UAH:5G?07>1$Q61?O1.-KK^'I[CBO7A4C45X.
MYP2A*#M)%FK)"@`H`*`"@`H`*`"@`H`*`)8.]`"3_P"N:@".@`H`Y'Q=J=[9
MZI'';7#QH(PP`QUY&?RKZO*,!AL1A^>K!-W9\[FF,KT*JC3E9-#O#OB:66YC
ML]0;<7SLE/!)]#7GYO@%A:BG35HO\&=65XUXB+A4?O+\4=3,2L$C*<$*2/RK
MR*23J13[H]:3M%GG;>+-3L=L\UP\Z!@"C8P<\5]9FN`PU#"RG3@D]/S/F,OQ
MN(JXB,)RNM?R/0;.;S[6*4C&]0<5\>?4DU`!0`4`%`!0!7U"]AT^T>YN"P1>
MRC))["NC#8:>*J*G3W,:]:%"#J3V1S$7C3=JD=N\`1)VVQ*.2/4DUZ.99?#`
MP@D[MWN<&!QTL7.>EDMC3\77<]G8P36LABD\S&X>A%1E&'I8C$\M6-U9F^8U
MIT<-*5-V=T8&C>*;U=7@LKJ1IQ<]"V/EQ_\`KKISK#4<-*"I1M>_Z'%E.(JU
M^?VDKVL=W7@'MA0!S7Q,_P"1'U+_`+9?^C4H`PO$_P#J?^XC-_.6N7#_`.]L
M[?\`ETC`G!,>`,DE0/S%>Q)>ZTC*6S+UW-]IE1V'"($7/88']:^JP&2X;#T8
MJ<$Y6U?F?&8S-\1.M)TIVCT*^@3-_P`)II,#C&V[#*?4&-Z^-XCH_5Z=6FMM
M&O2Y]'E^)>)H1D]]GZG<Z]_R![G_`+"8_F*^/RW_`'J'I^AWS^$YV^_X\I_^
MN;?RKZTYRIK'_'OI/_7NW\HZY,O_`(L_ZZGH3^&)-X2_Y&:P_P!Z3_T6]>E5
M^$YI['I-<IB94OW;W_L(V_\`[1KYC,_]Z_[=_1FT/A*VO?\`(+UC_K\@_E#7
M/@/]YI?UW'+9G.77_'K-_P!<V_E7V1SG=V7_`!Y6_P#UR7^0J!E:]TB"XD::
M(FVN&Y,D8^]_O+T/\_>LJE&%3XD:0J2I['$+=-$T,TS&WO;T!H]A`@8<'YL_
M49)Y]*\ODO=+5+[SO4MF]V:.]X)=TO\`H4S<>:GS12'_`&@>GXX/H:P<5)=_
MS-+V\C.U+5[VWNI5-R(MI^Z"`/PS7Z-@LHRR>#A.=-.3BKZ];>I\1CLQQU/%
M3A";23_KH:N@7PUO38[J5#'(#\K*<,A]01R*_-IJ6'J>XS[:%JL/>1M0:A<V
MWRW*FZB'_+1%_>#ZKT;ZCGVKT*&/C+2IIYG+4PK6L#3MYXKF(2V\BR(>-RGO
MZ>Q]J])--71QVMH24P"@`H`*`"@`H`*`"@"6#O0`D_\`KFH`CH`*`.'\<_\`
M(83_`*XK_,U]QD/^Z_-GR>=?QUZ?YG.JX<;HGP5;AA_"P->EB*-/&494WL_P
M:_R9YM*I/"U(S6_Z'H.A:H-3T9V;B:-"LB^AQ7Y\J4J.(5.>Z:_,^XC5C5I<
M\=FCS36/^/+_`(&G_H0K[/._]SEZK\SY'*_]ZC\_R/5["6.WT>&69PD:1`LQ
M[#%?#4Z<JLU""NV?93G&$7*3LD<YJ'C*7>PL842,?QR\D^^.@KZNAD%.,;UY
M:^6B^\^<K9U+FM1C]Y#:>,KL,#/%!,G^Q\IJZF0T)QO1DT_O1G#.:T)6J13_
M``.HTK5;;4XM]NV&'WD/5:^5Q&'J8:HZ=169]%0KPKP4X/0R-?\`$=UIFHM;
M0PPLH4'+@YY_&O=R_**.*H*K.33UVM_D>5CLRJ8:K[.*5K%&Z\8W3;/LD,<8
MP-Q<9)/?Z"NO#Y#3Y;UF[^70Y:^<SNE22*.H^)YM5LFMFBB5-V&*YSN!^M=.
M7Y;1H5'5IR;M='/C,PJU::IRBE=)F*(@+VWNLG?;DE1V/UKLQN7T\;R\[:MV
M.3"8V>$;<$G?N=%JNNPZYH4;PKM:*7:X[9QS7S>314,=**Z)_F?19C)SP/,^
MO*<]`7@UBUO54%;<,2"<9/&*]O,<NEC:L'>T4G?\#Q,!C8X2$]+MVL="GC'4
M"^X+;,F?NA?ZYK!9%A)1]V3];F[SC$1EJEZ6.CT37[?5/W8'E3J,F,G^5?+X
MW!SP=7V<M>S\CZ#"8J.*I\\=.Z*'Q,_Y$?4O^V7_`*-2N,ZS"\3_`.I_[B,W
M\Y:Y</\`[VSM_P"72,5$#9W#@<U]7EM#VV(5]EJ>3FE?V&&DUN]$5[N^%O?6
MMOU,Q.[V';]:^DQ&-C1Q%.C_`#?TOQ/D,/A'6I5*B^S_`%^18B_T;7M)U`<?
M9K@;_P#=((_F?UKP>*\)[7!NI'=:/T_X?\ST,DQ')5=)[/\`-'<ZVP;19V7H
M=2!'YBOR[+E;%P]/T9]=/X3E-0N9/+GA1%/RE1ZGBOU6GDM.IAU43?,U?IO;
MT/F*N:U*5=TVE9.W78ANYUN([.-@$:WBV`;OO9`S_P"@U.!X>I8>[K3O*71:
M+_-E8G/JLM*$;175Z_\`#$VASI8:U:7<N?*B+EL=>48#]2*K&Y++3V#OKUZ#
MP^=J:<:ZMYK_`"-BY\97;3$6L<,2CHK#<V/>MZ60X9+EJ2;E]QR5<YK-WIQL
MB2Q\1I-NANU$<MS>02!E^[PT8Q^2YKXGB3(IX2:Q--W@TUYIV9[&6YDL3>G-
M6E^9H^(IHX],U4.X#/=Q;!_>PL3''X`UX>1Y?6QN+IQIK2*NWV5V=^+Q,,-2
M<Y_\.<A/?,RE#L17!7!/-?JL<CPL$E.3OZV/EI9QB)/W(I+TN=-H_BR/$=O?
M1"(*`JR*>...17EX_)7AX.I1=TMUU._!YLJLE3JJS?7H;VI7AM=+FNX-KE$W
M+GH:\G!T(XBO&E+9GJXFHZ-*4UND>:W<KW(M8G1?+@C9/J/EZ_\`?->_#ARG
M1JWIR=GO>WX:'CPS^;@_:15UM:_XBPZH^E(JE]]N[!!#)RO/IW'\O:N+.,CP
ME&C[:FVI?F;9=G.)K5O9S2:_(;J-O:R7;/):(%4?ZIN0OT]/PXJ\+P[0GAHU
M'.5VKZ6_R)Q6=U:5>5.,59.W7_,U/#5[;_9%.E,(5//V:<X4^I4]OPR/:OA*
MM&4Y6:NWV/KJ<THW6B+-WXC8<6L(7`Y9SG!]L5]A@>$(<BGBYN_9:?>SYC&<
M2.,G'#1^;_1%2+7[I9OM$+1K)W>/C=[,.C?C7IKAG"QC_LU1KYW7]>C//_M[
M$.7[Z"?RLSIM'\4072[+U1`Z]9!]S\>Z_CQ[U\SB(2PM9T*VDOP?FCZ##U(X
MBDJM+;\5ZD>N>*197#6UE&DKIPSL?E!]!CK7T.`R3V\%4K.R>R6YY&-S54)N
MG35VMS'3QCJ.[@VSXZ@)_P#7KTO[$P<M(M_>>=_:^*CJTON-S1O%$%[(L%R@
M@F;[N#\K?2OG\QRV6!::=XL]K`X]8M--6DC?KRCT@H`*`"@"6#O0`D_^N:@"
M.@`H`X?QS_R&$_ZXK_,U]QD/^Z_-GR>=?QUZ?YG,>'[*2XBU.6+)\J=F*^V>
M:X<%CO8XVI1F_=E)V\G_`,$ZL1A/;8.%2/Q12^XTM(U!],O#(/\`53#9(/KT
M-=>;8'GG#$06J:OZ7W^1S97B_9WHRV>WK_P3(UC_`(\O^!I_Z$*WSO\`W.7J
MOS.;*_\`>H_/\CM/$URR:%IUNIPLB[F]\`8_G7D\/T4YSJ/II]YZ^=57&G&"
MZ_H<;;::^O>(HM-9BMM&H>0#N36>>XF<JWL4_=2_$634(JFZK6K9VFI>$;#3
M]+DEL$,;1+N(SPV*Y<GQ,Z.(C!/W9:6.S,L/&K0E)K5:HYFSU%]*U"VN$)"F
M01N/4&O:X@HIT8U.J=OO/&R6JXUG#HU^1J^+V#ZR6'0QH?TKJR3_`'./J_S,
M\X_WGY(Q/#FDW7B'6+D"ZDM[>V;:`AZD>OK7S^/S+$?69*$VE%V2]#U\#@*'
MU>+G%-O4W+KPC;Z%I,UQO,LYD&'/N>:>23D\9=O=,K-(1CA&DMK'+W5K'>:Q
MIMO-GRW=@0#CTKNXA;7L[>?Z'!D:5Y_+]3L]?T6ST;18XK%-BM+D_E7!D7^]
M_)_H>EFW^Z2]4<;>VTFH:A9:<C%4G<E\'J!BO2X@K2C&%)/1W;/*R6E&4Y3:
MVV.OUCPQI^BZ,LEFA20,JL?[U<&03E'$."V:/0SB"EA^9[IF#I$KP^*=.\MB
M-^X'W'%=/$2]^F_7]#ER-Z37I^IU_P`3/^1'U+Z1?^C4KY<^B,+Q/_J?^XC-
M_.6N7#_[VSM_Y=(R$&U![\U^C9/0]G1]H]Y?D?%YYB.>LJ2VC^;,G['<3:V]
MS+&5B0;8SD=J\O&8/%U\5*JH:+;5=/F=>78O"8>@H3GJ]]'_`)&K*@DC9#QN
M'Y5]'.E]8P[IU%;F6I\]*2HU^:D[I/0W]/O3=^#<2']ZE^H<>^:_&(X>6&S+
MV<NEU^9]_"HJM)3CLS'O#MGE/H2:_9,(^7"P?]U?D?!XU7Q,UYG.:?8"X\B_
MN6+23%V!STP5QC\Z_/:6(G6Q+J2>NY]W2PT*=%02T-F]D,%K-(O5$)'UQ7Z+
MB:KI8>51;I-GP%.DI5U3Z7M^)K^$/"5J^@OJ=YN>Z=&<,3R.*^`PE6<<3"=]
M;K\3[:O2@Z$J=M+&%JK&.U1UX9)8R#[[A7UF?Q3P$T_+\SY3*G;%Q^?Y&[X@
MED>^P[94JC@>A**#_P"@BO/X2P\*67\Z6LF[_)M(Z<[JN6(Y.B7YG,+I1NKZ
MXGU'E<$0J#G`[?2HQN6XW$UY5&E;IKT.K!8_"8>BH7UZZ=3<O4M$:-;%F:+R
MU!##&&QR*^@P%.M##JGB-UIWT/'QTZ,ZW/0V?RU-;0-0>Y\(ZC;2L6:VR@)]
M,\5\E@Z?LLQ4%TDU^9]+6G[3`.;ZQ.3UVZDM;`F`[9'8(I],]Z^HS;$SPV'O
M3=FW8^<RW#QQ%=1GLM1-#TF6]U/3(;JZ>16G!(8YQP?\*^-KUJU2FE4FVEW/
MLH82C1?/"*3\C<\0((]4O$7@*Y`K[?!_[E#_``_H?&8[_>Y^I%H%M)%X,6?=
M&\;.%VLOS(?4'_)KXO)<)"ICHU'T39]5F6(E3P4HKK9&'KI:1[:UW%8Y6)DV
MG!(';]:]OB/$3ITXTXNU[W^1XN1T(U*LIR6QO6^BP06#-I($V%&5/RR*?<''
MY'!]S7QN`S6M@*KDMGTZ>I]7C,NI8RGRO==>H[PUI^IMJ*W;RPJD8VNB9!'L
MP/-9YOFKQ]O:12:VL++LNC@K\C>O</$^D'?*L%_';K(/]4%R1^7(KV<OQ><8
MZAR1C>+TN[+[GU/.QN&RS"U>>;M+>VK_``(;2VT:STY(X+&0WFWF4L``?PZU
M[V`R6MAZL:LII6Z(\G%YM2JTW3C%N_<HWTK026<B'#"X7^M=.?K_`&9>OZ,Y
M<F_WA^C/7;9BUO&QZE0:^)/KB2@`H`*`)8.]`"3_`.N:@".@`H`X?QS_`,AA
M/^N*_P`S7W&0_P"Z_-GR>=?QUZ?YE?X7J'GU56&096!'XU\EC?\`>:GJ_P`S
MZ+!_[O#T1%XBTPZ;?LJC]T_S(?Z5]KE>-^MT?>^):/\`S/ELRPGU:K>/PO;_
M`",#6/\`CR_[:)_Z$*SSO_<Y>J_,65_[U'Y_D=IXEMF?0M/N%&1$NUO8$#_"
MO(X?K*-25)]=5\CV,ZI.5*,UT_4Q?"DB67B43R$+',@0L?X2*K/,%4=3V\%=
M6U\C'*,7",'1F[.^AUOBG5;>#3);>.5'FG7:%5LX!ZDURY1@JLZ\:LE:,3LS
M+%TZ=%P3NWH>;7Q,]_8V4(W2/*'('8"O2X@KQ4(T5NW<\W):+=1U>BT.E\5J
M4U4*>HB0?I7;DG^YQ]7^9AG'^\_)%CX6HHCU!\?,9V_G7QF+_P!XGZO\SZ;"
M?P(>B-_QD/\`B0RX[.O\Z]'(_P#?%Z,Y<U_W67R_,\Z52->TM\819#D]ATKT
M^(*<Y>SY4WO^AY>2SC&4TW;8[SQNP;2;<J009`00>O%>?D::Q=GV?Z'IYJT\
M&VNZ.*TW_D:],_X%_2NKB+XZ?H_T.'(]I_+]3O/&O_(#/_71:Y,B_P![^3.W
M-O\`=7ZHX/3?^1ITSZM_2NSB+XJ?S_0X<C^W\OU.S^)G_(CZE](O_1J5\N?1
MF%XE&8@/^HC-_.6L<%3=7'\BZG54J*EA^>6R,+4+I;*TDN&7(0<+G&3V%?IV
M(K0P.'Y[:1Z'YU3A/&8BU]9,J'4+M5C)TY@)5WK^\[?E7A4^(XU&U&GMY_\`
M`/:?#\E]O\/^"6+&ZEN"XFMS`5Y&6SFO5P&8K%MQY>5KS//QV6RP<5/FNF6K
M:Z-K,;8\1W4L;_\``@>?TKY3/\#[/'0Q,5I)/[['KY-B.>BZ3WC^0^__`-9-
M^-?8X;_<X_X?T/`QG^]3]3,TO_D$Z=_NR_S2OS?"?QI?(_0U\"+&J_\`'A<_
M[C5^CX__`'*I_A?Y'YY0_P![C_B_4]`\.?\`(FQ_]>[?RKX+#?QX>J_,^UJ_
MPY>C/.M9_P"/'_MHG_H0K[+/O]QG\OS/D,J_WN/S_(W=;1_M0D(^3:B*?I&I
M_P#9J\SA+$PJ8'V*WBW]S;:.K.Z+A753HU^1S\=G?2SW(-]+&%RT0&,$>E1C
MJN88>M)*3Y6]++_@'5@J>"K4E>*YEN7I=/BAD"'4KJ0!02Z;<9QS^5==+"YE
M.DINMRM]&C"K7R^G4<%2NNZ.ATC3+6R\-ZC/:79N?/7<Q/4'(ZUXN7R<L?%R
M=W=Z]]SUL4HQP<E%65MCC/$(S#;#MYP_D:^@S[^##U_1GB9)_O#]/\C<\-\:
M_I@'_/<?^@FOE:OP'V,]B;Q)_P`AB^_ZZ-7W6#_W*'^']#X+'?[W/U+'ARW:
M?X>$(,F-@^/H>:^/R:LJ6*C?KH?39C2=3#22Z:_<<WJ<4PGM;JW+![=R<KU`
M/?%>_GN#EB*<915[;^C/%R;%0H57&;M?\S:&JR7$&9HMMTH_=W,1V_F/Z<BO
MF,OR!UZWOW]G]SOT/ILPS2.&I7@US]!1K\7VV&&Z5EN2ORRPY##ZX['TZ5GF
M>2T,'5ITX3;4GJG;17,\NS2KBXSE.*5MFNYFZI-<_9YIH1YEP>>>>>YK[[%<
M^'PK^K1U2T1\;1<:^(3KO1O5CK31I%M([Z_U-G8C<D*M@$_05\?EN*S'&XR*
MES<B>M]%^A]1C,-@<+AI-6YFM.K*>L,46U8`G%PO`_&O=X@=L*GY_HSQ<E5\
M3;R?Z'K>DWD%U:1B%_G11NC;AT^HZBOB8RC-7BSZYQ<79ERJ$%`!0!+!WH`2
M?_7-0!'0`4`<=XYL+V6\AN+*#[0641[`<8QDU[>`S=8*E[+DOKWM^AY6-RUX
MN?.I6LNPGP[TF^TY[V2^A\DS.6"YSBO)KU/:U)5+6N[GH4:?LJ<87V5CH=?T
MU=2L&C`'F+RA]ZWP6+E@ZJJ1U[KN9XK#1Q--TY?\,><WNA:W<#R/[.*KO!W[
M\]#GIBO3QV<+%T72Y+7MU_X!YN%RIX:JJG/>WD>E0V:R:3':W"\&,*PKPH3E
M"2E%V:/:E%23BUH<7JWAS4;*5C;0?:H>VTX85]+0X@E%6K0OYK_(\&MDL9.]
M*5O)F,UGKDK>7:Z4Z,?XI#P/P%56XA;C:E"S\_\`(SI9)9WJ3T\CIO!O@UM.
MN#J&IOYUVW//\-?-5*DZLW.;NV>_3IPI14(*R0>--,OY-1%Q8VQN`Z@$`[=N
M*]O`YPL)15+DO;S_`.`>7C,L>*J^TYK?(L?#W3+S3K:Z^VP^4TLA8+GIFO$J
MS]I4E/NVSU*5/V5.,.RL='J=HM]82VS<!QQ['M5X>O+#555ANA5J4:U-TY;,
M\WU#3M5LYFB7399L=&1A@U]/_K#"W\-W]4?//(YWTFK>AHV&GZQ<:&8KY&63
M>7BC)S@`<"O"PV8+#8IUN6_-?2_?4]FK@_:X7V'-:UM?0J:-HFK-X@L[FXLC
M!'"3D[LYS5YCF'UV47RVM?J98'`_4^;WKW.V\3V<M[I$D4`S("&"^N.U8X#%
M_4ZOM+7TL;XO#_6:3IWL<3HVBZLVOV=Q<6)@CA)R=V<YK?,<P^NN+Y;6OUN8
M8'`_4^;WKW.F^)G_`"(^I?2+_P!&I7E'I&%XHE\FUD81^8WV^8*,XP=TG_UZ
M>5XF.%Q\JCC?1V_`>-P\L3A%3C*USBM4>[OTBB:V,,:N&;YLY[#^=>YF.8RQ
MD%#EY4M=SRL%E?U2;FY7T['3ZR@CDL$48`M/ZBOF\M>LSZ.KI8HP0R7.J:?;
M1-M,\Y3_`,AN?Y@5ZWU]Y=_M"5[;KNF>?C,,L32=)]1-3L-45=S6!18+D()`
M_1@?3%7B>(:&8P5%0L]UK_P#R<)E4\)4]HIW^7_!':H]Y%O9+,R*5)8[\8X^
ME>G3SM4Z*I>SV5M_^`8ULH=6JZG/:[OM_P`$BMK66TTS3$F7:3'(P^AV5\M@
MY)UIV/J+.,41S->7\S6%K9%FG#*K;_8GICT%?5XK./:494O9VNK7O_P#YF.3
M.G657GV=]O\`@GI^A64MOX<CM)ALD\HH?8D5\Y2G[.<9]G<]F<>:+CW//-4T
MC59&EMDLCY<5Q'&9=W<E2./^!"N_->(J5>E+#N%F]=_GV/(PF4O#U55Y[V\C
MK=6LS_PCU\&`6:&XA"DCH2D*G]#7QN4XZKA,;"=%[W3[-79[&)P]/$4G"HCC
M;F2[M0?,L7<#G,;#&/QK]-AQ!&WOTW?R9\U/(Y7]R:MYHDBT37=9VQ1VIL[=
M_O.QRQ4_RKSL;G53$1=.FN5/[SMPN4PH24YOF:^X[VT\/1Z?X:ETVU/S,F"?
M4UY>$K_5JT:MKV/3KTO;4I4[VN>7:HMY<"T62S,2NWF*V_.0!]/]H5Z&+S>.
M8Q5.,+<KON<>"RJ6#J>T<KW78W_#G'B#3/\`KN/_`$%JX:OPGLSV-'Q3I.I_
MVK.]G9FX28EMP;;C/:O8HYVJ5!4O9[*V_P#P#YROE+K574Y[7\O^";O@73)]
M/\/I:WL>U^<K7SBT/<.%U#S["*T<1F=;B+?P<,,`9_G7NY=Q%5:=.M'FMU6Y
MY.,R*$GST7RWZ="E'?WEU/%;V>GOYTK;5\QN,_A7H5<_M']W3U\_^`<4,BDG
M^\GIY'4^&O`MU%,VH:C<[;UN5XRH]B/3Z5\IBI2Q4G*H]6?0X>$<-%1IK1%/
M7]/OM+G+2VFZ-C\KQM\A/H">GT.*]W"\03H4U#$1YK=5^J/(Q62PKS<Z$N6_
M1_H80DU.]E6.UM_LL9;'G2<@^P/2HQ?$LI*U%67X_P#`'ALA47>J[_D6-0M;
M\RK;RV.SYU*R;_ER#ZX_0USX_/Z6-P[I.%OGM^!KA,EJ82NJBG>WE_P3OH8-
M]O"9%:.9%&'0[73Z'^G2OA(U)4I\T&?6."G&TD78-1GMOEO%,\0_Y;1K\RC_
M`&E[_5?RKU:&/C+2IH_P.&IAG'6&J-.":*>)98)%DC;HR'(->EZ'(/H`E@[T
M`)/_`*YJ`(Z`"@"&?_6V_P#UT/\`Z"U1+>/K^C+CL_ZZHFS6EF0%%F`9]Z+,
M`HLP#-%F`<>U%F`468!FBS`,T68!19@'%%F!#+_Q]6__``+^59R34H_,N/PL
MFJR`H`*`.:^)G_(CZE_VR_\`1J4`87B?_4_]Q&;^<M<N'_WMG;_RZ1S]Q_J3
M]1_,5Z\_A9E+8U->_P"/BQ_Z]?ZBO+RW[9O5Z$.A_P#(T:)_U^?^TY*O-O\`
M<Y_UU,'T.RU[_D#W/_83'\Q7S.6_[U#T_04_A.=OO^/*?_KFW\J^M.<J:Q_Q
M[Z3_`->[?RCKDR_^+/\`KJ>A/X8DWA+_`)&:P_WI/_1;UZ57X3FGL>DURF)E
M2_=O?^PC;_\`M&OF,S_WK_MW]&;0^$K:]_R"]8_Z_(/Y0USX#_>:7]=QRV9S
M=U_QZS?]<V_E7V1SG>67_'E;_P#7)?Y"H&34`>8:O_Q[:3_U[M_*.N?+_P"+
M/^NIWS^&(>'O^1ATW_KX'_H+5Z=7X3GGL>GUR&`4`>8:O_Q[:3_U[M_*.N?+
M_P"+/^NIWS^&(>'O^1ATW_KX'_H+5Z=7X3GGL>GUR&!3UL`Z+?A@"#;R9!''
MW34R^%@8>LZ,D<]VUL<VMI;+.;.0DQL<OG![?<&`<K["ODZ&*E:*EU=K]>G]
M=SM4VM]C*/VFTF^R.N9W&6T^120B>JL?X??D>@%>A&49KFCMW-HROM]Q;M9W
MB;R[4E2HR;2<X('^P?3\Q]*SE33U?WFJ=MC1MKR*=M@W13#DQ2<-]1ZCW%<\
MH.):DF/\IHY3-:R-;S'JR\JW^\O0_P`_>MJ.)J4?A>G8SJ48U-]RY!JRJ0FH
M(+=CP)`<QM^/\/T/YFO9HXNG5TV?8\^I0E3]#7AXS768"3_ZYJ`(Z`"@!T9V
M[F&,J,@XZ<BN3$TX5'"$U=-_^VL33<7RNS'"4MU)0^W2LG@HT_ABI+ST?W[?
M@%.KSK71K<"T@&0V1ZBG&GAF^64+/L]/NZ/Y%W8WS'_O&MOJE#^1"YF'F/\`
MWC1]4H?R(.9AYC_WC1]4H?R(.9AYC_WC1]4H?R(.9AYC_P!XT?5*'\B#F8>8
M_P#>-'U2A_(@YF'F/_>-'U2A_(@YF*K2'H36<Z.%I_%%?K]PTV+O*]7)]A_C
M6?U:,_@II+SW^[_-_('+E5VQ"YD1BP'&,<=*J.%IX>M#DW=[OY?<94Y2G>;T
M71?J_/\`)?,97>6%`!0!S7Q,_P"1'U+_`+9?^C4H`PO$_P#J?^XC-_.6N7#_
M`.]L[?\`ETCG[C_4GZC^8KUY_"S*6QJ:]_Q\6/\`UZ_U%>7EOVS>KT(=#_Y&
MC1/^OS_VG)5YM_N<_P"NI@^AV6O?\@>Y_P"PF/YBOF<M_P!ZAZ?H*?PG.WW_
M`!Y3_P#7-OY5]:<Y4UC_`(]])_Z]V_E'7)E_\6?]=3T)_#$F\)?\C-8?[TG_
M`*+>O2J_"<T]CTFN4Q,J7[M[_P!A&W_]HU\QF?\`O7_;OZ,VA\)6U[_D%ZQ_
MU^0?RAKGP'^\TOZ[CELSG+K_`(]9O^N;?RK[(YSN[+_CRM_^N2_R%0,FH`\P
MU?\`X]])_P"O=OY1USY?_%G_`%U.^?PQ#P]_R,.F_P#7P/\`T%J].K\)SSV/
M3ZY#`*`/,-7_`./?2?\`KW;^4=<^7_Q9_P!=3OG\,0\/?\C#IO\`U\#_`-!:
MO3J_"<\]CT^N0P*>M?\`(&OO^O>3_P!!-3+X6!7U;_F,?]@]?_:U?#T_L>O^
M1TLQO%T:R:Z`XSBVC((."#ODY!'2OH,FBG1FGW_0SFVFFBA`9YYDM)8C>J0S
MJ1Q*FWJ<]S],'ZUV5<';6G]QM#$=)DQ#-'@@WD2'TVS1'].?R/UK@:Y79Z,Z
MT[JZU19M;V54W(QO8`<948E3V(.,_H?K6$J2Z:%J1?@GAN8RT+K(G1O;V([?
M0U@XN+LRTT]B2U6YME*6-T8(NT9C5U7_`'<]/I773QU6G'EW]3GEAH2=]C>G
M_P!<U?0'ED=`!0`Y/NO]/ZBN>M\=/U_]MD-=1A]174GT9A4BT^>&_P":_K;[
MNHH..5./I42BFN62-8R4DI1V';@?O+GW'!K#V+A_#E;R>J_S7R95^X;<_<.?
M8\&CVSA_%C;SW7^:^:"W8JWMRUN4BAA,UQ+GRX\[1QU+'L!D<^XQDUNFI*Z>
M@B/[/?M\S7ZQM_<C@4J/SR3^8_"F`L-Q-%-';WRJ7DSY<T8(1\=B#]UL=LG.
M#@]J`+H0XR?E'O6#KQORQ]Y^7^>R^\=@RJ]!N/J>GY4N6K/XGRKLM_O_`,E\
MPT0C,3U/X5I"E"G\*_S^_<+C>OT%;_"O,YG^]E;[*_%]O1=?/3N/7[C_`(5R
M5/XM/Y_D=/1C:Z!!0`4`<U\3/^1'U+_ME_Z-2@#"\3_ZG_N(S?SEKEP_^]L[
M?^72.?N/]2?J/YBO7G\+,I;&IKW_`!\6/_7K_45Y>6_;-ZO0AT/_`)&C1/\`
MK\_]IR5>;?[G/^NI@^AV6O?\@>Y_["8_F*^9RW_>H>GZ"G\)SM]_QY3_`/7-
MOY5]:<Y4UC_CWTG_`*]V_E'7)E_\6?\`74]"?PQ)O"7_`",UA_O2?^BWKTJO
MPG-/8])KE,3*E^[>_P#81M__`&C7S&9_[U_V[^C-H?"5M>_Y!>L?]?D'\H:Y
M\!_O-+^NXY;,YRZ_X]9O^N;?RK[(YSN[+_CRM_\`KDO\A4#)J`/,-7_X]])_
MZ]V_E'7/E_\`%G_74[Y_#$/#W_(PZ;_U\#_T%J].K\)SSV/3ZY#`*`/,-7_X
M]])_Z]V_E'7/E_\`%G_74[Y_#$/#W_(PZ;_U\#_T%J].K\)SSV/3ZY#`IZU_
MR!K[_KWD_P#034R^%@5]6_YC'_8/7_VM7P]/['K_`)'2S)\5?\A[_MUC_P#0
MY*^AR3^#+U_0RJ;D/A__`)#]M_USE_D*]MF9TM]IEO>L'<&.<#`FCX<>WN/8
MYK*=.,U:2*C.4'>)PEQ.;=TN+UB+B9FCAN(VV(H!/WA@^G?=[8KR_9MR<(*Z
M1Z"EHI/J:!:2/9+<D(^T8O+;[I_WASQ]<CZ5SM)Z+[C3;4T;:_DC3$T#SY^[
M+;@%7'KC/'ZBN>5+71FBE;<ZF?\`US5].>*1T`%`#D^Z_P!/ZBN>M\=/U_\`
M;9#74;70(3I]*M>\K=3G?[J7-]E[^3[^G?[^XM0=`4`5;5BVK7FX;BJ1(H/9
M?F/\R?R]JYYTX17-?E\UI]_1C39>V)W;8?[O6N?V]=?!#F7?;\.OR'9%+7,Q
MZ7,ZKM:,!T;J=P(*X/;G`_&M*:C5^*=_+;[UO]X/0M'J<]:ZTE%62LB1*8"'
MT%4E;5F-1N3]G'?J^R_S[?>+TJ36,5%66PY?N/\`A7/4_BP^?Y%+9C:Z!!0`
M4`<U\3/^1'U+_ME_Z-2@#"\3_P"I_P"XC-_.6N7#_P"]L[?^72.?N/\`4GZC
M^8KUY_"S*6QJ:]_Q\6/_`%Z_U%>7EOVS>KT(=#_Y&C1/^OS_`-IR5>;?[G/^
MNI@^AV6O?\@>Y_["8_F*^9RW_>H>GZ"G\)SM]_QY3_\`7-OY5]:<Y4UC_CWT
MG_KW;^4=<F7_`,6?]=3T)_#$F\)?\C-8?[TG_HMZ]*K\)S3V/2:Y3$RI?NWO
M_81M_P#VC7S&9_[U_P!N_HS:'PE;7O\`D%ZQ_P!?D'\H:Y\!_O-+^NXY;,YR
MZ_X]9O\`KFW\J^R.<[NR_P"/*W_ZY+_(5`R:@#S#5_\`CWTG_KW;^4=<^7_Q
M9_UU.^?PQ#P]_P`C#IO_`%\#_P!!:O3J_"<\]CT^N0P"@#S#5_\`CWTG_KW;
M^4=<^7_Q9_UU.^?PQ#P]_P`C#IO_`%\#_P!!:O3J_"<\]CT^N0P*>M?\@:^_
MZ]Y/_034R^%@5]6_YC'_`&#U_P#:U?#T_L>O^1TLR?%7_(>_[=8__0Y*^AR3
M^#+U_0RJ;D/A_P#Y#]M_USE_D*]MF9V*_>%2!YIKW_'K8_\`7:7_`-FKFP?^
M\S_KJ=TOX<2KI,US;WD$%G(J+/,D9C<9C^9@,X['GM79B<+3J+FM9D*HX+0Z
M26V-E(R323:>Q.<1@&-_=<@CZ]#ZBO$J4*D':US>%6$EO8[2?_7-7L'FD=`!
M0`Y/NO\`3^HKGK?'3]?_`&V0UU&UT""@&KZ,%4GH./7M4U*L(;O7MU^XQIIP
M?(]NC_3Y?EZ#L*O4[C[<"L;U9[+E7GJ_NV7W_(WT13O!/%,+NTC$AV[)85.T
MR*,D8)XW`DXSP<GV-5&C%.[U?=Z_\-\@N,_M:Q7B2<1/WCD4JX_`C/Y5L(17
MDU!XRB-'9*V\^8I5IF!RORGHN>>>N!VJ)TXS^)?UZA>QH94]1M/J/\*RY*L/
MA=UV>_W_`.:^8]`*$#*_-]*J-:-[3]WU_1[,BHW%>ZKOH-'%;MW)IPY%;KU?
M=A2-!R_<?\*YZG\6'S_(:V8VN@04`%`'-?$S_D1]2_[9?^C4H`PO$_\`J?\`
MN(S?SEKEP_\`O;.W_ETCG[C_`%)^H_F*]>?PLREL:FO?\?%C_P!>O]17EY;]
MLWJ]"'0_^1HT3_K\_P#:<E7FW^YS_KJ8/H=EKW_('N?^PF/YBOF<M_WJ'I^@
MI_"<[??\>4__`%S;^5?6G.5-8_X]])_Z]V_E'7)E_P#%G_74]"?PQ)O"7_(S
M6'^])_Z+>O2J_"<T]CTFN4Q,J7[M[_V$;?\`]HU\QF?^]?\`;OZ,VA\)6U[_
M`)!>L?\`7Y!_*&N?`?[S2_KN.6S.<NO^/6;_`*YM_*OLCG.[LO\`CRM_^N2_
MR%0,FH`\PU?_`(]])_Z]V_E'7/E_\6?]=3OG\,0\/?\`(PZ;_P!?`_\`06KT
MZOPG//8]/KD,`H`\PU?_`(]])_Z]V_E'7/E_\6?]=3OG\,0\/?\`(PZ;_P!?
M`_\`06KTZOPG//8]/KD,"GK7_(&OO^O>3_T$U,OA8%?5O^8Q_P!@]?\`VM7P
M]/['K_D=+,GQ5_R'O^W6/_T.2OH<D_@R]?T,JFY#X?\`^0_;?]<Y?Y"O;9F=
MBOWA4@>::]_QZV/_`%VE_P#9JYL'_O,_ZZG=+^'$J:7_`,A?3_\`KZA_]#%>
MK4^%F$MCUJ`D;L$BN,P$G_US4`1T`%`#D^Z_T_J*YZOQT_7_`-MD-=0V$?>(
M4>_^%-UT]*:YO3;[]@L&57[HS[G_``H]G5G\;LNR_P`_\K!HMAK$M]XYK6G3
MC2^!6(G%35F(#6CC;5$4YMWC+=?U?^NHM38U%#$<`D?C18!*+`&::3>A,I*"
MYF(.#GH?Y4Y)-<O0SIQ=^>6[_!=O\Q^_/W@#[]#7+[#D_A.WENON_P`K&]^X
M;0?N-^!X-'M9P_B1^:U7^:_K4+=A0"J.",'BIE*,JE-Q=UK^0=&,KJ$%`!0!
MS7Q,_P"1'U+_`+9?^C4H`PO$_P#J?^XC-_.6N7#_`.]L[?\`ETCGKIE2`EF"
MC(Y)QW%>O/2+,I;&KKW_`!\6/_7K_45Y>6_;-ZO0AT/_`)&C1/\`K\_]IR5>
M;?[G/^NI@^AV6O?\@>Y_["8_F*^9RW_>H>GZ"G\)SM]_QY3_`/7-OY5]:<Y4
MUC_CWTG_`*]V_E'7)E_\6?\`74]"?PQ)O"7_`",UA_O2?^BWKTJOPG-/8])K
ME,3*E^[>_P#81M__`&C7S&9_[U_V[^C-H?"5M>_Y!>L?]?D'\H:Y\!_O-+^N
MXY;,YRZ_X]9O^N;?RK[(YSN[+_CRM_\`KDO\A4#)J`/,-7_X]])_Z]V_E'7/
ME_\`%G_74[Y_#$/#W_(PZ;_U\#_T%J].K\)SSV/3ZY#`*`/,-7_X]])_Z]V_
ME'7/E_\`%G_74[Y_#$/#W_(PZ;_U\#_T%J].K\)SSV/3ZY#`IZU_R!K[_KWD
M_P#034R^%@5]6_YC'_8/7_VM7P]/['K_`)'2S)\5?\A[_MUC_P#0Y*^AR3^#
M+U_0RJ;D/A__`)#]M_USE_D*]MF9V*_>%2!YIKW_`!ZV/_7:7_V:N;!_[S/^
MNIW2_AQ*FE_\A?3_`/KZA_\`0Q7JU/A9A+8]:@[UQF`D_P#KFH`CH`*`)(6*
M;F7J!Z>XKAQE&%=0ISV;].C*B[:H/,SWVGZ`BH6%]FK6YEZM/\[/\!W`LZC/
M&/4`8JX4\/-\JNGV;DG^8KM#?,;U'Y"MOJM+L_O?^8KL"[=B/R%-8:DM&G]\
MO\S.HI/6.Z_JWHP$C>WY"AX2DNC^]_YCA4YU=!YC>H_(4OJM+L_O?^9=V'F-
MZC\A1]5I=G][_P`PNQ/,;KD8^@JGA:4=+._K+_,PC)U7S?9Z>?G_`)??V%\Q
MO;\A4_5:79_>_P#,WNQ0[DX7!_X"*B=&A35Y:+_$_P#,=V+N*_>8?10*R]DI
M_P`.+7FW)?A>_P"07MN*9"\3*<`#&!40PD*&(C-7;=[_`'=OZ?F-RNK$5>F0
M%`!0!S7Q,_Y$?4O^V7_HU*`,7Q#"\ZB.+K_:,Q)QG`!ER<9&?SKSE5]CB)3M
M?^D=\5>G%$UOI6ER:-<FTD\]WB8-.V"Z\9QC^'Z5PUL36J5%[3[NAO&$%%V,
MK7?]?8G_`*=?ZBO8RW[9A5Z$.A\>*=#_`.OS_P!IO5YM_N<_ZZF#Z'9:]_R!
M[G_L)C^8KYG+?]ZAZ?H*?PG.WW_'E/\`]<V_E7UISE36/^/?2?\`KW;^4=<F
M7_Q9_P!=3T)_#$F\)?\`(S6'^])_Z+>O2J_"<T]CTFN4Q,J7[M[_`-A&W_\`
M:-?,9G_O7_;OZ,VA\)6U[_D%ZQ_U^0?RAKGP'^\TOZ[CELSG+K_CUF_ZYM_*
MOLCG.[LO^/*W_P"N2_R%0,FH`\PU?_CWTG_KW;^4=<^7_P`6?]=3OG\,0\/?
M\C#IO_7P/_06KTZOPG//8]/KD,`H`\PU?_CWTG_KW;^4=<^7_P`6?]=3OG\,
M0\/?\C#IO_7P/_06KTZOPG//8]/KD,"GK7_(&OO^O>3_`-!-3+X6!7U;_F,?
M]@]?_:U?#T_L>O\`D=+,GQ5_R'O^W6/_`-#DKZ')/X,O7]#*IN0^'_\`D/VW
M_7.7^0KVV9G8K]X5('FFO?\`'K8_]=I?_9JYL'_O,_ZZG=+^'$J:7_R%]/\`
M^OJ'_P!#%>K4^%F$MCUJ#O7&8"3_`.N:@".@`H`<GW7^G]17/6^.GZ_^VR&N
MHVN@0JDJ<J<5$X1J*TE=`M!<J?O+CW6LO9U(?PY?)_Y[_?<=T&S^Z=WTZ_E1
M[=1TJ+E]=OOV^^P6[%:[N4M0F0SR2-M2-1\SG_/4]`*ZD[JQA-.$N=?/_/U7
MXKY$(_M1B3_H,0SPA#N0/=LC^52:IIJZ%M[MVG%K=PB"<@LH5MR2`==IP.F1
MD$`U2]W4QG^\?(MNO^7^?D70A(ST'J>!6$ZT(/EW?9:O^O4Z$A?D7_:/Y"H_
M>S_NK[W_`)+\0T0A8D8Z#T'2KA1A!\RW[O5A<2M1#E^X_P"%<]3^+#Y_D-;,
M;70(*`"@#FOB9_R(^I?]LO\`T:E`&#XHR(058J1J4I'?^*7J.A'L:XJ4(U,5
M*,MCN3M2B5O[9B>"3^T%-O*(RJW,'RCIP".WZCZ4JV`E3UAJBU5770AGMUN+
MFU=9I$A6U!FNYE+*HR.0...O/`%30Q#P\965V]D*4>9HZ&RT:RMKK2)[0AV6
M[5_/)#&0%'&`>P^;.!Q7E8G$U:T9^T?3;MJBZE.,8:%_7O\`D$7/_83'\Q66
M6_[U#T_0XY_"<[??\>4__7-OY5]:<Y4UC_CWTG_KW;^4=<F7_P`6?]=3T)_#
M$F\)?\C-8?[TG_HMZ]*K\)S3V/2:Y3$RI?NWO_81M_\`VC7S&9_[U_V[^C-H
M?"5M>_Y!>L?]?D'\H:Y\!_O-+^NXY;,YRZ_X]9O^N;?RK[(YSN[+_CRM_P#K
MDO\`(5`R:@#S#5_^/?2?^O=OY1USY?\`Q9_UU.^?PQ#P]_R,.F_]?`_]!:O3
MJ_"<\]CT^N0P"@#S#5_^/?2?^O=OY1USY?\`Q9_UU.^?PQ#P]_R,.F_]?`_]
M!:O3J_"<\]CT^N0P*>M?\@:^_P"O>3_T$U,OA8%?5O\`F,?]@]?_`&M7P]/[
M'K_D=+,GQ5_R'O\`MUC_`/0Y*^AR3^#+U_0RJ;D/A_\`Y#]M_P!<Y?Y"O;9F
M=BOWA4@>::]_QZV/_7:7_P!FKFP?^\S_`*ZG=+^'$J:7_P`A?3_^OJ'_`-#%
M>K4^%F$MCUJ#O7&8"3_ZYJ`(Z`"@!R?=?Z?U%<];XZ?K_P"VR&NHVN@04`%`
M!1Y`5(")-8NGD4,T,:1(3U`.6.#[\?\`?(K!T5'6F^7\ONV_(=R]Y8&`&VY[
M-UK-8J33?+S6ZQV_KTN<LE[)\D7;FV\O^!VO;70I:SB'3Y)47$EOB5"W7<O.
M!]>1^-5'FK>]*>G:/^>_Y'1&*IKE1;8DGDG\:VA"--6@K(8E6`4`%`#E^X_X
M5SU/XL/G^0ULQM=`@H`*`.:^)G_(CZE_VR_]&I0!A>)_]3_W$9OYRURX?_>V
M=O\`RZ1@7'^J/U'\Q7KS^%F4MC5UF62&]T^2,@E;;.QQE&Y'4?YQ7AX.A&LI
MIG34DXM6+5CJ=I-?68:27396N5+JARK\'E>",_@#7)C,)4HPDVKJVY,YIQ[&
MSJ[10^')FP\48U(<2YW<L.O4Y)_'FN#`.V+@V^GZ'/)::&9-IE[=6,Y*M;@Q
MMM3&9'../9?QY^E>Q5S"*?+3^\UAA7:\C+U7_CUTCO\`Z,W\HZZ,N_B3+J;1
M)_"7_(S6'^])_P"BWKTZOPG-/8])KE,3*E^[>_\`81M__:-?,9G_`+U_V[^C
M-H?"5M>_Y!>L?]?D'\H:Y\!_O-+^NXY;,YRZ_P"/6;_KFW\J^R.<[NR_X\K?
M_KDO\A4#)J`/,-7_`./?2?\`KW;^4=<^7_Q9_P!=3OG\,0\/?\C#IO\`U\#_
M`-!:O3J_"<\]CT^N0P"@#S#5_P#CWTG_`*]V_E'7/E_\6?\`74[Y_#$/#W_(
MPZ;_`-?`_P#06KTZOPG//8]/KD,"GK7_`"!K[_KWD_\`034R^%@5]6_YC'_8
M/7_VM7P]/['K_D=+,GQ5_P`A[_MUC_\`0Y*^AR3^#+U_0RJ;D/A__D/VW_7.
M7^0KVV9G8K]X5('FFO?\>MC_`-=I?_9JYL'_`+S/^NIW2_AQ*FE_\A?3_P#K
MZA_]#%>K4^%F$MCUJ#O7&8"3_P"N:@".@`H`<GW7^G]17/6^.GZ_^VR&NHVN
M@04`*`2<*":B<XTU>3L"0NU5^\?P6LO:3G_#C\WI^&_Y#LD4KDM:737L2NT;
M1A)HT&YL`DA@.I(R00.HQZ<TJ"G_`!'S?E]W^=R9SY%<?'>VDD1D2ZA9/XCO
M`Q]<]*Z+VMR]#*-+W7SZM[_UY?\`!('E_M+;!`Q:T5@TDO\`"^""$'J#W(XP
M,=^,IT82?.E9]UH_Z]1TY./[N3]/-?Y]_O-'Y6]4/YBLOWU/^\ON?^3_``-M
M!"I`SCCU'2KA6A-\J=GV>C^X+6$K404`.7[C_A7/4_BP^?Y#6S&UT""@`H`Y
MKXF?\B/J7_;+_P!&I0!A>)_]3_W$9OYRURX?_>V=O_+I'/W'^I/U'\Q7KS^%
MF4MC4U[_`(^+'_KU_J*\O+?MF]7H0Z'QXIT/''^F?^TY*O-O]SG_`%U,'T.P
M\1%UT2[,:([?VEPK_=/(ZU\K@H<^(C'R'S<NIFZ9<M$GEVL[3%>6M[DA67_=
M(Z#\Q7H5J#B_>5CLIS37NNY@WHN)4T>/RP7>V;RX8QN<\)R>W]!ZUZ6#J0I2
MG*3LC&:;Y4:NE:)?V5[:7IF6*5'/R*@<("C#YCW[#CUZUG6S3F=H+3SZE?5[
MK5G6V^K(I"7ZBV<\"3/[IC['^'Z'\S6U'%4ZVBT?8Y:E"5/T&2\+>_\`80M_
M_:->%F?^]?\`;OZ,4/A*VO?\@O6/^OR#^4-<^`_WFE_7<<MF<Y=?\>LW_7-O
MY5]D<YW=E_QY6_\`UR7^0J!DU`'F&K_\>^D_]>[?RCKGR_\`BS_KJ=\_AB'A
M[_D8=-_Z^!_Z"U>G5^$YY['I]<A@%`'F&K_\>^D_]>[?RCKGR_\`BS_KJ=\_
MAB'A[_D8=-_Z^!_Z"U>G5^$YY['I]<A@4]:_Y`U]_P!>\G_H)J9?"P*^K?\`
M,8_[!Z_^UJ^'I_8]?\CI9D^*O^0]_P!NL?\`Z')7T.2?P9>OZ&53<A\/_P#(
M?MO^N<O\A7MLS.Q7[PJ0/-->_P"/6Q_Z[2_^S5S8/_>9_P!=3NE_#B5-+_Y"
M^G_]?4/_`*&*]6I\+,);'K4'>N,P$G_US4`1T`%`#D^Z_P!/ZBN>K\=/U_\`
M;9#7415)&>@]3P*N=:$'R]>RU8)"_*O^T?R%1^^G_=7WO_)?B&B$+$C'0>@X
M%7"C"#YEOW>K_KT"XE:DMJ*NQ!ZU3TT1C!.;]I+Y>7GZO\M.XR2W@DD$DD$3
MR#H[("P_&I-R0CCTQT]J:=C.<.==GT?8!0U8*<^9:Z-;_P!?D*"5/RG%9SA&
M:M)7--A<J?O+CW6LO9U(?PY:=G_GO]]QW0;#_"=WTZT>W4=*BY?7;[]OR"W8
M%^X_X45/XM/Y_D"V8VN@04`%`'-?$S_D1]2_[9?^C4H`PO$_^I_[B,W\Y:Y<
M/_O;.W_ETCG[C_4GZC^8KUY_"S*6QJ:]_P`?%C_UZ_U%>7EOVS>KT(=#_P"1
MHT3_`*_/_:<E7FW^YS_KJ8/H=EKW_('N?^PF/YBOF<M_WJ'I^@I_"<[?J/LL
MC]'C4LC#@J<=0>U?62BI*S,$W%W15N!#8QZ60CH);=M\R?-(G^KY!)SG^7H:
M\F%*59S4>G0]&ZBHG06=^_DB2.07]MT$D>/,7ZCO^A]C7!.C9VM9F\9?,T()
MHKF(O"ZR(>#CM[$=OH:YG%Q=F:)I["6$20V-VD2[5&HP8&>G,-8UY.51.3^R
M_P!3@JI1DTA=>_Y!>L?]?D'\H:O`?[S2_KN8RV9SEU_QZS?]<V_E7V1SG=V7
M_'E;_P#7)?Y"H&34`>8:O_Q[Z3_U[M_*.N?+_P"+/^NIWS^&(>'O^1ATW_KX
M'_H+5Z=7X3GGL>GUR&`4`>8:O_Q[Z3_U[M_*.N?+_P"+/^NIWS^&(>'O^1AT
MW_KX'_H+5Z=7X3GGL>GUR&!3UK_D#7W_`%[R?^@FIE\+`KZM_P`QC_L'K_[6
MKX>G]CU_R.EF3XJ_Y#W_`&ZQ_P#H<E?0Y)_!EZ_H95-R'P__`,A^V_ZYR_R%
M>VS,[%?O"I`\TU[_`(];'_KM+_[-7-@_]YG_`%U.Z7\.)4TO_D+Z?_U]0_\`
MH8KU:GPLPEL>M0=ZXS`2?_7-0!'0`4`20MLW':&P.A^HKAQE)U5""DXW>ZW^
M%E1=A2P<Y`7/HW^-9PHSH+E;=N\;?BK7_,=[C22IP8U'X5O""J*\:DG\U_D+
M;H)O_P!A/RJ_8/\`GE]Z_P`A7\A-_P#L)CZ5?L'%?'*_JO\`(PO[66WNK\7_
M`)+\_07?_L)^51[!_P`\OO7^1O?R#?\`["?E1[!_SR^]?Y!?R#?_`+"?E1[!
M_P`\OO7^07\@+>B)^54J+V=27WK_`",III\\5JOQ7;_+_@@'']Q/RI/#M:<\
MOO7^1<9J24D&[_87\C2=&RNZDOO7^15_(=]W[RHOX'-<^L]*<I2^:2^^VORN
M/;<<T@>-@%`QCGO65+"NA7BW)N]].BTZ>?\`5AMW1#7JD!0`4`<U\3/^1'U+
M_ME_Z-2@#"\3_P"I_P"XC-_.6N7#_P"]L[?^72.?N/\`4GZC^8KUY_"S*6QJ
M:]_Q\6/_`%Z_U%>7EOVS>KT(=#_Y&C1/^OS_`-IR5>;?[G/^NI@^AV6O?\@>
MY_["8_F*^9RW_>H>GZ"G\)SM]_QY3_\`7-OY5]:<Y4UC_CWTG_KW;^4=<F7_
M`,6?]=3T)_#$/#D'GZ]:PK+)#YN\,T9QG",1D=#R!UKNQ-*%2/O(P<W#5'2W
M]A/92&:;<N.!=P`XQ_MKS@?7(]Q7B5<)**TU1O3KQEOHPL))C;R&>Z@57U*`
M*L:X,Q_<^I.!CGC\Z\6O%*=DOLOY;DU?B+FO?\@O6/\`K\@_E#1@/]YI?UW,
M9;,YF]=4MI`<[F1@J@9+<=@*^QE)05Y.Q@DV[([G2;J"ZT^!K>17VQJ&`ZJ<
M#@CJ#4)J2NAM-.S+=,1YAJ__`![Z3_U[M_*.N?+_`.+/^NIWS^&(>'O^1ATW
M_KX'_H+5Z=7X3GGL>GUR&`4`>8:O_P`>^D_]>[?RCKGR_P#BS_KJ=\_AB'A[
M_D8=-_Z^!_Z"U>G5^$YY['I]<A@4]:_Y`U]_U[R?^@FIE\+`KZM_S&/^P>O_
M`+6KX>G]CU_R.EF3XJ_Y#W_;K'_Z')7T.2?P9>OZ&53<A\/_`/(?MO\`KG+_
M`"%>VS,[%?O"I`\TU[_CUL?^NTO_`+-7-@_]YG_74[I?PXE32_\`D+Z?_P!?
M4/\`Z&*]6I\+,);'K4'>N,P$G_US4`1T`%`#D^Z_T_J*YZWQT_7_`-MD-=1M
M=`A0Q7@=/0]*RG1A-W:U[K1_>-.P':W'*'VY%)*K3U^)?<_\G^!C-\[]G%V[
M^2_S?_!`H0,@<>HZ4XUXR=GH^ST?_!^1JHJ*LMB&YN(K:,/,V`3M4`9+,>@`
M[FM0(/M%\>4T]%7L)+D*WX@*1^M`$EM=B:1H7BD@G09,;CJ/52.&'T_'%`%E
M5)^Z,U$ZD*:O)V!(,*G4Y]E_QJ5.I5TA&WF_\ORO8QDE1;GT>_EY_P"?W]Q=
MY'"C:/;_`!J50B]:CYGY[?=L;W[#:W$.7[C_`(5SU/XL/G^0ULQM=`@H`*`.
M:^)G_(CZE_VR_P#1J4`87B?_`%/_`'$9OYRURX?_`'MG;_RZ1S]Q_J3]1_,5
MZ\_A9E+8U->_X^+'_KU_J*\O+?MF]7H0Z'_R-&B?]?G_`+3DJ\V_W.?]=3!]
M#LM>_P"0/<_]A,?S%?,Y;_O4/3]!3^$YV^_X\I_^N;?RKZTYRIK'_'OI/_7N
MW\HZY,O_`(L_ZZGH3^&)-X2_Y&:P_P!Z3_T6]>E5^$YI['I(XZ<5RF)B+:V]
MN;]H+>*)CJ%N"40`XS"<?G7S.9M_6;?W?T9M#8B\19_LC60LB1'[7#\[]%XA
MY-<>$DXUJ;71/]2[7T,[2FL1$8O)DMYIE*,TP.Z4>S$#/TX^E=]>564N:3O_
M`%V.ZFH15DK&E]F1=AC+PR1J%62-L,`.V>X]CD5G3K3I.\65.G&:LT6H-4DM
M_EU!04_Y^(EX'^\O4?49'TKV*&.A4TEH_P`#@J8:4-8ZHX75B#;:01R#;MC\
MHZVR_P#BS_KJ:U/AB'A[_D8=-_Z^!_Z"U>I5^$YY['I]<A@%`'F&K_\`'OI/
M_7NW\HZY\O\`XL_ZZG?/X8AX>_Y&'3?^O@?^@M7IU?A.>>QZ?7(8%/6O^0-?
M?]>\G_H)J9?"P*^K?\QC_L'K_P"UJ^'I_8]?\CI9D^*O^0]_VZQ_^AR5]#DG
M\&7K^AE4W(?#_P#R'[;_`*YR_P`A7MLS.Q7[PJ0/-->_X];'_KM+_P"S5S8/
M_>9_UU.Z7\.)4TO_`)"^G_\`7U#_`.ABO5J?"S"6QZU!WKC,!)_]<U`$=`!0
M`Y/NO]/ZBN>M\=/U_P#;9#74;70(0\525S.I/E5EN]OZ[+J*!BDW<<(*"M_5
MQ02IRIP:B4(S5I*Z+V*<3>=J]P95&VVC18\=06R6/IR-H_`^M9>RG#^&_D]5
M]^Z_$=^Y>$1(RI!'OQ6,L9"F^6HK-=M?QZ?.P^7L4=8"16AN5!,MF?.4].!]
MX>^5R,5JO:SU?NKRU?W[?=<6B+C,3QGCTZ5<*4*;NEKWW?WA<2M1"#CC\JM^
M]J80_=/V;VZ?Y?Y>7H+4&XY?N/\`A7/4_BP^?Y#6S&UT""@`H`YKXF?\B/J7
M_;+_`-&I0!A>)_\`4_\`<1F_G+7+A_\`>V=O_+I'/W'^I/U'\Q7KS^%F4MC4
MU[_CXL?^O7^HKR\M^V;U>A#H?_(T:)_U^?\`M.2KS;_<Y_UU,'T.RU[_`)`]
MS_V$Q_,5\SEO^]0]/T%/X3G;[_CRG_ZYM_*OK3G*FL?\>^D_]>[?RCKDR_\`
MBS_KJ>A/X8DWA+_D9K#_`'I/_1;UZ57X3FGL>DURF)E2_=O?^PC;_P#M&OF,
MS_WK_MW]&;0^$J^(55])UE'4,INX001D'B&N?`_[S2_KN.6S.>\V2WA97`NK
M8#+12\L`/0G^1_.OI:N#C+6&C*AB''26J-"VN)8<+"7D4*&-M.=LB`]-I/;Z
MY'N*\FK0<7:2LSMA435XNYH6MW%<$B-BLB_>C;Y77ZC^O2N24''<V33./U;_
M`(]=(_Z]F_E'7T.7?Q)G%4V0F@ND?B#3-[J@-P,;CC^$UZM7X3GGL>H]/:N0
MP"@#S#5_^/?2?^O=OY1USY?_`!9_UU.^?PQ#P]_R,.F_]?`_]!:O3J_"<\]C
MT^N0P*>M?\@:^_Z]Y/\`T$U,OA8%?5O^8Q_V#U_]K5\/3^QZ_P"1TLR?%7_(
M>_[=8_\`T.2OH<D_@R]?T,JFY#X?_P"0_;?]<Y?Y"O;9F=BOWA4@>::]_P`>
MMC_UVE_]FKFP?^\S_KJ=TOX<2II?_(7T_P#Z^H?_`$,5ZM3X682V/6H.]<9@
M)/\`ZYJ`(Z`"@!R?=?Z?U%<];XZ?K_[;(:ZC>E=*5W9$3DH+F8@IM]$13@[\
M\MW^'E_GYBU.RN:CMF/O';[=ZY_;\W\)<WY??_E<=K;E&XD%A>-=[<6TB`3.
M>?+*YPV/3!()[8'O3]G*?\1_):+[]_R"]MBXK>:HD1@ZMR&4Y!^AK6,(P7+%
M60BC=SB^D^PPXE0,/M#CI&`<[<_WB>W89]JR]A&+O3]WTV^[8=S0PK?=.#Z&
ME[2I#XXW7=?Y;_=<++H(5*G!&*UA4C45X.XK6$-:)V=R)P4X\K$'I3:ZHFG-
MMN,MU^*[_P!;,>OW'_"N6I_%A\_R-ELQM=`@H`*`.:^)G_(CZE_VR_\`1J4`
M87B?_4_]Q&;^<M<N'_WMG;_RZ1S]Q_J3]1_,5Z\_A9E+8U->_P"/BQ_Z]?ZB
MO+RW[9O5Z$.A_P#(T:)_U^?^TY*O-O\`<Y_UU,'T.RU[_D#W/_83'\Q7S.6_
M[U#T_04_A.=OO^/*?_KFW\J^M.<J:Q_Q[Z3_`->[?RCKDR_^+/\`KJ>A/X8D
MWA+_`)&:P_WI/_1;UZ57X3FGL>DURF)E2_=O?^PC;_\`M&OF,S_WK_MW]&;0
M^$K:]_R"]8_Z_(/Y0USX#_>:7]=QRV9SEU_QZS?]<V_E7V1SG:"SM[W3K9+F
M/=MC4JP.&0X'0CD5G**DK-%)N+NC(U#2+B$!L-=QIRLD?RS1_@.OX?D:\^IA
M&M8?<=D,0GI,X]K99TTQE66.);9C/<R#+!?DZ*>H'Y?6BE7E0<FE=]$6X\UC
MI+'2--^RQM9[)EWAFE;#F3'8GMUZ?I7FUL15J2O4>OY'1&$4M#4@>XL0!:L)
M(1_RPE;@?[K=1]#D?2NBACY0TGJOQ,:F%C+6.AI65_!=L40M',.3%(-KCWQW
M'N,BO7IU85%>#N>?.$H.TD>=:O\`\>^D_P#7NW\HZSR_^+/^NIVS^&(>'O\`
MD8=-_P"O@?\`H+5Z=7X3GGL>GUR&!3UK_D#7W_7O)_Z":F7PL"OJW_,8_P"P
M>O\`[6KX>G]CU_R.EF3XJ_Y#W_;K'_Z')7T.2?P9>OZ&53<A\/\`_(?MO^N<
MO\A7MLS.Q7[PJ0/-->_X];'_`*[2_P#LU<V#_P!YG_74[I?PXE32_P#D+Z?_
M`-?4/_H8KU:GPLPEL>M0=ZXS`2?_`%S4`1T`%`#D^Z_T_J*YZOQT_7_VV0UL
MQJJ6/`Z5T5*D:*]YV_K8YX)U9<_1;?Y_Y??U'85?O')]%_QKGYZD_@C9=W_E
MO]]CHLD&\CA1M'M1["+UJ/F?GM]VP7[#:Z!!0!4?2[!W+-9PY/)PN`?J!P?Q
MH`LQQI%&L<2*B*,!5&`*`'4`*K%1@=/0]*RG1A-\S6O=:/[QIV%^0_[!_,5%
MJL-O>7W/_)_@&@C(0,CD#N.E:4Z\&^5Z/L]'_7H95*;DKQW6W]=F*G^K?\*B
MJK5H?/\`(JG-3C?^D-K<H*`"@#FOB9_R(^I?]LO_`$:E`&%XG_U/_<1F_G+7
M+A_][9V_\ND<_<?ZD_4?S%>O/X692V-37O\`CXL?^O7^HKR\M^V;U>A#H?\`
MR-&B?]?G_M.2KS;_`'.?]=3!]#LM>_Y`]S_V$Q_,5\SEO^]0]/T%/X3G;[_C
MRG_ZYM_*OK3G*FL?\>^D_P#7NW\HZY,O_BS_`*ZGH3^&)-X2_P"1FL/]Z3_T
M6]>E5^$YI['I-<IB94OW;W_L(V__`+1KYC,_]Z_[=_1FT/A*VO?\@O6/^OR#
M^4-<^`_WFE_7<<MF<Y=?\>LW_7-OY5]D<YW=E_QY6_\`UR7^0J!DU`'F.JL\
M<6C21L%=(&(RH8=(^H/6N'"T8U9U(R_K4]"3<5%HM6>L0RS`SG[!=-A1,AS'
M(?0CI^?X&LL1@9TEWB5&JGY,W(]0\O`O5$0/29,F-OK_`'?QX]Z\N5)_9.A2
MMN6Y88YE7>H..58<%3Z@]OJ*B$Y0=XNS'**DK,XS5?\`CUT?_KV;^4=?0Y=_
M$F<=3:(OA[_D8=-_Z^!_Z"U>I5^$YY['I]<A@4]:_P"0-??]>\G_`*":F7PL
M"OJW_,8_[!Z_^UJ^'I_8]?\`(Z69/BK_`)#W_;K'_P"AR5]#DG\&7K^AE4W(
M?#__`"'[;_KG+_(5[;,SL5^\*D#S37O^/6Q_Z[2_^S5S8/\`WF?]=3NE_#B5
M-+_Y"^G_`/7U#_Z&*]6I\+,);'K4'>N,P$G_`-<U`$=`!0`UI?*>-2@82-M(
M)QV)_I7/7A*?+R2Y6GO:_1]P<%.+4MO^"2EP>"F!Z!L"LH8:<'=3U[M7?WW*
MNNPF4_N'_OJM>2M_S\_\E_X(M.P93^X?^^J/9UO^?G_DO_!#3L&4_N'_`+ZH
M]G6_Y^?^2_\`!#3L&4_N'_OJCV=;_GY_Y+_P0T[!E/[A_P"^J/9UO^?G_DO_
M``0T[!E/[A_[ZH]G6_Y^?^2_\$-.P93^X?\`OJCV=;_GY_Y+_P`$-.P93^X?
M^^J/9UO^?G_DO_!#3L&4_N'_`+ZH]G6_Y^?^2_\`!#3L*&53D*0?9JF=&I-6
ME--?X5_F.Z1'+.!)'&L8'F9R<^G-13H3IU(\T[I7LK;?/5_(2A&[FM&+7:(*
M`"@#FOB9_P`B/J7_`&R_]&I0!A>)_P#4_P#<1F_G+7+A_P#>V=O_`"Z1S]Q_
MJ3]1_,5Z\_A9E+8U->_X^+'_`*]?ZBO+RW[9O5Z$.A_\C1HG_7Y_[3DJ\V_W
M.?\`74P?0[+7O^0/<_\`83'\Q7S.6_[U#T_04_A.=OO^/*?_`*YM_*OK3G*F
ML?\`'OI/_7NW\HZY,O\`XL_ZZGH3^&)-X2_Y&:P_WI/_`$6]>E5^$YI['I-<
MIB94OW;W_L(V_P#[1KYC,_\`>O\`MW]&;0^$K:]_R"]8_P"OR#^4-<^`_P!Y
MI?UW'+9G.77_`!ZS?]<V_E7V1SG=V7_'E;_]<E_D*@9-0!YAJ_\`Q[Z3_P!>
M[?RCKGR_^+/^NIWS^&(GAX9\0::",CSQQ_P%J].K\)SSV.ZN]$3E]/9;=CUB
M89B;\/X?PX]C7F5</"IKLQ4ZTH:=#&V3Z?,(D'V60]+>4YB?_<(_I^(KRZV'
M</B7S.ZG54OA^XYJ]^T2KH\156EDMR(X(N6/"<DG'^%=^#JTZ,IRD[(RFF^5
M&K8>'[NVEM;MYS'<1S*P2$`B,<Y))'/TZ?6LJV:.3M35EY]2UA]/>.KAU5H?
MEU%`BC_EXC'R?\"'5?U'N*TH8V%326C.:IAY0U6J+&LD'1+UE(*FWD((/!^4
MUV2^%G,5]6_YC'_8/7_VM7P]/['K_D=+,GQ5_P`A[_MUC_\`0Y*^AR3^#+U_
M0RJ;D/A__D/VW_7.7^0KVV9G8K]X5('FFO?\>MC_`-=I?_9JYL'_`+S/^NIW
M2_AQ*FE_\A?3_P#KZA_]#%>K4^%F$MCUJ#O7&8"3_P"N:@".@`H`AG_UMO\`
M]=#_`.@M42WCZ_HRX[/^NJ)JL@*`"@`H`*`"@`H`*`"@`H`*`(9?^/F#_@7\
MJB7Q+YEKX6359`4`%`'-?$S_`)$?4O\`ME_Z-2@#"\3_`.I_[B,W\Y:Y</\`
M[VSM_P"72.?N/]2?J/YBO7G\+,I;&IKW_'Q8_P#7K_45Y>6_;-ZO0AT/_D:-
M$_Z_/_:<E7FW^YS_`*ZF#Z'9:]_R![G_`+"8_F*^9RW_`'J'I^@I_"<[??\`
M'E/_`-<V_E7UISE36/\`CWTG_KW;^4=<F7_Q9_UU/0G\,2;PE_R,UA_O2?\`
MHMZ]*K\)S3V/2:Y3$RI?NWO_`&$;?_VC7S&9_P"]?]N_HS:'PE;7O^07K'_7
MY!_*&N?`?[S2_KN.6S.<NO\`CUF_ZYM_*OLCG.[LO^/*W_ZY+_(5`R:@#S#5
M_P#CWTG_`*]V_E'7/E_\6?\`74[Y_#$/#W_(PZ;_`-?`_P#06KTZOPG//8]/
MKD,!D\,5Q$T,\:R1MU5AD46Z!L>9W6RR@TL1PKY<MNPF(&9",1\J3W]ST[5Y
MM*C*M*:6Z/1;Y5$W=.OR\6ZSF^VPK]Z-SB5/Q/\`(_G7!5H.#M)69M&?;4T[
M6ZBN`3"QW+]Y",,GU':N647'<U33V*VH1-;:;>?8Y/(5H7WQ@91OE.>.Q]QC
M\:ZJ&*J0]W='/5H0DG+9FIJW_,8_[!Z_^UJ\:G]CU_R.1F3XJ_Y#W_;K'_Z'
M)7T.2?P9>OZ&53<A\/\`_(?MO^N<O\A7MLS.Q7[PJ0/-->_X];'_`*[2_P#L
MU<V#_P!YG_74[I?PXE32_P#D+Z?_`-?4/_H8KU:GPLPEL>M0=ZXS`2?_`%S4
M`1T`%`$,_P#K;?\`ZZ'_`-!:HEO'U_1EQV?]=4359`4`8WBC5KC2H8&MEC)D
M8@[QGH*]G*<#2QDI*I?2VQYF8XNIA81<+:]S`_X3#4O^>=M_WP?\:]W^P,+W
ME]Z_R/%_MK$=E]W_``14\8:@K#?#;L/3:1_6E+A_#6TDU]W^0UG5=/5+^OF;
MFC>)+?4'$4J^1.>BDY#?0U\[F&6SP33O>+Z_YGMX+'PQ2M:TET-NO,/1"@`H
M`*`.4UOQ)?6.J36T"0%(R`-RDGH#ZU]5@<GP^(P\:LV[OS_X!\[C<SK8>M*G
M%*R-#0-;CUR."XB4KM+*P]\<U\G4251)>9]%3;=.[\C;J@"@`H`YWXBQ--X-
MOX8@#))Y85<@9(D4_P`@:VH4*E>?)35V95:L*,>>;LCC_$.K02R+`N1OO'E3
M/4JWF'I_P(5KB,LE@,1&4I7<D[^6P8+,(XN,HQ5E&WSW,^X_U)^H_F*J?PL[
M9;&IKW_'Q8_]>O\`45Y>6_;-ZO0K6C&VO;2\C_UMM)YJ`],X*\_@37UU')L/
MF&%M5;5^S_X!\OF69UL+7]G!*UD]3<CUS^U=%N4=0LR:@K/M&!R>U?!U,#'!
M9I[*'PJZ5]]#U<-6E6P\:DMV5K[_`(\I_P#KFW\J]@LJ:Q_Q[Z3_`->[?RCK
MDR_^+/\`KJ>A/X8DWA+_`)&:P_WI/_1;UZ57X3FGL>DURF)E2_=O?^PC;_\`
MM&OF,S_WK_MW]&;0^$K:]_R"]8_Z_(/Y0USX#_>:7]=QRV9SEU_QZS?]<V_E
M7V1SG=V7_'E;_P#7)?Y"H&34`>8:O_Q[Z3_U[M_*.N?+_P"+/^NIWS^&(>'O
M^1@TW_KN/_06KU*GPG//8UY?&EY;%I+B.`PQG+[4.<?G7T&+R;#T,/*K%NZ7
M?_@'RE#-*]2O&FTK-VV_X)UVEWJ:A8Q740(609`-?)GTAYUJ_P#Q[Z3_`->[
M?RCKGR_^+/\`KJ=\_AB1Z-"L^N6$;,Z!YMI9&*MC![BO1KPC.%I(P;<5='6Z
MAI4]N1(X>X1/NSPC;+']5'4?3CVKQ*N$:^#5=C6&(3TEH4KR]E72KGS<7$30
MN!/$.1P?O+_4?D*\[V5I::>1U.7NLVKZ5IEUES"\*_8%VB3AB/WO..WX\UY4
M%;D5^O\`D<)G>*O^0]_VZQ_^AR5[^2?P9>OZ&53<A\/_`/(?MO\`KG+_`"%>
MVS,[%?O"I`\TU[_CUL?^NTO_`+-7-@_]YG_74[I?PXE32_\`D+Z?_P!?4/\`
MZ&*]6I\+,);'K4'>N,P$G_US4`1T`%`$,_\`K;?_`*Z'_P!!:HEO'U_1EQV?
M]=4359`4`<OX^_X]K3_?;^0KZCAWXZGR_4\'._X</4X:TL?[4\3V]F\\L<31
M9(1B.YJ,\KU:>(2A)I6Z.W5DY/2ISHR<HIZ]5Y'73^"(;*WDFM[R8E%+$2-D
M$`>]<&!S#$4Z\5S-INUGKN=^*P-"=)^ZDTMUH<G?2M;VS31L5>(AE(['-?5Y
MO%2P<[]/\SYG+I..*A8]1TV\5M'AN[APB^6&9F.`*^!A"522A!7;/M92C!.4
MG9(Q[OQE;QN5M+9Y@#]YVV@_A7T5'A^I)7JSMZ:GAU<ZIQ=J<;_@+9^,;:1P
MMU;O!G^)6W`?UJ,1D%:FN:E+F\MF51SFG-VJ1Y?Q.A@FCN(A)"ZNC="#7SS3
MB[,]M--71P_C!;"XU>1)XKA9(\`M%)MW<"OH\'EN)K4(SA6<4^FO^9X>+QU"
MC6<)TKM==/\`(U?"\>G6.FH^F.TL2!W8$\Y"Y(KYU4^>O&G?=V/<4TJ+G;I<
MDMO&-G)*%F@D@4C[Q;=^@%>YB,CK48IQES-NUK'CT<WI5)-27*EUN0W'C.-9
M,6]DSH/XG?:3^`%=5/AZ3C[]2S\D85,[BG:$+KS9I:3XBL]181C,$W]QSU^A
MKR,;EU7!-<VJ?4]'"8ZGBKJ.C70R/&FJ)(6TX1,&C=7WYX/'I^->[D>"<%]9
MOHTU;YGE9OBD[X>VJL[_`".'O;!KF]M[@2!1"#E2.M=N8Y;+%U(S4K61QY=F
M$<&I)QO<//CGMV:)LC(_F*^1DURNQ]M?FC<V->_X^+'_`*]?ZBO+RW[9TU>A
M57[BU^CY3_NJ]6?"9W_O7R0[P]_QZ:E_U_1_SK\[S+_D;/UD?18#_=(>AI7W
M_'E/_P!<V_E6YTE36/\`CWTG_KW;^4=<F7_Q9_UU/0G\,1-%N1I^JVUZZ%TA
M+':#@G*,O]:^FH996Q<;K1=V>+C<RHX;W'K+LOU.E7QI\_SV&$]I.?Y5V2X=
MT]VIKZ?\$\A9XKZPT]?^`6;35+:^BN3$VQY+ZW<1MPV,Q#^8-?GN?9?B,'BD
MZD='%V?1Z,]W!XNEB87IO7MU)-?XTK6#Z7<)_(0G^E>=E5"IB,91ITU=Z_J=
M%>K"C3E.;LD<E/>AXWC1#AE*Y)]:_4X</RM[]2S\D?-SSN*?N0T\V='IOBZW
M"10W5N\050N]6W#@8Y%88C(*M.+E2ES>6S-*.=4Y.U2-OQ.E@FCGC62%PZ-R
M"*^<V/=]#S/462:#3@C@F&###T)"_P"%>IE&25Y\U6I[L7MW];')CLXHX=JG
M!<TEOV0W2&6VUBRGE8+'%*&8^@P1_6O4Q63580O2?-Y;,XJ.>4ZKY:D>7SW1
MGZW_`,@^[Q_=->YF7^YS]#Y[!_[W#U/2/!O_`"+EG_N"OSL^Y.)U?_CWTG_K
MW;^4=<^7_P`6?]=3OG\,0\/?\C#IO_7P/_06KTZOPG//8]/KD,#&\1Z7;RZ=
M>W$>;><0NQ>,#Y_E/WAT/UZ^]8U:<9J[6Q<9RCH@OH3"NL[YI)G:P4LSGO\`
MO>@Z`>PKXV#OR65M?\C8SO%7_(>_[=8__0Y*]_)/X,O7]#*IN0^'_P#D/VW_
M`%SE_D*]MF9V*_>%2!YIKW_'K8_]=I?_`&:N;!_[S/\`KJ=TOX<2II?_`"%]
M/_Z^H?\`T,5ZM3X682V/6H.]<9@)/_KFH`CH`*`(9_\`6V__`%T/_H+5$MX^
MOZ,N.S_KJB:K("@#E_'W_'M:?[[?R%?4<._'4^7ZG@YW_#AZG(6A-IJ"7T'$
MZ+M!/(Q]*]W$Y=A\5-3JK7U/#P^.K8:+C3>GH:.H:_J-Y`8KFX"Q'[RJH4'Z
MU-#+<+A9<\8Z]VRZN88BO'D;T\CF[AVU:ZBTS3_WI=QYCKR``>F:\7.<QA.'
ML*3OW?Z'IY5@)QG[:HK6V_S.T\4R/9V=EI:L0J1AW]ST'\C6G#^'7+*N]]E^
MH\ZKM<M)>K.5TW3[KQ%KCV,,S6]M!C>R'!8_6N/-LQK.NZ5.5E'MU9MEF!I>
MR56:NWWZ'1:OX8.CV0FBN'FC4@'?R1^-=62YA5J3="J[]GU,LUP5.%/VU-6M
MN1^%M7>PU:*T=CY%SD`'LPKGS_#QIU8U8_:W]4:9+7<H2I/IL)XJ_P"0_=?4
M?^@BO?RG_<Z?I^IY&:?[U+Y?D/\``'_(NS?]MO\`T$U\)0_WNG_B_4^P_P"8
M:7^']#GM3N'M;&26(`N,!<^I.*_0,PQ$L-AY5([]/F?$8.BJ]>--[,W=#\'3
M'2#J%U>RF=D+[2?EZ9Z5\=@\PQ$<1%RFVF];GUF(P-"5%Q44K+0P[Z9[>))H
MB5>.12"/K7TV=Q3P<O)K\SYS*FUBHV\_R.M\46:2:?;:GTED"JP'?CK^E>1D
M-:HZKIM^ZEM\SULXHP5+VB6MUJ<%K4EP-0M(8+B2%9`=VPXS73G6(K4JL(TY
M-)I['/DV'I5HS]I%/8E@LUL[1HU8GY@<GZBOG''EBSZNW+&R-W7O^/BQ_P"O
M7^HKS<M^V=-7H55^XM?H^4_[JO5GPF=_[U\D.\/?\>FI?]?T?\Z_.\R_Y&S]
M9'T6`_W2'H:5]_QY3_\`7-OY5N=)6U09AT@=OL[?R2HR:E[;%NF^K_4Z,;5]
MAA_:=D9.K7,EM;`P#,TC!$]B>]?H&9XIX+#WI[[+R/@L%0^MXBTWYLZ71/`L
MOV);BYOYC<2#=@ME?RKXZEF.)I3Y^=OR>Q]5/`X><.3D2]#(NXY;.X=0=LUN
M^01_>4Y'ZBOL<;AZ>8X%Q:^)77D['R=*<L%BM.CM\C<O+M]8\)W=_!RXN8VV
MDX4DI$O/YU^5Y/CIY7C%&$4^96U]6]#[/&86.+I<LFTEKH<=-87]U=,;F?[/
M$B_*D3GDXK[>K+,<;/FA%Q7K;_(\BE#`X.+C.2D_O_S-62."$(EM)+(H49:3
MKGO7TN`A7IT5'$.\CP<;.C.KS4%9&MX)U26'2M77<?\`1F?R\]O2OC%0C4S%
MTNG,_P`SZFG5=/`JIU4?T.7UR\DM++=!_K9&"*?3/>OJ\UQ4L+0O3W;LCYO+
ML,L37Y9[+5C=!TZ[>\MHS=2,]P^TJYR.A/\`2OF<-CZ^'FIRFVNJ9]3B,NH5
M*3BHI/I8GU@8TRY'HAKZO,_]SJ>A\C@E;$P7F>D^#?\`D7+/_<%?G1]T<3J_
M_'OI/_7NW\HZY\O_`(L_ZZG?/X8AX>_Y&'3?^O@?^@M7IU?A.>>QZ?7(8%/6
MO^0-??\`7O)_Z":F7PL"OJW_`#&/^P>O_M:OAZ?V/7_(Z69/BK_D/?\`;K'_
M`.AR5]#DG\&7K^AE4W(?#_\`R'[;_KG+_(5[;,SL5^\*D#S37O\`CUL?^NTO
M_LU<V#_WF?\`74[I?PXE32_^0OI__7U#_P"ABO5J?"S"6QZU!WKC,!)_]<U`
M$=`!0!#/_K;?_KH?_06J);Q]?T9<=G_75$U60%`'+^/O^/:T_P!]OY"OJ.'?
MCJ?+]3P<[_AP]3AK+3H=4\5V]K<EO*:+)"G'<UCGTI1Q$;/I^K'DL4Z,KKK^
MAVW_``K[1<_,DC`=BQ-?/N4GHV>XHQ6R-G2M"T[21BRMU0^N.:D9SOCN%EOX
M)L?*\>W/N#_]>OL^'ZB="4.J?YGR^=TVJD9]&K%7X=A;?5[Z-AAIL.A]1WKP
M<WH2HXJ3:TEJCU<KK1J8=16ZT9O^-KJ.+2_LQ8>;,PPO<`<YKKR&A*5?VMM$
MOQ9EF]:,*'L^K.`MV,OB;3((QEE8NV.PZ?XUT<0U4Y0IK=79R9)3:YZG38VO
M%'_(>N?JO_H(KVLI_P!SI_UU/-S3_>I?+\B3P!_R+LW_`&V_]!-?"4/][I_X
MOU/L/^8:7^']#FM9_P"/(?\`71/_`$(5]KG?^YOU7YGR.5?[U'Y_D>JVW_(`
M'_7N?_0:^*P_\:'JOS/L*GP2]&>5ZM_QY'_?3_T(5]OG7^YR^7YGQN5_[U'Y
M_D=UXC_Y%6S_`-Y/Y&O!R#_>9>GZH]W.?]V^:_4\XUCC6+#Z&M\^_CT_1F.0
M_#/U1?N/]2?J/YBO%G\+/II;,U->_P"/BQ_Z]?ZBO+RW[9O5Z%5?N+7Z/E/^
MZKU9\)G?^]?)#M`^2UU$/\I:]0@'C(SUKX+,<-6>:.2@[7EK9V/>P-:G'"P3
MDMNZ-&]=39S@,I)C;`!]JV^KUOY']S.CV]+^9?>BMJ;+Y6DX(.(&!P>APE1D
MG-A\<_:*WKIO<WQZ5?".--WTZ&;=Q[GMI,9$,RNP]NA_G7VN=T)5L->"ORNY
M\9E5:-+$>]HFK'K,$T0LDF+*L00,6)X`Q7PT(N<E&*NV?8MJ*N]$>9:]>H\]
M[>=$+,XSZ=J_1';!X/WOLQ_0^'F_K6*?)]IC=%N9[?PLEF,HLTV]_<!$P/Z_
ME7R7#6!HU:\\5-7E'1>6]WZGNYU7G3IQI1T3W,JZO+YKV2UL84'EIN+OSGC/
M`KULRS>MAJSHTXI6ZLX\!EE/$4_:3?R1J-:3V06*ZG2>8J'8H``N1G%>IEE:
MM6PZJ5MW\M#AS&C2HUN2ELE^):\%Q--8Z_&HRQ9B!]#FOE:=14\SYG_,_P`=
M#Z)0<\O45_*8FNPM):QNH)\J0,0/3H:^ASNC*IAU**^%W^1X>458T\3:3W5C
M2T2XCM]4L+ASB..3<3[;37RT*4J\E3@KMGV=>I&E3<Y:)%/6CG3;H^JDU]GF
M2M@ZB\CX/!.^*@_,])\&_P#(N6?^X*_.S[DXG5_^/?2?^O=OY1USY?\`Q9_U
MU.^?PQ#P]_R,.F_]?`_]!:O3J_"<\]CT^N0P*>M?\@:^_P"O>3_T$U,OA8%?
M5O\`F,?]@]?_`&M7P]/['K_D=+,GQ5_R'O\`MUC_`/0Y*^AR3^#+U_0RJ;D/
MA_\`Y#]M_P!<Y?Y"O;9F=BOWA4@>::]_QZV/_7:7_P!FKFP?^\S_`*ZG=+^'
M$J:7_P`A?3_^OJ'_`-#%>K4^%F$MCUJ#O7&8"3_ZYJ`(Z`"@"&?_`%MO_P!=
M#_Z"U1+>/K^C+CL_ZZHFJR`H`YKQY#(]A#+'&SB)B6"C)Y'85[64XZE@Y3=2
M^MMCR\RPE3%0C&GT.1\*PW$WBZWN!;31Q+'M)=,<Y-99IBZ>+K*=/:UM2LMP
MM3"TW&>]SU.O*/2"@#/US35U.R,)X<<H?0UU83%5,)4]I3_X<PQ&'AB(.$SS
MZ\@O-*G/G03QE.DD:DC\"*^JAG6$K1M6C;R:NCYN>4XFE*])W^=F9T]_=7,A
M6UM;FZG;^*12!^)/-16SS#TH<N'C?Y615/**]65ZSM^+.K\">%)[&=M3U0[K
MJ3H/[M?)5:LZTW.;NV?2TJ4*,%""LD5/&:36^M2RFWFD27!4QKN[#K7T^!S?
M#X?#QI3O=>1X&-RRO7KRJ0M9^99\!VD\>A-%+$T;R>;M##'5:^7IU%#$0F]D
M[GT'(_82AUM8Y;5H+E\VB6EP9%D7G9\O!]:^DS+-</BL.Z=.]].AX&!RVOAZ
MZJ3M97ZGJEK&QT58L88P[<'UQ7SM&2A4C)[)H^@FKQ:1Y9JD%RVZT6TN#('4
M9"?+P1WKZ/,<VP^)P\J4+W=NGF?/8++*]"O&I.UEYG<^*G6S\#-/,C-]G6-M
MHX.2P7_V:O&R_%_4ZZJ-76S/8QF'^LT73O9G!WU[;6LI6ZBD\R)RN#$20P."
M`?P-?42SC`3U>K7EJ?.QRK&P=HZ)^95LIY9[-FE4K\PQGTR*^3;O%L^QA=4[
M/>QT&O?\?%C_`->O]17FY;]LZZO0S9KQ(&BB*2N\AVJ$7.3R:^RPF:X?!X=1
MJWT\CY7,\MKXFO[2%K674:]]Y:%GM;L*&V$^5W]*Z(\1X&3LF_N/,_L7%+M]
MY&=4B4$FWN0!S_J__KUK_;V%\_N#^QL3Y?>5A<37&J1,$E2W,9*AUQD\9_I7
MS>,Q5+%XIU*6UDCZ/+,-4PM'DJ=[_D:$;S^>D*PO,7SM*=>`3T^@KV,-G/LH
MJ-=7\U^IYV.R;GDZE%VOT_R'SZE)%'Y#K>%5Z1;&Q^72NK^ULOIOGBM?*.IY
MW]FXZ2Y'MZZ$%II&I>()D\V!K6QBGC1@W5BS*.?^^A7R&=Y\ZW[M:+>W^9[F
M`RR.&]]N\OR]#L=?TN*VTB[:!"?L=RBJ!U(:.)?YD5Y/#N=2P6)49*\9K7R:
M;U-\QP*Q=.R=FMCC)]3@MR2T<V]1T$9S^=?HM3-\!)<TE=^FOXGSD,LQL':.
MB]2S:1ZC):27<UA*D.1Y849;'O6%#/Z;<O:QLNEM=/,VJY+427LW=];Z?<=!
M\-XV2]OPT$L:3'</,7'UKYO&5*=6O*I3V;N>[A*<Z5&,*FZ,&_;[!':O.'9;
MB+>&49[#.?SKV\LXAC4BZ>(6L>O<\O'Y')2]IA]GT_R,UM5$CK;:9;R2SR':
MHV;5!KIKYQAZ,7]6C[SZVLCGI97B:C2Q$K17G<N:Q;W:6DEJ]G<&5TQPG&:C
M%YQAZV&E35[M=AT,KK4J\9Z63[]#TKPE$\.@6B2*594&0:^3/I3AM7_X]])_
MZ]V_E'7/E_\`%G_74[Y_#$/#W_(PZ;_U\#_T%J].K\)SSV/3ZY#`IZU_R!K[
M_KWD_P#034R^%@5]6_YC'_8/7_VM7P]/['K_`)'2S)\5?\A[_MUC_P#0Y*^A
MR3^#+U_0RJ;D/A__`)#]M_USE_D*]MF9V*_>%2!YIKW_`!ZV/_7:7_V:N;!_
M[S/^NIW2_AQ*FE_\A?3_`/KZA_\`0Q7JU/A9A+8]:@[UQF`D_P#KFH`CH`*`
M(9_];;_]=#_Z"U1+>/K^C+CL_P"NJ)JL@*`$(!&"`1[T`($13\JJ/H*`'4`%
M`!0`UD5QAE##W%`#4@A0Y2)%/L*`)*`$**?O*#]10!#(H6Y@"@`?-T^E1+XH
M_,M?"R7RTSG8OY59`Z@!OEIG.Q?RH`YOXG#_`(H74QVQ'_Z-2D]F-;G-ZY#$
MFGQ!4``OI0._&9:X,!)RK)OM^AZ%1)1LNYC3E1&4!`/!Q[9%>[/X6<TMC5U[
M_CXL?^O7^HKR\M^V;U>A!H@!\4:("`1]L_\`:<E7FW^YS_KJ8/H=CKR(-(N<
M(H_XF8[>XKYG+F_K4/3]"9_"<]?(HLI_E'^K;M[5]:8%35U`M])P`/\`1V_E
M'7)E_P#%G_74]"?PQ)O"?_(S6'^])_Z+>O2J_"<T]CT9K>%CEHD)]=M<IB9K
MJ%2]"@`?VA;\#_MC7S&9_P"]?]N_HS:'PE?7O^07K'_7Y!_*&N?`?[S2_KN.
M6S.9NXT-O,2BYV-SCVK[(YSO;)5^PVXVC'E+QCV%0,F5%4_*H'T%`'F.L?\`
M'MI/_7NW\HZY\O\`XL_ZZG?4^&(WPZBCQ#IN%`_?CM_LM7IU?A.:>QZ>40G)
M53]17(8C@`.!Q0!YAJ__`![Z3_U[M_*.N?+_`.+/^NIWS^&(>'O^1ATW_KX'
M_H+5Z=7X3GGL>GUR&!3UK_D#7W_7O)_Z":F7PL"OJW_,8_[!Z_\`M:OAZ?V/
M7_(Z69/BK_D/?]NL?_H<E?0Y)_!EZ_H95-R'P_\`\A^V_P"N<O\`(5[;,SL5
M^\*D#S37O^/6Q_Z[2_\`LU<V#_WF?]=3NE_#B5-+_P"0OI__`%]0_P#H8KU:
MGPLPEL>M0=ZXS`2?_7-0!'0`4`0S_P"MM_\`KH?_`$%JB6\?7]&7'9_UU1-5
MD!0`4`%`!0`4`%`!0`4`%`!0!#+_`,?,'_`OY5$OB7S+7PLFJR`H`*`.9^)Y
MQX#U0C@A8^O_`%T2D]AK<XS59[B[C%KO(E^T-*OD@!`K;_F8D_+RV.<#ZUY^
M%E&C/G>UCOG>2L:UKX46.Q:35Y1<RQQEU1.%4XR#GJ2/RX[UE7S.=1\M/1?B
M7&@DO>U*>N_Z^Q_Z]?ZBN_+?MF=7H0Z$0?%.B8(.+S!QV_=R5>;?[G/^NI@S
ML]>_Y`]S_P!A,?S%?,Y;_O4/3]!3^$YV^_X\I_\`KFW\J^M.<J:Q_P`>^D_]
M>[?RCKDR_P#BS_KJ>A/X8DWA+_D9K#_>D_\`1;UZ57X3FGL>DURF)E2_=O?^
MPC;_`/M&OF,S_P!Z_P"W?T9M#X2MKW_(+UC_`*_(/Y0USX#_`'FE_7<<MF<Y
M=?\`'K-_US;^5?9'.=W9?\>5O_UR7^0J!DU`'F&K_P#'OI/_`%[M_*.N?+_X
ML_ZZG?/X8AX>_P"1ATW_`*^!_P"@M7IU?A.>>QZ?7(8!0!YAJ_\`Q[Z3_P!>
M[?RCKGR_^+/^NIWS^&(>'O\`D8=-_P"O@?\`H+5Z=7X3GGL>GUR&!3UK_D#7
MW_7O)_Z":F7PL"OJW_,8_P"P>O\`[6KX>G]CU_R.EF3XJ_Y#W_;K'_Z')7T.
M2?P9>OZ&53<A\/\`_(?MO^N<O\A7MLS.Q7[PJ0/-->_X];'_`*[2_P#LU<V#
M_P!YG_74[I?PXE32_P#D+Z?_`-?4/_H8KU:GPLPEL>M0=ZXS`2?_`%S4`1T`
M%`$,_P#K;?\`ZZ'_`-!:HEO'U_1EQV?]=4359`4`%`!0`4`%`!0`4`%`!0`4
M`0R_\?,'_`OY5$OB7S+7PLFJR`H`*`.:^)G_`"(^I?2+_P!&I0!>NM!BC+MI
M8CMBQRT./W3_`(#[OX<>U<]7#QJ:[,VIUI0TZ&)+!/:[[:,&TD=2/(E&8GR/
MX&_P_*O+JT'!WFOF=T*BDO=?R,"^AOKC4+2W:`F<0;!&JX08(_C/!_SQ7H82
MO2H1G*3T,YQE)I&OI'AV.RU33KVZ8/=K<*%"<*F0P/\`O'!ZG\J\['8^6(IR
MBE:-@E14(W>YL:]_R![G_L)C^8KBRW_>H>GZ'-/X3G;[_CRG_P"N;?RKZTYR
MIK'_`![Z3_U[M_*.N3+_`.+/^NIZ$_AB3>$O^1FL/]Z3_P!%O7I5?A.:>QZ3
M7*8F5+]V]_["-O\`^T:^8S/_`'K_`+=_1FT/A*VO?\@O6/\`K\@_E#7/@/\`
M>:7]=QRV9SEU_P`>LW_7-OY5]D<YW=E_QY6__7)?Y"H&34`>8:O_`,>^D_\`
M7NW\HZY\O_BS_KJ=\_AB'A[_`)&'3?\`KX'_`*"U>G5^$YY['I]<A@%`'F&K
M_P#'OI/_`%[M_*.N?+_XL_ZZG?/X8AX>_P"1ATW_`*^!_P"@M7IU?A.>>QZ?
M7(8%/6O^0-??]>\G_H)J9?"P*^K?\QC_`+!Z_P#M:OAZ?V/7_(Z69/BK_D/?
M]NL?_H<E?0Y)_!EZ_H95-R'P_P#\A^V_ZYR_R%>VS,[%?O"I`\TU[_CUL?\`
MKM+_`.S5S8/_`'F?]=3NE_#B5-+_`.0OI_\`U]0_^ABO5J?"S"6QZU!WKC,!
M)_\`7-0!'0`4`0S_`.MM_P#KH?\`T%JB6\?7]&7'9_UU1-5D!0`4`%`!0`4`
M%`!0`4`%`!0!#+_Q\P?\"_E42^)?,M?"R:K("@`H`YKXF?\`(CZE_P!LO_1J
M4`=,WWC0!%<00W,1BN(DEC/57&10&QBWVAN%VP8N;<G)AF/S+_NMW_'GWKBJ
M81/6GH=,,0TK25S,66[@DB,!,_V>57:&XRLJ8[>_7H?SKRJM"R<9*S.IOGC:
M+N-U/4?.T:Y2)9+ITO@\F(_*().0-I/?MU]2:C`TW#%0OII^AQS32U,F"*[U
MBW(LT:'.4=I/]7C\LD_3\:]ZOBZ='1[]A4Z$ZFVQ!JQS:Z0>G^C-_*.IR_6I
M/^NITU-(Q)_"7_(S6'^])_Z+>O3J_"<T]CTFN4Q,J7[M[_V$;?\`]HU\QF?^
M]?\`;OZ,VA\)6U[_`)!>L?\`7Y!_*&N?`?[S2_KN.6S.<NO^/6;_`*YM_*OL
MCG.[LO\`CRM_^N2_R%0,FH`\PU?_`(]])_Z]V_E'7/E_\6?]=3OG\,0\/?\`
M(PZ;_P!?`_\`06KTZOPG//8]/KD,`H`\PU?_`(]])_Z]V_E'7/E_\6?]=3OG
M\,0\/?\`(PZ;_P!?`_\`06KTZOPG//8]/KD,"GK7_(&OO^O>3_T$U,OA8%?5
MO^8Q_P!@]?\`VM7P]/['K_D=+,GQ5_R'O^W6/_T.2OH<D_@R]?T,JFY#X?\`
M^0_;?]<Y?Y"O;9F=BOWA4@>::]_QZV/_`%VE_P#9JYL'_O,_ZZG=+^'$J:7_
M`,A?3_\`KZA_]#%>K4^%F$MCUJ#O7&8!.I\UN#0!'M;^Z:`#:W]TT`0SJWFV
M_!_UA_\`06J);Q]?T9<=G_75$VUO[IJR`VM_=-`!M;^Z:`#:W]TT`&UO[IH`
M-K?W30`;6_NF@`VM_=-`!M;^Z:`#:W]TT`&UO[IH`AE5OM5OP?XOY5$OBC\R
MU\+)MK?W35D!M;^Z:`#:W]TT`<U\3%(\#ZEP?^67_HU*`.F96W'Y30`FUO[I
MH`-K?W30!!>6$5XH$T9W+]V1>'3Z&DTI:-7%Z:>FASNL:'(T>+Z`WD"?,)HD
MVR1XZ94=1],CU%<LJ4XZQ>FNGR*48:65I76MWM=7W\AL%U);QJLR"6!1A985
M^Z/]I1_,?D*\6=+73?L>Q&>E^ARFH3K-:Z4R*PB2W8>8>`2`F<=^*]S+URSG
M<Y:CT1>\,6&HQ:K;ZFEN6MHBQV2G8SY4K\O'OGGCWJ\3F%&#Y$[^A'L)S6AZ
M!9WD-X"(2P=?O1NI5U^H/\^E7"I&HKP=SEE&4'9JQ2E5MM[P?^0C;_\`M"OF
M\S_WK_MW]&:0^$K:\I_LO6.#_P`?D'\H:Y\!_O-+^NXY;,YNZ4_99N#_`*MO
MY5]D<YWEDK?8K?@_ZI?Y"H&3;6_NF@#S#6`?LVD<'_CW;^4=<V7_`,6?]=3O
MJ?#$3P\#_P`)#IO!_P"/@?\`H+5ZE7X3GGL>H;6_NFN0P#:W]TT`>8:P#]FT
MC@_\>[?RCKFR_P#BS_KJ=]3X8B>'@?\`A(=-X/\`Q\#_`-!:O4J_"<\]CU#:
MW]TUR&!3UI6_L:^X/_'O)_Z":F7PL"OJRM_Q..#_`,@]?_:U?#T_L>O^1TLR
M?%2D:]T/_'K'_P"AR5]#DG\&7K^AE4W(?#ZG^W[;@_ZN7^0KVV9G8JK;A\IJ
M0/-->!%K8\'_`%TO_LU<V#_WF?\`74[I?PXE32@?[7T_@_\`'U#_`.ABO5J?
."S"6QZU`K<_*:XS`_]D`
`
end
36644




















#End
