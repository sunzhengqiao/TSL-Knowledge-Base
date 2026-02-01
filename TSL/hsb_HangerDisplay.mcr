#Version 8
#BeginDescription
#Versions:
2.14 25.11.2021 HSB-12890: distinguish between only male beams and male+female beams Author: Marsel Nakuci
2.13 - 16.08.2021 HSB-11989: Change vecX if <= 0 Author: GC
2.12 30.03.2021 HSB-9099: when only male beams apply cut only on dbcreate Author: Marsel Nakuci

Last modified by: Geoffroy Cenni
16.08.2021  -  version 2.13

This tsl visualizes the hanger which is placed through the hsbHanger application.



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 3
#MinorVersion 2
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl adds a hanger to a t-connection.
/// </summary>

/// <insert>
/// This tsl is inserted by the hsb_Hanger tsl.
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.05" date="26.08.2014"></version>

/// <history>
// #Versions:
// Version 3.1 05.06.2023 HSB-18340: Import from Hsb_ImportIfc will get the graphical rep from source\body, and the other
// data from the model, originator and material description. Since then we introduced the External == 2.
// Version 2.14 25.11.2021 HSB-12890: distinguish between only male beams and male+female beams Author: Marsel Nakuci
/// GC - 2.13 - 16.08.2021 HSB-11989: Change vecX if <= 0
// Version 2.12 30.03.2021 HSB-9099: when only male beams apply cut only on dbcreate Author: Marsel Nakuci
/// AJ - 1.00 - 04.09.2013 - 	Pilot version
/// AJ - 1.01 - 04.09.2013 - 	Pilot version
/// AJ - 1.02 - 05.09.2013 - 	Pilot version
/// AJ - 1.03 - 08.09.2013 - 	Pilot version
/// AS - 1.04 - 24.06.2014 - 	Export to modelmap as an elemItem
/// AS - 1.05 - 26.08.2014 - 	Assign hanger to element of beam0, if beam1 is not part of an element.
/// CS - Further comments will be found in source control
/// </hsitory>

//Units
U(1,"mm");

Map mpAll[0];

for (int i=0; i<_Map.length(); i++)
{
	if (_Map.keyAt(i)=="HANGER")
	{
		mpAll.append(_Map.getMap(i));
	}
}

int firstRunAfterImport = mpAll.length() == 0 && _Map.hasBody("source\\body");
int bodyCouldBeValid = true;
if (firstRunAfterImport)
{
	Map mpHanger;
	mpHanger.appendInt("External", 2);
	
	Map mpSource = _Map.getMap("source");
	int sourceBodyIndex = - 1;
	for (int k = 0; k < mpSource.length(); k++)
	{
		String keyk = mpSource.keyAt(k);
		keyk.makeLower();
		String namek = mpSource.nameAt(k);
		namek.makeLower();
		if (keyk == "simplebody" && namek == "body")
		{
			sourceBodyIndex = k;
			break;
		}
	}
	
	if (sourceBodyIndex >= 0)
	{
		mpHanger.setMap("SimpleBody", mpSource.getMap(sourceBodyIndex));
		
		Body bd = mpSource.getBody(sourceBodyIndex);
		bodyCouldBeValid = bd.isValid();
		_Pt0.setToAverage(bd.allVertices());
	}
	else
	{ 
		bodyCouldBeValid = false;
	}
	
	// In case body is not valid, collect faces of Simplebody of the CgsItems of type CgsBrep.
	if (!bodyCouldBeValid && mpSource.hasMap("csgitems"))
	{ 
		Map mpCsgs = mpSource.getMap("csgitems");
		PLine plsToShow[0];
		for (int k = 0; k < mpCsgs.length(); k++)
		{
			String keyk = mpCsgs.keyAt(k);
			keyk.makeLower();
			if (keyk == "csgbrep")
			{
				Map mpCsgBrep = mpCsgs.getMap(k);
				PLine plines[] = mpCsgBrep.getBodyFaceLoops("brep");
				plsToShow.append(plines);
			}
		}
		if (plsToShow.length() > 0)
		{
			Map mpPls;
			for (int p = 0; p < plsToShow.length(); p++)
			{ 
				mpPls.appendPLine("pl", plsToShow[p]);
			}
			mpHanger.setMap("BodyPlines", mpPls);
		}
	}
	
	String sModel = _ThisInst.modelDescription();
	String sSupplier = _ThisInst.originator();
	String sType = _ThisInst.materialDescription();
	_ThisInst.setModelDescription("");
	_ThisInst.setOriginator("");
	_ThisInst.setMaterialDescription("");
	
	mpHanger.setString("Model", sModel);
	mpHanger.setString("Supplier", sSupplier);
	mpHanger.setString("Type", sType);
	_Map.setMap("HANGER", mpHanger);
	
	mpAll.append(mpHanger);
	
	//HsbBom export
	Map mp;
	mp.setString("Name", sModel);
	mp.setString("Type", sType);
	mp.setInt("Qty", 1);
	_Map.setMap("TSLBOM", mp);  
}

if (mpAll.length()==0)
{
	eraseInstance();
	return;
}

String sModels[0];
String sType;
String sSupplier;
int nGeneric;
double dHangerDepth = 50;

Map mpHangers[0];

if(!_Map.hasPoint3d("Origin"))
{
	_Map.setPoint3d("Origin",_Pt0,_kRelative);
}
else
{
	_Pt0=_Map.getPoint3d("Origin");
}

if(!_Map.hasInt("IsInverted"))
{
	_Map.setInt("IsInverted", false);
}

for (int i=0; i<mpAll.length(); i++)
{
	Map mp=mpAll[i];
	sModels.append(mp.getString("Model"));
	sType=mp.getString("Type");
	sSupplier=mp.getString("Supplier");
	nGeneric=mp.getInt("Generic");
	dHangerDepth = mp.getDouble("HangerDepth") == 0 ? dHangerDepth : mp.getDouble("HangerDepth");
	mpHangers.append(mp);
}

//Basics and properties
PropString sModel (0, sModels, T("Model"));
int nModel = sModels.find(sModel ,0);

PropString sDimLayout(1,_DimStyles,T("Dim Style"));

String strYesNo[]= {T("No"), T("Yes"), T("Short Model")};
PropString strDisplay (2, strYesNo, T("Display Model"), 2);
int nDisplay = strYesNo.find(strDisplay, 0);

PropDouble dTextHeight(0, U(-1), T("Text Height"));

int defaultAltModel = bodyCouldBeValid ? 0 : 1;
String strAltSolidNY[]= {T("No"), T("Yes")};
PropString strAltModel (3, strAltSolidNY, T("|Draw alt solid|"), defaultAltModel);
int nAltModel = strAltSolidNY.find(strAltModel, 0);

String arSAddHardwareEvent[] = {
	T("Model")
};

Map mpHanger=mpHangers[nModel];

// on Insert
if (_bOnInsert) 
{
	PrEntity ssE("\n"+T("Select male beams"), Beam());
	Beam bms[0];
	if (ssE.go()) { // let the prompt class do its job, only one run
		bms= ssE.beamSet(); 
		Beam bm = (Beam)bms[0];
		_Entity.append(bm);
	}

	Beam bm1 = getBeam("\n"+T("Select female beam"));
	if (!bm1.bIsValid()) {
		eraseInstance();
		return;
	}
	_Entity.append(bm1);
		
  	return;
}
//end on insert

String strInvertHanger = T("|Invert Hanger|");
addRecalcTrigger(_kContext, strInvertHanger );

if (_bOnRecalc && _kExecuteKey==strInvertHanger )
{
	int isInverted=_Map.getInt("IsInverted");
	_Map.setInt("IsInverted", isInverted ? false : true);
}

Display dp(-1);
dp.dimStyle(sDimLayout);
dp.showInDxa(true);

if (dTextHeight!=-1)
{
	dp.textHeight(dTextHeight);
}

Point3d ptDisplay;

Entity entMale[]=_Map.getEntityArray("MaleBeams", "MaleBeams", "asd");
Entity entFemale[]=_Map.getEntityArray("FemaleBeams", "FemaleBeams", "asd");
double dTolerance=mpHanger.getDouble("Tolerance");

Entity entMales[0];
Entity entFemales[0];
CoordSys entMaleCoords[0];
Quader entMaleQuaders[0];
Quader entFemaleQuaders[0];
Point3d ptAllMales[0];
Point3d ptAllFemales[0];
CoordSys entFemaleCoords[0];

_Entity.setLength(0);
String trussDefinitions[0];
Quader trussDefinitionQuaders[0];
for (int i=0; i<entMale.length(); i++)
{
	Beam bm=(Beam) entMale[i];
	if (bm.bIsValid())
	{
		entMales.append(bm);
		_Entity.append(bm);
		ptAllMales.append(bm.ptCen());
		entMaleCoords.append(bm.coordSys());
		entMaleQuaders.append(bm.quader());
		continue;
	}
	
	TrussEntity truss = (TrussEntity)entMale[i];
	if(truss.bIsValid())
	{ 
		Point3d ptTrussOrg = truss.coordSys().ptOrg();
		CoordSys coordSysTruss = truss.coordSys();
		entMales.append(truss);
		_Entity.append(truss);
		ptAllMales.append(ptTrussOrg);
		entMaleCoords.append(coordSysTruss);

		Quader trussQuader;
		int indexOfTrussDefinition = trussDefinitions.find(truss.definition());
		if( indexOfTrussDefinition == -1)
		{ 
			//Build new quader
			TrussDefinition trussDefinition(truss.definition());
			Entity entities[] = trussDefinition.entity();
			Point3d allEntVertices[0];
			for(int x=0;x<entities.length();x++)
			{
				Entity ent = entities[i];
				Body bd = ent.realBody();
				allEntVertices.append(bd.allVertices());
			}
			
			if (allEntVertices.length() > 0)
			{
				Line lnX(allEntVertices[0], _XW);
				Line lnY(allEntVertices[0], _YW);
				Line lnZ(allEntVertices[0], _ZW);
				
				Point3d ptXOrdered[] = lnX.orderPoints(allEntVertices);
				Point3d ptYOrdered[] = lnY.orderPoints(allEntVertices);
				Point3d ptZOrdered[] = lnZ.orderPoints(allEntVertices);
				
				for (int y = 0; y < ptZOrdered.length(); y++)
				{
					ptZOrdered[y].vis(1);
				}
				
				double quaderX = abs((ptXOrdered[0] - ptXOrdered[ptXOrdered.length() - 1]).dotProduct(_XW));
				double quaderY = abs((ptYOrdered[0] - ptYOrdered[ptYOrdered.length() - 1]).dotProduct(_YW));
				double quaderZ = abs((ptZOrdered[0] - ptZOrdered[ptZOrdered.length() - 1]).dotProduct(_ZW));
				
				Quader qdTrussDefinition(_PtW, _XW, _YW, _ZW, quaderX, quaderY, quaderZ, -1, 1, 0);
				trussDefinitionQuaders.append(qdTrussDefinition);
			}
			else
			{ 
				trussDefinitionQuaders.append(Quader());
			}
			
			indexOfTrussDefinition = trussDefinitionQuaders.length() - 1;
		}


		Quader trussDefinitionQuader = trussDefinitionQuaders[indexOfTrussDefinition];
		CoordSys csTransform;
		
		int xfac = 1;
		if( coordSysTruss.vecX().dotProduct(_Pt0 - ptTrussOrg) == 0)
		{ 
			xfac = - 1;
		}
		csTransform.setToAlignCoordSys(_PtW, _XW, _YW, _ZW, _Pt0, coordSysTruss.vecX()*xfac, coordSysTruss.vecY(), coordSysTruss.vecZ());
		trussDefinitionQuader.transformBy(csTransform);
		trussDefinitionQuader.vis();
		
		
		trussQuader = trussDefinitionQuader;
		entMaleQuaders.append(trussQuader);
	}
}

Point3d ptCenterMales;
ptCenterMales.setToAverage(ptAllMales);

for (int i=0; i<entFemale.length(); i++)
{
	Beam bm=(Beam) entFemale[i];
	if (bm.bIsValid())
	{
		entFemales.append(bm);
		_Entity.append(bm);
		ptAllFemales.append(bm.ptCen());
		entFemaleCoords.append(bm.coordSys());
		entFemaleQuaders.append(bm.quader());
	}
	
	TrussEntity truss = (TrussEntity)entFemale[i];
	if(truss.bIsValid())
	{ 
		CoordSys coordSysTruss = truss.coordSys();
		Point3d ptTrussOrg = truss.coordSys().ptOrg();
		
		entFemales.append(truss);
		_Entity.append(truss);
		ptAllFemales.append(ptTrussOrg);
		entFemaleCoords.append(coordSysTruss);
		
		Quader trussQuader;
		int indexOfTrussDefinition = trussDefinitions.find(truss.definition());
		if( indexOfTrussDefinition == -1)
		{ 
			//Build new quader
			TrussDefinition trussDefinition(truss.definition());
			Entity entities[] = trussDefinition.entity();
			Point3d allEntVertices[0];
			for(int x=0;x<entities.length();x++)
			{
				Entity ent = entities[i];
				Body bd = ent.realBody();
				allEntVertices.append(bd.allVertices());
			}
			
			if (allEntVertices.length() > 0)
			{
				Line lnX(allEntVertices[0], _XW);
				Line lnY(allEntVertices[0], _YW);
				Line lnZ(allEntVertices[0], _ZW);
				
				Point3d ptXOrdered[] = lnX.orderPoints(allEntVertices);
				Point3d ptYOrdered[] = lnY.orderPoints(allEntVertices);
				Point3d ptZOrdered[] = lnZ.orderPoints(allEntVertices);
				
				double quaderX = (ptXOrdered[0] - ptXOrdered[ptXOrdered.length() - 1]).length();
				double quaderY = (ptYOrdered[0] - ptYOrdered[ptYOrdered.length() - 1]).length();
				double quaderZ = (ptZOrdered[0] - ptZOrdered[ptZOrdered.length() - 1]).length();
				
				Quader qdTrussDefinition(_PtW, _XW, _YW, _ZW, quaderX, quaderY, quaderZ, 1, 1, 0);
				trussDefinitionQuaders.append(qdTrussDefinition);
			}
			else
			{ 
				trussDefinitionQuaders.append(Quader());
			}
			
			indexOfTrussDefinition = trussDefinitionQuaders.length() - 1;
		}

		Quader trussDefinitionQuader = trussDefinitionQuaders[indexOfTrussDefinition];
		CoordSys csTransform;
		csTransform.setToAlignCoordSys(_PtW, _XW, _YW, _ZW, ptTrussOrg, coordSysTruss.vecX(), coordSysTruss.vecY(), coordSysTruss.vecZ());

		trussDefinitionQuader.transformBy(csTransform);
		trussQuader = trussDefinitionQuader;
		
		entFemaleQuaders.append(trussQuader);
	}
}

if (mpHanger.getInt("External") == 1) 
{
	// Special case from hanger import - just need to create the visual.
	String faceDefinitionArray = "FACEDEFINITION[]";
	if(mpHanger.hasMap(faceDefinitionArray))
	{
		Vector3d vFNormal[0];
		double dFThick[0];
		PLine plFace[0];

		Map mpHangerShape = mpHanger.getMap(faceDefinitionArray);
		for (int i=0; i<mpHangerShape.length(); i++)
		{
			//Collect All Faces
			if (mpHangerShape.keyAt(i)=="FACEDEFINITION")
			{
				Map mp = mpHangerShape.getMap(i);
						
				vFNormal.append(mp.getPoint3d("Normal"));
				dFThick.append(mp.getDouble("Thickness"));
	 			plFace.append(mp.getPLine("PLine"));
			}
		}
		
		Body bd;
		for (int i = 0; i < plFace.length(); i++)
		{
			Body bdFacePart=Body(plFace[i], vFNormal[i]*dFThick[i], 1);
			bd.combine(bdFacePart);
		}
		
		dp.draw(bd) ;

		return;
	}
} 

if (mpHanger.getInt("External") == 2)
{
	// Special case from hanger import - External is set to 2 when inserted from ifc import
	
	//Database export
	exportToDxi(TRUE);
	dxaout("MODEL",sModel);
	dxaout("QUANTITY",1);
	
	setCompareKey(sModel);
	_ThisInst.setAllowGripAtPt0(false);
	
	int somethingDrawn = false;
	if (nAltModel == 1)
	{
		Map mpPls = mpHanger.getMap("BodyPlines");
		for (int p = 0; p < mpPls.length(); p++)
		{ 
			somethingDrawn = true;
			PLine pl = mpPls.getPLine(p);
			dp.draw(PlaneProfile(pl), _kDrawAsShell);
		}
	}
	
	if (!somethingDrawn)
	{ 
		Body bd = mpHanger.getBody("body");
		dp.draw(bd);
	}

	return;
}

if (entMales.length() < 1)
{
	eraseInstance();
	return;
}

Vector3d vX0, vY0, vZ0;
Vector3d vX1, vY1, vZ1;
Vector3d vDirection = _Pt0 - ptAllMales[0];
Entity firstEntMale = entMales[0];


vDirection.normalize();

Point3d ptCon;
vX0=entMaleCoords[0].vecX();
Quader qdM = entMaleQuaders[0];

//Entity specific stuff
if(firstEntMale.bIsKindOf(Beam()))
{ 
	Beam bm = (Beam) firstEntMale;
	vZ0 =bm.vecD(_ZU);
}
else if (firstEntMale.bIsKindOf(TrussEntity()))
{
	TrussEntity truss = (TrussEntity) firstEntMale;
	
	Vector3d vecDir = _ZU;
	Vector3d vecY = truss.coordSys().vecY();
	Vector3d vecZ = truss.coordSys().vecZ();
	Vector3d vecRet = vecZ; //the vecZ direction
	if (abs(vecDir.dotProduct(vecY)) > abs(vecDir.dotProduct(vecZ))) 
	{ 
		vecRet = vecY;
	}
	if (vecDir.dotProduct(vecRet) < 0) vecRet = - vecRet;
	vZ0 = vecRet;
}

Line ln0(ptCenterMales, vX0);
Entity entClosestFemale;	
int indexOfClosestFemale = - 1;

if (entFemales.length()>0)
{
 	//Find closest female beam
	double dSmallestDistanceToFemaleBeam;
	for(int i=0;i<entFemales.length();i++)
	{
		Entity ent = entFemales[i];
		Point3d ptFemaleCenter = ptAllFemales[i];
		if(i==0)
		{
			dSmallestDistanceToFemaleBeam= abs((ptFemaleCenter - ptCenterMales).length());
			entClosestFemale=ent;
			indexOfClosestFemale = i;
			continue;
		}
		
		double dDistanceToCurrentFemaleBeam= abs((ptFemaleCenter - ptCenterMales).length());
		if(dDistanceToCurrentFemaleBeam < dSmallestDistanceToFemaleBeam)
		{
			dSmallestDistanceToFemaleBeam = dDistanceToCurrentFemaleBeam ;
			entClosestFemale=ent;
			indexOfClosestFemale = i;
		}
	}
	
	Line ln1(ptAllFemales[indexOfClosestFemale], entFemaleCoords[indexOfClosestFemale].vecX());
	ptCon=ln0.closestPointTo(ln1);

	if (vX0.dotProduct(ptCenterMales-ptCon) >= 0)
	{
		vX0=-vX0;
	}
	
	Beam bmClosestFemale = (Beam) entClosestFemale;
	if (bmClosestFemale.bIsValid())
	{
		for (int i = 0; i < entMales.length(); i++)
		{
			Entity ent = entMales[i];
			if ( ! ent.bIsKindOf(Beam())) continue;
			
			Beam bmM = (Beam)ent;
			bmM.stretchDynamicTo(bmClosestFemale);
		}
	}
}
else
{
	if(_Map.hasPoint3d("PreviousOrigin"))
	{
		_Pt0=_Map.getPoint3d("PreviousOrigin");
	}

	ptCon=_Pt0;

	if (vX0.dotProduct(ptCon-ptCenterMales) <= 0)
	{
		vX0=-vX0;
	}
	vX0.normalize();
	vX0.vis(_Pt0);

	Cut ct(_Pt0, vX0);
	for(int i=0; i < entMales.length(); i++)
	{
		Entity ent = entMales[i];
		if ( ! ent.bIsKindOf(Beam())) continue;
		
		Beam bmM = (Beam)ent;
		bmM.addToolStatic(ct, _kStretchOnInsert);
	}
}

vY0=vZ0.crossProduct(vX0);
Plane plMaleMid(ptCenterMales, vY0);
ptCon=ptCon.projectPoint(plMaleMid, 0);

Line lnUp=qdM.lnEdgeD(vX0, vZ0);
Line lnDown=qdM.lnEdgeD(vX0, -vZ0);

Point3d ptTopFemale;
Point3d ptBottomMale;
Point3d ptTopMale;
if (entFemales.length()>0)
{
	CoordSys& coordSysClosestFemale = entFemaleCoords[indexOfClosestFemale];
	//Most aligned vector	
	Vector3d vecDir = vX0;
	Vector3d vecY = coordSysClosestFemale.vecY();
	Vector3d vecZ = coordSysClosestFemale.vecZ();
	Vector3d vecRet = vecZ; //the vecZ direction
	if (abs(vecDir.dotProduct(vecY)) > abs(vecDir.dotProduct(vecZ))) 
	{ 
		vecRet = vecY;
	}
	if (vecDir.dotProduct(vecRet) < 0) vecRet = - vecRet;
	
	vZ1 = vecRet;

	Quader qdrClosestFemale = entFemaleQuaders[indexOfClosestFemale];
	Plane pnFace(qdrClosestFemale.ptOrg()-vZ1*(qdrClosestFemale.dD(vZ1)*0.5), vZ1);

	Line lnCenterMales(ptCenterMales, vX0);
	ptCon=lnCenterMales.intersect(pnFace, 0);

	Quader& qd = qdrClosestFemale;
	Line ln=qd.lnEdgeD(-vZ1, vZ0);
	
	ptTopFemale=ln.closestPointTo(ptCon);
	
	ptBottomMale=lnDown.closestPointTo(ptCon);
	ptTopMale = lnUp.closestPointTo(ptCon);
	
	//Ensure that the points lie on the face of the female
	Line lnBottom(ptBottomMale, vX0);
	Line lnTop(ptTopMale, vX0);

	ptBottomMale=lnBottom.intersect(pnFace,0);
	ptTopMale=lnTop.intersect(pnFace,0);

	Vector3d vecAux=ptTopMale-ptBottomMale;
	vecAux.normalize();

	vY1 = vecAux;
	vX1 = vY1.crossProduct(vZ1);
}
else
{
	vX1 = vY0;
	vY1 = _ZU;
	vZ1= vX1.crossProduct(vY1);
		
	ptTopFemale=lnUp.closestPointTo(ptCon);
	ptBottomMale=lnDown.closestPointTo(ptCon);
	ptTopMale = lnUp.closestPointTo(ptCon);
}

double dHW;
for (int i=0; i<entMaleQuaders.length(); i++)
{
	dHW+=entMaleQuaders[i].dD(vY0);
}

double dWF=0;
for (int i=0; i<entFemaleQuaders.length(); i++)
{
	dWF+=entFemaleQuaders[i].dD(vZ1);
}

//vX0-(ptCon, 1);
//vY0.vis(ptCon, 2);
//vZ0.vis(ptCon, 150);

vX1.vis(ptCon, 1);
vY1.vis(ptCon, 2);
vZ1.vis(ptCon, 150);

ptTopFemale.vis(4);
ptBottomMale.vis(8);

//Redefinition of pt0 is required to maintain the grip point at a relevant location
_Pt0=ptBottomMale;
// HSB-9099 when only male beams apply cut only at dbCreate
Cut ct;
if(entFemales.length()==0)
{ 
	// 12890 only males, tolerance cut only on dbcreated
	if(_bOnDbCreated)
	{
		// HSB-12890: when no female beams. Only male beams
		ct=Cut (ptBottomMale-vZ1*dTolerance, vZ1);
		setExecutionLoops(2);
	}
	else
	{ 
		ct=Cut (ptBottomMale, vZ1);
		ptBottomMale += vZ1 * dTolerance;
	}
}
else
{
	// 12890: male and females
	ct=Cut (ptBottomMale-vZ1*dTolerance, vZ1);
}

for (int i=0; i<entMales.length(); i++)
{
	Entity ent = entMales[i];
	if ( ! ent.bIsKindOf(Beam())) continue;
	
	Beam bm = (Beam)ent;
	bm.addTool(ct, _kStretchOnInsert);
}

//Display
Vector3d vxDisp=vX0;
Vector3d vyDisp=vY0;

double dHH=_ZU.dotProduct(ptTopFemale-ptBottomMale);

// Construct coord sys for script from geometry
Vector3d vY = vY0 ;
Vector3d vZ = _ZU ;

Vector3d vX = vY0.crossProduct(vZ);

vX.vis(_Pt0, 4) ;
vY.vis(_Pt0, 4) ;
vZ.vis(_Pt0, 4) ;


//Get some dimensions from beams
double dMW = dHW;
double dMH = dHH;

Vector3d vFNormal[0];
double dFThick[0];
int bBendable[0];
PLine plFace[0];
Point3d ptFOrigen[0];
		
if(nGeneric)
{
	//Draw a generic hanger
	Point3d ptSt = _Pt0;		ptSt.vis(2);
	Body bd( ptSt, vX, vY, vZ, U(75), dMW +2, U(1), -1, 0, -1 ) ;
	bd.vis();
	ptSt =  ptSt + vY * ( dMW/2 )  ; 
	PLine plSide( vY ) ;
	Point3d pt  = ptSt ;

	plSide.addVertex( ptSt ) ;
	
	pt = pt + vZ * dMH  ;
	plSide.addVertex( pt ) ;
	pt = pt - vX * U(25)  ;
	plSide.addVertex( pt ) ;
	pt = pt -vZ * dMH * .666  ;
	plSide.addVertex( pt ) ;
	pt =pt -vX * 50 - vZ * U(50) ;
	plSide.addVertex( pt ) ;
	pt = pt -vZ * (dMH * .333 - U(50) ) ;
	plSide.addVertex( pt ) ;
	plSide.addVertex( ptSt ) ;
	
	Body bdSide ( plSide, vY ) ;
	Body bdSide1;
	bdSide1.copyPart( bdSide ) ;
	bdSide1.transformBy( -vY * (dMW + U(1) ) ) ;
	
	PLine plFace( vX ) ;
	ptSt  = ptSt + vZ * dMH ;
	plFace.addVertex( ptSt ) ;
	pt = ptSt + vY * U(50) ;
	plFace.addVertex( pt ) ;
	pt = pt - vZ * (dMH * .666 ) ;
	plFace.addVertex( pt ) ;
	pt = pt - vY * U(50) - vZ * U(25) ;
	plFace.addVertex( pt ) ;
	plFace.addVertex( ptSt ) ;
	Body bdFace( plFace, -vX ) ;
	
	Body bdFace1 ;
	bdFace1.copyPart( bdFace ) ;
	CoordSys cs ;
	cs.setToMirroring( Plane( _Pt0, vY ) ) ;
	bdFace1.transformBy( cs ) ;
	 
	bd.addPart ( bdSide ) ;
	bd.addPart ( bdSide1 ) ;
	bd.addPart ( bdFace ) ;
	bd.addPart ( bdFace1 ) ;
	
	dp.draw( bd ) ;
}
else
{
	//Draw this Hanger
	String faceDefinitionArray = "FACEDEFINITION[]";
	if(mpHanger.hasMap(faceDefinitionArray))
	{
		Map mpHangerShape = mpHanger.getMap(faceDefinitionArray);
		for (int i=0; i<mpHangerShape.length(); i++)
		{
			//Collect All Faces
			if (mpHangerShape.keyAt(i)=="FACEDEFINITION")
			{
				Map mp = mpHangerShape.getMap(i);
				vFNormal.append(mp.getPoint3d("Normal"));
				dFThick.append(mp.getDouble("Thickness"));
				bBendable.append(mp.getInt("Bendable"));
				
				PLine plThisFace=mp.getPLine("PLine");
				
				Point3d ptThisFace=mp.getPoint3d("Origin");
				ptFOrigen.append(ptThisFace);
				
				Point3d vertices[]=plThisFace.vertexPoints(true);
				
	 			plFace.append(plThisFace);
		
			}
		}
	}
}

CoordSys cs;
int bIsInverted=_Map.getInt("IsInverted") ;
Vector3d vecInversion = bIsInverted ? -vY1 : vY1;
Point3d ptInsertion = bIsInverted ? ptTopMale : ptBottomMale;

cs.setToAlignCoordSys(_PtW, _XW, _YW, _ZW, ptInsertion, - vX1, vZ1, vecInversion); ptInsertion.vis(3);

Vector3d vecCritical = ptTopFemale - ptBottomMale;
double dCriticalHeight=(vecCritical).length();
Plane plHangerBottom(_PtW, _ZW);
for (int i=0; i<plFace.length(); i++)
{
	PLine plFaceCurr=plFace[i];

	Vector3d vecFaceNormal=vFNormal[i];
	int isBendable=bBendable[i];
	double faceThickness= dFThick[i];
	Point3d faceVertices[]=plFaceCurr.vertexPoints(true);
	Point3d ptOnFace;
	if(faceVertices.length()==0) { continue; }

	ptOnFace=faceVertices[0];
	vecFaceNormal.vis(ptOnFace);
		
	Body bd;
	if(isBendable && entFemales.length() > 0)
	{
		PlaneProfile ppFace(plFaceCurr);
		LineSeg boundingBox = ppFace.extentInDir(_ZW);
		Point3d boundingStart = boundingBox.ptStart();
		Point3d boundingEnd = boundingBox.ptEnd();
		Vector3d boundingVector = boundingEnd - boundingStart;
		double verticalLengthOfFace=abs(boundingVector .dotProduct(_ZW));
		double horizontalLengthOfFace = abs((boundingVector).dotProduct(_XW));

		Vector3d vecSideways=_ZW.crossProduct(vecFaceNormal);
		double dBottomToEndOfFace = abs((boundingEnd - _PtW).dotProduct(_ZW));
		Vector3d previousExtrusionDirection;
		Point3d previousBendPoint;
		if(dBottomToEndOfFace > dCriticalHeight)
		{
			Body bdParts[0];
			double bendingSizes[]={dCriticalHeight, dWF, 0};
			Vector3d extrusionDirections[]={vecFaceNormal, _ZW, _YW};
			Plane plVeryHigh(boundingStart  + U(1000) * _ZW, _ZW);
			Vector3d offsetVector=U(5) * _XW;
			
			double totalCompletedBendingSize=0;
			for(int x=0;x<bendingSizes.length();x++)
			{
				double bendingSize=bendingSizes[x];
				 
				Vector3d extrusionDirection=extrusionDirections[x];
			
				PlaneProfile ppFacePart(ppFace);
				
				//Create top subtraction rectangle
				Point3d boundingStartProjectedToBottom = boundingStart.projectPoint(plHangerBottom, 0);
				Point3d boundingEndProjectedToBottom = boundingEnd.projectPoint(plHangerBottom, 0);

				int bReversed=false;				
				if(x!=bendingSizes.length()-1)
				{				
					//Top subtraction
					Point3d ptTopSubtractStart = boundingStartProjectedToBottom + (totalCompletedBendingSize + faceThickness) * _ZW + bendingSize * _ZW + offsetVector;
					ptTopSubtractStart.vis();
					ppFace.vis();
					if(ppFace.pointInProfile(ptTopSubtractStart)!=_kPointOutsideProfile)
					{
						bReversed=true;
						ptTopSubtractStart = boundingStartProjectedToBottom + bendingSize * _ZW - offsetVector;
					}
											
					Point3d ptTopSubtractEnd = bReversed? boundingEnd.projectPoint(plVeryHigh, 0) +  offsetVector : boundingEnd.projectPoint(plVeryHigh, 0) - offsetVector ;
					PLine plTopFaceSubtract(vecFaceNormal);
					plTopFaceSubtract.createRectangle(LineSeg(ptTopSubtractStart, ptTopSubtractEnd), _XW, _ZW);
					LineSeg facePartExtents = ppFacePart.extentInDir(_ZW);
	
					PlaneProfile ppTopFaceSubtract(plTopFaceSubtract);

	  				ppFacePart.subtractProfile(ppTopFaceSubtract);

					
					if(x==0 && ppFacePart.area()==0) 
					{
						
						//ptInsertion.vis(2);
						totalCompletedBendingSize += (facePartExtents.ptStart() - boundingStartProjectedToBottom).dotProduct(_ZW);
						previousBendPoint = facePartExtents.ptStart() - faceThickness * _ZW ;
						previousBendPoint.vis(3);
						previousExtrusionDirection = extrusionDirection;		
						
						continue;
					}
					else if(ppFacePart.area()==0) 
					{
						continue;
					}
					
					if(x==0)
					{
						previousBendPoint = ptTopSubtractStart - faceThickness * _ZW ;
						previousBendPoint.vis(3);
						
					}
				}
				
				//Create bottom subtraction rectangle
				if(totalCompletedBendingSize > 0)
				{

					Point3d ptBottomSubtractStart =bReversed ? boundingStartProjectedToBottom - offsetVector : boundingStartProjectedToBottom + offsetVector;
					Point3d ptBottomSubtractEnd = bReversed ? boundingEndProjectedToBottom + (totalCompletedBendingSize + faceThickness) * _ZW + offsetVector : 
													boundingEndProjectedToBottom + totalCompletedBendingSize * _ZW - offsetVector;
					
					PLine plBottomFaceSubtract(vecFaceNormal);
					plBottomFaceSubtract.createRectangle(LineSeg(ptBottomSubtractStart , ptBottomSubtractEnd ), _XW, _ZW);
					plBottomFaceSubtract.vis(x);
										
					PlaneProfile ppBottomFaceSubtract(plBottomFaceSubtract);
  					ppFacePart.subtractProfile(ppBottomFaceSubtract);
					if(ppFacePart.area()==0) { continue; }
					//Get extents of new face
					LineSeg newFacePartExtents = ppFacePart.extentInDir(_ZW);
					double dExtentLength=(newFacePartExtents.ptEnd() - newFacePartExtents.ptStart()).dotProduct(_ZW);
										
					CoordSys csTransform;
					Plane bendPlane(ptBottomSubtractEnd, _XW);
					Point3d bendPoint=previousBendPoint.projectPoint(bendPlane, 0);
					
					ptBottomSubtractEnd.vis(x);
					bendPoint.vis(x);
					csTransform.setToAlignCoordSys(ptBottomSubtractEnd, vecFaceNormal, _XW, _ZW, bendPoint , extrusionDirection, _XW, extrusionDirection.crossProduct(_XW));
					ppFacePart.transformBy(csTransform);
					
					CoordSys csTransformNewBendPoint;
					csTransformNewBendPoint.setToAlignCoordSys(ptBottomSubtractEnd, vecFaceNormal, _XW, _ZW, bendPoint - (dExtentLength - faceThickness)* previousExtrusionDirection , extrusionDirection, _XW, extrusionDirection.crossProduct(_XW));
					ptBottomSubtractEnd.transformBy(csTransformNewBendPoint);
					previousBendPoint = ptBottomSubtractEnd ;
					ptBottomSubtractEnd.vis(x+2);
					
				}

				ppFacePart.vis(x+5);
				
				PLine ppFacePartRings[]=ppFacePart.allRings();
				Body bdFacePart;
				//CS: Assumption, no rings are openings!
				for(int p=0;p<ppFacePartRings.length();p++)
				{
					if(p==0)
					{
						bdFacePart=Body(ppFacePartRings[p], extrusionDirection*faceThickness, 1);
					}
					else
					{
						bdFacePart.addPart(Body(ppFacePartRings[p], extrusionDirection*faceThickness, 1));
					}
					
					bdParts.append(bdFacePart);
				}
				
				
				totalCompletedBendingSize += bendingSize;
				previousExtrusionDirection = extrusionDirection;		
			}
			for(int x=0;x<bdParts.length();x++)
			{
				if(x==0)
				{
					bd=bdParts[x];
					continue;
				}
				bd.addPart(bdParts[x]);
			}
		}
		else
		{
			bd=Body(plFaceCurr, vecFaceNormal*faceThickness, 1);
		}
	}
	else
	{
		plFaceCurr.vis(1);
		bd=Body(plFaceCurr, vecFaceNormal*faceThickness, 1);
		
	}

	bd.transformBy(cs);
	dp.draw(bd);
}

if (!_Map.hasInt("nSetOrg"))
{
	double	dHeightOfText = dTextHeight == -1 ? dp.textHeightForStyle("A", sDimLayout) : dTextHeight;
	_PtG.append(_Pt0-vX0*dHangerDepth*0.5+vY0*(0.5*dHW + 0.5*dHeightOfText + U(10, "mm")));
}

_Map.setInt("nSetOrg", TRUE);

Vector3d vecTextX=_PtG[0]-_Pt0;
vecTextX.normalize();
Plane pln(ptBottomMale, _ZW);
_PtG[0]=pln.closestPointTo(_PtG[0]);

Point3d ptDraw = _PtG[0];
if (nDisplay==1)
{
	dp.draw(sModel, ptDraw, -vX0, -vY0, 1, 0, _kModel); // draw a string with default text style with lower left corner at pnt1
}
else if (nDisplay==2)
{
	dp.draw(sType, ptDraw, -vX0, -vY0, 1, 0, _kModel);	
}

// Set flag to create hardware.
int bAddHardware = _bOnDbCreated;
if (_ThisInst.hardWrComps().length() == 0)
	bAddHardware = true;
if (arSAddHardwareEvent.find(_kNameLastChangedProp) != -1)
	bAddHardware = true;

// add hardware if model has changed or on creation
if (bAddHardware) {
	String sArticleNumber = sModel;
	String sDescription = "Hanger " + sArticleNumber;
	sDescription.makeUpper();

	// declare hardware comps for data export
	HardWrComp hwComps[0];
       HardWrComp hw(sArticleNumber, 1);
	
	hw.setCategory(T("|Connectors|"));
	hw.setManufacturer("");
	hw.setModel(sArticleNumber);
	hw.setMaterial(T("|Steel, zincated|"));
	hw.setDescription(sDescription);
	hw.setDScaleX(0);
	hw.setDScaleY(0);
	hw.setDScaleZ(0); 
	hwComps.append(hw);

	_ThisInst.setHardWrComps(hwComps);
}

//export to dxa if linked to element
Element el;
if (_Entity.length() > 0)
{
	el = _Entity[0].element();
	if ( ! el.bIsValid())
	{
		if (_Entity.length() > 1)
		{
			el = _Entity[1].element();
		}
	}
}

if (el.bIsValid())
{
	assignToElementGroup(el, true, 0, 'I');
	
	String sDescription = "Hanger";
	sDescription.makeUpper();
	Map itemMapFixing= Map();
	itemMapFixing.setString("DESCRIPTION", sDescription );
	itemMapFixing.setString("LENGTH", "");
	itemMapFixing.setString("WIDTH", "");
	itemMapFixing.setString("THICKNESS","");
	itemMapFixing.setString("DIAMETER","");
	itemMapFixing.setString("QUANTITY",1); 
	itemMapFixing.setString("MATERIAL","");
	itemMapFixing.setString("ARTICLENUMBER",sModel);
	
	ElemItem itemFixing(1, "HANGER", _Pt0, el.vecZ(), itemMapFixing);
	itemFixing.setShow(_kNo);
	el.addTool(itemFixing);
	
	Map mapSub;
	mapSub.setString("Name", sModel);
	mapSub.setInt("Qty", 1);
	mapSub.setDouble("Width", 0);
	mapSub.setDouble("Length", 0);
	mapSub.setDouble("Height", 0);				
	mapSub.setString("Mat", "");
	mapSub.setString("Grade", "");
	mapSub.setString("Info", "");
	mapSub.setString("Volume", "");						
	mapSub.setString("Profile", "");	
	mapSub.setString("Label", "");					
	mapSub.setString("Sublabel", "");					
	mapSub.setString("Type", "BMF" + 0);						
	_Map.setMap("TSLBOM", mapSub);
}

//Database export
exportToDxi(TRUE);
dxaout("MODEL",sModel);
dxaout("QUANTITY",1);

//HsbBom export
Map mp;
mp.setString("Name", sModel);
mp.setInt("Qty", 1);

_Map.setMap("TSLBOM", mp);  //There is another TSL BOM above ??

setCompareKey(sModel);

_ThisInst.setAllowGripAtPt0(false);








#End
#BeginThumbnail





















#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18340: alternative solid from brep" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="12-Jun-23 6:21:20 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18340: Support for ifc import and visualization from external source as body." />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="05-Jun-23 8:28:56 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-12890: distinguish between only male beams and male+female beams" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="14" />
      <str nm="DATE" vl="01-Jan-01 12:00:00 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="ff" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="13" />
      <str nm="DATE" vl="01-Jan-01 12:00:00 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End