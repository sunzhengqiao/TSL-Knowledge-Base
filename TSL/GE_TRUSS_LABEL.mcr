#Version 8
#BeginDescription
Display LABEL and/or TAG of selected trusses
v18.0: 19.mar.2013: David Rueda (dr@hsb-cad.com)

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 18
#MinorVersion 0
#KeyWords 
#BeginContents
/*
  COPYRIGHT
  ---------------
  Copyright (C) 2011 by
  hsbSOFT 

  The program may be used and/or copied only with the written
  permission from hsbSOFT, or in accordance with
  the terms and conditions stipulated in the agreement/contract
  under which the program has been supplied.

  All rights reserved.

 REVISION HISTORY
 -------------------------

 v18.0: 19.mar.2013: David Rueda (dr@hsb-cad.com)
	- Copied from TS_TRUSS_LABEL, to keep US content folder naming standards
	- Description added

 - Old version:	TS_TRUSS_LABEL
 v18.0_RL_April 17 2012__This TSL was adapted for V18 AND HIGHER ONLY. It supports Xrefs
 v0.6_RL_Jan 20 2012__Will show icons on the refference end of the truss
 v0.5_RL_Jan 20 2012_Will read beam body from the truss def
 v0.4_RL_Nov 23 2011_Will take the tag from the definition for older imported files
 v0.3_RL_Nov 23 2011_Adapted for the new versions and will insert TrussEntity propset if present in dwg
 v0.2_Modified Displays_11/9/2011
 v0.1 

*/

Unit (1,"inch");

int stProp=0,nProp=0,dProp=0;
String arYN[]={"Yes","No"};


PropString stEmpty1(stProp,"- - - - - - - - - - - - - - - -",T("DISPLAY PROPERTIES"));stProp++;
stEmpty1.setReadOnly(true);

PropString stDim(stProp, _DimStyles ,T(" DimStyle"));stProp++;
PropDouble dTH(dProp,U(0)," Text Height (0 uses dimstyle)");dProp++;

String arStDisplay[]={"Label","Tag","Tag - Label","Label - Tag"};
PropString stDisplayText(stProp, arStDisplay ,T(" Display Text"),0);stProp++;

PropString stDispRepLabel(stProp, _ThisInst.dispRepNames() ,T(" Label Display Rep"));stProp++;
PropInt iColorLabel(nProp, -1 ,T(" Label Color"));nProp++;

PropString stDisplayLine(stProp, arYN ,T(" Display Center Line"));stProp++;
PropString stDispRepLine(stProp, _ThisInst.dispRepNames() ,T(" Center Line Display Rep"));stProp++;
PropString stLineTypeLine(stProp, _LineTypes ,T(" Line LineType"));stProp++;
PropInt iColorLine(nProp, -1 ,T(" Line Color"));nProp++;

PropString stDisplayOutline(stProp, arYN ,T(" Display Outline"));stProp++;
PropString stDispRepOutline(stProp, _ThisInst.dispRepNames() ,T(" Outline Display Rep"));stProp++;
PropString stLineTypeOutine(stProp, _LineTypes ,T(" Outline LineType"));stProp++;
PropInt iColorOutline(nProp, -1 ,T(" Outline Color"));nProp++;



PropString stEmpty2(stProp,"- - - - - - - - - - - - - - - -",T("TRUSS DFINITION PROPERTIES"));stProp++;
stEmpty2.setReadOnly(true);


PropString stTag(stProp, "" ,T(" Tag"));stProp++;
PropString stLabel(stProp, "" ,T(" Label"));stProp++;
PropString stTrussType(stProp, "" ,T(" Truss Type"));stProp++;
PropDouble dSpan(dProp, U(0) ,T(" Span"));dProp++;
PropInt iPly(nProp, -1 ,T(" Ply"));nProp++;
stTag.setReadOnly(TRUE);
stLabel.setReadOnly(TRUE);
stTrussType.setReadOnly(TRUE);
dSpan.setReadOnly(TRUE);
iPly.setReadOnly(TRUE);



// bOnInsert
if (_bOnInsert){
	
	showDialogOnce();
	
	_Map.setMap("mpProps", mapWithPropValues());
	
	
	PrEntity ssE("\nSelect a set of trusses",TrussEntity());
	ssE.allowNested(TRUE);
	
	if (ssE.go())
	{
		Entity ents[0]; 
		ents = ssE.set(); 
		// turn the selected set into an array of elements
		for (int i=0; i<ents.length(); i++)
		{
			if (ents[i].bIsKindOf(TrussEntity()))
			{
				_Entity.append(ents[i]);
				
			}
		}
	}

	
	// declare tsl props 
	TslInst tsl;
	String sScriptName = scriptName();

	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	Beam lstBeams[0];
	Entity lstEnts[1];
	Point3d lstPoints[1];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
		
	for(int i=0; i<_Entity.length();i++){
		
		//__Get from Entity
		TrussEntity te=(TrussEntity)_Entity[i];
		if(!te.bIsValid())continue;
		
		TrussDefinition cd(te.definitionObject());
		GenBeam arBmCE[]=cd.genBeam();
		
		//__Get _Pt0 location
		Point3d ptG;
		{
			CoordSys csTe=te.coordSys();
			Body bd=te.realBody();
			Plane pnBase(csTe.ptOrg(),csTe.vecY());
			
			Point3d arPtX[0],arPtZ[0],arPtXZ[0];
			{
				Point3d arPtXAll[0],arPtZAll[0];
				for(int b=0;b<arBmCE.length();b++){
					Beam bm=(Beam)arBmCE[b];
					if(!bm.bIsValid())continue;
					
					String stLabel=bm.label();
					stLabel.makeUpper();
					
					Body bd=arBmCE[b].envelopeBody();
					bd.transformBy(csTe);
					arPtXAll.append(bd.extremeVertices(csTe.vecX()));
					arPtZAll.append(bd.extremeVertices(csTe.vecZ()));	
				}
				arPtXAll=Line(csTe.ptOrg(),csTe.vecX()).orderPoints(arPtXAll);
				arPtZAll=Line(csTe.ptOrg(),csTe.vecZ()).orderPoints(arPtZAll);
				
				if(arPtXAll.length() * arPtZAll.length() == 0 )continue;
				
				arPtX.append(arPtXAll[0]);
				arPtX.append(arPtXAll[arPtXAll.length()-1]);
				arPtZ.append(arPtZAll[0]);
				arPtZ.append(arPtZAll[arPtZAll.length()-1]);
				
				arPtX=pnBase.projectPoints(arPtX);
				arPtZ=pnBase.projectPoints(arPtZ);
				
				//Get all corner points
				for(int i=0;i<arPtX.length();i++){
					Line ln(arPtX[i],csTe.vecZ());
					for(int j=0;j<arPtZ.length();j++){
						arPtXZ.append(ln.closestPointTo(arPtZ[j]));
					}
				}
			}
	
			
			if(arPtZ.length() == 2){
				ptG.setToAverage(arPtXZ);
				double dMove=csTe.vecZ().dotProduct(arPtZ[1]-arPtZ[0])*0.5+U(6);
				ptG.transformBy(dMove*csTe.vecZ());
			}
			else{
				ptG=csTe.ptOrg()-U(6)*csTe.vecZ();
			}
			
			
			double dTrussLength=csTe.vecX().dotProduct(arPtX[1]-arPtX[0]);
			ptG.transformBy(dTrussLength*0.25*csTe.vecX());
		}
		
		//__Remove exiting TSLs on this truss
		Group arGr[]=_Entity[i].groups();
		for(int g=0;g<arGr.length();g++){
			Entity entsInspect[]=arGr[g].collectEntities(1, TslInst(), _kModelSpace);
			for(int e=entsInspect.length()-1;e>-1;e--){
				TslInst tslEnt=(TslInst)entsInspect[e];
				if(!tslEnt.bIsValid())continue;
				
				Entity ents[]=tslEnt.entity();
				
				if(tslEnt.scriptName() == scriptName() && ents.find(_Entity[i])>-1){
					tslEnt.dbErase();
				}
			}
		}

		
		
		
			
		
		lstEnts[0] = _Entity[i];
		lstPoints[0]=ptG;

		tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString,1,_Map );
	}
	eraseInstance();
	return;	
	
}//END if (_bOnInsert)

//set properties from map
if(_Map.hasMap("mpProps")){
	setPropValuesFromMap(_Map.getMap("mpProps"));
	_Map.removeAt("mpProps",0);
}


if(_Entity.length()==0){
	eraseInstance();
	return;
}



Entity ent = _Entity[0];
TrussEntity te=(TrussEntity)ent;
if(!te.bIsValid()){
	reportMessage("\nNot a valid Truss Entity");
	eraseInstance();
	return;
}

//__Get from Entity
CoordSys csTe=te.coordSys();
Body bd;//=te.realBody();
Plane pnBase(csTe.ptOrg(),csTe.vecY());
TrussDefinition td(te.definitionObject());
stTag.set(te.definition());
Beam arBm[]=td.beam();
assignToGroups(te);




Point3d arPtX[0],arPtY[0],arPtZ[0],arPtXZ[0],arPtEnd[0];
{
	CoordSys csMove;
	csMove.setToAlignCoordSys(_PtW,_XW,_YW,_ZW,csTe.ptOrg(),csTe.vecX(),csTe.vecY(),csTe.vecZ());
	
	for(int i=0;i<arBm.length();i++){
		Body bd=arBm[i].realBody();
		bd.transformBy(csMove);
		
		arPtX.append(bd.extremeVertices(csTe.vecX()));
		arPtY.append(bd.extremeVertices(csTe.vecY()));
		arPtZ.append(bd.extremeVertices(csTe.vecZ()));
	}
	
	arPtX=Line(csTe.ptOrg(),csTe.vecX()).orderPoints(arPtX);
	arPtY=Line(csTe.ptOrg(),csTe.vecY()).orderPoints(arPtY);
	arPtZ=Line(csTe.ptOrg(),csTe.vecZ()).orderPoints(arPtZ);
	
	arPtX=pnBase.projectPoints(arPtX);
	arPtZ=pnBase.projectPoints(arPtZ);
	
	//Get all corner points
	if (arPtX.length() * arPtZ.length() > U(0)){
		Line ln1(arPtX[0],csTe.vecZ()),ln2(arPtX[arPtX.length()-1],csTe.vecZ()),lnEnd(arPtX[0]+csTe.vecX()*U(5),csTe.vecZ());
		arPtXZ.append(ln1.closestPointTo(arPtZ[0]));
		arPtXZ.append(ln1.closestPointTo(arPtZ[arPtZ.length()-1]));
		arPtEnd.append(arPtXZ);
		arPtEnd.append(lnEnd.closestPointTo(arPtZ[0]));
		arPtEnd.append(lnEnd.closestPointTo(arPtZ[arPtZ.length()-1]));
		arPtXZ.append(ln2.closestPointTo(arPtZ[0]));
		arPtXZ.append(ln2.closestPointTo(arPtZ[arPtZ.length()-1]));		
	}
}



if(arPtXZ.length()==0){
	reportMessage("\nProblem finding body shape of truss " + te.definitionObject());
	return;
}

//__Get from definition
String arKeys[]=td.subMapXKeys();
Map mpx;
//__Set some properties
if(arKeys.find("PROPERTIES")>-1){
	mpx=td.subMapX("PROPERTIES");
	
	if(mpx.hasString("TAG")){
		stTag.set(mpx.getString("TAG"));
		stTag.setReadOnly(TRUE);
	}
	else{
		stTag.set(te.definitionObject());
		stTag.setReadOnly(TRUE);
	}
	
	if(mpx.hasString("LABEL")){
		stLabel.set(mpx.getString("LABEL"));
		stLabel.setReadOnly(TRUE);
	}
	else stLabel.setReadOnly(FALSE);
	
	if(mpx.hasString("TRUSSTYPE")){
		stTrussType.set(mpx.getString("TRUSSTYPE"));
		stTrussType.setReadOnly(TRUE);
	}
	else stTrussType.setReadOnly(FALSE);
	
	if(mpx.hasString("SPAN")){
		String st=mpx.getString("SPAN");
		//This value comes in as decimal feet
		double dValue=st.atof() * 12;
		dSpan.set(U(dValue));
		dSpan.setReadOnly(TRUE);
	}
	else dSpan.setReadOnly(FALSE);
	
	if(mpx.hasString("PLY")){
		String st=mpx.getString("PLY");
		//This value comes in as decimal feet
		int iValue=st.atoi();
		iPly.set(iValue);
		iPly.setReadOnly(TRUE);
	}
	else if(mpx.hasInt("PLY")){
		int iValue=mpx.getInt("PLY");
		iPly.set(iValue);
		iPly.setReadOnly(TRUE);
		mpx.setString("PLY",iValue);
	}
	else iPly.setReadOnly(FALSE);
}



//See if we have the property set
String arPSNames[]=te.availablePropSetNames();
String arPSNamesAttached[]=te.attachedPropSetNames();
if(arPSNames.find("TrussEntity")>-1){
	if(arPSNamesAttached.find("TrussEntity")==-1)te.attachPropSet("TrussEntity");
	
	te.setAttachedPropSetFromMap("TrussEntity",mpx);
}


	
//__Create the line display
if(stDisplayLine==arYN[0])
{
	Display dpLine(iColorLine);
	dpLine.showInDispRep("Truss Line (Solid)");
	
	int iLineDraw = iPly>1?iPly:1;
	
	double dTrussLength=csTe.vecX().dotProduct(arPtX[arPtX.length()-1]-arPtX[0]);
	double dTrussWidth=csTe.vecZ().dotProduct(arPtZ[arPtZ.length()-1]-arPtZ[0]);
	double dSizePly=dTrussWidth/iLineDraw;
	
	
	Point3d ptCen;
	ptCen.setToAverage(arPtXZ);	
	ptCen.transformBy(-csTe.vecZ()*dTrussWidth/2);
	ptCen.transformBy(csTe.vecZ()*dSizePly/2);

	for(int i=0;i<iLineDraw;i++){
		LineSeg ls(ptCen-csTe.vecX()*dTrussLength/2,ptCen+csTe.vecX()*dTrussLength/2);
		dpLine.draw(ls);
		
		PLine plC;
		plC.createCircle(ptCen-csTe.vecX()*(dTrussLength/2-dSizePly/2),csTe.vecY(),dSizePly/2);
		dpLine.draw(plC);
		
		ptCen.transformBy(csTe.vecZ()*dSizePly);
	}
	
	Display dpLine2(iColorLine);
	dpLine2.lineType(stLineTypeLine);
	dpLine2.showInDispRep(stDispRepLine);
	
	ptCen.setToAverage(arPtXZ);	
	ptCen.transformBy(-csTe.vecZ()*dTrussWidth/2);
	ptCen.transformBy(csTe.vecZ()*dSizePly/2);
	
	//__Star draw at half a truss over
	
	
	for(int i=0;i<iLineDraw;i++){
		LineSeg ls(ptCen-csTe.vecX()*dTrussLength/2,ptCen+csTe.vecX()*dTrussLength/2);
		dpLine2.draw(ls);
		
		PLine plC;
		plC.createCircle(ptCen-csTe.vecX()*(dTrussLength/2-dSizePly/2),csTe.vecY(),dSizePly/2);
		dpLine2.draw(plC);
		
		ptCen.transformBy(csTe.vecZ()*dSizePly);
	}
}

//__Create the outline display
if(stDisplayOutline==arYN[0])
{
	PLine pl;
	pl.createConvexHull(pnBase, arPtXZ);
	PlaneProfile ppOutline(pl);
	
	Display dpOutlineS(iColorOutline);
	//dpOutline.lineType(stLineTypeOutine);
	dpOutlineS.showInDispRep("Truss Outline (Solid)");
	dpOutlineS.draw(ppOutline);

	Display dpOutline(iColorOutline);
	dpOutline.lineType(stLineTypeOutine);
	dpOutline.showInDispRep("Truss Outline (Hidden)");	
	dpOutline.draw(ppOutline);
	
	Display dpProp(iColorOutline);
	dpOutline.lineType(stLineTypeOutine);
	dpOutline.showInDispRep(stDispRepOutline);
	dpOutline.draw(ppOutline);
	
	if(arPtEnd.length() == 4)
	{
		Display dpX(-1);
		PLine plX(arPtEnd[0],arPtEnd[3],arPtEnd[2],arPtEnd[1]);
		dpOutlineS.draw(plX);
		dpOutline.draw(plX);
		dpOutline.draw(plX);
		
	}
}
	

//__Draw Label
{
	Display dp(iColorLabel);
	dp.showInDispRep(stDispRepLabel);
	dp.dimStyle(stDim);
	if(dTH>U(0))dp.textHeight(dTH);
	
	//Get text vectors
	Vector3d vTest(_YW-(_XW*0.8));
	
	Vector3d vx=csTe.vecX(),vy=-csTe.vecZ();
	double dAngleTest=vy.angleTo(vTest);
	if(dAngleTest>90){
		vx=-csTe.vecX();
		vy=csTe.vecZ();
	}
	vx=vy.crossProduct(_ZW);
	
	String stText;
	
	if(stDisplayText == arStDisplay[0])stText=stLabel;
	else if(stDisplayText == arStDisplay[1])stText=stTag;
	else if(stDisplayText == arStDisplay[2])stText=stTag + " - " + stLabel;
	else if(stDisplayText == arStDisplay[3])stText=stLabel + " - " + stTag;
	
	
	dp.draw(stText,_Pt0,vx,vy,0,0);
}

#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`%(`9`#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#WJBBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHS1F@`HHS29H`
M6BDS2YH`**,T9H`**,T9H`**,T9H`**3-+F@`HHS1F@`HHS1F@`HHS1F@`HH
MS1F@`HI,TN:`"BC-&:`"BDS2YH`**,T9H`**,T9H`**,T9H`**,T9H`**,T9
MH`**,T9H`**3-+F@`HI,TN:`"BC-)F@!:**,T`%%&:3-`"9HS3<T9H`=FC--
MS1F@!V:,TW-&:`'9HS3<T9H`=FC--S1F@!V:,TW-&:`'9HS3<T9H`=FC--S1
MF@!V:,TW-&:`'9HS3<T9H`=FC--S1F@!V:,TW-&:`'9HS3<T9H`=FC--S1F@
M!V:,TW-&:`'9HS3<T9H`=FC--S1F@!V:,TW-&:`'9HS3<T9H`=FC--S1F@!V
M:,TW-&:`'9HS3<T9H`=FC--S1F@!V:,TW-&:`'9HS3<T9H`9FC--S1F@!V:,
MTW-&:`'9HS3<T9H`=FC--S1F@!V:,TW-&:`'9HS3<T9H`=FC--S1F@!V:,TW
M-&:`'9HS3<T9H`=FC--S1F@!V:,TW-&:`'9HS3<T9H`=FC--S1F@!V:,TW-&
M:`'9HS3<T9H`=FC--S1F@!^:3--S1F@!V:,TW-&:`'9HS3<T9H`?FDS3<T9H
M`=FC--S1F@!^:3--S1F@!^:3--S1F@!V:,TW-&:`'9HS3<T9H`9FC-,S1F@!
M^:,TS-&:`'YHS3,T9H`?FC-,S1F@!^:,TS-&:`'YHS3,T9H`?FC-,S1F@!^:
M,TS-&:`'YHS3,T9H`?FC-,S1F@!^:,TS-&:`'YHS3,T9H`?FC-,S1F@!^:,T
MS-&:`'YHS3,T9H`?FC-,S1F@!^:,TS-&:`'YHS3,T9H`?FC-,S1F@!^:,TS-
M&:`'YHS3,T9H`?FC-,S1F@!^:,TS-&:`'YHS3,T9H`?FC-,S1F@!F:,U'FC-
M`$F:,TS-)F@"3-&:CS1F@"3-&:CS2YH`?FC-1YHS0!)FC-1YI<T`/S1FF9I,
MT`29HS4>:,T`29HS3,T9H`?FC-1YHS0!)FC-,S29H`DS1FH\TN:`'YHS4>:,
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
*4?U]?>BBJ`__V28J
`




#End
