#Version 8
#BeginDescription
This TSL defines an assembly of entities and represents the collecting entity for optional shopdrawings

version  value="1.0" date="10oct11" author="th@hsbCAD.de">new property to show ECS marker
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This TSL defines an assembly of entities and represents the collecting entity for optional shopdrawings
/// </summary>

/// <remark Lang=en>
/// Additional TSL's are required to setup a proper shopdrawing definition
/// </remark>

/// History
///<version  value="1.0" date="10oct11" author="th@hsbCAD.de">new property to show ECS marker</version>
///<version  value="1.0" date="7oct11" author="th@hsbCAD.de">initial</version>

// basics and prop
	double dCompassGridAngle =15;
	U(1,"mm");	
	double dEps = U(0.1);
	String sArNY[] = {T("|No|"), T("|Yes|")};
	double dRadius = U(50);

	String sPropNameD0 = T("|Scale|");
	PropString sCreateSD(0, sArNY,T("|Create Nested Shopdrawings|"));
	PropString sShowECS(1, sArNY,T("|Show ECS Marker|"));
	PropDouble dScale(0, 1,sPropNameD0 , _kNoUnit);
	
	
// on insert
	if (_bOnInsert)
	{	
		if (insertCycleCount()>1) { eraseInstance(); return; }
		showDialog();
		PrEntity ssE(T("|Select entities|"), Entity());
		if (ssE.go())
			_Entity= ssE.set(); 
			
		_Pt0 = getPoint();
		_PtG.append(_Pt0+_XU*2*dRadius);
		_PtG.append(_Pt0+_YU*2*dRadius);
		_PtG.append(_Pt0+_ZU*2*dRadius);
		
					
		return;		
	}// end on insert_______________________________________________________________________________________________
	
// Display
	Display dp(1);
	
// scale radius
	if (dScale>0)
		dRadius *=dScale;	

// flag if nested multipages to be created
	int bCreateSD = sArNY.find(sCreateSD);
	_Map.setInt("createChildPages", bCreateSD);
	int bShowEcs = sArNY.find(sShowECS);
	
// the pline to be shown at every body
	PLine pl(_ZE);
	pl.addVertex(_PtW-_XE*U(3));
	pl.addVertex(_PtW+_XE*U(3));
	pl.addVertex(_PtW);
	pl.addVertex(_PtW-_YE*U(3));
	pl.addVertex(_PtW+_YE*U(3));
	Point3d ptRef = _PtW;	
	PLine  pl2(_PtW-_ZE*U(3),_PtW+_ZE*U(3));

// on creation and recalc order the entities to achieve a proper compare key
	// declare the compare key
	String sCompareKey = _Map.getString("compKey");
	if (_bOnDbCreated || _bOnRecalc)
	{
		sCompareKey = scriptName();
	// order by type
		for (int i=0; i<_Entity.length();i++)		
			for (int j=0; j<_Entity.length()-1;j++)
				if (_Entity[j].typeDxfName()<_Entity[j+1].typeDxfName())	
					_Entity.swap(j,j+1);
	// order by posnum
		for (int i=0; i<_Entity.length();i++)	
		{	
			for (int j=0; j<_Entity.length()-1;j++)
			{
			// not of same type	
				if (_Entity[j].typeDxfName()!=_Entity[j+1].typeDxfName()){continue};
				String s1=-1, s2=-1;
			// get posnums	
				if (_Entity[j].bIsKindOf(GenBeam()))				{s1=((GenBeam)_Entity[j]).posnum();}
				else if (_Entity[j].bIsKindOf(MassGroup()))		{s1=_Entity[j].subMapX("hsbPosNum").getInt("posnum");}
				else if (_Entity[j].bIsKindOf(FastenerAssemblyEnt()))		
				{
					FastenerAssemblyEnt fae = (FastenerAssemblyEnt)_Entity[j];
					s1=fae.definition() + "_" + fae.holdingDistance();
				}
				else
				{
					s1 = _Entity[j].realBody().volume();	
					
				}

				
				if (_Entity[j+1].bIsKindOf(GenBeam()))				{s2=((GenBeam)_Entity[j+1]).posnum();}
				else if (_Entity[j+1].bIsKindOf(MassGroup()))		{s2=_Entity[j+1].subMapX("hsbPosNum").getInt("posnum");}
				else if (_Entity[j+1].bIsKindOf(FastenerAssemblyEnt()))		
				{
					FastenerAssemblyEnt fae = (FastenerAssemblyEnt)_Entity[j+1];
					s2=fae.definition() + "_" + fae.holdingDistance();
				}
				else
				{
					s2 = _Entity[j+1].realBody().volume();	
					
				}								
				if (s1>s2)	
					_Entity.swap(j,j+1);		
			}// next j
		}// next i
		
	// store the compare key in map
		for (int i=0; i<_Entity.length();i++)
		{
			String sPos =-1;
			if (_Entity[i].bIsKindOf(GenBeam()))				{sPos=((GenBeam)_Entity[i]).posnum();}
			else if (_Entity[i].bIsKindOf(MassGroup()))		{sPos=_Entity[i].subMapX("hsbPosNum").getInt("posnum");}	
			else if (_Entity[i].bIsKindOf(FastenerAssemblyEnt()))		
			{
				FastenerAssemblyEnt fae = (FastenerAssemblyEnt)_Entity[i];
				sPos=fae.definition() + "_" + fae.holdingDistance();
			}
			else
			{
				sPos= _Entity[i].realBody().volume();		
			}				
			sCompareKey = sCompareKey+_Entity[i].typeDxfName() + "Pos" + sPos;	
			
		}
		_Map.setString ("compKey",sCompareKey  );
	}
	setCompareKey(sCompareKey);



// at least one entity with a solid representation is needed
	Entity ents[0];
	ents = _Entity;	
	Body bd, bdSd;
	for (int i=0; i<ents.length();i++)
	{
		int nPos =-1;
		if (ents[i].bIsKindOf(GenBeam()))				{nPos=((GenBeam)ents[i]).posnum();}
		else if (ents[i].bIsKindOf(MassGroup()))		{nPos=ents[i].subMapX("hsbPosNum").getInt("posnum");}		
		sCompareKey = sCompareKey+ents[i].typeDxfName() + "Pos" + nPos;
		
		
		
	// assignment to the first entity
		if (i==0)assignToGroups(ents[i]);
		
		Body bdThis = ents[i].realBody();
		if (bdThis.volume()>pow(dEps,3))
		{
			int bOk = bd.addPart(bdThis);	
			if (bOk)
			{
				dp.color(ents[i].color());
				Point3d ptCen = bdThis.ptCen();
				pl.transformBy(ptCen-ptRef);
				pl2.transformBy(ptCen-ptRef);
				dp.draw(pl);
				dp.draw(pl2);
				ptRef = ptCen;	
				
				if (bdSd.volume()<pow(dEps,3))
					bdSd = Body(ptRef, _XE,_YE,_ZE,U(1), U(1), U(1),0,0,0);
			}
		}
	}
	if (bd.volume()<pow(dEps,3))
	{
		reportMessage("\n" + T("|No Solid found in selection set.|"));
		eraseInstance();
		return;	
	}	

// validate grips
	if (_PtG.length()<3 || _kNameLastChangedProp==sPropNameD0 )
	{
		_PtG.setLength(0);	
		_PtG.append(_Pt0+_XU*2*dRadius);
		_PtG.append(_Pt0+_YU*2*dRadius);
		_PtG.append(_Pt0+_ZU*2*dRadius);		
	}	
	
// standards
	Vector3d vx,vy,vz;
	vx = _PtG[0]-_Pt0; vx.normalize();	
	vy = _PtG[1]-_Pt0; vy.normalize();
	vz = _PtG[2]-_Pt0; vz.normalize();	
	
// X-Grip
	if (_kNameLastChangedProp == "_PtG0")
	{
		vx = _PtG[0]-_Pt0;
		vx.normalize();
		if (vx.isParallelTo(vz))
		{
			vz = vx.crossProduct(vy);
			vy = vx.crossProduct(-vz);	
		}
		else
		{
			vy = vx.crossProduct(-vz);	
			vz = vx.crossProduct(vy);			

		}		
	}
// Y-Grip
	else if (_kNameLastChangedProp == "_PtG1")
	{
		vy = _PtG[1]-_Pt0;
		vy.normalize();		

		if (vy.isParallelTo(vz))
		{
			vz = vx.crossProduct(vy);		
			vx = vy.crossProduct(vz);	
		}
		else
		{
			vx = vy.crossProduct(vz);			
			vz = vx.crossProduct(vy);		
		}		
		
	}	
// Z-Grip
	else if (_kNameLastChangedProp == "_PtG2")
	{
		vz = _PtG[2]-_Pt0;
		vz.normalize();
		if (vz.isParallelTo(vx))
		{
			vx = vy.crossProduct(vz);
			vy = vx.crossProduct(-vz);	
		}
		else
		{
			vy = vx.crossProduct(-vz);				
			vx = vy.crossProduct(vz);
		}		
				
	}	
	
	if (_kNameLastChangedProp.find("_PtG",0)>-1)
	{
		_PtG[0]=_Pt0+vx*2*dRadius;
		_PtG[1]=_Pt0+vy*2*dRadius;
		_PtG[2]=_Pt0+vz*2*dRadius;		
	}
	
// ECS Marker
	if (bShowEcs)
	{
		dp.color(1);
		PLine plCirc;
		plCirc.createCircle(_Pt0, vz, dRadius);
		dp.draw(plCirc);
		PLine plShort (_Pt0+vx*dRadius,_Pt0+vx*dRadius*1.2);
		PLine plLong (_Pt0+vx*dRadius,_Pt0+vx*dRadius*1.4);
		CoordSys csRot;
		
		int n = 360/dCompassGridAngle;
		double dAngle = 360/n;
		//if (abs(dAngle-dCompassGridAngle)>dEps) dCompassGridAngle.set(dAngle);
		
		csRot.setToRotation(dAngle,vz,_Pt0);
		for (int i=0;i<n;i++)
		{
			if (i%3==0)
				dp.draw(plLong);
			else
				dp.draw(plShort);
			plShort.transformBy(csRot);	
			plLong.transformBy(csRot);
		}
		
	// draw coordSys
		PLine plVector(_Pt0,_PtG[0]);
		plCirc.createCircle(_PtG[0]-vx*.4*dRadius, vx, .2*dRadius);
		PLine plArrow1(_PtG[0]-(2*vx+vz)*.2*dRadius, _PtG[0],_PtG[0]-(2*vx-vz)*.2*dRadius );
		PLine plArrow2(_PtG[0]-(2*vx+vy)*.2*dRadius, _PtG[0],_PtG[0]-(2*vx-vy)*.2*dRadius );
	
		int nArColor[] = {1,3,150};		
		for (int i=0;i<nArColor.length();i++)
		{
			dp.color(nArColor[i]);
			dp.draw(plCirc);
			dp.draw(plArrow1);
			dp.draw(plArrow2);
			dp.draw(plVector);
			
			if (i==0)
				csRot.setToRotation(90,vz,_Pt0);
			else if (i==1)
				csRot.setToRotation(90,vx,_Pt0);
			plVector.transformBy(csRot);
			plCirc.transformBy(csRot);
			plArrow1.transformBy(csRot);
			plArrow2.transformBy(csRot);	
		}
	}// end if draw ECS
	
// finally set my coordSys
	_XE = vx;
	_YE = vy;
	_ZE = vz;	
	
	
	
	
	
		
// add triggers
	String sTrigger[] = {T("|Add Entity|"),T("|Remove Entity|")};
	for (int i = 0; i < sTrigger.length(); i++)
		addRecalcTrigger(_kContext, sTrigger[i]);	

// trigger 0: add entity
	if (_bOnRecalc && _kExecuteKey==sTrigger[0])
	{
		Entity ent= getEntity();
		if (_Entity.find(ent)<0)
			_Entity.append(ent);
		setExecutionLoops(2);
	}
// trigger 1: remove entity
	if (_bOnRecalc && _kExecuteKey==sTrigger[1])
	{
		Entity ent = getEntity();
		int n = _Entity.find(ent);
		if (n>-1)
			_Entity.removeAt(n);
		setExecutionLoops(2);
	}
	
// set color to byBlock and drw the entire assembly		
	dp.color(-1);
	dp.draw(bd);
	_Map.setInt("isAssembly",true);			

	
	
		
	
#End
#BeginThumbnail
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
LMXG*1X^@Y/XFO3;"U@MX$@MXDAB`X2-0H_2IK5JD;)O[OZ_R+ITX/;\3_]G6
`

#End
