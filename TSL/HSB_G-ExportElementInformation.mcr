#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
26.09.2016  -  version 1.00












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
/// <summary Lang=en>
/// This tsl creates a dxf file with element information. 
/// </summary>

/// <insert>
/// Select a set of element information tsls.
/// </insert>

/// <remark Lang=en>
/// HSB_G-ElementInformation
/// </remark>

/// <version  value="1.00" date="26.09.2016"></version>

/// <history>
/// AS - 1.00 - 26.09.2016 - Pilot version
/// </history>

String categories[] = {
	T("Dxf output")
};

int outputVersions[] = {_kVersionCurrent, _kVersion2000, _kVersion2004, _kVersion2007, _kVersion2010 };
PropInt outputVersion(0, outputVersions, T("|Dxf version|"));
outputVersion.setCategory(categories[0]);
outputVersion.setDescription(T("|Sets the format the Dxf file is saved to. Leave it to '0' if you want to save it to the current version.|"));

PropString fileName(0, "", T("|Filename|"));
fileName.setCategory(categories[0]);
fileName.setDescription(T("|Sets the filename of the dxf file.|"));

if( _bOnInsert ){
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	showDialog();
	
	PrEntity ssE(T("|Select the element information tsls|"), TslInst());
	if (ssE.go()) {
		Entity selectedEntities[] = ssE.set();
		
		Display dxfFile(-1);
		for (int e=0;e<selectedEntities.length();e++) {
			TslInst elementInformation = (TslInst)selectedEntities[e];
			if (!elementInformation.map().hasMap("Dxf"))
				continue;
			
			Map dxfMap = elementInformation.map().getMap("Dxf");
			for (int m=0;m<dxfMap.length();m++) {
				if (dxfMap.hasMap(m) && dxfMap.keyAt(m) == "Text") {
					Map textMap = dxfMap.getMap(m);
					String text = textMap.getString("Text");
					Point3d position = textMap.getPoint3d("Position");
					Vector3d xDirection = textMap.getPoint3d("VecX");
					Vector3d yDirection = textMap.getPoint3d("VecY");
					
					double xFlag = 0;
					double yFlag = 0;
					
					dxfFile.draw(text, position, xDirection, yDirection, xFlag, yFlag);
				}
				
				if (dxfMap.hasPLine(m) && dxfMap.keyAt(m) == "PLine") {
					PLine pline = dxfMap.getPLine(m);
					
					dxfFile.draw(pline);
				}
			}
		}
		
		String fullPath = _kPathDwg +"\\"+ fileName + ".dxf";
		dxfFile.writeToDxfFile(fullPath, true, outputVersion);
		
		if (findFile(fullPath) == fullPath)
			reportMessage(TN("|File created|: ") + fullPath);
		else
			reportMessage(TN("|File could not be created|: ") + fullPath);
	}

	eraseInstance();
	return;
}	













#End
#BeginThumbnail

#End