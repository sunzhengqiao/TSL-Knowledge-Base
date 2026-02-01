#Version 8
#BeginDescription
version value="1.3" date="03feb21" author="marsel.nakuci@hsbcad.com"

HSB-10480: fix when walls are not horizontal/vertical
HSB-10136: inner and outer side of dimension is related to the inner or outer side of the element 
HSB-10136: add shrink at summation of planeprofiles to avoid bugs, add property to switch inner and aouter dimension
HSB-9291: initial


Select walls at the first corner, select walls at second corner,
Insert properties or catalog entry and press OK
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords Handlos,dimension,diagonal,logwall
#BeginContents
/// <History>//region
/// <version value="1.3" date="03feb21" author="marsel.nakuci@hsbcad.com"> HSB-10480: fix when walls are not horizontal/vertical </version>
/// <version value="1.2" date="04jan21" author="marsel.nakuci@hsbcad.com"> HSB-10136: inner and outer side of dimension is related to the inner or outer side of the element </version>
/// <version value="1.1" date="21dec20" author="marsel.nakuci@hsbcad.com"> HSB-10136: add shrink at summation of planeprofiles to avoid bugs, add property to switch inner and aouter dimension </version>
/// <version value="1.0" date="16nov20" author="marsel.nakuci@hsbcad.com"> HSB-9291: initial </version>
/// </History>

/// <insert Lang=en>
/// Select walls at the first corner, select walls at second corner
/// insert properties or catalog entry and press OK
/// For each corner the tsl will consider the intersecting couple of walls that are the farest from the other corner
/// </insert>

/// <summary Lang=en>
/// This tsl creates Dimension lines in plan view at collection of walls.
/// The user selects the walls of that define the first corner then the walls that define the second corner.
/// From all planeprofiles from intersection of couple walls the TSL will consider the planeprofile that is the farest from each corner
/// The 2 planeprofiles from wall couples from each corner will be used for the definition of the dimension line
/// User can switch between an inner or outer dimension. This is refered to the (inner, outer) side of the 2 walls that define the corener
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbFloorDiagonalDimension")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Swap dimension side|") (_TM "|Select hsbFloorDiagonalDimension TSL|"))) TSLCONTENT
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
	
//region properties
	// dim styles
	String sDimStyleName=T("|DimStyle|");	
	PropString sDimStyle(nStringIndex++, _DimStyles, sDimStyleName);
	sDimStyle.setDescription(T("|Defines the DimStyles|"));
	sDimStyle.setCategory(category);
	//
	String sDimensionName=T("|Dimension|");	
	String sDimensions[] ={ T("|Inner|"), T("|Outer|")};
	PropString sDimension(nStringIndex++, sDimensions, sDimensionName);	
	sDimension.setDescription(T("|Defines the Dimension|"));
	sDimension.setCategory(category);
//End properties//endregion 
	
//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount() > 1) { eraseInstance(); return; }
	// silent/dialog
		if (_kExecuteKey.length() > 0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			if (sEntries.findNoCase(_kExecuteKey ,- 1) >- 1)
				setPropValuesFromCatalog(_kExecuteKey);
			else
				setPropValuesFromCatalog(sLastInserted);
		}
	// standard dialog
		else
			showDialog();
		// prompt selection of the corners
		Entity entsWallCorner[0];
		
		Entity ents[0];
		PrEntity ssE(T("|Select walls of first corner|"), ElementWall());
//		PrEntity ssE(T("|Select first corner log walls or stick frame walls|"), ElementLog());
//		ssE.addAllowedClass(ElementWallSF());
		if (ssE.go())
			ents.append(ssE.set());
		
		_Entity.append(ents);
		_Map.setInt("NrWall1", ents.length());
		entsWallCorner.append(ents);
		
		Entity ents1[0];
		PrEntity ssE1(T("|Select walls of second corner|"), ElementWall());
//		PrEntity ssE1(T("|Select second corner log walls or stick frame walls|"), ElementLog());
//		ssE1.addAllowedClass(ElementWallSF());
		if (ssE1.go())
			ents1.append(ssE1.set());
		
		_Entity.append(ents1);
		_Map.setInt("NrWall2", ents1.length());
		entsWallCorner.append(ents1);
		// save wall references in _Map, in _Entity the duplicated enetities will be cleaned out
		_Map.setEntityArray(entsWallCorner, false, "entsWallCorner", "entsWallCorner", "entsWallCorner");
		return;
	}
// end on insert	__________________//endregion

ElementLog eLogs1[0];
ElementWall eWalls1[0];
ElementWallSF eSf1[0];
int iNrWall1 = _Map.getInt("NrWall1");

ElementLog eLogs2[0];
ElementWall eWalls2[0];
ElementWallSF eSf2[0];
int iNrWall2 = _Map.getInt("NrWall2");

Entity entsWallCorner[] = _Map.getEntityArray("entsWallCorner", "entsWallCorner", "entsWallCorner");
if (entsWallCorner.length() == 0)
{
	entsWallCorner.append(_Entity);
	_Map.setEntityArray(entsWallCorner, false, "entsWallCorner", "entsWallCorner", "entsWallCorner");
}
if(entsWallCorner.length()!=(iNrWall1+iNrWall2))
{ 
	reportMessage(TN("|unexpected|"));
	eraseInstance();
	return;
}
for (int i = 0; i < iNrWall1; i++)
{ 
	ElementLog eLog = (ElementLog)entsWallCorner[i];
	if (eLog.bIsValid())eLogs1.append(eLog);
	ElementWallSF eSf = (ElementWallSF)entsWallCorner[i];
	if (eSf.bIsValid())eSf1.append(eSf);
	ElementWall eWall = (ElementWall)entsWallCorner[i];
	if (eWall.bIsValid())eWalls1.append(eWall);
}//next i

for (int i = iNrWall1; i < (iNrWall1 + iNrWall2); i++)
{ 
	ElementLog eLog = (ElementLog)entsWallCorner[i];
	if (eLog.bIsValid())eLogs2.append(eLog);
	ElementWallSF eSf = (ElementWallSF)entsWallCorner[i];
	if (eSf.bIsValid())eSf2.append(eSf);
	ElementWall eWall = (ElementWall)entsWallCorner[i];
	if (eWall.bIsValid())eWalls2.append(eWall);
}//next i

if (eWalls1.length() < 2 || eWalls2.length() < 2)
{ 
	reportMessage(TN("|at least 2 walls needed for a corner connection|"));
	eraseInstance();
	return;
}

// take eWalls1[0] as a reference wall
Point3d ptOrg = eWalls1[0].ptOrg();
Vector3d vecX = eWalls1[0].vecX();
Vector3d vecY = eWalls1[0].vecY();
Vector3d vecZ = eWalls1[0].vecZ();

// Trigger Swap dimension side//region
	String sTriggerSwapDimensionSide = T("|Swap dimension side|");
	addRecalcTrigger(_kContextRoot, sTriggerSwapDimensionSide );
	if (_bOnRecalc && (_kExecuteKey==sTriggerSwapDimensionSide || _kExecuteKey==sDoubleClick))
	{
		if(sDimensions.find(sDimension)==0)
			sDimension.set(sDimensions[1]);
		else
			sDimension.set(sDimensions[0]);
		setExecutionLoops(2);
		return;
	}//endregion	

// for first corner get the intersecting planeprofile of all walls
PlaneProfile pp1(Plane(eWalls1[0].ptOrg(), eWalls1[0].vecY()));
Plane pn0(eWalls1[0].ptOrg(), eWalls1[0].vecY());
// intersections of planprofiles for walls at corner 1
PlaneProfile pps1[0];
// for each planeprofile save the wall couple
ElementWall eWallCouples1[0];
int iCoupleIds1[0];
// intersections of planprofiles for walls at corner 2
PlaneProfile pps2[0];
ElementWall eWallCouples2[0];
int iCoupleIds2[0];
//
for (int iCorner = 0; iCorner < 2; iCorner++)
{ 
	int iCoupleIds[0];
	ElementWall eWallCorner[0];
	if (iCorner == 0)eWallCorner.append(eWalls1);
	else eWallCorner.append(eWalls2);
	// 
	for (int i=0;i<eWallCorner.length();i++) 
	{ 
		Body bd = eWallCorner[i].realBody();
//		bd.vis(1);
//		eWallCorner[i].plEnvelope().vis(2);
//		eWallCorner[i].plOutlineWall().vis(1);
		
		PlaneProfile ppI(pn0);
		
		GenBeam gbsI[] = eWallCorner[i].genBeam();
		for (int ii = 0; ii < gbsI.length(); ii++)
		{ 
			ppI.unionWith(gbsI[ii].envelopeBody().shadowProfile(pn0));
			// HSB-10136:
			ppI.shrink(-U(10));
			ppI.shrink(U(10));
//			gbsI[ii].envelopeBody().vis(1);
		}//next j
		
		for (int j=0;j<eWallCorner.length();j++) 
		{ 
			if (i == j)continue;
			int iThisId = 1000 * i + j;
			int iCheckId = 1000 * j + i;
			if(iCoupleIds.find(iCheckId)>-1)
				continue
			PlaneProfile ppJ(pn0);
			GenBeam gbsJ[] = eWallCorner[j].genBeam();
			for (int jj=0;jj<gbsJ.length();jj++) 
			{ 
				ppJ.unionWith(gbsJ[jj].envelopeBody().shadowProfile(pn0));
				// HSB-10136:
				ppJ.shrink(-U(10));
				ppJ.shrink(U(10));
			}//next jj
			
			PlaneProfile _ppI = ppI;
			if(_ppI.intersectWith(ppJ))
			{ 
				ppI.intersectWith(ppJ);
				if (iCorner == 0)
				{
					pps1.append(ppI);
					eWallCouples1.append(eWallCorner[i]);
					eWallCouples1.append(eWallCorner[j]);
				}
				else
				{ 
					pps2.append(ppI);
					eWallCouples2.append(eWallCorner[i]);
					eWallCouples2.append(eWallCorner[j]);
				}
				iCoupleIds.append(1000 * i + j);
			}
		}//next j
	}//next i
	if (iCorner == 0)iCoupleIds1.append(iCoupleIds);
	else iCoupleIds2.append(iCoupleIds);
}//next iCorner

// calculate mid point of 1st corner
Point3d ptMid1;
Point3d ptMid2;
for (int iCorner = 0; iCorner < 2; iCorner++)
{ 
	Point3d ptMid;
	double dAreaTot = 0;
	PlaneProfile ppsCorner[0];
	if (iCorner == 0)ppsCorner.append(pps1);
	else ppsCorner.append(pps2);
	
	for (int i = 0; i < ppsCorner.length(); i++)
	{ 
	// get extents of profile
		LineSeg seg = ppsCorner[i].extentInDir(vecX);
		ptMid += seg.ptMid() * ppsCorner[i].area();
//		ppsCorner[i].transformBy(_XW*U(100));
		ppsCorner[i].vis(1);
		dAreaTot += ppsCorner[i].area();
	//	double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
	//	double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
	}//next i
	if(dAreaTot<pow(dEps,2))
	{ 
		reportMessage(TN("|unexpected error, no intersection for corner|")+" "+iCorner+1);
		eraseInstance();
		return;
	}
	ptMid = ptMid / dAreaTot;
	if (iCorner == 0)ptMid1 = ptMid;
	else ptMid2 = ptMid;
}//next iCorner

ptMid1.vis(1);
ptMid2.vis(1);
if((ptMid1-ptMid2).length()<dEps)
{ 
	reportMessage(TN("|same elements selected for corner 1 and corner 2|"));
	reportMessage(TN("|Instance will be deleted|"));
	eraseInstance();
	return;
}

// get the final planeprofiles 
PlaneProfile ppCorner1, ppCorner2;
// internal point of 1st and 2nd corner
Point3d ptInside1, ptInside2;

for (int iCorner = 0; iCorner < 2; iCorner++)
{ 
	// to get the farest planeprofile for each corner
	double dDistanceMax = dEps;
	
	PlaneProfile ppsCorner[0];
	Point3d ptMidNext;
	ElementWall eWallsCorner[0];
	if (iCorner == 0)
	{
		ppsCorner.append(pps1);
		ptMidNext = ptMid2;
		eWallsCorner.append(eWallCouples1);
	}
	else 
	{
		ppsCorner.append(pps2);
		ptMidNext = ptMid1;
		eWallsCorner.append(eWallCouples2);
	}
	
	for (int i=0;i<ppsCorner.length();i++) 
	{ 
	// get extents of profile
		Point3d ptInside, ptOutside;
		
		PLine pls[] = ppsCorner[i].allRings(true, false);
		PLine pl = pls[0];
		Point3d pts[] = pl.vertexPoints(false);
		ptInside = pts[0];
		ptOutside = pts[0];
		Vector3d vec1Inside, vec2Inside;
		vec1Inside = eWallsCorner[i * 2].vecZ();
		vec2Inside = eWallsCorner[i * 2 + 1].vecZ();
		double dMaxInside, dMaxOutside;
		dMaxInside = vec1Inside.dotProduct(pts[0]) + vec2Inside.dotProduct(pts[0]);
		dMaxOutside = vec1Inside.dotProduct(pts[0]) + vec2Inside.dotProduct(pts[0]);
		// HSB-10480:
		for (int iP=0;iP<pts.length();iP++) 
		{ 
			if(vec1Inside.dotProduct(pts[iP])+vec2Inside.dotProduct(pts[iP])<dMaxInside)
			{ 
				// point closer to inside side
				ptInside = pts[iP];
				dMaxInside = vec1Inside.dotProduct(pts[iP]) + vec2Inside.dotProduct(pts[iP]);
			}
			if(vec1Inside.dotProduct(pts[iP])+vec2Inside.dotProduct(pts[iP])>dMaxOutside)
			{ 
				// point closer to outside side
				ptOutside = pts[iP];
				dMaxOutside = vec1Inside.dotProduct(pts[iP]) + vec2Inside.dotProduct(pts[iP]);
			}
		}//next iP
		ptInside.vis(4);
		ptOutside.vis(4);

//		// distance for inside point
		double dDistanceMaxInsideI = (ptInside - ptMidNext).length();

//		// outside point
		// distance for outside point
		double dDistanceMaxOutsideI = (ptOutside - ptMidNext).length();
//		
		if(sDimensions.find(sDimension)==0)
		{ 
			// inner
			if(dDistanceMaxInsideI>dDistanceMax)
			{ 
				if(iCorner==0)
				{ 
					ppCorner1 = ppsCorner[i];
					dDistanceMax = dDistanceMaxInsideI;
					ptInside1 = ptInside;
				}
				else
				{ 
					ppCorner2 = ppsCorner[i];
					dDistanceMax = dDistanceMaxInsideI;
					ptInside2 = ptInside;
				}
			}
		}
		else
		{ 
			// outer
			if(dDistanceMaxOutsideI>dDistanceMax)
			{ 
				if(iCorner==0)
				{ 
					ppCorner1 = ppsCorner[i];
					dDistanceMax = dDistanceMaxOutsideI;
					ptInside1 = ptOutside;
				}
				else
				{ 
					ppCorner2 = ppsCorner[i];
					dDistanceMax = dDistanceMaxOutsideI;
					ptInside2 = ptOutside;
				}
			}
		}
	}//next i
}//next iCorner

ptInside1.vis(5);
ptInside2.vis(5);

// draw dimension
Vector3d vecXdim = ptInside1 - ptInside2;
vecXdim.normalize();
if (vecXdim.dotProduct(_XW) < 0)vecXdim *= -1;

Vector3d vecYdim = vecY.crossProduct(vecXdim);
if(_bOnDbCreated)
	_Pt0 = .5 * (ptInside1 + ptInside2);
_Pt0.vis(6);
Display dp(7);
dp.dimStyle(sDimStyle);
DimLine dl(_Pt0, vecXdim, vecYdim);

Dim dim(dl, ptInside1, ptInside2 );
dp.draw(dim);

//int zz;
#End
#BeginThumbnail





#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="0.001" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="366" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-10480: fix when walls are not horizontal/vertical" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="2/3/2021 2:31:05 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="meter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End