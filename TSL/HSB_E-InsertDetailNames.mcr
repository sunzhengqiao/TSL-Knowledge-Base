#Version 8
#BeginDescription
Last modified by: Anno Sportel (support.nl@hsbcad.com)
24.10.2017  -  version 1.18
















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 18
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl places detail texts at a given position
/// The catalog from this tsl can be set from the DSP parameters. The tsl reads a specific variable.
/// </summary>

/// <insert>
/// Auto: Attach the tsl to element definition
/// Manual: Select elements
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.17" date="17.11.2016"></version>

/// <history>
/// AS - 1.00 - 20.01.2012 -	Pilot version
/// AS - 1.01 - 23.01.2012 -	Erase this tsl after execution
/// AS - 1.02 - 25.01.2012 -	Trim spaces from detailname
/// AS - 1.03 - 30.01.2012 -	Check if tsl is valid
/// AS - 1.04 - 05.03.2012 -	Add support for sem-colon seperated details
/// AS - 1.05 - 25.03.2012 -	Position detail on frame
/// AS - 1.06 - 07.05.2012 -	Reposition detail
/// AS - 1.07 - 14.05.2012 -	Only use beams which are not aligned with detail
/// AS - 1.08 - 21.11.2012 -	Add support for element mirror.
/// AS - 1.09 - 30.08.2013 -	Add offset.
/// AS - 1.10 - 02.10.2013 -	Change name of satelite tsl. TODO: Make the name of the satelite a property.
/// AS - 1.11 - 03.03.2014 -	Check fro point in profile has now a 50 mm margin.
/// AS - 1.12 - 18.03.2014 -	Correct typo in name of detail tsl.
/// AS - 1.13 - 28.03.2014 -	Increase direction check
/// AS - 1.14 - 04.04.2014 -	Direction check nog based on intersect on plane profile.
/// AS - 1.15 - 23.06.2014 -	Insert default detail
/// AS - 1.16 - 19.10.2016 -	Also collect openingRoofs from element groups.
/// AS - 1.17 - 17.11.2016 -	Remove beam with invalid sizes.
/// AS - 1.18 - 24.10.2017 -	Option to specify default detail name.
/// </history>

double dEps = Unit(0.1, "mm");


//PropString sSeperator03(5, "", T("|Detail|"));
//PropString sScriptNameDetailName(6, "HSB_E-DetailName", "     "+T("|Scriptname detail tsl|"));

String sScriptNameDetailName = "HSB_E-DetailName";
String arSCatalogNamesDetailName[] = TslInst().getListOfCatalogNames(sScriptNameDetailName);

PropString sSeperator01(0, "", T("|Roof|/")+T("|Floor|"));
sSeperator01.setReadOnly(true);
PropInt nVarIndex(0, 60, "     "+T("|Variable index|"));
PropString defaultDetailName(5, "", "     "+T("|Default detail name|"));
defaultDetailName.setDescription(T("|Sets the detail name with the specified value, if it can't be found in the list of DSP variables.|"));
PropString sCatEdgeDetails(1, arSCatalogNamesDetailName, "     "+T("|Catalog edge details|"));
PropString sCatOpeningDetails(2, arSCatalogNamesDetailName, "     "+T("|Catalog opening details|"));
PropString sCatSupportingDetails(3, arSCatalogNamesDetailName, "     "+T("|Catalog supporting details|"));

PropString sSeperator02(4, "", T("|Position|"));
sSeperator02.setReadOnly(true);
PropDouble dOffsetDetail(0, U(0), "     "+T("|Offset detail|"));

double dDirectionCheck = U(750);

if( _bOnElementDeleted ){
	eraseInstance();
	return;
}

// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_E-InsertDetailNames");
if( _bOnDbCreated && arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert ){
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	
	int nNrOfTslsInserted = 0;
	//Select beam(s) and insertion point
	PrEntity ssE(T("|Select one or more elements|"), Element());
	if (ssE.go()) {
		Element arSelectedElements[] = ssE.elementSet();
		
		//insertion point
		String strScriptName = "HSB_E-InsertDetailNames"; // name of the script
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		Beam lstBeams[0];
		Entity lstEntities[1];
		
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		Map mapTsl;
		mapTsl.setInt("MasterToSatellite", TRUE);
		setCatalogFromPropValues("MasterToSatellite");
		mapTsl.setInt("ExecuteMode", 1);
		mapTsl.setInt("ManualInsert", true);
		for( int i=0;i<arSelectedElements.length();i++ ){
			Element el = arSelectedElements[i];
			lstEntities[0] = el;
			
			TslInst arTsl[] = el.tslInst();
			for( int j=0;j<arTsl.length();j++ ){
				TslInst tsl = arTsl[j];
				if( !tsl.bIsValid() || tsl.scriptName() == strScriptName )
					tsl.dbErase();
			}
			
			TslInst tsl;
			tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
			nNrOfTslsInserted++;
		}
	}
	
//	reportMessage(nNrOfTslsInserted + T(" |tsl(s) inserted|"));
	
	eraseInstance();
	return;
}
// set properties from master
if( _Map.hasInt("MasterToSatellite") ){
	int bMasterToSatellite = _Map.getInt("MasterToSatellite");
	if( bMasterToSatellite ){
		int bPropertiesSet = _ThisInst.setPropValuesFromCatalog("MasterToSatellite");
		_Map.removeAt("MasterToSatellite", true);
	}
}
int bManualInsert = false;
if( _Map.hasInt("ManualInsert") ){
	bManualInsert = _Map.getInt("ManualInsert");
	_Map.removeAt("ManualInsert", true);
}

if( _Element.length() == 0 ){
	reportMessage(TN("|Invalid selection|!"));
	eraseInstance();
	return;
}

//sScriptNameDetailName.setReadOnly(true);

int bIsWall = false;
int bIsRoof = false;
int bIsFloor = false;

Element el = _Element[0];
ElementRoof elRf = (ElementRoof)el;
ElementWallSF elSf = (ElementWallSF)el;
if( elRf.bIsValid() ){
	if( elRf.bIsAFloor() )
		bIsFloor = true;
	else
		bIsRoof = true;
}
else if( elSf.bIsValid() ){
	bIsWall = true;
}
else{
	reportMessage(TN("|Invalid element type|!"));
	eraseInstance();
	return;
}

TslInst arTsl[] = el.tslInst();
for( int i=0;i<arTsl.length();i++ ){
	TslInst tsl = arTsl[i];
	if( !tsl.bIsValid() || tsl.scriptName() == sScriptNameDetailName )
		tsl.dbErase();
}

CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();
_Pt0 = ptEl - vzEl * el.zone(0).dH();

CoordSys csDetails = csEl;
csDetails.transformBy(vzEl * vzEl.dotProduct(_Pt0 - ptEl));

Plane pnEl(_Pt0, vzEl);
Point3d ptElMid = ptEl - vzEl * 0.5 * el.zone(0).dH();

Vector3d vReadDirection = -vxEl + vyEl;
vReadDirection.normalize();

Display dp(1);
dp.textHeight(U(75));

Beam arBm[] = el.beam();

//insertion point
String strScriptName = sScriptNameDetailName;
Vector3d vecUcsX(1,0,0);
Vector3d vecUcsY(0,1,0);
Beam lstBeams[0];
Entity lstEntities[] = {el};

Point3d lstPoints[1];
int lstPropInt[0];
double lstPropDouble[0];
String lstPropString[0];
Map mapTsl;

if( _bOnDebug || _bOnElementConstructed || bManualInsert ){
	if( bIsFloor || bIsRoof ){
		//Outline
		PlaneProfile ppRf(csDetails);
		ppRf.unionWith(elRf.profBrutto(0));
		ppRf.vis();
		GenBeam arGBm[] = elRf.genBeam();
		for( int i=0;i<arGBm.length();i++ ){
			GenBeam gBm = arGBm[i];
			
			if (gBm.solidLength() * gBm.solidHeight() * gBm.solidWidth() == 0) {
				//reportNotice(TN("|PtCenSolid|: ") + gBm.ptCenSolid());
				gBm.dbErase();
				continue;
			}
			PlaneProfile ppGBm = gBm.envelopeBody().shadowProfile(pnEl);
			ppGBm.shrink(-U(1));
			ppRf.unionWith(ppGBm);
		}
		ppRf.vis(3);
		
		PLine plEl(vzEl);
		PLine arPlRf[] = ppRf.allRings();
		for( int i=0;i<arPlRf.length();i++ ){
			PLine pl = arPlRf[i];
			if( pl.area() > plEl.area() )
				plEl = pl;
		}
		if( plEl.area() == 0 )
			return;
		

		//Edges
		ElemRoofEdge arRfEdge[] = elRf.elemRoofEdges();
		for( int i=0;i<arRfEdge.length();i++ ){
			ElemRoofEdge rfEdge = arRfEdge[i];
			
			String sDetail = rfEdge.constrDetail();
			// stream detail text into map.
			Map mapDetail;
			int bContentSet = mapDetail.setDxContent(sDetail, true);
			
			String sDetailName = defaultDetailName;
			if( bContentSet ){
				if( mapDetail.hasDouble("DVAR"+(nVarIndex - 1)) ){
					double dValue = mapDetail.getDouble("DVAR"+(nVarIndex - 1));
					sDetailName = dValue;
				}
				else if( mapDetail.hasString("STRVAR"+(nVarIndex - 1)) ){
					String sValue = mapDetail.getString("STRVAR"+(nVarIndex - 1));
					sDetailName = sValue;
				}
			}
			else{
				sDetailName = sDetail.token(nVarIndex);
			}
			sDetailName.trimLeft();
			sDetailName.trimRight();
			if( sDetailName == "" )
				continue;
			
			Point3d ptDetail = (rfEdge.ptNode() + rfEdge.ptNodeOther())/2;
			Vector3d vDetail = rfEdge.vecDir();
			Vector3d vNormal = vDetail.crossProduct(vzEl);
			
			LineSeg lnSeg(ptDetail + vNormal * U(10000), ptDetail - vNormal * U(10000));
			LineSeg arLnSeg[] = ppRf.splitSegments(lnSeg, true);
			Point3d arPtLnSeg[0];
			for( int j=0;j<arLnSeg.length();j++ ){
				LineSeg lnSg = arLnSeg[j];
				arPtLnSeg.append(lnSg.ptStart());
				arPtLnSeg.append(lnSg.ptEnd());
			}
			arPtLnSeg = Line(ptDetail, vNormal).orderPoints(arPtLnSeg);
			if( arPtLnSeg.length() > 1 ){
				if( abs(vNormal.dotProduct(arPtLnSeg[arPtLnSeg.length() - 1] - ptDetail)) > abs(vNormal.dotProduct(arPtLnSeg[0] - ptDetail)) ){		
	//			Point3d ptDirectionCheck = ptDetail + vNormal * dDirectionCheck;
	//			if( ppRf.pointInProfile(ptDirectionCheck) == _kPointInProfile ){
					vDetail *= -1;
					vNormal *= -1;
				}
			}
			
			vNormal.vis(ptDetail,1);
			vDetail.vis(ptDetail, 3);
			vzEl.vis(ptDetail, 150);
		
			// find edge of beams
			Beam arBmNotAligned[0];
			for( int j=0;j<arBm.length();j++ ){
				Beam bm = arBm[j];
				if( abs(abs(vNormal.dotProduct(bm.vecX())) - 1) < dEps )
					continue;
				arBmNotAligned.append(bm);
			}
			Beam arBmEdge[] = Beam().filterBeamsHalfLineIntersectSort(arBmNotAligned, ptDetail + vzEl * vzEl.dotProduct(ptElMid - ptDetail), vNormal);
			if( arBmEdge.length() > 0 ){
				Beam bmEdge = arBmEdge[arBmEdge.length() - 1];

				ptDetail.vis(1);
				bmEdge.envelopeBody().vis(1);

				if( abs(abs(vDetail.dotProduct(bmEdge.vecX())) - 1) < dEps  )
					 ptDetail = Line(ptDetail, vNormal).intersect(Plane(bmEdge.ptCen(), vzEl.crossProduct(bmEdge.vecX())), 0);
			}
			
			Vector3d vxTxt = vNormal;
			Vector3d vyTxt = vDetail;
			if( vReadDirection.dotProduct(vyTxt) < 0 ){
				vyTxt *= -1;
				vxTxt *= -1;
			}
			
			ptDetail += vNormal * dOffsetDetail;
			dp.draw(sDetailName, ptDetail, vxTxt, vyTxt, 0 , 0);
			//Insert detail name tsl
			lstPoints[0] = ptDetail;
			mapTsl = Map();
			mapTsl.setPoint3d("Position", ptDetail);
			mapTsl.setPoint3d("Normal", ptDetail + vDetail * U(100));
			mapTsl.setPoint3d("Detail", ptDetail - vNormal * U(100));
					
			TslInst tsl;
			tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
			tsl.setPropValuesFromCatalog(sCatEdgeDetails);
			tsl.setPropString("     "+T("|Name|"), sDetailName);
		}
		
		// Supporting details
		if( bIsRoof ){
			double arDHorizontalDetails[] = {
				elRf.dKneeWallHeight(),
				elRf.dKneeWallHeight2(),
				elRf.dWallPlateHeight(),
				elRf.dWallPlateHeight2(),
				elRf.dStrutHeight(),
				elRf.dStrutHeight2()
			};
			String arSHorizontalDetails[] = {
				elRf.constrDetailKneeWall(),
				elRf.constrDetailKneeWall2(),
				elRf.constrDetailWallPlate(),
				elRf.constrDetailWallPlate2(),
				elRf.constrDetailStrut(),
				elRf.constrDetailStrut2()
			};
			for( int i=0;i<arDHorizontalDetails.length();i++ ){
				double dDetailHeight = arDHorizontalDetails[i];
				String sDetail = arSHorizontalDetails[i];
				String sDetailName = sDetail.token(nVarIndex);
				sDetailName.trimLeft();
				sDetailName.trimRight();	
				if( sDetailName == "" )
					continue;
				
				Plane pnHeight(_PtW + _ZW * dDetailHeight, _ZW);
				int bHasIntersection = pnHeight.hasIntersection(pnEl);
				if( !bHasIntersection )
					continue;
				
				Line lnIntersect = pnHeight.intersect(pnEl);
				lnIntersect.vis();
				plEl.vis(5);
				Point3d arPtDetail[] = plEl.intersectPoints(lnIntersect);
				if( arPtDetail.length() < 2 )
					continue;
				
				Point3d ptDetail = (arPtDetail[0] + arPtDetail[arPtDetail.length() - 1])/2;
				Vector3d vDetail = -vxEl;
				Vector3d vNormal = vyEl;
							
				vNormal.vis(ptDetail,1);
				vDetail.vis(ptDetail, 3);
				vzEl.vis(ptDetail, 150);
				
				Vector3d vxTxt = vNormal;
				Vector3d vyTxt = vDetail;
				if( vReadDirection.dotProduct(vyTxt) < 0 ){
					vyTxt *= -1;
					vxTxt *= -1;
				}
				
				dp.draw(sDetailName, ptDetail, vxTxt, vyTxt, 0 , 0);
				//Insert detail name tsl
				lstPoints[0] = ptDetail;
				mapTsl = Map();
				mapTsl.setPoint3d("Position", ptDetail);
				mapTsl.setPoint3d("Normal", ptDetail + vDetail * U(100));
				mapTsl.setPoint3d("Detail", ptDetail - vNormal * U(100));
						
				TslInst tsl;
				tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
				tsl.setPropValuesFromCatalog(sCatSupportingDetails);
				tsl.setPropString("     "+T("|Name|"), sDetailName);
			}
		}
		
		// Opening details
		Group grpFloor(el.elementGroup().namePart(0), el.elementGroup().namePart(1), "");
		Entity arEntOpRf[] = grpFloor.collectEntities(true, OpeningRoof(), _kModelSpace);
		OpeningRoof arOpRf[0];
		for( int i=0;i<arEntOpRf.length();i++ ){
			OpeningRoof opRf = (OpeningRoof)arEntOpRf[i];
			if( opRf.bIsValid() )
				arOpRf.append(opRf);
		}
		
		for( int i=0;i<arOpRf.length();i++ ){
			OpeningRoof opRf = arOpRf[i];
			PLine plOpRf = opRf.plShape();
			plOpRf.projectPointsToPlane(pnEl, _ZW);
	
			PlaneProfile ppOpRf(CoordSys(_Pt0, vxEl, vyEl, vzEl));
			ppOpRf.joinRing(plOpRf, _kAdd);
	
			PlaneProfile ppTmp = ppOpRf;
			if( !ppTmp.intersectWith(ppRf) )
				continue;
			
			Point3d arPtOpRf[] = ppOpRf.getGripEdgeMidPoints();
			if( arPtOpRf.length() == 0 )
				continue;
			
			ppOpRf.vis(1);
			Point3d ptOpRfCen = Body(plOpRf, vzEl).ptCen();
			for( int j=0;j<arPtOpRf.length();j++ ){
				Point3d pt = arPtOpRf[j];
				pt.vis(5);
				_Pt0.vis(3);
				
				double dx = vxEl.dotProduct(ptOpRfCen - pt);
				double dy = vyEl.dotProduct(ptOpRfCen - pt);
	
				String sDetail;
				Vector3d vDetail;
				Vector3d vNormal;
				if( abs(dx) > abs(dy) ){// vertical
					if( dx > 0 ){// left
						sDetail = opRf.constrDetailLeft();
						vDetail = vyEl;
						vNormal = vxEl;
					}
					else{// right
						sDetail = opRf.constrDetailRight();
						vDetail = -vyEl;
						vNormal = -vxEl;
					}
				}
				else{
					if( dy > 0 ){// bottom
						sDetail = opRf.constrDetailBottom();
						vDetail = -vxEl;
						vNormal = vyEl;
					}
					else{// top
						sDetail = opRf.constrDetailTop();
						vDetail = vxEl;
						vNormal = -vyEl;
					}
				}
				
				String sDetailName = sDetail.token(nVarIndex);
				sDetailName.trimLeft();
				sDetailName.trimRight();			
				if( sDetailName == "" )
					continue;
				
				Point3d ptDetail = pt;
				vNormal.vis(ptDetail,1);
				vDetail.vis(ptDetail, 3);
				vzEl.vis(ptDetail, 150);
				
				Vector3d vxTxt = vNormal;
				Vector3d vyTxt = vDetail;
				if( vReadDirection.dotProduct(vyTxt) < 0 ){
					vyTxt *= -1;
					vxTxt *= -1;
				}
				
				dp.draw(sDetailName, ptDetail, vxTxt, vyTxt, 0 , 0);
				//Insert detail name tsl
				lstPoints[0] = ptDetail;
				mapTsl = Map();
				mapTsl.setPoint3d("Position", ptDetail);
				mapTsl.setPoint3d("Normal", ptDetail + vDetail * U(100));
				mapTsl.setPoint3d("Detail", ptDetail - vNormal * U(100));
						
				TslInst tsl;
				tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
				tsl.setPropValuesFromCatalog(sCatOpeningDetails);
				tsl.setPropString("     "+T("|Name|"), sDetailName);
				tsl.transformBy(_XW*0);
			}
		}
	}
	else if( bIsWall ){
		
	}
		
	eraseInstance();
}














#End
#BeginThumbnail


















#End