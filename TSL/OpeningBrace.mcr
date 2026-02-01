#Version 8
#BeginDescription
#Versions:
1.1 08.09.2023 HSB-19228: For 2 openings that have same kingstuds, make sure to make them same module; Delete existing brace when inserting tsl a second time 
1.0 28.08.2023 HSB-19228: Initial Author: Marsel Nakuci


This tsl creates a brace (horizontal beam) at openings
The brace will be positioned above the bottom plate
and below the opening (window or door)
It will span between 2 King studs of the opening
The TSL can be attached as an Element TSL

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords Manley,Timber,Frame,Brace,Opening,SF,Stick frame
#BeginContents
//region <History>
// #Versions
// 1.1 08.09.2023 HSB-19228: For 2 openings that have same kingstuds, make sure to make them same module; Delete existing brace when inserting tsl a second time Author: Marsel Nakuci
// 1.0 28.08.2023 HSB-19228: Initial Author: Marsel Nakuci

/// <insert Lang=en>
/// Select entities
/// </insert>

// <summary Lang=en>
// This tsl creates a brace (horizontal beam) at openings
// The brace will be positioned above the bottom plate
// and below the opening (window or door)
// It will span between 2 King studs of the opening
// The TSL can be attached as an Element TSL
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "mtfBraceOpening")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|"))) TSLCONTENT
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
//end Constants//endregion


//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
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
//		else	
//			showDialog();

	// prompt for elements
		PrEntity ssE(T("|Select SF Walls|"), ElementWallSF());
	  	if (ssE.go())
			_Element.append(ssE.elementSet());
			
//	// prompt for entities
//		Entity ents[0];
//		PrEntity ssE(T("|Select Openings|"), Opening());
//		if (ssE.go())
//			ents.append(ssE.set());
			
		
	// create TSL
		TslInst tslNew;	Vector3d vecXTsl=_XW; Vector3d vecYTsl=_YW;
		GenBeam gbsTsl[]={}; Entity entsTsl[1]; Point3d ptsTsl[]={_Pt0};
		int nProps[]={}; double dProps[]={}; String sProps[]={};
		Map mapTsl;
		
		
		for (int i=0;i<_Element.length();i++) 
		{ 
			entsTsl[0]=_Element[i];
			mapTsl.setInt("Mode",0);
			tslNew.dbCreate(scriptName(),vecXTsl,vecYTsl,gbsTsl,entsTsl,
				ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl);
		}//next i
		
		eraseInstance();
		return;
	}	
// end on insert	__________________//endregion
	
	
	
int nMode=_Map.getInt("Mode");
//return;
if(nMode==0)
{ 
	// Element mode
	ElementWallSF eSf;
	if(_Element.length()==1)
	{ 
		eSf=(ElementWallSF)_Element[0];
	}
	if(!eSf.bIsValid())
	{ 
		reportMessage("\n"+scriptName()+" "+T("|Stick frame wall not found|"));
		eraseInstance();
		return;
	}
	Opening ops[]=eSf.opening();
	if(ops.length()==0)
	{ 
		reportMessage("\n"+scriptName()+" "+T("|No Opening found for Stickframe|"));
		eraseInstance();
		return;
	}
	
// create TSL
	TslInst tslNew;	Vector3d vecXTsl=_XW; Vector3d vecYTsl=_YW;
	GenBeam gbsTsl[]={}; Entity entsTsl[1]; Point3d ptsTsl[]={_Pt0};
	int nProps[]={}; double dProps[]={}; String sProps[]={};
	Map mapTsl;
	
	for (int i=0;i<ops.length();i++) 
	{ 
		mapTsl.setInt("Mode",1);
		entsTsl[0]=ops[i];
		tslNew.dbCreate(scriptName(),vecXTsl,vecYTsl,gbsTsl,entsTsl,
			ptsTsl,nProps,dProps,sProps,_kModelSpace,mapTsl); 
	}//next i
	
	eraseInstance();
	return;
}


// Opening Mode
Opening op;
if(_Opening.length()==1)
{ 
	op=_Opening[0];
}

if(!op.bIsValid())
{ 
	reportMessage("\n"+scriptName()+" "+T("|No Opening found|"));
	eraseInstance();
	return;
}


// basic information
CoordSys csOp=op.coordSys();
Point3d ptOrgOp=csOp.ptOrg();
Vector3d vecXOp=csOp.vecX();
Vector3d vecYOp=csOp.vecY();
Vector3d vecZOp=csOp.vecZ();
_Pt0=ptOrgOp;
//return;
ElementWallSF eSf;
Element el=op.element();
// basic information
Point3d ptOrg=el.ptOrg();
Vector3d vecX=el.vecX();
Vector3d vecY=el.vecY();
Vector3d vecZ=el.vecZ();
eSf=(ElementWallSF)el;
if(!eSf.bIsValid())
{ 
	reportMessage("\n"+scriptName()+" "+T("|No SF Wall found|"));
	eraseInstance();
	return;
}


Beam beamsAll[]=eSf.beam();
Beam beamsHor[]=vecY.filterBeamsPerpendicularSort(beamsAll);
Beam beamsVer[]=vecX.filterBeamsPerpendicularSort(beamsAll);

if(beamsAll.length()==0)
{ 
	return;
}
PLine plShapeOp=op.plShape();
plShapeOp.transformBy(vecZ*U(300));
plShapeOp.vis(3);
plShapeOp.transformBy(-vecZ*U(300));

PlaneProfile ppShapeOp(plShapeOp);

Point3d ptMidOp=ppShapeOp.ptMid();

ptMidOp+=vecZ*vecZ.dotProduct(0.5*(ptOrg-vecZ*el.zone(0).dH()+ptOrg)-ptMidOp);
ptMidOp.vis(2);
// get bottom plate
Beam bmBott;
Beam beamsBott[]=Beam().filterBeamsHalfLineIntersectSort(beamsHor,ptMidOp,-vecY);
if(beamsBott.length()>0)
{ 
	bmBott=beamsBott.last();
}
if(!bmBott.bIsValid())
{ 
	reportMessage("\n"+scriptName()+" "+T("|Bottom Plate not found|"));
	eraseInstance();
	return;
}
// get king stud beams
Beam beamsLeft[]=Beam().filterBeamsHalfLineIntersectSort(beamsVer,ptMidOp,-vecX);
Beam beamsRight[]=Beam().filterBeamsHalfLineIntersectSort(beamsVer,ptMidOp,vecX);

Beam bmKingLeft;
Beam bmKingRight;

for (int i=0;i<beamsLeft.length();i++) 
{ 
	if(beamsLeft[i].type()==_kKingStud)
	{ 
		bmKingLeft=beamsLeft[i];
		break;
	}
}//next i
if(!bmKingLeft.bIsValid())
{ 
	reportMessage("\n"+scriptName()+" "+T("|Left King Stud not found|"));
	eraseInstance();
	return;
}
for (int i=0;i<beamsRight.length();i++) 
{ 
	if(beamsRight[i].type()==_kKingStud)
	{ 
		bmKingRight=beamsRight[i];
		break;
	}
}//next i
if(!bmKingRight.bIsValid())
{ 
	reportMessage("\n"+scriptName()+" "+T("|Right King Stud not found|"));
	eraseInstance();
	return;
}


bmBott.envelopeBody().vis(1);
bmKingLeft.envelopeBody().vis(4);
bmKingRight.envelopeBody().vis(4);

String sModuleL=bmKingLeft.module();
String sModuleR=bmKingRight.module();

if(sModuleR!=sModuleL)
{ 
	// get all beams of moduleR and make moduleL
	for (int i=0;i<beamsAll.length();i++) 
	{ 
		if(beamsAll[i].module()==sModuleR)
		{ 
			beamsAll[i].setModule(sModuleL);
		}
	}//next i
}

String sOpType=op.openingType();
int nn=_kOpening, nn1=_kWindow, nn2=_kDoor,nn3=_kAssembly;
// create brace beam
Point3d ptBm=bmBott.ptCen()+bmBott.vecD(vecY)*.5*bmBott.dD(vecY);
ptBm+=vecX*vecX.dotProduct(ptMidOp-ptBm);

ptBm.vis(5);

int ny=0,nz=1;
if(bmBott.vecY().isParallelTo(vecY))
{ 
	ny=1;
	nz=0;
}



//return;
Beam bmNew;
bmNew.dbCreate(ptBm,bmBott.vecX(),bmBott.vecY(),bmBott.vecZ(),U(1),bmBott.dW(),bmBott.dH(),0,ny,nz);
bmNew.stretchDynamicTo(bmKingLeft);
bmNew.stretchDynamicTo(bmKingRight);

// make sure to delete existing Brace
Body bdBrace=bmNew.envelopeBody();
Beam beamsIntersect[]=bdBrace.filterGenBeamsIntersect(beamsAll);
for (int i=beamsIntersect.length()-1; i>=0 ; i--) 
{ 
	if(beamsIntersect[i].name()=="BRACE")
	{ 
		beamsIntersect[i].dbErase();
	}
}//next i


bmNew.assignToElementGroup(eSf,true,0,'Z');
bmNew.setColor(1);
bmNew.setModule(bmKingLeft.module());
bmNew.setName("BRACE");
bmNew.setMaterial("CLS");
bmNew.setGrade("C16");
bmNew.setInformation("BRACE");

// get vertical beams that need stretching to the new beam
Point3d ptLook=bmNew.ptCen()+bmNew.vecD(vecY)*(.5*bmNew.dD(vecY)+U(1));
ptLook.vis(6);
Beam _beamsLeft[]=Beam().filterBeamsHalfLineIntersectSort(beamsVer,ptLook,-vecX);
Beam _beamsRight[]=Beam().filterBeamsHalfLineIntersectSort(beamsVer,ptLook,vecX);
// stretch vertical beams before the king stud
for (int i=0;i<_beamsLeft.length();i++) 
{ 
	if(_beamsLeft[i]==bmKingLeft)break;
	_beamsLeft[i].stretchDynamicTo(bmNew);
}//next i
for (int i=0;i<_beamsRight.length();i++) 
{ 
	if(_beamsRight[i]==bmKingRight)break;
	_beamsRight[i].stretchDynamicTo(bmNew);
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
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19228: For 2 openings that have same kingstuds, make sure to make them same module; Delete existing brace when inserting tsl a second time" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="9/8/2023 10:30:18 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19228: Initial" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="8/28/2023 1:44:54 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End