#Version 8
#BeginDescription
Creates fillet timbers betweeen open angled Stickframe walls and assigns the fillets to their respective elements

Modified by: Alberto Jena (aj@hsb-cad.com)
06.09.2015  -  version 1.10
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 10
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2008 by
*  hsbSOFT 
*  IRELAND
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
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 16.09.2008
* version 1.0: Release Version
*
* date: 16.09.2008
* version 1.1: Add the basic Properties of the beams that are created
*
* date: 16.09.2008
* version 1.2: Publish the Properties
*
* date: 16.09.2008
* version 1.2: Publish the Properties
*
* date: 20.01.2011
* version 1.5: Add property for Display Rep and fix issue with multiple creation of beams in some cases
*
* date: 14.04.2011
* version 1.6: Fixed Solid Beam Generation, added check for parallel walls and added hsbId=999 to fillets
*
* date: 14.04.2011
* version 1.8: All the beams are now Type Stud and have beam code "AF"
*
* date: 14.04.2015
* version 1.9: Beam Type changes to Wedge
*/

//-----------------------------------------------------------------------------------------------------------------------------------
//                                                                      Properties

//String arSCodeExternalWalls[]={	"A", "B", "C", "D"}; //Add more External Walls codes as you request
//String arSCodePartyWalls[]={	"F", "G"}; //Add more External Walls codes as you request

Unit(1,"mm"); // script uses mm

String sArYesNo[] = {T("No"), T("Yes")};

String sPath= _kPathHsbCompany+"\\Abbund\\Materials.xml";

String sFind=findFile(sPath);

if (sFind=="")
{
	reportNotice("\n Materials not been set, please run hsbMaterial Utility or contact SupportDesk");
	eraseInstance();
	return;
}

Map mp;
mp.readFromXmlFile(sPath);

String sMaterials[0];

if (mp.hasMap("MATERIAL[]"))
{
	Map mpMaterials=mp.getMap("MATERIAL[]");
	for(int i=0; i<mpMaterials.length(); i++)
	{
		Map mpMaterial=mpMaterials.getMap(i);
		if (mpMaterial.getString("MATERIAL")!="DEFAULT")
			sMaterials.append(mpMaterial.getString("MATERIAL"));
	}
}

if (sMaterials.length()==0)
{
	reportNotice("\n Materials not been set, please run hsbMaterial Utility or contact SupportDesk");
	eraseInstance();
	return;
}

PropString sStretchPlates (0,sArYesNo,T("Stretch Top and Bottom Plate"));
sStretchPlates.setDescription("If YES then the top and bottom plate will be stretch creating a miter connection, otherwise the Angle Fillets will be the full heigth of the wall");

PropString sFullBeam (1,sArYesNo,T("Create a Full Solid Beam"));
sFullBeam.setDescription("If YES then a full solid beam will be created and will be attach to one of the elements, otherwise 2 half beams will be put in place");

PropString strNailing (9, sArYesNo,T("Set Fillets as NO Nail"));

//Basic Properties of the Beams
PropString sName (2, "Fillet", "Name");
sName.setCategory(T("Beam Properties"));
PropString sMaterial (3, sMaterials, "Material");
sMaterial.setCategory(T("Beam Properties"));
PropString sGrade (4, "", "Grade");
sGrade.setCategory(T("Beam Properties"));
PropString sInformation (5, "", "Information");
sInformation.setCategory(T("Beam Properties"));
PropString sLabel (6, "", "Label");
sLabel.setCategory(T("Beam Properties"));
PropString sSublabel (7, "", "Sublabel");
sSublabel.setCategory(T("Beam Properties"));
PropString sSublabel2 (8, "", "Sublabel2");
sSublabel2.setCategory(T("Beam Properties"));

PropInt nColor (0, 32, "Color");
nColor.setCategory(T("Beam Properties"));

int nBeamType= _kTRWedge;


//String sArNY[] = {T("No"), T("Yes")};

//PropString sName(0,"SolePlate","Name");
//sName.setDescription("");


//PropDouble dExtraPercent (12, 10, T("Extra Percent for Materials"));
//dExtraPercent.setDescription("");

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

int nStretchPlates=sArYesNo.find(sStretchPlates);
int nFullBeam=sArYesNo.find(sFullBeam);
int nNoNail=sArYesNo.find(strNailing);

//-----------------------------------------------------------------------------------------------------------------------------------
//                                                                           Insert

if(_bOnInsert){
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	if (_kExecuteKey=="")
		showDialogOnce();
	
	PrEntity ssE("\n"+T("Select 2 Elements"),Element());
	
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	_Map.setInt("nExecutionMode", 1);
	
	return;
}

if( _Element.length()==0 || _Element.length()!=2){
	eraseInstance();
	return;
}

String strChangeEntity = T("Reapply Timbers");
addRecalcTrigger(_kContext, strChangeEntity );
if (_bOnRecalc && _kExecuteKey==strChangeEntity) {
_Map.setInt("nExecutionMode", 1);
}



if (_bOnElementConstructed)
{
	_Map.setInt("nExecutionMode", 1);
}

//Reference Elemen
ElementWall el = (ElementWall) _Element[0];
if (!el.bIsValid())
{
	eraseInstance();
	return;
}

//Connected Element
ElementWall elC = (ElementWall) _Element[1];
if (!elC.bIsValid())
{
	eraseInstance();
	return;
}
if(abs(el.vecX().dotProduct(elC.vecX())))
{
	eraseInstance();
	return;
}

Beam bmAll[]=el.beam();
Beam bmAllC[]=elC.beam();

if (bmAll.length()==0 || bmAllC.length()==0)
{
	return;
}

double dBmWidth=el.dBeamWidth(); //38
double dBmHeight=el.dBeamHeight(); //89   140

CoordSys cs=el.coordSys();
Vector3d vx=cs.vecX();
Vector3d vy=cs.vecY();
Vector3d vz=cs.vecZ();
Point3d ptOrgEl=cs.ptOrg();

Line lnX (ptOrgEl, vx);
Line lnXBack (ptOrgEl-vz*dBmWidth, el.vecX());

int nValidConnection=FALSE;

Element elCon[] = el.getConnectedElements();
for (int i=0; i<elCon.length(); i++)
{
	if (elCon[i].handle()==elC.handle())
	{
		nValidConnection=TRUE;
		break;
	}
}

if (!nValidConnection)
{
	eraseInstance();
	return;
}

int nExecutionMode=0;
if (_Map.hasInt("nExecutionMode"))
{
	nExecutionMode=_Map.getInt("nExecutionMode");
}

if (nExecutionMode)
{
	for (int i=0; i<_Map.length(); i++) {
		if (_Map.keyAt(i)=="bm1")
		{
			Entity ent=_Map.getEntity(i);
			ent.dbErase();
		}
		if (_Map.keyAt(i)=="bm2")
		{
			Entity ent=_Map.getEntity(i);
			ent.dbErase();
		}
	}

	CoordSys csC=elC.coordSys();
	Vector3d vxC=csC.vecX();
	Vector3d vyC=csC.vecY();
	Vector3d vzC=csC.vecZ();
	Point3d ptOrgC=csC.ptOrg();
	
	
	double dBmWidthC=elC.dBeamWidth(); //38
	double dBmHeightC=elC.dBeamHeight(); //89   140

	Line lnXC (ptOrgC, vxC);
	Line lnXBackC (ptOrgC-vzC*dBmWidthC, vxC);
	
	Point3d ptIntFront=lnX.closestPointTo(lnXC);
	Point3d ptIntBack=lnXBack.closestPointTo(lnXBackC);
	
	PLine plOut=el.plOutlineWall();
	PLine plOutC=elC.plOutlineWall();
	
	Point3d ptCenter;
	ptCenter.setToAverage(plOut.vertexPoints(TRUE));
	
	Point3d ptCenterC;
	ptCenterC.setToAverage(plOutC.vertexPoints(TRUE));
	
	Point3d ptInterior;
	Point3d ptExterior;
	
	if (abs(vx.dotProduct(ptIntFront-ptCenter))>abs(vx.dotProduct(ptIntBack-ptCenter)))
	{
		ptInterior=ptIntBack;
		ptExterior=ptIntFront;
	}
	else
	{
		ptInterior=ptIntFront;
		ptExterior=ptIntBack;
	}
	
	ptInterior.vis();
	ptExterior.vis();
	_Pt0=ptExterior;
	
	Vector3d vxConnection=vx;
	Vector3d vzConnection=ptExterior-ptInterior;
	vzConnection.normalize();
	
	Vector3d vCut=vy.crossProduct(vzConnection);
	
	Vector3d vecAux=(ptInterior-ptCenter);
	vecAux.normalize();
	
	if (vecAux.dotProduct(vx)<0) vxConnection=-vxConnection;
	
	Vector3d vxConnectionC=vxC;
	Vector3d vecAuxC=(ptInterior-ptCenterC);
	vecAuxC.normalize();
	if (vecAuxC.dotProduct(vxC)<0) vxConnectionC=-vxConnectionC;

	
	if (vCut.dotProduct(vxConnection)<0) vCut=-vCut;

	
	Beam bmHor[]=vy.filterBeamsPerpendicularSort(bmAll);
	Beam bmHorC[]=vyC.filterBeamsPerpendicularSort(bmAllC);
	Body bdInterior (ptInterior, vy, vx, -vz, U(10000), U(25), U(25), 0, 0, 0);
	//bdInterior.vis();
	
	Cut ct (ptInterior, vCut);
	Cut ctC (ptInterior, -vCut);
	vCut.vis(_Pt0, 1);
	
	if (bmHor.length()<1)
		return;
	if (bmHorC.length()<1)
		return;
	
	double dSize=abs(vx.dotProduct(ptInterior-ptExterior));
	Vector3d vzBm=vy.crossProduct(vxConnection);
	Vector3d vzBmC=vyC.crossProduct(vxConnectionC);
	
	int nOrientation;
	if (vzBm.dotProduct(vzConnection)<0)
		nOrientation=-1;
	else
		nOrientation=1;

	Beam arBmTop[] = Beam().filterBeamsHalfLineIntersectSort(bmHor, ptInterior-vCut*U(10)+vy*U(500), vy);
	Beam arBmBottom[] = Beam().filterBeamsHalfLineIntersectSort(bmHor, ptInterior-vCut*U(10)+vy*U(500), vy);
	Beam arBmTopC[] = Beam().filterBeamsHalfLineIntersectSort(bmHorC, ptInterior+vCut*U(10)+vyC*U(500), vyC);
	Beam arBmBottomC[] = Beam().filterBeamsHalfLineIntersectSort(bmHorC, ptInterior+vCut*U(10)+vyC*U(500), vyC);

	Point3d ptAux=ptInterior+vCut*U(10)+vy*U(500);
	ptAux.vis(2);

	if (nStretchPlates)
	{
		for (int i=0; i<bmHor.length(); i++)
		{
			if (bmHor[i].realBody().hasIntersection(bdInterior))
			{
				bmHor[i].addToolStatic(ct, 1);
			}
		}
		for (int i=0; i<bmHorC.length(); i++)
		{
			if (bmHorC[i].realBody().hasIntersection(bdInterior))
			{
				bmHorC[i].addToolStatic(ctC, 1);
			}
		}
}


	if (nFullBeam)
	{
		//Check if the Z vector of each element is pointing in the same direction as the vxConnections
		if(vz.dotProduct(vxConnectionC)<0)
		{
			vz=-vz;
		}
		if(vzC.dotProduct(vxConnection)<0)
		{
			vzC=-vzC;
		}

		//Check to determin whether the two walls produce an accute or obtuse angle
		int nObtuse=0;
		double dAngleBetweenZvectors=vz.angleTo(vzC);
		Cut ctA1;
		Cut ctA2;
		
		if(dAngleBetweenZvectors>90)
		{
			nObtuse=1;
		}
		
		if(nObtuse==1)
		{
			ctA1=Cut(ptExterior, vzC);
			ctA2 =Cut(ptExterior, vz);
		}
		else
		{
			ctA1=Cut(ptInterior, -vxConnection);
			ctA2=Cut(ptInterior, -vxConnectionC);
		}
		
		vxConnection.vis(ptInterior);
		vxConnectionC.vis(ptInterior);
		vz.vis(ptExterior);
		vzC.vis(ptExterior);
		
		Body bd1 (ptInterior+vy*U(200), vy, vxConnection, vy.crossProduct(vxConnection), U(50), dSize, dBmWidth, 0, 1, nOrientation);
		Body bd2 (ptInterior+vyC*U(200), vyC, vxConnectionC, vyC.crossProduct(vxConnectionC), U(50), dSize, dBmWidth, 0, 1, -nOrientation);

		bd1.vis(3);
		bd1.addTool(ctA1);
		bd1.vis(6);
		
		bd2.vis(4);
		

		bd2.addTool(ctA2);
		

		bd1.addPart(bd2);


		
		//bd1.vis(1);
		//bd1.vis(1);
		bd1.vis(3);

		Beam bmNew;
		bmNew.dbCreate(bd1,vy, vxConnection, vy.crossProduct(vxConnection));
		
		bmNew.addToolStatic(ctA1);
		bmNew.addToolStatic(ctA2);
		
		_Map.appendEntity("bm1", bmNew);
		
		if (nStretchPlates)
		{
			Cut ctBottom(bmHorC[0].ptCen()+vyC*(bmHorC[0].dD(vyC)*0.5), -vyC);
			Cut ctTop(bmHorC[bmHorC.length()-1].ptCen()-vyC*(bmHorC[bmHorC.length()-1].dD(vyC)*0.5), vyC);

			bmNew.addToolStatic(ctBottom, 1);
			bmNew.addToolStatic(ctTop, 1);
			
		}
		else
		{
			Cut ctBottom(bmHorC[0].ptCen()-vyC*(bmHorC[0].dD(vyC)*0.5), -vyC);
			Cut ctTop(bmHorC[bmHorC.length()-1].ptCen()+vyC*(bmHorC[bmHorC.length()-1].dD(vyC)*0.5), vyC);

			bmNew.addToolStatic(ctBottom, 1);
			bmNew.addToolStatic(ctTop, 1);
		}
		
		bmNew.setName(sName);
		bmNew.setMaterial(sMaterial);
		bmNew.setGrade(sGrade);
		bmNew.setInformation(sInformation);
		bmNew.setLabel(sLabel);
		bmNew.setSubLabel(sSublabel);
		bmNew.setSubLabel2(sSublabel2);
		bmNew.setBeamCode("AF;");
		bmNew.setColor(nColor);
		bmNew.setType(nBeamType);
		bmNew.setHsbId("999");
		if (nNoNail)
		{
			bmNew.setBeamCode("AF;;;;;;;;NO;");
		}
		bmNew.assignToElementGroup(el, TRUE, 0, 'Z');

	}
	else
	{
		Beam bmNew;
		bmNew.dbCreate (ptInterior+vy*U(200), vy, vxConnection, vy.crossProduct(vxConnection), U(50), dSize, dBmWidth, 0, 1, nOrientation);
		_Map.appendEntity("bm1", bmNew);
		
		Beam bmNewC;
		bmNewC.dbCreate (ptInterior+vyC*U(200), vyC, vxConnectionC, vyC.crossProduct(vxConnectionC), U(50), dSize, dBmWidth, 0, 1, -nOrientation);
		_Map.appendEntity("bm2", bmNewC);
		
		if (nStretchPlates)
		{
			Cut ctBottom(bmHorC[0].ptCen()+vyC*(bmHorC[0].dD(vyC)*0.5), -vyC);
			Cut ctTop(bmHorC[bmHorC.length()-1].ptCen()-vyC*(bmHorC[bmHorC.length()-1].dD(vyC)*0.5), vyC);

			bmNew.addToolStatic(ctBottom, 1);
			bmNew.addToolStatic(ctTop, 1);
			
			bmNewC.addToolStatic(ctBottom, 1);
			bmNewC.addToolStatic(ctTop, 1);
			
		}
		else
		{
			Cut ctBottom(bmHorC[0].ptCen()-vyC*(bmHorC[0].dD(vyC)*0.5), -vyC);
			Cut ctTop(bmHorC[bmHorC.length()-1].ptCen()+vyC*(bmHorC[bmHorC.length()-1].dD(vyC)*0.5), vyC);

			bmNew.addToolStatic(ctBottom, 1);
			bmNew.addToolStatic(ctTop, 1);
			
			bmNewC.addToolStatic(ctBottom, 1);
			bmNewC.addToolStatic(ctTop, 1);
			

		}
		
		bmNew.addToolStatic(ct);		
		bmNewC.addToolStatic(ctC);
		
		bmNew.setName(sName);
		bmNew.setMaterial(sMaterial);
		bmNew.setGrade(sGrade);
		bmNew.setInformation(sInformation);
		bmNew.setLabel(sLabel);
		bmNew.setBeamCode("AF;");
		bmNew.setSubLabel(sSublabel);
		bmNew.setSubLabel2(sSublabel2);
		bmNew.setColor(nColor);
		bmNew.setType(nBeamType);
		bmNew.setHsbId("999");
		bmNew.assignToElementGroup(el, TRUE, 0, 'Z');

		bmNewC.setName(sName);
		bmNewC.setMaterial(sMaterial);
		bmNewC.setGrade(sGrade);
		bmNewC.setInformation(sInformation);
		bmNewC.setLabel(sLabel);
		bmNewC.setSubLabel(sSublabel);
		bmNewC.setSubLabel2(sSublabel2);
		bmNewC.setColor(nColor);
		bmNewC.setBeamCode("AF;");
		bmNewC.setType(nBeamType);
		bmNewC.setHsbId("999");		
		bmNewC.assignToElementGroup(elC, TRUE, 0, 'Z');
		if (nNoNail)
		{
			bmNew.setBeamCode("AF;;;;;;;;NO;");
			bmNewC.setBeamCode("AF;;;;;;;;NO;");
		}
	}
}

assignToElementGroup(el, TRUE, 0, 'T');

_Map.setInt("nExecutionMode", 0);

//Display something
Display dp(2);

double dSize = U(25);
PLine pl1(_ZW);
PLine pl2(_ZW);
PLine pl3(_ZW);
Point3d ptDraw=_Pt0;
pl1.addVertex(ptDraw+vx*dSize);
pl1.addVertex(ptDraw-vx*dSize);
pl2.addVertex(ptDraw-vy*dSize);
pl2.addVertex(ptDraw+vy*dSize);
pl3.addVertex(ptDraw-vz*dSize);
pl3.addVertex(ptDraw+vz*dSize);

dp.draw(pl1);
dp.draw(pl2);
dp.draw(pl3);



//eraseInstance();




#End
#BeginThumbnail
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
3`%%%%`!1110`4444`%%%%`'_V444
`






#End