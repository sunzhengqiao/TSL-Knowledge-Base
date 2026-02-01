#Version 8
#BeginDescription
Last modified by: Robert Pol (robert.pol@hsbcad.com)
18.08.2016  -  version 1.01

This tsl adds properties to Joist and Rafters in Floor/Roof Elements.

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl adds a Beamcode for Joist and Rafters in Floor/Roof Elements.
/// </summary>

/// <insert>
/// Select a set of elements
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.01" date="18.08.2016"></version>

/// <history>
/// RP - 1.00 - 15.07.2016 -	First version
/// RP - 1.01 - 18.08.2016 -	Only rename when empty

/// </history>
double dEps = U(.001,"mm");

String categories[] = {
	T("|General|"),
	T("|Joists|"),
	T("|Rafters|")
};

PropInt sequenceNumber(0, 0, T("|Sequence number|"));
sequenceNumber.setCategory(categories[0]);
sequenceNumber.setDescription(T("|The sequence number is used to sort the list of tsl's during generate construction|"));
PropString NameJoists(1, "", ""+T("Name Joists|"));
NameJoists.setCategory(categories[1]);
NameJoists.setDescription(T("|Specify the Name of joists in a floor element|"));
PropString NameRafters(2, "", ""+T("|Name Rafters|"));
NameRafters.setCategory(categories[2]);
NameRafters.setDescription(T("|Specify the Name of rafters in a roof element|"));
PropString MaterialJoists(3, "", ""+T("Material Joists|"));
MaterialJoists.setCategory(categories[1]);
MaterialJoists.setDescription(T("|Specify the Material of joists in a floor element|"));
PropString MaterialRafters(4, "", ""+T("|Material Rafters|"));
MaterialRafters.setCategory(categories[2]);
MaterialRafters.setDescription(T("|Specify the Material of rafters in a roof element|"));
PropString GradeJoists(5, "", ""+T("Grade Joists|"));
GradeJoists.setCategory(categories[1]);
GradeJoists.setDescription(T("|Specify the Grade of joists in a floor element|"));
PropString GradeRafters(6, "", ""+T("|Grade Rafters|"));
GradeRafters.setCategory(categories[2]);
GradeRafters.setDescription(T("|Specify the Grade of rafters in a roof element|"));
PropString InformationJoists(7, "", ""+T("Information Joists|"));
InformationJoists.setCategory(categories[1]);
InformationJoists.setDescription(T("|Specify the Information of joists in a floor element|"));
PropString InformationRafters(8, "", ""+T("|Information Rafters|"));
InformationRafters.setCategory(categories[2]);
InformationRafters.setDescription(T("|Specify the Information of rafters in a roof element|"));
PropString LabelJoists(9, "", ""+T("Label Joists|"));
LabelJoists.setCategory(categories[1]);
LabelJoists.setDescription(T("|Specify the Label of joists in a floor element|"));
PropString LabelRafters(10, "", ""+T("|Label Rafters|"));
LabelRafters.setCategory(categories[2]);
LabelRafters.setDescription(T("|Specify the Label of rafters in a roof element|"));
PropString SubLabelJoists(11, "", ""+T("SubLabel Joists|"));
SubLabelJoists.setCategory(categories[1]);
SubLabelJoists.setDescription(T("|Specify the SubLabel of joists in a floor element|"));
PropString SubLabelRafters(12, "", ""+T("|SubLabel Rafters|"));
SubLabelRafters.setCategory(categories[2]);
SubLabelRafters.setDescription(T("|Specify the SubLabel of rafters in a roof element|"));
PropString SubLabel2Joists(13, "", ""+T("SubLabel2 Joists|"));
SubLabel2Joists.setCategory(categories[1]);
SubLabel2Joists.setDescription(T("|Specify the SubLabel2 of joists in a floor element|"));
PropString SubLabel2Rafters(14, "", ""+T("|SubLabel2 Rafters|"));
SubLabel2Rafters.setCategory(categories[2]);
SubLabel2Rafters.setDescription(T("|Specify the SubLabel2 of rafters in a roof element|"));
PropString beamCodeJoists(15, "", ""+T("|Beamcode Joists|"));
beamCodeJoists.setCategory(categories[1]);
beamCodeJoists.setDescription(T("|Specify the Beamcode of joists in a floor element|"));
PropString beamCodeRafters(16, "", ""+T("|Beamcode Rafters|"));
beamCodeRafters.setCategory(categories[2]);
beamCodeRafters.setDescription(T("|Specify the Beamcode of rafters in a roof element|"));



// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames("HSB_E-AssignPropsJoistandRafters");
if( catalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert) {
	if (insertCycleCount() > 1) {
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || catalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	setCatalogFromPropValues(T("|_LastInserted|"));
	
	PrEntity ssElements(T("|Select elements|"), ElementRoof());
	if (ssElements.go()) {
		Element selectedElements[] = ssElements.elementSet();
		
		String strScriptName = scriptName();
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		Beam lstBeams[0];
		Entity lstEntities[1];
		
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		Map mapTsl;
		mapTsl.setInt("ManualInserted", true);

		for (int e=0;e<selectedElements.length();e++) {
			Element selectedElement = selectedElements[e];
			if (!selectedElement.bIsValid())
				continue;
			
			lstEntities[0] = selectedElement;

			TslInst tslNew;
			tslNew.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
		}		
	}
	
	eraseInstance();
	return;
}

if (_Element.length() == 0) {
	reportWarning(T("|invalid or no element selected.|"));
	eraseInstance();
	return;
}

int manualInserted = false;
if (_Map.hasInt("ManualInserted")) {
	manualInserted = _Map.getInt("ManualInserted");
	_Map.removeAt("ManualInserted", true);
}

// set properties from catalog
if (_bOnDbCreated && manualInserted)
	setPropValuesFromCatalog(T("|_LastInserted|"));
	
// Set the sequence number
_ThisInst.setSequenceNumber(sequenceNumber);

Element el = _Element[0];

CoordSys csEl = el.coordSys();
Point3d elOrg  = csEl.ptOrg();
Vector3d elX = csEl.vecX();
Vector3d elY = csEl.vecY();
Vector3d elZ = csEl.vecZ();
_Pt0 = el.ptOrg();
		
	Beam beams[] = el.beam();
	for (int b=0;b<beams.length();b++) {
		Beam bm = beams[b];
		
		//Continue if not Joist or Rafter
		if (bm.type() != _kDakCenterJoist && bm.type() != _kExtraRafter)
		continue;
		
		//Joist
		if (abs(bm.vecX().dotProduct(_ZW)) < dEps){
		if (bm.name() == "")
		bm.setName(NameJoists);
		if (bm.material() == "")
		bm.setMaterial(MaterialJoists);
		if (bm.grade() == "")
		bm.setGrade(GradeJoists);
		if (bm.information() == "")
		bm.setInformation(InformationJoists);
		if (bm.label() == "")
		bm.setLabel(LabelJoists);
		if (bm.subLabel() == "")
		bm.setSubLabel(SubLabelJoists);
		if (bm.subLabel2() == "")
		bm.setSubLabel2(SubLabel2Joists);
		if (bm.beamCode() == "")
		bm.setBeamCode(beamCodeJoists);
		
		}
		
		else {
		//Rafter
		if (bm.name() == "")
		bm.setName(NameRafters);
		if (bm.material() == "")
		bm.setMaterial(MaterialRafters);
		if (bm.grade() == "")
		bm.setGrade(GradeRafters);
		if (bm.information() == "")
		bm.setInformation(InformationRafters);
		if (bm.label() == "")
		bm.setLabel(LabelRafters);
		if (bm.subLabel() == "")
		bm.setSubLabel(SubLabelRafters);
		if (bm.subLabel2() == "")
		bm.setSubLabel2(SubLabel2Rafters);
		if (bm.beamCode() == "")
		bm.setBeamCode(beamCodeRafters);
		
		}
}

// Job done: remove tsl.
if (_bOnElementConstructed || manualInserted) {
	eraseInstance();
	return;
}


#End
#BeginThumbnail




#End