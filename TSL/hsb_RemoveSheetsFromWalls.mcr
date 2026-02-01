#Version 8
#BeginDescription
Removes alls sheets from zones in walls

Modified by: Chirag Sawjani (csawjani@itw-industry.com)
Date: 01.03.2012  -  version 1.2






#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2010 by
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
* --------------------------------
*
* Modified by: Chirag Sawjani (csawjani@itw-industry.com)
* date: 01.03.2012
* version 1.0: Release
*
* Modified by: Chirag Sawjani (csawjani@itw-industry.com)
* date: 16.04.2012
* version 1.2: Tool palette bugfix
*/

_ThisInst.setSequenceNumber(80);

//Units
U(1,"mm");

int nValidZones[]={1,2,3,4,5,6,7,8,9,10};
int nRealZones[]={1,2,3,4,5,-1,-2,-3,-4,-5};

PropString psWalls1(0,"",T("Wall 1 Codes"));
psWalls1.setDescription(T("Please type the Wall codes to use seperated by ;"));
PropString psZones1(1, "", T("Zones to Remove for Wall 1"));
psZones1.setDescription(T("Please type the number of the zones separate by ; (1-10)"));

PropString psWalls2(2,"",T("Wall 2 Codes"));
psWalls2.setDescription(T("Please type the Wall codes to use seperated by ;"));
PropString psZones2(3, "", T("Zones to Remove for  Wall 2"));
psZones2.setDescription(T("Please type the number of the zones separate by ; (1-10)"));

PropString psWalls3(4,"",T("Wall 3 Codes"));
psWalls3.setDescription(T("Please type the Wall codes to use seperated by ;"));
PropString psZones3(5, "", T("Zones to Remove for  Wall 3"));
psZones3.setDescription(T("Please type the number of the zones separate by ; (1-10)"));

PropString psWalls4(6,"",T("Wall 4 Codes"));
psWalls4.setDescription(T("Please type the Wall codes to use seperated by ;"));
PropString psZones4(7, "", T("Zones to Remove for  Wall 4"));
psZones4.setDescription(T("Please type the number of the zones separate by ; (1-10)"));



//int nLocZone=sValidZones.find(sZones, 0);
//int nZone=nRealZones[nLocZone];


if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if(_bOnInsert)
{
	if( insertCycleCount()>1 )
	{
		eraseInstance();
		return;
	}	
	if (_kExecuteKey=="")	showDialogOnce();
	
	PrEntity ssE(T("Select one or More Elements"), ElementWallSF());
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	return;
}

//Fill values for the various Walls from the properties into the arrays
String sWalls1=psWalls1;
sWalls1.trimLeft();
sWalls1.trimRight();
sWalls1=sWalls1+";";

String sWalls2=psWalls2;
sWalls2.trimLeft();
sWalls2.trimRight();
sWalls2=sWalls2+";";

String sWalls3=psWalls3;
sWalls3.trimLeft();
sWalls3.trimRight();
sWalls3=sWalls3+";";

String sWalls4=psWalls4;
sWalls4.trimLeft();
sWalls4.trimRight();
sWalls4=sWalls4+";";

String sArWalls1[0];
String sArWalls2[0];
String sArWalls3[0];
String sArWalls4[0];

for (int i=0; i<sWalls1.length(); i++)
{
	String str=sWalls1.token(i);
	str.trimLeft();
	str.trimRight();
	if (str.length()>0)
	{
		sArWalls1.append(str);
	}
}

for (int i=0; i<sWalls2.length(); i++)
{
	String str=sWalls2.token(i);
	str.trimLeft();
	str.trimRight();
	if (str.length()>0)
	{
		sArWalls2.append(str);
	}
}

for (int i=0; i<sWalls3.length(); i++)
{
	String str=sWalls3.token(i);
	str.trimLeft();
	str.trimRight();
	if (str.length()>0)
	{
		sArWalls3.append(str);
	}
}

for (int i=0; i<sWalls4.length(); i++)
{
	String str=sWalls4.token(i);
	str.trimLeft();
	str.trimRight();
	if (str.length()>0)
	{
		sArWalls4.append(str);
	}
}

//Fill the values for the various Zones from properties into arrays
String sZones1=psZones1;
sZones1.trimLeft();
sZones1.trimRight();
sZones1=sZones1+";";

String sZones2=psZones2;
sZones2.trimLeft();
sZones2.trimRight();
sZones2=sZones2+";";

String sZones3=psZones3;
sZones3.trimLeft();
sZones3.trimRight();
sZones3=sZones3+";";

String sZones4=psZones4;
sZones4.trimLeft();
sZones4.trimRight();
sZones4=sZones4+";";

int nZones1[0];
int nZones2[0];
int nZones3[0];
int nZones4[0];

for (int i=0; i<sZones1.length(); i++)
{
	String str=sZones1.token(i);
	str.trimLeft();
	str.trimRight();
	if (str.length()>0)
	{
		int nIndex=nValidZones.find(str.atoi());
		if(nIndex!=-1)
		{
	  		nZones1.append(nRealZones[nIndex]);
		}
	}
}

for (int i=0; i<sZones2.length(); i++)
{
	String str=sZones2.token(i);
	str.trimLeft();
	str.trimRight();
	if (str.length()>0)
	{
		int nIndex=nValidZones.find(str.atoi());
		if(nIndex!=-1)
		{
	  		nZones2.append(nRealZones[nIndex]);
		}
	}
}

for (int i=0; i<sZones3.length(); i++)
{
	String str=sZones3.token(i);
	str.trimLeft();
	str.trimRight();
	if (str.length()>0)
	{
		int nIndex=nValidZones.find(str.atoi());
		if(nIndex!=-1)
		{
	  		nZones3.append(nRealZones[nIndex]);
		}
	}
}

for (int i=0; i<sZones4.length(); i++)
{
	String str=sZones4.token(i);
	str.trimLeft();
	str.trimRight();
	if (str.length()>0)
	{
		int nIndex=nValidZones.find(str.atoi());
		if(nIndex!=-1)
		{
	  		nZones4.append(nRealZones[nIndex]);
		}
	}
}


for( int e=0; e<_Element.length(); e++)
{
	Element el=_Element[e];
	String sCode=el.code();
	if (!el.bIsValid())
		continue;

	CoordSys csEl = el.coordSys();
	Vector3d vx = csEl.vecX();
	Vector3d vy = csEl.vecY();
	Vector3d vz = csEl.vecZ();
	_Pt0=csEl.ptOrg();
	
	//Check which Wall set the current element belongs to
	int nWallSet=-1;
	int nZonesAux[0];
	if(sArWalls1.find(sCode)!=-1) nWallSet=1;
	if(sArWalls2.find(sCode)!=-1) nWallSet=2;
	if(sArWalls3.find(sCode)!=-1) nWallSet=3;
	if(sArWalls4.find(sCode)!=-1) nWallSet=4;

	
	if(nWallSet==-1) continue; //nothing to do if not found
	if(nWallSet==1) nZonesAux=nZones1;		
	if(nWallSet==2) nZonesAux=nZones2;
	if(nWallSet==3) nZonesAux=nZones3;
	if(nWallSet==4) nZonesAux=nZones4;

	for(int z=0;z<nZonesAux.length();z++)
	{
		int nZone=nZonesAux[z];
		Sheet shAll[]=el.sheet(nZone);
		
		for(int i=0;i<shAll.length();i++)
		{
			Sheet sh=shAll[i];
			sh.dbErase();
		}
	}
	
	
}

eraseInstance();
return;








#End
#BeginThumbnail


#End
