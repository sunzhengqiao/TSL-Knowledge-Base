#Version 8
#BeginDescription
#Versions:
Version 1.5 20/05/2025 HSB-23423: use body without extrusion to avoid extra static beamcuts when creating from body , Author Marsel Nakuci
Version 1.4 06.02.2025 HSB-23423: Fix extra static tool at female beam , Author: Marsel Nakuci
1.3 30.06.2023 HSB-19243: on insert, shorten the list of beam types by only showing types of existing beams
1.2 19.04.2023 HSB-18227: Fix when getting properties on mapio 
1.1 19.04.2023 HSB-18227: Support 8 type definitions 
1.0 17.04.2023 HSB-18227: Initial 



This tsl split beams based on their type and priority
Beam types is given a priorit index
If two beams intersect with each other, 
the beam with the highest priority index will be splitted
Beams with the same priority index will not get splitted
TSL can be inserted manually or 
it can be attached as a beam TSL during beam creation via _HSB_BEAMNEW
When beam is drawn, the TSL will get all other beams that this beam intersects
Based on the relative Type index the beams will get splitted







#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 5
#KeyWords Split,Beams,HSB_BEAMNEW
#BeginContents
//region <History>
// #Versions:
// 1.5 20/05/2025 HSB-23423: use body without extrusion to avoid extra static beamcuts when creating from body , Author Marsel Nakuci
// 1.4 06.02.2025 HSB-23423: Fix extra static tool at female beam , Author: Marsel Nakuci
// 1.3 30.06.2023 HSB-19243: on insert, shorten the list of beam types by only showing types of existing beams Author: Marsel Nakuci
// 1.2 19.04.2023 HSB-18227: Fix when getting properties on mapio Author: Marsel Nakuci
// 1.1 19.04.2023 HSB-18227: Support 8 type definitions Author: Marsel Nakuci
// 1.0 17.04.2023 HSB-18227: Initial Author: Marsel Nakuci

/// <insert Lang=en>
/// Select entities
/// </insert>

// <summary Lang=en>
// This tsl split beams based on their type and priority
// Beam types is given a priorit index
// If two beams intersect with each other, 
// the beam with the highest priority index will be splitted
// Beams with the same priority index will not get splitted
// TSL can be inserted manually or 
// it can be attached as a beam TSL during beam creation via _HSB_BEAMNEW
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "SplitBeamByType")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|"))) TSLCONTENT
//endregion

//region Constants 
	U(1,"mm");
	double dEps=U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick="TslDoubleClick";
	int bDebug=_bOnDebug;
	// read a potential mapObject defined by hsbDebugController
	{ 
		MapObject mo("hsbTSLDev" ,"hsbTSLDebugController");
		if (mo.bIsValid()){Map m=mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug=true; break;}}
		if(bDebug)reportMessage("\n"+ scriptName()+" starting "+_ThisInst.handle());
	}
	String sDefault=T("|_Default|");
	String sLastInserted=T("|_LastInserted|");
	String category=T("|General|");
	String sNoYes[]={T("|No|"), T("|Yes|")};
	String sDisabled=T("|Disabled|");
//end Constants//endregion

//region Properties
	String sBeamTypes[0];
	sBeamTypes.append(_BeamTypes);
	
	sBeamTypes=sBeamTypes.sorted();
	sBeamTypes.insertAt(0,sDisabled);
// Type 1
	String sTypePriority1Name=T("|Type 1|");
	PropString sTypePriority1(nStringIndex++, sBeamTypes, sTypePriority1Name);	
	sTypePriority1.setDescription(T("|Defines the priority for type 1.|")+" "+
		T("|Higher priorities are split when intersected with lower ones.|"));
	sTypePriority1.setCategory(category);
	
	String sTypePriorityValue1Name=T("|Priority value type 1|");
	PropInt nTypePriorityValue1(nIntIndex++, 0, sTypePriorityValue1Name);
	nTypePriorityValue1.setDescription(T("|Defines the priority value for type 1.|"));
	nTypePriorityValue1.setCategory(category);
	
// Type 2	
	String sTypePriority2Name=T("|Type 2|");
	PropString sTypePriority2(nStringIndex++, sBeamTypes, sTypePriority2Name);
	sTypePriority2.setDescription(T("|Defines the priority for type 2.|")+" "+
		T("|Higher priorities are split when intersected with lower ones.|"));
	sTypePriority2.setCategory(category);
	
	String sTypePriorityValue2Name=T("|Priority value type 2|");
	PropInt nTypePriorityValue2(nIntIndex++, 0, sTypePriorityValue2Name);
	nTypePriorityValue2.setDescription(T("|Defines the priority value for type 2.|"));
	nTypePriorityValue2.setCategory(category);
	
// Type 3
	String sTypePriority3Name=T("|Type 3|");
	PropString sTypePriority3(nStringIndex++, sBeamTypes, sTypePriority3Name);	
	sTypePriority3.setDescription(T("|Defines the priority for type 3.|")+" "+
		T("|Higher priorities are split when intersected with lower ones.|"));
	sTypePriority3.setCategory(category);
	
	String sTypePriorityValue3Name=T("|Priority value type 3|");
	PropInt nTypePriorityValue3(nIntIndex++, 0, sTypePriorityValue3Name);
	nTypePriorityValue3.setDescription(T("|Defines the priority value for type 3.|"));
	nTypePriorityValue3.setCategory(category);
	
// Type 4
	String sTypePriority4Name=T("|Type 4|");
	PropString sTypePriority4(nStringIndex++, sBeamTypes, sTypePriority4Name);
	sTypePriority4.setDescription(T("|Defines the priority for type 4.|")+" "+
		T("|Higher priorities are split when intersected with lower ones.|"));
	sTypePriority4.setCategory(category);
	
	String sTypePriorityValue4Name=T("|Priority value type 4|");
	PropInt nTypePriorityValue4(nIntIndex++, 0, sTypePriorityValue4Name);
	nTypePriorityValue4.setDescription(T("|Defines the priority value for type 4.|"));
	nTypePriorityValue4.setCategory(category);
	
// Type 5
	String sTypePriority5Name=T("|Type 5|");
	PropString sTypePriority5(nStringIndex++, sBeamTypes, sTypePriority5Name);
	sTypePriority5.setDescription(T("|Defines the priority for type 5.|")+" "+
		T("|Higher priorities are split when intersected with lower ones.|"));
	sTypePriority5.setCategory(category);
	
	String sTypePriorityValue5Name=T("|Priority value type 5|");
	PropInt nTypePriorityValue5(nIntIndex++, 0, sTypePriorityValue5Name);
	nTypePriorityValue5.setDescription(T("|Defines the priority value for type 5.|"));
	nTypePriorityValue5.setCategory(category);
// Type 6
	String sTypePriority6Name=T("|Type 6|");
	PropString sTypePriority6(nStringIndex++, sBeamTypes, sTypePriority6Name);
	sTypePriority6.setDescription(T("|Defines the priority for type 6.|")+" "+
		T("|Higher priorities are split when intersected with lower ones.|"));
	sTypePriority6.setCategory(category);
	
	String sTypePriorityValue6Name=T("|Priority value type 6|");
	PropInt nTypePriorityValue6(nIntIndex++, 0, sTypePriorityValue6Name);
	nTypePriorityValue6.setDescription(T("|Defines the priority value for type 6.|"));
	nTypePriorityValue6.setCategory(category);
// Type 7
	String sTypePriority7Name=T("|Type 7|");
	PropString sTypePriority7(nStringIndex++, sBeamTypes, sTypePriority7Name);
	sTypePriority7.setDescription(T("|Defines the priority for type 7.|")+" "+
		T("|Higher priorities are split when intersected with lower ones.|"));
	sTypePriority7.setCategory(category);
	
	String sTypePriorityValue7Name=T("|Priority value type 7|");
	PropInt nTypePriorityValue7(nIntIndex++, 0, sTypePriorityValue7Name);
	nTypePriorityValue7.setDescription(T("|Defines the priority value for type 7.|"));
	nTypePriorityValue7.setCategory(category);
// Type 8
	String sTypePriority8Name=T("|Type 8|");
	PropString sTypePriority8(nStringIndex++, sBeamTypes, sTypePriority8Name);
	sTypePriority8.setDescription(T("|Defines the priority for type 8.|")+" "+
		T("|Higher priorities are split when intersected with lower ones.|"));
	sTypePriority8.setCategory(category);
	
	String sTypePriorityValue8Name=T("|Priority value type 8|");
	PropInt nTypePriorityValue8(nIntIndex++, 0, sTypePriorityValue8Name);
	nTypePriorityValue8.setDescription(T("|Defines the priority value for type 8.|"));
	nTypePriorityValue8.setCategory(category);
//End Properties//endregion 
	
//region mapIO: support property dialog input via map on element creation
	{
		int bHasPropertyMap=_Map.hasMap("PROPSTRING[]") && _Map.hasMap("PROPINT[]");
		if (_bOnMapIO)
		{ 
			if (bHasPropertyMap)
				setPropValuesFromMap(_Map);
			showDialog();
		// HSB-19243:only names and values
			_Map=mapWithPropValues(true);
			return;
		}
		if (_bOnElementDeleted)
		{
			eraseInstance();
			return;
		}
//		else if (_bOnElementConstructed && bHasPropertyMap)
		else if (bHasPropertyMap)
		{ 
			setPropValuesFromMap(_Map);
			_Map=Map();
		}
	}
//End mapIO: support property dialog input via map on element creation//endregion
	
//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) {eraseInstance(); return;}
		
	// for insert state when TSL inserted manually
	// HSB-19243 get all available beam type that are there
		Entity entsQty[0];
		entsQty = Group().collectEntities(true, Beam(), _kModelSpace);
		sBeamTypes.setLength(0);
		for (int i = 0; i < entsQty.length(); i++)
		{ 
			Beam bmThis = (Beam) entsQty[i];
			int nTargetType = bmThis.type();
			String sTargetType = _BeamTypes[nTargetType];
			if (sBeamTypes.find(sTargetType) == -1)
			{ 
				sBeamTypes.append(sTargetType);
			}
		}
		sBeamTypes.insertAt(0,sDisabled);
		
		nStringIndex=0;
		nIntIndex=0;
		String sTypePriority1Name=T("|Type 1|");
		sTypePriority1=PropString (nStringIndex++, sBeamTypes, sTypePriority1Name);	
		sTypePriority1.setDescription(T("|Defines the priority for type 1.|")+" "+
			T("|Higher priorities are split when intersected with lower ones.|"));
		sTypePriority1.setCategory(category);
		
		String sTypePriorityValue1Name=T("|Priority value type 1|");
		PropInt nTypePriorityValue1(nIntIndex++, 0, sTypePriorityValue1Name);
		nTypePriorityValue1.setDescription(T("|Defines the priority value for type 1.|"));
		nTypePriorityValue1.setCategory(category);
		
	// Type 2	
		String sTypePriority2Name=T("|Type 2|");
		sTypePriority2=PropString (nStringIndex++, sBeamTypes, sTypePriority2Name);
		sTypePriority2.setDescription(T("|Defines the priority for type 2.|")+" "+
			T("|Higher priorities are split when intersected with lower ones.|"));
		sTypePriority2.setCategory(category);
		
		String sTypePriorityValue2Name=T("|Priority value type 2|");
		nTypePriorityValue2=PropInt (nIntIndex++, 0, sTypePriorityValue2Name);
		nTypePriorityValue2.setDescription(T("|Defines the priority value for type 2.|"));
		nTypePriorityValue2.setCategory(category);
		
	// Type 3
		String sTypePriority3Name=T("|Type 3|");
		sTypePriority3=PropString (nStringIndex++, sBeamTypes, sTypePriority3Name);	
		sTypePriority3.setDescription(T("|Defines the priority for type 3.|")+" "+
			T("|Higher priorities are split when intersected with lower ones.|"));
		sTypePriority3.setCategory(category);
		
		String sTypePriorityValue3Name=T("|Priority value type 3|");
		nTypePriorityValue3=PropInt (nIntIndex++, 0, sTypePriorityValue3Name);
		nTypePriorityValue3.setDescription(T("|Defines the priority value for type 3.|"));
		nTypePriorityValue3.setCategory(category);
		
	// Type 4
		String sTypePriority4Name=T("|Type 4|");
		sTypePriority4=PropString (nStringIndex++, sBeamTypes, sTypePriority4Name);
		sTypePriority4.setDescription(T("|Defines the priority for type 4.|")+" "+
			T("|Higher priorities are split when intersected with lower ones.|"));
		sTypePriority4.setCategory(category);
		
		String sTypePriorityValue4Name=T("|Priority value type 4|");
		nTypePriorityValue4=PropInt (nIntIndex++, 0, sTypePriorityValue4Name);
		nTypePriorityValue4.setDescription(T("|Defines the priority value for type 4.|"));
		nTypePriorityValue4.setCategory(category);
		
	// Type 5
		String sTypePriority5Name=T("|Type 5|");
		sTypePriority5=PropString (nStringIndex++, sBeamTypes, sTypePriority5Name);
		sTypePriority5.setDescription(T("|Defines the priority for type 5.|")+" "+
			T("|Higher priorities are split when intersected with lower ones.|"));
		sTypePriority5.setCategory(category);
		
		String sTypePriorityValue5Name=T("|Priority value type 5|");
		nTypePriorityValue5=PropInt (nIntIndex++, 0, sTypePriorityValue5Name);
		nTypePriorityValue5.setDescription(T("|Defines the priority value for type 5.|"));
		nTypePriorityValue5.setCategory(category);
	// Type 6
		String sTypePriority6Name=T("|Type 6|");
		sTypePriority6=PropString (nStringIndex++, sBeamTypes, sTypePriority6Name);
		sTypePriority6.setDescription(T("|Defines the priority for type 6.|")+" "+
			T("|Higher priorities are split when intersected with lower ones.|"));
		sTypePriority6.setCategory(category);
		
		String sTypePriorityValue6Name=T("|Priority value type 6|");
		nTypePriorityValue6=PropInt (nIntIndex++, 0, sTypePriorityValue6Name);
		nTypePriorityValue6.setDescription(T("|Defines the priority value for type 6.|"));
		nTypePriorityValue6.setCategory(category);
	// Type 7
		String sTypePriority7Name=T("|Type 7|");
		sTypePriority7=PropString (nStringIndex++, sBeamTypes, sTypePriority7Name);
		sTypePriority7.setDescription(T("|Defines the priority for type 7.|")+" "+
			T("|Higher priorities are split when intersected with lower ones.|"));
		sTypePriority7.setCategory(category);
		
		String sTypePriorityValue7Name=T("|Priority value type 7|");
		nTypePriorityValue7=PropInt (nIntIndex++, 0, sTypePriorityValue7Name);
		nTypePriorityValue7.setDescription(T("|Defines the priority value for type 7.|"));
		nTypePriorityValue7.setCategory(category);
	// Type 8
		String sTypePriority8Name=T("|Type 8|");
		sTypePriority8=PropString (nStringIndex++, sBeamTypes, sTypePriority8Name);
		sTypePriority8.setDescription(T("|Defines the priority for type 8.|")+" "+
			T("|Higher priorities are split when intersected with lower ones.|"));
		sTypePriority8.setCategory(category);
		
		String sTypePriorityValue8Name=T("|Priority value type 8|");
		nTypePriorityValue8=PropInt (nIntIndex++, 0, sTypePriorityValue8Name);
		nTypePriorityValue8.setDescription(T("|Defines the priority value for type 8.|"));
		nTypePriorityValue8.setCategory(category);
		
	// silent/dialog
		if (_kExecuteKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			if (sEntries.findNoCase(_kExecuteKey,-1)>-1)
				setPropValuesFromCatalog(_kExecuteKey);
			else
				setPropValuesFromCatalog(sLastInserted);
		}
	// standard dialog
		else
			showDialog();
		
		// prompt for beams
		Beam beams[0];
		PrEntity ssE(T("|Select beams|"), Beam());
		if (ssE.go())
			beams.append(ssE.beamSet());
		
	// create TSL
		TslInst tslNew; Vector3d vecXTsl=_XW; Vector3d vecYTsl=_YW;
		GenBeam gbsTsl[1]; Entity entsTsl[]={}; Point3d ptsTsl[]={_Pt0};
		int nProps[]={nTypePriorityValue1,nTypePriorityValue2,
			nTypePriorityValue3,nTypePriorityValue4,nTypePriorityValue5,nTypePriorityValue6,
			nTypePriorityValue7,nTypePriorityValue8};
		double dProps[]={};
		String sProps[]={sTypePriority1,sTypePriority2,sTypePriority3,sTypePriority4,
			sTypePriority5,sTypePriority6,sTypePriority7,sTypePriority8};
		Map mapTsl;
		
		for (int i=0;i<beams.length();i++) 
		{ 
			Beam bm=beams[i];
			gbsTsl[0]=bm;
			tslNew.dbCreate(scriptName(),vecXTsl,vecYTsl,gbsTsl,entsTsl,
				ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
		}//next i
		
		eraseInstance();
		return;
	}
// end on insert	__________________//endregion

//reportMessage("\n"+scriptName()+" "+T("|Triggered|"));

Beam bm;
if(_Beam.length()==1)
{ 
	bm=_Beam[0];
}
if(!bm.bIsValid())
{ 
	reportMessage("\n"+scriptName()+" "+T("|One beam needed|"));
	eraseInstance();
	return;
}

// basic information
Point3d ptCen=bm.ptCen();
Vector3d vecX=bm.vecX();
Vector3d vecY=bm.vecY();
Vector3d vecZ=bm.vecZ();
_Pt0=ptCen;

String sTypes[]={sTypePriority1,sTypePriority2,
	sTypePriority3,sTypePriority4,sTypePriority5,sTypePriority6,sTypePriority7,sTypePriority8};
int nTypeIndexes[]={nTypePriorityValue1,nTypePriorityValue2,
	nTypePriorityValue3,nTypePriorityValue4,nTypePriorityValue5,nTypePriorityValue6,
	nTypePriorityValue7,nTypePriorityValue8};


for (int i=sTypes.length()-1; i>=0 ; i--) 
{ 
	if(sTypes[i]==sDisabled)
	{ 
	// remove disabled types
		sTypes.removeAt(i);
		nTypeIndexes.removeAt(i);
	}
}//next i
if(sTypes.length()==0)
{ 
// no type defined
	reportMessage("\n"+scriptName()+" "+T("|No beam type defined|"));
	eraseInstance();
	return;
}

if(sTypes.find(_BeamTypes[bm.type()])<0)
{ 
	reportMessage("\n"+scriptName()+" "+T("|Type for this beam not found|")+" "+_BeamTypes[bm.type()]);
	eraseInstance();
	return;
}

int nTypeIndexBm=nTypeIndexes[sTypes.find(_BeamTypes[bm.type()])];

// get all beams this beam intersects
Entity entBeams[]=Group().collectEntities(true,Beam(),_kModelSpace);
Beam beams[0];
for (int i=0;i<entBeams.length();i++) 
{ 
	Beam bmI=(Beam)entBeams[i];
	if(bmI.bIsValid() && beams.find(bmI)<0)
	{ 
		beams.append(bmI);
	}
}//next i
if(beams.find(bm)>-1)
{ 
	beams.removeAt(beams.find(bm));
}

Beam bmIntersections[0];
Body bd=bm.envelopeBody(true,true);
Beam females[0];
for (int i=0;i<beams.length();i++) 
{ 
	Beam bmI=beams[i];
	Body bdI=bmI.envelopeBody(true,true);
	if(bd.hasIntersection(bdI))
	{ 
		bmIntersections.append(bmI);
	}
}//next i

if(bmIntersections.length()==0)
{ 
	reportMessage("\n"+scriptName()+" "+T("|Beam has no intersection|"));
	eraseInstance();
	return;
}

// beams to be splitted Type index>type index of this beam
Beam bmIntersectionsSplitted[0];
// beams that will split this beam Type index<type index of this beam
Beam bmIntersectionsSplit[0];
// neither will be splitted, type index is equal or type not included
Beam bmIntersectionsEqual[0];

for (int i=0;i<bmIntersections.length();i++) 
{ 
	String sTypeI=_BeamTypes[bmIntersections[i].type()];
	if(sTypes.find(sTypeI)<0)
	{
		bmIntersectionsEqual.append(bmIntersections[i]);
		continue;
	}
	int nTypeI=nTypeIndexes[sTypes.find(sTypeI)];
	if(nTypeIndexBm==nTypeI)
	{ 
		bmIntersectionsEqual.append(bmIntersections[i]);
		continue;
	}
	if(nTypeIndexBm>nTypeI)
	{ 
		// it will split bm
		bmIntersectionsSplit.append(bmIntersections[i]);
		continue;
	}
	if(nTypeIndexBm<nTypeI)
	{ 
		// will get splitted by bm
		bmIntersectionsSplitted.append(bmIntersections[i]);
	}
}//next i

// split bmIntersectionsSplitted
Beam bmMalesCreated[0];
for (int i=bmIntersectionsSplitted.length()-1;i>=0;i--)
{ 
	Beam & b=bmIntersectionsSplitted[i];
//	Body bd=b.envelopeBody(true, true);
	Body bd=b.envelopeBody(false, true);
	bd.vis(6);
	Body bdA = bd;
	
	Beam bmJ=bm;
	Body bdB;
	bdB=Body (bmJ.ptCen(), bmJ.vecX(), bmJ.vecY(), bmJ.vecZ(), 
		bmJ.solidLength(), bmJ.solidWidth(), bmJ.solidHeight(),0,0,0);
//		bmJ.solidLength(), bmJ.solidWidth()+2*dGap, bmJ.solidHeight()+2*dGap,0,0,0);
	
	bdA.subPart(bdB);
	Body lumps[]=bdA.decomposeIntoLumps();
	for (int j=0;j<lumps.length();j++) 
	{ 
		Body bdConv = lumps[j];
		if (bdConv.lengthInDirection(b.vecX())<U(20))
		{
			continue;
		}
		if (bDebug)
			bdConv.vis(j);
		else
		{ 
			Beam _bm;
			_bm.dbCreate(bdConv, b.ptCen(), b.vecX(), b.vecY(), b.vecZ(), b.dW(), b.dH());	

			_bm.setColor(b.color());
			_bm.setMaterial(b.material());
			_bm.setName(b.name());
			_bm.setType(b.type());
			_bm.setInformation(b.information());
			_bm.setGrade(b.grade());
			_bm.setLabel(b.label());
			_bm.setSubLabel(b.subLabel());
			_bm.setSubLabel2(b.subLabel2());

			if (b.extrProfile()!= _kExtrProfRectangular && b.extrProfile().length()>0)
				_bm.setExtrProfile(b.extrProfile());
			
//			_bm.assignToElementGroup(el, true, b.myZoneIndex(), 'Z');
			_bm.assignToGroups(b);
			bmMalesCreated.append(_bm);
		}
	}//next j
	
	if (!bDebug && b.bIsValid())
		b.dbErase();
	
	
}//next i

//for (int i=bmFemalesCreated.length()-1;i>=0;i--)
{ 
	Beam & b=bm;
	Body bd=b.envelopeBody(false, true);
//	Body bd=b.envelopeBody(true, true);
	bd.vis(6);
	Body bdA=bd;
	// HSB-23423
	int bBodiesIntersect;
	for (int j=0;j<bmIntersectionsSplit.length();j++)
	{ 
		Beam bmJ=bmIntersectionsSplit[j];
		Body bdB;
		bdB=Body (bmJ.ptCen(),bmJ.vecX(),bmJ.vecY(),bmJ.vecZ(), 
			bmJ.solidLength(),bmJ.solidWidth(),bmJ.solidHeight(),0,0,0);
	//		bmJ.solidLength(), bmJ.solidWidth()+2*dGap, bmJ.solidHeight()+2*dGap,0,0,0);
		// HSB-23423
		Body bdInter=bdA;
		int bHasInter=bdInter.intersectWith(bdB);
		if(bHasInter && bdInter.volume()>pow(U(10),3))
		{
			bBodiesIntersect=true;
			bdA.subPart(bdB);
		}
	}
	
	if(bBodiesIntersect)
	{ 
		// HSB-23423: 
		Body lumps[]=bdA.decomposeIntoLumps();
		for (int j=0;j<lumps.length();j++) 
		{ 
			Body bdConv = lumps[j];
			if (bdConv.lengthInDirection(b.vecX())<U(20))
			{
				continue;
			}
			if (bDebug)
				bdConv.vis(j);
			else
			{ 
				Beam _bm;
				_bm.dbCreate(bdConv, b.ptCen(), b.vecX(), b.vecY(), b.vecZ(), b.dW(), b.dH());	
	
				_bm.setColor(b.color());
				_bm.setMaterial(b.material());
				_bm.setName(b.name());
				_bm.setType(b.type());
				_bm.setInformation(b.information());
				_bm.setGrade(b.grade());
				_bm.setLabel(b.label());
				_bm.setSubLabel(b.subLabel());
				_bm.setSubLabel2(b.subLabel2());
	
				if (b.extrProfile()!= _kExtrProfRectangular && b.extrProfile().length()>0)
					_bm.setExtrProfile(b.extrProfile());
//				_bm.removeToolsStaticOfType(BeamCut());
	//			_bm.assignToElementGroup(el, true, b.myZoneIndex(), 'Z');
				_bm.assignToGroups(b);
			}
		}//next j
		
		if (!bDebug && b.bIsValid())
			b.dbErase();
	}
}//next i


eraseInstance();
return;









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
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="522" />
        <int nm="BreakPoint" vl="556" />
        <int nm="BreakPoint" vl="558" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23423: use body without extrusion to avoid extra static beamcuts when creating from body" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="5/20/2025 3:28:23 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23423: Fix extra static tool at female beam" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="2/6/2025 10:23:06 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19243: on insert, shorten the list of beam types by only showing types of existing beams" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="6/30/2023 3:29:35 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18227: Fix when getting properties on mapio" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="4/19/2023 5:08:22 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18227: Support 8 type definitions" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="4/19/2023 7:46:11 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18227: Initial" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="4/17/2023 10:51:46 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End