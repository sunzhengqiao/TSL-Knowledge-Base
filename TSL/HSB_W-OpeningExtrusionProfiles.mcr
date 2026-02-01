#Version 8
#BeginDescription

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


if( _bOnInsert ){
	_Entity.append(getOpening(T("|Select an opening|")));
	
	_Map.setInt("ManualInsert", true);
	
	return;
}

if( _Entity.length() == 0 ){
	reportWarning(T("|No opening selected|!"));
	eraseInstance();
	return;
}

int bManualInsert = false;
if( _Map.hasInt("ManualInsert") )
	bManualInsert =  _Map.getInt("ManualInsert");

OpeningSF opSf = (OpeningSF)_Entity[0];
if( !opSf.bIsValid() ){
	reportWarning(T("|Selected entity is not an opening|!"));
	eraseInstance();
	return;
}

Element el = opSf.element();
_Pt0 = el.ptOrg();

String sUsedProfile = el.beamExtrProfile();

Beam arBm[] = el.beam();
for( int i=0;i<arBm.length();i++ ){
	Beam bm = arBm[i];
	
	if( bm.extrProfile() != _kExtrProfRectangular ){
		if( sUsedProfile == "" ){
			sUsedProfile = bm.extrProfile();
		}
		continue;
	}
	
	if( bm.module() == "" )
		continue;
	
	bm.setExtrProfile(sUsedProfile);
}

if( _bOnElementConstructed || bManualInsert )
	eraseInstance();



#End
#BeginThumbnail

#End
