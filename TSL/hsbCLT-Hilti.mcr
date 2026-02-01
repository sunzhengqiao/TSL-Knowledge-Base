#Version 8
#BeginDescription
#Versions:
Version 1.10 30.10.2025 HSB-24843: Fix to allow insertion at multiple female-male connections , Author: Marsel Nakuci
1.9 12.12.2024 HSB-19771: Added missing hanger bolt Autor Nils Gregor
1.8 10.12.2024 HSB-19771: Changed Tsl to the requirements of Hilti Autor Nils Gregor
1.7 29.11.2024 20241129: Fix when drawing symbol Author: Marsel Nakuci
Version 1.6 08.10.2024 HSB-19771: Change TSL image , Author Marsel Nakuci
Version 1.5 24.09.2024 HSB-19771: Fix drilling position (apply Z-offset) for the hanger bolt/Concrete fastener (Stockschraube/Bolzenanker) , Author Marsel Nakuci
Version 1.4 20.09.2024 HSB-19771: Fix when identifying male and female panel , Author Marsel Nakuci
1.3 13.09.2024 HSB-19771: Fix when calculating the distribution line of a male-female panel Author: Marsel Nakuci
1.2 22/08/2024 HSB-19771: Enable insertion of one sigle connector by point Marsel Nakuci
1.1 19/06/2024 HSB-22250: Initial: Add block display of the connectors Marsel Nakuci
1.0 18/06/2024 HSB-22250: Initial Marsel Nakuci


This TSL inserts a HCW-L connection between two panels or a panel and a concrete floor

It can be inserted to connect two (male-female) panels HCWL-HSW
The Wood coupler HCWL will sit at the male panel
and the Hanger bolt HSW will sit at the female panel 

It can also be inserted at single panels 
e.g. wall panels that will be connected with the concrete floor
In this case the HCWL will sit at the panel and the 







#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 10
#KeyWords 
#BeginContents
//region <History>
// #Versions
// 1.10 30.10.2025 HSB-24843: Fix to allow insertion at multiple female-male connections , Author: Marsel Nakuci
// 1.9 12.12.2024 HSB-19771: Added missing hanger bolt Autor Nils Gregor
// 1.8 10.12.2024 HSB-19771: Changed Tsl to the requirements of Hilti Autor Nils Gregor
// 1.7 29.11.2024 20241129: Fix when drawing symbol Author: Marsel Nakuci
// 1.6 08.10.2024 HSB-19771: Change TSL image , Author Marsel Nakuci
// 1.5 24.09.2024 HSB-19771: Fix drilling position (apply Z-offset) for the hanger bolt/Concrete fastener (Stockschraube/Bolzenanker) , Author Marsel Nakuci
// 1.4 20.09.2024 HSB-19771: Fix when identifying male and female panel at "distinguishMaleFemaleFrom2Sips" , Author Marsel Nakuci
// 1.3 13.09.2024 HSB-19771: Fix when calculating the distribution line of a male-female panel Author: Marsel Nakuci
// 1.2 22/08/2024 HSB-19771: Enable insertion of one sigle connector by point Marsel Nakuci
// 1.1 19/06/2024 HSB-22250: Initial: Add block display of the connectors Marsel Nakuci
// 1.0 18/06/2024 HSB-22250: Initial Marsel Nakuci

/// <insert Lang=en>
/// Select entities
/// </insert>

// <summary Lang=en>
// This tsl connects panels with Hilti HCWL connector
// Connectors are used to connect 2 perpendicular panels
// The 2 panels can be both vertical or one horizontal and the other vertical
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCLT-Hilti")) TSLCONTENT
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
	String sBlockName="HCWL";
	String sBlockPath = _kPathHsbCompany + "\\Block";
	int bBlockFound=true;
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
	
	double dFlushExtraGap= U(9.1);
	double dOffsetZ;
//end Constants//endregion

//region Functions
	
	void visBd(Body _bd, Vector3d _vec)
	{ 
		_bd.transformBy(_vec);
		_bd.vis(6);
		_bd.transformBy(-_vec);
		return;
	}
	
//region cleanUpPline
	// this function will clean plines
	// it will remove points inside a line
	// it will leave only the corner points of a pline
	Map cleanUpPline(PLine plIn)
	{ 
		Map _m;
//		Point3d pts[]=plIn.vertexPoints(false);
		Point3d pts[]=plIn.vertexPoints(true);
		CoordSys csPl=plIn.coordSys();
		PLine plOut;
		
		if(pts.length()<3)
		{ 
			_m.setPLine("pl",plIn);
			return _m;
		}
		
		Point3d ptsAddition[0];  
		Point3d ptsFinal[0];  
		int nIndicesAdd[0];
		int nAdditionalPoints;
		if(pts.length()>2)
		{ 
			nAdditionalPoints=pts.length()-2;
		}
		for (int p=0;p<pts.length()-2+nAdditionalPoints;p++) 
		{ 
			int nIndp=p;
			if(p>pts.length()-1)
			{
				nIndp=p-(pts.length());
			}
			if(nIndicesAdd.find(nIndp)>-1)
			{ 
				// point already removed
				continue;
			}
			// point 0
			Point3d ptP=pts[nIndp];
			// vec01
			Vector3d vecDirP;
			Line lnp;
			for (int j=p+1;j<pts.length()+nAdditionalPoints;j++) 
			{ 
				int nIndj=j;
				int nIndjPrev=j-1;
				if(nIndj>pts.length()-1)
				{
					nIndj=j-(pts.length());
				}
				if(nIndjPrev>pts.length()-1)
				{
					nIndjPrev=(j-1)-(pts.length());
				}

				if(nIndicesAdd.find(nIndjPrev)>-1)
				{ 
					continue;
				}
				Point3d ptJ=pts[nIndj];
				lnp=Line(.5*(ptP+ptJ),vecDirP);
				if(j==p+1)
				{ 
					// point 1
					vecDirP=ptJ-ptP;// last with first
					vecDirP.normalize();// vector 01
				}
				else
				{ 
					Vector3d vecDirJ=ptJ-ptP;// last with 0
					vecDirJ.normalize();
					Vector3d vecDirJ1=ptJ-pts[nIndjPrev];// last with previous
					vecDirJ1.normalize();
					if(abs(abs(vecDirP.dotProduct(vecDirJ))-1.0)<.1*dEps
					&& abs(abs(vecDirP.dotProduct(vecDirJ1))-1.0)<.1*dEps)
					{
						// parallel 0-1 is parallel to 0-last and 01 is parallel to previous-last (check to remove previous)
						// HSB-22319
						// do the distance from line check
						// the vector direction not very accurate
						Point3d ptAtLine=lnp.closestPointTo(pts[nIndjPrev]);
						if((ptAtLine-pts[nIndjPrev]).length()<U(1))
						{ 
//							ptAtLine.vis(6);
//							lnp.vis(2);
							// parallel
							ptsAddition.append(pts[nIndjPrev]);
							nIndicesAdd.append(nIndjPrev);
						}
					}
					else
					{ 
						
						// new direction
						break;
					}
				}
			}//next j
		}//next p
		
		for (int p=0;p<pts.length();p++) 
		{ 
			if(nIndicesAdd.find(p)<0)
			{
				ptsFinal.append(pts[p]); 
			}
		}//next p
		ptsFinal.append(ptsFinal[0]);
		
		for (int p=0;p<ptsFinal.length();p++) 
		{ 
			Point3d ptFinal=ptsFinal[p];
			ptFinal.vis(6); 
		}//next p
		
		if(ptsAddition.length()>0)
		{ 
			// addition points found
			plOut=PLine(csPl.vecZ());
			for (int p=0;p<ptsFinal.length();p++) 
			{ 
				plOut.addVertex(ptsFinal[p]);
			}//next p
			_m.setPoint3dArray("ptsAddition",ptsAddition);
		}
		else
		{ 
			plOut=plIn;
		}
		
		_m.setPLine("pl",plOut);
		return _m;
//		return plOut;
	}
//End cleanUpPline//endregion
	
//region distinguishMaleFemaleFrom2Sips
// this routine will find which panel is the male and
// which one is the female
	Map distinguishMaleFemaleFrom2Sips(Sip _sips[])
	{ 
		// this will return which is the male and which is the female
		// between 2 panels
		Map _m;
		
		if(_sips.length()!=2)
		{ 
			return _m;
		}
		
		Sip _sipMale=_sips[0];
		Sip _sipFemale=_sips[1];
		
		Vector3d vecZmale=_sipMale.vecZ();
		Vector3d vecZfemale=_sipFemale.vecZ();
		
		if(!vecZmale.isPerpendicularTo(vecZfemale))
		{ 
			// not parallel
			_m.setInt("Error",true);
			return _m;
		}
		double dAllowedGap=U(50);
		// projected in vecZmale they must have a gap
		Plane pn(_sipMale.ptCen(), vecZmale);
		PlaneProfile ppMale=_sipMale.envelopeBody().shadowProfile(pn);
		PlaneProfile ppFemale=_sipFemale.envelopeBody().shadowProfile(pn);
		//
		PlaneProfile ppMaleShrink=ppMale;
		PlaneProfile ppFemaleShrink=ppFemale;
		ppMaleShrink.shrink(U(1));
		ppFemaleShrink.shrink(U(1));
		
		PlaneProfile ppMaleExtend=ppMale;
		PlaneProfile ppFemaleExtend=ppFemale;
		ppMaleExtend.shrink(-.5*dAllowedGap);
		ppFemaleExtend.shrink(-.5*dAllowedGap);
//		ppMaleShrink.vis(1);
//		ppFemaleShrink.vis(1);
		
		if(!ppMaleShrink.intersectWith(ppFemaleShrink) && ppMaleExtend.intersectWith(ppFemaleExtend))
		{ 
			// no intersection the shrinked profiles and close enough
			_m.setEntity("male", _sipMale);
			_m.setEntity("female", _sipFemale);
			return _m;
		}
		else
		{ 
			// check the other way
			_sipMale=_sips[1];
			_sipFemale=_sips[0];
			// V1.4 20.09.2024 HSB-19771
			vecZmale=_sipMale.vecZ();
			pn=Plane (_sipMale.ptCen(), vecZmale);
			ppMale=_sipMale.envelopeBody().shadowProfile(pn);
			ppFemale=_sipFemale.envelopeBody().shadowProfile(pn);
			//
			ppMaleShrink=ppMale;
			ppFemaleShrink=ppFemale;
			ppMaleShrink.shrink(U(1));
			ppFemaleShrink.shrink(U(1));
			
			ppMaleExtend=ppMale;
			ppFemaleExtend=ppFemale;
			ppMaleExtend.shrink(-.5*dAllowedGap);
			ppFemaleExtend.shrink(-.5*dAllowedGap);
			if(!ppMaleShrink.intersectWith(ppFemaleShrink) && ppMaleExtend.intersectWith(ppFemaleExtend))
			{ 
				// no intersection the shrinked profiles and close enough
				_m.setEntity("male", _sipMale);
				_m.setEntity("female", _sipFemale);
				return _m;
			}
		}
		
		_m.setInt("Error",true);
		return _m;
	}
//End distinguishMaleFemaleFrom2Sips//endregion


//region getSipConnections
// based on the 	_nConnectionType, this function will
// return all connections male-female
	Map getSipConnections(Sip _sips[],int _nConnectionType)
	{ 
		Map _m;
		if(_sips.length()<2)
		{ 
			// needed at least 2 panels
			String sError=T("|At least 2 panels needed|");
			_m.setString("sError",sError);
			_m.setInt("Error",true);
			return _m;
		}
		if(_nConnectionType==1)
		{ 
			// all male-female couples
			for (int s=0;s<_sips.length();s++) 
			{ 
				Sip sipS=_sips[s];
				
				Vector3d vecZs=sipS.vecZ();
				for (int sj=s+1;sj<_sips.length();sj++) 
				{ 
					Map mMales;
					Map mFemales;
					Sip sipSj=_sips[sj];
					Vector3d vecZsj=sipSj.vecZ();
					
					// check that are normal
					if(!vecZs.isPerpendicularTo(vecZsj))
					{ 
						// not parallel
						continue;
					}
					// get the male and the female
					Sip _sipMale=sipS;
					Sip _sipFemale=sipSj;
					
					// projected in vecZmale they must have a gap
					Sip _sipsIn[0];
					_sipsIn.append(sipS);
					_sipsIn.append(sipSj);
					Map _mOut=distinguishMaleFemaleFrom2Sips(_sipsIn);
					if(_mOut.getInt("Error"))
					{ 
						continue;
					}
					mMales.appendEntity("sip",_mOut.getEntity("male"));
					mFemales.appendEntity("sip",_mOut.getEntity("female"));
					Map mMaleFemales;
					mMaleFemales.appendMap("males", mMales);
					mMaleFemales.appendMap("females", mFemales);
					_m.appendMap("malefemales", mMaleFemales);
				}//next sj
			}//next s
		}
		return _m;
	}
//End getSipConnections//endregion 

//region getConnectionSideOf2Panels
// this will return the connection side
// for L/corner connections
// it will return the inner side of the connection
	Map getConnectionSideOf2Panels(Sip _sips[])
	{ 
		Map _m;
		if(_sips.length()!=2)
		{ 
			return _m;
		}
		
		Sip _sipMale=_sips[0];
		Sip _sipFemale=_sips[1];
		
		Vector3d vecZmale=_sipMale.vecZ();
		Vector3d vecZfemale=_sipFemale.vecZ();
		
		if(!vecZmale.isPerpendicularTo(vecZfemale))
		{ 
			_m.setString("sError","mConnectionSide2Panels: "+T("|Panels not parallel|"));
			return _m;
		}
	//
		Plane pn(_sipFemale.ptCen(),vecZfemale);
		PlaneProfile ppFemale=_sipFemale.envelopeBody().shadowProfile(pn);
		PlaneProfile ppMale=_sipMale.envelopeBody().shadowProfile(pn);
		
		Vector3d _vecDir=vecZmale.crossProduct(vecZfemale);
		_vecDir.normalize();
		
		Point3d ptL=_sipMale.ptCen()-.5*_sipMale.dH()*_sipMale.vecZ();
		Point3d ptR=_sipMale.ptCen()+.5*_sipMale.dH()*_sipMale.vecZ();
		
		PlaneProfile ppStripL(pn),ppStripR(pn);
		ppStripL.createRectangle(LineSeg(ptL-_vecDir*U(10e4),
			ptL+_vecDir*U(10e4)-_sipMale.vecZ()*U(10e4)),_sipMale.vecZ(),_vecDir);
		ppStripR.createRectangle(LineSeg(ptR-_vecDir*U(10e4),
			ptR+_vecDir*U(10e4)+_sipMale.vecZ()*U(10e4)),_sipMale.vecZ(),_vecDir);
		
		// default side is on the left
		Vector3d _vecSide=-_sipMale.vecZ();
		int nSide=1;//left
		ppStripL.intersectWith(ppFemale);
		ppStripR.intersectWith(ppFemale);
		if(ppStripR.area()>ppStripL.area())
		{ 
			_vecSide*=-1;
			nSide=-1;
		}
//		_vecSide.vis(_sipMale.ptCen());
		_m.setVector3d("vecSide", _vecSide);
		_m.setInt("Side",nSide);
		
		
	// calculate the distribution line	
		PlaneProfile _ppCommon=ppMale;
		_ppCommon.intersectWith(ppFemale);
		
	// get extents of profile
		LineSeg _segCommon=_ppCommon.extentInDir(_vecDir);
		Point3d _ptStart=_segCommon.ptStart();
		Point3d _ptEnd=_segCommon.ptEnd();
		
		
		Plane pnMale(_sips[0].ptCen()+.5*_sips[0].dH()*_vecSide, _vecSide);
		Vector3d _vecFemale=_sips[1].vecZ();
		if(_vecFemale.dotProduct(_sips[0].ptCen()-_sips[1].ptCen())<0)
		{ 
			_vecFemale=-_sips[1].vecZ();
		}
		Plane pnFemale(_sips[1].ptCen()+.5*_sips[1].dH()*_vecFemale,_vecFemale);
		Line ln=pnMale.intersect(pnFemale);
		
		_ptStart=ln.closestPointTo(_ptStart);
		_ptEnd=ln.closestPointTo(_ptEnd);
		
		Point3d _ptMid=.5*(_ptStart+_ptEnd);
		
		_m.setPoint3d("ptStart",_ptStart);
		_m.setPoint3d("ptEnd",_ptEnd);
		_m.setPoint3d("ptMid",_ptMid);
		_m.setVector3d("vecDir",_vecDir);
		return _m;
		
	}
//End getConnectionSideOf2Panels//endregion

//region getDistributionLineOf2Panels
// Dependent on the side provided as argument
// this routine will return the distribution line of 2 perpendicular panels
Map getDistributionLineOf2Panels(Sip _sips[],int _nSide)
{ 
	Map _m;
	if(_sips.length()!=2)
	{ 
		return _m;
	}
	
	Sip _sipMale=_sips[0];
	Sip _sipFemale=_sips[1];
	Vector3d vecZmale=_sipMale.vecZ();
	Vector3d vecZfemale=_sipFemale.vecZ();
	vecZfemale.normalize();
//	vecZfemale.vis(_sipFemale.ptCen());
	Vector3d _vecSide=-_sipMale.vecZ();
	if(_nSide==-1)_vecSide=_sipMale.vecZ();
	Plane pnMale(_sips[0].ptCen()+.5*_sips[0].dH()*_vecSide, _vecSide);
	Vector3d _vecFemale=_sips[1].vecZ();
	if(_vecFemale.dotProduct(_sips[0].ptCen()-_sips[1].ptCen())<0)
	{ 
		_vecFemale=-_sips[1].vecZ();
	}
	Plane pnFemale(_sips[1].ptCen()+.5*_sips[1].dH()*_vecFemale,_vecFemale);
	
	Line ln=pnMale.intersect(pnFemale);
	
	Plane pn(_sipFemale.ptCen(),vecZfemale);
	PlaneProfile ppFemale=_sipFemale.envelopeBody().shadowProfile(pn);
	PlaneProfile ppMale=_sipMale.envelopeBody().shadowProfile(pn);
	if(ppMale.area()<pow(U(1),2))
	{ 
		// Fix when calculating the distribution line of a male-female panel
		//try with - vecZfemale; somehow it can fix it
		ppMale=_sipMale.envelopeBody().shadowProfile(Plane (_sipFemale.ptCen(),-vecZfemale));
	}
// calculate the distribution line	
	PlaneProfile _ppCommon=ppMale;
	_ppCommon.intersectWith(ppFemale);
	
	if(_ppCommon.area()<pow(U(1),2))
	{ 
		String sError=T("|No contact between male and female, distribution not possible|");
		_m.setString("sError",sError);
		_m.setInt("Error",true);
		return _m;
	}
	
	Vector3d _vecDir=vecZmale.crossProduct(vecZfemale);
	_vecDir.normalize();
// get extents of profile
	LineSeg _segCommon=_ppCommon.extentInDir(_vecDir);
	Point3d _ptStart=_segCommon.ptStart();
	Point3d _ptEnd=_segCommon.ptEnd();
	_segCommon.vis(1);
	_ptStart=ln.closestPointTo(_ptStart);
	_ptEnd=ln.closestPointTo(_ptEnd);
	Point3d _ptMid=.5*(_ptStart+_ptEnd);
		
	_m.setPoint3d("ptStart",_ptStart);
	_m.setPoint3d("ptEnd",_ptEnd);
	_m.setPoint3d("ptMid",_ptMid);
	_m.setVector3d("vecDir",_vecDir);
	
	return _m;
}
//End getDistributionLineOf2Panels//endregion


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
				String sTxt=T("|no distribution possible. Try to change the distribution parameters|");
				_m.setString("sTxt",sTxt);
				_m.setInt("Error",true);
				return _m;
			}
			if(_dOffsetBetween>0)
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
				}
			}
			else if(_dOffsetBetween<0)
			{ 
				// negative entry is nr of parts
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
			else if(_dOffsetBetween==0)
			{ 
				// distribution not possible
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

//region doToolingAtPanels
// It does the tooling at panels
Map doToolingAtPanels(Sip _sips[],Map _min)
{ 
	Map _m;
	if(_sips.length()<1)
	{ 
		// needed at least 2 panels
		String sError=T("|At least 1 panel needed|");
		_m.setString("sError",sError);
		_m.setInt("Error",true);
		return _m;
	}
	
	if(_sips.length()==2)
	{ 
		// tooling at 2 panels
		Sip _sipMale=_sips[0];
		Sip _sipFemale=_sips[1];
		
		Vector3d vecZmale=_sipMale.vecZ();
		Vector3d vecZfemale=_sipFemale.vecZ();
		
		if(!vecZmale.isPerpendicularTo(vecZfemale))
		{ 
			_m.setString("sError","mConnectionSide2Panels: "+T("|Panels not parallel|"));
			_m.setInt("Error",true);
			return _m;
		}
		
		//
		Vector3d _vecSide=-vecZmale;
		if(_min.hasInt("Side"))
		{ 
			if(_min.getInt("Side")==-1)
			{ 
				_vecSide=vecZmale;
			}
		}
		double _dOffsetZ=U(0);
		double _dOffsetY=U(0);
		if(_min.hasDouble("OffsetZ"))
		{ 
			_dOffsetZ=_min.getDouble("OffsetZ");
		}
		if(_min.hasDouble("OffsetY"))
		{ 
			_dOffsetY=_min.getDouble("OffsetY");
		}
		// depth at female panel
		double _dDepth=U(0);
		if(_min.hasDouble("Depth"))
		{ 
			_dDepth=_min.getDouble("Depth");
		}
		Point3d _ptsDis[]=_min.getPoint3dArray("pts");
		Vector3d _vecUp=vecZfemale;
		if(_vecUp.dotProduct((_sipMale.ptCen()-_sipFemale.ptCen()))<0)
		{ 
			_vecUp*=-1;
		}
		// do tooling at each point
		for (int p=0;p<_ptsDis.length();p++) 
		{ 
			_ptsDis[p].vis(3);
			
			// do the tooling at female
			if(_dDepth>0)
			{ 
				// hous at female panel
				double _dLength = U(60);
				double _dDiameter=U(42);
				double _dWidth=_dDiameter;
				
				// 
	//			Point3d _ptHouse=_ptsDis[p]-_vecSide*_dOffsetZ+_vecUp*_dOffsetY;
				Point3d _ptHouse=_ptsDis[p];
				Vector3d _vecXT=_vecSide;
				Vector3d _vecZT=_vecUp;
				Vector3d _vecYT=_vecZT.crossProduct(_vecXT);
				_vecYT.normalize();
				
				
				_vecXT.vis(_ptHouse,1);
				_vecYT.vis(_ptHouse,3);
				_vecZT.vis(_ptHouse,5);
				
	//			Mortise ms(_ptHouse,_vecXT,-_vecYT,-_vecZT,_dLength,_dWidth,_dDepth*2,1,0,0);
	//			ms.setExplicitRadius(U(21));
	//			ms.setRoundType(_kExplicitRadius);
	
				House ms(_ptHouse,_vecXT,-_vecYT,-_vecZT,_dWidth,_dLength,_dDepth*2,1,0,0);
				ms.setEndType(_kFemaleSide);
				ms.setRoundType(_kRound);
				
	//			ms.cuttingBody().vis(2);
	//			ms.addMeToGenBeamsIntersect(_sips);
				_sips[1].addTool(ms);
			}
			// tooling at male
			if(_dOffsetZ > - U(22) + dFlushExtraGap)
			{ 
	//			Point3d _ptHouse=_ptsDis[p]+_dOffsetY*_vecUp;
				Point3d _ptHouse=_ptsDis[p];
				Vector3d _vecXT=_vecUp;
				Vector3d _vecZT=_vecSide;
				Vector3d _vecYT=_vecZT.crossProduct(_vecXT);
				_vecYT.normalize();
				
				
				_vecXT.vis(_ptHouse,1);
				_vecYT.vis(_ptHouse,3);
				_vecZT.vis(_ptHouse,5);
				
				// bottom part
				double _dLength = 2*U(61)+2*_dOffsetY;
				double _dDiameter=U(42);
				double _dWidth=_dDiameter;
				double _dDepth= _dDiameter;
				
				Mortise ms(_ptHouse,_vecXT,-_vecYT,-_vecZT,_dLength,_dWidth,_dDepth,0,0,0);
				ms.setEndType(_kFemaleSide);
				ms.setExplicitRadius(U(21));
				ms.setRoundType(_kExplicitRadius);
				
	//			ms.setRoundType(_kRound);
				ms.cuttingBody().vis(3);
	//			ms.addMeToGenBeamsIntersect(_sips);
				_sips[0].addTool(ms);
				
				if(_dOffsetZ > U(0))
				{ 
					// top part
					_ptHouse=_ptsDis[p]+_vecUp*U(174)+_dOffsetY*_vecUp;
					_ptHouse.vis(6);
					_dLength = U(268);
					_dWidth=U(68);
					_dDepth=dFlushExtraGap;
					Mortise ms(_ptHouse,_vecXT,-_vecYT,-_vecZT,_dLength,_dWidth,_dDepth*2,0,0,0);
					ms.setExplicitRadius(U(21));
					ms.setRoundType(_kExplicitRadius);
					ms.setEndType(_kFemaleSide);
	//				ms.setRoundType(_kRounded);
					ms.cuttingBody().vis(2);
		//			ms.addMeToGenBeamsIntersect(_sips);
					_sips[0].addTool(ms);
				}
			}
			// pilot drill at female for the stockschraube
			double dDiamPilotDrill=U(8);
			double dDepthPilotDrill=U(100);
			Drill dr(_ptsDis[p] + _vecUp * 10 * dEps,
			_ptsDis[p]-_vecUp*dDepthPilotDrill,.5*dDiamPilotDrill);
			_sips[1].addTool(dr);
		}//next p
	}
	else if(_sips.length()==1)
	{ 
		// tool at one panels
		Sip _sipMale=_sips[0];
		Vector3d vecZmale=_sipMale.vecZ();
		Vector3d _vecSide=-vecZmale;
		if(_min.hasInt("Side"))
		{ 
			if(_min.getInt("Side")==-1)
			{ 
				_vecSide=vecZmale;
			}
		}
		double _dOffsetZ=U(0);
		double _dOffsetY=U(0);
		if(_min.hasDouble("OffsetZ"))
		{ 
			_dOffsetZ=_min.getDouble("OffsetZ");
		}
		if(_min.hasDouble("OffsetY"))
		{ 
			_dOffsetY=_min.getDouble("OffsetY");
		}
		// depth at female panel
		double _dDepth=U(0);
		if(_min.hasDouble("Depth"))
		{ 
			_dDepth=_min.getDouble("Depth");
		}
		
		Point3d _ptsDis[]=_min.getPoint3dArray("pts");
		Vector3d _vecUp=_min.getVector3d("vecUp");
		
		// do tooling at each point
		for (int p=0;p<_ptsDis.length();p++) 
		{ 
			_ptsDis[p].vis(3);
			// tooling at male
			if(_dOffsetZ > - U(22) +dFlushExtraGap)
			{ 
	//			Point3d _ptHouse=_ptsDis[p]+_dOffsetY*_vecUp;
				Point3d _ptHouse = _ptsDis[p];
				Vector3d _vecXT=_vecUp;
				Vector3d _vecZT=_vecSide;
				Vector3d _vecYT=_vecZT.crossProduct(_vecXT);
				_vecYT.normalize();
				
				
				_vecXT.vis(_ptHouse,1);
				_vecYT.vis(_ptHouse,3);
				_vecZT.vis(_ptHouse,5);
		
		
				double _dLength = 2*U(61)+2*_dOffsetY;
				double _dDiameter=U(42);
				double _dWidth = _dDiameter;
				double _dDepth =  _dDiameter;
				
				
				Mortise ms(_ptHouse,_vecXT,-_vecYT,-_vecZT,_dLength,_dWidth,_dDepth,0,0,0);
				ms.setExplicitRadius(U(21));
				ms.setRoundType(_kExplicitRadius);
				ms.setEndType(_kFemaleSide);
//				ms.setRoundType(_kRounded);
				ms.cuttingBody().vis(3);
	//			ms.addMeToGenBeamsIntersect(_sips);
				_sips[0].addTool(ms);
				
				
				if(_dOffsetZ>U(0))
				{ 					
					// bottom part
					_ptHouse=_ptsDis[p]+_vecUp*U(174)+_dOffsetY*_vecUp;
					_dLength = U(268);
					 _dWidth= U(68);
					_dDepth= dFlushExtraGap;
				
					Mortise ms(_ptHouse,_vecXT,-_vecYT,-_vecZT,_dLength,_dWidth,_dDepth*2,0,0,0);
					ms.setEndType(_kFemaleSide);
					ms.setExplicitRadius(U(21));
					ms.setRoundType(_kExplicitRadius);
					
		//			ms.setRoundType(_kRound);
					ms.cuttingBody().vis(4);
//					ms.addMeToGenBeamsIntersect(_sips);
					_sips[0].addTool(ms);
				}
			}

			
			
		}//next p
		
	}
	return _m;
}
//End doToolingAtPanels//endregion

//region drawSymbol
// it draws the tsl symbol
Map drawSymbol(Sip _sips[], Map _min)
{ 
	Map _m;
	if(_sips.length()<1)
	{ 
		// needed at least 1 panels
		String sError=T("|At least 1 panels needed|");
		_m.setString("sError",sError);
		_m.setInt("Error",true);
		return _m;
	}
	double _dOffsetZ=U(0);
	if(_min.hasDouble("OffsetZ"))
	{ 
		_dOffsetZ=_min.getDouble("OffsetZ");
	}
	if(_sips.length()==2)
	{ 
		// 2 panels
		Sip _sipMale=_sips[0];
		Sip _sipFemale=_sips[1];
		
		Vector3d vecZmale=_sipMale.vecZ();
		Vector3d vecZfemale=_sipFemale.vecZ();
		
		if(!vecZmale.isPerpendicularTo(vecZfemale))
		{ 
			_m.setString("sError","mConnectionSide2Panels: "+T("|Panels not parallel|"));
			_m.setInt("Error",true);
			return _m;
		}
		
		//
		Vector3d _vecSide=-vecZmale;
		if(_min.hasInt("Side"))
		{ 
			if(_min.getInt("Side")==-1)
			{ 
				_vecSide=vecZmale;
			}
		}
		
		Point3d _ptsDis[]=_min.getPoint3dArray("pts");
		Vector3d _vecUp=vecZfemale;
		if(_vecUp.dotProduct((_sipMale.ptCen()-_sipFemale.ptCen()))<0)
		{ 
			_vecUp*=-1;
		}
		_vecSide.vis(_ptsDis.first(),1);
		Display dp(3);
		if(_min.hasInt("Color"))
		{ 
			dp.color(_min.getInt("Color"));
		}
		double _dDiameter=U(42);
		for (int p=0; p<_ptsDis.length(); p++)
		{
			_ptsDis[p].vis(1);
			
			PLine plCirc;
			plCirc.createCircle(_ptsDis[p], _vecUp, _dDiameter/2.0);
			dp.draw(plCirc);
		}
	}
	else if(_sips.length()==1)
	{ 
		// one panel
		Sip _sipMale=_sips[0];
		Vector3d vecZmale=_sipMale.vecZ();
		//
		Vector3d _vecSide=-vecZmale;
		if(_min.hasInt("Side"))
		{ 
			if(_min.getInt("Side")==-1)
			{ 
				_vecSide=vecZmale;
			}
		}
		Point3d _ptsDis[]=_min.getPoint3dArray("pts");
		Vector3d _vecUp=_min.getVector3d("vecUp");
		Display dp(3);
		if(_min.hasInt("Color"))
		{ 
			dp.color(_min.getInt("Color"));
		}
		double _dDiameter=U(42);
		for (int p=0; p<_ptsDis.length(); p++)
		{
			_ptsDis[p].vis(1);
			
			PLine plCirc;
			plCirc.createCircle(_ptsDis[p], _vecUp, _dDiameter/2.0);
			dp.draw(plCirc);
		}
	}
	return _m;
}
//End drawSymbol//endregion 

//region getPanelEdges
// this will return the start,end and mid point for every edge
Map getPanelEdges(Sip _sip,Map _min)
{ 
	Map _m;
	Plane _pn(_sip.ptCen(),_sip.vecZ());
	
	
	PlaneProfile _pp=_sip.envelopeBody().shadowProfile(_pn);
	PLine _plOutters[]=_pp.allRings(true,false);
	if(_plOutters.length()!=1)
	{ 
		_m.setString("sError",T("|Unexpected, more then one panel contour found|"));
		_m.setInt("Error", true);
		return _m;
	}
	PLine _plOutter=_plOutters[0];
	Map mCleanUp=cleanUpPline(_plOutter);
	Point3d ptsAddition[]=mCleanUp.getPoint3dArray("ptsAddition");
	if(ptsAddition.length()>0)
	{ 
		_plOutter=mCleanUp.getPLine("pl");
	}
	Point3d _pts[]=_plOutter.vertexPoints(false);
	
	// edge points
	Point3d _ptStarts[0],_ptEnds[0],_ptMids[0];
	
	for (int p=0;p<_pts.length()-1;p++)
	{ 
		Point3d ptS=_pts[p];
		Point3d ptE=_pts[p+1];
		Point3d ptM=.5*(ptS+ptE);
		
		_ptStarts.append(ptS);
		_ptEnds.append(ptE);
		_ptMids.append(ptM);
	}//next p
	
	_m.setPoint3dArray("Starts",_ptStarts);
	_m.setPoint3dArray("Ends",_ptEnds);
	_m.setPoint3dArray("Mids",_ptMids);
	
	_m.setVector3d("vecPlane",_sip.vecZ());
	
	
	if(_min.length()>0)
	{ 
		Point3d _pt;
		if(_min.hasInt("IndexEdgeInput"))
		{ 
			int _nEdgeSelected=_min.getInt("IndexEdgeInput");
			_m.setInt("IndexEdgeSelected", _nEdgeSelected);
		}
		else if(_min.hasPoint3d("pt"))
		{ 
			// point is provided as argument, find the selected edge
			_pt=_min.getPoint3d("pt");
			
			int _nEdgeSelected=-1;
			double dDist=U(10e9);
			for (int p=0;p<_ptMids.length();p++) 
			{ 
				double dDistI=(_ptMids[p]-_pt).length();
				if(dDistI<dDist)
				{ 
					dDist=dDistI;
					_nEdgeSelected=p;
				}
			}//next p
			if(_nEdgeSelected>-1)
			{ 
				_m.setInt("IndexEdgeSelected", _nEdgeSelected);
			}
		}
	}
	
	return _m;
}
//End getPanelEdges//endregion

//region getMainHardwareDefinition
// Writes the hardware for the hcwl	
HardWrComp getMainHardwareDefinition(int _nQty)
{ 
	String _sHWArticleNumber="2316495";
	HardWrComp _hwc(_sHWArticleNumber, _nQty);
	String _sHWManufacturer = "Hilti";
	_hwc.setManufacturer(_sHWManufacturer);
	String _sHWModel ="Wood coupler HCWL 40x295 M12";
	_hwc.setModel(_sHWModel);
	String sHWDescription = "Faster and more efficient wood connector system for assembling prefabricated timber structures";
	_hwc.setDescription(sHWDescription);
	_hwc.setCategory(T("|Connector|"));
	_hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
	return _hwc;
}
//End getMainHardwareDefinitionl//endregion

//region getHardwareDefinitionHSW
// Writes the hardware for the hcwl	
HardWrComp getHardwareDefinitionHSW(int _nQty, String sHardwareInfo[])
{ 
	String _sHWManufacturer = "Hilti";
	String _sHWArticleNumber="2316491";
	String _sHWModel ="Hanger bolt HSW M12x220/60 8.8";
	//String sHWDescription = "Galvanized hanger bolt for anchoring wooden structures with pre-installed HCW connectors";
	double dHWScaleX = U(220);
	double dHWScaleY = U(12);
	double dHWScaleZ = U(12);
	
	if(sHardwareInfo.length() == 3 )
	{	
		_sHWArticleNumber = sHardwareInfo[0];
		_sHWModel = sHardwareInfo[1];
		dHWScaleX = sHardwareInfo[2].atof();
	}

	HardWrComp _hwc(_sHWArticleNumber, _nQty);
	_hwc.setCategory(T("|Connector|"));
	_hwc.setManufacturer(_sHWManufacturer);	
	_hwc.setModel(_sHWModel);	
	_hwc.setDScaleX(dHWScaleX);
	_hwc.setDScaleY(dHWScaleY);
	_hwc.setDScaleZ(dHWScaleZ);
	_hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
	return _hwc;
}
//End getHardwareDefinitionHSW//endregion

//region drawBlock
// this will draw the block representation of the hcwl	
Map drawBlock(Map _min)
{ 
	Display dp(7);
	if(_min.hasInt("Color"))
	{ 
		dp.color(_min.getInt("Color"));
	}
	
	String sBlock=sBlockName;
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
		Point3d _ptBlock=_pts[p]+_vz*_dOffsetY;
		dp.draw(block,_ptBlock,_vx,_vy,_vz);
	}//next p
	
	
}
//End drawBlock//endregion 
//End Functions//endregion 


//region Properties
	String sConnectionTypeName=T("|Connection Type|");
	// male-female means for each male one female
	// male-females means one male to multiple connected females
	// males-females means multiple colinear males to multile colinear females
//	String sConnectionTypes[]={T("|single panel|"),T("|male-female|"), T("|male-females|"),T("|males-females|")};
	String sConnectionTypes[]={T("|single panel|"),T("|male-female|")};
	PropString sConnectionType(nStringIndex++, sConnectionTypes, sConnectionTypeName);	
	sConnectionType.setDescription(T("|Defines the Connection Type|"));
	sConnectionType.setCategory(category);
	int nConnectionType=sConnectionTypes.find(sConnectionType);
			
// distribution properties
	category = T("|Distribution|");
	String sDistributionName=T("|Rule|");
	String sDistributions[]={ T("|Fixed Distribution|"),T("|Even Distribution|")};
	PropString sDistribution(nStringIndex++,sDistributions,sDistributionName);	
	sDistribution.setDescription(T("|Defines the distribution type|"));
	sDistribution.setCategory(category);	
	
	String sOffsetBottomName=T("|Start Offset|");
	PropDouble dOffsetBottom(nDoubleIndex++,U(350),sOffsetBottomName);
	dOffsetBottom.setDescription(T("|Defines the start offset|"));
	dOffsetBottom.setCategory(category);
	
	if(dOffsetBottom <  U(72))
	{
		reportMessage(T("|Start Offset must be >= 72 mm|"));
		dOffsetBottom.set(U(72));
	}
	
	String sOffsetTopName=T("|End Offset|");
	PropDouble dOffsetTop(nDoubleIndex++,U(350),sOffsetTopName);
	dOffsetTop.setDescription(T("|Defines the end offset|"));
	dOffsetTop.setCategory(category);
	
	if(dOffsetTop <  U(72))
	{
		reportMessage(T("|End Offset must be >= 72 mm|"));
		dOffsetTop.set(U(72));
	}
	
	String sOffsetBetweenName=T("|Interdistance|");
	PropDouble dOffsetBetween(nDoubleIndex++,U(1000),sOffsetBetweenName);
	dOffsetBetween.setDescription(T("|Defines the interdistance|"));
	dOffsetBetween.setCategory(category);
	// tooling
//	category=T("|Tooling|");
//	String sOffsetZName=T("|Offset|")+" Z";
//	PropDouble dOffsetZ(nDoubleIndex++, U(0), sOffsetZName);
//	dOffsetZ.setDescription(T("|Defines the Offset of the tooling from the panel side|"));
//	dOffsetZ.setCategory(category);
	
	String sOffsetYName=T("|Offset|")+" Y";
	PropDouble dOffsetY(nDoubleIndex++, U(0), sOffsetYName);
	dOffsetY.setDescription(T("|Defines the OffsetY in height.|"));
	dOffsetY.setCategory(category);
	
	if(dOffsetY < - U(80))
	{
		reportMessage(T("|Offset Y must be >= - 80 mm|"));
		dOffsetY.set(U(-80));
	}
	
	String sDepthName=T("|Depth|");
	PropDouble dDepth(nDoubleIndex++, U(0), sDepthName);
	dDepth.setDescription(T("|Defines the milling depth at the female panel.|"));
	dDepth.setCategory(category);	
	
	String sPositionName=T("|Position|");
	String sPositions[]={ T("|Panel Outside|"),T("|Milled in Strap|"),T("|Flush|")};
	PropString sPosition(nStringIndex++,sPositions,sPositionName);	
       sPosition.setDescription(T("|Defines the position of the fastener at the panel.|"));
       
       double dOffsetZs[] = { U(0), U(3), U(42) - U(22) +dFlushExtraGap + U(1)};
       dOffsetZ = dOffsetZs[sPositions.find(sPosition, 0)];     
       
       category = T("|Fasteners|");
	String sFastenerNames=T("|Fastener|");
	String sFasteners[]={ T("|None|"),T("|HST3 M12x165|"),T("|HST3 M12x185|"),T("|HAS-U 8.8 M12x180|"),T("|HAS-U 8.8 M12x200|"), T("|Stockschraube HSW M12x220/60 8.8|"), T("|Stockschraube HSW M12x140/60 8.8|")};
	PropString sFastener(nStringIndex++,sFasteners,sFastenerNames);	
       sFastener.setDescription(T("|Defines the fastener for a connection to a concrete wall/floor or a wooden component.|"));
	sFastener.setCategory(category);	
	double sFastenersLength[] = { U(165), U(185), U(180), U(200), U(220), U(140)};
	String sFastenersArticles[]={ "2107687","2107687","2226626","2226626", "2316491", "216376"};
	int nFastener = sFasteners.find(sFastener);
	
	if(nFastener > 0 && nConnectionType == 1 && nFastener < 5)
	{
		sFastener.set(sFasteners[5]);
	}
//End Properties//endregion 

//region jig
	String strJigAction1 = "strJigAction1";
	if (_bOnJig && _kExecuteKey == strJigAction1)
	{
		Vector3d vecView = getViewDirection();
		
		Display dpjig(3);
		Point3d ptJig = _Map.getPoint3d("_PtJig");
		Map mEdges=_Map.getMap("Edges");
		Point3d ptStarts[]=mEdges.getPoint3dArray("Starts");
		Point3d ptEnds[]=mEdges.getPoint3dArray("Ends");
		Point3d ptMids[]=mEdges.getPoint3dArray("Mids");
		// normal plane vector
		Vector3d _vn=mEdges.getVector3d("vecPlane");
		
		
		Plane pnCen(ptMids[0],_vn);
		ptJig=Line(ptJig,vecView).intersect(pnCen,U(0));
		// view plane
		Plane pnView(ptJig,vecView);
		// get the closest edge, and highlight
		
		int nEdgeSelected=-1;
		double dDist=U(10e9);
		for (int p=0;p<ptMids.length();p++) 
		{ 
			double dDistI=(ptMids[p]-ptJig).length();
			if(dDistI<dDist)
			{ 
				dDist=dDistI;
				nEdgeSelected=p;
			}
		}//next p
		
		if(nEdgeSelected>-1)
		{ 
			Vector3d vDir=ptStarts[nEdgeSelected]-ptEnds[nEdgeSelected];
			vDir.normalize();
			
			// project in the vecview plane
			vDir=vecView.crossProduct(vecView.crossProduct(vDir));
			vDir.normalize();
			
			
			Vector3d vNormal=vDir.crossProduct(vecView);
			
			PlaneProfile ppEdge(Plane(ptJig,_vn));
			
			// draw text
			Display dp(1);
			
			Point3d ptStartView=ptStarts[nEdgeSelected];
			Point3d ptEndView=ptEnds[nEdgeSelected];
			
			ptStartView=Line(ptStartView,vecView).intersect(pnView,U(0));
			ptEndView=Line(ptEndView,vecView).intersect(pnView,U(0));
			
			ppEdge.createRectangle(LineSeg(ptStartView-vNormal*U(5),
				ptEndView+vNormal*U(5)),vDir,vNormal);
			
			dpjig.draw(ppEdge);
			dpjig.draw(ppEdge,_kDrawFilled);
		}
		
		
		return;
	}
//End jig//endregion 

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
		
//	// prompt for male sips
//		Entity entsMale[0];
//		PrEntity ssE(T("|Select male panels|"), Sip());
//		if (ssE.go())
//			entsMale.append(ssE.set());
//		
//	// prompt for female sips
//		Entity entsFemale[0];
//		PrEntity ssE2(T("|Select female panels|"), Sip());
//		if (ssE2.go())
//			entsFemale.append(ssE2.set());
	
		int bSingleInstance=(dOffsetBetween==U(0));
		int nConnectionType=sConnectionTypes.find(sConnectionType);// HSB-24843
		if(nConnectionType==0)
		{ 
			int sizeOK = false;
			Sip sip;
			
			while(!sizeOK)
			{
				// Distribution at single panel
				sip=getSip(T("|Select the Panel|"));				
				if (sip.solidHeight() > U(79.9))
				{
					sizeOK = true;
				}
				else
				{
					reportMessage(T("|Selected panel must have a thickness >= 80 mm. |"));
				}
			}

			// prompt the edge selection			
			
			String sStringStart = "|Select edge or|";
			String sStringPrompt = T(sStringStart)+" [Finish]";
			PrPoint ssP(sStringPrompt);
			
			Map mapArgs;
			int nGoJig=-1;
			
			// calculate all the panel edges
			Map mEdges=getPanelEdges(sip,Map());
			
			//
			mapArgs.setMap("Edges",mEdges);
			
			while (nGoJig != _kNone)
			{
				nGoJig=ssP.goJig(strJigAction1, mapArgs);
				
				if (nGoJig==_kOk)
				{ 
					// get the edge and create the tsl
					Vector3d vecView=getViewDirection();
					Point3d ptJig=ssP.value();
					Point3d ptMids[]=mEdges.getPoint3dArray("Mids");
					// normal plane vector
					Vector3d _vn=mEdges.getVector3d("vecPlane");
					Plane pnCen(ptMids[0],_vn);
					ptJig=Line(ptJig,vecView).intersect(pnCen,U(0));
					
				// create TSL
					TslInst tslNew; Vector3d vecXTsl=_XW; Vector3d vecYTsl=_YW;
					GenBeam gbsTsl[]={sip}; 
					Entity entsTsl[]={}; 
					Point3d ptsTsl[]={ptJig};
					int nProps[]={}; 
					double dProps[]={dOffsetBottom,dOffsetTop,dOffsetBetween,
						dOffsetZ,dOffsetY,dDepth};
					String sProps[]={sConnectionType,sDistribution};
					Map mapTsl;
					// distribution at single panel
					mapTsl.setInt("mode",2);
					
					if(bSingleInstance)
					{ 
						// get point for single instance at single panel
						Point3d pt=getPoint(T("|Select Insertion point|"));
						ptsTsl[0]=pt;
						mapTsl.setInt("mode",102);
						Map mInAddition;
						{
							mInAddition.setPoint3d("pt",ptJig);
							Map mEdges=getPanelEdges(sip,mInAddition);
							int nIndexEdge=mEdges.getInt("IndexEdgeSelected");
							mapTsl.setInt("IndexEdge",nIndexEdge);
						}
					}
					
					tslNew.dbCreate(scriptName(),vecXTsl,vecYTsl,gbsTsl,entsTsl,
						ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
					
				}
				else if(nGoJig==_kKeyWord)
				{ 
					if (ssP.keywordIndex()==0)
					{ 
						// finish was clicked
						nGoJig=_kNone;
					}
				}
				else if(nGoJig==_kCancel )
				{ 
				// cancel is clicked
					nGoJig=_kNone;
				}
				
			}
			eraseInstance();
			return;
		}
		
	// at first support one male with multiple females
	// prompt for sips
		Entity entsMale[0];
		PrEntity ssE(T("|Select male panels|"), Sip());
		if (ssE.go())
			entsMale.append(ssE.set());
			
		for (int e=entsMale.length()-1; e>=0 ; e--) 
		{ 
			Sip sip=(Sip)entsMale[e];
			if(!sip.bIsValid())
			{ 
				reportMessage(T("|Panel| ") + sip.posnum() + T(" |is invalid.|"));
				entsMale.removeAt(e);
			}
			else if(sip.solidHeight() < U(79.9))
			{
				reportMessage(T("|Panel| ") + sip.posnum()+ T(" |must have a thickness >= 80 mm. |"));
				entsMale.removeAt(e);
			}
			else
			{
				_Sip.append(sip);
			}
		}//next e
		
		for (int e=entsMale.length()-1; e>=0 ; e--) 
		{ 
			Sip sip=(Sip)entsMale[e];
			if(!sip.bIsValid())
			{ 
				entsMale.removeAt(e);
			}
			else
			{
				_Sip.append(sip);
			}
		}//next e
		
//		for (int e=0;e<entsMale.length();e++) 
//		{ 
//			Sip sipE=(Sip)entsMale[e];
//			if(sipE.bIsValid())
//			{ 
//				if(_Sip.find(sipE)<0)
//				{ 
//					_Sip.append(sipE);
//				}
//			}
//		}//next e
		
		
	// prompt for sips
		Entity entsFemale[0];
		PrEntity ssE2(T("|Select female panels|"), Sip());
		if (ssE2.go())
			entsFemale.append(ssE2.set());
		
		for (int e=entsFemale.length()-1; e>=0 ; e--) 
		{ 
			Sip sip=(Sip)entsFemale[e];
			if(!sip.bIsValid())
			{ 
				reportMessage(T("|Panel| ") + sip.posnum() + T(" |is invalid.|"));
				entsFemale.removeAt(e);
			}
			else if(sip.solidHeight() < U(79.9))
			{
				reportMessage(T("|Panel| ") + sip.posnum() + T(" |must have a thickness >= 80 mm. |"));
				entsFemale.removeAt(e);
			}
			else
			{
				_Sip.append(sip);
			}
		}//next e
//		for (int e=0;e<entsFemale.length();e++) 
//		{ 
//			Sip sipE=(Sip)entsFemale[e];
//			if(sipE.bIsValid())
//			{ 
//				if(_Sip.find(sipE)<0)
//				{ 
//					_Sip.append(sipE);
//				}
//			}
//		}//next e
		
		if(nConnectionType==1)
		{ 
			// male female
			if(bSingleInstance)
			{ 
				// single instance no distribution
				if(entsMale.length()==1 && entsFemale.length()==1 
					&& _Sip.length()==2)
				{ 
					// single instance at 2 panels male-female
					// create TSL
					TslInst tslNew; Vector3d vecXTsl=_XW; Vector3d vecYTsl=_YW;
					GenBeam gbsTsl[0];
					for (int s=0;s<_Sip.length();s++) 
					{ 
						gbsTsl.append(_Sip[s]); 
					}//next s
					
					Entity entsTsl[]={}; 
					Point3d ptsTsl[]={_Pt0};
					int nProps[]={}; 
					double dProps[]={dOffsetBottom,dOffsetTop,dOffsetBetween,
						dOffsetZ,dOffsetY,dDepth};
					String sProps[]={sConnectionType,sDistribution};
					Map mapTsl;
					// distribution at single panel
					mapTsl.setInt("mode",101);
				// get point
					Point3d pt=getPoint(T("|Select Insertion point|"));
					ptsTsl[0]=pt;
					tslNew.dbCreate(scriptName(),vecXTsl,vecYTsl,gbsTsl,entsTsl,
						ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
					
					eraseInstance();
					return;
				}
			}
		}
		_Map.setInt("mode", 0);
		
		return;
	}
// end on insert	__________________//endregion
//return;
int nMode=_Map.getInt("mode");
setKeepReferenceToGenBeamDuringCopy(_kAllBeams);
if(nMode==0)
{ 
	// distribution mode, after insert
	// male-female
	// every male with every female
//	return;
	// get all possible couples, and create tsls
//	return;
	Map mOut=getSipConnections(_Sip,nConnectionType);
	
//	return;
// create TSL
	TslInst tslNew;	Vector3d vecXTsl=_XW; Vector3d vecYTsl=_YW;
	GenBeam gbsTsl[]={}; Entity entsTsl[]={}; Point3d ptsTsl[]={_Pt0};
	int nProps[]={};
	double dProps[]={dOffsetBottom,dOffsetTop,dOffsetBetween,
		dOffsetZ,dOffsetY,dDepth};
	String sProps[]={sConnectionType,sDistribution};
	Map mapTsl;
	
	for (int c=0;c<mOut.length();c++) 
	{ 
		Map mc=mOut.getMap(c);
		
		Map mMales=mc.getMap("males");
		Map mFemales=mc.getMap("females");
		
		if(nConnectionType==1)
		{ 
			// male-female
			mapTsl.setInt("mode",1);
			// one male one female
			Entity entMale=mMales.getEntity("sip");
			Entity entFemale=mFemales.getEntity("sip");
			Sip sipMale=(Sip)entMale;
			Sip sipFemale=(Sip)entFemale;
			
			gbsTsl.setLength(0);
			gbsTsl.append(sipMale);
			gbsTsl.append(sipFemale);
			//
			tslNew.dbCreate(scriptName(),vecXTsl,vecYTsl,gbsTsl,entsTsl,
				ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
		}
	}//next c
	eraseInstance();
	return;
}
else if(nMode==1)
{ 
	
	// one male with one female
	sConnectionType.setReadOnly(_kHidden);
	Sip sipMale;
	Sip sipFemale;
	_ThisInst.setAllowGripAtPt0(false);
	if(_Sip.length()==2)
	{ 
		sipMale=_Sip[0];
		sipFemale=_Sip[1];
	}
	
	if(!sipMale.bIsValid())
	{ 
		reportMessage("\n"+scriptName()+" "+T("|No male panel found|"));
		eraseInstance();
		return;
	}
	
	if(!sipFemale.bIsValid())
	{ 
		reportMessage("\n"+scriptName()+" "+T("|No female panel found|"));
		eraseInstance();
		return;
	}
	
	// 
	// basic information
	Point3d ptCen=sipMale.ptCen();
	Vector3d vecX=sipMale.vecX();
	Vector3d vecY=sipMale.vecY();
	Vector3d vecZ=sipMale.vecZ();
	
	Point3d ptCen1=sipFemale.ptCen();
	Vector3d vecX1=sipFemale.vecX();
	Vector3d vecY1=sipFemale.vecY();
	Vector3d vecZ1=sipFemale.vecZ();
	
	assignToGroups(sipMale);
//	assignToGroups(sipFemale);
	_Pt0=ptCen;
	
	
	sipMale.envelopeBody().vis(1);
	sipFemale.envelopeBody().vis(3);
	
	// on dbcreate  for corner connection, insert on the inner side
	if(_bOnDbCreated)
	{
		Map mConnectionSide=getConnectionSideOf2Panels(_Sip);
		
		if(!mConnectionSide.hasInt("Side"))
		{ 
			String sError=mConnectionSide.getString("sError");
			reportMessage("\n"+scriptName()+" "+sError);
			eraseInstance();
			return;
		}
		_Map.setInt("Side",mConnectionSide.getInt("Side"));
	}
	
	if(!_Map.hasInt("Side"))
	{ 
		// initialize
		_Map.setInt("Side",1);
	}
	
	
//region Trigger FlipSide
	String sTriggerFlipSide = T("|Flip Side|");
	addRecalcTrigger(_kContextRoot, sTriggerFlipSide );
	if (_bOnRecalc && _kExecuteKey==sTriggerFlipSide)
	{
		_Map.setInt("Side",-_Map.getInt("Side"));
		setExecutionLoops(2);
		return;
	}//endregion
	// side 1-> -vecZ
	// side -1->vecZ
	
	int nSide=_Map.getInt("Side");
	Vector3d vecSide=-vecZ;
	if(nSide==-1)vecSide=vecZ;
	vecSide.vis(ptCen,2);
	
	// get the common distribution zonebetween male and female
	Map mDistributionLine = getDistributionLineOf2Panels(_Sip, nSide);
	if(mDistributionLine.getInt("Error"))
	{ 
		// 
		
		String sError=mDistributionLine.getString("sError");
		reportMessage("\n"+scriptName()+" "+sError);
		eraseInstance();
		return;
		
	}
	Point3d ptMidDistribution=mDistributionLine.getPoint3d("ptMid") + vecSide * (dFlushExtraGap - dOffsetZ);
	Point3d ptStartDistribution=mDistributionLine.getPoint3d("ptStart") + vecSide * (dFlushExtraGap - dOffsetZ);
	Point3d ptEndDistribution=mDistributionLine.getPoint3d("ptEnd") + vecSide * (dFlushExtraGap - dOffsetZ);
	Vector3d vecDirDistribution=mDistributionLine.getVector3d("vecDir");
	ptMidDistribution.vis(3);
	ptStartDistribution.vis(3);
	ptEndDistribution.vis(3);
	
	Line lnDistribution(ptMidDistribution, vecDirDistribution);
	
	if(dOffsetBetween==0)
	{ 
		dOffsetBetween.set(U(100));
	}
	// calculate the distribution points
	int nDistribution=sDistributions.find(sDistribution);
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
//	for (int p=0;p<ptsDis.length();p++) 
//	{ 
//		ptsDis[p].vis(1); 
//	}//next p
	
//region Trigger ReiheAufloesen
//	String sTriggerReiheAufloesen = "Reihe auflösen";
	String sTriggerReiheAufloesen = T("|Explode distribution|");
	addRecalcTrigger(_kContextRoot, sTriggerReiheAufloesen );
	if (_bOnRecalc && _kExecuteKey==sTriggerReiheAufloesen)
	{
		
	// create TSL
		TslInst tslNew; Vector3d vecXTsl=_XW; Vector3d vecYTsl=_YW;
		GenBeam gbsTsl[2]; Entity entsTsl[]={}; Point3d ptsTsl[]={_Pt0};
		int nProps[]={};
		double dProps[]={dOffsetBottom,dOffsetTop,dOffsetBetween,
			dOffsetZ,dOffsetY,dDepth};
		String sProps[]={sConnectionType,sDistribution};
		Map mapTsl;
		
		// 2 beams
		gbsTsl[0]=sipMale;
		gbsTsl[1]=sipFemale;
		// mapTsl
		mapTsl.setInt("mode",101);
		mapTsl.setInt("Side",nSide);
		
		for (int p=0;p<ptsDis.length();p++) 
		{ 
			ptsTsl[0]=ptsDis[p]; 
			
			tslNew.dbCreate(scriptName(),vecXTsl,vecYTsl,gbsTsl,entsTsl,
				ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
		}//next p
		
		eraseInstance();
		return;
	}//endregion
	
	Map mInTooling;
	{ 
		mInTooling.appendPoint3dArray("pts",ptsDis);
		mInTooling.setInt("Side",nSide);
		mInTooling.setDouble("OffsetZ",dOffsetZ);
		mInTooling.setDouble("OffsetY",dOffsetY);
//		mInTooling.setDouble("Depth",dDepth);
		double dDepthTooling=-dOffsetY+dDepth;
		mInTooling.setDouble("Depth",dDepthTooling);
	}
	Map mTooling=doToolingAtPanels(_Sip, mInTooling);
	Map mInSymbol;
	{ 
		mInSymbol.setDouble("OffsetZ",dOffsetZ);
		mInSymbol.appendPoint3dArray("pts",ptsDis);
		// 20241129
		mInSymbol.setInt("side",nSide);
		mInSymbol.setInt("Color", 6);
	}
	Map mDrawSymbol=drawSymbol(_Sip,mInSymbol);
	
	// Hardware//region
	// collect existing hardware
		HardWrComp hwcs[] = _ThisInst.hardWrComps();
		
	// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
		for (int i=hwcs.length()-1; i>=0 ; i--) 
			if (hwcs[i].repType() == _kRTTsl)
				hwcs.removeAt(i); 
	
	// declare the groupname of the hardware components
		String sHWGroupName;
		// set group name
		{ 
		// element
			// try to catch the element from the parent entity
			Element elHW =sipMale.element(); 
			// check if the parent entity is an element
			if (!elHW.bIsValid())	elHW = (Element)sipMale;
			if (elHW.bIsValid()) 	sHWGroupName=elHW.elementGroup().name();
		// loose
			else
			{
				Group groups[] = _ThisInst.groups();
				if (groups.length()>0)	sHWGroupName=groups[0].name();
			}		
		}
	// add main componnent
		{ 
			HardWrComp hwc=getMainHardwareDefinition(ptsDis.length());
			
			hwc.setGroup(sHWGroupName);
			hwc.setLinkedEntity(sipMale);	
		// apppend component to the list of components
			hwcs.append(hwc);
		}
	// add HSW Hanger bolt; differentiate between timber connection(HSW) and Concrete (HST3)
		{ 			
			if(nFastener > 0)
			{
				String sHardwareInfos[0];
				String concreteHardware[] = { sFastenersArticles[nFastener - 1], sFastener, sFastenersLength[nFastener - 1] };
				sHardwareInfos =  concreteHardware;

				HardWrComp hwc=getHardwareDefinitionHSW(ptsDis.length(), sHardwareInfos);
				
				hwc.setGroup(sHWGroupName);
				// only one panel, link to this panel
				hwc.setLinkedEntity(sipFemale);
			// apppend component to the list of components
				hwcs.append(hwc);			
			}
		}
	// make sure the hardware is updated
		if (_bOnDbCreated)	setExecutionLoops(2);				
		_ThisInst.setHardWrComps(hwcs);	
	//endregion
	
	// draw body via Blocks
	Vector3d vecUp=sipFemale.vecZ();
	if(vecUp.dotProduct((sipMale.ptCen()-sipFemale.ptCen()))<0)
	{ 
		vecUp*=-1;
	}
	Map minBlock;
	{ 
		minBlock.setPoint3dArray("pts",ptsDis);
		minBlock.setVector3d("vz",vecUp);
		minBlock.setVector3d("vy",-vecSide);
		Vector3d vxBlock=vecSide.crossProduct(vecUp);
		vxBlock.normalize();
		minBlock.setVector3d("vx",vxBlock);
		minBlock.setString("BlockName",sBlockName);
		minBlock.setDouble("OffsetZ",dOffsetZ);
		minBlock.setDouble("OffsetY",dOffsetY);
	}
	Map mDrawBlock=drawBlock(minBlock);
	
	return;
}
else if(nMode==2)
{ 
	// distribution at single panel
	// wall at concrete floor
	sConnectionType.setReadOnly(_kHidden);
	Sip sip;
	if(_Sip.length()==1)
	{ 
		sip=_Sip[0];
	}
	if(!sip.bIsValid())
	{ 
		reportMessage("\n"+scriptName()+" "+T("|One panel needed|"));
		eraseInstance();
		return;
	}
	Sip sipMale=sip;
	// basic information
	Point3d ptCen=sip.ptCen();
	Vector3d vecX=sip.vecX();
	Vector3d vecY=sip.vecY();
	Vector3d vecZ=sip.vecZ();
	_ThisInst.setAllowGripAtPt0(false);
	if(!_Map.hasInt("Side"))
	{ 
		// initialize
		_Map.setInt("Side",1);
	}
	
	assignToGroups(sipMale);
	//region Trigger FlipSide
	String sTriggerFlipSide = T("|Flip Side|");
	addRecalcTrigger(_kContextRoot, sTriggerFlipSide );
	if (_bOnRecalc && _kExecuteKey==sTriggerFlipSide)
	{
		_Map.setInt("Side",-_Map.getInt("Side"));
		setExecutionLoops(2);
		return;
	}//endregion
	// side 1-> -vecZ
	// side -1->vecZ
	int nSide=_Map.getInt("Side");
	Vector3d vecSide=-vecZ;
	if(nSide==-1)vecSide=vecZ;
	vecSide.vis(ptCen);
	
	Point3d ptSide=ptCen+.5*sip.dH()*vecSide;
	
	Map mInAddition;
	{ 
		mInAddition.setPoint3d("pt",_Pt0);
	}
	// get the panel edges 
	Map mEdges=getPanelEdges(sip,mInAddition);
	// start,end,mid point of each edge
	Point3d ptMids[]=mEdges.getPoint3dArray("Mids");
	Point3d ptStarts[]=mEdges.getPoint3dArray("Starts");
	Point3d ptEnds[]=mEdges.getPoint3dArray("Ends");
	// get the edge
	int nIndexEdge=mEdges.getInt("IndexEdgeSelected");
	Vector3d vecDirDistribution=ptEnds[nIndexEdge]-ptStarts[nIndexEdge];
	vecDirDistribution.normalize();
	
	Point3d ptStartDistribution=ptStarts[nIndexEdge];ptStartDistribution+=vecSide*(vecSide.dotProduct(ptSide-ptStartDistribution) + dFlushExtraGap - dOffsetZ);
	Point3d ptEndDistribution=ptEnds[nIndexEdge];ptEndDistribution+=vecSide*(vecSide.dotProduct(ptSide-ptEndDistribution) + dFlushExtraGap  - dOffsetZ);
	if(dOffsetBetween==0)
	{ 
		dOffsetBetween.set(U(100));
	}
	// calculate the distribution
	int nDistribution=sDistributions.find(sDistribution);
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
	Point3d ptsDis[]=mDistribution.getPoint3dArray("ptsDis");
	for (int p=0;p<ptsDis.length();p++) 
	{ 
		ptsDis[p].vis(1); 
	}//next p
	
	//region Trigger ReiheAufloesen
//	String sTriggerReiheAufloesen = "Reihe auflösen";
	String sTriggerReiheAufloesen=T("|Explode distribution|");
	addRecalcTrigger(_kContextRoot, sTriggerReiheAufloesen );
	if (_bOnRecalc && _kExecuteKey==sTriggerReiheAufloesen)
	{
		
	// create TSL
		TslInst tslNew; Vector3d vecXTsl=_XW; Vector3d vecYTsl=_YW;
		GenBeam gbsTsl[1]; Entity entsTsl[]={}; Point3d ptsTsl[]={_Pt0};
		int nProps[]={};
		double dProps[]={dOffsetBottom,dOffsetTop,dOffsetBetween,
			dOffsetZ,dOffsetY,dDepth};
		String sProps[]={sConnectionType,sDistribution};
		Map mapTsl;
		
		// 2 beams
		gbsTsl[0]=sip;
		
		// mapTsl
		mapTsl.setInt("mode",102);
		mapTsl.setInt("Side",nSide);
		mapTsl.setInt("IndexEdge",nIndexEdge);
		
		for (int p=0;p<ptsDis.length();p++) 
		{ 
			ptsTsl[0]=ptsDis[p]; 
			
			tslNew.dbCreate(scriptName(),vecXTsl,vecYTsl,gbsTsl,entsTsl,
				ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
		}//next p
		
		eraseInstance();
		return;
	}//endregion
	
	// upwar vector
	Vector3d vecUp=vecZ.crossProduct(vecDirDistribution);
	if(vecUp.dotProduct(ptCen-ptMids[nIndexEdge])<0)
	{ 
		vecUp*=-1;
	}
	// save in _Map
	_Map.setPoint3dArray("ptsDis",ptsDis);
	_Map.setVector3d("vecUp", vecUp);
	Map mInTooling;
	{ 
		mInTooling.appendPoint3dArray("pts",ptsDis);
		mInTooling.setInt("Side",nSide);
		mInTooling.setDouble("OffsetZ",dOffsetZ);
		mInTooling.setDouble("OffsetY",dOffsetY);
		mInTooling.setDouble("Depth",dDepth);
		
		mInTooling.setVector3d("vecUp",vecUp);
	}
	Map mTooling=doToolingAtPanels(_Sip, mInTooling);
	
	Map mInSymbol;
	{ 
		mInSymbol.setDouble("OffsetZ",dOffsetZ);
		mInSymbol.appendPoint3dArray("pts",ptsDis);
		mInSymbol.setInt("Color", 6);
		mInSymbol.setVector3d("vecUp",vecUp);
		// 20241129
		mInSymbol.setInt("side",nSide);
	}
	Map mDrawSymbol=drawSymbol(_Sip,mInSymbol);
	
// Hardware//region
// collect existing hardware
	HardWrComp hwcs[] = _ThisInst.hardWrComps();
	
// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
	for (int i=hwcs.length()-1; i>=0 ; i--) 
		if (hwcs[i].repType() == _kRTTsl)
			hwcs.removeAt(i); 

// declare the groupname of the hardware components
	String sHWGroupName;
	// set group name
	{ 
	// element
		// try to catch the element from the parent entity
		Element elHW =sipMale.element(); 
		// check if the parent entity is an element
		if (!elHW.bIsValid())	elHW = (Element)sipMale;
		if (elHW.bIsValid()) 	sHWGroupName=elHW.elementGroup().name();
	// loose
		else
		{
			Group groups[] = _ThisInst.groups();
			if (groups.length()>0)	sHWGroupName=groups[0].name();
		}		
	}
// add main componnent
	{ 
		HardWrComp hwc=getMainHardwareDefinition(ptsDis.length());
		
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(sipMale);	
	// apppend component to the list of components
		hwcs.append(hwc);
	}
// add HSW Hanger bolt
	{ 
		if( nFastener > 0)
		{
			String sHardwareInfos[0];
			String concreteHardware[] = { sFastenersArticles[nFastener - 1], sFastener, sFastenersLength[nFastener - 1] };
			sHardwareInfos =  concreteHardware;

			HardWrComp hwc=getHardwareDefinitionHSW(ptsDis.length(), sHardwareInfos);
			
			hwc.setGroup(sHWGroupName);
			// only one panel, link to this panel
			hwc.setLinkedEntity(sipMale);
		// apppend component to the list of components
			hwcs.append(hwc);			
		}
	}

// make sure the hardware is updated
	if (_bOnDbCreated)	setExecutionLoops(2);				
	_ThisInst.setHardWrComps(hwcs);	
//endregion
	
	Map minBlock;
	{ 
		minBlock.setPoint3dArray("pts",ptsDis);
		minBlock.setVector3d("vz",vecUp);
		minBlock.setVector3d("vy",-vecSide);
		Vector3d vxBlock=vecSide.crossProduct(vecUp);
		vxBlock.normalize();
		minBlock.setVector3d("vx",vxBlock);
		minBlock.setString("BlockName",sBlockName);
		minBlock.setDouble("OffsetZ",dOffsetZ);
		minBlock.setDouble("OffsetY",dOffsetY);
	}
	Map mDrawBlock=drawBlock(minBlock);
	
	return;
}
else if(nMode==101)
{ 
	// single instance at male-female panel
	// set to hidden the properties not needed
	sConnectionType.setReadOnly(_kHidden);
	sDistribution.setReadOnly(_kHidden);
	dOffsetBottom.setReadOnly(_kHidden);
	dOffsetTop.setReadOnly(_kHidden);
	dOffsetBetween.setReadOnly(_kHidden);
	
	// single instance at 2 panels
	Sip sipMale;
	Sip sipFemale;
	
	if(_Sip.length()==2)
	{ 
		sipMale=_Sip[0];
		sipFemale=_Sip[1];
	}
	
	if(!sipMale.bIsValid())
	{ 
		reportMessage("\n"+scriptName()+" "+T("|No male panel found|"));
		eraseInstance();
		return;
	}
	
	if(!sipFemale.bIsValid())
	{ 
		reportMessage("\n"+scriptName()+" "+T("|No female panel found|"));
		eraseInstance();
		return;
	}
	
	// 
	assignToGroups(sipMale);
//	assignToGroups(sipFemale);
	// basic information
	Point3d ptCen=sipMale.ptCen();
	Vector3d vecX=sipMale.vecX();
	Vector3d vecY=sipMale.vecY();
	Vector3d vecZ=sipMale.vecZ();
	
	Point3d ptCen1=sipFemale.ptCen();
	Vector3d vecX1=sipFemale.vecX();
	Vector3d vecY1=sipFemale.vecY();
	Vector3d vecZ1=sipFemale.vecZ();
	
	
//	_Pt0=ptCen;
	
	sipMale.envelopeBody().vis(1);
	sipFemale.envelopeBody().vis(3);
	
	
	if(!_Map.hasInt("Side"))
	{ 
		// initialize
		_Map.setInt("Side",1);
	}
	
	//region Trigger FlipSide
	String sTriggerFlipSide = T("|Flip Side|");
	addRecalcTrigger(_kContextRoot, sTriggerFlipSide );
	if (_bOnRecalc && _kExecuteKey==sTriggerFlipSide)
	{
		_Map.setInt("Side",-_Map.getInt("Side"));
		setExecutionLoops(2);
		return;
	}//endregion
	// side 1-> -vecZ
	// side -1->vecZ
	
	int nSide=_Map.getInt("Side");
	Vector3d vecSide=-vecZ;
	if(nSide==-1)vecSide=vecZ;
	vecSide.vis(ptCen);
	
	
	Map mDistributionLine = getDistributionLineOf2Panels(_Sip, nSide);
	Point3d ptMidDistribution=mDistributionLine.getPoint3d("ptMid");
	Vector3d vecDirDistribution=mDistributionLine.getVector3d("vecDir");
	Line lnDistribution(ptMidDistribution, vecDirDistribution);
	_Pt0=lnDistribution.closestPointTo(_Pt0);
	
	Point3d pts[0];pts.append(_Pt0);
	Map mInTooling;
	{ 
		
		mInTooling.appendPoint3dArray("pts",pts);
		mInTooling.setDouble("OffsetZ",dOffsetZ);
		mInTooling.setDouble("OffsetY",dOffsetY);
		mInTooling.setInt("Side",nSide);
		
//		mInTooling.setDouble("Depth",dDepth);
		double dDepthTooling=-dOffsetY+dDepth;
		mInTooling.setDouble("Depth",dDepthTooling);
	}
	Map mTooling=doToolingAtPanels(_Sip, mInTooling);
	Map mInSymbol;
	{ 
		mInSymbol.setDouble("OffsetZ",dOffsetZ);
		mInSymbol.appendPoint3dArray("pts",pts);
		mInSymbol.setInt("Color", 6);
		// 20241129
		mInSymbol.setInt("side",nSide);
	}
	Map mDrawSymbol=drawSymbol(_Sip,mInSymbol);
	
	// Hardware//region
	// collect existing hardware
		HardWrComp hwcs[] = _ThisInst.hardWrComps();
		
	// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
		for (int i=hwcs.length()-1; i>=0 ; i--) 
			if (hwcs[i].repType() == _kRTTsl)
				hwcs.removeAt(i); 
	
	// declare the groupname of the hardware components
		String sHWGroupName;
		// set group name
		{ 
		// element
			// try to catch the element from the parent entity
			Element elHW =sipMale.element(); 
			// check if the parent entity is an element
			if (!elHW.bIsValid())	elHW = (Element)sipMale;
			if (elHW.bIsValid()) 	sHWGroupName=elHW.elementGroup().name();
		// loose
			else
			{
				Group groups[] = _ThisInst.groups();
				if (groups.length()>0)	sHWGroupName=groups[0].name();
			}		
		}
	// add main componnent
		{ 
			HardWrComp hwc=getMainHardwareDefinition(1);
			
			hwc.setGroup(sHWGroupName);
			hwc.setLinkedEntity(sipMale);	
		// apppend component to the list of components
			hwcs.append(hwc);
		}
	// add HSW Hanger bolt
		{ 
			if(nFastener > 0)
			{
				String sHardwareInfos[0];
				String concreteHardware[] = { sFastenersArticles[nFastener - 1], sFastener, sFastenersLength[nFastener - 1] };
				sHardwareInfos =  concreteHardware;

				HardWrComp hwc=getHardwareDefinitionHSW(1, sHardwareInfos);
				
				hwc.setGroup(sHWGroupName);
				// only one panel, link to this panel
				hwc.setLinkedEntity(sipFemale);
			// apppend component to the list of components
				hwcs.append(hwc);			
			}
		}
	// make sure the hardware is updated
		if (_bOnDbCreated)	setExecutionLoops(2);				
		_ThisInst.setHardWrComps(hwcs);	
	//endregion
	// draw body via Blocks
	Vector3d vecUp=sipFemale.vecZ();
	if(vecUp.dotProduct((sipMale.ptCen()-sipFemale.ptCen()))<0)
	{ 
		vecUp*=-1;
	}
	Map minBlock;
	{ 
		minBlock.setPoint3dArray("pts",pts);
		minBlock.setVector3d("vz",vecUp);
		minBlock.setVector3d("vy",-vecSide);
		Vector3d vxBlock=vecSide.crossProduct(vecUp);
		vxBlock.normalize();
		minBlock.setVector3d("vx",vxBlock);
		minBlock.setString("BlockName",sBlockName);
		minBlock.setDouble("OffsetZ",dOffsetZ);
		minBlock.setDouble("OffsetY",dOffsetY);
	}
	Map mDrawBlock=drawBlock(minBlock);
	
}
else if(nMode==102)
{ 
	// single instance at one panel
	// set to hidden the properties not needed
	sConnectionType.setReadOnly(_kHidden);
	sDistribution.setReadOnly(_kHidden);
	dOffsetBottom.setReadOnly(_kHidden);
	dOffsetTop.setReadOnly(_kHidden);
	dOffsetBetween.setReadOnly(_kHidden);
	
	Sip sipMale;
	if(_Sip.length()==1)
	{ 
		sipMale=_Sip[0];
	}
	
	if(!sipMale.bIsValid())
	{ 
		reportMessage("\n"+scriptName()+" "+T("|No male panel found|"));
		eraseInstance();
		return;
	}
	// basic information
	Point3d ptCen=sipMale.ptCen();
	Vector3d vecX=sipMale.vecX();
	Vector3d vecY=sipMale.vecY();
	Vector3d vecZ=sipMale.vecZ();
	Sip sip=sipMale;
	
	if(!_Map.hasInt("Side"))
	{ 
		// initialize
		_Map.setInt("Side",1);
	}
	assignToGroups(sipMale);
	//region Trigger FlipSide
	String sTriggerFlipSide = T("|Flip Side|");
	addRecalcTrigger(_kContextRoot, sTriggerFlipSide );
	if (_bOnRecalc && _kExecuteKey==sTriggerFlipSide)
	{
		_Map.setInt("Side",-_Map.getInt("Side"));
		setExecutionLoops(2);
		return;
	}//endregion
	// side 1-> -vecZ
	// side -1->vecZ
	
	int nSide=_Map.getInt("Side");
	Vector3d vecSide=-vecZ;
	if(nSide==-1)vecSide=vecZ;
	vecSide.vis(ptCen);
	
	Point3d ptSide=ptCen+.5*sip.dH()*vecSide;
	
	Map mInAddition;
	{ 
		mInAddition.setPoint3d("pt",_Pt0);
		if(_Map.hasInt("IndexEdge"))
		{ 
			mInAddition.setInt("IndexEdgeInput",_Map.getInt("IndexEdge"));
		}
		
	}
	// get the panel edges 
	Map mEdges=getPanelEdges(sip,mInAddition);
	// start,end,mid point of each edge
	Point3d ptMids[]=mEdges.getPoint3dArray("Mids");
	Point3d ptStarts[]=mEdges.getPoint3dArray("Starts");
	Point3d ptEnds[]=mEdges.getPoint3dArray("Ends");
	// get the edge
	int nIndexEdge=mEdges.getInt("IndexEdgeSelected");
	Vector3d vecDirEdge=ptEnds[nIndexEdge]-ptStarts[nIndexEdge];
	vecDirEdge.normalize();
	
	Point3d ptMidEdge=ptMids[nIndexEdge];
	ptMidEdge+=vecSide*vecSide.dotProduct(ptSide-ptMidEdge);
	Line lnDistribution(ptMidEdge, vecDirEdge);
	_Pt0=lnDistribution.closestPointTo(_Pt0);
	
	Vector3d vecUp=vecZ.crossProduct(vecDirEdge);
	if(vecUp.dotProduct(ptCen-ptMids[nIndexEdge])<0)
	{ 
		vecUp*=-1;
	}
	Point3d pts[0];pts.append(_Pt0);
	Map mInTooling;
	{ 
		mInTooling.appendPoint3dArray("pts",pts);
		mInTooling.setInt("Side",nSide);
		mInTooling.setDouble("OffsetZ",dOffsetZ);
		mInTooling.setDouble("OffsetY",dOffsetY);
		mInTooling.setDouble("Depth",dDepth);
		
		mInTooling.setVector3d("vecUp",vecUp);
	}
	// save in _Map
	_Map.setPoint3dArray("ptsDis",pts);
	_Map.setVector3d("vecUp", vecUp);
	Map mTooling=doToolingAtPanels(_Sip, mInTooling);
	Map mInSymbol;
	{ 
		mInSymbol.setDouble("OffsetZ",dOffsetZ);
		mInSymbol.appendPoint3dArray("pts",pts);
		mInSymbol.setInt("Color", 6);
		mInSymbol.setVector3d("vecUp",vecUp);
		// 20241129
		mInSymbol.setInt("side",nSide);
	}
	Map mDrawSymbol=drawSymbol(_Sip,mInSymbol);
	
	// Hardware//region
	// collect existing hardware
		HardWrComp hwcs[] = _ThisInst.hardWrComps();
		
	// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
		for (int i=hwcs.length()-1; i>=0 ; i--) 
			if (hwcs[i].repType() == _kRTTsl)
				hwcs.removeAt(i); 
	
	// declare the groupname of the hardware components
		String sHWGroupName;
		// set group name
		{ 
		// element
			// try to catch the element from the parent entity
			Element elHW =sipMale.element(); 
			// check if the parent entity is an element
			if (!elHW.bIsValid())	elHW = (Element)sipMale;
			if (elHW.bIsValid()) 	sHWGroupName=elHW.elementGroup().name();
		// loose
			else
			{
				Group groups[] = _ThisInst.groups();
				if (groups.length()>0)	sHWGroupName=groups[0].name();
			}		
		}
	// add main componnent
		{ 
			HardWrComp hwc=getMainHardwareDefinition(1);
			
			hwc.setGroup(sHWGroupName);
			hwc.setLinkedEntity(sipMale);	
		// apppend component to the list of components
			hwcs.append(hwc);
		}
	// add HSW Hanger bolt
		{ 
			if(nFastener > 0)
			{
				String sHardwareInfos[0];

				String concreteHardware[] = { sFastenersArticles[nFastener - 1], sFastener, sFastenersLength[nFastener - 1] };
				sHardwareInfos =  concreteHardware;

				HardWrComp hwc=getHardwareDefinitionHSW(1, sHardwareInfos);
				
				hwc.setGroup(sHWGroupName);
				// only one panel, link to this panel
				hwc.setLinkedEntity(sipMale);
			// apppend component to the list of components
				hwcs.append(hwc);			
			}
		}
	// make sure the hardware is updated
		if (_bOnDbCreated)	setExecutionLoops(2);				
		_ThisInst.setHardWrComps(hwcs);	
	//endregion
	
	Map minBlock;
	{ 
		minBlock.setPoint3dArray("pts",pts);
		minBlock.setVector3d("vz",vecUp);
		minBlock.setVector3d("vy",-vecSide);
		Vector3d vxBlock=vecSide.crossProduct(vecUp);
		vxBlock.normalize();
		minBlock.setVector3d("vx",vxBlock);
		minBlock.setString("BlockName",sBlockName);
		minBlock.setDouble("OffsetZ",dOffsetZ);
		minBlock.setDouble("OffsetY",dOffsetY);
	}
	Map mDrawBlock=drawBlock(minBlock);
	
}









#End
#BeginThumbnail
M0DW<AP4``````#8````H````D0$``"T!```!`!@``````*:'!0`2"P``$@L`
M````````````________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________________O?__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________S[_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________^^________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________/?______________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________SW_
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________^^________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________N?______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________[[_____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________^^
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________/?______________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________[W_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________^]____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
MO?__________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________S[_____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________\\____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________/O__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_S[_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________\^____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________O/__________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________[[_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__\]________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________O?__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________S[_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________\]________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____/?______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________SS_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________^]________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________/O______________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____[[_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________________________________________^
M_O_[_OW__OW___________[]_?O_________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________\]________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________O[\_________OW_^_O[____
M_?S]^OS]_/[]________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________/O______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______S\_?____W]_?W\^__^_?________W\_?____________W]_?O[^___
M_?W]_?______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________S[_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________________________]_?[_________
M___________]_?[______OW^_?_______OW^_?_^_?___OW_____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______\^____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________?W]_____/S]_________O[__O[_
M_O[______/S]^OW^^_[]_?W[_O[__/S]____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________.O______
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________S\_?____________O\__[]____________________
M_____</#Q.KJ[/[^__W]^?______________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________[[_____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________]_?W________[^_O___W__?K__OV[O+Z+BY!K:VUF9F9V=WKL
MZ^K[_?______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________\^____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________?W]____
M_____?W]__[]W^#AG9ZC<7%R9F=G:&AF:&=E:&=H9V=G>'A[ZNKL________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________/?__________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___^_?_^_?O\__S______OW]_?W]_?W]_?_______?S___[]_^#?X(V-CVAH
M:&EH9VAG9V=G9V=G9V=G9V9G9V=H:&=G:'AX>>GJ[?___O________[^____
M___^_?S_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________[[_____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________O______
M___[_/_____^_O[__OW____\_/_N[>^/CI%H:&9G9V=F9F=H:&EH9V=H9V=H
M9V=G9V=G:&AG:&AG9VAG9VAX>7OLZ^O___W^_O_____\___^_?_^_O[_____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________^^____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________/___________?W]_OW_^OW^___]
M_OW_____L[.U;&UN9V=E9F9F:&=H9VAH:&AH:&=G:&=G:&=G:6AH:&=G9F9F
M9VAH9F=G9V9E>'AZZNOM_?W]^OW]____^OW]________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________OO__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________S______?____S\_?____S___S\_>[M[HB(B6=G9V=G
M96AG:&=F:&=G9VEH:&AG:&AH:&=G9VAG9V=F9FEH:&AG9VAG9VAG9V=G9V9G
M9WAX>NKK[/____S____^_?W]_O__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________SW_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______^_?_\^_?____\_______6U=AR<G1H9V=G9VAG9VAG9V=F9V=F9V=H
M9V=H9V=H9V=H9V=H:&AH9V=G9V=G9V=H9V=H9V=F9VAH9VAH9V=X=WGJZ^[^
M_/W_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\^____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________[]__[_
M________RLG,;&YM9F9F9V=H9V=H:&=H9V=H9VAH9V=G9V=G9V=H9F9G9V=H
M9V=H9V=H9V9G9V9G9V=F:&=G9F9F9V=G:6=G:&AH?GY_____^_S__?W]____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________/O__________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________?O\_________[:VNFAH:&=F
M96AG9V=H:&AH:6AG:6AG9V=G9V9G:&=G:&AH:69G:&AI:69F9VAH:69G9VAG
M:&AH9V=G9VAH9V9G9V=G:&EG9V=G9XR,CO[]_?___O__________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________[[_________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________[_?[^_?_6U=1G9VAH9F=H9VAG9VAH9V=G9V=G
M9F9H:&EG9V=G:&AH9V=H9VAH:&EQ<7*8EI5K:VQG:&AG9VAH9VAG9V=H9V=H
M9VAF9V=G:&AH9VAH9V>,C([[_/__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________\^________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________OW__?W]
M_____/______U]76;&UM9V=G9F9H:&AF9V=G9V=G:&=G:&=G:&=G9VAF9F9F
M9VAH<7%SI:6HV=G9U=?9O;Z^:VQN:&=G9V=G9F=G:&=G:&=G9V=G9V=H:&=G
M9V9E9V=HCHV/_/____[]_____O[__?S]_________/__________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________________O?__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________W]_?____[^_O_______________^_N[WAY
M?&=H:&=G:&AH9F=G:6=G9VAG9V=G9V=G:&=G9V=F:&AH:9:6F-'/SMG7U]C8
MV-C9V=C8V+V\O69F:&=G9VAG9VAG:&=G:&=G9V=G9V=G9V=F9V=F9V9F9XN,
MC_W]_?____[]_______^_?O[^___________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________[W_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________^_OS]_?W_______^8F9QG9V=F9V=G9VAG9V=G
M:&AG:&AH:&AG9VAG9V=G:&EK:VVUL[;9V-C7V-C8V-K9V=G8V-C8V-K:V-BF
MIJ=F9F=G9F9G9F=G9VAF9V=G:&AG9V=H9VEH9VAH9V5H9V>+C([_________
M___Z_/S__OW\_/W_____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________^]________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________/S____]____
M_OW______/[]_?W]__[_R\G+9VAI9V=G:&=G9V9F:&AJ9VAH9VAH:&=H:&AG
M9F=G=79VT=#/U]?7U]C;U]C8U]G9V-C8VMK:V-C8V-G8V=G9IJ6F:&AI:&AH
M:&=H9V9G:&=G:&=G:&=G9V9F:&AH9VAH9F=GC(R-_____/______^_O\____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________/?______________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________[^___^_?____[^______K\_?[^
M_____WEY?&=G9V=G9VEH:&=F9F=G9V9G9VAH:&=G:&9G9W5V=]'0S]?8V-?8
MVMC:V-C8VM?7U]G:V=C8V-C8V-C9V=G:VMC8V*:FJ6=G:&AH:&AH:&=G:&AG
M9V=H:&=H:&9G9V=G9V=G9VEH:8R,C_____[^_?____O[^_______________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________[S_
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________^_O_]_?O____\_/W____]_/W^_?VUM+=F9V=G9VAH
M9V=G9VAH:&AG9V=G9F=H9V5G9F9V=WK0T-'8VMK7V=G:V=C8V-C8VMK9V=G9
MVMG8V=C:VMK8V=G5UM79V]O9VMNFI:9G:&AG9V5G9V=G9VAF9F=G9V=F9F9G
M9VAF9V=F96=H:&F=G)S____]_?W__OW_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________^^________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____OW_______________[]^_S___WZ<7)U9V=G:&AI9V=H9V=G:&AH9V=H
M9V=G:&=G;&QMQ,/$U]?9V-K;V=C8V=G9V-G8V-G9V=G;V=G9V-G8V-C8VMK:
MVMK:U]?7V=K;VMK9I:2F9V=H9V=H:&=H9V=H9F=G:&AH9V9F:&AI9F=G:&AH
M9V=HL;"P_?W]___]____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________//______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________[]________
M_______^_?___[V]P6AH9F9G9V=F9VAH9V=G9V=G:&=G:&AG9VAG:*RML-K9
MUMK8V=C9VMC9W-C8V-G9V=G9V]C:V=?9V]G9V=C8V-K:V=G9V]C9V-G9V-;8
MV=K:V:6DI6=H:&AH:&=F9VAG:&AG9VAG:&=G9V=G9F=G9V=H:&AG:;&PL?S_
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________S[_____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________OW^_?________^%
MA8EG9V=H9VAH9V5H:&9H9VAG9F=I9V=H9VA\?7_9V=G:VMG8V-C9V=C9V=G7
MU]?9V=G8V-K9V=G8V-C8V-C8V=C8V-C8V-C8V=C9V=G:VMK8V=O8VMJEI*9F
M9F=H9V=G9V=F9VAH9VAH9V=F9V=G9VAG9F=G9F9E9FBPKK#\______W]_/_^
M_O[\_O[____^_?______________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________\^
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________?W^_O[__?SX___]WM[A9VAH:&=G:&=H:&=G
M9V=G9VAH:&=G:&AH9V=IQ\;%V=G8V-C8VMK:VMK<V-C8V-C7V-C7V-C:V-C8
MV-C8V-G8V-C8V=G9V=G9V=G9V-C8V-C8VMK9U]G9U]?6IJ:G9V=H9V=G:&=G
M9V9H9F9F:&AH9V9F:&=G9V9G9F=G9F=IKZ^P_OW__?S[_________/___/[]
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________/?______________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______^_?W\_?S\__K\^____ZBHJF=G9VAG9VAG:&=G9FAH:69F9V9G9VAH
M:(B(BMC8U]C9V-C9V-K:V=C9V-C8V-K:V=G9V-C8V-G9V=C8V-C8V-C8V-C8
MV-C8V-C9V-C8V-O9VMG9V=?7U]?9V]C8UX>(BFAH:6=G9VAH:&=G9V9F9F=G
M9FAG9VAG:&AG:&=G9V=H:+"OL?W^_/____[]___^_?S]_?______________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________SO_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________W_____
M___\___]_?V`?X)G9VAG9VAG9VAH9V=G9F9G9VAG9V=G9V=K;&Z]O+W:VMG9
MV=G8V-C:VMK8V-C9V=O9V=G9V=C9V=G8V-C8V=C8V-C9V=G8V-C8V-C8V=C7
MU]?:VMK9VMO7U]G8VMG:V=B)B8QG9VAH:&AG9VAG:&AG9VAH:&AG9V=H9V=H
M9VAG9F=G9V>QL+/____________^_O[\____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\]____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________OW]__[]_/______9V=H
M:&=G969F9VAH9F9F:6AH:&=G:&=H9V=H:&AI:VQMOKV^VMG9U]C9U]?7V=K9
MV-G;V-C:V-C8V-C8V-C8V-G8V-C8V-C8V-C8V-C8V-C8U]G9U]?7V=G9V=G8
MV-C:V-C:VMG8B(F,9V=H:&=G9V=G9VAH9V=H9V=E9F9F9V9H9V=H:&AG9V=G
MK["S_________/W]_O[^________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M/?__________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________[^_____OK]_?[^_G5V>6AH:&9G9V9G9V=F
M9F=G9VAG9VAG:&=F9VAH9VAH9FIL;+Z\O=K8VMC8V-K9V-C9V-C9VMG:V]C9
MV-G9V=C9V-G9V=C8V-G9V=C8V-C9V-;7V=K:V=O9V-K9V=C9VMK:V=C9V-C8
MV(F)C&=G:&=G9F=G9V=G:&9G9VAH:&=G:&AG:6AG:&9F9F=H:,3#Q_[^_/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________[[_____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________W____]_?W___[LZ^IV=WIG9VAG9V=H:&AH9V=G9V=G9VAG
M9VAH9V=H:&AG9V=L;&Z^O;[9V-C9V=G9V=C8V=C8V=O8V-C9V=G8V-C8V=C8
MV-C8V-C8V-C9V=G:VMK9V=G8V-?9V=G7U]?9V=G8V-C8V-C:V=B)B8MG9VAH
M9V=G9F=G9V=G9V=I:&AF9F=G9V=G:&AG9V=K;&S1S]'Y^/7_____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________\^____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________/SZ____
M_?[\_OW____]_OW_[>KL>'AX9V=G9V=H9V=H9F=G:&AH9V=G:&=H9V=H:&=G
M9V=F:VQLQL7&V-C:VMK9V-C7VMK:V-C8V=G9V-G8V-G8V-G8V=G9V=G9V-G8
MVMG8VMK9V-G:V-K9V=G9VMK9V=G9U]C8U]C9VMC7B8F,9V=H:&=G:6AH:&=H
M:&=H9V=H9V=H:&=G9V=G9VAH;&QOT<_2_/__________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________OO__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__O[_.KK[GAX>6=H:&AH:&AG:&AG9VAG9V=G:&AG:&=G:&=G9V=G979W>-#/
MSMG9V=C8U]G9V=C8V-G:V]C8VMK:VMC8V-?7V=G9V]G9V=G9V=C9V-C8V-G9
MV=C9V-G9V=C8V-G9V=C9V-?9V]C8V(B)BVAG:&AG:&=F9V=H:&AG9V=G:&9F
M9V=G:&AH:69G9VML;M#.SOK]___^_____________?K]_O[^___^_?______
M______W]_?____W]_?_______?__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_[[_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________________________________[^_OLZ^IV
M=WIG9VAH9V5G9V=F9V=F9V=G9V=F9V=H9V=H9VAG9VAU=GC/SL[:V]S9V=G:
MVMK9V=G9V=G8V-C9V=G8V=C:VMG9VMO9V=G8V-C8V-C8V-C8V-C9V=G9V=G8
MV=C7U]?8V-C;V]K9V=F)B8MG9V=H9V9G9VAH9V=F9F9G:&AH:&AH9V5H9V=F
M9FAK:VW/S]#^_/O]_/W__OW\_/___O_[^_O^_O_____\_/W__OW____]_?[_
M___]_?W_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________^]____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________/S]_________/__ZNGK>'E[9V=G9V=G
M9F=G:&AH9F9G9V=G:&AH9V9G:&AH:&AH=G=ZS\[.VMK9V-K9V-C7V=G8V=G9
MV-C:VMK9V-G8V=G;V-C8V-C8V-C8V-C8V-C8V-C8V-G8V-G8V-?:V=G8V=K;
MV-G:S]#0=G=X9F9F:&=G9V=H9VAH9V=H9VAH9V=G:6AH9V=G9V=G:FMKT,_1
M_____?S]_____________?W[_____________O[^_____/S_____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________O?__________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________W]_?____________S______^OJZG=W>6=G9VAG9V=G:&AH:6=G
M9V=G:&=H:&AG9VAG9VAG9W5V>-#/S]?7V=K:V=G9V-C8V-G:V]?7U]O;V]C8
MV-C9V-G9V=C9V-G9V=G9V=C9V-C9V-C9V-K:V=?7V=C8U]C9V]G;VLW.SG9W
M>6AH:&=G:&=G9V=H:&=G:&AG:6AH:&AG96AG:&AG:&ML;,W-T/___?K]_?W^
M_/_^_?[]______S\_?____________W]_?____S]_?__________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________[W_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________OW]_OS[^_S>WN%K;&UG9V=H9V=G9F=G9F=H9VAG:&AF9F=H
M9VAH9V=G9V=V=WK/S\_9V=C8V=K9V=G6UM;:VMK7V-C9V=G9V=G8V-C9V=G8
MV-C8V-C8V=C8V=C9V=G7V-C9V=G8V-C9V-;8V-K:V]K/SLYU=7=H:&AH9VEG
M9F=H:&AF9F=G9VAH:&AG9F=G9V=H:&EK;&W0SM'__?K\_OW_____________
M_______[^_S____]_?W_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__\]________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________/S]________________________________
M_?S]_/___?W]SLW0;&QM9V9F:&=G9V9G:&=G9VAH9V=G:&AH9F9G:&=H:&AF
M=79XS\[.V=C;V-G;V=G8V-C7V-C8V=G;V-G8V-C8V-C8V-C8V-C8V=G9V-C8
MV-C8V-G9V=G9V=G9V=K9V-?6V-C8V-C7T,_/=G9W9V=G:&=H9F9G9VAH:&AH
M9V=H9V=H9VAH9V=G:&=G9VAHPL#$^_K]_____?S[____^_O[_________?W]
M_______^_/W]________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________/O__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________[^__W\_?____O[_/__
M_]#/T6ML;6=G:&=H:6AG9VAG:&=F:&=G9VAH:6=F:&=G9V=H:'9W>M#/S]C8
MV-G9V=G9V-G9V=C8VMC8V-C8V-G9V=C8V-C8V-G9V=G9V=C8V-C8V-G:V=C8
MVMC9V-G9V]G9V-G9V=C9V\_.SG5V>&=G:&AG:&AH:&=G9V=G9VAG:&AH:69F
M:&=G96AG9V=G9W-T=K2TMO[]___]^O_^_?[^_?____W]_?____S]_?______
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________SW_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___]_?W____________________\______W___[____\_______0S]%L;&UF
M9V=G:&AG9F9G9V=H9VAG:&AG:&AG9VAH9V9E9F9U=GC8V-?7V-G8VMO9V=G9
MV=G8V-C8V-C9V=G9V=G9V=G9V=G8V-C8V=C:V=G8V-C7V=G7V-C5U]G7V-K8
MV=C9V=G8V=K0S\]V=G=H:&AG9VAH9VAG9V=G9V=I:&=I:&5F9V=G9VEG9F=H
M9V=H:&AS<W.>H*;LZ^O____[^_S____]_?W_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________^]________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________OW__________?W[S]'5;6QL9V=I9V=G:&AF
M:&=G9F=G:&AI:6=G9V9H:&AF9V=EB8F+VMG8U]G;V-G9V-C8VMK9V-G8V-C8
MV=K9V-G8V-C8V-G8VMK:V]G9V=G;UMC8V-K8V=G9V-C:V=G9V=C7V-G8UM?8
MT=#/;V]Q9V=G9V=G9V=G9V=E:&=H9V=G9V=G9V=H9V9H:&=G:&AH9V9G9V=H
M;&QNH:&EW][@_?W[_________?S]______________________________[_
M_OW__________?W]_OW___[__/S]_?S[____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____O?______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________W]_?____S\_?____W\^]#/T6QL;6AG:&=G9V=H:&=G:&=G9V=G
M9F=H:&=G9V=F9V9G9XF)B]O9V-C9VMC9V=K:V=C8V-G9V=C8V-K:VMC8V-?7
MU]C9V-C8VMG9V=C8V-C9V-C8V-G9V=C8V-?9V]C8V,W,S'9W>F%A869F96=F
M9VAG:&=G:&AG9FAG:&=F9V=G9V=G9V=G:&=F9VAG9V=G9V=G9V=G9V=G:)"0
ME.'?X/____S\_?S___________________[]__[]_____________?_^_?_^
M_?____________S]_?__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________S[_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___]_?W\_?W____[___0S]!K:VQF9V=H9V=G9FAG9V=G9V9G9V=G9VAH9VAH
M9V=G9VB)B8O;VMC7V-K8V=G9V=G8V=C8V-C8V=C9V=G:VMK8V=C8V=G9V=G7
MU]?9V=O7U]?8V-C9V=G9V=N\NKMJ:VQ@8F%A86%A8F)G9VAH9VEG9F=H9V=H
M9V=G9V=H:&AG9V=F9V=G9VAF9V=G9V9G9V5G9V=G9VAG9VAG:&B`@83)R,K^
M_?_______OW____]_?W]_?W__OW________________\_/W____\_/W\_?W_
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\]________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________?W]_____________/S]____________
M__[]_O[^S]#2:VQL:&=G9V=G9F9G:&=H9V=H9V=G9V=G:6AH9V9F:&=HB8F+
MV=G8V-C8V=G9V=K9V-C8V-G8VMK9V-C8V=G9U]C8V-G8V=G;V=G8U]C8V-K;
MV-C7JJFJ969F86%A8&%@86%A8&%@8F-C9F=G9V=G:&=I9V=H9V=G:&AI:&=H
M:&=G9VAH9V=G9F9G:&=H9V9F:&AH9V9G:&=H9V=G9VAF>GM\M+.V__[]^_O[
M______________[]_________?W]__[___[__?W]____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________OO______________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________W]_O________________S]_?[]_____?S___C[^[FY
MO6=G9V=G9VAG9VAG:&AG:&AH9V=G:&9G9VAG9V=G9V=G:(F*C-C8U]G:V=G9
MV]?7V=C8V-C8V-?8U]C8V-?7U]G9V=C9V-C9V-C:W-C8V**BHV%B8F)A86!@
M8&!A8&!@7V%A7V!@8&%B8F5E969F9FAH9FAH:&=F9VAG:&AG9VAG9V=H:&=F
M9VAG:&9G9V=H:&=G9VAG9VAG9VAG:&AG9V9F9W)R=*RLKNOK[?[]______S\
M_?S^_OO[^?________________S]_?[]____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____[W_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___\_/W________________________^_?_]_?W____]_?VOKK)H:&9H9V=G
M9V=H9V=G9F=H:&EG9V=G9V=H9VEH9VAG9V6(B(S;VMG9V-C9V=O9V=G8V-C9
MV=G9V=G9V=O8V-C8V=C:VMK8V-BAH*)A8F)A8%]A86%@86%@8&!A8F)@86!A
M8F)@8&!A85]J:VV%A89F9F=G:&AG9V=H:&EG9F=H:&EG9VAG9V=G9V=G9VAH
M9VAH:&AG9F9H9VAG9V=H:&EG9F=F9F9K;&ZAH:3?W^#______O_\___\___X
M^_S[_?S____]_?W^_O__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________\^________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________?W]_?W]
M_________________O[_________^OW]__[]L*^S9V=H9V=H9V=G:&=H9V9G
M:&AH:&AH9VAH:&=G:&=F9V=HB8F+V]G8U]?7V=K9V-C8U]?7V=K9V-C:VMK:
MVMK9V-?6A(2'86)B8&!@8&!@86%A8F)@8&!@8&%A86%B8&!@86%A96=GR\S/
M]O+QW-K8CX^19F=I9F9G9V=H:&=E9V=G9V=H:&AI:&=G9V=G:&=H9V=H9V=E
M9V=H9V=H9V9F:&=H9V=H9V=H969HCY"2X.#A_?S[_/W]_________/S]_?W]
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________O?______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________S]_?__________
M__S^_?[^_O________W]_?S\_;&PM&AH9F=G9V=G9V=G9V=F9V9G:&=G:&=G
M9V=G:&=G96=H:)"0DMG9V-G9V=?8V-G9V=?7UMC9V-C9V]C8VHR,CV!@8&%A
M7V%A86%A86%B8F%A86!A86!@86%A7V!A7F!A8J^NL/+R\O+S\O3S]//R\^?E
MY*"?HVQL;F=G9V=G9VAH:&AG9V=G9V=G9V=G9V=G:&AG:&9G9V=H:&=G9V9G
M9VAG9V=F9VAH:&AG9V9G9XF)B\G'R/___?S\_?[]_?_______?__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________SW_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________________________________]_?W\
M_?W_______W__OVMK[9G9V5F9FAH9V=G9V=G9FAG:&AG9V=G9V=I9VAH9V=F
M9VBDI*79V=G8V-K9VMG:VMG7V-K9V=NBH:%@85]@86%A86)A85]@8&!A86%A
M86%A86%A85]@8%YA86&;FYWR\_7R\_+P\/#T]?7R\_3P\?+T]//CY.2OL;9S
M<G-H9VAG9VAG9V=G9V=G9V=F9F=G9VAH9V=G9V=H9V=H:&AG9V=G9FAG9VAG
M9VAG9VAG9V=H:&B#@H6SLK?________\_OW\_?W____________\_?W____]
M_?W^_?____W___W___W________^_?_______OW_____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______\^____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________[]
M__[]KZ^S9V=F9V=H9F=G9VAH:&=G9V=H9VAH:&AH:&=G969F9F=II:6FV=C8
MV-G;UMC8V=K;H:&A8&%A86%A86%A8&%A86%A86%?8&%A7U]?8&!@86%@86)B
MBHJ,\O'P]//R\O+Q]/7U\?+R\?+S]/7U\/'P]/3S\O+P\_3SL;*T>7E[:&=G
M:6=G9V9H:&=G9V=F9V=H9V=G9F9F9V=G9V=H:&=I9V9F:&=G9V=H:&AI9V9H
M9V=H9V=F<G-SMK6W[.KL_____/S]_____O[__OW_______[]_O[^________
M_OW__/S]_?W]___]_/W]________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________OO______
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________W]_?_________^_?___Z^NL6=G
M:&9F9V=G96=G:&AG:6=H:&AG9V=G:&=G9VAH:&9F9Z:EIMC8U]?8V+.RM&!A
M8&!@7F%A86%A86!@8&!@8&%A7V!@86!A86%A7V!A88F*C/+S\_+R\O+Q\O'Q
M\/+S]/#R\O/T]?/T]/+R\O'Q\?+R\?'S]/+S]/3S\L3#PX*"A&9G9VEH:&=F
M9V=G:&=G:&=G:&9F9F9F9F=G:&EH:&=F9VAG9VAG9VAH:&EH:&AG9V=G9V=G
M:&QL;J*BI>[KZ?____W]_?S^_OS]_?____[]__[]______S]_?_____^_?__
M______S]_?__________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________SW_____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______^_O[____]_?W____]_?W________\_?W__O^NK[%G:&9H9V=H9VAF
M9V=G:&AG9VAH9V=H9V=G9F9H:&AG9VBFIJ:[NKQE969@86!@8&!@86%A86%@
M85]A86%A86)A85]A86!@86&+BXWU]/7R\?#R\?+S]/7Q\O/R\_3R\_3S]/7Q
M\O/S]/3R\_3Q\O/U\O/S\O'R\O'T]//P\?#;VMN/CY)G9VAH9V=G9VAG9VAH
M9V=I:&EG9VAH:&EF9F9G:&AF9V=G:&AF9F9G:&AH:&EG9V=H:&9H9VAF9F>0
MD)+@W^#\_/W^_?_Y^?K______OW____Z^OW^_?_^_O_____]_?[_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________\]____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________?W]____
M_____?W]_________/S]_____/______E967:&=G:&=H:&=H9F=G9V=H9V=F
M:&AH:&=H9V9F9V=G9VAH;6UP8&%A8&%@8&!@8&%@8&!>8F%A8&!@86%A8&!>
M86%BB8J-]?/T[^_O]//T]//S\O/T\O/T\O/S\?+S\_3U\_3U\_3T\?+R\_3T
M]//R]//R]?3U\/'R]/7U\O'P]?/QV=G9H:"C:VQM9V=E9V=G9F5F:&=I9V=G
M9V=H9F=G9V=G9V=G9F9F9F=G9F9F9VAH9V=H9V=H:&=H:&=G9VAHDI*3Q\;)
M____^OW^_O[_______[]_____O[__O[__O[_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________O?__________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________O[^_____W]_?______________
M__W]_?____________[]_8V-D&AG:&AG9V=G:&=G9V=G:&=H:&=G9VAH:&AH
M:&=G9VAG9V1D9&%A7V!A8&!A8&%A7V!?7V%@86%A7V%A88J*C//T]/+Q\/3S
M]/+S\O+S\O+R\O+S]/'R\_3U]?+S]/+S\_+S]//T]?/T]/+S]/+S\O+Q\/7T
M\_+Q\O/R]//T]//T]?/S\>3CY*FIJW-S=6AH:&=G:&AH9VAG96AG:&AG:&AH
M:&AG9V=F9V=G:&9G9VAH9F=G9V=G9VAG:&=F9VAG9V=H:("`@[Z]O_______
M_____OK[^_________O[_/______________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________[[_____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________]_?[^_O[____________]_?W____]
M_?W_______^,C(YG9VEH:&EH9V=H9VAF9V=F9V=H9V=H9VAG9V=H9V=H9VAC
M8V-@8&!@8&!@86!A86%@86%@8&&<FYWR\?#R\_+R\?+T\_3R\O'R\O'T\_+R
M\_3T]?7S]/7Q\O/S]/3R\_3Q\O/S]//S]/3R\_+R\_+Q\?'R\_3T]?7S\O/T
M\_+R\_3S]/7R\O/S\O2RL;5Y>7MH:&=G9V=G9F=G9F=G9VAG9V=H9V=H:&=G
M9V=G9V=H:&EG9F=G9VAG9V=G9V5F9V=H9VAH9VAQ<G2UM;;__OW^_?_]_?W_
M_OW[^_K_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________^]____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________^_O\_____________________OW______________/_____^
MC(R.:&9E:&=H9V=G:&AG:&=H9V9G:&=G9V=G9VAI:&=G:&=H8F-C8&%@8&%A
M8&!@7V%@KZZP\O/U]//R\O'R]/7U\O/T\O+R]//R\O'P\_3T\O/T\O/T\O/T
M\?+R\O/R\O+R\O/R]//T]?3R\_+Q]//R]O3S\?'Q]/3S\O+R\O'R\_/T\O+R
M\O+R\O/T]/+QQ,/%@("$9V=E9F9G9VAH9V=H9V=H9V=G:&AH9V=G:&=G:&AH
M:&=G9V=G:&=G9VAH9F=G9V=G:&=H:&=H;&UOH*"D[>SN^_S__OW_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________/?__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________________________]^HF+D6AH96AH
M:6=G:&=G9V=F9VAH:&=G9F=G9VAG9V=G:&AG:&%@86%A7F5G:,W-S/3R\?+R
M\O+R\?+R\O+R\O+R\?+R\?+S\O+R\O+R\?+R\O+R\O+R\O+R\O+R\?+S\O+R
M\O+R\?+R\O+S\O+R\O+R\O+R\O+R\O+R\?+S\O+R\O+R\O+S\O+R\?+S\O+R
M\?+R\=#.SX^/D69G9V=F9FAH:&=F9V9G9V=H:&AG9V=G9V=F9VAG:&AG:&AH
M:69G9V=G:&AG9V=H:&=G:&=G:&QL;9"0DM_>WOS___S^_?O\__[]______W]
M^____?_^_?S_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________SW_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______\_?W________]_?W^_?_]_?W^_/O__?J+BY!F9V=H9V=G9VAH9V=F
M9F9I:&AG9VAG9V=G9VAH9V9D9&1[?(#CXN+T\O'U]/7R\_+R\O'R\_+S\_+R
M\O+R\O'R\O'R\O+R\O'R\O+R\O'R\O+R\_+S\_+R\_+R\O'R\_+R\_+R\O'R
M\O'R\_+R\O'R\_+R\O+R\O+R\O'R\_+R\_+R\_+R\O+R\O+R\O'T\_#S\O3;
MVMV8F)QL;6UG9V5H9V=H9V=G9VAH:&AG9F9H:&AH:&=H9VAG9VAH9VAH9V=G
M9V=G9F=H9VAG9V=G9V=K;7'4TM/________\_?W^_O_____[_/K^_?______
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\\____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____/W]_OW_^_S__?W]________C(R/9V=G:&=G9V=H9VAH9V=H9V=G:&AH
M9V=G:&=G;6UL]/+Q\?+U\_3U\_+S\O/R\O/R\O+Q\O+R\O+Q\O/R\O/R\O/R
M\O/R\O+R\O+R\O/R\O/R\O+R\O/R\O+Q\O/R\O+Q\O/R\O/R\O+R\O/R\O/R
M\O/R\O+R\O/R\O+R\O/R\O/R\O/R\_/R\O/R\O/S\O/T\_3T\_3UY>3EH*"C
M<W)T9V=H:&AH9V=G9V=G9V=G9VAH9F9G:&AH:&=G9V9G9V=G:&AH:&=G:&AH
M:&=G9V9G;&UNU-/5_?W[_/_______/S]_OW_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________OO__________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________W\^_____O[^_[]
M__[]______W]_?___XZ-C6=H:&AH:&=G:&=F:&AH9F9G9V=G:&=F9F=G:+R[
MO/+S]?'R\/7T]?+S\O+R\?+S\O+R\O+R\?+S\O+R\O+R\?+R\?+R\?+R\?+R
M\O+S\O+R\O+R\O+S\O+R\O+R\O+R\?+R\O+S\O+R\O+R\?+R\?+S\O+S\O+R
M\O+R\O+R\?+S\O+S\O+R\O/R\_+Q\/3T\_+S\O+S]/+Q\_7T\K&QM'-S=6=G
M:6=H:&=H:&AH:&9F9F=G9V=G:&=G9V=G:&9F:&=G:&=G9VEH:&=G9FAG:&UM
M;M33U?O[^?____[^_OS\_?_______?______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________S[_________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________W___W____]_?W]_?W____\____
M_OW\_/]O<'!G9VEH9F9F9V=H:&AG9VAH9V=G9FAH9V>'B(OT\_#S]//S\O/R
M\O+R\O'R\O+R\_+R\O+S\_+R\O'R\O+R\_+R\O+R\_+R\O'R\_+R\O'R\O'R
M\O+R\O'R\O+R\O+R\O'R\_+R\O'R\O'R\O'R\O+R\O+R\O+R\O+R\_+R\_+R
M\_+R\O'T\O'U]/7R\?+T]//R\O+Q\?#O\/'R\_3V]//$P\.`@8-H:&EG9FAG
M9VAG:&AG:&AF9V=F9V=G:&AG9VEH:&EF9F9H:&AG9VAH9VAM;6[5T]?__?G_
M___]_?W____Z_?O_____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________\^________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________?W]______[]_?S[_______________]^_W_____Z^KJ9V=H
M:&AH9V9F9V=H:&=H:&=G:&=E:&=I:&AHVMC9]//T]//U\O+Q\O+Q\O/R\O/R
M\O+R\O+R\O/R\O+R\O+Q\O+R\O/R\_/R\O/R\O+Q\O/R\O+Q\O+Q\O+R\O+Q
M\O/R\_/R\O+R\O/R\O+Q\O+Q\O+Q\O+Q\O/R\O+Q\O+R\O+Q\O/R\O+Q\O+Q
M]?3S]//U\_/T]/+Q\O/Q]/3S\O/R\O/S]?3UP\3%CX^29V=H:6AH:6=G9VAH
M:&=E:&=E9V=G9V=H9F=G9V=G:6AH9V=G:&=I;6UNTM+6___]_OW_____^OW]
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________________OO__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__W]_?_____________________^_?____S___[\_9"0DV9G9VAG9V=G:&AG
M:&=G9V=G9V=F9F=G:*"?H_3S]?+S]/+R\?+S\O+R\?+R\O+R\O+R\O+R\?+R
M\O+R\O+S\O+R\?+S\O+R\O+R\?+R\?/S\O+R\?+R\?+S\O+S\O+R\O+R\?+R
M\O+R\?+R\O+R\O+R\?+R\?+R\O+R\O+S\O+S\O+R\O/T]//T]//R\?3S\?+Q
M\/3S]/+Q\_/R\_3U]>_P[_7V]/'Q\=K8V9"/D6UL;6=G:&=G:&=F9VAH:&AG
M9VAH:&=G:&=G:&=G:&AH9FAG:&ML;M/2U/___OS]_?__________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________[[_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___\_/W____________^_?___?K&Q<9F9VAH9V=I9VAH9V9G9V=G9VAG9V=H
M9V=K;&[T\_+R\_+R\_+R\_+R\O'R\_+R\O+R\O+R\O+R\O+R\_+R\O+R\O'R
M\O'R\O'R\O+S\_+R\O+R\O'R\O+R\_+R\O'R\O'R\O'S\_+R\O+R\_+R\O'R
M\O+R\O'R\_+R\O+R\O'R\O+T\_3T\_'R\_+R\_+R\_3R\_3R\_3S\O/V]//T
M\O'U]/7S\O/S\O'T\_+T]//DY>:BH:)L;&QH9V=H:&=H9VAF9F9H:&AG9VAF
M9V=H:&AH9V5I:&AL;6[JZ^O^_?_]_/O_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________^^________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________/__
M_____?S__/___?[\<G)T9V=H9F=G:&=H:&=I9V=G:&AH9V=G9V=GLK*T]/7U
M\O'R\_+Q\O'P\_+T]?3R\O+R\O+R]//R\O+Q\O/R\O/R\_/R\O+Q\O+R\O+R
M\O+R\O+R\O+Q\_/R\_/R\O/R\O+Q\O/R\O/R\O+R\O+Q\O+R\O+R\O/R\O/R
M\O+R\O/R\O/R\O+R\O+Q\O+Q\O+R\O+Q\O+R\O+Q\O+R\O/R\O+R\O+Q\O+R
M\O/R\O/R\O+R\O/TY^;G>7I]9V=G:&=F9V=G9V=H9V9G9V9H:&=H:&=H:&=G
M9V=H>7E_[NSM_/S\_____OW__/S]________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________/O______________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________S^_?________G\_?__
M_;.RM&=G:&=G9V=G:&AH:6=G9V=H:&=F:&AH:("!@_3R\O/R\_#Q\//S\_3S
M\O3S]/+S\O+S\O3S]//S\O+R\O+R\O+R\O+R\O+S\O+S\O+R\O+R\O+R\O+R
M\O/S\O+S\O+R\O+R\O+S\O+S\O+R\?+R\O+R\?+R\?+R\O+R\?+R\O+R\O+R
M\?+R\O+R\O/S\O+S\O/S\O+S\O+R\?+S\O/S\O+R\?+S\O+S\O+S\O+R\O3S
M\O3R\N?FYWAY>6=G:&EH:&9F9V=H:&=G9V9F9F=H:&AG:&=F9V=H:'I[?N[L
M[?W\_?___________?S\_?______________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________[W_
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________W__O_\_/W____^_O[M[.YL;&YH9VAH
M9VAH9V=F9V=G9V=G9VAG9V=H:&C9U]CT\_3T]//P\?#U]/+U]/7R\_/R\_/U
M]/7R\O+R\O+R\_+R\_+R\_+R\O+R\O+R\O+R\O'R\O+R\_+R\_+R\_+R\_+S
M\_+R\_+R\O'R\_+R\O+R\_+R\_+R\O+R\O'R\_+R\O+R\_+S\_+R\_+R\_+R
M\_+R\O+S\_+R\O+S\_+R\O+R\O'R\O'R\O+R\O'R\O'S\_3S]/3Q\?#FYNAX
M>7IH9VAG9V=G9V=G9V=G9VAG9V=F9F9H:&AF9F5G9V=X>7_N[>_]_/O^_O__
M___]_/G_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________\]________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________OW__________?S^_OW_CX^29V=G9V=G9V9F9VAH9VAH
M9V=H:&=G969FD(^4\O'R\O/T\_/R]//R\O'S\O/T]/7U\?'P\O+Q\O/R\O+R
M\O+R\O/R\O+R\O/R\O+R\O+R\O/R\O+R\O/R\O/R\O/R\O+Q\O/R\O/R\O+R
M\O+R\O+R\O+Q\O+R\O/R\O+R\O+Q\O+R\O+Q\O/R\O+Q\O+R\O/R\O+R\O/R
M\O/R\O+R\O/R\O+R\O+R\O+Q\O+R\O'R\O/S\O/T\_3TZ>?I>'EX9V=F:&=H
M9V=H:&=G:&AH9VAH9F9F:6AH9V9G9V=G>GI\[.ON_____/W______?S[_OW_
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________/O______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________[]
M______S]_?___O[^__G\_=/1TVAG9V=F9FAG:6=F9F9F9F=H:&AG9VAG:&QM
M;>;DY/3U]?'R\_3T\_/R]/3U]?'Q\?/S\O+S\O+R\?+S\O+S\O+R\O+R\?+R
M\O+R\O+S\O+R\O+R\O+R\O+S\O+R\?+R\O+R\?+S\O+S\O+R\O+R\O+R\?+S
M\O+S\O+R\O+R\?+S\O+S\O+R\?+S\O+R\?+R\O+S\O+R\O+R\O/S\O+S\O+R
M\O+R\?+R\O+S\O3T\_#Q\O+S\O+S]/3T\\W-SVML;6AG:&=F9VAG9F=G9V=G
M:&AH:69F9FAG:6AH9VAG:'EZ?.SK[_[]_/[]________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________[S_____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________________________^_O_________^_OW]
M_?W___W___V`@(%G9V=G9VAG9F9G:&AG9V=H:&AH9VEH:&:SLK3S\O/U]O;Q
M\?'U]/7R\?+R\_+R\_+R\O'R\_+R\O'R\_+R\O+R\O'R\O'R\_+R\_+R\O+S
M\_+R\_+R\_+R\O'R\_+S\_+R\O'R\O+R\O+R\_+R\O+R\O+R\O'R\_+R\O'R
M\_+R\O+R\_+R\O+R\O'R\O+R\_+S\_+R\_+R\O+R\O+S\_+R\O'R\_+R\O+R
M\_3T\_'T\O'U]/7Q\N_R\_/-S,YM;6YH9V5G9VAH9VAG9V=H:&AF9V=H:&AH
M9VAI9V=H9VAY>7OO[O#__OW^_O_______OW_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________^]
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________/W]_____/S]_________/W]_/S]L[2W
M9VAH9V9G:6AH9V=G9V=H:&=H9V9F9V=G>GM]\O#N\O/T]/3S]//T]//T\O/R
M\?+S\O+R\O+R\O/R\O+Q\O+R\O/R\O+Q\O+Q\O+Q\O+R\O+R\O/R\O+R\O+R
M\O+R\O+R\O/R\O/R\O+Q\O+R\O/R\O/R\O/R\O+R\O/R\O+R\O/R\O/R\O/R
M\O/R\O+Q\O/R\O/R\O+R\O/R\O+R\O+Q\O+Q\O+R\O+R\/'P\O'R]/+Q\_+Q
M\O/S\O+Q]O3SSLW-:VQM9V=I9V=H:6AF9V=G9V=H9F9F9V9H9V=G:&=H9V=G
M>7E[Z^OM_OW\_?W]____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________._______________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________[]__[^__W\^_[]_____OW]_FQM;6=G:&AG9VAH
M9V=G:&=F9VAH96=G:&=G9\7$QO#Q\O+R\O'R\O/R\_+S\O+S]?+R\O+R\?+S
M\O+R\O+R\O+R\O+R\O+S\O+R\O+R\O+S\O+R\?+S\O+S\O+S\O+R\O+S\O+S
M\O+R\?+R\?+R\O+R\O+R\O+R\O+R\O+R\?+R\O+R\O+S\O+R\O+S\O+R\O+R
M\O+R\O+R\O+R\?+R\?+S\O+R\?+R\O/R\?+Q\O3S]?/R]//R\?3S\O+S\O/T
M]M#.S6QM;6AG9F=G:&AG:&=G9V=G9V=G:&9G9VAH9VEH9VAH:("!@_____[]
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________SW_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________^8F)QG:&AH9V5G9V=F9F9H9VAH9VAG
M9V=H9V>0D)'S]/3U]/3T\_+U]/7Q\?'S\O/R\_+R\_+R\O+R\_+R\_+R\O'R
M\_+R\O+R\O+R\O+R\O+R\O+R\O+R\O'R\_+S\_+R\_+R\O+R\O+R\O'R\O+R
M\O+R\_+R\O+R\_3R\_3R\_3R\_3R\_/R\_3R\_3R\_/R\O'R\_+R\_+R\_+R
M\O'S\_+R\O'R\_+R\_+R\_+R\O+R\O'R\_+R\O'R\_+R\_+R]/7.S<UL;&UF
M9V=G9VAG9F=H9V=G9V=G9FAH9V=G9VAH9VAG9V>0D)3____\____________
M___^_O_\_?W__OW^_O____W_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________\^____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________X-_@9F9F:&=H9F=G:&AI9V9F:&=H9V=G9V9H9F=IY>3C
M\O'R]?/T\_'Q\_3U\/'Q\O+R\O/R\O/R\O/R\O+Q\O+Q\O+Q\O+R\O+R\O+Q
M\O/R\O+Q\O/R\O+R\O/R\O+R\O/R\O+R\O/R\O+Q\O/R\_/R\O+R\O+Q\O/T
M\O/T\O/T\O/T\_3T\O/T\O/T\_3T\O+Q\O+R\O+Q\O/R\O+R\O/R\O/R\O/R
M\_/R\O/R\O+Q\O/R\O+Q\O+R\O+R\O+R\_+T]O3OT,_/;&QM9V9H:&AH9F=G
M:&=G:&=H9F=G:&AH:&=G9V=G9F=GD)"4_____/___?W]_____?W]_____OW_
M___^________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M/?__________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__[\_8F)C&AG:&=G:&=G:&=G9V=G9VAH:&AG:&9G9ZJJK//R\_3U]?+Q\/'P
M\O+R\?+S\O+S\O+S\O+R\?+R\?+S\O/S\O+R\O+R\O+R\?+S\O+S\O+R\?+S
M\O+S\O+R\O+S\O+S\O+R\?/S\O+R\O+S\O+R\O+R\?+S\_+S]//T]/+S]/+S
M]/+S]/+S\_+S]/+S\O+R\O+R\O+S\O+R\?+R\?+S\O+R\?+R\O+R\O+S\O+S
M\O+R\O+S\O+R\O+R\O?T\O#Q]/#P\,_.T&QL;6=H:&=G9VAG:&=G9VAH:6=G
M:&=G9V=F9V=H9F=G9Y"0E/_^_?____[]__W]^______^_?____O]_O______
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________SW_____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________________________\__^\O,%G:&AG
M9VEG9F9G9V=F9F=H9V=G9V=H:&ER<W3T\_3Q\?'T\_3T\_3Q\?#R\_+R\O'R
M\_+R\O+R\O+R\_+R\_+R\_+R\_+R\O+R\_+R\O'R\_+R\_+R\_+R\O'R\_+R
M\O+R\O'R\_+R\_+R\_+R\O+R\O+R\_3R\_3R\_3R\_3R\_3R\_3R\_3R\_3R
M\O'R\O+R\O'R\O'R\O'R\_+R\O'R\_+R\O+R\O'R\O+R\O'R\O'R\O+R\O'R
M\O'S\O'S\O/U]/;Q\>_/SM!K:VMH9VAH9V=H:&AF9F9G:&AF9F=H9VAG9F=H
M9V=F9V>0D)+__O_Y_/W____^_/W___W___W__O______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________^^____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________/[^_OW_<W-T9V9F:6AF9F=G:&AH
M9V=G9V=G9V=H9V=FO+N]\_+Q\?#R]//R\O/T\O+Q\_/R\O+Q\O/R\O+Q\O+R
M\O/R\O/R\O/R\O+R\O/R\O/R\O+Q\O+Q\O+R\O+Q\O+R\O+R\O+R\O+R\O/R
M\_/R\O+Q\O+R\O/S\O/S\O/T\O/T\O/S\O/T\O/T\O/T\O+R\O+Q\O+R\O+Q
M\_/R\O/R\O/R\_/R\O+R\O/R\O/R\O+R\O+R\O/R\O+R\O+R\O/R]?3S\O'R
M\?+R\O/RL[*U9V=G:&=G9V=H9V=G:&=E:&=G9V=H9V=G9V=G:&=H9V=HDI*3
M^_O\_/S__?W]__[]_?W]_OW]____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________OO__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________O]_/___Z"@I&AH9FAG9V9G9V=G9VAG:&=G9V=F9VAG
M9XB(BO+Q\/7T\_+S\O+S\_/S\O/S\O+R\O+R\?+R\?+S\O+R\?+S\O+S\O+S
M\O+S\O/S\O+R\?+R\O/S\O+R\O+S\O+S\O+S\O+S\O+R\?+S\O+R\O+R\?/T
M]/+S]/+S]/+S]/+S]/+S]/+S]//T]/+S\O+S\O+S\O+R\O+R\O+S\O/S\O+S
M\O+S\O+R\O+R\O+R\?+R\?+R\?+R\O/S\O/R\_/S\O'Q\?3S]/+Q\_+S]+.S
MLV=G9VAG96AG:&AG9VAH9F=G9V=H:&=G9VAG:&AG:6=G99"0DO[]__K]_?_^
M_________?__________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_[[_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______\_/WLZ^UG9VAH9V=H:&AF9F9G9F=G9F=H:&AG9VAF9F?;V=CP\/#S
M\_+S\O/R\O'R\_+R\O'R\O'R\O+R\O'R\O'R\O+R\_+R\_+R\_+R\_+R\O+R
M\O+R\O+R\_+R\_+S\_+R\O+R\O'R\_+R\O+R\O+R\O+S]/3S]/3R\_/R\_/R
M\_3S]/3R\_/R\_3R\O+R\O+R\O+R\O'R\_+R\O+R\_+R\O+R\O'R\O'R\O'R
M\O+R\O+R\O'R\O'R\_+S\O/T]//R\O+R\?+T\_3R\_+S\O2SLK-F9F9H9VAH
M9VAG9V=F9F9G:&AG9V=H:&AF9V=I:&EH9V>.CY'_____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________^\____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________OW_______[]
MD)"49V9F9V=G9V=H9V=G9V=H9V=H:&=H:&=HH)^B\O/R\_/R]//T\O+R\O/R
M\O+R\O/R\O/R\O+Q\O+R\O+R\O+R\O+Q\O+R\O+R\O+R\O+R\O+R\O+R\O/R
M\O+Q\O/R\_/R\O+R\O+R\O+Q\O+Q\_3T\O/T\_3T\O/T\O/T\O/T\_3T\O/T
M\O+R\O+Q\_/R\O/R\O+R\O+R\O/R\O/R\O+Q\O/R\O/R\O+Q\O/R\O+Q\O/R
M\O+Q]?3U]/+Q\O+Q\O+R\_+T]O/T]//R\O/UL;"R9F=G9V=E:&=H:6AH9V=G
M:&=H:&=H9V=H9F=G:&=G9V9GH:&C_O[__OW_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________OO__________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________OS___S__\C'R&=G9V9G9V=H
M:&EH:&=G9V=G:&=F:&AH:&ML:O3S]/+R\O3R\?+S\O+R\?+R\O+R\O+S\O+S
M\O+R\?+S\O+S\O+R\O+R\O+R\?+R\O+S\O+S\O+R\?+R\O+S\O+R\O+R\?/S
M\O+R\?+R\?+R\O+S\O+R\O+S\O+R\O+R\O/S\O+R\?+R\O+S\O+R\O+S\O+S
M\O+S\O+R\?+R\O+S\O+R\O+S\O+R\O+S\O+R\?+R\O+R\O+R\O+R\O+R\?+R
M\O/S\O+R\O+S\O+S\O+R\O+S]+.RM&9F:&=G9V=G96AH:6=F:&=G96=G9VAG
M9V=G:6=G:&=G9[2SM?[]__K]_O____________________[^______[]_/__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________[[_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________\___\______YQ<G-G:&AG9F=H9V=H9V=F9VAG
M9FAG9F9G9V>RLK3Q\O+T\_+R\O+R\O'R\_+R\_+R\O+R\O+R\O+R\O+R\O+R
M\O'R\O+R\O+R\O+R\O+S\_+R\_+R\O'R\O'R\O+R\O+R\O'R\_+R\_+R\O+R
M\_+R\_+R\O'R\O+R\O+R\_+R\O'R\O'R\_+R\O+R\O+R\O'R\_+R\O'R\_+R
M\O'R\O'R\_+R\O'R\O+R\_+R\O+R\_+R\O+R\_+R\O+R\O+R\_+R\O'R\O'R
M\_+R\_+T\_+R\?"SL[5F9F9G9FAG9F9H:&AG9VAG9VAG9V=F9V=H9VAG9VAG
M:&>TM+3^_O_^_O________[\_/W]_?W]_?W_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__\^________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____OW______/S]^OK]M;2V9V=H:&=H:&=G9V=H9V=G9V=H9V=G9V=H@(""
M\O+T\O+Q\O+R\O/R\O/R\O+R\O+R\O/R\O+R\O/R\O+Q\O+R\O+R\O/R\O+Q
M\O+R\O/R\O+R\O+Q\O/R\O+R\O+R\O+R\O/R\O/R\O+R\O+Q\O+Q\O+R\O+Q
M\O+R\O/R\_/R\_/R\O+Q\O/R\O+R\O+R\O+R\O/R\O/R\O+R\O+R\O+R\_/R
M\O+Q\O+R\O+Q\O/R\O/R\O/R\O/R\O/R\O+R\O+R\O/R\O+R\O+Q]?+Q\_3U
M\?'QL[*U9V=H:&=G9V9F9V9G9F9F9VAH9V=G9V9G:&=H9V=E9FAGM+.U_/S]
M_____OW\___________^_/S]_/__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________OO__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________W\_?[^_/S\
M_?___^OJ[&UM;6AG9V=G9VAG:&9F9F=G9VEH:&AG:&9G9]O9V_+R\O+R\?+S
M\O+R\O+S\O+R\O+R\O+S\O+S\O/S\O+R\O+S\O+S\O+R\O+R\?+R\?/S\O+R
M\O+R\O+S\O+R\O+R\O+R\O+S\O+R\O+R\O+R\O+R\O+R\O+S\O+R\O+R\O+S
M\O+R\?+S\O+S\O/S\O+R\O+R\O+S\O+R\O+R\O+R\O+R\O+S\O+S\O+R\O+R
M\O+R\?+R\O+R\O+S\O+R\O+S\O+R\O+R\?+R\?/R]/7T\_/R\_+Q\[*QLF=G
M9VAG9VAG9VAH:&=G:&=H:&=F9FAH:6=G:&=G:&AH:+2SM?___?____W]_?W]
M_?[\_?___OS_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________[W_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________________\___]_?O__O_\_OW^_?^0D))H
M9V5H9VAH9VAG9VAG9V=H:&AG9F=H:&B/CY'T\_+R\O'R\_+R\_+R\O'S\_+R
M\_+R\O+R\_+R\O+R\O'R\O'R\_+R\O+R\_+R\_+R\O+R\O'R\O'R\_+R\O+R
M\O'R\O+R\_+R\O+R\_+R\O+R\_+R\O'R\O'R\_+R\O'R\O'R\O+R\O'R\O+R
M\O'R\O'R\O'R\_+R\O+R\O+R\O+R\O+R\O'R\O+R\_+R\_+R\O+R\_+R\O+R
M\O'R\O'R\O+R\_+R\O+R\O+R\_3T\O+R\?#S]/3U]/6.CI%H:&AH9V=H9VAG
M9VAG9V=I:&AG9F9G9F=H9VAG9FAF9V>TM+7____^_?_________[^_O_____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________\\________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________/W]_OW_T]'39V=G9V=H9V9F9V=H
M9V=G9F9F:6AH9F5G;&UMYN7D\O/R\O+Q\O+Q\O+Q\O/R\O+R\O/R\O/R\O+Q
M\O/R\O+Q\O+R\O+Q\O+R\O+Q\O+R\O/R\O+R\O+R\O/R\O+R\O+Q\O+R\O+R
M\O+Q\O/R\O+R\O+Q\O+R\O+R\O+Q\O+R\O+R\O+R\O+R\O/R\O+R\O+R\O/R
M\O+Q\O+R\O+Q\O+Q\O+Q\O+R\O+R\_/R\O+Q\O+R\O/R\O+R\O+R\O/R\O/R
M\O/R\O+Q\O/T\O/S\O/Q]//T]//T\O+QCH^19F=G9V=H:&=I:&=G9V=G9VAH
M9F=G9F9F:&=I:&=G9V=HM;6X_?S__O[^_O[\_OW__?S[________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____O/______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______[^_/[]_____?[]_________8"!@VAH:6=H:&AG:6=F9FAH:&=G9VAG
M:&AH:+*RL_+R\O+S\O+S\O+S\O+S\O+R\O+R\?+R\?+R\?+R\O+S\O+S\O+S
M\O+R\O+R\O+R\O+R\O+S\O+R\?+S\O+R\?+R\?+R\O+S\O+S\O+R\?+R\O+R
M\O+S\O+R\?+R\?+S\O+S\O+S\O+S\O+R\O+R\O+R\O+S\O+S\O+S\O+S\O+S
M\O+R\O+R\O+S\O+R\O+S\O+S\O+S\O+R\O+R\?+S\O+R\?+S\O+S\O/R\_/S
M\?+S]/3R\?/R\_+S]/7T\XZ.D69F9F=G:&AG:6=G:&=G:&=G9V=G9VAG9V=G
M9FEH9F9F:+2TM__]^OW]_?S\_?__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________[[_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________________________________^_?__
M___^_O_______OVSL[9H9V=G9VAG9V=H9V=G9VAG9VAH:&AF9V=X>7SR\_+R
M\_+R\_+S\_+R\O+R\_+R\O'R\O'R\_+R\O+S\_+R\O'S\_+R\O+R\O'R\O'R
M\O'R\_+R\O+R\_+R\O+R\O+R\O+R\_+R\_+R\_+R\_+R\O+R\O+R\O+R\_+R
M\O+R\O'R\O+R\O'R\_+R\O'R\_+R\_+R\O+R\O'R\O'R\_+R\_+R\O+R\O+R
M\O+R\_+R\O+R\O'R\_+R\O+R\O+R\_+R\O'R\O'V]//T\_3P\/#R\O+R\O+R
M\?+T\O'S]/60D)5G9V=G9V=G9VAH:&AF9F9G9VAG9V=G:&AG9F=I:&9G9VC(
MQ\G^_?_\____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________^^________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________/W]_____?W]_?W[_O[_
M__WZ:VQM9V=G:&=G:6AH9V=H9V=H9V9G9V9G9V=GQ<3$]//R\O/T\_/T]//R
M\O/T\_3T\_+S\O+R\_/R\O+R\O/R\O/R\O/R\O+R\_/R\O+R\O+R\O+R\O/R
M\O+Q\O+R\O/R\O+R\O+Q\O/R\O+Q\O+R\O+Q\O/R\_/R\O+Q\O/R\O/R\O/R
M\O/R\O+R\O+Q\O+R\O/R\O/R\O+Q\O+Q\O/R\O+R\O+R\O/R\_/R\O/R\O/R
M\O+R\O+R\O/R\O+R\O+R\O+Q\O/R\O+Q\O/R\O+R\_/R\O+R\O+R\O+Q\?3V
MCX^2:&=H9V=G9V=G9F9F9F9F9F=G:&=G9V9G:&=I:&=E;&QNU-+4_/S]^OS]
M_______]________^OW]_/___?W[_OW_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________O/______________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________^_?___________?_^__[]_9F9FV=G:&AH
M:6=G9V=G9V=H:&AG:6=F9V=G9X^/D?7T]?+S]/7T]?3R\?/T]/+R\O/R\_/S
M\O+S\O+R\O+R\?+S\O+S\O+S\O+R\O+S\O+S\O/S\O+S\O+S\O+S\O+R\?+R
M\O+S\O+R\?+S\O+R\O+R\O+R\?+S\O+R\?+R\O+R\O+R\O+S\O+R\O+S\O+R
M\O+S\O+S\O+R\O+R\O+R\O+R\?+R\O+R\?+S\O+R\O+R\?+R\?+R\O/S\O+S
M\O+R\?+R\O+R\O+S\O+R\?+S\O+R\O+R\O+S\O+R\O/R\?3S\I"0D6=G:&AG
M9V=H:&=H:&=G9V=G:&AG:&=F9VAH:&=G9VQM<-32TOW\_O____S\_?___?_^
M______O[^_[]___^_?__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____SW_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________[____^_O_____Z_?_^_O_>W=YF9F=H:&IH9V5G9V=H:&EH
M9V=G9VAG9V=G9VGGY>;T]//Q\O/S\O/T\_3S\?#S\O3R\_+R\O'R\O'R\O+R
M\_+R\O+R\O'S\_+R\O'S\_+R\_+R\O+R\O+R\_+R\O+R\O+R\_+R\O'R\_+R
M\_+R\_+R\_+R\O+R\O+R\O+R\O+R\O+R\_+R\O+R\O+R\_+R\O+R\O+R\_+R
M\O+R\_+R\O+R\O+R\_+R\O+R\_+R\_+R\O'R\O+R\_+R\_+R\O'R\_+R\O'R
M\O+R\O'R\O+R\O+R\O+R\O+R\O+V\_'R\O+Q\O.0D))G9VAG9VAG9VAH9V=G
M9VAF9V=G:&AG9F=G9V=H:&9K;&_5TM3^_?___OW^_?_____]_/O\_/W__OWZ
M_?[_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________\^________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________[]
M______[______/___O[_____B8B+9V9F:&AH9V=G9V=H:&=G:&AH9V=H:&=G
MJJJL\?+S\_3S\_+S\_/T]/+R]/7U\O+R\O+R\O+Q\O/R\O+Q\O+Q\O+R\O/R
M\O+Q\O+R\O+Q\O+R\O+Q\O+Q\O/R\O+R\O/R\O+R\O+R\O+R\O/R\O+R\O+Q
M\O/R\O+R\O+R\O+R\O+R\O+Q\O+R\O+Q\O/R\O+R\O+R\O+Q\O/R\O+R\O/R
M\O+R\O/R\O+R\O+Q\O/R\O+R\O/R\O/R\O+R\O+Q\O+R\O+R\O/R\O/R\O+R
M\O/R\O/R\O+R]//R\_+T]/7U\O+QD)"19V=H:&=G9F9F9V=G9VAH:&AH9V9G
M9F9G9V=G9V=G;&QNT]'3_____/O]__[]_______]_/S]_/______________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________/_______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________O____[^_____?S^
M_O____W\_K^^P6=G96AH:&AG:6=H:&9F9FAH9FAG:&=G9W)R<_7T]?'R\?3U
M]?3S]//R\_+R\O+R\?+R\O+R\?+R\O+R\?+R\O/S\O+R\O/S\O+R\O+R\?+S
M\O+R\?+R\O+R\O+S\O+R\O+R\O+S\O+R\O+R\O+R\O+S\O+R\O+R\O+R\O+S
M\O+S\O+R\O+R\?+S\O+R\?+S\O+R\O+R\O+S\O+R\O+R\?+R\?+R\O+R\?+R
M\?+R\O+S\O+S\O+R\O+R\O+R\O+S\O+S\O+R\?+R\?+S\O+S\O+R\?+R\O+R
M\?+Q\/'R\O+R\N7EY7EZ?6=G9V=G9V=G9VEH:&AH:&AH:&=F9V=G:&=G9V=H
M9FQM;M33U?W]_?S____]^O[^____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________[W_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________________]_?W__OW[^_G____^_O___OUR
M<W1G9V=G9VAF9V=H:&AG9V5H9VAG9F=G9V6[NKWT\O'Q\O/T\O'T\_/R\O+R
M\O'R\_+R\O+R\O+R\O+R\O+R\O+R\O+R\O'R\_+R\O+R\O+R\O'R\O'R\O+R
M\O+R\O+R\O+R\O+R\_+R\_+R\O+R\_+R\O+R\O+R\O'R\_+R\O+R\_+R\O+S
M\_+R\O+R\O'R\_+R\O+R\O+R\_+R\O+R\O'R\_+R\O+R\_+R\O'R\_+R\O+R
M\O+R\O+R\O+R\O+R\O'R\_+R\O'R\O+R\O+R\O+R\O'S]/3Q\?#S\_'S\O/U
M\_3EY>9Y>GMG9V=H9VAG9F=F9F9I:&AH9V=H:&AF9F=G9VAH9V=K;&W1TM;_
M__W^_O____________W_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______\]____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________/S]____________________H:&E9V=G:&AH9V=H
M:&=G:&=G9V9G9V=H:&=FB(>*]/+R\O/T\?'P]/+Q\_3S\O+R\O/R\O+R\O/R
M\O+R\O+R\O/R\O+Q\O/R\O+Q\O+R\O+R\O+Q\_/R\O+R\O/R\O+R\O+R\O+R
M\O/R\O/R\O/R\O/R\O+R\O+Q\O/R\O/R\O+R\O+R\O/R\O/R\O+R\O+Q\O+R
M\O/R\O/R\O/R\O+Q\O+R\O+R\O+R\O+Q\O+R\O+Q\O+Q\O+R\O+Q\O/R\O+Q
M\O+Q\_/R\O+R\O/R\O+R\_/R\O/R]//T]/3S\_/R\O+S]//T]?7TY^;G>7I\
M9V=H:&=H:&=H:&=G:&=G:&=G:&=I9V9G9V9F9V=G:VQLT]+6___]________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________//______
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__S\_?____[]_?[^__________S__^+@XVAH:&AG9F=G:&AG9VAG:&AG9V=G
M:&=G:&AI9]O:W?+S\_+R\?;T\_3S]/+S\O+R\O+R\O+S\O+S\O+R\?+R\O+S
M\O+S\O+R\?+S\O+S\O+S\O/S\O+S\O+R\O+R\?+R\?+S\O+R\?+S\O+R\O+R
M\O+R\?+R\O+R\O+S\O+R\O+R\O+R\O/S\O+S\O+S\O/S\O+R\O+R\?/S\O+S
M\O+S\O+R\O+R\O+R\O+S\O+S\O+R\O+R\?+R\O+R\?+R\O+R\O+R\O+R\?+R
M\O+R\O+R\?+R\O+S\O/R\_3S]?/T]?+R\O/R\?/R\.3EYWIY>6=G:&9G:&=G
M9V=G9V=G:&=F9VAG9VAI:6AG9V=G9VML;M_?X/[]__O\________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________[S_____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________^0D)1G9F=F9V=F9V=F9F9G9VAG9F=H9V=G9V>?GZ+V
M\O#S\O'T\_+R\_3S]/3R\O+R\O+S\O'T\_3T\_3T\_+T\O+R\_+R\_+R\_+R
M\O+S\_+R\O'R\O+R\_+R\_+R\O'R\O+R\O+R\O+R\O+R\O+R\O+R\O'R\O'R
M\_+R\O'S\_+R\O+R\O'S\_+R\O+R\O'R\O+R\O'R\_+R\O+R\O+R\O+R\_+R
M\O+R\O'S\_+R\_+R\O+R\O+R\O+Q\?#R\O'R\O+R\O'R\O'S\_/R\_+R\_+R
M\O+S\_+R\O+R\O+R\_+R\O+R\O+S\_+GYNEZ>GQH9V=G9V=G9V=F9F=H9VAG
M9VAG:&9G9VAG9F=I:&A[>GWN[.W^_?_\_OW_______W___[__OW_________
M___]_/W_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________\^____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____Q\;):6AH9V9G:&AH9F=G:&=H:&=H9F9F9V=G;&UO]/'R]?3R\O+Q]?3U
M\O/T\O+Q\_3S]/+Q]?3U\O'R\_+S\_+Q\O+R\O+R\O+Q\O+Q\O/R\O+R\O+Q
M\O+R\O+R\O/R\O+R\O/R\O+R\O/R\O+R\O+Q\O+Q\_/R\O/R\O+Q\O+R\O+R
M\O+Q\O+Q\O/R\O/R\O+Q\O+Q\O/R\O/R\O/R\O+Q\O+R\_/R\O/R\O/R\O/R
M\O+R\O+Q\O/R\O+R\O/T\?'R\?+S\O/T\_/S\O+R\O/R\O/R\O+R\O+Q\O/R
M\O/R\O+R\O/R\O+Q]/+QY.3F>7E[9V=E:&=H9V=H9V=G:&=G9V=H:&=H:&AH
M9V9F:&AI>7I][.OI__[__________/W]_________O[__?W[____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________O?__________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________?W]_7-S=&=F
M9V=F9VAH9FAG:&=G9VAH:6EH9F9G9[&QM/+S]/+S\O+R\?+S\O#Q\/+R\O3R
M\?+Q\O7T]?+Q\O/R\_+R\?+S\O+R\O+R\O+R\O/S\O+R\?+R\O+S\O+S\O+R
M\O+R\?+R\?+S\O/S\O+R\?+R\O+R\?+R\O+R\?/S\O+S\O+S\O+S\O+R\O+R
M\O+R\O+R\O+R\?+R\?+R\O+S\O+R\?+S\O+R\?+R\O+R\O+R\O+R\?+R\O3U
M]?/T]/+S]/3U]?+S\_'R\_+R\?+R\?+S\O+R\O+R\O+R\O+R\?+R\O+R\O+S
M\O+S]/+S]./CY'MZ?&=F9VEG:&AI:69F9F=G:&=G9VAG9V=G:&AH9F=G9GI[
M?NWK[/S___S]_?____S[__W]_?W]^_[]_____?______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________[W_____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________^IJJUG9V=G9VEF9F5H9VAG
M9V=G9F=H9V=H9V>`@(+U\O'S]/3S]//Q\O/R\O'R\_+T\_+U]/7R\?+U]/7S
M\O/R\O'R\_+R\_+R\O+R\O'R\O+R\O+R\O+R\_+R\_+R\_+R\_+R\O+R\O+R
M\O+S\_+R\O+R\O'R\O'R\O+R\_+R\_+R\O'R\O'R\_+R\O+R\O+R\O+R\_+R
M\O+R\_+R\_+R\O+R\_+R\O'R\_+R\O'R\O+S\_+R\O'R\_3R\_3R\_3T]/7R
M\_3R\_/S\_+S\_+R\O'R\_+R\_+R\_+R\O+R\O'R\_+R\O'R\O'P\?+U\_+C
MY.5Z>GMH9V=H9F=H:&EG:&AG9V=G9VAH9VAH:&AH:&9G9VAZ>7WLZ^O___W^
M_?________W\_?W^_O[_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________^^____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________OW____]ZNOM;6UM9V=H9V=G:&=G:&AG:&=H9VAH9V9C
M9V=HCX^1]?/R\O/T\_3U\O/T\O/T\O'R]//R]/+Q]/+R\_+Q\O/R\O+R\O+Q
M\O+R\O+R\O/R\O+Q\O+Q\O/R\O+Q\O+R\O+R\O/R\O+R\O+Q\O+Q\O+R\O+R
M\O+R\O+R\O+R\O/R\O+R\O/R\O+Q\O/R\O/R\_/R\O/R\_/R\O+Q\O+Q\O+R
M\O/R\O/R\O/R\O+Q\O+R\O+Q\O+R\O/S\_3T\O/T\_3U\O/T]/3S\O+R\O+R
M\O+R\O/R\O/R\O+Q\O+Q\O+R\O+Q\O+R\/'P]//R[_#Q]O3SSL[0;6UN9V=H
M9F9G9V=G9V=G:&AI:6AI9V=H9V9G9V=G:&AH>GE[[NSO___]^?S]__[]_OW_
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________/?__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________^_X^/DF=F9F=G:6=G9V=F9V=G:&=G9V=G9FAG:&9G9X^/D//R
M\?3R\?/R\_3S]/+S]//S\O+S\O/S\O+R\?+R\O+S\O+S\O+S\O/S\O+R\?+S
M\O+S\O+R\O+R\O+S\O+S\O+R\O+S\O+R\O+R\?+S\O+R\?+R\O+R\O+S\O+S
M\O+R\O+R\?+R\O+S\O+R\?+R\O+R\O+R\O+R\?+R\?+S\O+R\?/S\O+R\?+S
M\O+S\O+S\O+R\O+R\O+R\O3T\_+R\O#Q\/3T\_+S\O'Q\/+R\O+R\O/S\O+S
M\O+R\O/S\O+R\?/S\O/R\_+S]/3S]//T]/+Q\,_/T&QM;6EG9V=G9VAH:&9F
M9V=H:&=G:&AG9VAG9VAG:&=F:'IZ?.SL[?S^_?[^__[\_/[^_?___?______
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________[W_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________________________________\_/_2
MT=)G:&AF96=G9V=H:&AG9VAG9V9G:&AG9V=H:&AH:&B.CI/U\_'V]//T\_3S
M]/3R\O'Q\?'R\O'R\O+R\O+R\O+R\_+R\O+R\O+S\_+R\O+R\_+R\O+R\O+R
M\_+R\O'R\O+R\O+S\_+R\O'R\O'S\_+R\_+R\_+R\O+R\O'R\O'R\_+R\_+R
M\O+R\_+R\O+R\O+R\_+R\O+R\O+R\_+R\O+R\_+R\O+R\O+R\_+R\O+S\_+R
M\O+R\O+R\_+O\._S\_+R\O+R\_3R\_3R\_+R\O+R\O+R\O+R\O'R\O+S\_+R
M\_+T\_3Q\O/R\O+U]//P\?/R\>_-S<UK;&YG9F=H9VAG9V=G:&AF9V=H9V=H
M9VAG9VAH9VAG9V9Y>GOM[._]_/O__________OW_____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\^____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________?W\_OW_____>7IZ:6=G9V=H
M:&=E:&=G9V9H9V=G9VAH9V=G9V=H9V=GC8^5]//Q]//R\_3U\?+S\O+R\O/S
M\O/T\O+Q\O+Q\O/R\O+R\O+R\O/R\O/R\O/R\O+R\O+Q\_/R\O/R\O/R\O/R
M\O/R\O+Q\O+Q\O+Q\O+R\O+R\O/R\O+Q\O+R\O+R\O+Q\O/R\O+R\O+R\O/R
M\O/R\O+Q\O+R\O/R\O+Q\O+Q\O+R\O/R\O/R\_/R\O+R\O+QU]C9P,+&R\S/
M\/#P]/3S\O/T\O/T\O+R\O+R\O+R\O+R\O+R\O/R\O+Q\O/R\/'P\_3S]//R
M\O/T\O/T\_+S]//RSL_1;6QM9V9G:&AH9F=G9V=G9V=H9F=G9V=F9F=G9V=G
M9V9H>7I[___^^_W__/____[]____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________O/__________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________W\^_____[]_____[R\O6=G:6AG9V=F9VAH:6=F:&EH
M:&AG9V=F9FAH:&=H:&AG99>7FO+R\?3U]?3S]//R\?/Q\/+S]/+S]/3U]?+S
M]/3U]?'R\_+S]/+S]/'R\_+R\?+S\O+R\O+R\O+R\O+R\O+S\O+S\O+S\O+R
M\?+R\O+R\?+S\O+R\O+R\O+R\?+S\O+R\?+R\?+R\?+R\O+S\O+S\O+S\O+Q
M\O+S]?'Q\?3R\_+S]/+R\?/R\_CT\XJ*C6!@8&%A8&)B87EZ?./EY_3U\O3S
M]/+R\O+R\O+R\O+R\?+R\O+S\O+S\O+R\O+S]/+S\O+R\?+R\?3U]?+S]/+S
M\_+R\<_/TFQL;6EH9F=G9V=G:&AG9VAH9V=G:&=G9VAG:&AG9V=G9Y"0E/[]
M_/[^__K]_?W\_?____W]^_S___K]_?______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________S[_________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________________________________________^
M_?W____^_O[____]_?W__OVSL[5G9VEH:&9G9F=H9V=H9V=G:&AG:&AF9F9H
M:&AG9VAF9V>QL;3R\O+S]/3R\?#R\?#R\?+R\_3Q\O/R\_3P\?+R\_3R\_/S
M]/3R\_3R\O+R\_+R\O+R\O'R\O+R\_+R\_+R\O+R\O'R\_+R\O+S\_+R\_+R
M\O+R\O+R\O+R\O'R\O+R\O'R\O+R\_+R\O+R\_+R\O+T\_3P\?+R\O'R\?/R
M\_3R\_3R\?"<G)]?86!@85]A86%@8%Y@86"*BHWT\_#R\_3R\O+R\O+R\O'R
M\O+R\O+R\_+R\O'R\O+S\O'T\O+T\_+T\_3R\?#T\O'R\_+R\_/T\_'/SM%L
M;&UF9V=I9VAG9V=G9V=F9F9G9FAG9V=G9V=G:&AG:&B0D93__OW^_?_\___^
M_?W^_O_[^_O_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________\^________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________________________]_/S________^
M^OW]^OW____]M;6V9V=H9V=G9V=G9V=H9V=H9V=G:&=G:&AH9F=G9V=H9VAH
MLK*U\O+Q[_#Q]O7V]/+Q\/'R\O/S\O/T\O+R]/3S\O+Q\O/T\?+R\O+R\O+R
M\O+R\O+Q\O/R\O+R\O+R\O+R\O/R\O/R\O+R\O+R\O+R\O/R\O/R\O+R\O+Q
M\O+R\O+R\O+R\O+Q\O+R\O+Q\O+R\_+S\?'Q\O/R\_+S]/7U\O/S]//R>GM\
M86%A8&!@86%A8&%@86%A86)B]O/T\O/T\O+R\O/R\O+R\O+Q\O/R\O+R\O+R
M\O+R]//T\O'R]//S\_/T]?3U]//R\?'Q\O+R\_+S]?/RSL[0;6QN9V=H:&=G
M9V=E:6AH9V=H:&=G9V=G:&AH9V9F:&AHD)"4_OS[_/_______?O[_?S_____
M___]_?W]____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________________OO__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________[^_O____S_________
M_[2TM69G:&AH:6AG:6=G9V=G:&9F9VAG:&=G9VAG9V=G9V=G9[*QM?#Q\//T
M]/3S\O+S]/+S\_+S\O/S\_'R\?+R\?+S]/'R\_+R\O+R\?+R\O+R\?+R\O+R
M\?+R\?+R\O+R\?+R\O+S\O+R\?+R\O+S\O+S\O+S\O+S\O+S\O+S\O+S\O+S
M\O+R\O+S\O+S\O/R]/+R\O+S\O/R\_'Q\?+S\_3S\GI[>V%A86!A86%A86%A
M8&%@7F!A8?3Q\O/T]/+S\O+R\O+R\O+S\O+R\O+S\O+R\O+R\?+Q\/7T\O+Q
M\?3S\?3S\O'Q\/+S\O+R\O/R\_+R\?3S\L_.T&UM;F=G9V=G9V9G9VAG9VAH
M:&AH:&AH:&=F9V=G9F=G:)"0E/W]_O_]^O[^__[]_/[]___________^____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________[[_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________Z_?_]_OS___[\_/W____]_?O____^_O___OVUM+=F9V=H
M9V=G9V=H9V=G:&EG9V=H9V=F9V=H9V=H9F=G9VBSLK7Q\?#R\_3R\_3S]/3Q
M\?'R\_+T]//R\O+R\_/T]?7R\O+R\_+R\O+R\O+R\_+R\_+R\O+R\O+R\_+R
M\O+R\_+R\O+R\O'R\O+R\_+R\O'R\_+R\O'R\_+R\O+R\_+R\_+R\_+R\O'S
M\O3R\_3T]?7R\?+T]/+Q\O/R\?.+BXYA8F!A86!A86%A86!A85Y[>WST\_'R
M\_3R\O'S\_+R\O'R\_+R\O+R\O+R\O+R\_+R\O+P\._U]//T\_+T\_+T\_+S
M\O3S\O3U]//S\O/O\?/T\O*QLK5I:&AG9VAI:&AG9VAG9V=G9FAH9VEH9V=G
M9VAG9VAG9V>0D)+]_/_Z_/S\_OW____^_?_____^_O[_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________\^________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_O[______?W\___]_/W]_____/W]____^OW]____D)&59V=E9V=G:&=H9F=G
M9V=G9V=G9V=H9V=H9V=H9V9G9V=GLK*U\O/T\O/R\?'Q]/3S\/'P\O+R\O/T
M\O/S\O/T\O/R\O+Q\O+R\O/R\O/R\O/R\O/R\O+Q\O+Q\O/R\O+Q\O+R\O+R
M\O+R\O+Q\O+R\O+R\O+Q\O+Q\O+Q\O/R\O+Q\O+Q\O+R\O'P\O/T\?+S]?3U
M\?'O\O/R]?3VY>/C<W1U8&%A8&!@86%C9VAHS<W-]?3R\O/S\O+R\O+R\O+R
M\O+R\O+R\O+R\O/R\O+Q\?+S]/7U]?3UV=?8I:6GFIJ=KJZP]?+P]//R\_+S
M]O3S\//R]//PL;&T9V9G9V=F9V=G9V=H:&AI:&=H:&AH9V=G:&AH9V=G9V=G
MD)"3_OW_^OW]_______________]________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________/O______________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________S]_?W]
M_/____S\__W]_?___?_________^_8^0DF=H:&=G:&AH9F=H:&=G9V=G:&=F
M9VAH:&AG9VAG:&9G:+*QL_+R\?+R\O'Q\/+S]/+S]/3U]?'R\_3U]?+S\O+S
M\O+R\?+R\O+R\O+R\?+R\O+R\O+R\?+S\O+R\O+S\O+R\O+R\O+S\O+S\O+S
M\O+R\O+R\?/S\O+R\?+S\O+R\O+S\O+S\O+S]/+R\?+Q\O#P\/'Q\?+S\_3S
M\N7EY*6EIIV=GJ2DI>CGY/3S]?+Q\O7T\_+R\O+S\O+R\O+R\O+S\O+S\O+R
M\O+R\O/T]/3S\<W,RV5F:&!A86%A7V!A871T=?3R\O3R\?'R\_+R\O+S]/7T
M\K&QLV9H:&=G9V9F:&=G:&AG9VEH:&AG9V=F9F=G:&AG9VAH:)"0E/_____^
M_?___?[]____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________SO_
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________W\_/W^_?___O_______OW\___\
M__________[Z_/W___^/CY%H:&9H9V=G:&AH9VAF9V=G9V=H9V=I:&AF9F=G
M9VEH9V6PLK?R\O'R\_+R\_3R\_3R\_/R\_3R\_3R\_+R\O+R\O+R\O+R\O'R
M\O+R\O+R\_+R\_+R\O+R\O+R\_+R\O'R\O+R\_+R\O'R\_+R\O+R\O'R\_+R
M\O+R\O+R\O+R\O+R\O+S]/3S\O'S\O'R\_3T]//Q\O+T\_+S\_7S\O3P[_'V
M]?+T\_3S\O/T\_3T\O+R\O+R\O+R\O+S\_+R\O'R\_+R\O+R\_+R\_7S\>UL
M;6]@8&!A8&!A8&%B86)A86&DI:CP\.[U]//T\_3U]/7R\_3U]/*RL;)G9VAG
M:&AG9V=G9VAG9V=G9VAH9VAG9V=G:&AH9V=H9VB9F9S____\___[_?S^_?__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________^^________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________[]_/S]_/__
M_OW___[]CX^29V=G9V9G9V=G9F9H9V=H:6AH:&AF:&=G9V=H9VAH:&AFO+N]
M\_3S\?+S]?+S]//T\O/T\_/S\O+Q\O+Q\O+R\O+R\O/R\?'Q\O+R\O+R\_/R
M\O/R\O+R\O/R\O+R\O+Q\O/R\O/R\/#P\O+S\_+S\O/R\O+Q\_/R]//U\_/S
M\O+Q\/'S\O/T\_3U\O/U]//R]?/T\O/T\O/R\O/R\O/R\O+R\O+Q\O+Q\O/R
M\O+Q\O+Q\O/R\O+R\O/R\O+R\O/R\O+R\O+Q\O+RSLS/86%A86!?86%B8&!>
M8&!?8F%?>7I[]//R\O/U\O/R\_3T]?3R]//R\?+TL[*U9F=G:&=G9F=G9F=G
M:&=G9V=G:&=H9V=G:&=H:&=G9V=GM;6W_/W]_________OW]___]_?W]____
M_________O[_^?S]____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________/?______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________[]______W]^____?_____^_9"1
ME6=H:&=F9F9G9V=G:69F9FAH:6=F:&=F9F=G:&=G:&QM;<[-S?7T\_#R\_7T
M\_/R\?+S]/+R\?+S\O+R\O+S\O3T\_3T\_'Q\?+R\?+R\?+S\O+R\O+R\?+R
M\O+R\O+R\O+S\O+R\?/R]/+Q\O'R\_#Q\_3S\O7R\]C7ULW-S?/Q\?3S\O+S
M]?+S\O+Q\/+Q\/+R\O+R\O+R\O+R\O+S\O+R\O+R\?+R\?+R\O+R\O+R\O+R
M\?+S\O+S\O+S\O+R\?+S\O+S]-G7V&%A86%A7F%A86)B8F!A8&%A8(.$AO3S
M\O3U]?'Q\//T]?/R\_3S\O+S]/3R\;&QM&=G9V=G:&AG:&=F9F=H:&AG9V=G
M9VAG9V=F9V=G:&9G9[:UMOK[_/_______?________S\_?S\_?_______?[^
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________[W_____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________\_?W___________[]_/O^_?___OV/D))I:&9G9VAH
M:&AG9VEH9V=G9VAH9VEG9V5G9V=H9VAN;6W.SL[T]//Q\_+U]/+S\O3R\_+R
M\_+R\O+R\_+Q\O'R\_+R\O'R\_+R\O+R\O'R\O'R\O'R\_+R\O+R\O+R\_+R
M\_3S\O/R\?#S]/7S\O//S<MZ>WY?8&%?86)L;7"ZN;KR\?#T\_3T\O'U]/;Q
M\?'R\_+R\O'R\_+R\O'R\_+R\O+R\_+R\O'R\O+R\_+R\O+R\O+S\_+R\_+R
M\_+R\O+R\_7U]/5Y>GUA86!@86!B8F)A86%@86&MKK#S\O/S]/7P\?#S\O/S
M\O/T\O'T]?7R\_3R\O*QL;-G:&AG9VAG9V=G9V=G9V=H9VAG9V=H:&AG9VAG
M9V=F9V>VM;;\_?W\___]_?W\_/W__O_Z_?[[_OW_____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________\^
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________/SZ______[__?W]_?W[_______]D)"49F9F9V=G:&=G:&=G:&=G
M9V9G:6AH:&AH9V9F9V=G;FUNS<W-\O+Q\?/T]O/R\O+R\O/R\/'P]/3S\_/S
M\O/R\O/R\/'P\O+R\O/R\O+Q\O+R\O+Q\O+Q\O+Q\O/R\_3V]//R]//R\O/T
M]?/Q;&UO86%A86)?8&!>8&%A969GV-C8\_+Q]//U]?3V\O/T\O+Q\O+R\O/R
M\O/R\O+Q\O/R\O+Q\O+R\O/R\O/R\O+Q\O+R\O/R\O+Q\O/R\O+Q]/+Q\O'P
MSL[-:VUN86)C8&!@7V!ADY.4]//P]//T\O'P]O3Q\._Q]//T]/+Q]//R\O/T
M\?'Q\O/RL[*T:&AI9V9H9F=G9V=H9V=G:&AH9F9E:&=G:6AJ:&=G9F=GMK:W
M____________^OK[_/[^_/____[_________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________/O______________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_?O[^_[]___^_?___?[]_____Y"0DFAG9VAG9FAG:&=H9F=H:&=F:&=G9V=G
M:&AH:&=G:&UM;L[.SO3R\?3T]?+R\O+S\O3T\_+R\O/T\_#Q\/3T\_/S\O+R
M\O+R\O/S\O+R\O+S\O+R\O+R\O+R\?/S]/3R\O3S\O;V]\'"Q%]A86!@7V%A
M86%@86%@8&!A8)N;G/7T]O3S\O/R]//S\?+R\O+R\O+R\?+R\O+S\O+R\O+R
M\O+R\O+S\O/S\O+S\O+S\O+S\O+S\O+S\O+R\O/R\?+Q\O3U]?/R[\'`P</"
MP]G8V/+Q\O+S]/+S\_3S\O+Q\?7T]?/R]//Q\//R\?3R\?3S]//T\_+Q\8^/
MDFAG:&AG:&=G9V=F9FAH9VAG:&AG:6AG9V=F:&=G:&=G9[6UM_____S[_?_^
M_?____S\____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________S[_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________________\_/_]_/O__OW________]
M_?O\___\___O[O!Z>GMH9V=H9V=F9V=G9V=G9VAG9V9G9VAF9F=H9V=H:&AN
M;6[/SL[R\_+T]//Q\?'R\O'R\O'R\O+R\_+R\O+S\_+R\O+R\O'R\O+S\_+R
M\O'R\O+R\O+R\O'S\_/S\?'R\?+S\O3#P\1@86!A86%A86)A86!A86%A85Z;
MFY[S\O/S]/7T\_+R\_+R\O+R\_+R\_+R\O'R\O+R\O'R\O+R\O'R\O'R\_+R
M\O+R\O'R\_+R\O'R\O'R\_+T\O+T]//O\/'R\O+U]/7U]/7R\O'R\_3T]?7S
M\O3T\_+T\_+T]?7Q\O/T]//T\_+T\_3T\_3R\?+T]//S\O&1D91G9VAG9V=G
M9VAG9VAH9VEH9VAF9F5H:&AG9F=I9V=F9VBUM+?^_?W\_/W________]_?W\
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________^]____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________[]_____/S______/SZ_________/S]_/___/O]
M[NSO>7I[9VAH:&AI:&AH9V=G9V=G9F9G:&=H9V=G9V=G9V=H;&QMT=#0\/'P
M]/3S\?'Q\O+R\O+Q\O+R\O+R\_/R\O+R\O+Q\O+R\O+Q\O/R\O+Q\O+Q\O+R
M\?+S\_+Q]?3U\?'PV-?686)A86%A86%@8&!@86%?7V%@L*^Q\?+U\O+R\O'R
M\_3T\O+R\O+Q\O+Q\O+R\O/R\O+R\O+R\O/R\O+R\O/R\O+Q\O+R\O+Q\O+R
M\O+R\O+R\O'R\O/R\O/T]/7U\O/S\O/S\_/R\_/R\O/T]/+Q]?3R\_+T\O/S
M\?+R\O+R]//R\_3T]//T\O/S\O+Q\O/R]//TD)"19V=H:&AI9V9H:&=H:&=G
M9V=H9V=G9V=G:&=H:&=F9V=HM;6X___________________^____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M/?__________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________^_?____________S]_?[^_____?________S__^WL[GMZ?&AG
M96AG:&=G9V=F:&=G9V=G96=F9FAG9V=H:&=G:6UL;,[/TO'Q\/3T\_3T\_'Q
M\?+S\O+S\O+R\?+R\?+R\?+R\O+R\?+R\O+R\O+S\O+S\O+R\O3S]/+Q\O/T
M]?3R\I24E6!@8F%A86!A86%A87-T=O;S\?/T]//S\O/R]/3R\?+R\?+S\O+R
M\?+R\O+S\O+R\O+R\O+R\O+R\O+S\O+S\O+S\O+S\O+R\O+R\?+R\?+S\O3T
M\_7T]O+S]/+R\O+S\_7S\O/R]/+S]/7S\O3S]/3S]/+S\_+R\?+S\O/R\_+S
M\O+S\_+S]/3S\O3S]/+S]/3S\I"0D69F9VAH:6=G:&=G9V=G9V=G:&=H:&=G
M9VAG9VAG9F9G9[^^O_W]_?S___W]^_______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________S[_____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________^_O_[_/K___W^_?_N[>YZ>WYG9V=G9V=G9VAG
M9VAG9F=G9V=H9V5G9F=G:&AG9V5K;&S;V=KR\_/R\_+T\_+S\O/T\_3R\_3R
M\O+R\O+R\O+R\_+R\O+R\_+R\O'R\O+R\_3R\_3P\/#P\?#R\_+S\>^WN+F"
M@X9Z>WVDI*;V]?+Q\O/S]/;R\_3S\O'U\_+R\_3R\O'T\_3T\_+R\?#R\_7Q
M\O/T\_3R\O'T\_+S\O3R\O'R\O+U]/7U]//T\O'S\_+R\O+R\O+R\_+R\O'R
M\O+R\O+R\O'R\_+R\O+R\_+R\_+R\O+R\_+R\O+R\O'R\O'R\_+R\_+R\O+R
M\_+R\_+S\_+R\_*0D))H9VAG9F9G9V=G9V=G9V=H9V=I:&EF9VAH9VAH9V=L
M;&[2TM3__OW]_?W____^_?_____]_OS]_?W____[_/K____^_O__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________^]____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________]_OW______O[][>OL>GM_9V=G:&=G9V9G:&AH9V=E:&=I
M:&=G:&=G9V=H:&AI>'EZY>3E\?+S]//R]?3U\O'S\O/R\O+Q\O+R\O+R\O+R
M\O+R\O/R\O+R\O+R\_3S\O+R\O+R\O/S\O/T]?3U\O'P\O'O]O+Q]//Q]/+R
M\_/T\?'Q\O+Q\_+T\_+T\O/T\/#P\O/T\O'R]O3S[^_O]?/OFYN<;&UN8&%?
M='1VP\+"]?/R\?+U\O/T]/7U\O+R\O/R\O/R\O+R\O+Q\O+R\O+R\O+R\O+Q
M\O+R\O/R\O+R\O+R\O/R\O/R\O/R\O+Q\O+Q\O+R\O+R\O+R\O/R\O+Q\O+Q
M]_3RCX^19V=G9V9G:&=G9V=G9V=G:&AH9V=H:&=G:&=H9F9H;&UMTM'5_O[_
M_?W]_?W[_/S]_________________?W]____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________OO__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________[^_/S\
M_?_____^_?[^__[^_^WJ['E[?6AG9VAG:69G9V=G9F9G9VAG:6AG9V=G9VAG
M9V=G:'EZ>^3DY//T]/+R\O/R\?3S\O+R\?+R\?+S\O+R\O/S\O3T\_+R\O+R
M\O+S\O+R\?/S\_+Q\O'P\O7T]O/S]//R]/7T]O+R]/+Q\O+R\O3T\_#P\/3S
M]//R]//R\_+S]/3T\_+R]/+Q\/7T\IN;G%]A8&%@8&%@8&!A86!A8LO*R_3U
M]O+R\?'R\_+S\O+R\O+R\O+S\O+S\O+S\O+S\O+R\?+S\O+R\O+S\O+R\?+R
M\O/S\O+S\O+S\O+S\O+R\?+S\O+R\O+R\?+R\O+S\O+R\O3S]?+R\8^/D6=G
M:&EG:&AG9V=G9V=G9VEH:6=G9V=G:&AG96=G:6UM;]+1U?_^_?___?[^_OS]
M_?W]_?S]_?___________O______________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_[W_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________________________^_?_]_/O\_/W^
M_?_]_?WN[>Y[>GYH:&AH9V5H:&EG9VAG9VAH:&AH9V9G9V=G9V9G9V=Y>GOF
MY>;S\O3P\?#S\O/S\_/R\O+R\O'R\_+R\O+T]//R\_+R\O'R\_3Q\O/U\_3S
M\O'U]/+S\O'R\O'R\O'R\_+R\_3R\_3R\?/T\_3T\_3S]/3R\_3T\_3R\_3P
M\/#T]?7R\?#S\O-E9FAB8F)A8&!@8&!A86%A86"+BXSS\>_S\_+S\O'R\_+R
M\_+R\O+R\O+R\O'R\O'R\O+R\O+R\O'S\_+R\O'R\_+R\_+R\O+R\O+R\_+R
M\O'R\O'R\_+R\_+R\O+R\O+R\O+R\O+R\O+R\O+S\?"0D)%F9F=H9VAG9VAG
M:&AH9V=G:&AG:&9H9VAG9VAG9VEL;FW2TM3^_O_^_O[__OW_____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________^^____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________[__/S]_?S[__[]_____O[_[.OM
M>GI\9V=G:6=G9V9H:&AF9V=G:&=G9V=H9V9G:&=G9V9F>7I[Y^7E\_+S\?+S
M\O+R\O+R\O+R\?'Q\O+Q\O+Q\O+Q\O+R\_3T\_3T\O'R\O'Q\_+Q]//R\O/R
M\O+R\O/Q]/3S\?'Q]_;V]//T\_+T\?'P]/3S\_+S\O/T\O/R\O/R\_'P\_+T
M8&%A86!@86%A86%>86%A8&!A>GM\]?/Q\/'R]?/R\O/R\O+R\O/R\O/R\O+R
M\O+R\O+Q\O+R\_/R\O+R\O+Q\O/R\O+R\O+Q\O+R\O/R\O+R\O+R\O/R\O+Q
M\O/R\O+R\O+R\O/R\O+R]?3U\?+SY>3G>7I[9V=H:&=H9V=G:&AH:&=G9F9G
M9V=H9V=H:&=F9F9H;&QNT]/5__[]_O[]_?W]_____/W]________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________O?__________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________^_?[^__W]_?_^__[]______[]_____?S__]'0U&UM;V=G9VEH
M969F9V=G9V=H:&=G:&AH:6=G9VEI:6=G9WEY>^?EYO/T]/3T\_+R\?+R\O+R
M\?+R\?+R\O+R\O+S\O+S\O/T]//R]/;T\_3R\?+R\O/T]/+S]//T]?#Q\O3T
M]?+Q\_3S]/7T]?+R\O#P\/7T\O+S\O'R\_3T\_3S]//R\V=H9V!A7V)A86!@
M8&%A86%A7XJ*C?+Q\O3T]?3S\O+R\O+R\O+S\O+R\O+S\O+R\?+R\?+S\O+R
M\O+R\O+S\O+R\?+R\O+R\?+S\O+R\O+S\O+S\O+R\O+R\O+S\O+R\?+S\O+S
M\O/R]//R\_/R]/'Q\>7EY7IZ>F=G:&AH:&=G:6AG9V=F9V9G9VAH9F9G9VAG
M:6=G9VMM<-/2T_[\_______^_?_________^_?______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________[W_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________________________________________^
M_OS^_?_________]_/W__OW[^_G\_/W^_?_4T]5K;&UG:&AG9V=H9VEG9V=G
M9FAG9V=G9V=G9VAH9V=G9V=Y>7KFX^/O[^_T]//R\O+R\O+R\O+R\O'R\O+R
M\_+S\_+R\_/R\_3S]/3P\?#R\O+R\_3T]?7T\_7S\O/T\O'S]//R\_3P\?+S
M\O/T\_+T\O+T]//S]//S\O/U]/7T\_*;FYQ?8&%A8E]A8&!@8&!F9V?+R\OT
M\O/R\O+S]/3R\O+R\_+R\_+R\O+R\O+R\_+R\O+R\O+R\O'R\O'R\O+R\O'R
M\_+R\_+S\_+R\O'R\_+R\O'R\O+R\_+R\O+R\O+R\O+R\O+R\_3S\O/R\O'T
M]//R\O'FY.=Y>7EF9FAG9VAH9VAG9F9G9V=G9V=G9V=H:&AG9VAH9V5L;7'4
MTM/__OW\_/W]_?W_____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__\^________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________/S]_______]________
M_O[\_____OW___[]_____/W]TM+4;&QN:6AH:&=E9V=G9V9F9VAH9V=H9VAH
M:&=H9V9F:&AI>7I\Y>;F\/#P\_/R\O/R\_3S\O+R\O+R\O+R\/'P\O/T\O/T
M\O/T\O+R\O/R\O+R\O/R]//R]//R]?3S\O+R]/7U\_3T]//T]/+R\_+S\?'Q
M\_/R]//T]//R\O+R\_+SI*.D<G-T8&)?@H.'S,S/\/#P\O+Q\O'P\O/S\O+R
M\_/R\O+Q\O/R\O+R\O+R\O+Q\O+Q\O+Q\O+R\O+Q\O/R\O/R\O/R\O+R\O+R
M\O+Q\O+R\O+Q\O/R\O+Q\O/R\O/R\O/R\O+Q]/3S\O/T]//R]/7U\?+SY>3G
M>GI[9VAF:&=H9V=H:6AH:&=G:6AI9VAH9VAH:&=G9F9D;&UPWM[?_OW__/[]
M_?W[_OW_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________OO__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________[^
M_____O____[]_]/3U&ML;FAG96EG:&=H:&=H:&AH9VAG9V=G9VAG:&9G:&=G
M9WEY?//R[_+R\O3S\O3S\O3S\O/T]?/S]/+S\O+S\O+S\O+R\O+R\O+R\O+S
M\O+R\O+S\_+R\O3R\?3S\//R\?/R]/3S\O/S\?+S\O+R\O+R\O+R\O+R\O+S
M\O+R\O/S\O+R\O+R\O+R\O+R\?+R\O+R\?+S\O+S\O'R\_+R\?/Q\/3S]/3S
M\?+S\O+S]/+S]?#S]?3S\L/"Q<[-S?3R\O3T\_+S]/3S\O+R\O+S\O+R\O+R
M\?/S\O+R\O+R\O+R\O#P\//R]//S]?7T]?3R\?+S\O3R\>7DY7IZ>V=H:&AG
M9V=G9VAH:&=G:&=F:&AF9V=H:&=G9VAH9GEY?.SK[?[^_O[^_____?[]____
M___^_?___________?_____^____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________SW_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________W]_?W_________
M__W3T=-M;7!G9V5G9F=H:&AG9V=G9V=G9V=H9V=G9F=G9VAG9VB/CY'R\?/R
M\O'S\_+T\_3S\O3S\_+R\O+R\_+R\O+R\_+R\_+R\_+R\_+S\_+S\O/S\O/S
M\O/Q\/+T\_3R\?+U]/7S\O3R\_+R\_+R\O'R\O+R\O'R\_+R\O'R\_+R\O+R
M\_+R\O+R\O+R\O+R\O+R\O'R\O'S\O/S\O/R\_3P\/#Q\?'T\_+V]//R\?"X
MM[EF:&=@8E]@85]K;7#.SLWQ\O+R\O+R\O+R\O+R\_+R\O+R\O'S\_+R\O+R
M\O'T]//T]//T\O+S\O/R\O+R\O+S\O'S\_3GY>5Y>GUG9VEH:&9F9V=H9VAG
M9V=H:&AG:&AG9F9H9VAG9VAZ>GONZ^[]_?W^_O___OW___W__O_________^
M_?___OW_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________^^________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________[]_____________OW__?S_T]'3:VQN
M:&AH9V=H9V=G9V=F9VAH9V=H:&=G9V9H:&AG9V=HD)"2\_3T\O+R\O'R]?3S
M\?'Q\O+Q\O/R\O/R\O+R\O+R\O/R\O+R\O/R]//T\_+O\_+Q]?3U\O+R]?/R
M\_+S]?3U\O+Q\O+R\O+R\O/R\O+R\O+R\O/R\O+R\O+R\O+R\O+R\O/R\O+R
M\O+R\O+R\O+Q]//R]//T\O/T\O+R\O/R\_+S\._OV=G786%A8&!@86%?86%A
M86%B;&UN]?3U\?'P\O+R\O+Q\O/R\O/R\O+Q\O/R\O/R\O+R\O/U\O+R]//Q
M\_+Q\O/S\O+R\_+S\O'R\O/TYN;F>7I[9V=H:6AH9V9H9V9F9FAG9V=H9VAH
M9V=G:&=E9V9G>WM[[NSN_?W]___]_OW__?W\_OW___[__/W]_O[____]____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____/O______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________W]_?____O[_/____[^_OS\_____=/3TVQL;6=G:6AH:&AG
M9V=F9F=G:&AG9VEH9FAG9VAH:&=H:(^/DO/R\_;T\_/R\_+S\O+R\?+S\O+S
M\O+R\O+R\O+R\O+R\?+R\O+R\O+S]/3T\_'R\/#Q\_+S]/+R\O+S]/+R\O+S
M\O+R\?+R\O+R\?+R\O+S\O+R\O+R\O+R\O+R\?+S\O+R\?+S\O+S\O+R\?;T
M\_+Q\O+S\_'R\?+S\O/R\_7S\9R<GF!A7V%A8F!@8&%B8F%A8&!A8,+!P_+S
M\_+S\O+S\O+R\?+R\O+R\O+R\?+R\O+S\O/R\_+Q\O+Q\O3S\O3S\O3S]/3S
M]/3R\?+S\O3R\>7DY7MZ?&=G9VEG9V5F9FAH:6AG:&=H:&=H:&AG:&EH9F9E
M9WI[>^SL[?S\_?S\_?___?W]^_____S\_?__________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________S[_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_O_________[^_O____________^_O_3T]1L;6YH9V=I9VEG9FAG9V=H:&EG
M9V=G9VAG9VAH:&9G9V>0CY+R\?+S\_+R\_3R\O+R\_+R\O+R\_+R\O+R\_+R
M\_+R\_+R\_+S]/3P\?+S\_7U]/'Q\/+S\?'S\_/R\O+R\_+R\_+R\O+S\_+R
M\O'R\O+R\O+R\O+R\_+S\_+R\_+R\O+R\O'R\O+R\O+U\_+T\_3P\?+T]//R
M\_+T\_3T\_":FIUA86%?7V!A86%A85]B86%A86'"P</T]//R\_+R\_+R\O+R
M\O'R\O+R\O+R\O+R\O'S\O'T\_+T\_+S\O'T\_+S]/7S]/3R\O'R\?#P\?'R
M\?+-SL]M;6YG:&AH9FAG9VAH:&9G9VAG:&AF9F9G9FAH9V5G9VAZ>7WL[.W^
M_O[^_?_____]_/O\_/W_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\]________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M^OO[_________/S]_/__M;6X9V=H:6AH9V9G9V=G9V=G9F=H9V=H9V=G9F9G
M:FAF:&=HD)"2]/+R]//T\O/R\O+R\O+R\O+R\O+R\O/R\O+R\O/R\_3U\_+O
MY.3FI:6GFYN<I:6DV=C:]/+Q\_/R\O+R\O+R\O/R\O+R\O/R\O/R\O/R\O/R
M\O+Q\O/R\O/R\_/R\O/R\O+R\O/R]//R]//T\O/T\/'P\?'P]//T]?/RKJ^R
M86%?86!A8&!@86%A8&!>8&%?V=G:\_3S\O+R\O/R\O/R\O+R\O/R\O+Q\O/R
M\O/R\O+Q\?'P\_3U\O/T]?3U\?#O\O/T\?+U]//T]?3T\O/R]?/RS<W/;6UN
M9V=G:&AG:&=G9V=G:&=H9V=H9V=G9V=G:&=H:&AF>7I][^WN_/S]_O[__?W[
M_?S[_O[___[]________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________O?______________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________^_?W]_?_____________________^
M_?____[]_[6UMV5F9VAH:6=G:&=F9F9G9V=G:&=G9VAH9V9F:&AG9V9G9X^/
ME/;S\?+R\O+R\O+R\?+R\O+R\?+R\O+R\?+R\O+S\N;FY6QM;F%A8F%A86!@
M865G9\[,S_+S\O+R\O+S\O+S\O+R\O+R\O+R\O+R\O+S\O+S\O+R\?+R\O+R
M\O+R\O/S\O+R\O3S]//R\_'R\_+R\?+S\O/R\?7T\_'P[WIZ?6%B8&)B8&%A
M7F!A89*2E?3S]/'R]//S\O+S\O+S\O+R\O+S\O+S\O+R\O+R\?'R\_+S]/#Q
M\/;U\KFXN9N;GKFXN?3S\?7T]?'R\_3R\?+R\O+R\\_/T&UM;6=H:&AG:6AG
M9VAG9V=F9V=G9V=G:&=G9V=G9VAH:'EZ?O#N[_W]_O____S___W]^_______
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____[W_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________Z_?O___[____^_O_______OW___W^_?___O________VS
MM+9G9VAI9V=H9VAG:&9G9F9H9V=G9VAG:&AF9V=G9V=G9VB/D)3R\O+R\O'R
M\O'R\O+R\O'R\_+R\_+R\_+T\_6+C(QA85]B86%A8&%A8%Y@86%[>WSR\O+R
M\O+R\O+R\O+R\_+R\O'R\_+R\O+R\_+R\O+R\O'R\O+R\O+R\O'R\_+R\O+S
M]/3R\_+T\O'S\O/T\_+T]//S]/3R\_7T\O&OKJ^#@X6,C(W"P<3U]/7R\O/T
M\_#R\_+R\O'R\_+R\O'R\O+R\O+R\O+R\O'T\_+T\_3EY.1R<W=A86%A85]@
M86%L;6[6U]CT]/+R\O+R\_3T]?7S\O//SM!L;&QG9V=H9VAH9V=H9V5G9VAH
M9VAG:&AG9V=H9V=F9F=Y>GW__OW[_?_\_______^_O__________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________^[________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________OW___[]_/______M+.U9VAH9V=E
M:&AH9V=G9V=H:&=H:&=G9V=H9V=G9V=G:&AHF)>;\_'P\O/T]/+Q]O/R]//R
M\O/T\O/T]/+R>WM\8&%?86%A8&!>86%@86%A86!A\O+Q\_/R\O+R\O/R\O+Q
M\O+R\O/R\O/R\O/T]//R]?/T\/'P\_3U]//U]O3R[_#Q\_3T\O+Q\/'P]//T
M\_+S]?/R\O'P]/3S\O+R\O+R\O/R\O/R\O+Q\O/R\O/R\O+Q\O+Q\O+R\O/R
M\O+Q\O+R\O/R\O+R\O+R\O+Q]//TFYN=86%>8&%@8&%A8&%A86%?@X2&]O/T
M\O/R\O+Q\O'R]O3S\_3TS<_1;6UM:&AJ9VAH:&AH9F9F:&AG9V=G9V=H:&AH
M:&=G:&AFD)"3___________]_____?W]__[________^_OW__?W]___]____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________O?______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________^_?_____________^_;6TMV9F9VAH9F=F9VEH:&=G
M9V=G9V=G9VAG:&AG:6AH:&9F9[.QL_+Q\?#Q\O3U\O+Q\_7T]?+R\O3R\7M\
M?6%A7V!@8&%A86%A86!@8&%B8/+S\O+R\?+S\O+R\O+R\O+R\?+S\O+R\?+S
M\O3S\O/R]//T\_+S]/7T]?+Q\/'R]?3T\_+R\?+R\?#Q\O'R\_/R]/7T]?+Q
M\_+S\O+R\?+R\O+R\?+S\O+S\O+S\O+R\O+S\O+R\O+R\?+R\?+S\O+R\O+R
M\?+R\O+R\O3S\7I[?E]A7F!A86%B8F!@8&%A85]@8?3S\O+R\?/T]/3S]/+Q
M\//T]?+R\L_-S6QL;6AG:&AG96AH:&=F9VAG:&=G9VAG:&=G9V=G:&9F9Y"0
MD_____[^___^_?W\^_________W]_?W]^_____W]_?K[^_______________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________SW_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______]_?W]_?W____^_?____^UM+=G9VAG9V=H9VAG9V=G9V=H:&EF9F=H
M9VEG9V=G9V=F9F>RL;/R\_+Q\O3S\?#T\_3Q\?'R\O*<G)]@86%B8F!@8&%@
M86%@85^*BHSR\_+S\_+R\O+R\O'R\_+R\_+R\O+R\O+R\O+T\_+S\O/S\_+Q
M\O/T\_'T\_#R\?#S\?'S\O'T\_3R\_3R\O+S\_'U\_'U\_+R\_+R\O+R\O+R
M\O'R\_+R\_+R\O+R\O+R\_+R\_+R\_+R\O+R\O+R\_+R\O'R\O+S]/3T\_)Z
M>WYA85]B8F)A86%@85]@85]@8F'T\_#S]/3R\_/U]/7T\_+R\_+T\_+R\_3.
MS<UM;6UG9V=G9V=I:&IG9VAF9V=G:&AG:&AH9VAG9FAG9V>/CY'________^
M_?____W\_?W____^_OS^_O[\_/__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______\^____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________OW_
M^_O[_/____[___[]M+2V9V=H9VAH9V=G:&=G9F9G:&AH9V=E9V=G9V=G9V=G
M9VAHLK&S]O3S\_/T\_+Q\O/T\_3U\_+QC8R.7V%>8&%@7V%@>GI\Y.3D\O/R
M\O/R\O+Q\O/R\O/R\O+Q\O+R\O+R\?+S]?/R]/+Q\O/R\_3V]?+PFYN;96=G
M8&%A969HL*^P]//Q\/'S\O/U\O/T\?'S\O/R\O+Q\O/R\O+R\O/R\O/R\O+Q
M\O/R\O+R\O/R\O/R\O/R\O/R\O+Q\O/R\O/R]//R]//TG)N?8&%A86!@8F%B
M86!@86)B@8&#\_+Q\_3T\O/T\_+S]//R\?+R]//R\O/S]/7UT,_/;6UM:&=H
M:6AH9V=G9V=G9V=H:&AH9F=G9V=H:&=F9F=GD)&3_____OW___[]___]_/S_
M_OW__/W]_____?W^____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________OO______
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________S\__S___K\^_O[^_______
M_____[2TM&=H:6=G9VAG:&AG9V9G96=G9VAG9VAG9V=G:&9G9VAH:+*QL_3R
M\?+S]?+S]/3U]?3S\O+Q\MC8V</#Q,[,S/;S\O7T]O+R\O+S\O+R\?+R\O+R
M\O+R\?+R\?+R\O+S]//Q\?3R\O+R\O+R])N;GF!A86%A7F%@7F%A86!@8+FX
MN/3S\_+S]/+R\O3S\?+R\O+R\O+S\O+R\O+R\O+R\?+S\O+R\?+S\O+R\?+R
M\?+R\?+R\?/S\O+R\O+R\O'Q\?3S\^3BX'I[?F%B86!A7V!B86UM;MK8V?+R
M\_/T\_+Q\/+Q\O3U]?'R\_3S\?+Q\O+S]/#P\+&PM&=G9V=F9F=G9VAH:6AH
M:&=G:&=H:&=G9F=F9VAG:&=G:)&1D_W\^_S\_?S\_?____[^__[^_O_^_?__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________[W_____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________X^OG\_____O_]_?[____\______^/CY-F
M9V=G9V5F9V=H:&AG9V=H9VEH9VAF9V=G9V=H9VAH9V>RL;3U]//S\O3T\_3T
M\_'S\_+R\_+R\O+T\_+S\O3P\?+R\O+R\O+R\O+R\O'R\O+R\_+R\_+R\O+R
M\_3S\_3T\_3R\?#V\_%F9VEA8&!A86%A86!B86%B86%[>W[T\_+R\_/R\O+S
M\O'R\_+R\O'R\_+R\O'R\_+R\O+R\O+R\_+R\O+R\O+R\O+R\O+R\O+R\O+R
M\O+R\_+P\/#R\O'T\_+R\>^XM[F<G)ZXN+KS\O3T\_3R\_3P\?#V]/+T\_3T
M]?7R\_3T\_+S\O3T\O'R\O'S]/.QL+1G9V=H9VAG9VAH:&9F9FAH:&AG9VAG
M:&AG9VAG9FAG9V6/D)+___[^_O_]_?W]_OS_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________\]____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____OW____]____^_S______OW]______[]_/S____]D)"49F9G:&AI9V9F
M9V=G9VAH9V=H9V=F9V=H9V9G:&=H9V=GL;&R]/+R]/+Q\_'P\O/R\_/S\O/S
M\O'R\O'P\O+R\O+R\O/R\O+Q\O+R\O+Q\O+Q\O/R\O/R\O/R\_+S\O'R]//R
M]O3S8&%A86)B86%A86!@8&!A8&%A>GI\]?3Q\_3T\O/R]//T\O+R\O+Q\O+R
M\O+R\O+R\O+R\O/R\O+R\O+Q\O+Q\O/R\O+Q\O+Q\O+R\O+Q\O/R\O/U\?+S
M\_3T]//T]//T]//P\_+Q\?+T]//T\O/S\_3T]//R]/+Q\O/T\O/S]?3S\_/T
M]//R\_+Q\O/T\O+RL+"S9V=H9VAH9V=G:&=F9F9G9V=H:&AH9V=G:&=G9V=G
M9V=HD)"4__WZ_?W[_________?W]________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________/O__________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________S___[]____
M_______________^_?[^__S^_?[]___^_9"0E&AG9VAG9V=F:&=G9VAG9V=G
M:&=H:&9H:&9G9V=G9V=G:;&PM/+S\O3S\O3U]?+S]/3S\O3R\?+S]/'S]/+S
M\O+S\O+R\?+R\?+R\?+R\O+S\O+S\O+S]//R\_/S]/+S]//R]&MM;&%A86%A
M8&!@7F%B8F!A88.#A?3R\?3U]?+S\O3S]/+S\O+R\O+R\?+S\O+R\O+R\O+S
M\O+S\O+R\O+S\O+R\?/S\O+R\?+R\O/S\O+S\O3S\O;T\_/R\?3S\O3S]//R
M\_/R\_;T\_+S\O+R\O/T]?7T]?7T\_+S\O#Q\/7T\_3T\_+S]//S]//R\_/T
M]//T\[*QLV=G96=G:&9G9VAG9FAG9V=G:&AH:6=F9VAG9V=G:&9G9Y:8F_W]
M_/_^__[^_?____W]_?__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________[S_____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______^_O_____\___]_?V/CY-H:&AH9V=G9V=G9F9G9VAG9F=H9VAG9F9G
M9VAG9V=G9VB[NKWT\_'P\_3V]//S\?'U]/3R\_3S]/3R\O+R\_+R\O+R\O+R
M\O'R\O+R\_+R\O+S\O3T\_3R\_3R\_3T\_*XM[E@86-@85]A8E]@8&!F9VK.
MS<WS\O'T\_3S\O/U]/7T\_+S]/7R\_3U]/+T\O+Q\O/P\/#R\_7T\O+Q\O/R
M\_3T\_3Q\>_S]/3R\_7S\O'R\O'R\O+R\O+R\_+R\O+R\_+R\O+R\O+R\O+R
M\O+R\O'R\O'R\_+R\O'R\_+R\_+R\_3R\_3Q\O+R\_3R\_3R\O+R\_*PLK=H
M:&=G9VAG9VAH9V=H9VAH9VAG9V5G9V=G9V=H:&9H:&FTL[;___[^_O[__OW]
M^_O____________^_?_\_______]_?W_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________\]____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______]____D)"49VAH:&AG:&=H9V9G:&AI9V9F:&=G9V=H9V=H9V=G;&UM
MT<_1\O'S\O/S]?3S]//T]//T\_/R\O+Q\O/R\O+Q\O/R\O+R\O+Q\O+Q\O+R
M]O3S]//R\/'P\O/T\O'R]//RP\+"@8*%>GM^BHN/S<O+\_+Q]//T\O/S]//R
M]//R]/+R\O/S\O/T\O'R]//T\?'P\O/S]?/R\_+S]/+Q\O'R]//R\_/U]/3S
M\O/T]//R\O/R\O/R\O+R\O/R\O+R\O/R\O/R\O+R\O+R\O+Q\O+R\O+R\O/R
M\O/R\O+Q\O+R]/7U\?+S]/7U\O/S\O/T\O+Q\O+Q\O/RLK*T9V=H:&=G:&=G
M:&=H9V9F:&=H9VAH:&=H9V=G9V=H9V=IM+.V___]_/O]__[]_________?W]
M_____?W]_/S]________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________OO__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________________^_?[]__[]_?____K]_?__
M_Y"/E&=G9VAG9V=G9VAG9VAG9VAG9VAH:6=G:&=G9V9G9VQL;=#/T?3S\O#R
M\_/Q\/3R\?3S\O+R\O+R\O+S\O+S\O+R\O/S\O+S\O+R\?+Q\O7T\_/S\_+S
M\O/T]?+S]//T]?3S\O/R\?3S\O/R\_/T]?'R\_+R\O3S\O7T\_7T\O+R\O+S
M\O+S]?/R]//T\_7S],[,RX*#A7I[?7M[?KJYN??T]/'R]?/T]?/R]/+S\O+R
M\O+R\?+R\O+R\O+S\O+R\O+S\O+S\O+R\O+S\O+S\O+R\?+R\O+R\O+R\?+S
M\_/T]?+S]/+R\?'Q\?3T\_+S\O+R\O/S]+*QLVAG:&=G9V=G9VAH:FAH:&=F
M9FAG9V=G:6AG9VAG9V=H:+.SMO_^_?[^_?____[]______W^_/___?[^_?__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________SW_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________^_/_____Z_?SZ_?[^_?V/CY1F9V=H
M9V=G9V=G9F=H9VAG9F9I:&AF9V=I:&AF9F9L;&W/S]#T\_3R\_3T\_+R\_+R
M\_+R\O+R\O+R\O+R\O+R\_+R\O'R\_+R\_3R\_+Q\?'R\O'R\_+R\_3R\_/R
M\_+R\_3Q\?#Q\O/R\_/S]/3R\O+S\O'S\O'T\_+S]//R\O+Q\O+S]/7R\?#/
MS<UE9FAA8F!A8F!A86)@86&OKK#V]/+Q\?'R\_/R\_+R\O+R\O+R\_+R\O'R
M\O'R\O'S\_+R\_+R\O+R\_+R\O+R\O'R\O+R\O+R\O+T]?7Q\O+R\O'S\_/T
M]//P\?#S]/3R\_3R\_3T\_2SLK1F9F9H9V=G9VAH:&EG9V=G:&AH9V=G9F=H
M9V9I:6EH:&FTL[;__OW^_?_____]_?W^_O_^_O[___W]_?W__O__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________^\____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________[_____^OK]__________[]_?W]D)"2:&AI9V=E:&=G:&=H
M:&=G:6AH9F=G:&=G:&AI969F;6QLS<S.]?/R\O/T]//T\O/R\O+Q\O/R\O+R
M\O+Q\O/R\O+R\O+Q\O/S\_3T]/3S\_+Q]?3R]/+Q\O/R]/3S\O/T\O/R]//R
M]//R\O'P]//R\?'Q\O/S]/+Q\_3T\O+Q\O+R\_/T]?3UBHJ-86%A86%A8&%A
M8&!@86%B9F=G]/+R\O+R\O/S\O+Q\O+R\O+R\O/R\O/R\O/R\O/R\O+R\O/R
M\O+Q\O+R\O+R\O+R\O/R\O+R\O/R\?+S\O/T]/3S\?'Q]/3S\O/R\O/T\O/T
M]/3U\?+S\_+SD)"49V=G9V=G9F9G9VAF9V=G:&=G9V=G9F=H:&=E:&=G9V=I
MM+2W_________/___O[__/S]_?W[_____OW_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________OO__________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________[\__[^_O____S__^_M[GAY?6=G96AH9VAG9VAG9V=G9V=G9V=F
M9V9G9VAG9V=G9VYM;<_-S_3R\?/T]/+R\?+R\?+R\O+R\O+R\O+R\O+S\O+R
M\?3T\_'R\O3S]/3S]/3S]/3S]/7T\O3S\O/S]/3S\O7S\O+Q\O;T\_3R\?+R
M\?'R\_;T\_+S]//T]?+Q[_+S]//R\WM\?F!@7V%A7V%B8&!@7V!A8&!A8?/R
M\_+S]?'R]?+R\O+R\O+R\?+S\O+R\O+S\O+R\O+R\O+S\O+R\O+S\O+S\O+S
M\O+S\O/S\O+R\O#Q\O+S]/+S\O3T\_/S\O+S\_/T]?'R\_+S\O/T]?+S\_3S
M\HZ.D69G:&EH:&9G:&AG9V=G9V5F9V=G9V=F9VAG9V=G:&AH:;6UN/_]^?G\
M_?O^_O________S\_?__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________SW_________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________________________]_?[____\_/_____^
M_O_________Z^OWO[NUZ>W]F9VAH9V=G9VAH9VAG:&AH9VAG9V5G9V=G9VAG
M9V=M;6W0SM#T\O'R\_+R\O+R\O'R\O'R\O'R\O+R\_+R\O+R\_+R\O+R\_3S
M\_3R\?+U]/7R\?/S\O3T\_3U]/+R\O+R\_/R\_3S]//T\O+Q\/+R\O+P\?+R
M\?/U]//Q\?'R\O&!@H9A85]A86%@8&!A8F!?8&!G:&CR\?/R\_'T\_3R\O+R
M\_+R\O'R\O+R\O+R\O+S\_+R\O+R\_+R\_+R\O'R\_+R\O+R\O+R\O+R\O+S
M]/3S]/3R\_3R\_3O\/'S]/7P\?+R\_/R\_+R\?#T]?7Q\?'U]/6/CI%F9V=G
M9VAG9V=G9VAF9F=H9V=G9F9H:&IG:&AH:&9F9VBTL[7__?K\_?W____]_/W_
M___Z_?[_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________\]________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________________________]_____OW__/[]
M____[NOK>WM_:&AG:&=G9V=H9F=G9V=G:&AH9V=G9FAG9V=H:&=G;&QMSL_1
M\O/R\O+Q\O+R\O+Q\O+Q\O/R\O+Q\O+R\_3T\?'R\O+R]/3S\_/R\O/R\_3S
M\O/R]/3S\?'Q\_/R\O/T\_3T\O+Q]/+Q\_+T\_/R]/7U]//T\?#Q\_/R\O+R
MP\+#8&%A8&!A86%A7U]?86)AFYN<]//U\O/Q]?/T\O+R\O+R\O+R\O+Q\O/R
M\O+R\O+R\O/R\O+R\O+Q\O/R\O+R\O+R\_/R\O+Q\O/R\?+S\_3T\O/S\?+S
M]/7U\O/T\O/T\O/T]?3U\O/R\?'O\_3U\?+S]//QCX^19V=F9F=G9V9F:&=G
M9VAH9V=G:&=G9V9H9V=G:6=G9V=IOKV______OW______O[]_/__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________________/?__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________S___K]_^WL[GIZ
M?6AG:&AG:&=G9V=G96=G9VAG:&AH:&=G:&=H:&=H:&UL;-?8V?+Q\/3S]?/R
M\_/T\_7T]?+Q\O3T\_+R\O+R\?+R\?+R\O+S\O+S\O/S\O+R\O+S]/3S]/7T
M\_3R\?7T\_+Q\?+S\O/T\_+S]/+S]/#Q\O3U]?+S\_+R\O+S\K>XO&UN;U]@
M86=H:9N;GO;R\?3S\O3R\_+R\O+R\?+R\?/S\O+R\O+R\?/S\O/S\O+S\O+R
M\O7T]?/R]/7U]O+S\O/S\?3S]/;R\?3S\?7T\_+S]/+S]//S\_+R\?+S]/+S
M]/+S]/+S\_+R\?'R\_3U]?3S\O3S\8V/E6AG9V=G:&=G9FAG9V=G:&AG9V=G
M9V=G:&=G:&AH9FUM;M32U/____S______?_^_?______________________
M__S\________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________[W_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________W____]_?W]_?ON[.YY>GQG9VAH9VEG
M:&EF9F=I:&AH:&AG:&AF9V=H:&EH9VAY>7OGYN?T\O+R\_3T\O+S]//U]/+S
M\O/R\O'R\_+R\O+R\O'R\O+R\O'R\O+R\_+S\_'T]//R\_+Q\?'R\_3R\_/R
M\O'R\O+R\_3R\_3S]/7Q\O/R\_3S\_+T]//R\_+Q\?+W]O3R\?'T\_+T\_3R
M\_/S\_+R\_'R\O+R\O+R\_+R\O+R\O+R\_+R\O'R\_+S]/7S]/3S\?#R\_+R
M\O'R\_+R\O'T\_+T\O+T\_+R\_3R\_3R\_+S\_+R\_3R\_3R\O'R\O+Q\O'R
M\O'R\_3S\O/U]//T\_&0D)1G9V=H9VAG9V=G9V=H9VAH9V=G9VAG9VAG9F9H
M9V=L;6[2TM3]_?O^_O____W\_/W^_O[]_?W____]_?W\_/______________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________\]________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________?W[_OW]_OS]_OW__?W\[.OM>7I[9V=H:&=H9V=H:&AH9V=G
M9V=G:6EI9F9G:&=H:&=H>7E[Y.7D]O7R\O/T\?+S\O/R]?3U\O+Q\O/R\O+Q
M\O+Q\O/R\O+Q\O+Q\O+R]//R]//Q\O/T\?+T\O/T\?+S\_3V\O+R\_3U\O/S
M\?+S]/3S\_/S\O+R\O+R\O/R\_3S\?'Q]/3S\O+Q\O/T\O/T\O/S\?'P\O/R
M\O+Q\O/R\O+R\O+Q\O+R\O+R\O/R\_+Q\?'P\O/T\O/T]/3V\/'S\O/T\O/T
M]/7U\O/T]/+Q]//R\_+T]//R]/+Q\_+S\O+R\_3S\O/R\O+R\O/T\_+S]//S
M]/+R]?/QD)"39V=H9VAH9F=G:&=I:&=H:&AH9F=G:&=G:&=F:&=G:VQLU=36
M_?W[_/_______________?W]_/W]_?S^_/__^OS\____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________OO______________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______W\__W]^_K]_?W\^^[K[GIZ?6=G96AH:6=F9VAG:&AG9V9F9FAH:&AH
M:6AG9V=G9WIZ>N/DX_3S\O/T]O/R]//S\O+S\O+R\?+R\?+R\O+R\O+R\O+R
M\?+S\O3S]/3S]//R\_+Q\_+S\O7T\_+Q\_+Q\O+S]/'R\O+R\O/T\_#Q\/3T
M\_+S]//T]/'R\_+S\O'Q\/+S\O7T]?7T]?+Q\/3R\?+R\?+R\O+R\?+R\?+R
M\O+R\?+R\?+S\O7T]?#Q\/3T\_3S\O3Q\_?T]/3S\O+R\>_P\?3U]?3S\O+Q
M\?3R\_/R\_+Q\/+Q\O3S\O3S\O3R\?3R\O+Q\O+S]/+S]//T]/3T\_3S](^/
MDF=F9VAH9F=H:&9G9V=G9V=F:&AG9V=F9VAH:&=G:&QL;-+2U/____[^__W]
M_?____S]_?W]_?S\__W]_?S^_O__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________[[_
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________________________[^_S^_?_____]
M_?S^_O_]_?OLZ^UZ>GQF9V=H9V=H9VAH:&EG9V=G9V=G9VAG9V=H9V=H9V=Y
M>7KCY.7U]/7R\_3T\O'R\O'R\O'R\O+R\O'R\_+R\_+R\O+R\_+U\_'U]?;S
M\O/T\O'R\?/T\O'S\N_S\_3S]/3R\_/S]//R\O'T]//S]//Q\O/S]/7S\_7U
M]/7S\O/U\_3R\?+U]/7T\_+T\O'R\_+R\O'R\O+R\O'R\_+R\O'R\O+R\O+R
M\O+R\_7V]/*<G)]U=79?8&""@H/.S<WS\O'S\O/T\_+U]//S\O3S\O/S\O'U
M]/7T\_3U]/7R\?/U]/7S\O'R\O+R\O'P\?+R\O'S]/3GY^EX>7IH:&EG9F5G
M9V=G9F=G9V=G:&AG9VAF9V=H:&AH9V=L;6[4T]7^_O[^_?_____\_/K_____
M___^_O______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________^^________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________?S[_O[__?S[_OW__?S__OW]_?W]^O[_
MX-[?;&UP9VAF:&AH9V9G:6AH9V=G:&AI9VAH9V=H:6=H9V9G>7E\X^3D]//R
M\_+S\O+R\O/R\O/R\O+R\O/R\O+Q\O/R\O/R\_/S\/#P\O/T]?3U]//R]//R
M\_+T\O/T\?+S\_3T\O/R]/3S\O+Q\/'R]/7U[_#Q]//R\_'P]?3R\O/R\O+Q
M\?+R\O/T\O/T\O+R\O+R\O+R\O/R\_/R\O+R\O+R\O/R\O/T\O'RG)N<8&)A
M86%A86%?86%A9F=GSL[-\_+S]//R]//R\?+S\_+S]//R\_+S\_+S\?#R]?3U
M\O+S]/+Q\O+Q\?'Q\O/R\O+R\_+S\_+QYN;F>'EZ:&=H:&=G9F=H:&=G9F=H
M9V=G9V=H9F9G:&AF:&=G;6UNT]'3_OS[_____?W]___]_________/S_____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________/O______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________^_?_^__K[^_____[]_?____S___S\_]/3TFMM<&AH
M:&=F9FAG:&=G:&=H:&=H:&=G9VAH:6EG:&=G:'AX>N7EY/3S\O+R\?+R\?/S
M\O+R\O+R\O+R\O+R\O+S\O+S]//S\?3S\LO*S)V<GIN;GMG7V/3S\/+S]/+S
M]//T]/+S]/'R\O+S\_/T]/+S]/+S]//T]?+S]//T]/+S]/3U]?'R\_3U]?+S
M\O+R\O+S\O/S\O+R\O+R\O+R\O+R\O+R\O3R\F9G9V!@8&!A8F%A86!A86!A
M88J+CO+Q\/3S]/'R[_/T]?'R\_3R\O/R]/3S\O3S]/+Q\O7S]//R\?3T\_+R
M\?/T]//T]/3S\O+Q\O+S\^;EY7AY>F5F:6=G:&=F9V=G96=G:&=G9V=G9VAG
M9V=F9FAG9FQM<-32TOW]_/______________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________[W_____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_O_____]_?S________]_/O__OW____\___^_?W4TM-L;6YH:&9G9F=G9VAG
M9V5G9VAG:&AG9VAG9VAG9V=H9V=Y>GWDY>?R\_+R\_+S\_+R\O+R\O+R\O+R
M\O'S\_+U]/3T\_**BHUA86%@8%YA86!@86&NKK#Q\O/S]/3P\?+R\_3R\_3S
M]/7S]/3S]/3R\O+R\O+R\_+T\_3T\_3T\_+V]//S\O3S\_+R\O'R\O+R\O+R
M\O+R\_+R\_+R\O+R\O+V\_1A86%A85]@86%A85Y@8&!@8&![?'WV\_+T\_7T
M]?+R\O+S]/7T\_+R\?/T\_+T\_+T\_3S\O3T\O'R\_+R\_+R\_/S\O/Q\O/R
M\O+T\_3T\_3FYN5Z>GQI9V=H:&AG9F=H9V=G9F9G9VAF9V=G9V=G9VAH:&9L
M;7'@X./\^_W________]_?W\____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________^]
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________OW_U-+4;&QN:&AH9V=G9V=H:&AH:&AH9V=H
M9V=H9V9F:&=E9VAH>7E[\O/T]//Q]/+Q\O/T\O/S\O/R]//R]?3R]//UP\+"
M86%A8&!>86%B8&%@8&%?9V=GX^3D\O/R\O+R\O/T]/3U\O/T\/#P\O+R\O+R
M\O+R\O+R\O/R\O+Q\O+R\O+R\O+R\O+R\O+Q\_+S\?#R]//Q\O'P]?3R\_3T
M\?'Q]//R8&%B8&%?86%B86!@8&%A86%ABHN0\_'O]//R\O/S\O/T]/3S\O/T
M\O/T\O/T\_+Q]/+Q\_/T\O+Q\O/T\_/T\O+Q\O+R\O/S]?3U]//R\O/T\?+P
MZ.7C>7A\9V9F:&=H9V=G9V=H:&=H9V=G9V=G9V=H9V=H9F9G>GI][>OL____
M_/____[]_____________?W]__________[]__[]____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________/?______________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____?_____^_?W\_-33U6ML;6=G9VAG9VAG:&AG9VAH9F9G9VAH:6=G9V=G
M9VAH:8^/DO/R\?+R\O/R\_+Q\_+S\O'Q\//R\?/R])R<G&!A8&%B86!@7F!A
M8&%B8F%A8<#"Q?+R\O+R\O'R\O+S]/+S]/+R\O#Q\/+S\O+S\O+S\O+R\O+S
M\O+S\O+S\O+S\O+S\_'R\_'R\_+S]//T]/+S]/+S]/+S]/+Q\_3R\923E&%A
M7V%A86!@7F%A7F%A8<S,S/3S\/3S]//T]//T]/+R\O+R\O+S]/'Q\?3R\?/R
M\_+R\O+R]/3R\O+Q\-?7U]G8V/3S]/+Q[_+Q\_+S\O+S]//R].;DY7EZ?69G
M9VAH:&9G9V=G9V9G9VAH9FAH:6=G9V=F9V=H:'EZ>^[M[OW]_/W\_?_^_?__
M__________W]_?[]__S\_?[^_O__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________S[_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________W\_/W____^
M_?_____4T]5K;&UH9V=H9VAG9V=G9V=G9V=H9VAG9F=G9VAH9V=H9VB.CY#U
M]/7T\_+S\O/T]//R\O'R\O+S\O2;G)Y@8&%A8&!A8&!A86%@86%?8&'`PL;R
M\O'Q\?'S\_3S\_3R\_3T]//R\O'R\O+S\_+T]//T]//R\O'R\O+R\_+R\_+S
M\O3S\O/R\O'T]//Q\O+S]/3R\_3T]?7U\_'U]//T\?*;FIQL;6Y@86)Y>GO-
MS,[T\_+R\?/U]/7Q\O/R\_+R\O+S\_/R\O'T]//T\_7S\O'Q\O/T\_+.S,UL
M;6]@86)A86%L;6[.S<ST\O'S\O;T\_+R\O+Q\O#DY.1Y>GQG9V=H9F=F9F=H
M:&9G:&AH9VEG:&AH9V=H9V9H9VAZ>7OO[._]_?O\_________OW]_/O_____
M_O_^_?___O__________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________^^____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________OW___[]^_[^____U=/5
M;&QN9V=F9V=H9V=H9V=G:&AH9V9G:&=H9V=G:&AF9VAHCHZ1]//T\O/R\_+T
M\O'R\O/S\_+TPL'`8&%A86!@8F%A86!@86%A9V=EX>+C\_3S\O+Q\O/T\O/T
M\O/T\O/R\O/R\O+Q\O/R]/3S\O+R\O+R\O+R\O+R\O+Q\O'P]//R\O/R\O+R
M\O+Q]/7U\_+T\_+S\O/S\O+R]//T\_+P\_+S]//U]?/Q]?3U\?+S]/7U\_3T
M\O'R]//R]/+Q]//R\_+Q\?+Q]//T\_+T\_+QY>3B969H86%?86%?8F%?86%A
M969HY>7D\?#R\O+R\/#P\_3U\O/TY.3E>7EY9F=G:6=H9F=H9V=G9V=H:&=H
M9V9E:&=G:6AH9V=I>GE[[NWO______________[]_?S[_____O[______/[]
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
MO?__________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________S___[]__[]_/_____^_?_^__S[^]73U&UM;F=G:&=G
M9VEH:&9F9F=G9V9G9VAG:&AG9VAG9VAG:)"0D_3S]/3S\O3S]//T]/+S\O/R
M\ZZNL%]A86!@7V%A7V5G9\W,SO3T\_'Q\?+R\O+S]/+S]/+S]/+R\?3T\_+R
M\O+R\?+S\O+R\O+S\O+S\O+S\O/S\O+S]/+S\O+R\O+S]/'R\_/R\_+Q\O7T
M\_'Q\/'R\_+S]//T]/+S\_+S\_'Q\/+S\_+S]/+S]/+S]/7T]?3R\O7T\O/R
M\?7T]?+S\O3S\O+R\_/R\[FXN6!A8F%A8&%A8F%A8F)A86!@8*^NL/+R\O'Q
M\?7T]?3S]?+S]/+Q\]#0TVQL;&9G9VEG:&AG9V=G9V=G:&=G9V=H:&9F9VEH
M:&AG:'EZ?.WK[?[^__[]__S___W]^____O____W]_?_^_?______________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________SO_____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___\___]_?O\_/_]_?O^_?_______OW^_?_`OL!G9VEI:6=H9VAG9VAG9V=G
M9V=F9V=H9VAH9V=H9V=G9F>.CI#U]/3S\_+T\_+R\_3R\O+T\_37U]NYN;K"
MP<+EY>7Q\>_R\_+R\O+R\_+S]/7R\_3R\_3R\O+R\_+R\O+R\O'R\O+R\O+R
M\_+R\O+R\_+S\_/R\_3R\_3T\_/T\_+T\_+T\_+R\_+O\/'T\_3S\O/S\O'R
M\_+S\_+Q\?'S]/7T\_+S\_+R\O+R\O+T\_+R\?#S\O3R\?/S\O3T]//S\O'U
M]/7P\/*;FIQA8F)A8&!@8&%?86!B8E]A86&;FY[T]?7R\O#T\_+V]?+T\_+R
M\_+T\_3/S]!L;&QG9V5H9V=G9V=H9V=F9V=H:&AF9V=G9V=H:&9G9VAZ>7WM
M[.S]_?W^_O_______OW]^_S_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________\\____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________?W[__[__OW\
M_O[______/W]____________M+2V9V=I9F9G:&=H9V=G9V=G:&=H9V=G9F9F
M:&=G:&=G9VAHCHZ0]//R]?/Q\_/Q\O+Q\O/T]/7U\_'P]/+Q\?'P\O/R\O/T
M]/7U\?+S]/3S\O+R\O/R]/7U\_3T\O+R\O/R\O+R\O/R\O/R\O/R\_3S[_#O
MYN3DFYN>>GM\>GM]KJVP\_+T]/3S\O+P\_/T]//T]/+Q]/+Q\O'P\O'P\_+T
M\_+T\O/T]/3S\O+R\?#O]O3S]//R\_+T\_+T\O/T]//R\O'S]O3SS<W-8&%A
M8&!>86)@8&%A86!@86%AP<'"\/'R\_+S]//R\_/R]//R]?3R\/'P\O'RS\_0
M;&UM9V=G9V=H9V9H:&AF9F=G:&AH9V9E:&=G9V9G9F9F>7I^[NOJ_____/S]
M_____________/W]____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________/O__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________[]__W\^_S___S________^_?_^
M_?____S____^_;6TMF=G:&AG96AH:&=G:&=F9F=G9F=G9V=G:&AG9V=G96=G
M:(^/DO+S]//R\_7U]O+S]/#P\/3S\O+Q\O3S]/'R\_+S\_+S]/+S]/+S\O3T
M\_+R\?+S]/+S]/+R\O+R\?+R\?+R\?+R\?3T\^_O[^3DY7-T=6!@8&!A8&%A
M8&%A8I.3EO/Q[_+S]O3R\O+R\O+S\O+S]/+S]//T]/'Q\/3S\?+S]//T]/+R
M\?3S\O3S\O/R\?3S\O3S\O3U]?3S]/3R\O7S]/3S\HN+C6%A86!@8&%A7V%A
M88N+C/7S\?#Q\_/R]//R]/#S]/3S]/3S\O3S\O#Q]/+S],_/SVQL;FAG9VAH
M:&AG:&AG9VAG:&=G:&=G9V=G9V=H:&AG97EY?_[\^_____S\_?W]_?W]_?S^
M_O__________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_S[_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________________________________[_OW\___^
M_O^SL[9G9VAH9V5H9VAG9VAH9V=H9V=G9V=G9VAF9F=G9V5G9V>8EYOR\_3T
M\O'R\?#T]?7Q\?#R\O+R\?+S\_7R\_+R\O+R\O+R\O+R\O'R\_+R\_+R\O'T
M\_+S\O/S]/3R\_+R\O'T\_3S\N^OKJ]A86)@8&%A8F!A85]B86%A86':V-KR
M\_3R\O+R\O+R\O+R\_+R\O+R\O+R\O'R\_+T\_+T\_3T\O+S\O/R\?#V]//T
M\_3V]/'T\_+R\?#R\_3R\_3T\_3S\O"OK[%Z>W]Z>WZOK['Q\.[U]/7Q\O+R
M\_/R\?'T\O+V]//T\O+R\O+R\O'R\_3U\_+/S<QK;6YH9V=I:&AG9FAG9VAG
M9VEG9VAG:&AG9VAH9VAG9VB0D)3__OW[^_S^_?_[_/___OW\_____OW__OW_
M_______________^_O__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________\^____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________________________]__WZM+.V9V=I
M:&=F:&=H9V9H9F9G9V=H9VAH:6AF9V9G:&=I9V=GL;&R]//R\O/U]//R\_+S
M]/3S\O+R\O'R\O+R\O+R\O+Q\O/R\O+R\O/R\O/R\O+Q]/+Q]?3U\O/T\O+R
M\O+Q]//T\_+OFYN?8&!>8&%A8&%A86!A8&%A7V!@PL'"\O+Q\O/R\O+R\O+Q
M\O+Q\O+R\O+R\O/R\O+R\_+S]//T\_/T]//U\O'R]/+S]//R\_+S]//T]/+R
M\O+Q\_3T\?#Q]?3U\?#O^/3R]_/Q\O'P]?3U\._Q\O/T\O/R]//R]//T\_+T
M\_/T\_/R\O+R\O/T\O'R]O7RT,[-;&QM9V=H:&AH:&AI9V=E9F=G9V=H:&=E
M9F9F:&=G9V=GD9"3____^_W^_/[^^_S__OW__?W^_?W]_____/S__/___?W]
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________N___________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________S]_?____W\^________[.RM69G:&=G96=G:&9F
M9F=G9V=G9V=G9VAG:&AG:&AG96=G:+"OLO/S\O/S]?;T\_'Q\?3T\_+R\O+S
M\O+R\O+R\O+R\?+R\O+S\O+R\O+R\O7T\_'P\?+S\_+R\?'R\?3S]/3R\IJ;
MH&!@8&%A86%B86%A7U]@7E]A8<[-S_#Q\O+R\O+S\O+R\O+S\O+R\O+R\O+R
M\O+S\O/R\_7T\_+S\_/S\O/S\_'R\_3R\?/R]/+S]//T]?3S\O3R\O7T]?3S
M]/7T]?+Q]/+R]/7T]O3S]/7T]?3R\?3S\O/T]?+S\_3S]/3S]/+S]/+R\?3U
M]?#O\?'Q\O;T\\_-SFQM;FAH:&AG96EH:&=G9V9G9VAG:&AH:&AG9VAG96=G
M:)"0E/___?K]_?_^__W\_?____W]_?____[^__G\_?S___W]^___________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________S[_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________^_OW\_/_____\______^TM+=G:&AH9V=G9VAG:&AF9V=H:&EG
M9F9H:&9H9VAG9V=G:&BPL++T\_'Q\O/V]//S\O3Q\?#S\_+R\_+R\O'S\_+R
M\O'R\O'R\O+R\_+S\O'U]/7Q\O'Q\?#T]//Q\/+T\_+6UM=H:&9@86%B8E]@
M8&%@86%S='3V\_3R\?+R\_+R\O+R\O+R\O+R\O+R\O+R\_+R\_+U]/7P\/#S
M]/7T]//R\O+S]/7R\_+T\_3R\_7Q\O/T\_+T\O'T\O+R\?#R\_3R\_3R\_/R
M\_3R\?#T\O'U]//T\_+Q\O/R\_7R\O+R\_/S\O/T\_+R\?#T]/7R\_/R\_3S
M\O//SLUM;6UH9VAF9F=G9V9H9V9G9VAG9F=G9V5G9VAG9V=H:&F0D)3____[
M^_O____\_/S___[\_/K____^_O_____]_?W_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__^^________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________/_____^
M_____/S]__________WZM+.V9V=H:&=H9V=G:&=G9F9G:&AI9V=G:&=I:&=G
M:&=H9V=HL[*T]//Q]//U]//R\_3U\O+R\_/R\O/R\O+R\O+R\_/R\O+Q\O+R
M]//T\_+T\O+R\O+R\?'Q]?3U]/+Q]//RS<S.;6YN8&)?86)@>WM\YN3E]//R
M\_'P\O/R\O/R\O/R\O/R\O/R\O+Q\O+R\O/R\?'Q\O/U\O'R\_+T\_+T\_+S
M\O/U\O+Q\O/S\_3T]?3U\_+T]//R\?'Q\O+R\O+R\O+R\O+R\O+R]//R]//T
M]//T]/7U\O/T\_/P\?'Q\_+S]/+Q]//R\O+R\O/R\O+Q\_+S]//TNKJ\9F=H
M:&=H:&=E:&=H9F9F9V=H9V=H9V=G:&=I9V9F:&=HD)"3___]____________
M___]___]_____OW_____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________/?__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________S_______W]^_____S\__W\
M^____?[]_YJ9G6=G:&=H9F=G9V=G9V9F9F=H:&=G9VAG:&AG9VEH:&=G:+"P
MLO/S\O+S]?+Q\/+S\O+R\?+R\O+R\?+R\?+R\O+S\O+R\O/R]/3S\O+S\O+R
M\O'R\O/R\?/R\?/R\?+Q\O3S]//Q[_3S]/3S\O+S\_/T]O+S]/+R\O+R\?+R
M\O+R\O+R\O+R\?+R\?+R\O3U]?+Q\,/"PIN;GIR<G\+!P?3S\O3T\_+S\O/S
M\O+Q\_/R\_7T]?3S]/+S]/3U]?3U]?+S]//S]/7T]?3S]/+Q\O/T\_+R\O+R
M\O+S]/3S]/3S]//R\_+S]/+R\O+R\O+Q\/+S\_'R\K*QM69F9FAG9V=F96=G
M:&9G:&AH:&AF9V=G9V=H:&AG96AH:)"0E?___?[]___^__W]_?_^_?[^_O__
M__W]_?______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________SW_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________OW^_?_______OW]_?W________\______V/
MCY)H:&AG9FAH9V=G9V=G9V=H9V=G9F9G:&AG9F9H9VAG:&BPL++T\O+T\O+S
M\_+R\_+R\O'R\O'R\O+R\O+R\_+R\O'T]?7T]//S\O'R\?+S\O/R\_+S\_+P
M\?+R\_3S]/3T\_+R\_7S\_'S\_+Q\?'V]//R\_+R\O+S\_+R\_+R\O+S\_+R
M\_+R\O'R\?*PL+!>8&!@8&!?8%]A8F&)BH[V]//R\_+R\O+T\_3U]/3T\_3R
M\?+T\_3T\_3S\O/S\O/R\?+S\O/T\_3T\_3R\O'R\O+U]/7U]/3R\_3P\?#R
M\_3T\_3T\_3T\_+T\_+R\_+P\/#S\O2RL;1G:&AG9VAF9V=G9V=G9F=H:&AG
M9VAG9V5G9V=G9V=G9V>/D)3__?K^_O_____]_?S_____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________\^________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________[]_/___/_______/W]_____/[]_/____[]D)"4:&AH:&=G
M:&=H9V=H:&=G:&AH9V=G9V9G9V=G9VAH9V=HLK&R\_3T\O+Q\O+R\O/R\O+R
M\O+R\O+R\O/R\O+Q\O/T\O+Q\_+S\_+S\_+S\O+R\O/R\O/T\_3T]//R\_+Q
M\O'R\_/Q\/'S]?3R]O/R\O+R\O+R\O/R\O+Q\O/R\O+R\O+Q\O+RV=?87V!B
M8&!@86%@86%@86%?8&%BP\+#\O/T\O/T\_+S]/+R\_'P\_+Q\_+Q]//T\_+S
M\_+Q]//R\_+Q\O'P]//T\O/T\O/T]//T]?3U\O+Q\_/Q\O/R\_+S\_+S]?3S
M\_+T]//R\O/R\/'P\_+TL;&T9VAH:&=G:6=G:&AH9F=H9F=G:&=H:&AH9F9F
M9V=H9V=GF)B<___________]_O[^_?W^_/__________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____/O______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________O]_____Y"0DF=G:&AG9V=G9V=G:&AG
M9VAG9V=G9V=G:&=F9VAG9F=G:+V[O/'R]?3R\O7R\_+S]/#Q\?+S]/7T\O3S
M\O+R\O+R\O+R\O+R\O+R\O+S\O+S\O+R\O+S\O+R\O+S\O+R\O+S\O+R\O+R
M\?+R\?+R\?+R\O+R\O+R\?+R\?+R\?+R\O+R\L/"Q&!A86%A86%B86!A86%A
M86%@7IR;G_+R\?+S\O+R\O+S\O+R\O+R\O+R\O+R\O/R\_+S\O+Q\O3R\O7S
M\O#P\O+S]/3R\O+R\O+R\O+R\?+R\O+S\O+R\?+R\O+R\O3S\O3U]?+S]/3T
M\_3R\O+Q\+.RM&=H:6AG9VAG9V=H:&=G:&9F9V=G:&AG9VAG:&AG9V=G9[2T
MM_____S\_?[^_?[]______O]_O___O___?________________[^________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________SW_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________OW__OW___^0D)-H9V=G9VAG:&AH:&AF9V=G9V=G9V=H
M9V5G9VAF9FAM;6[0SL_S\?'Q\O/T\_3S]/7S\^[R\_3U]//R\_+S\_+R\_+R
M\_+R\O+R\O'R\_+R\O+R\O+R\_+R\O+R\O+R\O'R\O+R\O+R\O'R\O+R\_+R
M\_+R\O+R\O'R\O'R\_+R\_+"P\1?85YA8&!@86%A86%A8&!A8F";FY_S\_+R
M\_+R\O'R\_+R\O'R\_+R\O'R\_+T\_3O[^_R\O+S]/3S\?'R\_3S]//T\_+S
M\_+S\_+R\O+R\_+R\O+R\O+R\O+R\O+S\O'P\?+S]//Q\?'U]/7S\_7S\.ZS
ML[5F9V=F9FAG9V=H9V=G9VAG:&9F9F=H:&AH9V=G9VEG9V>UM+;^_O[\___]
M_OS__O_____\_?W^_?_\_/________[_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________^]________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________________________________________]
M__[]_/O]_/___/W]D)"29V=F:&=G:&=H:&AH9V=G9V=H9V=G:&=H:&=H:&=F
M;6UNS\W/]?3R\?+S\_+Q\O+R\_/N\_3T\O/R\O+R\O+Q\O+R\O+Q\O+Q\O+R
M\O+R\_/R\O+R\O+R\O+Q\O+Q\O/R\O+R\O+R\O+R\O+R\O+R\O+Q\O/R\O/R
M\O+R\O+QY>3G9F=F8&%A86%A86!@8&!?8&)?U]?9\O+R\O/R\O+Q\O+R\O+Q
M\_/R\O/R\O+R\_+S\O+R\O/T\O+Q\_/R\O/P\O+S]/+Q\O+Q\O/R\O/R\O+Q
M\O+Q\O+R\O+Q\O/R]//R]/3U\O/S\O+R]//R]//U]//U\O'PLK*S9VAG:&=G
M:&=H9V=G9F=G:6AF:&=H9V=I9V9F9V=G9V=GL[2V_?W]_/___?W]________
M_O[__OW______/S]___]________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________/O______________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________S\_?____[]__S\
M_?S\_9&0DV=G:&AH9V=F:&=G:&AH:6AG:6AG9VEH9FAG:&=G9VQM;<[.T/7T
M\O#S\?3S\O/T]>_P\?+R\?+R\O+R\O+S\O+S\O+R\?+R\?+R\O+R\?+R\O+S
M\O+S\O+R\O+R\?+R\?+S\O+R\?+R\O+R\?+S\O+R\?+R\O+R\?+R\O+R\\_-
MSV=H9V!A7V!A7V=H9ZVLL//R\?+S\O+S\O+R\O+S\O+S\O+R\O+R\O/S\O+S
M\O3S]?3S\N;EY<O+S?+R\_3S\O3R\O+R\O+S\O+S\O+R\O+R\O+R\O+R\?+R
M\O'Q\?3U]?+S]/+R\O3R\?3S\O7T]?/R\?3S]+.SLV9G9V=F:&EH:F=G9V=G
M9VAH:&=G:&AH:6AG9V9G:&AH:+.TMO[^_OS\_?_^_?O[_/______________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____SS_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________^_?_]_?W____^_/O^_?_\______^0D))G
M9V=G9F=J:6EF9F9I:6IG9VAG9V=F9V=H9V=G9V=M;6[,S=#V]//P\?+T\_3R
M\_/R\_+R\O+R\O+R\O'R\_+R\O+R\O'R\O'R\O+R\O'R\_+R\O+R\O+R\_+R
M\O'R\O+R\O+R\O+R\O+R\O+R\O+R\O'R\O+R\_+T\O'T\_3R\?+!PL/"PL/D
MX^3S\_3U\_+R\_+S\_+R\O+R\O'R\O+R\_+R\_+R\_+Q\?'GY>2+BXQ@85Y?
M8&%F9V>MK:[T\_+R\O'R\_+R\O+R\O'R\O+R\O+R\O+S\_+S\_+T\_3S\O/U
M]/7R\_+R\O'P\?#S]//S\O3R\?.9FIUF9F9G9F=G9VAH:&AG9VAG9VAG9V=F
M9V=H9VAG9VEG:&BTM+7____\_/___________OW____^_O_[_/__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________\\________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________/____[__OS\_________?S]__[]____>7I^9F=G:&=E:6AH
M9F9G9VAH9VAH9V=G:&=E:&=H9V=H;6UNSL[0]O3S\/'R]O/T\O+R\O+R\O+R
M\O+R\O+Q\O/R\O+R\O+R\O+R\O+Q\O+R\O+Q\_/R\O+Q\O+Q\O+R\O/R\O+R
M\O/R\O+R\O+R\O+Q\O+Q\O/R]?3R\_/R\/#P]/7U\_3T\O+R]//R\O'P\O/R
M\O/R\O+R\O+Q\O+Q\O+Q\O+Q\O+R\?'PBXR08&%A86%?86%A8F%B8&%AM[B\
M\O+R\O/R\O/R\O+R\O+R\O/R\O/R\O+Q\O'Q]/+Q]?3U\_+S\O/T\O/T]/3S
M\O/S]//T]/3S\?#OD)"29V=G:&=G9V9F9V=H:6AH9V=G9V=G9V=H:&=G:&=G
M9V=GM+.V_OW]__[__O[__/S]____^_S__OW____]____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________OO______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____?[^__W]_?S]_?_^_?___?O]_^WL['I[?F=G:&AG:&AG:&=G9V9F9FAH
M:&AG9V=H:&=F:&=G9VQL;=#.T/+Q\/3R\?+R\?+R\?+R\O+R\?+R\O+S\O+R
M\O+R\O+R\O+R\?+S\O+S\O+R\?+R\O+S\O+S\O+S\O+R\O+R\O+S\O+R\?+S
M\O+S\O+S\O3S\O3U\O'R]/+R\?#Q\/3T]O'R\//R\?+R\?+R\?+R\?+S\O+R
M\?+S\O+R\?+R\?/R\V!A86%A86%B8&%A86%A7V%A7X*#AO+S\O+R\O+S\O+R
M\O+R\O+S\O/S\O+R\O3S]/3R\O3S\O/R\_3U]?/T]?#Q\O3U]?3S]/+S\O+S
M\O/R\X^/D6=H:&9F:&=G9V=G9VAG:&=H:&=G9VAH:6AG9V9G:&=G9[6TMOS[
M^O[]______S]_?________[]_/__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________S[_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________OW____\___^_O__
M______W____________N[>UY>GYH:&AH9V=G9F=H9V=H9V=G9VEH9V=H:&9H
M9V=F9V=L;&W/SL[Q\O7R\O'R\O+R\O+R\_+R\O'R\O+R\O+R\O+R\_+R\_+R
M\O+R\_+R\O+R\O'R\O+R\O+R\O+R\O+R\O+R\O+R\O'R\_+R\O+R\O+S]/;S
M]/3R\O+T\_3T\_3R\O+T]?7Q\O3R\_+R\O+R\O+R\O'R\O+R\O+R\_+R\O'T
M\?)@85]A86)?86%A86%B86)@8%Y[>WSR\O'R\O+R\O+R\O+R\_+R\O+R\O+R
M\_+S\O3T\_3R\?#S\_/P\?#T\O'T\_+S\O'S\_+Q\O+R\_3R\?#T\_*.CI)G
M9VAG9V=H9VEH9V=H:&AG:&AG9VAG9VEH9V=H:&AF9VB_O[_______O___OW_
M_______Z_?[_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______\\____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____OW_[.SN>GI]9V=G:&=F:&=H9VAH:&AI9V9F:&AH9V=G9V=H9F9D;&UO
MV]G8\O/T\O+R\_+Q]/+Q\_/S\O+Q]//R]?3U\_/R\_+T]O3S\_+S]?3U\O/U
M\?'P\_/Q\O/T\?+T\O/Q\_3T]//R\_+T\O'S\O/T]//T]//T\?'P\O+R\_3T
M]//U]//T\_+T]//T\/#P\O+R\O/S\_+S]?3U\O'S]/3S\_'P;&UN8&!?86%B
M86!@8F%?8&%ABXN,\O/R\O/R\O/R\O+R\O+R\O+Q\O+Q\O+Q\?'P]?3U\_+S
M]O3S\/'R\?+U\O/T\O/S\O/T\O'P\_+T\_'P\O/R]//RD)"29V=F9V=G9V9G
M9V=G9V=H9V=H9F9F9VAH9V9H:&=E;6UOT]+4_/W]_____O[_____^_O\____
M__[]__[]__[]_/W]_/___/W]_/O]________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________OO______
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________[]_/_____^_>[M
M[WIZ?&=F9VAH:&AG:&=F9F=G9V9G9V=H:&AG9VAG:&=G:7EZ>^;EY?;T\_+Q
M\O3U]?+S]/7T]?/R\_3S\O/S\O+S]/'Q[_+S]/'Q\?7T\MG7UL'!Q>7DXO3S
M\O+S]/+R\?3S\O+Q\O3S\O/S\O/R\?+Q\//T\_'R\_/T]/3S]//R\?3S\O3S
M]//R\_'Q\/+R\?3R\?3S]/+Q\/+S\O3S\KFXN6!A86!@7V)B8F%A7V=I:=C7
MV/+R\?+S\O+S\O+R\O+R\O+S\O+S\O+S\O+S\_+S]?+R\/'R\_+Q\.3DYKBX
MN+FYNMG7V/3S\O#Q\/+S]?+R\?+Q\O?T]H^/E&=G9V=G9V9E9VAG9V=G9VAH
M:69G9VAG:&AG:&=G:&QM;=/2U/[]___^_?OZ^_____________[]___^____
M__W]^_[]_/__________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________[W_____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________W___W^_?_____M[>]Z>GQH9VEH
M9V5G9VAG9V9G9V=G9VAH9VAG9FAG9VAG:&9Y>7OHYNCS]/3S]/7S]/3T\_7U
M]/3R\O'S\O/R\_3R\_7Q\O/EY>1Y>GMA86%@86!?8&*;FYWQ\/'T\O+T\_3S
M\O/R\_3Q\?'O[^_T]//T\_3U]/7S\O3P\?#T]//R\O+T\_3R\?#R\O'R\_3T
M]//T\_+T\_+R\_7Q\?#S\O'#PL6*BHUZ>WN3DY;DX^3S\O'R\O+R\O+R\_+R
M\O+R\O+R\O'R\_+R\O+S\O/S\_'R\O+Q\?"OK[!E9F=B8F-?8&!?8&&NKJ_R
M\O+S]/3R\_3R\O3S\O'T\_&/CY)F9V=H:&AG9V=G9V=G9V=G:&AF9V=F9V=F
M9F9H9V=L;6[3TM3^_O___OW^_?_]_?W____^_O_[_/_^_O[__OW__OW]_?W_
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________^^____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________/W][.SP>7I[9V=H:&=H:&=H9F9F
M9V=G9V=H9V9G:&=G:&AI9V=G>'AZY>3G\O/R\O/R\O/T\_3T\_3S\O/T\_3T
M\?'Q\_+Q>GM[8&)A86%>8F)@86%?7V%@NKFZ]/+R\_+S\_+S\?+S]/7U]/3S
M]/3S\._Q\_+S]?3U\_/R\?'Q]/7U\O'R\O/S\O/T\/'R\/'R\O/R\_+S]//T
M\O/T\_3T]?3U\?#O\_+Q\_+S\O/T\_3S\O+Q\O+Q\O+R\O+R\O+Q\O+Q\O+R
M\O/R\_3U\O+P]/+RY.3D9F=F86)@86!>86%?8&!?8&%@VMG8[_#Q\O+Q]?/R
M]?3R\?'O]?3RCX^29V=G:6AH9V=H:&=G:&AI9V=H9VAH9V=G9V=G9V=H;6YO
MU-/5_OW________]_/W]^_O[_________________OW]________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________/O__________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______[^__OY^/___?O[_O___^WL[GEZ?6AG9V=G:&AG9VAG96=H:&9G9VAH
M:6=F9FAG9V=G9WEY>^3CX_+R\O/T]//T]?3S\O#Q\//S\O/R\?7R\V!A7V!A
M86%A86!@86)A86%B8H*"A/3S]/#P\?3T\_#P\/+S\O+S\_+S]/7T]?/R\_+Q
M\/+R\?3U]?'R]?7U\/'R\_'R\O'Q\?7U\_'R\_+Q\O3S\?+S]//T]//S\?/S
M\?'R]/#Q\O+R\O+R\?+S\O+S\O+R\O+R\O+S\O+R\?+S\O+R\O+S]//T]/3R
M\KBWNF%A86!?8&%A86!A8&%A8&!A89J:F_7T]?+S\_/S\?/T]?3S]/+S]//R
M]'IZ?&=G:&EH:&=G9VEH9V=G:6AG:&EH:&=G9VAG:6=F:&QM;M/2U/W]_?S\
M_?____[^_/W]_/_____^__[^___^_?______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________S[_____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________________________]_/W________]
M_/O__OW^_?_Y^OC@X.!L;&YF9F9G9VAH9V=F9V=G9V=F9V=G:&AG9V=G9VAG
M:&9Y>7OEY>CR\_3R\?+T\_+T\_3R\O+R\?+EY.9A86%A86%@86%A85YA86%@
M86%Z>WSU]/7R\_3T\O'S\O/T]?7S\O3T\_3S]/3P\?#R\O'S\O/S\O/U]/+R
M\?+U]/7S\O/U]/7R\O3S]/3R\?#T\O'T\_+U]/+R\O+Q\?#P\?#R\_3R\_3U
M\_'R\_+R\_+R\O+R\O'R\O'R\_+R\O'R\_+R\O'T\O+S\O.OKK!A86%A85]@
M86%@8&!B85]@86&<FYWT\_3T]/;S\_+T\_+T\_7R\_3V]?+FY.=Y>7MG9V=H
M9V5H9VAG:&AG9FAG9F9G9V9H9V=G9F9H:&AL;6W3TM3^_O_^_?_^_?____W_
M___^_?_^_O____[_____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________^^____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________/S]_______]____^_O\__[]
M_O[_TM#0;&UO:&AH9V=H:&=H:&AG9F=G:&AH:&AI9V=G9V=H9V=G>'AZY^;H
M]?3S\O+R]//R\?'Q]/3R]/+Q;&UM86)B8&%@86%A86%A7V%@FYN<]//T\?+S
M\O'R]?7V\O'R]/+R\_+T\O/T\?'O\O+Q\_+T]/+RSLW*>WM]7V%@7V!@BXJ-
MZ.7C\_'O]/7U\?+V]//T]O3S\O/T\O/U\?+T\O+R]//R]//T\O+R\O+R\_/R
M\O+R\O+R\O+Q\O+Q\O+R]?/Q\?'Q\O+QV-C98&%?86%?8&!@86%A86%A86)@
MS<W-\?+U]/+S\_+S]/+R\O+R\O/T\O+Q\O/SY>3E>GI[9F9H:&=G9V=G9V9G
M:6AH9V9F:&AH9V=G9F9F9V=H;&QNU-+3_____OW____________________]
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________O?__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________W]_?________W]_?_________^___^_?[]_]/1T&UM
M;VAH:&=F9V=G:&AH:&=G:&AG9VAG:&=G9VAH:&=G9WAX>N7EY/+S]/3S\O/S
M\O'R]/3T\[BWN6!A86)B8&%A8&!A871U=>;EYO+Q\_'Q\//R\?/R\_3S\?3R
M\?3S]//T]//S\?/S\_+R].7BXF5G:&%@8&%A8&%A7V%A8')T=O3S\/+S]/+R
M\?+S]/+S]?/S]//T\^_P[_+S]/3S]/7S\O+R\O+S\O+R\O+S\O+R\?+S\O+S
M\O+R\O/S]?+S\_#S]/+S\J^OL&%A8F)A7V!@8&%A8IN<GO'Q[_/T]/3S\O7T
M\_/R\_+R\O3S]/+S]/#Q\/7S\N7CYGIY>V=F9FAG9V=G9V=F9VAG:&=G:&9G
M9V=H:&AG:&AG96MM;N#?W_[]_______^_?__________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________[W_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________________^_?_1TM5L;6]H:&AH9V=G
M9VAG9V=G:&AG9VAH9VAH9V=G9V=H9V=X>7SX]//P\?+T\O'U]/+U]/7T\O',
MS<Z2DY=[>WRBI*KCY./R\_+R\_3R\_3Q\O+R\O'R\O+T]//P\?+S\O/R\?'R
M\O'Q\?&EI:9@8&%@85]@86!A85]@8&!A8F'-R\SU\_3U]//S\_+T]//Q\?#R
M\O'R\_+R\O'T]//R\_+R\_3R\_3Q\O/R\O+R\O'Q\>_R\O+P\?+S\O/S\_3S
M\O3U]/+T\O+9V->;FY^;FY[+S=#P\?#R\_+R\_+R\O+R\O+R\O+R\O+R\O'R
M\O+T]//Q\O/R\_3EY.1X>'QG9V=H9VAG9V=G9V=H9VAG9FAG9VAG:&AG9V=G
M9V=Z>G[N[>_______O_^_?_^_O_\_/W^_O_^_OW^_O_\_/W______OW]_?W^
M_?__________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\\____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________^__[]TM#3;&UN9V9G:&AF9V=H9F9G:&=H
M:&AI9VAH9V=H9V=G9V=HCX^2\_+S]//Q\O/S\O/P]/7U\O'P]?/P]/+R\?+P
M]/3S\?'P\_3U\O/T\O/T\O+R\O/R\O/R\O/S\O'R]//R\?+S\_/RFYN>8&%@
M86%@8&!@86!@86%A7V%@P\/#\O/S\_/U]/3S\?+Q\O/R\O/R\O/R\O+R\O+Q
M\O/R]//R\_3S\O/T\O/T\O/T\O/T\?'R\_3T\O+R\O+R]//T\_+T\_+S]//R
M\O'P]//P\?'P]/3S\?+Q\O/R\_/R]/3S\O/R]/3S\?+S]?/T]//T\_3T\O/S
M\?#OY^7C>'A\:&=E9V=H:&=H:&=G9V=G9F=G9V=E9V9G9V9G9V=H>7E[[.SM
M__[]^_O[___]_OW______________OW______/S]____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________O?__________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______S^_?____S\_?___=+2U&QL;&=G:&AG9VAH:&=F:&=G9V=H:&9F9V=G
M9VAG9V=H:(^/D/3S]/3U]?/T]?#Q\?'P\O/S]?+S]?+S\O+R\O/S\O'R\_#Q
M\O/T]?+R\O+R\?3T\_'Q\?+S\O7T\N_P\O+S\ZZNKV!A8&%@86%@86)A86%A
M86!B8LW-S/'Q\?+S\_'Q\?+S\O/S\_'Q\?+S\O+S\O3T\_/S\O+R\?+R\O3S
M\O/R]//R]/3S]//R\_3R\O3T\_+R\?+Q\O/R\_7T]?3S]/3S]/+Q\O+R\O'Q
M\?+R\?+R\O+S\O+S\O+R\?+R\O7T]?+Q\O+Q\O+Q\/+S\O+S]/'P[^7DXWIZ
M>V=H:&AH:&AH:6=G9VAH9FAG:&=G:&=G9VAH:&=G9WIZ>^SK[?_]^OO[^_[]
M___^_?_^_?W]_?W]_?_^______W]_?_^_?__________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________SW_________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________________________________[_?S^_?__
M_O_]_/W[^_G6U==L;&YG9VAG9F9H9VEG9VAG9VAF9V=H:&EG9F9H:&AG9V60
MD)+S\O;Q\O/U]O;Q\?'U]/;T\_#R\_3R\_3R\_/R\_+U]?3Q\?'R\_3R\_3S
M\O'R\O'T]//R\?#R\_/P\?+FYN-S='=A86)A86%A85]@86&*BHWT\_+S]/;S
M\_3R\O+R\_+P\?#T]//T]//R\O+T]//R\_+P\?+R\_/S\O3T\_3S\_3S\O/T
M\O'R\_+R\_3R\_/R\?+R\?+R\O/V]//Q\?'T]//R\O+R\O'R\_+P\?#S\_/R
M\O'R\_+R\O+T\O+U]/7U\_3T\_+P\?#R\_+R\_3R\_3GY.1X>'IH9VAH9V=F
M9V=G9V=G9V=G9FAG9VAG9V5H9VAF9FA[>WOM[.W___W^_?_____[^_O____]
M_?[____\_/________W_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________^]________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________O[^_/W]_/___?W]
MTM+4;6UN9V=G:&AH9V9G9V=G9V=G9V=H9V9H9V9G:&AG9VAHCXZ1]_3R\O+Q
M]/7U\O+Q\_+S]/7U\O/T\_3U\O+R\?'Q\/'P\_3U\O/T\_+S\_3T\?'R]//R
M\/#P\O/R]/+QYN/CBHJ->GM]>7M]G)R=]O3R\O/T]/7U\O'P\O+R\O/R\_/R
M]/3S\?'Q\O+Q\O+Q\O+Q\O+R\_+S]?/T\O'R\O'P\_+Q\O/T]/7U]/7U\/'R
M]//T\_+Q\O'Q\?'P\_3S\?'Q\O/R]/3S\O+R\_/S]/3S\/'P\O/R\_/R\_/Q
M\O+Q\?+S]?;T]/+R\O'P\_3T\?+S\?+RW-K;;&QM:&=H:&=G9V=H9V=G9V=H
M:6AH9V9F9F=G:&=I9V=I>GI[[>SM______[__OW______?S[__[]________
M_?W]________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________________O?__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________S\^O[]__[^_OS]_?K]_?W]^;Z]OV=H:6=G
M9VAH:6=G:&9F9F=G9V=G:&=G9V9G9V=G9V=H:(^/D?3S]//S\_+S]?+Q\/+S
M\_+S]/+S]/+S\O+R\?+S\O'R\_+S]//R\_+S\_+S]/3S]//R\?3T\_+S]/3S
M]?;T\?7S\O;T\_/R\?'P\?+R\?+R\O3S\O+S\O+R\?+R\?+R\O/S\O+R\?'Q
M\?+R\O/R\:6EIWI[>WI[>YR<G^3CY/+S]//S\_+S]/+S]/;T\_/R\?;T\_+S
M]/+S]/+S\_+S\O/S\O+R\O+S\O'Q\?3T\_+R\O#Q\/+R\O/T]/+S]/'R\_7T
M]?+Q\O/R\_/T\_'Q\O/R[]'0T6QM;6AG:6AG96=G:&=G9V=G9V=G:&=G:&9G
M9VEG:&=G9WEY>^[M[O[\_?W\_?[^_____O_^_?____[]________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________S[_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________OW^_?_^_?S]_?W__O_\_?W]_?O___^UM;=F9VAF9V=G9VAG9V=H
M9V=H9VAG9V=G9V=G9V=F9F9G:&B/D)+R\O/T\O'R\O'R\O+S\_+P\?#T]?7S
M]/7S]/3R\O'R\_+U]/7R\_+S\_+U]/7R\/#R\O'R\_3S\_7R\O'R\_3Q\O7T
M\O'U]/;R\O+R\_3S\_3T]//R\O+T]//S]//R\_+Q\?'S\_+Q\?"+BXQA8F-@
M86!B8E]@85]S=';T\_#T]??T\_3U]/7Q\?'R\_3R\_3S\O/S\O/R\O/R\O+R
M\O+R\_+R\O'R\O'R\O+Q\?'T]//R\_+O\/'T]?7R\O+U]/7R\?/U]/7R\O+R
M\O'R\_/T\_#/SM!K;&QH9VAH9VAH:&AG9V=H9V=G9VAG9F9F9F5H9V=G9VAZ
M>GWN[>G^_/S]_/W____]_/O_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________^]________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________/_____]
M_________O[]_____O[__/______M+.S9VAH9V9F:&=G:&=G:&=I9V=H:&AI
M:&=H9VAH9V=G9F=GD)"2]O/R\O/T]/3S\O/R\_3S\O/S\_3T]/7U\O+R\O+Q
M]//T\_3S\O+R\_+S]?3U\O+Q\O/R\O/R\_3T\O/T]?3R]//P]?7V\O/R]/3S
M]//T\O/R\O+Q\O/R\O+R\O/R\O+Q\/#PS,W086%?8&%A8F%B86%A86%@7V!A
MKJZP]/+R\_+S\O'S\O/T\O/R\O/R]/+Q\O'P]//R\O/R\_/S\O+R\_/R\O+Q
M\?'P\_/R\O/R]//T\O+R\O/R\_/Q\_+Q]?3U\?+S\O+R]//T]/3S\?/R\_3S
MS\W/;6UN9V9E:6AI9V=H9V=G:&=G:&AH9V=H9V=G9V9G:&AG>'I___WY_OW_
M_?S^_________?W^_?S[________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________//______________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________[]_[.TMV9G:&9F9F9F9F=H:&=F:&AG:&=F:&AG:&AG9VAH
M:&=G9YB7F?/R\_+S]/3U]?/S\O3S\O7T\O3S\O+R\?'S\O+R\O+R\O+S\O+R
M\O+R\O+R\O+R\O+R\O+S\O+S\O+R\?+S\O+R\O+S\O+R\O+R\?+R\O+R\O+S
M]/+S]/3T]?+R\O+R\+_!Q&%A86!A86%B8&%A7V%A8F%A89R;F_3S]/+S\O+S
M\O/S\O+R\?+R\O+S\O+S\O+R\?+R\O+R\O/S\O+R\?+S\O+R\?+R\O+R\O+R
M\O+S\O+R\O+S\O+R\O+R\O+R\?+S\O'S\O+S\_7T]?3S]/3T]<[.SFUN;FAH
M:&AG:&=F:&=G9V=H:&=G:&=G:&9G9V=G96AH9I"0E?[^_/S_____________
M__[]________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________S[_
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________________________________________^
M_OS___^UM+9F:&=H:&AG9F=G9V=F9F9H9VAH9V=G9V=G9F=H9V=G9VBSL[/T
M\_3R\O+P\?#S]/7T\_3P[_'T\_3R\O'R\O+R\_+R\_+R\_+R\O+R\O+R\_+R
M\_+R\_+R\O+S\_+R\O'R\O'R\_+R\_+R\_+R\_+R\O+R\_3R\_3P\?+T]//P
M\/#!PL5@86%@8&!@86%B8F%A85]A86&DI*3R\_3R\O+R\O+R\O'R\O+R\_+R
M\O+R\O'R\_+R\O+R\O'S\_+S\_+S\_+S\_+R\O+R\_+R\_+R\O+R\O'R\_+R
M\_+R\O+R\_+R\_+T\O'U]/+R\?#T]?7Q\?#T\_&QL+5I:&9G9VAG9FAG9V=G
M9V=F9V=H9V=H9VAG9VAG9VAG:&B8FIW]_?W^_?_\_?W____]_?W_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________^]________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________?W[____________M+2V
M9V=H9V=H9VAF9V=G9V=H9V=G9F=G9VAH9V9H:&=G9V=HL;&S]?3U\O/U\/'P
M]/3S]?3U\._Q]//R\O+Q\O+Q\O/R\O+Q\O/R\O/R\O+Q\O+Q\O/R\O+R\O+Q
M\O/R\O+Q\O+Q\O+R\O+Q\O/R\O+Q\O/T\O/S\O/S\?'Q\?'Q\O/R<W-T86)A
M8&!@86%B86%A969GY>3C\?+U\O+Q\O/R\O/R\O+Q\O/R\O+R\O+R\O/R\O+Q
M\_/R\O+Q\O+Q\O+Q\O/R\O+R\O+Q\O+Q\O/R\O/R\O+R\O+Q\O+R\O/R\O+R
M]?3U\O'S]/3S\?'Q\O+RS\W/;6UN:&=H9V=G9V=G9V=H:&AI:&=H:&AG:&AH
M9V=H9V=G:VQMT]/2_____?W]____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________/?______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________[]__W]_?S______[2SMF=H:&9G9V=G
M9V=G:&=G:&=G9V=G9V=G:&AG9VAG9V9G:+&PLO/R\_+R\?+R\/3T\_3S]/7T
M\O+R\O+S\O+R\O+R\O+R\O+R\O+R\?+R\?+S\O+R\O+R\?+R\?+R\O+R\O+S
M\O+R\O+S]//T]?'Q\/3T\_+S\O+S\_3U]?+S\^3CXWM\?&)B8F!A8'-T=<_/
MS^_O[_+S\_+R\?+R\O+R\?+S\O+R\O+R\O+S\O+S\O+R\?+R\O+R\?+S\O+S
M\O+R\O+R\?+R\O+R\O+R\O+S\O+R\O+R\O+S\O+S\O+R\?+Q\_/S\_#Q\O3S
M\M#/T6ML;&=G96AG9VAH:&=G9VAH:6=G:&=F:&=G:&AG9VAH:&ML;M32U/__
M__W]_?____[^_O______________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________[W_____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________Z^OW^_O_____^_O[___^TL[5G9VAH:&AH9V=F9F=G9VAG
M9V=G9F=H9VEH9V=G9VAH:&FSLK3R\?/R\O'Q\?'S]/7S\O'R\_+R\_+R\O+R
M\_+R\_+R\O+R\O+R\O+R\_+R\O+S\_+R\_+R\O+R\O+R\_+R\O'Q\O/R\_3Q
M\?'P\?#R\O'S]/3R\_3R\_3T]//S\O/V\_+V\_3T\O/Q\O#S]/3T\_+R\O+R
M\_+R\_+R\O+R\O+R\O+R\O+R\O+R\O+R\O+R\O'R\_+R\O+R\_+R\O+R\O+S
M\_+R\O+R\O+R\_+R\_+R\O+R\O+R\_+S\_'R\_+T\_*ZN;YM;6YH9V=G9F=H
M9V=G9V=G9V=H9VAG9F=H:&AF9F5G9VAZ>GW@W^#^_?W________]_/W_____
M_OW\^_W_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________^^
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_OW_^_O\________^OW^____F9B<9VAH9V=G:&=H9V=H9F9F9V9F:&=H9V=G
M9V=G:6AH969GM+.U\_+S\O/U\?'P\O+Q\O+R\O+Q\O+R\O/R\O/R\O+R\O/R
M\O+Q\O/R\O/R\O+Q\O+Q\O+Q\O+R\O/R\O+Q]/7U[_#Q]/3S\O+Q\O+Q\O/T
M\O/T\O/T\/'S\_3T]?3U\?'O\O/R\_3T\?'O\_+Q\O+R\O/R\O+R\O+R\O+Q
M\O+Q\O+Q\O/R\O/R\_/R\O+Q\O+Q\O/R\O+R\O+R\O/R\O+R\O+Q\O/R\O+Q
M\O+R\O+R\O/R\O/R\?+S\O'PL;&V:&AH9V9F:&AH:&AH9V=H9V=H:&=G:&=G
M:&=H9F=E9VAF>GI][NSM__[____]_/[]_/_______?W]_OW__OW_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________O?______________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________W\^_________[^
M_OW\_?_]^O___Y"1E6=G:&=F9FAG:&9F9VAH:&=F9VAH:&AG96=G:6EH:&=H
M:+&PLO7T]?+S\O3U]?+R\O+R\O+R\O+R\O+R\?+R\O+S\O+R\O+R\O+R\?+S
M\O+S\O+R\O+R\O+R\O+R\O+R\?/S\O/T]/3U]?3T]?+R\O/S\_+R\O+R\?+S
M]/#Q\/3T\_/T]/+S\_+S]/3S]/+S\O+R\?+S\O+S\O+R\O+S\O+S\O+S\O+R
M\O+S\O+R\O+R\O+R\O+R\O+R\?+S\O+R\O+R\O+R\O+R\O+R\O+R\?+R\?+R
M\?3S]+*QM6=H:&=F9F=G9V=G9V9G9VAG9V=G:&=F9VAG9VAG9V9F9WI[?NOJ
MZ/[]______________W]_?W^_/____[^__[]________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________[[_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________\_/W________________\_?_\____
M__Z0D)-G9V=H:&AG9V=G9VAH9VAG9FAG9VAG9V5H9V=G9F=F9VBRL;/S\O3R
M\_3R\_+R\_+R\O'R\O+R\O+R\_+R\O'R\O'R\_+R\O+R\O+R\O+R\_+R\O+R
M\_+R\O+S]//R\O+R\_3T]?7R\_3Q\?'R\_+R\O+S\O'U]/7S\O3T\_3S\O3T
M\_3R\O+R\O'R\O+R\O+R\O'R\_+S\_+R\O+R\O'R\_+R\_+R\_+R\_+R\_+R
M\O+R\O'R\O+R\_+R\O+R\_+R\_+R\O+R\_+R\O+R\O+R\O*RLK1G:&AH9V9H
M9V9G9VAF9VAG9VAH9V=G:&9G9FAG9F=I:&AZ>GWO[.[^_O_[_OW___W^_O__
M__________________W_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________^]____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________OW____^CY"29V=I
M:&=H9V=H9V=H9V=G9V9H9V9G9V=G:&=G9V=G9V=GO;NZ\_/T]?3U]//T\O+R
M\O+R\O+Q\O/T]//R]O3S]/'R\O/R\O/T\O+P\_+S\_+S\O+R]O3S\_3T\O+R
M\O/T]//R]//R]/3R\O/U\_+Q\O/R\O+R\O/R\O/R\O/R\O/R\O+Q\O+R\O+Q
M\O+R\O/R\O+R\O/R\O/R\O/R\O/R\O+Q\O+R\O+R\O+R\O+R\O+R\_/R\O+R
M\O+R\O/T\O'R]/+Q\O/T\O/S]/+QL;&T9V=H9F=G9F=G9VAH:&=G:&=H9V=H
M9F=G9V=G:&=H9V9H>GI[[>SL_/__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
MO?__________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________________^_?___Y"0DFAI:6=F9VEH:&9G
M9V=G9VAG:&AG9V=G9V=G:&AH:&IK;=#.S?+S]/'Q\?+S\_+S]/3S]/3R\?+Q
M]/3S\O7T]?+R\?'R\_3R\>3BXJZNL)N;G<S+S?7T[_3S]/+S]/3R\?3R\O3T
M\_'R\_3S\O+R\?+R\O+R\?+R\O+R\?+R\?+S\O+R\?+R\O+S\O+R\?+R\?+S
M\O/S\O+R\?+R\O+R\O+R\O+S\O+R\?+R\?+S\O+R\O+R\O/T]//S]//R\_/R
M\_#Q\/+R\;*QM69G9V=G9V=G:6=F9VAG9VAH:&AH:&=F9FAG:&AG9V9F97I[
M?.[L[O_^_?W]_?_______?______________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________SW_____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________OW^_O_[^_S___^0D9)I:&AG9VAF9V=F9F=G9VAH:&AG
M9V=G9F=G9VAH:&AL;&W.SL[V]?+R\_7S\O3U\_+S\O/S\O'R\_/R\_3S\^_T
M]?7-R\MF9VE@86%?8&)@86%Z>WWU\_/S\O/U]/7S\O'Q\O/T]//R\?#R\O+R
M\_+R\_+R\O+R\O+R\_+R\_+R\O+R\O+R\O'S\_+R\O'S\_+R\O'R\O'R\O+R
M\_+R\O+R\_+R\O+R\_+R\O'R\O+R\O+R\_/R\_3S\O/T]//Q\?&QL;-G:&AH
M9V=G9V=G9VAH9VEG9VAG9V=G9V=H9V=G9V=H:&EZ>WSM[.W__OW^_O_]_?W\
M_/W__OW_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________\[____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M^_O\________________CX^1:&AI9V=H9F=G:&=H9V9G:&AH9V=G:&=H9V9F
M:&AH;&UMSLW/\_'Q]/7U]/+Q]?/R\_+T\O+R\O+R\O+R]//T>WM]86%A8&%?
M8&%A86%@8&%AI*2G]//T\O'R\O+R\/'R\O/R\_+T\_/R\O/R\O/R\O/R\O+R
M\O/R\O+Q\O/R\O+R\O/R\O/R\O+R\O+R\O+R\O+R\O+R\O+Q\O/R\O+R\O/R
M\O+R\O/R\O+R\O+R]/+R\O+R]/3S\O'PL[*T9V=H9F9G9F=G9V=H:&=G9V=H
M:&=I:&=G:&AH9V=H9V=G>7I\[.SN^_[]^?S]_____/O________]________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________/?__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________?W\_?KZ_?__
M__W]_?W]_8^/D6=H:&=G9VAG9V=F:&9G9V=G9V=F:&=G:&AG9V=G9VQL;='0
MTO'P[O3U]?/R]//T]//S\O/T]/3U]?3S\F!A86)A8F%A7V%A86!A86)B8'M\
M?/+Q\O/R]/3T\_+R\?/Q\//R]//S\O+S\O+R\O+R\O+R\?+R\O+S\O+R\?/S
M\O+R\O+S\O+S\O+S\O+R\O+S\O+S\O+S\O+S\O+R\O+R\O+R\O+S\O+S\O+R
M\?+Q\O+R\O+Q\)B8FF9F9VAG:6AG:&=G:&=G9VEH:&AG9VAH:&=G:&=F9F=G
M:)"0E/___?[]_/[]_____?_^_?W]_?______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_SS_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________]_/O____\_/W________Y_/W___]Z
M>GUG9V=G9F9I:&AG9VAF9F9H:&AH9VAF9F9I:&AG9VAK;&S1T-+R\?'R\_7R
M\_3R\O'U]/7T\O+T\_)@85]A86!A85]@86%A85]B86%Z>WOU]/7P\?+S\?#R
M\_+T\_+S\O3R\_+R\O'S\_+R\O'R\O+R\O+R\O+R\O+R\O'R\O'R\O+S\_+R
M\O'R\O'R\O+R\_+R\_+R\O+R\O'R\O'R\O+R\O+R\O+R\_+R\_/S\O./CY)G
M9F=G9VAG9V=H:&=H:&AH9VAI:&AG9V=G:&AG9F9G9V>0D)3^_/O[_?_____^
M_?S\_/W\_?W]_/O^_?__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________\^____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________O[______/S]_?W]_/___?W[[>OK>7E]9VAH9F9F
M:&=H9VAH9V=H9V9G9V=G9V=H:6EI:&=H;&QLSLW/]?3Q\?'Q]?/T]//P[_#Q
M]?/R?'Q\86%A8&!@86%@86%?86%AI:6F[^_O\?+S]//T]O3S\O/T\O'P\O/R
M\O/R\O/R\O+Q\O/R\O+Q\O+Q\O+R\O+Q\O+Q\O/R\O/R\O+R\O+Q\O/R\O+Q
M\O+Q\O/R\_/R\O+R\O+Q\O+Q\O/R\O/R]//RD)"1:&=H9V9G9V=H9F=G9V=G
M9V=G9V=H9V9F:&=G9V=H9V=HD)&4__[]_OW__/_______OW]_____?W]__[_
M_OW\________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________/?__________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__[^______[\_?W]_?____[^_O____S__^[LZWIZ?6=G9V=G9V=G9VAG:&=G
M:&AG:&9H9V=G:&EH:&AG9VQM;L[.SO+S]/7T]?'P\O/S\_+Q\\W,SVQM;F%A
M86%A7V!@87Q[?/?T]?+R\O'R]//R\_3S]/+S]/+S\O+R\O+S\O+R\?+S\O+R
M\O/S\O+S\O+R\O+R\?+R\O/S\O+R\O+R\O+R\?+S\O+R\O+R\O+R\O+R\O+R
M\?+R\O+S\O+R\?+S\I&1DF=H:&AG9V=G9VAH:6=H:&AG9VAG:&=G9VAG:&AG
M9V=G9Y"0E/W\^_[^__K]_?_^_?___?_^_?_________^_?____W\_?______
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________SW_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________\___LZ^UZ>WUG9V=G9V=F9VAF9VAH9V=I:&EH:&=G
M9V=H9V=H9V=L;&[:V-?R\_7Q\?'R\_3R\_3R\_+FY>2OK[*;FY_.S,SR\_+R
M\O'R\O'R\O'R\O'R\O+R\O+S\_+R\O'R\O+R\O+R\_+R\_+R\_+R\O+R\O+R
M\O'R\O'R\O'R\O'R\_+R\_+R\O+R\_+R\O'R\O+S\O/R\O+Q\?#R\?+U\O&/
MCY)F9F9H:&EG9VAH9V=H9V=G9VAF9V=G:&AG9V=G9V=G9V>0D)+]_?W\___\
M_O[\_/W_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__^\________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________][^SO>GI[9V=H9V=H:&=G9F=G9V=G:&=G:&=G:&=H9V9G9V=G
M>'AZYN3D\_3T\O/R\O+Q]?3U]?/R]?/Q]/+Q]O7R\O+Q\O+Q\O+R\O+Q\O/R
M\O/R\O/R\O/R\O+R\O+R\O+R\O/R\O/R\_/R\O+R\_/R\O+Q\O+Q\O+Q\O+R
M\O/R\O/R\O/R\O+R]/3S]//U\_+T\_+Q\O/R\O+QCX^2:&=H:&AI9V=H:&=H
M9V=G:&AH9V=G:&=G9V9G9V=G9V=GD(^4_OW]___]_____?W]____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________//__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________[^__W]
M^^[M\7EZ>V=G:&=G:&AG9VAG9F9G9V=G:&9G9VAH:6=G9V=H:'AY>^;EY?3S
M\O'R]//R\_'P\O/R]//Q\/+S\_/S\O+S\O+R\?+R\O+R\O+R\?+R\?+R\?+R
M\O+R\?+R\O+R\?+S\O+R\O+R\O+S\O+R\O+R\O/T\_/T\_+S\O+R\O+R\O+R
M\O+R\O'R\O/R\_+S\O'P\8^/D6AH:&AG9VAG:&AG:&=G:&=F9V=G96=H:&=F
M:&AG9VAG:)"0E/____K]_?____[]_?[]__W]^_______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________S[_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________________]_/W____\_______N[.]Z>WUG
M9V=H9VAG9FAG9FAH:&EF9V=G9F5G9F=G9FAG9V=X>7OGY>7R\O'P\?+T\_3Q
M\/+T\_3T]?7R\O'R\O+R\_+R\O+S\_+R\O+R\O+R\O'R\O+R\O+R\O+R\O+R
M\O'R\_+R\O+R\_+R\O'R\O+S]//R\_+R\_+R\_+R\O+T]//S\O'S]//R\O+R
M\?*0D)%G:&AG9VAG9V=G9V=H9V=G9VAH9VAH9V=G9VAG:&AG9V>9F)S____Z
M_?W\_OW^_O[]_/_]_?[\________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________\]________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________/S]____[NWO>7E[9V=G:&=H:6AH
M:&=G9V=H9V=G9V=G:&AI9V=H9V9G>'AZY>3E\O+R\O/T\O/R]//T]//R\O+R
M\O+Q\O+Q\O/R\O+R\O/R\O/R\O/R\O/R\_/R\O+R\O+R\_/R\O+R\O/R\O+R
M\O/R\O+R\O+R\_/R\?'P\O+R\O/R\O/R\O/S\/#PY^;F>'EZ:&AH:&=H9V9G
M9V=G:&=G:&AH9F=E9V=G:6AJ:&=G9F=FMK:W_____OW\_______^_O[_____
M_OW__/______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____OO______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______[]_/________[]__W^_/[^_N'?XFQM;F=G96AG9V=G:&AG:&=H:&AH
M9F=H9F=G:&AG:&=G:7EZ>N?FYO#Q\/3T]?/Q\?3R\O+S\O+R\O+R\?+S\O+R
M\?+R\?+R\O+R\?+S\O+S\O/S\O+S\O+S\O+R\?+R\O+R\O+S\O+R\O+R\?+S
M\O+R\O+S\O+R\O3T\_+S].?EZ'EY>6AH:&AG:&=G9V=H:&AG9V=G:&=G9V=G
M9V=F9V=G9V9G9[:UMOW]_?S______?W]^_W[_____?__________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________SS_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________OW\_?W_
M_______^_?_____^_?S3T]1L;6UF9FAG9FAG9F9G:&AG:&AG:&9G9V=H:&EH
M:&9H:&EX>7KGYN?S]//Q\?'T\_3R\_+R\_+R\O'R\O'R\O+R\O+R\_+R\O+R
M\O+R\O+R\O'R\_+R\_+R\_+S\_+R\O+S\_+R\O+R\_+R\O'R\O+R\O+T]//O
M\._EY>5X>7EG9VAH:&EG9V=F9V=G9V5H:&EG9V=G9V=G9F=F9VAE9V:UM;7[
M^_S____Z_/W^_?W__O_____^_?__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________^^________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________O[__/W]_________OW_
M_____/__U-+4;&UO9V=F9V=H9V9G9F=G9V=G:&=G9F=G:&=G:&=E9V9H>7E\
MYN7F\?+T\O+R\_/R\O+Q\O+R\O+R\_/R\O+R\O+R\O+R\O/R\O+R\O+R\O+R
M\O+R\_/R\_/R\O+R\O+R\O+Q\O+R\_/R\O/R\_/S[_#OY>;F>'EZ9V=H:&=G
M9F9G9V=G9F=G9V=G9V9G9V=G:&=H:&=G9F=GMK6W_?W^_________?S]____
M___]_____OW__________O[^____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________/?______________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________S__]32
MU&QL;F=G9VAG9VAG9V9F9FAG9VAG9V=F9FAG9VAG9VAG9GI[??7T]?3U]?3R
M\O3R\?/R\_+S\_+S\_+R\O3T]?3S]/+S\O3T\_+S\O/S\O+S\O+S\O+S\O+R
M\O#Q\/3S]//R]/3S\O+S\O+S].?EY7IY>V=G9F=G:&=G:&AH:&=G9VEH:6=G
M:&=G:&AG9V=G9F9H:+2TMO____S____^_?[\_?______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____[S_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________________]_?W]^_C4T]=M;6YH9V=G
M9VAH:&IH9V5H9V=G9V=G9V=G9VAH:&AG9V>0D)+T\_+S]/3R\_3R\_+T\_3S
M\O/S\O/R\_+S]/7S]//Q\?'S\_+R\O+T]//R\O'R\_+R\O+R\O'R\_3T\_3R
M\_+T\_+FY>9X>7QG9VAH9VAG9F=G9V=G9F9G9V=F9V=H9V=G9VAI:&9G9VBU
MM+?________]_?W______OW_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________\^________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________OW____^T]+4;6UN9V=H:&=G:&=G9F=G
M9V=G9VAH9V=G:&=G9V=G9V=GCX^3\O'P\_/R\?+S]?3R\O'R]?3S\_+S\O+Q
M\/'Q\O+R]/3S\?'Q\O+R\_/R\O/R\O+R\O+R\_+Q]/3S\_/TY>3E>7I[9F9H
M:&=G:&=I9V=G9V=H9V=G9V=E9F=G:&=H9V=G9V=HM;2W_OW]_OW______/W]
M_____/W]____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________/?______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________[]__________[^_-/3UVQM;6AH:&AG:&=G:&=G9V=G:&=G9V=G
M:&=F9V=G9VAG:(^/DO7S\?+S]/'R]?;U\O+Q\_3R\_/T]/+R\O+S\O'Q\?+R
M\?3T\_/S\O+R\O+R\O+S]/+S\O3R\MG9VGMZ?&9F9VEH9FAG9VAH:&=G9V9F
M9F9G:&=F9VAG9F9G:&UM;[^^O_____S[_?___?GY^O[^__W]_?__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________[K_____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________________________________\____
M_______\___]_?W5T]5M;6]G9V=G9F9H:&AH:&9G9F=F9FAG9V=G9V9H:&=H
M9VF/CY+U]/+Q\?#Q\O7U]//T\_3R\_3R\_+R\_+R\O+S]//Q\?'S]//R\O'T
M]//R\_3T\_3/S]!L;6UG9VAI:&AF9V=G9V=H9V=F9V=G9V5G9VAH9VAH9VEL
M;6W2TM3________________\_O[Z_?W^_O__________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______^]____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________________________________]_O[]_/W]_?S]
M_?S]O[[`9F=G:6AF9V9G:&=E:&AH9F=G9F9E9VAH9V=G:6=H9V=HD)"1]?3R
M\O/T\?'R\O+R]//T\O+R\O+R\O/R\O/R\O+R\O+Q\?'Q]/3S\_/TSL[0;6UN
M9V=H:&=G9V9F:&=H9VAH:6AI9F9F9V=H9V=E:&=I;6UOTM'5___]_/______
M____^OK]_/__^OS[____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________/O______
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________________^_?W]_?S\_________[6TMF=H
M:&=G:6=G:&AH9F9G9V9F9F=G9VAG9VAG:&EH9F=G:(^/D?7S\?/S\O+S]//R
M\?+R\?+R\O+R\O+R\O+S\O'Q\?3T\_#Q\,_.T&QL;6=G9VIH:&9F9VAH:&=G
M9VAG:&9G9VAG9VAG:&9F:&QM;=+1U?[^__W]_?W]^_____________[^____
M___^_?_^____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________SW_____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________OW^_O_\_/_\_OW__OW^_?_____\__^VM;9F9V=H9V=G9VAF
M9V=G9V=H9V=G9V=G9V9G9VAI9VAH9VB/CY+S\?'R\_3T\_+R\O'R\_+R\O+Q
M\?'T]//S]//P\?#-SM%M;6YG:&AH:&AH9VAG9VAF9V=H:&9H9V=G:&AG9VAG
M9V=L;6[3T]7__OW]_?W___________W\_______________^_?_Y_/W_____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________^\____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________/__M+2V9V=H9V=H9V=G:&=G9V9G9V=H
M9V=H:6AH9V9G9V=G9F9GD(^2]/+R\//U]?3U\O+Q]/3S\O'R\?+S]/3ST,[.
M;&QN9F=G:&=H:&=G:&AF9V=H9V=H9VAH9V=G:&=G:&=E:VUPTM+4_OW____]
M^_SZ_OW_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________OO__________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________[]_?___K2SN&=G9VAG9VAG9V=G9F=F9FAG9V=G:&=G:&AG
M:&AG9V=H:+*QLO/Q\/'Q\?/T]O#Q\/+S]/+Q\,_.SFML;F=G9VAG:6AH:&=G
M9V=F9V=G9V=G:&=G9V=G9V9G96UM<=32U/_^_?W]_?W]_?______________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________[[_____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_OW\_/___OVUM+=G9VAH9VEG9V9H:&AF9F9G9V=F9V=E9F=G9V=G9V9G9VBS
MLK3U]/7R\?'S\O/Q\/+0SLYM;6UG9V=G9V=H9V=G9V=H9VAG:&AG9V=G9V=G
M9VAH9V9L;7#4TM3]_/_]_?W___W]_?W____]_?O_____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________^\____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________________/W]_?W]
MM+2W9F=G:&=H:&=G:&AH9V=G9V=E9F9F:&=I:&=G:6AF9F9HM+.U\O'R]//T
MO;N^;&QL9V=G9F=G:&=G:&=E9V=H:&AI9F9F9V9G:&AF9VAH>GE]WM[?__[]
M_____O[^_/W]_?W]_/S]_?W]____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________O?__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________S___[]_/___________[2TM6=G:&=G
M9VAG9V=F9VAH:&=G9V9G9V=G:&AH:&AH:&9F9[.RM+.RM69F9FEH:&=G9VAH
M:69F9F=G:&=G9V9G9VAG:&EH9V=F9WIZ>^SL[O[^_________?________W]
M_O__________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________[W_________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________^_O[^_O_____\_/W____\_/V9FIUG9V=H9V=H9VAH9VAH
M:&AH:&AG9VAG9V=H9V=H:&AF9V=F9F9G:&AG:&AG9VAG9V=G9VAH9VAG:&AG
M:&AH9V5G9F=[>WON[.[^_O[\_O[]_?W____]_?W____________\_/K_____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________\^____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____?W]_?W]_____OW___[]____D)"39V=H:&AI:&=H9V9G9V=G:&AH9V=H
M9V9G9F=G:6AF9V9F:&AH9V=G9V=H:&=H:&=E9V=H9V=G:&=H9V=H>GI[[NSN
M_/S]_OW__/SZ_____?W]_____________O[^________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________OO__________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________________________________^_?___?S_
M__O\__[^_____?O^_Y&1DV=G9VAG96=G:&=F9V=G9V=G:&=G9V=G:&=G:&AG
M9VEG:&=G:&=H9F=G96AG:6=G9V=G9VAG97EY?.SK[?[^_O[^___^_?_^____
M___^_?_________^_?____[^____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________S[_________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___\__^0D)-H:&AH9V=G9VAF9V=I:&AH9VEH9VAG9F=G9F9G9V5H9VAF9VAH
M:&AF9V=H9V=G:&AY>7SM[.W]_/W__OW___W__O______________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________\^________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________?W[____CX^2
M9F=G:&=G9V=H9F9G:6AF:&=H9V=G9F9G9V=H:&=G:&=G9V9G:6AH9F9F>7I^
M\.WO_?W]_?W]_OW____]________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________________OO__
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________[^_Y"/DF9G9VEG:&=G
M:&AG9FAG9V9G9V9G9V=G:&=F9FEH:6=F:&AG9GE[?>_M[OS\_?_^___^_?W]
M^_[^_____?__________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________S[_________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________WZ^_O_______^1D9-G9V=I9V=F9V=H9V9F9VAG
M9VAG9V=G9V=H9V=G9VF0D)+___W\_?W^_?_____^_OS^_O______________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________^]________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________O[^_/__________DI&39V=H:&=H:&=G:&=G9V9F:&=G9V=G9V=G
MCX^2____^_W______?W[_?S[_____OW_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________/O______________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________[^__S___W]
M_?S_______S\_7I[?FAG9V9G9VAH:&=G:&AG9V=H:(Z/D?W\^_S___S___S_
M___^_?W]_?W\_?O[_/[^_____?__________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________________SS_
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________O_______OW\_?W\___]_?WK
MZNQZ>WYG:&AG9F=H9VEG9VF0D)/]_/O__O_________]_OS__O_________^
M_?___OW_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________^^________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________/_____]__[]_____?S]_/S____]Z^SO>GI[:&=G
M:&=FCX^2__[]_/____________[_______[]__________[]______[_____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________O/______________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________^_L[GE[?(^1DO[]_/[^____
M_O__________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________S[_____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_______________________]_/____W__OW^_?_]_?W]_?[\^_W__OW_____
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________________^^
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________O[__?S^_/S]__[]_________/SZ____________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________O?______________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________________[\^?__
M__S]_?___?KZ^_[]_?_____^____________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________SS_____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___________________________________________[^OO]_?[____]_/W^
M_?W__OW^_O__________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________^\____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________OW__OS_______[]_OW__OW___[]________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M/?__________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________W^_/____S\^O_^_?____[^____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____________________________________________SS_____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M___]_?W____]_?W_____________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________\^____________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________/?__________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_SS_________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M______________________________________________^^____________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________.O__________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________[W_________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__^]________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M________________________________________________/O__________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________S[_________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________^^________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____/?______________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_________________________________________________[[_________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________\^________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________//______________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M_____[[_____________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M__________________________________________________\[________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
M____________________________________________________________
>____________________________________O@``





#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="Resource[]">
    <lst nm="IMAGE[]" />
  </lst>
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
      <str nm="Comment" vl="HSB-24843: Fix to allow insertion at multiple female-male connections" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="10" />
      <str nm="Date" vl="10/30/2025 8:36:50 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19771: Added missing hanger bilot" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="12/12/2024 4:12:21 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19771: Changed Tsl to the requirements of Hilti" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="12/10/2024 11:05:55 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="20241129: Fix when drawing symbol" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="11/29/2024 8:23:42 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19771: Change TSL image" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="10/8/2024 9:50:10 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19771: Fix drilling position (apply Z-offset) for the hanger bolt/Concrete fastener (Stockschraube/Bolzenanker)" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="9/24/2024 10:07:26 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19771: Fix when identifying male and female panel at &quot;distinguishMaleFemaleFrom2Sips&quot;" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="9/20/2024 11:02:25 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19771: Fix when calculating the distribution line of a male-female panel" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="9/13/2024 10:01:03 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19771: Enable insertion of one sigle connector by point" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="8/22/2024 3:02:33 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22250: Initial: Add block display of the connectors" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="6/19/2024 3:41:53 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22250: Initial" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="6/18/2024 11:17:21 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End