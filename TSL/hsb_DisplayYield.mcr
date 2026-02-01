#Version 8
#BeginDescription
Last modified by: Alberto Jena (aj@hsb-cad.com)
18.10.2011  -  version 1.0






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
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2009 by
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
* date: 18.10.2011
* version 1.0: Prototype
*
*/

PropString pDimStyle(1,_DimStyles ,"Dim style");
PropDouble pTextHeight(0,U(1000),"Text height");

U(1,"mm");
if (_bOnInsert)
{
	//showDialogOnce();
	_Pt0 = getPoint(); // select point
	
	PrEntity ssE(T("|Select Master Panels|"), MasterPanel());
	if (ssE.go()) {
		Entity ssBeams[] = ssE.set();
		for (int i=0; i<ssBeams.length(); i++)
		{
			_Entity.append(ssBeams[i]);
		}
	}
	return;
}

if (_Entity.length()==0) return;

MasterPanel mpAll[0];

for (int i=0; i<_Entity.length(); i++)
{
	MasterPanel mp = (MasterPanel)_Entity[i];
	if (mp.bIsValid())
	{
		mpAll.append(mp);
	}
}

double dAllYields=0;
for (int i=0; i<mpAll.length(); i++)
{	
	MasterPanel mp=mpAll[i];
	mp.transformBy(-_ZW*U(10));
	mp.updateYield();
	double dThisYield=mp.dYield();
	dAllYields+=dThisYield;
	mp.transformBy(+_ZW*U(10));
}

// display the lines
Display dp(-1);
dp.dimStyle(pDimStyle);
dp.textHeight(pTextHeight);

dAllYields=dAllYields/mpAll.length();

dAllYields=dAllYields*100;
dAllYields+=9.307166221;

//dAllYields=100-dAllYields;

dp.draw("Yield: "+dAllYields+"%",_Pt0,_XU, _YU, 1,1);






#End
#BeginThumbnail




#End