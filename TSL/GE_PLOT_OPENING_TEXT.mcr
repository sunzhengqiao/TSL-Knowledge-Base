#Version 8
#BeginDescription
v2.8: 11.oct.2013: David Rueda (dr@hsb-cad.com)
Displays opening info:
- Sill height
- Header height
- Rough opening
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 2
#MinorVersion 8
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

* v1.0: 14.mar.2013: David Rueda (dr@hsb-cad.com)
	- Copied from BP_PLOT_OPENING_TEXT, to keep US content folder naming standards
* v2.7: 14.mar.2013: David Rueda (dr@hsb-cad.com)
	- Version control from 1.0 to 2.7, to keep updated with BP_PLOT_OPENING_TEXT
	- Description added
	- Copyright added
	- Thumbnail added
* v2.8: 11.oct.2013: David Rueda (dr@hsb-cad.com)
	- Text will be always parallel to _XW
*/

Unit(1,"inch"); // script uses mm

String strChoise[]={"Yes","No"};
PropString sDimLayout(0,_DimStyles,T("DimStyle"));
PropString pSill(1,strChoise,"Display Sill Height");
PropString pSillPF(2,"Sill: ","Sill Prefix");
PropString pHead(3,strChoise,"Display Head Height");
PropString pHeadPF(4,"Head: ","Head Height Prefix");
PropString pModule(5,strChoise,"Display Module Name");
PropString pSizePF(6,"","Module Prefix");
PropString pRO(7,strChoise,"Display RO");

PropString pROPF(8,"RO: ","RO Prefix");

String arRoFrom[]={"Framed hole","Opening size"};
PropString pRoFrom(9,arRoFrom,"Take Opening Properties from");

PropDouble dOffsetText(0,U(0.6),"Offset Text");
PropDouble dOffsetAllTextX(1,U(0.6),"Offset All Text-X");
PropDouble dOffsetAllTextY(2,U(0.6),"Offset All Text-Y");
PropDouble dTH(3,1,"Text Height");
PropDouble dmm(4,1,"Scale output by");
dmm.setFormat(_kNone);
PropString pBrockportDefaults(10,strChoise,"Set To Brockport Defaults",1);

//Set the brockport defaults here
if(pBrockportDefaults!=strChoise[1])
{
	sDimLayout.set("RandyVP(inch)");
	pSill.set(strChoise[0]);
	pSillPF.set("Sill: ");
	pHead.set(strChoise[0]);
	pHeadPF.set("Head: ");
	pModule.set(strChoise[0]);
	pSizePF.set("");
	pRO.set(strChoise[0]);
	pROPF.set("RO: ");
	pRoFrom.set("Framed hole");
	dOffsetText.set(U(0.125));
	dOffsetAllTextX.set(U(0));
	dOffsetAllTextY.set(U(0));
	dTH.set(U(0.09375));
	dmm.set(1);
	pBrockportDefaults.set(strChoise[0]);
}

dmm.setFormat(_kNone);

if (_bOnInsert)
{
  Viewport vp = getViewport("Select a viewport"); // select viewport
  _Viewport.append(vp);

  return;
}

// set the diameter of the 3 circles, shown during dragging
setMarbleDiameter(U(4));

Display dp(-1); // use color red
dp.dimStyle(sDimLayout); // dimstyle was adjusted for display in paper space, sets textHeight
if(dTH>0)dp.textHeight(dTH);


if (_bOnDebug)
{
  // draw the scriptname at insert point
  dp.draw(scriptName() ,_Pt0,_XW,_YW,1,1);
}

// do something for the last appended viewport only
if (_Viewport.length()==0) return; // _Viewport array has some elements
Viewport vp = _Viewport[_Viewport.length()-1]; // take last element of array
_Viewport[0] = vp; // make sure the connection to the first one is lost

// check if the viewport has hsb data
if (!vp.element().bIsValid()) return;

CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
Element el = vp.element();
Plane pnEl(el.ptOrg(),el.vecZ());
Point3d ptMiddleOp[0];
Point3d ptMidOpe;

Wall wl = (Wall)el;
double dWallHeight=wl.baseHeight();

//Put all Ope in array
Opening arOpenings[] = el.opening(); // collect all openings // include the opening gaps

//Sorting of Opening Array
Opening arSortOpenings[0] ;
double dDistArray[0];
int iCommonHeader=0;
for (int i=0; i<arOpenings.length(); i++)
{
	Opening opngi = arOpenings[i]; 
	CoordSys csOpi=opngi.coordSys();
	Vector3d vxOpi=csOpi.vecX();
	Vector3d vyOpi=csOpi.vecY();
	Vector3d vzOpi=csOpi.vecZ();
	Point3d ptOrgOpi=csOpi.ptOrg();
	PLine plOpi= opngi.plShape();
	double dDistToOrgi=el.vecX().dotProduct(plOpi.ptStart()-el.ptOrg());

	for (int j=0; j<arOpenings.length(); j++)
	{
		if(j==i)continue;
		Opening opngj = arOpenings[j]; 		
		Point3d ptOrgOpj=csOpi.ptOrg();
		PLine plOpj= opngj.plShape();//plOp.transformBy(ms2ps);plOp.vis(1);
		double dDistToOrgj=el.vecX().dotProduct(plOpj.ptStart()-el.ptOrg());
		if(dDistArray.length()>1)
		{
			if(dDistArray[dDistArray.length()-1]<dDistArray[dDistArray.length()-2])
			{
						arSortOpenings.swap(dDistArray.length()-2,dDistArray.length()-1);
						dDistArray.swap(dDistArray.length()-2,dDistArray.length()-1);
			}			
		}
		if(arSortOpenings.find(opngj)>-1)continue;
		if(dDistToOrgj<dDistToOrgi){
				arSortOpenings.append(opngj);
				dDistArray.append(dDistToOrgj);
		}
	}
}

for (int i=0; i<arOpenings.length(); i++)
{	
		Opening opngi = arOpenings[i];		
 		if(arSortOpenings.find(opngi)>-1)continue;
		arSortOpenings.append(opngi);
}

//Work on individual Openning
for (int i=0; i<arSortOpenings.length(); i++) 
{
	//Unit correction
	Point3d ptText;
	Point3d ptText1;
	
	Opening opng = arSortOpenings[i]; 
	PLine plOp= opng.plShape();//plOp.transformBy(ms2ps);plOp.vis(1);
	double dMovePl=el.vecZ().dotProduct(plOp.ptStart()-el.ptOrg());
	plOp.transformBy(el.vecZ()*dMovePl);

	// create body to find beams
	Body bdOp(plOp,el.vecZ()*U(24),0);
	bdOp.transformBy(el.vecY()*U(6));
	int x=5*i;
	Beam arBm[]=el.beam();	

	//create ope
	PlaneProfile ppOp(plOp);
	ppOp.shrink(U(-3));
	
	//see if it touched another ope
	for (int j=0; j<arSortOpenings.length(); j++) {
		if(j==i)continue;
		PLine plOp2= arSortOpenings[j].plShape();
		PlaneProfile ppOp2(plOp2);
		ppOp2.shrink(U(-2));
		
		PLine arPl1[]=ppOp.allRings();
		PLine arPl2[]=ppOp2.allRings();	
		
		if(arPl1.length()*arPl2.length()==0)continue;
		
		Body bdOp1(arPl1[0],el.vecZ()*U(20),0);
		Body bdOp2(arPl2[0],el.vecZ()*U(20),0);
		
		bdOp1.transformBy(el.vecY()*U(6));
		bdOp2.transformBy(el.vecY()*U(6));
	
		if(bdOp1.hasIntersection(bdOp2))
		{
			ppOp.unionWith(ppOp2);
			
			PLine arPlNew[]=ppOp.allRings();
			plOp=arPlNew[0];
			arSortOpenings.removeAt(j);
		} 
		for(int j=0;j<arBm.length();j++){
		
			if(arBm[j].type()==_kHeader || arBm[j].type()==_kSFTransom){
				Beam bm=arBm[j];
				Body bdBm=bm.realBody();
				if(bdBm.hasIntersection(bdOp1) && bdBm.hasIntersection(bdOp2))
					iCommonHeader=1;
			}
		}	
	}

	String strMod="-1";
	for(int j=0;j<arBm.length();j++){
		//if(arBm[j].type()==_kHeader || arBm[j].type()==_kSFTransom)continue;
		if(iCommonHeader==1 ){
			if(arBm[j].type()==_kHeader || arBm[j].type()==_kSFTransom)continue;
		}
		if(arBm[j].realBody().hasIntersection(bdOp) && arBm[j].module().length()>1)
		{
			strMod=arBm[j].module();
			break;
		}
	}
	
	PlaneProfile ppBms;
	Beam arBmMod[0];
	Beam arBmJackUnOp[0];
	Beam arBmHeader[0];

	for(int j=0;j<arBm.length();j++){
			if(arBm[j].module() == strMod && arBm[j].type() != _kBrace){
			arBmMod.append(arBm[j]);
			PlaneProfile ppBm=arBm[j].realBody().extractContactFaceInPlane(pnEl,U(8));
			ppBm.shrink(U(-6));
			ppBms.unionWith(ppBm);
			ppOp.subtractProfile(ppBm);		 	
			}		
	}

	PLine plRecBase;plRecBase.createRectangle(LineSeg(el.ptOrg()-el.vecX()*U(36),el.ptOrg()+el.vecX()*U(500)-el.vecY()*U(36)),el.vecX(),el.vecY()); ;
	PlaneProfile ppBase(plRecBase);
	ppBase.shrink(U(-6));
	ppOp.subtractProfile(ppBase);
	ppOp.shrink(U(-6));

	PLine arPlRings[]=ppOp.allRings();	
	double dNSill=0,dNHead=0,dNW=0,dNH=0;

	if(arPlRings.length()>0)
	{
		
		PLine pl=arPlRings[0];
		pl.transformBy(ms2ps);
		pl.vis();
		PLine plRing=arPlRings[0];
		Point3d arPtV[]=Line(el.ptOrg(),el.vecY()).orderPoints(plRing.vertexPoints(TRUE));	
		Point3d arPtH[]=Line(el.ptOrg(),el.vecX()).orderPoints(plRing.vertexPoints(TRUE));		
		double dS=el.vecY().dotProduct(arPtV[0]-el.ptOrg());
		if(dS>0)dNSill=dS;
		double dH=el.vecY().dotProduct(arPtV[arPtV.length()-1]-el.ptOrg());
		dNHead=dH;
		dNW=abs(el.vecX().dotProduct(arPtH[arPtH.length()-1]-arPtH[0]));
		dNH=abs(el.vecY().dotProduct(arPtV[arPtV.length()-1]-arPtV[0]));
	}
	
	if(pRoFrom==arRoFrom[1])
	{
		dNW=opng.width();
		dNH=opng.height();
		dNSill=opng.sillHeight();
		dNHead=opng.headHeight();
	}
	
	double dOW=U(dNW,"inch",3); 
	double dOH=U(dNH,"inch",3); 

	//Center of ope in paper space
	ptMidOpe.setToAverage(plOp.vertexPoints(TRUE));
	ptMiddleOp.append(ptMidOpe);
	ptMidOpe=ptMidOpe+dOffsetAllTextY*el.vecY();
	ptMidOpe=ptMidOpe+dOffsetAllTextX*el.vecX();
	double dMove=el.vecX().dotProduct(ptMidOpe-ptText);
	double dMove1=el.vecY().dotProduct((el.ptOrg()+dWallHeight*el.vecY())-ptMidOpe);
	ptText=ptText+dMove*el.vecX();
	ptText=ptMidOpe+(dMove1+U(2))*el.vecY();

	String strModuleTemp=strMod.spanExcluding(" ^ ");
	String strModule=strModuleTemp;


	if(ptMiddleOp.length()>=2){
		if(abs(el.vecX().dotProduct(ptMiddleOp[0]-ptMiddleOp[1]))<U(65))ptText=ptText+el.vecY()*U(5);
	}
	
	if(ptMiddleOp.length()>=3){
		if(abs(el.vecX().dotProduct(ptMiddleOp[0]-ptMiddleOp[1]))<U(65) && abs(el.vecX().dotProduct(ptMiddleOp[1]-ptMiddleOp[2]))>U(65))ptText=ptText-el.vecY()*U(5);
		else if(abs(el.vecX().dotProduct(ptMiddleOp[0]-ptMiddleOp[1]))<U(65) && abs(el.vecX().dotProduct(ptMiddleOp[1]-ptMiddleOp[2]))<U(65))ptText=ptText-el.vecY()*U(5);
		else if(abs(el.vecX().dotProduct(ptMiddleOp[0]-ptMiddleOp[1]))>U(65) && abs(el.vecX().dotProduct(ptMiddleOp[1]-ptMiddleOp[2]))<U(65))ptText=ptText+el.vecY()*U(5);	
	}
	
	if(ptMiddleOp.length()>=4){
		if(abs(el.vecX().dotProduct(ptMiddleOp[0]-ptMiddleOp[1]))<U(65)){
			if(abs(el.vecX().dotProduct(ptMiddleOp[1]-ptMiddleOp[2]))<U(65) && abs(el.vecX().dotProduct(ptMiddleOp[2]-ptMiddleOp[3]))<U(65))ptText=ptText+el.vecY()*U(5);
		}
		if(abs(el.vecX().dotProduct(ptMiddleOp[0]-ptMiddleOp[1]))>U(65)){
			if(abs(el.vecX().dotProduct(ptMiddleOp[1]-ptMiddleOp[2]))<U(65) && abs(el.vecX().dotProduct(ptMiddleOp[2]-ptMiddleOp[3]))<U(65))ptText=ptText-el.vecY()*U(5);
			if(abs(el.vecX().dotProduct(ptMiddleOp[1]-ptMiddleOp[2]))>U(65) && abs(el.vecX().dotProduct(ptMiddleOp[2]-ptMiddleOp[3]))<U(65))ptText=ptText+el.vecY()*U(5);
			if(abs(el.vecX().dotProduct(ptMiddleOp[1]-ptMiddleOp[2]))<U(65) && abs(el.vecX().dotProduct(ptMiddleOp[2]-ptMiddleOp[3]))>U(65))ptText=ptText-el.vecY()*U(5);
		}
	} 
	
	OpeningSF ope = (OpeningSF) opng;	

	String st1; st1.formatUnit(dNSill*dmm,sDimLayout);

	String st2; st2.formatUnit(dNHead*dmm,sDimLayout);

	String st5; st5.format(dOW*dmm,sDimLayout);
	String st6; st6.format(dOH*dmm,sDimLayout);

	String sSt5f = st5.token(0,".");
	String sSt6f = st6.token(0,".");
	double dWidth=sSt5f.atof();
	double dHt=sSt6f.atof();
	double dSt5Dist=abs(dOW-dWidth);
	double dSt6Dist=abs(dOH-dHt);
	String st7; 
	String st8; 
	if(dSt6Dist<U(0.09375))	st7.format("%.0f",dHt);
	else if(dSt6Dist>U(0.09375) && dSt6Dist<U(0.95)){ 
		st6.formatUnit(dSt6Dist*dmm,sDimLayout);
		st7=sSt6f+"-"+st6;
	}
	else{ 
		double dTempSt6=dHt+U(1);
		st7.format(dTempSt6*dmm,sDimLayout);
	}
	if(dSt5Dist<U(0.09375))	st8.format("%.0f",dWidth);
	else if(dSt5Dist>U(0.09375) && dSt5Dist<U(0.95)){ 
		st5.formatUnit(dSt5Dist*dmm,sDimLayout);
		st8=sSt5f+"-"+st5;
	}
	else{ 
		double dTempSt5=dWidth+U(1);
		st8.format(dTempSt5*dmm,sDimLayout);
	}
	
	Vector3d vReadY=_YW;
	Vector3d vReadX=_XW;

	/*if(dNW<U(30)) // DR: 11.oct.2013
	{
		vReadX=_YW;
		vReadY=-_XW;
	}*/ 
	
	ptMidOpe.transformBy(ms2ps);
	ptText.transformBy(ms2ps);
	
	Point3d pt11 = ptMidOpe -dOffsetText*vReadY; 
	Point3d pt22 = ptMidOpe +dOffsetText*vReadY; 
	Point3d pt33 = ptText +2*dOffsetText*_YW; 

	//Place all text
	if (pSill=="Yes"){
	    dp.draw(pSillPF+st1,pt11,vReadX,vReadY,0,0);
	}
	if (pHead=="Yes"){
	    dp.draw(pHeadPF+st2,pt22,vReadX,vReadY,0,0);
	}
	/*if (pModule=="Yes"){
	    dp.draw(pSizePF+strModule,pt33,vReadX,vReadY,0,0);
	}*/ 
	if (pModule=="Yes"){
	    dp.draw(pSizePF+strModule,pt33,_XW,_YW,0,0);
	}

	if (pRO=="Yes"){
	    dp.draw(pROPF+st8+"x"+st7,ptMidOpe,vReadX,vReadY,0,0);
	}
}

#End
#BeginThumbnail
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
/O_`7K^C._HHHKN/G3__9
`


#End
