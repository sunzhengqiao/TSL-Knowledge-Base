#Version 8
#BeginDescription
#Versions
V1.0 12/2/2021 tsl to collect contents of wall groups for multipage shop drawings
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
setMarbleDiameter(U(2));
if (_bOnInsert) {
	if (insertCycleCount()>1) {
		eraseInstance();
		return;
	}
	PrEntity ssE("\n Select shop draw views", ShopDrawView());
	if (ssE.go())
		_Entity.append(ssE.set().filterValid());
	_Pt0 = getPoint("\n Select insertion point");
}

if (_Entity.length()<1) {
	eraseInstance();
	return;
}

addRecalcTrigger(_kShopDrawEvent, _kShopDrawViewDataShowSet);

if (_bOnGenerateShopDrawing && _kExecuteKey == _kShopDrawViewDataShowSet) {
	ViewData vwDatas[] = ViewData().convertFromSubMap(_Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets, 2);
	Map mpVwData = ViewData().convertToMap(vwDatas);
	String wallNames[0];
	for (int i = 0; i < _Entity.length(); i++) {
		Entity entView = _Entity[i];
		int foundData = ViewData().findDataForViewport(vwDatas, entView);
		if (foundData < 0) continue;
		ViewData vwData = vwDatas[foundData];
		Entity ents[] = vwData.showSetDefineEntities();
		Entity entsDraw[0];
		if (ents.length() < 1) continue;
		for (int j = 0; j < ents.length(); j++) {
			TslInst tsl = (TslInst) ents[j];
			Map mpX = tsl.subMapX("mpElementShop");
			if (mpX.length() > 0) {
				Entity walls[] = mpX.getEntityArray("walls", "walls", "walls");
				for (int k = 0; k < walls.length(); k++) {
					Element el = (Element) walls[k];
					if (wallNames.find(el.number()) < 0)
						wallNames.append(el.number());
					Group gp = el.elementGroup();
					Entity wallComps[] = gp.collectEntities(true, Entity(), _kModelSpace);
					if (wallComps.find(el) < 0)
						wallComps.append(el);
					entsDraw.append(wallComps);
				}
			}
		}
		String strViewHandle = entView.handle();
		Map mpViewData;
		mpViewData.setEntityArray(entsDraw, TRUE, "Handle[]", "showSetEntities", "han");
		mpViewData.setString("ViewHandle", strViewHandle);
		_Map.appendMap(_kShopDrawViewDataShowSet + "\\ViewData[]\\ViewData", mpViewData);
	}
	wallNames = wallNames.sorted();
	reportMessage("\n Walls: " + wallNames);
	Display dp(-1);
	double dth = U(0.25);
	dp.textHeight(dth);
	Point3d ptWalk = _Pt0 - _YW * dth / 4;
	if (wallNames.length()<1)
		wallNames.append("N/A");
	for (int i=0; i<wallNames.length(); i++) {
		dp.draw(wallNames[i], ptWalk, _XW, _YW, 1, -1);
		ptWalk -= _YW * dth * 1.5;
	}
	reportMessage("\n " + _kExecuteKey);
}




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
    <lst nm="VERSION">
      <str nm="COMMENT" vl="tsl to collect contents of wall groups for multipage shop drawings" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="12/2/2021 3:25:19 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End