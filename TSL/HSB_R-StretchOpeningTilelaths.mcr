#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@itwindustry.nl)
19.09.2012  -  version 1.00

This tsl stretches the tilelath under and over an opening to the closest rafters (left & right).






#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl stretches the tilelath under and over an opening to the closest rafters (left & right).
/// </summary>

/// <insert>
///
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.00" date="19.09.2012"></version>

/// <history>
/// 1.00 - 19.09.2012 - 	Pilot version
/// </hsitory>

U(1,"mm");

PropString sSeperator01(0, "", T("|Tilelath|"));
sSeperator01.setReadOnly(true);
PropString sMaterialToStretch(1, "PANLAT O", "     "+T("|Material of tilelath to stretch|"));

// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_R-StretchOpeningTilelaths");
if( _bOnDbCreated && arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert) {
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
		String strScriptName = "HSB_R-StretchOpeningTilelaths"; // name of the script
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
	
	reportMessage(nNrOfTslsInserted + T(" |tsl(s) inserted|"));
	
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

Element el = _Element[0];

if( _bOnElementConstructed || bManualInsert ){
	if( el.bIsKindOf(ERoofPlane()) ){
		eraseInstance();
		return;
	}
	
	CoordSys csEl = el.coordSys();
	Point3d ptEl = csEl.ptOrg();
	Vector3d vxEl = csEl.vecX();
	Vector3d vyEl = csEl.vecY();
	Vector3d vzEl = csEl.vecZ();
	Line lnX(ptEl, vxEl);
	
	Beam arBm[] = el.beam();
	Beam arBmRafter[0];
	int arNBmTypeRafter[] = {
		_kDakCenterJoist,
		_kDakLeftEdge,
		_kDakRightEdge,
		_kExtraRafter
	};
	for( int i=0;i<arBm.length();i++ ){
		Beam bm = arBm[i];

		if( arNBmTypeRafter.find(bm.type()) != -1 || bm.hsbId() == "4101" )
			arBmRafter.append(bm);
	}
	arBmRafter = vxEl.filterBeamsPerpendicularSort(arBmRafter);
	
	Sheet arShZn05[] = el.sheet(5);
	for( int i=0;i<arShZn05.length();i++ ){
		Sheet shZn05 = arShZn05[i];
		
		if( shZn05.material() != sMaterialToStretch )
			continue;
		
		Point3d arPtSh[] = shZn05.profShape().getGripVertexPoints();
		Point3d arPtShX[] = lnX.orderPoints(arPtSh);
		
		if( arPtShX.length() < 2 )
			continue;
		
		Point3d ptLeft = arPtShX[0] + vzEl * vzEl.dotProduct((ptEl - vzEl * 0.5 * el.zone(0).dH()) - arPtShX[0]);
		Point3d ptRight = arPtShX[arPtShX.length() - 1] + vzEl * vzEl.dotProduct((ptEl - vzEl * 0.5 * el.zone(0).dH()) - arPtShX[arPtShX.length() - 1]);
		
		double dExtraLengthLeft = U(0);
		Beam arBmRafterLeft[] = Beam().filterBeamsHalfLineIntersectSort(arBmRafter, ptLeft, -vxEl);
		if( arBmRafterLeft.length() > 0 ){
			Beam bm = arBmRafterLeft[0];
			dExtraLengthLeft = abs(vxEl.dotProduct(bm.ptCen() - vxEl * 0.5 * bm.dD(vxEl) - ptLeft));
		}
		
		double dExtraLengthRight = U(0);
		Beam arBmRafterRight[] = Beam().filterBeamsHalfLineIntersectSort(arBmRafter, ptRight, vxEl);
		if( arBmRafterRight.length() > 0 ){
			Beam bm = arBmRafterRight[0];
			dExtraLengthRight = abs(vxEl.dotProduct(bm.ptCen() + vxEl * 0.5 * bm.dD(vxEl) - ptRight));			
		}
		
		Point3d ptNewSh = shZn05.ptCen() + vxEl * (dExtraLengthRight - dExtraLengthLeft)/2;
		
		Sheet shNew;
		shNew.dbCreate(ptNewSh, shZn05.vecX(), shZn05.vecY(), shZn05.vecZ(), shZn05.solidLength(), shZn05.solidWidth() + dExtraLengthRight + dExtraLengthLeft, shZn05.solidHeight());
		shNew.assignToElementGroup(el, true, 5, 'Z');
		shNew.setColor(3);
		shNew.setMaterial("PANLAT");
		
		shZn05.dbErase();
	}
	
	
	eraseInstance();
	return;
}

#End
#BeginThumbnail
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
1G^\,$=.A'(Z#I6C30:!,_]D`
`

#End
