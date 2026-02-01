#Version 8
#BeginDescription
Creates double tennon at beam end

Modified by: Mihai Bercuci (mihai.bercuci@hsbcad.com)
Date: 09.01.2018  -  version 1.1

#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
PropDouble dWidth(0, U(40), T("|Width|"));
PropDouble dDepth(1, U(50), T("|Depth|"));
PropDouble dLength(2, U(50), T("|Length|"));
//PropDouble dOff1(2, 0, T("|Offset|") + " 1");
//PropDouble dOff2(3, 0, T("|Offset|") + " 2");
//PropDouble dToleranceLengthLeft(7, 0, T("|Tolerance length left|"));
//PropDouble dToleranceLengthRight(8, 0, T("|Tolerance length right|"));	

PropDouble dOffAxis(5, 0, T("|Offset from axis|"));
PropDouble dGap(4, 0, T("|Tolerance depth|"));
PropDouble dGapLength(6, 0, T("|Gap on Length|"));
//
String sArAlign[] = {T("|Parallel female beam|"),T("|Perpendicular female beam|"),T("|Parallel with projected Z-axis of tenon beam|"),T("|Perpedicular to projected Z-axis of tenon beam|")};

//PropString sAlign(0, sArAlign, T("|Alignment|"));		
int nArShape[]={_kNotRound,_kRound,_kRounded};
String sArShape[] = {T("|Rectangular|"),T("|Round|"),T("|Rounded|")};
PropString sShape(1, sArShape, T("|Shape|"));

if (_bOnInsert)
{
	if (insertCycleCount()>1) { eraseInstance(); return; }

	// show the dialog if no catalog in use
	if (_kExecuteKey == "")
		showDialog();		
	// set properties from catalog		
	else	
		setPropValuesFromCatalog(_kExecuteKey);	
		
	_Beam.append(getBeam(T("|Select male beam|")));

	PrEntity ssE2(T("|Select female beam(s)|"), Beam());
	Beam bmFemale[0];
	if (ssE2.go())
		bmFemale= ssE2.beamSet();
	_Beam.append(bmFemale);
	return;
}

// ints
//int nAlign = sArAlign.find(sAlign);
int nAlign = 0;
int nShape = nArShape[sArShape.find(sShape)];

// declare standards
Beam bmMale, bmFemale;
bmMale = _Beam[0];
//bmMale.vecZ().vis(_Pt0,40);
bmFemale = _Beam[1]; 
Point3d ptOrg = _Pt0;
Vector3d vx,vy,vz;
vx=_Z1;
vy=vx.crossProduct(_X1);

if (vy.isParallelTo(_Y0) && !vy.isCodirectionalTo(_Y0))
	vy*=-1;	
else if (vy.isParallelTo(_Z0) && !vy.isCodirectionalTo(_Z0))
	vy*=-1;

vz=vx.crossProduct(-vy);

//X
Vector3d vx2=_Beam2.vecD(_Beam0.vecX());
if (vx2.dotProduct(_X0)<0)
	vx2=-vx2;

//Y
Vector3d vy2;
vy2=vx2.crossProduct(_X2);

if (vy2.isParallelTo(_Y0) && !vy2.isCodirectionalTo(_Y0))
	vy2*=-1;	
else if (vy2.isParallelTo(_Z0) && !vy2.isCodirectionalTo(_Z0))
	vy2*=-1;

//Z
Vector3d vz2;
vz2=vx2.crossProduct(vy2);

if (nAlign == 1)
{
	Vector3d vt = vz;
	vz = vy;	
	vy = -vt;
	Vector3d vt2 = vz2;
	vz2 = vy2;	
	vy2 = -vt2;
}	
else if (nAlign == 2)
{
	Vector3d vt = vz;
	vz = bmMale.vecD(vz);	
	vy = vx.crossProduct(-vz);
	
	Vector3d vt2 = vz2;
	vz2 = bmMale.vecD(vz2);	
	vy2 = vx2.crossProduct(-vz2);
}	
else if (nAlign == 3)
{
	Vector3d vt = vz;
	vz = -bmMale.vecD(vy);	
	vy = vx.crossProduct(-vz);
	
	Vector3d vt2 = vz2;
	vz2 = -bmMale.vecD(vy2);	
	vy2 = vx2.crossProduct(-vz2);
}

vz=vx.crossProduct(vy);		
vx.vis(ptOrg, 1);
vy.vis(ptOrg, 3);
vz.vis(ptOrg, 150);


vx2.normalize();
vy2.normalize();
vz2.normalize();

vx2.vis(ptOrg, 1);
vy2.vis(ptOrg, 3);
vz2.vis(ptOrg, 150);



//double dLength=50;

//setExecutionLoops(2);

Vector3d vx1= _X0;
Vector3d vy1= _Y0;
Vector3d vz1= _Z0;

Point3d pt=_Pt0;

//Vector3d vx2= _X0;
//Vector3d vy2= _Y0;
//Vector3d vz2= _Z0;

//vx1=vx1.rotateBy(45, _Z0);
//vy1=vy1.rotateBy(45, _Z0);

//vx2=vx2.rotateBy(-45, _Z0);
//vy2=vy2.rotateBy(-45, _Z0);


//vx1.vis(_Pt0, 1);
//vy1.vis(_Pt0, 3);
//vz1.vis(_Pt0, 150);

//vx2.vis(_Pt0, 1);
//vy2.vis(_Pt0, 3);
//vz2.vis(_Pt0, 150);

//Connection Beam 0 and 1
Point3d ptMs = _Pt0-vz*(U(_Beam0.dD(vz)*0.25)) - vz*dOffAxis;
Point3d ptTennon=ptMs;//-vz*(dToleranceLengthLeft-dToleranceLengthRight);

Mortise ms(ptTennon, vy, vz, vx, dWidth, dLength,dDepth, 0,0,1);
ms.setEndType(_kMaleEnd);
ms.setRoundType(nShape);
_Beam0.addTool(ms);	

// this can cause the TSL to fail in some instances
// ms.cuttingBody().vis();



// add house
Mortise msFemale(ptMs, vy, vz,vx, dWidth, dLength+dGapLength,dDepth+dGap, 0,0,1);
msFemale.setEndType(_kFemaleSide);
msFemale.setRoundType(nShape);
_Beam1.addTool(msFemale);	


//Connection Beam 0 and 2
Point3d ptMs2 = _Pt0+vz2*(U(_Beam0.dD(vz2)*0.25)) + vz2*dOffAxis;
Point3d ptTennon2=ptMs2;// +vz2*(dToleranceLengthLeft-dToleranceLengthRight);

Mortise ms2(ptTennon2, vy2, vz2, vx2, dWidth, dLength,dDepth, 0,0,1);
ms2.setEndType(_kMaleEnd);
ms2.setRoundType(nShape);
_Beam0.addTool(ms2);	

// this can cause the TSL to fail in some instances
//ms2.cuttingBody().vis();

// add house
Mortise msFemale2(ptMs2, vy2, vz2,vx2, dWidth, dLength+dGapLength,dDepth+dGap, 0,0,1);
msFemale2.setEndType(_kFemaleSide);
msFemale2.setRoundType(nShape);
_Beam2.addTool(msFemale2);

//Display
Display dp(-1);

Point3d ptDraw = _Pt0;

PLine pl1(_XW);
PLine pl2(_YW);
PLine pl3(_ZW);
pl1.addVertex(ptDraw+vz*U(5));
pl1.addVertex(ptDraw-vz*U(5));
pl2.addVertex(ptDraw-vx*U(5));
pl2.addVertex(ptDraw+vx*U(5));
pl3.addVertex(ptDraw-vy*U(5));
pl3.addVertex(ptDraw+vy*U(5));

dp.draw(pl1);
dp.draw(pl2);
dp.draw(pl3);
#End
#BeginThumbnail


#End