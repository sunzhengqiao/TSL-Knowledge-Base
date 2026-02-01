#Version 8
#BeginDescription
Sets the timber/sheet color based on material description

Last modified by: Bruno Bortot (bruno.bortot@hsbcad.com)
Date: 03.11.2016 - version 2.1
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 2
#MinorVersion 1
#KeyWords 
#BeginContents
Unit(1,"mm");

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

if (mp.hasMap("MATERIAL[]"))
{
	Map mpMaterials=mp.getMap("MATERIAL[]");
	for(int i=0; i<mpMaterials.length(); i++)
	{
		Map mpMaterial=mpMaterials.getMap(i);
		if (mpMaterial.getString("MATERIAL")!="DEFAULT")
			sMaterials.append(mpMaterial.getString("MATERIAL").makeUpper());
	}
}


PropString sMaterial1 (0,sMaterials,"Material 1");
PropInt sColor1(0,-1,"Color 1");
sMaterial1.setCategory("Material 1");
sColor1.setCategory("Material 1");

PropString sMaterial2 (1,sMaterials,"Material 2");
PropInt sColor2(1,-1,"Color 2");
sMaterial2.setCategory("Material 2");
sColor2.setCategory("Material 2");

PropString sMaterial3 (2,sMaterials,"Material 3");
PropInt sColor3(2,-1,"Color 3");
sMaterial3.setCategory("Material 3");
sColor3.setCategory("Material 3");

PropString sMaterial4 (3,sMaterials,"Material 4");
PropInt sColor4(3,-1,"Color 4");
sMaterial4.setCategory("Material 4");
sColor4.setCategory("Material 4");

PropString sMaterial5 (4,sMaterials,"Material 5");
PropInt sColor5(4,-1,"Color 5");
sMaterial5.setCategory("Material 5");
sColor5.setCategory("Material 5");


String sAllMaterials[]={sMaterial1,sMaterial2,sMaterial3,sMaterial4,sMaterial5};
int sAllColors[]={sColor1,sColor2,sColor3,sColor4,sColor5};


if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);


if(_bOnInsert){
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	if (_kExecuteKey=="")
		showDialogOnce();
		
	PrEntity ssE("\n"+T("Select a set of elements"), Element());
	
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	return;
}

if( _Element.length()==0 ){
	eraseInstance();
	return;
}

for( int e=0; e<_Element.length(); e++ )
{
	Element el = _Element[e];
	if (!el.bIsValid()) continue;
	
	GenBeam bmAll[]=el.genBeam();
	
	for (int i=0;i<bmAll.length();i++)
	{
		GenBeam gbm=bmAll[i];
		String sThisMat=gbm.material();
		sThisMat.makeUpper();
		sThisMat.trimLeft();
		sThisMat.trimRight();
		int nIndex=sAllMaterials.find(sThisMat,-1);
		if(nIndex !=-1)
		{
			gbm.setColor(sAllColors[nIndex]);
		}
	}
}

eraseInstance();
return;
	
		







#End
#BeginThumbnail



#End