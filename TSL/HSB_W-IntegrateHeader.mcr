#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@itwindustry.nl)
20.06.2012  -  version 1.0











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
/// This tsl adjusts the headers above openings 
/// </summary>

/// <insert>
/// Select a set of elements
/// </insert>

/// <remark Lang=en>
/// .
/// </remark>

/// <version  value="1.00" date="20.06.2012"></version>

/// <history>
/// AS - 1.00 - 20.06.2012 - Pilot version
/// </history>

//Script uses mm
double dEps = U(.1,"mm");

PropString sBmCodeHeader(0, "", T("|Beamcode Header|"));

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

//Insert
if( _bOnInsert ){
	//Erase after 1 cycle
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	//Showdialog
	if (_kExecuteKey=="")
		showDialog();	
	
	//Select beam(s) and insertion point
	PrEntity ssE(T("|Select one or more openings|"), OpeningSF());
	if (ssE.go()) {
		Entity arSelectedOpenings[] = ssE.set();

		//insertion point
		String strScriptName = "HSB_W-IntegrateHeader"; // name of the script
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
		
		for( int i=0;i<arSelectedOpenings.length();i++ ){
			OpeningSF opSF = (OpeningSF)arSelectedOpenings[i];
			if( !opSF.bIsValid() ){
				continue;
			}
			lstEntities[0] = opSF;
			
			TslInst tsl;
			tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
		}
	}
	
	return;
}

if( _Map.hasInt("MasterToSatellite") ){
	int bMasterToSatellite = _Map.getInt("MasterToSatellite");
	if( bMasterToSatellite ){
		int bPropertiesSet = _ThisInst.setPropValuesFromCatalog("MasterToSatellite");
		_Map.removeAt("MasterToSatellite", TRUE);
	}
}

//Check if there is a valid opening present
if( _Entity.length() == 0 ){
	eraseInstance();
	return;
}

//Get selected opening
OpeningSF op = (OpeningSF)_Entity[0];
if( !op.bIsValid() ){
	eraseInstance();
	return;
}

Element el = op.element();
if( !el.bIsValid() ){
	eraseInstance();
	return;
}

CoordSys csEl = el.coordSys();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

//All beams
Beam arBm[] = el.beam();
Beam arBmNoHeader[0];
//Find the headers for this opening
Beam arBmHeader[0];
arBmNoHeader.append(arBm);
for( int i=0;i<arBm.length();i++ ){
	Beam bm = arBm[i];
	String sBmCode = bm.name("beamCode").token(0);
	sBmCode = sBmCode.trimLeft();
	sBmCode = sBmCode.trimRight();
	
	if( sBmCode == sBmCodeHeader ){
		arBmHeader.append(bm);
		arBmNoHeader = bm.filterGenBeamsNotThis(arBmNoHeader);
	}
}

//Beam arBmHorizontal[] = vyEl.filterBeamsPerpendicular(arBmNoHeader);
Beam arBmVertical[] = vxEl.filterBeamsPerpendicular(arBmNoHeader);

//Modify header
for( int i=0;i<arBmHeader.length();i++ ){
	Beam bmHeader = arBmHeader[i];
		
	//Apply beamcut
	double dDHeaderZ = bmHeader.dD(vzEl);
	double dDHeaderY = bmHeader.dD(vyEl);
	Point3d ptBmCut = bmHeader.ptCen();
	BeamCut bmCutHeader(ptBmCut, vxEl, vyEl, vzEl, bmHeader.solidLength(), dDHeaderY, dDHeaderZ, 0, 0, 0);
	
	Body bdBmCutHeader = bmCutHeader.cuttingBody();
	for( int j=0;j<arBmVertical.length();j++ ){
		Beam bmVertical = arBmVertical[j];
		if( bmVertical.envelopeBody(false, true).hasIntersection(bdBmCutHeader) )
			bmVertical.addToolStatic(bmCutHeader);
	}
}

eraseInstance();








#End
#BeginThumbnail

#End
