#Version 8
#BeginDescription

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 0
#MinorVersion 10
#KeyWords 
#BeginContents
// Note: this script may be inserted form both the UI (e.g. HSB_MACROSELECTONLY) and code (using Hsb_temacro::scriptInsertNoPrompt())
// In first case this needs to select the trusses connected, in latter case the two trusses connected should be supplied already in entity list

U(1,"mm");

// Own properties
PropDouble pSymbolSize(0, U(120), T("|Symbol size|"));

if (_bOnInsert)	// Inserted directly from UI 
{	
	// Get the two trusses connected
	_Entity.append(getTrussEntity("Select carried truss"));
	_Entity.append(getTrussEntity("Select carrier truss"));	
}

// Set up truss entity variables and validate 
if (_Entity.length() != 2)
{
	eraseInstance(); // Erase from DB
	return;
}
TrussEntity trussHost = (TrussEntity)_Entity[0];	// Host entity (physically carried)
TrussEntity trussOther = (TrussEntity)_Entity[1];	// Other entity (physical carrier)	
if ( !trussHost.bIsValid() || !trussOther.bIsValid()) {
	eraseInstance(); // Erase from DB
	return;
}
	
if(_bOnDbCreated)	// Run once on the creation of the script entity
{ 
}

setDependencyOnEntity(trussHost);
setDependencyOnEntity(trussOther);

// Update position
TrussConnection conn();
conn.setConnectionTypeName("SymbolicConnection");
conn.connectTrusses(trussHost, trussOther);	// Recreating the connection tool on update
auto ptHost = conn.refPositionHost(trussHost, trussOther);

// Draw parameters
Display dp(-1);
double outRadius = pSymbolSize / 2;
double inRadius = outRadius - U(5);

// Draw symbol: in the plane of the first
dp.trueColor(rgb(0, 0, 255));
PLine circle;
auto nHost = trussHost.trussEnvelope().coordSys().vecZ();
circle.createCircle(ptHost, nHost, outRadius);
dp.draw(circle);
circle.createCircle(ptHost, nHost, inRadius);
dp.draw(circle);

// Draw symbol: on the plane of the other
dp.trueColor(rgb(0, 255, 0));
auto ptOther = conn.refPositionOther(trussHost, trussOther);
auto nOther = trussOther.trussEnvelope().coordSys().vecZ();
circle.createCircle(ptOther, nOther, outRadius);
dp.draw(circle);
circle.createCircle(ptOther, nOther, inRadius);
dp.draw(circle);

// Draw symbol: line between host and other (prominent only when have gap)
dp.trueColor(rgb(255, 0, 0));
PLine connLine(ptHost, ptOther);
dp.draw(connLine);
#End
#BeginThumbnail






#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]" />
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End