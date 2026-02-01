#Version 8
#BeginDescription

#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 0
#MinorVersion 0
#KeyWords 
#BeginContents
String sPath= _kPathHsbCompany+"\\Abbund\\Materials.xml";

String sFind=findFile(sPath);

if (sFind=="")
{
	reportNotice("\n Materials not been set, please run hsbMaterial Utility or contact SupportDesk");
	eraseInstance();
	return;
}

Map mp;
mp.readFromXmlFile(sPath);

String sMaterials[0];
sMaterials.append("");

if (mp.hasMap("MATERIAL[]"))
{
	Map mpMaterials=mp.getMap("MATERIAL[]");
	for(int i=0; i<mpMaterials.length(); i++)
	{
		Map mpMaterial=mpMaterials.getMap(i);
		if (mpMaterial.getString("MATERIAL")!="DEFAULT")
			sMaterials.append(mpMaterial.getString("MATERIAL"));
	}
}

PropString sName (0, "", T("Name"));
sName.setCategory(T("Beam properties for module"));

PropString sMaterial (1, sMaterials, T("Material"));
sMaterial.setCategory(T("Beam properties for module"));

PropString sGrade (2, "", T("Grade"));
sGrade.setCategory(T("Beam properties for module"));

PropInt nColor(0, 2, T("Color"));
nColor.setCategory(T("Beam properties for module"));

if( _bOnInsert ){
	if( insertCycleCount() >1 ){ eraseInstance(); return; }
	showDialogOnce();
	PrEntity ssE(T("Select beams"),Beam());
	
	if( ssE.go()){
		_Beam.append(ssE.beamSet());
	}
}

int nNrOfSelectedBeams = _Beam.length();
Beam arBmModule[0];
arBmModule.append(_Beam);

if (_Beam.length()<1)
{ 
	eraseInstance();
	return;
}

String sModuleName = _Beam[0].handle();

for( int i=0;i<arBmModule.length();i++ ){
	Beam bm = arBmModule[i];
	if (sName!="")
		bm.setName(sName);
	if (sMaterial!="")
		bm.setMaterial(sMaterial);
	if (sGrade!="")
		bm.setGrade(sGrade);
	
	bm.setModule(sModuleName);
	bm.setColor(nColor);
}

eraseInstance();
#End
#BeginThumbnail

#End