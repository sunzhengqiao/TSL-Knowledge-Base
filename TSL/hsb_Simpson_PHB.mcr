#Version 8
#BeginDescription
Version 1.0 date=17/03/17 author: bruno.bortot@hsbcad.com
This tsl creates a Simpson StrongTie PHB column base
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
/// <summary Lang=en>
/// This tsl creates 
/// </summary>
/// <History>//region
/// <version value="1.0" date="17/03/17" author="bruno.bortot@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates a Simpson StrongTie PHB column base
/// </summary>//endregion

// constants //region
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("No"), T("Yes")};
	//endregion

//Geometric Parametres
String sTypes[]={"PHB75","PHB120"};	//Type as per Simpson Catalogue
//Flange
double dFlangeWidth[]={ 45,90};
double dFlangeLength[]={ 110,110};
double dFlangeThickness[]={ 8,8};
//Top Plate
double dTopPlateWidth[]={ 75,120};
double dTopPlateLength[]={ 75,120};
double dTopPlateThickness[]={ 8,8};
//Base Plate
double dBasePlateWidth[]={ 100,155};
double dBasePlateLength[]={ 160,155};
double dBasePlateThickness[]={ 8,8};
//Stub
double dStubDiam[]={ 42,42};
double dStubLength[]={ 200,200};
//Flange Drilling
double dFlangeDrillDiams[]={ 8.5,8.5};
double dTimberDrillDiams[]={ 8,8};
int	nFlangeDrillRows[]={ 2,2};
int nFlangeDrillCols[]={ 1,2};
double dFlangeColDists[]={ 0,50};
double dFlangeRowDists[]={ 40,40};
double dFlangeEdgeDists[]={ 20,20};


//Base Plate Drilling
double dBaseDrillDiams[]={ 13,13};
int	nBaseDrillRows[]={ 2,2};
int nBaseDrillCols[]={ 1,2};
double dBaseColDists[]={ 0,115};
double dBaseRowDists[]={ 130,115};
double dBaseEdgeDists[]={ 20,20};

//General
category=T("|Model Type|");
String sTypeName=T("|Type|");	
PropString sType(nStringIndex++, sTypes, sTypeName);	
sType.setDescription(T("|Defines the Type|"));
sType.setCategory(category);

// Slot
category=T("|Slot|");
String sSlotAlignments[]={T("|Side 1|"),T("|Side 2|"),T("|Full Depth|")};
String sSlotAlignmentName=T("|Alignment|");	
PropString sSlotAlignment(nStringIndex++,sSlotAlignments, sSlotAlignmentName);	
sSlotAlignment.setDescription(T("|Defines the Slot Alignment|"));
sSlotAlignment.setCategory(category);

//Drill
category=T("|Drills|");

String sDrillLengthName=T("|Drill Depth|");	
PropDouble dDrillLength(nDoubleIndex++, U(80), sDrillLengthName);	
dDrillLength.setDescription(T("|If Drill Depth = 0, Full depth|"));
dDrillLength.setCategory(category);



// bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();

		if (sKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			for(int i=0;i<sEntries.length();i++)
				sEntries[i] = sEntries[i].makeUpper();	
			if (sEntries.find(sKey)>-1)
				setPropValuesFromCatalog(sKey);
			else
				setPropValuesFromCatalog(T("|_LastInserted|"));					
		}	
		else	
			showDialog();
		_Beam.append(getBeam());
		_Pt0=getPoint();
		
		return;
	}	
	
// end on insert	__________________
	
// Vectors

Vector3d vecX=_X0; 
if(vecX.dotProduct(_ZW)<0)
{
	vecX*=-1;
}
Vector3d vecY=_Y0;
Vector3d vecZ=_Z0; 

vecX.vis(_Pt0,1);
vecY.vis(_Pt0,2);
vecZ.vis(_Pt0,3);

//Set Type

int nType=sTypes.find(sType);

double dFlangeW=dFlangeWidth[nType];
double dFlangeL=dFlangeLength[nType];
double dFlangeT=dFlangeThickness[nType];

double dTopPlateW=dTopPlateWidth[nType];
double dTopPlateL=dTopPlateLength[nType];
double dTopPlateT=dTopPlateThickness[nType];

double dBasePlateW=dBasePlateWidth[nType];
double dBasePlateL=dBasePlateLength[nType];
double dBasePlateT=dBasePlateThickness[nType];

double dStubD=dStubDiam[nType];
double dStubL=dStubLength[nType];

double dFlangeDrillDiam=dFlangeDrillDiams[nType];
double dTimberDrillDiam=dTimberDrillDiams[nType];
int nFlangeDrillRow=nFlangeDrillRows[nType];
int nFlangeDrillCol=nFlangeDrillCols[nType];
double dFlangeRowDist=dFlangeRowDists[nType];
double dFlangeColDist=dFlangeColDists[nType];
double dFlangeEdgeDist=dFlangeEdgeDists[nType];

double dBaseDrillDiam=dBaseDrillDiams[nType];
int nBaseDrillRow=nBaseDrillRows[nType];
int nBaseDrillCol=nBaseDrillCols[nType];
double dBaseRowDist=dBaseRowDists[nType];
double dBaseColDist=dBaseColDists[nType];
double dBaseEdgeDist=dBaseEdgeDists[nType];


//Body
// Collect Simple bodies
Body bodies[0];

Body bdFlange(_Pt0,vecX,vecY,vecZ,dFlangeL,dFlangeW,dFlangeT,1,0,0);

//Drilling Flange

Point3d ptA=bdFlange.ptCen()+(0.5*dFlangeL-dFlangeEdgeDist-((nFlangeDrillRow-1)*dFlangeRowDist))*vecX-(nFlangeDrillCol-1)*0.5*dFlangeColDist*vecY;
ptA.vis(6);

for (int i=0;i<nFlangeDrillRow;i++) 
{ 
	for(int j=0;j<nFlangeDrillCol;j++)
	{
		Point3d ptDrill=ptA+i*dFlangeRowDist*vecX+j*dFlangeColDist*vecY;
		ptDrill.vis(1);
		
		double dDlength;
		if(dDrillLength==0)
		{
			dDlength=_Beam0.dD(vecZ);
		}
		else
		{
			dDlength=dDrillLength;
		}
		
		Drill drFlange(ptDrill-100*vecZ,ptDrill+100*vecZ,0.5*dFlangeDrillDiam);
		Drill drBeam(ptDrill-0.5*_Beam0.dD(vecZ)*vecZ,ptDrill-(0.5*_Beam0.dD(vecZ)-dDlength)*vecZ,0.5*dTimberDrillDiam);
		_Beam0.addTool(drBeam);
		bdFlange.addTool(drFlange);
	}
	 
}
bodies.append(bdFlange);

Body bdTopPLate(_Pt0,vecX,vecY,vecZ,dTopPlateT,dTopPlateW,dTopPlateL,-1,0,0);
bodies.append(bdTopPLate);

Body bdStub(_Pt0-dTopPlateT*vecX,_Pt0-(dTopPlateT+dStubL)*vecX,0.5*dStubD);
bodies.append(bdStub);

Body bdBasePLate(_Pt0-(dTopPlateT+dStubL)*vecX,vecX,vecY,vecZ,dBasePlateT,dBasePlateW,dBasePlateL,-1,0,0);

//TODO Drilling on Base Plate

bodies.append(bdBasePLate);


//Draw Body
Display dp(-1);
for (int i=0;i<bodies.length();i++) 
{ 
	dp.draw(bodies[i]); 	 
}

//Slot
int nAlignment=sSlotAlignments.find(sSlotAlignment);
if(nAlignment==0)
{
	BeamCut sl0(_Pt0-(0.5*dFlangeW+10)*vecY,vecX,vecY,vecZ,dFlangeL+10,500,dFlangeT+4,1,1,0);
	_Beam0.addTool(sl0);
}
if(nAlignment==1)
{
	BeamCut sl1(_Pt0+(0.5*dFlangeW+10)*vecY,vecX,vecY,vecZ,dFlangeL+10,500,dFlangeT+4,1,-1,0);
	_Beam0.addTool(sl1);
}
if(nAlignment==2)
{
	BeamCut sl2(_Pt0,vecX,vecY,vecZ,dFlangeL+10,500,dFlangeT+5,1,0,0);
	_Beam0.addTool(sl2);
}

//Stretch Beam

Cut ctBeam(_Pt0,-vecX);
_Beam0.addTool(ctBeam,TRUE);


#End
#BeginThumbnail
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
%110!_]D\
`

#End