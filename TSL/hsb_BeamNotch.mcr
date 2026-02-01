#Version 8
#BeginDescription
Create a cut with the shape of the male beam into the female beam, mainly used for profile beams.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 14.10.2014 - version 1.2


#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 0
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2008 by
*  hsbSOFT 
*  IRELAND
*
*  The program may be used and/or copied only with the written
*  permission from hsbSOFT, or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
* REVISION HISTORY
* -------------------------
*
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 19.05.2010
* version 1.0: Release Version
*
* date: 11.02.2011
* version 1.1: Remove bOnInsert so allow the user to insert multiple instances in one go.
*
* date: 14.10.2014
* version 1.2: Add Tolerance.
*/

Unit (1, "mm");

PropDouble dTolerance (0, 0, T("Tolerance"));

//if (_bOnInsert)
//{
//	_Beam.append(getBeam(T("Select Beam to be Notched")));
//	_Beam.append(getBeam(T("Select Beam with will determine the notch")));
//	return;
//}

Beam bmMale=_Beam[1];
Beam bmFemale=_Beam[0];

Body bdTool=bmFemale.envelopeBody(true, true);

PlaneProfile ppShape=bdTool.getSlice(Plane(_Pt0, bmFemale.vecX()));
ppShape.shrink(-dTolerance);

PLine plAll[]=ppShape.allRings();
PLine plForBody=plAll[0];


Body bdForTool(plForBody, bmFemale.vecX()*U(1000), 0);

SolidSubtract sosu(bdForTool);

bmMale.addTool(sosu);

Display dp(-1);
//Display something
double dSize = Unit(5, "mm");
//Display dspl (-1);
PLine pl1(_ZW);
PLine pl2(_ZW);
PLine pl3(_ZW);
Point3d ptDraw=_Pt0;
pl1.addVertex(ptDraw+_XW*dSize);
pl1.addVertex(ptDraw-_XW*dSize);
pl2.addVertex(ptDraw-_YW*dSize);
pl2.addVertex(ptDraw+_YW*dSize);
pl3.addVertex(ptDraw-_ZW*dSize);
pl3.addVertex(ptDraw+_ZW*dSize);
	
dp.draw(pl1);
dp.draw(pl2);
dp.draw(pl3);






#End
#BeginThumbnail





#End