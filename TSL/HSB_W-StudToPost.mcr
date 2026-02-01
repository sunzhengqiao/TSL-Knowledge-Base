#Version 8
#BeginDescription
Last modified by: Anno Sportel (support.nl@hsbcad.com)
21.02.2018  -  version 1.02
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// 
/// </summary>

/// <insert>
/// -
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.02" date="21.02.2018"></version>

/// <history>
/// AS - 1.00 - 19.02.2018 -	First revision
/// AS - 1.01 - 20.02.2018 -	Add option to change post height, position and properties.
/// AS - 1.02 - 21.02.2018 -	Add option to set catalog through map.
/// </history>

double vectorTolerance = Unit(0.01, "mm");

String category = T("|Size and position|");

PropDouble widthPost(0, U(105), T("|Width post|"));
widthPost.setCategory(category);
widthPost.setDescription(T("|Sets the width of the posts.|") + TN("|Setting it to zero will not change the height.|"));

PropDouble heightPost(1, U(0), T("|Height post|"));
heightPost.setCategory(category);
heightPost.setDescription(T("|Sets the height of the posts.|") + TN("|Setting it to zero will not change the height.|"));

String positions[] = 
{
	T("|Front|"),
	T("|Center|"),
	T("|Back|")
};
int positionIndexes[] = 
{
	1,
	0,
	-1
};
PropString postPositionProp(1, positions, T("|Post position|"), 1);
postPositionProp.setCategory(category);
postPositionProp.setDescription(T("|Sets the height of the posts.|") + TN("|Setting it to zero will not change the height.|"));

String noYes[] = 
{
	T("|No|"), 
	T("|Yes|")
};
PropString stretchAboveTopPlateProp(0, noYes, T("|Stretch above top plate|"));
stretchAboveTopPlateProp.setCategory(category);
stretchAboveTopPlateProp.setDescription(T("|Specifies whether the post should be strecth through the top plate.|"));


category = T("|Beam properties|");

PropString beamTypeProp(2, _BeamTypes, T("|Beam type|"));
beamTypeProp.setCategory(category);
beamTypeProp.setDescription(T("|Sets the beam type of the post.|"));

PropString beamName(3, "", T("|Name|"));
beamName.setCategory(category);
beamName.setDescription(T("|Sets the name of the post.|"));

PropString beamMaterial(4, "", T("|hsbCAD Material|"));
beamMaterial.setCategory(category);
beamMaterial.setDescription(T("|Sets the name field of the post.|"));

PropString beamGrade(5, "", T("|Grade|"));
beamGrade.setCategory(category);
beamGrade.setDescription(T("|Sets the grade field of the post.|"));

PropString beamInformation(6, "", T("|Information|"));
beamInformation.setCategory(category);
beamInformation.setDescription(T("|Sets the information field of the post.|"));

PropString beamLabel(7, "", T("|Label|"));
beamLabel.setCategory(category);
beamLabel.setDescription(T("|Sets the label field of the post.|"));

PropString beamSublabel(8, "", T("|Sublabel|"));
beamSublabel.setCategory(category);
beamSublabel.setDescription(T("|Sets the sublabel field of the post.|"));

PropString beamSublabel2(9, "", T("|Sublabel 2|"));
beamSublabel2.setCategory(category);
beamSublabel2.setDescription(T("|Sets the sublabel 2 field of the post.|"));

PropString beamCode(10, "", T("|Beam code|"));
beamCode.setCategory(category);
beamCode.setDescription(T("|Sets the beam code field of the post.|"));

PropInt beamColor(0, -1, T("|Color|"));
beamColor.setCategory(category);
beamColor.setDescription(T("|Sets the color of the post.|"));


// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if (_kExecuteKey != "" && catalogNames.find(_kExecuteKey) != -1) 
{
	setPropValuesFromCatalog(_kExecuteKey);
}

if (_Map.hasString("Catalog"))
{
	setPropValuesFromCatalog(_Map.getString("Catalog"));
}

if (_bOnInsert)
{
	if (insertCycleCount() > 1) 
	{
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || catalogNames.find(_kExecuteKey) == -1 )
	{
		showDialog();
	}
	setCatalogFromPropValues(T("|_LastInserted|"));
	
	PrEntity ssBeams(T("|Select studs to convert|"), Beam());
	if (ssBeams.go())
	{
		_Beam.append(ssBeams.beamSet());
	}
	
	return;
}

if (_Beam.length() == 0) 
{
	reportWarning(T("|invalid or no beams selected.|"));
	eraseInstance();
	return;
}

if (widthPost <= 0)
{
	reportWarning(T("|The width of the post must have a positive value.|"));
	eraseInstance();
	return;
}

int stretchAboveTopPlate = noYes.find(stretchAboveTopPlateProp);
int postPosition = positionIndexes[positions.find(postPositionProp, 1)];
int beamType = _BeamTypes.find(beamTypeProp); 

for (int b = 0; b < _Beam.length(); b++)
{
	Beam stud = _Beam[b];
	
	stud.setType(beamType);
	stud.setName(beamName);
	stud.setMaterial(beamMaterial);
	stud.setGrade(beamGrade);
	stud.setInformation(beamInformation);
	stud.setLabel(beamLabel);
	stud.setSubLabel(beamSublabel);
	stud.setSubLabel2(beamSublabel2);
	stud.setBeamCode(beamCode);
	stud.setColor(beamColor);
	
	Element el = stud.element();
	if (!el.bIsValid())
	{
		// Only modify the section and continue to the next beam.
		stud.setD(stud.vecY(), widthPost);
		if (heightPost > 0)
		{
			double originalPostHeight = stud.dD(stud.vecZ());
			stud.setD(stud.vecZ(), heightPost);
			if (postPosition != 0)
			{
				stud.transformBy(-stud.vecZ() * postPosition * 0.5 * (heightPost - originalPostHeight));
			}
		}
		
		continue;
	}
	
	CoordSys elementCoordSys = el.coordSys();
	Point3d elOrg = elementCoordSys.ptOrg();
	Vector3d elX = elementCoordSys.vecX();
	Vector3d elY = elementCoordSys.vecY();
	Vector3d elZ = elementCoordSys.vecZ();
	_Pt0 = elOrg;
	
	Point3d elementCenter = elOrg - elZ * 0.5 * el.dBeamWidth();
	
	stud.setD(stud.vecD(elX), widthPost);
	if (heightPost > 0)
	{
		stud.setD(stud.vecD(elZ), heightPost);
		stud.transformBy(elZ * (elZ.dotProduct(elementCenter - stud.ptCenSolid()) + postPosition * 0.5 * (el.dBeamWidth() - heightPost)));
	}
	
	if (stretchAboveTopPlate)
	{
		Beam beams[] = el.beam();
		Beam topPlates[0];
		for (int b=0;b<beams.length();b++)
		{
			Beam beam = beams[b];
			if (beam.type() == _kSFTopPlate)
			{
				topPlates.append(beam);
			}
		}
		
		for (int t=0;t<topPlates.length();t++)
		{
			Beam topPlate = topPlates[t];
			
			Point3d startTopPlate = topPlate.ptCenSolid() - topPlate.vecX() * 0.5 * topPlate.solidLength();
			Point3d endTopPlate = topPlate.ptCenSolid() + topPlate.vecX() * 0.5 * topPlate.solidLength();
			
			if ((topPlate.vecX().dotProduct(startTopPlate - stud.ptCenSolid()) * topPlate.vecX().dotProduct(endTopPlate - stud.ptCenSolid())) < 0)
			{
				Cut cut(topPlate.ptCenSolid() + topPlate.vecD(elY) * 0.5 * topPlate.dD(elY), topPlate.vecD(elY));
				stud.addToolStatic(cut, _kStretchOnInsert);
				
				topPlate.dbSplit(stud.ptCenSolid() + stud.vecD(topPlate.vecX()) * 0.5 * stud.dD(topPlate.vecX()), stud.ptCenSolid() - stud.vecD(topPlate.vecX()) * 0.5 * stud.dD(topPlate.vecX()));
				
				break;
			}
		}
	}
}

eraseInstance();
return;
#End
#BeginThumbnail



#End