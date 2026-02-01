#Version 8
#BeginDescription
version  value="1.0" date="13dec13" author="th@hsbCAD.de"> 
initial

This tsl creates marker lines on each edge of the contacting plane of a t-connection

Insert
/// Select marking beam(s), then select beams to be marked.
/// The insert is done without a dialog shown. One can modify the length of the marker lines as follows:
/// 	individual: select an instance of this tsl in the drawing and change the length property
/// 	set the default value: select an instance of this tsl in the drawing and change the length property, then save the catalog entry _LastInserted
/// 	multiple values: select an instance of this tsl in the drawing and change the length property, then save it with a catalog name (i.e. mySettings), 
///	   create a tool button with the catalog name, i.e. ^C^C(hsb_scriptinsert"hsbT-CornerMarking.mcr" "mySettings")
#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 0
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/// <summary>
/// This tsl creates marker lines on each edge of the contacting plane of a t-connection
/// </summary>

/// <insert>
/// Select marking beam(s), then select beams to be marked.
/// The insert is done without a dialog shown. One can modify the length of the marker lines as follows:
/// 	individual: select an instance of this tsl in the drawing and change the length property
/// 	set the default value: select an instance of this tsl in the drawing and change the length property, then save the catalog entry _LastInserted
/// 	multiple values: select an instance of this tsl in the drawing and change the length property, then save it with a catalog name (i.e. mySettings), 
///	   create a tool button with the catalog name, i.e. ^C^C(hsb_scriptinsert"hsbT-CornerMarking.mcr" "mySettings")
/// </insert>

/// History
/// <version  value="1.0" date="13dec13" author="th@hsbCAD.de"> initial </version>

// basics and props
	U(1,"mm");
	double dEps = U(0.1);
	
	String sNameMarkerLength = T("|Marker Length|");
	String sMalePrompts[] = { T("|Select marking beams|")};
	String sFemalePrompts[] = {T("|Select beams to be marked|")};
	PropDouble dMarkerLength (0, U(30),sNameMarkerLength );
	dMarkerLength .setDescription(T("|Defines length of the marker line, overlapping segments will be combined.|"));
	
// on creation assign properties from valid catalog entry 
	if (_bOnDbCreated)
	{
		String sEntries[] = _ThisInst.getListOfCatalogNames(scriptName());	
		for (int i=0;i<sEntries.length();i++)
			sEntries[i].makeUpper();
		String sKey = _kExecuteKey.makeUpper();
		reportMessage("\n"+sKey + " vs"+ sEntries);
		int n = sEntries.find(sKey);
		if (_kExecuteKey.length()>0 && n>-1)
			setPropValuesFromCatalog(sEntries[n]);
		

	}
	
// assign beams
	Beam bm0 = _Beam[0];
	Beam bm1 = _Beam[1];
	
// Display
	Display dp(1);	
	
// corner points
	Point3d pts[] = {_Pt1,_Pt2,_Pt3,_Pt4};	
	
	for (int i=0;i<pts.length();i++)
	{
		int x = i+1;
		if (i==pts.length()-1)x=0;
		Vector3d vecX = pts[x]-pts[i];
		double d = vecX.length();
		vecX.normalize();
		
		if (2*dMarkerLength>= d)
		{
			MarkerLine ml1(pts[i], pts[x], -_Z1);
			bm1.addTool(ml1);	
			dp.draw(PLine(pts[i], pts[x]));	
		}
		else
		{
			MarkerLine ml1(pts[i],pts[i] + vecX*dMarkerLength, -_Z1);
			bm1.addTool(ml1);		
			MarkerLine ml2(pts[x], pts[x] - vecX*dMarkerLength, -_Z1);
			bm1.addTool(ml2);	
				
			dp.draw(PLine(pts[i],pts[i] + vecX*dMarkerLength));
			dp.draw(PLine(pts[x], pts[x] - vecX*dMarkerLength));			
		}
	}
		
	
#End
#BeginThumbnail
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
3*/TJ:U6I!*[W[%4J<)/3\3__V7&U
`

#End
