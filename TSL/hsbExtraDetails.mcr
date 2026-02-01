#Version 8
#BeginDescription
Version 1.1   04.04.2005   th@hsbCAD.de
   - neue Option 'Elementcode ergänzen' setzt dem eingebenen Detailnamen
     automatisch den entsprechenden Code des Elementes vorweg. Bei freien
     Details (z.B. _XX123) sollte diese Option deaktiviert werden, da ansonsten ein
     ungültiger Detailname generiert wird.

   - new option 'Add Elementcode to Detailname' adds Code
     to detailname. This option should be toggled to 'No' if you
     insert free details like _XX123
Version 1.0   24.02.2005   th@hsb-systems.de
   - ordnet Sonderdetails mehreren Holzrahmenbau-Elementen gleichzeitig zu
   - die Etage kann zum gleichen Zeitpunkt gesetzt werden, ist
     dieser Wert auf -1 gesetzt, so bleibt die ursprüngliche Einstellung
     erhalten
   - die Option 'Überschreiben' setzt eventuell vorhandene Details
     auf die Vorgabe zurück
   - über den TSL-Katalog können Detailkonfigurationen
     gespeichert werden

   - this tsl applies extra details to multiple stickframe elements
   - the level can be set at the same time, the value -1
     will keep the old value
   - option 'overwrite' will reset details to default
   - using the tsl catalog allows you to store customized combinations
     of extra details
     
     
     
     




1.3 21/08/2024 Remove extra show dialogue. AJ
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------
*  Copyright (C) 2005 by
*  hsb SYSTEMS gmbh
*  Germany
*
*  The program may be used and/or copied only with the written
*  permission from hsb SYSTEMS gmbh, or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
*
* REVISION HISTORY
* ----------------
*
* Revised: Thorsten Huck 050404
* Change:  1.1
*
* Modify by: Alberto Jena (aj@hsb-cad.com)
* date: 29.02.2012
* version 1.2: Àdd code to work from the palette
*
*/



// basic and props
	U(1,"mm");
	PropInt nLevel(0,0,T("Level"));
	PropString sDetL(0,"",T("Detail") + " " + T("Left"));
	PropString sDetR(1,"",T("Detail") + " " +  T("Right"));
	PropString sDetT(2,"",T("Detail") + " " +  T("Top"));
	PropString sDetB(3,"",T("Detail") + " " +  T("Bottom"));
	PropString sDetLT(4,"",T("Detail") + " " +  T("Left") + " " + T("Top"));
	PropString sDetRT(5,"",T("Detail") + " " +  T("Right") + " " + T("Top"));

	sDetL.setDescription(T("Defines details for") + " " + T("left") + " " + T("side of the element.") + " " + T("String must not contain Elementcode!"));
	sDetR.setDescription(T("Defines details for") + " " + T("right") + " " + T("side of the element.") + " " + T("String must not contain Elementcode!"));
	sDetT.setDescription(T("Defines details for") + " " + T("top") + " " + T("side of the element.") + " " + T("String must not contain Elementcode!"));
	sDetB.setDescription(T("Defines details for") + " " + T("bottom") + " " + T("side of the element.") + " " + T("String must not contain Elementcode!"));
	sDetLT.setDescription(T("Defines details for") + " " + T("left top") + " " + T("side of the element.") + " " + T("String must not contain Elementcode!"));
	sDetRT.setDescription(T("Defines details for") + " " + T("right top") + " " + T("side of the element.") + " " + T("String must not contain Elementcode!"));

	String sArNY[] = {T("No"), T("Yes")};
	PropString sOverWrite(6,sArNY, T("Overwrite existing details"),0);
	PropString sUseElemCode(7,sArNY, T("Add Elementcode to Detailname"),0);


	if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);
	
// bOnInsert
	if(_bOnInsert)
	{
		if( insertCycleCount()>1 )
		{
			eraseInstance();
			return;
		}

		if (_kExecuteKey=="")
			showDialogOnce();
		
  		PrEntity ssE(T("Select a set of elements"), ElementWallSF());
  		if (ssE.go()) {
    		_Element = ssE.elementSet();

  		}
		if (_Element.length() <= 0){
			eraseInstance();
			return;
		}
		ElementWallSF el = (ElementWallSF) _Element[0];
		if (!el.bIsValid()) return;
		nLevel.set(el.forceLevelDetail());

		return;
	}	


// declare standards
	for (int e = 0; e < _Element.length(); e++){
		ElementWallSF el = (ElementWallSF) _Element[e];
		if (!el.bIsValid()) return;


	// get wall code
		String sCode = el.code();
		if (sUseElemCode == sArNY[0])
			sCode = "";

		if (nLevel > -1)
			el.setForceLevelDetail(nLevel);
		if (sDetL != "")
			el.setConstrDetailLeft(sCode + sDetL); 
		if (sDetR!= "")
			el.setConstrDetailRight(sCode +sDetR); 
		if (sDetT!= "")
			el.setConstrDetailTop(sCode + sDetT); 
		if (sDetB!= "")
			el.setConstrDetailBottom(sCode + sDetB); 
		if (sDetLT!= "")
			el.setConstrDetailTopLeft(sCode + sDetLT); 
		if (sDetRT!= "")
			el.setConstrDetailTopRight(sCode + sDetRT); 	

		if (sOverWrite == sArNY[1]){
			if (sDetL == "")
				el.setConstrDetailLeft("");
			if (sDetR== "")
				el.setConstrDetailRight("");
			if (sDetT== "")
				el.setConstrDetailTop(""); 
			if (sDetB== "")
				el.setConstrDetailBottom("");
			if (sDetLT== "")
			el.setConstrDetailTopLeft("");
			if (sDetRT== "")
				el.setConstrDetailTopRight("");
		}
	}// next e

// kill me
	eraseInstance();





#End
#BeginThumbnail
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
=OUE^;,ZI-PH`*`"@`H`*`"@`H`*`"@`H`*`/_]D`
`






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
      <str nm="COMMENT" vl="Remove extra show dialogue." />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="8/21/2024 12:32:31 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End