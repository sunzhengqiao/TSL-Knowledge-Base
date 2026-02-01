#Version 8
#BeginDescription
Creates no tool areas.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 03.11.2017 - version 2.0


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 0
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2011 by
*  hsbSOFT 
*  UK
*
*  The program may be used and/or copied only with the written
*  permission from hsbSOFT, or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*/

Unit(1,"mm"); // script uses mm

PropDouble dHeight (0, U(100), T("Height"));
PropDouble dWidth (1, U(100), T("Length"));

int nValidZones[]={1,2,3,4,5,6,7,8,9,10};
int nRealZones[]={1,2,3,4,5,-1,-2,-3,-4,-5};
PropString psZones(1, "1;2", T("Zones to apply no tool area"));
psZones.setDescription(T("Please type the number of the zones separate by ; (1-10)"));


String sOperations[] = {T("No Nail"), T("No Glue"), T("No Nail and No Glue")};

PropString sOperationCNC(0, sOperations, T("Exclusion Type"));

if(_bOnInsert)
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
	if (_kExecuteKey=="")
		showDialog();

	_Element.append(getElement(T("Select an Element")));
	
	if(_Element.length()==0)
	{
		eraseInstance();
		return;
	}
	
	EntPLine pl = getEntPLine("Pick a polyline, or enter to pick a point");
	
	if (pl.bIsValid())
	{
		//reportNotice("yes");
		_Entity.append(pl);
	}
	else
	{
		//reportNotice("no");
		_Pt0 = getPoint(); // select point
	} 

	return;
}

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

int nOperationCNC = sOperations.find(sOperationCNC, 0);

if ( _Element.length()==0 ) 
{
	eraseInstance();
	return;
}

Element el = _Element[0];
if (!el.bIsValid())
{
	eraseInstance();
	return;
}

int nZones[0];

//Fill the values for the externall Walls
String sZones=psZones;
sZones.trimLeft();
sZones.trimRight();
sZones=sZones+";";
for (int i=0; i<sZones.length(); i++)
{
	String str=sZones.token(i);
	str.trimLeft();
	str.trimRight();
	if (str.length()>0)
	{
		int nIndex=nValidZones.find(str.atoi());
		if(nIndex!=-1)
		{
	  		nZones.append(nRealZones[nIndex]);
		}
	}
}

// Define coordinate system.
CoordSys csEl = el.coordSys();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();

Map noToolAreaArrayMap;
for(int x = 0 ; x < nZones.length() ; x++)
{
	int& nZone = nZones[x];
	ElemZone elZone=el.zone(nZone);
	
	CoordSys csZone=elZone.coordSys();
	Vector3d vxZone=csZone.vecX();
	Vector3d vzZone=csZone.vecZ();
	
	//csZone.vis();
	
	Point3d ptZoneOrg=csZone.ptOrg();
	Plane plnZ(ptZoneOrg+vzZone*elZone.dH(), vzZone);
	
	
	PLine plNoNail(vzZone);
	
	if (_Entity.length()>1)
	{
		EntPLine epl = (EntPLine)_Entity[1];
		if (epl.bIsValid())
		{
			PLine pl = epl.getPLine();
			pl.projectPointsToPlane(plnZ, vzZone);
			plNoNail=pl;
			_Pt0=plnZ.closestPointTo(plNoNail.ptStart());
		}
		else
		{
			eraseInstance();
			return;
		}
	}
	else
	{
		
		
		Point3d ptTRNoNail=_Pt0-vy*dHeight*0.5-vxZone*dWidth*0.5;
		plNoNail.addVertex(ptTRNoNail);
		plNoNail.addVertex(ptTRNoNail+vxZone*dWidth);
		plNoNail.addVertex(ptTRNoNail+vxZone*dWidth+vy*dHeight);
		plNoNail.addVertex(ptTRNoNail+vy*dHeight);
		plNoNail.close();
		
	}
	
	
	//Remove Previous Tags
	//Remove TAG
	Map mpTags = _ThisInst.subMapX("Hsb_Tag");
			
	for (int i=0; i<mpTags.length(); i++)
	{
		if (mpTags.keyAt(i)=="TAG")
		{
			String sThisKey=mpTags.getString(i);
			
			if (sThisKey == "NoNail")
			{
				int status=mpTags.removeAt(i, true);
		
				_ThisInst.removeSubMapX("Hsb_Tag");
				
				if (mpTags.length()>0)
				{
					_ThisInst.setSubMapX("Hsb_Tag", mpTags);
				}
			}
			if (sThisKey == "NoGlue")
			{
				int status=mpTags.removeAt(i, true);
		
				_ThisInst.removeSubMapX("Hsb_Tag");
				
				if (mpTags.length()>0)
				{
					_ThisInst.setSubMapX("Hsb_Tag", mpTags);
				}
			}
		}
	}
	
	//Add TAGs
	
	if (nOperationCNC==0 || nOperationCNC==2) //No Nail
	{
		//ADD TAG
		String sAllKeys=_ThisInst.subMapXKeys();
		if (sAllKeys.find("Hsb_Tag", -1) != -1)
		{
			//Already have some tags
			Map mpTags = _ThisInst.subMapX("Hsb_Tag");
			int nFound=false;
			for (int i=0; i<mpTags.length(); i++)
			{
				if (mpTags.getString(i)=="NoNail")
				{
					nFound=true;
				}
			}
			
			if (!nFound)
			{
				mpTags.appendString("Tag", "NoNail");
			}
			
			_ThisInst.setSubMapX("Hsb_Tag", mpTags);
		}
		else //doesnt have tags before
		{
			Map mpTags;
			mpTags.setString("Tag", "NoNail");
			_ThisInst.setSubMapX("Hsb_Tag", mpTags);
		}
	}
	if (nOperationCNC==1 || nOperationCNC==2) //No Glue
	{
		//ADD TAG
		String sAllKeys=_ThisInst.subMapXKeys();
		if (sAllKeys.find("Hsb_Tag", -1) != -1)
		{
			//Already have some tags
			Map mpTags = _ThisInst.subMapX("Hsb_Tag");
			int nFound=false;
			for (int i=0; i<mpTags.length(); i++)
			{
				if (mpTags.getString(i)=="NoGlue")
				{
					nFound=true;
				}
			}
			
			if (!nFound)
			{
				mpTags.appendString("Tag", "NoGlue");
			}
			
			_ThisInst.setSubMapX("Hsb_Tag", mpTags);
		}
		else //doesnt have tags before
		{
			Map mpTags;
			mpTags.setString("Tag", "NoGlue");
			_ThisInst.setSubMapX("Hsb_Tag", mpTags);
		}	
	}
	
	//Create No Nail Zones
	ElemNoNail elNoNailTR(nZone, plNoNail);
	el.addTool(elNoNailTR);

	Map noToolAreaMap;
	noToolAreaMap.setPLine("NoToolShape", plNoNail);
	noToolAreaMap.setInt("NoToolZone", nZone);
	
	noToolAreaArrayMap.appendMap("NoToolArea", noToolAreaMap);
}

//No tool areas used by gluing TSL to ensure no glue lines are created where there are no glue areas
_Map.setMap("NoToolArea[]", noToolAreaArrayMap);

//_Map.setPLine("NoToolShape", plNoNail);
//_Map.setInt("NoToolZone", nZone);
#End
#BeginThumbnail




#End