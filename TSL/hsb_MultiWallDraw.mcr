#Version 8
#BeginDescription
Refresh or Delette multiwalls from the model.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 14.11.2013  -  version 1.2













#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2008 by
*  hsbSOFT IRELAND
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
* date: 22.08.2012
* version 1.0: First version
*
* date: 14.11.2013
* version 1.2: Bugfix 
*/

Unit (1, "mm");

PropDouble dOffset (0, U(4000), T("Offset between panels"));

PropString sDimStyle(0, _DimStyles, T("Dimension Style"));
PropDouble dNewTextHeight(1, -1, T("Text Height"));

PropInt nColor(0, -1, T("Text Color"));

if( _bOnInsert )
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
	
	showDialogOnce();

	Group gp;
	Entity allElements[]=gp.collectEntities(true, Element(), _kModel);
	for (int e=0; e<allElements.length(); e++)
	{
		Element el=(Element) allElements[e];
		
		if (el.bIsValid())
		{
			Map mp=el.subMapX("hsb_Multiwall");
			if (mp.length()>0)
			{
				_Element.append(el);
			}
		}
	}

	_Pt0=getPoint("Pick a point");

	return;
}


String strChangeEntity = T("|Refresh Multiwalls|");
addRecalcTrigger(_kContext, strChangeEntity );
if (_bOnRecalc && _kExecuteKey==strChangeEntity)
{
	_Element.setLength(0);
	
	Group gp;
	Entity allElements[]=gp.collectEntities(true, Element(), _kModel);
	for (int e=0; e<allElements.length(); e++)
	{
		Element el=(Element) allElements[e];
		
		if (el.bIsValid())
		{
			Map mp=el.subMapX("hsb_Multiwall");
			if (mp.length()>0)
			{
				_Element.append(el);
			}
		}
	}
}

String strSeparator = T("--------------------------------------");
addRecalcTrigger(_kContext, strSeparator);


String strDeleteEntity = T("|Delete Multiwalls|");
addRecalcTrigger(_kContext, strDeleteEntity);
if (_bOnRecalc && _kExecuteKey==strDeleteEntity)
{
	_Element.setLength(0);
	
	Group gp;
	Entity allElements[]=gp.collectEntities(true, Element(), _kModel);
	for (int e=0; e<allElements.length(); e++)
	{
		Element el=(Element) allElements[e];
		
		if (el.bIsValid())
		{
			Map mp=el.subMapX("hsb_Multiwall");
			if (mp.length()>0)
			{
				el.removeSubMapX("hsb_Multiwall");
				//_Element.append(el);
			}
		}
	}
}

/*
String strDeleteSingleEntity = T("|Delete Single Multiwall|");
addRecalcTrigger(_kContext, strDeleteSingleEntity);
if (_bOnRecalc && _kExecuteKey==strDeleteSingleEntity)
{
	_Element.setLength(0);
	
	Group gp;
	Entity allElements[]=gp.collectEntities(true, Element(), _kModel);
	for (int e=0; e<allElements.length(); e++)
	{
		Element el=(Element) allElements[e];
		
		if (el.bIsValid())
		{
			Map mp=el.subMapX("hsb_Multiwall");
			if (mp.length()>0)
			{
				el.removeSubMapX("hsb_Multiwall");
				_Element.append(el);
			}
		}
	}
}
*/



String elNumber[0];
String mwNumber[0];
int nSequence[0];

Element elSingle[0];

for (int e=0; e<_Element.length(); e++)
{
	Element el=_Element[e];
	Map mp=el.subMapX("hsb_Multiwall");
	
	if ( mp.hasString("Number"))
	{
		elNumber.append(el.number());
		mwNumber.append(mp.getString("Number"));
		nSequence.append(mp.getInt("Sequence"));
		elSingle.append(el);
	}
}


String sMultiwalls[0];
String sSingleElements[0];


for (int i=0; i<mwNumber.length(); i++)
{
	if (sMultiwalls.find(mwNumber[i], -1) != -1)//Already contain a multiwall
	{
		int n=sMultiwalls.find(mwNumber[i], -1);
		if (sSingleElements[n] == "")
		{
			sSingleElements[n]+=elNumber[i];
		}
		else
		{
			sSingleElements[n]+=" - ";
			sSingleElements[n]+=elNumber[i];
		}
	}
	else
	{
	
		sMultiwalls.append(mwNumber[i]);
		sSingleElements.append(elNumber[i]);
	}
}

Display dp(-1);
Display dpText(nColor);
dpText.dimStyle(sDimStyle);

if (dNewTextHeight!=-1)
{
	dpText.textHeight(dNewTextHeight);
}


dpText.draw("Multiwalls", _Pt0, _XW, _YW, 1,1);

CoordSys cs(_Pt0, _XW, _YW, _ZW);

for (int m=0; m<sMultiwalls.length(); m++)
{
	cs.transformBy(-_YW*U(dOffset));
	
	Element elThisMW[0];
	int nThisSquence[0];
	CoordSys csElements[0];
	
	double dDisplacement[0];
	
	//get all the element of this multiwall
	for (int e=0; e<_Element.length(); e++)
	{
		Element el=_Element[e];
		Map mp=el.subMapX("hsb_Multiwall");
		String sMultiwallNumber;
		if ( mp.hasString("Number"))
		{
			sMultiwallNumber=mp.getString("Number");
		}
		if (sMultiwallNumber==sMultiwalls[m])
		{
			elThisMW.append(el);
			nThisSquence.append(mp.getInt("Sequence"));
			Point3d ptElOrg=mp.getPoint3d("PTORG");
			Vector3d vx=mp.getVector3d("VECX");
			Vector3d vy=mp.getVector3d("VECY");
			Vector3d vz=mp.getVector3d("VECZ");
			//CoordSys csEl(ptElOrg, vx, vy, vz);
			//csElements.append(csEl);
			csElements.append(el.coordSys());
			dDisplacement.append(ptElOrg.X());
		}
	}
	
	PLine pln(_ZW);
	pln.createRectangle(LineSeg(cs.ptOrg(), cs.ptOrg()+_XW*U(10000)), _XW, _YW); 
	
	Map mpInformation;
	Map mp;
	for (int e=0; e<elThisMW.length(); e++)
	{
		
		
		Element el=elThisMW[e];
		GenBeam gbmAll[]=el.genBeam();
		CoordSys csEl=csElements[e];
		
		CoordSys csNew;
		csNew.setToAlignCoordSys(csEl.ptOrg(), csEl.vecX(), csEl.vecY(), csEl.vecZ(), cs.ptOrg()+(_XW*dDisplacement[e]), cs.vecX(), cs.vecY(), cs.vecZ());
		

		mp.setString("Number", el.number());
		
		
		for (int i=0; i<gbmAll.length(); i++)
		{
			Entity gbm = (Entity) gbmAll[i];
			//GenBeam gbm = gbmAll[i];
			String sDispRep[]=gbm.dispRepNames();
			
			dp.color(gbm.color());
			
			//Body bd=gbm.envelopeBody();
			//bd.transformBy(csNew);
			//dp.draw(bd);
			
			dp.draw(gbm, csNew, "hsbCAD Model"); // display the entity
			
			dpText.draw(el.number(), cs.ptOrg()+(_XW*dDisplacement[e])-_YW*U(100), _XW, _YW,1,-1);
			
			//PropString pDispRep(0,ent.dispRepNames(),"Disp rep");
		}
	}
}

return;









#End
#BeginThumbnail





#End
