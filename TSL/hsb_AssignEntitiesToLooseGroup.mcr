#Version 8
#BeginDescription
Assign entities to a loose group.

Created by: Alberto Jena (aj@hsb-cad.com)
Date: 27.02.2019 - version 1.6
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 6
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
* date: 25.11.2010
* version 1.0: Release Version
*
* date: 28.11.2010
* version 1.1: Look for the Electrical TSL that could be attach to the loose sheets and it's setting them as a NO Tool by keeping the display
*
* date: 31.03.2016
* version 1.3: Fix issue where the naillines that were part of the sheets that were assing to loose were not removed from the element.
*/

PropString sName (0, "", T("|New name for the entity|"));
sName.setDescription(T("|If the name is set, it will overwrite the current name of the entity|"));

PropInt nColor(0, -1, T("Color to set on the entities"));
nColor.setDescription(T("Set the color of the entities, (-1) will keep the existing color"));

//Insert
if( _bOnInsert )
{
	if( insertCycleCount()>1 ){eraseInstance(); return;}
	
	PrEntity ssE(T("\nSelect beams/sheets to set loose"), GenBeam());
	
	if (_kExecuteKey=="")
		showDialogOnce();
	
	if( ssE.go() )
	{
		Entity ent[]=ssE.set();
		for (int i=0; i<ent.length(); i++)
		{
			GenBeam gb=(GenBeam) ent[i];
			
			if (gb.bIsValid())
			{
				_Entity.append(gb);
			}
		}
	}
	
	return;
}



//Check if there is an element selected.
if( _Entity.length() == 0 ){eraseInstance(); return; }

int nErase=false;

//reportNotice("\n"+_GenBeam.length());

Element elAll[0];
String sAllHandle[0];

int nValidZones[]={1,2,3,4,5,6,7,8,9,10};
int nRealZones[]={1,2,3,4,5,-1,-2,-3,-4,-5};

String entitiesMarkedLoose[0];
for (int g=0; g<_Entity.length(); g++)
{
	GenBeam gb=(GenBeam) _Entity[g];

	if(!gb.bIsValid()) continue;

	Element el = gb.element();
	
	if (!el.bIsValid()) continue;
	
	CoordSys cs=el.coordSys();
	Vector3d vx=cs.vecX();
	Vector3d vy=cs.vecY();
	Vector3d vz=cs.vecZ();
	Point3d ptEl=cs.ptOrg();
	_Pt0=ptEl;
	int nThisGBZone=gb.myZoneIndex();
	int nZone=nValidZones[nRealZones.find(nThisGBZone, 0)];

	String sThisHandle=el.handle();
	
	Group gpEl=el.elementGroup();
	String sGrpNm1=gpEl.namePart(0);

	Group gpToAssign(sGrpNm1+"\\" + "Loose");

	gpToAssign.addEntity(gb, TRUE);
	entitiesMarkedLoose.append(gb.handle());
	
	if (nColor != -1)
	{ 
		gb.setColor(nColor);
	}
	
	if (sName!="")
	{ 
		gb.setName(sName);
	}
	
	if (sAllHandle.find(sThisHandle, -1) == -1)
	{
		elAll.append(el);
		sAllHandle.append(sThisHandle);
		gpToAssign.setBIsDeliverableContainer(true);
	}
	
	Map mp;
	mp.setString("ElementHandle", sThisHandle);

	gb.setSubMapX("Assign", mp);

	nErase=true;
	
	//Get the plane profile of the object and if the milling TSL is part of that are then i should set that to no Tool
	
	Plane plnZ (ptEl, vz);
	PlaneProfile pp (plnZ);
	pp=gb.realBody().shadowProfile(plnZ);
	pp.shrink(-U(2));
	//Collect all the TSLs that are part of this wall
	TslInst tslAll[]=el.tslInstAttached();
	for (int t=0; t<tslAll.length(); t++)
	{
		TslInst tsl=tslAll[t];
		int nTSLZone=tsl.propInt(0);
		String name = tsl.scriptName();
		if (name=="CCG_ElectricalSockets" && nTSLZone==nZone)
		{
			Map mp=tsl.map();
			if (mp.hasPLine("plSocket"))
			{
				PLine pl=mp.getPLine("plSocket");
				PlaneProfile ppSocket(plnZ);
				ppSocket.joinRing(pl, false);
				ppSocket.intersectWith(pp);
				if (ppSocket.area()/U(1)*U(1) > U(2)*U(2))
				{
					tsl.setPropString(4, "No");
					tsl.transformBy(_XW*U(0));
				}
			}
		}
	}
	
	NailLine nlAll[] = el.nailLine(nThisGBZone);
	for (int n=0; n<nlAll.length(); n++)
	{
		NailLine nl = nlAll[n];
		PLine plPathNL=nl.plPath();
		Point3d ptAllPoint[]=plPathNL.vertexPoints(true);
		for (int i=0; i<ptAllPoint.length(); i++)
		{
			Point3d ptThis=ptAllPoint[i];
			ptThis.vis(1);
			if (pp.pointInProfile(ptThis)==_kPointInProfile)
			{
				nl.dbErase();
				break;
			}
		}
	}
}

if (elAll.length()>0)
{
	//Insert the TSL again for each Element
	TslInst tsl;
	String sScriptName = "hsb_ManageLooseGroupEntities"; // name of the script
	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	
	Entity lstEnts[0];
	Beam lstBeams[0];
	Point3d lstPoints[0];
	int lstPropInt[0];
	String lstPropString[0];
	double lstPropDouble[0];
	
	for (int i=0; i<elAll.length(); i++)
	{
		lstEnts.setLength(0);
		lstEnts.append(elAll[i]);
		tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString);
	}
}


//Check for any TSLs that have dependencies and need to recalculate
for (int i = 0; i < elAll.length(); i++)
{
	Element el = elAll[i];
	TslInst tslInstances[] = el.tslInst();
	//Check for dependency map
	for(int x =0 ; x < tslInstances.length() ; x++)
	{ 
		TslInst instance = tslInstances[x];
		String name = instance.scriptName();
		Map tslMap = instance.map();
		if(tslMap.hasMap("DependantEntity[]"))
		{ 
			Map dependantEntityArrayMap = tslMap.getMap("DependantEntity[]");
			int test = dependantEntityArrayMap.length();
			for(int m = 0 ; m < dependantEntityArrayMap.length() ; m++)
			{ 
				if (dependantEntityArrayMap.keyAt(m) != "DependantEntity") continue;
				Map dependantEntityMap = dependantEntityArrayMap.getMap(m);
				Entity en = dependantEntityMap.getEntity("Entity");
				
				String sHandle = en.handle();
	
				if (entitiesMarkedLoose.find(sHandle) == -1) continue;
				
				instance.recalc();
				break;
			}
		}
	}
}

eraseInstance();
return;

#End
#BeginThumbnail







#End