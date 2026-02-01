#Version 8
#BeginDescription
#Versions
Version 1.2 29-6-2023 Add options to show or hide the diagonal line and the module number. Ronald van Wijngaarden
Version 1.1 09.12.2021 HSB-13799 Module text aligns with view direction , Author Thorsten Huck






























#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
// #Versions
// 1.2 29-6-2023 Add options to show or hide the diagonal line and the module number. Ronald van Wijngaarden
// 1.1 09.12.2021 HSB-13799 Module text aligns with view direction , Author Thorsten Huck


/// <summary Lang=en>
/// Tsl to number modules. The modules are numbered per element.
/// </summary>

/// <version  value="1.00" date="02.10.2014"></version>

/// <history>
/// 1.00 - 02.10.2014 - 	Pilot version
/// </hsitory>



double dEps(Unit(0.01,"mm"));

String sNoYes[] = { T("|No|"), T("|Yes|")};
String category = T("|General|");

//Properties
PropString sSeperator01(0, "", T("|Selection|"));
sSeperator01.setReadOnly(true);
sSeperator01.setCategory(category);

category = T("|Display|");
PropString sShowDiagonalLine(1, sNoYes, T("|Show diagonal line|"), 1);
sShowDiagonalLine.setDescription(T("|Choose if the diagonal line should be shown|"));
sShowDiagonalLine.setCategory(category);

PropString sShowNumber(2, sNoYes, T("|Show module number|"), 1);
sShowNumber.setDescription(T("|Choose if the number should be shown|"));
sShowNumber.setCategory(category);

PropDouble sTextHeight (0, U(20), T("|Textheight|"));
sTextHeight.setDescription(T("|Give in the textheight|"));
sTextHeight.setCategory(category);



// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_E-NumberModules");
if( arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert ){
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	
	int nNrOfTslsInserted = 0;
	PrEntity ssE(T("Select a set of elements"), Element());

	if( ssE.go() ){
		Element arSelectedElement[] = ssE.elementSet();
		
		String strScriptName = "HSB_E-NumberModules"; // name of the script
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		Beam lstBeams[0];
		Element lstElements[1];
		
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		Map mapTsl;
		mapTsl.setInt("MasterToSatellite", true);
		mapTsl.setInt("ManualInsert", true);
		setCatalogFromPropValues("MasterToSatellite");
				
		for( int e=0;e<arSelectedElement.length();e++ ){
			Element el = arSelectedElement[e];
			lstElements[0] = el;
			
			TslInst arTsl[] = el.tslInst();
			for (int i=0;i<arTsl.length();i++) {
				TslInst tsl = arTsl[i];
				if (tsl.scriptName() == strScriptName) {
					tsl.dbErase();
				}
			}
			
			TslInst tsl;
			tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
			nNrOfTslsInserted++;
		}
	}
	
	reportMessage(nNrOfTslsInserted + T(" |tsl(s) inserted|"));
	
	eraseInstance();
	return;
}


if( _Map.hasInt("MasterToSatellite") ){
	int bMasterToSatellite = _Map.getInt("MasterToSatellite");
	if( bMasterToSatellite ){
		int bPropertiesSet = _ThisInst.setPropValuesFromCatalog("MasterToSatellite");
		_Map.removeAt("MasterToSatellite", TRUE);
	}
}

int bManualInsert = false;
if( _Map.hasInt("ManualInsert") ){
	bManualInsert = _Map.getInt("ManualInsert");
	_Map.removeAt("ManualInsert", true);
}

Element el = _Element[0];
_ThisInst.assignToElementGroup(el, true, 0, 'I');

CoordSys csEl = el.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

Line lnX(ptEl, vxEl);
Line lnY(ptEl, vyEl);
Line lnZ(ptEl, vzEl);

_Pt0 = ptEl;

int showDiagonalLine = sShowDiagonalLine == "Yes";
int showModuleNumber = sShowNumber == "Yes";

String moduleNames[0];
int moduleIDs[0];
// Beams with the module set will receive a module index. 
Beam moduleBeams[0];
int moduleBeamIDs[0];

Beam elementBeams[] = el.beam();

for (int i=0;i<elementBeams.length();i++) {
	Beam bm = elementBeams[i];
	
	String moduleName = bm.module();
	if (moduleName == "") 
		continue;
	
	int moduleID = moduleNames.find(moduleName);
	// Is it a known module?
	if (moduleID == -1){ // No. Add it.
		moduleNames.append(moduleName);
		moduleID = moduleNames.length() - 1;
		moduleIDs.append(moduleID);
	}
	
	moduleBeams.append(bm);
	moduleBeamIDs.append(moduleID);
}

// Order beams by module beam ID.
for (int s1=1;s1<moduleBeamIDs.length();s1++) {
	int s11 = s1;
	for (int s2=s1-1;s2>=0;s2--) {
		if (moduleBeamIDs[s11] < moduleBeamIDs[s2]) {
			moduleBeamIDs.swap(s2, s11);	
			moduleBeams.swap(s2, s11);
			
			s11=s2;
		}
	}
}

// The extreme points of the modules. The start positions are taken in the lower left hand corner. The end postions in the upper righthand corner.
LineSeg moduleMinMaxSegments[0];

// Points used to calculate the min-max segments.
Point3d moduleVertices[0];

// Start with the first module.
int previousModuleBeamID = 0;
for (int i=0;i<moduleBeamIDs.length();i++) {
	int moduleBeamID = moduleBeamIDs[i];
	
	Beam moduleBeam = moduleBeams[i];
	Point3d beamVertices[] = moduleBeam.envelopeBody().allVertices();
	if (moduleBeamID == previousModuleBeamID) {
		moduleVertices.append(beamVertices);
	}
	
	// This is the start of a new module, or it is the last module beam.
	if (moduleBeamID != previousModuleBeamID || i == (moduleBeamIDs.length() - 1)) {
		// Set the extremes for this module.
		Point3d moduleVerticesX[] = lnX.orderPoints(moduleVertices);
		Point3d moduleVerticesY[] = lnY.orderPoints(moduleVertices);
		Point3d moduleVerticesZ[] = lnZ.orderPoints(moduleVertices);
		
		Point3d lowerLeftHandCorner = moduleVerticesX[0];
		lowerLeftHandCorner += vyEl * vyEl.dotProduct(moduleVerticesY[0] - lowerLeftHandCorner);
		lowerLeftHandCorner += vzEl * vzEl.dotProduct(moduleVerticesZ[moduleVerticesZ.length() - 1] - lowerLeftHandCorner);
		
		Point3d upperRightHandCorner = moduleVerticesX[moduleVerticesX.length() - 1];
		upperRightHandCorner += vyEl * vyEl.dotProduct(moduleVerticesY[moduleVerticesY.length() - 1] - upperRightHandCorner);
		upperRightHandCorner += vzEl * vzEl.dotProduct(moduleVerticesZ[0] - upperRightHandCorner);
		
		moduleMinMaxSegments.append(LineSeg(lowerLeftHandCorner, upperRightHandCorner));
		
		previousModuleBeamID = moduleBeamID;
		moduleVertices = beamVertices;
	}
}

// Order modules from left to right
for (int s1=1;s1<moduleMinMaxSegments.length();s1++) {
	int s11 = s1;
	for (int s2=s1-1;s2>=0;s2--) {
		if (vxEl.dotProduct(moduleMinMaxSegments[s11].ptMid() - moduleMinMaxSegments[s2].ptMid()) < 0) {
			moduleMinMaxSegments.swap(s2, s11);	
			moduleNames.swap(s2, s11);
			moduleIDs.swap(s2, s11);
			
			s11=s2;
		}
	}
}

// Create the new module names.
String newModuleNames[0];
for (int i=0;i<moduleIDs.length();i++){
	String newModuleName = el.number() + "-" + (i + 1);
	newModuleNames.append(newModuleName);
	moduleNames[i] = newModuleName;
}


// Set the new module names.
for (int i=0;i<moduleBeamIDs.length();i++) {
	int moduleBeamID = moduleBeamIDs[i];
	Beam moduleBeam = moduleBeams[i];
	moduleBeam.setModule(newModuleNames[moduleBeamID]);
}

// Visualise the modules
Display moduleDisplay(-1);
moduleDisplay.textHeight(sTextHeight);
for (int i=0;i<moduleMinMaxSegments.length();i++) {
	LineSeg moduleMinMaxSegment = moduleMinMaxSegments[i];
	
	if(showDiagonalLine)
	{
		moduleDisplay.draw(moduleMinMaxSegment);		
	}
	if (showModuleNumber)
	{
		moduleDisplay.draw(moduleNames[i], moduleMinMaxSegment.ptMid(), vxEl, vyEl, 0, 0,_kDevice);		
	}
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
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Add options to show or hide the diagonal line and the module number." />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="6/29/2023 12:02:14 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13799 Module text aligns with view direction" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="12/9/2021 8:47:43 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End