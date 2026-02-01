#Version 8
#BeginDescription
This tsl creates a double cut tool. The double cut is defined by 2 halfplanes, and cuts away the overlap of the 2 halfplanes. The tool can be placed anywhere on a Beam/Sheet/Panel/Sip/Clt.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
/// <History>//region
/// <version value="1.0" date="10Jun2020" initial </version>
/// <version value="1.2" date="18Dec2020" make it work for panels and sheet as well</version>
/// </History>

/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tool creates a double cut tool. The double cut is defined by 2 halfplanes, and cuts away the overlap of the 2 halfplanes. 
/// The tool can be placed anywhere on a Beam/Sheet/Panel/Sip/Clt.
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbDoubleCut")) TSLCONTENT
//endregion

//region Constants 
	U(1,"mm");	
	
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	double dDisplayRadius = U(25);
	double dInitializeDistance = U(25);
	
	int bInDebug = FALSE;
//end Constants//endregion

//region Properties
	
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	
	// This tsl gets inserted automatically through the console tools actions. Keep the default behaviour!
	PropString pIsEndTool(0, sNoYes, T("|Insert as end tool|"), 0);
	pIsEndTool.setDescription(T("|Inserting as end tool will remove all the end tools in that direction.|"));
	pIsEndTool.setCategory(category);
	int bIsEndTool= sNoYes.find(pIsEndTool);
	PropString pUseSecondPoint(1, sNoYes, T("|Use second point for direction|"), 0);
	pUseSecondPoint.setDescription(T("|The direction of the double cut is calculated most perpendicular to the part surface. But if a second point is set, the direction is through the second point.|"));
	pUseSecondPoint.setCategory(category);
	int bUseSecondPoint= sNoYes.find(pUseSecondPoint);

//End Properties//endregion 
	
//region OnInsert

	if (_bOnInsert)
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
			
		_GenBeam.append(getGenBeam());
		
		_Pt0 = getPoint(T("|Select apex location of double cut.|"));
		
		Point3d ptApex2;
		if (bUseSecondPoint)
		{
			PrPoint prS(T("|Select second apex point|"), _Pt0);
			if ( ! prS.go())
			{
				eraseInstance();
				return;
			}
			ptApex2 = prS.value();
		}
	
		
		PrPoint pr1(T("|Select point on first plane.|"), _Pt0); 
		PrPoint pr2(T("|Select point on second plane.|"), _Pt0); 
		if (!pr1.go() || !pr2.go())
		{ 
			eraseInstance();
			return;
		}
		
		_PtG.append(pr1.value());
		_PtG.append(pr2.value());
		if (bUseSecondPoint)
			_PtG.append(ptApex2);
		
		return;
	}

// OnInsert//endregion 


if (_GenBeam.length() == 0 || !_GenBeam[0].bIsValid())
{ 
	if (bInDebug) reportMessage("\nstate invalid: missing genbeam");
	eraseInstance();
	return;
}
GenBeam bm0 = _GenBeam[0];

//InitializeFrom happens from Console->tools->(of type hex) convert to double cut entity.
if (_Map.hasMap("InitializeFrom"))
{ 
	Map mp = _Map.getMap("InitializeFrom");
	_Map.removeAt("InitializeFrom", FALSE);
	
	Point3d ptCut1 = mp.getPoint3d("ptCut1");
	Vector3d vecCut1 = mp.getVector3d("vecCut1");
	Point3d ptCut2 = mp.getPoint3d("ptCut2");
	Vector3d vecCut2 = mp.getVector3d("vecCut2");
	
	Vector3d vecInter = vecCut1.crossProduct(vecCut2).normal();
	if (vecInter.bIsZeroLength())
	{ 
		_Pt0 = ptCut1 + 0.5 * (ptCut2-ptCut1);
		_PtG.setLength(0);
		_PtG.append(ptCut1);
		_PtG.append(ptCut2);
		pIsEndTool.set(sNoYes[0]);
		pUseSecondPoint.set(sNoYes[0]);
		if (bInDebug) reportMessage("\nInitializeFrom: zerolength");
	}
	else
	{
		Line lnInter = Plane(ptCut1, vecCut1).intersect(Plane(ptCut2, vecCut2));
		_Pt0 = lnInter.closestPointTo(ptCut1);
		_PtG.setLength(0);
		{
			Vector3d vecInPlane = vecInter.crossProduct(vecCut1).normal();
			if (vecInPlane.dotProduct(vecCut2) < 0)
				vecInPlane *= -1;
			Point3d ptInPlane = _Pt0 + dInitializeDistance * vecInPlane;
			_PtG.append(ptInPlane);
		}
		{
			Vector3d vecInPlane = vecInter.crossProduct(vecCut2).normal();
			if (vecInPlane.dotProduct(vecCut1) < 0)
				vecInPlane *= -1;
			Point3d ptInPlane = _Pt0 + dInitializeDistance * vecInPlane;
			_PtG.append(ptInPlane);
		}
		_PtG.append(_Pt0 + dInitializeDistance * vecInter); // second point on apex line
		
		pIsEndTool.set(sNoYes[0]); // No
		pUseSecondPoint.set(sNoYes[1]); // Yes
		
		if (bInDebug) reportMessage("\nInitializeFrom: set");
	}
	
	bIsEndTool= sNoYes.find(pIsEndTool);
	bUseSecondPoint= sNoYes.find(pUseSecondPoint);
}

if (_PtG.length() < 2)
{ 
	if (bInDebug) reportMessage("\nstate invalid: missing grips");
	eraseInstance();
	return;
}

setEraseAndCopyWithBeams(_kBeam0);
setKeepReferenceToGenBeamDuringCopy(_kBeam0);
assignToGroups(bm0, 'T');


Display dp(-1);

// what to do if the 3 points are coplanar => just add one cut
int bOneCut = FALSE;
Vector3d vecInPlane0 = _PtG[0] - _Pt0;
Vector3d vecInPlane1 = _PtG[1] - _Pt0;
if (vecInPlane0.crossProduct(vecInPlane1).bIsZeroLength())
{
	bOneCut = TRUE;
}
else if (bUseSecondPoint && _PtG.length() > 2)
{ 
	if (vecInPlane0.crossProduct(vecInPlane1).isPerpendicularTo(_PtG[2] - _Pt0))
		bOneCut = TRUE;
}

if (bOneCut)
{ 
	Vector3d vecFromPtCen = _Pt0 - bm0.ptCen();
	Vector3d vecBm = bm0.vecD(vecFromPtCen); // pointing in tool direction
		
	Vector3d vecInPlane = _PtG[1] - _PtG[0];
	if (vecInPlane.length() < vecInPlane0.length()) vecInPlane = vecInPlane0;
	if (vecInPlane.length() < vecInPlane1.length()) vecInPlane = vecInPlane1;
		
	Vector3d vecN(0,0,0); // normal of cut
	// if second point is specified, this has precedence
	if (bUseSecondPoint && _PtG.length() > 2 && !(_PtG[2]-_Pt0).bIsZeroLength())
	{ 
		vecN = vecInPlane.crossProduct(_PtG[2] - _Pt0);
	}
	if (vecN.bIsZeroLength()) // could not use second point, or crossproduct was 0 length
	{
		vecN = vecInPlane0.crossProduct(vecInPlane1);
	}
	if (vecN.bIsZeroLength()) // the 3 points are colinear
	{
		vecN = vecBm.crossProduct(vecInPlane).crossProduct(vecInPlane);
	}
	
	if (vecN.dotProduct(vecBm) < 0)
		vecN *= -1;
	if (vecN.bIsZeroLength())
		vecN = vecBm;
	Cut ct(_Pt0, vecN);
	bm0.addTool(ct, bIsEndTool);
	
	// display
	PLine pl;
	pl.createCircle(_Pt0, vecN, dDisplayRadius);
	dp.draw(pl);
	
	// correct grip count
	if (bUseSecondPoint && _PtG.length() < 3)
	{
		Vector3d vecOffset = vecInPlane.crossProduct(vecN).normal();
		_PtG.append(_Pt0 + dInitializeDistance * vecOffset);
	}
	else if (!bUseSecondPoint && _PtG.length() > 2)
		_PtG.removeAt(2);
		
	if (bInDebug) reportMessage("\ncalc: parallel planes");
	return;
}

// calculate the second point on the dividing line, and check if number of grips corresponds to property
Point3d ptSecond;
if (bUseSecondPoint && _PtG.length() > 2)
{ 
	ptSecond = _PtG[2];
}
else
{ 
	Vector3d vecTempLn = vecInPlane0.crossProduct(vecInPlane1).normal();
	Vector3d vecLn = bm0.vecD(vecTempLn);
	ptSecond = _Pt0 + 0.5 * dInitializeDistance * vecLn;
	
	vecLn *= 2;
	vecTempLn.vis(_Pt0);
	vecLn.vis(_Pt0,1);
	
	if (bUseSecondPoint &&  _PtG.length() < 3)
		_PtG.append(ptSecond);
	else if (!bUseSecondPoint && _PtG.length() > 2)
		_PtG.removeAt(2);
}

ptSecond.vis();

Vector3d vecLn = (_Pt0 - ptSecond).normal();

Vector3d vecN0, vecN1;
{
	Vector3d vecInPlane = _PtG[0] - _Pt0;
	Vector3d vecInPlaneOther = _PtG[1] - _Pt0;
	Vector3d vecN = vecLn.crossProduct(vecInPlane);
	if (vecN.dotProduct(vecInPlaneOther)<0)
		vecN *= -1;
	vecN.normalize();
	vecN0 = vecN;
}
{
	Vector3d vecInPlane = _PtG[1] - _Pt0;
	Vector3d vecInPlaneOther = _PtG[0] - _Pt0;
	Vector3d vecN = vecLn.crossProduct(vecInPlane);
	if (vecN.dotProduct(vecInPlaneOther)<0)
		vecN *= -1;
	vecN.normalize();
	vecN1 = vecN;
}

DoubleCut dc(_Pt0, vecN0, _Pt0, vecN1);
bm0.addTool(dc, bIsEndTool);

{
	Vector3d vecApex = vecN0.crossProduct(vecN1).normal();
	Point3d ptS = _Pt0 - dDisplayRadius * vecApex;
	Point3d ptE = _Pt0 + dDisplayRadius * vecApex;
	{
		PLine pl(vecN0);
		pl.addVertex(ptS);
		pl.addVertex(ptE, 1);
		dp.draw(pl);
	}
	{
		PLine pl(vecN1);
		pl.addVertex(ptE);
		pl.addVertex(ptS, 1);
		dp.draw(pl);
	}
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
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End