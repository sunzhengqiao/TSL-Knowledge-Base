#Version 8
#BeginDescription
#Versions:
1.1 06/09/2024 HSB-20922: Fix when getting pt0Edge at "getWallConnectionType" Marsel Nakuci
1.0 26/06/2024 HSB-20922: Initial Marsel Nakuci



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords Face,connector,TFPC,Simpson,Wall,SF,
#BeginContents
//region <History>
// #Versions:
// 1.1 06/09/2024 HSB-20922: Fix when getting pt0Edge at "getWallConnectionType" Marsel Nakuci
// 1.0 26/06/2024 HSB-20922: Initial Marsel Nakuci

/// <insert Lang=en>
/// Select entities
/// </insert>

// <summary Lang=en>
// This tsl creates 
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "FaceConnector")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|"))) TSLCONTENT
//endregion
//region Constants 
	U(1,"mm");	
	double dEps=U(.1);
	int nDoubleIndex,nStringIndex,nIntIndex;
	String sDoubleClick="TslDoubleClick";
	int bDebug=_bOnDebug;
	// read a potential mapObject defined by hsbDebugController
	{ 
		MapObject mo("hsbTSLDev","hsbTSLDebugController");
		if (mo.bIsValid()){Map m=mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug=true;break;}}
		if(bDebug)reportMessage("\n"+scriptName()+" starting "+_ThisInst.handle());
	}
	String sDefault=T("|_Default|");
	String sLastInserted=T("|_LastInserted|");
	String category=T("|General|");
	String sNoYes[]={ T("|No|"),T("|Yes|")};
	String sBlockPath = _kPathHsbCompany + "\\Block";
//end Constants//endregion

	
//region Functions
void visualisePp(PlaneProfile _pp, Vector3d _vecTransform)
{ 
	_pp.transformBy(_vecTransform);
	_pp.vis(6);
}

//region getTextOrientation
// text should continue in the direction of _vx
// vxTxt,vyTxt should have the orientation of reading firection
// nx is calculated fromt _vx the direction the text should run
Map getTextOrientation(Vector3d _vx)
{ 
	Map _m;
	Vector3d _vxTxt=_vx;
	Vector3d _vyTxt=_ZW.crossProduct(_vxTxt);
	
	int _nx=1;
	if(_vx.dotProduct(_XW)<-dEps)
	{ 
		_nx=-1;
		_vxTxt=-_vx;
	}
	else if(_vx.isParallelTo(_YW))
	{ 
		if(_vx.dotProduct(_YW)<0)
		{ 
			_nx=-1;
			_vxTxt=-_vx;
		}
	}
	if(_vyTxt.dotProduct(_YW)<-dEps)
	{ 
		_vyTxt*=-1;
	}
	else if(_vyTxt.isParallelTo(_XW))
	{ 
		if(_vyTxt.dotProduct(_XW)>0)
		{ 
			_vyTxt*=-1;
		}
	}
	_m.setVector3d("vx",_vxTxt);
	_m.setVector3d("vy",_vyTxt);
	_m.setInt("nx", _nx);
	
	return _m;
}
//End getTextOrientation//endregion


Map findMaleFemaleAt2Walls(Element _els[])
{ 
	Map _m;
	
	ElementWallSF _esf0;
	ElementWallSF _esf1;
	ElementWallSF eMale,eFemale;
	int nMaleIndex=-1,nFemaleIndex=-1;
	if(_els.length()==2)
	{ 
		_esf0=(ElementWallSF)_els[0];
		_esf1=(ElementWallSF)_els[1];
	}
	
	if(!_esf0.bIsValid() || !_esf1.bIsValid())
	{ 
		String sError="findMaleFemaleAt2Walls: "+T("|2 walls needed|");
		_m.setInt("Error", true);
		_m.setString("sError",sError);
		return _m;
	}
	Vector3d _vx0=_esf0.vecX();
	Vector3d _vx1=_esf1.vecX();
	
	PLine _plOutlineWall0 = _esf0.plOutlineWall();
	Plane _pn0(_esf0.ptOrg(), _esf0.vecY());
	PlaneProfile pp0(_pn0);
	pp0.joinRing(_plOutlineWall0, _kAdd);
	
	Point3d ptsThis[] = _plOutlineWall0.vertexPoints(true);
	PLine _plOutlineWall1 = _esf1.plOutlineWall();
	_plOutlineWall1.projectPointsToPlane(_pn0, _esf0.vecY());
	Point3d ptsOther[] = _plOutlineWall1.vertexPoints(true);
	
	// common points on contour
	int nOnThis = 0, nOnOther = 0;
	Point3d ptsOnThis[0], ptsOnOther[0];
	// points from the other wall
	for (int p = 0; p < ptsOther.length(); p++)
	{
		double d = (ptsOther[p] - _plOutlineWall0.closestPointTo(ptsOther[p])).length();
		if (d < dEps)
		{
			ptsOnThis.append(ptsOther[p]);// collect connecting points between 2 walls
			nOnThis++;// count points of wall in el1 that are connected with wall in el0
		}
	}
	// points from this wall at other wall 
	for (int p = 0; p < ptsThis.length(); p++)
	{
		double d = (ptsThis[p] - _plOutlineWall1.closestPointTo(ptsThis[p])).length();
		if (d < dEps)
		{
			ptsOnOther.append(ptsThis[p]);
			nOnOther++;
		}
	}
	
	if(nOnThis==1 && nOnOther==2 && !_vx0.isParallelTo(_vx1))
	{ 
		eMale=_esf0;
		eFemale=_esf1;
		nMaleIndex=0;
		nFemaleIndex=1;
	}
	if(nOnThis==2 && nOnOther==1 && !_vx0.isParallelTo(_vx1))
	{ 
		eMale=_esf1;
		eFemale=_esf0;
		nMaleIndex=1;
		nFemaleIndex=0;
	}
	_m.setEntity("male", eMale);
	_m.setEntity("female", eFemale);
	_m.setInt("maleIndex",nMaleIndex);
	_m.setInt("femaleIndex",nFemaleIndex);
	return _m;
}

//region getOutterPoints
// returns the most outter points	
// for the reference side and the opposite side
Map getOutterPoints(Element _el)
{ 
	// gets ptRef and ptOpp
	// as the most outter points of the element
	Map _m;
	Point3d _ptRef, _ptOpp;
	
	// basic information
	Point3d _ptOrg=_el.ptOrg();
	Vector3d _vx=_el.vecX();
	Vector3d _vy=_el.vecY();
	Vector3d _vz=_el.vecZ();
	
	
	
	_ptRef=_el.ptOrg();
	_ptOpp=_el.ptOrg()-_vz*_el.zone(0).dH();
	
	int nZonesRef[]={5,4,3,2,1};
	int nZonesOpp[]={-5,-4,-3,-2,-1};
	int _nZoneRef=0;
	int _nZoneOpp=0;
	
	for (int z=0;z<nZonesRef.length();z++) 
	{ 
		ElemZone ez=_el.zone(nZonesRef[z]);
		Sheet _sheetsZ[]=_el.sheet(nZonesRef[z]);
		if(ez.dH()>0 && _sheetsZ.length()>0)
		{ 
			_nZoneRef=nZonesRef[z];
			break;
		}
	}//next z
	for (int z=0;z<nZonesOpp.length();z++) 
	{ 
		ElemZone ez=_el.zone(nZonesOpp[z]);
		Sheet _sheetsZ[]=_el.sheet(nZonesOpp[z]);
		if(ez.dH()>0 && _sheetsZ.length()>0)
		{ 
			_nZoneOpp=nZonesOpp[z];
			break;
		}
	}//next z
	
	if(_nZoneRef>0)
	{ 
		ElemZone _ez=_el.zone(_nZoneRef);
		_ptRef=_ez.ptOrg()+_ez.vecZ()*_ez.dH();
	}
	if(_nZoneOpp<0)
	{ 
		ElemZone _ez=_el.zone(_nZoneOpp);
		_ptOpp=_ez.ptOrg()+_ez.vecZ()*_ez.dH();
	}
	
	_m.setPoint3d("ptRef",_ptRef);
	_m.setPoint3d("ptOpp",_ptOpp);
	return _m;
}
//End getOutterPoints//endregion

//region getWallConnectionType
// finds parallel or corner type
// returns also distribution area
// and distribution points
Map getWallConnectionType(Element _els[])
{ 
	// for 2 walls, it finds whether
	// 2 parallel walls or
	// 2 corner walls
	Map _m;
	
	ElementWallSF _esf0;
	ElementWallSF _esf1;
	if(_els.length()==2)
	{ 
		_esf0=(ElementWallSF)_els[0];
		_esf1=(ElementWallSF)_els[1];
	}
	
	if(!_esf0.bIsValid() || !_esf1.bIsValid())
	{ 
		String sError="getWallConnectionType: "+T("|2 walls needed|");
		_m.setInt("Error", true);
		_m.setString("sError",sError);
		return _m;
	}
	
	Vector3d _vx0=_esf0.vecX();
	Vector3d _vy0=_esf0.vecY();
	Vector3d _vz0=_esf0.vecZ();
	
	Vector3d _vx1=_esf1.vecX();
	Vector3d _vy1=_esf1.vecY();
	Vector3d _vz1=_esf1.vecZ();
	
	int _bParallel, _bCorner;
	if(_vx0.isParallelTo(_vx1))
	{ 
		_bParallel=true;
	}
	else if(_vx0.isParallelTo(_vz1))
	{ 
		_bCorner=true;
	}
	if(!_bParallel && !_bCorner)
	{ 
		String sError="getWallConnectionType: "+T("|Only parallel and corner connected walls supported|");
		_m.setInt("Error", true);
		_m.setString("sError",sError);
		return _m;
	}
	
	_m.setInt("Parallel",_bParallel);
	_m.setInt("Corner",_bCorner);
	// walls can be up to 100mm apart for valid connection
	double dMaxDistanceApart=U(100);
	if(_bParallel)
	{ 
		// parallel connection
		// check not far apart in top plane
		PlaneProfile pp0top(_esf0.plOutlineWall());
		PlaneProfile pp1top(_esf1.plOutlineWall());
		
		PlaneProfile pp0topExtend=pp0top;pp0topExtend.shrink(-.5*dMaxDistanceApart);
		PlaneProfile pp1topExtend=pp1top;pp1topExtend.shrink(-.5*dMaxDistanceApart);
		
		if(!pp0topExtend.intersectWith(pp1topExtend))
		{ 
			String sError="getWallConnectionType: "+T("|Walls too far apart, connection not possible|");
			_m.setInt("Error", true);
			_m.setString("sError",sError);
			return _m;
		}
		
		// check common area in height
		PlaneProfile pp0(_esf0.plEnvelope());
		PlaneProfile pp1(_esf1.plEnvelope());
//		pp0.vis(1);
//		pp1.vis(2);
		PlaneProfile pp0Extend(pp0.coordSys());
		PlaneProfile pp1Extend(pp1.coordSys());
		LineSeg ls0=pp0.extentInDir(_vx0);
		LineSeg ls1=pp1.extentInDir(_vx0);
		pp0Extend.createRectangle(LineSeg(ls0.ptStart()-_vx0*dMaxDistanceApart,
			ls0.ptEnd()+_vx0*dMaxDistanceApart),_vx0,_vy0);
		pp1Extend.createRectangle(LineSeg(ls1.ptStart()-_vx1*dMaxDistanceApart,
			ls1.ptEnd()+_vx1*dMaxDistanceApart),_vx1,_vy1);
			
//		pp0Extend.vis(1);
//		pp1Extend.vis(2);
		PlaneProfile pp01=pp0Extend;pp01.intersectWith(pp1Extend);
//		pp01.vis(6);
		
		if(pp01.area()<pow(U(1),2))
		{ 
			String sError="getWallConnectionType: "+T("|no common area in height|");
			_m.setInt("Error", true);
			_m.setString("sError",sError);
			return _m;
		}
		// common profile in height of 2 walls
		
		_m.setPlaneProfile("ppCommon",pp01);
		Vector3d _vecDir=_vy0;
		_m.setVector3d("vecDir",_vecDir);
		LineSeg lsCommon=pp01.extentInDir(_vecDir);
		_m.setPoint3d("ptStart",lsCommon.ptStart());
		_m.setPoint3d("ptEnd",lsCommon.ptEnd());
		_m.setPoint3d("ptMid",.5*(lsCommon.ptEnd()+lsCommon.ptStart()));
		
		
		// get middle point
		Point3d _ptMid=pp0topExtend.extentInDir(_vx0).ptMid();
		visualisePp(pp0top,_vy0*U(300));
//		_ptMid.vis(6);
		
		// get pt0ref, pt1ref and pt0opp, pt1opp
		Vector3d _vx01=_vx0;
		if(_vx01.dotProduct(pp1top.ptMid()-pp0top.ptMid())<0)
		{ 
			_vx01*=-1;
		}
		_m.setVector3d("v01",_vx01);
//		_vx01.vis(_ptMid);
		// for the edge calculation consider sheeting!!!
		Point3d pt0Edge=pp0top.extentInDir(_vx01).ptEnd();
		Point3d pt1Edge=pp1top.extentInDir(_vx01).ptStart();
//		pt0Edge.vis(1);
		
		Point3d _pt0Ref, _pt0Opp, _pt1Ref, _pt1Opp;
		Map _mOutterPts0=getOutterPoints(_esf0);
		_pt0Ref=_mOutterPts0.getPoint3d("ptRef");
		_pt0Opp=_mOutterPts0.getPoint3d("ptOpp");
		_pt0Ref+=_vx0*_vx0.dotProduct(pt0Edge-_pt0Ref);
		_pt0Opp+=_vx0*_vx0.dotProduct(pt0Edge-_pt0Opp);
		
//		_pt0Ref.vis(3);
//		_pt0Opp.vis(3);
		
		Map _mOutterPts1=getOutterPoints(_esf1);
		_pt1Ref=_mOutterPts1.getPoint3d("ptRef");
		_pt1Opp=_mOutterPts1.getPoint3d("ptOpp");
		
		_pt1Ref+=_vx1*_vx1.dotProduct(pt1Edge-_pt1Ref);
		_pt1Opp+=_vx1*_vx1.dotProduct(pt1Edge-_pt1Opp);
		
		_m.setPoint3d("pt0Ref",_pt0Ref);
		_m.setPoint3d("pt1Ref",_pt1Ref);
		_m.setPoint3d("pt0Opp",_pt0Opp);
		_m.setPoint3d("pt1Opp",_pt1Opp);
		return _m;
	}
	else if(_bCorner)
	{ 
		// corner connection
		// find which is male and which is female
		// find vecDepth, vec01
		// entry should always be the female wall
		
		Map mMaleFemale=findMaleFemaleAt2Walls(_els);
		int _nIndexFemale=mMaleFemale.getInt("femaleIndex");
		int _nIndexMale=mMaleFemale.getInt("maleIndex");
		ElementWallSF esfFemale=(ElementWallSF)_els[_nIndexFemale];
		ElementWallSF esfMale=(ElementWallSF)_els[_nIndexMale];
		// connection is from female to male
		if(!esfFemale.bIsValid() || !esfMale.bIsValid())
		{ 
			String sError="getWallConnectionType: "+T("|Stick frame wall not valid|");
			_m.setInt("Error", true);
			_m.setString("sError",sError);
			return _m;
		}
		
		_esf0=esfFemale;
		_esf1=esfMale;
		
		_vx0=_esf0.vecX();
		_vy0=_esf0.vecY();
		_vz0=_esf0.vecZ();
		
		_vx1=_esf1.vecX();
		_vy1=_esf1.vecY();
		_vz1=_esf1.vecZ();
		
		// check not far apart in top plane
		PlaneProfile pp0top(_esf0.plOutlineWall());
		PlaneProfile pp1top(_esf1.plOutlineWall());
		
		PlaneProfile pp0topExtend=pp0top;pp0topExtend.shrink(-.5*dMaxDistanceApart);
		PlaneProfile pp1topExtend=pp1top;pp1topExtend.shrink(-.5*dMaxDistanceApart);
		
		if(!pp0topExtend.intersectWith(pp1topExtend))
		{ 
			String sError="getWallConnectionType: "+T("|Walls too far apart, connection not possible|");
			_m.setInt("Error", true);
			_m.setString("sError",sError);
			return _m;
		}
		
		Point3d _ptMid=pp0topExtend.ptMid();
		
		Vector3d _vx101=_vx0;// female vector but pointing male female
		if(_vx101.dotProduct(pp1top.ptMid()-pp0top.ptMid())<0)_vx101*=-1;
		
		Vector3d _vx01=_vx1;
		if(_vx01.dotProduct(pp1top.ptMid()-pp0top.ptMid())<0)_vx01*=-1;
//		_vx01.vis(pp0top.ptMid());
		_m.setVector3d("v01",_vx01);
		Vector3d _vecDepth=_vx0;
		if(_vecDepth.dotProduct(pp1top.ptMid()-pp0top.ptMid())<0)_vecDepth*=-1;
		_vecDepth.vis(pp0top.ptMid());
		// check common area in height
		PlaneProfile pp0(_esf0.plEnvelope());
		// get extents of profile
		LineSeg seg0 = pp0top.extentInDir(_vz0);
		double dh0=abs(_vz0.dotProduct(seg0.ptStart()-seg0.ptEnd()));
		Body bd0(_esf0.plEnvelope(),-dh0*_vz0);
		bd0.vis(1);
		PlaneProfile pp1(_esf1.plEnvelope());
		
		LineSeg seg1 = pp1top.extentInDir(_vz1);
		double dh1=abs(_vz1.dotProduct(seg1.ptStart()-seg1.ptEnd()));
		Body bd1(_esf1.plEnvelope(),-dh1*_vz1);
		bd1.vis(1);
		
		pp0=bd0.shadowProfile(Plane(_ptMid,_vecDepth));
		pp1=bd1.shadowProfile(Plane(_ptMid,_vecDepth));
		
		
//		pp0.vis(1);
//		pp1.vis(2);
		PlaneProfile pp0Extend(pp0.coordSys());
		PlaneProfile pp1Extend(pp1.coordSys());
		LineSeg ls0=pp0.extentInDir(_vx01);
		LineSeg ls1=pp1.extentInDir(_vx01);
		pp0Extend.createRectangle(LineSeg(ls0.ptStart()-_vx01*2*dMaxDistanceApart,
			ls0.ptEnd()+_vx01*2*dMaxDistanceApart),_vx01,_vy0);
		pp1Extend.createRectangle(LineSeg(ls1.ptStart()-_vx01*2*dMaxDistanceApart,
			ls1.ptEnd()+_vx01*2*dMaxDistanceApart),_vx01,_vy1);
			
		pp0Extend.vis(1);
		pp1Extend.vis(2);
		PlaneProfile pp01=pp0Extend;pp01.intersectWith(pp1Extend);
//		pp01.vis(6);
		
		if(pp01.area()<pow(U(1),2))
		{ 
			String sError="getWallConnectionType: "+T("|no common area in height|");
			_m.setInt("Error", true);
			_m.setString("sError",sError);
			return _m;
		}
		_m.setPlaneProfile("ppCommon",pp01);
		Vector3d _vecDir=_vy0;
		_m.setVector3d("vecDir",_vecDir);
		LineSeg lsCommon=pp01.extentInDir(_vecDir);
		Point3d _ptStart=lsCommon.ptStart();_ptStart+=_vx01*_vx01.dotProduct(_ptMid-_ptStart);
		Point3d _ptEnd=lsCommon.ptEnd();_ptEnd+=_vx01*_vx01.dotProduct(_ptMid-_ptEnd);
		_ptMid=.5*(_ptStart+_ptEnd);
		_m.setPoint3d("ptStart",_ptStart);
		_m.setPoint3d("ptEnd",_ptEnd);
		_m.setPoint3d("ptMid",_ptMid);
		
		// for the edge calculation consider sheeting!!!
		Point3d _pt0Edge=pp0top.extentInDir(_vx01).ptEnd();// side 
//		Point3d _pt1Edge=pp1top.extentInDir(_vx01).ptStart();
		// V101
		Point3d _pt0Edge1=pp0top.extentInDir(_vx101).ptEnd();
//		Point3d _pt1Edge1=pp1top.extentInDir(_vx101).ptStart();
		_pt0Edge+=_vx101*_vx101.dotProduct(_pt0Edge1-_pt0Edge);
		
			Point3d _pt0Ref, _pt0Opp, _pt1Ref, _pt1Opp;
			Map _mOutterPts0=getOutterPoints(_esf0);// female
			_pt0Ref=_mOutterPts0.getPoint3d("ptRef");
			_pt0Opp=_mOutterPts0.getPoint3d("ptOpp");
			_pt0Ref+=_vx0*_vx0.dotProduct(_pt0Edge-_pt0Ref);
			_pt0Opp+=_vx0*_vx0.dotProduct(_pt0Edge-_pt0Opp);
			_pt0Ref.vis(3);
			_pt0Opp.vis(3);
			_m.setPoint3d("pt0Ref",_pt0Ref);
			_m.setPoint3d("pt1Ref",_pt1Ref);
			_m.setPoint3d("pt0Opp",_pt0Opp);
			_m.setPoint3d("pt1Opp",_pt1Opp);
		
		
		_m.setPoint3d("pt0Edge",_pt0Edge);
		_m.setVector3d("vecDepth",_vecDepth);
		return _m;
	}
	
	return _m;
	
}
//End getWallConnectionType//endregion

//region calcDistribution
// this routine calculates the distribution
// it requires a map that contain the information
// for the calculation of distribution
// it returns a map with the distributed points
	Map calcDistribution(Map _min)
	{ 
		Map _m;
		
		Point3d _ptsDis[0];
		// input data
		double _dPartLength=_min.getDouble("PartLength");
		Point3d _pt0Start=_min.getPoint3d("pt0Start");
		Point3d _pt0End=_min.getPoint3d("pt0End");
		double _dOffsetBottom=_min.getDouble("OffsetBottom");
		double _dOffsetTop=_min.getDouble("OffsetTop");
		double _dOffsetBetween=_min.getDouble("OffsetBetween");
		Vector3d _vecDistribution=_min.getVector3d("vecDistribution");
		int _nDistribution=_min.getInt("evenDistribution");
		
		int nDistributionType=_min.getInt("DistributionType");
		
		if(nDistributionType==0)
		{ 
			// type 0, in a single row, default type
			Vector3d _vecDir=_pt0End-_pt0Start;
			_vecDir.normalize();
			if(_min.hasVector3d("vecDistribution"))
			{
				_vecDir=_vecDistribution;
			}
			Point3d _pt1=_pt0Start+_vecDir*_dOffsetBottom;
			Point3d _pt2 =_pt0End-_vecDir*(_dOffsetTop+_dPartLength);
			
			double _dDistTot = (_pt2 - _pt1).dotProduct(_vecDir);
			if (_dDistTot < 0)
			{
				String sTxt=T("|no distribution possible|");
				_m.setString("sTxt",sTxt);
				_m.setInt("Error",true);
				return _m;
			}
			if(_dOffsetBetween>=0)
			{ 
				// distance is defined
				if(_nDistribution==1)
				{ 
					// even distribution
					double dDistMod=_dOffsetBetween+_dPartLength;
					int iNrParts=_dDistTot/dDistMod;
					double dNrParts=_dDistTot/dDistMod;
					if (dNrParts-iNrParts>0)iNrParts+=1;
					
					double dDistModCalc = 0;
					if (iNrParts != 0)
						dDistModCalc = _dDistTot / iNrParts;
						
					// first point
					Point3d pt;
					pt=_pt0Start+_vecDir*(_dOffsetBottom+_dPartLength/2);
					_ptsDis.append(pt);
					if (dDistModCalc>0)
					{
						for (int i=0;i<iNrParts;i++)
						{
							pt+=_vecDir*dDistModCalc;
							//					pt.vis(1);
							_ptsDis.append(pt);
						}
					}
				}
				else if(_nDistribution==0)
				{ 
					// fixed
					double dDistMod = _dOffsetBetween + _dPartLength;
					int iNrParts = _dDistTot / dDistMod;
		
					// calculated modular distance between subsequent parts
					double dDistModCalc = 0;
					dDistModCalc = dDistMod;
					// first point
					Point3d pt;
					pt=_pt0Start+_vecDir*(_dOffsetBottom+_dPartLength/2);
					_ptsDis.append(pt);
					if(dDistModCalc>0)
					{ 
						for (int i = 0; i < iNrParts; i++)
						{ 
							pt+=_vecDir*dDistModCalc;
				//					pt.vis(1);
							_ptsDis.append(pt);
						}
					}
					// last
					_ptsDis.append(_pt0End-_vecDir *(_dOffsetTop+_dPartLength/2));
					
					_ptsDis=Line(.5*(_pt0Start+_pt0End),_vecDir).projectPoints(_ptsDis);
					_ptsDis=Line(.5*(_pt0Start+_pt0End),_vecDir).orderPoints(_ptsDis,U(1));
				}
			}
			else
			{ 
				double dDistModCalc;
				//
				int nNrParts=-_dOffsetBetween/1;
				if (nNrParts==1)
				{
					dDistModCalc=_dOffsetBottom;
					_ptsDis.append(_pt0Start+_vecDir*_dOffsetBottom);
				}
				else
				{ 
					double dDistMod=_dDistTot/(nNrParts-1);
					dDistModCalc=dDistMod;
					int nNrPartsCalc=nNrParts;
					// clear distance between parts
					double dDistBet=dDistMod-_dPartLength;
					if (dDistBet<0)
					{
						// distance between 2 subsequent parts < 0
						dDistModCalc=_dPartLength;
						// nr of parts in between 
						nNrPartsCalc=_dDistTot/dDistModCalc;
						nNrPartsCalc+=1;
					}
					// first point
					Point3d pt;
					pt=_pt0Start+_vecDir*(_dOffsetBottom+_dPartLength/2);
					_ptsDis.append(pt);
		//			pt.vis(1);
					for (int i=0;i<(nNrPartsCalc-1);i++)
					{
						pt+=_vecDir*dDistModCalc;
						_ptsDis.append(pt);
					}//next i
				}
			}
	//
		}
		else if(nDistributionType==1)
		{ 
			// distribution in 2 directions, grid in x and y
			double _dDistanceX=_min.getDouble("DistanceX");
			double _dOffsetX=_min.getDouble("OffsetX");
			int _nNrX=_min.getInt("NrX");
			double _dDistanceY=_min.getDouble("DistanceY");
			double _dOffsetY=_min.getDouble("OffsetY");
			int _nNrY=_min.getInt("NrY");
			
			Point3d _pt=_min.getPoint3d("ptCen");
			Vector3d vx=_min.getVector3d("vx");
			Vector3d vn=_min.getVector3d("vn");
			Vector3d vy=vn.crossProduct(vx);
			vy.normalize();
			
			//
			Point3d _ptStart=_pt;
			_ptStart.vis(3);
			_ptStart+=vx*_dOffsetX+vy*_dOffsetY;
			int _nxSpace=_nNrX-1;
			if(_nNrX>1)
			{
				double _dxSpace=_nxSpace;
				_ptStart-=vx*.5*_dxSpace*_dDistanceX;
			}
			int _nySpace=_nNrY-1;
			if(_nNrY>1)
			{
				double _dySpace=_nySpace;
				_ptStart-=vy*.5*_dySpace*_dDistanceY;
			}
			Point3d pti=_ptStart;
			_ptStart.vis(6);
			for (int ix=0;ix<_nxSpace+1;ix++) 
			{ 
//				pti=_ptStart+ix*_dDistanceX*vx;
				for (int iy=0;iy<_nySpace+1;iy++) 
				{ 
					pti=_ptStart+ix*_dDistanceX*vx+iy*_dDistanceY*vy;
//					pti.vis(2);
					_ptsDis.append(pti);
				}//next iy
			}//next ix
			
			
			
		}
		_m.setPoint3dArray("ptsDis",_ptsDis);
		return _m;
	}
//End calcDistribution//endregion 

//region applyHardware
// this function reads the hardware map from the xml
// and applies it as hardware
 HardWrComp[] applyHardware(Map _mIn,Entity _ent0,Entity _ent1,
	TslInst& thisInst,int _nQty, HardWrComp& hwcs[])
{ 
	Map m;
	HardWrComp hwcs[] = thisInst.hardWrComps();
// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
	for (int i=hwcs.length()-1; i>=0 ; i--) 
		if (hwcs[i].repType() == _kRTTsl)
			hwcs.removeAt(i); 
	
	if(_mIn.length()>0)
	{ 
		// info comming as map from xml
		for (int i=0;i<_mIn.length();i++) 
		{ 
			Map mI=_mIn.getMap(i);
			
			int nHWQty=mI.getInt("Quantity");
			if(_nQty>1)nHWQty*=_nQty;
			String sHWArticleNumber=mI.getString("ArticleNumber");
			HardWrComp hwc(sHWArticleNumber, nHWQty); // the articleNumber and the quantity is mandatory
			String sHWManufacturer=mI.getString("Manufacturer");
			hwc.setManufacturer(sHWManufacturer);
			
			String sDesignation=mI.getString("Designation");
			
			
			String sHWGroupName;
			Group groups[]=_ent0.groups();
			hwc.setLinkedEntity(_ent0);
			hwc.setCategory(T("|Connector|"));
			hwc.setRepType(_kRTTsl);
			if(sDesignation=="Female")
			{ 
				groups=_ent1.groups();
				hwc.setLinkedEntity(_ent1);	
			}
			hwc.setGroup(sHWGroupName);
			if (groups.length()>0)	sHWGroupName=groups[0].name();
			
			hwcs.append(hwc);
		}
	}
	else if(_mIn.length()==0)
	{ 
		// default hardware definition
		
		// main part
		{ 
			
			String sHWArticleNumber="TFPC";
			int nHWQty=1*_nQty;
			HardWrComp hwc(sHWArticleNumber, nHWQty);
			hwc.setManufacturer("Simpson Stron Tie");
			hwc.setDescription(T("|Timber Frame Panel Closer|"));
			hwc.setCategory(T("|Connector|"));
			hwc.setRepType(_kRTTsl);
			
			hwc.setDScaleX(U(21));
			hwc.setDScaleY(U(54));
			hwc.setDScaleZ(U(50));
			
			String sHWGroupName;
			Group groups[]=_ent0.groups();
			if (groups.length()>0)	sHWGroupName=groups[0].name();
			hwc.setGroup(sHWGroupName);
			
			hwc.setLinkedEntity(_ent0);
			hwcs.append(hwc);
		}
		// main diagonal structural screw
		{ 
			// 1. 1xSDW22458 refers to 8.0 x 117mm SDW structural screw (included).
			String sHWArticleNumber="SDW22458";
			int nHWQty=1*_nQty;
			HardWrComp hwc(sHWArticleNumber, nHWQty);
			hwc.setDescription(T("|8.0 x 117mm SDW structural screw|"));
			hwc.setCategory(T("|Connector|"));
			hwc.setRepType(_kRTTsl);
			
			hwc.setDScaleX(U(8.0));
			hwc.setDScaleY(U(117));
			
			String sHWGroupName;
			Group groups[]=_ent0.groups();
			if (groups.length()>0)	sHWGroupName=groups[0].name();
			hwc.setGroup(sHWGroupName);
			
			hwc.setLinkedEntity(_ent0);
			hwcs.append(hwc);
		}
		// 2 nails
		{ 
			// 2. 2xN3.75x30 refers to 3.75 x 30mm square twist nail (included).
			
			String sHWArticleNumber="N3.75x30";
			int nHWQty=2*_nQty;
			HardWrComp hwc(sHWArticleNumber, nHWQty);
			hwc.setDescription(T("|3.75 x 30mm square twist nail|"));
			hwc.setCategory(T("|Connector|"));
			hwc.setRepType(_kRTTsl);
			
			hwc.setDScaleX(U(3.75));
			hwc.setDScaleY(U(30));
			
			String sHWGroupName;
			Group groups[]=_ent0.groups();
			if (groups.length()>0)	sHWGroupName=groups[0].name();
			hwc.setGroup(sHWGroupName);
			
			hwc.setLinkedEntity(_ent0);
			hwcs.append(hwc);
		}
	}

	return hwcs;
}
//End applyHardware//endregion

//region drawSymbol
// it draws the tsl symbol
Map drawSymbolAt2Walls(Element _els[], Map _min)
{ 
	Map _m;
	if(_els.length()!=2)
	{ 
		// needed at least 1 panels
		String sError=T("|2 Walls needed|");
		_m.setString("sError",sError);
		_m.setInt("Error",true);
		return _m;
	}
	if(_els.length()==2)
	{ 
		// 2 walls
		
		Vector3d _vx=_XW;
		Vector3d _vy=_YW;
		Vector3d _vz=_ZW;
		if(_min.hasVector3d("vecX"))
		{ 
			_vx=_min.getVector3d("vecX");
		}
		if(_min.hasVector3d("vecY"))
		{ 
			_vy=_min.getVector3d("vecY");
		}
		if(_min.hasVector3d("vecZ"))
		{ 
			_vz=_min.getVector3d("vecZ");
		}
		double _dOffset=U(0);
		if(_min.hasDouble("Offset"))
		{ 
			_dOffset=_min.getDouble("Offset");
		}
		
		Point3d _ptsDis[]=_min.getPoint3dArray("pts");
		_vx.vis(_ptsDis[0], 1);
		_vy.vis(_ptsDis[0], 3);
		_vz.vis(_ptsDis[0], 5);
		Display dp(3);
		if(_min.hasInt("Color"))
		{ 
			dp.color(_min.getInt("Color"));
		}
		double _dDiameter=U(42);
		String sBlock;
		if(_min.hasString("BlockName"))
		{ 
			sBlock=_min.getString("BlockName");
		}
		Vector3d _vxb=_XW;
		Vector3d _vyb=_YW;
		Vector3d _vzb=_ZW;
		if(_min.hasVector3d("vecXb"))
		{ 
			_vxb=_min.getVector3d("vecXb");
		}
		if(_min.hasVector3d("vecYb"))
		{ 
			_vyb=_min.getVector3d("vecYb");
		}
		if(_min.hasVector3d("vecZb"))
		{ 
			_vzb=_min.getVector3d("vecZb");
		}
		Block block(sBlock);
		
		for (int p=0; p<_ptsDis.length(); p++)
		{
			_ptsDis[p].vis(1);
			
			Body bdSample(_ptsDis[p]+_vx*_dOffset,_vx,_vy,_vz,U(55),U(50),U(2.5),-1,0,-1);
			dp.draw(bdSample);
			
			
			dp.draw(block,_ptsDis[p]+_vx*_dOffset,_vxb,_vyb,_vzb);
		}
	}
	
	return _m;
}
//End drawSymbol//endregion 

//region getBlockName
// it checks if block is loaded in drawing
// if not it looks in directory
// if block is found, it returns the block name
String getBlockName(String _sBlockName)
{ 
	// it checks if block is loaded in drawing
	// if not it looks in directory
	// if block is found, it returns the block name
	String _sBlockNameReturn;
	if(_BlockNames.findNoCase(_sBlockName ,- 1) >-1)
	{ 
		_sBlockNameReturn=_sBlockName;
	}
	else if (_BlockNames.findNoCase(_sBlockName ,-1) < 0)
	{ 
		String files[]=getFilesInFolder(sBlockPath);
		String fileName=_sBlockName;
		if (files.findNoCase(fileName+".dwg",-1)>-1)
		{
			_sBlockNameReturn=sBlockPath+"\\" + fileName + ".dwg";
		}
	}
	
	
	return _sBlockNameReturn;
}
//End getBlockName//endregion

void displayTextPlan(Map _min)
{ 
	double _dTextHeight=U(50);
	if(_min.hasDouble("TextHeight"))
	{ 
		_dTextHeight=_min.getDouble("TextHeight");
	}
	int _nColor=7;
	if(_min.hasInt("Color"))
	{ 
		_nColor=_min.getInt("Color");
	}
	
	Vector3d _vx=_XW;
	Vector3d _vy=_YW;
	if(_min.hasVector3d("vx"))
	{ 
		_vx=_min.getVector3d("vx");
	}
	if(_min.hasVector3d("vy"))
	{ 
		_vy=_min.getVector3d("vy");
	}
	int _nx=-1;
	if(_min.hasInt("nx"))
	{ 
		_nx=_min.getInt("nx");
	}
	
	String sTxt=_min.getString("Text");
	
	Point3d _pt=_min.getPoint3d("pt");
	
	Display _dp(_nColor);
	_dp.textHeight(_dTextHeight);
	_dp.addViewDirection(_ZW);
	
	_dp.draw(sTxt,_pt,_vx,_vy,_nx,0);
	
	
	
	return;
}


//End Functions//endregion 
	
//region Settings
// settings prerequisites
	String sDictionary="hsbTSL";
	String sPath=_kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral=_kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName="FaceConnector";
	Map mapSetting;

// compose settings file location
	String sFolders[]=getFoldersInFolder(sPath); 
	int bPathFound=_bOnInsert?sFolders.find(sFolder)>-1?true:makeFolder(sPath+"\\"+sFolder):false;
	String sFullPath=sPath+"\\"+sFolder+"\\"+sFileName+".xml";

// read a potential mapObject
	MapObject mo(sDictionary,sFileName);
	if (mo.bIsValid())
	{
		mapSetting=mo.map();
		setDependencyOnDictObject(mo);
	}
	// create a mapObject to make the settings persistent	
	else if ((_bOnInsert || _bOnDebug) && !mo.bIsValid())
	{
		String sFile=findFile(sFullPath);
	// if no settings file could be found in company try to find it in the installation path
		if (sFile.length()<1) sFile=findFile(sPathGeneral+sFileName+".xml");
		if (sFile.length()>0)
		{ 
			mapSetting.readFromXmlFile(sFile);
			mo.dbCreate(mapSetting);
		}
	}
	// validate version when creating a new instance
	if(_bOnDbCreated)
	{ 
		int nVersion=mapSetting.getInt("GeneralMapObject\\Version");
		String sFile=findFile(sPathGeneral+sFileName+".xml");		// set default xml path
		if (sFile.length()<1) sFile=findFile(sFullPath);				// set custom xml path if no default found
		Map mapSettingInstall; mapSettingInstall.readFromXmlFile(sFile);	// read the xml from installation directory
		int nVersionInstall=mapSettingInstall.getMap("GeneralMapObject").getInt("Version");
		if(sFile.length()>0 && nVersion!=nVersionInstall)
			reportNotice(TN("|A different Version of the settings has been found for|")+scriptName()+
			TN("|Current Version| ")+nVersion+"	"+_kPathDwg + TN("|Other Version| ") +nVersionInstall+"	"+sFile);
	}
//End Settings//endregion	

//region Properties
	String sConnectionTypeName=T("|Connection Type|");
	// male-female means for each male one female
	// male-females means one male to multiple connected females
	// males-females means multiple colinear males to multile colinear females
//	String sConnectionTypes[]={T("|single panel|"),T("|male-female|"), T("|male-females|"),T("|males-females|")};

//	String sConnectionTypes[]={T("|Distribution at 2 walls|"),T("|Exploded distribution at 2 walls|")};
	String sConnectionTypes[]={T("|Distribution at 2 walls|")};
	PropString sConnectionType(nStringIndex++, sConnectionTypes, sConnectionTypeName);	
	sConnectionType.setDescription(T("|Defines the Connection Type|"));
	sConnectionType.setCategory(category);
	
	category=T("|Distribution|");
	String sDistributionName=T("|Rule|");
	String sDistributions[]={ T("|Fixed Distribution|"),T("|Even Distribution|")};
	PropString sDistribution(nStringIndex++,sDistributions,sDistributionName);	
	sDistribution.setDescription(T("|Defines the distribution type|"));
	sDistribution.setCategory(category);	
	
	String sOffsetBottomName=T("|Start Offset|");
	PropDouble dOffsetBottom(nDoubleIndex++,U(350),sOffsetBottomName);
	dOffsetBottom.setDescription(T("|Defines the start offset|"));
	dOffsetBottom.setCategory(category);
	
	String sOffsetTopName=T("|End Offset|");
	PropDouble dOffsetTop(nDoubleIndex++,U(350),sOffsetTopName);
	dOffsetTop.setDescription(T("|Defines the end offset|"));
	dOffsetTop.setCategory(category);
	
	String sOffsetBetweenName=T("|Interdistance|");
	PropDouble dOffsetBetween(nDoubleIndex++,U(1000),sOffsetBetweenName);
	dOffsetBetween.setDescription(T("|Defines the interdistance. Negative entries will define the quantity.|"));
	dOffsetBetween.setCategory(category);
	
	// 
	category=T("|Position|");
	String sSideParallelWallsName=T("|SideParallelWalls|");
	String sSideParallelWallss[]={T("|Reference|"),T("|Opposite|")};
	PropString sSideParallelWalls(nStringIndex++, sSideParallelWallss, sSideParallelWallsName);	
	sSideParallelWalls.setDescription(T("|Defines the Side of connection at Parallel Walls. Can be the reference side or the opposite side. When opposing walls, side is defined by first selected wall. |"));
	sSideParallelWalls.setCategory(category);
	
	String sOffsetName=T("|Offset|");
	PropDouble dOffset(nDoubleIndex++, U(0), sOffsetName);
	dOffset.setDescription(T("|Defines the Offset. For walls it is the edge of the wall panel.|"));
	dOffset.setCategory(category);
	
	category=T("|Display|");
	String sTextHeightName=T("|Text Height|");
	PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName);
	dTextHeight.setDescription(T("|Defines the Text Height|"));
	dTextHeight.setCategory(category);
//End Properties//endregion 

//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) {eraseInstance();return;}
					
	// silent/dialog
		if (_kExecuteKey.length()>0)
		{
			String sEntries[]= TslInst().getListOfCatalogNames(scriptName());
			if (sEntries.findNoCase(_kExecuteKey,-1)>-1)
				setPropValuesFromCatalog(_kExecuteKey);
			else
				setPropValuesFromCatalog(sLastInserted);
		}
	// standard dialog
		else
			showDialog();
		
		int nConnectionType=sConnectionTypes.find(sConnectionType);
		if(nConnectionType==0 || nConnectionType==1)
		{ 
			// 2 parallel walls
		// prompt for elements
			Element els[0];
			PrEntity ssE(T("|Select 2 parallel SF Walls|"), ElementWallSF());
		  	if (ssE.go())
				els.append(ssE.elementSet());
				
			if(els.length()>=2)
			{ 
				_Element.append(els[0]);
				_Element.append(els[1]);
			}
			
			if(nConnectionType==0)
			{ 
				// as distribution
				_Map.setInt("mode",1);
				return;
			}
			else if(nConnectionType==1)
			{ 
				// distribution mode after insert, for connection type 1
				_Map.setInt("mode",11);
			}
			
			return;
		}
		
		return;
	}
// end on insert	__________________//endregion

	
int nMode=_Map.getInt("mode");
if(nMode==1)
{ 
	// 2 wall elements with distribution
	// they can be 2 parallel, or in a corner connection
	Element el,el1;
	ElementWallSF esf, esf1;
	if(_Element.length()==2)
	{ 
		el=_Element[0];
		esf=(ElementWallSF)el;
		el1=_Element[1];
		esf1=(ElementWallSF)el1;
	}
	if(!esf.bIsValid() || !esf1.bIsValid())
	{ 
		reportMessage("\n"+scriptName()+" "+T("|2 Walls needed|"));
		eraseInstance();
		return;
	}
	
	sConnectionType.setReadOnly(_kHidden);
	sSideParallelWalls.setReadOnly(_kHidden);
	
	// basic information
	Point3d ptOrg=el.ptOrg();
	Vector3d vecX=el.vecX();
	Vector3d vecY=el.vecY();
	Vector3d vecZ=el.vecZ();
	
	// basic information
	Point3d ptOrg1=el1.ptOrg();
	Vector3d vecX1=el1.vecX();
	Vector3d vecY1=el1.vecY();
	Vector3d vecZ1=el1.vecZ();
	
	assignToElementGroup(el,false);
	assignToElementGroup(el1,false);

	
	
	_Pt0=ptOrg;
	_ThisInst.setAllowGripAtPt0(false);
	// check the two walls, can be parallel or corner
	Map mWallConnectionType=getWallConnectionType(_Element);
	if(mWallConnectionType.getInt("Error"))
	{ 
		String sError=mWallConnectionType.getString("sError");
		reportMessage("\n"+scriptName()+" "+sError);
		eraseInstance();
		return;
	}
	
	// vector pointing outside the depth of the tool
	Vector3d vecDepth=vecZ;// initialise
	// vector pointing from el0 to el1
	Vector3d vec01=vecX;
	
	int nDistribution=sDistributions.find(sDistribution);
	
	int bParallel=mWallConnectionType.getInt("Parallel");
//region Trigger SwapWalls
	String sTriggerSwapWalls = T("|Swap Walls|");
	if(bParallel)
		addRecalcTrigger(_kContextRoot, sTriggerSwapWalls );
	if (_bOnRecalc && _kExecuteKey==sTriggerSwapWalls)
	{
		_Element.swap(0,1);
		setExecutionLoops(2);
		return;
	}
//endregion
	
	vec01=mWallConnectionType.getVector3d("v01");
	Vector3d vecSide;
	// get pt0Edge and pt1Edge
	Point3d pt0Edge, pt1Edge;
	if(bParallel)
	{ 
		// can have 2 sides ref and opp
		if(!_Map.hasVector3d("vecSide"))
		{ 
			// initialise with the property refereing to first wall
			int nSideParallelWalls=sSideParallelWallss.find(sSideParallelWalls);
			Vector3d vSide=esf.vecZ();// reference
			if(nSideParallelWalls==1)vSide*=-1;
			_Map.setVector3d("vecSide",vSide);
		}
		vecSide=_Map.getVector3d("vecSide");
		
	//region Trigger FlipSide
		String sTriggerFlipSide = T("|Flip Side|");
		addRecalcTrigger(_kContextRoot, sTriggerFlipSide );
		if (_bOnRecalc && _kExecuteKey==sTriggerFlipSide)
		{
			_Map.setVector3d("vecSide",-vecSide);
			setExecutionLoops(2);
			return;
		}//endregion
		
		vecDepth=vecSide;
		if(vecSide.dotProduct(vecZ)>0)
		{ 
			// reference
			pt0Edge=mWallConnectionType.getPoint3d("pt0Ref");
			pt1Edge=mWallConnectionType.getPoint3d("pt1Ref");
		}
		else if(vecSide.dotProduct(vecZ)<0)
		{ 
			// opposite side
			pt0Edge=mWallConnectionType.getPoint3d("pt0Opp");
			pt1Edge=mWallConnectionType.getPoint3d("pt1Opp");
		}
		
	}
	else
	{ 
		// vecDepth for 2 corner walls
		vec01=mWallConnectionType.getVector3d("v01");
		vecDepth=mWallConnectionType.getVector3d("vecDepth");
		pt0Edge=mWallConnectionType.getPoint3d("pt0Edge");
		
	}
	_Pt0 = esf.ptOrg();
	vecDepth.vis(_Pt0, 1);
	vec01.vis(_Pt0, 3);// male vx but direction female - male
	pt0Edge.vis(1);
	Point3d ptMidDistribution=mWallConnectionType.getPoint3d("ptMid");
	Point3d ptStartDistribution=mWallConnectionType.getPoint3d("ptStart");
	Point3d ptEndDistribution=mWallConnectionType.getPoint3d("ptEnd");;
	Vector3d vecDirDistribution=mWallConnectionType.getVector3d("vecDir");
	
	// calculate the distribution points
	Map minDistribution;
	{ 
		double dPartLength=0;
		minDistribution.setDouble("PartLength", dPartLength);
		minDistribution.setPoint3d("pt0Start",ptStartDistribution);
		minDistribution.setPoint3d("pt0End",ptEndDistribution);
		minDistribution.setDouble("OffsetBottom", dOffsetBottom);
		minDistribution.setDouble("OffsetTop", dOffsetTop);
		minDistribution.setDouble("OffsetBetween", dOffsetBetween);
		minDistribution.setVector3d("vecDistribution", vecDirDistribution);
		minDistribution.setInt("evenDistribution", nDistribution);
	}
	Map mDistribution=calcDistribution(minDistribution);
	Display dp(7);
	if (mDistribution.getInt("Error"))
	{
		dp.color(1);
		String sText=mDistribution.getString("sTxt");;
		dp.draw(sText,ptMidDistribution,_XW,_YW,0,0,_kDeviceX);
		return;
	}
	Point3d ptsDis[]=mDistribution.getPoint3dArray("ptsDis");
	Line lnWallEdge(pt0Edge, vecDirDistribution);
	ptsDis=lnWallEdge.projectPoints(ptsDis);
	for (int p=0;p<ptsDis.length();p++) 
	{ 
		ptsDis[p].vis(1); 
	}//next p
	
	//region Trigger ReiheAufloesen
//	String sTriggerReiheAufloesen = "Reihe auflösen";
	String sTriggerReiheAufloesen = T("|Explode distribution|");
	addRecalcTrigger(_kContextRoot, sTriggerReiheAufloesen );
	if (_bOnRecalc && _kExecuteKey==sTriggerReiheAufloesen)
	{
		
	// create TSL
		TslInst tslNew; Vector3d vecXTsl=_XW; Vector3d vecYTsl=_YW;
		GenBeam gbsTsl[]={}; Entity entsTsl[2]; Point3d ptsTsl[]={_Pt0};
		int nProps[]={};
		double dProps[]={dOffsetBottom,dOffsetTop,dOffsetBetween,
			dOffset,dTextHeight};
		String sProps[]={sConnectionType,sDistribution,sSideParallelWalls};
		Map mapTsl;
		
		// 2 beams
		entsTsl[0]=esf;
		entsTsl[1]=esf1;
		// mapTsl
		mapTsl.setInt("mode",101);
		// needed for parallel connections
		mapTsl.setVector3d("vecSide",vecSide);
		
		for (int p=0;p<ptsDis.length();p++) 
		{ 
			ptsTsl[0]=ptsDis[p]; 
			
			tslNew.dbCreate(scriptName(),vecXTsl,vecYTsl,gbsTsl,entsTsl,
				ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
		}//next p
		
		eraseInstance();
		return;
	}//endregion
	
	String sBlockNameFound=getBlockName("TFPC");
	
	Map mInSymbol;
	{ 
		mInSymbol.appendPoint3dArray("pts",ptsDis);
		mInSymbol.setInt("Color", 6);
		Vector3d vxSymbol=vec01;
		Vector3d vzSymbol=-vecDepth;
		Vector3d vySymbol=vzSymbol.crossProduct(vxSymbol);
		mInSymbol.setVector3d("vecX",vxSymbol);
		mInSymbol.setVector3d("vecY",vySymbol);
		mInSymbol.setVector3d("vecZ",vzSymbol);
		mInSymbol.setDouble("Offset",dOffset);
		
		if(sBlockNameFound!="")
		{ 
			mInSymbol.setString("BlockName",sBlockNameFound);
			mInSymbol.setVector3d("vecXb",-vxSymbol);
			mInSymbol.setVector3d("vecYb",vySymbol);
			mInSymbol.setVector3d("vecZb",-vzSymbol);
		}
	}
	Map mDrawSymbol=drawSymbolAt2Walls(_Element,mInSymbol);
	
	// hardware
	HardWrComp hwcs[0];
	int nQty=ptsDis.length();
	Map mapHardwares;
	hwcs=applyHardware(mapHardwares,el,el1,_ThisInst,nQty,hwcs);
	if (_bOnDbCreated)	setExecutionLoops(2);				
	_ThisInst.setHardWrComps(hwcs);
	
	Map mTextOrientation=getTextOrientation(vecDepth);
	// draw text in plan
	Map mInText;
	{ 
//		mInText.setInt("Qty",nQty);
//		mInText.setString("Product","TFPC");
////		mInText.setInt("Color",7);
		mInText.setString("Text","TFPC x "+nQty);
//		mInText.setString("Text","TFPC");
		mInText.setDouble("TextHeight",dTextHeight);
		mInText.setPoint3d("pt",pt0Edge+vecDepth*U(100));
		mInText.setVector3d("vx",mTextOrientation.getVector3d("vx"));
		mInText.setVector3d("vy",mTextOrientation.getVector3d("vy"));
		mInText.setInt("nx",mTextOrientation.getInt("nx"));
	}
	displayTextPlan(mInText);
}
else if(nMode==11)
{ 
	// distribute at 2 elements
	
	return;
	
	
	eraseInstance();
	return;
}
else if(nMode==101)
{ 
	// single instance at 2 elements
	
	sConnectionType.setReadOnly(_kHidden);
	sDistribution.setReadOnly(_kHidden);
	dOffsetBottom.setReadOnly(_kHidden);
	dOffsetTop.setReadOnly(_kHidden);
	dOffsetBetween.setReadOnly(_kHidden);
	sSideParallelWalls.setReadOnly(_kHidden);
	
	Element el,el1;
	ElementWallSF esf, esf1;
	if(_Element.length()==2)
	{ 
		el=_Element[0];
		esf=(ElementWallSF)el;
		el1=_Element[1];
		esf1=(ElementWallSF)el1;
	}
	if(!esf.bIsValid() || !esf1.bIsValid())
	{ 
		reportMessage("\n"+scriptName()+" "+T("|2 Walls needed|"));
		eraseInstance();
		return;
	}
	
	// basic information
	Point3d ptOrg=el.ptOrg();
	Vector3d vecX=el.vecX();
	Vector3d vecY=el.vecY();
	Vector3d vecZ=el.vecZ();
	
	// basic information
	Point3d ptOrg1=el1.ptOrg();
	Vector3d vecX1=el1.vecX();
	Vector3d vecY1=el1.vecY();
	Vector3d vecZ1=el1.vecZ();
	
	assignToElementGroup(el,false);
	assignToElementGroup(el1,false);
	


	// check the two walls, can be parallel or corner
	Map mWallConnectionType=getWallConnectionType(_Element);
	if(mWallConnectionType.getInt("Error"))
	{ 
		String sError=mWallConnectionType.getString("sError");
		reportMessage("\n"+scriptName()+" "+sError);
		eraseInstance();
		return;
	}
	
	// vector pointing outside the depth of the tool
	Vector3d vecDepth=vecZ;// initialise
	// vector pointing from el0 to el1
	Vector3d vec01=vecX;
	
	int bParallel=mWallConnectionType.getInt("Parallel");
//region Trigger SwapWalls
	String sTriggerSwapWalls = T("|Swap Walls|");
	if(bParallel)
		addRecalcTrigger(_kContextRoot, sTriggerSwapWalls );
	if (_bOnRecalc && _kExecuteKey==sTriggerSwapWalls)
	{
		_Element.swap(0,1);
		setExecutionLoops(2);
		return;
	}
//endregion
	
	vec01=mWallConnectionType.getVector3d("v01");
	Vector3d vecSide;
	// get pt0Edge and pt1Edge
	Point3d pt0Edge, pt1Edge;
	
	if(bParallel)
	{ 
		// can have 2 sides ref and opp
		if(!_Map.hasVector3d("vecSide"))
		{ 
			// initialise with the property refereing to first wall
			int nSideParallelWalls=sSideParallelWallss.find(sSideParallelWalls);
			Vector3d vSide=esf.vecZ();// reference
			if(nSideParallelWalls==1)vSide*=-1;
			_Map.setVector3d("vecSide",vSide);
		}
		vecSide=_Map.getVector3d("vecSide");
		
	//region Trigger FlipSide
		String sTriggerFlipSide = T("|Flip Side|");
		addRecalcTrigger(_kContextRoot, sTriggerFlipSide );
		if (_bOnRecalc && _kExecuteKey==sTriggerFlipSide)
		{
			_Map.setVector3d("vecSide",-vecSide);
			setExecutionLoops(2);
			return;
		}//endregion
		
		vecDepth=vecSide;
		if(vecSide.dotProduct(vecZ)>0)
		{ 
			// reference
			pt0Edge=mWallConnectionType.getPoint3d("pt0Ref");
			pt1Edge=mWallConnectionType.getPoint3d("pt1Ref");
		}
		else if(vecSide.dotProduct(vecZ)<0)
		{ 
			// opposite side
			pt0Edge=mWallConnectionType.getPoint3d("pt0Opp");
			pt1Edge=mWallConnectionType.getPoint3d("pt1Opp");
		}
		
	}
	else
	{ 
		// vecDepth for 2 corner walls
		vec01=mWallConnectionType.getVector3d("v01");
		vecDepth=mWallConnectionType.getVector3d("vecDepth");
		pt0Edge=mWallConnectionType.getPoint3d("pt0Edge");
		
	}
	
	Vector3d vecDirDistribution=mWallConnectionType.getVector3d("vecDir");
	
	Line lnWallEdge(pt0Edge, vecDirDistribution);
	_Pt0=lnWallEdge.closestPointTo(_Pt0);
	
	
	String sBlockNameFound=getBlockName("TFPC");
	
	Map mInSymbol;
	{ 
		Point3d pts[]={ _Pt0};
		mInSymbol.appendPoint3dArray("pts",pts);
		mInSymbol.setInt("Color", 6);
		Vector3d vxSymbol=vec01;
		Vector3d vzSymbol=-vecDepth;
		Vector3d vySymbol=vzSymbol.crossProduct(vxSymbol);
		mInSymbol.setVector3d("vecX",vxSymbol);
		mInSymbol.setVector3d("vecY",vySymbol);
		mInSymbol.setVector3d("vecZ",vzSymbol);
		mInSymbol.setDouble("Offset",dOffset);
		
		if(sBlockNameFound!="")
		{ 
			mInSymbol.setString("BlockName",sBlockNameFound);
			mInSymbol.setVector3d("vecXb",-vxSymbol);
			mInSymbol.setVector3d("vecYb",vySymbol);
			mInSymbol.setVector3d("vecZb",-vzSymbol);
			
		}
	}
	Map mDrawSymbol=drawSymbolAt2Walls(_Element,mInSymbol);
	
	// hardware
	HardWrComp hwcs[0];
	int nQty=1;
	Map mapHardwares;
	hwcs=applyHardware(mapHardwares,el,el1,_ThisInst,nQty,hwcs);
	if (_bOnDbCreated)	setExecutionLoops(2);				
	_ThisInst.setHardWrComps(hwcs);
	
	
	Map mTextOrientation=getTextOrientation(vecDepth);
	// draw text in plan
	Map mInText;
	{ 
//		mInText.setInt("Qty",nQty);
//		mInText.setString("Product","TFPC");
////		mInText.setInt("Color",7);
//		mInText.setString("Text","TFPC x "+nQty);
		mInText.setString("Text","TFPC");
		mInText.setDouble("TextHeight",dTextHeight);
		mInText.setPoint3d("pt",_Pt0+vecDepth*U(100));
		mInText.setVector3d("vx",mTextOrientation.getVector3d("vx"));
		mInText.setVector3d("vy",mTextOrientation.getVector3d("vy"));
		mInText.setInt("nx",mTextOrientation.getInt("nx"));
		
	}
	displayTextPlan(mInText);
	
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
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="312" />
        <int nm="BreakPoint" vl="569" />
        <int nm="BreakPoint" vl="1367" />
        <int nm="BreakPoint" vl="1365" />
        <int nm="BreakPoint" vl="1212" />
        <int nm="BreakPoint" vl="1292" />
        <int nm="BreakPoint" vl="406" />
        <int nm="BreakPoint" vl="398" />
        <int nm="BreakPoint" vl="411" />
        <int nm="BreakPoint" vl="501" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20922: Fix when getting pt0Edge at &quot;getWallConnectionType&quot;" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="9/6/2024 3:59:00 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20922: Initial" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="6/26/2024 2:26:46 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End