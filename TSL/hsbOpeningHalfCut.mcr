#Version 8
#BeginDescription
/// Dieses TSL erzeugt zwei Sägeschnitte links und rechts  einer Öffnung in der Schwelle eines Elementes.
/// Schwellen, welche nicht in der Nähe der Wandgrundrisslinie liegen werden ignoriert.
/// </summary>

version  value="1.1" date=20apr15" author="th@hsbCAD.de"
Gruppenzuordnung ergänzt (C) 

/// <remark Lang=de>
/// Fügen Sie das TSL dem Öffnungskatalog hinzu um es automatisch mit dem gewählten Stil auszuführen. 
/// Existierende Katalogeinträge können die Eigenschaften steuern.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords Opening;Halfcut;Top plate
#BeginContents
/// <summary Lang=de>
/// Dieses TSL erzeugt zwei Sägeschnitte links und rechts  einer Öffnung in der Schwelle eines Elementes.
/// Schwellen, welche nicht in der Nähe der Wandgrundrisslinie liegen werden ignoriert.
/// </summary>

/// <remark Lang=de>
/// Fügen Sie das TSL dem Öffnungskatalog hinzu um es automatisch mit dem gewählten Stil auszuführen. 
/// Existierende Katalogeinträge können die Eigenschaften steuern.
/// </remark>


/// <insert=en>
/// Select opening
/// </insert>


/// History
///<version  value="1.1" date=20apr15" author="th@hsbCAD.de"> Gruppenzuordnung ergänzt (C) </version>
///<version  value="1.0" date=24mar15" author="th@hsbCAD.de"> initial </version>

// basics and props 	
	U(1,"mm"); 	
	double dEps = U(0.1); 
	double dSawWidth = U(6);

	String sDepthName= T("|Depth|");
	PropDouble dDepth(0, U(10),sDepthName);
	dDepth.setDescription(T("|Sets the depth of the half cut|"));		

// on insert 	
	if (_bOnInsert)  	
	{ 
		if (insertCycleCount()>1) { eraseInstance(); return; }
		
		_Entity.append(getOpening());
		_Pt0 = getPoint();
		return;	
	}
	
// get defining entity
	Opening op;
	if (_Entity.length()>0 && _Entity[0].bIsKindOf(Opening()))
		op = (Opening)_Entity[0];
	
// _kill me on element deleted
	if (_bOnElementDeleted)
	{
		eraseInstance();
		return;	
	}	
		
// get element from opening
	Element el = op.element();
	_Element.append(el);
	CoordSys cs = el.coordSys();
	Point3d ptOrg = cs.ptOrg();
	Vector3d vecX =cs.vecX();
	Vector3d vecY =cs.vecY();
	Vector3d vecZ =cs.vecZ();
	assignToElementGroup(el, true,0,'C');
	
// get extremes and location of opening
	PLine plShape = op.plShape();
	LineSeg seg = PlaneProfile(plShape).extentInDir(vecX);
	Point3d ptMid =seg.ptMid();
	ptMid.transformBy(vecZ*(vecZ.dotProduct(ptOrg-ptMid)-.5*el.dBeamWidth()));
	double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
	Point3d ptRef = ptMid-vecY*.5*dY;
	ptRef.vis(5);
	double dWidth = op.width();
		
// add grips
	if (_PtG.length()<2)
	{
		_PtG.setLength(0);
		_PtG.append(ptRef-vecX*.5*dWidth);
		_PtG.append(ptRef+vecX*.5*dWidth);	
	}
	
// repos grips
	for (int i=0;i<_PtG.length();i++)
		_PtG[i].transformBy(vecZ*vecZ.dotProduct(ptOrg-_PtG[i]));			
	_Pt0.setToAverage(_PtG);

// display
	Display dp(3);
	PLine plRec;	
	plRec.createRectangle(LineSeg(ptOrg, ptOrg+vecX*U(20000)-vecZ*el.dBeamWidth()),vecX, -vecZ);
	PlaneProfile pp(plRec);
	plRec.createRectangle(LineSeg(_PtG[0]+vecZ*U(1000),_PtG[1]-vecZ*U(1000)),vecX, -vecZ);	
	PlaneProfile pp2(plRec);
	pp.intersectWith(PlaneProfile(plRec));
	plRec.createRectangle(LineSeg(_PtG[0]+vecZ*U(1000)+vecX*dSawWidth,_PtG[1]-vecZ*U(1000)-vecX*dSawWidth),vecX, -vecZ);		
	pp.joinRing(plRec,_kSubtract);
	dp.draw(pp,_kDrawFilled);
		
// stay in wait mode if no beams are found
	Beam beams[] = el.beam();
	Beam beamsHor[] = Beam().filterBeamsHalfLineIntersectSort(beams,ptMid,-vecY);
	if (beamsHor.length()<1)
	{
		return;	
	}
	else
	{
		Point3d ptCen = beamsHor[0].ptCenSolid();
		
	// validate if ths beam is within the valid range
		double d1 = abs(vecY.dotProduct(ptCen-ptRef));
		double d2 = abs(vecY.dotProduct(ptOrg-ptRef));
		double dRange = beamsHor[0].dD(vecY);
		
		if (dRange>d1 && dRange>d2)
		{
			beamsHor[0].realBody().vis(3);	
			Beam bm = beamsHor[0];
		// add halfcuts
			int nDir=1;
			for (int i=0; i<_PtG.length();i++)
			{
				Point3d pt = _PtG[i]-vecY*(vecY.dotProduct(_PtG[i]-ptCen)+.5*bm.dD(vecY)-dDepth);//-bm.dD(vecY)+dDepth
				pt.vis(4);
				HalfCut hc(pt, vecX*nDir, vecY, true);
				bm.addTool(hc);

				nDir*=-1;
			}	
	
		}
		else
		{
			eraseInstance();
			return;
		}
	}
		
	
#End
#BeginThumbnail
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
H\?0<_F:]-L;6"W@2"WB2&(#A(U"C]*BM5J123?W?U_D73IP>WXG_V=K6
`

#End