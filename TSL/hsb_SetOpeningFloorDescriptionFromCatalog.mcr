#Version 8
#BeginDescription
Sets the DSP edge details from an opening catalog for hsbRoof Openings

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 01.07.2010  -  version 1.0

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
Unit(1,"mm");

PropString sCatalogName(0, "", T("Opening Catalog Name"));

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

	PrEntity ssE("\nSelect a set of Opening Roof/Floors",OpeningRoof());
	if(ssE.go()){
		Entity ent[]=ssE.set();
		for (int i=0; i<ent.length(); i++)
		{
			OpeningRoof op=(OpeningRoof) ent[i];
			if (op.bIsValid())
				_Entity.append(op);
		}
	}
	return;
}

if (_Entity.length()==0) 
{
	eraseInstance();
	return;
}

for (int i=0; i<_Entity.length(); i++)
{

	OpeningRoof opRoof = (OpeningRoof) _Entity[i];
	if (!opRoof.bIsValid()) continue;
	
	Element elRoof=opRoof.element();

	// collect all the catalog values, and report them
	int bFloorNotRoof= opRoof.bIsInFloor();
	String arEntries[] = opRoof.getListOfCatalogNames(bFloorNotRoof);
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
		opRoof.setValuesFromCatalog(sCatalogToAssign, bFloorNotRoof); 
	}

	//if (bGenerate && elRoof.bIsValid())
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
