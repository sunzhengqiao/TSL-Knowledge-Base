#Version 8
#BeginDescription
Adds a Column Foot with Glued rods

Last modified by: Bruno Bortot 11.08.16 -  bruno.bortot@hsbcad.com
Date: 11.08.2016  -  version 1.0



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
sFlipStub.setCategory(T("Stub"));

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
//PropDouble dBasePlateDrillTol(14,2,"Drill Tolerance");
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
//dBasePlateDrillTol.setCategory(T("Base Plate"));
dBasePlateOffset1.setCategory(T("Base Plate"));
dBasePlateOffset2.setCategory(T("Base Plate"));

//Top Plate
PropString sTopName(17,"Top Plate","Name");
PropDouble dTopPlateT(18,20,"Top Plate Thickness");
PropDouble dTopPlateL(19,200,"Top Plate Length");
PropDouble dTopPlateW(20,300,"Top Plate Width");

sTopName.setCategory(T("Top Plate"));
dTopPlateT.setCategory(T("Top Plate"));
dTopPlateL.setCategory(T("Top Plate"));
dTopPlateW.setCategory(T("Top Plate"));

//Fin Plate
PropString sFinName(21,"Fin Plate","Name");
PropDouble dFinPlateT(22,20,"Fin Plate Thickness");
PropDouble dFinPlateL(23,400,"Fin Plate Length");
PropDouble dFinPlateW(24,300,"Fin Plate Width");
PropDouble dFinPlateSlotTolL(25,20,"Slot Tolerance Length");
PropDouble dFinPlateSlotTolW(26,20,"Slot Tolerance Width");
PropDouble dFinPlateSlotTolT(27,5,"Slot Tolerance Thickness");
String sArrLocations[]={T("None"),T("Side1"),("Side2"),("Both")};
PropString sStretchT(28,sArrLocations,T("Stretch Slot"),1);
int nLoc = sArrLocations.find(sStretchT,1);
String sFinArrYN[]={T("Yes"),T("No")};
PropString sFlipFin(29,sFinArrYN,T("Flip Direction"),1);
int nFinFlip = sFinArrYN.find(sFlipFin,1);

PropInt nFinRows(30,3,T("Quantity of Drill Rows"));
PropInt nFinCols(31,3,T("Quantity of Drill Columns"));
PropDouble dRowDistFin(32,100,"Drill Row Centers");
PropDouble dColDistFin(33,100,"Drill Col Centers");
PropDouble dDrillOffsetL(34,70,"Drill Offset Along Length");
PropDouble dFinPlateDrill(35,20,"Drill Diametre");
PropDouble dFinPlateDrillTol(36,2,"Drill Tolerance");
PropDouble dSinkholeDiam(37,20,"Sinkhole Diameter");
PropDouble dSinkholeDepth(38,20,"Sinkhole Depth");

sFinName.setCategory(T("Fin Plate"));
dFinPlateT.setCategory(T("Fin Plate"));
dFinPlateL.setCategory(T("Fin Plate"));
dFinPlateW.setCategory(T("Fin Plate"));
nFinRows.setCategory(T("Fin Plate"));
nFinCols.setCategory(T("Fin Plate"));
dRowDistFin.setCategory(T("Fin Plate"));
dColDistFin.setCategory(T("Fin Plate"));
dFinPlateDrill.setCategory(T("Fin Plate"));
dFinPlateDrillTol.setCategory(T("Fin Plate"));
dSinkholeDiam.setCategory(T("Fin Plate"));
dSinkholeDepth.setCategory(T("Fin Plate"));
dFinPlateSlotTolL.setCategory(T("Fin Plate"));
dFinPlateSlotTolW.setCategory(T("Fin Plate"));
dFinPlateSlotTolT.setCategory(T("Fin Plate"));
sStretchT.setCategory(T("Fin Plate"));
sFlipFin.setCategory(T("Fin Plate"));
dDrillOffsetL.setCategory(T("Fin Plate"));

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
		Drill DBottom(ptDrillBottom-100*_X0,_X0,200,(dBasePlateDrill/*+dBasePlateDrillTol*/)*0.5);
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

//Fin Plate

Point3d ptArrDrillFin[0];
if(nFinFlip)
{
Body bdFinPlate(_Pt0-0.5*dFinPlateL*_X0,-_X0,_Y0,_Z0, dFinPlateL,dFinPlateT,dFinPlateW);
//bdBottomPlate.vis(3);
Beam bFinPlate;
bFinPlate.dbCreate(bdFinPlate);
bFinPlate.setName(sFinName);
bFinPlate.setColor(sColor1);
bFinPlate.setGrade(sGrade);
bFinPlate.setMaterial("Steel");
_Entity.append(bFinPlate);
//Beam and Fin Drilling
Point3d ptFinRef(bFinPlate.ptCen()-(nFinRows-1)*dRowDistFin*0.5*_X0-dDrillOffsetL*_X0-(nFinCols-1)*dColDistFin*0.5*_Z0);
	for(int i=0;i<nFinRows;i++)
	{
		for(int j=0;j<nFinCols;j++)
		{
		Point3d ptF=(ptFinRef+i*dRowDistFin*_X0+j*dColDistFin*_Z0);
		Drill MainDrillFin(ptF-0.5*(_Beam0.dD(_Y0))*_Y0,_Y0,_Beam0.dD(_Y0),(dFinPlateDrill+dFinPlateDrillTol)*0.5);
		Drill MainDrillBeam(ptF-0.5*(_Beam0.dD(_Y0))*_Y0,_Y0,_Beam0.dD(_Y0),dFinPlateDrill*0.5);
		Drill SinkDrillBeam1(ptF-0.5*(_Beam0.dD(_Y0))*_Y0,_Y0,dSinkholeDepth,dSinkholeDiam*0.5);
		Drill SinkDrillBeam2(ptF+0.5*(_Beam0.dD(_Y0))*_Y0,-_Y0,dSinkholeDepth,dSinkholeDiam*0.5);
		bFinPlate.addTool(MainDrillFin);
		_Beam0.addTool(MainDrillBeam);
		_Beam0.addTool(SinkDrillBeam1);
		_Beam0.addTool(SinkDrillBeam2);
		}
	}
}
else
{
Body bdFinPlate(_Pt0-0.5*dFinPlateL*_X0,-_X0,_Z0,_Y0, dFinPlateL,dFinPlateT,dFinPlateW);
//bdBottomPlate.vis(3);
Beam bFinPlate;
bFinPlate.dbCreate(bdFinPlate);
bFinPlate.setName(sFinName);
bFinPlate.setColor(sColor1);
bFinPlate.setGrade(sGrade);
bFinPlate.setMaterial("Steel");
_Entity.append(bFinPlate);
//Beam and Fin Drilling
Point3d ptFinRef(bFinPlate.ptCen()-(nFinRows-1)*dRowDistFin*0.5*_X0-dDrillOffsetL*_X0-(nFinCols-1)*dColDistFin*0.5*_Y0);
	for(int i=0;i<nFinRows;i++)
	{
		for(int j=0;j<nFinCols;j++)
		{
		Point3d ptF=(ptFinRef+i*dRowDistFin*_X0+j*dColDistFin*_Y0);
		Drill MainDrillFin(ptF-0.5*(_Beam0.dD(_Z0))*_Z0,_Z0,_Beam0.dD(_Z0),(dFinPlateDrill+dFinPlateDrillTol)*0.5);
		Drill MainDrillBeam(ptF-0.5*(_Beam0.dD(_Z0))*_Z0,_Z0,_Beam0.dD(_Z0),dFinPlateDrill*0.5);
		Drill SinkDrillBeam1(ptF-0.5*(_Beam0.dD(_Z0))*_Z0,_Z0,dSinkholeDepth,dSinkholeDiam*0.5);
		Drill SinkDrillBeam2(ptF+0.5*(_Beam0.dD(_Z0))*_Z0,-_Z0,dSinkholeDepth,dSinkholeDiam*0.5);
		bFinPlate.addTool(MainDrillFin);
		_Beam0.addTool(MainDrillBeam);
		_Beam0.addTool(SinkDrillBeam1);
		_Beam0.addTool(SinkDrillBeam2);
		}
	}
}



//Fin PLate Slot
if(nFinFlip)
{
	if(nLoc ==0)
	{
	BeamCut cSlot1(_Pt0-0.5*dFinPlateL*_X0,-_X0,_Y0,_Z0, dFinPlateL+2*dFinPlateSlotTolL,dFinPlateT+dFinPlateSlotTolT,dFinPlateW+dFinPlateSlotTolW);
	_Beam0.addTool(cSlot1);
	}
	if(nLoc ==1)
	{
	BeamCut cSlot1(_Pt0-0.5*dFinPlateL*_X0-500*_Z0,-_X0,_Y0,_Z0, dFinPlateL+2*dFinPlateSlotTolL,dFinPlateT+dFinPlateSlotTolT,dFinPlateW+dFinPlateSlotTolW+1000);
	_Beam0.addTool(cSlot1);
	}
	if(nLoc ==2)
	{
	BeamCut cSlot1(_Pt0-0.5*dFinPlateL*_X0+500*_Z0,-_X0,_Y0,_Z0, dFinPlateL+2*dFinPlateSlotTolL,dFinPlateT+dFinPlateSlotTolT,dFinPlateW+dFinPlateSlotTolW+1000);
	_Beam0.addTool(cSlot1);
	}
	if(nLoc ==3)
	{
	BeamCut cSlot1(_Pt0-0.5*dFinPlateL*_X0,-_X0,_Y0,_Z0, dFinPlateL+2*dFinPlateSlotTolL,dFinPlateT+dFinPlateSlotTolT,dFinPlateW+2000);
	_Beam0.addTool(cSlot1);
	}
}
else
{
	if(nLoc ==0)
	{
	BeamCut cSlot1(_Pt0-0.5*dFinPlateL*_X0,-_X0,_Z0,_Y0, dFinPlateL+2*dFinPlateSlotTolL,dFinPlateT+dFinPlateSlotTolT,dFinPlateW+dFinPlateSlotTolW);
	_Beam0.addTool(cSlot1);
	}
	if(nLoc ==1)
	{
	BeamCut cSlot1(_Pt0-0.5*dFinPlateL*_X0-500*_Z0,-_X0,_Z0,_Y0, dFinPlateL+2*dFinPlateSlotTolL,dFinPlateT+dFinPlateSlotTolT,dFinPlateW+dFinPlateSlotTolW+1000);
	_Beam0.addTool(cSlot1);
	}
	if(nLoc ==2)
	{
	BeamCut cSlot1(_Pt0-0.5*dFinPlateL*_X0+500*_Z0,-_X0,_Z0,_Y0, dFinPlateL+2*dFinPlateSlotTolL,dFinPlateT+dFinPlateSlotTolT,dFinPlateW+dFinPlateSlotTolW+1000);
	_Beam0.addTool(cSlot1);
	}
	if(nLoc ==3)
	{
	BeamCut cSlot1(_Pt0-0.5*dFinPlateL*_X0,-_X0,_Z0,_Y0, dFinPlateL+2*dFinPlateSlotTolL,dFinPlateT+dFinPlateSlotTolT,dFinPlateW+2000);
	_Beam0.addTool(cSlot1);
	}
}




//Create Entity Array
_Entity.append(bTopPlate);
_Entity.append(bBottomPlate);

// TSL Symbol
LineSeg ls1 (_Pt0, _Pt0+_X0*dFootH);
Display dp1(3);
dp1.draw(ls1);
LineSeg ls2 (_Pt0+_X0*dFootH*0.5+_Y0*50, _Pt0+_X0*dFootH*0.5-_Y0*50);
Display dp2(3);
dp2.draw(ls2);
LineSeg ls3 (_Pt0+_X0*dFootH*0.5+_Z0*50, _Pt0+_X0*dFootH*0.5-_Z0*50);
Display dp3(3);
dp3.draw(ls3);

//Stretch Beam to Top plate

_Beam0.stretchDynamicTo(bTopPlate);
#End
#BeginThumbnail

#End