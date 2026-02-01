#Version 8
#BeginDescription

#End
#Type O
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
// constants //region
	/// <summary Lang=en>
	/// Description
	/// </summary>

	/// <insert>
	/// Specify insert
	/// </insert>

	/// <remark Lang=en>
	/// 
	/// </remark>

	/// <version  value="1.00" date="14-01-2019"></version>

	/// <history>
	/// RP - 1.00 - 14-01-2019 -  Pilot version.

	/// </history>
	//endregion

	U(1,"mm");	
	double pointTolerance =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));	
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	//endregion


	

if(_bOnInsert)
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
				
// silent/dialog
	String sKey = _kExecuteKey;
	sKey.makeUpper();

	if (sKey.length()>0)
	{
		String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
		for(int i=0;i<sEntries.length();i++)
			sEntries[i] = sEntries[i].makeUpper();	
		if (sEntries.find(sKey)>-1)
			setPropValuesFromCatalog(sKey);
		else
			setPropValuesFromCatalog(T("|_LastInserted|"));					
	}	

	// prompt for entities
	Entity ents[0];
		PrEntity ssE(T("|Select beam(s)"), Beam());
	  	if (ssE.go())
	  	{
			ents.append(ssE.set());
	  	}
		_Map.setEntityArray(ents, false, "Beams", "Beams", "Beam");
	  	
	  	_Pt0 = getPoint(T("|Select base point|"));
	  	_Map.setPoint3d("Origin", _Pt0);
	  	_Map.setPoint3d("Xaxis", getPoint(T("|Select point for X-axis|")));
	  	if (getString(T("|<Enter> to select point for Y-Axis|") + T(" |<Z> to select Z-axis|")) == "")
	  	{
	  		_Map.setPoint3d("Yaxis", getPoint(T("|Select point for Y-axis|")));
	  	}
		else
	  	{
	  		_Map.setPoint3d("Zaxis", getPoint(T("|Select point for Z-axis|")));
	  	}
		
	return;
}	

Entity beams[] = _Map.getEntityArray("Beams", "Beams", "Beam");
for (int index=0;index<beams.length();index++) 
{ 
	Beam beam = (Beam)beams[0];
	Vector3d x(_Map.getPoint3d("Xaxis") - _Map.getPoint3d("Origin"));
	x.normalize();
	
	Vector3d y;
	Vector3d z;
	
	if (_Map.hasPoint3d("Yaxis"))
	{
		y = Vector3d(_Map.getPoint3d("Yaxis") - _Map.getPoint3d("Origin"));
		y.normalize();
		z = x.crossProduct(y);
	}
	else if (_Map.hasPoint3d("Zaxis"))
	{
		z = Vector3d(_Map.getPoint3d("Zaxis") - _Map.getPoint3d("Origin"));
		z.normalize();
		y = x.crossProduct(z);
	}
	else
	{
		eraseInstance();
		return;
	}
	
	Beam newBeam;
	newBeam.dbCreate(beam.realBody(), x, y, z);
	newBeam.setColor(beam.color());
	newBeam.setType(beam.type());
	newBeam.setBeamCode(beam.beamCode());
	newBeam.assignToLayer(beam.layerName());
	newBeam.setInformation(beam.information());
	newBeam.setGrade(beam.grade());
	newBeam.setMaterial(beam.material());
	newBeam.setLabel(beam.label());
	newBeam.setSubLabel(beam.subLabel());
	newBeam.setSubLabel2(beam.subLabel2());
	newBeam.setName(beam.name());
	newBeam.setModule(beam.module());
	newBeam.setHsbId(beam.hsbId());
	newBeam.setIsotropic(beam.isotropic());
	newBeam.setExtrProfile(beam.extrProfile());
	
	beam.dbErase();

}

if (!_bOnMapIO)
{
	eraseInstance();
	return;
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
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End