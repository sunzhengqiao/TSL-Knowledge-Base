#Version 8
#BeginDescription
#Versions
V1.0 12/2/2021 tsl to filter wall groups fro multipage shop drawings
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
if (_bOnInsert) {
	if (insertCycleCount()>1) {
		eraseInstance();
		return;
	}
	PrEntity ssE("\n Select wall group tsls", TslInst());
	if (ssE.go())
		_Entity.append(ssE.set().filterValid());
}

int bInDebug = false;
if (bInDebug) reportNotice("\n"+scriptName()+": ");

for (int i=_Entity.length()-1; i>-1; i--) {
	TslInst tsl = (TslInst) _Entity[i];
	Map mpX = tsl.subMapX("mpElementShop");
	int good = false;
	if (mpX.length() > 0) {
		Entity walls[] = mpX.getEntityArray("walls", "walls", "walls");
		if (walls.length() > 0)	good = true;
	}
	if ( ! good) _Entity.removeAt(i);
}

if (_Entity.length()==0) {
	if (bInDebug) reportNotice("\nNo entities in selection set.");
 	return; 
}

if (bInDebug) reportNotice("\n_Entity length: "+_Entity.length());
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
      <str nm="Comment" vl="tsl to filter wall groups fro multipage shop drawings" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="12/2/2021 2:48:46 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End