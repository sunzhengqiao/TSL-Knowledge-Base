#Version 8
#BeginDescription

Created by: Alberto Jena (aj@hsb-cad.com)
Date: 25.10.2012 - version 1.0

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 0
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
* date: 08.11.2010
* version 1.0: Release Version
*
* date: 02.09.2011
* version 1.1: Add sequence number
*
* date: 05.09.2011
* version 1.2: Add sequence number
*
* date: 28.06.2012
* version 1.3: It will remove the entities that were link to the same wall
*/


_ThisInst.setSequenceNumber(-40);

// Load the values from the catalog
if (_bOnDbCreated || _bOnInsert) setPropValuesFromCatalog(_kExecuteKey);

//Insert
if( _bOnInsert )
{
	if( insertCycleCount()>1 ){eraseInstance(); return;}
	
	if (_kExecuteKey=="")
		showDialogOnce();
	
	PrEntity ssE(T("\nSelect a set of elements"),Element());
	
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	
	//Insert the TSL again for each Element
	TslInst tsl;
	String sScriptName = scriptName(); // name of the script
	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	Entity lstEnts[0];
	Beam lstBeams[0];
	Point3d lstPoints[0];
	int lstPropInt[0];
	String lstPropString[0];
	double lstPropDouble[0];
	
	for (int i=0; i<_Element.length(); i++)
	{
		lstEnts.setLength(0);
		lstEnts.append(_Element[i]);
		tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString);
	}

	eraseInstance();
	return;
}


if (_Element.length()!=0)
{
	Element el=_Element[0];
	
	String sHandle=el.handle();
	
	Group gp=el.elementGroup();
	String sGroup=gp.name();
	
	String sGrpNm1=gp.namePart(0);
	
	Group gpToAssign(sGrpNm1+"\\"+"Loose");

	_Map.setString("sHandle", sHandle);
	_Map.setString("sGroup", gpToAssign);
	
	
	TslInst tslAll[]=el.tslInstAttached();
	for (int i=0; i<tslAll.length(); i++)
	{
		if ( tslAll[i].scriptName() == scriptName() && tslAll[i].handle() != _ThisInst.handle() )
		{
			tslAll[i].dbErase();
		}
	}
	assignToElementGroup(el, true, 0, 'E');
	setDependencyOnEntity(el);
	
	_Pt0 = el.ptOrg();
}


if (_bOnElementDeleted || _bOnElementConstructed || _bOnElementListModified) 
{
	String sHandle;
	String sGroup;
	if ( _Map.hasString("sHandle") )
		sHandle=_Map.getString("sHandle");
	if ( _Map.hasString("sGroup") )
 		sGroup=_Map.getString("sGroup");
	
	if (sHandle!="" && sGroup!="")
	{
		Group gpThisEl(sGroup);
		Entity entAll[] = gpThisEl.collectEntities(true, GenBeam(), _kModel);
		
		for (int i=0; i<entAll.length(); i++)
		{
			Map mpEnt=entAll[i].subMapX("Assign");
			if (mpEnt.hasString("ElementHandle"))
			{
				String sThisHandle=mpEnt.getString("ElementHandle");
				if (sThisHandle== sHandle)
				{
					entAll[i].dbErase();
					//reportNotice("\nDelete");
				}
			}
		}
	}
}

//reportNotice("\nManager");

//Check if there is an element selected.
if( _Element.length() == 0 )
{
	eraseInstance();
	return;
}

Display dp(-1);
dp.showInDispRep("ASD");
dp.draw(scriptName(), _Pt0, _XW, _YW, 1, 1);




#End
#BeginThumbnail

#End
