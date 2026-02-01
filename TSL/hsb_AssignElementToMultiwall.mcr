#Version 8
#BeginDescription
Assigns an element to a multiwall number and sets a sequence number based on selection.
To be used in conjunction with the exporter's multiwall extension

Modified by: Chirag Sawjani(csawjani@itw-industry.com)
Date: 14.03.2012  -  version 1.0


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
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2012 by
*  ITW-INDUSTRY
*  UK
*
*  The program may be used and/or copied only with the written
*  permission from hsbSOFT, or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
* REVISION HISTORY
* --------------------------------
*
* Modified by: Chirag Sawjani(csawjani@itw-industry.com)
* Date: 14.03.2012
* version 1.0: Release version
*
* Modified by: Chirag Sawjani(csawjani@itw-industry.com)
* Date: 21.03.2012
* version 1.1: Re-instated export to the bill of materials checkbox as it is not allowing mapx to be written
*/

Unit(1,"mm"); // script uses mm

PropString strPrefix(0,1,"Enter the prefix number");
PropString sDimStyle(1, _DimStyles, T("Dim style"));

PropInt nSequence(0,0,"Sequence Number");
nSequence.setReadOnly(TRUE);
// Load the values from the catalog
if (_bOnDbCreated || _bOnInsert) setPropValuesFromCatalog(_kExecuteKey);

if(_bOnInsert){
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	if (_kExecuteKey=="")
		showDialogOnce();
		

		PrEntity ssE (T("Please select Walls"),ElementWall());
		if (ssE.go())
		{
 			Entity ents[0];
 			ents = ssE.set();
		
 			for (int i = 0; i < ents.length(); i++ )
			 {
 				Element el = (Element) ents[i];
				if (el.bIsValid()) {
 					_Element.append(el);
				}	
 			 }
		}
		if (_Element.length()==0) 
		{
			reportMessage("No valid object selected");
			eraseInstance();
			return;
		}
		
			
		//Clonning TSL 
		TslInst tsl;
		String sScriptName = scriptName(); // name of the script
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		Entity lstEnts[0];
		Beam lstBeams[0];
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		lstPropString.append(strPrefix);
		lstPropString.append(sDimStyle);
	
	
		Map mpToClone;
		mpToClone.setInt("nExecutionMode", 1);
	
		for (int e=0; e<_Element.length(); e++)
		{
			Element el=_Element[e];
			TslInst tslIns[]=_Element[e].tslInstAttached();
			for(int i=0;i<tslIns.length();i++)
			{
				TslInst tslCurr=tslIns[i];
				if(tslCurr.scriptName()!=scriptName())
				{
					continue;
				}
				if (tslIns[i].scriptName()==scriptName() && tslIns[i].handle()!=_ThisInst.handle())
				{
					tslCurr.dbErase();
				}
			}
			
			mpToClone.setString("Handle",el.handle());
			
			lstEnts.setLength(0);
			lstPropInt.setLength(0);
			
			//reportNotice("\n"+(e+1));
			lstEnts.append(el);
			lstPropInt.append(e+1);
			tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,	lstPropInt, lstPropDouble,lstPropString, _kModel, mpToClone);
		}
		eraseInstance();
		return;
}

int nExecutionMode=0;
if (_Map.hasInt("nExecutionMode"))
{
	nExecutionMode=_Map.getInt("nExecutionMode");
}
if(nExecutionMode)
{
	 nSequence.setReadOnly(FALSE);
}
else
{
	nSequence.setReadOnly(TRUE);
}

Display dp(-1);
dp.dimStyle(sDimStyle);

ElementWall eWalls[0];
for (int i=0; i<_Element.length(); i++) 
{
	ElementWall ewTemp=(ElementWall) _Element[i];
	if (ewTemp.bIsValid()) 
	{
		eWalls.append(ewTemp);
	} 
}

Map mpMultiwall;


for(int e=0;e<eWalls.length();e++)
{
	String sHandle;
	if(_Map.hasString("Handle"))
	{
		sHandle=_Map.getString("Handle");
	}
	
	Element el=eWalls[e];
	
	if(el.handle()!=sHandle)continue;
	
	CoordSys csEl = el.coordSys();
	Vector3d vx = csEl.vecX();
	Vector3d vy = csEl.vecY();
	Vector3d vz = csEl.vecZ();
	
	if (!_Map.hasInt("nSetOrg"))
	{
		_Pt0=csEl.ptOrg()+vx*U(100)+vz*U(100);
	}
	

	_Map.setInt("nSetOrg", TRUE);
	
	Plane pln(csEl.ptOrg(), _ZW);
	_Pt0=pln.closestPointTo(_Pt0);


	String sSequence;
	sSequence.format(nSequence,'i');
	String sMultiwallDisplay=strPrefix+"-"+sSequence;
	dp.draw(sMultiwallDisplay, _Pt0, vx, -vz, 0, 0);
	
	mpMultiwall.setString("Number",strPrefix);
	mpMultiwall.setInt("Sequence",nSequence);
	
	//Set the MapX with the map
	_ThisInst.setSubMapX("hsb_Multiwall",mpMultiwall);

	
	assignToElementGroup(el,true,0,'T');

	
}


#End
#BeginThumbnail



#End
