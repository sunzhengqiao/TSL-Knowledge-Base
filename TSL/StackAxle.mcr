#Version 8
#BeginDescription
This tsl creates and manages axle positions of a TruckDefinition
It can be inserted on a StackEntity Tsl

#Versions: 
Version 1.5 07/03/2025 HSB-23313: Consider if no existing grip when adding a grip , Author Marsel Nakuci
Version 1.4 07.02.2025 HSB-23313: Show weight in elevation , Author: Marsel Nakuci
Version 1.3 31.01.2025 HSB-23313: Fix when saving after "edit in place" , Author: Marsel Nakuci
Version 1.2 23.01.2025 HSB-23313: Use radio buttons for sve mode , Author: Marsel Nakuci
Version 1.1 17.01.2025 HSB-23313: Add toggle to differentiate between "Style based" and "Instance based" , Author: Marsel Nakuci

Version 1.0 10.01.2025 HSB-23313: Initial , Author: Marsel Nakuci





#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 5
#KeyWords 
#BeginContents
//region <History>
// #Versions
// 1.5 07/03/2025 HSB-23313: Consider if no existing grip when adding a grip , Author Marsel Nakuci
// 1.4 07.02.2025 HSB-23313: Show weight in elevation , Author: Marsel Nakuci
// 1.3 31.01.2025 HSB-23313: Fix when saving after "edit in place" , Author: Marsel Nakuci
// 1.2 23.01.2025 HSB-23313: Use radio buttons for sve mode , Author: Marsel Nakuci
// 1.1 17.01.2025 HSB-23313: Add toggle to differentiate between "Style based" and "Instance based" , Author: Marsel Nakuci
// 1.0 10.01.2025 HSB-23313: Initial , Author: Marsel Nakuci

/// <insert Lang=en>
/// Select entities
/// </insert>

// <summary Lang=en>
// This tsl creates and manages axle positions of a TruckDefinition
// it can be inserted on a StackEntity Tsl
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "StackAxle")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|"))) TSLCONTENT
//endregion


//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug || _kShiftKeyPressed;

	String tDefault =T("|_Default|");
	String tLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};

	String sDialogLibrary = _kPathHsbInstall + "\\Utilities\\DialogService\\TslUtilities.dll";
	String sClass = "TslUtilities.TslDialogService";	
	String listSelectorMethod = "SelectFromList";
	String optionsMethod = "SelectOption";
	String simpleTextMethod = "GetText";
	String askYesNoMethod = "AskYesNo";
	String showNoticeMethod = "ShowNotice";
	String showMultilineNotice = "ShowMultilineNotice";

//region Color and view	
	int bIsDark;{int n = getBackgroundTrueColor();bIsDark = ((rgbR(n) + rgbB(n) + rgbG(n)) / 3 < 127);}
	int grey = bIsDark?rgb(199,200,202):rgb(99,100,102);
	int white = bIsDark?rgb(255,255,255):rgb(0,0,0);	
	
	int lightblue = rgb(204,204,255);
	int blue = rgb(69,84,185);	
	int darkblue = rgb(26,50,137);	
	int yellow = rgb(241,235,31);
	int darkyellow = rgb(254, 204, 102);
	int orange = rgb(242,103,34);
	int red = rgb(205,32,39);
	int purple = rgb(147,39,143);
	int petrol = rgb(16,86,137);
	int green = rgb(19,155,72);	

	Vector3d vecXView = getViewDirection(0);
	Vector3d vecYView = getViewDirection(1);
	Vector3d vecZView = getViewDirection(2);
	double dViewHeight = getViewHeight();
	
	String sDefinitions[] = TruckDefinition().getAllEntryNames().sorted();
//endregion 	

	String kTruckParent = "hsb_TruckParent";
//end Constants//endregion

//region Functions

//region visPp
void visPp(PlaneProfile _pp,Vector3d _vec)
{ 
	_pp.transformBy(_vec);
	_pp.vis(6);
	_pp.transformBy(-_vec);
	return;
}
//endregion//visPp

//region initiateAxles
// this function will initiate axle positions
// it will place 2 axles one front one back
Map initiateAxles(TruckDefinition _td, Map _mapTruckInfo)
{ 
	// 
	Vector3d _vecX=_mapTruckInfo.getVector3d("vecX");
	Vector3d _vecY=_mapTruckInfo.getVector3d("vecY");
	Vector3d _vecZ=_mapTruckInfo.getVector3d("vecZ");
	//
	Map _mOut;
	
	// initiate 2 axle loads 
	double dDistFront=U(2000);// front axle distance
	double dDistBack=U(1000);// back axle distance
	
	PlaneProfile _ppLoad=_mapTruckInfo.getPlaneProfile("ppLoad");
	
// get extents of profile
	LineSeg _seg=_ppLoad.extentInDir(_vecX);
//	double _dX=abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
//	double _dY=abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
	
	Map m;
	// front axle coordinate X
	m.setDouble("X",dDistFront);
	_mOut.appendMap("m",m);
	// back axle coordinate X
	Point3d _ptBack=_seg.ptEnd()-_vecX*dDistBack;
	double _dDist=abs(_vecX.dotProduct(_seg.ptStart()-_ptBack));
	m.setDouble("X",_dDist);
	_mOut.appendMap("m",m);
	return _mOut;
}
//endregion//initiateAxles
	
//region drawAxle
//This will draw the axles and wheels
Map drawAxle(Map _mapTruckInfo,Map _mapAxle, int _bDrawAxle,
	Point3d _ptCOG, double _dWeight, double _dAxleWeights[],int _bDrawAxleLoads,
	int _bStyleBased)
{ 
	//
	Map _mOut;
	
	Vector3d _vecX=_mapTruckInfo.getVector3d("vecX");// length
	Vector3d _vecY=_mapTruckInfo.getVector3d("vecY");// width
	Vector3d _vecZ=_mapTruckInfo.getVector3d("vecZ");// height (_ZW)
	Point3d _ptOrg=_mapTruckInfo.getPoint3d("ptOrg");
	PlaneProfile _ppLoad=_mapTruckInfo.getPlaneProfile("ppLoad");
	
	LineSeg _seg=_ppLoad.extentInDir(_vecX);
	
	double _dWidth=abs(_vecY.dotProduct(_seg.ptStart()-_seg.ptEnd()));
	double _dLength=abs(_vecX.dotProduct(_seg.ptStart()-_seg.ptEnd()));
	Display _dp(7);
	
	Point3d _ptStart=_seg.ptMid()-_vecX*.5*_dLength;
	double _dDistBelow=U(100);
	
	int _nColor=7;
	if(!_bStyleBased)_nColor=6;
	Display _dpTop(_nColor);
	
	_dpTop.addViewDirection(_vecZ);
	Display _dpElevation(_nColor);
	_dpElevation.addViewDirection(_vecY);
	_dpElevation.addViewDirection(-_vecY);
	
	double dHtriang=U(400);
	double dWtriang=U(150);
	for (int i=0;i<_mapAxle.length();i++)
	{ 
		Map mi=_mapAxle.getMap(i);
		Map mAxleI;// contains the seg and 2 bodies
		Point3d _pti=_ptStart+_vecX*mi.getDouble("X");
		
		// draw a triangle
		Point3d _ptTriang=_pti-_vecY*(.5*_dWidth+U(300));
		_ptTriang.vis(1);
		
		
		Point3d ptTriangTop, ptTriangElevation;
		{ 
			
			// top
			PLine _plTriang;
			_plTriang.addVertex(_ptTriang);
			ptTriangTop=_ptTriang;
			_plTriang.addVertex(_ptTriang-_vecY*dHtriang+_vecX*dWtriang);
			_plTriang.addVertex(_ptTriang-_vecY*dHtriang-_vecX*dWtriang);
			_plTriang.close();
			_plTriang.vis(1);
			if(_bDrawAxle)
			{
				_dpTop.draw(_plTriang);
			}
			mAxleI.setPLine("plTriangTop",_plTriang);
			// elevation
			_ptTriang-=_vecZ*U(200);
			_plTriang=PLine();
			_plTriang.addVertex(_ptTriang);
			ptTriangElevation=_ptTriang;
			_plTriang.addVertex(_ptTriang-_vecZ*dHtriang+_vecX*dWtriang);
			_plTriang.addVertex(_ptTriang-_vecZ*dHtriang-_vecX*dWtriang);
			_plTriang.close();
			_plTriang.vis(1);
			if(_bDrawAxle)
			{
				_dpElevation.draw(_plTriang);
			}
			mAxleI.setPLine("plTriangElevation",_plTriang);
			
		}
		// draw loads
		if(_bDrawAxleLoads)
		{ 
			Point3d _ptTxt=ptTriangTop-_vecY*(1.5*dHtriang);
			double dWeightI=_dAxleWeights[i];
			String sAxleWeight;
			sAxleWeight.format("%.0f",dWeightI);
			_dpTop.draw(sAxleWeight,_ptTxt,_vecX,_vecY,0,0);
			
			_ptTxt=ptTriangElevation-_vecZ*(1.5*dHtriang);
			_dpElevation.draw(sAxleWeight,_ptTxt,_vecX,_vecZ,0,0);
		}
		Point3d _ptLeft=_pti-_vecY*(.5*_dWidth)-_vecZ*_dDistBelow;
		Point3d _ptRight=_pti+_vecY*(.5*_dWidth)-_vecZ*_dDistBelow;
		mAxleI.setPoint3d("ptL",_ptLeft);
		mAxleI.setPoint3d("ptR",_ptRight);
		// draw as body
		
//		_pti.vis(3);
//		Point3d _ptLeft=_pti-_vecY*(.5*_dWidth+U(300))-_vecZ*_dDistBelow;
//		Point3d _ptRight=_pti+_vecY*(.5*_dWidth+U(300))-_vecZ*_dDistBelow;
//		LineSeg _lSeg(_ptLeft,_ptRight);
//		mAxleI.setPoint3d("ptL",_ptLeft);
//		mAxleI.setPoint3d("ptR",_ptRight);
//		if(_bDrawAxle)
//		_dp.draw(_lSeg);
//		
//		PLine _plCirc;
//		_plCirc.createCircle(_ptLeft,_vecY,U(500));
////		_dp.draw(_plCirc);
//		Body _bd(_plCirc,-_vecY*U(250),-1);
//		if(_bDrawAxle)
//		_dp.draw(_bd);
//		mAxleI.setBody("bdL",_bd);
//		_plCirc.createCircle(_ptRight,_vecY,U(500));
////		_dp.draw(_plCirc);
//		_bd=Body (_plCirc,+_vecY*U(250),-1);
//		if(_bDrawAxle)
//		_dp.draw(_bd);
//		
//		mAxleI.setBody("bdR",_bd);
		_mOut.appendMap("m", mAxleI);
	}//next i
	
	if(_bDrawAxleLoads)
	{ 
		// draw weight
		Point3d _ptTxt=_ptStart-_vecY*(.5*_dWidth+U(300)+0*dHtriang);
		_ptTxt+=_vecX*_vecX.dotProduct(_ptCOG-_ptTxt);
		String sWeight;
		sWeight.format("%.0f",_dWeight);
		_dpTop.draw(sWeight,_ptTxt,_vecX,_vecY,0,0);
		_dpElevation.draw(sWeight,_ptTxt-_vecZ*(0*dHtriang+U(200)),_vecX,_vecZ,0,0);
	}
	
	return _mOut;
}
//endregion//drawAxle

//region InitiateAxleGrips
//
Point3d[] initiateAxleGrips(Map _mapTruckInfo,Map _mapAxle)
{ 
	//
	Point3d _ptGrips[0];
	
	Vector3d _vecX=_mapTruckInfo.getVector3d("vecX");
	Vector3d _vecY=_mapTruckInfo.getVector3d("vecY");
	Vector3d _vecZ=_mapTruckInfo.getVector3d("vecZ");
	Point3d _ptOrg=_mapTruckInfo.getPoint3d("ptOrg");
	PlaneProfile _ppLoad=_mapTruckInfo.getPlaneProfile("ppLoad");
	
	LineSeg _seg=_ppLoad.extentInDir(_vecX);
	double _dLength=abs(_vecX.dotProduct(_seg.ptStart()-_seg.ptEnd()));
	Point3d _ptStart=_seg.ptMid()-_vecX*.5*_dLength;
	// 
	for (int i=0;i<_mapAxle.length();i++)
	{ 
		Map mi=_mapAxle.getMap(i);
		Point3d _pti=_ptStart+_vecX*mi.getDouble("X");
		_ptGrips.append(_pti);
	}
	//
	return _ptGrips;
}
//endregion//InitiateAxleGrips

//region getMapAxleFromPoints
//
Map getMapAxleFromPoints(Map _mapTruckInfo,Point3d _ptGrips[])
{ 
	Map _mOut;
	
	Vector3d _vecX=_mapTruckInfo.getVector3d("vecX");
	Vector3d _vecY=_mapTruckInfo.getVector3d("vecY");
	Vector3d _vecZ=_mapTruckInfo.getVector3d("vecZ");
	Point3d _ptOrg=_mapTruckInfo.getPoint3d("ptOrg");
	PlaneProfile _ppLoad=_mapTruckInfo.getPlaneProfile("ppLoad");
	
	LineSeg _seg=_ppLoad.extentInDir(_vecX);
	double _dLength=abs(_vecX.dotProduct(_seg.ptStart()-_seg.ptEnd()));
	Point3d _ptStart=_seg.ptMid()-_vecX*.5*_dLength;
	
	Map m;
	for (int i=0;i<_ptGrips.length();i++) 
	{ 
		double _dDist=_vecX.dotProduct(_ptGrips[i]-_ptStart);
		m.setDouble("X",_dDist);
		_mOut.appendMap("m",m);
	}//next i
	
	return _mOut;
}
//endregion//getMapAxleFromPoints

//region getPointAxleFromMap
// get points from map definition		
Map getPointAxleFromMap(Map _mapTruckInfo, Map _mapAxle)
{ 
	Map _mOut;
	
	Point3d _pts[0];
	
	Vector3d _vecX=_mapTruckInfo.getVector3d("vecX");
	Vector3d _vecY=_mapTruckInfo.getVector3d("vecY");
	Vector3d _vecZ=_mapTruckInfo.getVector3d("vecZ");
	Point3d _ptOrg=_mapTruckInfo.getPoint3d("ptOrg");
	PlaneProfile _ppLoad=_mapTruckInfo.getPlaneProfile("ppLoad");
	
	LineSeg _seg=_ppLoad.extentInDir(_vecX);
	double _dLength=abs(_vecX.dotProduct(_seg.ptStart()-_seg.ptEnd()));
	Point3d _ptStart=_seg.ptMid()-_vecX*.5*_dLength;
	
	for (int i=0;i<_mapAxle.length();i++) 
	{ 
		Map mi=_mapAxle.getMap(i);
		Point3d pti=_ptStart+_vecX*mi.getDouble("X");
		_pts.append(pti);
	}//next i
	
	_mOut.setPoint3dArray("pts",_pts);
	return _mOut;
}
//endregion//getPointAxleFromMap


//region getClosestPoint
// from _pts find the closest point with _pt
// returns the index
int getClosestPoint(Point3d _pts[], Point3d _pt)
{ 
	
	int _nIndexOut;
	Point3d _ptClosest;
	_ptClosest=_pts.first();
	double _dDistMin=(_pt-_ptClosest).length();
	_nIndexOut=0;
	for (int i=1;i<_pts.length();i++) 
	{ 
		double _dDistMinI=(_pts[i]-_pt).length();
		if(_dDistMinI<_dDistMin)
		{ 
			_dDistMin=_dDistMinI;
			_nIndexOut=i;
		}
	}//next i
	
	return _nIndexOut;
}
//endregion//getClosestPoint

//region getCross
//
 
	PlaneProfile getCross(Point3d _pt,Vector3d _vecDir,Vector3d _vecPlane,
		double _dScale)
	{ 
		PlaneProfile _pp(Plane(_pt,_vecPlane));
		
		Vector3d _vec=_vecPlane.crossProduct(_vecDir.crossProduct(_vecPlane));
		_vec.normalize();
		Vector3d _vecN=_vecPlane.crossProduct(_vec);
		_vecN.normalize();
		
//		Vector3d _v1=_vec+_vecN;_v1.normalize();
//		Vector3d _v2=_vecPlane.crossProduct(_v1);
//		_v2.normalize();
		
		Vector3d _v1=_vec;
		Vector3d _v2=_vecN;
		
		PlaneProfile _pp1;
		_pp1.createRectangle(LineSeg(_pt-_v1*_dScale*U(40)-_v2*_dScale*U(6),
			_pt+_v1*_dScale*U(40)+_v2*_dScale*U(6)),_v1,_v2);
		
		_pp.unionWith(_pp1);
		_pp1.createRectangle(LineSeg(_pt-_v1*_dScale*U(6)-_v2*_dScale*U(40),
			_pt+_v1*_dScale*U(6)+_v2*_dScale*U(40)),_v1,_v2);
		_pp.unionWith(_pp1);
		return _pp;
		
	}
//End getCross//endregion

//region calcAxleWeights
// This routine does the load distribution at axles
	double[] calcAxleWeights(double _das[], double _dXcog, double _dWeight)
	{ 
		// _das -> x coordinates of each axle
		// _dXcog -> x coordinate of cog
		// _dWeight -> total weight to be distributed
//		Map _mOut;
		double _dWeights[0];
		
		double dSuma, dSumaSquared;
		
		for (int i=0;i<_das.length();i++) 
		{ 
			dSuma+=_das[i];
			dSumaSquared+=(_das[i]*_das[i]);
		}//next i
		int nrAxles=_das.length();
		
		if(nrAxles==0)
		{ 
			return _dWeights;
		}
		
		if(abs(dSuma-_dXcog*nrAxles)>dEps)
		{ 
		// there is a rotation point
		// calc center of rotation
			double dXrot=(_dXcog*dSuma-dSumaSquared)/(dSuma-_dXcog*nrAxles);
			double dRot=_dWeight/(nrAxles*dXrot+dSuma);
			for (int ia=0;ia<_das.length();ia++) 
			{ 
				double dFi=(dXrot+_das[ia])*dRot;
				_dWeights.append(dFi);
			}//next ia
		}
		else
		{ 
		// transversal uniform displacement
			double dFi=_dWeight/nrAxles;
			for (int ia=0;ia<_das.length();ia++) 
			{ 
				_dWeights.append(dFi);
			}//next ia
		}
		return _dWeights;
	}
//endregion//calcAxleWeights

//region showConfigDialog
// it pops the dialog to choose how to save configuration
// 1- save in truck definition
// 2- save in instance
	Map showConfigDialog(Map _mIn, String _sSaveOptions[])
	{ 
		int numRows = _sSaveOptions.length();
		double dHeight = numRows > 5 ? 1000 : numRows * 100;
		Map mapDialog;
		
		mapDialog.setString("Title", T("|Saving mode|"));
		mapDialog.setString("Prompt", T("|Select the saving mode|"));
		
		Map mapItems;
	    Map m;
	    m.setInt("IsSelected",1);
	    m.setString("Text",_sSaveOptions[0]);
	    mapItems.appendMap("Item",m);
	    
	    for (int i=1;i<_sSaveOptions.length();i++) 
	    { 
	//	    	column1.setString("catalog"+i, _sCatalogs[i]);
	    	m.setInt("IsSelected",0);
		    m.setString("Text",_sSaveOptions[i]);
		    mapItems.appendMap("Item",m);
	    }//next i
	    
	     mapDialog.setMap("Items[]", mapItems);
//	   	Map mapRet = callDotNetFunction2(sDialogLibrary, sClass, listSelectorMethod, mapDialog);
	   	Map mapRet = callDotNetFunction2(sDialogLibrary, sClass, optionsMethod, mapDialog);
	    return mapRet;
	}
//endregion//showConfigDialog

//region prepareMapRequest
// prepares the maprequest for dim points

	Map prepareMapRequest(Map _mapTruckInfo,Map _mapAxle)
	{ 
		Map _mapRequestDim;
		
		Vector3d _vecX=_mapTruckInfo.getVector3d("vecX");
		Vector3d _vecY=_mapTruckInfo.getVector3d("vecY");
		Vector3d _vecZ=_mapTruckInfo.getVector3d("vecZ");
		Point3d _ptOrg=_mapTruckInfo.getPoint3d("ptOrg");
		
		_mapRequestDim.setString("DimRequestPoint", "DimRequestPoint");
		_mapRequestDim.setVector3d("AllowedView", _vecZ);
		_mapRequestDim.setInt("AlsoReverseDirection", true);
		_mapRequestDim.setVector3d("vecDimLineDir", _vecX);
		_mapRequestDim.setVector3d("vecPerpDimLineDir", _vecY);
		_mapRequestDim.setString("stereotype", "StackAxleDim");
		
		Point3d _ptDims[]=initiateAxleGrips(_mapTruckInfo,_mapAxle);
		_mapRequestDim.setPoint3dArray("Node[]", _ptDims);
		
		return _mapRequestDim;
	}
//endregion//prepareMapRequest

//endregion//Functions

//region Properties
//	String sDefinitionName=T("|Definition|");	
//	PropString sDefinition(nStringIndex++, sDefinitions, sDefinitionName);	
//	sDefinition.setDescription(T("|Defines the Definition|"));
//	sDefinition.setCategory(category);			
//End Properties//endregion 

//region Jig
	String strJigAddRemove = "JigAddRemoveAxle";
	if (_bOnJig && _kExecuteKey==strJigAddRemove) 
	{
		Vector3d vecView = getViewDirection();
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point	
	    Map mapTruckInfo=_Map.getMap("mapTruckInfo");
	    Map mapAxleMap=_Map.getMap("mapAxleMap");
		// 
		int bAddAxle=_Map.getInt("bAddAxle");
		Point3d ptGripsRemain[]=_Map.getPoint3dArray("ptGripsRemain");
		Point3d ptGripsAdded[]=_Map.getPoint3dArray("ptGripsAdded");
		//
		Vector3d vecX=mapTruckInfo.getVector3d("vecX");
		Vector3d vecY=mapTruckInfo.getVector3d("vecY");
		Vector3d vecZ=mapTruckInfo.getVector3d("vecZ");
		Point3d ptOrg=mapTruckInfo.getPoint3d("ptOrg");
		PlaneProfile ppLoad=mapTruckInfo.getPlaneProfile("ppLoad");
		LineSeg seg=ppLoad.extentInDir(vecX);
		//
		
		Plane pn(ptOrg,vecZ);
		Point3d ptIntersect;
		int bIntersect=Line(ptJig, vecView).hasIntersection(pn,ptIntersect);
		if(bIntersect)
			ptJig = ptIntersect;
		
		// check point 
		PlaneProfile ppLoadAllowed(ppLoad.coordSys());
		
		
		Display dp(-1),dpElevation(-1);
		Display dpError(1);
	    dp.trueColor(lightblue, 50);
	    dpElevation.trueColor(lightblue, 50);
	    dpElevation.addViewDirection(vecY);
	    dpElevation.addViewDirection(-vecY);
	    Display dpRemove(1),dpRemoveElevation(1);
	    dpRemoveElevation.addViewDirection(vecY);
	    dpRemoveElevation.addViewDirection(-vecY);
		ppLoadAllowed.createRectangle(LineSeg(seg.ptStart()+vecX*U(50)-vecY*U(10e6),
			seg.ptEnd()-vecX*U(50)+vecY*U(10e6)),vecX,vecY);
		if(ppLoadAllowed.pointInProfile(ptJig)==_kPointOutsideProfile)
		{ 
			dpError.draw(ppLoad);
		}
		else
		{ 
			Point3d ptCog;
			double dWeight;
			double dAxleWeights[0];
			if(bAddAxle)
			{ 
				
				// draw a preview of the axle
				// get map of axle
				Point3d pts[0];pts.append(ptJig);
				Map m=getMapAxleFromPoints(mapTruckInfo,pts);
				// draw by map
				Map mDraw=drawAxle(mapTruckInfo,m,false,
					ptCog,dWeight,dAxleWeights,false,false);
				for (int i=0;i<mDraw.length();i++) 
				{ 
					Map mi=mDraw.getMap(i);
					Point3d ptL=mi.getPoint3d("ptL");
					Point3d ptR=mi.getPoint3d("ptR");
					LineSeg lSeg(ptL,ptR);
					Body bdL=mi.getBody("bdL");
					Body bdR=mi.getBody("bdR");
					dp.draw(lSeg);
					dp.draw(bdL);
					dp.draw(bdR);
					
					PLine plTriangTop=mi.getPLine("plTriangTop");
					dp.draw(plTriangTop);
					
					PLine plTriangElevation=mi.getPLine("plTriangElevation");
					dpElevation.draw(plTriangElevation);
				}//next i
				// draw existing added
				{
					Map mAdded=getMapAxleFromPoints(mapTruckInfo,ptGripsAdded);
					
					Map mDraw=drawAxle(mapTruckInfo,mAdded,false,
						ptCog,dWeight,dAxleWeights,false,false);
					for (int i=0;i<mDraw.length();i++) 
					{ 
						Map mi=mDraw.getMap(i);
						Point3d ptL=mi.getPoint3d("ptL");
						Point3d ptR=mi.getPoint3d("ptR");
						LineSeg lSeg(ptL,ptR);
						Body bdL=mi.getBody("bdL");
						Body bdR=mi.getBody("bdR");
						dp.draw(lSeg);
						dp.draw(bdL);
						dp.draw(bdR);
						
						PLine plTriangElevation=mi.getPLine("plTriangElevation");
						dpElevation.draw(plTriangElevation);
					}//next i
				}
				
			}
			else
			{ 
				// draw cross
				// get the point closer with the ptjig
				int nIndexRemove=getClosestPoint(ptGripsRemain,ptJig);
				Point3d ptRemove=ptGripsRemain[nIndexRemove];
				Vector3d v=vecX+vecY;v.normalize();
				
				PlaneProfile pp=getCross(ptRemove,v,vecZ,4);
				dpRemove.draw(pp);
				dpRemove.draw(pp,_kDrawFilled);
				
				v=vecX+vecZ;v.normalize();
				PlaneProfile ppElevation=getCross(ptRemove,v,vecY,4);
				dpRemoveElevation.draw(ppElevation);
				dpRemoveElevation.draw(ppElevation,_kDrawFilled);
				
				// draw existing crosses
				Point3d ptGripsRemoved[]=_Map.getPoint3dArray("ptGripsRemoved");
				for (int i=0;i<ptGripsRemoved.length();i++) 
				{ 
					v=vecX+vecY;v.normalize();
					PlaneProfile pp=getCross(ptGripsRemoved[i],v,vecZ,4);
					dpRemove.draw(pp);
					dpRemove.draw(pp,_kDrawFilled); 
					
					v=vecX+vecZ;v.normalize();
					PlaneProfile ppElevation=getCross(ptGripsRemoved[i],v,vecY,4);
					dpRemoveElevation.draw(ppElevation);
					dpRemoveElevation.draw(ppElevation,_kDrawFilled);
				}//next i
				// 
				{ 
					Map mSelected=getMapAxleFromPoints(mapTruckInfo,ptGripsRemoved);
						
					Map mDraw=drawAxle(mapTruckInfo,mSelected,false,
						ptCog,dWeight,dAxleWeights,false,false);
					for (int i=0;i<mDraw.length();i++) 
					{ 
						Map mi=mDraw.getMap(i);
						Point3d ptL=mi.getPoint3d("ptL");
						Point3d ptR=mi.getPoint3d("ptR");
						LineSeg lSeg(ptL,ptR);
						Body bdL=mi.getBody("bdL");
						Body bdR=mi.getBody("bdR");
						dp.draw(lSeg);
						dp.draw(bdL);
						dp.draw(bdR);
					}//next i
				}
				
				// draw selected
				{ 
					Point3d _ptsSelected[]={ptRemove};
					Map mSelected=getMapAxleFromPoints(mapTruckInfo,_ptsSelected);
						
					Map mDraw=drawAxle(mapTruckInfo,mSelected,false,
						ptCog,dWeight,dAxleWeights,false,false);
					for (int i=0;i<mDraw.length();i++) 
					{ 
						Map mi=mDraw.getMap(i);
						Point3d ptL=mi.getPoint3d("ptL");
						Point3d ptR=mi.getPoint3d("ptR");
						LineSeg lSeg(ptL,ptR);
						Body bdL=mi.getBody("bdL");
						Body bdR=mi.getBody("bdR");
						dp.draw(lSeg);
						dp.draw(bdL);
						dp.draw(bdR);
					}//next i
				}
			}
		}
		
	    return;
	}
//endregion//Jig

//region OnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		if (_kExecuteKey.length()>0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey,-1)>-1)
			setPropValuesFromCatalog(_kExecuteKey);						
	// standard dialog	
//		else	
//			showDialog();
		
	// select StackEntity tsls
		
	// prompt for tsls
		Entity ents[0];
		PrEntity ssE(T("|Select 'StackEntity' tsls|"), TslInst());
	  	if (ssE.go())
			ents.append(ssE.set());
		
	// loop tsls
		TslInst tsls[0];
		for (int i=ents.length()-1; i>=0 ; i--) 
		{ 
			TslInst tsl=(TslInst)ents[i];
			if (tsl.bIsValid())
			{ 
				if(tsl.scriptName()=="StackEntity")
				{ 
					if(tsls.find(tsl)<0)
					{ 
						tsls.append(tsl);
					}
				}
			}
		}
		
	// create TSL
		TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[] = {};		Entity entsTsl[1];			Point3d ptsTsl[] = {_Pt0};
		int nProps[]={};
		double dProps[]={};
		String sProps[]={};
//		String sProps[]={sDefinition};
		Map mapTsl;	
		
		for (int i=0;i<tsls.length();i++)
		{ 
			TslInst tsl=tsls[i];
			entsTsl[0]=tsl;
			tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, 
				ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
		}//next i
		
		eraseInstance();
		return;
	}			
//endregion 


//region Validate
	TslInst tslStackEntity;
	if(_Entity.length()==1)
	{ 
		TslInst tsl=(TslInst)_Entity[0];
		if(tsl.bIsValid() && tsl.scriptName()=="StackEntity")
		{ 
			tslStackEntity=tsl;
		}
	}
	
	if(!tslStackEntity.bIsValid())
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|StackEntity TSL not found|"));
		eraseInstance();
		return;
	}
//endregion//Validate

//_Pt0=tslStackEntity.subMapX(kTruckParent).getPoint3d("ptOrg");
Point3d ptOrg=tslStackEntity.subMapX(kTruckParent).getPoint3d("ptOrg");
_ThisInst.setAllowGripAtPt0(false);
// get the definition from the stackentity
String sDefinition=tslStackEntity.propString(2);

int nDefinition=sDefinitions.find(sDefinition);

TruckDefinition td(sDefinition);
int bValid = sDefinitions.findNoCase(sDefinition ,- 1) >- 1 && td.bIsValid();

if(!bValid)
{ 
	reportMessage("\n" + scriptName() + ": " +T("|No TruckDefinition found|"));
	eraseInstance();
	return;
}
// wether StackEntity is on edit mode
int bEditDefinition=tslStackEntity.map().getInt("EditDefinition");

setDependencyOnEntity(_Entity[0]);

Vector3d vecX=_XW;
Vector3d vecY=_YW;
Vector3d vecZ=_ZW;
CoordSys cs=CoordSys(ptOrg,vecX,vecY,vecZ);
CoordSys csInv=cs;
csInv.invert();
// map with general information
Map mapTruckInfo;
mapTruckInfo.setVector3d("vecX",vecX);
mapTruckInfo.setVector3d("vecY",vecY);
mapTruckInfo.setVector3d("vecZ",vecZ);
mapTruckInfo.setPoint3d("ptOrg",ptOrg);

// get the truckload planeprofiles
PlaneProfile ppLoads[]=td.loadProfiles();
double dWidthTruck=td.width();
double dLengthTruck=td.length();
double dHeightTruck=td.height();

mapTruckInfo.setDouble("width",dWidthTruck);
mapTruckInfo.setDouble("length",dLengthTruck);
mapTruckInfo.setDouble("height",dHeightTruck);
if(ppLoads.length()==0)
{ 
	reportMessage("\n" + scriptName() + ": " +T("|No load profiles found|"));
	eraseInstance();
	return;
}
PlaneProfile ppLoad(ppLoads.first());

for (int i=0;i<ppLoads.length();i++) 
{ 
	PlaneProfile ppI=ppLoads[i];
	ppI.transformBy(cs);
	if(i==0)
	{ 
		ppLoad=ppI;
	}
	else
	{ 
		ppLoad.unionWith(ppI);
	}
}//next i

int bHasMapDefinition, bHasMapInstance;
// contains general information if needed in any function
Map mapPpLoads;
for (int i=0;i<ppLoads.length();i++) 
{ 
	Map mi;
	mi.setPlaneProfile("pp",ppLoads[i]);
	mapPpLoads.appendMap("m",mi);
}//next i
mapTruckInfo.setMap("mapPpLoads",mapPpLoads);
mapTruckInfo.setPlaneProfile("ppLoad",ppLoad);

// flag that tells if style based or instance based
int bStyleBased;// default instance based
if(_Map.hasInt("StyleBased"))
{ 
	bStyleBased=_Map.getInt("StyleBased");
}
//visPp(ppLoad, vecZ*U(2000));

// get the loads from the truck definition
Map mapAxleDef=td.subMapX("Axle");


bHasMapDefinition=(mapAxleDef.length()>0);

// on dbcreate write information on tsl
if(_bOnDbCreated)
{ 
	if(bHasMapDefinition)
	{
		_Map.setMap("Axle",mapAxleDef);
		bStyleBased=true;
		_Map.setInt("StyleBased",bStyleBased);
	}
	else if(!bHasMapDefinition)
	{ 
		// insert with active edit in place
		_Map.setInt("directEdit",true);
	}
}

// 
Map mapAxleMap;
if(_Map.hasMap("Axle"))
{ 
	mapAxleMap=_Map.getMap("Axle");
	bHasMapInstance=(mapAxleMap.length()>0);
}
int bTslHasAxle=(mapAxleMap.length()>0);


//return;
//if(!bTslHasAxle || _bOnDebug)
int bEditInPlace=_Map.getInt("directEdit");
if(!bTslHasAxle)
{ 
	// should not be empty
	// it has the TD map if available or it is initiated
	// definition not found and instance not found initiate
	// initiate the axles
	Map mapAxleInit=initiateAxles(td,mapTruckInfo);
	mapAxleMap=mapAxleInit;
	_Map.setMap("Axle",mapAxleMap);
	// initialise grips
	Point3d ptGripsInit[]=initiateAxleGrips(mapTruckInfo,mapAxleMap);
	for (int p=0;p<ptGripsInit.length();p++) 
	{ 
		ptGripsInit[p].vis(6);
	}
	Grip grip(_Pt0);
//			grip.setShapeType(_kGSTCircle);
//			grip.setShapeType(_kGSTTriangle);
	grip.setShapeType(_kGSTDiamond);
	
//	grip.addViewDirection(_ZW);
	grip.setColor(4);
	grip.setIsStretchPoint(true);
	grip.setIsRelativeToEcs(true);
	grip.setPtLoc(_Pt0);
	grip.setName("Axle");
	for (int p=0;p<ptGripsInit.length();p++) 
	{ 
		grip.setPtLoc(ptGripsInit[p]);
		_Grip.append(grip);
	}//next p
	// activate grips
	bEditInPlace=true;
	_Map.setInt("directEdit",bEditInPlace);
}

// 
//region Trigger SwitchMode
	String sTriggerSwitchMode = T("|Truck Definition Mode|");
	if(bStyleBased)sTriggerSwitchMode = T("|Instance Mode|");
	if(!bEditInPlace && bHasMapDefinition && bHasMapInstance)
	{
		addRecalcTrigger(_kContextRoot, sTriggerSwitchMode );
	}
	if (_bOnRecalc && _kExecuteKey==sTriggerSwitchMode)
	{
		_Map.setInt("StyleBased",!bStyleBased);
		setExecutionLoops(2);
		return;
	}//endregion
	


// TriggerEditInPlacePanel
	
//	String sTriggerEditInPlaces[] = {T("|Edit in Place|"),T("|Disable Edit in Place|")};
	String sTriggerEditInPlaces[] = {T("|Edit Definition|"),T("|Disable Edit in Place|")};
	String sTriggerEditInPlace = sTriggerEditInPlaces[bEditInPlace];
	addRecalcTrigger(_kContextRoot, sTriggerEditInPlace );
	if (_bOnRecalc && (_kExecuteKey==sTriggerEditInPlace || _kExecuteKey==sDoubleClick))
	{
		if (bEditInPlace)
		{
			//
			
			// show prompt to save the configuration in style mode or instance mode
			Map mInDialog;
			String sSaveOptions[]={T("|Save in definition|"),T("|Save in instance|")};
			Map mapDialog = showConfigDialog(mInDialog, sSaveOptions);
			
//			Map mapSelections = mapDialog.getMap("Selection[]");
			String sSelected=mapDialog.getString("Selection");
			int nSelected=sSaveOptions.find(sSelected);
		// save in definition//			
			Point3d ptGrips[0];
			for (int i=0;i<_Grip.length();i++) 
			{ 
				ptGrips.append(_Grip[i].ptLoc());
			}//next i
			// get mapAxle from grips
			mapAxleMap=getMapAxleFromPoints(mapTruckInfo,ptGrips);
			if(nSelected>-1)
			{
				bEditInPlace=false;
	//			_PtG.setLength(0);
				_Grip.setLength(0);
			}
			if(nSelected==0)
			{ 
				// save in truck definition
				td.setSubMapX("Axle",mapAxleMap);
				reportMessage("\n" + scriptName() + ": " +T("|Truck definition was updated|"));
				_Map.setInt("StyleBased",true);
			}
			else if(nSelected==1)
			{ 
				// save in instance
				_Map.setInt("StyleBased",false);
				_Map.setMap("Axle", mapAxleMap);
			}
			if(nSelected==0 || nSelected==1)
			{
				_Map.setInt("directEdit",bEditInPlace);
				setExecutionLoops(2);
				return;
			}
			else
			{ 
				// let it run through, nothing changed
			}
		}
		else
		{
			bEditInPlace= true;
			// create grips of axles
			// Initiate grips
			Map mapAxle=bStyleBased?mapAxleDef:mapAxleMap;
			Point3d ptGripsInit[]=initiateAxleGrips(mapTruckInfo,mapAxle);
			Grip grip(_Pt0);
//			grip.setShapeType(_kGSTCircle);
//			grip.setShapeType(_kGSTTriangle);
			grip.setShapeType(_kGSTDiamond);
			
			
//				grip.addViewDirection(_ZW);
			grip.setColor(4);
			grip.setIsStretchPoint(true);
			grip.setIsRelativeToEcs(true);
			grip.setPtLoc(_Pt0);
			grip.setName("Axle");
			for (int p=0;p<ptGripsInit.length();p++) 
			{ 
				grip.setPtLoc(ptGripsInit[p]);
				_Grip.append(grip);
			}//next p
			_Map.setInt("directEdit",bEditInPlace);
			setExecutionLoops(2);
			return;
		}
	}


// draw axle
Vector3d vecOffsetApplied;
if(bEditInPlace)
{ 
	// on edit in place
	int indexOfMovedGrip = Grip().indexOfMovedGrip(_Grip);
	Grip gripMoved;
	if (indexOfMovedGrip>-1)
	{ 
		gripMoved=_Grip[indexOfMovedGrip];
		vecOffsetApplied=gripMoved.vecOffsetApplied();
//		Line ln(_Pt0, vecX);
//		Point3d ptGripNew=ln.closestPointTo(gripMoved.ptLoc());
//		
//		gripMoved.setPtLoc(ptGripNew);
//		_Grip[indexOfMovedGrip]=gripMoved;
	}
	if (indexOfMovedGrip>-1 && gripMoved.name()=="Axle")
	{ 
		Vector3d vecZoffset=vecZ*vecZ.dotProduct(vecOffsetApplied);
		Vector3d vecYoffset=vecY*vecY.dotProduct(vecOffsetApplied);
		Point3d ptGripNew=gripMoved.ptLoc()-vecYoffset-vecZoffset;
		gripMoved.setPtLoc(ptGripNew);
		_Grip[indexOfMovedGrip]=gripMoved;
	}
	
	Point3d ptGrips[0];
	for (int i=0;i<_Grip.length();i++) 
	{ 
		ptGrips.append(_Grip[i].ptLoc());
	}//next i
	
	// get mapAxle from grips
	mapAxleMap=getMapAxleFromPoints(mapTruckInfo,ptGrips);
//	// update
//	_Map.setMap("Axle",mapAxleMap);
}
else if(!bEditInPlace)
{ 
	if(bStyleBased)
	{ 
		mapAxleMap=td.subMapX("Axle");
	}
	else
	{ 
		mapAxleMap=_Map.getMap("Axle");
	}
}
//region Axle load distribution
	Point3d ptCOG;
	double dWeight;
	double das[0];// X coordinates of each axle wrt ptOrg
	for (int i=0;i<mapAxleMap.length();i++) 
	{ 
		Map mi=mapAxleMap.getMap(i);
		das.append(mi.getDouble("X"));
	}//next i
	
	Map mapX=tslStackEntity.subMapX("Data");
	dWeight=mapX.getDouble("Weight");
	ptCOG=mapX.getPoint3d("COG");
	ptCOG.vis(3);
	
	double dXcog=vecX.dotProduct(ptCOG-ptOrg);
	double dAxleWeights[]=calcAxleWeights(das,dXcog,dWeight);
	// draw axle weights
	
//endregion//Axle loads

int bDrawAxle=true;
int bDrawAxleLoad=true;
Map mapDrawAxle=drawAxle(mapTruckInfo,mapAxleMap,bDrawAxle,
	ptCOG,dWeight,dAxleWeights,bDrawAxleLoad,bStyleBased);


//region Trigger SaveAxleConfigInTruckDef
//	String sTriggerSaveAxleConfigInTruckDef = T("|Save axle configuration in truck definition|");
	String sTriggerSaveAxleConfigInTruckDef = T("|Save Definition|");
	addRecalcTrigger(_kContext, sTriggerSaveAxleConfigInTruckDef);
	if (_bOnRecalc && _kExecuteKey==sTriggerSaveAxleConfigInTruckDef)
	{
		// save in mapx of td
		td.setSubMapX("Axle",mapAxleMap);
		setExecutionLoops(2);
		return;
	}//endregion
	
//region Trigger AddRemoveAxle
	String sTriggerAddAxle = T("|Add axle|");
	String sTriggerRemoveAxle = T("|Remove axle|");
	
	if(bEditInPlace)
	{
		// add axis only when in edit mode
		addRecalcTrigger(_kContextRoot, sTriggerAddAxle);
		addRecalcTrigger(_kContextRoot, sTriggerRemoveAxle);
	}
	if (_bOnRecalc && (_kExecuteKey==sTriggerAddAxle || _kExecuteKey==sTriggerRemoveAxle))
	{
		int bAddAxle=true;
		if(_kExecuteKey==sTriggerRemoveAxle)bAddAxle=false;
		String sStringStart="|Select Point|";
		PrPoint ssP(sStringStart);
		
		Map mapArgs;
		// general information
		mapArgs.setMap("mapTruckInfo",mapTruckInfo);
		// current axles defined
		mapArgs.setMap("mapAxleMap",mapAxleMap);
		//
		mapArgs.setInt("bAddAxle",bAddAxle);
		int nGoJig=-1;
		
		// indices of grips to be removed
		int nGripsRemove[0];
		// axle grip points during remove
		Point3d ptGripsRemain[0];
		for (int i=0;i<_Grip.length();i++) 
		{ 
			ptGripsRemain.append(_Grip[i].ptLoc());
		}//next i
		Point3d ptGripsInit[0];ptGripsInit.append(ptGripsRemain);
		//
		Point3d ptGripsRemoved[0];
		int nIndexGripsRemoved[0];
		//
		Point3d ptGripsAdded[0];
		mapArgs.setPoint3dArray("ptGripsRemain",ptGripsRemain);
		//
		while(nGoJig!=_kNone)
		{ 
			// 
			nGoJig=ssP.goJig(strJigAddRemove, mapArgs);
			if(nGoJig==_kOk)
			{ 
				//point was clicked
				Point3d ptLast=ssP.value();
				Vector3d vecView=getViewDirection();
				
				Plane pn(_Pt0,vecZ);
				Point3d ptIntersect;
				int bIntersect=Line(ptLast, vecView).hasIntersection(pn,ptIntersect);
				if(bIntersect)
					ptLast=ptIntersect;
				
				PlaneProfile ppLoadAllowed(ppLoad.coordSys());
				LineSeg seg=ppLoad.extentInDir(vecX);
				ppLoadAllowed.createRectangle(LineSeg(seg.ptStart()+vecX*U(50)-vecY*U(10e6),
					seg.ptEnd()-vecX*U(50)+vecY*U(10e6)),vecX,vecY);
				if(ppLoadAllowed.pointInProfile(ptLast)==_kPointOutsideProfile)
				{ 
					continue;
				}
				else
				{ 
					if(bAddAxle)
					{ 
						// add point
						Point3d pts[0];pts.append(ptLast);
						Map mapAxleNew=getMapAxleFromPoints(mapTruckInfo,pts);
						for (int i=0;i<mapAxleNew.length();i++) 
						{ 
							Map mi=mapAxleNew.getMap(i);
							mapAxleMap.appendMap("m",mi);
						}//next i
						//
						_Map.setMap("Axle",mapAxleMap);
						// update grips
						Map mPointsNew=getPointAxleFromMap(mapTruckInfo,mapAxleNew);
						Point3d ptsNew[]=mPointsNew.getPoint3dArray("pts");
						
						Grip grSample;
						if(_Grip.length()>0)
						{
							grSample=_Grip.first();
						}
						else if(_Grip.length()==0)
						{ 
							// HSB-23313: V1.5
							Grip grip(_Pt0);
							grip.setShapeType(_kGSTDiamond);
							grip.setColor(4);
							grip.setIsStretchPoint(true);
							grip.setIsRelativeToEcs(true);
							grip.setPtLoc(_Pt0);
							grip.setName("Axle");
						}
						for (int i=0;i<ptsNew.length();i++) 
						{ 
							Point3d pti=ptsNew[i];
							ptGripsAdded.append(pti);
							grSample.setPtLoc(pti);
							_Grip.append(grSample);
						}//next i
						mapArgs.setPoint3dArray("ptGripsAdded",ptGripsAdded);
					}
					else if(!bAddAxle)
					{ 
						// get index to be removed
//						ptGripsRemain=mapArgs.getPoint3dArray("ptGripsRemain");
						int nIndexRemove=getClosestPoint(ptGripsRemain,ptLast);
						ptGripsRemoved.append(ptGripsRemain[nIndexRemove]);
						ptGripsRemain.removeAt(nIndexRemove);
						mapArgs.setPoint3dArray("ptGripsRemain",ptGripsRemain);
						mapArgs.setPoint3dArray("ptGripsRemoved",ptGripsRemoved);
						
						
						int nIndexRemoveInit=getClosestPoint(ptGripsInit,ptLast);
						nIndexGripsRemoved.append(nIndexRemoveInit);
						//
					}
				}
			}
			else if(nGoJig==_kKeyWord)
			{ 
				// implement if any keyword
			}
			else if(nGoJig==_kCancel)
			{ 
				nGoJig=_kNone;
			}
			else if(nGoJig==_kNone)
			{ 
				// will finish
				// do nothing keep state before the command
				if(!bAddAxle)
				{ 
					// we are in remove, remove grips that are removed
					Grip gripsNew[0];
					for (int i=0;i<_Grip.length();i++) 
					{ 
						if(nIndexGripsRemoved.find(i)<0)
						{ 
							gripsNew.append(_Grip[i]);
						}
					}//next i
					_Grip=gripsNew;
				}
			}
		}
		
		setExecutionLoops(2);
		return;
	}
//endregion	

	
// write submapX to tsl
tslStackEntity.setSubMapX("Axle",mapAxleMap);

// save mapreques
Map mapRequestDim=prepareMapRequest(mapTruckInfo,mapAxleMap);
Map mapRequests;
mapRequests.appendMap("DimRequest",mapRequestDim);
_Map.setMap("DimRequest[]", mapRequests);





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
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="249" />
        <int nm="BreakPoint" vl="1280" />
        <int nm="BreakPoint" vl="1033" />
        <int nm="BreakPoint" vl="202" />
        <int nm="BreakPoint" vl="910" />
        <int nm="BreakPoint" vl="954" />
        <int nm="BreakPoint" vl="1114" />
        <int nm="BreakPoint" vl="1216" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23313: Consider if no existing grip when adding a grip" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="3/7/2025 3:43:44 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23313: Show weight in elevation" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="2/7/2025 8:38:20 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23313: Fix when saving after &quot;edit in place&quot;" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="1/31/2025 2:47:36 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23313: Use radio buttons for sve mode" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="1/23/2025 4:38:08 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23313: Add toggle to differentiate between &quot;Style based&quot; and &quot;Instance based&quot;" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="1/17/2025 11:20:37 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23313: Initial" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="1/10/2025 1:08:06 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End