#Version 8
#BeginDescription
version value="1.0" date="14oct2019" author="david.rueda@hsbcad.com"
List all genBeam info
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
//region history
/// <History>
/// <version value="1.00" date="14oct2019" author="david.rueda@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select GenBeam(s)
/// </insert>

/// <summary Lang=en>
/// List all genBeam info
/// </summary>

//endregion
{
	// constants //region
	U(1, "mm");
	double dEps = U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick = "TslDoubleClick";
	double dUnitsPerMilimiter = Unit(1, "m"); //calculates how much 1 m is in drawing units
	double dUnitsPerMilimiter3 = dUnitsPerMilimiter * dUnitsPerMilimiter * dUnitsPerMilimiter; //calculate the volume scale factor
	
	int bDebug = _bOnDebug;
	// read a potential mapObject defined by hsbDebugController
	{
		MapObject mo("hsbTSLDev" , "hsbTSLDebugController");
			if (mo.bIsValid()) { Map m = mo.map(); for (int i = 0; i < m.length(); i++) if (m.getString(i) == scriptName()) { bDebug = true; 	break; }}
		if (bDebug)reportMessage("\n" + scriptName() + " starting " + _ThisInst.handle());
	}
	
	String sDefault = T("|_Default|");
	String sLastInserted = T("|_LastInserted|");
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	String sRealSolid = "RealSolid";
	String sPosNum = "PosNum";
	String sTab = " ";
	//endregion
	
	// bOnInsert//region
	if (_bOnInsert)
	{
		if (insertCycleCount() > 1) { eraseInstance(); return; }
		
		// prompt for beams
		PrEntity ssE(T("|Select GenBeam(s)|"), GenBeam());
		Entity entities[0];
		if (ssE.go())
			entities.append(ssE.set());
		
		// create TSL
		TslInst tslNew;				Vector3d vecXTsl = _XW;			Vector3d vecYTsl = _YW;
		GenBeam gbsTsl[1];		Entity entsTsl[] = { };			Point3d ptsTsl[] = { _Pt0};
		int nProps[] ={ };			double dProps[] ={ };				String sProps[] ={ };
		Map mapTsl;
		
		for (int e = 0; e < entities.length(); e++)
		{
			Entity ent = entities[e];
			GenBeam genBeam = (GenBeam) ent;
			if ( ! genBeam.bIsValid())
				continue;
			
			gbsTsl[0] = genBeam;
			
			tslNew.dbCreate(scriptName() , vecXTsl , vecYTsl, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
		}//next e
		
		eraseInstance();
		return;
	}
	// end on insert	__________________//endregion
	
	
	// validations
	if (_GenBeam.length() == 0)
	{
		if (bDebug)
			reportMessage("\n" + scriptName() + T(" - |Error|: ") + T("|not valid genBeam on _GenBeam|\n"));
		
		eraseInstance();
		return;
	}
	
	GenBeam genBeam = _GenBeam[0];
	if ( ! genBeam.bIsValid())
	{
		if (bDebug)
			reportMessage("\n" + scriptName() + T(" - |Error|: ") + T("|not valid genBeam at _GenBeam[0]|\n"));
		
		eraseInstance();
		return;
	}
	
	_Pt0 = genBeam.ptCenSolid();
	
	String sType = "";
	Beam beam = (Beam)genBeam;
	Sheet sheet = (Sheet)genBeam;
	Sip sip = (Sip)genBeam;
	
	if (beam.bIsValid())
		sType += T("|Beam|");
	else if (sheet.bIsValid())
		sType += T("|Sheet|");
	else if (sip.bIsValid())
		sType += T("|SIP|");
	else
	{
		reportMessage("\n" + scriptName() + T(" - |Error|: ") + T("|not valid type defined|\n"));
		eraseInstance();
		return;
	}
	
	if ( ! genBeam.bIsValid())
	{
		reportMessage("\n" + scriptName() + T(" - |Error|: ") + T("|not Valid GenBeam|\n"));
		eraseInstance();
		return;
	}
	
	String sMessage = TN("\n-------------------- |GenBeam|") + genBeam.handle() + " is of type: " + sType + " --------------------";
	sMessage += T("\n|volume|: ") + (genBeam.volume() / dUnitsPerMilimiter3);
	sMessage += T("\n|length|: ") + (genBeam.solidLength() / dUnitsPerMilimiter);
	sMessage += T("\n|width|: ") + (genBeam.solidWidth() / dUnitsPerMilimiter);
	sMessage += T("\n|height|: ") + (genBeam.solidHeight() / dUnitsPerMilimiter);
	sMessage += T("\n|posnum|: ") + genBeam.posnum();
	sMessage += T("\n|grade|: ") + genBeam.name("grade");
	sMessage += T("\n|profile|: ") + genBeam.name("profile");
	sMessage += T("\n|material|: ") + genBeam.name("material");
	sMessage += T("\n|label|: ") + genBeam.name("label");
	sMessage += T("\n|sublabel|: ") + genBeam.name("sublabel");
	sMessage += T("\n|sublabel2|: ") + genBeam.name("sublabel2");
	sMessage += T("\n|beamcode|: ") + genBeam.name("beamcode");
	sMessage += T("\n|hsbId|: ") + genBeam.name("hsbId");
	sMessage += T("\n|module|: ") + genBeam.name("module");
	sMessage += T("\n|type as string|: ") + genBeam.name("type");
	sMessage += T("\n|type as number|: ") + genBeam.type();
	sMessage += T("\n|information|: ") + genBeam.name("information");
	sMessage += T("\n|name|: ") + genBeam.name("name");
	sMessage += T("\n|posnumandtext|: ") + genBeam.name("posnumandtext");
	sMessage += T("\n|layer|: ") + genBeam.name("layer");
	sMessage += T("\n|bIsDummy|: ") + genBeam.bIsDummy();
	sMessage += T("\n|color|: ") + genBeam.color();
	
	TslInst tsls[] = genBeam.tslInstAttached();
	if (tsls.length() == 0)
	{
		sMessage += TN("|No valid TSLs attached|");
	}
	else
	{
		sMessage += TN("|Found| " + tsls.length() + T(" |attached|:"));
		for (int index = 0; index < tsls.length(); index++)
		{
			TslInst tsl = tsls[index];
			sMessage += "\n\t" + tsl.scriptName();
		}//next index
	}
	
	reportNotice(sMessage);
	eraseEntity();
}


#End
#BeginThumbnail


#End
#BeginMapX

#End