#Version 8
#BeginDescription
This Tsl tool shows a preview of the multi elements. It is only a visualisation. Multi elements cannot be changed in the preview.
The data is created by the Tsl tool hsbMultiwallManager. 

1.9 22.02.2022 HSB-14360 Add option to handle updates and refresh multiwall. Author: Nils Gregor


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 9
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl draws the multiwalls based on the meta data which is attached to the single elements.
/// </summary>

/// <insert>
/// Select a set of elements
/// </insert>

/// <remark Lang=en>
/// The map x data needs to be present in a map with "hsb_Multiwall" as key. 
/// The transformation vectors are stored as points in this map.
/// </remark>

/// <version  value="1.05" date="09.04.2019"></version>

/// <history>
/// AJ - 1.00 - 22.08.2012	- Pilot version
/// AJ - 1.02 - 14.11.2013	- Bugfix
/// AS - 1.03 - 21.07.2015	- Correct orientation and position of single element numbers (FogBugzId 1498).
/// AS - 1.04 - 05.04.2019	- Show the multiwall number.
/// AS - 1.05 - 09.04.2021	- Normalize vectors before using them.  Vectors are stored as points in the MapX and are in drawing units.
/// </history>

	Unit (0.001, "mm");
	
	PropDouble dVerticalOffset (0, U(4000), T(" Vertical offset between panels"));
	PropDouble dHorizontalOffset (2, U(0), T(" Horizontal offset between panels"));
	
	PropString sDimStyle(0, _DimStyles, T("Dimension Style"));
	PropDouble dNewTextHeight(1, -1, T("Text Height"));
	
	PropInt nColor(0, -1, T("Text Color"));
	
	PropString groupingFormat(2, "", T("|Grouping format|"));
	groupingFormat.setDescription(T("|Specifies the format for grouping the multi-elements|"));
	
	if (_bOnInsert) {
		if (insertCycleCount()>1) { 
			eraseInstance();
			return;
		}
		
		showDialogOnce();
	
		Group gp;
		Entity allElements[]=gp.collectEntities(true, Element(), _kModel);
		for (int e=0; e<allElements.length(); e++)
		{
			Element el=(Element) allElements[e];
			
			if (el.bIsValid())
			{
				Map mp=el.subMapX("hsb_Multiwall");
				if (mp.length()>0)
				{
					_Element.append(el);
				}
			}
		}
	
		_Pt0=getPoint(T("|Pick a point|"));
	
		return;
	}


	String strChangeEntity = T("../|Refresh all Multielements|");
	String updateMulitElementsCommand = "update Multielements";
	addRecalcTrigger(_kContext, strChangeEntity );
	if (_bOnRecalc && ( _kExecuteKey==strChangeEntity ||  _kExecuteKey == updateMulitElementsCommand))
	{
		_Element.setLength(0);
		
		Group gp;
		Entity allElements[]=gp.collectEntities(true, Element(), _kModel);
		for (int e=0; e<allElements.length(); e++)
		{
			Element el=(Element) allElements[e];
			
			if (el.bIsValid())
			{
				Map mp=el.subMapX("hsb_Multiwall");
				if (mp.length()>0)
				{
					_Element.append(el);
				}
			}
		}
	}
	
	
	String strSeparator = T("--------------------------------------");
	addRecalcTrigger(_kContext, strSeparator);
	
	
	String strDeleteEntity = T("|Delete Multiwalls|");
	addRecalcTrigger(_kContext, strDeleteEntity);
	if (_bOnRecalc && _kExecuteKey==strDeleteEntity)
	{
		_Element.setLength(0);
		
		Group gp;
		Entity allElements[]=gp.collectEntities(true, Element(), _kModel);
		for (int e=0; e<allElements.length(); e++)
		{
			Element el=(Element) allElements[e];
			
			if (el.bIsValid())
			{
				Map mp=el.subMapX("hsb_Multiwall");
				if (mp.length()>0)
				{
					el.removeSubMapX("hsb_Multiwall");
					//_Element.append(el);
				}
			}
		}
	}

	String multiElementNumbers[0];
	String multElementGroupingKeys[0];
	for (int e=0; e<_Element.length(); e++)
	{
		Element el=_Element[e];
		Map mp=el.subMapX("hsb_Multiwall");
		
		if (mp.hasString("Number"))
		{
			String multiElementNumber = mp.getString("Number");
			if (multiElementNumbers.find(multiElementNumber) != -1) continue;
			
			multiElementNumbers.append(multiElementNumber);
			if (groupingFormat != "")
			{
				String groupingKey = el.formatObject(groupingFormat);
				multElementGroupingKeys.append(groupingKey);
			}
			else
			{
				multElementGroupingKeys.append("");
			}
		}
	}
	
	for(int s1=1;s1<multiElementNumbers.length();s1++){
		int s11 = s1;
		for(int s2=s1-1;s2>=0;s2--){
			if( multiElementNumbers[s11] < multiElementNumbers[s2] ){
				multiElementNumbers.swap(s2, s11);
				multElementGroupingKeys.swap(s2, s11);
				s11=s2;
			}
		}
	}


	for(int s1=1;s1<multElementGroupingKeys.length();s1++){
		int s11 = s1;
		for(int s2=s1-1;s2>=0;s2--){
			if( multElementGroupingKeys[s11] < multElementGroupingKeys[s2] ){
				multiElementNumbers.swap(s2, s11);
				multElementGroupingKeys.swap(s2, s11);
				s11=s2;
			}
		}
	}
	
	String firstMultiElementNumberInGroup[multiElementNumbers.length()];
	String firstMultiElementNumberInCurrentGroup;
	String currentMultElementGroupingKey = "";
	for (int m = 0; m < multiElementNumbers.length(); m++)
	{
		String multiElementNumber = multiElementNumbers[m];
		String multElementGroupingKey = multElementGroupingKeys[m];
		if (m == 0 || multElementGroupingKey != currentMultElementGroupingKey)
		{
			firstMultiElementNumberInCurrentGroup = multiElementNumber;
			currentMultElementGroupingKey = multElementGroupingKey;
		}
		firstMultiElementNumberInGroup[m] = firstMultiElementNumberInCurrentGroup;
	}

	for(int s1=1;s1<firstMultiElementNumberInGroup.length();s1++){
		int s11 = s1;
		for(int s2=s1-1;s2>=0;s2--){
			if( firstMultiElementNumberInGroup[s11] < firstMultiElementNumberInGroup[s2] ){
				firstMultiElementNumberInGroup.swap(s2, s11);
				multiElementNumbers.swap(s2, s11);
				multElementGroupingKeys.swap(s2, s11);
				s11=s2;
			}
		}
	}
	
	Display dp(-1);
	Display dpText(nColor);
	dpText.dimStyle(sDimStyle);
	
	if (dNewTextHeight!=-1) {
		dpText.textHeight(dNewTextHeight);
	}

	
	dpText.draw("Multiwalls", _Pt0, _XW, _YW, 1,1);
	
	CoordSys cs(_Pt0, _XW, _YW, _ZW);
	
	double groupWidth = 0;
	currentMultElementGroupingKey = "";
	for (int m=0; m<multiElementNumbers.length(); m++) 
	{
		String multiElementNumber = multiElementNumbers[m];
		String multElementGroupingKey = multElementGroupingKeys[m];
		if (m>0 && multElementGroupingKey != currentMultElementGroupingKey)
		{
			cs.transformBy(_YW * _YW.dotProduct(_Pt0 - cs.ptOrg()) + _XW * (groupWidth + dHorizontalOffset));
			dpText.draw(multElementGroupingKey, cs.ptOrg(), cs.vecX(), cs.vecY(), 1, -4);
			groupWidth = 0;
		}
		currentMultElementGroupingKey = multElementGroupingKey;
		if (m==0)
		{
			dpText.draw(multElementGroupingKey, cs.ptOrg(), cs.vecX(), cs.vecY(), 1, -4);
		}
		
		cs.transformBy(-_YW * dVerticalOffset);
		
		dpText.draw(multiElementNumbers[m], cs.ptOrg(), _YW, - _XW, 1, 3);
		
		Element elThisMW[0];
		int nThisSquence[0];
		CoordSys csElInMultiElements[0];
		
		//get all the element of this multiwall
		for (int e=0; e<_Element.length(); e++) {
			Element el=_Element[e];
			Map mp=el.subMapX("hsb_Multiwall");
			String sMultiwallNumber;
			if ( mp.hasString("Number")) {
				sMultiwallNumber=mp.getString("Number");
			}
			if (sMultiwallNumber==multiElementNumbers[m]) {
				elThisMW.append(el);
				nThisSquence.append(mp.getInt("Sequence"));
				Point3d ptElOrg=mp.getPoint3d("PtOrg");
				Vector3d vx=mp.getPoint3d("VecX");
				Vector3d vy=mp.getPoint3d("VecY");
				Vector3d vz=mp.getPoint3d("VecZ");
				vx.normalize();
				vy.normalize();
				vz.normalize();
				CoordSys csElInMultiElement(ptElOrg, vx, vy, vz);
				csElInMultiElements.append(csElInMultiElement);
			}
		}
		
		Line lineX(_Pt0, _XW);
		Line lineY(_Pt0, _YW);
		Point3d genBeamVertices[0];
		
		Map mpInformation;
		Map mp;
		for (int e=0; e<elThisMW.length(); e++) {
			Element el=elThisMW[e];
			GenBeam gbmAll[]=el.genBeam();
			CoordSys csElInMultiElement=csElInMultiElements[e];
			
			CoordSys csToMultiElement = el.coordSys();
			csToMultiElement.invert();
			csToMultiElement.transformBy(csElInMultiElement);
			csToMultiElement.transformBy(cs.ptOrg());
			
			mp.setString("Number", el.number());
			
			for (int i=0; i<gbmAll.length(); i++) {
				Entity gbm = (Entity) gbmAll[i];
				//GenBeam gbm = gbmAll[i];
				Body bd = ((GenBeam)gbm).envelopeBody();
				bd.transformBy(csToMultiElement);
				genBeamVertices.append(bd.allVertices());
				
				String sDispRep[]=gbm.dispRepNames();
				
				dp.color(gbm.color());
				//dp.elemZone(el, gbm.myZoneIndex(), 'Z');
				dp.draw(gbm, csToMultiElement, "hsbCAD Model"); // display the entity
			}
			
			// Draw element number under the single element.
			Point3d ptNumber = el.ptOrg();
			ptNumber.transformBy(csToMultiElement);
			dpText.draw(el.number(), ptNumber, _XW, _YW,1,-2);
		}
		
		Point3d genBeamVerticesX[] = lineX.orderPoints(genBeamVertices);
		Point3d genBeamVerticesY[] = lineY.orderPoints(genBeamVertices);
		
		if (genBeamVerticesX.length() > 0 && genBeamVerticesY.length() > 0)
		{
			double sizeX = _XW.dotProduct(genBeamVerticesX.last() - genBeamVerticesX.first());
			double sizeY = _YW.dotProduct(genBeamVerticesY.last() - genBeamVerticesY.first());
			
			if (sizeX > groupWidth)
			{
				groupWidth = sizeX;
			}
		}
	}
	
	return;









#End
#BeginThumbnail













#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-14360 Add option to handle updates and refresh multiwall." />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="9" />
      <str nm="DATE" vl="2/22/2022 11:02:25 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Show grouping key" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="6/23/2021 4:52:04 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Sequence groups by first mult element in that group" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="6/22/2021 2:50:02 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End