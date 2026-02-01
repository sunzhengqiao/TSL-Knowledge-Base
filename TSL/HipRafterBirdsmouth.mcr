#Version 8
#BeginDescription
version value="1.7" date="09dec16" author="florian.wuermseer@hsbcad.com"> 
minimal tooling for <90° angles enabled
bugfix varying plate heights 
bugfix alignment, contact face between plates and rafter is used as display

EN
   - inserts a birdsmouth of two mitred plates with a hip rafter
   - How to use: select two plates, press enter then select hip rafter

DE
   - fügt eine Herzkerve an einem Gratsparren in Abhängigkeit zweier Pfetten ein
   - Anwendung: zwei Pfetten wählen, Gratsparren wählen




#End
#Type G
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 7
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl inserts a birdsmouth of two mitred plates with a hip rafter.
/// The tool will be composed of two beamcuts placed at the mitre intersection

/// </summary>

/// <insert>
/// Select two plates, press enter then select hip rafter
/// </insert>


/// History
///<version value="1.7" date="09dec16" author="florian.wuermseer@hsbcad.com"> minimal tooling for <90° angles enabled </version>
///<version value="1.6" date="07jul14" author="th@hsbCAD.de"> bugfix varying plate heights </version>
///<version value="1.5" date="15oct13" author="th@hsbCAD.de"> bugfix alignment, contact face between plates and rafter is used as display </version>
/// Version 1.4   17.06.2013   th@hsbCAD.de
/// supports angles smaller 90°. for angles < 90° the new property 'Relief' effects the tool
/// Version 1.3   17.06.2013   th@hsbCAD.de
/// supports angles smaller 90°. for angles < 90° the new property 'Relief' effects the tool
/// Version 1.2   17.06.2013   th@hsbCAD.de
/// new properties to create open beamcuts
/// Version 1.1   09.01.2008   th@hsbCAD.de
/// bugfix and user input improved
/// Version 1.0   22.March 2006   rh@hsb-cad.com





//Units
	U(1,"mm");
	double dEps= U(.1);
	
	String sArNY[] = {T("|No|"), T("|Yes|")};
	PropString sMinToolY(0, sArNY, T("|Minimal Tooling|")  + " Y");
	PropString sMinToolZ(1, sArNY, T("|Minimal Tooling|")+ " Z");

	String sReliefs[] = {T("|not rounded|"),T("|rounded|"),T("|relief|"),T("|rounded with small diameter|"),T("|relief with small diameter|"),T("|rounded|"),T("|relief|") + " " + "K1"};
	int nReliefs[] ={_kNotRound, _kRound, _kRelief, _kRoundSmall,_kReliefSmall,_kRounded,_kNotRound };
	PropString sRelief(2, sReliefs, T("|Relief|"));	
	
//On Insert
	if (_bOnInsert) {
		if (insertCycleCount()>1) { eraseInstance(); return; }
		PrEntity prPla (T("|Select plates|"),Beam());
		if (prPla.go())
		 {
			Beam ssBeams[] = prPla.beamSet();
			 for (int i=0; i<ssBeams.length(); i++) 
				_Beam.append(ssBeams[i]);
				
			int bOk=true;	
			if (_Beam.length()<2)
				bOk=false;
			else if (_Beam.length()>1 && _Beam[0].vecX().isParallelTo(_Beam[1].vecX()))	
				bOk=false;
			
			if (!bOk)
			{	
				if (_Beam.length()>0)
					reportNotice("\n" + T("|Invalid selection|"));	
				eraseInstance();
				return;
			}		
				
			_Beam.append(getBeam(T("|Select hip rafter|")));
			
			}
			return;
		
	}
	
// validate
	if (_Beam.length()<3)
	{
		eraseInstance();
		return;	
	}	
	Beam bm0 = _Beam[0];
	Beam bm1 = _Beam[1];
	Beam bm2 = _Beam[2];
	Vector3d vx0 = _X0;
	Vector3d vx1 = _X1;
	
	_Pt0T.vis();
	_X0.vis(_Pt0T,1);
	//_Y0.vis(_Pt0T,3);
	_Z0.vis(_Pt0T,150);
	_Pt0B.vis();

// parhouse is required if angle between the plates is <90°
	double dAngle = vx0.angleTo(vx1);
	int bAddParHouse;
	if (dAngle<90-dEps)
	{
		bAddParHouse=true;
	}

// min tool
	int bMinToolY=sArNY.find(sMinToolY);
	int bMinToolZ=sArNY.find(sMinToolZ);

	int nRelief = nReliefs[sReliefs.find(sRelief)];


// the vector along the hip pointing towards the ridge
	Vector3d vxRidge = _Beam[2].vecX();
	if (vxRidge.dotProduct(_ZW)<0)vxRidge*=-1;
	vxRidge.vis(_Beam[2].ptCen(),1);
	
// get upper ref point
	Point3d ptRef = _Pt0T;
	Vector3d vz = vx0.crossProduct(vx1);
	vz.normalize();
	if (vz.dotProduct(_ZW)<0)vz*=-1;
	ptRef.transformBy(vz*.5*bm0.dD(vz));
	
// consider differnet eam heights	
	Line lnZ(ptRef, vz);
	Point3d ptsZ[0];
	for (int i=0;i<2;i++)
		ptsZ.append( _Beam[i].envelopeBody(false,true).intersectPoints(lnZ));
	ptsZ=lnZ.orderPoints(ptsZ);
	if (ptsZ.length()>0)
		ptRef.transformBy(vz*vz.dotProduct(ptsZ[ptsZ.length()-1]-ptRef));
	
	
	
//	vz.vis(ptRef,150);
	ptRef.vis(6);

	Vector3d vy0 = _X0.crossProduct(-vz); vy0.normalize();
	Vector3d vy1 = _X1.crossProduct(-vz); vy1.normalize();
//	vy0.vis(_Pt0T,3);
//	vy1.vis(_Pt0T,93);

// tools beam 0
	double dB0w = _Beam0.dD(vy0);
	double dB0h = _Beam0.dD(vz);	
	if (!bMinToolY)
		dB0w*=10;
	if (!bMinToolZ)
		dB0h *=10;
	
// tools beam 1
	double dB1w = _Beam1.dD(vy1);
	double dB1h = _Beam1.dD(vz);	
	if (!bMinToolY && !bAddParHouse)
		dB1w*=10;
	if (!bMinToolZ && !bAddParHouse)
		dB1h *=10;
		
		
// add tools
	if (!bAddParHouse)
	{	
		double dYFlag = 1;
		if (vy0.dotProduct(vxRidge)<0)dYFlag*=-1;	
		BeamCut bc1(ptRef, _X0,vy0,vz,U(1000),dB0w,dB0h,-1,dYFlag,-1);
		//bc1.cuttingBody().vis(3);
		_Beam2.addTool(bc1);
		
		dYFlag = 1;
		if (vy1.dotProduct(vxRidge)<0)dYFlag*=-1;			
		BeamCut bc2(ptRef, _X1,vy1,vz,U(1000),dB1w,dB1h,-1,dYFlag,-1);		
		//bc2.cuttingBody().vis(6);
		_Beam2.addTool(bc2);	
	}	
	else
	{
		Plane pn0 (_Pt0T, bm0.vecD(vx1));
		Line ln0 (_Pt0B, vx1);
		Point3d ptIntersect0 = ln0.intersect(pn0, 0);
		ptIntersect0.vis(3);
		
		Plane pn1 (ptRef, bm1.vecD(vx0));
		Line ln1 (_Pt0B, vx0);
		Point3d ptIntersect1 = ln1.intersect(pn1, 0);
		
		double dX = abs(vx0.dotProduct(_Pt0B-ptIntersect1));	
		double dY = abs(vx1.dotProduct(_Pt0B-ptIntersect0));
		if (bMinToolY || bMinToolZ)
		{
			ParHouse parHouse1(ptRef, vx0,vx1, vz, 5*dX, dY, U(1000),-1,-1,-1);
			ParHouse parHouse2(ptRef, vx0,vx1, vz, dX, 5*dY, U(1000),-1,-1,-1);
			parHouse1.setRoundType(nRelief);
			parHouse2.setRoundType(nRelief);
			parHouse1.cuttingBody().vis(6);
			parHouse2.cuttingBody().vis(6);
			_Beam2.addTool(parHouse1);
			_Beam2.addTool(parHouse2);
		}
		else
		{
			ParHouse parHouse(ptRef, vx0,vx1, vz, 5*dX, 5*dY, U(1000),-1,-1,-1);
			parHouse.setRoundType(nRelief);
			parHouse.cuttingBody().vis(6);	
			_Beam2.addTool(parHouse);
		}
	}

vx0.vis(ptRef, 1);
vx1.vis(ptRef, 3);
		
// add tool display	
	Display dp0(9);
	Plane pnRef(ptRef,vz);
	PlaneProfile pp0=_Beam[0].realBody().extractContactFaceInPlane(pnRef, dEps);
	PlaneProfile pp1=_Beam[1].realBody().extractContactFaceInPlane(pnRef, dEps);
	PlaneProfile pp2=_Beam[2].realBody().extractContactFaceInPlane(pnRef, dEps);		
	pp0.unionWith(pp1);
	pp2.intersectWith(pp0);
	dp0.draw(pp2);	
	LineSeg seg= pp2.extentInDir(_X0+_X1);
	PLine plCirc(vz);
	plCirc.createCircle(seg.ptMid(),vz,(seg.ptStart()-seg.ptEnd()).length()/8);
	dp0.draw(plCirc);





#End
#BeginThumbnail
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
<V\*1*69RJ*`"S$ECQW)))]230%A]`!0`4`?_V0``
`
e





#End