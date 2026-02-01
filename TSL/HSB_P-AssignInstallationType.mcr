#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
25.02.2015  -  version 1.02


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 0
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
/// <summary>
/// This TSL assigns electrical symbols to a installation objects
/// </summary>

/// <insert>
///
/// </insert>

/// <remark>
/// 
/// </remark>

/// <history>
/// AS - 1.00 - 17.06.2014	- Pilot version
/// AS - 1.01 - 05.11.2014	- Also export the Id
/// AS - 1.02 - 25.02.2015	- Set the values passed in as valid properties.
/// </history>


String sFileLocation = _kPathHsbCompany+"\\Abbund";
String sFileName = "HSB-InstallationTypeCatalogue.xml";
String sFullPath = sFileLocation + "\\" + sFileName;


if (_bOnMapIO) {
	int nNrOfInstallationPoints = _Map.getInt("NrOfInstallationPoints");
	
	Map mapSymbols;
	int bMapIsRead = mapSymbols.readFromXmlFile(sFullPath);
	
	String arSEntryName[0];
	for (int i=0;i<mapSymbols.length();i++) {
		if (mapSymbols.hasMap(i)) {
			arSEntryName.append(mapSymbols.keyAt(i)+"/"+mapSymbols.getMap(i).getString("Type"));
		}
	}

	
	// General properties
	PropString sSeparator01(0, "", T("|Installation type|"));
	sSeparator01.setReadOnly(true);
	PropString sInstallationType1(1, arSEntryName, "     "+T("|Installation type| 1"));
	sInstallationType1.setReadOnly(1 > nNrOfInstallationPoints);
	PropString sInstallationType2(2, arSEntryName, "     "+T("|Installation type| 2"));
	sInstallationType2.setReadOnly(2 > nNrOfInstallationPoints);
	PropString sInstallationType3(3, arSEntryName, "     "+T("|Installation type| 3"));
	sInstallationType3.setReadOnly(3 > nNrOfInstallationPoints);
	PropString sInstallationType4(4, arSEntryName, "     "+T("|Installation type| 4"));
	sInstallationType4.setReadOnly(4 > nNrOfInstallationPoints);
	PropString sInstallationType5(5, arSEntryName, "     "+T("|Installation type| 5"));
	sInstallationType5.setReadOnly(5 > nNrOfInstallationPoints);
	PropString sInstallationType6(6, arSEntryName, "     "+T("|Installation type| 6"));
	sInstallationType6.setReadOnly(6 > nNrOfInstallationPoints);
	PropString sInstallationType7(7, arSEntryName, "     "+T("|Installation type| 7"));
	sInstallationType7.setReadOnly(7 > nNrOfInstallationPoints);
	PropString sInstallationType8(8, arSEntryName, "     "+T("|Installation type| 8"));
	sInstallationType8.setReadOnly(8 > nNrOfInstallationPoints);
	PropString sInstallationType9(9, arSEntryName, "     "+T("|Installation type| 9"));
	sInstallationType9.setReadOnly(9 > nNrOfInstallationPoints);
	PropString sInstallationType10(10, arSEntryName, "     "+T("|Installation type| 10"));
	sInstallationType10.setReadOnly(10 > nNrOfInstallationPoints);
	
	Map mapCurrentInstallations = _Map.getMap("Installations");
	for (int i=0;i<mapCurrentInstallations.length();i++) {
		Map mapInstallation = mapCurrentInstallations.getMap(i);
		if (i==0) sInstallationType1.set(mapInstallation.getString("InstallationType"));
		else if (i==1) sInstallationType2.set(mapInstallation.getString("InstallationType"));
		else if (i==2) sInstallationType3.set(mapInstallation.getString("InstallationType"));
		else if (i==3) sInstallationType4.set(mapInstallation.getString("InstallationType"));
		else if (i==4) sInstallationType5.set(mapInstallation.getString("InstallationType"));
		else if (i==5) sInstallationType6.set(mapInstallation.getString("InstallationType"));
		else if (i==6) sInstallationType7.set(mapInstallation.getString("InstallationType"));
		else if (i==7) sInstallationType8.set(mapInstallation.getString("InstallationType"));
		else if (i==8) sInstallationType9.set(mapInstallation.getString("InstallationType"));
		else if (i==9) sInstallationType10.set(mapInstallation.getString("InstallationType"));
	}
	setCatalogFromPropValues("IO");
	
	if (_kExecuteKey == "ShowDialog")
		showDialog("IO");
	
	String arSInstallationType[0];
	arSInstallationType.append(sInstallationType1);
	arSInstallationType.append(sInstallationType2);
	arSInstallationType.append(sInstallationType3);
	arSInstallationType.append(sInstallationType4);
	arSInstallationType.append(sInstallationType5);
	arSInstallationType.append(sInstallationType6);
	arSInstallationType.append(sInstallationType7);
	arSInstallationType.append(sInstallationType8);
	arSInstallationType.append(sInstallationType9);
	arSInstallationType.append(sInstallationType10);
	
	// Reset the map content
	_Map = Map();
	
	Map mapInstallations;
	for (int i=0;i<nNrOfInstallationPoints;i++) {
		Map mapInstallation;
		mapInstallation.setString("InstallationType", arSInstallationType[i]);
		mapInstallations.appendMap("Installation", mapInstallation);
	}
	_Map.setMap("Installations", mapInstallations);
	
	return;
}


#End
#BeginThumbnail



#End