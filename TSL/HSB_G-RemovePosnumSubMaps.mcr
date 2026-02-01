#Version 8
#BeginDescription

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 0
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents


Entity arEnt[] = Group().collectEntities(true, Entity(), _kModelSpace);
for( int i=0;i<arEnt.length();i++ ){
	Entity ent = arEnt[i];
	ent.removeSubMap("Posnum");
}

eraseInstance();
return;
#End
#BeginThumbnail

#End