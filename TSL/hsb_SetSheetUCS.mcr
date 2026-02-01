#Version 8
#BeginDescription
#Versions:
1.1 06.04.2022 HSB-15147: Erase TSL after sheets vector X is set Author: Marsel Nakuci


This TSL will modify the X direction of sheets for floor elements
If the sheet plane lies at the plane of the element then
the vector X of sheet will be set in the same direction as the VecX of the element



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
/// 
/// </summary>

/// <insert>
/// 
/// This TSL will modify the X direction of sheets for floor elements
/// If the sheet plane lies at the plane of the element then
/// the vector X of sheet will be set in the same direction as the VecX of the element
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>
/// #Versions:
// 1.1 06.04.2022 HSB-15147: Erase TSL after sheets vector X is set Author: Marsel Nakuci
/// <version  value="1.00" date="08.12.2021"></version>

/// <history>
/// AJ - 1.00 - 08.12.2021 -	First revision
/// </history>


if( _bOnInsert ){
	if( insertCycleCount()> 1){
		eraseInstance();
		return;
	}
	
	PrEntity ssE(T("|Select a set of elements|"), Element());
	if (ssE.go())
		_Element.append(ssE.elementSet());
	
	return;	
}

Display dp(1);
double dSize = U(250);
dp.textHeight(0.5 * dSize);

String arSText[] = {
	"X",
	"Y",
	"Z"
};
int arColor[] = {
	1,
	3,
	150
};
_Pt0 = _Element[0].ptOrg();
for (int e=0;e<_Element.length();e++) 
{
	Sheet shAll[] = _Element[e].sheet();
	CoordSys csEl = _Element[e].coordSys();
	Vector3d vx = csEl.vecX();
	Vector3d vz = csEl.vecZ();
	
	int iNrSheetsModified;
	for (int i = 0; i < shAll.length(); i++)
	{
		Sheet sh = shAll[i];
		CoordSys csEnt = sh.coordSys();
		if (abs(csEnt.vecZ().dotProduct(vz))>0.99)
		{ 
			sh.setXAxisDirectionInXYPlane(vx);
			iNrSheetsModified++;
		}
		
//		Vector3d arVector[] = {
//			csEnt.vecX(),
//			csEnt.vecY(),
//			csEnt.vecZ()
//		};
//		sh.coordSys().ptOrg().vis(1);
//		Point3d ptDraw = sh.ptCen();
//		ptDraw+=csEnt.vecZ()*csEnt.vecZ().dotProduct(csEnt.ptOrg()-ptDraw);
//		for (int j = 0; j < arVector.length(); j++) {
//			Vector3d vector = arVector[j];
//			String sText = arSText[j];
//			
//			dp.color(arColor[j]);
//			
////			LineSeg lnSeg(csEnt.ptOrg(), csEnt.ptOrg() + vector * dSize);
//			LineSeg lnSeg(ptDraw, ptDraw + vector * dSize);
//			dp.draw(lnSeg);
//			
//			PLine plCircle(vector);
////			plCircle.createCircle(csEnt.ptOrg() + vector * 0.85 * dSize, vector, 25);
//			plCircle.createCircle(ptDraw + vector * 0.85 * dSize, vector, 25);
//			dp.draw(plCircle);
//			
////			dp.draw(sText, csEnt.ptOrg() + vector * dSize, _XU, _YU, 1.25, 1.25, _kDevice);
//			dp.draw(sText, ptDraw + vector * dSize, _XU, _YU, 1.25, 1.25, _kDevice);
//		}
	}
	
	reportMessage("\n"+scriptName()+" "+T("|Nr sheets modified from element|")+" "+_Element[e].number()+" "+T("|is|")+": "+iNrSheetsModified);
	
}
eraseInstance();
return;


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
      <str nm="COMMENT" vl="HSB-15147: Erase TSL after sheets vector X is set" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="4/6/2022 4:15:40 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End