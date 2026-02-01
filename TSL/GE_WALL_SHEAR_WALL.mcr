#Version 8
#BeginDescription
V1.8__Creates propset and attaches to wall and script
v1.7: 03.nov.2013: David Rueda (dr@hsb-cad.com)
Creates a shear wall segment between 2 selected points on a wall. 
NOTICE: This tool needs these TSL's to work properly:
GE_HDWR_ANCHOR_ADHESIVE
GE_HDWR_ANCHOR_EMBEDDED
GE_HDWR_ANCHOR_J-BOLT
GE_HDWR_ANCHOR_SCREW
GE_HDWR_HANGER_WAH
GE_HDWR_ITW_TDS
GE_HDWR_STRAP_TSA
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
* v1.7: 03.nov.2013: David Rueda (dr@hsb-cad.com)
	- Stickframe path added to mapIn when calling dll
* v1.6: 13.mar.2013: David Rueda (dr@hsb-cad.com)
*	- Works in decimal and imperial
	- Added all values for ACA schedule
	- Refreshing schedule now needs only recalculate TSL's and update schedule table
* v1.5: 07.mar.2013: David Rueda (dr@hsb-cad.com)
*	- Display of text, tags, and dimension lines are now always readable in any angle of walls
* v1.4: 28.feb.2013: David Rueda (dr@hsb-cad.com)
*	- Description added
* v1.3: 22.ene.2013: David Rueda (dr@hsb-cad.com)
*	- Prop. name corrected
	- All display props set from defaults editor
* v1.2: 29.nov.2012: David Rueda (dr@hsb-cad.com)
*	- Bugfix relocating _Pt0
* v1.1: 27.nov.2012: David Rueda (dr@hsb-cad.com)
*	- Version control (several enhancements, coordinated with Manish Patel and Marcelo Quevedo)
* v1.0: 14.nov.2012: David Rueda (dr@hsb-cad.com)
*	Release
*
*/

//Setting info
String sCompanyPath 	= _kPathHsbCompany; 
String sStickFramePath 	= _kPathHsbWallDetail;
String sInstallationPath	= _kPathHsbInstall;

int nImperial=U(0,1);

String sTab="     "; 
int nStr, nInt, nDbl;
String sNoYes[]={T("|No|"), T("|Yes|")};

PropString sStyle(nStr, "",T("|SHEAR WALL STYLE|"));nStr++;
sStyle.setDescription(T("|Shear wall style can be changed from right click on the TSL instance|") + " -> " + T("|Custom| ") + " -> " +  T("|Change style|"));
sStyle.setReadOnly(true);

PropString sEmpty51(nStr, "", T("|SYMBOL|"));nStr++;sEmpty51.setReadOnly(1);nStr++;

	PropString sNote(nStr, "", sTab+T("|Note|"), 0);nStr++;
	//sNote.setReadOnly(true);

	String sColors[0];int nColors[0];
	sColors.append(T("|From layer|")); 	nColors.append(-1);
	sColors.append(T("|Red|")); 			nColors.append(1);
	sColors.append(T("|Yellow|")); 		nColors.append(2);
	sColors.append(T("|Green|")); 		nColors.append(3);
	sColors.append(T("|Cyan|")); 			nColors.append(4);
	sColors.append(T("|Blue|")); 			nColors.append(5);
	sColors.append(T("|Magenta|")); 		nColors.append(6);
	sColors.append(T("|White|")); 		nColors.append(7);
	sColors.append(T("|Gray|")); 			nColors.append(8);
	
	PropString sSymbolColor(nStr, sColors,sTab+T("|Symbol color|"), 4);nStr++;
	
	String sShapes[]={T("|Triangle|"),T("|Diamond|"),T("|None|")};
	PropString sShape(nStr, sShapes, sTab+T("|Tag shape|"), 1);nStr++;

	PropDouble dDistanceFromWall(nDbl, U(25,1), sTab+T("|Offset from wall|")+"/"+T("|hatch depth|")); nDbl++;
	
	PropString sDisplayP1P2(nStr, sNoYes, sTab+T("|Display start and end points|"),0);nStr++;
	
	String sDisplayTypes[]={"Hatch","Dashed line","none"};
	PropString sDisplayType(nStr, sDisplayTypes, sTab+T("|Display| "),1);nStr++;

	PropString sDimstyleSymbol(nStr, _DimStyles, sTab+T("|Dimension style|"), 0);nStr++;

PropString sEmpty61(nStr, "", T("|DIMENSION|"));nStr++;sEmpty61.setReadOnly(1);nStr++;
	
	String sDimensionTypes[]={T("|Tag string|"), T("|Dimension line|"), T("|None|")};
	PropString sDimensionType(nStr, sDimensionTypes, sTab+T("|Dimension type|"), 0);nStr++;
	
	String sRoundOptions[0];
	if(nImperial)
	{
		sRoundOptions.append(T("|Nearest inch|"));
		sRoundOptions.append(T("|Nearest foot|"));
		sRoundOptions.append(T("|Actual dimension|"));
	}
	else
	{
		sRoundOptions.append(T("|Nearest cm|"));
		sRoundOptions.append(T("|Nearest m|"));
		sRoundOptions.append(T("|Actual dimension|"));
	}
	PropString sRoundOption(nStr, sRoundOptions, sTab+T("|Round down options|"), 0);nStr++;

	PropString sDimstyleDimensionLine(nStr, _DimStyles, sTab+T("|Dimension style| "), 0);nStr++;

	PropString sDimColors(nStr, sColors,sTab+T("|Dimension color| "), 4);nStr++;

if(_bOnInsert)
{
	// Insertion
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	
	// Get what's needed for this TSL
	_Element.append(getElement(T("|Select wall|")));
	_PtG.append(getPoint(T("|Select start point|")));
	_PtG.append(getPoint(T("|Select end point|")));
	sStyle.setReadOnly(true);
}

if(_Element.length()==0)
{
	eraseEntity();
	return;
}

Element el=_Element[0];
if(!el.bIsValid())
{
	eraseInstance();
	return;
}

assignToElementGroup(el,1);

CoordSys csEl=el.coordSys();
Point3d ptElOrg=csEl.ptOrg();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();

// Element's lenght
PlaneProfile ppEl(el.plOutlineWall());
LineSeg ls=ppEl.extentInDir(vx);
double dElLength=abs(vx.dotProduct(ls.ptStart()-ls.ptEnd()));
ls=ppEl.extentInDir(vz);
double dElWidth=abs(vz.dotProduct(ls.ptStart()-ls.ptEnd()));// if framed: double dElWidth=el.dBeamWidth();
double dElHeight= ((Wall)el).baseHeight();
Point3d ptElStart= ptElOrg;
Point3d ptElEnd= ptElOrg+vx*dElLength;
Point3d ptElCenter= ptElOrg+vx*dElLength*.5-vz*dElWidth*.5;	

// Realign points to zone 1
_PtG[0]+=vy*vy.dotProduct(ptElOrg-_PtG[0])+vz*vz.dotProduct(ptElOrg-_PtG[0]);
_PtG[1]+=vy*vy.dotProduct(ptElOrg-_PtG[1])+vz*vz.dotProduct(ptElOrg-_PtG[1]);
Point3d pt1= _PtG[0];
Point3d pt2= _PtG[1];
Vector3d vTmpX=(pt2-pt1);
vTmpX.normalize();
_Pt0=pt1+vTmpX*abs(vx.dotProduct(pt2-pt1))*.5;
//if(_PtG.length()==2)
//	_PtG.append(_Pt0-vz*dDistanceFromWall);

// FRAMING TROUGH CONSTRUCTION DIRECTIVES
//Insert a Shear Wall Insert Directive
String sChangeStyle= "Change style";
addRecalcTrigger(_kContext, sChangeStyle);

if( _bOnInsert || _kExecuteKey == sChangeStyle || _bOnRecalc )
{
	String sAssemblyFolder					=	"\\Utilities\\hsbFramingDefaultsEditor";
	String sAssembly							=	"\\hsbFramingDefaults.Shearwalls.dll";
	String sAssemblyPath 					=	sInstallationPath+sAssemblyFolder+sAssembly;
	String sNameSpace						=	"hsbSoft.FramingDefaults.Shearwalls.Models";
	String sClass								=	"ShearwallAccessInTSL";
	String sClassName						=	sNameSpace+"."+sClass;
	String sGetShearwallStyleNamesFunction	=	"GetShearwallStyleNames";
	String sGetShearwallStyleMapFunction		=	"GetShearwallStyleMap";
	String sEditShearwallStyleFunction			=	"EditShearwallStyle";

	Map mapIn=_Map.getMap("mapNewStyleMap");
	mapIn.setString("CompanyPath", sCompanyPath);
	mapIn.setString("StickFramePath", sStickFramePath);

	// Get new style and set it to prop.
	Map mapNewStyleMap;
	if(_bOnInsert || _kExecuteKey == sChangeStyle)
	{
		mapNewStyleMap=callDotNetFunction2(sAssemblyPath, sClassName, sEditShearwallStyleFunction, mapIn);
	}
	else
	{
		mapNewStyleMap=mapIn;
	}
	
	if(mapNewStyleMap.length()==0)
	{
		if(_bOnInsert)
			eraseInstance();
	}
	else
	{
		_Map.setMap("mapNewStyleMap",mapNewStyleMap);
		sStyle.set(mapNewStyleMap.getString("Name"));
		_Map.setString("STYLENAME",mapNewStyleMap.getString("Name"));	
		mapIn.setString("STYLENAME", sStyle);	

		// Get map from selected style
		Map StyleMapFromDlg= callDotNetFunction2(sAssemblyPath, sClassName, sGetShearwallStyleMapFunction, mapIn);
	
		Map mapShearWallInsert;
		mapShearWallInsert.setPoint3d("PtStart", pt1);
		mapShearWallInsert.setPoint3d("PtEnd", pt2);
		mapShearWallInsert.setString("StyleName", sStyle);
		mapShearWallInsert.setMap("StyleMap", StyleMapFromDlg);
		_Map.setMap("mapShearWallInsert",mapShearWallInsert);
	
		// SETTING DISPLAY PROPS FROM MAP
		String sPath="STYLEMAP\\DISPLAYTAG\\";
		
		sNote.set(mapShearWallInsert.getString(sPath+"NOTE"));
		int nSymbolColorIndex=nColors.find(mapShearWallInsert.getInt(sPath+"SYMBOLCOLOR"),0);sSymbolColor.set(sColors[nSymbolColorIndex]);
		int nShapeIndex=mapShearWallInsert.getInt(sPath+"TAGSHAPE");sShape.set(sShapes[nShapeIndex]);
		dDistanceFromWall.set(mapShearWallInsert.getDouble(sPath+"OFFSETFROMWALLHATCHDEPTH"));
		sDisplayP1P2.set(sNoYes[mapShearWallInsert.getInt(sPath+"DISPLAYSTARTANDENDPOINTS")]);
		sDisplayType.set(sDisplayTypes[mapShearWallInsert.getInt(sPath+"DISPLAY")]);
		sDimensionType.set(sDimensionTypes[mapShearWallInsert.getInt(sPath+"DIMENSIONTYPE")]);
		sRoundOption.set(sRoundOptions[mapShearWallInsert.getInt(sPath+"ROUNDDOWNOPTION")]);
		int nDimensionColorIndex=nColors.find(mapShearWallInsert.getInt(sPath+"DIMENSIONCOLOR"),0);sDimColors.set(sColors[nDimensionColorIndex]);
		// DONE SETTING DISPLAY PROPS FROM MAP

		reportMessage("\n"+T("|Message from|")+" "+ _ThisInst.scriptName()  +" TSL: "+ T("|Wall|")+" "+_Element[0].code()+"-"+ _Element[0].number()+" "+T("|must be framed to apply changes|")+"\n");
	}
}

Map mapShearWallInsert=_Map.getMap("mapShearWallInsert");

ElemConstructionMap cdShearwallInsert("ElementShearwallInsertDirective", mapShearWallInsert);
el.addTool(cdShearwallInsert);
// DONE FRAMING

int nSymbolColor=nColors[sColors.find(sSymbolColor,4)];
int nShape=sShapes.find(sShape,1);
int nDisplayP1P2=sNoYes.find(sDisplayP1P2,1);
int nDisplayType=sDisplayTypes.find(sDisplayType,1);
int nDimensionType=sDimensionTypes.find(sDimensionType,0);
int nRoundOption=sRoundOptions.find(sRoundOption,0);
int sDimColor=nColors[sColors.find(sDimColors,-1)];

// START DISPLAYING
Display dp(-1);
dp.addHideDirection(vz);
dp.addHideDirection(-vz);
dp.addHideDirection(vx);
dp.addHideDirection(-vx);
dp.color(nSymbolColor);
dp.dimStyle(sDimstyleSymbol);
Point3d ptPointOnDimLine;

// Vectors to align text
Vector3d vTextX, vTextY;
vTextX=vx; vTextY=-vz;

if(vx.dotProduct(_XW)<0)
{
	vTextX=-vTextX;
	vTextY=-vTextY;
}
else if(vx.dotProduct(_XW)==0)
{
	vTextX=_YW;
	vTextY=-_XW;
}

// DISPLAY: symbol
// Start/end points
if(nDisplayP1P2)
{
	dp.draw("P1", pt1+vz*(dDistanceFromWall+ dp.textHeightForStyle("X", sDimstyleSymbol)) , vTextX, vTextY,0,0);//vx, -vz, 0, 0);		
	dp.draw("P2", pt2+vz*(dDistanceFromWall+ dp.textHeightForStyle("X", sDimstyleSymbol)) , vTextX, vTextY,0,0);//, vx, -vz, 0, 0);		
	double dRadius=U(15,.5);
	PLine plCircle1; plCircle1.createCircle(pt1,vy,dRadius);
	dp.draw(plCircle1);
	PLine plCircle2; plCircle2.createCircle(pt2,vy,dRadius);
	dp.draw(plCircle2);
	ptPointOnDimLine=_Pt0;
}
// Hatch
if(nDisplayType==0)
{
	Hatch hatch( "LINE", U(35, 1.5));hatch.setAngle(-45);
	PLine plHatch; plHatch.createRectangle(LineSeg(pt1, pt2+vz*dDistanceFromWall), vx, vz);
	PlaneProfile ppHatch(plHatch);
	dp.draw(ppHatch,hatch);
	dp.draw(plHatch);
	ptPointOnDimLine=_Pt0+vz*dDistanceFromWall;
}

// Dashed line
else if(nDisplayType==1)
{
	PLine plLine(pt1+vz*dDistanceFromWall, pt2+vz*dDistanceFromWall);
	dp.lineType("DASHED");
	dp.draw(plLine);
	ptPointOnDimLine=_Pt0+vz*dDistanceFromWall;
	dp.lineType("");
}

// Tag
String sTag= sStyle;
Point3d ptTxt=_Pt0+vz*dDistanceFromWall;

double dRectLenght=dp.textLengthForStyle(sTag,sDimstyleSymbol)*1.2;
double dRectHeight=dp.textHeightForStyle("X",sDimstyleSymbol);
Point3d ptLB=ptTxt-vx*dRectLenght*.5-vz*dRectHeight*.5;
Point3d ptRT=ptTxt+vx*dRectLenght*.5+vz*dRectHeight*.5;
double dRadius=sqrt ( pow((dRectLenght*.5),2) + pow((dRectHeight*.5),2));
double dDistFromVertexToCenter;

PLine plSymbol;
Point3d ptVertex;

if(nShape==0) // Triangle
{
	double dTriangleSide=2*dRadius/tan(30);
	dDistFromVertexToCenter=dRadius/sin(30);
	ptTxt+=vz*dDistFromVertexToCenter;
	ptVertex= ptTxt+vz*dRadius;
	plSymbol.addVertex(ptVertex);
	ptPointOnDimLine=ptVertex;
	ptVertex-=vx*dTriangleSide*.5;
	plSymbol.addVertex(ptVertex);
	ptVertex+=vx*dTriangleSide;
	plSymbol.addVertex(ptVertex);
	plSymbol.addVertex(_Pt0+vz*dDistanceFromWall);
	ptVertex= ptTxt+vz*dRadius;
	ptVertex-=vx*dTriangleSide*.5;
	plSymbol.addVertex(ptVertex);
	dp.draw(sTag, ptTxt-vx*dp.textLengthForStyle("X",sDimstyleSymbol)*.25 , vTextX, vTextY,0,0);
	dp.draw(plSymbol);
}	

if(nShape==1) // Diamond
{
	double dDiamondDiag= 2*sqrt(pow(dRadius,2)*2);
	dDistFromVertexToCenter=dDiamondDiag*.5;
	ptTxt+=vz*dDiamondDiag*.5;
	ptVertex=_Pt0+vz*dDistanceFromWall;
	plSymbol.addVertex(ptVertex);
	ptVertex+=-vx*dDiamondDiag*.5+vz*dDiamondDiag*.5;
	plSymbol.addVertex(ptVertex);
	ptVertex+=vx*dDiamondDiag*.5+vz*dDiamondDiag*.5;
	plSymbol.addVertex(ptVertex);
	ptPointOnDimLine=ptVertex;
	ptVertex+=vx*dDiamondDiag*.5-vz*dDiamondDiag*.5;
	plSymbol.addVertex(ptVertex);
	plSymbol.close();
	dp.draw(sTag, ptTxt-vx*dp.textLengthForStyle("X",sDimstyleSymbol)*.25 , vTextX, vTextY,0,0);
	dp.draw(plSymbol);
}

// DISPLAY: Dimension tag/lines
dp.dimStyle(sDimstyleDimensionLine);
dp.color(sDimColor);
	
double dDimension=abs(vx.dotProduct(pt1-pt2));
String sDimension;
if(nImperial)
{
	if(nRoundOption==0) // Nearest inch
	{
		int nDimension=dDimension;
		sDimension.formatUnit(nDimension, _kLength);
		sDimension+=" min";
	}
	else if(nRoundOption==1) // Nearest foot
	{
		int nDimension=dDimension;
		int nMod=nDimension%12;
		nDimension=nDimension-nMod;
		sDimension.formatUnit(nDimension, _kLength);	
		sDimension+=" min";
	}
	else
		sDimension.formatUnit(dDimension, _kLength);			
}
else
{
	if(nRoundOption==0) // Nearest cm
	{
		int nDimension=dDimension;
		int nMod=nDimension%10;
		nDimension=nDimension-nMod;
		sDimension.formatUnit(nDimension, _kLength);	
		sDimension+=" min";
	}
	else if(nRoundOption==1) // Nearest m
	{
		int nDimension=dDimension;
		int nMod=nDimension%1000;
		nDimension=nDimension-nMod;
		sDimension.formatUnit(nDimension, _kLength);	
		sDimension+=" min";
	}
	else
		sDimension.formatUnit(dDimension, _kLength);	
}

double dOffsetForDimLine=dDistanceFromWall*2;
ptPointOnDimLine+=vz*dOffsetForDimLine;

if(_PtG.length()==2)
{
	Point3d pt=ptPointOnDimLine+vx*vx.dotProduct(_Pt0-ptPointOnDimLine)+vz*dp.textHeightForStyle("X",sDimstyleDimensionLine);
	_PtG.append(pt);
}
	
if(nDimensionType==0) // Tag string 
{
	// Relocate if too close to wall
	double dMinDistToWall=dp.textHeightForStyle("X",sDimstyleDimensionLine);
	if(abs(vz.dotProduct(_PtG[2]-_Pt0)<dMinDistToWall))
		_PtG[2]+=vz*vz.dotProduct((_Pt0+vz*dMinDistToWall)-_PtG[2]);
		
	dp.draw(sDimension, _PtG[2], vTextX, vTextY,0,0,_kDevice);
}

if(nDimensionType==1) // Dimension lines
{	
	DimLine dimLn(_PtG[2], vTextX, vTextY);
	Dim dim(dimLn, pt1, pt2, sDimension);
	dim.setDeltaOnTop(1);
	if(vz.dotProduct(_YW)<0 || (vx.isParallelTo(_YW) && vz.dotProduct(_XW)>0) )
		dim.setDeltaOnTop(0);
	dp.draw(dim);
	_PtG[2]+=vx*vx.dotProduct(_Pt0-_PtG[2]);
}

if(sNote!="") // NOTE
{
	if(nDimensionType<2) // Any but NONE
	{
		if (nDimensionType==0)  // Tag string
		{
			dp.draw(sNote, _PtG[2]+vz*dp.textHeightForStyle("X",sDimstyleDimensionLine)*1.5, vTextX, vTextY,0,0,_kDevice);
		}
		else // dimension line
			dp.draw(sNote, _PtG[2]+vz*dp.textHeightForStyle("X",sDimstyleDimensionLine)*2.5 , vTextX, vTextY,0,0,_kDevice);		
	}
	else
		dp.draw(sNote, _PtG[2], vTextX, vTextY,0,0, _kDevice);
}

if(nDisplayType==2 && !nDisplayP1P2&&nShape == 2 && nDimensionType==2) // No symbol, no dimension, need display something or it will dissapear
{	
	_PtG[2]=_Pt0;
	double dRadius=U(15,.5);
	PLine plCircle1; plCircle1.createCircle(pt1,vy,dRadius);
	dp.draw(plCircle1);
	PLine plCircle2; plCircle2.createCircle(pt2,vy,dRadius);
	dp.draw(plCircle2);
}	

// Make sure that dimension line grip point is always available (not same as _Pt0
double dMin=U(25,1);
if(abs(vz.dotProduct(_Pt0-_PtG[2])) < dMin)
	_PtG[2]=_Pt0+vz*dMin;
// Done displaying

// Adding values for ACA schedules
Map mapSchedulePropertySet;

// Define units to display
int nLunit, nPrec;
if(nImperial)
{
	nLunit=4;
	nPrec=3;
}
else
{
	nLunit=2;
	nPrec=2;
}

//	STYLENAME
mapSchedulePropertySet.setString("Stylename", mapShearWallInsert.getString("STYLENAME").trimLeft().trimRight());

//	MAX. SHEAR
mapSchedulePropertySet.setString("MaxShear", "N/A");

//	SILL ANCHOR BOLTS
double dAnchorType=mapShearWallInsert.getString("STYLEMAP\BOTTOMPLATEANCHORS\ANCHORHARDWARE\TYPE").atof(_kLength);
String sAnchorType;sAnchorType.formatUnit(dAnchorType,nLunit,nPrec);
double dSpacingAnchor=mapShearWallInsert.getDouble("STYLEMAP\BOTTOMPLATEANCHORS\SPACING");
String sSpacingAnchor;sSpacingAnchor.formatUnit(dSpacingAnchor,nLunit,nPrec);
if (dSpacingAnchor > 0)
{
	mapSchedulePropertySet.setDouble("SillAnchorBoltsSpacing", dSpacingAnchor);
	mapSchedulePropertySet.setString("SillAnchorBolts", sAnchorType + " @ " + sSpacingAnchor);
}
else
{
	mapSchedulePropertySet.setString("SillAnchorBolts", "-");
	mapSchedulePropertySet.setDouble("SillAnchorBoltsSpacing", U(0));
}
//	MINIMUM SILL THICKNESS
mapSchedulePropertySet.setString("MinimumSillThickness", mapShearWallInsert.getInt("STYLEMAP\BOTTOMPLATEREPLACEMENT\QUANTITY")+"x");

// START COMPRESSION POST
String sStartCompressionPostType= mapShearWallInsert.getMap("STYLEMAP\\STARTCOMPRESSIONPOST").getMapName().trimLeft().trimRight();;
String sStartCompressionTieDownAnchorRod, sStartCompPostMinimumEndPost, sStartCompPostTieDownsOrHoldowns;
if( sStartCompressionPostType=="TIE_DOWN_SYSTEM")
{
	// TIE DOWN ANCHOR ROD
	double dStartTieDownRodDiameter=(mapShearWallInsert.getString("STYLEMAP\\STARTCOMPRESSIONPOST\RODHARDWARE\TYPE").trimLeft().trimRight()).atof(_kLength);
	String sStartTieDownRodDiameter;sStartTieDownRodDiameter.formatUnit(dStartTieDownRodDiameter, nLunit, nPrec);
	String sStartTieDownRodModel=mapShearWallInsert.getString("STYLEMAP\\STARTCOMPRESSIONPOST\RODHARDWARE\MODEL").trimLeft().trimRight();
	double dStartTieDownRodEmbedment=mapShearWallInsert.getDouble("STYLEMAP\\STARTCOMPRESSIONPOST\RODEMBEDMENT");
	double dStartTieDownRodExtension=mapShearWallInsert.getDouble("STYLEMAP\\STARTCOMPRESSIONPOST\RODEXTENSION");
	double dStartTieDownRodHeight= dElHeight+dStartTieDownRodEmbedment+dStartTieDownRodExtension;
	String sStartTieDownRodHeight;sStartTieDownRodHeight.formatUnit(dStartTieDownRodHeight,nLunit, nPrec);
	sStartCompressionTieDownAnchorRod=sStartTieDownRodDiameter+" x "+sStartTieDownRodHeight;
	
	// MINIMUM END POST
	String sStartTieDownLeftPostDetail=mapShearWallInsert.getString("STYLEMAP\\STARTCOMPRESSIONPOST\LEFTPOSTDETAILNAME").trimLeft().trimRight();
	String sStartTieDownRightPostDetail=mapShearWallInsert.getString("STYLEMAP\\STARTCOMPRESSIONPOST\RIGHTPOSTDETAILNAME").trimLeft().trimRight();
	if(sStartTieDownLeftPostDetail==sStartTieDownRightPostDetail)
	{
		if(sStartTieDownLeftPostDetail!="")
		{
			sStartCompPostMinimumEndPost="(2) "+sStartTieDownLeftPostDetail;
		}
		else
		{
			sStartCompPostMinimumEndPost=T("|NONE|");
		}
	}
	else
	{
		if(sStartTieDownLeftPostDetail!="")
		{
			sStartCompPostMinimumEndPost=sStartTieDownLeftPostDetail;
			if(sStartTieDownRightPostDetail!="")
			{
				sStartCompPostMinimumEndPost+=" / "+sStartTieDownRightPostDetail;
			}
		}
		else
		{
			if(sStartTieDownRightPostDetail!="")
			{
				sStartCompPostMinimumEndPost=sStartTieDownRightPostDetail;
			}
		}
	}
	
	// TIE-DOWN/HOLDOWNS
	sStartCompPostTieDownsOrHoldowns=sStartTieDownRodDiameter+" "+sStartTieDownRodModel;
}
else if(sStartCompressionPostType=="POST_WITH_HARDWARE")
{
	// TIE DOWN ANCHOR ROD
	sStartCompressionTieDownAnchorRod="N/A";

	// MINIMUM END POST
	sStartCompPostMinimumEndPost=mapShearWallInsert.getString("STYLEMAP\\STARTCOMPRESSIONPOST\POSTDETAILNAME");
	
	// TIE-DOWN/HOLDOWNS
	String sStartCompressionPostBottomHardwareAndAnchor;
	String sStartCompressionPostBottomHardware=mapShearWallInsert.getString("STYLEMAP\\STARTCOMPRESSIONPOST\BOTTOMHARDWARE\TYPE").trimLeft().trimRight();
	if(sStartCompressionPostBottomHardware!="")
	{
		double dStartCompressionPostBottomAnchorType=(mapShearWallInsert.getString("STYLEMAP\\STARTCOMPRESSIONPOST\BOTTOMHOLDOWNANCHORHARDWARE\TYPE").trimLeft().trimRight()).atof(_kLength);
		String sStartCompressionPostBottomAnchorType;
		if(dStartCompressionPostBottomAnchorType>0)
			sStartCompressionPostBottomAnchorType.formatUnit(dStartCompressionPostBottomAnchorType, nLunit, nPrec);
			
		String sStartCompressionPostBottomAnchorModel=mapShearWallInsert.getString("STYLEMAP\\STARTCOMPRESSIONPOST\BOTTOMHOLDOWNANCHORHARDWARE\MODEL").trimLeft().trimRight();
		String sStartCompressionPostBottomAnchor=sStartCompressionPostBottomAnchorType+" "+sStartCompressionPostBottomAnchorModel;
		sStartCompressionPostBottomAnchor.trimLeft().trimRight();
		sStartCompressionPostBottomHardwareAndAnchor=sStartCompressionPostBottomHardware;
		if(sStartCompressionPostBottomAnchor!="")
			sStartCompressionPostBottomHardwareAndAnchor=sStartCompressionPostBottomHardwareAndAnchor+" + "+sStartCompressionPostBottomAnchor;
	}
	
	String sStartCompressionPostTopHardwareAndAnchor;
	String sStartCompressionPostTopHardware=mapShearWallInsert.getString("STYLEMAP\\STARTCOMPRESSIONPOST\TOPHARDWARE\TYPE").trimLeft().trimRight();
	if(sStartCompressionPostTopHardware!="")
	{
		double dStartCompressionPostTopAnchorType=(mapShearWallInsert.getString("STYLEMAP\\STARTCOMPRESSIONPOST\TOPHOLDOWNANCHORHARDWARE\TYPE").trimLeft().trimRight()).atof(_kLength);
		String sStartCompressionPostTopAnchorType;
		if(dStartCompressionPostTopAnchorType>0)
			sStartCompressionPostTopAnchorType.formatUnit(dStartCompressionPostTopAnchorType, nLunit, nPrec);
			
		String sStartCompressionPostTopAnchorModel=mapShearWallInsert.getString("STYLEMAP\\STARTCOMPRESSIONPOST\TOPHOLDOWNANCHORHARDWARE\MODEL").trimLeft().trimRight();
		String sStartCompressionPostTopAnchor=sStartCompressionPostTopAnchorType+" "+sStartCompressionPostTopAnchorModel;
		sStartCompressionPostTopAnchor.trimLeft().trimRight();

		sStartCompressionPostTopHardwareAndAnchor=sStartCompressionPostTopHardware;
		if(sStartCompressionPostTopAnchor!="")
			sStartCompressionPostTopHardwareAndAnchor=sStartCompressionPostTopHardwareAndAnchor+" + "+sStartCompressionPostTopAnchor;
	}


	if(sStartCompressionPostBottomHardwareAndAnchor==sStartCompressionPostTopHardwareAndAnchor) // Top complete hardware is same than bottom complete hardware
	{
		if(sStartCompressionPostBottomHardwareAndAnchor!="")
		{
			sStartCompPostTieDownsOrHoldowns= "(2) "+ sStartCompressionPostBottomHardwareAndAnchor;
		}
		else
		{
			sStartCompPostTieDownsOrHoldowns=T("|NONE|");
		}
	}
	else
	{
		if(sStartCompressionPostBottomHardwareAndAnchor!="")
		{
			sStartCompPostTieDownsOrHoldowns=sStartCompressionPostBottomHardwareAndAnchor;
			if(sStartCompressionPostTopHardwareAndAnchor!="")
				sStartCompPostTieDownsOrHoldowns=sStartCompPostTieDownsOrHoldowns+" / "+sStartCompressionPostTopHardwareAndAnchor;
		}
		else
			if(sStartCompressionPostTopHardwareAndAnchor!="")
				sStartCompPostTieDownsOrHoldowns=sStartCompressionPostTopHardwareAndAnchor;
	}

}

mapSchedulePropertySet.setString("StartCompPostTieDownAnchorRod",sStartCompressionTieDownAnchorRod);
mapSchedulePropertySet.setString("StartCompPostMinimumEndPost",sStartCompPostMinimumEndPost);
mapSchedulePropertySet.setString("StartCompPostTieDownsOrHoldowns",sStartCompPostTieDownsOrHoldowns);

// END COMPRESSION POST
String sEndCompressionPostType= mapShearWallInsert.getMap("STYLEMAP\\ENDCOMPRESSIONPOST").getMapName().trimLeft().trimRight();
String sEndCompressionTieDownAnchorRod, sEndCompPostMinimumEndPost, sEndCompPostTieDownsOrHoldowns;
if( sEndCompressionPostType=="TIE_DOWN_SYSTEM")
{
	// TIE DOWN ANCHOR ROD
	double dEndTieDownRodDiameter=(mapShearWallInsert.getString("STYLEMAP\\ENDCOMPRESSIONPOST\RODHARDWARE\TYPE").trimLeft().trimRight()).atof(_kLength);
	String sEndTieDownRodDiameter;sEndTieDownRodDiameter.formatUnit(dEndTieDownRodDiameter, nLunit, nPrec);
	String sEndTieDownRodModel=mapShearWallInsert.getString("STYLEMAP\\ENDCOMPRESSIONPOST\RODHARDWARE\MODEL").trimLeft().trimRight();
	double dEndTieDownRodEmbedment=mapShearWallInsert.getDouble("STYLEMAP\\ENDCOMPRESSIONPOST\RODEMBEDMENT");
	double dEndTieDownRodExtension=mapShearWallInsert.getDouble("STYLEMAP\\ENDCOMPRESSIONPOST\RODEXTENSION");
	double dEndTieDownRodHeight= dElHeight+dEndTieDownRodEmbedment+dEndTieDownRodExtension;
	String sEndTieDownRodHeight;sEndTieDownRodHeight.formatUnit(dEndTieDownRodHeight,nLunit, nPrec);
	sEndCompressionTieDownAnchorRod=sEndTieDownRodDiameter+" x "+sEndTieDownRodHeight;
	
	// MINIMUM END POST
	String sEndTieDownLeftPostDetail=mapShearWallInsert.getString("STYLEMAP\\ENDCOMPRESSIONPOST\LEFTPOSTDETAILNAME").trimLeft().trimRight();
	String sEndTieDownRightPostDetail=mapShearWallInsert.getString("STYLEMAP\\ENDCOMPRESSIONPOST\RIGHTPOSTDETAILNAME").trimLeft().trimRight();
	if(sEndTieDownLeftPostDetail==sEndTieDownRightPostDetail)
	{
		if(sEndTieDownLeftPostDetail!="")
		{
			sEndCompPostMinimumEndPost="(2) "+sEndTieDownLeftPostDetail;
		}
		else
		{
			sEndCompPostMinimumEndPost=T("|NONE|");
		}
	}
	else
	{
		if(sEndTieDownLeftPostDetail!="")
		{
			sEndCompPostMinimumEndPost=sEndTieDownLeftPostDetail;
			if(sEndTieDownRightPostDetail!="")
			{
				sEndCompPostMinimumEndPost+=" / "+sEndTieDownRightPostDetail;
			}
		}
		else
		{
			if(sEndTieDownRightPostDetail!="")
			{
				sEndCompPostMinimumEndPost=sEndTieDownRightPostDetail;
			}
		}
	}
	
	// TIE-DOWN/HOLDOWNS
	sEndCompPostTieDownsOrHoldowns=sEndTieDownRodDiameter+" "+sEndTieDownRodModel;
}
else if(sEndCompressionPostType=="POST_WITH_HARDWARE")
{
	// TIE DOWN ANCHOR ROD
	sEndCompressionTieDownAnchorRod="N/A";

	// MINIMUM END POST
	sEndCompPostMinimumEndPost=mapShearWallInsert.getString("STYLEMAP\\ENDCOMPRESSIONPOST\POSTDETAILNAME");
	
	// TIE-DOWN/HOLDOWNS
	String sEndCompressionPostBottomHardwareAndAnchor;
	String sEndCompressionPostBottomHardware=mapShearWallInsert.getString("STYLEMAP\\ENDCOMPRESSIONPOST\BOTTOMHARDWARE\TYPE").trimLeft().trimRight();
	if(sEndCompressionPostBottomHardware!="")
	{
		double dEndCompressionPostBottomAnchorType=(mapShearWallInsert.getString("STYLEMAP\\ENDCOMPRESSIONPOST\BOTTOMHOLDOWNANCHORHARDWARE\TYPE").trimLeft().trimRight()).atof(_kLength);
		String sEndCompressionPostBottomAnchorType;
		if(dEndCompressionPostBottomAnchorType>0)
			sEndCompressionPostBottomAnchorType.formatUnit(dEndCompressionPostBottomAnchorType, nLunit, nPrec);
		
		String sEndCompressionPostBottomAnchorModel=mapShearWallInsert.getString("STYLEMAP\\ENDCOMPRESSIONPOST\BOTTOMHOLDOWNANCHORHARDWARE\MODEL").trimLeft().trimRight();
		String sEndCompressionPostBottomAnchor=sEndCompressionPostBottomAnchorType+" "+sEndCompressionPostBottomAnchorModel;
		sEndCompressionPostBottomAnchor.trimLeft().trimRight();
		sEndCompressionPostBottomHardwareAndAnchor=sEndCompressionPostBottomHardware;
		if(sEndCompressionPostBottomAnchor!="")
			sEndCompressionPostBottomHardwareAndAnchor=sEndCompressionPostBottomHardwareAndAnchor+" + "+sEndCompressionPostBottomAnchor;
	}
	
	String sEndCompressionPostTopHardwareAndAnchor;
	String sEndCompressionPostTopHardware=mapShearWallInsert.getString("STYLEMAP\\ENDCOMPRESSIONPOST\TOPHARDWARE\TYPE").trimLeft().trimRight();
	if(sEndCompressionPostTopHardware!="")
	{
		double dEndCompressionPostTopAnchorType=(mapShearWallInsert.getString("STYLEMAP\\ENDCOMPRESSIONPOST\TOPHOLDOWNANCHORHARDWARE\TYPE").trimLeft().trimRight()).atof(_kLength);
		String sEndCompressionPostTopAnchorType;
		if(dEndCompressionPostTopAnchorType>0)
			sEndCompressionPostTopAnchorType.formatUnit(dEndCompressionPostTopAnchorType, nLunit, nPrec);
			
		String sEndCompressionPostTopAnchorModel=mapShearWallInsert.getString("STYLEMAP\\ENDCOMPRESSIONPOST\TOPHOLDOWNANCHORHARDWARE\MODEL").trimLeft().trimRight();
		String sEndCompressionPostTopAnchor=sEndCompressionPostTopAnchorType+" "+sEndCompressionPostTopAnchorModel;
		sEndCompressionPostTopAnchor.trimLeft().trimRight();

		sEndCompressionPostTopHardwareAndAnchor=sEndCompressionPostTopHardware;
		if(sEndCompressionPostTopAnchor!="")
			sEndCompressionPostTopHardwareAndAnchor=sEndCompressionPostTopHardwareAndAnchor+" + "+sEndCompressionPostTopAnchor;
	}


	if(sEndCompressionPostBottomHardwareAndAnchor==sEndCompressionPostTopHardwareAndAnchor) // Top complete hardware is same than bottom complete hardware
	{
		if(sEndCompressionPostBottomHardwareAndAnchor!="")
		{
			sEndCompPostTieDownsOrHoldowns= "(2) "+ sEndCompressionPostBottomHardwareAndAnchor;
		}
		else
		{
			sEndCompPostTieDownsOrHoldowns=T("|NONE|");
		}
	}
	else
	{
		if(sEndCompressionPostBottomHardwareAndAnchor!="")
		{
			sEndCompPostTieDownsOrHoldowns=sEndCompressionPostBottomHardwareAndAnchor;
			if(sEndCompressionPostTopHardwareAndAnchor!="")
				sEndCompPostTieDownsOrHoldowns=sEndCompPostTieDownsOrHoldowns+" / "+sEndCompressionPostTopHardwareAndAnchor;
		}
		else
			if(sEndCompressionPostTopHardwareAndAnchor!="")
				sEndCompPostTieDownsOrHoldowns=sEndCompressionPostTopHardwareAndAnchor;
	}
}

mapSchedulePropertySet.setString("EndCompPostTieDownAnchorRod",sEndCompressionTieDownAnchorRod);
mapSchedulePropertySet.setString("EndCompPostMinimumEndPost",sEndCompPostMinimumEndPost);
mapSchedulePropertySet.setString("EndCompPostTieDownsOrHoldowns",sEndCompPostTieDownsOrHoldowns);

//	SHEATHING 
double dSheathingThickness=mapShearWallInsert.getDouble("STYLEMAP\SHEATHINGREPLACEMENT\THICKNESS");
String sSheathingThickness; sSheathingThickness.formatUnit(dSheathingThickness,nLunit,nPrec);
mapSchedulePropertySet.setString("SheathingThickness", sSheathingThickness);

String sSheathingMaterial=mapShearWallInsert.getString("STYLEMAP\SHEATHINGREPLACEMENT\MATERIAL");
mapSchedulePropertySet.setString("SheathingMaterial", sSheathingMaterial);

String sSheathingGrade=mapShearWallInsert.getString("STYLEMAP\SHEATHINGREPLACEMENT\GRADE");
mapSchedulePropertySet.setString("SheathingGrade", sSheathingGrade);

String sSheathingTreatment=mapShearWallInsert.getString("STYLEMAP\SHEATHINGREPLACEMENT\TREATMENT");
mapSchedulePropertySet.setString("SheathingTreatment", sSheathingTreatment);

String sSheathing=sSheathingThickness+" "+sSheathingMaterial;
mapSchedulePropertySet.setString("Sheathing", sSheathing);

String sSheathingPanelEdgeFastener=mapShearWallInsert.getString("STYLEMAP\SHEATHINGREPLACEMENT\PANELEDGEFASTENER");
mapSchedulePropertySet.setString("PanelEdgeNailing", sSheathingPanelEdgeFastener);
double dSheathingPanelEdgeSpacing=mapShearWallInsert.getDouble("STYLEMAP\SHEATHINGREPLACEMENT\PANELEDGESPACING");
String sSheathingPanelEdgeSpacing;sSheathingPanelEdgeSpacing.formatUnit(dSheathingPanelEdgeSpacing, nLunit, nPrec);
mapSchedulePropertySet.setString("PanelEdgeSpacing", sSheathingPanelEdgeSpacing);

String sSheathingPanelIntermediateFastener=mapShearWallInsert.getString("STYLEMAP\SHEATHINGREPLACEMENT\PANELINTERMEDIATEFASTENER");
mapSchedulePropertySet.setString("PanelFieldNailing", sSheathingPanelIntermediateFastener);
double dSheathingPanelIntermediateSpacing=mapShearWallInsert.getDouble("STYLEMAP\SHEATHINGREPLACEMENT\PANELINTERMEDIATESPACING");
String sSheathingPanelIntermediateSpacing;sSheathingPanelIntermediateSpacing.formatUnit(dSheathingPanelIntermediateSpacing,nLunit,nPrec);
mapSchedulePropertySet.setString("PanelFieldSpacing", sSheathingPanelIntermediateSpacing);

_ThisInst.createPropSetDefinition("Shearwall", mapSchedulePropertySet, true);

_ThisInst.setAttachedPropSetFromMap("Shearwall", mapSchedulePropertySet); 
_ThisInst.attachPropSet("Shearwall");

el.createPropSetDefinition("Shearwall", mapSchedulePropertySet, true);

el.setAttachedPropSetFromMap("Shearwall", mapSchedulePropertySet); 
el.attachPropSet("Shearwall");
#End
#BeginThumbnail
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
MV3O-R^HI0P/0UP1^'4V/^0[J/_@5+_\`%5N>&O#;Z#)<,]]<W7G*HQ-,[[<9
MZ;B?6A2;W1<92;U1T5%%%6:!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4444`%%%%`!28I:*`$Q12T4`)12T4`)1CVI:*`$Q12T4`)12T4K`)1BEHHL
M`F**,BC(]:+`%+1118!*6BBF`E%&0*,B@`HYHR*,C.*5@"BEHI@)12T4`)BB
MEHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"@]**0\C%`&%K/B)-+U"UL$MWN+JY#,
MD:NJ`*.I+,0*JW/BPV4NEB^L)+);QY%E^T2`&((,YX)!!I/$VBW.JW$)&DZ=
MJ$"(>+B9HI%;/9E!^7&.*H67A'4H/[!%Q+!.EC/-+*K.6"*P^5%R/FQZG%`'
M3?V]I(T_[?\`VA;_`&0ML\W?\N[T^M-/B+2!8"^.H0?9B_E^9NXW>GU]JY0^
M"M06P5%:W\R'4WO$C69D#H1@#>%RK<5+_P`(YK,5F3:0QVTDUWYUU&+YV:9=
MN.92N0<^@Z4`=.-?TDV4=Y_:%O\`9I9?)64OA2_/RY]>#3I-2A;29=0M,74:
M1NZB)L^9MSP/R-<BG@S45T^*W(M?EUE;UE:5F!B'49*Y+5W*V\21>4D2)%@C
M8JX%`'.)XVL))]%B$4A.J*&4A@1'DX`/KSD59MO%6GR0W=Q<.+6WM[IK82RL
M,2.!SBN<@\#:E#9ZA'YT!F0Q_P!FOO/[I4E,G/'&3@\9J\/#FL6GA?3[&TDB
M\])C+>HLY3SMQ)8*^W(&3Z=!0!J:CXGM;>PL[RR:.\BN;Q+8LCXV[CS^(]*G
MT36?[6FU&/R1&;.Z:W^_NW`8YKGH/!^I1V*PG[.&&LK?C,[/MC'8$KRW&/ZU
MN^'M)N],GU62Y,9%W>M/&$8MA3C@Y%`&]1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`44
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`
#'__9
`





#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="0.03937008" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End