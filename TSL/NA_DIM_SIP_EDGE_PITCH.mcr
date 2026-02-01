#Version 8
#BeginDescription
V1.0  03-06-2023  TSL to display pitch icon for Sip edges
#End
#Type E
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords
#BeginContents
int bInDebug = false;
Unit(1, "inch");
String defaultDimStyle = "MP Shops 1_8";
int defaultDimStyleIndex = _DimStyles.find(defaultDimStyle);
if (defaultDimStyleIndex < 0) defaultDimStyleIndex = 0;
int propStringIndex, propDoubleIndex, propIntIndex;
PropString userDimStyle(propStringIndex++,_DimStyles, T("Dim style"), defaultDimStyleIndex);
String yes_no[] ={ T("Yes"), T("No")};
PropString userDisplayAccurateIcon(propStringIndex++,yes_no, T("Display accurate icon"), 0);

if (_bOnMapIO) {
	showDialog("_LastInserted");
	_Map.setMap("mpProps", mapWithPropValues());
	return;
}
if (_Map.hasMap("mpProps")) {
	setPropValuesFromMap(_Map.getMap("mpProps"));
}


if (_bOnInsert) {
	showDialog();
	_Sip.append(getSip("\n" + T("Select Sip Panel")));
}
Sip activeSipPanel;
if (_Sip.length())
	activeSipPanel = _Sip.first();
if (!activeSipPanel.bIsValid() && _Entity.length())
	activeSipPanel = (Sip)_Entity.first();
if (!activeSipPanel.bIsValid()){
	reportMessage("\n" + scriptName() + ": " + T("No Sip found. Erasing this instance."));
	eraseInstance();
	return;
}

Vector3d widthDirection  = activeSipPanel.vecX();
Vector3d heightDirection = activeSipPanel.vecY();
Vector3d depthDirection  = activeSipPanel.vecZ();
Element activeElement = activeSipPanel.element();
if (activeElement.bIsValid()){
	widthDirection  = activeElement.vecX();
	heightDirection = activeElement.vecY();
	depthDirection  = activeElement.vecZ();
}

SipEdge allEdges[] = activeSipPanel.sipEdges();
for (int i=0; i<allEdges.length(); i++) {
	SipEdge panelEdge = allEdges[i];
	Vector3d edgeNormal = panelEdge.vecNormal();
	if (edgeNormal.isParallelTo(widthDirection) || edgeNormal.isParallelTo(heightDirection))
		continue;
	double offsetFromEdge = panelEdge.dRecessDepth() + U(0.125);
	Vector3d pitchDirection = edgeNormal.crossProduct(depthDirection);
	if (pitchDirection.dotProduct(widthDirection)<0)
		pitchDirection *= -1;
	pitchDirection.normalize();

	Point3d iconPoint = panelEdge.ptMid() + edgeNormal * offsetFromEdge;
	double pitchWidth = U(12);
	double pitchHeight = abs(heightDirection.dotProduct(pitchDirection * pitchWidth));
	double deltaX = pitchWidth;
	double deltaY = pitchHeight;
	if (userDisplayAccurateIcon == yes_no[1]) {
		double textHeight = Display().textHeightForStyle(String(deltaX), userDimStyle)*2;
		deltaX = textHeight;
		deltaY = textHeight;
	}
	DimRequestPitch pitchIcon("Pitch " + scriptName(), iconPoint, widthDirection, deltaX, deltaY);
	pitchIcon.setDimStyle(userDimStyle);
	if (userDisplayAccurateIcon == yes_no[1]) {
		String textXOverride = String().formatUnit(pitchWidth, userDimStyle);
		String textYOverride = String().formatUnit(pitchHeight, userDimStyle);
		pitchIcon.setDeltaTextX(textXOverride);
		pitchIcon.setDeltaTextY(textYOverride);
	}
	pitchIcon.addAllowedView(depthDirection, true);
	pitchIcon.setStereotype("PitchIcon");
	addDimRequest(pitchIcon);
}
if(bInDebug){
    String stMapName = _Map.getMapKey() == "" ? _Map.getMapName() : _Map.getMapKey();
	if (stMapName == "") stMapName = scriptName() + ".mpDebug.dxx";
    String stPath = _kPathDwg + "\\" + stMapName ;
    _Map.writeToDxxFile(stPath);
    String stMapExplorerPath = _kPathHsbInstall + "\\Utilities\\hsbMapExplorer\\hsbMapExplorer.exe";
    spawn_detach("", stMapExplorerPath, "\"" + stPath + "\"", "");
}
#End
#BeginThumbnail




#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="0.03937008" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End