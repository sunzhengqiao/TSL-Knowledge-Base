#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@itwindustry.nl)
23.12.2013  -  version 1.00

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
/// This tsl creates a dovetail connection between a beam and a CLT panel.
/// </summary>

/// <insert>
/// Select beam, select panel
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.00" date="23.12.2013"></version>

/// <history>
/// AS - 1.00 - 23.12.2013 -	First revision
/// </history>



Unit(0.001, "mm");

PropString sSeperator01(0, "", T("|Dovetail|"));
sSeperator01.setReadOnly(true);
PropDouble dXWidth(0, U(40), "     "+T("|Width|"));
PropDouble dYHeight(1, U(80), "     "+T("|Height|"));
PropDouble dZDepth(2, U(20), "     "+T("|Depth|"));
PropDouble dAlfa(3, 20, "     "+T("|Angle|")); // in degrees


if (_bOnInsert) {
	_GenBeam.append(getBeam(T("|Select beam|")));
	_GenBeam.append(getGenBeam(T("|Select panel|")));
	
	return;
}

if (_GenBeam.length() < 2){
	reportMessage(T("|Invalid number of genbeams selected|!"));
	eraseInstance();
	return;
}

Beam bm = (Beam)_GenBeam[0];
if (!bm.bIsValid()) {
	reportMessage(T("|The selected beam is not valid|!"));
	eraseInstance();
	return;
}

Sip sip = (Sip)_GenBeam[1];
if (!sip.bIsValid()) {
	reportMessage(T("|The selected panel is not valid|!"));
	eraseInstance();
	return;
}

Point3d ptSip = sip.ptCen();

CoordSys csBm = bm.coordSys();
Point3d ptBm = bm.ptCen();
Vector3d vxBm = csBm.vecX();
if (vxBm.dotProduct(ptSip - ptBm) < 0)
	vxBm *= -1;
Line lnBmX(ptBm, vxBm);

Vector3d vzSip = sip.vecZ();
if( vzSip.dotProduct(ptSip - ptBm) < 0)
	vzSip *= -1;


Plane pnSipZ(ptSip, vzSip);

_Pt0 = lnBmX.intersect(pnSipZ, -0.5 * sip.dH());

Vector3d vecZ = vzSip;
Vector3d vecY = bm.vecD(_ZW);
Vector3d vecX = vecY.crossProduct(vecZ);

Point3d ptDoveTail = _Pt0 + 0.5 * vecY * bm.dD(vecY);
Dove doveTail(ptDoveTail,vecX,vecY,vecZ,dXWidth,dYHeight,dZDepth, dAlfa,_kFemaleSide);
sip.addTool(doveTail);
doveTail.setEndType(_kMaleEnd);
bm.addTool(doveTail, _kStretchOnInsert);

setMarbleDiameter(U(1));

#End
#BeginThumbnail

#End
