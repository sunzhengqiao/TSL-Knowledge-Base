#Version 8
#BeginDescription
v1.04_11may2023_JF_Renamed to GE_AB_DIM
v1.02_12mar2020_DR_Align and stagger siblings available for XRefs 
v1.01_03mar2020_DR_Deactivated align and stagger triggers until solve issue with XRefs anchors 
v1.00_03mar2020_DR_initial
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords 
#BeginContents
//region history
/// <History>
/// <version value="1.03" date="02apr2020" author="david.rueda@hsbcad.com"> Renamed from GE_ANCHOR_DIM  </version>
/// <version value="1.02" date="12mar2020" author="david.rueda@hsbcad.com"> Align and stagger siblings available for XRefs  </version>
/// <version value="1.01" date="03mar2020" author="david.rueda@hsbcad.com"> Deactivated align and stagger triggers until solve issue with XRefs anchors  </version>
/// <version value="1.00" date="03mar2020" author="david.rueda@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Not to be manually inserted, only created by GE_ANCHOR_DIMSentity(s)
/// </insert>

/// <summary Lang=en>
/// Description
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "ScriptName")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|")))
//endregion
{
	// units
	U(1, "inch");
	
	// custom constants (for easy access)
	double dInitialOffset = U(20);
	double dFixedDimSegIn = U(6);
	double dFixedDimSegOut = U(10);
	String sMapKeyIsVertical = "IsVertical";
	String sMapKeyPtDim = "PtDim";
	String sMapKeyIsPtG0Set = "IsPtG0Set";
	Vector3d vDirections [] = { _XW, _YW};
	String sMapKeyAlignMe = "AlignMe";
	String sMapKeyAlignmentPoint = "AlignmentPoint";
	
	// - mandatory values -	
	String sMapKeyLocationPoint = "LocationPoint";
	String sMapKeyReferencePoint = "ReferencePoint";
	String sMapKeyImInRegion = "ImInRegion";
	String sMapKeyImOrphan = "ImOrphan";
	String sMapKeyHideMe = "HideMe";
	String sMapKeyMyElement = "MyElement";
	String sMapKeyDimStyle = "DimStyle";
	String sMapKeyLayer = "Layer";
	String sMapKeyReferenceDirection = "ReferenceDirection";
	
	// constants
	double dEps = U(0.01);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick = "TslDoubleClick";
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
	
	// TriggerAlignSiblings
	int bAlignSiblings;
	String sTriggerAlignSiblings = T("|../Align Siblings|");
	addRecalcTrigger(_kContext, sTriggerAlignSiblings );
	if (_bOnRecalc && _kExecuteKey == sTriggerAlignSiblings)
	{
		bAlignSiblings = true;
	}
	
	// TriggerStaggerSiblings
	int bStaggerSiblings;
	String sTriggerStaggerSiblings = T("|../Stagger Siblings|");
	addRecalcTrigger(_kContext, sTriggerStaggerSiblings );
	if (_bOnRecalc && _kExecuteKey == sTriggerStaggerSiblings)
	{
		bStaggerSiblings = true;
	}
	
	// TriggerWriteMapToDxx
	if (bDebug)
	{
		String sTriggerWriteMapToDxx = T("|../WriteMapToDxx|");
		addRecalcTrigger(_kContext, sTriggerWriteMapToDxx );
		if (_bOnRecalc && _kExecuteKey == sTriggerWriteMapToDxx)
		{
			TslInst tslOut = _ThisInst; Map mapOut = tslOut.map(); String sMapName = tslOut.scriptName() + "_" + tslOut.handle(); String sMapPath = "C:\\Temp\\DebugMaps\\" + sMapName; mapOut.writeToDxxFile(sMapPath + + ".dxx"); reportMessage(sMapName + " was written to " + sMapPath + "\n");
		}
	}
	
	if (_bOnDbCreated)
	{
		if (bDebug)
		{
			TslInst tslOut = _ThisInst; Map mapOut = tslOut.map(); String sMapName = tslOut.scriptName() + "_" + tslOut.handle() + "_AtCreation"; String sMapPath = "C:\\Temp\\DebugMaps\\" + sMapName; mapOut.writeToDxxFile(sMapPath + + ".dxx"); reportMessage(sMapName + " was written to " + sMapPath + "\n");
		}
		return; //_Map will be empty
	}
	
	// bOnInsert//region
	if (_bOnInsert)
	{
		reportMessage("\n" + scriptName() + ": " + T("|This TSL is not meant to be manually inserted. Is part of automation from GE_AB_DIMS|\n"));
		eraseInstance();
		return;
		
	}
	// end on insert	__________________//endregion
	
	// validations
	if ( ! _Map.hasPoint3d(sMapKeyLocationPoint) || !_Map.hasPoint3d(sMapKeyReferencePoint) || ! _Map.hasInt(sMapKeyImInRegion) || !_Map.hasInt(sMapKeyImOrphan) || !_Map.hasInt(sMapKeyHideMe)
		 || !_Map.hasInt(sMapKeyIsVertical) || !_Map.hasString(sMapKeyDimStyle) || !_Map.hasString(sMapKeyDimStyle) || !_Map.hasString(sMapKeyLayer) || !_Map.hasVector3d(sMapKeyReferenceDirection))
		{
			if (bDebug)
			{
				reportMessage("\n" + scriptName() + "_" + _ThisInst.handle() + "- " + T("|has been deleted because _Map is missing one or more fields|\n"));
				TslInst tslOut = _ThisInst; Map mapOut = tslOut.map(); String sMapName = tslOut.scriptName() + "_" + tslOut.handle(); String sMapPath = "C:\\Temp\\DebugMaps\\" + sMapName + ".dxx"; mapOut.writeToDxxFile(sMapPath + + ".dxx"); reportMessage(sMapName + " was written to " + sMapPath + "\n");
			}
		eraseInstance();
		return;
	}
	
	if (_Element.length() != 1)
	{
		if (bDebug) { reportMessage("\n" + scriptName() + "_" + _ThisInst.handle() + " " + T("|has been deleted because _Element.length() was expected to be 1 and it's |\n") + _Element.length()); }
		eraseInstance();
		return;
	}
	
	Element element = _Element[0];
	if ( ! element.bIsValid())
	{
		if (bDebug) { reportMessage("\n" + scriptName() + "_" + _ThisInst.handle() + " " + T("|has been deleted because element is not valid entity|\n")); }
		eraseInstance();
		return;
		
	}
	
	// basics
	Display dp (-1`);
	Point3d ptLocation = _Map.getPoint3d(sMapKeyLocationPoint);
	Point3d ptReference = _Map.getPoint3d(sMapKeyReferencePoint);
	int bImInRegion = _Map.getInt(sMapKeyImInRegion);
	int bImOrphan = _Map.getInt(sMapKeyImOrphan);
	int bHideMe = _Map.getInt(sMapKeyHideMe);
	int bIsVertical = _Map.getInt(sMapKeyIsVertical);
	int bIsPtG0Set = _Map.getInt(sMapKeyIsPtG0Set);
	String sLayer = _Map.getString(sMapKeyLayer);
	Vector3d vReferenceDirection = _Map.getVector3d(sMapKeyReferenceDirection);
	
	CoordSys cs = element.coordSys();
	Point3d ptOrg = _Pt0 = cs.ptOrg();
	Vector3d vecX = cs.vecX();
	Vector3d vecY = cs.vecY();
	Vector3d vecZ = cs.vecZ();
	
	LineSeg lsElMinMax = element.segmentMinMax();
	double dLengthElement = abs(vecX.dotProduct(lsElMinMax.ptStart() - lsElMinMax.ptEnd()));
	Point3d ptCenElement = lsElMinMax.ptMid();
	Point3d ptLeftElement = ptOrg + vecX * dLengthElement;
	
	// trigger align/stagger siblings
	if (bAlignSiblings || bStaggerSiblings)
	{
		if (bDebug) reportMessage("\n" + scriptName() + "-" + _ThisInst.handle() + ": " + T("|attempting to align/stagger siblings|") + "\n");
		
		String sMapKeySiblings = "Siblings";
		// collect siblings	
		TslInst tslSiblings[0];
		Entity entSiblings [] = _Map.getEntityArray(sMapKeySiblings, sMapKeySiblings, sMapKeySiblings);
		for (int e = 0; e < entSiblings.length(); e++)
		{
			TslInst tslSibling = (TslInst)entSiblings[e];
			if ( ! tslSibling.bIsValid())
				continue;
			
			tslSiblings.append(tslSibling);
		}//next e
		
		if (bAlignSiblings)
		{
			if (bDebug) reportMessage("\n" + scriptName() + "-" + _ThisInst.handle() + ": " + T("|attempting to align siblings|") + "\n");
			
			for (int s = 0; s < tslSiblings.length(); s++)
			{
				TslInst tslSibling = tslSiblings[s];
				Map map = tslSibling.map();
				map.setInt(sMapKeyAlignMe, true);
				map.setPoint3d(sMapKeyAlignmentPoint , _PtG[0]);
				tslSibling.setMap(map);
				tslSibling.recalc();
				
				if (bDebug) { reportMessage("\n" + scriptName() + "-" + _ThisInst.handle() + ": " + "aligning sibling :" + tslSibling.handle() + "\n"); }
			}
		}
		else if (bStaggerSiblings)
		{
			// sort
			Vector3d vSortDirection = vecX;
			double dDistances[0];
			for (int t = 0; t < tslSiblings.length(); t++)
			{
				dDistances.append(vSortDirection.dotProduct(tslSiblings[t].ptOrg() - Point3d(0, 0, 0)));
			}//next t
			
			int nRows = dDistances.length();
			int bAscending = TRUE;
			for (int s1 = 1; s1 < nRows; s1++)
			{
				int s11 = s1;
				for (int s2 = s1 - 1; s2 >= 0; s2--)
				{
					int bSort = dDistances[s11] > dDistances[s2];
					if ( bAscending )
					{
						bSort = dDistances[s11] < dDistances[s2];
					}
					if ( bSort )
					{
						dDistances.swap(s2, s11);
						tslSiblings.swap(s2, s11);
						s11 = s2;
					}
				}
			}
			
			// stagger			
			int bIsThisPair;
			int nIndex = tslSiblings.find(_ThisInst, - 1);
			if (nIndex % (2) == 0)
				bIsThisPair = true;
			else
				bIsThisPair = false;
			
			Vector3d vAlignDirection = vecZ;
			if (vAlignDirection.dotProduct(_PtG[0] - ptCenElement) < 0)
				vAlignDirection *= -1;
			
			for (int t = 0; t < tslSiblings.length(); t++)
			{
				TslInst tslSibling = tslSiblings[t];
				if (tslSibling == _ThisInst)
					continue;
				
				int bIsSiblingPair;
				if (t % (2) == 0)
				{
					bIsSiblingPair = true;
				}
				else
				{
					bIsSiblingPair = false;
				}
				
				Vector3d vAlign = vAlignDirection;
				if (bIsThisPair != bIsSiblingPair)
					vAlign = - vAlign;
				
				Point3d ptAlign = ptCenElement + vAlign * abs (vecZ.dotProduct(_PtG[0] - ptCenElement));
				Map map = tslSibling.map();
				map.setInt(sMapKeyAlignMe, true);
				map.setPoint3d(sMapKeyAlignmentPoint , ptAlign);
				tslSibling.setMap(map);
				tslSibling.recalc();
				
				if (bDebug) { reportMessage("\n" + scriptName() + "-" + _ThisInst.handle() + ": " + "staggering sibling :" + tslSibling.handle() + "\n"); }
			}//next t
		}
		
		setExecutionLoops(2);
		return;
	}
	
	if ( _Map.hasInt(sMapKeyAlignMe))
	{
		int bAlignMe = _Map.getInt(sMapKeyAlignMe);
		if (bAlignMe)
		{
			if (_Map.hasPoint3d(sMapKeyAlignmentPoint))
			{
				Point3d ptAlignmentPoint = _Map.getPoint3d(sMapKeyAlignmentPoint);
				_PtG[0] += vecZ * vecZ.dotProduct(ptAlignmentPoint - _PtG[0]);
			}
		}
		_Map.setInt(sMapKeyAlignMe, false);
	}
	
	_Pt0 = ptLocation;
	_ThisInst.setAllowGripAtPt0(true);
	assignToLayer(sLayer);
	// hide me
	if ( ! bImInRegion || bHideMe)
	{
		_ThisInst.setAllowGripAtPt0(false);
		return;
	}
	
	// verify if its orphan (it was in a list removed from the model)
	if (bImOrphan)
	{
		dp.color(1);
	}
	
	// get info and values	
	int bIsPerpendicular;
	if ( abs(1 - abs(element.vecZ().dotProduct(vReferenceDirection))) < dEps) //is perpendicular to dim direction
	{
		bIsPerpendicular = true;
	}
	
	// set dimLine direction
	Vector3d vOffsetDirection;
	if ( ! _Map.getInt(sMapKeyIsPtG0Set))
	{
		Point3d ptDim0 = _Pt0;
		vOffsetDirection = vecZ;
		
		if (bIsPerpendicular)
		{
			// find closer wall extreme (left/right edge)
			if (abs(vecX.dotProduct(ptOrg - _Pt0)) < (abs(vecX.dotProduct( ptLeftElement - _Pt0)) ))
			{
				ptDim0 = ptOrg;
			}
			else
			{
				ptDim0 = ptOrg + vecX * dLengthElement;
			}
			ptDim0 += vecZ * vecZ.dotProduct(ptCenElement - ptDim0); //align to element center along element.vecZ()
			
			// find direction
			vOffsetDirection = vecX;
			if ((ptDim0 - ptCenElement).dotProduct(vOffsetDirection) < 1)
			{
				vOffsetDirection *= -1;
			}
		}
		
		ptDim0 += vOffsetDirection * dInitialOffset;
		
		_PtG.append(ptDim0);
		_Map.setInt(sMapKeyIsPtG0Set, true);
	}
	else
	{
		vOffsetDirection = vecZ;
		
		if (bIsPerpendicular)
		{
			vOffsetDirection = vecX;
		}
		
		if ((_PtG[0] - _Pt0).dotProduct(vOffsetDirection) < 0)
		{
			vOffsetDirection *= -1;
		}
	}
	
	if (_PtG.length() != 1)
	{
		if (bDebug) { reportMessage("\n" + scriptName() + "_" + _ThisInst.handle() + " " + T("|has been deleted because _PtG length is not 1 but |") + _PtG.length()); }
		eraseInstance();
		return;
	}
	
	//Display
	String sDimStyle = _Map.getString(sMapKeyDimStyle);
	dp.dimStyle(sDimStyle);
	
	double dRelativeDistance = U(abs(vReferenceDirection.dotProduct(_Pt0 - ptReference)));
	String sRelativeDistance;
	sRelativeDistance.formatUnit(dRelativeDistance, 4, 2);
	sRelativeDistance.trimLeft().trimRight();
	
	Vector3d vecXTxt, vecYTxt, vecXAlign, vecYAlign;
	if (bIsVertical)
	{
		vecXAlign = _XW;
		vecYAlign = _YW;
		
		vecXTxt = _XW;
		vecYTxt = _YW;
	}
	else
	{
		vecXAlign = _YW;
		vecYAlign = - _XW;
		
		vecXTxt = _YW;
		vecYTxt = _XW;

	}
	
	if (vecXTxt.dotProduct(vecXAlign) < 0)
	{
		vecXTxt *= -1;
	}
	if (vecYTxt.dotProduct(vecYAlign) < 0)
	{
		vecYTxt *= -1;;
	}
	
	dp.draw(sRelativeDistance, _PtG[0] + vOffsetDirection * (dp.textLengthForStyle(sRelativeDistance, sDimStyle) * .5 + 1), vecXTxt, vecYTxt, 0, 0);
	
	PLine plDim();
	plDim.addVertex(_Pt0);
	plDim.addVertex(_Pt0 + vOffsetDirection * dFixedDimSegIn);
	plDim.addVertex(_PtG[0] - vOffsetDirection * dFixedDimSegOut);
	plDim.addVertex(_PtG[0]);
	dp.draw(plDim);
	
	if (bDebug )
	{
		TslInst tslOut0 = _ThisInst; Map mapOut0 = tslOut0.map(); String sMapName = tslOut0.scriptName() + "_" + tslOut0.handle(); String sMapPath = "C:\\Temp\\DebugMaps\\" + sMapName; mapOut0.writeToDxxFile(sMapPath + 0 + ".dxx"); reportMessage(sMapName + " was written to " + sMapPath + "\n");
		reportMessage("\n" + scriptName() + "- bImInRegion " + bImInRegion + ".\n");
		reportMessage("\n" + scriptName() + "- bImOrphan " + bImOrphan + ".\n");
		reportMessage("\n" + scriptName() + "- bHideMe " + bHideMe + ".\n");
		reportMessage("\n" + scriptName() + "- bIsVertical " + bIsVertical + ".\n");
		reportMessage("\n" + scriptName() + "- bIsPtG0Set " + bIsPtG0Set + ".\n");
		reportMessage("\n" + scriptName() + "- My element :" + element.code() + "-" + element.number() + "\n");
	}
}
#End
#BeginThumbnail






#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="0.03937008" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Renamed to GE_AB_DIM" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="5/11/2023 12:49:49 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End