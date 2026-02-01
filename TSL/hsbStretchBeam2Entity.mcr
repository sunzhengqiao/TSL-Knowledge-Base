#Version 8
#BeginDescription
#Versions:
1.0 10.05.2022 HSB-15447: Init Author: Marsel Nakuci



This tsl stretches beams to a bounding entity (beam, or TrussEntity)
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
//region <History>
// #Versions
// 1.0 10.05.2022 HSB-15447: Init Author: Marsel Nakuci
	
/// <insert Lang=en>
/// Select entities
/// </insert>
	
// <summary Lang=en>
// This tsl stretches beams to a bounding entity (beam, or TrussEntity) 
// </summary>
	
// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbStretchBeam2Entity")) TSLCONTENT
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
		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true; break;}}
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());
	}
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
//end Constants//endregion
	
//region Properties
	String sGapName=T("|Gap|");
	PropDouble dGap(nDoubleIndex++, U(0), sGapName);
	dGap.setDescription(T("|Defines the Gap|"));
	dGap.setCategory(category);
//End Properties//endregion
	
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
		else
			showDialog();
		
	// prompt beam selection of beams to be stretched
		Beam beamsToStretch[0];
		PrEntity ssE(T("|Select beams to stretch|"), Beam());
		if (ssE.go())
			beamsToStretch.append(ssE.beamSet());
		
	// prompt for entities where they will be stretched
	// prompt for entities
		Entity ents[0];
		PrEntity ssE2(T("|Select bounding entities|"), Entity());
		ssE2.addAllowedClass(TrussEntity());
		if (ssE2.go())
			ents.append(ssE2.set());
		
	// distribute
	// create TSL
		TslInst tslNew; Vector3d vecXTsl= _XW; Vector3d vecYTsl= _YW;
		GenBeam gbsTsl[] = {}; Entity entsTsl[] = {}; Point3d ptsTsl[] = {_Pt0};
		int nProps[]={};
		double dProps[]={dGap};
		String sProps[]={};
		Map mapTsl;
		
	//	
		mapTsl.setEntityArray(ents,true,"entsBounding","entsBounding","entsBounding");
		for (int ib=0;ib<beamsToStretch.length();ib++)
		{ 
			Beam bmI = beamsToStretch[ib];
			
			// find the left and the right bounding entity
			gbsTsl.setLength(0);
			gbsTsl.append(bmI);
		// create TSL
			tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl,
				ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
		}//next ib
		
		eraseInstance();
		return;
	}
// end on insert	__________________//endregion

if(_Beam.length()!=1)
{
	reportMessage("\n" + scriptName() + " " + T("|Beam for stretching is needed|"));
	eraseInstance();
	return;
}

Beam bm = _Beam[0];
// basic information
Point3d ptCen = bm.ptCen();
Vector3d vecX = bm.vecX();
Vector3d vecY = bm.vecY();
Vector3d vecZ = bm.vecZ();

Element el = bm.element();
_Pt0 = ptCen;
//return;

if(!el.bIsValid())
{ 
	reportMessage("\n"+scriptName()+" "+T("|No element found|"));
	eraseInstance();
	return;
}
Entity _entToStretchTo[]=_Map.getEntityArray("entsBounding","entsBounding","entsBounding");
if(_entToStretchTo.length()==0)
{ 
	reportMessage("\n"+scriptName()+" "+T("|No bounding entities found|"));
	eraseInstance();
	return;
}

// left
Entity entToStretchLeft;
Quader quaderToStretchLeft;
double dClosestLeft = U(10e7);
int iStretchLeft;
// right
Entity entToStretchRight;
Quader quaderToStretchRight;
double dClosestRight = U(10e7);
int iStretchRight;

for (int ient = 0; ient < _entToStretchTo.length(); ient++)
{
	Body bd;
	Beam bmI = (Beam)_entToStretchTo[ient];
	TrussEntity trussI = (TrussEntity)_entToStretchTo[ient];
	if(bmI.bIsValid())
	{ 
		// beam
		Body bdI = bmI.envelopeBody();
		Quader qdI(bmI.ptCen(),bmI.vecX(),bmI.vecY(),bmI.vecZ(),bmI.dL(),bmI.dW(),bmI.dH(),0,0,0);
		// in direction vxBm
		Point3d ptIntersectLeft;
		int iIntersectLeft = bdI.rayIntersection(bm.ptCen(), bm.vecX(), ptIntersectLeft);
		
		if ( iIntersectLeft)
		{
			ptIntersectLeft.vis(1);
			
			if(abs(bm.vecX().dotProduct(ptIntersectLeft-bm.ptCen()))<dClosestLeft)
			{ 
				dClosestLeft = abs(bm.vecX().dotProduct(ptIntersectLeft-bm.ptCen()));
				quaderToStretchLeft = qdI;
				entToStretchLeft = bmI;
				iStretchLeft = true;
			}
		}
		Point3d ptIntersectRight;
		int iIntersectRight = bdI.rayIntersection(bm.ptCen(), -bm.vecX(), ptIntersectRight);
		if ( iIntersectRight)
		{
			if(abs(bm.vecX().dotProduct(ptIntersectRight-bm.ptCen()))<dClosestRight)
			{ 
				dClosestRight=abs(bm.vecX().dotProduct(ptIntersectRight-bm.ptCen()));
				quaderToStretchRight = qdI;
				entToStretchRight = bmI;
				iStretchRight = true;
			}
		}
	}
	else if(trussI.bIsValid())
	{ 
		// truss
		CoordSys csTruss = trussI.coordSys();
		Vector3d vecXt = csTruss.vecX();
		Vector3d vecYt = csTruss.vecY();
		Vector3d vecZt = csTruss.vecZ();
		Point3d ptOrgTruss = trussI.ptOrg();
		String strDefinition = trussI.definition();
		TrussDefinition trussDefinition(strDefinition);
		Beam beamsTruss[] = trussDefinition.beam();
		Body bdTruss;
		for (int i=0;i<beamsTruss.length();i++) 
		{ 
	//		beamsTruss[i].envelopeBody().vis(4);
			bdTruss.addPart(beamsTruss[i].envelopeBody());
		}//next i
		bdTruss.transformBy(csTruss);
		Point3d ptCenBd = bdTruss.ptCen();
		PlaneProfile ppX = bdTruss.shadowProfile(Plane(ptCenBd, vecXt));
		LineSeg segX = ppX.extentInDir(vecYt);
		Point3d ptCenX = segX.ptMid();
		Point3d ptCenTruss = ptCenX;
		PlaneProfile ppY = bdTruss.shadowProfile(Plane(ptCenBd, vecYt));
		LineSeg segY = ppY.extentInDir(vecXt);
		ptCenTruss += vecXt * vecXt.dotProduct(segY.ptMid() - ptCenTruss);
		double dLx = bdTruss.lengthInDirection(vecXt);
		double dLy = bdTruss.lengthInDirection(vecYt);
		double dLz = bdTruss.lengthInDirection(vecZt);
		Quader qdI(ptCenTruss, vecXt, vecYt, vecZt, dLx, dLy, dLz,0,0,0);
		Body bdI(qdI);
		bdI.vis(2);
		Point3d ptIntersectLeft;
		int iIntersectLeft = bdI.rayIntersection(bm.ptCen(), bm.vecX(), ptIntersectLeft);
		if (iIntersectLeft)
		{
			ptIntersectLeft.vis(6);
			if(abs(bm.vecX().dotProduct(ptIntersectLeft-bm.ptCen()))<dClosestLeft)
			{ 
				dClosestLeft = abs(bm.vecX().dotProduct(ptIntersectLeft-bm.ptCen()));
				quaderToStretchLeft = qdI;
				entToStretchLeft = trussI;
				iStretchLeft = true;
			}
		}
		Point3d ptIntersectRight;
		int iIntersectRight = bdI.rayIntersection(bm.ptCen(), -bm.vecX(), ptIntersectRight);
		if (iIntersectRight)
		{
			ptIntersectRight.vis(6);
			if(abs(bm.vecX().dotProduct(ptIntersectRight-bm.ptCen()))<dClosestRight)
			{ 
				dClosestRight = abs(bm.vecX().dotProduct(ptIntersectRight - bm.ptCen()));
				quaderToStretchRight = qdI;
				entToStretchRight = trussI;
				iStretchRight = true;
			}
		}
	}
}

if(iStretchLeft)
{
//			Point3d ptAllLeft[]=bmToStretchLeft[0].envelopeBody(FALSE, TRUE).intersectPoints(Line (bm.ptCen(), vecX));
	Body bdLeft(quaderToStretchLeft);
	Point3d ptAllLeft[]=bdLeft.intersectPoints(Line (bm.ptCen(), vecX));
	if (ptAllLeft.length()>0)
	{
		Point3d ptCutLeft=ptAllLeft[0];
//				Vector3d cutVecLeft = bmToStretchLeft[0].vecX().crossProduct(bmToStretchLeft[0].vecD(el.vecZ()));
		Vector3d cutVecLeft = quaderToStretchLeft.vecX().crossProduct(quaderToStretchLeft.vecD(el.vecZ()));
		if (cutVecLeft.dotProduct(vecX) < 0)
		{
			cutVecLeft *= -1;
		}
		ptCutLeft=ptCutLeft-cutVecLeft*dGap;
		Cut ctLeft (ptCutLeft, cutVecLeft);
		//cutVecLeft.vis(ptCutLeft, 3);	
		//bm.realBody().vis(2);
		bm.addToolStatic(ctLeft, _kStretchOnInsert);
	}
}
if(iStretchRight)
{
//			Point3d ptAllRight[]=bmToStretchRight[0].envelopeBody(FALSE, TRUE).intersectPoints(Line (bm.ptCen(), -vxBm));
	Body bdRight(quaderToStretchRight);
	Point3d ptAllRight[]=bdRight.intersectPoints(Line (bm.ptCen(), -vecX));
	if (ptAllRight.length()>0)
	{
		Point3d ptCutRight=ptAllRight[0];
//				Vector3d cutVecRight = bmToStretchRight[0].vecX().crossProduct(bmToStretchRight[0].vecD(el.vecZ()));//version value="1.7"
		Vector3d cutVecRight = quaderToStretchRight.vecX().crossProduct(quaderToStretchRight.vecD(el.vecZ()));
		if (cutVecRight.dotProduct(vecX) > 0)
		{
			cutVecRight *= -1;
		}
		ptCutRight=ptCutRight - cutVecRight*dGap;
		Cut ctRight (ptCutRight, cutVecRight);
//
//				bm.realBody().vis(i);
//				cutVecRight.vis(ptCutRight, 2);					
		bm.addToolStatic(ctRight, _kStretchOnInsert);
	}
}

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
      <str nm="Comment" vl="HSB-15447: Init" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="5/10/2022 5:12:09 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End