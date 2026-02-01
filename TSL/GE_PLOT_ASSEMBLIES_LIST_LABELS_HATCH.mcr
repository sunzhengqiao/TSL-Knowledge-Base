#Version 8
#BeginDescription
GE_PLOT_ASSEMBLIES_LIST_LABELS_HATCH
Displays element's dim line and assemblie's labels, hatch and dimlineson lines in shop drawing, and/or a list of them with start/end location, and face alignment (Up/Down)
v1.6: 09.ene.2014: David Rueda (dr@hsb-cad.com)
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 6
#KeyWords 
#BeginContents
/*
  COPYRIGHT
  ---------------
  Copyright (C) 2012 by
  hsbSOFT 

  The program may be used and/or copied only with the written
  permission from hsbSOFT, or in accordance with
  the terms and conditions stipulated in the agreement/contract
  under which the program has been supplied.

  All rights reserved.

 REVISION HISTORY
 -------------------------

 v1.6: 09.ene.2014: David Rueda (dr@hsb-cad.com)
	- DimLines can now be refered to headers only or complete assemblies when openings
 v1.5: 11.oct.2013: David Rueda (dr@hsb-cad.com)
	- Added/relocated dim lines
	- Applied unitFormat to jacks and header dimensioning 
 v1.4: 09.oct.2013: David Rueda (dr@hsb-cad.com)
	- Added "View type" prop.
 v1.3: 06.oct.2013: David Rueda (dr@hsb-cad.com)
	- Added labels for assemblies inside opening (around interior opening)
	- Changed opening name to use full description (width+height+type+style name)
 v1.2: 04.sep.2013: David Rueda (dr@hsb-cad.com)
	- Hatch now is full customizable
	- Added assemblies at wall connections
 v1.1: 31.ago.2013: David Rueda (dr@hsb-cad.com)
	- Hatch added for assemblies
	- Labels will align to bottom of wall and then will be placed vertically alternated
	- If opening, label will be module name
	- Assembly list enhanced, added start/end location and face alignment (Up/Down)
 v1.0: 29.ago.2013: David Rueda (dr@hsb-cad.com)
	- Release
*/

double dTolerance=U(0.01,0.001);
int nLunits=U(2,4);
int nPrec=U(2,4);
int nIndex;
String sTab="     ";
String sNoYes[]={T("|No|"), T("|Yes|")};
String sOpeningTypes[]={T("|None|"),T("|Opening|"),T("|Window|"),T("|Door|"),T("|Assembly|")};
String sColors[0]; int nColors[0];
sColors.append(T("|Dark Brown|")+" ("+"32)");					nColors.append(32);
sColors.append(T("|Light Brown|")+" ("+"40)");					nColors.append(40);
sColors.append(T("|White|"));										nColors.append(0);
sColors.append(T("|Red|"));										nColors.append(1);
sColors.append(T("|Yellow|"));									nColors.append(2);
sColors.append(T("|Green|"));										nColors.append(3);
sColors.append(T("|Cyan|"));										nColors.append(4);
sColors.append(T("|Blue|"));										nColors.append(5);
sColors.append(T("|Magenta|"));									nColors.append(6);
sColors.append(T("|Black|"));										nColors.append(7);

String sViews[]={T("|Elevation view|"),T("|Plan view|")};
PropString sView(19,sViews,T("|View type|"),0);
String sOpDimOptions[]={T("|Ends of complete assembly|"),T("|Ends of header|")};
PropString sDimToHeaders(25,sOpDimOptions,T("|Dimension openings to|"),0);

PropString sEmpty(24,""," ",0);sEmpty.setReadOnly(1);

PropString sTitle1(0,"",T("|Labels Over Assemblies|"));
sTitle1.setReadOnly(1);
	PropString sDisplayLabels(7,sNoYes,sTab+T("|Display Labels|"),1);
	PropString sLabelDimstyle(1, _DimStyles, sTab+T("|Dimstyle|"));
	PropString sPrLabelColor(2,sColors,sTab+T("|Color|"),7);
	nIndex=sColors.find(sPrLabelColor,-1);
	int nLabelColor=nColors[nIndex];
	if (nLabelColor> 255 || nLabelColor< -1) 
		nLabelColor=-1;
	PropDouble dVerticalOffset(0,U(50,2),sTab+T("|Vertical Offset From Assembly Center|"));
	PropDouble dTxtOffset(1,U(38,1.5),sTab+T("|Text around opening offset|"));

PropString sTitle2(3,"",T("|Assemblies List|"));
sTitle2.setReadOnly(1);
	PropString sDisplayList(4,sNoYes,sTab+T("|Display List|"),1);
	PropString sListDimstyle(5, _DimStyles, sTab+T("|Dimstyle|"+" "),"hsb-vp-inch");
	PropString sPrListColor(6,sColors,sTab+T("|Color|"+" "),9);
	nIndex=sColors.find(sPrListColor,0);
	int nListColor=nColors[nIndex];
	if (nListColor> 255 || nListColor< -1) 
		nListColor=-1;	

PropString sTitle3(8,"",T("|Hatch|"));
sTitle3.setReadOnly(1);
	PropString sDisplayHatch(9,sNoYes,sTab+T("|Display Hatch|"),1);
	int nDisplayHatch=sNoYes.find(sDisplayHatch,1);
	PropString sHatchPattern(10,_HatchPatterns,sTab+T("|Pattern|"),1);
	PropDouble dHatchScale(2,U(250,10),sTab+T("|Scale|"));	
	PropString sPrHatchColor(11,sColors,sTab+T("|Color| "+" "),7);
	nIndex=sColors.find(sPrHatchColor,0);
	int nHatchColor=nColors[nIndex];
	if (nHatchColor> 255 || nHatchColor< -1) 
		nHatchColor=-1;

PropString sTitle4(12,"",T("|Dimension Lines|"));
sTitle4.setReadOnly(1);
	PropString sDisplayDimlineCum(13,sNoYes,sTab+T("|Display Assembly Cummulative|"),1);
	PropDouble dDimLineCumOffset(3,-U(12,.5),sTab+sTab+T("|Offset (from insertion point)|"));
	PropString sDimlineCumDimstyle(14, _DimStyles, sTab+sTab+T("|Dimstyle|"+" "),"hsb-vp-inch");
	PropString sPrDimlineCumColor(15,sColors,sTab+sTab+T("|Color|"+"  "),7);
	nIndex=sColors.find(sPrDimlineCumColor,0);
	int nDimlineCumColor=nColors[nIndex];
	if (nDimlineCumColor> 255 || nDimlineCumColor< -1) 
		nDimlineCumColor=-1;

	PropString sDisplayDimlineDelta(16,sNoYes,sTab+T("|Display Assembly Delta|"),1);
	PropDouble dDimLineDeltaOffset(4,-U(22.2,.875),sTab+sTab+T("|Offset (from insertion point)|")+" ");
	PropString sDimlineDeltaDimstyle(17, _DimStyles, sTab+sTab+T("|Dimstyle|"+"  "),"hsb-vp-inch");
	PropString sPrDimlineDeltaColor(18,sColors,sTab+sTab+T("|Color|"+"   "),7);
	nIndex=sColors.find(sPrDimlineDeltaColor,0);
	int nDimlineDeltaColor=nColors[nIndex];
	if (nDimlineDeltaColor> 255 || nDimlineDeltaColor< -1) 
		nDimlineDeltaColor=-1;

	PropString sDisplayElementDelta(20,sNoYes,sTab+T("|Display Element Dimension Line|"),1);
	PropDouble dDimElementDeltaOffset(5,-U(30.1,1.1875),sTab+sTab+T("|Offset (from insertion point)|")+"  ");
	PropString sDimlineElementDeltaDimstyle(21, _DimStyles, sTab+sTab+T("|Dimstyle| "+"  "),"hsb-vp-inch");
	PropString sPrDimlineElementDeltaColor(22,sColors,sTab+sTab+T("|Color| "+"   "),7);
	nIndex=sColors.find(sPrDimlineElementDeltaColor,0);
	int nDimlineElementDeltaColor=nColors[nIndex];
	if (nDimlineElementDeltaColor> 255 || nDimlineElementDeltaColor< -1) 
		nDimlineElementDeltaColor=-1;

if (_bOnInsert)
{
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	
  	Viewport vp = getViewport(T("Select the viewport from which the element is taken")); // select viewport
	_Viewport.append(vp);

	int nViewType=getInt("\n"+T("|Please select view type:|  ")+T("|Elevation view|")+"<0>; "+T("|Plan view|")+"<1>");
	
	if(nViewType==0)
		_Pt0= getPoint(T("|Select point for asseblies list|"));

	else
		nViewType=1;
	
	sView.set(sViews[nViewType]);
	
	nIndex=_DimStyles.find("hsb-vp-inch",-1);
	if(nIndex>-1)
	{
		sLabelDimstyle.set(_DimStyles[nIndex]);
		sListDimstyle.set(_DimStyles[nIndex]);
		sDimlineCumDimstyle.set(_DimStyles[nIndex]);
		sDimlineDeltaDimstyle.set(_DimStyles[nIndex]);
		sDimlineElementDeltaDimstyle.set(_DimStyles[nIndex]);
	}

	nIndex=_HatchPatterns.find("DOTS",-1);
	if(nIndex>-1)
	{
		sHatchPattern.set(_HatchPatterns[nIndex]);
	}

	return;
}

if (_Viewport.length()==0) 
	return; // _Viewport array has some elements
Viewport vp= _Viewport[_Viewport.length()-1]; // take last element of array
_Viewport[0] = vp; // make sure the connection to the first one is lost

// check if the viewport has hsb data
if (!vp.element().bIsValid())
	return;

// Set props according to view type
int nView=sViews.find(sView,0);
if(nView==0) // Elevation
{
	sDisplayLabels.set(sNoYes[1]);
	sDisplayList.set(sNoYes[1]);
	sDisplayDimlineCum.set(sNoYes[0]);
	sDisplayDimlineDelta.set(sNoYes[0]);
	sDisplayElementDelta.set(sNoYes[0]);
}
else // Plan
{
	sDisplayLabels.set(sNoYes[0]);
	sDisplayList.set(sNoYes[0]);
	sDisplayDimlineCum.set(sNoYes[1]);
	sDisplayDimlineDelta.set(sNoYes[1]);
	sDisplayElementDelta.set(sNoYes[1]);
}
int nDisplayLabels=sNoYes.find(sDisplayLabels,1);
int nDisplayList=sNoYes.find(sDisplayList,1);
int nDisplayDimlineCum=sNoYes.find(sDisplayDimlineCum,1);
int nDisplayDimlineDelta=sNoYes.find(sDisplayDimlineDelta,1);
int nDisplayElementDelta=sNoYes.find(sDisplayElementDelta,1);

if(nView==1) // Plan view
{
	_Pt0=vp.ptCenPS()+_YW*vp.heightPS()*.5-_XW*vp.widthPS()*.5;	
}

CoordSys csVp= vp.coordSys();
Element el= vp.element();
if (!el.element().bIsValid()) 
	return;

Point3d ptElOrg= el.ptOrg();
Vector3d vx = el.vecX();
Vector3d vy = el.vecY();
Vector3d vz = el.vecZ();
Point3d ptElOrgVP=ptElOrg;
ptElOrgVP.transformBy(csVp);

PLine plEl=el.plOutlineWall();
PlaneProfile ppEl(plEl);
LineSeg ls=ppEl.extentInDir(vx);
double dElLength=abs(vx.dotProduct(ls.ptStart()-ls.ptEnd()));
double dElWidth=el.dBeamWidth();
double dElHeight= ((Wall)el).baseHeight();
Point3d ptElStart= ptElOrg;
Point3d ptElEnd= ptElOrg+vx*dElLength;
Point3d ptElCenter= ptElOrg+vx*dElLength*.5-vz*dElWidth*.5;
Point3d ptElBack= el.ptOrg()-vz*dElWidth;
Beam bmAll[]= el.beam();
if(bmAll.length()==0)
	return;
	
Opening opAll[]=el.opening();
// Read opening Framing Styles catalog from Stickframe folder
Map mapOpeningStyles;
mapOpeningStyles.readFromDxxFile(_kPathHsbWallDetail+"\\OpeningSFCat.dat");

// Get T wall to wall connections
PLine plEl1=plEl; // Just to avoid confusion below
Element elWallsConnected[]= ((ElementWall)el).getConnectedElements();
Point3d ptWallConnections[0];
for( int e=0;e<elWallsConnected.length();e++)
{
	Element el2=elWallsConnected[e];
	//Checking this is a T or an L connection 
	PLine plEl2=el2.plOutlineWall();
	Point3d ptAllInt[]=plEl2.intersectPLine(plEl1);
	if(ptAllInt.length()!=2)
	{
		continue;
	}
	
	Point3d ptCon1=ptAllInt[0];
	Point3d ptCon2=ptAllInt[1];
	Vector3d vTmp1(ptCon2-ptCon1); vTmp1.normalize();
	Point3d ptWallConnection=ptCon1+vTmp1*((ptCon2-ptCon1).length()*.5);
	ptWallConnections.append(ptWallConnection);
}

// Get all beams that belong to a module and plates
Beam bmPlates[0];
Beam bmMod[0];
for(int b=0;b<bmAll.length();b++)
{
	Beam bm=bmAll[b];
	if(bm.module()!=""&&bm.information()!="")
	bmMod.append(bm);

	if(bm.type()== _kBottom || bm.type()== _kSFBottomPlate || bm.type()==_kTopPlate || bm.type()==_kSFTopPlate)
	{
		bmPlates.append(bm);
	}
}

// Sort beams along vx then list will display sorted
for(int i=0;i<bmMod.length()-1;i++)
{
	for(int j=0;j<bmMod.length()-1;j++)
	{
		Beam bmj0=bmMod[j];
		Beam bmj1=bmMod[j+1];
		if(vx.dotProduct(bmj0.ptCen()-ptElOrg)>vx.dotProduct(bmj1.ptCen()-ptElOrg))
		{
			Beam bmAux=bmj0;
			bmMod[j]=bmj1;
			bmMod[j+1]=bmAux;
		}
	}
}

Display dp(-1);
dp.dimStyle(sLabelDimstyle);

/*
FIND ALL MODULES:
- Define module names (to be displayed in horizontal/staggered line below element in front view)
- Group all assemblies in openings as one single group for label display 
- Collect points to display assembly locations (distance from element org to assembly start/end) in list
- Display hatch
- Define assembly's Up/Down zone alignment
*/

String sFoundModules[0], sNamesToList[0];
Point3d ptLefts[0], ptRights[0];
Hatch hatch(sHatchPattern,dHatchScale);
int nOpeningTypes[]={_kHeader,_kSill,_kKingStud,_kSFSupportingBeam,_kSFTransom,_kSFTopHeaderSill,_kSFBottomHeaderSill};
int nC;
for( int b=0;b<bmMod.length();b++)
{
	Beam bm=bmMod[b];
	String sBmModule=bm.module();
	String sBmInformation=bm.information();
	String sNameToList, sLabelToDisplay;
	if(sFoundModules.find(sBmModule)>=0)
		continue;

	Body bdCurrentAssembly, bdHeadersInAssembly[0];
	int bIsOpening=false;
	double dLeft= U(250000,10000), dRight=0, dBottom=U(250000,10000), dTop=0;
	Point3d ptMostLeft, ptMostRight, ptMostBottom, ptMostTop;

	int bIsSS=true;
	double dBmW=bm.dD(vx);
	double dBmH=bm.dD(vz);
	double dBmL=bm.dL();
	
	for( int b1=b;b1<bmMod.length();b1++)
	{
		Beam bm1=bmMod[b1];
		// Collecting all beams in assembly
		if(bm1.module()==sBmModule&&bm1.information()!="")
		{
			bdCurrentAssembly.addPart(bm1.envelopeBody()); // For hatch

			nIndex=nOpeningTypes.find(bm1.type(),-1); // For name display
			if(nIndex>-1)
				bIsOpening=true;
			if(bm1.type()==_kHeader)
				bdHeadersInAssembly.append(bm1.envelopeBody());

			// Collecting most left and right points of assembly
			Point3d ptBmExtrems[]=bm1.envelopeBody().extremeVertices(vx);
			Point3d ptBmLeft=ptBmExtrems[0];
			if(dLeft>vx.dotProduct(ptBmLeft-ptElOrg))
			{
				dLeft=vx.dotProduct(ptBmLeft-ptElOrg);
				ptMostLeft=ptBmLeft;
			}
			Point3d ptBmRight=ptBmExtrems[ptBmExtrems.length()-1];
			if(dRight<vx.dotProduct(ptBmRight-ptElOrg))
			{
				dRight=vx.dotProduct(ptBmRight-ptElOrg);
				ptMostRight=ptBmRight;
			}
			
			// Collecting most top and bottom points of assembly
			ptBmExtrems.setLength(0);
			ptBmExtrems=bm1.envelopeBody().extremeVertices(vy);
			Point3d ptBmBottom=ptBmExtrems[0];
			if(dBottom>vy.dotProduct(ptBmBottom-ptElOrg))
			{
				dBottom=vy.dotProduct(ptBmBottom-ptElOrg);
				ptMostBottom=ptBmBottom;
			}
			Point3d ptBmTop=ptBmExtrems[ptBmExtrems.length()-1];
			if(dTop<vy.dotProduct(ptBmTop-ptElOrg))
			{
				dTop=vy.dotProduct(ptBmTop-ptElOrg);
				ptMostTop=ptBmTop;
			}
			// Define is is an SS, SSS, SSS etc type
			if( dBmW!=bm1.dD(vx)||dBmH!=bm1.dD(vz)||dBmL!=bm1.dL())
				bIsSS=false;
		}
 	}
	sFoundModules.append(sBmModule);
	
	// Redefine ptMostLeft and ptMostRight when user wants to have dimensions to end to end of headers instead of all assembly (affects only dimension line, not hatch or others)
	if(bIsOpening && bdHeadersInAssembly.length()>0 && sOpDimOptions.find(sDimToHeaders,0))
	{
		double dLeft= U(250000,10000), dRight=0;
		for(int b=0;b<bdHeadersInAssembly.length();b++)
		{
			Point3d ptBmExtrems[]=bdHeadersInAssembly[b].extremeVertices(vx);
			Point3d ptBmLeft=ptBmExtrems[0];
			if(dLeft>vx.dotProduct(ptBmLeft-ptElOrg))
			{
				dLeft=vx.dotProduct(ptBmLeft-ptElOrg);
				ptMostLeft=ptBmLeft;
			}
			Point3d ptBmRight=ptBmExtrems[ptBmExtrems.length()-1];
			if(dRight<vx.dotProduct(ptBmRight-ptElOrg))
			{
				dRight=vx.dotProduct(ptBmRight-ptElOrg);
				ptMostRight=ptBmRight;
			}
		}
	}
	
	// Collect points to display assembly locations (distance from element org to assembly start/end) in list
	ptMostLeft+=vy*vy.dotProduct(ptElOrg-ptMostLeft)+vz*vz.dotProduct(ptElOrg-ptMostLeft);
	ptMostRight+=vy*vy.dotProduct(ptElOrg-ptMostRight)+vz*vz.dotProduct(ptElOrg-ptMostRight);
	ptLefts.append(ptMostLeft);
	ptRights.append(ptMostRight);

	if(bIsOpening)
	{
		//Search closer opening to module
		Point3d ptBottomLeft=ptMostBottom;
		ptBottomLeft+=vx*vx.dotProduct(ptMostLeft-ptBottomLeft);
		Point3d ptTopRight=ptMostTop;
		ptTopRight+=vx*vx.dotProduct(ptMostRight-ptTopRight);
		PLine plDiagonal(ptBottomLeft,ptTopRight);
		Point3d ptModuleCenter=plDiagonal.ptMid();
		ptModuleCenter+=vy*vz.dotProduct(ptElOrg-ptModuleCenter);
		OpeningSF op;
		Point3d ptOpCen;
		double dDist=U(1000);
		int nIndex=-1;
		for(int o=opAll.length()-1;o>=0;o--)
		{
			Opening opCurrent=opAll[o];
			CoordSys csOp=opCurrent.coordSys();
			Point3d ptOpCenCurrent=csOp.ptOrg();
			ptOpCenCurrent+=csOp.vecX()*opCurrent.width()*.5+csOp.vecY()*opCurrent.height()*.5;
			ptOpCenCurrent+=vz*vz.dotProduct(ptElOrg-ptOpCenCurrent);
			PLine plOp=opCurrent.plShape();
			if((ptOpCenCurrent-ptModuleCenter).length()<dDist)
			{
				op=(OpeningSF)opCurrent;
				nIndex=o;
				dDist=(ptOpCenCurrent-ptModuleCenter).length();
				ptOpCen=ptOpCenCurrent;
			}
		}
		ptOpCen+=vz*vz.dotProduct(ptElCenter-ptOpCen);

		if(nIndex>-1)
			opAll.removeAt(nIndex);
			
		// Get opening's name to display 
		Map mapOpSf, mapOp;
		for(int m=0;m<mapOpeningStyles.length();m++)
		{
			Map mapOpeningSFCat=mapOpeningStyles.getMap(m);
			if(mapOpeningSFCat.getString("EntryName").trimLeft().trimRight()==op.styleNameSF().trimLeft().trimRight())
			{
				mapOpSf=mapOpeningSFCat.getMap("OpeningSF");
				mapOp=mapOpSf.getMap("Opening") ;
				break;
			}
		}
		double dWidth=mapOp.getDouble("Width");
		String sWidth;sWidth.formatUnit(dWidth,nLunits,nPrec);
		double dHeight=mapOp.getDouble("Height");
		String sHeight;sHeight.formatUnit(dHeight,nLunits,nPrec);
		sNameToList=sWidth+" x "+sHeight+" "+sOpeningTypes[op.openingType()]+" "+op.styleNameSF().trimLeft().trimRight();

		// Display opening's assemblies details
		if(nDisplayLabels)
		{
			dp.color(nLabelColor);
			dWidth=op.width();
			dHeight=op.height();
			CoordSys csOp=op.coordSys();
			Point3d ptOpOrg=csOp.ptOrg();
			Vector3d vxOp=csOp.vecX();
			Vector3d vyOp=csOp.vecY();
			Vector3d vzOp=csOp.vecZ();

			// Find module of opening
			Beam bmIntersect[]=Beam().filterBeamsHalfLineIntersectSort(bmAll,ptOpCen,vx);
			String sCurrentModule;
			if(bmIntersect.length()>0)
				sCurrentModule=bmIntersect[0].module();

			int nHasHeader=false;
			bmIntersect=Beam().filterBeamsHalfLineIntersectSort(bmAll,ptOpCen,vy);
			for(int k=0;k<bmIntersect.length();k++)
			{
				if(bmIntersect[k].type()==_kHeader)
				{
					nHasHeader=true;
					break;
				}
			}
			Beam bmFrame=bmIntersect[0];
			Point3d ptHeaderTxt=bmFrame.ptCen()-vy*(bmFrame.dD(vy)*.5+dTxtOffset);
			ptHeaderTxt+=vx*vx.dotProduct(ptOpCen-ptHeaderTxt);
			ptHeaderTxt.transformBy(csVp);
			if(nHasHeader)
			{
				String sHeaderDesc=mapOpSf.getString("DESCRPLATE").trimLeft().trimRight();
				dp.draw(sHeaderDesc,ptHeaderTxt,_XW,_YW,0,-1);
			}
			
			int nHasTopSill=false;
			for(int k=0;k<bmIntersect.length();k++)
			{
				if(bmIntersect[k].type()==_kSill && bmIntersect[k].module()==sCurrentModule)
				{
					nHasTopSill=true;
					break;
				}
			}
			if(nHasTopSill)
			{
				String sTopDesc=mapOpSf.getString("CONSTRDETAILTOP").trimLeft().trimRight();
				Point3d ptTopTxt=ptHeaderTxt-_YW*dp.textHeightForStyle("X",sLabelDimstyle)*1.5;
				dp.draw(sTopDesc,ptTopTxt,_XW,_YW,0,-1);
			}
	
			int nHasBottomSill=false;
			bmIntersect=Beam().filterBeamsHalfLineIntersectSort(bmAll,ptOpCen,-vy);
			for(int k=0;k<bmIntersect.length();k++)
			{
				if(bmIntersect[k].type()==_kSill && bmIntersect[k].module()==sCurrentModule)
				{
					nHasBottomSill=true;
					break;
				}
			}

			if(nHasBottomSill)
			{
				String sBottomDesc=mapOpSf.getString("CONSTRDETAILBOTTOM").trimLeft().trimRight();
				bmFrame=bmIntersect[0];
				Point3d ptBottomTxt=bmFrame.ptCen()+vy*(bmFrame.dD(vy)*.5+dTxtOffset);
				ptBottomTxt+=vx*vx.dotProduct(ptOpCen-ptBottomTxt);
				ptBottomTxt.transformBy(csVp);
				dp.draw(sBottomDesc,ptBottomTxt,_XW,_YW,0,1);
			}
			
			String sLeftDesc=mapOpSf.getString("CONSTRDETAILLEFT").trimLeft().trimRight();
			bmIntersect=Beam().filterBeamsHalfLineIntersectSort(bmAll,ptOpCen,-vx);
			bmFrame=bmIntersect[0];
			Point3d ptLeftTxt=bmFrame.ptCen()+vx*(bmFrame.dD(vx)*.5+dTxtOffset);
			ptLeftTxt+=vy*vy.dotProduct(ptOpCen-ptLeftTxt);
			ptLeftTxt.transformBy(csVp);
			dp.draw(sLeftDesc,ptLeftTxt,_YW,-_XW,0,-1);
	
			String sRightDesc=mapOpSf.getString("CONSTRDETAILRIGHT").trimLeft().trimRight();
			bmIntersect=Beam().filterBeamsHalfLineIntersectSort(bmAll,ptOpCen,vx);
			bmFrame=bmIntersect[0];
			Point3d ptRightTxt=bmFrame.ptCen()-vx*(bmFrame.dD(vx)*.5+dTxtOffset);
			ptRightTxt+=vy*vy.dotProduct(ptOpCen-ptRightTxt);
			ptRightTxt.transformBy(csVp);
			dp.draw(sRightDesc,ptRightTxt,_YW,-_XW,0,1);
		}
	}

	else // Not opening
		sNameToList=sBmInformation;
	
	sNameToList.trimLeft().trimRight();
	sLabelToDisplay=sNameToList;
	
	// Display Hatch
	if(nDisplayHatch)
	{
		dp.color(nHatchColor);
		if(nView==0) // Elevation view hatch
		{
			PlaneProfile ppAssemblyFront=bdCurrentAssembly.shadowProfile(Plane(ptElOrg,vz));
			ppAssemblyFront.transformBy(csVp);
			dp.draw(ppAssemblyFront);
			dp.draw(ppAssemblyFront,hatch);	
		}
		
		else // Plan view hatch
		{
			PlaneProfile ppAssemblyTop=bdCurrentAssembly.shadowProfile(Plane(ptElOrg,vy));
			ppAssemblyTop.transformBy(csVp);
			dp.draw(ppAssemblyTop);
			dp.draw(ppAssemblyTop,hatch);
		}
	}
	
	// Define if is alignet to front or back face of wall
	String sFaceAlignment=""; // "Up"=Zone 1=front; "Down"=Zone 6=back
	if(!bIsOpening && !bIsSS)
	{
		double dLineOffsetX=U(25,.1), dLineOffsetZ=U(10,.5), dLineLength=U(250000,10000), dFrontDistance=0, dBackDistance=0;
		Line lnFront(ptElOrg-vx*dLineOffsetX+vy*dElHeight*.5-vz*dLineOffsetZ,vx*dLineLength);
		Point3d ptIntersectsFront[]=bdCurrentAssembly.intersectPoints(lnFront);
		if(ptIntersectsFront.length()>=2)
			dFrontDistance=abs(vx.dotProduct(ptIntersectsFront[0]-ptIntersectsFront[ptIntersectsFront.length()-1]));
		Line lnBack(ptElBack-vx*dLineOffsetX+vy*dElHeight*.5+vz*dLineOffsetZ,vx*dLineLength);
		Point3d ptIntersectsBack[]=bdCurrentAssembly.intersectPoints(lnBack);
		if(ptIntersectsBack.length()>=2)
			dBackDistance=abs(vx.dotProduct(ptIntersectsBack[0]-ptIntersectsBack[ptIntersectsBack.length()-1]));
		if(abs(dFrontDistance-dBackDistance)<U(2.5,.1))
			sFaceAlignment="";
		else if(dFrontDistance>dBackDistance)
			sFaceAlignment="Up";
		else if(dFrontDistance<dBackDistance)
			sFaceAlignment="Down";
	
		// Forcing display alignment when T wall to wall connection
		for(int p=0;p<ptWallConnections.length();p++)
		{
			Point3d ptCon=ptWallConnections[p];
			int bIsTeeConnection;
			if( vx.dotProduct(ptCon-ptMostLeft)>=0 && vx.dotProduct(ptMostRight-ptCon)>=0)
				bIsTeeConnection=true;
			
			if(!bIsTeeConnection)
				continue;
			
			if(abs(vz.dotProduct(ptElOrg-ptCon))<=dTolerance)
				sFaceAlignment="Up";
			if(abs(vz.dotProduct(ptElBack-ptCon))<=dTolerance)
				sFaceAlignment="Down";
		}
	}
	
	sNameToList+=+"   "+sFaceAlignment;
	sNameToList.trimLeft().trimRight();
	sNamesToList.append(sNameToList);

	// Display labels
	dp.color(nLabelColor);
	if(nDisplayLabels)
	{
		ptMostLeft.transformBy(csVp);
		ptMostRight.transformBy(csVp);
		Point3d ptCenterVP=ptMostLeft+_XW*abs(_XW.dotProduct(ptMostRight-ptMostLeft))*.5;
		ptCenterVP+=_YW*(dVerticalOffset*vp.dScale()-(dp.textHeightForStyle("X",sLabelDimstyle)*2*((nC%2)+1)) );
		dp.draw(sLabelToDisplay,ptCenterVP,_XW,_YW,0,0);
	}
	
	nC++;
}

// Show dimlines
// Get start/end from framed wall
DimLine dmTmp(ptElOrg,vx,vy);
Point3d  ptTmp[0];
for(int b=0;b<bmPlates.length();b++)
{
	ptTmp.append(bmPlates[b].dimPoints(dmTmp, _kLeftAndRight));
}
Line lnX(ptElOrg,vx);
ptTmp=lnX.projectPoints(ptTmp);
ptTmp=lnX.orderPoints(ptTmp);
Point3d ptStartDim=ptTmp[0];
Point3d ptEndDim=ptTmp[ptTmp.length()-1];

//Check if the panel haven been reversed on the viewport
int nReverseX=FALSE;
Vector3d vxTxt=vx;
Vector3d vzTxt=vz;
Vector3d vAuxX=vx;
vAuxX.transformBy(csVp);
if (vAuxX.dotProduct(_XW)<0)
{
	vxTxt=-vxTxt;
}
Vector3d vAuxZ=vz;
vAuxZ.transformBy(csVp);
if (vAuxZ.dotProduct(_YW)<0)
{
	vzTxt=-vzTxt;
}

// Get viewport scale for dimensioning
CoordSys csInv=csVp;
csInv.invert();
double dScale=csInv.scale();
double vpScale=vp.dScale();
// Verify which assemblies must be dimensioned (taking out stacked openings)
if(sNamesToList.length()>0)
{
	Point3d ptDim[0];
	ptDim.append(ptStartDim);
	for(int p=0;p<ptLefts.length();p++)
	{
		Point3d ptLp=ptLefts[p];
		Point3d ptRp=ptRights[p];
		int bDimension=true;
		for(int q=0;q<ptLefts.length();q++)
		{
			if(p==q)
				continue;
			
			Point3d ptLq=ptLefts[q];
			Point3d ptRq=ptRights[q];
			if(vx.dotProduct(ptLp-ptLq)>=0 && vx.dotProduct(ptRq-ptRp)>=0)
				bDimension=false;
		}
		if( bDimension)
		{
			ptDim.append(ptLp);
			ptDim.append(ptRp);
		}
	}
	ptDim.append(ptEndDim);

	// Cumulative
	if(nDisplayDimlineCum)
	{
		dp.dimStyle(sDimlineCumDimstyle,dScale);
		dp.color(nDimlineCumColor);
		DimLine dimLn(ptElOrg,vxTxt,vzTxt);;
	Dim dim(dimLn,ptDim,"<>","<>", _kDimCumm);
		dim.transformBy(csVp);
		dimLn.transformBy(csVp);
		dimLn.ptOrg().vis();
		Vector3d vAlign=_YW*(_YW.dotProduct(_Pt0-dimLn.ptOrg())+dDimLineCumOffset);
		dim.transformBy(vAlign);
		dp.draw(dim);
	}

	// Delta
	if(nDisplayDimlineDelta)
	{
		dp.dimStyle(sDimlineDeltaDimstyle,dScale);
		dp.color(nDimlineDeltaColor);
		DimLine dimLn(ptElOrg,vxTxt,vzTxt);
		Dim dim(dimLn,ptDim,"<>","<>", _kDimDelta);
		dim.transformBy(csVp);
		dimLn.transformBy(csVp);
		Vector3d vAlign=_YW*(_YW.dotProduct(_Pt0-dimLn.ptOrg())+dDimLineDeltaOffset);
		dim.transformBy(vAlign);
		dp.draw(dim);
	}
}

if(nDisplayElementDelta)
{
	Point3d ptDim[0];
	ptDim.append(ptStartDim);
	ptDim.append(ptEndDim);

	dp.dimStyle(sDimlineElementDeltaDimstyle,dScale);
	dp.color(nDimlineElementDeltaColor);
	DimLine dimLn(ptElOrg,vxTxt,vzTxt);
	Dim dim(dimLn,ptDim,"<>","<>", _kDimDelta);
	dim.transformBy(csVp);
	dimLn.transformBy(csVp);
	Vector3d vAlign=_YW*(_YW.dotProduct(_Pt0-dimLn.ptOrg())+dDimElementDeltaOffset);
	dim.transformBy(vAlign);

	if(sNamesToList.length()==0) // Relocate element dimline closer to element
	{
		DimLine dimLn1(ptElOrg,vxTxt,vzTxt);
		Dim dim1(dimLn1,ptDim,"<>","<>", _kDimDelta);
		dim1.transformBy(csVp);
		dimLn1.transformBy(csVp);
		Vector3d vAlign1=_YW*(_YW.dotProduct(_Pt0-dimLn1.ptOrg())+dDimLineDeltaOffset);
		dim1.transformBy(vAlign1);
		dim=dim1;
	}
	
	dp.draw(dim);
}

// Display assembly list
if(sNamesToList.length()==0 || !nDisplayList)
	return;
	
dp.color(nListColor);
dp.dimStyle(sListDimstyle);
double dTxtH=dp.textHeightForStyle("X",sListDimstyle);

double dNameColW,dStartColW,dEndColW;
double dTxtOffV=U(12,.5)*vp.dScale();
double dOffsetH=dp.textLengthForStyle("XXXX",sListDimstyle);
Point3d ptTxt=_Pt0-_YW*dTxtH;
Point3d ptStartV=ptTxt;

// Title names
String sNameColTitle=T("|Assembly|");
String sStartColTitle=T("|Start|");
String sEndColTitle=T("|End|");
double dColW;

// Display assemblies names
for( int i=0;i<sNamesToList.length();i++)
{
	ptTxt-=_YW*(dTxtH+dTxtOffV);
	dp.draw(sNamesToList[i],ptTxt,_XW,_YW,1,0);
	dColW=dp.textLengthForStyle(sNamesToList[i],sListDimstyle);
	if(dNameColW<dColW)
		dNameColW=dColW;
}

dColW=dp.textLengthForStyle(sNameColTitle,sListDimstyle);
if(dNameColW<dColW)
	dNameColW=dColW;

// Display start locations
ptTxt=ptStartV+_XW*(dNameColW+dOffsetH);
for( int i=0;i<ptLefts.length();i++)
{
	ptTxt-=_YW*(dTxtH+dTxtOffV);
	double dLeftLocation=vx.dotProduct(ptLefts[i]-ptElOrg);
	String sLeftLocation;sLeftLocation.formatUnit(dLeftLocation,nLunits,nPrec).trimLeft().trimRight();
	dp.draw(sLeftLocation,ptTxt,_XW,_YW,1,0);
	double dColW=dp.textLengthForStyle(sLeftLocation,sListDimstyle);
	if(dStartColW<dColW)
		dStartColW=dColW;
}
dColW=dp.textLengthForStyle(sStartColTitle,sListDimstyle);
if(dStartColW<dColW)
	dStartColW=dColW;

// Display end locations
ptTxt=ptStartV+_XW*(dNameColW+dOffsetH+dStartColW+dOffsetH);
for( int i=0;i<ptRights.length();i++)
{
	ptTxt-=_YW*(dTxtH+dTxtOffV);
	double dRightLocation=vx.dotProduct(ptRights[i]-ptElOrg);
	String sRightLocation;sRightLocation.formatUnit(dRightLocation,nLunits,nPrec).trimLeft().trimRight();
	dp.draw(sRightLocation,ptTxt,_XW,_YW,1,0);
}

// Display title
dp.draw(sNameColTitle,ptStartV,_XW,_YW,1,0);
dp.draw(sStartColTitle,ptStartV+_XW*(dNameColW+dOffsetH),_XW,_YW,1,0);
dp.draw(sEndColTitle,ptStartV+_XW*(dNameColW+dOffsetH+dStartColW+dOffsetH),_XW,_YW,1,0);

return;

#End
#BeginThumbnail


#End
