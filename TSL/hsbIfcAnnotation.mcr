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
#MinorVersion 0
#KeyWords 
#BeginContents
if (_bOnInsert)
{
	return;
}


Display dp(-1); // use color of entity
dp.textHeight(U(150)); // specify active textHeight

int bSomethingDrawn = 0;


// get ifc annotation map
Map tslMap = _ThisInst.map();
Map ifcAnnotationMap = tslMap.getMap("ifcAnnotation");  
String annotationType = ifcAnnotationMap.getString("type");	
	
	Map itemsMap = ifcAnnotationMap.getMap("items");
	
	for (int i = 0; i < itemsMap.length(); i++)
	{
		String mapKey = itemsMap.keyAt(i);
		
		if (mapKey == "Pline")
		{
			PLine pline = itemsMap.getPLine(i);
			dp.draw(pline);
			bSomethingDrawn = 1;
		}

		else if (mapKey == "Point")
		{
			Point3d point = itemsMap.getPoint3d(i);
			double pointSize = U(50);
			
			LineSeg lineSeg(point-_XU*pointSize, point+_XU*pointSize);  
			dp.draw(lineSeg);

			LineSeg lineSeg2(point-_YU*pointSize, point+_YU*pointSize);  
			dp.draw(lineSeg2);

			bSomethingDrawn = 1;
		}
		else if (mapKey == "TextLiteral")
		{			
			Map textMap = itemsMap.getMap(i);
			
			String ifcLiteral = textMap.getString("Literal");
			int dXFlag = textMap.getInt("dDXFlag");
			int dYFlag = textMap.getInt("dyFlag");


			double dSizeY = textMap.getDouble("SizeY");
			dp.textHeight(dSizeY); // specify active textHeight

			String path = textMap.getString("Path");
			Point3d location = textMap.getPoint3d("Location");

			
			Vector3d vecX = textMap.getVector3d("vecX");
			Vector3d vecZ = textMap.getVector3d("vecZ");
			Vector3d vecY = vecZ.crossProduct(vecX);
			vecY.normalize();
			
			dp.draw(ifcLiteral, location, vecX, vecY, dXFlag, dYFlag);
			bSomethingDrawn = 1;
		}
}

if (bSomethingDrawn == 0) {
	dp.draw(scriptName(), _Pt0, _XU, _YU, 1, 1);
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
      <lst nm="BREAKPOINTS">
        <int nm="BREAKPOINT" vl="48" />
      </lst>
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End