#Version 8
#BeginDescription
Flips wall corners
v0.4: 21.jul.2012: David Rueda (dr@hsb-cad.com)

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 0
#MinorVersion 4
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2011 by
*  hsbSOFT 
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
* v0.4: 21.jul.2012: David Rueda (dr@hsb-cad.com)
	- Description added
	- Thumbnail added
	- Copyright added
	V0.3_RL_March 2 2011_Can now stretch ACA wall at the same time
	Version 0.2 //used to flip wall corners
*
*/

Unit(1,"inch"); // script uses inch

//Stretch ACA wall
int iStretchACA=1;

//Flag that controls angulal walls
int nAngleConfig=7;
//0=butt and pass, 1=Miter, 2= open angle, 3=Miter-square bottom,4=Miter-square top,5=Square-miter bottom,6=Square-miter top
//7=Prompt
String strPrompt="\nAngle Type [1 Butt and pass/2 Miter/3 Open angle/4 Miter-square bottom/5 Miter-square top/6 Square-miter bottom/7 Square-miter top] <2>";

//angle tolerance for 90 degree corners
double dTol=4;//in degrees

///////////////////////////////////////////////Properties////////////////////////////////////

int strProp=0,nProp=0,dProp=0;
String arYN[]={"Yes","No"};


// bOnInsert
if (_bOnInsert)
{
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}

	PrEntity ssE("\n"+T("Select 2 elements"),Element());
	
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	return;
}

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if(_Element.length()!=2){
	eraseInstance();
	return;
}

//}//End Insert while testing

// check implementation requirements
if (_Element.length()!=2) { return;} 
if (_Element.length()==0) {eraseInstance(); return;}

//name both Elements
Element el1=_Element[0],el2=_Element[1];
ElementWall el1W=(ElementWall)el1;
ElementWall el2W=(ElementWall)el2;
Wall w1=(Wall)el1;
Wall w2=(Wall)el2;

Plane pn1(el1.ptOrg(),el1.vecZ()),pn2(el2.ptOrg(),el2.vecZ());
Line ln1(el1.ptOrg(),el1.vecX()),ln2(el2.ptOrg(),el2.vecX());
Vector3d v1=el1.vecX(),v2=el2.vecX();
Point3d ptCen1,ptCen2;
ptCen1.setToAverage(el1.plOutlineWall().vertexPoints(TRUE));
ptCen2.setToAverage(el2.plOutlineWall().vertexPoints(TRUE));
Line lnW1(w1.ptStart(),el1.vecX()),lnW2(w2.ptStart(),el2.vecX());

//see if there is a condition
if(!ln1.hasIntersection(pn2))eraseInstance();

//Create a mess of point to determin all corners
Point3d arPt[0];
arPt.append(ln1.intersect(pn2,U(0)));
arPt.append(ln2.intersect(pn1,U(0)));
ln1.transformBy(-el1.vecZ()*el1.dBeamWidth());
ln2.transformBy(-el2.vecZ()*el2.dBeamWidth());
arPt.append(ln1.intersect(pn2,U(0)));
arPt.append(ln2.intersect(pn1,U(0)));
pn1.transformBy(-el1.vecZ()*el1.dBeamWidth());
pn2.transformBy(-el2.vecZ()*el2.dBeamWidth());
arPt.append(ln1.intersect(pn2,U(0)));
arPt.append(ln2.intersect(pn1,U(0)));
ln1.transformBy(el1.vecZ()*el1.dBeamWidth());
ln2.transformBy(el2.vecZ()*el2.dBeamWidth());
arPt.append(ln1.intersect(pn2,U(0)));
arPt.append(ln2.intersect(pn1,U(0)));

_Pt0.setToAverage(arPt);

//see if vectors must be flipped
if(v1.dotProduct(_Pt0-ptCen1)<U(0))v1=-v1;
if(v2.dotProduct(_Pt0-ptCen2)<U(0))v2=-v2;

Vector3d vMiter(v1+v2);
vMiter.normalize();
Vector3d vMiterNorm=vMiter.crossProduct(el1.vecY());
vMiterNorm.normalize();

arPt=Line(_Pt0,-vMiter).orderPoints(arPt);
Point3d arPt1[]=Line(_Pt0,-v1).orderPoints(arPt);
Point3d arPt2[]=Line(_Pt0,-v2).orderPoints(arPt);

//Calculate distance to extreme most point to get which one goes first
Point3d ptC1=el1.plOutlineWall().closestPointTo(arPt[0]),ptC2=el2.plOutlineWall().closestPointTo(arPt[0]);

if(abs(v1.angleTo(v2)- 90)<=dTol){
	
	PLine pl1(w1.ptStart(),w1.ptEnd());
	pl1.vis(1);
	
	
	if(Vector3d(ptC1-arPt[0]).length()>Vector3d(ptC2-arPt[0]).length()){
		Plane pnCut1(arPt1[0],el2.vecZ()),pnCut2(arPt2[arPt2.length()-1],el1.vecZ());
		if(iStretchACA){
			Point3d ptW1=lnW1.intersect(pnCut1,U(0));
			if((w1.ptStart()-ptW1).length() < (w1.ptEnd()-ptW1).length()){
				w1.setStartEnd(ptW1,w1.ptEnd()); 
				w1.ptStart().vis(3);
				w1.ptEnd().vis(3);
				ptW1.vis(2);
			}
			else{
				w1.setStartEnd(w1.ptStart(),ptW1); 
				w1.ptStart().vis(1);
				w1.ptEnd().vis(3);
				ptW1.vis(2);
				
			}
		}
		
		el1W.stretchOutlineTo(pnCut1);
		el2W.stretchOutlineTo(pnCut2);
		
		
	}
	else{
		Plane pnCut1(arPt1[arPt1.length()-1],el2.vecZ()),pnCut2(arPt2[0],el1.vecZ());
		if(iStretchACA){
			Point3d ptW1=lnW1.intersect(pnCut1,U(0));
			if((w1.ptStart()-ptW1).length() < (w1.ptEnd()-ptW1).length()){
				w1.setStartEnd(ptW1,w1.ptEnd()); 
				w1.ptStart().vis(3);
				w1.ptEnd().vis(3);
				ptW1.vis(2);
			}
			else{
				w1.setStartEnd(w1.ptStart(),ptW1); 
				w1.ptStart().vis(1);
				w1.ptEnd().vis(3);
				ptW1.vis(2);
				
			}
		}
		el1W.stretchOutlineTo(pnCut1);
		el2W.stretchOutlineTo(pnCut2);		
	}
}
else
{
	reportMessage("\nConnection angle of " +  v1.angleTo(v2) + " degrees");
	
	int nConfig=1;
	
	if(nAngleConfig==7){
		int n= getInt(strPrompt);
		if(n>0 && n<8) nConfig=n-1;
		else nConfig=1;
	}
	
	if(nConfig==0){//butt and pass
		if(Vector3d(ptC1-arPt[0]).length()>Vector3d(ptC2-arPt[0]).length()){
			Plane pnCut1(arPt1[0],el2.vecZ()),pnCut2(arPt2[arPt2.length()-1],el1.vecZ());
			el1W.stretchOutlineTo(pnCut1);
			el2W.stretchOutlineTo(pnCut2);
		}
		else{
			Plane pnCut1(arPt1[arPt1.length()-1],el2.vecZ()),pnCut2(arPt2[0],el1.vecZ());
			el1W.stretchOutlineTo(pnCut1);
			el2W.stretchOutlineTo(pnCut2);	
		}
	}
	else if(nConfig==1){//miter
		Plane pnCut(arPt[0],vMiterNorm);
		el1W.stretchOutlineTo(pnCut);
		el2W.stretchOutlineTo(pnCut);
	}	
	else if(nConfig==2){//open
			Plane pnCut1(arPt[arPt.length()-1],v1),pnCut2(arPt[arPt.length()-1],v2);
			el1W.stretchOutlineTo(pnCut1);
			el2W.stretchOutlineTo(pnCut2);
	}	
	else if(nConfig==3){//open
			Plane pnCut(arPt[arPt.length()-1],v1);
			el1W.stretchOutlineTo(pnCut);
			el2W.stretchOutlineTo(pnCut);
	}		
	else if(nConfig==4){//open
			Plane pnCut(arPt[0],v1);
			el1W.stretchOutlineTo(pnCut);
			el2W.stretchOutlineTo(pnCut);
	}
	else if(nConfig==5){//open
			Plane pnCut(arPt[arPt.length()-1],v2);
			el1W.stretchOutlineTo(pnCut);
			el2W.stretchOutlineTo(pnCut);
	}		
	else if(nConfig==6){//open
			Plane pnCut(arPt[0],v2);
			el1W.stretchOutlineTo(pnCut);
			el2W.stretchOutlineTo(pnCut);
	}	
}
				
Group grp1 = el1W.elementGroup();
Group grp2 = el2W.elementGroup();
String strName1 = grp1.name();
String strName2 = grp2.name();
pushCommandOnCommandStack("-Hsb_GenerateConstruction "+strName1);
pushCommandOnCommandStack("-Hsb_GenerateConstruction "+strName2);

eraseInstance();
return;























#End
#BeginThumbnail
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
>BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@#__9
`


#End
