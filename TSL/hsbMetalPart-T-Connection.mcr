#Version 8
#BeginDescription

#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 0
#MinorVersion 0
#KeyWords 
#BeginContents
//basics and props
	U(1,"mm");
	double dEps=U(.1);

	String sArNY[] = {T("|No|"), T("|Yes|")};
	PropString sSide(0,sArNY,T("|Stretch Male Beam|"));

// declare the tsl props
	TslInst tslNew;
	Vector3d vUcsX = _XU;
	Vector3d vUcsY = _YU;
	GenBeam gbAr[0];
	Entity entAr[0];
	Point3d ptAr[0];
	int nArProps[0];
	double dArProps[0];
	String sArProps[0];
	Map mapTsl;
	String sScriptname = scriptName();
	
// on insert
	if (_bOnInsert){
		if (insertCycleCount()>1) { eraseInstance(); return; }
		
	// show the dialog if no catalog in use
		if (_kExecuteKey == "" )
		{
			showDialog();	
		}
	// set properties from catalog		
		else	
			setPropValuesFromCatalog(_kExecuteKey);	

	// select male and female beams
		Beam bmMale[0], bmFemale;
	  	PrEntity ssBm(T("|Select male Beam(s)|"),  Beam());
  		if (ssBm.go()) {
			bmMale= ssBm.beamSet();
  		}
		if (bmMale.length()>0)
		{
			bmFemale= getBeam("|Select female beam|");
		}
		else
		{
			eraseInstance();
			return;	
		}		

	// prompt user for mass elements
	  	PrEntity ssE(T("|Select Metalpart(s)|"),  MassGroup());
		Entity ents[0];
  		if (ssE.go()) {
			ents= ssE.set();
  		}

	// validate massgroups: at least one massgroup needs to have an ecs marker
	// which X-Axis is not perp to beam0 vecX
		EcsMarker ecs;
		for (int i=0;i<ents.length();i++)
		{
			MassGroup mg = (MassGroup)ents[i];
			Entity entsMg[0];
			entsMg = mg.entity();
			for (int e=0;e<entsMg .length();e++)
			{
				ecs =(EcsMarker)entsMg[e];
				if (ecs.bIsValid() && !ecs.coordSys().vecX().isPerpendicularTo(bmMale[0].vecX()))
				{
					break;
				}
				else// reset ecs link
				{
					ecs = EcsMarker();
				}	
			}	
			if (ecs.bIsValid())break;
		}

	// link beams and metalparts together
		if (ecs.bIsValid())
		{

			entAr.setLength(0);
			entAr.append(ents);
	
			ptAr.setLength(0);
			ptAr.append(ecs.coordSys().ptOrg());
			for (int e=0;e<bmMale.length();e++)
			{
				if (e==1)
				{
					gbAr.append(bmFemale);
				}
				gbAr.append(bmMale[e]);
			}
			reportNotice("\ncretae gb " + gbAr.length());			
			tslNew.dbCreate(sScriptname, vUcsX,vUcsY,gbAr, entAr, ptAr, 
				nArProps, dArProps, sArProps,_kAllSpaces, mapTsl); // create new instance		
			reportNotice("\ncretae " + tslNew.bIsValid());	
		}


				
	// erase the caller
		eraseInstance();
		return;
		
	}	
	
// assign beams
	Beam bmMale[0], bmFemale;
	for (int e=0;e<_Beam.length();e++)
	{
		if (e==1)bmFemale=_Beam[1];
		else bmMale.append(_Beam[e]);
	}
	
// validate massgroups: at least one massgroup needs to have an ecs marker
// which X-Axis is not perp to beam0 vecX
	EcsMarker ecs;
	Entity ents[0];
	ents = _Entity;
	for (int i=0;i<ents.length();i++)
	{
		MassGroup mg = (MassGroup)ents[i];
		Entity entsMg[0];
		entsMg = mg.entity();
		for (int e=0;e<entsMg .length();e++)
		{
			ecs =(EcsMarker)entsMg[e];
			if (ecs.bIsValid() && !ecs.coordSys().vecX().isPerpendicularTo(bmMale[0].vecX()))
			{
				break;
			}
			else// reset ecs link
			{
				ecs = EcsMarker();
			}	
		}	
		if (ecs.bIsValid())break;
	}

// link beams and metalparts together
	if (ecs.bIsValid())
	{
		_Pt0 = ecs.coordSys().ptOrg();
	}
	else
	{
		eraseInstance();
		return;
	}	

	
// Display
	Display dp(1);
	dp.draw(scriptName(),_Pt0,_XW,_YW,1,0,_kDeviceX);
		
	
#End
#BeginThumbnail

#End
