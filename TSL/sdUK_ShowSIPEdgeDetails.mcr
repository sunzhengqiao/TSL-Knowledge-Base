#Version 8
#BeginDescription
 #Versions
Version 1.5 05.08.2021 HSB-12767 bugfix outlines , Author Thorsten Huck
Version 1.4 03.08.2021 HSB-12767 bugfix dimlines , Author Thorsten Huck


Shows the detail of each edge of a SIP wall in shop drawings




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 5
#KeyWords 
#BeginContents
// #Versions
// 1.5 05.08.2021 HSB-12767 bugfix outlines , Author Thorsten Huck
// 1.4 03.08.2021 HSB-12767 bugfix dimlines , Author Thorsten Huck



/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2012 by
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
* Created by: Chirag Sawjani (csawjani@itw-industry.com)
* date: 13.07.2012 
* version 1.0: Release
*
* Modified by: Chirag Sawjani (chiragsawjani@hsbcad.com)
* date: 07.08.2014 
* version 1.1: Made angle output consistent with other panel CNC output
*
* Modified by: Chirag Sawjani (chiragsawjani@hsbcad.com)
* date: 11.06.2015
* version 1.2: Altered vectors to suit new coordsys, valid from 19.1.104
*/


//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	// read a potential mapObject defined by hsbDebugController
	{ 
		MapObject mo("hsbTSLDev" ,"hsbTSLDebugController");
		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true;	break;}}
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		
	}
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
//end Constants//endregion


	
	





String sModel = T("|Model|");
String sShopdrawSpace = T("|shopdraw multipage|");
String sArSpace[] = { sModel , sShopdrawSpace };
PropString sSpace(0,sArSpace,T("|Drawing space|"));
PropString sDimLayout(1,_DimStyles,T("|Dimstyle|"));

PropInt nDetailColor(0,1,T("|Detail Color|"));
if (nDetailColor< 0 || nDetailColor> 255) nDetailColor.set(0);

PropInt nTextColor(1,0,T("|Text Color|"));
if (nTextColor< 0 || nTextColor> 255) nTextColor.set(0);

PropInt nMaxRows(2,5,T("|Maximum Number of Rows|") );

PropDouble dDimOffset(0,50,T("|Dimensions offset|"));
PropDouble dExtraOffset(1,200,T("|Extra offset between details|"));

if(_bOnInsert)
{
	showDialog();

	_Pt0=getPoint(T("|Pick a point for edge details|"));
	
		if (sSpace == sModel)
	{	//Model
		PrEntity ssE(T("|Please select Elements|"),Sip());
	 	if (ssE.go())
		{
	 		Entity ents[0];
	 		ents = ssE.set();
	 		for (int i = 0; i < ents.length(); i++ )
			 {
	 			Sip s = (Sip) ents[i];
	 			_Entity.append(s);
	 		 }
	 	}	
	}
	else if (sSpace == sShopdrawSpace)
	{	//Shopdraw Space
	
		//Shopdraw Space
		Entity ent = getShopDrawView(T("|Select the view entity from which the module is taken|")); // select ShopDrawView
		_Entity.append(ent);
	}


	
	return;

}//end bOnInsert

// coordSys
CoordSys ms2ps, ps2ms;	
Sip sipCurr;

Display dp(nDetailColor);
dp.dimStyle(sDimLayout);

if (_Entity.length()==0) return; // _Entity array has some elements

if (sSpace == sModel) 
{
	sipCurr=(Sip)_Entity[0];
}

if (sSpace == sShopdrawSpace ) 
{
	
	ShopDrawView sv = (ShopDrawView)_Entity[0];
	if (!sv.bIsValid()) return;
	
	// interprete the list of ViewData in my _Map
	ViewData arViewData[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets,0); // 2 means verbose
	int nIndFound = ViewData().findDataForViewport(arViewData, sv);// find the viewData for my view
	if (nIndFound<0) 
	{
		dp.dimStyle(sDimLayout);
		dp.draw(scriptName(),_Pt0,_XW ,_YW,1,0);	
		return; // no viewData found
	}
	
	ViewData vwData = arViewData[nIndFound];
	Entity arEnt[] = vwData.showSetEntities();

	ms2ps = vwData.coordSys();
	ps2ms = ms2ps;
	ps2ms.invert();

	for (int i = 0; i < arEnt.length(); i++)
	{
		Entity ent = arEnt[i];
		if (arEnt[i].bIsKindOf(Sip()))
		{
			sipCurr=(Sip)ent;
		}
	}
}

//Sip vectors
CoordSys csSip=sipCurr.coordSys();
Vector3d vx = csSip.vecX();
Vector3d vy = csSip.vecY();
Vector3d vz = csSip.vecZ();

Point3d ptSipCen=sipCurr.ptCen();

vx.normalize();
vy.normalize();
vz.normalize();

csSip.vis();

//Components
Body bdComponents[0];
int nNumComp = SipStyle(sipCurr.style()).numSipComponents();
for (int s=0; s<nNumComp; s++) 
{
	Body bd = sipCurr.realBodyOfComponentAt(s);
	bdComponents.append(bd);
}

Body bdSipEnvelope=sipCurr.envelopeBody(false, true);
Body bdSipReal=sipCurr.realBody();

Plane plnNormal(ptSipCen,-vz);
PlaneProfile ppSip(plnNormal);
PlaneProfile ppComponents[0];


PLine plAllRingsBm[]=ppSip.allRings();
PLine plOutline;

double dSipDepth=sipCurr.dD(-vz);

//Get the outermost ring
for (int i=0; i<plAllRingsBm.length(); i++)
{
	if (plAllRingsBm[i].area()>plOutline.area())
	{
		plOutline=plAllRingsBm[i];
	}
}

SipEdge sipEdges[]=sipCurr.sipEdges();

for(int e=0;e<sipEdges.length();e++)
{
	SipEdge edge=sipEdges[e];
	PLine plEdge=edge.plEdge();
}

PlaneProfile ppEdges[0];

int nRowCount;
double dNewDetailVertOffset;
//Loop through all the edges of the shape extracting plane profile slices at the centre point of each vertex
for(int e=0;e<sipEdges.length();e++)
{
	SipEdge edge=sipEdges[e];
	
	
	//Get the centre point of the vertex
	Point3d ptStart=edge.ptStart();
	Point3d ptEnd=edge.ptEnd();
	Point3d ptMid=edge.ptMid();
	ptMid.vis();
	Vector3d vecN = edge.vecNormal();
	vecN .vis(ptMid);
	Vector3d vecVertex=ptEnd-ptStart;
	vecVertex.normalize();
	vecVertex.vis(ptMid);
	
	//Create a slice of the SIP through the centre point of the vertex
	Plane plSlice(ptMid,vecVertex);

	PlaneProfile ppSlice;
	PlaneProfile ppSliceComponents(plSlice);
	ppSlice=bdSipReal.getSlice(plSlice);
	
	//Slice Each component
	for(int b=0;b<bdComponents.length();b++)
	{
		Body bd=bdComponents[b];
		PlaneProfile pp=bd.getSlice(plSlice);
		pp.shrink(dEps*.01);
		//pp.vis();
		PLine pl[]=pp.allRings();
		for(int p=0;p<pl.length();p++)
		{
			ppSliceComponents.joinRing(pl[p],false);
		}
		
	}
	//ppSliceComponents.shrink(-dEps);
	//ppSlice.vis(5);
	//ppSliceComponents.vis();
	
	PlaneProfile ppSliceEnvelope;
	ppSliceEnvelope=bdSipEnvelope.getSlice(plSlice);
	
	//Possibility of multiple rings being formed.  Only the closest ring to the edge is important
	ppSliceEnvelope.shrink(U(-10));
	PLine plSlices[]=ppSlice.allRings();

	PLine plSliceEnvelopes[]=ppSliceEnvelope.allRings();
	if(plSlices.length()==plSliceEnvelopes.length())
	{
		for(int p=0;p<plSliceEnvelopes.length();p++)
		{
			PLine plCurr=plSliceEnvelopes[p];
			PlaneProfile ppTemp(plCurr);

			if(ppTemp.pointInProfile(ptMid)==_kPointInProfile)
			{
				ppSliceEnvelope=ppTemp;
				double dArea=ppSliceEnvelope.area();
				//ppSliceEnvelope.vis(1);
				//Check which slice is in this ring
				for(int s=0;s<plSlices.length();s++)
				{
					PLine plSliceCurr=plSlices[s];

					PlaneProfile ppSliceCurr(plSliceCurr);
					//ppSliceCurr.vis(2);
					PlaneProfile ppAux2;
					ppAux2=ppTemp;
					int nSubtract=ppAux2.intersectWith(ppSliceCurr);
					
					//Same for components
					PlaneProfile ppAux3;
					ppAux3=ppTemp;

					if(nSubtract)
					{
						//ppAux2.vis(3);
						ppSlice=ppSliceCurr;
						ppSliceComponents.intersectWith(ppSliceCurr);

					}
				}
				
				break;
			}
		}
		
	}
	ppSliceEnvelope.shrink(U(10)); // HSB-12767 
ppSliceEnvelope.vis(3);
	//For each slice, only interested in the top part of the profile that defines the edge.  Create a rectangular plane profile of the size of the maximum shape of the plane profile
	//move it in the direction of the uninterested part and subtract that part
	
	//Get extermities of planeprofile by ordering points along the normal vector of the edge
	Point3d ptPPVertices[]=ppSliceEnvelope.getGripVertexPoints();

	Vector3d vecLengthPP;
	vecLengthPP=vecVertex.crossProduct(-vz);
	vecLengthPP.normalize();
	vecLengthPP.vis(ptMid);	
	
	Line lnAlongPP(ptMid+U(5)*vecLengthPP,ptMid);
	
	Point3d ptPPVerticesOrdered[]=lnAlongPP.orderPoints(ptPPVertices);
	Point3d ptPPAverage;
	ptPPAverage.setToAverage(ptPPVerticesOrdered);
	ptPPAverage.vis();

	// calc bevel.
	Vector3d vecRef = vz.crossProduct(vecN);
	vecRef.vis(ptMid);
	double dBevelAngle = abs(-vz.angleTo(vecN));
	double dBevelAngleQ1;
	String sBevelAngle;
	if(dBevelAngle>90 && dBevelAngle<=180)
	{
		dBevelAngleQ1=90-abs(dBevelAngle-180);
	}
	else
	{
		dBevelAngleQ1=90-abs(dBevelAngle);		
	}
	sBevelAngle.formatUnit((90-abs(dBevelAngle)),2,1);

	double dExteremes;
	Point3d ptExtremeStart;
	if(ptPPVerticesOrdered.length()>2)
	{

		ptExtremeStart=ptPPVerticesOrdered[0];
		Point3d ptExtremeEnd=ptPPVerticesOrdered[ptPPVerticesOrdered.length()-1];
		
		
		Point3d ptMidProject=lnAlongPP.closestPointTo(ptMid);
		ptMidProject.vis();
		//Check which point is closest to the ptMid
		if(abs((ptExtremeStart-ptMidProject).length())>abs((ptExtremeEnd-ptMidProject).length()))
		{
			//Swap
			ptExtremeEnd=ptPPVerticesOrdered[0];
			ptExtremeStart =ptPPVerticesOrdered[ptPPVerticesOrdered.length()-1];
			vecLengthPP=-vecLengthPP;
			//vy=-vy;
		}

		
		//Create Extreme points which are at the centre of the panel
		ptExtremeStart=ptExtremeStart.projectPoint(plnNormal,0);
		ptExtremeEnd=ptExtremeEnd.projectPoint(plnNormal,0);
		
		ptExtremeStart.vis();
		ptExtremeEnd.vis();
				
		Vector3d vecExtremes=ptExtremeEnd-ptExtremeStart;
		dExteremes=abs(vecLengthPP.dotProduct(vecExtremes));
	}
	
	//Create Rectange
	Point3d ptRecStart=ptPPAverage-(0.5*dExteremes)*vecLengthPP+(U(0.5*dSipDepth)+U(20))*-vz;
	Point3d ptRecEnd=ptPPAverage+(0.5*dExteremes)*vecLengthPP-(U(0.5*dSipDepth)+U(20))*-vz;
	LineSeg lsRectangle(ptRecStart,ptRecEnd);
	
	PLine plRectangle;
	plRectangle.createRectangle(lsRectangle,vecLengthPP,-vz);


	//Move rectangle along by a certain amount
		double dOffsetDistance=U(200);
	if(dBevelAngleQ1<90 && dBevelAngleQ1>0)
	{
		dOffsetDistance=(dSipDepth/tan(90-dBevelAngleQ1))+dExtraOffset;
	}
	Vector3d vecTranslation=-(dOffsetDistance)*vecLengthPP;
	plRectangle.transformBy(vecTranslation);
	//plRectangle.vis(4);
	
	//Alter the plane profile to give only the edge 
	PlaneProfile ppRectangle(plRectangle);
			ppSlice.vis(1);
				ppSliceComponents.vis(2);
	ppSlice.subtractProfile(ppRectangle);

	ppSliceComponents.subtractProfile(ppRectangle);
	ppSlice.vis(1);
	ppSliceComponents.vis(2);
	
	//Envelope
	ppSliceEnvelope.subtractProfile(ppRectangle);
	
	//Get Recess depth
	String sRecessDepth;
	sRecessDepth.formatUnit(edge.dRecessDepth(),2,1);
	
	//Add dimensions to the various edge slices
	//Horizontal dimensions
	Point3d ptSliceVertices[0];
	ptSliceVertices=ppSliceEnvelope.getGripVertexPoints();
	Point3d ptSliceVerticesEnvelope[0];
	ptSliceVerticesEnvelope=ppSliceEnvelope.getGripVertexPoints();
	
	Line lnHorizontal(ptExtremeStart,-vz);
	Point3d ptSliceProjected[]=lnHorizontal.projectPoints(ptSliceVertices);
	Point3d ptDimsHorizontal[]=lnHorizontal.orderPoints(ptSliceProjected);
	DimLine dlHorizontal(ptExtremeStart+(dDimOffset*vecLengthPP), -vz,vecLengthPP);
	Dim dimHorizontal(dlHorizontal,ptDimsHorizontal,"<>","<>",_kDimDelta, _kDimNone);
	
	//Overall SIP dimension
	
	//Vertical Dimensions (Use of the envelopebody to get one set of dimensions)
	
	Line lnVertical(ptExtremeStart,vecLengthPP);
	if(vecN.dotProduct(-vz)<0)
	{
		lnVertical=Line(ptExtremeStart-((0.5*dSipDepth)*-vz),vecLengthPP);
	}
	else
	{
		lnVertical=Line(ptExtremeStart+((0.5*dSipDepth)*-vz),vecLengthPP);		
	}
	Point3d ptSliceProjectedVertical[]=lnVertical.projectPoints(ptSliceVerticesEnvelope);
	Point3d ptDimsVertical[]=lnVertical.orderPoints(ptSliceProjectedVertical);
	//Remove first point as it is not relevant
	ptDimsVertical.removeAt(0);
	DimLine dlVertical;
	Dim dimVertical;
	int nVerticalDim=false;
	if(ptDimsVertical.length()>1)
	{
		nVerticalDim=true;
		
		double dTest=vecN.dotProduct(-vz);
		if(vecN.dotProduct(-vz)<0)
		{
			dlVertical=DimLine (ptExtremeStart-((0.5*dSipDepth)*-vz)-(dDimOffset*-vz),vecLengthPP,vz );

		}
		else
		{
			dlVertical=DimLine (ptExtremeStart+((0.5*dSipDepth)*-vz)+(dDimOffset*-vz),-vecLengthPP,-vz);
		}
		dimVertical=Dim (dlVertical,ptDimsVertical,"<>","<>",_kDimDelta, _kDimNone);	
	}

	//Draw Dim
	if(sSpace == sShopdrawSpace)
	{
		Display dp(nDetailColor);
		dp.dimStyle(sDimLayout);
		
		Plane plCen(sipCurr.ptCen(),-vz);
		
		int nColumns=ceil((e)/nMaxRows);

		if (nRowCount+1>nMaxRows)
		{
			nRowCount=0;
			dNewDetailVertOffset=0;
		}
		

		String sEdgeDetail="E"+(e+1);		
		String sBevelAngleText="Bevel Angle: "+sBevelAngle;
		String sRecessDepthText="Recess Depth: "+sRecessDepth;
		
		//Vertical Offsets
		double dVertDetailOffset=dOffsetDistance+dp.textHeightForStyle("E",sDimLayout)+U(10);
		double dVertBevelOffset=dVertDetailOffset+dp.textHeightForStyle("R",sDimLayout)+U(10);
		double dVertRecessOffset=dVertBevelOffset+dp.textHeightForStyle("R",sDimLayout)+U(20);

		//reportNotice("\n"+dNewDetailVertOffset);

		//Horizontal Offsets
		double dHorizDetailOffset=(0.5*dp.textLengthForStyle(sEdgeDetail,sDimLayout));
		double dHorizBevelOffset=(0.5*dp.textLengthForStyle(sBevelAngleText,sDimLayout));
		double dNewDetailHorizOffset=dp.textLengthForStyle(sBevelAngleText,sDimLayout)+dSipDepth+U(50);
		
		Point3d ptProjectedExtreme=ptExtremeStart.projectPoint(plCen,0);
		Point3d ptNewOrigin=_Pt0-U(100)*_YW-dNewDetailVertOffset*_YW+dNewDetailHorizOffset*nColumns*_XW;
		CoordSys csTrans();
		csTrans.setToAlignCoordSys(ptProjectedExtreme,-vz,vecLengthPP,-vz.crossProduct(vecLengthPP),ptNewOrigin,_XW,_YW,_ZW);
		dimHorizontal.transformBy(csTrans);
		dimVertical.transformBy(csTrans);
		ppSliceComponents.transformBy(csTrans);
		

		dp.draw(dimHorizontal);
		if(nVerticalDim) dp.draw(dimVertical);
		dp.draw(ppSliceComponents);
		
		dp.color(nTextColor);
		dp.draw(sEdgeDetail,ptNewOrigin-(dVertDetailOffset*_YW)-(dHorizDetailOffset*_XW),_XW,_YW,1,-1); 
		dp.draw(sBevelAngleText ,ptNewOrigin-(dVertBevelOffset*_YW)-(dHorizBevelOffset*_XW),_XW,_YW,1,-1); 
		dp.draw(sRecessDepthText,ptNewOrigin-(dVertRecessOffset*_YW)-(dHorizBevelOffset*_XW),_XW,_YW,1,-1); 
		
		dNewDetailVertOffset+=dVertRecessOffset+dDimOffset+dp.textHeightForStyle("R",sDimLayout)+U(150);
		nRowCount++;
		//reportNotice("\n"+nRowCount);
	}
	else
	{
		Display dp(-1);
		dp.dimStyle(sDimLayout);
		dp.draw(dimHorizontal);
		if(nVerticalDim) dp.draw(dimVertical);
	}
	
}


#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`/J!W$#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#R:BBBM#,*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`*]4\4S2KH,4`E<0OX+TYVC#':S+=1@$CN
M0&;!]SZUSWPSAB7Q+<ZO-$DRZ+I\^I"!U!$K1KA1D_=(+!@V#@J.*]1\$V$N
MI>-O'T&I-<JR:I:SJ7)#;8YI)(OO?PX1,?[.,=J3*1X1H^G_`-JZQ:6)E\E)
MI0LDQ7(ACZO(>1\JKECR``#DBC6=0_M?7-0U+RO*^V7,EQY>[=LWL6QG`SC/
M7%;%N]G$?$VK:?$]O9A6MM/WG+1F=\!",G)-N)QDY`QUW;37-4Q!1110(***
M*`"MOQ#^^AT6^;B6ZTV/>!]T>4[VZX^J0J3[D]!@#$K;;_2/`\6SC[#J3^;G
MOY\:[,?3[,^<XZKC.3@&8E%%%`@HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`GL[2?4+ZWLK5/,N+B58HDR!N9C@#)X')[U=\1W<%[KUR]H_F6<6VVMI"
M""\,2B.-CG^(HBD\#DG@=*G\,?Z/?7.K?]`NV:[3'WA+E8X6`Z';+)&Q!XPI
MZ]#B4#"MO0O]#L=6U9N/)MC:0YY5I9P8]I'7_5>>P/`!09ZX.)6W??Z)X3TF
MUZ/=RS7SE.CQY$,8;U96BG([`2<'YF%`&)1110(****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@#U'X?6L
M'A+1?^$QULPMI>I[M+%O(I;>K21[GP`V5"I/E2!GRP!G<,=+XA\412^"M>\5
M6UDEK#K]I#86XD`+3.LMS&Y;;T80X.3P,`9;%,N_AYJ.O_#O2TTR\V6J:1:W
M%OIY?Y9;LEWD<EL[<K*P`!`)(R0$%<3X_P!/NM(;P_X+CEAOI=.BE*&V4F1Y
M)YV*J5R<,4$1V]<MU((-+<HYV^_T3PGI-KT>[EFOG*='CR(8PWJRM%.1V`DX
M/S,*Q*V/%,T4OB6]2WE26VMF%I;RHP8210J(HVR."2J*21P23C`XK'IB"BBB
M@04444`%;>B?Z5I>M::?F:2V%W!'TS+"VXMGVA-QP3@^[;:Q*V_"'S^+-.M3
M]R]E^PR$=1'.#"Y'^T%<D=1G&0>E`S$HHHH$%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`&VW^A^"UC?[^I7PF53P5C@1E#`?Q*S3.,\`&%ASSC$K;\5?
MZ/K']E+PFE1+8X'02)GSB#U*M,96&><,.!T&)0,?##+<SQP01/+-(P1(T4LS
M,3@``=23VK5\4S12^);U+>5);:V86EO*C!A)%"HBC;(X)*HI)'!).,#BG^&/
M]'OKG5O^@7;-=IC[PERL<+`=#MEDC8@\84]>AQ*`"BBB@04444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%;'AC
M16\1:ZFEQJ[3303M"J,%+2+"[H,G@`LH!]B>1UK'KT/X*Z?]M^(D-QYNS[#;
M2W&W;G?D"/'7C_69SSTQWH8T=UX;UB75M,^&NG7EO;26URMZDJ%"0RP0R0J"
M"2""K'<#U/H.*\GTK4KR_P!?U#Q+J%P]Q=64#WIE;[WG96.%@.F%E>([>FU2
M,'[I]$T/QAI/@G2-?L)9'EU'0[NZLM(64`EXY'R%(4KN`>+<[$#`(`/(6O,5
M_P!#\%M(GW]2OC"S#@K'`BL5)_B5FF0XX`,*GGC"0V8E%%%,D****`"BBB@`
MHHHH`V_%_P`_BS4;H?<O9?MT8/41S@3(#_M!7`/49S@GK6)6WK?^E:7HNI#Y
MFDMC:3R=,RPMM"X]H3;\@8/NVZL2@84444""BBB@`HHHH`****`"BBB@`HHH
MH`*V/#,,3ZW'<W,226MBK7DZ2*"CK&-PC;/`#L%CR<\N.#T./6W9_P"@^$]1
MNCP^H2I8Q`\AHT*S2D8Z,K"W'/!#M@'JH,QYII;F>2>>5Y9I&+O([%F9B<DD
MGJ2>],HHH$;:_P"A^"VD3[^I7QA9AP5C@16*D_Q*S3(<<`&%3SQC$K;\3_Z/
M?6VD_P#0+MEM'S]X2Y:292>AVRR2*".,*.O4XE`PHHHH$%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!4]K=S
MV4S2V[[':*2(G`/RNA1ASZJQ'XU!10!UGQ%#3>*_[5^Q)9PZM:6^H11HP(Q)
M$NX\8YWA\D@$G)[UG>)_]'OK;2?^@7;+:/G[PERTDRD]#MEDD4$<84=>I?H[
MKK.JZ1:W\2/8Z;!(TJ*2K26\;27$@SG[Q!<#&/X>1R:R+R[GU"^N+VZ?S+BX
ME:65\`;F8Y)P.!R>U`R"BBB@04444`%%%%`!1110!MK_`*1X'EW\?8=23RL=
M_/C;?GZ?9DQC'5LYR,8E;?A[]]#K5BO$MUILFPG[H\ITN&S]4A8#W(Z#)&)0
M,****!!1110`4444`%%%%`!1110`4444`%;>O_Z-:Z/IHX-O8I-*%^XTDQ,P
M;W;RWA4DC/R8Y"@U5T&PBU37["RN&=+:6=1<2(0#'%G,CY/`"J&8D\``D\"H
M-3OY=5U6\U&=46:[G>=U0$*&9BQQG/&30,JUJ>'+2"]UZV2[3S+.+=<W,8)!
M>&)3)(H(_B*(P'(Y(Y'6LNMO3O\`0_"^L7;_`/+YY5A$IXW?.LSN#WV^4BD#
MIYRDD<`@&7>7<^H7UQ>W3^9<7$K2RO@#<S').!P.3VJ"BB@04444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110!MZ=_H?A?6+M_^7SRK")3QN^=9G<'OM\I%('3SE)(X!Q*V];_`-%T
MO1=-'RM';&[GCZXEF;<&S[PBWX!P/9MU8E`PHHHH$%%%%`!1110`4444`:GA
MN[@L/$VF7-V^RS2Y3[22"0820)`0/O*4+`C!R"1@YJE>6D^GWUQ972>7<6\K
M12ID':RG!&1P>1VJ"MOQ;\_B2>Z/W[V*&^D`Z"2>))G`_P!D,Y`ZG&,D]:!F
M)1110(****`"BBB@`HHHH`****`"BBB@#;T;_0]'UC5?XUB6QA(Y*R3[MQ(Z
M;3"DZ]R"ZX'<8E;>I?Z#X=TO3QQ+<;K^X'W6^;Y(D<=\(AD4GM<'`P<MB4#"
MMO6_]%TO1=-'RM';&[GCZXEF;<&S[PBWX!P/9MU9VF6$NJZK9Z=`R+-=SI`C
M.2%#,P49QGC)]*GUZ_BU/7[^]MU=+:6=C;QN`#'%G$:8'`"J%4`<```<"@#.
MHHHH$%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`5:TRPEU75;/3H&19KN=($9R0H9F"C.,\9/I56MO0
M/]&M=8U(\&WL7AB+?<:28B$K[MY;S,`#GY,\A2*!E77K^+4]?O[VW5TMI9V-
MO&X`,<6<1I@<`*H50!P``!P*SJ**`"BBB@04444`%%%%`!1110`5MZK_`*1X
M;T"Z3A(HI[%@>ID24S$C_9VW"#UR&XZ$XE;=G_I/@_5+<?/+:W,%VJG_`)9Q
M$/'(PSTR[VX(')PIY"\`S$HHHH$%%%%`!1110`4444`%%%%`!4]G:3ZA?6]E
M:IYEQ<2K%$F0-S,<`9/`Y/>H*V_#?^CR:EJ8Y?3[%YHP.")'9848'^%D:42`
M]<H,8Z@&0>([N"]\17TMH^^R67RK0X(_<)\D0YYX15'//'/.:RZ**`-O0/\`
M1K76-2/!M[%X8BWW&DF(A*^[>6\S``Y^3/(4BL2MN\_T'PGIUJ.'U"5[Z4CD
M-&A:&('/1E87!XX(=<D]%Q*`"BBB@04444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!6W>?Z#X3TZU'#ZA
M*]]*1R&C0M#$#GHRL+@\<$.N2>BXE;?BS]SXBN-/7B+3<6"`<*?*^1G`_AWN
M&D(]7/).209B4444""BBB@`HHHH`****`"BBB@`K;\-?OIM3L6XBNM-N-Y'W
MAY2?:%Q]7A4'V)Z'!&)5W1M0_LC7-/U+RO-^QW,=QY>[;OV,&QG!QG'7%`RE
M15W6=/\`[(US4--\WS?L=S);^9MV[]C%<XR<9QTS5*@#1T30M3\1:B+#2;1[
MJY*E]BD`!1U))(`'09)ZD#J15&:&6VGD@GB>*:-BCQNI5E8'!!!Z$'M7H_P3
M^U?\)5JOV'R?MG]D3>1Y^?+\S?'MW8YVYQG'.*-<DC^(W@^]\4)8PP>(=*E5
M=02U5]L]N0=LFW!^9<$?>X5&).-H!?4+'FM%/$,K0/.(G,*,J-(%.U68$@$]
MB0K8'L?2F4""BBB@`HHHH`*VY_\`0?!]M;GB74KDW;*>?W40:.-ACIEWN`0>
M?D4\#[V)6WXJ_P!'UC^REX32HEL<#H)$SYQ!ZE6F,K#/.&'`Z`&8E%%;?A7_
M`$?6/[5;A-*B:^R>@D3'D@CJ5:8Q*<<X8\CJ``\6?N?$5QIZ\1:;BP0#A3Y7
MR,X'\.]PTA'JYY)R3B444`%%%%`@HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`-OPK_H^L?VJW":5$U]
MD]!(F/)!'4JTQB4XYPQY'48E;<'^@^#[FX'$NI7(M%8<_NH@LDBG/3+O;D$<
M_(PX'WL2@84444""BBB@`HHHH`****`"BBB@`HHHH`V_%'[[4+6_7YDO;&WF
M\T]99`@CF8]]QF27)/).3SG)Q*V[[_2_">DW75[26:Q<)T2/(FC+>C,TLX'8
MB/@?*QK$H&=%X$UR#PYXVTO5+H9MXI2LIR?D5U*%N`2=H;.`.<8KO?"]G_8O
MQPNM-%M9RZ7K,5QY86/=#):2*9D\OHI7Y0IX*\,!ZUY!7H?@WQQI4<FEV?C&
MVFO(-+E#Z9>([;[0[EX8!AO0;01U(VX`((`3!%[X9:8@\5>)?!>K3PFWNK:6
MVE1=I\R:)\!HRPSN4&1AQVR1QQY_KNBWGAW6[K2;]4%S;,%;8VY2"`00?0@@
M\X//(!XKLO#VJ06OQX-ZZ3&*;5[B)5,95P96=%RK8(P7&0>1SQGBJOQ4U2\O
M?%MS9ZG:HEY83RQ)<*_,ELS;X5*C@%58\CDA@#R,DZAT.&HKV7XCZ#_PE/@O
M2?'&GV\,EZULC:E]D7(8;!EC\Q_U;`J>I`/)PE>-4TP"BBB@1M^$_P!SXBM]
M0;B+3<W[D\*?*^=4)_AWN%C!]7'!.`<2MNV_T/P??W'W);^YCM(VZ^9$@\R9
M?;#FV.>#V'&ZL2@85MP?Z#X/N;@<2ZE<BT5AS^ZB"R2*<],N]N01S\C#@?>Q
M*V_$G^CR:;IAY?3[%(9">")'9IG4C^%D:4QD=<H<XZ``Q****!!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%:.A6$6I:W:VURSI:EC)=.A&Y($!>5AUY"*QQ@DXX!Z4#+7B3_1Y-
M-TP\OI]BD,A/!$CLTSJ1_"R-*8R.N4.<=!B5:U._EU75;S49U19KN=YW5`0H
M9F+'&<\9-5:`"BBB@045>CLO]$BF,$TQD+<1'[H''/RGWH^R_P#3A>?]]?\`
MV%8^WC?_`(;_`#-.1E&BKWV7_IPO/^^O_L*/LO\`TX7G_?7_`-A1[>/]-?YA
MR/\`JY1HJ]]E_P"G"\_[Z_\`L*/LO_3A>?\`?7_V%'MX_P!-?YAR/^KE&BKW
MV7_IPO/^^O\`["C[+_TX7G_?7_V%'MX_TU_F'(_ZN4:*O?9?^G"\_P"^O_L*
M/LO_`$X7G_?7_P!A1[>/]-?YAR/^KEW3/](\+Z[:?=\G[/?[NN=CF'9CW^T[
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
MPSRO-=>1.JHJ9E*X9O,R%$GR%MO7C&>*2V^'/AR72CHUK\0M*EFN[N.4[1&S
M.RJRQHBB7KF1\]<Y7&,'=TX=.%&,7NDOR)>YX[17<ZYX$T;1_#4NHP^-M*U"
M^B5";&U9&+,64,%8/D@9)SMZ#H*X:MA!1110(****`"BBB@`HHHH`****`"B
MBB@`HHHH`N::BFZ,CC*1(TC`=<`=O?FK^D.TFF^)7<Y9M/4D^_VJWJDG[G27
M?HTS[1G@X`ZC\R#]?SMZ+_R"?$?_`&#D_P#2JWKE?O2E+S2^Y_YFCT21C444
M5U&84444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!6IX<M(-1UZVL)TW_:]UM%DD!9G4I$
MQ(YVB0H3UX!X/0Y=;?@W_D>/#_\`V$K?_P!&+0,O:]I%]X3T--%U.#R-0O+D
M7<T)=7VQ1J5B8%21\S23@C)/R+T_BY:O4?CQ_P`CQ9?]@U/_`$9+7EU"!A11
M10(GLX?/O(8MNX,PW#..._Z47DWGW<DF[<"<!L8R!P#^E3V'[N&ZN>\:;1CJ
M"W`(_P`]S5&L8^]5;[:?J_T-'I!+N;-S_P`B5I?_`&$;S_T7;5C5LW/_`")6
ME_\`81O/_1=M6-5T_A^;_-D,****L04444`%%%%`!1110`5U_CK_`(EW]E>&
MQQ_9=O\`O4/.V9\%]I[HVU9!GD>80<8VK0\$64E[XPTWRV13!,L^Z0D)N4@H
MK-_"&?:F<'EQ@$X!SM:O8]1UN]NX%=;>69C`C``QQ9PB8'`"K@`#@`8%<,_W
MF,C'I!7^;T7X<WW_`'VM(^I8T?\`Y!?B#_L'I_Z4P5D5KZ/_`,@OQ!_V#T_]
M*8*R*WH_'4]?_;8B>R"MN\_TGP?I=P?GEM;F>T9A_P`LXB$DC4XZ9=[@@GDX
M8<A>,2MO2O\`2/#>OVK\)%%!?*1U,B2B$`_[.VX<^N0O/4'<1B5MZK_I'AO0
M+I.$BBGL6!ZF1)3,2/\`9VW"#UR&XZ$XE;=G_I/@_5+<?/+:W,%VJG_EG$0\
M<C#/3+O;@@<G"GD+P`;VBZG?VO@+7=2NKZY=95BTJT665G1UVONCVY.T*C[E
M/&#P#@LIS_!6C:I<:HFLVFFWEQ!IVZX62&!G4SQKNB0[1ELR&,$#G:2>`"PF
M\4_\2WPKX:T9>-UN=1D9.%F\X`J6']]<.F>?E`.>2HA\*^/M8\(1^7IR6<B>
M:TF+B#<1N4!E#`A@K;8R0#UC7W!X,#[ZG7_G;^Y>ZOOM?YERTLB/Q7K.J?V[
MKFE_VE>?V?\`VA/_`*)Y[>5_K6;[F<?>YZ=>:YJO6==^,&NV'BF_A33M*E^Q
MW3PPM-'*Q78SJ&`\S"L59@6`!(.#P`*B_P"%V^([>RADM]$TJ"%VD#OY$FR2
M7<7<KAQ@X=21DG)R3\P`Z</948);67Y$RW/*Z*Z+Q5XSU3Q?);-J`A1+;S#'
M'%N(!=MS'+LS<\`#.`%``%<[6P@HHHH$%%%%`!1110`4444`%%%%`!1110`4
M459L8O.O(U(4@')W=#Z`_4X'XU,Y*,7)]!I7=B74?W7DVO\`SQ7YAZ,>OX'K
M^/X"WHO_`""?$?\`V#D_]*K>LNYE\^ZEERQ#,2-W7':M31?^03XC_P"P<G_I
M5;UBHN-))[Z???4J3O)F-111700%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`5J>'+N
M#3O$5CJ%P^U+.7[4!@GS&C^=8^.FYE"[NV[/:LNB@9Z'\4]0_P"$D7P[XJBB
M\BWU"Q>%86;+I)%*P?M@KEQ@]3CD"O/*VY_])\%V4@^=[*^EAE8]8XY$1HE!
M/\)9+@X'`.XG&[G$H0!113XHS+*D:X#.P49]Z&TE=@6Y_P!SIEO#_%(QE8'J
M.!C'L0:HU;U*0/>LB9$<0$:`]@./YYJI65!/D3?77[RI_%;L;-S_`,B5I?\`
MV$;S_P!%VU8U=.EA#<>#=-6ZU.UT]OMMU+&+I)294*0+N78C<;D89..00,X.
M*/\`8NG_`/0T:3_WZN__`(Q2A4237F^C[L31C45L_P!BZ?\`]#1I/_?J[_\`
MC%']BZ?_`-#1I/\`WZN__C%7[6/G]S_R%8QJ*V?[%T__`*&C2?\`OU=__&*/
M[%T__H:-)_[]7?\`\8H]K'S^Y_Y!8QJ*V?[%T_\`Z&C2?^_5W_\`&*/[%T__
M`*&C2?\`OU=__&*/:Q\_N?\`D%C&HK9_L73_`/H:-)_[]7?_`,8H_L73_P#H
M:-)_[]7?_P`8H]K'S^Y_Y!8UO#G_`!+?!OB+5C^[EFC%C;LWW90W$T?U"NCC
MH?DXR`XKD*]"U_2[.Q\*Z)HW]O:=;;X_MTC-'<;;D."8Y,+$=I&Z1.<$JJ$]
M`J\M_8NG_P#0T:3_`-^KO_XQ7!@JBGSUM?>>FCV6B_*_SZ;*YK9#='_Y!?B#
M_L'I_P"E,%9%=CI.A6PT?7Y4U_3I(?L<<<DJPW6V,FXB(W$P]]I``R?;`)&/
M_8NG_P#0T:3_`-^KO_XQ6]&K'GJ;[]G_`"Q$UHC&K;\)?/XD@M1]^]BFL8R>
M@DGB>%"?]D,X)ZG&<`]*;_8NG_\`0T:3_P!^KO\`^,5/9V%OI]];WMKXKTF.
MXMY5EB?R;H[64Y!P8,'D=ZW]I'S^Y_Y$V.?KI_`EO#J6O2Z1=F46>H6LL=PT
M"EI0L8\\;``<G="HQ@Y!(`R00_7O#NE6VN72VVOZ7;6DC>?:Q.ETS+!(`\63
MY1YV,O<GUYK?^'UEIN@ZC>>)I]6TZ\@TN#@Q_:5\N60[4W9B!P1O7(#8SG%8
M8K$QIT92UOLM'N]%^+*C&[.3\9ZE_:_C+5KP-$Z-<-'&\1RK(GR*0<G.54'/
MO6%71ZGX8L=-U:\L'\4:7NMIWA.^&Y#95B.0(B`>.Q(]SUJ"+P_:3S)##XDT
MN261@J(D-V69CP``(.2:NC[.A2C35[126SZ"=V[D7BO_`)''7/\`L(3_`/HQ
MJD@_TGP7>QGYWLKZ*:)1UCCD1UE8@?PEDMQD\`[0,;N=/Q-I%C)XKUAW\1Z7
M$S7TQ,;QW.Y#O/!Q"1D>Q(I_A_2+)GU*S_X2+3)([O3YED$<=R&41CSP1F$#
M`:%<]3MW`#.*C#5$J$-]ET?8;6K..HK9_L73_P#H:-)_[]7?_P`8H_L73_\`
MH:-)_P"_5W_\8KH]K'S^Y_Y$V,:BMG^Q=/\`^AHTG_OU=_\`QBC^Q=/_`.AH
MTG_OU=__`!BCVL?/[G_D%C&HK9_L73_^AHTG_OU=_P#QBC^Q=/\`^AHTG_OU
M=_\`QBCVL?/[G_D%C&HK9_L73_\`H:-)_P"_5W_\8H_L73_^AHTG_OU=_P#Q
MBCVL?/[G_D%C&HK9_L73_P#H:-)_[]7?_P`8H_L73_\`H:-)_P"_5W_\8H]K
M'S^Y_P"06,:BMG^Q=/\`^AHTG_OU=_\`QBC^Q=/_`.AHTG_OU=__`!BCVL?/
M[G_D%C&HK9_L73_^AHTG_OU=_P#QBC^Q=/\`^AHTG_OU=_\`QBCVL?/[G_D%
MC&J]:?N;&ZG/!9?*3/0Y(W?CC'Z^E6_[%T__`*&C2?\`OU=__&*L/I=G]AB@
M?7M.MR&+'S([@B49^5QMB/!!/7!]1TK&M44K0UU?9]-2X*UV<]6SHO\`R"?$
M?_8.3_TJMZ/[%T__`*&C2?\`OU=__&*T;33;>R\/>(;B+6+*\5K2.';`DZD,
M;B)@,R1J,X1CC.>"<8!Q52HFDM=UT?=$I'*T445N2%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`;>E?Z1X;U^U?A(HH+Y2.ID240@'_9VW#GUR%YZ@XE;?A'Y_
M%%G:=/MV^PW?W//1H=^.^WS-V.,XQD9S6)0,*NZ:`LTD[@&.&-F((X;(P%_'
M-4JO#]QI#$_>N7P`?[J]Q^-8U]8<O?3_`#_"Y4-[]BDS%F+,26)R2>])16[X
M-TYM5\8Z7:K;I<_OQ*T#XQ*J`NR?-QE@I`S@9(R0.:UDU&+?8G=G0>)Y;'P[
M:Z+HEQH]G?W=K9YG-W),KP.S%FB(CD4'#[V#?Q(Z8R!N;G?[<T[_`*%31_\`
MO[=__'ZC\4:BNJ^)+VZCN'N80PAAGDSOECC41H[9Y+,J@D\<D\#I614TX\L4
M@;NS;_MS3O\`H5-'_P"_MW_\?H_MS3O^A4T?_O[=_P#Q^L2BK`V_[<T[_H5-
M'_[^W?\`\?H_MS3O^A4T?_O[=_\`Q^L2B@#;_MS3O^A4T?\`[^W?_P`?H_MS
M3O\`H5-'_P"_MW_\?K$HH`V_[<T[_H5-'_[^W?\`\?K2T"ZT[5]=L[$^$M,:
M.23,ODR79<1CYG*CSCDA0Q``).,`$\5R5=?X%_XEW]J^)#Q_9=O^Z<<[9GR$
MW#NC;6C..1Y@(QC<O+C:KI8>4H[[+U>B_%HJ"O(=XF\465WX@NS)H.D7HBD:
M);CS;@+)@G+J$F"@,Q9\`?Q<ECECD_VYIW_0J:/_`-_;O_X_6)4MK;O=W<-M
M&5#S2+&I;H"3CFM:5.-"DH+:*_(B<TKR9Z+:726W@&Z>#PM9&749HTDLXS=,
M)(@=T<I/FEAADD&`1]]">,;N>W2?]"%9_P#?-]_\>J]\2[A(M5M=&B#(EC'E
MHCTB=E52$QP$*QHX`YS(V<'($.B>%M-N%MVO;[S;B55E^S0GE5(W?/WP1CGC
MKC)R*\BABO98?ZU4=N=\UK-OLNO9+4X<9C)8:FIU7;RY6WY]>GR*^Z3_`*$*
MS_[YOO\`X]1ND_Z$*S_[YOO_`(]6%JOV4:K<K91JELLA6,*Y<$#C()ZYQG\:
MIUZL/:RBI72OY?\`!-H.M."E=*_E_P#;'?ZTTDD&D7;>";6:>XL%\W*WGR>6
M[PHH`E&,1Q1]>3G/>KEU,+/P-IT,'A2TEEO9YI9[5!=#R%4JH5@)=_S;$;E@
MOR#Y20&KE;>UFU;PG9VEHFZ>#5C%L)`WM<QH(P">.MN^<XQE>O.+7CRX@F\5
M+IMO,IM-+@BTZ*5U.<1C#%^.2&+#(';@>O'B%.=>G2NM+R>G;1=>[NO3KJ;6
MJJ+?,ON?^9J>(6DDOH+P>";6X%W:PS&9EO-SR;`LN[$HY\Q9!DC+8W$MNW&3
MPI&DWB.U:X\)V.FQQ-YBW;+=_NI!_JVVM-A@'*9'IDG`!(@U!-!3PYI#PV\N
MLS0$V)\N1D"`DS+D+R&9I9``>HC(ZJV='^QK?0=$U":T6>&;4C':0>;@HK2!
MT>)F4Y(V2%P.1NA4DGY0>;&XV7L_9[.>BNN^C>]U:]]5]YP0QS=6,):73:;C
MO97?VKKYI&)J%]-?ZE=7C>`K;=<3/*=XO"V6)/)$H&>>P`]A4FC7QT_7-/O9
M/`L,:6]S'*SP1WAD4*P)*AIMI;CC/&>M6CX4LK&:SM1ILNH^<-T]RTYC6'D`
MC`QG^]CT/4\XYO6=#BLO$$.F6=QYGG;`/,(RC,<88C\#TZ$5MAL?"H_9P:2M
M=:=%Z2;7SL8X?-(UY\L9+:^W1>DFU\TBSJ5[9Z7J=U83^%M$:2WE:,O'->%7
MP?O*3.,J>H/<$55_MS3O^A4T?_O[=_\`Q^I?&3176NKJ=OYIMM1MX[F-Y7+,
M[;=DA.22,2I(,=../EQ7/UZD&W%.6YZL')Q3EN;?]N:=_P!"IH__`']N_P#X
M_1_;FG?]"IH__?V[_P#C]8E%46;?]N:=_P!"IH__`']N_P#X_1_;FG?]"IH_
M_?V[_P#C]8E%`&W_`&YIW_0J:/\`]_;O_P"/T?VYIW_0J:/_`-_;O_X_6)10
M!M_VYIW_`$*FC_\`?V[_`/C]']N:=_T*FC_]_;O_`./UB44`;?\`;FG?]"IH
M_P#W]N__`(_1_;FG?]"IH_\`W]N__C]8E%`&W_;FG?\`0J:/_P!_;O\`^/T?
MVYIW_0J:/_W]N_\`X_6)10!T%MJ^G3W447_"*:20S`';+=YQW_Y;TQ];LD8Q
MRZ!I=VR$CSY)+@%^3SA)54?@/S/)H:=^Z\ZZ_P">*_*?1CT_`]/Q_$4:Q7O5
M6^VGWZ_Y%O2'J;?]N:=_T*FC_P#?V[_^/UT5S+8K\+[FX31[.SGO;R(!+>28
M_(#)Y<N7D8=8KE"O?(;C`W<%7:?$'_B72:5X<'#:;;*9X^R3LB*^S'&QA&DH
M[YE8M@DJM35Y*/S^[_@DHXNBBBM"0HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M!\,TMM/'/!*\4T;!TD1BK*P.001T(/>M7Q5#%#XIU(VT21VLT[7%JJ*%7R)/
MWD1`_A!1E..",X('2L>MO7_])M='U(<FXL4AE*_<62$F$+[-Y:0L03GY\\!@
M*!F)5[4_W<L5MT\F)58#INZDCZYIFF1A]0B+9"(=[-Z8YY]LXJO+(997D;`9
MV+''O6+]ZLEV7Y_\,R]H>HRNT\&?\2[0/$6MGAHK;R(\_>.[H\?^W',;5LY^
M4-GJ5KBZ[3Q!_P`2GX?:'HZ_*]W*=0N$;^(F,&.1.^TI-L/;="0.C%JJ:M1_
MK0A'%T445H(****`"BBB@`HHHH`*Z^^_XEGPTT^T;_7ZA>/<9'#(@5=T;CKA
M@+>0?WL@X&U2W+6EK-?7D%I;)OGGD6*-<@;F8X`R>!R:Z/X@74,OB;[):/OL
M["WCM;;((94`W;&SSE2Y3!&X;0&RV2>'$_O,12I=KR?RT7XO\&7'2+9RU==\
M.;*2X\3BXB9$DM8F>&24D1"8_+&KGT+,!@<GM7(UWNB?\23X;:IJ(^6?4E>"
M-^J.F5C:-L]&Q(SKMY_=DDX!!C-9M8=TX[S:BOGO^%S&:O:/=_AN_P`%8Y'6
MKV/4=;O;N!76WEF8P(P`,<6<(F!P`JX``X`&!6YX48:;I6K:RZ*#%&(H7;)!
M;KM('J2G^/6IIM+L;I=%T^TMDM_MC--(SN&F\L#@YYQN7)QC&?H:O7.DZ5J0
MM;5+-[)FN3%$?*\J1HU3<Q(.2X.,;C@@D>^[CQ&+HSHQH--1Z]?=B_7K9]]#
MP\;F%*O3]G--*6K]$]>O6S[Z7W.`JYI]Q8V\CM>V+7@(PJ^<8POOP,FNM%A:
MZI:;[O2HK2[B,EQ'9P(4DEA48"MCD9;`SC)P<#FLG6G@?1+=I[2SM-2,Y_<6
M\9C98\?QKV).",]B,=ZZXXV-=^RY7J[.SV]&G>VFK1U1Q\<0U2<7J[.SV]&G
M>VFK1UGPYU31/M^JR'1/+BL[![\J9C-\T+*0RJW`<`OAN",D9Y-<;H>B7?B.
M_DGGDD\G>6GN'.6=CR0">K'N>V<GL#WW@RRCTC0_LD]G>)_;[QV-VQ=3Y2OF
M/*C`P?WN>=V,C(X-><^'[:VO-7AM[BW>X\QMHC#[!C!W,3UX`S@=?7L>6E.,
MHUZU%M6]U._-HM6]7O=OK:R3*EB(/"3^K3?NWNW>5GUM=ZZ;:VZ['I=GH\^G
M^']2LM#CMH&VQ7#7$[,S.RGR\$8P.)=P/(R"-O.14N9]."Z9I^L3Q331P/.)
M977RI<L5(?.`S)+]H"#&%1O7-5_!^FQ7_B:\F;3K=K"X>6V4!\1S+L9454`V
MG,@C;<V5!`(&1D5]75KG4=2U)-+:_P!2:Z2R*W($B`*BC?@<8(`^8GT.>2*\
MR<.:<8SE=I:O1._F[O;FU[6VUT\>$^2G*G*;<I*S>B:=T]9<S[VMY/R+.[5[
M6V^T:I>16D=O>%Y)UPT<\;HI\I0>05\DX&,G>Y'0[N+ENK>XOM3U&UMUMH5A
M*0QX`7+@1XP.,E2[8'<=P#776VG:?#)?3:<D+I?P2[))LBTB$3([+)_LML<J
M?[P0#C)KEO$GV."5HM/V?9[B4S_N_ND#Y!CZ,)>G&&'MCT,$XRFK+5JVUEH]
M4UKKNM>SM9'1@7"<U9:R5M$HJR>J:NW?=:]G:R(]1_TCPGHET_#Q2W-BH'0Q
MH4F!/^UNN''I@+QU)Q*V]._TCPGK=JG#Q2VU\Q/0QH7A('^UNN$/I@-ST!Q*
M]\^D"BBB@04444`%%%%`!1110`4444`%%%.1&DD5$&68@`>]#=M6,N/^YTE$
MZ-,^XXX.`.A_,$?7\Z-7-2=3="-#E(D6-2>N`._OS5.L:"]SF?74J>]NQT?@
M2PEU#QC8+"R))"_G1R2DB-95&8MY'13+Y:G')W8')%9NNW\6I:W=7-LKI:EA
M':HX&Y($`2)3UY"*HSDDXY)ZUT?A?_B4>#M=UIN#<Q2:?'Z.&0*\9)X#9FCE
M7`)(MY!\HR:XNJCK)R^7W$O8****T$%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%;?_'SX'_N_8-2^OF?:(_TV_9??._MCG$K;T+_`$C3]<L/OO+8^=#$>ADB
M=)&8=@RPB?GK@L!][!!E&W)ATZYFP0TA$*M]>6'Y8JE5Z]_=6EI;CH4\UB.,
MEO4>W3-4:QHZIS[O_@%3TLNQ=TFP_M35K6R,ODI-(%DFVY$2?Q.>G"KECR!@
M'D5L>.]2;4/%,\8MFM(K)1:):,P86Y3.^-6'51(9-OHN````HN?#Z&*WOM0U
MZ[B22UTRT=BDJ@Q2NZL!"_H'02*">-Q4?-D*W(S32W,\D\\KRS2,7>1V+,S$
MY))/4D]ZI:U&^VG]?@+H,HHHK0D****`"BBB@`HHHH`ZGP%:PR:[/?7*>9!I
MMG+>21@E695PIVL.5=0VY3Q\RCE<[ASEW=37UY/=W+[YYY&ED?`&YF.2<#CJ
M:ZFS_P")3\.+ZX'_`!\:C<1Q@=XX_P!X%D5ATSLN8V7J0>P^_P`A7#AOWF(J
MU>UHKY:O\7^'H7+1)!7<^);S^R?#VBZ+);PS;H%N)HV+*BL-R@;5(*RJQF5\
MYSM4G'W5Y?0--_M?7;.Q*RM'))F7R1EQ&/F<J,')"AB``2<8`)XJYXQU+^U/
M%5],K1-&DAB0P']TV#\SH,G`=MSXR>7/)/)G$15;%4Z;VBG)_DOU^XB5.,HW
M?YM?D4Y-52;9YNG6TFQ0B;I)CM4=`/WG`]J)M52XE:6?3K:61NKO),Q/XF2L
MZBNI8>"VO][_`,S!8:FMK_>_\S1_M5//\_\`LZV\[=O\SS)MV[.<Y\S.<]Z/
M[53S_/\`[.MO.W;_`#/,FW;LYSGS,YSWK.KH/`^F1ZQXUTJRFV>4TWF.KIO5
MU0%RI![';C\>]95XTJ-*565[13>[V6O<:PL&[:]MW_F;?B[6)]*>S\/&W8"T
MM5-U%+,^!/,!)*`R/\Z_,/O$\Y[5G^)=36#Q3<7T5A;K+=A+X.))E9//C64K
MD.,X\S;D`9QG`SBL/6M3DUK6[W4I=X:YF:0*SERBD\+GN`,`>PJYK/\`I&BZ
M#>K\_P#HSVDTI^\98Y&.T]SMBD@`/3&`/NX&>$P<:=",)K5KWM7N]^O>XY8:
MEJE>S\WZ=^QTGA+5I+#2-1UGR$CBTX(UO`LLN'DW@@@,Y!"R&(.!@[9>O.UL
M+Q!-;Z;XAU.TAL(9(//<1RR2S$SQ%MR.2'PP8;6!Z'(([5=U7_B3^`-*TW[M
MS?R->3`\.B$+M&?XHW7R6]FB;))&$R_$?[[^R;_I]KTV'Y/[GDYMNO?/D;O;
M=CG&3G@Z49N=76SD[:O9:7^;3=_NT!X6E'9?B_\`,M^&=8ABUVUM7@MK.SO)
M1;7<@FD4"&3*.3N<KPCMR1QUK#U%YVO'CN+?[,\'[DV^UE\K;P5PW(.<DY[D
MU5K;\6_/XDGNC]^]BAOI`.@DGB29P/\`9#.0.IQC)/6N^-*$976_JQPHPB^9
M;^K?YAX5_>ZT;+[WVZVGM$B/W997C80J>W^M\L@G@$`\8R,2K6F7\NE:K9ZC
M`J--:3I.BN"5+*P89QCC(J?7["+2O$>J:=`SM#:7<L",Y!8JKE1G&.<#TK0U
M,ZBBB@04444`%%%%`!1110`4444`%7--13=&1QE(D:1@.N`.WOS5.KR?N=)=
M^C3/M&>#@#J/S(/U_/&N_<Y5UT+AO?L4W=I)&=SEF))/O3:*T-$L8M1UFVMK
MAG6U+;[ET(W)"@+2,.O(16.,'IP#TK5M1C?HB=SI/%/_`!*?!^A:$O[N5BUW
M=(/^6C8PK,/X71VN(2/O'RANX"`<772>/KZ6]\;:H)513;3-;;8P0FY"0[*O
M.T.^]\9/+G))R3S=*FFHI/<'N%%%%4(****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBG
MPPRW,\<$$3RS2,$2-%+,S$X``'4D]J``0RM`\XB<PHRHT@4[59@2`3V)"M@>
MQ]*97M/A_P"#EY+HE_IVJ:B]I/.L,QB^R[TBD!)5UD#@.0K2H5XP6S@C8S>=
M^+/!&K>$IV:ZA>33VG>&"\"%5D*GNIY4\'&>#@E2PYHN.QS5%%6K#3+_`%6=
MH-.L;F\F5=YCMXFD8+D#.%!XR1S[T"*M%7=0T;5-(\O^TM-O++S<^7]I@:/?
MC&<;@,XR/SJE0,****!!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M6UX19?\`A+--CE95MYIA!<EV"CR)/DE!)Z`QLPSP1U!!K%J]I_[I+B[[PIA<
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
M1;R#Y1DUV5&G"RZ_J<UFGJ<YKM_%J6MW5S;*Z6I81VJ.!N2!`$B4]>0BJ,Y)
M..2>M9U%%:""BBB@04444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`5/:7EUI
M]TEU97,UM<)G9+#(4=<C!P1R."1^-044`;'BC4EUCQ#<:D+AYVNECFE9L_+(
MT:ET7/.U6W*HY^51R>M8]%%`PHHHH$%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110!]`?!B[@O?`.HZ7IS_8M4AE<R3X,GS2+B.7:WR\;<;<_\L\G
M[U>0^*]*\46=]+)XB34I_)E-JE[="5HY,%L!'<<J<,1[9-96CG4?[8M$TB::
M+4)91%;M#+Y;[G^4`-D8SG'7O7T1I6E?%!+%;V\\2::][P5TZXM%,1!`X>2,
M!@PR>%R,J.2#2V*W/!?#W_"4?Z3_`,(U_;'\/VC^S?-]]N[9_P`"QGWKVGXN
M0Q7/PPL;W7(DM]91H?+2)00)V7][&#\V%P'/7!*+R>,\GXL^(_Q)TBZAM]0M
M8=%<9P8;8.DW"GAG+JV,C[IXS@^T?AO0]6^+EI>SZIXQN5FMIT+V;6Y>-05P
MCA0RH"<..!G@D_>H\P\CRNMO4_\`2/"^A7?W?)^T6&WKG8XFWY]_M.W'^QG/
M.!CS0RVT\D$\3Q31L4>-U*LK`X((/0@]JV-._P!(\)ZW:IP\4MM?,3T,:%X2
M!_M;KA#Z8#<]`6(Q****!!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`'4^
M!]=T'0]4:3Q!HW]IVK8*C;&_ED*PSM8?-G=C&X#N0Q"XW?$OBKPYJ1NEL/#E
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
M*.LG+Y?<#V"BBBM!!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110!<M28;2
MZGZ;E\E05."6Z\^P%4ZN7/[JQM8<,K,#*PSP<G`/Y"J=94M;S[O\M/\`@EST
MLBSIUC+J>J6FGP,BRW4R0H7)"AF8*,X[9-=%\1;Z*Y\8W-G:JZ66EJNG6T3@
M9C2(;2,\DC?O())."/H)OAU#%#J]_K=W$DECI-A-/+',H\N<LAC6%F/`+[B!
MD'.,8-<C--+<SR3SRO+-(Q=Y'8LS,3DDD]23WIK6;?;^O\B>@RBBBM!!1110
M`5MZ%_I&GZY8??>6Q\Z&(]#)$Z2,P[!EA$_/7!8#[V#B5L>%IHHO$MDEQ*D5
MM<L;2XE=@HCBF4Q2-D\`A78@G@$#.1Q0,QZ*?-#+;3R03Q/%-&Q1XW4JRL#@
M@@]"#VIE`CIO`UE'<ZW-<S,ZPV-J]Q*R'#HF0C2*><-&',@P"<Q@#DBL+4+V
M34M2NK^9466YF>9P@(4,Q).,]N:Z:Q_XE7P[U"<\2ZC(B)C[R#+*C*>P94O$
M;G)^48PQ)Y"N'#?O,14JOI[J^6K_`!?X%RT205U_B/\`XE/@WP[HB</<QG5;
MG;RKF3Y8CD\@A`00,#Z]:Y_1=,DUK6[+38MX:YF6,LJ%RBD\MCN`,D^PK1\;
MZG'JWC#4KBWV"V69HX1&X9"H)RRD<89MS\=W)YSDE;]YBJ=/I&\G^2_-OY>@
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
M2YM-U+5?/LYMOF1_9XESA@PY50>H'>J,_P#I/@NRD'SO97TL,K'K''(B-$H)
M_A+)<'`X!W$XW<]+JWPC\36T'VNPTNYDAVL\EO))"TT6!G`V.?,&#@$`,Q4_
M(O&<AM(OM)T_Q+H>JP?9[BSBM[YD#JQ$@=8U!()!4I=,>.<A>>"#6A)RU6;'
M3[O4IVALX'E95WN1PL:`@%W8\*HR,L2`.YK0_L>#3?FUV6:VF'/]GQQG[0?3
M=N^6('!Y.6&5.QE(-:5\GD0+;ZX[Z7;(WF)H-FCB3=@X=Q(2$+#<-[EW`*X0
MIMK/G<O@^_\`K<+%>PL[=)VM]+LTUJ^C7S'NF#"U@7(^?8P7A3M)>7"<D%"`
M&*7.J6EG=M<M+_;NK$AC?W+R-"I`^7:CA6=EPO,GR]5*,`&.=?ZS<7L"VD:)
M::>C;TLK=G$*O@_/AF)9N3\S$G'`.``,ZJ4$M6%PHHHJA!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`5;;$.F(H(W3N6.&_A7@`CZY_*JJ@LP502Q.``
M.M6=0*BY$*;2L*B,$+C)'4_GFLIZRC'Y_=_P;%QT395KJOAQ817WCO36N6>.
MUM'-Y/,I`6)8@7#.QX5=P4$GUZBN5KM-`_XDWPZ\0ZX.+B_D31[=TY*!AOF#
M`\;60``\D'ICK3JZQY>^A*W.5U._EU75;S49U19KN=YW5`0H9F+'&<\9-5:*
M*T$%%%%`!1110`4444`;<'^D^"[V,_.]E?131*.L<<B.LK$#^$LEN,G@':!C
M=SJ>&?\`B5^%=:UMODD.VVMF/_+1L?,JG^%T9H)0?O'RCMX#$<O!=SVT-S%"
M^U+J(13#`.Y0ZOCV^9%/'I74>(_^)7X2T72!P;B-+Y_1P5+)(`.`<RR1G.21
M`AX&!7#CO?Y*'\S5_1:O\K?/3NKAIJ<A3XHI)YDAAC>261@J(BDLS'@``=2:
M974_#^UAD\3?VA=)YEKI-O)J,R`D,PC&5V^I#%3@D#@Y]*Z,36]A1E5WLOO\
MOF**N[#_`(B2QCQ2--MY$DMM*M8;"%PP+%47)W$<;@S,#@#IC%<G4UW=37UY
M/=W+[YYY&ED?`&YF.2<#CJ:AI82BZ%"%)ZM)?-]7\V$G=W"BBBMR2SI]E)J6
MI6MA"R++<S)"A<D*&8@#..W-:GC"_AOO$UT+0_Z#:[;2T43&51%&-B[6/8X+
M?\"/)ZFSX+5;2_O-=E5#%I%J]PGFP&2-IS\D*G'0EV!!_P!D],9',UR1_>8I
MO^16^;U?W)+[R]H^H5U]O_Q+/A9>R_=FUC4$@V2\;H81OWQCOASM)Y';@UR%
M=CXZ1K*[TOPQ$,+I-FJ2J.4,\@\R5U8\[3E>N,8/`%9XQ\]2E1[OF?I'7_TK
ME".S9QU2I`Q02/\`)%_>/?Z#O_G.*ECB1<D%7=?O,Q`C0_\`LWT'IW%(\X1R
M8SND[RD#_P`=&/E_GP.G2NIS<G:']?U_2#E2U8_*11\C8C#C`!D<>_\`=!_D
M?XJKR2EEV*H2,'A1_4]S_CQBF,Q9BS$EB<DGO24XTTM7N)R[!1116A(4444`
M7+'4KFP\Q(VWV\V!/;.28I@,X#J#SC)P>H/((.#71^18>*^89)4O_P"!/*\V
MX?U,FQ5$PR0QD4&49?*.`&'(45S5L,IOG@^67<I2MHRS>V-QI\PBN%0%EW(T
M<BR(Z\C*LI*L,@C@GD$=0:V/#NNC2-;TW5IB9VMIXUN%DMTE/D*R$;"^<,`I
M4$;=H"@'DXELO$:WD)M-99'C9MX,D1:*1S@;IE0JV[.#YRYDQN!WAL!)]#>U
MF9K-[J2S>/=>1Q;)GCASDL"C;)HU*_?!`#IA@AVYQ^L2BU&LK27W/^OSL:T[
M7MT>G]>FYJ3?&#QO+/)(FK)"KL6$:6L15`3T&Y2<#W)/O4^F?&#Q;%JMG)J.
MK/-8I.C7$:6L(9XPPW`?*.2,]Q]:X1+>:6Y6VBC:69W"(D:EBY/0`=\]JV(=
M/L;*>."X1]4U)V"QV5G(KQ;B?E#2H3O).,HF.&'SJP*CL<HK8SE&46T^AV<O
MC3XDP7][;S:Y#%!97,EM/>R6\*0!T.&"L8\L<<A%!<CHIK0\-7;^+==\^TM+
MD:I<++;R>)9U$/FDPE=JQ@E8Y$0AAY;%F$7.U7=EYOQA]A@U.TU'59?[3NKN
MRAFCM[65!;!]N)2TB$YS.LQ9(PN=Q(D!)%2?#+4;G4OBOHLMRR$JLR(D<2QH
MB^3(<*B@*HR2<`#))/4FIY')>]]W];BN4O$UM%X"UN31-,9)[^W53/J4L`$@
M9AN`B!9@@"E"'`$@8-A@.*XRO2OBCK3I\1M5L=0A^WZ>GD^7!+(P,&84+-"P
M/R,<GC!4G!96P,<3=Z0@M7OM,N?MEBF-[,%CFBYQ^\B#,57)&'!*_,HR&)4:
MH3,NBBB@04444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`%S2XC-J$8
M".^P-*0G7"*6)^@`R?;-/:SB9BS7)+$Y))CY_P#'Z70[Z+3==L;R=7>WBF4S
MQH`3)%G#I@\$,NY2#P02#Q4&HV,NF:I=Z?.R-+:S/"Y0DJ65BIQGMD5A*,G4
MT=M/\S127+9HE^Q0_P#/Q^L?_P`773^(1]C\.Z/X9?\`T>6SWW-VH_=L\LF"
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
M,$$'AE()!!!!!(((-:GV?3M:YLO)TV_/_+I))LMG`[I+(^4;'.US@X8A\E4H
M`Q**?-#+;3R03Q/%-&Q1XW4JRL#@@@]"#VIE`@J[I^J3Z=YB(D,UO-CSK>XC
M#QR8SVZJV"P#J0P#'!&:I44#-B;3K.^@DNM'D<>6I>2PG??.BJ/F=6"JLB@<
MG&&`W97:I<X]/AFEMIXYX)7BFC8.DB,596!R"".A![UL?;K'6N-5/V6^//\`
M:,:,_G,>/WZ[OH3(@W<,2LC-D`&)15J_TZYTV=8KE4!9=Z/'*LB.N2,JZDJP
MR",@G!!'4&JM`@HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`K;\3?N+JQTT=-/L8H2#]]9&!FE5O1EDED7&`1M`/(),'ART@O=>MDNT\RS
MBW7-S&"07AB4R2*"/XBB,!R.2.1UJE>7<^H7UQ>W3^9<7$K2RO@#<S').!P.
M3VH&05/:VD][,T5NF]UBDE(R!\J(78\^BJ3^%05MV/\`HGA/5KKH]W+#8H'Z
M/'DS2%?5E:*`'L!)R/F4T`8E%%%`@HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"O2O!?AJ?4/A;XNU!=2\JW>(J]MY`;<T&
MR=6W9R."RX_VL\X`KS6GQ32P.7AE>-BK(61B"58%6''8@D$=P30,91110(**
M**`-B'5K>[@CM-:A>:.-0D-U`$6>(`8&XD?O5`QA&(("J%9!G,%_HUQ90+=Q
MNEWI[ML2]MU<PL^#\F64%6X/RL`<<@8()SJM6%_+I\[21JDD<B^7-#("4F0D
M$JP&.,@'((((!!!`(!E6BMO^S;76?GT8^7>'E].D8+R>T#,V9>>B'Y_F4#S,
M,U8E`!1110(T;#5FM8&L[F%+K3Y&W/`X&Y20`6C<@F-N%Y'!VJ&#`;:GFT9;
MJ"2\T5WNX$4R36VTM/:(!R9,*`RC!^=>,8+!"P6L>GPS2VT\<\$KQ31L'21&
M*LK`Y!!'0@]Z!C**V]VG:WPRPZ;J1X4QKMMKACSE\MB%B<C*CR^5&(PI8Y=W
M:3V%T]M<ILE3&0"""",@@CAE(((()!!!!(-`$%%%%`@HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`V]-_T'P[JFH'B6XVV%N?NM\WSRNA[X1!&P':X&3@
MX;$K;UG_`$/1]'TK^-8FOI@>2LD^W:`>FTPI`W<@NV3V&)0,*V]=_P!#L=)T
ME>/)MA=S8Y5I9P)-P/7_`%7D*1P`4..N31T?3_[5UBTL3+Y*32A9)BN1#'U>
M0\CY57+'D``')%&L:A_:NL7=\(O)2:4M'"&R(8^B1C@?*JX4<```8`H`I444
M4""BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"MO^TK76?DUD>7>'A-1C4+R>\ZJN9>>KCY_F8G
MS,*M8E%`R[J&E76F^6\J;[6?)M[J,$Q3@8R48@9QD9'!4\,`015*KNGZF]AY
MD;00W5K+CS;6XW>6Y&=I^4A@PR<%2#@D9PS`VYM)M[N"2[T69YHXU+S6LY19
MX@!D[0#^]4#.74`@*Q94&,@&/1110(*U+35T%JECJ=M]LL4SL52L<T7.?W<I
M5BJY)RA!7YF.`Q##+HH&:EWHKI:O?:?-]OT],>9/%&P,&3A5F4CY&.1SDJ3D
M*S8.,NI[2[GL+I+FV?9*F<$@$$$8((/#*02"""""000:U/L^G:US9>3IM^?^
M72239;.!W261\HV.=KG!PQ#Y*I0!B44^:&6VGD@GB>*:-BCQNI5E8'!!!Z$'
MM3*!!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%6M,L)=5U6STZ!D6:[G2!&<D*&9@H
MSC/&3Z55K;\/?Z-'JFIO]RVL985!X$DDZF$*#_>"N\F.21$W3D@&5=>OXM3U
M^_O;=72VEG8V\;@`QQ9Q&F!P`JA5`'```'`K.HHH`V]"_P!#L=6U9N/)MC:0
MYY5I9P8]I'7_`%7GL#P`4&>N#B5MWW^B>$])M>CW<LU\Y3H\>1#&&]65HIR.
MP$G!^9A6)0`4444""BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`I\,TMM/'/!*\4T;!TD
M1BK*P.001T(/>F44`;?VC3M:XO?)TV_/_+W''LMG`[/%&F4;'&Y!@X4%,EGK
M.O\`3;S2YUAO;=X6==\9/*R(20'1APRG!PRD@]C56M&PU1;>!K.\M4O;%FW^
M4[E6B8@`O&P^ZV!CD,IPNY6VK@&9U%:EWI""U>^TRY^V6*8WLP6.:+G'[R(,
MQ5<D8<$K\RC(8E1ET`%%%%`C8AU:WNX([36H7FCC4)#=0!%GB`&!N)'[U0,8
M1B"`JA609S!?Z-<64"W<;I=Z>[;$O;=7,+/@_)EE!5N#\K`''(&""<ZK5A?R
MZ?.TD:I)'(OES0R`E)D)!*L!CC(!R"""`000"`95HK;_`+-M=9^?1CY=X>7T
MZ1@O)[0,S9EYZ(?G^90/,PS5B4`%%%%`@HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`K;N?]#\'V%O
M]R6_N9+N1>OF1(/+A;VP_P!I&.#W/&VL2MOQ9^Y\17&GKQ%IN+!`.%/E?(S@
M?P[W#2$>KGDG)(,Q*?##+<SQP01/+-(P1(T4LS,3@``=23VIE;?AC_1[ZYU;
M_H%VS7:8^\)<K'"P'0[99(V(/&%/7H0!GBF:*7Q+>I;RI+;6S"TMY48,)(H5
M$4;9'!)5%)(X))Q@<5CT44`%%%%`@HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@">TO+K3[I+JRN9K:X3.R6&0HZY&#@CD<$C\:U-NG:WRK0Z;J1Y82-MMK
MACQA,+B%B<'#'R^6.8PH4XE%`R>[L[K3[I[6]MIK:X3&^*:,HZY&1D'D<$'\
M:@K4M-3@>U2PU2#SK5<K%.N?.M03D^7R`R[N2C<<MM*%BU,O]):U@6\MIDNM
M/D;:DZ$;E)!(61`28VX;@\':Q4L!NH`SJ***!!6W_:<&M?)KDLQO3\L>ILY9
MAZ"88+2*.@8'<H)^^%5!B44#-&ZT2_MI[>-8'N([MMMG-`C,EUR!^[./F.2`
M5QN!."`<BK7B;1WT>ZL0]E-9?:;&*4V\ZLLBL`8Y"P;D;I(W8?[++TZ!_A/Q
M7>>$]56Z@1+BV=D-Q:2\I,%;<I]F4C*MU4^V0?H[Q7X;TSX@^$D,81Y)(/M&
MG71RA1F7*D\9"MQN&.G;(!";L"1\IT444Q!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`;?A7_1]8_M5N$TJ
M)K[)Z"1,>2".I5IC$IQSACR.HQ*VX/\`0?!]S<#B74KD6BL.?W406213GIEW
MMR".?D8<#[V)0,*VV_T/P6L;_?U*^$RJ>"L<",H8#^)6:9QG@`PL.><8E;?B
MG]QJD6FCY5TVVBM#'U\N4+NG7/?]\TO.2.>/EQ0!B4444""BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`*M6&I7FF3M-97#PLZ[)`.5D0D$H
MZGAE.!E6!![BJM%`&W]AL=:YTH?9;X\?V=([/YS'G]PVWZ@1N=W"@-(S8&/-
M#+;3R03Q/%-&Q1XW4JRL#@@@]"#VIE;$.HV=]!':ZQ&X\M0D=_`F^=%4?*C*
M659%`X&<,!MPVU0A!F/15W4-+GT[RW=X9K>;/DW%O('CDQCOU5L%248!@&&0
M,U2H`*]#\!>/];\.>']:MK=H;BWL[9;FWBN59EC8SQ1L!@@[2)"<9ZC/<Y\\
MK;\)?/XD@M1]^]BFL8R>@DGB>%"?]D,X)ZG&<`]*&!T7@C14^(_B866KS>5]
MGMI)Y;FWC5)KCE%`=L8+;F+%RI9LD$GC;!XP^&NH^%K&/5;>ZAU31Y=NR\MQ
M]T,!M+#D!23@$$@\<@D"L[P#XB7POXSL-2F=UM=QBN=K$#RV&"2`#N"G#8QR
M5'UKJ=2?5OAGXEGET^)[WPA?-OCA<E[.YAE7.S.6&X*,!CR0H)!4X*Z@>8T5
MU_C/PS8V-K8>(M`::30-5W&%94;?;2`X:)CT/(;!R2=K=<;CR%,`HHHH$%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`445HZ%81
M:EK=K;7+.EJ6,ETZ$;D@0%Y6'7D(K'&"3C@'I0,M>(O]$_L_2%X^PVR^<!QF
M>3]Y)N7LZ[EB;//[D9QC`Q*M:G?RZKJMYJ,ZHLUW.\[J@(4,S%CC.>,FJM`&
MQX7ABE\0V\D\230VJR7CPNH*S+#&TIC.>S!-N<'&<X/2LJ::6YGDGGE>6:1B
M[R.Q9F8G)))ZDGO6Q9_Z#X3U&Z/#ZA*EC$#R&C0K-*1CHRL+<<\$.V`>JXE`
M!1110(****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`+NGZK=:;YB1/OM9\"XM9"3%.!G`=01G&3@\%3RI!`-7O['@U;Y]`\Z28]
M=,D)DN1CJR%4"R+T.``P^;Y=JESB44#"I[.[GT^^M[VU?R[BWE66)\`[64Y!
MP>#R.]:GV^UUOY=9E^SW@^Y?QP`^83VG"X+<_,90&?[V1)E=N=?Z=<Z;.L5R
MJ`LN]'CE61'7)&5=2589!&03@@CJ#0!:\1VD%EXBOHK1-EDTOFV@R3^X?YXC
MSSRC*>>>>><U]%Z3X$;0-`ET22X?7-$F@(GL+E0KB3!8M"V0%#-MPA(VD[@X
M(.[Y[\0_OH=%OFXENM-CW@?='E.]NN/JD*D^Y/08`ZRQU+5M:\-:9J/A^XN1
MXFT-1930VN3)/9;@T3;!@,J-A"H#9R"W&*3&CI?%$/@O2_A7K6F:)J$,DLE\
M+F.SNI`+B"42(C*L;@2+A58<C=C.20:\3KT[4KK3/BI:3W4-LFG>+K6#>88\
MLFI(BY8(`,^8,'"\G&!E@,IYC30F%%%%`@HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"MO2/]%T'7-0/!,4=C$R_?225MQ.>RF.
M&9#CD[\8()QB5MZK_HGAW1=/;F5O.OW!X:/S=J*A'ND*R`]Q*.,8)!F)115W
M1]/_`+5UBTL3+Y*32A9)BN1#'U>0\CY57+'D``')%`%[7?\`0['2=)7CR;87
M<V.5:6<"3<#U_P!5Y"D<`%#CKDXE7=9U#^U]<U#4O*\K[9<R7'E[MVS>Q;&<
M#.,]<52H`****!!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%;&B:_+I3B"X@34-*=B9]/N"3&^1M++_<DQTD7YA],@
MX]%`SZE\:>%K/XC>$K=K.X1)BJW5A<M'P0RY"MD;@K`C..00IP<8/E%K#?P?
M"J'7;>)+#6?#&J-;+/M9)A$Q!:-@>&/F3?=88QN'<[K7PH^(G]A6-[HU_#-<
M6L44EY;B)LR#:-TB`,0NW:'DZCD-]XL!5WPCJ.@>-]2\7Z&;/[!+KFZ:"0R$
MA]CLZL4+Y\T%]Y"MM(4\*`=T[##PYKO@3Q'XBL=;OI)O#OB.*7SIWAE\JVNI
M/XLL<A5(4Y!VD^81ER<UP?Q&.G-\0-7ETJ:&:SEE659(9?,1F=%9R&R?XRWT
MZ=J]#U7QSX=\!^(F\-:-X>LY-(3,.JN,223YSE0Q)W;-S`AR><K\H&:\_P#'
M'AZPTJ?3]4T1G;1-7@^T6H=U9H6!^>(D$Y*$@<^N,DJ330,Y.BBBF2%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110!/9VD^H7UO96
MJ>9<7$JQ1)D#<S'`&3P.3WJ[XCNX+WQ%?2VC[[)9?*M#@C]PGR1#GGA%4<\\
M<\YJ?PW_`*/)J6ICE]/L7FC`X(D=EA1@?X61I1(#UR@QCJ,2@85MZ-_H>CZQ
MJO\`&L2V,)')62?=N)'3:84G7N077`[C$K;U+_0?#NEZ>.);C=?W`^ZWS?)$
MCCOA$,BD]K@X&#E@#$HHHH$%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`#XII8'+PRO&Q5D+(Q!*L"K#C
ML02".X)IE%%`!7JGC'3])B^#'AJ2PODOVM;LQK.,*T8F5Y6C=%9@K#Y,@DD8
M]Z\KHH&%%%%`@HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHH
MH`****`-N?\`T'P?;6YXEU*Y-VRGG]U$&CC88Z9=[@$'GY%/`^]B5M^*O]'U
MC^REX32HEL<#H)$SYQ!ZE6F,K#/.&'`Z#$H&3V=I/J%];V5JGF7%Q*L429`W
M,QP!D\#D]ZN^([N"]UZY>T?S+.+;;6TA!!>&)1'&QS_$412>!R3P.E3^&?W%
MU?:D>FGV,LP(^^LC`0Q,OHRR2QMG((VDCD`'$H`****!!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%;'AF&)];CN;F))+6Q5KR=)%!1UC&X1MG@!V"QY.>7'!Z''K;L_\`0?">
MHW1X?4)4L8@>0T:%9I2,=&5A;CG@AVP#U4&8\TTMS/)//*\LTC%WD=BS,Q.2
M23U)/>F444"-N7_1/!<$?1]1OFF=7Z^7"FV-E']TM-.">03'@8VMG$K;\5?Z
M/K']E+PFE1+8X'02)GSB#U*M,96&><,.!T&)0,****!!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`444
M4`3K:3O8RWJIFWBE2)WR.&<,5&.O(1OR^E:_B6&734TO1IHGAGL[0/<Q%2H\
MV4F7)!YW>6\2,2,YCQR%!KNO@?H5KK%]K,E_'#=6<$42FSN(1)&TC%MLF#QN
M4*X'&<2'D<Y\QU._EU75;S49U19KN=YW5`0H9F+'&<\9-'495K8\,PQ/K<=S
M<Q)):V*M>3I(H*.L8W"-L\`.P6/)SRXX/0X];=M_H?@^_N/N2W]S':1MU\R)
M!YDR^V'-L<\'L.-U`&/--+<SR3SRO+-(Q=Y'8LS,3DDD]23WIE%%`@HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@#VGX!S16T'B:>>5(H8UMW>1V"JJ@2DDD]`!WKQF:&6V
MGD@GB>*:-BCQNI5E8'!!!Z$'M7>^+?!%YX<^'7AZ^N)G#2SR-<6LG'E22JI7
M`V!@=D0#!B<,..]<UXN^?Q1>7?3[=LO]O]SST6;9GOM\S;GC.,X&<4D-F)6W
MXA_T:/2],3[EM8Q3,1P)))U$Q8C^\%=(\\DB)>G`%70K"+4M;M;:Y9TM2QDN
MG0C<D"`O*PZ\A%8XP2<<`]*@U._EU75;S49U19KN=YW5`0H9F+'&<\9-,"K1
M110(****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`K8\*::NK^+=(T^2W>XAGNXUFC3.3'N&_IR`%R
M2>P!-8]=9\,[^+3?B/HD\RNRO.8`$`)W2*8UZ]LN,^V:!G;>+O$"^)_"WC62
MY"&QL]4MQI,OG%E>0?NW$;9VL"BE]H!QYA//!KSC6?\`2-%T&]7Y_P#1GM)I
M3]XRQR,=I[G;%)``>F,`?=P/8M/^%]Y>?#2TT&]B2QN0UQ>3#SLL;O[D&2-R
M^7LSN"\\+CG=7CL'^D^"[V,_.]E?131*.L<<B.LK$#^$LEN,G@':!C=RD-AH
MW^AZ/K&J_P`:Q+8PD<E9)]VXD=-IA2=>Y!=<#N,2MO5?]$\.Z+I[<RMYU^X/
M#1^;M14(]TA60'N)1QC!.)3$%%%%`@HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"GPS2VT\<\$K
MQ31L'21&*LK`Y!!'0@]Z910![LWC"\U+0O!TUS(ZW7B#78IIHT&84C@F1-B;
MB2H++&^!G)WG(SBN:\'>%=.UCX@^*?#S>=!I<MM)Y#0/\WDBXB>(JS`Y4J%(
M/.0<YYS6WX;M-1A\"^$_$MDD+1:%8ZO<R&4\%CO"+@<G)!)Z<`\YQFU\,@MQ
MXLTK5([)[=;KPSY3N6+++)!.L!()XSMCC)`Z9'KDR4>3^-75O&>JPQQ)%#:3
MFSAC0DA8X0(DY)))VH,G/7-8-;?C+_D>/$'_`&$KC_T8U8E4(****!!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1
M110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%
M%`!1110`4444`%%%%`'I7PXUR;4+&X\)ZO;PW/AB.*6_OFD:3S((D`;Y"K`[
M?,"G:H)RS>IK;\8:SH]C\,]'NO!NI36:M?,D$:3[)[>,H6FBR#OV[]C,"6&6
M4YV[*X;P!=2QZGJUA!;/<3:EHUY:HJ9+!O*,@P`#N),>W'^U^%<M-#+;3R03
MQ/%-&Q1XW4JRL#@@@]"#VI6U'<O:Y?Q:IJ\M_&KAKA4DG+@`O.47S6P.`&DW
ML`,#!'`Z#.HHI@%%%%`@HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`
MHHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"B
MBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH
M`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@#1T'5I=!U^PU6'>6M
M)UE*)(4+J#\R9'0,,@]>">M&NZW>>(M;NM6OV0W-RP9MB[5`````]``!SD\<
MDGFLZB@84444""BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
&****`/_9
`


#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="300" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12767 bugfix outlines" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="8/5/2021 8:44:37 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12767 bugfix dimlines" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="8/3/2021 10:56:37 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End