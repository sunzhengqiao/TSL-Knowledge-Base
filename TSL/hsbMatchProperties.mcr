#Version 8
#BeginDescription
version value="1.1" date="28may2020" author="thorsten.huck@hsbcad.com"
HSB-7756 transparency, render material, zone, notes, line weight and  property sets added

Select properties or catalog entry, pick source entity and and then select entities to assign the selected properties to
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords property;modify;eiganp;matchprop
#BeginContents
/// <History>//region
/// <version value="1.1" date="28may2020" author="thorsten.huck@hsbcad.com"> HSB-7756 transparency, render material, zone, notes, line weight and  property sets added </version>
/// <version value="1.0" date="27may2020" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select properties or catalog entry, pick source entity and and then select entities to assign the selected properties to
/// </insert>

/// <summary Lang=en>
/// This tsl creates 
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbMatchProperties")) TSLCONTENT
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
	String sYes = T("|Yes|");
	String sNoYes[] = { T("|No|"), sYes};
//end Constants//endregion


//region Properties
	String sDesc = T("|Toggles if this property shall be mapped.|");
	
	//region genbeam
	String sColorName=T("|Color|");	
	PropString sColor(nStringIndex++, sNoYes, sColorName);	
	sColor.setDescription(sDesc);	sColor.setCategory(category);	
	
	String sLabelName=T("|Label|");	
	PropString sLabel(nStringIndex++, sNoYes, sLabelName);	
	sLabel.setDescription(sDesc);	sLabel.setCategory(category);	
	
	String sSubLabelName=T("|SubLabel|");
	PropString sSubLabel(nStringIndex++, sNoYes, sSubLabelName);	
	sSubLabel.setDescription(sDesc);	sSubLabel.setCategory(category);	
	
	String sSubLabel2Name=T("|SubLabel2|");	
	PropString sSubLabel2(nStringIndex++, sNoYes, sSubLabel2Name);	
	sSubLabel2.setDescription(sDesc);	sSubLabel2.setCategory(category);	
	
	String sGradeName=T("|Grade|");
	PropString sGrade(nStringIndex++, sNoYes, sGradeName);	
	sGrade.setDescription(sDesc);	sGrade.setCategory(category);	
	
	String sInformationName=T("|Information|");		
	PropString sInformation(nStringIndex++, sNoYes, sInformationName);	
	sInformation.setDescription(sDesc);	sInformation.setCategory(category);
	
	String sMaterialName = T("|Material|");
	PropString sMaterial(nStringIndex++, sNoYes, sMaterialName);	
	sMaterial.setDescription(sDesc);	sMaterial.setCategory(category);	

	String sNameName=T("|Name|");
	PropString sName(nStringIndex++, sNoYes, sNameName);	
	sName.setDescription(sDesc);	sName.setCategory(category);

	String sBeamtypeName=T("|Beamtype|");
	PropString sBeamtype(nStringIndex++, sNoYes, sBeamtypeName);	
	sBeamtype.setDescription(sDesc);	sBeamtype.setCategory(category);
	
	String sIsotropicName=T("|Isotropic|");
	PropString sIsotropic(nStringIndex++, sNoYes, sIsotropicName);	
	sIsotropic.setDescription(sDesc);	sIsotropic.setCategory(category);
			
	String shsbIdName=T("|hsbId|");		
	PropString shsbId(nStringIndex++, sNoYes, shsbIdName);	
	shsbId.setDescription(sDesc);	shsbId.setCategory(category);	
		
	String sGroupName=T("|Group|");
	PropString sGroup(nStringIndex++, sNoYes, sGroupName);	
	sGroup.setDescription(sDesc);	sGroup.setCategory(category);
	
	String sModuleName=T("|Element Module|");
	PropString sModule(nStringIndex++, sNoYes, sModuleName);	
	sModule.setDescription(sDesc);	sModule.setCategory(category);	
		
	String sZoneName=T("|Zone|");	
	PropString sZone(nStringIndex++, sNoYes, sZoneName);	
	sZone.setDescription(sDesc);	sZone.setCategory(category);	
	
	
	String sTransparencyName=T("|Transparency|");	
	PropString sTransparency(nStringIndex++, sNoYes, sTransparencyName);	
	sTransparency.setDescription(sDesc);	sTransparency.setCategory(category);	
	
	
	String sLineWeightName=T("|Line Weight|");	
	PropString sLineWeight(nStringIndex++, sNoYes, sLineWeightName);	
	sLineWeight.setDescription(sDesc);	sLineWeight.setCategory(category);	
	
	
	String sNotesName=T("|Notes|");	
	PropString sNotes(nStringIndex++, sNoYes, sNotesName);	
	sNotes.setDescription(sDesc);	sNotes.setCategory(category);	
	
	
	String sPropertySetName=T("|Property Set|");	
	PropString sPropertySet(nStringIndex++, sNoYes, sPropertySetName);	
	sPropertySet.setDescription(sDesc);	sPropertySet.setCategory(category);	
	
	
	String sRenderMaterialName=T("|Render Material|");	
	PropString sRenderMaterial(nStringIndex++, sNoYes, sRenderMaterialName);	
	sRenderMaterial.setDescription(sDesc);	sRenderMaterial.setCategory(category);		

	//End genbeam//endregion 	
	
	//region beam
	category = T("|Beam|");		
	
	String sExtrusionProfileName=T("|Extrusion Profile|");	
	PropString sExtrusionProfile(nStringIndex++, sNoYes, sExtrusionProfileName);	
	sExtrusionProfile.setDescription(sDesc);	sExtrusionProfile.setCategory(category);	
	
	String sTextureName=T("|Texture|");	
	PropString sTexture(nStringIndex++, sNoYes, sTextureName);	
	sTexture.setDescription(sDesc);	sTexture.setCategory(category);	
	
	String sCurvedStyleName=T("|Curved Style|");	
	PropString sCurvedStyle(nStringIndex++, sNoYes, sCurvedStyleName);	
	sCurvedStyle.setDescription(sDesc);	sCurvedStyle.setCategory(category);	
	
	String sSplinterFreeName=T("|Splinter Free|");	
	PropString sSplinterFree(nStringIndex++, sNoYes, sSplinterFreeName);	
	sSplinterFree.setDescription(sDesc);	sSplinterFree.setCategory(category);	

	String sWidthName=T("|Width|");	
	PropString sWidth(nStringIndex++, sNoYes, sWidthName);	
	sWidth.setDescription(sDesc);	sWidth.setCategory(category);
	
	String sHeightName=T("|Height|");	
	PropString sHeight(nStringIndex++, sNoYes, sHeightName);	
	sHeight.setDescription(sDesc);	sHeight.setCategory(category);				
	//End beam//endregion 

	//region sheet
	category = T("|Sheet|");
	
	String sThicknessName=T("|Thickness|");	
	PropString sThickness(nStringIndex++, sNoYes, sThicknessName);	
	sThickness.setDescription(sDesc);	sThickness.setCategory(category);			
	//End sheet//endregion 

	//region sip
	category = T("|Sip|");
	
	String sStyleName=T("|Style|");	
	PropString sStyle(nStringIndex++, sNoYes, sStyleName);	
	sStyle.setDescription(sDesc);	sStyle.setCategory(category);
		
	String sSurfaceQualityTopName=T("|SurfaceQualityTop|");	
	PropString sSurfaceQualityTop(nStringIndex++, sNoYes, sSurfaceQualityTopName);	
	sSurfaceQualityTop.setDescription(sDesc);	sSurfaceQualityTop.setCategory(category);
		
	String sSurfaceQualityBottomName=T("|SurfaceQualityBottom|");	
	PropString sSurfaceQualityBottom(nStringIndex++, sNoYes, sSurfaceQualityBottomName);	
	sSurfaceQualityBottom.setDescription(sDesc);	sSurfaceQualityBottom.setCategory(category);			
	//End sip//endregion 
	
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
		
		GenBeam source = getGenBeam(T("|Select source entity|"));
		_Map.setEntity("Source",source);
	
	// prompt for genbeams of same class
		if (source.bIsKindOf(Beam()))
		{ 
			PrEntity ssE(T("|Select beams|"), Beam());
			if (ssE.go())
				_Beam.append(ssE.beamSet());	
		}
		else if (source.bIsKindOf(Sheet()))
		{ 
			PrEntity ssE(T("|Select sheets|"), Sheet());
			if (ssE.go())
				_Sheet.append(ssE.sheetSet());	
		}		
		else if (source.bIsKindOf(Sip()))
		{ 
			PrEntity ssE(T("|Select sip|"), Sip());
			Entity ents[0];
			if (ssE.go())
				ents.append(ssE.set());	
			for (int i=0;i<ents.length();i++) 
				_Sip.append((Sip)ents[i]); 		
		}				
		
		
		if (bDebug)_Pt0 = getPoint();
		return;
	}	
// end on insert	__________________//endregion


// get source
	Entity entSource = _Map.getEntity("source");
	GenBeam source = (GenBeam)entSource;
	if (!source.bIsValid())
	{ 
		eraseInstance();
		return;
	}
	Beam bmSource = (Beam)source;
	Sheet shSource = (Sheet)source;
	Sip sipSource = (Sip)source;
	
	String sPropertyNames[0];
	
// collect targets
	GenBeam targets[0];
	for (int i=0;i<_Beam.length();i++) 
	{
		Beam t = _Beam[i];
		if (sExtrusionProfile == sYes){t.setExtrProfile(bmSource.extrProfile()); 	if(i==0)sPropertyNames.append(sExtrusionProfileName);}
		if (sTexture == sYes){t.setTexture(bmSource.texture()); 					if(i==0)sPropertyNames.append(sTextureName);}
		if (sCurvedStyle == sYes){t.setCurvedStyle(bmSource.curvedStyle());			if(i==0)sPropertyNames.append(sCurvedStyleName);}
		if (sSplinterFree == sYes){t.setCncSplinterFree(bmSource.cncSplinterFree());if(i==0)sPropertyNames.append(sSplinterFreeName);}
		if (sWidth == sYes){t.setD(t.vecY(),bmSource.dW());							if(i==0)sPropertyNames.append(sWidthName);}
		if (sHeight == sYes){t.setD(t.vecZ(),bmSource.dH());						if(i==0)sPropertyNames.append(sHeightName);}
		
		targets.append(t); 
	}
	for (int i=0;i<_Sheet.length();i++) 
	{
		Sheet t = _Sheet[i];
		if (sThickness == sYes){t.setDH(shSource.dH());								if(i==0)sPropertyNames.append(sThicknessName);}
		
		targets.append(t); 	
	}
	for (int i=0;i<_Sip.length();i++) 
	{
		Sip t = _Sip[i];
		SipStyle style = sipSource.style();
		if (sStyle == sYes)t.setStyle(style);
		if (sSurfaceQualityTop == sYes)
		{
			SurfaceQualityStyle sqs =  sipSource.surfaceQualityOverrideTop()!=""?sipSource.surfaceQualityOverrideTop():style.surfaceQualityTop();
			t.setSurfaceQualityOverrideTop(sqs);									if(i==0)sPropertyNames.append(sSurfaceQualityTopName);
		}
		if (sSurfaceQualityBottom == sYes)
		{
			SurfaceQualityStyle sqs =  sipSource.surfaceQualityOverrideBottom()!=""?sipSource.surfaceQualityOverrideBottom():style.surfaceQualityBottom();
			t.setSurfaceQualityOverrideBottom(sqs);									if(i==0)sPropertyNames.append(sSurfaceQualityBottomName);
		}
		
		targets.append(t); 
	}
		
// map genbeam properties
	for (int i=0;i<targets.length();i++) 
	{ 
		GenBeam& t= targets[i]; 
		
		if (sColor == sYes){t.setColor(source.color());								if(i==0)sPropertyNames.append(sColorName);}
		if (sLabel == sYes){t.setLabel(source.label());								if(i==0)sPropertyNames.append(sLabelName);}
		if (sSubLabel == sYes){t.setSubLabel(source.subLabel());					if(i==0)sPropertyNames.append(sSubLabelName);}
		if (sSubLabel2 == sYes){t.setSubLabel2(source.subLabel2());					if(i==0)sPropertyNames.append(sSubLabel2Name);}
		if (sGrade == sYes){t.setGrade(source.grade());								if(i==0)sPropertyNames.append(sGradeName);}
		if (sInformation == sYes){t.setInformation(source.information());			if(i==0)sPropertyNames.append(sInformationName);}
		if (sMaterial == sYes){t.setMaterial(source.material());					if(i==0)sPropertyNames.append(sMaterialName);}
		if (sName == sYes){t.setName(source.name());								if(i==0)sPropertyNames.append(sNameName);}
		if (sBeamtype == sYes){t.setType(source.type());							if(i==0)sPropertyNames.append(sBeamtypeName);}
		if (sIsotropic == sYes){t.setIsotropic(source.isotropic());					if(i==0)sPropertyNames.append(sIsotropicName);}
		if (shsbId == sYes){t.setHsbId(source.hsbId());								if(i==0)sPropertyNames.append(shsbIdName);}
		if (sGroup == sYes){t.assignToGroups(source);								if(i==0)sPropertyNames.append(sGroupName);}
		if (sModule == sYes){t.setModule(source.module());							if(i==0)sPropertyNames.append(sModuleName);}	
		
		if (sZone == sYes)
		{
			Element elt = t.element();
			Element els = source.element();
			if (elt.bIsValid() && els.bIsValid())
			{ 
				t.assignToElementGroup(elt, true, source.myZoneIndex(), 'Z');
				if(i==0)sPropertyNames.append(sZoneName);
			}					
		}
		if (sTransparency == sYes){t.setTransparency(source.transparency());		if(i==0)sPropertyNames.append(sTransparencyName);}
		if (sLineWeight == sYes){t.setLineWeight(source.lineWeight());				if(i==0)sPropertyNames.append(sLineWeightName);}
		if (sNotes == sYes){t.setNotes(source.notes());								if(i==0)sPropertyNames.append(sNotesName);}
		if (sPropertySet == sYes)
		{
			String propSetNames[] = source.attachedPropSetNames();
			for (int ii=0;ii<propSetNames.length();ii++) 
			{ 
				Map m = source.getAttachedPropSetMap(propSetNames[ii]);
				if (m.length()>0)
				{ 
					t.attachPropSet(propSetNames[ii]);
					t.setAttachedPropSetFromMap(propSetNames[ii], m); 
					if(i==0)sPropertyNames.append(sPropertySetName);
				}
			}//next ii
		}
		if (sRenderMaterial == sYes){t.setRenderMaterial(source.renderMaterial());	if(i==0)sPropertyNames.append(sRenderMaterialName);}
		
		
	}//next i


	reportMessage("\n" + scriptName() + ": " +targets.length() + T(" |items mapped with| ") + sPropertyNames);
	if (!bDebug)eraseInstance();
	return;
#End
#BeginThumbnail
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
A>-:@(JP*%2H\:_#_`6<Y$[S6,1EJ`````$E%3D2N0F""

#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS">
        <int nm="BREAKPOINT" vl="252" />
      </lst>
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End