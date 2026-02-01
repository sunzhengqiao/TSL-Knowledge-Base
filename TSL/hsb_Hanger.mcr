#Version 8
#BeginDescription
Last modified by: Mihai Bercuci
23.07.2018  -  version 5.4
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 5
#MinorVersion 4
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl inserts hangers. The hangers are defined in a database.
/// </summary>

/// <insert>
/// 
/// </insert>

/// <remark Lang=en>
/// Microsoft SQL Server Compact 4.0 is required.
/// </remark>

/// <version  value="3.01" date="24.06.2014"></version>

/// <history>
/// AS - 3.00 - 02.05.2013 -	Development by UK office.
/// AS - 3.01 - 24.06.2013 -	Get database from comapny folder in order to avoid read-write issues.
/// CS - Further comments will be found in source control
/// </history>

Unit(1,"mm");

if( _bOnInsert )
{
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	
	String strAssemblyPath = _kPathHsbInstall+"\\Utilities.Acad\\\Hanger\\hsbAcadHangerIntegration.dll";  
//	strAssemblyPath = "D:\\hsbCAD\\Default\\dev10\\beamapp\\Hsb_NetApi\\hsb_Hanger\\hsbAcadHangerIntegration\\bin\\Debug\\hsbAcadHangerIntegration.dll";  
	String strType = "hsbCad.Hanger.AutoCAD.MapTransaction";
	String strFunction = "HangerDialogDotNetInsertion";	

	Map mpOut;
	mpOut.setString("HostScript",scriptName());
	Map mpInput= callDotNetFunction2(strAssemblyPath, strType, strFunction, mpOut);

	return;
}

//CALLMAPIO
if(_kExecuteKey=="changeHanger")
{
	String sDimLayout=_DimStyles[0];
	String strYesNo[]= {T("No"), T("Yes"), T("Short Model")};
	
	if(!_Map.hasMap("CONNECTION[]")) { return; }
	Map mpConnections = _Map.getMap("CONNECTION[]");
	
	String strFileName = _kPathDwg + "\\insertHangerMap.dxx";
	//mpConnections.writeToDxxFile(strFileName );

	for(int i=0; i<mpConnections.length();i++)
	{
		if(mpConnections.keyAt(i)=="CONNECTION");
		
		Map mpThisConnection=mpConnections.getMap(i);
	
		Map mpMaleBeams=mpThisConnection.getMap("MALEBEAMS");
		Map mpFemaleBeams=mpThisConnection.getMap("FEMALEBEAMS");
		Entity entMale[0];
		for(int m=0;m<mpMaleBeams.length();m++)
		{
			Entity e=mpMaleBeams.getEntity(m);
			if(e.bIsValid())
			{
				entMale.append(e);
			}
		}
	
		Entity entFemale[0];
		for(int m=0;m<mpFemaleBeams.length();m++)
		{
			Entity e=mpFemaleBeams.getEntity(m);
			if(e.bIsValid())
			{
				entFemale.append(e);
			}
		}
	
		Point3d ptOrigin=mpThisConnection.getPoint3d("Origin");
	
		Map mpToClone;
		mpToClone.setEntityArray(entMale, false, "MaleBeams", "MaleBeams", "asd");
		mpToClone.setEntityArray(entFemale, false, "FemaleBeams", "FemaleBeams", "asd");
		
		String sModel;
		String sDimstyle;
		int nDisplayModel;
		String sType;
		double dTolerance;
		String sScriptName;
		
		for (int j=0; j<mpThisConnection.length(); j++)
		{
			if (mpThisConnection.keyAt(j)=="HANGER")
			{
				Map mp=mpThisConnection.getMap(j);
				mpToClone.appendMap("HANGER", mp);
				sModel=mp.getString("Model");
				sType=mp.getString("Type");
				sDimstyle=mp.getString("Dimstyle");
				nDisplayModel=mp.getInt("DisplayModel");
				dTolerance=mp.getDouble("Tolerance");
				sScriptName = mp.getString("ScriptName");
			}
		}
		
		mpToClone.setString("Type", sType);
	
		// declare tsl props
		TslInst tsl;
		String strScriptName=sScriptName.length()==0 ?  "hsb_HangerDisplay" : sScriptName;
		Vector3d vecUcsX = _XU;
		Vector3d vecUcsY = _YU;
		Element lstElements[0];
		Beam lstBeams[0];
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		
		lstPoints.append(ptOrigin);
		
		lstPropString.append(sModel);
		lstPropString.append(sDimstyle);
		lstPropString.append(strYesNo[nDisplayModel]);
		
		//remove any tsls of the same type from the male beam if the female is the same
		for(int e=0;e<entMale.length();e++)
		{
			Entity ent=entMale[e];
	
			//Cast to beam
			Beam bm=(Beam) ent;
			if(!bm.bIsValid()) continue;
			Entity entTools[]=bm.eToolsConnected();
		
			TslInst tslIns[0];
			for(int e=0;e<entTools.length();e++)
			{
				TslInst tsl=(TslInst)entTools[e];
				if(tsl.bIsValid())
				{
					tslIns.append(tsl);
				}
			}
	
			for(int i=0;i<tslIns.length();i++)
			{
				TslInst tslCurr=tslIns[i];
				Map mpRetrieve;
				mpRetrieve=tslCurr.map();
				if(tslCurr.scriptName()!=strScriptName)
				{
					continue;
				}
	
				//Check if the side is the same
				double dSide=(ptOrigin-bm.ptCen()).dotProduct(tslCurr.ptOrg()-bm.ptCen());
				double dDistanceBetweenPoints = abs((ptOrigin - tslCurr.ptOrg()).dotProduct(bm.vecX()));
	
				if(dSide > 0 && dDistanceBetweenPoints < (dTolerance +U(1)))
				{
					mpToClone.setPoint3d("PreviousOrigin", tslCurr.ptOrg());
					tslCurr.dbErase();
				}
			}
		}
	
		tsl.dbCreate(strScriptName, vecUcsX,vecUcsY, lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModel, mpToClone);
	}
}

eraseInstance();

#End
#BeginThumbnail




#End
#BeginMapX

#End