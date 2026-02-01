#Version 8
#BeginDescription
Make a beamcut square on the longest side
Version 3.3 15-3-2022 Change vec tolerance for small angled beamcuts. And change the origin of the check for the free vectors, from the quader.ptorg to the resultingbody ptorg. Ronald van Wijngaarden

3.2 17/02/2022 Not use analysedBeamcut to check free direction Author: Robert Pol


3.4 2-6-2022 Do the check for intersection of the cuttingbody vectors with the beam after getting the correct vectors. Ronald van Wijngaarden

3.5 06/03/2024 Move point in vectorforprofile because of tolerance Author: Robert Pol
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 3
#MinorVersion 5
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// 
/// </summary>

/// <insert>
/// 
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <history>
/// AS - 1.00 - 23.01.2013 -	Pilot version
/// AS - 1.01 - 07.04.2014 -	Check orientation of vyBmTool
/// AS - 1.02 - 14.04.2014 -	Add flag for x direction
/// RP - 2.00 - 25.01.2019 -	Use static tools
/// RP - 2.01 - 15.03.2019 -	Check on contactface and free direction to make it work in more general situations.
/// RP - 2.02 - 15.03.2019 -	Make sure longest/ shortest side are correct.
/// RP - 2.03 - 11.04.2019 -	Not working for all vectors
/// RP - 2.04 - 12.04.2019 -	Check on wrong vector
/// RP - 2.05 - 26.06.2019 -	Add the loop for rotation twice so the beamcut gets rotated twice.
/// RP - 3.00 - 14.04.2020 -	Always on longest side
/// RP - 3.01 - 14.07.2020 -	Fix bug where beamcut is at the end of a beam
//#Versions
//3.5 06/03/2024 Move point in vectorforprofile because of tolerance Author: Robert Pol
//3.4 2-6-2022 Do the check for intersection of the cuttingbody vectors with the beam after getting the correct vectors. Ronald van Wijngaarden
//3.3 15-3-2022 Change vec tolerance for small angled beamcuts. And change the origin of the check for the free vectors, from the quader.ptorg to the resultingbody ptorg. Ronald van Wijngaarden
//3.2 17/02/2022 Not use analysedBeamcut to check free direction Author: Robert Pol


U(1,"mm");	
double pointTolerance =U(.1);
double vectorTolerance =U(.0001);
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
		PrEntity ssE(T("|Select beam(s)|"), Beam());
	  	if (ssE.go())
	  	{
			ents.append(ssE.set());
	  	}
		_Map.setEntityArray(ents, false, "Beams", "Beams", "Beam");	
		
	return;
}	

Entity beams[] = _Map.getEntityArray("Beams", "Beams", "Beam");
for (int index = 0; index < beams.length(); index++)
{
	Beam beam = (Beam)beams[index];
	_Pt0 = beam.ptCen();
	Body beamBody = beam.realBody();
//			beamBody.vis(1);
	
	BeamCut beamCuts[] = beam.getToolsStaticOfTypeBeamCut();
	Vector3d beamVecX = beam.vecX();
	Vector3d beamVecY = beam.vecY();
	Vector3d beamVecZ = beam.vecZ();
	
	for (int index2 = 0; index2 < beamCuts.length(); index2++)
	{
		BeamCut beamCut = beamCuts[index2];
		Body beamCutBody = beamCut.cuttingBody();
		Quader quader = beamCut.quader();
//		quader.vis(5);
		Vector3d vectorsToCheck[0];
		vectorsToCheck.append( quader.vecX());
		vectorsToCheck.append( quader.vecY());
		vectorsToCheck.append( quader.vecZ());
		
		Body resultingBody = beamCutBody;
		
		resultingBody.intersectWith(beam.envelopeBody());
//		resultingBody.vis(6);
		Point3d ptOrg = resultingBody.ptCen();
//		ptOrg.vis();
		
		Point3d bodyVertices[] = resultingBody.allVertices();
		Point3d intersectionPoint;
		for (int index3 = 0; index3 < vectorsToCheck.length(); index3++)
		{
			Vector3d vector = vectorsToCheck[index3];
//			vector.vis(ptOrg);
			
			if (abs(beam.vecD(vector).dotProduct(vector)) > 1 - vectorTolerance || abs(beamVecX.dotProduct(vector)) > 1 - vectorTolerance) continue;
			
			Vector3d mostAlignedVector = beamVecX;
			Vector3d vectorForProfile = beamVecZ;
			double dotProductX = abs(vector.dotProduct(beamVecX));
			double dotProductY = abs(vector.dotProduct(beamVecY));
			double dotProductZ = abs(vector.dotProduct(beamVecZ));
			double length = resultingBody.lengthInDirection(beamVecX);
			double width = resultingBody.lengthInDirection(beamVecY) + pointTolerance;
			double height = resultingBody.lengthInDirection(beamVecZ) + pointTolerance;
			
			if (dotProductY > dotProductX && dotProductY > dotProductZ)
			{
				mostAlignedVector = beamVecY;
				vectorForProfile = beamVecX;
				length += pointTolerance;
				width -= pointTolerance;
			}
			else if (dotProductZ > dotProductX && dotProductZ > dotProductY)
			{
				mostAlignedVector = beamVecZ;
				vectorForProfile = beamVecY;
				length += pointTolerance;
				height -= pointTolerance;
			}
			if (!beamBody.rayIntersection(ptOrg, mostAlignedVector, intersectionPoint) && !beamBody.rayIntersection(ptOrg, -mostAlignedVector, intersectionPoint)) continue;
			
			PlaneProfile sideBodyProfile = resultingBody.shadowProfile(Plane(resultingBody.ptCen(), vectorForProfile));
			PlaneProfile frontBodyProfile = resultingBody.shadowProfile(Plane(resultingBody.ptCen(), mostAlignedVector.crossProduct(vectorForProfile)));
//			frontBodyProfile.vis(1);
			Point3d resultingBodyCenter = sideBodyProfile.extentInDir(mostAlignedVector).ptMid();
//			vectorForProfile.vis(resultingBodyCenter, 2);
			resultingBodyCenter += vectorForProfile * vectorForProfile.dotProduct(frontBodyProfile.extentInDir(mostAlignedVector).ptMid() - resultingBodyCenter);
//			mostAlignedVector.vis(resultingBodyCenter);		

			Point3d sortedVertices[] = Line(resultingBodyCenter, mostAlignedVector).projectPoints(bodyVertices);
			sortedVertices = Line(resultingBodyCenter, mostAlignedVector).orderPoints(sortedVertices, pointTolerance);
			
			if (sortedVertices.length() < 3) continue;
			beam.removeToolStatic(beamCut);
//			resultingBodyCenter.vis(1);
			beamCut = BeamCut(resultingBodyCenter, beamVecX, beamVecY, beamVecZ, length, width, height);
			beamCut.cuttingBody().vis(3);
			beam.addToolStatic(beamCut);
		}		
	}	
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
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Move point in vectorforprofile because of tolerance" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="3/6/2024 11:36:19 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Do the check for intersection of the cuttingbody vectors with the beam after getting the correct vectors." />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="6/2/2022 2:16:05 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Change vec tolerance for small angled beamcuts. And change the origin of the check for the free vectors, from the quader.ptorg to the resultingbody ptorg." />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="3/15/2022 3:07:51 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Not use analysedBeamcut to check free direction" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="2/17/2022 2:06:49 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End