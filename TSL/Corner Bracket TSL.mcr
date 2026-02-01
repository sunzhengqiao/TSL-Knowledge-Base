#Version 8
#BeginDescription
v: 1.5 Change Holes Distribution  Date: 16/Nov/2010  Author: Alberto Jena (aj@hsb-cad.com)

v: 1.4 add 11mm Drills  Date: 25/Mar/2009  Author: Alberto Jena (aj@hsb-cad.com)
v: 1.3 relocate the drills  Date: 22/May/2007  Author: Alberto Jena (aj@hsb-cad.com)
v: 1.2 fix the problem with the location  Date: 18/April/2007  Author: Alberto Jena (aj@hsb-cad.com)
v: 1.1 fix the drill location  Date: 17/April/2007  Author: Alberto Jena (aj@hsb-cad.com)
v: 1.0 initial version  Date: 16/April/2007  Author: Alberto Jena (aj@hsb-cad.com)





#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 5
#KeyWords 
#BeginContents
Unit (1,"mm");

if( _bOnInsert )
{
	PrEntity ssE("\nSelect a set of elements",Element());
	Element elToClone[0];
	if (ssE.go()) // let the prompt class do its job, only one run
	{
		Entity ents[0]; // the PrEntity will return a list of entities, and not elements
		ents = ssE.set(); 
		
		for (int i=0; i<ents.length(); i++)
		{
			Element el = (Element)ents[i]; // cast the entity to a element    
			elToClone.append(el);
		}
	}
	
	//Prepare to clone the TSL
		
	TslInst tsl;
	String sScriptName = scriptName(); //name of the script for nailLines
	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
						
	Beam lstBeams[0];		
	Entity lstEnts[1];
							
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	
	//Parameters for clone tsl	
	lstPoints.setLength(0);	
	
	lstPropString.setLength(0);
	lstPropInt.setLength(0);
	lstPropDouble.setLength(0);

			
	for(int i =0; i<elToClone.length(); i++)
	{
		lstEnts.setLength(0);
		lstEnts.append(elToClone[i]);
		tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString );
	}
					 
	eraseInstance();
	return;
}

if( _Element.length() == 0 ){eraseInstance(); return;}

double dDiameter27=U(27);
double dDiameter11=U(11);

double dLen=U(100);

double d27mmFromBase[0];
double d27mmFromTop[0];
double d11mmFromBase[0];
double d11mmFromTop[0];

//Height of 27mm holes from Base			Height of 27mm holes from Top
d27mmFromBase.append(U(108.4));			d27mmFromTop.append(U(108.4));

d27mmFromBase.append(U(198.4));			d27mmFromTop.append(U(198.4));	

d27mmFromBase.append(U(267.4));			d27mmFromTop.append(U(267.4));	
d27mmFromBase.append(U(273.4));			d27mmFromTop.append(U(273.4));	
d27mmFromBase.append(U(279.4));			d27mmFromTop.append(U(279.4));	
d27mmFromBase.append(U(285.4));			d27mmFromTop.append(U(285.4));
d27mmFromBase.append(U(291.4));			d27mmFromTop.append(U(291.4));

d27mmFromBase.append(U(333.4));			d27mmFromTop.append(U(333.4));	

d27mmFromBase.append(U(375.4));			d27mmFromTop.append(U(375.4));	
d27mmFromBase.append(U(381.4));			d27mmFromTop.append(U(381.4));
d27mmFromBase.append(U(387.4));			d27mmFromTop.append(U(387.4));
d27mmFromBase.append(U(393.4));			d27mmFromTop.append(U(393.4));
d27mmFromBase.append(U(399.4));			d27mmFromTop.append(U(399.4));

d27mmFromBase.append(U(1144.4));		d27mmFromTop.append(U(1144.4));

//Height of 11mm holes from Base			Height of 11mm holes from Top
d11mmFromBase.append(U(153.4));			d11mmFromTop.append(U(153.4));

d11mmFromBase.append(U(560.9));			d11mmFromTop.append(U(560.9));	

d11mmFromBase.append(U(1110.9));		d11mmFromTop.append(U(1110.9));	

Element elWall = _Element[0];
ElementWallSF el = (ElementWallSF) elWall;
if (!el.bIsValid())
{
	eraseInstance();
	return;
}

Beam bmAll[]=el.beam();
if (bmAll.length()<=0)
	return;

CoordSys cs=el.coordSys();
Vector3d vx=cs.vecX();
Vector3d vy=cs.vecY();
Vector3d vz=cs.vecZ();

_Pt0=cs.ptOrg();

Display dp(-1);

Beam bmToDrill[0];
bmAll=vx.filterBeamsPerpendicularSort(bmAll);
bmToDrill.append(bmAll[0]);
bmToDrill.append(bmAll[bmAll.length()-1]);

for (int b=0; b<bmToDrill.length(); b++)
{
	Beam bm=bmToDrill[b];
	Point3d ptExtreme[]=bm.envelopeBody().extremeVertices(vy);
	Point3d ptBase=ptExtreme[0];
	Point3d ptTop=ptExtreme[ptExtreme.length()-1];
	Line ln(bm.ptCen(), vy);
	ptBase=ln.closestPointTo(ptBase);
	ptTop=ln.closestPointTo(ptTop);
	ptBase=ptBase-vx*U(100);
	ptTop=ptTop-vx*U(100);
	ptBase.vis();
	ptTop.vis();
	
	for (int i=0; i<d27mmFromBase.length(); i++)
	{
		double dOffset=d27mmFromBase[i];
		Point3d ptDrill = ptBase+vy*dOffset;
		Drill dDrill( ptDrill, vx, U(400), dDiameter27*0.5);
		bm.addTool(dDrill);
		
		Point3d ptDisplay=ln.closestPointTo(ptDrill);
		LineSeg ln1(ptDisplay-vx*(dLen*.5), ptDisplay+vx*(dLen*.5));
		dp.draw(ln1);
	}
	for (int i=0; i<d27mmFromTop.length(); i++)
	{
		double dOffset=d27mmFromTop[i];
		Point3d ptDrill = ptTop-vy*dOffset;
		Drill dDrill( ptDrill, vx, U(400), dDiameter27*0.5);
		bm.addTool(dDrill);
		
		Point3d ptDisplay=ln.closestPointTo(ptDrill);
		LineSeg ln1(ptDisplay-vx*(dLen*.5), ptDisplay+vx*(dLen*.5));
		dp.draw(ln1);
	}
	for (int i=0; i<d11mmFromBase.length(); i++)
	{
		double dOffset=d11mmFromBase[i];
		Point3d ptDrill = ptBase+vy*dOffset;
		Drill dDrill( ptDrill, vx, U(400), dDiameter11*0.5);
		bm.addTool(dDrill);

		Point3d ptDisplay=ln.closestPointTo(ptDrill);
		LineSeg ln1(ptDisplay-vx*(dLen*.5), ptDisplay+vx*(dLen*.5));
		dp.draw(ln1);
	}
	for (int i=0; i<d11mmFromTop.length(); i++)
	{
		double dOffset=d11mmFromTop[i];
		Point3d ptDrill = ptTop-vy*dOffset;
		Drill dDrill( ptDrill, vx, U(400), dDiameter11*0.5);
		bm.addTool(dDrill);

		Point3d ptDisplay=ln.closestPointTo(ptDrill);
		LineSeg ln1(ptDisplay-vx*(dLen*.5), ptDisplay+vx*(dLen*.5));
		dp.draw(ln1);
	}
}

assignToElementGroup(el,TRUE,0,'E');

#End
#BeginThumbnail

#End
