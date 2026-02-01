#Version 8
#BeginDescription
Assign beams with a specific code to a floor level group specify by a property.

Created by: Alberto Jena (aj@hsb-cad.com)
Date: 29.06.2012 - version 1.3




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 3
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


_ThisInst.setSequenceNumber(-60);

// filter beams with beamcode
PropString sBeamCodeFloor(0,"",T("Beams with beamcode to Group(; - separated list)"));
sBeamCodeFloor.setDescription(T("Fill the Code of the beams that need to be added to the Group describe below, use ; to separate them"));

//PropString sGrpNm0(7, "House Level", T("House Level group name"));
PropString sGrpNm1(1, "00_GF-Soleplates", T("House Level group name"));
sGrpNm1.setDescription("House group or empty will select the house level of the element that is selected");
PropString sGrpNm2(2, "GF-Loose", T("Floor Level group name"));
sGrpNm2.setDescription("");

// Load the values from the catalog
if (_bOnDbCreated || _bOnInsert) setPropValuesFromCatalog(_kExecuteKey);

String sBCFloor = sBeamCodeFloor + ";";
String arSBCFloor[0];
int nIndexBC = 0; 
int sIndexBC = 0;
while(sIndexBC < sBCFloor.length()-1)
{
	String sTokenBC = sBCFloor.token(nIndexBC);
	nIndexBC++;
	if(sTokenBC.length()==0)
	{
		sIndexBC++;
		continue;
	}
	sIndexBC = sBCFloor.find(sTokenBC,0);
	
	arSBCFloor.append(sTokenBC);
}

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
	lstPropString.append(sBeamCodeFloor);
	lstPropString.append(sGrpNm1);
	lstPropString.append(sGrpNm2);
	
	for (int i=0; i<_Element.length(); i++)
	{
		lstEnts.setLength(0);
		lstEnts.append(_Element[i]);
		tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString);
	}

	eraseInstance();
	return;
}

//Check if there is an element selected.
if( _Element.length() == 0 ){eraseInstance(); return; }

Element el = _Element[0];

if (sGrpNm1=="")
{
	Group gpEl=el.elementGroup();
	String sPart1=gpEl.namePart(0);
	sGrpNm1.set(sPart1);
}

if (sGrpNm1=="" && sGrpNm2=="")
{
	reportMessage("Group Name not valid to assign the beams");
	eraseInstance();
	return;
}

Group gpToAssign(sGrpNm1+"\\"+sGrpNm2);

Beam bmAll[]=el.beam();

int nErase=false;

//Check beams from this element are in the group
String sThisHandle=el.handle();
Entity ent[]=gpToAssign.collectEntities(false, Beam(), _kModel);

for(int i=0;i<ent.length();i++ )
{
	Map mpEnt=ent[i].subMapX("Assign");
	if (mpEnt.hasString("ElementHandle"))
	{
		String sHandle=mpEnt.getString("ElementHandle");
		if (sHandle == sThisHandle)
			ent[i].dbErase();
	}
}


/*

if (bmAll.length()>0)
{
	_Entity.append(bmAll[0]);
	setDependencyOnEntity(bmAll[0]);
}
else
{
	if (_Map.hasEntity("bm"))
	{
		for(int i=0;i<_Map.length();i++ )
		{
			if (_Map.keyAt(i)=="bm")
			{
				Entity ent=_Map.getEntity(i);
				if (ent.bIsValid())
				{
					ent.dbErase();
				}
			}
		}
	}
	_Map=Map();
}

*/


for( int i=0;i<bmAll.length();i++ )
{
	Beam bm = bmAll[i];
	String sBmCode = bm.beamCode().token(0);

	if( arSBCFloor.find(sBmCode ) != -1 )
	{
		gpToAssign.addEntity(bm ,TRUE);
		Map mp;
		mp.setString("ElementHandle", sThisHandle);
		bm.setSubMapX("Assign", mp);
	}
}

if (_bOnElementConstructed || nErase)
{
	eraseInstance();
	return;
}


#End
#BeginThumbnail




#End
