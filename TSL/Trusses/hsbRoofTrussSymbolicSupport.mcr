#Version 8
#BeginDescription


Version 0.2 14/07/2023 Added Beam.loadBearing , Tamas Racz
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 0
#MinorVersion 2
#KeyWords 
#BeginContents
// Note: this script may be inserted form both the UI (e.g. HSB_MACROSELECTONLY) and code (using Hsb_temacro::scriptInsertNoPrompt())
// In first case this needs to select the trusse and support object (wall, beam, ...), in latter case the truss and support object should be supplied already in entity list

U(1,"mm");

if (_bOnInsert)	// Inserted directly from UI 
{	
	// Get the two trusses connected
	_Entity.append(getTrussEntity("Select truss"));
	_Entity.append(getEntity("Select supporting object"));	
}
// Set up truss entity variables and validate 
if (_Entity.length() != 2)
{
	eraseInstance(); // Erase from DB
	return;
}
	
if(_bOnDbCreated)	// Run once on the creation of the script entity
{ 
}

TrussEntity eTruss = (TrussEntity)_Entity[0];	// The truss supported
Entity eSupport = _Entity[1];		// Supporting entity	
if ( !eTruss.bIsValid() || !eSupport.bIsValid()) {		
	eraseInstance();		// Erase from DB
	return;
}

// Indicates if the support entity is load bearing
// If object has no explicit load bearing flag then it is assumed to be load bearing
int isLoadBearing = true;

// Evaluate the support entity's load, when it is available
ElementWallSF elWallSF = (ElementWallSF) eSupport;
if (elWallSF.bIsValid())
	isLoadBearing = elWallSF.loadBearing();
Beam eBeam = (Beam)eSupport;
if (eBeam.bIsValid())
	isLoadBearing = eBeam.loadBearing();

// The support object candidate
TrussSupport ts();

// Properties
// Active flag
String strActive[] = {T("|Yes|"),T("|No|")};
PropString prStrActive(0, strActive, T("|Active|"), 0);	// default: strActive[0] == 'Yes'
prStrActive.setDescription(T("|Indicates if the support is active.|"));
if(!isLoadBearing)
{
	prStrActive.setReadOnly(true);	// For non-load bearing sub-structure do not allow turning the active flag back on
	prStrActive.setDescription(T("|Supporting object is not load bearing: this flag is inactive and the support is considered inactive.|"));
}
PropString _prop(0, strActive, T("|Active|"), 0);
// Vertical tolerance
PropDouble prDoubleTolerance (0, ts.verticalTolerance(), T("|Vertical tolerance|"));	// Note: default TrussSupport provides the default vertical tolerance
prDoubleTolerance.setDescription(T("|The maximum allowed gap between truss and its supporting object.|"));
// Set up own group
String opmCategory = T("|Truss support|");
prStrActive.setCategory(opmCategory);
prDoubleTolerance.setCategory(opmCategory);
ts.setVerticalTolerance(prDoubleTolerance);

// Make the support
int isActive = prStrActive == T("Yes") && isLoadBearing;
isActive = isActive && ts.canHaveValidGeom(eTruss, eSupport);
ts.setIsActive(isActive);
ts.setSupportTypeName("SymbolicSupport");
if(!ts.create(eTruss, eSupport))	// Recreating the support tool on update
{ 	// Reason to fail includes the existence of an other support for this very truss and support entity
	eraseInstance();		// Erase from DB
	return;	
}

setDependencyOnEntity(eTruss);
setDependencyOnEntity(eSupport);

// Draw parameters
Display dp(-1);
auto trussEnvelope = eTruss.trussEnvelope();
auto xTruss = trussEnvelope.coordSys().vecX();
auto nTruss = trussEnvelope.coordSys().vecZ();
auto width = eTruss.width();
auto alignment = eTruss.alignment();
double leftOffset = -width / 2;
double rightOffset = width / 2;
if(alignment == "Left")
{ 
	leftOffset = 0.0;
	rightOffset = width;
}
else if (alignment == "Right")
{ 
	leftOffset = -width;
	rightOffset = 0.0;
}

auto trussColor = rgb(255, 0, 0);
auto supportColor = rgb(0, 255, 0);
auto connectionColor = rgb(255, 0, 0);
if(!isActive)
{ 
	trussColor = rgb(64, 64, 64);
	supportColor = rgb(64, 64, 64);
	connectionColor = rgb(64, 64, 64);
}

// Draw symbol on support object
auto suppSeg = ts.geomSupport(eTruss, eSupport);
{ 
	dp.trueColor(supportColor);
	LineSeg diag1(suppSeg.ptStart() + leftOffset * nTruss, suppSeg.ptEnd() + rightOffset * nTruss);
	LineSeg diag2(suppSeg.ptStart() + rightOffset * nTruss, suppSeg.ptEnd() + leftOffset * nTruss);
	PLine rect;
	rect.createRectangle(diag1, xTruss, nTruss);
	dp.draw(suppSeg);
	dp.draw(rect);
	dp.draw(diag1);
	dp.draw(diag2);
}

// Draw symbol on truss
auto trussSeg = ts.geomTruss(eTruss, eSupport);
{ 
	dp.trueColor(trussColor);
	dp.draw(trussSeg);	
}

// Connect support and truss
{ 
	dp.trueColor(connectionColor);	
	LineSeg side1(suppSeg.ptStart(), trussSeg.ptStart());
	LineSeg side2(suppSeg.ptEnd(), trussSeg.ptEnd());
	LineSeg diag1(suppSeg.ptStart(), trussSeg.ptEnd());
	LineSeg diag2(suppSeg.ptEnd(), trussSeg.ptStart());
	dp.draw(side1);
	dp.draw(side2);
	dp.draw(diag1);
	dp.draw(diag2);
}
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
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Added Beam.loadBearing" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="7/14/2023 11:46:50 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End