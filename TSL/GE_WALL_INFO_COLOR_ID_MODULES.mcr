#Version 8
#BeginDescription
Identifies modules in wall with colors and text in belonging beams
v1.1: 10.jul.2013: David Rueda (dr@hsb-cad.com)
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
/*
  COPYRIGHT
  ---------------
  Copyright (C) 2011 by
  hsbSOFT 

  The program may be used and/or copied only with the written
  permission from hsbSOFT, or in accordance with
  the terms and conditions stipulated in the agreement/contract
  under which the program has been supplied.

  All rights reserved.

 REVISION HISTORY
 -------------------------

 v1.0: 10.jul.2013: Kris Riemslagh (kr@hsb-cad.com)
	- Release
 v1.1: 10.jul.2013: David Rueda (dr@hsb-cad.com)
	- Renamed from ShowModule to GE_WALL_INFO_COLOR_ID_MODULES
	- Thumbnail added
	- Description added
*/

Unit(1,"mm");

if (_bOnInsert) {
	_Element.append(getElement());

	TslInst tlsAll[]=_Element[0].tslInstAttached();
	for (int i=0; i<tlsAll.length(); i++)
	{
		String sName = tlsAll[i].scriptName();
		if (sName == scriptName() && tlsAll[i].handle()!= _ThisInst.handle())
		{
			tlsAll[i].dbErase();
		}
	}
	return;
}

if (_Element.length()==0 || !_Element[0].bIsValid()) {
	eraseInstance();
	return;
}

Element el = _Element[0];
assignToElementGroup(el,1);
_Pt0 = el.ptOrg();


Beam arBm[] = el.beam();
String arMod[0];

Display dp(-1);
dp.textHeight(U(20));

for (int b=0; b<arBm.length(); b++) {
	Beam bm = arBm[b];
	String strMod = bm.module();
	dp.draw(strMod,bm.ptCen(),bm.vecX(),bm.vecY(),0,0);
	
	// collect modules
	if (arMod.find(strMod)==-1)
		arMod.append(strMod);
}

if (arBm.length()==0) {
	dp.draw(scriptName(),_Pt0, _ZW,-_XW,0,0);
}

int nColor = 1;

for (int m=0; m<arMod.length(); m++) 
{
	String strMod = arMod[m];
	Beam arBmMod[0];
	
	for (int b=0; b<arBm.length(); b++)
		if (arBm[b].module()==strMod)
			arBmMod.append(arBm[b]);

	dp.color(nColor++);	
	for (int b=0; b<arBmMod.length(); b++)
		dp.draw(arBmMod[b].envelopeBody());
}

#End
#BeginThumbnail
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
IHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`__]FB
`

#End
