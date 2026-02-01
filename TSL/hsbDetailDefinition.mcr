#Version 8
#BeginDescription
version  value="1.1" date="14dec11" author="th@hsbCAD.de">
error display if invalid section is defined

/// This tsl defines the section for detail drawings, views or sections.
/// One can select a set of entities with a solid representation. With the 
/// intersection of this with the bounding box of the instance it defines the solids
/// to be shown in the declared multipage.

/// Dieses TSL definiert den Schnittbereich für Detailzeichnungen, Ansichten oder Schnitte.
/// Es wird die Schnittmenge der gewählten Körper mit dem Hüllquader der Instanz als
/// Definition für Einzelzeichnungen verwendet.

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl defines the section for detail drawings, views or sections.
/// One can select a set of entities with a solid representation. With the 
/// intersection of this with the bounding box of the instance it defines the solids
/// to be shown in the declared multipage.
/// </summary>

/// <summary Lang=de>
/// Dieses TSL definiert den Schnittbereich für Detailzeichnungen, Ansichten oder Schnitte.
/// Es wird die Schnittmenge der gewählten Körper mit dem Hüllquader der Instanz als
/// Definition für Einzelzeichnungen verwendet.
/// </summary>


/// <insert Lang=en>
/// Pick two points defining the diagonal of the section area. If you set the height
/// to 0, it will calculate the extents of all selected entities and set the height and 
/// insertion point accordingly.
/// </insert>

/// History
///<version  value="1.1" date="14dec11" author="th@hsbCAD.de">error display if invalid section is defined</version>
///<version  value="1.0" date="15dec11" author="th@hsbCAD.de">initial</version>

// basics and props
	U(1,"mm");
	double dEps = U(.1);
	String sArProp[0];

	sArProp.append(T("|Detail Name|"));
	PropString sDetailName(0,T("|Detail|"),sArProp[sArProp.length()-1]);	

	String sArType[] = {T("|Detail Definition|"), T("|Vertical View Definition|"), T("|Vertical Section|")};
	sArProp.append(T("|Type|"));
	PropString sType(2,sArType,sArProp[sArProp.length()-1]);	
	sType.setDescription(T("|Defines the the type of the Definition|"));
	
	sArProp.append(T("|Length|"));
	PropDouble dX(0,U(500),sArProp[sArProp.length()-1]);	

	sArProp.append("   " + T("|Width|"));
	PropDouble dY(1,U(500),sArProp[sArProp.length()-1]);	

	sArProp.append("   " + T("|Height|"));
	PropDouble dZ(2,0,sArProp[sArProp.length()-1]);	
	dZ.setDescription(T("|0 = auto|"));

	sArProp.append(T("|Dimstyle|"));
	PropString sDimStyle(1,_DimStyles,sArProp[sArProp.length()-1]);	
	
	sArProp.append("   " + T("|Text Height|"));
	PropDouble dTxtH(3,U(150),sArProp[sArProp.length()-1]);

	sArProp.append("   " + T("|Color|"));
	PropInt nColor(0,170,sArProp[sArProp.length()-1]);	
	
// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
	
	// get base rectangle	
		Point3d pt1, pt2, pt3;
		pt1 = getPoint(T("|Select lower left corner|"));
		
		PrPoint ssP("\n" + T("|Select upper right corner|"),pt1);
		if (ssP.go()==_kOk) // do the actual query
			pt2 = ssP.value(); // retrieve the selected point

	// get entities
		PrEntity ssE(T("|Select Entities|"), Entity());
		Entity ents[0];
  		if (ssE.go())
	    	ents.append(ssE.set());	
	
	// ignore non solid entities and get the total body
		Body bdTotal;
		for (int i=0;i<ents.length();i++)
		{
		
			Body bd = ents[i].realBody();
			if (bd.volume()<pow(dEps,3))continue;
			_Entity.append(ents[i]);
			bdTotal.addPart(bd);
		}
		


		
		dX.set(abs(_XU.dotProduct(pt2-pt1)));
		dY.set(abs(_YU.dotProduct(pt2-pt1)));
		setCatalogFromPropValues(T("|_LastInserted|"));
		showDialog(T("|_LastInserted|"));
		
	// set the height if set to auto (dZ=0)	
		if (dZ<=0)
		{
			Point3d pt[]=bdTotal.extremeVertices(_ZU);	
			if(pt.length()>0)
			{
			// set dZ to the extensions of the total solid + a standard offset to ensure an edge offset	
				dZ.set(abs(_ZU.dotProduct(pt[0]-pt[1]))+U(100));
				pt1.transformBy(_ZU*(_ZU.dotProduct(pt[0]-pt1)-U(50)));
				pt2.transformBy(_ZU*(_ZU.dotProduct(pt[0]-pt2)-U(50)));
			}
		}
		if (dX<=0)dX.set(U(500));
		if (dY<=0)dY.set(U(500));
				
		
		_Pt0 = (pt1+pt2)/2;
		_PtG.append(_Pt0+_XU*.5*dX);	// +X
		_PtG.append(_Pt0-_XU*.5*dX);	// -X
		_PtG.append(_Pt0+_YU*.5*dY);	// +Y
		_PtG.append(_Pt0-_YU*.5*dY);	// -Y
		_PtG.append(_Pt0-_ZU*dZ);		// +Z
		_PtG.append(_Pt0-0.5*_ZU*dZ - _XU*(.5*dX+dTxtH)+ _YU*(.5*dY+dTxtH)); // description grip
		
		_Map.setVector3d("vx",_XU);
		_Map.setVector3d("vy",_YU);
		_Map.setVector3d("vz",_ZU);
		
		return;
	}
// end on insert


// standards
	Vector3d vx= _XE;//_Map.getVector3d("vx");
	Vector3d vy= _YE;//_Map.getVector3d("vy");
	Vector3d vz= _ZE;//_Map.getVector3d("vz");

// ints
	int nType=sArType.find(sType);
	

// validate detail name
	if (_bOnDbCreated || _bOnRecalc || _kNameLastChangedProp == sArProp[0])
	{
		Entity entDetails[] = Group().collectEntities(true,TslInst(),_kModelSpace);
		String sDetailNames[0];;
		for (int i = 0; i < entDetails.length(); i++)
			if (entDetails[i].bIsKindOf(TslInst()))
			{
				TslInst tsl = (TslInst)entDetails[i];
				if (tsl.scriptName()==scriptName() && tsl!=_ThisInst)
					sDetailNames.append(tsl.propString(0));
			}
	
		String sNewDetailName = sDetailName;
		int n, nFound;
		nFound=sDetailNames.find(sNewDetailName);
			
		while (nFound>-1 && n<1000)
		{
			sNewDetailName = sDetailName +" " + (n+1);
			sDetailNames.find(sNewDetailName);
			nFound=sDetailNames.find(sNewDetailName);
			n++;
		}
	// change detail name and inform user	
		if (sNewDetailName!=sDetailName)
		{
			reportMessage("\n" + T("|Detail Name|") + " '" + sDetailName + "' " + T("|already exists in this drawing.|") + " " + T("|Name has been changed to:|") + " '" + sNewDetailName+ "' ");
			sDetailName.set(sNewDetailName);		
		}
	}

// grip or property changes
	// X-Grips
	if (_kNameLastChangedProp == "_PtG0" || _kNameLastChangedProp == "_PtG1")
	{
		double d = abs(vx.dotProduct(_PtG[0]-_PtG[1]));
		// invalid
		if (d>-dEps && d<dEps)
		{
			_PtG[0] = _Pt0+vx*.5*dX;
			_PtG[1] = _Pt0-vx*.5*dX;
			d = dX;	
		}	
		else
		{
			Point3d ptMid = (_PtG[0]+_PtG[1])/2;
			_Pt0.transformBy(vx*vx.dotProduct(ptMid-_Pt0));
		}		
		dX.set(d);				
	}	
	// Y-Grips
	if (_kNameLastChangedProp == "_PtG2" || _kNameLastChangedProp == "_PtG3")
	{
		double d = abs(vy.dotProduct(_PtG[2]-_PtG[3]));
		// invalid
		if (d>-dEps && d<dEps)
		{
			_PtG[2] = _Pt0+vy*.5*dY;
			_PtG[3] = _Pt0-vy*.5*dY;
			d = dY;	
		}	
		else
		{
			Point3d ptMid = (_PtG[2]+_PtG[3])/2;
			_Pt0.transformBy(vy*vy.dotProduct(ptMid-_Pt0));
		}		
		dY.set(d);				
	}	
	// Z-Grip
	else if (_kNameLastChangedProp == "_PtG4")
	{
		double d = vz.dotProduct(_PtG[4]-_Pt0);
		// invalid
		if (d>-dEps && d<dEps)
		{
			d=dZ;	
		}			
		else if (d<-dEps)
		{
			vz*=-1;
			vy*=-1;
			_YE*=-1;
			_ZE*=-1;
			
			_Map.setVector3d("vy",_YU);
			_Map.setVector3d("vz",_ZU);			
		}	
		dZ.set(abs(d));				
	}
	// dX property changes	
	else if (_kNameLastChangedProp == sArProp[2])
	{
		_PtG[0] = _Pt0+vx*.5*dX;
		_PtG[1] = _Pt0-vx*.5*dX;			
	}	
	// dY property changes	
	else if (_kNameLastChangedProp == sArProp[3])
	{
		_PtG[2] = _Pt0+vy*.5*dY;
		_PtG[3] = _Pt0-vy*.5*dY;			
	}	
	// dZ property changes	
	else if (_kNameLastChangedProp == sArProp[4])
	{
		_PtG[4] = _Pt0+vz*dZ;		
	}
// relocate grips
	if (_PtG.length()>4)
	{
		_PtG[0] = _Pt0+vx*.5*dX;
		_PtG[1] = _Pt0-vx*.5*dX;
		_PtG[2] = _Pt0+vy*.5*dY;
		_PtG[3] = _Pt0-vy*.5*dY;
		_PtG[4] = _Pt0+vz*dZ;	
	}

// add triggers
	String sTrigger[] = {T("|Add Entity|"),T("|Remove Entity|")};
	for (int i = 0; i < sTrigger.length(); i++)
		addRecalcTrigger(_kContext, sTrigger[i]);	

// trigger 0/1: add/remove entity
	if (_bOnRecalc && (_kExecuteKey==sTrigger[0] ||  _kExecuteKey==sTrigger[1]))
	{
		PrEntity ssE(T("|Select Entities|"), Entity());
		Entity ents[0];
  		if (ssE.go())
	    	ents.append(ssE.set());	
		for (int i=0;i<ents.length();i++)
		{
			int n = _Entity.find(ents[i]);
		// add
			if (n<0 && _kExecuteKey==sTrigger[0])
				_Entity.append(ents[i]);
		// remove
			else if (n>-1 && _kExecuteKey==sTrigger[1])
				_Entity.removeAt(n);						
		}
		setExecutionLoops(2);
	}

	
// the display
	Display dp(nColor);
	dp.dimStyle(sDimStyle);
	dp.textHeight(dTxtH);

	
// the detail bounding body
	if (dX<=0 || dY<=0 || dZ <=0)
	{
		
		reportMessage("\n" + sDetailName+ " " + T("|The section volume may not be empty.|"));
		Display dpErr(1);
		dpErr.textHeight(dTxtH);
		dpErr.draw(T("|Error|") + " " + sDetailName,_Pt0,vx,vy,0,0,_kDeviceX)	;
		return;
	}
	Body bdBound(_Pt0,vx,vy,vz,dX,dY,dZ,0,0,1);
	
// draw wireframe bounds
	{
		LineSeg ls;
		PLine plRec;
		Vector3d vec = .5*(vx*dX+vy*dY);
		Point3d ptX = _Pt0;
		ls = LineSeg(ptX-vec,ptX+vec);
		plRec.createRectangle(ls,vx,vy);
		dp.draw(plRec);
		plRec.transformBy(vz*dZ);
		dp.draw(plRec);
	
		ptX = _Pt0+vz*.5*dZ;
		vec = .5*(vx*dX+vz*dZ);
		ls = LineSeg(ptX-vec,ptX+vec);
		plRec.createRectangle(ls,vx,vz);
		plRec.transformBy(-.5*vy*dY);	
		dp.draw(plRec);
		plRec.transformBy(vy*dY);
		dp.draw(plRec);
	
		vec = .5*(vy*dY+vz*dZ);
		ls = LineSeg(ptX-vec,ptX+vec);
		plRec.createRectangle(ls,vy,vz);
		plRec.transformBy(-.5*vx*dX);	
		dp.draw(plRec);
		plRec.transformBy(vx*dX);
		dp.draw(plRec);
	}
// draw detailname	
	if (nType==0)
	{
		dp.draw(sDetailName,_PtG[5],_XW,_YW,1,0,_kDevice);
	}
// draw section line with section bubbles
	else if (nType==1 || nType==2)
	{	
		Point3d ptSect[] = {_PtG[0]-vy*.5*dY,_PtG[1]-vy*.5*dY};
		
		double dW = sqrt(2*pow(dTxtH*1.05,2));
		Point3d pt = ptSect[0]+vx*dW;
		// createposnum mask
		PLine plPosNum(vz);
		plPosNum.createCircle(pt,vz,dTxtH);

		PLine plArrow(vy);		
		plArrow.addVertex(pt - vx*dW); 
		plArrow.addVertex(pt + vy*dW); 
		plArrow.addVertex(pt + vx*dW); 
		plArrow.addVertex(pt+vx*(dTxtH));
		plArrow.addVertex(pt-vx*(dTxtH),pt-vy*(dTxtH));				
		plArrow.close();
		
	// first sym
		dp.draw(sDetailName,pt,vx,vy,0,0);
		dp.draw(plPosNum);	
		PlaneProfile pp(plArrow);
		pp.joinRing(plPosNum,_kSubtract);	
		dp.draw(pp,_kDrawFilled);			

	// second sym
		Point3d pt2 = ptSect[1]-vx*dW;
		pp.transformBy(pt2-pt);
		plPosNum.transformBy(pt2-pt);
		
		dp.draw(sDetailName,pt2,vx,vy,0,0);
		dp.draw(plPosNum);
		if(nType==1)		dp.draw(pp);
		else if(nType==2)	dp.draw(pp,_kDrawFilled);
	
	// section line
		dp.lineType("DASHDOT");
		dp.draw(PLine(ptSect[0], ptSect[1]));
		
		dp.lineType("CONTINUOS");
			
	}
	//dp.draw(bdBound);
	
// draw detail name
	dp.color(nColor);
					
// draw detail bodies
	for (int i=0;i<_Entity.length();i++)
	{
	// process only intersecting bodies
		Body bd = _Entity[i].realBody();
		if (bd.volume()<pow(dEps,3))continue;
		setDependencyOnEntity(_Entity[i]);		
		bd.intersectWith(bdBound);
		if (bd.volume()<pow(dEps,3))continue;
		dp.color(_Entity[i].color())	;
		dp.draw(bd);
	}
	
// store quader lineSeg points in map to achieve max dimensions in shopdrawing
	Point3d ptExtr[] = {_Pt0+.5*(vx*dX+vy*dY),_Pt0-.5*(vx*dX+vy*dY)+vz*dZ};	
	_Map.setPoint3dArray("ptExtr",ptExtr);
	_Map.setInt("type",nType);// publishes the view type

	


	

		

#End
#BeginThumbnail
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
`


#End
