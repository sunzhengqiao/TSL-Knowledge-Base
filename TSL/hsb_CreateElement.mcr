#Version 8
#BeginDescription
Creates a floor element around the selected beams and assign it to the current group.

<version value="1.8" date="20apr20" author="nils.gregor@hsbcad.com"> HSB-7318 Committed last version again
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 8
#KeyWords 
#BeginContents
/// <History>//region

/// <version value="1.8" date="20apr20" author="nils.gregor@hsbcad.com"> HSB-7318 Committed last version again </version>
/// <version value="1.7" date="01apr20" author="nils.gregor@hsbcad.com"> HSB-6318 Coordinate system is taken by Collection entity </version>
/// <version value="1.6" date="26mar20" author="nils.gregor@hsbcad.com"> HSB-6318 all Entities can be selected for zone 0</version>
/// </History>

/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates an element out of selected entities
/// </summary>

//endregion


//basics and props
	U(1,"mm");

	PropString sCompName(1,"",T("Component Name"));	
	PropString sNotes(2,"",T("SubType"));
	PropString sDimStyle(0,_DimStyles,T("Dimstyle"));
	PropInt nColor (0,171,T("Color"));
	
					
//on insert
	if (_bOnInsert)
	{	
		Group gr = _kCurrentGroup;
		if ( (gr.namePart(0)=="") || (gr.namePart(1)=="") ) {
			reportMessage("\n" + T("Make a floor group current before inserting this TSL."));
			eraseInstance(); return;
		}

		showDialog();
		
		if ( sCompName == "" ) {
			reportMessage("\n" + T("You must give a component name"));
			eraseInstance(); return;
		}
					
		
		_Pt0 = _PtU;

		PrEntity ssE(T("Select a set of beams and sheets"), Entity());	
//		ssE.addAllowedClass(Sheet());		
//		ssE.addAllowedClass(TslInst());	
		
  		if (ssE.go()){
	 		Entity ents[0];
    			_Entity = ssE.set();
		}
		
		Vector3d vx, vy, vz;
		Beam bmAux;
		
		for (int i=0;i<_Entity.length();i++) 
		{ 
			if(_Entity[i].bIsKindOf(Beam())) 
			{
				bmAux=(Beam) _Entity[i];		
				break;
			}
		}//next i
		
		Point3d ptOrigen;
		int bOriginSet;
		
		if (_Entity.length()>0 && bmAux.bIsValid())
		{
			vz = bmAux.vecD(_ZU);	
			vx = bmAux.vecX();
			vy = vx.crossProduct(vz);
			vx.normalize();
			vy.normalize();
			vz.normalize();
			ptOrigen=bmAux.ptCen()+vz*bmAux.dD(vz)*0.5;		
			bOriginSet = true;
		}
		else
		{
			vx = _XU;
			vy = _YU;
			vz = _ZU;
			ptOrigen=_PtU;
		}
		
		//standards
		
		Plane pn(ptOrigen, vz);
		
		// get PP
		PlaneProfile pp;
		
		for (int i = 0 ; i < _Entity.length(); i++)
		{
			if(! bOriginSet)
			{
				CollectionEntity ce = (CollectionEntity)_Entity[i];
				
				if(! ce.bIsValid())
				{
					ptOrigen = getPoint(T("|Get origin point|"));
					Point3d pt = getPoint(T("|Get secound point for x-directionof the element|"));
					
					vx = Vector3d(pt - ptOrigen);
					vy = vz.crossProduct(vx);
					vz = vx.crossProduct(vy);
				}
				else
				{
					CoordSys cs = ce.coordSys();
					
					if(_ZW.dotProduct(cs.vecZ()) > _ZW.dotProduct(cs.vecY()))
						vz = cs.vecZ();
					else
						vz = cs.vecY();
					
					vx = cs.vecX();
					vy = vx.crossProduct(vz);
					
					Body bd = ce.realBody();
					Point3d pts[] = bd.extremeVertices(vz);
					
					if(pts.length() > 0)
					{
						ptOrigen = cs.ptOrg() + vz * abs(vz.dotProduct(pts.last() - cs.ptOrg()));
					}
					else					
						ptOrigen = cs.ptOrg();					
				}
				
				vx.normalize();
				vy.normalize();
				vz.normalize();
				
				bOriginSet = true;
				
				pn = Plane(ptOrigen, vz);
			}
			
			PlaneProfile ppEnt;
			
//			ppEnt = _Entity[i].realBody().extractContactFaceInPlane(pn, U(500));
			ppEnt = _Entity[i].realBody().shadowProfile(pn);
			Point3d ptOrg;
			if (pp.area() < U(10)){
				ptOrg = ppEnt.coordSys().ptOrg();
				pp = ppEnt;
				
			}
			else{
				
				LineSeg ls = ppEnt.extentInDir(vx);	
				double dShrink = abs(vx.dotProduct(ptOrg - ls.ptMid()));
				pp.shrink(	-dShrink);
				ppEnt.shrink(	-dShrink);
				pp.unionWith(ppEnt);	
				pp.shrink(dShrink);
				}
		}
		
		// find outer contour
		PLine pl, plAllContour[0];
		plAllContour = pp.allRings();
		
		for (int i = 0 ; i < plAllContour.length(); i++)
			if (plAllContour[i].area() > pl.area())
				pl = plAllContour[i];
		
		
		if (pl.area() < U(10) || !PlaneProfile(pl).coordSys().vecZ().isParallelTo(vz))
		{
			eraseInstance(); 
			return;	
		}
		
	// Define the direction of the beams 
		LineSeg seg = pp.extentInDir(vx);
		double dX = abs(vx.dotProduct(seg.ptEnd() - seg.ptStart()));
		double dY = abs(vy.dotProduct(seg.ptEnd() - seg.ptStart()));
		Vector3d vecDir = (dX > dY)? vx : vy;
		
		//create the element
		gr.setNamePart(2,sCompName);
		ElementRoof er;
		er.dbCreate(gr,pl);	
		er.setVecY(vecDir);
		er.setVecZ(vz);
		er.setSubType(sNotes);		
		_Element.append(er);
		_Element[0].setInformation("Manufactured Element");
		
		// append entities
		for (int i = 0 ; i < _Entity.length(); i++)
		{ 
			_Entity[i].assignToElementGroup(_Element[0], TRUE, 0, 'Z');
			GenBeam gbm = (GenBeam) _Entity[i];
			if (gbm.bIsValid())
			{ 
				gbm.setPanhand(_Element[0]);
			}
		}
		
		// relocate _Pt0 and grip
		Point3d ptPl[0];
		ptPl = pl.vertexPoints(TRUE);
		_Pt0.setToAverage(ptPl);
		return;
		//eraseInstance();	
	}// end on insert
	//________________________________________________________________________________________________
	

	if (_Entity.length()<1)
	{
		eraseInstance();
		return;
	}
// restrict color index
	if (nColor > 255 || nColor < -1) nColor.set(171);

// declare standards
	CoordSys cs;
	Point3d ptOrg;
	Vector3d vx,vy,vz;

// check element length
	if (_Element.length() < 1)
	{
		Group gr = _kCurrentGroup;
		if ( (gr.namePart(0)=="") || (gr.namePart(1)=="") ) {
			reportMessage("\n" + T("Make a floor group current before inserting this TSL."));
			eraseInstance();
			return;
		}		
		
		Beam bmAux=(Beam) _Entity[0];
		
		if (_Entity.length()>0 && bmAux.bIsValid())
		{
			vz = bmAux.vecD(_ZU);	
			vx = bmAux.vecX();
			vy = vx.crossProduct(vz);
			vx.normalize();
			vy.normalize();
			vz.normalize();			
		}
		else
		{
			vx = _XU;
			vy = _YU;
			vz = _ZU;	
		}	
		
		PLine pl;
		for (int i = 0; i < _PtG.length();i++)
			pl.addVertex(_PtG[i]);
		pl.close();
			
		//create the element
		gr.setNamePart(2,sCompName);
		ElementRoof er;
		er.dbCreate(gr,pl);
		er.setVecY(vy);
		er.setVecZ(vz);				
		_Element.append(er);
		_Element[0].setInformation("Manufactured Element");
		
		// append entities
		for (int i = 0 ; i < _Entity.length(); i++)
			_Entity[i].assignToElementGroup(_Element[0], TRUE, 0, 'Z');	
		// append sheets
		for (int i = 0 ; i < _Sheet.length(); i++)
			_Sheet[i].assignToElementGroup(_Element[0], TRUE, 0, 'Z');
			
		//reset Grips
		_PtG.setLength(0);	
	}


	
// declare standards
	Element el = _Element[0];
	if (!el.bIsValid())
	{
		eraseInstance();
		return;
	}



	cs = el.coordSys();
	ptOrg = cs.ptOrg();
	vx=cs.vecX();
	vy=cs.vecY();
	vz=cs.vecZ();

	_Pt0 = _Pt0 - vz * vz.dotProduct(_Pt0 - ptOrg);
	
	if(_PtG.length()< 1)
		_PtG.append(_Pt0 + (vx+vy+vz) * U(100));
		
//Display
	Display dp(nColor);
	dp.dimStyle(sDimStyle);	
	dp.draw(PLine(_Pt0, _PtG[0]));
	dp.draw(sCompName, _PtG[0], vx, vy, 1,0,_kDeviceX);
	double dTxtHeight = dp.textHeightForStyle	("O",sDimStyle);
	dp.textHeight(0.5 * 	dTxtHeight);		
	dp.draw(sNotes, _PtG[0], vx, vy, 1,-5,_kDeviceX);	
	assignToElementGroup(_Element[0], TRUE, 5, 'I');		

	eraseInstance();
	return;

#End
#BeginThumbnail
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
A`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`?_9
`
















#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End