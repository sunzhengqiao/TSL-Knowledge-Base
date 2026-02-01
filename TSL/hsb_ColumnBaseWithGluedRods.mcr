#Version 8
#BeginDescription
Adds a slot tool to a beam

Last modified by: Bruno Bortot bruno.bortot@hsbcad.com
Date: 01.01.2008  -  version 1.0



#End
#Type E
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
	Unit(1,"mm");
// General Properties
PropString sGrade(0,"S275","Steel Grade");
PropInt sColor1(1,-1,"Color");
sGrade.setCategory(T("General"));
sColor1.setCategory(T("General"));

//Stub

PropDouble dFootH(2,300,"Overall Foot Height");
PropString sProfile(3, ExtrProfile().getAllEntryNames(), T("|Extrusion profile name|"));
String sArrYN[]={T("Yes"),T("No")};
PropString sFlipStub(4,sArrYN,T("Flip Direction"),1);
int nST = sArrYN.find(sFlipStub,1);


dFootH.setCategory(T("Stub"));
sProfile.setCategory(T("Stub"));

//Base Plate
PropString sBaseName(5,"Base Plate","Name");
PropDouble dBasePlateT(6,20,"Base Plate Thickness");
PropDouble dBasePlateL(7,400,"Base Plate Length");
PropDouble dBasePlateW(8,300,"Base Plate Width");
PropInt nBaseRows(9,3,T("Quantity of Drill Rows"));
PropInt nBaseCols(10,3,T("Quantity of Drill Columns"));
PropDouble dRowDistBase(11,100,"Drill Row Centers");
PropDouble dColDistBase(12,100,"Drill Col Centers");
PropDouble dBasePlateDrill(13,20,"Drill Diametre");
PropDouble dBasePlateDrillTol(14,2,"Drill Tolerance");
PropDouble dBasePlateOffset1(15,50,"Offset Side 1");
PropDouble dBasePlateOffset2(16,60,"Offset Side 2");

sBaseName.setCategory(T("Base Plate"));
dBasePlateT.setCategory(T("Base Plate"));
dBasePlateL.setCategory(T("Base Plate"));
dBasePlateW.setCategory(T("Base Plate"));
nBaseRows.setCategory(T("Base Plate"));
nBaseCols.setCategory(T("Base Plate"));
dRowDistBase.setCategory(T("Base Plate"));
dColDistBase.setCategory(T("Base Plate"));
dBasePlateDrill.setCategory(T("Base Plate"));
dBasePlateDrillTol.setCategory(T("Base Plate"));
dBasePlateOffset1.setCategory(T("Base Plate"));
dBasePlateOffset2.setCategory(T("Base Plate"));

//Top Plate
PropString sTopName(17,"Top Plate","Name");
PropDouble dTopPlateT(18,20,"Top Plate Thickness");
PropDouble dTopPlateL(19,200,"Top Plate Length");
PropDouble dTopPlateW(20,300,"Top Plate Width");
PropInt nTopRows(21,3,T("Quantity of Drill Rows"));
PropInt nTopCols(22,3,T("Quantity of Drill Columns"));
PropDouble dRowDistTop(23,50,"Drill Row Centers");
PropDouble dColDistTop(24,50,"Drill Col Centers");
PropDouble dTopPlateDrill(25,20,"Drill Diametre");
PropDouble dTopPlateDrillTol(26,2,"Drill Tolerance");
PropDouble dDrillLengthT(27,200,"Drilling Depth");

sTopName.setCategory(T("Top Plate"));
dTopPlateT.setCategory(T("Top Plate"));
dTopPlateL.setCategory(T("Top Plate"));
dTopPlateW.setCategory(T("Top Plate"));
nTopRows.setCategory(T("Top Plate"));
nTopCols.setCategory(T("Top Plate"));
dTopPlateDrill.setCategory(T("Top Plate"));
dRowDistTop.setCategory(T("Top Plate"));
dColDistTop.setCategory(T("Top Plate"));
dTopPlateDrillTol.setCategory(T("Top Plate"));
dDrillLengthT.setCategory(T("Top Plate"));

// on insert
	if (_bOnInsert) 
	{
		
		if (insertCycleCount()>1) { eraseInstance(); return; }
	
	// set properties from catalog
		if (_kExecuteKey!="")
			setPropValuesFromCatalog(_kExecuteKey);			
		showDialog();

		_Beam.append(getBeam());
		_Pt0 = getPoint();
		
		return;
	}
//end on insert________________________________________________________________________________

//Vectors
_X0.vis(_Pt0, 1);
_Y0.vis(_Pt0, 2);
_Z0.vis(_Pt0, 3);

// Empty entity array

Entity ents[0];
ents = _Entity;
for(int i=0;i<ents.length();i++)
{
Entity E1=ents[i];
E1.dbErase();
}
_Entity.setLength(0);

//Top Plate
Body bdTopPlate(_Pt0+dTopPlateT*0.5*_X0,_X0,_Y0,_Z0, dTopPlateT,dTopPlateL,dTopPlateW);
//bdTopPlate.vis(3);
Beam bTopPlate;
bTopPlate.dbCreate(bdTopPlate);
bTopPlate.setName(sTopName);
bTopPlate.setColor(sColor1);
bTopPlate.setGrade(sGrade);
bTopPlate.setMaterial("Steel");

//Top Plate Drilling
Point3d ptA(_Pt0-(nTopRows-1)*dRowDistTop*0.5*_Z0-(nTopCols-1)*dColDistTop*0.5*_Y0);
//ptA.vis(3);

Point3d ptArrDrillTop[0];

for(int i=0;i<nTopRows;i++)
{
	for(int j=0;j<nTopCols;j++)
	{
	
			Point3d ptTPlate=(ptA+i*dRowDistTop*_Z0+j*dColDistTop*_Y0);
			//ptTPlate.vis(2);
			Vector3d vPT((ptTPlate-_Pt0));
			if(!_X0.dotProduct(vPT)==0)
			{
			ptArrDrillTop.append(ptTPlate);
			}
			
	}
}

for(int d=0;d<ptArrDrillTop.length();d++)
{
		Point3d ptDrillTop=ptArrDrillTop[d];
		Drill DBeam(ptDrillTop,-_X0,dDrillLengthT,(dTopPlateDrill)*0.5);
		Drill DTop(ptDrillTop,_X0,200,(dTopPlateDrill+dTopPlateDrillTol)*0.5);
		bTopPlate.addTool(DTop);
		_Beam0.addTool(DBeam);
		
}


//Bottom Plate

Body bdBottomPlate(_Pt0+dFootH*_X0-dBasePlateT*0.5*_X0+dBasePlateOffset1*_Y0+dBasePlateOffset2*_Z0,_X0,_Y0,_Z0, dBasePlateT,dBasePlateL,dBasePlateW);
//bdBottomPlate.vis(3);
Beam bBottomPlate;
bBottomPlate.dbCreate(bdBottomPlate);
bBottomPlate.setName(sBaseName);
bBottomPlate.setColor(sColor1);
bBottomPlate.setGrade(sGrade);
bBottomPlate.setMaterial("Steel");

//Bottom Plate Drilling
Point3d ptB(bBottomPlate.ptCen()-(nBaseRows-1)*dRowDistBase*0.5*_Z0-(nBaseCols-1)*dColDistBase*0.5*_Y0);
//ptB.vis(3);

Point3d ptArrDrillBottom[0];

for(int i=0;i<nBaseRows;i++)
{
	for(int j=0;j<nBaseCols;j++)
	{
	
			Point3d ptBPlate=(ptB+i*dRowDistBase*_Z0+j*dColDistBase*_Y0);
			//ptBPlate.vis(2);
			Vector3d vPB((ptBPlate-bBottomPlate.ptCen()));
			if(!_X0.dotProduct(vPB)==0)
			{
			ptArrDrillBottom.append(ptBPlate);
			}
			
	}
}

for(int d=0;d<ptArrDrillBottom.length();d++)
{
		Point3d ptDrillBottom=ptArrDrillBottom[d];
		Drill DBottom(ptDrillBottom-100*_X0,_X0,200,(dBasePlateDrill+dBasePlateDrillTol)*0.5);
		bBottomPlate.addTool(DBottom);
	
		
}

//Stub
if(nST )
{
Body bdStub(_Pt0+0.5*dFootH*_X0,_X0,_Y0,_Z0, dFootH,50,70);
//bdStub.vis(3);
Beam bStub;
bStub.dbCreate(bdStub);
bStub.stretchDynamicTo(bTopPlate);
bStub.stretchDynamicTo(bBottomPlate);
bStub.setExtrProfile(sProfile);
bStub.setColor(sColor1);
bStub.setGrade(sGrade);
_Entity.append(bStub);

}
else
{
Body bdStub(_Pt0+0.5*dFootH*_X0,_X0,_Z0,_Y0, dFootH,50,70);
//bdStub.vis(3);
Beam bStub;
bStub.dbCreate(bdStub);
bStub.stretchDynamicTo(bTopPlate);
bStub.stretchDynamicTo(bBottomPlate);
bStub.setExtrProfile(sProfile);
bStub.setColor(sColor1);
bStub.setGrade(sGrade);
_Entity.append(bStub);
}

//Create Entity Array
_Entity.append(bTopPlate);
_Entity.append(bBottomPlate);


LineSeg ls (_Pt0, _Pt0+_X0*dFootH);
Display dp(3);
dp.draw(ls);

//Stretch Beam to Top plate

_Beam0.stretchDynamicTo(bTopPlate);
#End
#BeginThumbnail
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
8`!1110`4444`%%%%`!1110`4444`?__9
`

#End