#Version 8
#BeginDescription

#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 0
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
if ( _kExecuteKey=="readBlock" ) {
if (_Map.length() >0) {
reportNotice("\nMap has Data!");
}
else {
reportNotice("\n_Map does not contain Data!");
}
return;
}
#End
#BeginThumbnail

#End