#Version 8
#BeginDescription

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 0
#FileState 1
#MajorVersion 0
#MinorVersion 0
#KeyWords 
#BeginContents


Entity arEnt[] = Group().collectEntities(true, GenBeam(), _kModelSpace);
for( int i=0;i<arEnt.length();i++ ){
	Entity ent = arEnt[i];
	GenBeam gBm = (GenBeam)ent;
	
	if( !gBm.bIsValid() )
		continue;
	
	if( gBm.solidLength() * gBm.solidWidth() * gBm.solidHeight() == 0 ){
		reportMessage(TN("|Invalid bod for genBeam. GenBeam is deleted|!"));
		gBm.dbErase();
	}	
}

eraseInstance();
return;
#End
#BeginThumbnail

#End
