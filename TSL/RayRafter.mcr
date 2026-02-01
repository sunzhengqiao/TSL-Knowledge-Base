#Version 8
#BeginDescription
version value="1.1" date="27jan2020" author="thorsten.huck@hsbcad.com"
HSB-6316 dialog image updated

This tsl rotates the selected / detected rafters by the given angle. The sign of the angle will be calculated by the connecting hip or valley.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords Rafter, Ray;Strahlenschifter;Rotation
#BeginContents
/// <History>//region
/// <version value="1.1" date="27jan2020" author="thorsten.huck@hsbcad.com"> HSB-6316 dialog image updated </version>
/// <version value="1.0" date="08jan2020" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select rafters or roofplanes, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl rotates the selected / detected rafters by the given angle. The sign of the angle will be calculated by the connecting hip or valley.
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "RayRafter")) TSLCONTENT

//endregion



//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	// read a potential mapObject defined by hsbDebugController
	{ 
		MapObject mo("hsbTSLDev" ,"hsbTSLDebugController");
		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true;	break;}}
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		
	}
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
//end Constants//endregion

//region Properties
	String sAngleName=T("|Angle|");	
	PropDouble dAngle(nDoubleIndex++, 22.5, sAngleName,_kAngle);	
	dAngle.setDescription(T("|Defines the positive rotation angle.|") + T(" |The sign of the angle will be calculated by the connecting hip or valley.|")  );
	dAngle.setCategory(category);

	category = T("|Beam|");
	String sNameName=T("|Name|");	
	PropString sName(nStringIndex++, "", sNameName);	
	sName.setDescription(T("|Defines the Name|, ")+T("|empty string means the name of the entity will not change|"));
	sName.setCategory(category);
	
	PropInt nColor(nIntIndex++, -1, T("|Color|"));	
	nColor.setDescription(T("|Color '-1' will not change the color of the entity|"));	
	nColor.setCategory(category);
//End Properties//endregion 

//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();
		if (sKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			if (sEntries.findNoCase(sKey,-1)>-1)			
				setPropValuesFromCatalog(sKey);
			else
				showDialog();					
		}		
		else	
			showDialog();
		
	// prompt for beams
		PrEntity ssE(T("|Select rafters|, ") + T("|<Enter> to align first and last rafters by roofplane selection|"), Beam());
		if (ssE.go())
			_Beam.append(ssE.beamSet());
		
	// prompt for roofplanes if no beams found
		if (_Beam.length()<1)
		{ 
		// prompt for roofplanes
			Entity ents[0];
			PrEntity ssErp(T("|Select roofplane(s)|"), ERoofPlane());
		  	if (ssErp.go())
				ents.append(ssErp.set());
			
		// collect first and last of roofplane
			for (int i=0;i<ents.length();i++) 
			{ 
				ERoofPlane erp = (ERoofPlane)ents[i];
				if (!erp.bIsValid())continue;
				CoordSys cs = erp.coordSys();
				Beam beams[]=cs.vecX().filterBeamsPerpendicularSort(erp.beam());
				
				if (beams.length() > 0)_Beam.append(beams.first());
				if (beams.length() > 1)_Beam.append(beams.last()); 
			}//next i		
		}

		if (_Beam.length()<1)
		{ 
			reportMessage("\n" + scriptName() + ": " +T("|no valid rafters selected.|"));
			eraseInstance();
		}
		return;
	}	
// end on insert	__________________//endregion
	
	
//region Get all roofplanes
	ERoofPlane erps[0];
	{
		Entity	ents[] = Group().collectEntities(true, ERoofPlane(), _kModelSpace);
		for (int i=0;i<ents.length();i++) 
			erps.append((ERoofPlane)ents[i]); 
	}
//End Get all roofplanes//endregion 	
	
	
//region Loop beams
	for (int i=0;i<_Beam.length();i++) 
	{ 
		Beam b= _Beam[i]; 
		Point3d ptCen = b.ptCen();
		Vector3d vecX = b.vecX(); 
		Vector3d vecY = b.vecY();
		Vector3d vecZ = b.vecZ();
		vecX.vis(ptCen, 1);vecY.vis(ptCen, 3);vecZ.vis(ptCen, 150);
		
	// validate if roofplane link
		ERoofPlane erp;
		for (int e=0;e<erps.length();e++) 
		{ 
			Beam beams[]=erps[e].beam();		
			if (beams.find(b)>-1)
			{ 
				erp = erps[e];
				break;
			}
		}//next e
		if (!erp.bIsValid())continue;
		
		CoordSys csE = erp.coordSys();
		Vector3d vecXE = csE.vecX();
		Vector3d vecYE = csE.vecY();
		Vector3d vecZE = csE.vecZ();
		erp.coordSys().vecZ().vis(erp.coordSys().ptOrg(),6);
		
	// determine side
		PLine pl = erp.plEnvelope();pl.vis(2);
		Point3d pts[0], ptLeft= ptCen-b.vecD(vecXE)*.5*b.dD(vecXE), ptRight= ptCen+b.vecD(vecXE)*.5*b.dD(vecXE);
		pts = pl.intersectPoints(Plane(ptLeft, vecXE));
		pts = Line(ptLeft, -vecYE).orderPoints(pts);
		if (pts.length() > 0)ptLeft = pts.first();
		else continue;
		
		pts = pl.intersectPoints(Plane(ptRight, vecXE));
		pts = Line(ptRight, -vecYE).orderPoints(pts);
		if (pts.length() > 0)ptRight = pts.first();
		else continue;
		
		Vector3d vecEdge = Vector3d(ptRight - ptLeft);
		vecEdge.normalize();
		if (vecEdge.isParallelTo(vecXE) || vecEdge.isParallelTo(vecYE))continue;
		int nSide = vecEdge.dotProduct(_ZW) > 0?-1:1;
		
	// get base rotation point
		Point3d ptBase;
		pts = pl.intersectPoints(Plane(ptCen, vecXE));
		pts = Line(ptCen, vecYE).orderPoints(pts);
		if (pts.length() > 0)ptBase = pts.first();
		else continue;
		
		CoordSys csRot;
		csRot.setToRotation(nSide*dAngle, _ZW, ptBase);
				
	// get new vecX / transformation
		Vector3d vecXN = vecX.crossProduct(_ZW).crossProduct(-_ZW);
		vecXN.normalize();
		vecXN.transformBy(csRot);//vecXN.vis(ptBase, 1);
		Vector3d vecY2 = vecXN.crossProduct(-_ZW);
		pts = pl.intersectPoints(Plane(ptBase, vecY2));
		pts = Line(ptBase, vecXN).orderPoints(pts);
		Vector3d vecX2 = pts.last() - pts.first();
		vecX2.normalize();
		Vector3d vecZ2 = vecX2.crossProduct(vecY2);
		if (bDebug){vecX2.vis(ptBase, 1);	vecY2.vis(ptBase, 3);	vecZ2.vis(ptBase, 150);}
		
	// get half offset
		Point3d ptX = ptBase + vecY2 * .5 * b.dD(vecY);
		//ptX.vis(2);
		double dZ = abs(vecZE.dotProduct(ptX - csE.ptOrg()));
		
		CoordSys cs;
		cs.setToAlignCoordSys(ptBase, vecX, vecY, vecZ, ptBase, vecX2, vecY2, vecZ2);
		double det = cs.det();
		
	// apply cut
		Cut ct(ptBase, vecZE);
		
		if (bDebug)
		{ 
			Body bd = b.realBody();
			bd.transformBy(cs);
			bd.transformBy(vecZE * dZ);
			bd.addTool(ct, 0);	
			bd.vis(4);
		}
		else
		{ 
			b.transformBy(cs);
			b.transformBy(vecZE * dZ);
			b.addToolStatic(ct, 0);			
		}

	// assign color
		if (nColor >- 1)b.setColor(nColor);
		
	// assign name
		if (sName.length() > 0)b.setName(sName);
		
	}//next i
	
	if (!bDebug)
	{ 
		eraseInstance();
		return;
	}

//End Loop beams//endregion 	
	
	
#End
#BeginThumbnail
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
7")A$PB81,(F$3")A$PB81,(F$3"+_]D`

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
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End