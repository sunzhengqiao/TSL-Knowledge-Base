#Version 8
#BeginDescription
#Versions:
Version 1.5 01/04/2025 HSB-23724: Fix group assignment , Author Marsel Nakuci
Version 1.4 01/04/2025 HSB-23724: Fix position of connector , Author Marsel Nakuci
Version 1.3 20.03.2025 HSB-23724: Add property "Marking"; Add color parameter in xml , Author: Marsel Nakuci
1.2 24/06/2024 HSB-20099: Add tooling (Drill,milling) parameters as instance properties Marsel Nakuci
1.1 21.06.2024 HSB-20099: Add mode distribution at 2 studs Author: Marsel Nakuci
1.0 10.04.2024 HSB-20099: Initial Author: Marsel Nakuci


This tsl creates connectors of type Knapp Walco Z40 and  Z32
Walco Z connectors are identical brackets made out of blue-galvanized steel. 
Commonly used gaskets can be installed on the prefabricated wall panels.
When sliding the wall panels together, the brackets hook into each other in a dovetail-like manner and tighten up the joint. 
The tsl can be inserted at 2 parallel beams
The 2 parallel beams can be part of 2 walls that will be connected
The first selected beam will serve as the main principal beam





#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 5
#KeyWords Connector,concealed,wall,Knapp,Hardware,SF,Stickframe,genbeam
#BeginContents
//region <History>
// #Versions
// 1.5 01/04/2025 HSB-23724: Fix group assignment , Author Marsel Nakuci
// 1.4 01/04/2025 HSB-23724: Fix position of connector , Author Marsel Nakuci
// 1.3 20.03.2025 HSB-23724: Add property "Marking"; Add color parameter in xml , Author: Marsel Nakuci
// 1.2 24/06/2024 HSB-20099: Add tooling (Drill,milling) parameters as instance properties Marsel Nakuci
// 1.1 21.06.2024 HSB-20099: Add mode distribution at 2 studs Author: Marsel Nakuci
// 1.0 10.04.2024 HSB-20099: Initial Author: Marsel Nakuci

/// <insert Lang=en>
/// Select first beam select second parallel beam
/// </insert>

// <summary Lang=en>
// This tsl creates concealed connectors
// It supports Knapp Walco Z40, Z32
// Walco Z connectors are identical brackets made out of blue-galvanized steel. 
// Commonly used gaskets can be installed on the prefabricated wall panels.
// When sliding the wall panels together, the brackets hook into each other in a dovetail-like manner and tighten up the joint. 
// The tsl can be inserted at 2 parallel beams
// The 2 parallel beams can be part of 2 walls that will be connected
// The first selected beam will serve as the main principal beam
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "Knapp")) TSLCONTENT
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
	// some constants
	String kManufacturer="Manufacturer";
	String sBlockPath = _kPathHsbCompany + "\\Block";
//end Constants//endregion
	
//region Functions
//region checkInsertion
// function return flag that tells if valid or not valid
// it verifies that 2 genbeams are needed
// depending on the insertionModus it checks other conditions
// genBeams[] ->input to be checked for verification
// beams[] - > input needed when inserted at 2 beams
Map checkInsertion(GenBeam genBeams[],Beam beams[],int insertionMode)
{ 
	Map m;
	// flag that tells if valid or not valid
	int bValid=true;
	// return message
	String sMsgReturn;
	
	if(genBeams.length()!=2)
	{ 
		sMsgReturn=T("|2 genbeams needed|");
		bValid=false;
		m.setInt("Valid",bValid);
		m.setString("MsgReturn",sMsgReturn);
		return m;
	}
	GenBeam gb0, gb1;
	gb0=genBeams[0];
	gb1=genBeams[1];
	if(!gb0.bIsValid() || !gb1.bIsValid())
	{ 
		sMsgReturn=T("|2 valid genbeams needed|");
		bValid=false;
		m.setInt("Valid",bValid);
		m.setString("MsgReturn",sMsgReturn);
		return m;
	}
	
	if(insertionMode>-1)
	{ 
		// check all cases for different insertion modes
		if(insertionMode==0)
		{ 
			// 2 Studs at stick frame wall
			if(beams.length()!=2)
			{ 
				sMsgReturn=T("|2 beams needed|");
				bValid=false;
				m.setInt("Valid",bValid);
				m.setString("MsgReturn",sMsgReturn);
				return m;
			}
			
			Beam bm0, bm1;
			
			bm0=beams[0];
			bm1=beams[1];
			
//			bm0=(Beam)genBeams[0];
//			bm1=(Beam)genBeams[1];
			
			if(!bm0.bIsValid() || !bm1.bIsValid())
			{ 
				// bm0 or bm1 not valid
				sMsgReturn=T("|2 valid beams needed|");
				bValid=false;
				m.setInt("Valid",bValid);
				m.setString("MsgReturn",sMsgReturn);
				return m;
			}
			// check that beams are parallel
			Vector3d vecX0=bm0.vecX();
			Vector3d vecX1=bm1.vecX();
			if(abs(abs(vecX0.dotProduct(vecX1))-1.0)>dEps)
			{ 
				sMsgReturn=T("|2 beams not parallel|");
				bValid=false;
				m.setInt("Valid",bValid);
				m.setString("MsgReturn",sMsgReturn);
				return m;
			}
			// check that beams belong to 2 connecting walls
			Element el0=bm0.element();
			Element el1=bm1.element();
			if(!el0.bIsValid() || !el1.bIsValid())
			{ 
			// if one the 2 elements not valid
				sMsgReturn=T("|2 beams must belong to 2 SF walls|");
				bValid=false;
				m.setInt("Valid",bValid);
				m.setString("MsgReturn",sMsgReturn);
				return m;
			}
			m.setEntity("el0",el0);
			m.setEntity("el1",el1);
		}
	}
	
	
//	if(genBeams.length()==2)
//	{ 
//		bm0=beams[0];
//		bm1=beams[1];
//	}
//	if(!bm0.bIsValid() || !bm1.bIsValid())
//	{ 
//	// if any not valid
//		sMsgReturn=T("|2 beams needed|");
//		bValid=false;
//	}
	
	
	m.setInt("Valid",bValid);
	m.setString("MsgReturn",sMsgReturn);
	return m;
}
//End checkInsertion//endregion

//region getBlockVectors
// gets the draw vectors of the block
// in order to align it to _vx,_vy,_vz (vecLength,vecWidth,vecDepth) vectors

Map getBlockVectors(Map _min,
	Vector3d _vx,Vector3d _vy,Vector3d _vz)
{ 
	Map _m;
	if(_min.hasString("LengthB") && _min.hasString("WidthB")
				&& _min.hasString("DepthB"))
	{ 
		String sDefs[0];
		sDefs.append(_min.getString("LengthB"));
		sDefs.append(_min.getString("WidthB"));
		sDefs.append(_min.getString("DepthB"));
		// length,width,depth vectors
		Vector3d vectors[]={_vx,_vy,_vz};
		
		// drawing vectors
		Vector3d vx,vy,vz;
		// 
		for (int s=0;s<sDefs.length();s++) 
		{ 
			String sDefS=sDefs[s];
			sDefS.trimLeft();
			sDefS.trimRight();
			if(sDefS=="X")
			{ 
				vx=vectors[s];
			}
			else if(sDefS=="-X")
			{ 
				vx=-vectors[s];
			}
			if(sDefS=="Y")
			{ 
				vy=vectors[s];
			}
			else if(sDefS=="-Y")
			{ 
				vy=-vectors[s];
			}
			if(sDefS=="Z")
			{ 
				vz=vectors[s];
			}
			else if(sDefS=="-Z")
			{ 
				vz=-vectors[s];
			}
		}//next s
		_m.setVector3d("vecX",vx);
		_m.setVector3d("vecy",vy);
		_m.setVector3d("vecZ",vz);
	}
	
	return _m;
}
//End getBlockVectors//endregion 

//region validate2Beams
// This function validates 2 beams for connection
// it checks that they are near enough to be connected
// it return the common planeprofile of the two beams
// it returns the vector of principal beam toward the secondary beam
Map validate2Beams(Beam beams[])
{ 
	Map m;
	// flag that tells if valid or not valid
	int bValid=true;
	// return message
	String sMsgReturn;
	
	if(beams.length()!=2)
	{ 
		bValid=false;
		sMsgReturn=T("|2 Beams needed|");
		m.setInt("Valid",bValid);
		m.setString("MsgReturn",sMsgReturn);
		return m;
	}
	
	// first beam bm0 is the principal beam
	Beam bm0=beams[0];
	Beam bm1=beams[1];
	// second beam will be connected to this beam
	// beam section vectors
	Vector3d vecXbm=bm0.vecX();
	Vector3d vecYbm=bm0.vecY();
	Vector3d vecZbm=bm0.vecZ();
	
	PlaneProfile ppBm0=bm0.realBody().shadowProfile(Plane(bm0.ptCen(),bm0.vecX()));
// get extents of profile for bm0
	LineSeg seg=ppBm0.extentInDir(vecYbm);
	Point3d ptMid=seg.ptMid();
	double dY=abs(vecYbm.dotProduct(seg.ptStart()-seg.ptEnd()));
	double dZ=abs(vecZbm.dotProduct(seg.ptStart()-seg.ptEnd()));
// 2 planeprofiles large in direction Y or Z for the bm0
	PlaneProfile ppY(ppBm0.coordSys());
	PlaneProfile ppZ(ppBm0.coordSys());
	// large in direction of Z
	ppZ.createRectangle(LineSeg(ptMid-.5*dY*vecYbm-U(10e4)*vecZbm,
		ptMid+.5*dY*vecYbm+U(10e4)*vecZbm),vecYbm,vecZbm);
	// large in the direction of Y
	ppY.createRectangle(LineSeg(ptMid-.5*dZ*vecZbm-U(10e4)*vecYbm,
		ptMid+.5*dZ*vecZbm+U(10e4)*vecYbm),vecYbm,vecZbm);
		
	Vector3d vecConnection=vecYbm;
	PlaneProfile ppBm1=bm1.realBody().shadowProfile(Plane(bm1.ptCen(),bm1.vecX()));
	ppBm1.shrink(U(2));
//	ppBm1.vis(3);
//	ppZ.vis(3);
//	ppY.vis(3);
	if(ppY.intersectWith(ppBm1))
	{ 
		vecConnection=vecYbm;
//		vecConnection.vis(bm0.ptCen());
	}
	else if(ppZ.intersectWith(ppBm1))
	{ 
		vecConnection=vecZbm;
//		vecConnection.vis(bm0.ptCen());
	}
	else
	{ 
		// not possible
		bValid=false;
		sMsgReturn=T("|2 Beams can not be connected|");
		m.setInt("Valid",bValid);
		m.setString("MsgReturn",sMsgReturn);
		return m;
	}
	
	// check that the other bem is also oriented in the same direction 
	// get distance between beams
	Vector3d vecConnection1=bm1.vecD(vecConnection);
	
	if(abs(abs(vecConnection.dotProduct(vecConnection1))-1.0)>dEps)
	{ 
	// section orientation is not OK, not parallel
		bValid=false;
		sMsgReturn=T("|2 beams are not properly aligned for connection|");
		m.setInt("Valid",bValid);
		m.setString("MsgReturn",sMsgReturn);
		return m;
	}
	if(vecConnection.dotProduct(bm1.ptCen()-bm0.ptCen())<0)
	{ 
		vecConnection*=-1;
	}
//	vecConnection.vis(bm0.ptCen(),1);
	
	double dW0, dW1;
	dW0=bm0.dD(vecConnection);
	dW1=bm1.dD(vecConnection);
	
	Point3d pt0=bm0.ptCen()+bm0.vecD(vecConnection)*.5*bm0.dD(vecConnection);
	Point3d pt1=bm1.ptCen()-bm1.vecD(vecConnection)*.5*bm1.dD(vecConnection);
//	pt0.vis(6);
//	pt1.vis(2);
	
	double dDist=abs(vecConnection.dotProduct(pt0-pt1));
	if(dDist>U(100))
	{ 
		bValid=false;
		sMsgReturn=T("|2 Beams can not be connected, too far apart|");
		m.setInt("Valid",bValid);
		m.setString("MsgReturn",sMsgReturn);
		return m;
	}
	
	Plane pn (bm0.ptCen()+bm0.vecD(vecConnection)*.5*bm0.dD(vecConnection),vecConnection);
	PlaneProfile pp0=bm0.envelopeBody().shadowProfile(pn);
	PlaneProfile pp1=bm1.envelopeBody().shadowProfile(pn);
	PlaneProfile ppCommon=pp0;
	ppCommon.intersectWith(pp1);
	// pp0 at the middle point
	PlaneProfile pp0Mid(Plane(.5*(pt0+pt1),vecConnection));
//	pp0Mid.unionWith(pp0);
	pp0Mid.unionWith(ppCommon);
//	pp0.vis(6);
	
	// get the distance 
	// point at side in beam 0
	m.setInt("Valid",bValid);
	m.setPoint3d("pt0",pt0);
	// point at side in Beam 1
	m.setPoint3d("pt1",pt1);
	m.setPoint3d("ptMid01",.5*(pt0+pt1));
	// pp of bm0
	m.setPlaneProfile("pp0",pp0);
	m.setPlaneProfile("pp1",pp1);
	m.setPlaneProfile("ppCommon",ppCommon);
	// pp0 at the middle point of 2 planes
	m.setPlaneProfile("pp0Mid",pp0Mid);
	//
	m.setDouble("Dist", dDist);
	
	// depth of the beamcut
	m.setVector3d("vecConnection",vecConnection);// z
	// hight of beamcut
	m.setVector3d("vecLength",bm0.vecX());//x
	// width
	Vector3d vecWidth=vecConnection.crossProduct(bm0.vecX());
	vecWidth.normalize();
	m.setVector3d("vecWidth",vecWidth);//y
	return m;
}
//End validate2Beams//endregion

//region getDistributionPoints
// this function calculates the distribution points at a planeprofile
// pp -> planeProfile
// vecDir -> direction of distribution
// start -> distance at start
// end -> distance at end
// distance - > distance between distribution points. (applies if negative entry of quantity)
// quantity -> quantity, nr of instances
// bFixed -> fixed distribution or equally distributed
Map getDistributionPoints(PlaneProfile pp,Vector3d _vecDir,double start,
	double end, double distance, int quantity, int bFixed, Map _mAddition)
{ 
// get extents of profile
	Map m;
	double _dOffsetBottom=start;
	double _dOffsetTop=end;
	double _dOffsetBetween=distance;
	LineSeg seg=pp.extentInDir(_vecDir);
	
	double dX=abs(_vecDir.dotProduct(seg.ptStart()-seg.ptEnd()));
	Point3d _pt0Start=seg.ptMid()-_vecDir*.5*dX;
	Point3d _pt0End=seg.ptMid()+_vecDir*.5*dX;
	double dLengthTot = (_pt0End - _pt0Start).dotProduct(_vecDir);
	
	String sMsgReturn;
	int bValid=true;
	
	double _dPartLength=0;
	
	Point3d _ptsDis[0];
	
	if (_dOffsetBottom + _dOffsetTop > dLengthTot)
	{ 
		sMsgReturn=T("|Distribution not possible|");
		bValid=false;
		m.setInt("Valid",bValid);
		m.setString("MsgReturn",sMsgReturn);
		return m;
	}
	Vector3d _vecConnection,_vecSide;
	if(_mAddition.hasVector3d("vecConnection"))
	{ 
		_vecConnection=_mAddition.getVector3d("vecConnection");
		_vecSide=_vecConnection.crossProduct(_vecDir);
		
		double _dOffsetZ=_mAddition.getDouble("OffsetZ");// side
		double _dOffsetX=_mAddition.getDouble("OffsetX");// depth
		
		_pt0Start+=_vecConnection*_dOffsetX+_vecSide*_dOffsetZ;
		_pt0End+=_vecConnection*_dOffsetX+_vecSide*_dOffsetZ;
		
	}
	
	
//
	Point3d pt1=_pt0Start+_vecDir*_dOffsetBottom;
	Point3d pt2=_pt0End-_vecDir*(_dOffsetTop+_dPartLength);
	double _dDistTot = (pt2 - pt1).dotProduct(_vecDir);
	if (_dDistTot < 0)
	{ 
		sMsgReturn=T("|Distribution not possible|");
		bValid=false;
		m.setInt("Valid",bValid);
		m.setString("MsgReturn",sMsgReturn);
		return m;
	}
	if(_dOffsetBetween>0 && quantity<=0)
	{ 
		if(!bFixed)
		{ 
			// equally distributed
		
			// distance between is given
			double dDistMod = _dOffsetBetween + _dPartLength;
			int iNrParts = _dDistTot / dDistMod;
			// calculated modular distance between subsequent parts
			
			double dDistModCalc = 0;
			if (iNrParts != 0)
				dDistModCalc = _dDistTot / iNrParts;
			
			// first point
			Point3d pt;
			pt = _pt0Start + _vecDir * (_dOffsetBottom + _dPartLength / 2);
	//				pt.vis(1);
			_ptsDis.append(pt);
			if(dDistModCalc>0)
			{ 
				for (int i = 0; i < iNrParts; i++)
				{ 
					pt += _vecDir * dDistModCalc;
	//					pt.vis(1);
					_ptsDis.append(pt);
				}
			}
		}
		else if(bFixed)
		{ 
			// fixed distance
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
		}
	}
	else if(quantity>0)
	{ 
		// quantity is defined
		double dDistModCalc;
		//
//		int nNrParts = -quantity / 1;
		int nNrParts = quantity / 1;
		if(nNrParts==1)
		{ 
			dDistModCalc = _dOffsetBottom;
			_ptsDis.append(_pt0Start + _vecDir * _dOffsetBottom );
		}
		else
		{ 
			double dDistMod = _dDistTot / (nNrParts - 1);
			dDistModCalc = dDistMod;
			int nNrPartsCalc = nNrParts;
			// clear distance between parts
			double dDistBet = dDistMod - _dPartLength;
			if (dDistBet < 0)
			{ 
				// distance between 2 subsequent parts < 0
				
				dDistModCalc = _dPartLength;
				// nr of parts in between 
				nNrPartsCalc = _dDistTot / dDistModCalc;
				nNrPartsCalc += 1;
			}
			// first point
			Point3d pt;
			pt = _pt0Start + _vecDir * (_dOffsetBottom + _dPartLength / 2);
			_ptsDis.append(pt);
			pt.vis(1);
			for (int i = 0; i < (nNrPartsCalc - 1); i++)
			{ 
				pt += _vecDir * dDistModCalc;
				pt.vis(1);
				_ptsDis.append(pt);
			}//next i
		}
	}
	
	
	m.setPoint3dArray("ptsDis",_ptsDis);
	return m;
}
//End getDistributionPoints//endregion

//region getBodyPart
// this gives back the body at the desired location
// and desired orientation
// pt -> referent position point
// vecLength -> vector in direction of length
// vecWidth -> vector in width direction
// vecDepth -> vector in depth direction
Map getBodyPart(Point3d pt, Vector3d _vecLength,
	Vector3d _vecWidth, Vector3d _vecDepth, String sType)
{ 
	// draw body in _Ptw,_XW,_YW,_ZW
	// then transform to the location
	Map m;
	double dLength, dWidth, dDepth;
	dLength=U(142);
	dWidth=U(40);
	dDepth=U(14.6);
	if(sType=="Z32")
	{ 
		dWidth=U(32);
	}
	
	Body bd(_PtW,_XW,_YW,_ZW,dWidth,dLength,dDepth,0,1,1);
	
//	Point3d ptRef=_PtW-_YW*U(110);
	Point3d ptRef=_PtW+_YW*U(110);
//	_PtW.vis(3);
//	_XW.vis(_PtW, 1);
//	_YW.vis(_PtW, 3);
//	_ZW.vis(_PtW, 5);
////	bd.transformBy(ptRef-_PtW);
//	bd.vis(2);
	
	CoordSys csTransform;
	csTransform.setToAlignCoordSys(ptRef,_XW,_YW,_ZW,
		pt,_vecWidth,_vecLength,_vecDepth);
	bd.transformBy(csTransform);
	bd.vis(6);
	m.setBody("bd",bd);
	return m;
}
//End getBodyPart//endregion

//region getBodies
// reades body parameters as in the xml
// creates the body and positions and aligns it
// ptConn -> center point of the overall connector usually _Pt0
// vecX -> direction vector in length
// vecY -> direction vector in width
// vecZ -> direction vector in depth
// This direction vectors should be provided by the tsl
// and define the alignment of the body

Map getBodies(Map mIn,Point3d ptConn, 
	Vector3d _vecX,Vector3d _vecY, Vector3d _vecZ)
{ 
	Map m;
	for (int g=0;g<mIn.length();g++) 
	{ 
		Map mapG=mIn.getMap(g);
		double dL=mapG.getDouble("Length");
		double dW=mapG.getDouble("Width");
		double dD=mapG.getDouble("Depth");
		
		double dOffsetX=mapG.getDouble("OffsetX");
		double dOffsetY=mapG.getDouble("OffsetY");
		double dOffsetZ=mapG.getDouble("OffsetZ");
		
		int nAlignmentX=mapG.getInt("AlignmentX");
		int nAlignmentY=mapG.getInt("AlignmentY");
		int nAlignmentZ=mapG.getInt("AlignmentZ");
		
		Body bd(_PtW,_XW,_YW,_ZW,dL,dW,dD,0,0,0);
		Point3d ptBd=ptConn+dOffsetX*_vecX+dOffsetY*_vecY+dOffsetZ*_vecZ;
		CoordSys csTransform;
		csTransform.setToAlignCoordSys(_PtW,_XW,_YW,_ZW,
			ptBd, _vecX*nAlignmentX,_vecY*nAlignmentY,_vecZ*nAlignmentZ);
		bd.transformBy(csTransform);
//		bd.vis(6);
		Map mi;
		mi.setBody("bd", bd);
		mi.setString("Name",mapG.getString("Name"));
		// HSB-23724
		if(mapG.hasInt("Color"))
		{ 
			mi.setInt("Color",mapG.getInt("Color"));
		}
		
		// check for block
		String sBlockName;
		int bBlockFound=true;
		if(mapG.hasString("BlockName"))
		{ 
			sBlockName=mapG.getString("BlockName");
			if (_BlockNames.findNoCase(sBlockName ,- 1) < 0)
			{ 
				bBlockFound=false;
				String files[]=getFilesInFolder(sBlockPath);
				String fileName=sBlockName;
				if (files.findNoCase(fileName+".dwg",-1)>-1)
				{
					sBlockName=sBlockPath+"\\" + fileName + ".dwg";
					bBlockFound=true;
				}
			}
		}
		else
		{ 
			bBlockFound=false;
		}
		if(bBlockFound)
		{ 
			mi.setString("BlockName",sBlockName);
			// get the block directionalvectors
			if(mapG.hasString("LengthB") && mapG.hasString("WidthB")
				&& mapG.hasString("DepthB"))
			{ 
				// this definitions shows which direction is defined the block
				// e.g. Length is in YW direction
				Map mBlockVectors=getBlockVectors(mapG,_vecX,_vecY,_vecZ);
				mi.setVector3d("vxBlock",mBlockVectors.getVector3d("vecX"));
				mi.setVector3d("vyBlock",mBlockVectors.getVector3d("vecY"));
				mi.setVector3d("vzBlock",mBlockVectors.getVector3d("vecZ"));
			}
			Point3d _ptBlock=ptConn;
			if(mapG.hasDouble("OffsetLengthB") && mapG.hasDouble("OffsetWidthB")
						&& mapG.hasDouble("OffsetDepthB"))
			{ 
				// this definitions shows which direction is defined the block
				// e.g. Length is in YW direction
				mi.setDouble("OffsetLengthB",mapG.getDouble("OffsetLengthB"));
				mi.setDouble("OffsetWidthB",mapG.getDouble("OffsetWidthB"));
				mi.setDouble("OffsetDepthB",mapG.getDouble("OffsetDepthB"));
				
				_ptBlock+=_vecX*mapG.getDouble("OffsetLengthB")+
							_vecY*mapG.getDouble("OffsetWidthB")+
							_vecZ*mapG.getDouble("OffsetDepthB");
				mi.setPoint3d("ptBlock",_ptBlock);
			}
		}
		mi.setInt("BlockFound", bBlockFound);
		m.appendMap("m", mi);
	}//next g
	return m;
}

//End getBodies//endregion

//region applyTools
// this function applies tools at male gb0 and female gb1
// it takes as input map the map definition from xml
Map applyTools(Map mIn,Map mInProp,Point3d ptConns[], Vector3d vecX,
	Vector3d vecY, Vector3d vecZ,GenBeam _gb0,GenBeam _gb1,Map _mAddition)
{ 
	Map m;
	// HSB-23724
	int _bMarking;
	if(_mAddition.hasInt("Marking"))
	{ 
		_bMarking=_mAddition.getInt("Marking");
	}
	for (int p=0;p<ptConns.length();p++) 
	{ 
		Point3d _ptP=ptConns[p]; 
		for (int i=0;i<mIn.length();i++) 
		{ 
			Map mI=mIn.getMap(i);
			// Male or female
			String sGb=mI.getString("GenBeam");
			
			if(_bMarking)
			{ 
				// HSB-23724
				Vector3d vMark;
				if(sGb=="Male")
				{
					vMark=_gb0.vecD(vecZ);
					Mark mark(_ptP, vMark);
					_gb0.addTool(mark);
				}
				else if(sGb=="Female")
				{ 
					vMark=_gb1.vecD(-vecZ);
					Mark mark(_ptP, vMark);
					_gb1.addTool(mark);
				}
			}
			
			String sToolType=mI.getString("Name");
			if(sToolType=="Drill")
			{ 
				// drill
				double dOffsetX=mI.getDouble("OffsetX");
				double dOffsetY=mI.getDouble("OffsetY");
				double dOffsetZ=mI.getDouble("OffsetZ");
				//
				double dAlignmentX=mI.getDouble("AlignmentX");
				double dAlignmentY=mI.getDouble("AlignmentY");
				double dAlignmentZ=mI.getDouble("AlignmentZ");
				
//				Point3d ptDr=ptConn+dOffsetX*vecX+dOffsetY*vecY+dOffsetZ*vecZ;
				Point3d ptDr=_ptP+dOffsetX*vecX+dOffsetY*vecY+dOffsetZ*vecZ;
				ptDr.vis(3);
				Vector3d vecDr=dAlignmentX*vecX+dAlignmentY*vecY+dAlignmentZ*vecZ;
				vecDr.normalize();
				vecDr.vis(ptDr,3);
				double dDiameter=mI.getDouble("Diameter");
				if(mInProp.hasDouble("DrillDiameterProp"))dDiameter=mInProp.getDouble("DrillDiameterProp");
				double dDepth=mI.getDouble("Depth");
				if(mInProp.hasDouble("DrillDepthProp"))dDepth=mInProp.getDouble("DrillDepthProp");
				Drill dr(ptDr,ptDr+dDepth*vecDr,.5*dDiameter);
				
				dr.cuttingBody().vis(6);
				if(sGb=="Male")
				{ 
					_gb0.addTool(dr);
				}
				else if(sGb=="Female")
				{ 
					_gb1.addTool(dr);
				}
			}
			else if(sToolType=="BeamCut")
			{ 
				double dL=mI.getDouble("Length");
				if(dL==0)dL=U(10e5);
				// 
				double dW=mI.getDouble("Width");
				if(mInProp.hasDouble("MillingWidthProp"))dW=mInProp.getDouble("MillingWidthProp");
				double dD=mI.getDouble("Depth");
				if(mInProp.hasDouble("MillingDepthProp"))dD=mInProp.getDouble("MillingDepthProp");
				
				double dOffsetX=mI.getDouble("OffsetX");
				double dOffsetY=mI.getDouble("OffsetY");
				double dOffsetZ=mI.getDouble("OffsetZ");
				
				int nAlignmentX=mI.getInt("AlignmentX");
				int nAlignmentY=mI.getInt("AlignmentY");
				int nAlignmentZ=mI.getInt("AlignmentZ");
				
				BeamCut bc(_PtW,_XW,_YW,_ZW,dL,dW,dD,0,0,0);
//				Point3d ptBd=ptConn+dOffsetX*vecX+dOffsetY*vecY+dOffsetZ*vecZ;
				Point3d ptBd=_ptP+dOffsetX*vecX+dOffsetY*vecY+dOffsetZ*vecZ;
				CoordSys csTransform;
				csTransform.setToAlignCoordSys(_PtW,_XW,_YW,_ZW,
					ptBd, vecX*nAlignmentX,vecY*nAlignmentY,vecZ*nAlignmentZ);
				bc.transformBy(csTransform);
				bc.cuttingBody().vis(6);
				if(sGb=="Male")
				{ 
					_gb0.addTool(bc);
				}
				else if(sGb=="Female")
				{ 
					_gb1.addTool(bc);
				}
			}	
			 
		}//next i
	}//next p
	
	return m;
}
//End applyTools//endregion 

//region applyHardware
// this function reads the hardware map from the xml
// and applies it as hardware
 
HardWrComp[] applyHardware(Map mIn,GenBeam _gb0,GenBeam _gb1,
	TslInst& thisInst,int _nQty, HardWrComp& hwcs[])
{ 
	Map m;
	HardWrComp hwcs[] = thisInst.hardWrComps();
// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
	for (int i=hwcs.length()-1; i>=0 ; i--) 
		if (hwcs[i].repType() == _kRTTsl)
			hwcs.removeAt(i); 
	for (int i=0;i<mIn.length();i++) 
	{ 
		Map mI=mIn.getMap(i);
		
		int nHWQty=mI.getInt("Quantity");
		if(_nQty>1)nHWQty*=_nQty;
		String sHWArticleNumber=mI.getString("ArticleNumber");
		HardWrComp hwc(sHWArticleNumber, nHWQty); // the articleNumber and the quantity is mandatory
		String sHWManufacturer=mI.getString("Manufacturer");
		hwc.setManufacturer(sHWManufacturer);
		
		String sDesignation=mI.getString("Designation");
		
		
		String sHWGroupName;
		Group groups[]=_gb0.groups();
		hwc.setLinkedEntity(_gb0);
		hwc.setCategory(T("|Connector|"));
		hwc.setRepType(_kRTTsl);
		if(sDesignation=="Female")
		{ 
			groups=_gb1.groups();
			hwc.setLinkedEntity(_gb1);	
		}
		hwc.setGroup(sHWGroupName);
		if (groups.length()>0)	sHWGroupName=groups[0].name();
		
		hwcs.append(hwc);
	}
	return hwcs;
}

//End applyHardware//endregion

//region drawBlock
// this will draw the block representation of the hcwl	
Map drawBlock(Map _min)
{ 
	Display dp(7);
	if(_min.hasInt("Color"))
	{ 
		dp.color(_min.getInt("Color"));
	}
	
	String sBlock;
	if(_min.hasString("BlockName"))
	{ 
		sBlock=_min.getString("BlockName");
	}
	Vector3d _vx=_XW;
	Vector3d _vy=_YW;
	Vector3d _vz=_ZW;
	if(_min.hasVector3d("vx"))
	{ 
		_vx=_min.getVector3d("vx");
	}
	if(_min.hasVector3d("vy"))
	{ 
		_vy=_min.getVector3d("vy");
	}
	if(_min.hasVector3d("vz"))
	{ 
		_vz=_min.getVector3d("vz");
	}
	double _dOffsetY=U(0);
	double _dOffsetZ=U(0);
	if(_min.hasDouble("OffsetY"))
	{
		_dOffsetY=_min.getDouble("OffsetY");
	}
	if(_min.hasDouble("OffsetZ"))
	{
		_dOffsetZ=_min.getDouble("OffsetZ");
	}
	
	Point3d _pts[]=_min.getPoint3dArray("pts");
	Block block(sBlock);
	for (int p=0;p<_pts.length();p++) 
	{ 
//		Point3d _ptBlock=_pts[p]-U(22)*_vy+_vz*_dOffsetY+_dOffsetZ*_vy;
		Point3d _ptBlock=_pts[p]-U(0)*_vy+_vz*_dOffsetY+_dOffsetZ*_vy;
		dp.draw(block,_ptBlock,_vx,_vy,_vz);
	}//next p
}
//End drawBlock//endregion 

//End Functions//endregion

//region Settings
// settings prerequisites
	String sDictionary="hsbTSL";
	String sPath=_kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral=_kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName="CC";
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

//region get sManufacturers from the mapSetting
	String sManufacturers[0];
	Map mapManufacturers = mapSetting.getMap("Manufacturer[]");
	{ 
		// get the products of this family and populate the property list
		
		for (int i = 0; i < mapManufacturers.length(); i++)
		{
			Map mapManufacturerI = mapManufacturers.getMap(i);
			if (mapManufacturerI.hasString("Name") && mapManufacturers.keyAt(i).makeLower() == "manufacturer")
			{
				String sManufacturerName = mapManufacturerI.getString("Name");
				if (sManufacturers.find(sManufacturerName) < 0)
				{
					sManufacturers.append(sManufacturerName);
				}
			}
		}
	}
//End get sManufacturers from the mapSetting//endregion 

//region Properties
	category=T("|Product|");
	String sManufacturerName=T("|Manufacturer|");
	PropString sManufacturer(nStringIndex++, sManufacturers, sManufacturerName);	
	sManufacturer.setDescription(T("|Defines the Manufacturer|"));
	sManufacturer.setCategory(category);
	
	String sProductName=T("|Product|");
	String sProducts[0];
	PropString sProduct(nStringIndex++, sProducts, sProductName);	
	sProduct.setDescription(T("|Defines the Product|"));
	sProduct.setCategory(category);
	// 
	category=T("|General|");
	String sInsertionModeName=T("|Insertion Mode|");
	String sInsertionModes[]={T("|Single Instances at Studs at 2 walls|"),T("|Distribution at Studs at 2 walls|")};
	PropString sInsertionMode(nStringIndex++, sInsertionModes, sInsertionModeName);
	sInsertionMode.setDescription(T("|Defines the Insertion Mode of the connector.|"));
	sInsertionMode.setCategory(category);
	// distribution properties
	category=T("|Distribution|");
	String sQuantityName=T("|Quantity|");	
//	int nQuantitys[]={1,2,3};
	PropInt nQuantity(nIntIndex++, 0, sQuantityName);	
	nQuantity.setDescription(T("|Defines the Quantity|"));
	nQuantity.setCategory(category);
	
	String sDistanceBetweenName=T("|Interdistance|");
	PropDouble dDistanceBetween(nDoubleIndex++, U(500), sDistanceBetweenName);
	dDistanceBetween.setDescription(T("|Defines the distance between the instances.|"));
	dDistanceBetween.setCategory(category);
	
	String sDistanceStartName=T("|Start|");
	PropDouble dDistanceStart(nDoubleIndex++, U(100), sDistanceStartName);
	dDistanceStart.setDescription(T("|Defines the starting distance.|"));
	dDistanceStart.setCategory(category);
	
	String sDistanceEndName=T("|End|");
	PropDouble dDistanceEnd(nDoubleIndex++, U(100), sDistanceEndName);
	dDistanceEnd.setDescription(T("|Defines the ending distance.|"));
	dDistanceEnd.setCategory(category);
	
	String sDistributionModeName=T("|Distribution Mode|");
	String sDistributionModes[]={T("|equally|"), T("|fixed|")};
	PropString sDistributionMode(nStringIndex++, sDistributionModes, sDistributionModeName);
	sDistributionMode.setDescription(T("|Defines the DistributionMode|"));
	sDistributionMode.setCategory(category);
	// tooling
	category = T("|Tooling|");
	// drill
	String sDrillDepthName=T("|Drill Depth|");
	PropDouble dDrillDepth(nDoubleIndex++, U(40), sDrillDepthName);
	dDrillDepth.setDescription(T("|Defines the Drill Depth. Negative value will make use the xml values|"));
	dDrillDepth.setCategory(category);
	
	String sDrillDiameterName=T("|Drill Diameter|");
	PropDouble dDrillDiameter(nDoubleIndex++, U(6), sDrillDiameterName);
	dDrillDiameter.setDescription(T("|Defines the Drill Diameter. Negative value will make use the xml value.|"));
	dDrillDiameter.setCategory(category);
	// milling
	String sMillingWidthName=T("|Milling Width|");
	PropDouble dMillingWidth(nDoubleIndex++, U(45), sMillingWidthName);
	dMillingWidth.setDescription(T("|Defines the Milling Width. Negative value will make use of the xml values.|"));
	dMillingWidth.setCategory(category);
	
	String sMillingDepthName=T("|Milling Depth|");
	PropDouble dMillingDepth(nDoubleIndex++, U(15), sMillingDepthName);
	dMillingDepth.setDescription(T("|Defines the total Milling Depth to accomodate the 2 connectors. Depending on the position of the connector it can be milled none, one or both beams.|"));
	dMillingDepth.setCategory(category);
	
	// position of the connector
	category=T("|Position|");
	// Offsets of the connector
	String sConnectorOffsetZName=T("|Offset|")+" Z";
	PropDouble dConnectorOffsetZ(nDoubleIndex++, U(0), sConnectorOffsetZName);
	dConnectorOffsetZ.setDescription(T("|Defines the Z Offset of the connector in the side direction.|"));
	dConnectorOffsetZ.setCategory(category);
	
	String sConnectorOffsetXName=T("|Offset|")+" X";
	PropDouble dConnectorOffsetX(nDoubleIndex++, U(0), sConnectorOffsetXName);
	dConnectorOffsetX.setDescription(T("|Defines the X Offset of the connector in the depth direction.|"));
	dConnectorOffsetX.setCategory(category);
	// HSB-23724
	category=T("|Marking|");
	String sMarkingName=T("|Marking|");	
	PropString sMarking(nStringIndex++, sNoYes, sMarkingName);	
	sMarking.setDescription(T("|Defines the marking|"));
	sMarking.setCategory(category);
//End Properties//endregion

//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) {eraseInstance();return;}
		
	// get opm key from the _kExecuteKey
		String sTokens[]=_kExecuteKey.tokenize("?");
		String sOpmKey;
		if(sTokens.length()>0)
		{ 
			sOpmKey=sTokens[0];
		}
		else
		{ 
			sOpmKey="";
		}
		
		if (sOpmKey.length() > 0)
		{ 
			String s1=sOpmKey;
			s1.makeUpper();
			int bOk;
			
			for (int i=0;i<sManufacturers.length();i++)
			{
				String s2=sManufacturers[i];
				s2.makeUpper();
				if (s1==s2)
				{
					bOk=true;
					sManufacturer.set(T(sManufacturers[i]));
					setOPMKey(sManufacturers[i]);
					sManufacturer.setReadOnly(true);
					break;
				}
			}//next i
		// the opmKey does not match any family name -> reset
			if (!bOk)
			{
				reportNotice("\n" + scriptName() + ": " + T("|NOTE, the specified OPM key| '") +sOpmKey+T("' |cannot be found in the list of Manufacturers.|"));
				sOpmKey = "";
			}
		}
		else
		{
		// sOpmKey not specified, show the dialog
			sManufacturer.setReadOnly(false);
			sProduct.set("---");
			sProduct.setReadOnly(true);
			
			showDialog("---");
			
		}
		
		if (mapSetting.length() > 0)
		{ 
			
			Map mapManufacturers = mapSetting.getMap("Manufacturer[]");
			if (mapManufacturers.length() < 1)
			{
				// wrong definition of the map
				reportMessage("\n"+scriptName()+" "+T("|wrong definition of the map|"));
				eraseInstance();
				return;
			}
			
			for (int i=0;i<mapManufacturers.length();i++)
			{
				Map mapManufacturerI=mapManufacturers.getMap(i);
				//				if (mapManufacturerI.hasString("Name") && mapManufacturers.keyAt(i).makeLower() == "manufacturer")
				if (mapManufacturers.keyAt(i).makeLower()=="manufacturer")
				{
					//					String sManufacturerName = mapManufacturerI.getString("Name");
					String sManufacturerName=mapManufacturerI.getMapName();
					if (sManufacturerName.makeUpper()!=sManufacturer.makeUpper())
					{
						// not this family, keep looking
						continue;
					}
				}
				else
				{
					// not a manufacturer map
					continue;
				}
				
				// map of the selected manufacturer is found
				// get its families
				Map mapProducts = mapManufacturerI.getMap("Product[]");
				if (mapProducts.length() < 1)
				{
					// wrong definition of the map
					reportMessage("\n"+scriptName()+" "+T("|no product definition for this manufacturer|"));
					eraseInstance();
					return;
				}
				for (int j = 0; j < mapProducts.length(); j++)
				{
					Map mapProductJ = mapProducts.getMap(j);
//					if (mapFamilyJ.hasString("Name") && mapProducts.keyAt(j).makeLower() == "family")
					if (mapProducts.keyAt(j).makeLower() == "product")
					{
//						String sName = mapFamilyJ.getString("Name");
						String sName = mapProductJ.getMapName();
						if (sProducts.find(sName) < 0)
						{
							// populate sFamilies
							sProducts.append(sName);
							if (bDebug)reportMessage("\n" + scriptName() + " sName: " + sName);
						}
					}
				}
			// set the family
				if (sTokens.length() < 2)//family not defined in opmkey, showdialog
				{
					// set array of sproducts and get the first by default
					// manufacturer is set, set as readOnly
					sManufacturer.setReadOnly(true);
					sProduct.setReadOnly(false);
					sProduct=PropString(1,sProducts,sProductName,0);
					
					showDialog();
				}
				else
				{
					int indexSTokens = sProducts.find(sTokens[1]);
					sProduct.set(sTokens[1]);
				}
			}
		}
		
		
		
		
//	// silent/dialog
//		if (_kExecuteKey.length()>0)
//		{
//			String sEntries[]= TslInst().getListOfCatalogNames(scriptName());
//			if (sEntries.findNoCase(_kExecuteKey,-1)>-1)
//				setPropValuesFromCatalog(_kExecuteKey);
//			else
//				setPropValuesFromCatalog(sLastInserted);
//		}
//	// standard dialog
//		else
//			showDialog();
		
		int nInsertionMode=sInsertionModes.find(sInsertionMode);
		
	// create TSL
		TslInst tslNew;	Vector3d vecXTsl=_XW; Vector3d vecYTsl=_YW;
		GenBeam gbsTsl[]={}; Entity entsTsl[]={}; Point3d ptsTsl[]={_Pt0};
		int nProps[]={nQuantity};
		double dProps[]={dDistanceBetween,dDistanceStart,dDistanceEnd,dDrillDepth,dDrillDiameter,
			dMillingWidth,dMillingDepth,dConnectorOffsetZ,dConnectorOffsetX};
		String sProps[]={sManufacturer,sProduct,sInsertionMode,sDistributionMode,
			sMarking};
		Map mapTsl;
		
		if(nInsertionMode==0 || nInsertionMode==1)
		{ 
		// 2 vertical Studs of 2 walls
		// 0-> single instances
		// 1-> distribution
		// prompt 2 studs
			// create single instances at  2 studs of 2 walls
			mapTsl.setInt("mode",0);
			if(nInsertionMode==1)mapTsl.setInt("mode",1);
			
			int bContinue=true;
			while(bContinue)
			{ 
				Beam beams[0];
				PrEntity ssE(T("|Select 2 vertical studs|"), Beam());
				if (ssE.go())
					beams.append(ssE.beamSet());
					
				// check the validity of selection
				if(beams.length()!=2)
				{ 
					bContinue=false;
					break;
				}
				
				// append the two beams
				gbsTsl.setLength(0);
				gbsTsl.append(beams[0]);
				gbsTsl.append(beams[1]);
				
				tslNew.dbCreate(scriptName(),vecXTsl,vecYTsl,gbsTsl,entsTsl,
					ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
			}
		}
		else if(nInsertionMode==2)
		{ 
			// other insertion mode here
		}
		
		return;
	}
// end on insert	__________________//endregion

int nMode=_Map.getInt("mode");
sInsertionMode.setReadOnly(_kHidden);
int bMarking=sNoYes.find(sMarking);// HSB-23724

//int nInsertionMode=sInsertionModes.find(sInsertionMode);
// 2 beams are needed in any case
GenBeam gb0, gb1;
// check validity befor insertion mode
Map mapReturn=checkInsertion(_GenBeam,_Beam,-1);
if(!mapReturn.getInt("Valid"))
{ 
	// not valid
	reportMessage("\n"+scriptName()+" "+mapReturn.getString("MsgReturn"));
	eraseInstance();
	return;
}

//region check properties and dependencies
Map mapManufacturer;
for (int i=0; i<mapManufacturers.length(); i++)
{ 
	Map mapManufacturerI = mapManufacturers.getMap(i);
//		if (mapManufacturerI.hasString("Name") && mapManufacturers.keyAt(i).makeLower() == "manufacturer")
	if (mapManufacturers.keyAt(i).makeLower() == "manufacturer")
	{
//			String sManufacturerName = mapManufacturerI.getString("Name");
		String sManufacturerName = mapManufacturerI.getMapName();
		if (sManufacturerName.makeUpper() != sManufacturer.makeUpper())
		{
			continue;
		}
	}
	else
	{ 
		// not a manufacturer map
		continue;
	}
	
	mapManufacturer = mapManufacturers.getMap(i);
	break;
}
Map mapProduct;
Map mapProducts = mapManufacturer.getMap("Product[]");
sProducts.setLength(0);
for (int i = 0; i < mapProducts.length(); i++)
{
	Map mapProductI = mapProducts.getMap(i);
//		if (mapFamilyI.hasString("Name") && mapFamilies.keyAt(i).makeLower() == "family")
	if (mapProducts.keyAt(i).makeLower() == "product")
	{
//			String sName = mapFamilyI.getString("Name");
		String sName = mapProductI.getMapName();
		if (sProducts.find(sName) < 0)
		{
			// populate sFamilies with all the families of the selected manufacturer
			sProducts.append(sName);
		}
	}
}
int indexProduct = sProducts.find(sProduct);
if (indexProduct >- 1)
{
	// selected sProductis contained in sProducts
	sProduct = PropString(1, sProducts, sProductName, indexProduct);
}
else
{
	// existing sProduct is not found, family has been changed so set 
	// to sProduct the first Product from sProducts
	sProduct= PropString(2, sProducts, sProductName, 0);
	sProduct.set(sProducts[0]);
}

if (mapProducts.length() < 1)
{ 
	// wrong definition of the map
	reportMessage("\n"+scriptName()+" "+T("|wrong definition of the map|"));
	eraseInstance();
	return;
}
for (int i = 0; i < mapProducts.length(); i++)
{
	Map mapProductI = mapProducts.getMap(i);
//		if (mapFamilyI.hasString("Name") && mapFamilies.keyAt(i).makeLower() == "family")
	if (mapProducts.keyAt(i).makeLower() == "product")
	{
//			String sName = mapFamilyI.getString("Name");
		String sName = mapProductI.getMapName();
		if(sName==sProduct)
		{ 
			mapProduct=mapProductI;
			break;
		}
	}
}
//End check properties and dependencies//endregion 

if(nMode==0)
{ 
	// single instances at 2 vertical studs of 2 walls
	Map mapRet=checkInsertion(_GenBeam,_Beam,0);
	
	Beam bm0, bm1;
	bm0=_Beam[0];
	bm1=_Beam[1];
//	_Pt0=bm0.ptCen();
	
	// 
	Entity entEl0=mapRet.getEntity("el0");
	Entity entEl1=mapRet.getEntity("el1");
	Element el0=(Element)entEl0;
	Element el1=(Element)entEl1;
	
	assignToElementGroup(el0,true,0,'E');
//	assignToElementGroup(el0,false);
//	assignToElementGroup(el1,false);
	
	// validate 2 beams and get connecting plane
	Map mapRet1=validate2Beams(_Beam);
	Vector3d vecConnection=mapRet1.getVector3d("vecConnection");
	
	if(!mapRet1.getInt("Valid"))
	{ 
		reportMessage("\n"+scriptName()+" "+mapRet1.getString("MsgReturn"));
		eraseInstance();
		return;
	}
	
	int nDistributionMode=sDistributionModes.find(sDistributionMode);
	int bFixed=nDistributionMode==1;
	
	
	_Pt0=bm0.ptCen();
	_ThisInst.setAllowGripAtPt0(false);
		
// distribution mode
// get distribution points
	Map mDistrAddition;
	{ 
		// additional parameters for the distribution
		mDistrAddition.setDouble("OffsetZ",dConnectorOffsetZ);
		mDistrAddition.setDouble("OffsetX",dConnectorOffsetX);
		mDistrAddition.setVector3d("vecConnection",vecConnection);
	}
	Map mapDistr=getDistributionPoints(mapRet1.getPlaneProfile("pp0"),el0.vecY(),
		dDistanceStart,dDistanceEnd,dDistanceBetween,nQuantity,bFixed,mDistrAddition);
	
	Point3d ptsDis[]=mapDistr.getPoint3dArray("ptsDis");
//		for (int p=0;p<ptsDis.length();p++) 
//		{ 
//			ptsDis[p].vis(6);
//		}//next p
	
// create TSL
	TslInst tslNew;	Vector3d vecXTsl=_XW; Vector3d vecYTsl=_YW;
	GenBeam gbsTsl[]={bm0,bm1}; Entity entsTsl[]={}; Point3d ptsTsl[]={_Pt0};
	int nProps[]={nQuantity};
	double dProps[]={dDistanceBetween,dDistanceStart,dDistanceEnd,dDrillDepth,dDrillDiameter,
		dMillingWidth,dMillingDepth,dConnectorOffsetZ,dConnectorOffsetX};
	String sProps[]={sManufacturer,sProduct,sInsertionMode,sDistributionMode,
		sMarking};
	Map mapTsl;
	
	mapTsl.setInt("mode",101);
	
	for (int p=0;p<ptsDis.length();p++) 
	{ 
		ptsTsl[0]=ptsDis[p];
		tslNew.dbCreate(scriptName(),vecXTsl,vecYTsl,gbsTsl,entsTsl,
			ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
			
	}//next p
	eraseInstance();
	return;
	
}
else if(nMode==1)
{ 
	// distribution at studs
	Map mapRet=checkInsertion(_GenBeam,_Beam,0);
	
	Beam bm0, bm1;
	bm0=_Beam[0];
	bm1=_Beam[1];
//	_Pt0=bm0.ptCen();
	// 
	Entity entEl0=mapRet.getEntity("el0");
	Entity entEl1=mapRet.getEntity("el1");
	Element el0=(Element)entEl0;
	Element el1=(Element)entEl1;
	
	assignToElementGroup(el0,true,0,'E');
//	assignToElementGroup(el0,false);
//	assignToElementGroup(el1,false);
	
	// validate 2 beams and get connecting plane
	Map mapRet1=validate2Beams(_Beam);
	
	PlaneProfile pp0_=mapRet1.getPlaneProfile("pp0");
	pp0_.vis(6);
	
	if(!mapRet1.getInt("Valid"))
	{ 
		reportMessage("\n"+scriptName()+" "+mapRet1.getString("MsgReturn"));
		eraseInstance();
		return;
	}
	
	int nDistributionMode=sDistributionModes.find(sDistributionMode);
	int bFixed=nDistributionMode==1;
	
	_Pt0=bm0.ptCen();
	_ThisInst.setAllowGripAtPt0(false);
	Vector3d vecConnection=mapRet1.getVector3d("vecConnection");
// distribution mode
// get distribution points
	Map mDistrAddition;
	{ 
		// additional parameters for the distribution
		mDistrAddition.setDouble("OffsetZ",dConnectorOffsetZ);
		mDistrAddition.setDouble("OffsetX",dConnectorOffsetX);
		mDistrAddition.setVector3d("vecConnection",vecConnection);
	}
	Map mapDistr=getDistributionPoints(mapRet1.getPlaneProfile("pp0Mid"),el0.vecY(),
		dDistanceStart,dDistanceEnd,dDistanceBetween,nQuantity,bFixed,mDistrAddition);
	
	Point3d ptsDis[]=mapDistr.getPoint3dArray("ptsDis");
	
	for (int p=0;p<ptsDis.length();p++) 
	{ 
		ptsDis[p].vis(1);
		 
	}//next p
	// set dependencies with _Entity
	for (int e=0;e<_Entity.length();e++) 
	{ 
		setDependencyOnEntity(_Entity[e]);
	}//next e
	
	Map mapGeometries=mapProduct.getMap("Geometry[]");
	Map mapTools=mapProduct.getMap("Tool[]");
	Map mapHardwares=mapProduct.getMap("Hardware[]");
	// distribution
	// Display object
	Display dp0(3);
	dp0.elemZone(el0,0,'T');
	Display dp1(1);
	dp1.elemZone(el1,0,'T');
	
	PlaneProfile pp0=mapRet1.getPlaneProfile("pp0");
	// pointng from male to female
	
	vecConnection.vis(_Pt0);
	Point3d ptM=.5*(mapRet1.getPoint3d("pt0")+mapRet1.getPoint3d("pt1"));
	_Pt0+=vecConnection*vecConnection.dotProduct(ptM-_Pt0);
	pp0.vis(6);
	_Pt0.vis(6);
	
	//region Trigger SwapConnectors
	String sTriggerSwapConnectors = T("|Swap Connectors|");
	addRecalcTrigger(_kContextRoot, sTriggerSwapConnectors );
	if (_bOnRecalc && _kExecuteKey==sTriggerSwapConnectors)
	{
		_Beam.swap(0, 1);
		if(dConnectorOffsetZ!=0)
		{ 
			dConnectorOffsetZ.set(-dConnectorOffsetZ);
		}
		if(dConnectorOffsetX!=0)
		{ 
			dConnectorOffsetX.set(-dConnectorOffsetX);
		}
		setExecutionLoops(2);
		return;
	}
	//endregion	
	
	
	Point3d ptConnector=_Pt0;
	Vector3d vecWidth=mapRet1.getVector3d("vecWidth");
	Vector3d vecLength=mapRet1.getVector3d("vecLength");
	// we need the dp0 here
	for (int p=0;p<ptsDis.length();p++) 
	{ 
		Point3d ptP=ptsDis[p]; 
		Map mpBodies=getBodies(mapGeometries,ptP,vecLength,
		vecWidth,vecConnection);
		
		vecLength.vis(_Pt0);
		vecWidth.vis(_Pt0);
		vecConnection.vis(_Pt0);
			
		for (int m=0;m<mpBodies.length();m++) 
		{ 
			Map mi=mpBodies.getMap(m);
			Body bd=mi.getBody("bd");
			if(mi.getString("Name")=="Male")
			{ 
	//			dp0.draw(bd);
				if(mi.hasInt("Color"))
				{ 
					dp0.color(mi.getInt("Color"));
				}
				if(mi.hasString("BlockName") && mi.getInt("BlockFound"))
				{ 
					Point3d ptBlock=ptP;
					if(mi.hasPoint3d("ptBlock"))ptBlock=mi.getPoint3d("ptBlock");
					String sBlockName=mi.getString("BlockName");
					Block block(sBlockName);
					dp0.draw(block,ptBlock,
						mi.getVector3d("vxBlock"),mi.getVector3d("vyBlock"),
						mi.getVector3d("vzBlock"));
				}
				else
				{
					dp0.draw(bd);
				}
			}
			else if(mi.getString("Name")=="Female")
			{ 
	//			dp1.draw(bd);
				if(mi.hasInt("Color"))
				{ 
					dp1.color(mi.getInt("Color"));
				}
				if(mi.hasString("BlockName") && mi.getInt("BlockFound"))
				{ 
					Point3d ptBlock=ptConnector;
					if(mi.hasPoint3d("ptBlock"))ptBlock=mi.getPoint3d("ptBlock");
					String sBlockName=mi.getString("BlockName");
					Block block(sBlockName);
					dp1.draw(block,ptBlock,
						mi.getVector3d("vxBlock"),mi.getVector3d("vyBlock"),
						mi.getVector3d("vzBlock"));
				}
				else
				{
					dp1.draw(bd);
				}
			}
		}//next m
	}//next p
	
	
	//region Trigger ReiheAufloesen
//	String sTriggerReiheAufloesen = "Reihe auflösen";
	String sTriggerReiheAufloesen =T("|Explode distribution|");
	addRecalcTrigger(_kContextRoot, sTriggerReiheAufloesen );
	if (_bOnRecalc && _kExecuteKey==sTriggerReiheAufloesen)
	{
		
	// create TSL
		TslInst tslNew; Vector3d vecXTsl=_XW; Vector3d vecYTsl=_YW;
		GenBeam gbsTsl[2]; Entity entsTsl[]={}; Point3d ptsTsl[]={_Pt0};
		int nProps[]={};
		double dProps[]={dDistanceBetween,dDistanceStart,dDistanceEnd,dDrillDepth,dDrillDiameter,
			dMillingWidth,dMillingDepth,dConnectorOffsetZ,dConnectorOffsetX};
		String sProps[]={sManufacturer,sProduct,sInsertionMode,sDistributionMode,
			sMarking};
		Map mapTsl;
		
		// 2 beams
		gbsTsl[0]=bm0;
		gbsTsl[1]=bm1;
		// mapTsl
		// single instances at 2 studs
		mapTsl.setInt("mode",101);
		
		for (int p=0;p<ptsDis.length();p++) 
		{ 
			ptsTsl[0]=ptsDis[p]; 
			
			tslNew.dbCreate(scriptName(),vecXTsl,vecYTsl,gbsTsl,entsTsl,
				ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
		}//next p
		
		eraseInstance();
		return;
	}//endregion
	
	gb0 = _GenBeam[0];// male
	gb1 = _GenBeam[1];// female
	ptConnector.vis(3);
	gb0.envelopeBody().vis(1);
//	Point3d ptTools[]={ptConnector};
	Point3d ptTools[]=ptsDis;
	// the tool parameters from the properties
	Map mapToolsProperty;
	if(dDrillDepth>=0)mapToolsProperty.setDouble("DrillDepthProp",dDrillDepth);
	if(dDrillDiameter>=0)mapToolsProperty.setDouble("DrillDiameterProp",dDrillDiameter);
	if(dMillingWidth>=0)mapToolsProperty.setDouble("MillingWidthProp",dMillingWidth);
	if(dMillingDepth>=0)mapToolsProperty.setDouble("MillingDepthProp",dMillingDepth);
	Map mAdditionTools;
	mAdditionTools.setInt("Marking",bMarking);
	Map mapT=applyTools(mapTools,mapToolsProperty,ptTools,vecLength,
		vecWidth,vecConnection, gb0,gb1,mAdditionTools);
	HardWrComp hwcs[0];
	int nQty=ptsDis.length();
	hwcs=applyHardware(mapHardwares,gb0,gb1,_ThisInst,nQty,hwcs);
	
	if (_bOnDbCreated)	setExecutionLoops(2);				
	_ThisInst.setHardWrComps(hwcs);
	
	return;
}
if(nMode==101)
{ 
	// single instane, mo distribution
	sInsertionMode.setReadOnly(_kHidden);
	nQuantity.setReadOnly(_kHidden);
	dDistanceBetween.setReadOnly(_kHidden);
	dDistanceStart.setReadOnly(_kHidden);
	dDistanceEnd.setReadOnly(_kHidden);
	sDistributionMode.setReadOnly(_kHidden);
	// single instances at 2 vertical studs at 2 walls
	
	// hide distribution properties
	// check the 2 beams
	Map mapRet=checkInsertion(_GenBeam,_Beam,0);
	
	Beam bm0, bm1;
	bm0=_Beam[0];
	bm1=_Beam[1];
//	_Pt0=bm0.ptCen();
	
	// 
	Entity entEl0=mapRet.getEntity("el0");
	Entity entEl1=mapRet.getEntity("el1");
	Element el0=(Element)entEl0;
	Element el1=(Element)entEl1;
	
	assignToElementGroup(el0,true,0,'E');
//	assignToElementGroup(el0,false);
//	assignToElementGroup(el1,false);
	
	// validate 2 beams and get connecting plane
	Map mapRet1=validate2Beams(_Beam);
	
	if(!mapRet1.getInt("Valid"))
	{ 
		reportMessage("\n"+scriptName()+" "+mapRet1.getString("MsgReturn"));
		eraseInstance();
		return;
	}
	// set dependencies with _Entity
	for (int e=0;e<_Entity.length();e++) 
	{ 
		setDependencyOnEntity(_Entity[e]);
	}//next e
	
	int nDistributionMode=sDistributionModes.find(sDistributionMode);
	int bFixed=nDistributionMode==1;
	// get distribution points
//	int nMode=_Map.getInt("mode");
	
	Map mapGeometries=mapProduct.getMap("Geometry[]");
	Map mapTools=mapProduct.getMap("Tool[]");
	Map mapHardwares=mapProduct.getMap("Hardware[]");
	// distribution
	// Display object
	Display dp0(3);
	dp0.elemZone(el0,0,'T');
	Display dp1(1);
	dp1.elemZone(el1,0,'T');
	// single instance
	// bm0 is the male beam
	// bm1 is the female beam where the milling is done
	// beamcut
	Vector3d vecWidth=mapRet1.getVector3d("vecWidth");
	Vector3d vecLength=mapRet1.getVector3d("vecLength");
	PlaneProfile pp0=mapRet1.getPlaneProfile("pp0");
	// pointng from male to female
	Vector3d vecConnection=mapRet1.getVector3d("vecConnection");
	vecConnection.vis(_Pt0);
//	Point3d ptM=.5*(mapRet1.getPoint3d("pt0")+mapRet1.getPoint3d("pt1"));
	Point3d ptM=mapRet1.getPlaneProfile("pp0Mid").extentInDir(vecConnection).ptMid();
	_Pt0+=vecConnection*vecConnection.dotProduct(ptM-_Pt0);
	_Pt0+=vecWidth*vecWidth.dotProduct(ptM-_Pt0);
	pp0.vis(6);
	_Pt0.vis(6);
//	_ThisInst.setAllowGripAtPt0(false);
	
//region Trigger SwapConnectors
	String sTriggerSwapConnectors = T("|Swap Connectors|");
	addRecalcTrigger(_kContextRoot, sTriggerSwapConnectors );
	if (_bOnRecalc && _kExecuteKey==sTriggerSwapConnectors)
	{
		_Beam.swap(0, 1);
		if(dConnectorOffsetZ!=0)
		{ 
			dConnectorOffsetZ.set(-dConnectorOffsetZ);
		}
		if(dConnectorOffsetX!=0)
		{ 
			dConnectorOffsetX.set(-dConnectorOffsetX);
		}
		setExecutionLoops(2);
		return;
	}
//endregion	
	
	Point3d ptConnector=_Pt0;
	
	
	// consider the Offset Z,X 
	ptConnector+=vecConnection*dConnectorOffsetX+vecWidth*dConnectorOffsetZ;
	
	// draw bodies
	Map mpBodies=getBodies(mapGeometries,ptConnector,vecLength,
		vecWidth,vecConnection);
		
	vecLength.vis(_Pt0);
	vecWidth.vis(_Pt0);
	vecConnection.vis(_Pt0);
		
	for (int m=0;m<mpBodies.length();m++) 
	{ 
		Map mi=mpBodies.getMap(m);
		Body bd=mi.getBody("bd");
		if(mi.getString("Name")=="Male")
		{ 
//			dp0.draw(bd);

			if(mi.hasString("BlockName") && mi.getInt("BlockFound"))
			{ 
				Point3d ptBlock=ptConnector;
				if(mi.hasPoint3d("ptBlock"))ptBlock=mi.getPoint3d("ptBlock");
				String sBlockName=mi.getString("BlockName");
				Block block(sBlockName);
				dp0.draw(block,ptBlock,
					mi.getVector3d("vxBlock"),mi.getVector3d("vyBlock"),
					mi.getVector3d("vzBlock"));
			}
			else
			{
				dp0.draw(bd);
			}
		}
		else if(mi.getString("Name")=="Female")
		{ 
//			dp1.draw(bd);
			if(mi.hasString("BlockName") && mi.getInt("BlockFound"))
			{ 
				Point3d ptBlock=ptConnector;
				if(mi.hasPoint3d("ptBlock"))ptBlock=mi.getPoint3d("ptBlock");
				String sBlockName=mi.getString("BlockName");
				Block block(sBlockName);
				dp1.draw(block,ptBlock,
					mi.getVector3d("vxBlock"),mi.getVector3d("vyBlock"),
					mi.getVector3d("vzBlock"));
			}
//			if(mi.hasString("BlockName"))
//			{ 
//				// draw block
//				Map minBlock;
//				{ 
//					Point3d ptBlock=ptConnector;
//					if(mi.hasDouble("OffsetLengthB") && mi.hasDouble("OffsetWidthB")
//						&& mi.hasDouble("OffsetDepthB"))
//					{ 
//						ptBlock+=vecLength*mi.getDouble("OffsetLengthB")+
//							vecWidth*mi.getDouble("OffsetWidthB")+
//							vecConnection*mi.getDouble("OffsetDepthB");
//					}
//					Point3d pts[]={ptBlock};
//					minBlock.setPoint3dArray("pts",pts);
//					
//					if(mi.hasVector3d("vxBlock") && mi.hasVector3d("vyBlock")
//						&& mi.hasVector3d("vzBlock"))
//					{ 
//						minBlock.setVector3d("vx",mi.getVector3d("vxBlock"));
//						minBlock.setVector3d("vy",mi.getVector3d("vyBlock"));
//						minBlock.setVector3d("vz",mi.getVector3d("vzBlock"));
//					}
//					
//					String sBlockName=mi.getString("BlockName");
//					minBlock.setString("BlockName",sBlockName);
//					// 
//					Block block(sBlockName);
//					dp1.draw(block,ptBlock,
//						mi.getVector3d("vxBlock"),mi.getVector3d("vyBlock"),
//						mi.getVector3d("vzBlock"));
//				}
////				Map mDrawBlock=drawBlock(minBlock);
//				
//			}
			else
			{
				dp1.draw(bd);
			}
		}
	}//next m
	
//	return;
	gb0 = _GenBeam[0];// male
	gb1 = _GenBeam[1];// female
	ptConnector.vis(3);
	gb0.envelopeBody().vis(1);
	Point3d ptTools[]={ptConnector};
	Map mapToolsProperty;
	if(dDrillDepth>=0)mapToolsProperty.setDouble("DrillDepthProp",dDrillDepth);
	if(dDrillDiameter>=0)mapToolsProperty.setDouble("DrillDiameterProp",dDrillDiameter);
	if(dMillingWidth>=0)mapToolsProperty.setDouble("MillingWidthProp",dMillingWidth);
	if(dMillingDepth>=0)mapToolsProperty.setDouble("MillingDepthProp",dMillingDepth);
	Map mAdditionTools;
	mAdditionTools.setInt("Marking",bMarking);
	Map mapT=applyTools(mapTools,mapToolsProperty,ptTools,vecLength,
		vecWidth,vecConnection, gb0,gb1,mAdditionTools);
	
	HardWrComp hwcs[0];
	int nQty=1;
	hwcs=applyHardware(mapHardwares,gb0,gb1,_ThisInst,nQty,hwcs);
	
	if (_bOnDbCreated)	setExecutionLoops(2);				
	_ThisInst.setHardWrComps(hwcs);	
	
	return;
//	Body bd0, bd1;
	
	Point3d ptBc=mapRet1.getPoint3d("pt1");
	Point3d pt0=mapRet1.getPoint3d("pt0");
//	ptBc+=vecWidth*vecWidth.dotProduct(pt0-ptBc);
	ptBc+=vecWidth*vecWidth.dotProduct(ptConnector-ptBc);
	
	BeamCut bc(ptBc,mapRet1.getVector3d("vecLength"),
		mapRet1.getVector3d("vecWidth"),
		mapRet1.getVector3d("vecConnection"),
		U(10e4),U(40),U(15), 0,0,1);
//	bc.cuttingBody().vis(3);
	ptBc.vis(1);
//	bd0=Body(ptBc,mapRet1.getVector3d("vecLength"),
//		mapRet1.getVector3d("vecWidth"),
//		mapRet1.getVector3d("vecConnection"),
//		U(10e4),U(40),U(15), 0,0,1);
//	bd0.vis(1);
	
//	vecLength.vis(_Pt0, 1);
//	vecWidth.vis(_Pt0, 3);
//	vecConnection.vis(_Pt0, 5);
	
	bm1.addTool(bc);
	// drills at female
	Point3d ptDr=ptBc-U(8)*el0.vecY();
	ptDr+=el0.vecY()*el0.vecY().dotProduct(_Pt0-ptDr);
	Drill dr(ptDr,ptDr+vecConnection*U(50),U(3));
	dr.cuttingBody().vis(1);
//	bm1.addTool(dr);
	ptDr.vis(3);
//	Map mapBd1=getBodyPart(ptDr,vecLength,vecWidth,vecConnection,"Z40");
//	bd1=mapBd1.getBody("bd");
//	bd1.vis(3);
//	dp1.draw(bd1);
	ptDr-=el0.vecY()*U(90);
	dr=Drill (ptDr,ptDr+vecConnection*U(50),U(3));
//	bm1.addTool(dr);
	// drills at male
	ptDr=ptBc+U(8)*el0.vecY();
	ptDr+=el0.vecY()*el0.vecY().dotProduct(_Pt0-ptDr);
	ptDr+=vecConnection*vecConnection.dotProduct(pt0-ptDr);
	dr=Drill (ptDr,ptDr-vecConnection*U(50),U(3));
//	bm0.addTool(dr);
//	Map mapBd0=getBodyPart(ptDr+vecConnection*U(14.6),-vecLength,vecWidth,-vecConnection,"Z40");
//	bd0=mapBd0.getBody("bd");
//	bd0.vis(1);
//	dp0.draw(bd0);
	
	ptDr+=el0.vecY()*U(90);
	dr=Drill (ptDr,ptDr-vecConnection*U(50),U(3));
//	bm0.addTool(dr);
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
        <int nm="BreakPoint" vl="768" />
        <int nm="BreakPoint" vl="849" />
        <int nm="BreakPoint" vl="1819" />
        <int nm="BreakPoint" vl="663" />
        <int nm="BreakPoint" vl="1803" />
        <int nm="BreakPoint" vl="1804" />
        <int nm="BreakPoint" vl="1814" />
        <int nm="BreakPoint" vl="1811" />
        <int nm="BreakPoint" vl="745" />
        <int nm="BreakPoint" vl="1784" />
        <int nm="BreakPoint" vl="1665" />
        <int nm="BreakPoint" vl="1664" />
        <int nm="BreakPoint" vl="709" />
        <int nm="BreakPoint" vl="1371" />
        <int nm="BreakPoint" vl="1683" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23724: Fix group assignment" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="4/1/2025 3:36:12 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23724: Fix position of connector" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="4/1/2025 2:06:00 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23724: Add property &quot;Marking&quot;; Add color parameter in xml" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="3/20/2025 10:36:08 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-20099: Add tooling (Drill,milling) parameters as instance properties" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="6/24/2024 11:42:33 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-20099: Add mode distribution at 2 studs" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="6/21/2024 1:20:54 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-20099: Initial" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="4/10/2024 9:16:30 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End