#Version 8
#BeginDescription
#Versions
V1.0 12/2/2021 tsl to group walls for multipage shop drawings
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
Unit(1, "inch");
if (_bOnInsert) {
	if (insertCycleCount()>1) {
		eraseInstance();
		return;
	}
	PrEntity ssE("\n Select wall(s) to display in a shop drawing as a group", ElementWallSF());
	if (ssE.go()) 
		_Element.append(ssE.elementSet().filterValid());
}

if (_Element.length()<1) {
	eraseInstance();
	return;
}

String addWalls = "Add wall(s)";
addRecalcTrigger(_kContextRoot, addWalls);
if (_bOnRecalc && _kExecuteKey == addWalls){
	PrEntity ssE("\n Select wall(s) to add to a group", ElementWallSF());
	if (ssE.go()) {
		Element walls[] = ssE.elementSet().filterValid();
		for (int i=0; i<walls.length(); i++) {
			Element el = walls[i];
			if (_Element.find(el)<0)
				_Element.append(el);
		}
	}
}

String removeWalls = "Remove wall(s)";
addRecalcTrigger(_kContextRoot, removeWalls);
if (_bOnRecalc && _kExecuteKey == removeWalls){
	PrEntity ssE("\n Select wall(s) to remove from a group", ElementWallSF());
	if (ssE.go()) {
		Element walls[] = ssE.elementSet().filterValid();
		for (int i=_Element.length()-1; i>-1; i--) {
			Element el = _Element[i];
			if (walls.find(el)>=0)
				_Element.removeAt(i);
		}
	}
}

String error;
for (int i=0; i<_Element.length(); i++){
	Element el = _Element[i];
	TslInst tsls[] = el.tslInst().filterValid();
	for (int j=0; j<tsls.length(); j++) {
		TslInst tsl = tsls[j];
		if (tsl.handle() == _ThisInst.handle()) continue;
		Map mpX = tsl.subMapX("mpElementShop");
		if (mpX.length()>0){
			Entity walls[] = mpX.getEntityArray("walls", "walls", "walls");
			if (walls.length()<1) continue; 
			error += "\n Wall " + el.number() + " is already groupped with: ";
			for (int k=0; k<walls.length(); k++) {
				Element elK = (Element) walls[k];
				if (elK.number() != el.number()) 
					error += elK.number()+" ";				
			}
		}
	}	
}
if (error.length()>0){
	reportMessage(error);
	reportMessage("\n Please modify existing wall groups (tsls). Erasing this instance.");
	eraseInstance();
	return;
}

Map mpX;
mpX.setEntityArray(_Element, true, "walls", "walls", "walls");
_ThisInst.setSubMapX("mpElementShop", mpX);

Display dp(-1);
dp.lineType("DASHED2", 25);
PlaneProfile outlineAll;
for (int i=0; i<_Element.length(); i++){
	Element el = _Element[i];
	assignToElementGroup(el, i==0);
	PlaneProfile outline = PlaneProfile(el.plOutlineWall());
	outline.shrink(-U(0.5));
	if (i == 0) outlineAll = outline;
	else outlineAll.unionWith(outline);
}
dp.draw(outlineAll);
#End
#BeginThumbnail

#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="0.03937008" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="tsl to group walls for multipage shop drawings" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="12/2/2021 1:59:41 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End