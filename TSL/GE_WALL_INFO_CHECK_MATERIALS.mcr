#Version 8
#BeginDescription
Creates a table with wrong values of material or grade based on defaults editor
v1.2: 11.may.2013: David Rueda (dr@hsb-cad.com)
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
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
* v1.2: 11.may.2013: David Rueda (dr@hsb-cad.com)
	- Added sheathing control
* v1.1: 11.may.2013: David Rueda (dr@hsb-cad.com)
	- Changed key creation of beams to compare with lumber items map
	- Added table for materials with no weight definition
	- Description updated
* v1.0: 13.apr.2013: David Rueda (dr@hsb-cad.com)
	Release
*/
double dTolerance=U(0.1,.01);
int bImperial=U(0,1);
int nLunits=U(2,4);
int nPrec=U(2,3);
String sKgLbs, sMeterFoot;
if(bImperial)
{
	sKgLbs="Lbs";
	sMeterFoot="ft";
}
else
{
	sKgLbs="Kg";
	sMeterFoot="m";
}

String sNoYes[]={T("|No|"), T("|Yes|")};
PropString sDimstyle(2, _DimStyles, T("|Dimstyle|"));
PropString sShowPointer(3, sNoYes, T("|Show pointer|"), 1);
int nShowPointer= sNoYes.find( sShowPointer, 1);
PropString sHighlightBeams(4, sNoYes, T("|Highlight beams|"), 0);
int nHighlightBeams= sNoYes.find( sHighlightBeams, 0);
PropInt nBeamInfoColor(0, 4, T("|Beam info color|"));
PropString sHighlightSheets(5, sNoYes, T("|Highlight sheets|"), 0);
int nHighlightSheets= sNoYes.find( sHighlightSheets, 0);
PropInt nSheetInfoColor(1, 3, T("|Sheathing info color|"));
if (nBeamInfoColor> 255 || nBeamInfoColor< -1) 
	nBeamInfoColor.set(3);
if (nSheetInfoColor> 255 || nSheetInfoColor< -1) 
	nSheetInfoColor.set(3);
int nTitleColor=45;
int nFrameColor=23;

if(_bOnInsert){

	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	
	Element el=getElement(T("|Select a wall|"));
	_Element.append(el);
	_Beam=el.beam();
	_Sheet=el.sheet();
	_Pt0 = getPoint("\n"+T("|Select point to create table|"));

	//Setting info
	String sCompanyPath 			= _kPathHsbCompany;
	String sInstallationPath			= _kPathHsbInstall;
	
	String sAssemblyFolder			=	"\\Utilities\\hsbFramingDefaultsEditor";
	String sAssembly					=	"\\hsbFramingDefaults.Inventory.dll ";
	String sAssemblyPath 			=	sInstallationPath+sAssemblyFolder+sAssembly;
	String sNameSpace				=	"hsbSoft.FramingDefaults.Inventory.Interfaces";
	String sClass						=	"InventoryAccessInTSL";
	String sClassName				=	sNameSpace+"."+sClass;
	
	// Filling lumber items
	Map mapIn;
	mapIn.setString("CompanyPath", sCompanyPath);
	mapIn.setString("InstallationPath", sInstallationPath);
	
	String sFunction					=	"GetLumberItems";
	Map mapLumberItems=callDotNetFunction2(sAssemblyPath, sClassName, sFunction, mapIn);
	_Map.setMap("LumberItems",mapLumberItems);

	
	sFunction					=	"GetSheathingItems";
	Map mapSheathingItems=callDotNetFunction2(sAssemblyPath, sClassName, sFunction, mapIn);
	_Map.setMap("SheathingItems",mapSheathingItems);
	
	return;
} // End _bOnInsert

if(_Element.length()==0)
	eraseInstance();
	
Element el=_Element[0];
if(!el.bIsValid())
	eraseInstance();
	
setDependencyOnEntity(el);
assignToElementGroup(el,1);
Vector3d vz=el.coordSys().vecZ();

String sConcatSize="x";
String sConcatGrade="@";

// BEAMS
// Filling lumber items
Map mapLumberItems=_Map.getMap("LumberItems");
String sLumberItemKeys[0];
String sLumberItemNames[0];
String sLumberItemHsbGrades[0];
double dLumberItemHeights[0];
double dLumberItemWidths[0];
double dLumberItemWeightPerWeightLenghts[0];
double dLumberItemWeightLenghts[0];
for( int m=0; m<mapLumberItems.length(); m++)
{
	String sKey= mapLumberItems.keyAt(m);
	String sName= mapLumberItems.getString(sKey+"\NAME").trimLeft().trimRight().makeUpper();
	if( sKey!="" && sName!="")
	{
		sLumberItemKeys.append((mapLumberItems.getDouble(sKey+"\WIDTH")+sConcatSize+mapLumberItems.getDouble(sKey+"\HEIGHT")+sConcatGrade+mapLumberItems.getString(sKey+"\HSB_GRADE").trimLeft().trimRight()).trimLeft().trimRight());
		sLumberItemNames.append(sName);
		sLumberItemHsbGrades.append(mapLumberItems.getString(sKey+"\HSB_GRADE").trimLeft().trimRight().makeUpper());
		dLumberItemHeights.append(mapLumberItems.getDouble(sKey+"\HEIGHT"));
		dLumberItemWidths.append(mapLumberItems.getDouble(sKey+"\WIDTH"));
		dLumberItemWeightPerWeightLenghts.append(mapLumberItems.getDouble(sKey+"\WEIGHTPERWEIGHTLENGTH"));
		dLumberItemWeightLenghts.append( mapLumberItems.getDouble(sKey+"\WEIGHTLENGTH"));
	}
}

// Filling sheathing items
Map mapSheathingItems=_Map.getMap("SheathingItems");
String sSheathingItemKeys[0];
String sSheathingItemNames[0];
String sSheathingItemMaterials[0];
double dSheathingItemThickness[0];
double dSheathingItemWeightPerWeightAreas[0];
double dSheathingItemWeightAreas[0];
for( int m=0; m<mapSheathingItems.length(); m++)
{
	String sKey= mapSheathingItems.keyAt(m);
	String sName= mapSheathingItems.getString(sKey+"\NAME").trimLeft().trimRight().makeUpper();
	if( sKey!="" && sName!="")
	{
		sSheathingItemKeys.append(sKey);
		sSheathingItemNames.append(sName);
		sSheathingItemMaterials.append(mapSheathingItems.getString(sKey+"\MATERIAL\NAME").trimLeft().trimRight().makeUpper());
		dSheathingItemThickness.append(mapSheathingItems.getDouble(sKey+"\THICKNESS"));
		dSheathingItemWeightPerWeightAreas.append(mapSheathingItems.getDouble(sKey+"\WEIGHTPERWEIGHTAREA"));
		dSheathingItemWeightAreas.append(mapSheathingItems.getDouble(sKey+"\WEIGHTAREA"));
	}
}

// COLLECT BEAMS WITH ISSUES
Beam bmGradeIssues[0],bmWeightIssues[0];
for( int b=0; b< _Beam.length(); b++)
{
	Beam bm= _Beam[b];
	int bReportBeam=false;
	
	// Check grade
	String sBmGrade= bm.grade().trimLeft().trimRight().makeUpper();
	if( sBmGrade == "") // Grade is empty
	{
		bReportBeam=true;
	}
	else // Grade is not empty but need to check ITW standard ( material ! grade ! treatment )
	{
		int nIndex=sLumberItemHsbGrades.find(sBmGrade,-1);			
		if(nIndex==-1)
		{
			bReportBeam=true;
		}
		
	}
	if(bReportBeam) // Will be on list already, not need to check weight values
	{
		bmGradeIssues.append(bm);
		continue;
	}
	
	// Check weight values
	bReportBeam=true;
	double dBmHeight, dBmWidth;
	if(bm.dH()>bm.dW())
	{
		dBmHeight=bm.dH();
		dBmWidth=bm.dW();
	}
	else
	{
		dBmHeight=bm.dW();
		dBmWidth=bm.dH();
	}
	
	for( int m=0; m<sLumberItemKeys.length(); m++)
	{
		String sLumberItemGrade= sLumberItemHsbGrades[m];
		if(sLumberItemGrade==sBmGrade) // searching same grade
		{
			double dLumberItemHeight=dLumberItemHeights[m];
			if(abs(dLumberItemHeight-dBmHeight)<dTolerance) // Searching same height
			{
				double dLumberItemWidth=dLumberItemWidths[m];
				if(abs(dLumberItemWidth-dBmWidth)<dTolerance) // Searching same width
				{
					if(dLumberItemWeightPerWeightLenghts[m]>0) // Has a value defined
					{
						bReportBeam=false;
						break;
					}
				}
			}
		}
	}
	if(bReportBeam)
	{
		bmWeightIssues.append(bm);
	}
}

// SHEATHING
Sheet shMaterialIssues[0], shWeightIssues[0];
for(int s=0; s<_Sheet.length();s++)
{
	Sheet sh=_Sheet[s];
	double dThickness=sh.dD(vz);
	int bReportSheet=false;
	
	// Check material
	String sShMaterial= sh.material().trimLeft().trimRight().makeUpper();
	if( sShMaterial == "") // Grade is empty
	{
		bReportSheet=true;
	}
	else // Material is not empty but need to check if define in defaults editor
	{
		int nIndex=sSheathingItemMaterials.find(sShMaterial,-1);			
		if(nIndex==-1)
		{
			bReportSheet=true;
		}
		
	}
	if(bReportSheet) // Will be on list already, not need to check weight values
	{
		shMaterialIssues.append(sh);
		continue;
	}
	
	//Check weight values
	bReportSheet=true;
	for(int m=0;m<sSheathingItemKeys.length();m++)
	{
		String sSheathingItemMaterial=sSheathingItemMaterials[m];
		if(sSheathingItemMaterial==sShMaterial) // Has material defined
		{
			double dSheathingItemThicknes=dSheathingItemThickness[m];
			if(abs(dSheathingItemThicknes-dThickness)<dTolerance) // Has thickness defined
			{
				if(dSheathingItemWeightPerWeightAreas[m]>0) // Has weight value defined
				{
					bReportSheet=false;
					break;
				}
			}
		}
	}
	
	if(bReportSheet)
	{
		shWeightIssues.append(sh);
	}
}

if( _bOnElementDeleted)
	eraseInstance();

if( bmGradeIssues.length()==0 && bmWeightIssues.length()==0 && shMaterialIssues.length()==0 && shWeightIssues.length()==0 )
{
	reportNotice("\n"+T("|No issues found|"));
	eraseInstance();
	return;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	 DISPLAY  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CREATE TABLE
Vector3d vx= _XW;
Vector3d vy= _YW;

Display dp(nBeamInfoColor);
dp.dimStyle( sDimstyle);

// Horizontal and vertical offsets
double dHOff=dp.textHeightForStyle( "A", sDimstyle);
double dVOff= dHOff;

Point3d ptNewStart=_Pt0;
Point3d ptBottom=ptNewStart;

// Width for external rectangle
String sHeader=T("|BEAMS WITH NOT VALID GRADE FOR DEFAULTS EDITOR|");
double dExtRecW;
dExtRecW= dp.textLengthForStyle( sHeader, sDimstyle);
dExtRecW+= dHOff*2;
Point3d ptLeft= _Pt0+ vx* dHOff; // Starting point to write text

Point3d ptLn; // Starting point for each line
ptLn= ptNewStart; // Starting point for each line
//ptLn+= vx*vx.dotProduct( ptLeft- ptLn) - vy*dHOff*1.5;

// Draw title
Display dpT(0);
dpT.dimStyle( sDimstyle);
String sTitle=T("               |WALL|")+" "+el.code()+"-"+el.number();
Point3d ptTitle= ptNewStart+vx*dHOff - vy*dVOff;
dpT.draw( sTitle, ptTitle, vx, vy, 1, 0);
LineSeg ls0(ptLn-vy*dVOff*2, ptLn+vx*dExtRecW-vy*dVOff*2);
dp.draw(ls0);
ptLn+= -vy*dHOff*2;
ptNewStart=ptLn;
String sColType[0], sColGrade[0];

// TABLE FOR GRADE ISSUES ON BEAMS
if(bmGradeIssues.length()>0 )
{
	// Draw header
	Point3d ptHdr= ptNewStart+vx*dHOff - vy*dVOff;
	dp.draw( sHeader, ptHdr, vx, vy, 1, 0);
	LineSeg ls1(ptLn-vy*dVOff*2, ptLn+vx*dExtRecW-vy*dVOff*2);
	dp.draw(ls1);
	
	sColType.append(T("|TYPE|"));
	sColGrade.append(T("|ASSIGNED VALUE|"));
	for( int b=0; b< bmGradeIssues.length(); b++)
	{
		Beam bm= bmGradeIssues[b];
		sColType.append(bm.name("type"));
		if( bm.grade()=="")
			sColGrade.append("   "+T("|EMPTY|"));
		else
			sColGrade.append(bm.grade());
	}
}

ptLn-= vy*dVOff*1.5;

double dColW= dp.textLengthForStyle( sHeader, sDimstyle)/3;

for( int s=0; s< sColType.length(); s++)
{
	if (s==0)
		ptLn+= vx*vx.dotProduct( ptLeft- ptLn) - vy*dHOff*1.5;
	else
		ptLn+= vx*vx.dotProduct( ptLeft- ptLn) - vy*dHOff*2;

	// Draw pointer
	if(s>0)
	{
		Beam bm= bmGradeIssues[s-1];
		PLine plPointer (ptLn-vx*dHOff, bm.ptCen());
		if(nShowPointer)
		{
			dp.draw( plPointer);
			// Draw 'X' at beam ends
			Vector3d vBmX=bm.vecX();
			Vector3d vBmY=bm.vecY();
			Vector3d vBmZ=bm.vecZ();
			Point3d ptBmCen=bm.ptCen();
			double dBmW=bm.dD(vBmY);
			double dBmH=bm.dD(vBmZ);

			Point3d ptEnd1=ptBmCen+vBmX*bm.dL()*.5;
			PLine pl1;
			pl1.addVertex(ptEnd1+vBmY*dBmW*.5+vBmZ*dBmH*.5);
			pl1.addVertex(ptEnd1);
			pl1.addVertex(ptEnd1-vBmY*dBmW*.5-vBmZ*dBmH*.5);
			pl1.addVertex(ptEnd1);
			pl1.addVertex(ptEnd1-vBmY*dBmW*.5+vBmZ*dBmH*.5);
			pl1.addVertex(ptEnd1);
			pl1.addVertex(ptEnd1+vBmY*dBmW*.5-vBmZ*dBmH*.5);
			dp.draw(pl1);

			Point3d ptEnd2=ptBmCen-vBmX*bm.dL()*.5;
			PLine pl2;
			pl2.addVertex(ptEnd2+vBmY*dBmW*.5+vBmZ*dBmH*.5);
			pl2.addVertex(ptEnd2);
			pl2.addVertex(ptEnd2-vBmY*dBmW*.5-vBmZ*dBmH*.5);
			pl2.addVertex(ptEnd2);
			pl2.addVertex(ptEnd2-vBmY*dBmW*.5+vBmZ*dBmH*.5);
			pl2.addVertex(ptEnd2);
			pl2.addVertex(ptEnd2+vBmY*dBmW*.5-vBmZ*dBmH*.5);
			dp.draw(pl2);
		}
		if(nHighlightBeams)
			dp.draw( bm.envelopeBody());
		// Draw line along X axis of beam
		PLine plX(bm.ptCen()+bm.vecX()*bm.dL()*.5,bm.ptCen()-bm.vecX()*bm.dL()*.5);
		dp.draw(plX);
	}	
	dp.draw( sColType[s], ptLn, vx, vy, 1, 0);
	dp.draw( sColGrade[s], ptLn+vx*dColW*1.5, vx, vy, 1, 0);
	LineSeg ls1(ptLn+vx*vx.dotProduct(_Pt0-ptLn)-vy*dVOff , ptLn+vx*(dExtRecW-dHOff)-vy*dVOff);
	dp.draw(ls1);
	ptBottom= ptLn+vx*(dExtRecW-dHOff)-vy*dVOff;
}

if(bmGradeIssues.length()>0 )
{
	dp.color(nFrameColor);
	PLine plExtRect;
	plExtRect.createRectangle(LineSeg( _Pt0, ptBottom), vx, vy);
	dp.draw( plExtRect);
	dp.color(nBeamInfoColor);
}

// TABLE FOR WEIGHT ISSUES ON BEAMS
ptNewStart=_Pt0;
if(bmGradeIssues.length()>0)
	ptNewStart+=_YW*_YW.dotProduct(ptBottom-ptNewStart);

ptBottom=ptNewStart;
ptLn= ptNewStart; // Starting point for each line

sHeader=T("     |BEAMS WITH UNDEFINED WEIGHT VALUES|");

sColType.setLength(0);
sColGrade.setLength(0);
if(bmWeightIssues.length()>0 )
{
	// Draw header
	Point3d ptHdr= ptNewStart+vx*dHOff - vy*dVOff;
	
	dp.draw( sHeader, ptHdr, vx, vy, 1, 0);
	LineSeg ls1(ptLn-vy*dVOff*2, ptLn+vx*dExtRecW-vy*dVOff*2);
	dp.draw(ls1);
	
	sColType.append(T("|TYPE|"));
	sColGrade.append(T("|MATERIAL|"));
	for( int b=0; b< bmWeightIssues.length(); b++)
	{
		Beam bm= bmWeightIssues[b];
		sColType.append(bm.name("type"));
		sColGrade.append("   "+bm.grade());
	}
}	

ptLeft= _Pt0+ vx* dHOff; // Starting point to write text
ptLn-= vy*dVOff*1.5;

for( int s=0; s< sColType.length(); s++)
{
	if (s==0)
		ptLn+= vx*vx.dotProduct( ptLeft- ptLn) - vy*dHOff*1.5;
	else
		ptLn+= vx*vx.dotProduct( ptLeft- ptLn) - vy*dHOff*2;

	// Draw pointer
	if(s>0)
	{
		Beam bm= bmWeightIssues[s-1];
		PLine plPointer (ptLn-vx*dHOff, bm.ptCen());
		if(nShowPointer)
		{
			dp.draw( plPointer);
			// Draw 'X' at beam ends
			Vector3d vBmX=bm.vecX();
			Vector3d vBmY=bm.vecY();
			Vector3d vBmZ=bm.vecZ();
			Point3d ptBmCen=bm.ptCen();
			double dBmW=bm.dD(vBmY);
			double dBmH=bm.dD(vBmZ);

			Point3d ptEnd1=ptBmCen+vBmX*bm.dL()*.5;
			PLine pl1;
			pl1.addVertex(ptEnd1+vBmY*dBmW*.5+vBmZ*dBmH*.5);
			pl1.addVertex(ptEnd1);
			pl1.addVertex(ptEnd1-vBmY*dBmW*.5-vBmZ*dBmH*.5);
			pl1.addVertex(ptEnd1);
			pl1.addVertex(ptEnd1-vBmY*dBmW*.5+vBmZ*dBmH*.5);
			pl1.addVertex(ptEnd1);
			pl1.addVertex(ptEnd1+vBmY*dBmW*.5-vBmZ*dBmH*.5);
			dp.draw(pl1);

			Point3d ptEnd2=ptBmCen-vBmX*bm.dL()*.5;
			PLine pl2;
			pl2.addVertex(ptEnd2+vBmY*dBmW*.5+vBmZ*dBmH*.5);
			pl2.addVertex(ptEnd2);
			pl2.addVertex(ptEnd2-vBmY*dBmW*.5-vBmZ*dBmH*.5);
			pl2.addVertex(ptEnd2);
			pl2.addVertex(ptEnd2-vBmY*dBmW*.5+vBmZ*dBmH*.5);
			pl2.addVertex(ptEnd2);
			pl2.addVertex(ptEnd2+vBmY*dBmW*.5-vBmZ*dBmH*.5);
			dp.draw(pl2);
		}		if(nHighlightBeams)
			dp.draw( bm.envelopeBody());
		// Draw line along X axis of beam
		PLine plX(bm.ptCen()+bm.vecX()*bm.dL()*.5,bm.ptCen()-bm.vecX()*bm.dL()*.5);
		dp.draw(plX);
	}

	dp.draw( sColType[s], ptLn, vx, vy, 1, 0);
	dp.draw( sColGrade[s], ptLn+vx*dColW*1.5, vx, vy, 1, 0);
	LineSeg ls1(ptLn+vx*vx.dotProduct(_Pt0-ptLn)-vy*dVOff , ptLn+vx*(dExtRecW-dHOff)-vy*dVOff);
	dp.draw(ls1);
	ptBottom= ptLn+vx*(dExtRecW-dHOff)-vy*dVOff;
}

if(bmWeightIssues.length()>0 )
{
	dp.color(nFrameColor);
	PLine plExtRect;
	plExtRect.createRectangle(LineSeg( _Pt0, ptBottom), vx, vy);
	dp.draw( plExtRect);
	dp.color(nBeamInfoColor);
}

// TABLE FOR MATERIAL ISSUES ON SHEATHING
dp.color(nSheetInfoColor);
ptNewStart=_Pt0;
if(bmGradeIssues.length()>0 || bmWeightIssues.length()>0)
	ptNewStart+=_YW*_YW.dotProduct(ptBottom-ptNewStart);

ptBottom=ptNewStart;
ptLn= ptNewStart; // Starting point for each line

sHeader=T("      |SHEATHING WITH NOT VALID MATERIAL|");

sColType.setLength(0);
sColGrade.setLength(0);
if(shMaterialIssues.length()>0 )
{
	// Draw header
	Point3d ptHdr= ptNewStart+vx*dHOff - vy*dVOff;
	
	dp.draw( sHeader, ptHdr, vx, vy, 1, 0);
	LineSeg ls1(ptLn-vy*dVOff*2, ptLn+vx*dExtRecW-vy*dVOff*2);
	dp.draw(ls1);
	
	sColType.append(T("|SHEATHING DETAILS|"));
	sColGrade.append(T("|MATERIAL|"));
	for( int s=0; s< shMaterialIssues.length(); s++)
	{
		Sheet sh= shMaterialIssues[s];
		PlaneProfile ppSh=sh.profShape();
		double dArea=ppSh.area();
		String sArea;sArea.format("%.2f",dArea/U(1000000000,1728));
		sArea+=" sq."+sMeterFoot+".";
		double dThickness=sh.dD(el.vecZ());
		String sThickness;sThickness.formatUnit(dThickness, nLunits, nPrec);
		String sDetails=sArea+", "+T("|Th|")+":"+sThickness;
		sColType.append(sDetails);
		if(sh.material()!="")
			sColGrade.append("   "+sh.material());
		else
			sColGrade.append("   EMTPY");
	}
}	

ptLeft= _Pt0+ vx* dHOff; // Starting point to write text
ptLn-= vy*dVOff*1.5;

for( int s=0; s< sColType.length(); s++)
{
	if (s==0)
		ptLn+= vx*vx.dotProduct( ptLeft- ptLn) - vy*dHOff*1.5;
	else
		ptLn+= vx*vx.dotProduct( ptLeft- ptLn) - vy*dHOff*2;

	// Draw pointer
	if(s>0)
	{
		Sheet sh= shMaterialIssues[s-1];
		Point3d ptShCen=sh.ptCen();
		Vector3d vElX=el.coordSys().vecX();
		Vector3d vElY=el.coordSys().vecY();
		PLine plPointer (ptLn-vx*dHOff, ptShCen);
		if(nShowPointer)
		{
			dp.draw( plPointer);
			// Draw '+' on sheathing
			double dCrossSide=U(50,2);
			PLine pl1;
			pl1.addVertex(ptShCen+vElX*dCrossSide*.5);
			pl1.addVertex(ptShCen);
			pl1.addVertex(ptShCen-vElX*dCrossSide*.5);
			pl1.addVertex(ptShCen);
			pl1.addVertex(ptShCen+vElY*dCrossSide*.5);
			pl1.addVertex(ptShCen);
			pl1.addVertex(ptShCen-vElY*dCrossSide*.5);
			dp.draw(pl1);
		}		
		if(nHighlightSheets)
			dp.draw( sh.envelopeBody());
	}

	dp.draw( sColType[s], ptLn, vx, vy, 1, 0);
	dp.draw( sColGrade[s], ptLn+vx*dColW*1.5, vx, vy, 1, 0);
	LineSeg ls1(ptLn+vx*vx.dotProduct(_Pt0-ptLn)-vy*dVOff , ptLn+vx*(dExtRecW-dHOff)-vy*dVOff);
	dp.draw(ls1);
	ptBottom= ptLn+vx*(dExtRecW-dHOff)-vy*dVOff;
}

if(shMaterialIssues.length()>0 )
{
	dp.color(nFrameColor);
	PLine plExtRect;
	plExtRect.createRectangle(LineSeg( _Pt0, ptBottom), vx, vy);
	dp.draw( plExtRect);
	dp.color(nSheetInfoColor);
}

// TABLE FOR WEIGHT ISSUES ON SHEATHING
ptNewStart=_Pt0;
if(bmGradeIssues.length()>0 || bmWeightIssues.length()>0 || shMaterialIssues.length()>0 )
	ptNewStart+=_YW*_YW.dotProduct(ptBottom-ptNewStart);

ptBottom=ptNewStart;
ptLn= ptNewStart; // Starting point for each line

sHeader=T("   |SHEATHING WITH UNDEFINED WEIGHT VALUES|");

sColType.setLength(0);
sColGrade.setLength(0);
if(shWeightIssues.length()>0 )
{
	// Draw header
	Point3d ptHdr= ptNewStart+vx*dHOff - vy*dVOff;
	
	dp.draw( sHeader, ptHdr, vx, vy, 1, 0);
	LineSeg ls1(ptLn-vy*dVOff*2, ptLn+vx*dExtRecW-vy*dVOff*2);
	dp.draw(ls1);
	
	sColType.append(T("|SHEATHING DETAILS|"));
	sColGrade.append(T("|MATERIAL|"));
	for( int s=0; s< shWeightIssues.length(); s++)
	{
		Sheet sh= shWeightIssues[s];
		PlaneProfile ppSh=sh.profShape();
		double dArea=ppSh.area();
		String sArea;sArea.format("%.2f",dArea/U(1000000000,1728));
		sArea+=" sq."+sMeterFoot+".";
		double dThickness=sh.dD(el.vecZ());
		String sThickness;sThickness.formatUnit(dThickness, nLunits, nPrec);
		String sDetails=sArea+", "+T("|Th|")+":"+sThickness;
		sColType.append(sDetails);
		sColGrade.append("   "+sh.material());
	}
}	

ptLeft= _Pt0+ vx* dHOff; // Starting point to write text
ptLn-= vy*dVOff*1.5;

for( int s=0; s< sColType.length(); s++)
{
	if (s==0)
		ptLn+= vx*vx.dotProduct( ptLeft- ptLn) - vy*dHOff*1.5;
	else
		ptLn+= vx*vx.dotProduct( ptLeft- ptLn) - vy*dHOff*2;

	// Draw pointer
	if(s>0)
	{
		Sheet sh= shWeightIssues[s-1];
		Point3d ptShCen=sh.ptCen();
		Vector3d vElX=el.coordSys().vecX();
		Vector3d vElY=el.coordSys().vecY();
		PLine plPointer (ptLn-vx*dHOff, ptShCen);
		if(nShowPointer)
		{
			dp.draw( plPointer);
			// Draw '+' on sheathing
			double dCrossSide=U(50,2);
			PLine pl1;
			pl1.addVertex(ptShCen+vElX*dCrossSide*.5);
			pl1.addVertex(ptShCen);
			pl1.addVertex(ptShCen-vElX*dCrossSide*.5);
			pl1.addVertex(ptShCen);
			pl1.addVertex(ptShCen+vElY*dCrossSide*.5);
			pl1.addVertex(ptShCen);
			pl1.addVertex(ptShCen-vElY*dCrossSide*.5);
			dp.draw(pl1);
		}		
		if(nHighlightSheets)
			dp.draw( sh.envelopeBody());
	}

	dp.draw( sColType[s], ptLn, vx, vy, 1, 0);
	dp.draw( sColGrade[s], ptLn+vx*dColW*1.5, vx, vy, 1, 0);
	LineSeg ls1(ptLn+vx*vx.dotProduct(_Pt0-ptLn)-vy*dVOff , ptLn+vx*(dExtRecW-dHOff)-vy*dVOff);
	dp.draw(ls1);
	ptBottom= ptLn+vx*(dExtRecW-dHOff)-vy*dVOff;
}

if(shWeightIssues.length()>0 )
{
	dp.color(nFrameColor);
	PLine plExtRect;
	plExtRect.createRectangle(LineSeg( _Pt0, ptBottom), vx, vy);
	dp.draw( plExtRect);
	dp.color(nSheetInfoColor);
}

#End
#BeginThumbnail



#End
