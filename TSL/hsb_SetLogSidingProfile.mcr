#Version 8
#BeginDescription
v: 1.0 initial version. Date: 07/Oct/2006 Author: Alberto Jena (aj@hsb-cad.com)

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
Unit (1,"inch");
//PropString strProfile (0,"False Log Siding", T("|Extrusion Profile Name|"));
PropString strProfile(0, ExtrProfile().getAllEntryNames().sorted(),T( "|Extrusion profile name|"));
PropString stGrade(1, "", T("|Grade|"));
PropString stMaterial(2, "", T("|Material|"));

if (_bOnInsert)
{
	if(insertCycleCount() > 1)
	{ 
		eraseInstance();
		return;
	}
	showDialogOnce();
	
	String strScriptName = scriptName(); //name of the script to insert
	
	Point3d lstPoints[0];
	int lstPropInt[0];
	Beam lstBeams[0];
	Element lstElements[1];
	double lstPropDouble[0];
	String lstPropString[0];
	lstPropString.append(strProfile);
	lstPropString.append(stGrade);
	lstPropString.append(stMaterial);
	
	Map mp;
	mp.setInt("bDoExecute", TRUE);
	
	PrEntity ssE(T("|Select a set of elements|"), ElementWallSF());
	if (ssE.go())
	{
		_Entity = ssE.set();
		
		for (int i = 0; i < _Entity.length(); i++)
		{
			Element el = (Element)_Entity[i];
			
			lstElements[0] = el;		
			
			TslInst tsl;
			
			tsl.dbCreate(strScriptName, Vector3d(1, 0, 0), Vector3d(0, 1, 0), lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, true, mp); //create new instance
		}
	}
	
	eraseInstance();

	return;
	
}
//reportMessage("\nEntity Length: " + _Entity.length() + " - Elements: " + _Element.length());
if(_Element.length()!=1)
{
	reportMessage("\n Wrong number of elements");
	eraseInstance();
	return;
}

if (_kExecuteKey!="")
	_Map.setString("Key",_kExecuteKey);

ElementWallSF el = (ElementWallSF) _Element[0];
if (!el.bIsValid()) 
{
	reportMessage("\n Element not valid");
	eraseInstance();
	return;
}

//clean out other TSLs
TslInst arTsl[] = el.tslInstAttached();
for (int i = arTsl.length()-1; i>-1;i--)
{
	if (arTsl[i].scriptName() == scriptName() && arTsl[i] != _ThisInst) arTsl[i].dbErase();
}



CoordSys csEl=el.coordSys();
Vector3d vx=csEl.vecX();
Vector3d vy=csEl.vecY();
Vector3d vz=csEl.vecZ();
_Pt0=csEl.ptOrg();
setMarbleDiameter(1);

Display dp(-1);
dp.textHeight(U(.25));
dp.layer("Defpoints");
dp.draw(scriptName(), _Pt0, vx, vz, 1, 1, _kDevice);


String strProf;

int bDoExecute=FALSE;
if (_bOnElementConstructed)
{
	bDoExecute= TRUE;
}
else
{
	if (_Map.hasInt("bDoExecute"))
	{
		bDoExecute=TRUE;
		_Map=Map();
	}
}

if (!bDoExecute)
	return;
	
String strKey;
if (_Map.hasString("Key"))
	strKey=_Map.getString("Key");


if (strKey!="")
	strProf=strKey;
else
	strProf=strProfile;

int arNZone[]={-5,-4,-3,-2,-1,1,2,3,4,5};
int nZone=0;

for (int i=0; i<arNZone.length(); i++)
{
	ElemZone elZone=el.zone(arNZone[i]);
	if (elZone.code()=="HSB-PL14")
		nZone=arNZone[i];
}

if (nZone!=0)
{
	GenBeam gbToBeProf[]=el.genBeam(nZone);
	Beam bmToBeProf[0];
	for (int i=0; i<gbToBeProf.length(); i++)
	{
		Beam bm= (Beam) gbToBeProf[i];
		if (bm.bIsValid())
			bmToBeProf.append(bm);
	}
	for (int i=0; i<bmToBeProf.length(); i++)
	{
		bmToBeProf[i].setExtrProfile(strProf);
		bmToBeProf[i].setGrade(stGrade);
		bmToBeProf[i].setMaterial(stMaterial);
	}
}
else
{
	eraseInstance();
	return;
}



#End
#BeginThumbnail




#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="0.03937008" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Added grade and material" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="11/22/2022 12:59:27 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Will stay on wall." />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="11/22/2022 12:45:26 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Added multi select and sorted the profile list" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="11/22/2022 12:25:41 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End