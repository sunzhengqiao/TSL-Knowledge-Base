#Version 8
#BeginDescription
This tsl optimizes the x and y direction of the sheet. It tries to align the length direction of the sheet with the longest edge of the sheeting outline. But only if that decreases the area of the sheeting bounding box.
2.3 03/06/2021 use new setXAxisDirectionInXYPlane function Author: Robert Pol

2.2 01/06/2021 Fix bug in creation of the sheet, it had a negative coordsys Author: Robert Pol


2.4 29/11/2023 Do not set vecx if it is already aligned Author: Robert Pol

2.5 19/12/2024 Add zone filter Author: Robert Pol
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 5
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl optimizes the x and y direction of the sheet. It tries to align the length direction of the sheet with the longest edge of the sheeting outline. But only if that decreases the area of the sheeting bounding box. 
/// </summary>

/// <insert>
/// 
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="2.01" date="17.05.2021"></version>

/// <history>
/// AS - 1.00 - 29.05.2013 - Pilot version
/// AS - 1.01 - 27.09.2013 - Redesign the tsl
/// AS - 1.02 - 11.09.2014 - Add option to select single sheets
/// AS - 1.03 - 17.09.2014 - Update the thickness after sorting it.
/// AS - 1.04 - 18.09.2014 - Support multiple sheets in selection set during insert.
/// AS - 1.05 - 07.04.2015 - Compare areas with a tolerance. (FogBugzId 1042)
/// AS - 1.06 - 08.09.2015 	- Sort edges on length, longest first.
/// DR - 1.07 - 17.05.2017	- Added sequence number -1000, solved issue: not working when framing 
/// AS - 1.08 - 19.07.2017	- Prefer element UCS if the sheet has a similar area in that UCS.
/// AS - 1.09 - 20.07.2017	- Set element z as sheet z if element orientation is used.
/// RP - 1.10 - 17.10.2017	- Only use element ucs if sheet z is aligned to element z
/// RP - 1.11 - 20.12.2017	- If a sheet has 3 edges, check i the 90 degrees corner is used the set the ucs
/// RP - 1.12 - 16.07.2018	- Check on length of array
/// FA - 1.13 - 09.03.2020		- Exclude a sheet when new VecX is equal to previous VecX
/// AS - 1.14 - 23.07.2020	- No longer changing sheet Z direction. 
/// 					 The sheet Z was mapped to the smallest dimension without changing the PlEnvelope or ProfSheet, which are used assuming that sheet Z is their normal.
/// RP - 2.00 - 30.10.2020	- Changing the Z direction caused issues with sheeting on sloped floors, use original z direction only change X
/// RP - 2.01 - 17.05.2021	- Make sure sheet is not changed when new x is aligned with old x
// #Versions
//2.5 19/12/2024 Add zone filter Author: Robert Pol
//2.4 29/11/2023 Do not set vecx if it is already aligned Author: Robert Pol
//2.3 03/06/2021 use new setXAxisDirectionInXYPlane function Author: Robert Pol
//2.2 01/06/2021 Fix bug in creation of the sheet, it had a negative coordsys Author: Robert Pol
/// </history>
double dEps = Unit(0.01, "mm");
double dEpsArea = U(10);

PropString sSeparator01(2, "", T("|Filter|"));
sSeparator01.setReadOnly(true);
PropString sMaterial(0, "", "    "+T("|Material to recalculate|"));
sMaterial.setDescription(T("|Leave this filter empty if all selected sheets must be analysed.|"));

PropInt nZone(0, -100, "    "+T("|Zone to recalculate|"));
nZone.setDescription(T("|Leave this filter -100 if all selected sheets must be analysed.|"));

PropString sSeparator02(3, "", T("|Selection|"));
sSeparator02.setReadOnly(true);
String arSSelectionMode[] = {T("|Elements|"), T("|Sheets|")};
PropString sSelectionMode(1, arSSelectionMode, "    "+T("|Selection mode|"));

_ThisInst.setSequenceNumber(-1000);

// set props from execute key
if (_bOnDbCreated)
	setPropValuesFromCatalog(_kExecuteKey);

//Insert
if( _bOnInsert ){
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" )
		showDialog();
}

int nSelectionMode = arSSelectionMode.find(sSelectionMode,0);

if (_bOnInsert) {
	if (nSelectionMode == 0) {
		PrEntity ssE(T("|Select a set of elements|"),Element());
		if(ssE.go())
			_Element.append(ssE.elementSet());
		
		String strScriptName = "HSB_E-RecalculateSheetOrientation"; // name of the script
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
		mapTsl.setInt("ManualInserted", true);
		setCatalogFromPropValues("MasterToSatellite");
		for( int e=0;e<_Element.length();e++ ){
			Element el = _Element[e];
			
			TslInst arTsl[] = el.tslInst();
			for( int i=0;i<arTsl.length();i++ ){
				TslInst tsl = arTsl[i];
				if( tsl.scriptName() == strScriptName )
					tsl.dbErase();
			}
		
			lstElements[0] = el;
		
			TslInst tsl;
			tsl.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
		}
		
		eraseInstance();
	}
	else{
		PrEntity ssE(T("|Select a set of sheets|"),Sheet());
		if(ssE.go())
			_Sheet.append(ssE.sheetSet());
		_Map.setInt("ManualInserted", true);
	}
	
	return;
}

if( _Map.hasInt("MasterToSatellite") ){
	int bMasterToSatellite = _Map.getInt("MasterToSatellite");
	if( bMasterToSatellite ){
		int bPropertiesSet = _ThisInst.setPropValuesFromCatalog("MasterToSatellite");
		_Map.removeAt("MasterToSatellite", true);
	}
}

int manualInserted = false;
if (_Map.hasInt("ManualInserted")) 
{
	manualInserted = _Map.getInt("ManualInserted");
	_Map.removeAt("ManualInserted", true);
}

Sheet arSh[0];

if (_Element.length() > 0) {
	Element el = _Element[0];
	_Pt0 = el.ptOrg();
	arSh = el.sheet();
}
else if (_Sheet.length() > 0) {
	arSh = _Sheet;
}
else{
	eraseInstance();
	return;
}

if(_bOnElementConstructed || manualInserted || _bOnDebug)
{ 
	for( int s=0;s<arSh.length();s++ ){
		Sheet sh = arSh[s];
		//_Pt0 = sh.ptCen();
		//return;
		if( sh.material() == sMaterial+"-new" )
			sh.dbErase();
		
		String s = sh.material();
		
		if( sMaterial != "" && sh.material() != sMaterial ) continue;
			
		if (nZone != -100 && sh.myZoneIndex() != nZone) continue;
		
		Point3d ptSh = sh.ptCen();
		
		Vector3d vxSh = sh.vecX();
		Vector3d vySh = sh.vecY();
		Vector3d vzSh = sh.vecZ();
		
		//	Body bdSh = sh.envelopeBody();
		double dxSh = sh.solidLength();//bdSh.lengthInDirection(vxSh);
		double dySh = sh.solidWidth();//bdSh.lengthInDirection(vySh);
		double dzSh = sh.solidHeight();//bdSh.lengthInDirection(vzSh);
		
		Point3d ptCenter=sh.ptCen();
		_Pt0 = ptCenter;
		vzSh.vis(_Pt0, 150);
		Body bdSh = sh.realBody();
		PlaneProfile ppSh = sh.profShape();
		
		PLine arPlSh[] = ppSh.allRings();
		int arBRingIsOpening[] = ppSh.ringIsOpening();
		PLine plShEnvelope(vzSh);
		PLine plShOpenings[0];
		for( int j=0;j<arPlSh.length();j++ ){
			PLine plSh = arPlSh[j];
			int bIsOpening = arBRingIsOpening[j];
			if( bIsOpening ){
				plShOpenings.append(plSh);
				continue;
			}
			
			plShEnvelope = plSh;
		}
		
		Point3d ptVertex[]=plShEnvelope.vertexPoints(false);
		for(int i=0;i<ptVertex.length();i++)
			ptVertex[i].vis(i);
		double dArea=plShEnvelope.area();
		dArea=dArea/U(1)*U(1);
		
		Point3d ptVertexToSort[0];
		ptVertexToSort.append(ptVertex);
		
		//Store all the posible areas and vectors to define the new orientation of the sheet
		double dValidAreas[0];
		double dSegmentLength[0];
		Vector3d vxNew[0];
		
		//Loop of the vertex Points to analize each segment
		for (int i=0; i<ptVertex.length()-1; i++)
		{
			//Declare of the new X and Y Direction using a pair of Vertex Points
			Vector3d vxSeg=ptVertex[i+1]-ptVertex[i];
			vxSeg.normalize();
			Vector3d vySeg=vxSeg.crossProduct(vzSh);

			//Lines to Sort the Point in the New X and Y Direction
			Line lnX (ptCenter, vxSeg);
			Line lnY (ptCenter, vySeg);
			
			//Sort the vertext Point in the new X direction and fine the bigest distance
			ptVertexToSort=lnX.orderPoints(ptVertexToSort);
			double dDistA=abs(vxSeg.dotProduct(ptVertexToSort[0]-ptVertexToSort[ptVertexToSort.length()-1]));
			
			//Sort the vertext Point in the new Y direction and fine the bigest distance
			ptVertexToSort=lnY.orderPoints(ptVertexToSort);
			double dDistB=abs(vySeg.dotProduct(ptVertexToSort[0]-ptVertexToSort[ptVertexToSort.length()-1]));
			
			double dNewArea=dDistA*dDistB;
			
			dValidAreas.append(dNewArea);
			dSegmentLength.append(abs(vxSeg.dotProduct(ptVertex[i+1]-ptVertex[i])));
			vxNew.append(vxSeg);
		}
		
		
		//Sort the arrays by Segment Length, longest first
		for (int i=0; i<dSegmentLength.length()-1; i++) {
			for (int j=i+1; j<dSegmentLength.length(); j++) {
				if( dSegmentLength[i] < dSegmentLength[j]) {
					dValidAreas.swap(i, j);
					dSegmentLength.swap(i, j);
					vxNew.swap(i, j);
				}
			}
		}
		//Sort the arrays by Smallest Area
		for (int i=0; i<dValidAreas.length()-1; i++) {
			for (int j=i+1; j<dValidAreas.length(); j++) {
				if( (dValidAreas[i] - dValidAreas[j]) > dEpsArea) {
					dValidAreas.swap(i, j);
					dSegmentLength.swap(i, j);
					vxNew.swap(i, j);
				}
			}
		}
		
		if (vxNew.length() == 3)
		{
			Vector3d vector1 = vxNew[0];
			vector1.vis(sh.ptCen(), 2);
			Vector3d vector2 = vxNew[1];
			vector2.vis(sh.ptCen(), 2);
			Vector3d vector3 = vxNew[2];
			vector3.vis(sh.ptCen(), 2);
			
			if (abs(vector1.dotProduct(vector2)) < dEps || abs(vector1.dotProduct(vector3)) < dEps || abs(vector2.dotProduct(vector3)) < dEps)
			{
				if (abs(vector1.dotProduct(vector2)) > dEps && abs(vector1.dotProduct(vector3)) > dEps)
					vxNew.swap(0, 1);
			}
		}
		
		if (vxNew.length() < 1) 
		{
			reportMessage(TN("|Sheet|: ") + sh.posnum() + T(" |could not be analysed|"));
			continue;
		}
		
		if (abs(vxSh.dotProduct(vxNew[0])) > 1 - dEps) continue;
		
		sh.setXAxisDirectionInXYPlane(vxNew[0]);
	}
	eraseInstance();
	return;
}




#End
#BeginThumbnail






















#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Add zone filter" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="12/19/2024 10:20:03 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Do not set vecx if it is already aligned" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="11/29/2023 3:01:33 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="use new setXAxisDirectionInXYPlane function" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="6/3/2021 1:36:53 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Fix bug in creation of the sheet, it had a negative coordsys" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="6/1/2021 11:25:50 AM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End