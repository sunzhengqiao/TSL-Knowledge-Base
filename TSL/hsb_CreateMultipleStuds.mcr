#Version 8
#BeginDescription
Creates multiple studs replacing the existing one, it will create them as a module.

#Versions
Version 2.1 11.01.2022 HSB-14018 instance remains in drawing, property changes only applied when reconstructing element 

V2.0__17jun2020__Bugfix ignore module beams nils.gregor@hsbcad.de
V1.9__19August2019__Ignore module beams
V1.8__19August2019__Revised to look only at beams from Zone 0
V1.7__06Sept2017__Will not force styd type and hsbID assignement
V1.6_25July2017__Revised to support staggered stud layout
Last modified by: Alberto Jena (aj@hsb-cad.com)
11.11.2016  -  version 1.5



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 2
#MinorVersion 1
#KeyWords 
#BeginContents
//region <History>
// #Versions
// 2.1 11.01.2022 HSB-14018 instance remains in drawing, property changes only applied when reconstructing element , Author Thorsten Huck

/// <insert Lang=en>
/// Select elements
/// </insert>

// <summary Lang=en>
// This tsl creates a stud distribution based on default studs
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsb_CreateMultipleStuds")) TSLCONTENT
//endregion

//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	// read a potential mapObject defined by hsbDebugController
	{ 
		MapObject mo("hsbTSLDev" ,"hsbTSLDebugController");
		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true;	break;}}
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		
	}
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	
	_ThisInst.setSequenceNumber(-40);
//end Constants//endregion


//region Properties
	PropInt nNumberOfStuds(0, 2, T("|Number of studs|"));
	
	PropInt nColorStuds(1, 32, T("|Color of studs|"));
	nColorStuds.setDescription(T("|0 = byBeam|"));
	PropString sCreateModule(0, sNoYes, T("|Create Beams as Modules|"),0);
			
//End Properties//endregion 


//region OnInsert

// Load the values from the catalog
	if (_bOnDbCreated || _bOnInsert) 
		setPropValuesFromCatalog(_kExecuteKey);

	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		if (_kExecuteKey=="")
			showDialogOnce();
		
		PrEntity ssE("\nSelect a set of elements",ElementWall());	
	  	if (ssE.go()) { 
			_Element.append(ssE.elementSet());
		}
		
				// declare tsl props
			TslInst tsl;
			String strScriptName=scriptName();
			Vector3d vecUcsX = _XW;
			Vector3d vecUcsY = _YW;
			Element lstElements[0];
			Beam lstBeams[0];
			Point3d lstPoints[0];
			int lstPropInt[0];
			double lstPropDouble[0];
			String lstPropString[0];
			
			lstPropInt.append(nNumberOfStuds);
			lstPropInt.append(nColorStuds);
			
			lstPropString.append(sCreateModule);
			
			Map mpToClone;
			mpToClone.setInt("ExecutionMode",0);
			
			for( int e=0; e<_Element.length(); e++ )
			{
				lstElements.setLength(0);
				lstElements.append(_Element[e]);
			
				TslInst tsl;
				tsl.dbCreate(strScriptName, vecUcsX,vecUcsY, lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mpToClone);
			}
			
			eraseInstance();
			return;
		
	}
		
//endregion 


//region defaults
	int bModule = sNoYes.find(sCreateModule,0);
	
	if( _Element.length() == 0 )
	{
		eraseInstance();
		return;
	}
	
	if (_bOnElementConstructed )
		_Map.setInt("ExecutionMode",0);

	int nExecutionMode = _Map.hasInt("ExecutionMode")?_Map.getInt("ExecutionMode"):1;
	int arValidBeamType[]={_kStud, _kSFJackOverOpening, _kSFJackUnderOpening};
	String arHsbIdsNoCopy[] = { "95", "96"};		
//endregion 

//region Element
	Element el=_Element[0];
	
	if (!el.bIsValid())
	{
		eraseInstance();
		return;
	}
	
	_Pt0=el.ptOrg();
	_Pt0=_Pt0+el.vecX()*U(20);
	_Pt0=_Pt0-el.vecZ()*U(20);
	
	
	
	
	CoordSys csEl = el.coordSys();
	Beam arBeam[0];
	Beam bmAllZones[] = el.beam();	
	for (int i=0;i<bmAllZones.length();i++) 
	{ 
		Beam bm = bmAllZones[i]; 
		if(bm.myZoneIndex() == 0) arBeam.append(bm); 
	}
		
	Vector3d vecX = csEl.vecX();
	Vector3d vecY = csEl.vecY();	
	Vector3d vecZ = csEl.vecZ();

//See if the wall is done constructing
	int beamCount = arBeam.length();
	for(int i=0;i<arBeam.length(); i++)
	{
		if(arBeam[i].panhand().bIsValid())beamCount--;
	}
	
	//wait
	if(beamCount < 1)
		return;

//endregion 

//region Modify
	if (nExecutionMode==0)
	{
		//reportNotice("yes"+scriptName());
		
		
		
		
		
		//_Pt0=csEl.ptOrg();
		
		//Create beams
		Beam arBmNew[0];
		int arBMinSet[0];
		int arBMaxSet[0];
		double arDDistMin[0];
		double arDDistMax[0];
		Beam arBmMin[0];
		Beam arBmMax[0];
		Beam bmToErase[0];
		Plane plnZ(csEl.ptOrg(), csEl.vecZ());
		Plane pnElBase(csEl.ptOrg(), vecY);
		
		int nStuds=nNumberOfStuds;
		
		
		//__Collect items not to touch
		Body bdNoTouch;
		Beam bms[0];
		int arTypesNoTouch [] ={ _kSFSupportingBeam, _kKingStud };
		for (int b=0; b<arBeam.length(); b++)
		{
			Beam bm=arBeam[b];
			
			if( arTypesNoTouch.find(bm.type()) > -1) bdNoTouch.combine(bm.envelopeBody());
			//if(bm.module().length() > 0) bdNoTouch.combine(bm.envelopeBody());		
		}
		
		
		bdNoTouch.vis(2);
		
		for (int b=0; b<arBeam.length(); b++)
		{
			Beam bm=arBeam[b];
			
			if(bm.module().length() > 0)
				continue;
			
			if (arValidBeamType.find(bm.type()) != -1 && arHsbIdsNoCopy.find(bm.hsbId()) == -1)
			{	
				if (bm.beamCode().token(0)!="")
					continue;
				
				Point3d ptToCreate=bm.ptCen();
				Plane pnBmMid (ptToCreate, vecZ);
				double dStudX = bm.dD(vecX);
				double dStudZ = bm.dD(vecZ);
				//ptToCreate=plnZ.closestPointTo(ptToCreate);
				//ptToCreate=ptToCreate + csEl.vecY() * U(200) - csEl.vecX() * (el.dBeamHeight()/2) * (nStuds-1);
				//ptToCreate=ptToCreate + csEl.vecY() * U(200) - csEl.vecX() * (dStudX/2) * (nStuds-1);
				ptToCreate=ptToCreate - csEl.vecX() * (dStudX/2) * (nStuds-1);
				
				String sModule=el.handle();
				sModule=sModule+b;
				int iColor = nColorStuds;
				
				if (bm.module()!="")
				{ 
					sModule = bm.module();
					if(iColor==0)
						iColor = bm.color();
				}
				for (int i=0; i<nStuds; i++)
				{
					Point3d ptBm=ptToCreate+csEl.vecX()*(dStudX*i);
					
					//check for room
					Body bdTest(ptBm, csEl.vecY(), csEl.vecX(), -csEl.vecZ(), U(100), dStudX, dStudZ, 1, 0, 0);
					if(bdTest.hasIntersection( bdNoTouch ))continue;
					
					Beam bmStud;
					bmStud.dbCreate(ptBm, csEl.vecY(), csEl.vecX(), -csEl.vecZ(), U(100), dStudX, dStudZ, 1, 0, 0);
					
					bmStud.setColor(iColor);
					bmStud.assignToElementGroup(el, TRUE, 0, 'Z');
					bmStud.setName(bm.name());
					bmStud.setMaterial(bm.material());
					bmStud.setGrade(bm.grade());
					bmStud.setLabel(bm.label());
					bmStud.setSubLabel(bm.subLabel());
					bmStud.setInformation(bm.information());
					bmStud.setBeamCode(bm.beamCode());
					bmStud.setType(bm.type());
					bmStud.setHsbId(bm.hsbId());
		
					if (nStuds>1 && bModule)
					{
						bmStud.setModule(sModule);
					}
					
		
	
					//fill arrays
					arBmNew.append(bmStud);
					arBMinSet.append(FALSE);
					arBMaxSet.append(FALSE);
					arDDistMin.append(double());
					arDDistMax.append(double());
					arBmMin.append(Beam());
					arBmMax.append(Beam());
	
				}
				bmToErase.append(bm);
			}
		}
		for (int i=0; i<bmToErase.length(); i++)
		{
			bmToErase[i].dbErase();
		}
	
		//Stretch beams
		Beam arBm[] = el.beam();
		Beam bmBlocking[0];
		for (int b=0; b<arBm.length(); b++)
		{
			if (arBm[b].type() == _kSFBlocking || arBm[b].type() == _kBlocking)	
			{
				bmBlocking.append(arBm[b]);
				arBm.removeAt(b);	
				b--;
			}
		}
		
		//Stretch beams
		//Beam arBm[] = el.beam();
		for( int i=0;i<arBmNew.length();i++ )
		{
			Beam bmNew = arBmNew[i];
			Line lnBmNewX(bmNew.ptCen(), bmNew.vecX());
			
			for( int j=0;j<arBm.length();j++ )
			{
				Beam bm = arBm[j];
				Body bdBm = bm.realBody();
				
				if( bm.vecX().isParallelTo(csEl.vecY()) )continue;
				Point3d ptBmMin = bdBm.ptCen() - bm.vecX() * .5 * bdBm.lengthInDirection(bm.vecX());
				Point3d ptBmMax = bdBm.ptCen() + bm.vecX() * .5 * bdBm.lengthInDirection(bm.vecX());
				
				Point3d ptIntersect = lnBmNewX.intersect(Plane(bm.ptCen(), csEl.vecZ().crossProduct(bm.vecX())),0);
				if( (csEl.vecX().dotProduct(ptIntersect - ptBmMin) * csEl.vecX().dotProduct(ptIntersect - ptBmMax)) > 0 )continue;
				
				double dDist = csEl.vecY().dotProduct(ptIntersect - bmNew.ptCen());
				if( dDist <= 0 ){
					if( !arBMinSet[i] ){
						arBMinSet[i] = TRUE;
						arDDistMin[i] = dDist;
						arBmMin[i] = bm;
					}
					else{
						if( (dDist-arDDistMin[i]) > dEps ){
							arDDistMin[i] = dDist;
							arBmMin[i] = bm;
						}
					}
				}
				else{
					if( !arBMaxSet[i] ){
						arBMaxSet[i] = TRUE;
						arDDistMax[i] = dDist;
						arBmMax[i] = bm;
					}
					else{
						if( (arDDistMax[i] - dDist) > dEps ){
							arDDistMax[i] = dDist;
							arBmMax[i] = bm;
						}
					}
				}			
			}
			
			bmNew.stretchStaticTo(arBmMin[i], true);
			bmNew.stretchStaticTo(arBmMax[i], true);	
		}
		
		PlaneProfile ppAllBm(plnZ);
		for( int i=0;i<arBmNew.length();i++ )
		{
			Beam bmNew = arBmNew[i];
			PlaneProfile ppBm=bmNew.realBody().shadowProfile(plnZ);
			ppBm.shrink(-U(5));
			ppAllBm.unionWith(ppBm);
		}
		ppAllBm.shrink(U(5));
		
		for (int i=0; i<bmBlocking.length(); i++)
		{
			Beam bm=bmBlocking[i];
			PlaneProfile ppBlocking=bm.realBody().shadowProfile(plnZ);
			double dBlockingArea=ppBlocking.area()/U(1)*U(1);
			PlaneProfile ppThisBlocking=ppBlocking;
			ppBlocking.intersectWith(ppAllBm);
			if (ppBlocking.area()/U(1)*U(1) > U(2)*U(2))
			{
				//reportNotice("\nBlocking");
				if (dBlockingArea-ppBlocking.area()/U(1)*U(1) < U(3)*U(3))//Its almost fully cover by the pointload
				{
					//reportNotice("\nErase");
					bm.dbErase();
					continue;
				}
			}
				
			Beam bmAux1[0];
			bmAux1=Beam().filterBeamsHalfLineIntersectSort(arBm, bm.ptCen(), bm.vecX());
			if (bmAux1.length()>0)
				bm.stretchStaticTo(bmAux1[0], true);
			
			Beam bmAux2[0];
			bmAux2=Beam().filterBeamsHalfLineIntersectSort(arBm, bm.ptCen(), -bm.vecX());
			if (bmAux2.length()>0)
				bm.stretchStaticTo(bmAux2[0], true);
		}
		_Map.setInt("ExecutionMode", 1);
	}
		
//endregion 

//region Display
	assignToElementGroup(el, TRUE, 0, 'E');
		
	Display dp(-1);
	LineSeg ls (_Pt0-_XW*U(5), _Pt0+_XW*U(5));
	LineSeg ls2 (_Pt0-_YW*U(5), _Pt0+_YW*U(5));
	dp.draw(ls);
	dp.draw(ls2);		
//endregion 







#End
#BeginThumbnail

















#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14018 instance remains in drawing, property changes only applied when reconstructing element" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="1/11/2022 9:54:11 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End