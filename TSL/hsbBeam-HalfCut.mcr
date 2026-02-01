#Version 8
#BeginDescription
version value="1.8" date="14.may.2019" author="marsel.nakuci@hsbcad.com"
if beam is transformed, move the TSL with it without any check
remove width from the properties
neglect transformation operations copy, mirror, etc that move the TSL from its plane
change description
support mirror
add grip point for depth, points always projected to the plane in _ZU
change name+copy and mirror functionality
initial

select properties or catalog entry and press OK
Select Beam and enter, pick first point on beam, pick second point on beam

This tsl creates beamcut at a face of a beam
The HulfCut will be created at the face of the beam that has its normal 
vector most aligned with the _ZU vector Z of UCS
First point and second point define the length of the halfCut
Depth, width and andgle are entered through the properties
agle of rotation is refered to the line between 2 points of halfCut
the 2 points can be moved after the tsl has been inserted but they will remain at the 
/same plane
The depth can also be changed by draging the grip point that defines the depth
Direction of depth will not be changed
Angle of direction can only be influenced by the properties by changing the angle
TSL can be copied, mirrored or rotated
This should always be done so that the TSL remains at the same plane
As reference for the segment between 2 points of the cut 
user can select middle, left or right
middle - segment is at middle of thicknes of saw cut
left - segment is at left side of thicknes of saw cut
right - segment is at right side of thicknes of saw cut
this selection also influences the depth of the cut
depth is referenced to the side selected
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 8
#KeyWords stab; halfcut; saw
#BeginContents
/// <History>//region
/// <version value="1.8" date="14.may.2019" author="marsel.nakuci@hsbcad.com"> if beam is transformed, move the TSL with it without any check </version>
/// <version value="1.7" date="14.may.2019" author="marsel.nakuci@hsbcad.com"> remove width from the properties </version>
/// <version value="1.6" date="01.may.2019" author="marsel.nakuci@hsbcad.com"> neglect transformation operations copy, mirror, etc that move the TSL from its plane </version>
/// <version value="1.5" date="24.apr.2019" author="marsel.nakuci@hsbcad.com"> change description </version>
/// <version value="1.4" date="09.apr.2019" author="marsel.nakuci@hsbcad.com"> support mirror </version>
/// <version value="1.3" date="09.apr.2019" author="marsel.nakuci@hsbcad.com"> set version </version>
/// <version value="1.2" date="08.apr.2019" author="marsel.nakuci@hsbcad.com"> add grip point for depth, points always projected to the plane in _ZU </version>
/// <version value="1.1" date="04.apr.2019" author="marsel.nakuci@hsbcad.com"> change name+copy and mirror functionality </version>
/// <version value="1.0" date="23.mar.2019" author="marsel.nakuci@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// select properties or catalog entry and press OK
/// Select Beam and enter, pick first point on beam, pick second point on beam
/// </insert>

/// <summary Lang=en>
/// This tsl creates beamcut at a face of a beam
/// The HulfCut will be created at the face of the beam that has its normal 
/// vector most aligned with the _ZU vector Z of UCS
/// First point and second point define the length of the halfCut
/// Depth, width and andgle are entered through the properties
/// agle of rotation is refered to the line between 2 points of halfCut
/// the 2 points can be moved after the tsl has been inserted but they will remain at the 
/// same plane
/// The depth can also be changed by draging the grip point that defines the depth
/// Direction of depth will not be changed
/// Angle of direction can only be influenced by the properties by changing the angle
/// TSL can be copied, mirrored or rotated
/// This should always be done so that the TSL remains at the same plane
/// As reference for the segment between 2 points of the cut 
/// user can select middle, left or right
/// middle - segment is at middle of thicknes of saw cut
/// left - segment is at left side of thicknes of saw cut
/// right - segment is at right side of thicknes of saw cut
/// this selection also influences the depth of the cut
/// depth is referenced to the side selected

/// </summary>

/// commands
// command to insert a G-connection
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbBeam-HalfCut")) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|"))) TSLCONTENT
//endregion

//region constants 
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
	String category = T("|Cut|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
//end constants//endregion

//region properties

	// depth of cut
	String sDepthCutName=T("|Depth|");	
	PropDouble dDepthCut(nDoubleIndex++, U(70), sDepthCutName);	
	dDepthCut.setDescription(T("|Defines the cut Depth|"));
	dDepthCut.setCategory(category);
	// width of cut
//	String sWidthCutName=T("|Width|");	
//	PropDouble dWidthCut(nDoubleIndex++, U(6), sWidthCutName);	
//	dWidthCut.setDescription(T("|Defines the cut width|"));
//	dWidthCut.setCategory(category);
//	dWidthCut.setReadOnly(true);
	double dWidthCut = U(6);
	// angle of the cut
	String sAngleCutName=T("|Angle|");	
	PropDouble dAngleCut(nDoubleIndex++, U(0), sAngleCutName);	
	dAngleCut.setDescription(T("|Defines the cut angle|"));
	dAngleCut.setCategory(category);
	
	String sSideOfCuts[] ={ "middle", "left", "right"};
	String sSideOfCutName=T("|Side|");	
	PropString sSideOfCut(nStringIndex++, sSideOfCuts, sSideOfCutName);	
	sSideOfCut.setDescription(T("|Defines the side Of Cut|"));
	sSideOfCut.setCategory(category);

//End properties//endregion 

// bOnInsert//region
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
				setPropValuesFromCatalog(sLastInserted);
		}
		else
			showDialog();
		
		Beam bm = getBeam(TN("|Select the Beam|"));
		
		if(!bm.bIsValid())
		{ 
			// 
			reportMessage(TN("|select first a beam|"));
			eraseInstance();
			return;
		}
		
		Point3d pt1 = getPoint(TN("|Select first point|"));
		Point3d pt2 = getPoint(TN("|Select second point|"));
		Point3d ptMid = .5 * (pt1 + pt2);
		
		// find the index ofclosest plane to pt1
		// find the face of beam closer to the first point
		Vector3d vecX = bm.vecX();  
		Vector3d vecY = bm.vecY();	
		Vector3d vecZ = bm.vecZ();	
		Point3d ptCen = bm.ptCen();
		
		Body bodyBm = bm.envelopeBody(true, false);
		Plane pnX(ptCen, vecX);
		PlaneProfile ppBeamSec = bodyBm.shadowProfile(pnX);
		ppBeamSec.vis(2);
		double dLength = bm.solidLength();
	// get extents of profile
		LineSeg seg = ppBeamSec.extentInDir(vecY);
		double dWidth = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
		double dHeight = abs(vecZ.dotProduct(seg.ptStart()-seg.ptEnd()));
		
	// 6 planes of the beam
		Plane planes[0];
		Vector3d vecs[0];
		Point3d pts[0];
		
		Point3d pt = ptCen + .5 * dLength * vecX;
		Plane pnXPlus(pt, vecX);
		planes.append(pnXPlus);
		vecs.append(vecX);
		pts.append(pt);
		
		pt = ptCen - .5 * dLength * vecX;
		Plane pnXMinus(pt, vecX);
		planes.append(pnXMinus);
		vecs.append(-vecX);
		pts.append(pt);
		
		pt = ptCen + .5 * dWidth * vecY;
		Plane pnYPlus(pt, vecY);
		planes.append(pnYPlus);
		vecs.append(vecY);
		pts.append(pt);
		
		pt = ptCen - .5 * dWidth * vecY;
		Plane pnYMinus(pt, vecY);
		planes.append(pnYMinus);
		vecs.append(-vecY);
		pts.append(pt);
		
		pt = ptCen + .5 * dHeight * vecZ;
		Plane pnZPlus(pt, vecZ);
		planes.append(pnZPlus);
		vecs.append(vecZ);
		pts.append(pt);
		
		pt = ptCen - .5 * dHeight * vecZ;
		Plane pnZMinus(pt, vecZ);
		planes.append(pnZMinus);
		vecs.append(-vecZ);
		pts.append(pt);
		
	// create a quader
		Quader quader(ptCen, vecX, vecY, vecZ);
	// find the vector most aligned with the _ZU
		Vector3d vecAligned = quader.vecD(_ZU);
		
	// find the plane
		int iPlaneCloseIndex = vecs.find(vecAligned);
		if(iPlaneCloseIndex<0)
		{ 
			reportMessage(TN("|unexpected error|"));
			eraseInstance();
			return;
		}
		
		// create TSL
			TslInst tslNew;				Vector3d vecXTsl= _XU;			Vector3d vecYTsl= _YU;
			GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[0];
			int nProps[]={};			double dProps[]={};				String sProps[]={};
			Map mapTsl;	
			Plane pnSelected = planes[iPlaneCloseIndex];
			gbsTsl.append(bm);
			ptsTsl.append(pnSelected.closestPointTo(ptMid));// will be stored to _Pt0
			ptsTsl.append(pnSelected.closestPointTo(pt1));// will be stored to _PtG[0]
			ptsTsl.append(pnSelected.closestPointTo(pt2));// will be stored to _PtG[1]
			
			dProps.append(dDepthCut);
//			dProps.append(dWidthCut);
			dProps.append(dAngleCut);
			sProps.append(sSideOfCut);
			
			mapTsl.setInt("iPlaneCloseIndex", iPlaneCloseIndex);
//			mapTsl.setVector3d("vecCut", vecs[iPlaneCloseIndex]);
//			mapTsl.setPoint3d("ptCut", pts[iPlaneCloseIndex]);
			
			tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			
		
		eraseInstance();
		return;
	}	
// end on insert	__________________//endregion

//region TSL is mitkopiert when the beam is copied
		
// The TSL can be copied, 
	setEraseAndCopyWithBeams(_kBeam0);

//End TSL is mitkopiert when the beam is copied//endregion 

//region error handling

	if(_Beam.length()<1)
	{ 
		reportMessage(TN("|no beam selected|"));
		eraseInstance();
		return;
	}	

//End error handling//endregion 

// do the calculation

//region angles >80° not allowed
		
	if (_kNameLastChangedProp == sAngleCutName)
	{ 
		if(abs(dAngleCut)>80)
		{ 
			dAngleCut.set(80.0);
			reportMessage(TN("|angles larger then (+-)80 degrees not accepted|"));
		}
	}

//End angles >80° not allowed//endregion 

//region standards
	
	Beam bm = _Beam[0];
	
	_PtG[0].vis(1);
	_PtG[1].vis(1);
	
	// find the face of beam closer to the first point
	Vector3d vecX = bm.vecX();
	Vector3d vecY = bm.vecY();
	Vector3d vecZ = bm.vecZ();
	Point3d ptCen = bm.ptCen();	
	
//End standards//endregion 
	
//region 6 vectors and extreme points of the beam

	Body bodyBm = bm.envelopeBody(true, false);
	Plane pnX(ptCen, vecX);
	PlaneProfile ppBeamSec = bodyBm.shadowProfile(pnX);
	ppBeamSec.vis(2);
	double dLength = bm.solidLength();
// get extents of profile
	LineSeg seg = ppBeamSec.extentInDir(vecY);
	double dWidth = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
	double dHeight = abs(vecZ.dotProduct(seg.ptStart()-seg.ptEnd()));
// index of the closest plane
	int iPlaneCloseIndex = _Map.getInt("iPlaneCloseIndex");
	Vector3d vecs[0];
	vecs.append(vecX);
	vecs.append(-vecX);
	vecs.append(vecY);
	vecs.append(-vecY);
	vecs.append(vecZ);
	vecs.append(-vecZ);
	
	Point3d points[0];
	points.append(ptCen + .5 * dLength * vecX);
	points.append(ptCen - .5 * dLength * vecX);
	points.append(ptCen + .5 * dWidth * vecY);
	points.append(ptCen - .5 * dWidth * vecY);
	points.append(ptCen + .5 * dHeight * vecZ);
	points.append(ptCen - .5 * dHeight * vecZ);
	
//End 6 vectors and extreme points of the beam//endregion 

//region check geometry and properties when mirror or copy 
	// check if angle and length corresponds to the geometry 
	// if this geometry is not done frome changing grip points or properties
	// this can happen when a copy or mirror is done
	// in that case we accept the geometry and will update the properties so they correspond to the geometry

	if(!(_kNameLastChangedProp=="_Pt0" || _kNameLastChangedProp=="_PtG0" || _kNameLastChangedProp=="_PtG1" || _kNameLastChangedProp=="_PtG2"
	   || _kNameLastChangedProp==sDepthCutName || _kNameLastChangedProp==sAngleCutName || _kNameLastChangedProp==sSideOfCutName || _bOnDbCreated))
	{ 
		if(bDebug)reportMessage("\n"+ scriptName() + " enters...");
		
		Point3d ptCenExist = _Map.getPoint3d("ptCenStatic");
		// see if beam is transformed 
		if(!abs((ptCenExist-ptCen).length())>dEps)
		{ 
			// beam is not moved, only tsl
			// check if the operation leaves the TSL in the same plane
			
			Vector3d vecCutExist = _Map.getPoint3d("vecCut");// stayes constant, not changed after transformation operation
			Point3d ptg0Exist = _Map.getPoint3d("ptg0");
			Point3d ptg1Exist = _Map.getPoint3d("ptg1");
			
			Plane pn(ptg0Exist, vecCutExist);
			Point3d ptPlane = pn.closestPointTo(_PtG[0]);
			double d = (ptPlane - _PtG[0]).length();
			ptPlane = pn.closestPointTo(_PtG[1]);
			double d2 = (ptPlane - _PtG[1]).length();
			if(d>dEps || d2>dEps)
			{ 
			// from move or copy
				if(bDebug)reportMessage("\n"+ scriptName() + " not allowed1");
				if(bDebug)reportMessage("\n"+ scriptName() + " d= "+d);
				if(bDebug)reportMessage("\n"+ scriptName() + " d2= "+d2);
				
				reportMessage(TN("|not possible|"));
				reportMessage(TN("|transformation operations like copy, move, mirror, rotate|"));
				reportMessage(TN("|must only be performed so that the cut remains at the same plane|"));
				reportMessage(TN("|where it is defined|"));
				eraseInstance();
				return;
			}
			
			Vector3d vecCutVecExist = _Map.getVector3d("vecCutVec");// is modified by transformBy
			if(abs(vecCutExist.dotProduct(vecCutVecExist)-1.0)>dEps)
			{ 
				if(bDebug)reportMessage("\n"+ scriptName() + " not allowed2");
				if(bDebug)reportMessage("\n"+ scriptName() + "vecCutExist.dotProduct(vecCutVecExist): "+vecCutExist.dotProduct(vecCutVecExist));
				
				reportMessage(TN("|not possible|"));
				reportMessage(TN("|transformation operations like copy, move, mirror, rotate|"));
				reportMessage(TN("|must only be performed so that the cut remains at the same plane|"));
				reportMessage(TN("|where it is defined|"));
				eraseInstance();
				return;
			}
		}
		
	// check properties and geometry
		dDepthCut.set((_PtG[2] - _Pt0).length());// set depth
	// set angle
	// in a mirror operation angle will be changed
		Vector3d vecXCut = _PtG[1] - _PtG[0];
		vecXCut.normalize();
		Vector3d vec02 = _PtG[2] - _Pt0;
		vec02.normalize();// vector of cut depth
	// cross product -vecCut with vec02
		Vector3d vecCut = vecs[iPlaneCloseIndex];
		int vecOrientation = _Map.getInt("vecOrientation");
		if (vecOrientation)vecCut *= -1;
		Vector3d vecCutPtg = _Pt0 - _PtG[2];
		vecCutPtg.normalize();
		if(vecCut.dotProduct(vecCutPtg)<0)
		{ 
			if(bDebug)reportMessage("\n"+ scriptName() + " inconsistency");
			vecCut *= -1;
			vecOrientation =! vecOrientation;
			_Map.setInt("vecOrientation", vecOrientation);
		}
		Vector3d vCross = (-vecCut).crossProduct(vec02);
	//	set angle
		double dAngle = asin(vCross.length());
		if(vCross.dotProduct(vecXCut)<0)
		{ 
			dAngle *= -1;
		}
		dAngleCut.set(dAngle);// set angle
		
	// check vecSide
		Vector3d vecSideGeo = vecXCut.crossProduct(vecCut);
		Vector3d vecSide = _Map.getVector3d("vecSide");
		int iSide=_Map.setInt("intSide", 1);
		if(iSide==0)
		{ 
		// middle
			sSideOfCut.set(sSideOfCuts[0]);
		}
		else 
		{ 
		// left of right
			if(vecSideGeo.dotProduct(vecSide)>0)
			{ 
			// left
				sSideOfCut.set(sSideOfCuts[1]);
			}
			else if(vecSideGeo.dotProduct(vecSide)<0)
			{ 
			// right
				sSideOfCut.set(sSideOfCuts[2]);	
			}
		}
		
		if (bDebug)reportMessage("\n" + scriptName() + "vecOrientation " + vecOrientation);
	}	
//End check geometry and properties//endregion 

// Trigger direction of cut depth//region
	String sTriggerPlaneVector = T("|change direction of cut depth|");
	addRecalcTrigger(_kContext, sTriggerPlaneVector );
	if (_bOnRecalc && (_kExecuteKey==sTriggerPlaneVector || _kExecuteKey==sDoubleClick))
	{
	// flip it
		int vecOrientation = _Map.getInt("vecOrientation");
		vecOrientation =! vecOrientation;
		_Map.setInt("vecOrientation", vecOrientation);
		
	// change also orientation of ptg
		Vector3d vec02 = _PtG[2] - _Pt0;
		_PtG[2] = _PtG[2] - 2 * vec02;
		
		setExecutionLoops(2);
		return;
	}//endregion	

//region some data

	int vecOrientation = _Map.getInt("vecOrientation");
	
	Point3d ptCut = points[iPlaneCloseIndex];
	Vector3d vecCut = vecs[iPlaneCloseIndex];
	if (vecOrientation)vecCut *= -1;
	
	Plane pnClose(ptCut, vecCut);
	vecCut.vis(ptCut, 1);
	ptCut.vis(2);

//End some data//endregion 

//region Properties changed
	if(_kNameLastChangedProp=="_Pt0")
	{ 
		// displace the whole cut
		_Pt0 = pnClose.closestPointTo(_Pt0);
	}
	else if (_kNameLastChangedProp=="_PtG0" || _kNameLastChangedProp=="_PtG1")
	{ 
		// change start and end of Cut
		_PtG[0] = pnClose.closestPointTo(_PtG[0]);
		_PtG[1] = pnClose.closestPointTo(_PtG[1]);
		_Pt0 = .5 * (_PtG[1] + _PtG[0]);
		Vector3d vecXCut = _PtG[1] - _PtG[0];
		vecXCut.normalize();
		Vector3d vecYCut = vecXCut.crossProduct(-vecCut);
		Vector3d vecZCut = vecXCut.crossProduct(vecYCut);
	// rotate
		vecYCut = vecYCut.rotateBy(dAngleCut, vecXCut);
		vecZCut = vecZCut.rotateBy(dAngleCut, vecXCut);	
		
		_PtG[2] = _Pt0 - vecZCut * dDepthCut;
	}

// vector of cut direction
	Vector3d vecXCut = _PtG[1] - _PtG[0];
	vecXCut.normalize();
	Vector3d vecYCut = vecXCut.crossProduct(-vecCut);// width of cut, vector in plane
	Vector3d vecZCut = vecXCut.crossProduct(vecYCut);// depth of cut
	
// rotate y and z with the angle
	vecYCut = vecYCut.rotateBy(dAngleCut, vecXCut);
	vecZCut = vecZCut.rotateBy(dAngleCut, vecXCut);	
	if(_PtG.length()<3)
	{ 
		_PtG.append(_Pt0 - vecZCut * dDepthCut);
	}
	if(_kNameLastChangedProp=="_PtG2")
	{ 
		// depth of the cut
		Line ln(_Pt0, vecZCut);
//		Plane pn(_Pt0, vecXCut);
		_PtG[2] = ln.closestPointTo(_PtG[2]);
		dDepthCut.set((_PtG[2] - _Pt0).length());
		
		Vector3d vecCutPtg = _Pt0 - _PtG[2];
		vecCutPtg.normalize();
		if(vecCut.dotProduct(vecCutPtg)<0)
		{ 
			vecOrientation =! vecOrientation;
			_Map.setInt("vecOrientation", vecOrientation);
			setExecutionLoops(2);
		}
	}
	else if(_kNameLastChangedProp==sDepthCutName || _kNameLastChangedProp==sAngleCutName)
	{ 
		_PtG[2] = _Pt0 - vecZCut * dDepthCut;
	}
//End Properties changed//endregion 	

//region side middle, left, right

	double dLengthCut = (_PtG[1] - _PtG[0]).length();
	Point3d ptCenCut;
	// selection of the side, middle, left, right
	int iSideIndex = sSideOfCuts.find(sSideOfCut);
	if(iSideIndex==0)
	{ 
		// middle
		ptCenCut = _Pt0 - vecYCut * .5*dWidthCut;
	// set vector
		_Map.setInt("intSide", 0);
		
	}
	else if(iSideIndex==1)
	{ 
		//left
		ptCenCut = _Pt0;
	// set vector
		Vector3d vecSide = vecXCut.crossProduct(vecCut);
		_Map.setVector3d("vecSide", vecSide);
		_Map.setInt("intSide", 1);
	}
	else if(iSideIndex==2)
	{ 
		//right
		ptCenCut = _Pt0 - vecYCut * dWidthCut;
		Vector3d vecSide = vecCut.crossProduct(vecXCut);
		_Map.setVector3d("vecSide", vecSide);
		_Map.setInt("intSide", 1);
	}
//End side middle, left, right//endregion 

//region save ptg0, ptg1, vecCut
	// this information is needed if an operation mirror, rotation or copy is performed
	// if from this operation the TSL is not in the plane then it should not happen

	_Map.setPoint3d("vecCut", vecCut, _kAbsolute);
	_Map.setVector3d("vecCutVec", vecCut, _kAbsolute);
	_Map.setPoint3d("ptg0", _PtG[0], _kAbsolute);
	_Map.setPoint3d("ptg1", _PtG[1], _kAbsolute);
	// beam reference
	_Map.setPoint3d("ptCenStatic", ptCen, _kAbsolute);
		
//End save ptg0, ptg1, vecCut//endregion 

//region do the halfCut and display

//	ptCenCut.vis(2);
//	BeamCut bc(ptCenCut,vecXCut, vecYCut, vecZCut,
//				dLengthCut, dWidthCut, 2*dDepthCut );
//	bm.addTool(bc);
	Vector3d vecN = vecYCut;
	Vector3d vecYHalfCut = -vecZCut;
	Point3d ptOrg = ptCenCut - dDepthCut * vecZCut;
	ptOrg.vis(2);
	vecXCut.vis(ptOrg, 1);
	vecN.vis(ptOrg, 3);	
	vecYHalfCut.vis(ptOrg, 150);	
	
	HalfCut hc(ptOrg, vecN, vecYHalfCut, true);
	hc.setLength(dLengthCut);
	bm.addTool(hc);
	
// display
	Display dp(252);
	LineSeg lSeg(_PtG[0], _PtG[1]);
	dp.draw(lSeg);
	LineSeg lSeg2(_Pt0, _PtG[2]);
	dp.draw(lSeg2);		

//End do the halfCut and display//endregion 

#End
#BeginThumbnail
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
?O^[)_P"@FO7Z**];`_PCR\9_%"BBBNPY`HHHH`__V=T*
`










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