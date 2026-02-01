#Version 8
#BeginDescription
Last modified by: Yarnick Boertje (support.nl@hsbcad.com)
24.04.2017  -  version 1.07

This TSL duplicates beams.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 7
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl duplicates beams
/// </summary>

/// <insert>
/// Select a wall, insert sheet zone in properties.
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.07" date="24.04.2017"></version>

/// <history>
/// YB - 1.00 - 06.04.2017 -	Pilot version
/// YB - 1.01 - 07.04.2017 - 	Added support for angled beams at lower end, improved filter
/// YB - 1.02 - 07.04.2017 - 	Fixed a bug where beams would go through an opening
/// YB - 1.03 - 10.04.2017 - 	Fixed angled beams at lower end
/// YB - 1.04 - 10.04.2017 - 	Added an include / exlude option for the filter
/// YB - 1.05 - 21.04.2017 - 	Fixed a bug with mirroring the wall, TSL will now be deleted after placing.
/// YB - 1.06 - 24.04.2017 - 	TSL now cuts a beam properly when intersecting a second roofplane.
/// YB - 1.07 - 24.04.2017 - 	Bug fix.
/// </history>

double vectorTolerance = Unit(0.01, "mm");

String categories[] = 
{
	"Filter",
	"Sheeting"
};
String filterTypeCategories[] = { "Include", "Exclude"};
PropString filterType(0, filterTypeCategories, T("|Filter type|"));
filterType.setDescription(TN("|Include: The TSL will only duplicate the beams with the beamcode entered in the property 'Beamcode filter'.|") + TN("|Exclude: The TSL will filter out the beams with the beamcode entered in the property 'Beamcode filter'.|"));
filterType.setCategory(categories[0]);
PropString beamcodeFilter(1, "", T("|Beamcode filter|"));
beamcodeFilter.setDescription(TN("|Beamcode used for filtering the beams. Use the property 'Filter type' to include or excluse beams with this beamcode.|"));
beamcodeFilter.setCategory(categories[0]);

int zoneIndexes[] = {1,2,3,4,5,6,7,8,9,10};
PropInt propZoneIndex(1, zoneIndexes, T("|Zone index|"));
propZoneIndex.setDescription(TN("|The zone index for the sheeting.|"));
propZoneIndex.setCategory(categories[1]);
int zoneIndex = propZoneIndex;
if (zoneIndex > 5)
   zoneIndex = 5 - zoneIndex;

// Select set of beams 
if(_bOnInsert)
{
	if(insertCycleCount() > 1)
	{
		eraseInstance();
		return;
	}
	
	showDialog();
	_Element.append(getElement(T("|Select wall|")));
	
	return;
}

Element el;
if(_Element.length() != 1)
{
	eraseInstance();
	return;
}

if(!_Element[0].bIsKindOf(Wall()))
{
	eraseInstance();
	return;
}
el = _Element[0];

assignToElementGroup(el, true, 0, 'E');

Wall wall = (Wall)el;

CoordSys csEl = el.coordSys();
Point3d elOrg = csEl.ptOrg();
Vector3d elX = csEl.vecX();
Vector3d elY = csEl.vecY();
Vector3d elZ = csEl.vecZ();

_Pt0 = elOrg;

for (int i=0;i<_Map.length();i++) 
{
	String test = _Map.keyAt(i);
  if (_Map.keyAt(i) != "Beam" && _Map.keyAt(i) != "Sheet" && _Map.keyAt(i) != "BeamOriginal")
   continue;
  if (!_Map.hasEntity(i))
   continue;
  
  Entity ent = _Map.getEntity(i);
  if(_Map.keyAt(i) == "BeamOriginal")
  {
  	Beam bmOrg = (Beam)ent;
  	double transformWidth = bmOrg.dD(elX) * 0.5;

	bmOrg.transformBy(elX * transformWidth);
  }
  else	
  	ent.dbErase();
  
  _Map.removeAt(i, true);
  i--;
 }

 int filterTypeIndex = filterTypeCategories.find(filterType);

// Get all beams from the element
Beam beams[] = el.beam();

String beamcodeFilters[0];
int amountOfSeperators = 0;
for(int i = 0; i < beamcodeFilter.length(); i++)
{
	if(beamcodeFilter.getAt(i) == ';')
		amountOfSeperators++;
}

for(int i = 0; i <= amountOfSeperators; i++)
{
	beamcodeFilters.append(beamcodeFilter.token(i, ';'));
}

Beam filteredBeams[0];
for(int b = 0; b < beams.length(); b++)
{
	Beam bm = beams[b];
	for(int i = 0; i < beamcodeFilters.length(); i++)
	{
		
		if(bm.beamCode().token(0, ';') == beamcodeFilters[i] && bm.beamCode().token(0, ';') != "")
		{
			if(filterTypeIndex == 1)
				beams.removeAt(b);
			
			else
				filteredBeams.append(bm);
		}
	}
}

if(filterTypeIndex == 1)
filteredBeams = beams;

// Get all sheet from the selected zone
Sheet allSheet[] = el.sheet(zoneIndex);

//PlaneProfile 
Point3d sheetEdges[0];
for(int s = 0; s < allSheet.length(); s++)
{
	Sheet sh = allSheet[s];
	PlaneProfile pp = sh.profShape();
	Point3d corners[] = pp.getGripVertexPoints();
	if (corners.length() == 0)
		continue;
	corners.append(corners[0]);
	
	for (int p=0; p<(corners.length() - 1); p++)
	{
		Point3d thisPoint = corners[p];
		Point3d nextPoint = corners[p+1];

		Vector3d edge(nextPoint - thisPoint);
		edge.normalize();
		if (abs(edge.dotProduct(elX)) > vectorTolerance) continue;
		
		Point3d midPoint = (thisPoint + nextPoint)/2;
		sheetEdges.append(midPoint);
	}
}

// Loop through all points in the array
for(int i = 0; i < sheetEdges.length(); i++)
{         
	Point3d sheetEdgeFirst = sheetEdges[i];
	// Loop through all points in the array, index is your previous index + 1
	for(int j = i + 1; j < sheetEdges.length(); j++)
	{
		Point3d sheetEdgeSecond = sheetEdges[j];
		// Check if your first number is higher than your second one
		double test = abs(elX.dotProduct(sheetEdges[i] - sheetEdges[j]));
		if (abs(elX.dotProduct(sheetEdges[i] - sheetEdges[j])) < vectorTolerance)
		{
			sheetEdges.removeAt(j);
			j--;
			continue;
		}
		if (elX.dotProduct(sheetEdges[i] - sheetEdges[j]) < vectorTolerance)
		{
			// If so, swap the numbers
			sheetEdges.swap(i, j);
		}
	}
}

if(sheetEdges.length() < 2)
{
	eraseInstance();
	return;
}

sheetEdges.removeAt(0);
sheetEdges.removeAt(sheetEdges.length() - 1);

// Calculate all the line segments between the sheets
Point3d elPtOrg = el.ptOrg();
elPtOrg = elPtOrg + elY * U(200) - elX * U(200);

LineSeg elMinMax = el.segmentMinMax();
double elLength = elX.dotProduct(elMinMax.ptEnd() - elMinMax.ptStart());

Point3d linePtStart = el.ptOrg() + elY * U(200) - elX * U(500);
Point3d sheetJointLocations[0];
Point3d gridPoints[] = PlaneProfile(el.plOutlineWall()).getGripVertexPoints();

// Calculate the tolerance between the beam and the line segment
double beamHeight = el.dBeamHeight();
Beam verticalBeams[0];
Beam sheetJointBeams[0];

// Loop through all beams and append the ones that are vertical and behind a sheet
for(int b = 0; b < filteredBeams.length(); b++)
{
	Beam bm = (Beam)filteredBeams[b];
	
	if(elX.dotProduct(bm.vecX()) < vectorTolerance)
	{
		verticalBeams.append(bm);
		for(int i = 0; i < sheetEdges.length(); i++)
		{
			double test = abs(elX.dotProduct(sheetEdges[i] - bm.ptCen()));
			if(abs(elX.dotProduct(sheetEdges[i] - bm.ptCen())) <= beamHeight) 
			{
				sheetJointBeams.append(bm);
				break;
			}
		}
	}
}

if(sheetJointBeams.length() < 1)
{
	eraseInstance();
	return;
}

for(int b = 0; b < sheetJointBeams.length(); b++)
{
	Beam bm = sheetJointBeams[b];
	for(int i = 0; i < beamcodeFilters.length(); i++)
	{
		String test1 = beamcodeFilters[i];
		String test2 = bm.beamCode().token(0, ';');
		if(bm.beamCode().token(0, ';') == beamcodeFilters[i] && bm.beamCode().token(0, ';') != "")
		{
			sheetJointBeams.removeAt(b);
			b--;
		}
	}
}

Beam bm[0];

for(int b = 0; b < filteredBeams.length(); b++)
	bm.append((Beam)filteredBeams[b]);
	
Beam allAngledBeams[0];
Beam blockingBeams[0];
int beamTypesToExclude[] = 
{
	_kSFBlocking
};

// Filter out all angled beams.
for(int b = 0; b < filteredBeams.length(); b++)
{
	Beam bm = filteredBeams[b];
	if(beamTypesToExclude.find(bm.type()) != -1)
	{
		blockingBeams.append(bm);
		continue;
	}

	if(abs(elY.dotProduct(bm.vecY())) < vectorTolerance)
	{
		continue;
	}
	
	allAngledBeams.append(bm);
}

for(int i = 0; i < sheetJointBeams.length(); i++)
{
	for(int j = i + 1; j < sheetJointBeams.length(); j++)
	{
		double test = elY.dotProduct(sheetJointBeams[i].ptCen() - sheetJointBeams[j].ptCen());
		if(elY.dotProduct(sheetJointBeams[i].ptCen() - sheetJointBeams[j].ptCen()) > vectorTolerance)
		{
			sheetJointBeams.swap(i, j);
		}
	}
}

for(int b = 0; b < sheetJointBeams.length(); b++)
{
	// Get the original beam
	Beam bmOrg = sheetJointBeams[b];
	_Map.appendEntity("BeamOriginal", bmOrg);
	Point3d ptCenter = bmOrg.ptCen();`
	// Create a beam, this is a copy of the original beam
	Beam bmCopy = bmOrg.dbCopy();
	_Map.appendEntity("Beam", bmCopy);
	verticalBeams.append(bmCopy);
	
	// Set the transform width 
	double transformWidth = bmOrg.dD(elX) * 0.5;
	
	// Transform both beams 
	bmCopy.transformBy(elX * transformWidth);
	sheetJointBeams[b].transformBy(-elX * transformWidth);
	
	
	Beam intersectingCopyBeam[] = bmCopy.filterBeamsCapsuleIntersect(bm);
	
	Point3d controlPoint = bmOrg.ptCenSolid() + elY * 0.45 * bmOrg.solidLength() - elX * 0.5 * bmOrg.dD(elY);
	Point3d controlPointCopy = bmCopy.ptCenSolid() + elY * 0.45 * bmCopy.solidLength() + elX * 0.5 * bmCopy.dD(elY);
	
	Beam beamsAtBeamStart[] = Beam().filterBeamsHalfLineIntersectSort(allAngledBeams, controlPoint, elY);
	Beam beamsAtBeamStartReversed[] = Beam().filterBeamsHalfLineIntersectSort(allAngledBeams, controlPoint, -elY);
	Beam beamsAtBeamStartCopy[] = Beam().filterBeamsHalfLineIntersectSort(allAngledBeams, controlPointCopy, elY);
	Beam beamsAtBeamStartReversedCopy[] = Beam().filterBeamsHalfLineIntersectSort(allAngledBeams, controlPointCopy, -elY);

	if (beamsAtBeamStart.length() > 0)
	{
		bmOrg.stretchStaticTo(beamsAtBeamStart[0], _kStretchOnInsert);
		bmCopy.stretchStaticTo(beamsAtBeamStart[0], _kStretchOnInsert);
	}
		
	if (beamsAtBeamStartReversed.length() > 0)
	{
		bmOrg.stretchStaticTo(beamsAtBeamStartReversed[0], _kStretchOnInsert);
		bmCopy.stretchStaticTo(beamsAtBeamStartReversed[0], _kStretchOnInsert);
	}
	
	if(beamsAtBeamStart.length() > 0 && beamsAtBeamStartCopy.length() > 0 && beamsAtBeamStart[0] != beamsAtBeamStartCopy[0])
	{
		Beam bmIntersect = beamsAtBeamStartCopy[0];
		Vector3d bmIntersectX = bmIntersect.vecX();
		Vector3d bmIntersectZ = bmIntersect.vecD(_ZW);
		Point3d test = bmIntersect.ptCenSolid() - bmIntersectZ * 0.5 * bmIntersect.dD(bmIntersectZ);
		Cut cut(test, bmIntersectZ);
		bmCopy.addTool(cut);
		bmOrg.addTool(cut);
	}
	if(beamsAtBeamStartReversed.length() > 0 && beamsAtBeamStartReversedCopy.length() > 0 && beamsAtBeamStartReversed[0] != beamsAtBeamStartReversedCopy[0])
	{
		Beam bmIntersect = beamsAtBeamStartReversedCopy[0];
		Vector3d bmIntersectX = bmIntersect.vecX();
		Vector3d bmIntersectZ = bmIntersect.vecD(_ZW);
		Point3d test = bmIntersect.ptCenSolid() - bmIntersectZ * 0.5 * bmIntersect.dD(bmIntersectZ);
		Cut cut(test, bmIntersectZ);
		bmCopy.addTool(cut);
		bmOrg.addTool(cut);
	}
}

for(int c = 0; c < blockingBeams.length(); c++)
{
	Beam blockingBeam = blockingBeams[c];
	Beam intersectingBeams[] = Beam().filterBeamsHalfLineIntersectSort(verticalBeams, blockingBeam.ptCenSolid(), blockingBeam.vecX());
	Beam intersectingBeamsReversed[] = Beam().filterBeamsHalfLineIntersectSort(verticalBeams, blockingBeam.ptCenSolid(), -blockingBeam.vecX());
	if(intersectingBeams.length() > 0)
		blockingBeam.stretchStaticTo(intersectingBeams[0], _kStretchOnInsert);
	if(intersectingBeamsReversed.length() > 0)
		blockingBeam.stretchStaticTo(intersectingBeamsReversed[0], _kStretchOnInsert);
}

eraseInstance();
return;
#End
#BeginThumbnail






#End