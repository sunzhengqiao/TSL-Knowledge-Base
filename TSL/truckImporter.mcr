#Version 8
#BeginDescription










#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 0
#FileState 0
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
// Rev 1.1 - Initial Coding.


Unit(1,"mm");

if ( _bOnDbCreated )
{
  _ThisInst.setColor( 8 );
}

Display dp( - 1 );

Map mpTruckLoad =_Map.getMap("truckLoad");

Map mpTruckLoadLayout = mpTruckLoad.getMap("truckLoadLayout"); 
Map mpCoordSys = mpTruckLoadLayout.getMap("coordSys");  
Point3d ptOrgTruck = mpCoordSys.getPoint3d("ptorg");
Vector3d vecXTruck = mpCoordSys.getVector3d("vecX");
Vector3d vecYTruck = mpCoordSys.getVector3d("vecY");
Vector3d vecZTruck = mpCoordSys.getVector3d("vecZ");

//ptOrgTruck.setY(ptOrgTruck.Y() + j * 10000);
CoordSys truckCoordSys = _ThisInst.coordSys();
truckCoordSys.transformBy(truckCoordSys.vecX() * -50000);

//CoordSys truckCoordSys(ptOrgTruck, vecXTruck, vecYTruck, vecZTruck);

Map mpLoadBodies =mpTruckLoadLayout.getMap("loadBody[]");
Map mpLoadAxles =mpTruckLoadLayout.getMap("loadAxle[]");
Point3d truckStartOffset;

for (int j = 0; j < mpLoadBodies.length(); j++)
{
	Map mpLoadBody = mpLoadBodies.getMap(j);
	Map mpCoordSys = mpLoadBody.getMap("coordSys");
	
	Point3d ptOrg = mpCoordSys.getPoint3d("ptorg");
	Vector3d vecX = mpCoordSys.getVector3d("vecX");
	Vector3d vecY = mpCoordSys.getVector3d("vecY");
	Vector3d vecZ = mpCoordSys.getVector3d("vecZ");
	CoordSys bodyCoordSys(ptOrg, vecX, vecY, vecZ);
	CoordSys coordSys;
	
	Map mpQuader = mpLoadBody.getMap("quader");
	double length = mpQuader.getDouble("length");
	double width = mpQuader.getDouble("width");
	double height = mpQuader.getDouble("height");
	Quader quader(coordSys.ptOrg(), coordSys.vecX(), coordSys.vecY(), coordSys.vecZ(), length, width, height);

	if (bodyCoordSys.ptOrg().X() -length/2 < truckStartOffset.X()) 
	{
		truckStartOffset.setX(bodyCoordSys.ptOrg().X() -length/2);
	}

	bodyCoordSys.transformBy(truckCoordSys);

	quader.transformBy(bodyCoordSys);
	
	Body loadBox(quader);
	dp.transparency(0);
	dp.trueColor(rgb(51, 204, 51));
	dp.draw(loadBox);


	Map mpLoadSpaces = mpLoadBody.getMap("loadSpace[]");
	
	for (int j = 0; j < mpLoadSpaces.length(); j++)
	{
		Map mpLoadSpace = mpLoadSpaces.getMap(j);
		Map mpCoordSys = mpLoadSpace.getMap("coordSys");
		
		Point3d ptOrg = mpCoordSys.getPoint3d("ptorg");
		Vector3d vecX = mpCoordSys.getVector3d("vecX");
		Vector3d vecY = mpCoordSys.getVector3d("vecY");
		Vector3d vecZ = mpCoordSys.getVector3d("vecZ");
		CoordSys spaceCoordSys(ptOrg, vecX, vecY, vecZ);
		CoordSys coordSys;
		
		Map mpQuader = mpLoadSpace.getMap("quader");
		Map mpQuaderCoordSys = mpQuader.getMap("coordSys");
		Point3d ptOrgQuader = mpQuaderCoordSys.getPoint3d("ptorg");
		Vector3d vecXQuader = mpQuaderCoordSys.getVector3d("vecX");
		Vector3d vecYQuader = mpQuaderCoordSys.getVector3d("vecY");
		Vector3d vecZQuader = mpQuaderCoordSys.getVector3d("vecZ");
		CoordSys quaderCoordSys(ptOrg, vecX, vecY, vecZ);
		
		double length = mpQuader.getDouble("length");
		double width = mpQuader.getDouble("width");
		double height = mpQuader.getDouble("height");
		Quader quader(ptOrgQuader, vecXQuader, vecYQuader, vecZQuader, length, width, height);
		
		spaceCoordSys.transformBy(bodyCoordSys);
		quader.transformBy(spaceCoordSys);
		
		Body loadBox(quader);
		dp.transparency(80);
		dp.trueColor(rgb(242, 242, 242));
		dp.draw(loadBox);
		
		Map mpStacks = mpLoadSpace.getMap("stack[]");
		
		for (int j = 0; j < mpStacks.length(); j++)
		{
			Map mpStack = mpStacks.getMap(j);
			Map mpStackItems = mpStack.getMap("stackItem[]");
			
			for (int j = 0; j < mpStackItems.length(); j++)
			{
				Map mpStackItem = mpStackItems.getMap(j);
				Map mpCoordSys = mpStackItem.getMap("coordSys");
				
				Point3d ptOrg = mpCoordSys.getPoint3d("ptorg");
				Vector3d vecX = mpCoordSys.getVector3d("vecX");
				Vector3d vecY = mpCoordSys.getVector3d("vecY");
				Vector3d vecZ = mpCoordSys.getVector3d("vecZ");
				CoordSys stackItemCoordSys(ptOrg, vecX, vecY, vecZ);
				CoordSys coordSys;
				
				Map mpQuader = mpStackItem.getMap("quader");
				Map mpQuaderCoordSys = mpQuader.getMap("coordSys");
				Point3d ptOrgQuader = mpQuaderCoordSys.getPoint3d("ptorg");
				Vector3d vecXQuader = mpQuaderCoordSys.getVector3d("vecX");
				Vector3d vecYQuader = mpQuaderCoordSys.getVector3d("vecY");
				Vector3d vecZQuader = mpQuaderCoordSys.getVector3d("vecZ");
				CoordSys quaderCoordSys(ptOrg, vecX, vecY, vecZ);
				
				double length = mpQuader.getDouble("length");
				double width = mpQuader.getDouble("width");
				double height = mpQuader.getDouble("height");
				Quader quader(ptOrgQuader, vecXQuader, vecYQuader, vecZQuader, length, width, height);
				
				stackItemCoordSys.transformBy(spaceCoordSys);
				quader.transformBy(stackItemCoordSys);
				
				String id = mpStackItem.getString("entityid");
				
				Entity stackEntity = mpStackItem.getEntity("entityHandle");
				
				if (stackEntity.bIsValid()) 
				{
					GenBeam genBeams[0];
					
					if (stackEntity.bIsKindOf(Element())) 
					{
						Element element = (Element)stackEntity;
						CoordSys elementCoordSys = element.coordSys();
						genBeams = element.genBeam();
						
						for (int i; i < genBeams.length(); i++) 
						{
							GenBeam genBeam = genBeams[i];
							CoordSys beamCoordSys = genBeam.coordSys();
							Body body = genBeams[i].realBody();
							
							if (body.isNull()) continue;
							CoordSys transformCoordSys;
							transformCoordSys.setToAlignCoordSys(elementCoordSys.ptOrg(), elementCoordSys.vecX(), elementCoordSys.vecY(), elementCoordSys.vecZ(),
																	stackItemCoordSys.ptOrg(), stackItemCoordSys.vecX(), stackItemCoordSys.vecY(), stackItemCoordSys.vecZ());
							body.transformBy(transformCoordSys);
							dp.color(genBeams[i].color());
							dp.transparency(0);
							dp.draw(body);						
						}						
						
						
					}
					else if (stackEntity.bIsKindOf(GenBeam())) 
					{
						GenBeam genBeam = (GenBeam)stackEntity;
						CoordSys beamCoordSys = genBeam.coordSys();
						Body body = genBeam.realBody();
						Point3d ptRef = genBeam.ptRef();
						Point3d ptCent = genBeam.ptCen();
						
						if (body.isNull()) continue;
						CoordSys transformCoordSys;
						transformCoordSys.setToAlignCoordSys(ptCent, beamCoordSys.vecX(), beamCoordSys.vecY(), beamCoordSys.vecZ(),
																stackItemCoordSys.ptOrg(), stackItemCoordSys.vecX(), stackItemCoordSys.vecY(), stackItemCoordSys.vecZ());
						body.transformBy(transformCoordSys);
						dp.color(genBeam.color());
						dp.transparency(0);
						dp.draw(body);	
					}
				}
				
				if ((length + width + height) > 0 )
				{
					Body loadBox(quader);
					dp.transparency(0);
					dp.trueColor(rgb(115, 115, 115));
					dp.draw(loadBox);
				}
				
			}
		}
	}
}

for (int j = 0; j < mpLoadAxles.length(); j++)
{
	Map mpLoadAxle = mpLoadAxles.getMap(j);
	Map mpCoordSys = mpLoadAxle.getMap("coordSys");
	
	Point3d ptOrg = mpCoordSys.getPoint3d("ptorg");
	Vector3d vecX = mpCoordSys.getVector3d("vecX");
	Vector3d vecY = mpCoordSys.getVector3d("vecY");
	Vector3d vecZ = mpCoordSys.getVector3d("vecZ");
	CoordSys axleCoordSys(ptOrg, vecX, vecY, vecZ);
	CoordSys coordSys;
	
	axleCoordSys.transformBy(truckCoordSys);
	
	Map mpQuader = mpLoadAxle.getMap("quader");
	Map mpQuaderCoordSys = mpQuader.getMap("coordSys");
	Point3d ptOrgQuader = mpQuaderCoordSys.getPoint3d("ptorg");
	Vector3d vecXQuader = mpQuaderCoordSys.getVector3d("vecX");
	Vector3d vecYQuader = mpQuaderCoordSys.getVector3d("vecY");
	Vector3d vecZQuader = mpQuaderCoordSys.getVector3d("vecZ");
	CoordSys quaderCoordSys(ptOrg, vecX, vecY, vecZ);
	int isDoubleWheel = mpLoadAxle.getInt("doublewheel");
	
	double length = mpQuader.getDouble("length");
	double width = mpQuader.getDouble("width");
	double height = mpQuader.getDouble("height");
	Quader quader(axleCoordSys.ptOrg(), axleCoordSys.vecX(), axleCoordSys.vecY(), axleCoordSys.vecZ(), 200, width-250, 200);

	dp.transparency(80);
	dp.trueColor(rgb(242, 242, 242));

	Body axleBox(quader);
	dp.draw(axleBox);

	dp.transparency(50);

	// Left side...
	Point3d leftPt = axleCoordSys.ptOrg();
	Point3d rightPt = axleCoordSys.ptOrg();
	leftPt += vecY * -width/2;
	rightPt += vecY * width/2;
	PLine pline(vecY);
	pline.createCircle(leftPt, vecY, height / 2);
	Body wheel(pline, vecY* 150);
	Drill drl( leftPt, leftPt+150*vecY, height / 4);
	wheel.addTool(drl);
	wheel.transformBy(100 * vecY);
	dp.draw(wheel);

	if (isDoubleWheel) 
	{
		PLine pline(vecY);
		pline.createCircle(leftPt, vecY, height / 2);
		Body wheel(pline, vecY* 150);
		Drill drl( leftPt, leftPt+150*vecY, height / 4);
		wheel.addTool(drl);
		wheel.transformBy(300 * vecY);
		dp.draw(wheel);
	}

	{ 
		//Right side...
		PLine pline(vecY);
		pline.createCircle(rightPt, -vecY, height / 2);
		Body wheel(pline, -vecY* 150);
		Drill drl( rightPt, rightPt+150*-vecY, height / 4);
		wheel.addTool(drl);
		wheel.transformBy(100 *- vecY);
		dp.draw(wheel);
	
		if (isDoubleWheel) 
		{
			PLine pline(vecY);
			pline.createCircle(rightPt, -vecY, height / 2);
			Body wheel(pline, -vecY* 150);
			Drill drl( rightPt, rightPt+150*-vecY, height / 4);
			wheel.addTool(drl);
			wheel.transformBy(300 * -vecY);
			dp.draw(wheel);
		}		
	}
	
	{
		PLine pline(vecY);
		pline.addVertex(Point3d(-2000, 0, 0));
		pline.addVertex(Point3d(-2000, 1700, 0));
		pline.addVertex(Point3d(-1700, 3000, 0));
		pline.addVertex(Point3d(-200, 3000, 0));
		pline.addVertex(Point3d(0, 2800, 0));
		pline.addVertex(Point3d(0, 600, 0));
		pline.addVertex(Point3d(-1200, 600, 0));
		pline.addVertex(Point3d(-1500, 0, 0));
		pline.addVertex(Point3d(-2000, 0, 0));
		Point3d pts[] =pline.vertexPoints(true);
		
		Body cab(pline, vecZ* 3000);
		CoordSys coordSys();
		CoordSys cabCoordSys(coordSys.ptOrg(), coordSys.vecX(), coordSys.vecZ(), coordSys.vecY());
		
		cabCoordSys.transformBy(truckCoordSys);
		
		cab.transformBy(cabCoordSys);
		cab.transformBy( coordSys.vecZ() * 500);
		cab.transformBy( coordSys.vecY() * -1500);
		cab.transformBy( coordSys.vecX() * -(abs(truckStartOffset.X() ) +1000) );
		dp.trueColor(rgb(51, 204, 51));
		dp.draw(cab);
		{ 
			dp.trueColor(rgb(26, 26, 26));
			Point3d axlePt = cabCoordSys.ptOrg();
			axlePt.transformBy( cabCoordSys.vecX() * -(abs(truckStartOffset.X() ) +2000) + truckCoordSys.vecZ() *height / 2 );
		
			Quader quader(axlePt, vecX, vecY, vecZ, 200, width-250, 200);

			dp.transparency(80);
			dp.trueColor(rgb(242, 242, 242));
		
			Body axleBox(quader);
			dp.draw(axleBox);

			dp.transparency(50);
	
			// Left side...
			Point3d leftPt = axlePt;
			Point3d rightPt = axlePt;
			leftPt += vecY * -width/2;
			rightPt += vecY * width/2;
			PLine pline(vecY);
			pline.createCircle(leftPt, vecY, height / 2);
			Body wheel(pline, vecY* 150);
			Drill drl( leftPt, leftPt+150*vecY, height / 4);
			wheel.addTool(drl);
			wheel.transformBy(100 * vecY);
			dp.draw(wheel);
		
			if (isDoubleWheel) 
			{
				PLine pline(vecY);
				pline.createCircle(leftPt, vecY, height / 2);
				Body wheel(pline, vecY* 150);
				Drill drl( leftPt, leftPt+150*vecY, height / 4);
				wheel.addTool(drl);
				wheel.transformBy(300 * vecY);
				dp.draw(wheel);
			}
		
			{ 
				//Right side...
				PLine pline(vecY);
				pline.createCircle(rightPt, -vecY, height / 2);
				Body wheel(pline, -vecY* 150);
				Drill drl( rightPt, rightPt+150*-vecY, height / 4);
				wheel.addTool(drl);
				wheel.transformBy(100 *- vecY);
				dp.draw(wheel);
			
				if (isDoubleWheel) 
				{
					PLine pline(vecY);
					pline.createCircle(rightPt, -vecY, height / 2);
					Body wheel(pline, -vecY* 150);
					Drill drl( rightPt, rightPt+150*-vecY, height / 4);
					wheel.addTool(drl);
					wheel.transformBy(300 * -vecY);
					dp.draw(wheel);
				}		
			}			
		}
	}
}

	










#End
#BeginThumbnail






















#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS">
        <int nm="BREAKPOINT" vl="169" />
        <int nm="BREAKPOINT" vl="172" />
      </lst>
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End