#Version 8
#BeginDescription
 v1.3: 06.07.2014: David Rueda (dr@hsb-cad.com)
Replaces actual blocking runs with new ones that connect properly to new/deleted/relocated studs in selected wall(s).
PLEASE NOTICE: This TSL makes the reading of blocking runs present in wall(s), then it will insert a new instance of GE_WALL_SECTION_BLOCKING to replace found lines.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
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

 v1.3: 06.07.2014: David Rueda (dr@hsb-cad.com)
	- Display text only on DEBUG mode
 v1.2: 02.oct.2013: David Rueda (dr@hsb-cad.com)
	- TSL won't stop doing working and display if it does not find blocking in element
 v1.1: 30.jul.2013: David Rueda (dr@hsb-cad.com)
	- Erase al previous CHILDREN TLS's inserted by THIS or OTHER instance of this TSL
 v1.0: 18.jul.2013: David Rueda (dr@hsb-cad.com)
	- Release
*/

U(1, "inch"); // Script uses inches
String sChildTSL="GE_WALL_SECTION_BLOCKING";
String sLn="\n";

if(_bOnInsert)
{
	if( insertCycleCount()>1 )
	{
		eraseInstance();
		return;
	}
	
	PrEntity ssE("\n"+T("|Select element(s)|"), ElementWall());	
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	TslInst tsl;
	String sScriptName = scriptName();
	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	Beam lstBeams[0];
	Entity lstEnts[1];
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];

	Element elAll[0];
	elAll.append(_Element);
	for( int e= 0; e<elAll.length(); e++)
	{
		Element el= elAll[e];
		// Clone THIS tsl for every selected element
		lstEnts[0]= el;
		tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString);
	}

	eraseInstance();
	return;
}

// Get element and its info
if( _Element.length()==0){
	eraseInstance();
	return;
}

ElementWall el = (ElementWall) _Element[0];

if (!el.bIsValid())
{
	eraseInstance();
	return;
}

assignToElementGroup(el,1);
setDependencyOnEntity(el);

Point3d ptElOrg= el.ptOrg();
Vector3d vx = el.vecX();
Vector3d vy = el.vecY();
Vector3d vz = el.vecZ();

PlaneProfile ppEl(el.plOutlineWall());
LineSeg ls=ppEl.extentInDir(vx);
double dElLength=abs(vx.dotProduct(ls.ptStart()-ls.ptEnd()));

ls=ppEl.extentInDir(vz);
ElemZone elzStart= el.zone(-10);
ElemZone elzEnd= el.zone(10);
double dElWidth=abs(vz.dotProduct(elzStart.coordSys().ptOrg()-elzEnd.coordSys().ptOrg()));

double dElHeight= ((Wall)el).baseHeight();
Point3d ptElStart= ptElOrg;
Point3d ptElEnd= ptElOrg+vx*dElLength;
Point3d ptElCenter= ptElOrg+vx*dElLength*.5-vz*dElWidth*.5;	

if( !_Map.getInt("ExecutionMode") || _bOnElementConstructed)
{
	TslInst tsls[]=el.tslInstAttached();
	Map mapBmLock;
	mapBmLock.setInt("Locked",1);
	for( int t=0; t<tsls.length(); t++)
	{
		TslInst tsl= tsls[t];			

		// Erase all previous versions of this TSL
		if ( tsl.scriptName() == scriptName() && tsl.handle()!= _ThisInst.handle())
		{
			tsl.dbErase();
			continue;
		}	
				
		// Erase al previous CHILDREN TLS's inserted by OTHER instance of THIS TSL
		if( tsl.scriptName() == sChildTSL)
		{
			 if( tsl.map().getString("MasterTSL") == scriptName() )
			{
				tsl.dbErase();
			}
			else // get all blocking created by child TSL
			{
				Map mapBlocksInTSL=tsl.map().getMap("mpBlocks");
				for( int m=0; m< mapBlocksInTSL.length(); m++)
				{
					String sKey= mapBlocksInTSL.keyAt(m);
					Entity entBm= mapBlocksInTSL.getEntity(sKey);
					Beam bm= (Beam)entBm;
					if( bm.bIsValid())
						bm.setSubMapX(scriptName(), mapBmLock);
				}			
			}
		}
	}
	
	// Search all beams "blocking" type 
	Beam bmAll [] = el.beam();
	Beam bmHorizontals[]=vx.filterBeamsParallel(bmAll);
	Beam bmBlocking[0];
	for( int b=0; b<bmHorizontals.length(); b++)
	{
		Beam bm=	bmHorizontals[b];
	
		// Excludying blocking inserted by instances of children TSL not inserted by this or other intances of this TSL
		if( bm.subMapX(scriptName()).getInt("Locked"))
			continue;
	
		if((bm.type()==_kSFBlocking || bm.type()==_kBlocking) && bm.name("module")=="" && bm.vecX().isParallelTo(vx) )
		{
			bmBlocking.append(bm);	
		}
	}
	
	if( bmBlocking.length() > 0)
	{
	
		// Search blocking lines and erasing actual blocking
		Map mapBm;
		mapBm.setInt("EraseMe",1);
		Beam bmLines[0];
		for( int b=0; b< bmBlocking.length(); b++)
		{
			Beam bm= bmBlocking[b];
			if(bm.subMapX(scriptName()).getInt("EraseMe"))
				continue;
			
			Beam bmAligned[0];
			bmAligned.append(bm.filterBeamsHalfLineIntersectSort(bmBlocking, bm.ptCen(),vx));
			bmAligned.append(bm.filterBeamsHalfLineIntersectSort(bmBlocking, bm.ptCen(),-vx));
			for( int i=0; i<bmAligned.length(); i++)
				bmAligned[i].setSubMapX(scriptName(), mapBm);
		
			bmLines.append(bm);
		}
		
		// We have every line on every beam on bmLines[]
		
		// Clonning tsl's
		TslInst tsl;
		String sScriptName = sChildTSL;
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		Beam lstBeams[0];
		Entity lstEnts[0];
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		
		// Filling props for cloned TSL's
		double dElevations[0];
		String sMaterials[0], sOrientations[0];
		for( int p=0; p<4;p++)
		{
			if(p<bmLines.length())
			{
				Beam bm=bmLines[p];
				sMaterials.append(bm.material());
				// Define orientation
				double dY= bm.dD(vy);
				double dZ= bm.dD(vz);
				if(dY>dZ)
					sOrientations.append("Flat");
				else
					sOrientations.append("Edge");
				//Define elevation
				dElevations.append(abs(vy.dotProduct(bm.ptCen()-ptElOrg)));		
			}
			else
			{
				sMaterials.append(bmLines[0].material());
				sOrientations.append("Flat");
				dElevations.append(0);
			}
		}
		Point3d ptSide=bmLines[0].ptCen();
		ptSide+=vx*vx.dotProduct(ptElCenter-ptSide);
		ptSide+=vy*vy.dotProduct(ptElCenter-ptSide);
		
		for( int b=0;b<bmBlocking.length();b++)
		{
			bmBlocking[b].dbErase();
		}
		
		lstEnts.append(el);
		
		lstPoints.append(ptSide); // Side of wall
		lstPoints.append(ptElStart); // Start
		lstPoints.append(ptElEnd); // End
		
		lstPropDouble.append(U(3)); // Minimum block length
		lstPropDouble.append(dElevations);
		
		lstPropString.append("- - - - - - - - - - - - - - - -"); // Empty
		lstPropString.append(sMaterials);
		lstPropString.append("- - - - - - - - - - - - - - - -"); // Empty
		lstPropString.append(sOrientations);
		lstPropString.append("- - - - - - - - - - - - - - - -"); // Empty
		lstPropString.append(_DimStyles[0]); // DimStyle
		
		Map map;
		map.setString("MasterTSL", scriptName() );// To erase al previous CHILDREN TLS's inserted by OTHER instance of THIS TSL
		tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,lstPropInt, lstPropDouble,lstPropString, 1, map);
	}
	_Map.setInt("ExecutionMode",1);
}

if( _bOnElementDeleted )
{
	TslInst tsls[]=el.tslInstAttached();
	Map mapBmLock;
	mapBmLock.setInt("Locked",1);
	for( int t=0; t<tsls.length(); t++)
	{
		TslInst tsl= tsls[t];			
		// Erase al previous CHILDREN TLS's inserted by THIS or OTHER instance of this TSL
		if( tsl.scriptName() == sChildTSL)
		{
			 if( tsl.map().getString("MasterTSL") == scriptName() )
			{
				tsl.dbErase();
			}
		}
	}
}

// Display
Display dp(-1);
dp.addViewDirection(_ZW);
_Pt0=ptElCenter;
String sTxt=T("|Re-run blocking lines|");
if( _bOnDebug)
	dp.draw(sTxt, _Pt0, vx,-vz,0,0);
return;
#End
#BeginThumbnail
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
?%%%%`!1110`4444`%%%%`!1110`4444`%%%%`'__V44`
`

#End
