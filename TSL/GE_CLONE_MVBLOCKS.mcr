#Version 8
#BeginDescription
v1.3: 18.apr.2013: David Rueda (dr@hsb-cad.com)
This TSL is used in the cloning process hsb_structuralclone or convertion process hsb_acatohsb and will insert special TSLs based on mvBlock classifications
Will be attached to MVBlocks only.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
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
* v1.3: 18.apr.2013: David Rueda (dr@hsb-cad.com)
	- Bugfix: Filtering out non valid SFWall or Wall entities
* v1.2: 02.apr.2013: David Rueda (dr@hsb-cad.com)
	- Bugfix: Searching body was cutting all blocking body (deleting), as result no point was available hence error message
* v1.1: 01.apr.2013: David Rueda (dr@hsb-cad.com)
	- Bugfix: when bdMvbMoved the assignation of points where being done when no points where available
* v1.0: 31.ene.2013: David Rueda (dr@hsb-cad.com)
	- Version control
* v0.9: 15.may.2012: David Rueda (dr@hsb-cad.com)
	- Thumbnail added
	- Description made visible to user
* V0.8_May 2 2012__RL__In placing the opening it will find the center point of the MvBlock body that intersects with the wall body and base the opening location on the center point of the resulting body.
* V0.7_April 19 2012__RL__Will now dbCreate an opening for Recessed MVBlocks. No data is attached to the opening
* v0.6: 01.nov.2011: David Rueda (dr@hsb-cad.com): Added flag to cloned GE_WALL_SECTION_BLOCKING TslInst to make it load values from certain catalog
* V0.5_RL_Sept 6 2011__Will move a block 2 inches upwards in case it cuts the wall__ Will take the realbody of the block with an isometric vector to make sure it gets the body of model display
* V0.4_RL_Sept 8 2010_Added special framing for tubs and toilets ("PLUMBING - VOID 12","PLUMBING - TUB SHOWER CENTERED")
* V0.3_RL_July 16 2010_Fixed lower block location in no stud area
* V0.2_RL_June 24 2010_Can insert on a wall with no hsbCAD data
* V0.1_RL_June 22 2010_Used to clone or convert ACA rules for MVBlocks
*/

Unit(1,"inch");
int bOnInternalDebug=0;
if(bOnInternalDebug)reportMessage("\n*TSL " + scriptName() + " has been inserted");
//////////////////////////////////////////////////////////////////////////////////////////////////// SET SOME PROPERTIES /////////////////////////////////////////////////////////////////////////////////////////////////////

int strProp=0,nProp=0,dProp=0;
String arYN[]={T("Yes"),T("No")};

PropString strEmpty0(strProp,"- - - - - - - - - - - - - - - -",T("Empty 1"));strProp++;
strEmpty0.setReadOnly(true);

PropString strEmpty1(strProp,"- - - - - - - - - - - - - - - -",T("Empty 2"));strProp++;
strEmpty1.setReadOnly(true);

// bOnInsert
if (_bOnInsert){
	
	//showDialogOnce("_Default");
	PrEntity ssE("\nSelect a set of MVBlocks", MvBlockRef ());
	if (ssE.go())
	{
		Entity ents[0]; 
		ents = ssE.set(); 
		// turn the selected set into an array of elements
		for (int i=0; i<ents.length(); i++)
		{
			if (ents[i].bIsKindOf(MvBlockRef()))
			{
				_Entity.append(ents[i]);
			}
		}
	}
	
	if(bOnInternalDebug)reportMessage("\n*TSL " + scriptName() + " on insert and recieved " + _Entity.length() + " MVBlock entities.");
	
	//CLONE IT AND DO SOMETHING WITH EACH BLOCK
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
		
	for(int i=0; i<_Entity.length();i++){
		lstEnts[0] = _Entity[i];
		tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString );
	}
	eraseInstance();
	return;	
	
}//END if (_bOnInsert)

if(_Entity.length()==0){
	
	if(bOnInternalDebug)reportMessage("\n*TSL " + scriptName() + " erased due to no entity to work on.");
	
	eraseInstance();
	return;
}

MvBlockRef mvB;

//take first valid block
for(int mv=0;mv<_Entity.length();mv++){
	if (_Entity[mv].bIsKindOf(MvBlockRef())){
		mvB=(MvBlockRef)_Entity[mv];
		break;
	}
}

if(!mvB.bIsValid()){
	reportMessage("\n*No Valid MvBlock found");
	eraseInstance();
	return;
}	
MvBlockDef mvDef=mvB.definition();
if(bOnInternalDebug)reportMessage("\n*Working on MVBlock " + mvDef.entryName() + ".");

CoordSys csMv=mvB.coordSys();
_Pt0=csMv.ptOrg();

//Get block classification
Map mpClassMv=mvB.getClassificationMap(TRUE);

int bNeedsUpperBacking=0,bNeedsLowerBacking=0,bIsRecessed=0;
int bElementSearchType=-1;//-1=nothing 0=Wall, 1=floor, 2=ceiling
int bIsTubSpecial=0,bIsStandardVoid=0;//some special items atteded for BCMC
int bBodyAsCircle12=0;

//recessed Properties
double dRecessWidth,dRecessHeight;
if(mpClassMv.hasString("ITWBFraming"))
{
	//get the value to see what to do
	String strActionFlag=mpClassMv.getString("ITWBFraming");
	strActionFlag.makeUpper();
	
	//only look at walls for now
	bElementSearchType=0;
	
	if(strActionFlag=="CABINET - BASE")
		bNeedsUpperBacking=1;	
	if(strActionFlag=="CABINET - TALL")
		bNeedsUpperBacking=1;
	if(strActionFlag=="CABINET - WALL")
	{
		bNeedsUpperBacking=1;	
		bNeedsLowerBacking=1;
	}
	
	if(strActionFlag=="RECESSED")
	{
		bIsRecessed=1;
		double dMvbX=mvB.dScaleX(),dMvbY=mvB.dScaleY(),dMvbZ=mvB.dScaleZ();
		String arNames[] = mvDef.attachedPropSetNames();

		Map mpPropSetStyle=mvDef.getAttachedPropSetMap("FramedOpeningStyleFixed");
		
		if(mpPropSetStyle.hasDouble("FramedOpeningHeight"))
		{
			dMvbZ=mpPropSetStyle.getDouble("FramedOpeningHeight");
		}
		if(mpPropSetStyle.hasDouble("FramedOpeningWidth"))
		{
			dMvbY=mpPropSetStyle.getDouble("FramedOpeningWidth");
		}		
		
		dRecessWidth=dMvbY;
		dRecessHeight=dMvbZ;
	}
	if(strActionFlag=="PLUMBING - VOID 12"){
		bIsStandardVoid=1;
		bBodyAsCircle12=1;
	}
	if(strActionFlag=="PLUMBING - TUB SHOWER CENTERED"){
		bIsTubSpecial=1;
		bBodyAsCircle12=1;
	}
}
else //nothing to do
{
	eraseInstance();
	return;
}		

//Get model shape of the block
Vector3d viewDir=_XW-_YW-_ZW;
viewDir.normalize();

Body bdMvb=mvB.realBody(viewDir);
Point3d ptMvbCen=bdMvb.ptCen();
Point3d arPtMvb[]=bdMvb.allVertices();
double dMvbElevToCen=ptMvbCen.Z();

//transform body when needed
if(bBodyAsCircle12){
	bdMvb=Body(_Pt0-csMv.vecZ()*U(12),_Pt0+csMv.vecZ()*U(12),U(6));
	arPtMvb=bdMvb.allVertices();
}

//sort points in Z to get upper and lower points
arPtMvb=Line(csMv.ptOrg(),csMv.vecZ()).orderPoints(arPtMvb);
Point3d ptMvbUpper,ptMvbLower;

//for now, end if body is not valid
if(arPtMvb.length()==0)//nothing to do
{	
	eraseInstance();
	return;
}			

ptMvbUpper=arPtMvb[arPtMvb.length()-1];
ptMvbLower=arPtMvb[0];

//collect all walls
Group grAll("");
Entity arEntElements[0];
if(bElementSearchType==0)
	arEntElements.append(grAll.collectEntities(TRUE,ElementWallSF(),_kModel));
else if(bElementSearchType>0)
	arEntElements.append(grAll.collectEntities(TRUE,ElementRoof(),_kModel));
//-1=nothing 0=Wall, 1=floor, 2=ceiling

//loop over each wall and insert slaves at correct locations
for(int i=0;i<arEntElements.length();i++)
{
	ElementWallSF el=(ElementWallSF)arEntElements[i];
	Wall w=(Wall)arEntElements[i];
	CoordSys csEl(arEntElements[i].coordSys().ptOrg() ,arEntElements[i].coordSys().vecX(),_ZW,arEntElements[i].coordSys().vecX().crossProduct(_ZW));

	//see if it is valid
	if(!w.bIsValid() || !el.bIsValid()) // v1.3: DR 18.apr.2013
	{
		continue;
	}
	
	csEl=el.coordSys();
		
	//set proper elevation
	dMvbElevToCen=csEl.vecY().dotProduct(ptMvbCen-csEl.ptOrg());

	//Create a body of the wall
	Body bdWall=w.realBody();
	if(bdWall.volume()<U(1))//hmm must has wall model turned off
	{
		PLine plRec;
		plRec.createRectangle(LineSeg(w.ptStart()+csEl.vecZ()*0.5*w.instanceWidth(),w.ptStart()-csEl.vecZ()*0.5*w.instanceWidth()),csEl.vecZ(),csEl.vecX());
		bdWall=Body(plRec,csEl.vecY(),w.baseHeight());
	}

	//Find a vector of what side the block is on. This vector goes towards the wall perpendicularly.
	Vector3d vDirTmp=csEl.vecX().crossProduct(_ZW);vDirTmp.normalize();
	Vector3d vDir=Vector3d(csEl.ptOrg()-ptMvbCen).dotProduct(vDirTmp)<0?-vDirTmp:vDirTmp;

	//create a copy of the mvb body and move towards the wall
	Body bdMvbMoved=bdMvb;
	bdMvbMoved.transformBy(_ZW*U(2));
	bdMvbMoved.transformBy(vDir*U(2));

	//see if it intersects
	if(bdMvbMoved.hasIntersection(bdWall))
	{
		//reset some data
		if(bOnInternalDebug)
			reportMessage("\n*Block " + mvDef.entryName() + " intersects with a wall.");
		
		//create a body on both faces of the wall
		double dSearchOffset=U(50,3);
		Body bdIn,bdOut,bdMvbCut;
		Point3d ptIn=csEl.ptOrg()+csEl.vecZ()*dSearchOffset;
		//bdIn=Body(w.ptStart()+csEl.vecZ()*0.5*w.instanceWidth(),csEl.vecX(),csEl.vecY(),csEl.vecZ(),U(2000),U(2000),U(50),0,0,1);
		bdIn=Body(ptIn,csEl.vecX(),csEl.vecY(),csEl.vecZ(),U(2000),U(2000),U(50),0,0,1);// v1.2: DR 02.apr.2013
		
		Point3d ptOut=csEl.ptOrg()-csEl.vecZ()*(el.dBeamWidth()+dSearchOffset);
		//bdOut=Body(w.ptStart()-csEl.vecZ()*0.5*w.instanceWidth(),csEl.vecX(),csEl.vecY(),csEl.vecZ(),U(2000),U(2000),U(50),0,0,-1);
		bdOut=Body(ptOut,csEl.vecX(),csEl.vecY(),csEl.vecZ(),U(2000),U(2000),U(50),0,0,-1);// v1.2: DR 02.apr.2013
		bdOut.vis(2);ptOut.vis();bdIn.vis(2);ptIn.vis();

		bdMvbCut = bdMvb;
		bdMvbCut -= bdIn;
		bdMvbCut -= bdOut;

		ptMvbCen=bdMvbCut.ptCen();
		arPtMvb=bdMvbCut.allVertices();
		dMvbElevToCen=ptMvbCen.Z();
		
		//sort points in Z to get upper and lower points
		arPtMvb=Line(csMv.ptOrg(),csMv.vecZ()).orderPoints(arPtMvb);

//		if(arPtMvb.length()==0)
		if(arPtMvb.length()>=2) // v1.0: DR 31.ene.2013
		{  
			ptMvbUpper=arPtMvb[arPtMvb.length()-1];
			ptMvbLower=arPtMvb[0];
		}
		
		//sortPoint and copy because line sorting can remove points...
		Point3d arPtX[]=Line(csEl.ptOrg(),csEl.vecX()).orderPoints(arPtMvb);
		double dLgt=csEl.vecX().dotProduct(arPtX[arPtX.length()-1]-arPtX[0]);
		double dUpperElev=csEl.vecY().dotProduct(ptMvbUpper-csEl.ptOrg());
		double dLowerElev=csEl.vecY().dotProduct(ptMvbLower-csEl.ptOrg());
		
		if(bIsRecessed){
			/*
			commentted out because new now create an opening
			
			TslInst tsl;
			String sScriptName = "GE_WALL_NO_STUD_AREA_BLOCKING";

			Vector3d vecUcsX = _XW;
			Vector3d vecUcsY = _YW;
			Beam lstBeams[0];
			Entity lstEnts[0];
			lstEnts.append(w);
			Point3d lstPoints[0];
			lstPoints.append(_Pt0);//insertion point
			lstPoints.append(_Pt0);//side of wall
			int lstPropInt[0];
			lstPropInt.append(0);//hatch angle
			double lstPropDouble[0];
			lstPropDouble.append(dRecessWidth);//recess width
			lstPropDouble.append(U(2));//hatch scale
			lstPropDouble.append(U(3));//minimum block length
			lstPropDouble.append(dMvbElevToCen-(dRecessHeight/2+U(.75)));//elevation 1
			lstPropDouble.append(dMvbElevToCen+(dRecessHeight/2+U(.75)));//elevation 2
			lstPropDouble.append(U(0));//elevation 3
			lstPropDouble.append(U(0));//elevation 4
			
			String lstPropString[0];
			lstPropString.append("- - - - - - - - - - - - - - -");//blank prop
			lstPropString.append(T("ANGLE"));//Hatch
			lstPropString.append("- - - - - - - - - - - - - - -");//blank prop		
			lstPropString.append("Stud Size");//choices = Stud Size,2x4,2x6,2x8,2x10,2x12
			lstPropString.append("Stud Size");
			lstPropString.append("Stud Size");
			lstPropString.append("Stud Size");				
			lstPropString.append("- - - - - - - - - - - - - - -");//blank prop		
			lstPropString.append(T("Flat"));//choices = T("Upright"),T("Flat")};
			lstPropString.append(T("Flat"));
			lstPropString.append(T("Flat"));
			lstPropString.append(T("Flat"));			
				

			tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString );
			*/
			
			//create the opening here
			Point3d ptOrg = _Pt0 - csEl.vecX()*dRecessWidth/2;
			ptOrg = ptOrg.projectPoint(Plane(csEl.ptOrg(),csEl.vecZ()),U(0));
			ptOrg = ptOrg.projectPoint(Plane(ptMvbCen,csEl.vecY()),U(0));
			ptOrg.transformBy(-csEl.vecY()*0.5*dRecessHeight);

			CoordSys csOp(ptOrg, csEl.vecX(), csEl.vecY(), csEl.vecZ());
			int openingType = _kOpening;
			String strStyleName = "";
			int bStoreRoughDimensions = FALSE; // only meaningful in case of window or door with non zero frame width
			
			Opening opNew;
			opNew.dbCreate(openingType, dRecessWidth, dRecessHeight, csOp, strStyleName, bStoreRoughDimensions, w);
			
			if(bOnInternalDebug)reportMessage("\n*Just ceated a new opening for block "+mvDef.entryName() + ".");
			
			//Recess is only inserted once so break here
			break;
	
		}
		else if(bNeedsUpperBacking || bNeedsLowerBacking){
			
			TslInst tsl;
			String sScriptName = "GE_WALL_SECTION_BLOCKING";

			Vector3d vecUcsX = _XW;
			Vector3d vecUcsY = _YW;
			Beam lstBeams[0];
			Entity lstEnts[0];
			lstEnts.append(w);
			Point3d lstPoints[0];
			lstPoints.append(ptMvbCen);//side of wall
			lstPoints.append(arPtX[0]);//grip 1
			lstPoints.append(arPtX[arPtX.length()-1]);//grip 2
			int lstPropInt[0];
			double lstPropDouble[0];
			lstPropDouble.append(U(3));//minimum block length
			lstPropDouble.append(U(0));//elevation 1
			lstPropDouble.append(U(0));//elevation 2
			lstPropDouble.append(U(0));//elevation 3
			lstPropDouble.append(U(0));//elevation 4
			
			//set some levations
			if(bNeedsLowerBacking)lstPropDouble[1]=dLowerElev;
			if(bNeedsUpperBacking)lstPropDouble[2]=dUpperElev;
			
			String lstPropString[0];
		
			lstPropString.append("- - - - - - - - - - - - - - -");//blank prop
			lstPropString.append(T("2x6"));//choices = OSB,2x3,2x4,2x6,2x8,2x10,2x12
			lstPropString.append(T("2x6"));
			lstPropString.append(T("2x6"));
			lstPropString.append(T("2x6"));
			lstPropString.append("- - - - - - - - - - - - - - -");//blank prop
			lstPropString.append(T("Upright"));//choices = T("Upright"),T("Flat")};
			lstPropString.append(T("Upright"));
			lstPropString.append(T("Upright"));
			lstPropString.append(T("Upright"));			
			lstPropString.append("- - - - - - - - - - - - - - -");//blank prop
			lstPropString.append(T("Standard"));	//dimstyle		
			Map map;
			map.setInt("SET_PROPS_FROM_CATALOG",1);	

			tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString,1,map);
		}

		if(bIsTubSpecial || bIsStandardVoid){
			
			TslInst tsl;
			String sScriptName = "GE_WALL_NO_STUD_AREA_BLOCKING";

			Vector3d vecUcsX = _XW;
			Vector3d vecUcsY = _YW;
			Beam lstBeams[0];
			Entity lstEnts[0];
			lstEnts.append(w);
			Point3d lstPoints[0];
			lstPoints.append(_Pt0);//insertion point
			lstPoints.append(_Pt0);//side of wall
			int lstPropInt[0];
			lstPropInt.append(0);//hatch angle
			double lstPropDouble[0];
			lstPropDouble.append(U(12));//recess width
			lstPropDouble.append(U(2));//hatch scale
			lstPropDouble.append(U(3));//minimum block length
			if(bIsTubSpecial){
				lstPropDouble.append(U(24));//elevation 1
				lstPropDouble.append(U(72));//elevation 2
			}
			else{
				lstPropDouble.append(U(0));//elevation 1
				lstPropDouble.append(U(0));//elevation 2				
			}
			lstPropDouble.append(U(0));//elevation 3
			lstPropDouble.append(U(0));//elevation 4
			
			String lstPropString[0];
			lstPropString.append("- - - - - - - - - - - - - - -");//blank prop
			lstPropString.append(T("ANGLE"));//Hatch
			lstPropString.append("- - - - - - - - - - - - - - -");//blank prop		
			lstPropString.append("2x6");//choices = Stud Size,2x4,2x6,2x8,2x10,2x12
			lstPropString.append("2x4");
			lstPropString.append("Stud Size");
			lstPropString.append("Stud Size");				
			lstPropString.append("- - - - - - - - - - - - - - -");//blank prop		
			lstPropString.append(T("Upright"));//choices = T("Upright"),T("Flat")};
			lstPropString.append(T("Upright"));
			lstPropString.append(T("Flat"));
			lstPropString.append(T("Flat"));			
			
			tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString );
			
			//Recess is only inserted once so break here
			break;
		}
	}// END if(bdMvbMoved.hasIntersection(bdWall))
}// END for(int i=0;i<arEntElements.length();i++)

eraseInstance();

Display dp(-1);
PLine plC;
plC.createCircle(_Pt0,csMv.vecZ(),U(3));
dp.draw(plC);



#End
#BeginThumbnail
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
M11104%%%%`!1110`4444`%%%%`$+VZMRORG]*K,C(<,,5?I&4,,,,BNNEBY0
MTEJCPL=D5"O[U+W9?@_E_D9]%6)+8YRG(]*KD8.#7I4ZL:BO%GR&*P5?"RY:
ML;>?1^C"BBBK.0****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"I(()KF98;>*265ONI&I9CWX`KI]"\#7VHL);\265L,'#+^\?GD`'[O0\
MGVX->AZ3HMCHMN8;*';NQO=CEG(&,D_T'')XKQ,=GE##WC3]Z7EM\W_E^!M"
MDY;G(:-\._N3:O-Z'[/"?H<,WY@@?@:[N""&VA6&WBCBB7[J1J%4=^`*<SJG
M4_A4#S,W`X%?)XC%8G&RO5>GX'3&,8[$DS1-&\4BK(K`JR$9!!Z@UBBWAM<P
MV\2Q1`DA%Z#)R<>G)/%:-4Y_]<U*,>2-DP9):_Q_A5BJ]K_'^%2RS1P1F2:1
M(XQU9V``_$U:!)MV0^J>HZI::7")+J3;NSL4#+,1V`_R.17-:KXQ+!HM-4KS
M_KW`]>RGUXY/Y5RDLTD\ADFD>20]6=B2?Q-=]'`REK4T1[N#R2I4]ZO[J[=?
M^`;VK>*[N];R[0O:P=,J?G;G@Y[?0>_)KGJ**].G3C35HH^DH8>E0CRTU9!1
M115FX4444`%%%%`!1110`4444`%%%%`!1110`444JJ6Z"F)M+5B4&W$P^88]
M^]3K&%YZFG`@]"#6D$XN]SCKRA5BX-77F8M%%%>V?FH4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!15K3].N]4NA;64#32D%L`@8`[DG@?C7H>A^`;2
MS59M4*W5P#GRU)\I>1CL"W3OQSC'>N#&YEA\&OWCU[+<N,'+8XK2/#.J:UA[
M:#9`?^6\ORIWZ'J>1C@''>O2-#\)Z=H;+,BM-=@8\^3MD`':.@[^IY(S6Y'&
MD4:QQHJ(@"JJC``'0`4QYP.%Y/Z5\AC<WQ.,;A'W8]E^K.J%*,=20L%&2<"H
M7G[)^=0LS,<L<TE<,**6K+N!))R3DT445N(*IS_ZYJ@U37;+2T<22![@#Y85
M/)/'7^[U[_AFN&U77+K59#O/E0]HD)P1GC/J>G^`KIHX2=779'HX/*ZV)][:
M/=_IW.DO?%5O8[XK51<2D##!OD'![CKVX'YUR5_J-UJ5P9;F4MR2J9^5/8#M
MT%5:*]6CAX4MMSZG"9?1PJO!:]^H4445N=P4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%*`2<`9IZQ$\MQ4GRH/052CW,9UDM(ZL8L0ZM^5/9U7C]!3-
MS.<+P/6G+&%.3R?>K7D82[S?R&_/)_LK3U0+T_.D9]LB)C[V>:?32(E-O1:(
MQ****]H_.`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHKH]"\&:AK*B:0_9+7C$D
MB'<X(R"J\9'3G('/&<5C7Q%+#PYZLK(I1;=D<]'&\LBQQHSNY"JJC))/0`5V
M^B?#V=Y$GU=UCC!R;=#EFZ\%AP.W3/![&NQT?P_I^AP[+2+,ASNFDP9&![$X
MZ<#@<<>M:3.J#)-?*8[B"I4_=X967?K\NWY^AT0HI:R(;.QM=/MQ;V<$<,0_
MA08R<8R?4\#D\U*\JIQU/I4+S,W"\"HJ\-4I2?-4>IM?L/>1GZG`]*9116Z2
M2LA!13)9HX(S)-(D<8ZL[``?B:Y75O&**OE:8-S'K,Z\#C^$'O\`7TZ&MJ5&
M=1VBCIPV$K8F5J:^?0Z2\U"TT^,274Z1`]`>I^@')ZCI7&ZGXON[K='9K]FB
M.1NZN1SW[=NG(QUK!N;NXO)C-<S/+(>['IWP/0<]*AKU*."A#66K/IL'D]*C
M[U3WI?A_7J%%%%=A[(4444`%%%%`!1110`4444`%%%%`!1110`4444`%%*JE
MN@J98@.O)JDFS.=2,=R)8V;V%3!509_4TC2`<#DTFQGY<X'I5));&$G*6LM$
M!DSP@R:!'SECDT\``8`Q2T[=S-SMI'0****HS(I/^/B'_@7\JEJ*3_CXA_X%
M_*I:0&)1117M'YV%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`>A>"M+TR.QAU&>$R7
M,F<-)AEC*L<%1C@\#GD^F*[K>I7<&!7U!KB_"W_(N6G_``/_`-#:N@M?X_PK
M\_S%2JXJ;D]FU\KG;#2*+[S]D_.H"23DG)HHK",%'8H***H:EK%GI4>ZXDRY
MQB),%SGOCTX//M6D8N3LBJ=.522C!79?K#U3Q39:<[PQ@W%PIPR*<!3QP6_P
MSTYQ7*ZKXEO=2+(C&WMR,>4C=>.<GJ<YZ=*QJ]&C@.M3[CZ+!Y']K$/Y+]7_
M`)?>7=0U:]U-\W,Q*9RL:\*O7H/QZGFJ5%%>C&*BK)'T,(1IQY8*R"BBBF6%
M%%%`!1110`4444`%%%%`!1110`4444`%%%2+$3][@4TKDRDH[C`"3@#-2+%W
M;\J?\J#L*9N9SA>!ZU5DMS!U)3^'1#RRIQ^@IGSR?[*TY8PIR>3[T^JM?<QY
MHQ^'?N-5`O3\Z=113(;;U84444Q!1110!%)_Q\0_\"_E4M12?\?$/_`OY5+2
M`Q****]H_.PHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@#TCPM_R+EI_P`#_P#0VKH+
M7^/\*Y_PM_R+EI_P/_T-JWX'6-)'=@J*,LS'``]37P.+_P!YJ?XG^9VPV19J
M&YN[>SA,US,D48[L>O?`]3QTKGM6\7PVS>5IZI<2=Y&SL4YZ?[7?H<=.M<=>
M7MQ?W!GNI3))@#)XP/0`<"MJ."G/66B/;P>35:WO5?=C^/\`P/G]QT.J>,9;
MA'AL(S"C#!E8_/VZ8X'?U_"N8=VD=G=BSL<LS'))]3245ZE.E"FK11]/A\+2
MP\>6DK!1116AT!1110`4444`%%%%`!1110`4444`%%%%`!112JI8\4Q-I:L2
MG+&6]AZU*L0'7DT-(!P.35<O<PE5;=H"J@7Z^M-,N[B/GWIREB/F`%0V?^I/
M^]5>AA>S;EJ2"/G+')J2BBFE8F4G+<****9(4444`%%%%`!1110!%)_Q\0_\
M"_E4M12?\?$/_`OY5+2`Q****]H_.PHHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@#TC
MPM_R+EI_P/\`]#:N>\3:A.VK36CR$V\94H@Z`E1R?7J:TO"NL6?]GPZ>\GES
MQYQOP`^6/"GN>1Q6%XF_Y&&Z_P"`?^@"ODXTG''5.==VOOW/HLD:]M?LO\BF
M"",@YI:JABIX.*U;&&SOT$7VM+.Z"C;]I;]U,V3P&`_=G!0#=\OWB77@5W<K
MZ'URKQ2]XJ45-=6LUE<O;W";)%P>"""",@@C@J0001D$$$9!J&D;)IJZ"BBB
MD,****`"BBB@`HHHH`****`"BBB@`H`).!4BQ$]>!4F%0=@*I1,9UDM%JQBQ
M=V_*GEE08_04PNS\(,#UIRQ@<GDU2\C&6NM1_(;\\G^RM/5`O3\Z=5=S_IL8
M[;?\:JQFYMZ+1%BJ]G_J3_O58JO9_P"I/^]03T+%%%%,04444`%%%%`!1110
M`4444`12?\?$/_`OY5+44G_'Q#_P+^52T@,2BBBO:/SL****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`*FWLX!=BQP!DG/`X`_*H:D3[HKEQGP+U/;R'_>9?X7^:'444
M5YQ]:.5V7Z>E3+(K<=#Z57HI-7+C4<2W14"2D=>14RL&&14-6.F,U+86BBBD
M6%%%%`!1110`44JJ6.`*E6(#D\FJ2;,YU(QW(U0M[#UJ945!G]32-(J^YINU
MI.6.!Z5226QA*4IZRT0IDYPHR:!&2<N<^U/50HP!2T[=S/GMI``,=****HS"
MJ[_\?L?^[_C5BJ[_`/'['_N_XTAHL57L_P#4G_>JQ5>S_P!2?]Z@.A8HHHIB
M"BBB@`HHHH`****`"BBB@"*3_CXA_P"!?RJ6HI/^/B'_`(%_*I:0&)1117M'
MYV%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%2)]T5'4B?=%<N,^!>I[>0_P"\R_PO
M\T.HHHKSCZT****`"@$@Y%%%`$JS=F'XU,"",BJE*K%3D&I<3:-9K<M45&LH
M/!X-6%B)Y/`J;,V]I&U[D8&>E2K%W;\JD`5!Z>],,A;A!^-79+<P=24_AT0X
ME4'I3,LY^7@>M*L?=N34E/5F=XQVU8U8PON?6G444S-MMW84444Q!1110`57
M?_C]C_W?\:L57?\`X_8_]W_&D-%BJ]G_`*D_[U6*KV?^I/\`O4!T+%%%%,04
M444`%%%%`!1110`4444`12?\?$/_``+^52U%)_Q\0_\``OY5+2`Q****]H_.
MPHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`J1/NBHZD3[HKEQGP+U/;R'_`'F7^%_F
MAU%%%><?6A1110`4444`%%%%`!6H[;49O09K+K2E_P!2_P#NFFB6,C'G*'8\
M'M4H``P!BH[;_CW7\?YU+0D$I-Z!1113)"BBB@`HHHH`****`"J[_P#'['_N
M_P"-6*KO_P`?L?\`N_XTAHL57L_]2?\`>JQ5>S_U)_WJ`Z%BBBBF(****`"B
MBB@`HHHH`****`(I/^/B'_@7\JEJ*3_CXA_X%_*I:0&)1117M'YV%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%2)]T5'4B?=%<N,^!>I[>0_[S+_"_P`T.HHHKSCZ
MT****`"BBB@`HHHH`*TI?]2_^Z:S:TI?]2_^Z::)8VV_X]U_'^=2U%;?\>Z_
MC_.I:"6%%%%,`HHHH`****`"BBB@`JN__'['_N_XU8JN_P#Q^Q_[O^-(:+%5
M[/\`U)_WJL57L_\`4G_>H#H6****8@HHHH`****`"BBB@`HHHH`BD_X^(?\`
M@7\JEJ*3_CXA_P"!?RJ6D!B4445[1^=A1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M4B?=%1U(GW17+C/@7J>WD/\`O,O\+_-#J***\X^M"BBB@`HHHH`****`"M*7
M_4O_`+IK-K2E_P!2_P#NFFB6-MO^/=?Q_G4M16W_`![K^/\`.I:"6%%%%,`H
MHHH`****`"BBB@`JN_\`Q^Q_[O\`C5BJ[_\`'['_`+O^-(:+%5[/_4G_`'JL
M57L_]2?]Z@.A8HHHIB"BBB@`HHHH`****`"BBB@"*3_CXA_X%_*I:BD_X^(?
M^!?RJ6D!B4445[1^=A1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!4B?=%1U(GW17+C
M/@7J>WD/^\R_PO\`-#J***\X^M"BBB@`HHHH`****`"M*7_4O_NFLVM*7_4O
M_NFFB6-MO^/=?Q_G4M16W_'NOX_SJ6@EA1113`****`"BBB@`HHHH`*KO_Q^
MQ_[O^-6*KO\`\?L?^[_C2&BQ5>S_`-2?]ZK%5[/_`%)_WJ`Z%BBBBF(****`
M"BBB@`HHHH`****`(I/^/B'_`(%_*I:BD_X^(?\`@7\JEI`8E%%%>T?G8444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`5(GW14=2)]T5RXSX%ZGMY#_`+S+_"_S0ZBB
MBO./K0HHHH`****`"BBB@`K2E_U+_P"Z:S:TI?\`4O\`[IIHEC;;_CW7\?YU
M+45M_P`>Z_C_`#J6@EA1113`****`"BBB@`HHHH`*KO_`,?L?^[_`(U8JN__
M`!^Q_P"[_C2&BQ5>S_U)_P!ZK%5[/_4G_>H#H6****8@HHHH`****`"BBB@`
MHHHH`BD_X^(?^!?RJ6HI/^/B'_@7\JEI`8E%%%>T?G84444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`5(GW14=2)]T5RXSX%ZGMY#_O,O\+_`#0ZBBBO./K0HHHH`***
M*`"BBB@`K2E_U+_[IK-K2E_U+_[IIHEC;;_CW7\?YU+45M_Q[K^/\ZEH)844
M44P"BBB@`HHHH`****`"J[_\?L?^[_C5BJ[_`/'['_N_XTAHL57L_P#4G_>J
MQ5>S_P!2?]Z@.A8HHHIB"BBB@`HHHH`****`"BBB@"*3_CXA_P"!?RJ6HGYN
M(L=LY_*I:0V8E%%%>T?G04444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`5(GW14=2)]T
M5RXSX%ZGMY#_`+S+_"_S0ZBBBO./K0HHHH`****`"BBB@`K2E_U+_P"Z:S:T
MI?\`4O\`[IIHEC;;_CW7\?YU+45M_P`>Z_C_`#J6@EA1113`****`"BBB@`H
MHHH`*KO_`,?L?^[_`(U8JN__`!^Q_P"[_C2&BQ5>S_U)_P!ZK%5[/_4G_>H#
MH6****8@HHHH`****`"BBF;BWW1QZFE<:BV.+!>IQ3?F;_9'ZTH4`Y/)]33B
M0`23@"C<=U'80*%Z4CR+&NYS@55FOE`(B&3_`'C5)W:1MS,2?>NJGAI2UEHC
MQ<9G-.G>-+WG^'_!^7WC:***]`^3"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"I$^
MZ*CJ1/NBN7&?`O4]O(?]YE_A?YH=1117G'UH4444`%%%%`!1110`5I2_ZE_]
MTUFUI2_ZE_\`=--$L;;?\>Z_C_.I:BMO^/=?Q_G4M!+"BBBF`4444`%%%%`!
M1110`57?_C]C_P!W_&K%5W_X_8_]W_&D-%BJ]G_J3_O58JO9\Q'_`'C_`"IV
MNQ-J*;98HJ2:,1L%!SQFHZ&K.S)A-3BI1V8444A8+QU/H*1:3>PM-+\X`R:3
M#-][@>@IP``P!B@=DM]1H3/+G/MVI]12SQP_>/)Z`=:H374DO`.U?05M2H2G
MML>?C,SI8?1N[[+^M"Y->1Q$J/F8=A5"6:24_.W'IVJ.BN^G1C#;<^8Q>85L
M2[2=EV7]:A1116IP!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`5(GW14=2)]
MT5RXSX%ZGMY#_O,O\+_-#J***\X^M"BBB@`HHHH`****`"M*7_4O_NFLVM*7
M_4O_`+IIHEC;;_CW7\?YU+45M_Q[K^/\ZEH)84444P"BBB@`HHHH`****`"J
M[_\`'['_`+O^-6*KO_Q^Q_[O^-(:+@C!A9\\@XZU3M/]2W^]5Y/^/23_`'O\
M*HVG^I;ZG^5:R24E8XJ,Y2IU.=[-HOW7^M'^[5<D`9)Q4UV6\T!1_#U-0!`#
MD\GU-34^)FV$2]A%OL)EG''RCU-."A>G7UI20`23@"JDU\JDK&-Q'<]*(4Y3
M>@8C%TJ$;U'9%EW6-=S,`/>J,UZSC$8*CU[U6=VD;<S$GWIM=U/#1CK+5GS.
M+S>K6]VE[J_'_@`2222<DT445TGD!1110(****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`J1/NBNL\*>$;?58DO;Z<&!N4@C8AF(8@[CCIQVYYZC%9OBF
MU@L?$5S;6T2Q0QB,*B]OD7_.:\BOCZ56J\-#5K5]NUOQ/>R*#5=R?;]48]%%
M%9GU04444`%%%%`!1110`5I2_P"I?_=-9M:4O^I?_=--$L;;?\>Z_C_.I:BM
MO^/=?Q_G4M!+"BBBF`4444`%%%%`!1110`57?_C]C_W?\:F9U7J>?2HPA>99
M3QCBE<M1=KEU1BTD_P![_"J%I_J6_P!ZKJNHMW3/S$Y`_*J6Z.T0@L3DY`[U
MJ[N2Y3SJ5H4ZCJZ)MEZY8-(-I!P.U49KM(C@?,WH#TJI-=O*,#Y5]`>M5ZZH
M8:[YIGD5LW5.'LL/TZO_`"_S))9WF.6/'H.E1T45U))*R/#G4E4ES3=V%%%%
M,@****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`/2/"W_(N6
MG_`__0VKE/%#%O$=V6))^3D_[BUU?A;_`)%RT_X'_P"AM7)^)O\`D8;K_@'_
M`*`*^1H_[]5]9?F?19+_`!7_`(?U1DT445Z9],%%%%`!1110`4444`%:4O\`
MJ7_W36;6E+_J7_W331+&VW_'NOX_SJ6HK;_CW7\?YU+02PHHHI@%%%%`!114
M9DSP@R?6DW8J,7+8>6"]3BH]S.<+P/6E$>3ESD^E/)`&3@`4M65>,/,:L84Y
M/)]Z5W6-=S,`/>JTUZJ'$8#'U[51>1I&W.<FNJEAI2U>B/%QN<TZ;Y8>]+\/
MZ]"U->ELK$,#IN[U3)))).2:**[X4XP5HGS.(Q57$2YJCN%%%%4<X4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110!Z1X6_Y%
MRT_X'_Z&U8?B?1[TWTVH1Q>9`V,E,DH`HY8=AP>:Y_3M4N]+F,EK)MW8WJ1E
M6`/0C_)Y-=7%X[BCT]C]E<WI7`''E[O7.<X[X_#/>OFZV`Q-'$NK27,I-_CK
M_3/1P6-^KRYEVL<=14E[J$U_=O<3+$'<DD1H%'))[=>O4Y/O408'I7=.C4@K
MR1]/A,RH8G2+M+L_ZU%HHHK(]`****`"BBB@`K2E_P!2_P#NFLVM*7_4O_NF
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
M6"LNR"BBBK`****`"BBB@`HHHH`****`,^Y_X^&_#^515+<_\?#?A_*HJDM!
M1110,****`"BBB@`HHHH`*D63C#C<*CHH!.PK0!AF-L^QJ$@@X(P?>I@2#D'
M%/W+(,2#Z$5U4L5*.D]4>-C,EHUO>H>[+MT?^15HJ5X".4^9?:HJ[X5(S5XL
M^8Q&&JX>?)5C9_UL%%%%4<X4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%;FA>%M0UQ@\:^1:\$S
MR*=I&<';_>/!]N.2*]&T+PMI^AJ'C7S[K@F>11N!Q@[?[HY/OSR37E8[.,/A
M+Q^*79?J^AK"E*1Q6A^!+W4%6>_9K.#/W&4^:V".Q^[GGD^G0BO0]+TBRT>U
M6"SA5!@!GP-\F.['OU/TSQBKI(49)P*A>?LGYU\AB\PQ..=I.T>W3_@G3&$8
M$K.J=3^%5WF9N!P*C)).2<FBL845'5CN%%%%:@%1W%Q%:P///($B099CVK`U
M+Q?:VVZ*R7[3+R-W1`>>_?G'3@YZUR%U=7>H2B2\G>0CH#T'T`X'0=*[:&!G
M4UEHCU<-E-2I[U7W8_B_E_F=%JGC!G#0Z6A4Y_U[@>O93Z\<G\JYES)-*99Y
M&ED/5G8DG\30``,`8I:]BCAX4E[J/=HTJ="/+15O/J_F%%%%;EA1110`4444
M`%%%%`!1110`4444`%%%%`&?<_\`'PWX?RJ*I;G_`(^&_#^515):"BBB@844
M44`%%%%`!1110`4444`%%%%`#E=EZ&E(CE^]\K>M,HIQ;B[QT)J0A5CR5%==
MF,DB:,\C(]:95A9"!@\CT-#1))RAVMZ&NVEB^D_O/G<9D3UGAG==GO\`+O\`
MGZE>BG,C(<,,4VNU--71\[.$H2<9*S04444$A1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
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
M`"BBB@`HHHH`****`"BBB@`HHHH`S[G_`(^&_#^515+<_P#'PWX?RJ*I+044
M44#"BBB@`HI54L<`58CM\]L_RI7*46]>A"L;-ST'K5F*#C/ZFIEC"\]33Z=K
M[@YJ/P_>(JA>@I::T@7W/I3-KO\`>.!Z47Z(GE;]Z3%,G.%&30(R3ESGVIZJ
M%&`*6BW<.=+2``8Z44451F%%%%`!4%Y_QZO^'\ZGJ"\_X]7_``_G5T_C7J<^
M,_W>I_A?Y&71117K'P84444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%2)]T5'4B?=%<N,^!>I[>0_[S+_"_P`T.HHHKSCZ
MT****`%!(.0<5-'.1P3@^M044K#C)HT4E#=>*DK,5RIX_*K$5QV_0T[VW&X1
ME\.C+=%-5PWL?2G4S)IIV84444Q!1110`4444`%%%%`!1110`4444`%%%%`!
M1110!GW/_'PWX?RJ*I;G_CX;\/Y5%4EH***D2(L>>*"E%O8C`).!4R0$GGGV
M%6(X,#T'ZU,%"]!BEJQMQCYLC2$`<_D*EH)QUJ,R%N$&?>GHB?>J#V8*.:CR
MSGY>!ZTJQ]VY-24:L+QCMJQJQA?<^M.HHID-MN["BGI$TGW:E_=P?[;U:@]V
M<\\1%/ECK+M_6PU("PRQVK43`!B`<@'K3I)6D^\>/04RB3CL@I1J_%4?R"BB
MF,X!P.6J+G0HM[#R<=:@NR#:O@YZ?SJ0(6Y<_@*CN_\`CU?\/YU=+XUZF&-2
M6'J>C_(RZ***]<^!"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`J1/NBHZD3[HKEQGP+U/;R'_>9?X7^:'4445YQ]:%%%
M%`!1110`4444`/65EXZBK4=QGOG^=4J*5NQ2EI:6IJ!@W0YI:H).5//YBK23
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
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"I$^Z*CJ1/NBN7&?`O4]O(?]YE_A?YH=1117
MG'UH4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`#XO]<G^\*N7*,\
M0"C)!S5.+_7)_O"K\SE(BPZBF2]Q$8)$@;@[1Q1EWZ<+ZT1H"H8\DC-24M65
M>,=M1JH%Z4ZBBF0VV[L****8@HHHH`****`"HH_^/B;_`(#_`"J6HH_^/B;_
M`(#_`"I`%P<0-3HO]2G^Z*;<_P#'NWX?SIT7^I3_`'10/H/HHHIB"BBB@`HH
MHH`****`"BBB@"NG_'[)_N_X4MY_QZO^'\Z1/^/V3_=_PI;S_CU?\/YU=+XU
MZG/C/]WJ?X7^1ET445ZQ\&%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!4B?=%1U(GW17+C/@7J>WD/\`O,O\+_-#J***
M\X^M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`?%_KD_P!X5;NF
MQ`1ZG%5(O]<G^\*M78_<CV:F2]R6+_4I_NBGTR+_`%*?[HI],D****`"BBB@
M`HHHH`****`"HH_^/B;_`(#_`"J6HH_^/B;_`(#_`"I`%S_Q[M^'\Z=%_J4_
MW13;G_CW;\/YTZ+_`%*?[HH'T'T444Q!1110`4444`%%%%`!1110!73_`(_9
M/]W_``I;S_CU?\/YTB?\?LG^[_A2WG_'J_X?SJZ7QKU.?&?[O4_PO\C+HHHK
MUCX,****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"I$^Z*CJ1/NBN7&?`O4]O(?]YE_A?YH=1117G'UH4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`#XO\`7)_O"KMS_P`>[?A_.J47^N3_`'A5
MVY_X]V_#^=,E[CHO]2G^Z*?3(O\`4I_NBGTR0HHHH`****`"BBB@`HHHH`*B
MC_X^)O\`@/\`*I:BC_X^)O\`@/\`*D`7/_'NWX?SIT7^I3_=%-N?^/=OP_G3
MHO\`4I_NB@?0?1113$%%%%`!1110`4444`%%%%`%=/\`C]D_W?\`"EO/^/5_
MP_G2)_Q^R?[O^%+>?\>K_A_.KI?&O4Y\9_N]3_"_R,NBBBO6/@PHHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*D3[HJ.I
M$^Z*Y<9\"]3V\A_WF7^%_FAU%%%><?6A1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`/B_P!<G^\*N76?(.#QD9JG%_KD_P!X5=N?^/=OP_G3)>XZ
M+_4I_NBGTR+_`%*?[HI],D****`"BBB@`HHHH`****`"HH_^/B;_`(#_`"J6
MHH_^/B;_`(#_`"I`%Q_J&S3HO]2G^Z*2?_4/GTI8O]2G^Z*!]!]%%%,04444
M`%%%%`!1110`4A(`R3BF&3G"C)H$>>7.34W[&BA;66@R,$W+28^4C'\J+S_C
MU?\`#^=3@8Z54O)T\MH@<L?3MS6M&+<T<.85(1P\[NUTU^!GT445ZQ\*%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!4B
M?=%1U(GW17+C/@7J>WD/^\R_PO\`-#J***\X^M"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`?%_KD_WA5VY_P"/=OP_G5*+_7)_O"KMS_Q[M^'\
MZ9+W'1?ZE/\`=%/ID7^I3_=%/IDA1110`4444`%%%%`!1110`5%'_P`?$W_`
M?Y5+44?_`!\3?\!_E2`6?_4/QGBEB_U*?[HI)QF!\G'%+%_J4_W10/H/HHHI
MB"BBB@`HI&8+U-1Y>3IPM)LN,&]7HAS2!?<^E-VLYRW`]*>J!?KZTZE:^X^9
M1^'[Q`H7H,4R6=(1ECSZ#K4E9M\P:<8(.%P<?4UO1IJ<K,\[,<5+#T7..XDU
MV\HP/E7T!ZU7HHKTXQ459'QM6M4K2YJCNPHHHIF04444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%2)]T5'4B?=%<N,^!>I
M[>0_[S+_``O\T.HHHKSCZT****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@!\7^N3_>%7+H9@)]"#5.+_7)_O"KMS_Q[M^'\Z9+W'1?ZE/]T4^F1?ZE
M/]T4^F2%%%%`!1110`4444`%%%%`!44?_'Q-_P`!_E4M11_\?$W_``'^5(!9
M\>0^?2EB_P!2G^Z*;<?ZALTZ+_4I_NB@?0?114;2=EY-#=AQBY;#R0!DG%,W
MLQP@_&@1EN7.?:I`,=*6K*]V/F_P&+&!RW)I]%(S*BEF.`.III=$1.=_>DQ:
MCEFCB'SMSZ=ZJS7V?EB&/]HU3+%CEB2?4UUT\*WK+0\/%YS"G[M#5]^G_!+$
MUY(Y(0[%]NM5J**[8PC%6BCYRM7J5I<U1W844451B%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`5(GW14=2)]T5
MRXSX%ZGMY#_O,O\`"_S0ZBBBO./K0HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`'Q?ZY/]X5=N?^/=OP_G5*+_7)_O"KET0("#WP!3)>X^+_`%*?
M[HI],B_U*?[HI],D****`"BBB@`HHHH`****`"HH_P#CXF_X#_*I:BC_`./B
M;_@/\J0!<_\`'NWX?SIT7^I3_=%-N.8'X)^E.B_U*?[HH'T&[7?[QP/2I%4*
M,`4M%"14IMZ=`HJ&:Y2$8/+?W15":Y>8X/"_W16].A*>NR/+Q>9T</>.\NW^
M9;FO43Y4^=O7M5%Y'E.78FF45WTZ,8;'S.*Q];$OWWIVZ!1116AQ!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`5(GW14=2(PQBN;%)N&A[&25(PQ+YG:ZM^*'4445YI]@%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`^+_7)_O"KET,P'VQ5.+_`%R?
M[PJ[<_\`'NWX?SIDO<=%_J4_W13Z9%_J4_W13Z9(4444`%%%%`!1110`44TL
M`<#D^@I-I;[QX]!2N4H]6+OSPHS[]J$3:2QY9NM.`QTHH!M;(",C!Z4@`4`#
MH.*"P498@#U-4YKX`8BY/]XBM(4Y3?NG+B,72P\;U'\NI:>1(AEV`JC+>N^1
M&-H]>]5F9G8LQR3U-)7=3PT8ZRU9\UB\WJUO=I^['\?Z]`HHHKH/("BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@!P8CWIX8'I45%85</&>JT9ZN#S:MA_=E[T
M>W_!)J*8']:>#GI7GU*4J;U/I\+C:.)5X/7MU"BBBLSL"BBB@`HHHH`****`
M"BBB@`HHHH`****`'Q?ZY/\`>%7;G_CW;\/YU2B_UR?[PJY<_P"H;\*9+W'Q
M?ZE/]T4^F1?ZE/\`=%/IDA1110`44$XZTS<6^Z,#U-*XU%L<S!1DFF_,W^R/
MUI50#GJ?4TZ@JZ6P@4+T&*6BHI9XX?O'D]`.M5&+;LC*I5C"+G-V1+5>:[2+
M*K\SC\A5.:ZDEX!VKZ"H*[*>%ZS/GL7G5[QPZ^;_`$7^?W$DLTDI^=N/3M4=
M%%=B22LCP9SE.7-)W84444$!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!0"1THHH:3T949.+YHNS)`^>M.J&E#$=*XZF$3U@>]@\[E&T:ZNN_
M7_@_UN2T4T,#3JXI1<79H^CI5J=6/-3=T%%%%2:A1110`4444`%%%%`!1110
M`^+_`%R?[PJ[<_\`'NWX?SJE%_KD_P!X5=N?^/=OP_G3)>XZ+_4I_NBGTR+_
M`%*?[HI6<#CJ?04"2;=D.II?)PO)_04FTM]XX'H*>!CI0/1>8T)DY;D_H*=1
M02`"2<`46$Y7W"FNZQKN9@![U6FOE4E8QN([GI5%W:1MS,2?>NJGAI2UEH>-
MB\XI4O=I>\_P_P""69KUG&(P5'KWJH2222<DT45W0A&"M%'S=?$U:\N:H[A1
M115'.%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!3@Y'7FFT5,X1FK21M1Q%2A+FINS)00>E+4-/#^M<-7"M:PU/I
M,'G<*GNU]'WZ?\`?10#FBN38]U--704444#"BBB@`HIP1BA<*2H[TV@0^+_7
M)_O"KER?W#>^*IQ?ZY/]X5>G4M`P`R:8GN+'S"G^Z*<JA1@"DC&(D!Z[13J!
M7>P45'+-'$/G;GT[U0FNWERJ_*A_,UM3HRGML<&+S"CAE[SN^R_K0N374<7`
M.YO050EGDF^\>!T`Z5%17?3H1AZGS.+S&MB=&[1[+]>X4445J>>%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`H)'2GAP>O%1T5E4HPJ;G;A<?7PS]QZ=GL345$&(J0,
M#7!5P\H:[H^IP>:4<3[NTNS_`$%HHHK`](NV?^I/^]2R6J/R/E/MTI+/_4G_
M`'JL4R'N4!$\4R;AQN'(Z5?HJK+>HF1&-Q]>U7"$I.T485\32HQYJCL66944
MLQP!U-4IKXDXBX']XBJKR/*<NQ-,KNIX:,=9:GS>+SBI5]VC[J_'_@?UJ*6+
M'+$D^II***Z3QFVW=A1110(****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@!P<CKS3P0>E145SU,-&>JT9Z^$SBM0]V?O1_'[S3L_]2?\`>ITURD(P
M>6_NBL\7$BQE%.`3G(ZU%65/"?SG;BL[5K4%\W_D337+S'!X7^Z*AHHKLC%1
M5D?/U:LZLN>;NPHHHIF84444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
%110!_]E%
`








#End
