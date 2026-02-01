#Version 8
#BeginDescription
/// Version 1.2    th@hsbCAD.de  26.08.2011
/// Fastener Assmebly added

This TSL shows the selected properties of a potential linked hardware
All components in the hardware list will be displayed


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
/// <summary Lang=en>
/// This TSL shows the selected properties of a potential linked hardware
/// All components in the hardware list will be displayed
/// </summary>

/// <insert=en>
/// Select all entities which contain hardware information and/or entities which have
/// tools including hardware attached 
/// </insert>


/// History
/// Version 1.2    th@hsbCAD.de  26.08.2011
/// Fastener Assmebly added
/// Version 1.1    th@hsbCAD.de  17.08.2011
/// TSL Labeling added
/// Version 1.0    th@hsbCAD.de  10.08.2011
/// initial


//basics and props
	U(1,"mm");
	double dEps=U(.1);

// content props
	int nArSeq[] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13};
	int nArProp[0];
	nArProp= nArSeq;
	PropInt nName(1,nArSeq,T("|Display|") + " " + T("|Name|"));
	PropInt nArticleNumber(2,nArSeq,"   " + T("|Article Number|"));
	PropInt nDescription(3,nArSeq,"   " + T("|Description|"),2);
	PropInt nManufacturer(4,nArSeq,"   " + T("|Manufacturer|"));
	PropInt nModel(5,nArSeq,"   " + T("|Model|"));
	PropInt nMaterial(6,nArSeq,"   " + T("|Material|"));
	PropInt nQuantity(7,nArSeq,"   " + T("|Quantity|"),1);
	PropInt nScaleX(8,nArSeq,"   " + T("|Scale X|"));		
	PropInt nScaleY(9,nArSeq,"   " + T("|Scale Y|"));
	PropInt nScaleZ(10,nArSeq,"   " + T("|Scale Z|"));	
	PropInt nNorm(11,nArSeq,"   " + T("|Norm|"));	
	PropInt nCoating(12,nArSeq,"   " + T("|Coating|"));	
	PropInt nGrade(13,nArSeq,"   " + T("|Grade|"));		
	PropInt nType(14,nArSeq,"   " + T("|Type|"));

	PropInt nColor (0,250,T("|Color|"));
	PropDouble dTxtH(0, U(10),T("|Text Height|"));
	PropString sDimStyle(0,_DimStyles,T("|Dimstyle|"));	


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
		showDialog();
		
	// prompt user
	  	PrEntity ssE(T("Select entities with attached hardware"), Entity());
		Entity ents[0];
  		if (ssE.go()) {
			ents= ssE.set();
  		}
	
	// filter only entities with attached hardware
		ToolEnt tentAr[0];
		for(int i=0; i<ents.length();i++)
		{
			ToolEnt tentThis;
		// query genbeams	
			if (ents[i].bIsKindOf(GenBeam()))
			{
				GenBeam gb = (GenBeam)ents[i];
				Entity entTools[] = gb.eToolsConnected();
				for(int e=0; e<entTools.length();e++)
				{
					ToolEnt tent = (ToolEnt)entTools[e];
					if (tent.bIsValid())	tentThis = tent;					
				}
			}
			else
			{
				ToolEnt tent = (ToolEnt)ents[i];
				if (tent.bIsValid())	tentThis = tent;
			}
			
			if (tentThis.bIsValid() && tentAr.find(tentThis)<0 && (tentThis.hardWrComps().length()>0 || tentThis.bIsKindOf(FastenerAssemblyEnt())))
				tentAr.append(tentThis);	
			
		}// next i


	// collect all tslInsts of this script in the dwg
		Entity entAllTsl[0];
		Group gr;
		entAllTsl=gr.collectEntities(true,TslInst(),_kModelSpace);

	// clone instances	
		for(int i=0; i<tentAr.length();i++)
		{
		// make sure it does not have an instance of this tsl already attached
			int bOk = true;	
			for (int e=0;e<entAllTsl.length();e++)
			{
				TslInst tsl = (TslInst)entAllTsl[e];
				Entity entArTsl[] = tsl.entity();
				if (entArTsl.find(tentAr[i])>-1)
				{
					reportMessage("\n" + tentAr[i].typeDxfName() + " " + T("|already labled.|"));
					bOk=false;
					break;	
				}	
			}		
			if (!bOk)continue;	
			
			Point3d ptIns = tentAr[i].ptOrg();
		// overwrite ptIns for FAE's
			if (tentAr[i].bIsKindOf(FastenerAssemblyEnt()))
			{
				FastenerAssemblyEnt fae = (FastenerAssemblyEnt)tentAr[i];
				ptIns =fae.coordSys().ptOrg();
			}
			entAr.setLength(0);
			entAr.append(tentAr[i]);
			ptAr.setLength(0);	
			ptAr.append(ptIns);
			
			tslNew.dbCreate(sScriptname, vUcsX,vUcsY,gbAr, entAr, ptAr, 
				nArProps, dArProps, sArProps,_kModelSpace, mapTsl); // create new instance	
			if(tslNew.bIsValid())
				tslNew.setPropValuesFromCatalog(T("|_LastInserted|"));
			
		}
		
		eraseInstance();
		return;
	}// end on insert	
	
// validate
	if (_Entity.length()<1)
	{
		eraseInstance();
		return;	
	}
	Entity ents[0];
	ents = _Entity;

// standard
	Vector3d vx,vy,vz;
	vx = _XW;
	vy = _YW;
	vz = _ZW;
	_Pt0.vis(1);	


// collect index of properties to be displayed
	int nArShow[]= {nName,nArticleNumber,nDescription,nManufacturer,nModel,nMaterial,nQuantity,nScaleX,nScaleY,nScaleZ, nNorm, nCoating,nGrade, nType};
	
	// order by slected sequence
	for (int i=0;i<nArShow.length();i++)
		for (int j=0;j<nArShow.length()-1;j++)
			if (nArShow[j]>nArShow[j+1])
			{
				nArShow.swap(j,j+1);
				nArProp.swap(j,j+1);	
			}
	

// Display
	Display dp(nColor);
	dp.dimStyle(sDimStyle);
	dp.textHeight(dTxtH);	
		
// draw hardware info individual per toolent
	for(int i=0; i<ents.length();i++)
	{
		setDependencyOnEntity(ents[i]);
		ToolEnt tent = (ToolEnt)ents[i];
		
		if (!tent.bIsValid())continue;
		HardWrComp hwc[] = tent.hardWrComps();
		Point3d ptTxt = _Pt0;
		
	// get ref point for guideline display	
		Point3d ptRef = tent.ptOrg();
		if (tent.bIsKindOf(FastenerAssemblyEnt()))
		{
			FastenerAssemblyEnt fae = (FastenerAssemblyEnt)	tent;
			ptRef = fae.coordSys().ptOrg();
			
		}
		ptRef.vis(5);

	// if the instance is a tsl with model data draw it
		if (ents[i].bIsKindOf(TslInst()))
		{
			TslInst tsl = (TslInst)ents[i];
			String s;
			
			String sModelDesc = tsl.modelDescription();
			if (sModelDesc=="")sModelDesc =scriptName();
			
			
		// loop and concatenate properties to be displayed
			for (int p=0;p<nArProp.length();p++)
			{
				if (nArShow[p]<1)continue;
				if (nArProp[p]==4 || nArProp[p]==2) s = s+sModelDesc;
				else if (nArProp[p]==5) s = s+tsl.materialDescription();
				if (s!="") s=s+" ";					
			}
			s=s.trimLeft().trimRight();
			if(s!="")
			{
				dp.draw(s,ptTxt,vx,vy,0,0,_kDeviceX);
				ptTxt.transformBy(-(vx+vy+vz)*dTxtH*1.4);				
			}
		}	
	// the instance is a fastener assmebly: collect the data from it and draw it
		else if (ents[i].bIsKindOf(FastenerAssemblyEnt()))
		{
			FastenerAssemblyEnt fae = (FastenerAssemblyEnt)ents[i];
			FastenerAssemblyDef fadef(fae.definition());
			FastenerListComponent flc = fadef.listComponent();

			//FastenerSimpleComponent fscMain = fadef.mainComponent(fae.articleNumber());
			FastenerSimpleComponent fsc[0];
			fsc.append(fadef.mainComponent(fae.articleNumber()));
			fsc.append(fadef.headComponents());			
			fsc.append(fadef.tailComponents());
			
		// collect article number per component
			String sArArticle[0];		
			for (int f=0;f<fsc.length();f++)					
				sArArticle.append(fsc[f].articleData().articleNumber());
					
		// collect unique fsc's and its qty
			int nArQty[0];
			FastenerSimpleComponent fscUnique[0];
			String sArArticleUnique[0];
			for (int f=0;f<sArArticle.length();f++)				
			{
				int n = sArArticleUnique.find(sArArticle[f]);
				if (n<0)
				{
					sArArticleUnique.append(sArArticle[f]);
					fscUnique.append(fsc[f]);
					nArQty.append(1);		
				}	
				else
				{
					nArQty[n]+=1;		
				}
			}				
				
			//FastenerArticleData fad = fscMain.articleData();

			
			
			for (int h=0;h<fscUnique.length();h++)
			{
				String s;
				if (h>0)	s=s+"\n";
			// loop and concatenate properties to be displayed
				for (int p=0;p<nArProp.length();p++)
				{
					FastenerComponentData fcd = fscUnique[h].componentData();
					String sArticleNumber;
					if (h==0)	sArticleNumber=fae.articleNumber();
					
					int n6 = nArQty[h];
					double d7, d8;
					d7 = fscUnique[h].articleData().fastenerLength();
					d8 = fcd.mainDiameter();
					
					if (nArShow[p]<1)continue;
					if (nArProp[p]==0) s = s;//+hw.name();
					else if (nArProp[p]==1) s = s+sArticleNumber;
					else if (nArProp[p]==2) s = s+fcd.name();//+hw.description();
					else if (nArProp[p]==3) s = s+fcd.manufacturer();
					else if (nArProp[p]==4) s = s+fcd.model();
					else if (nArProp[p]==5) s = s+fcd.material();
					else if (nArProp[p]==6 && n6>1) s = s+n6 + T("|pcs|");
					else if (nArProp[p]==7 && d7>0) s = s.trimRight()+"x"+d7;//+hw.dScaleX();
					else if (nArProp[p]==8 && d8>0) s = s+d8;
					else if (nArProp[p]==9) s = s;//+hw.dScaleZ();
					else if (nArProp[p]==10) s = s+fcd.norm().makeUpper();
					else if (nArProp[p]==11) s = s+fcd.coating();
					else if (nArProp[p]==12) s = s+fcd.grade();
					else if (nArProp[p]==13) s = s+fcd.type();
					if (s!="") s=s+" ";					
				}
				s=s.trimLeft().trimRight();
				dp.draw(s,ptTxt,vx,vy,0,0,_kDeviceX);
				ptTxt.transformBy(-(vx+vy+vz)*dTxtH*1.4);	
			}			
			
		}
		
	// loop hardware components	
		for(int h=0; h<hwc.length();h++)
		{
			HardWrComp hw = tent.hardWrCompAt(h);
			String s;
			if (h>0)s=s+"\n";
		// loop and concatenate properties to be displayed
			for (int p=0;p<nArProp.length();p++)
			{
				if (nArShow[p]<1)continue;
				if (nArProp[p]==0) s = s+hw.name();
				else if (nArProp[p]==1) s = s+hw.articleNumber();
				else if (nArProp[p]==2) s = s+hw.description();
				else if (nArProp[p]==3) s = s+hw.manufacturer();
				else if (nArProp[p]==4) s = s+hw.model();
				else if (nArProp[p]==5) s = s+hw.material();
				else if (nArProp[p]==6) s = s+hw.quantity() + T("|pcs|");
				else if (nArProp[p]==7) s = s+hw.dScaleX();
				else if (nArProp[p]==8) s = s+hw.dScaleY();
				else if (nArProp[p]==9) s = s+hw.dScaleZ();
				if (s!="") s=s+" ";					
			}
			s=s.trimLeft().trimRight();
			dp.draw(s,ptTxt,vx,vy,0,0,_kDeviceX);
			ptTxt.transformBy(-(vx+vy+vz)*dTxtH*1.4);			
			
		}// next h
		
	}
	
// debug
	//dp.draw(scriptName(),_Pt0,vx,vy,1,0);	
	
	
		


#End
#BeginThumbnail
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
5HHH`****`"BBB@`HHHH`****`/_9
`



#End
