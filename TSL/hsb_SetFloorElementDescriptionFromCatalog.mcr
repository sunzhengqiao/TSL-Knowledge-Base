#Version 8
#BeginDescription
Sets the DSP edge details from a floor catalog for hsbFloor/Roof Openings

Last modified by: Alberto Jena (aj@hsb-cad.com)
Date: 01.07.2010  -  version 1.1

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
Unit(1,"mm");

PropString sCatalogName(0, "", T("Catalog Name"));

//String sArNY[] = {T("No"), T("Yes")};
//PropString sGenerate(1, sArNY, T("Generate Element"), 0);
//sGenerate.setDescription("This option will frame the selected elements");

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

//int bGenerate= sArNY.find(sGenerate,0);

if (_bOnInsert)
{
	if (insertCycleCount()>1) { eraseInstance(); return; }
	if (_kExecuteKey=="")
		showDialogOnce();

	PrEntity ssE("\nSelect a set of elements",ElementRoof());
	if(ssE.go()){
		_Element.append(ssE.elementSet());
	}
	return;
}

if (_Element.length()==0)
{
	eraseInstance();
	return;
}

for (int i=0; i<_Element.length(); i++)
{

	ElementRoof elRoof = (ElementRoof) _Element[i];
	if (!elRoof.bIsValid()) continue;

	// insert the setBeamNameFloor TSL for this element
	// declare tsl props

	String strScriptName="hsb_SetBeamNameFloor";
	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	Element lstElements[0];
	Beam lstBeams[0];
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];

	Map mpToClone;
	mpToClone.setInt("nExecutionMode", 1);
	
	lstElements.setLength(0);
	lstElements.append(elRoof);
	
	TslInst tsl;
	tsl.dbCreate(strScriptName, vecUcsX,vecUcsY, lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModel, mpToClone);
	
	
	// collect all the catalog values, and find a match
	int bFloorNotRoof= elRoof.bIsAFloor();
	String arEntries[] = elRoof.getListOfCatalogNames(bFloorNotRoof);
	String sCatalogToAssign="";
	
	for (int e=0; e<arEntries.length();e++)
	{
		String sAux=arEntries[e];
		String sCatalog=sCatalogName;
		sCatalog.makeUpper();
		sAux.makeUpper();
		if (sCatalog==sAux)
			sCatalogToAssign=arEntries[e];;
		
	}
	
	if (sCatalogToAssign!="")
	{
		elRoof.setValuesFromCatalog(sCatalogToAssign, bFloorNotRoof); 
	}
	
	//if (bGenerate)
	//{
	//	Group grp = elRoof.elementGroup();
	//	String strName = grp.name();
	//	pushCommandOnCommandStack("-Hsb_GenerateConstruction "+strName);
	//}
}

eraseInstance();

#End
#BeginThumbnail


#End
