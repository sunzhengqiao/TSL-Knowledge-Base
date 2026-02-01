#Version 8
#BeginDescription
/// Version 1.0   th@hsbCAD.de   02.03.2010
/// This tsl creates a housing at a t-connection. the tooling direction is towards the connecting side of beams
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
/// <summary Lang=en>
/// This tsl creates a housing at a t-connection. the tooling direction is towards the connecting side of beams
/// </summary>

/// History
/// Version 1.1   th@hsbCAD.de   03.02.2011
/// minor translation bugfix
/// Version 1.0   th@hsbCAD.de   02.03.2010
/// initial


// basics and props
	U(1,"mm");
	double dEps = U(0.1);
	String sArRound[] =  {T("|not rounded|"),T("|round|"),T("|relief|"),T("|rounded with small diameter|"),T("|relief with small diameter|"),T("|rounded|")};
	int nArRound[] =  {_kNotRound,_kRound,_kRelief,_kRoundSmall,_kReliefSmall,_kRounded};
	PropString sRound(0, sArRound, T("Rounding Type"));
	String sArOrientation[] =  {T("|Parallel Beam Axis|"),T("|Perpendicular Beam Axis|")};
	//PropString sOrientation(1, sArOrientation, T("Orientation"));
	PropInt nColor (0,254,T("|Color|"));
	PropString sLayerGroup(1, "T", T("|Group, Layername or Zone Character|"));
	
// bOnInsert
	if(_bOnInsert)
	{
		showDialog();		
   		_Beam.append(getBeam(T("|Select male beam|")));
   		_Beam.append(getBeam(T("|Select female beam|")));
		return;
	}	

// ints
	int nOrientation;//=sArOrientation.find(sOrientation);
	int nRound=nArRound[sArRound.find(sRound,0)];
		
// beams
	Beam bm0=_Beam[0], bm1=_Beam[1];		
// standards
	Vector3d vx, vy, vz;
	if (nOrientation==0)
	{	
		vx = bm0.vecX();		

		Point3d pt = Line(bm1.ptCen(),bm1.vecX()).closestPointTo(_Pt0);
		pt.vis(1);
		vz = bm0.vecD(pt-_Pt0);
		vy = vx.crossProduct(-vz);

	}
	else// not implemented
	{
		;	
		
	}	

	vx.vis(_Pt0,1);
	vy.vis(_Pt0,3);
	vz.vis(_Pt0,150);

// contact face
	PlaneProfile pp0 = bm0.envelopeBody().shadowProfile(Plane(_Pt0,vz));
	PlaneProfile pp1 = bm1.envelopeBody().shadowProfile(Plane(_Pt0,vz));
	pp0.intersectWith(pp1);
	LineSeg ls = pp0.extentInDir(vx);
	ls.vis(6);

// display
	Display dp(nColor);
	
// tooling
	double dX,dY,dZ;
	dX = abs(vx.dotProduct(ls.ptStart()-ls.ptEnd()));
	dY = abs(vy.dotProduct(ls.ptStart()-ls.ptEnd()));		
	dZ = bm0.dD(vz);
	
	if (dX>0 && dY>0 && dZ >0)
	{
		Point3d ptHs = ls.ptMid()-vx*dX;
		House hs(ptHs , vx, vy, vz, dX*3, dY, dZ,0,0,0);
		hs.setEndType(_kFemaleSide);
		hs.setRoundType(nRound);
		bm1.addTool(hs);
		
		Body bd = hs.cuttingBody();
		bd.intersectWith(bm1.envelopeBody());
		dp.draw(bd);
	}
	else
	{
		dp.color(1);
		dp.draw(ls);
	}

// assignment
	if (sLayerGroup != "")
	{
		Entity ent = bm1; // assign your entity here
		// find group name
		int bFound;
		Group grAll[] = Group().allExistingGroups();
		for (int i=0;i<grAll.length();i++)
			if (grAll[i].name() == sLayerGroup)
			{
				bFound=true;
				grAll[i].addEntity(_ThisInst,TRUE,0,'T');
				break;	
			}
	
		// no valid groupname found, assuming it is a layername
		if (!bFound)
		{
			String sLayer = sLayerGroup;
			sLayer.makeUpper();
	
		// group assignment via entity
			String sGroupChars[] = {	'T', 'I','J','Z','C'};
			int nFindChar = sGroupChars.find(sLayer);
			if (sLayer.length()==1 && nFindChar >-1)// if you want to allow manual layer assignments replace <1> with <_bOnDbCreated>)
			{
				//overwrite the automatic layer assignment 
				assignToLayer(ent.layerName());
				Group grEnt[0];
				grEnt = ent.groups();
				for (int g = 0; g < grEnt.length(); g++)	
					grEnt[g].addEntity(_ThisInst, false, ent.myZoneIndex(),sLayer.getAt(0));
			}
		// create a new layer and/or assign it to it
			else
				assignToLayer(sLayerGroup);
		}
	}
		
#End
#BeginThumbnail
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
I10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110!__]F!
`

#End
