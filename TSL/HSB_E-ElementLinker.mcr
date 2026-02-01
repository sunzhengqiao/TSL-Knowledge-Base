#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@itwindustry.nl)
13.09.2013  -  version 1.00
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
/// <summary Lang=en>
/// This tsl links elements to each other.
/// </summary>

/// <insert>
/// Select elements
/// </insert>

/// <remark Lang=en>
/// Custom actions to add and remove sub elements.
/// </remark>

/// <version  value="1.00" date="13.09.2013"></version>

/// <history>
/// AS - 1.00 - 13.09.2013 -	Pilot version
/// </history>


String arSTrigger[] = {
	T("|Add subelements|"),
	T("|Remove subelements|")
};

for( int i=0;i<arSTrigger.length();i++ )
	addRecalcTrigger(_kContext, arSTrigger[i] );


// Set properties if inserted with an execute key
String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_E-ElementLinker");
if( _bOnDbCreated && arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert ){
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
//	if( _kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1 )
//		showDialog();
	
	Element mainElement = getElement(T("|Select the main element|"));
	_Element.append(mainElement);

	//Select beam(s) and insertion point
	PrEntity ssE(T("|Select one or more elements|"), Element());
	if (ssE.go()) {
		Element subElements[] = ssE.elementSet();
		
		for (int i=0;i<subElements.length();i++) {
			Element subElement = subElements[i];
			if (subElement.handle() == mainElement.handle())
				continue;
			
			if( _Element.find(subElement) != -1 )
				continue;
			
			_Element.append(subElement);
		}
	}
	
	return;
}

if( _Element.length() == 0 ){
	reportWarning(TN("|No elements selected.|"));
	eraseInstance();
	return;
}

Element mainElement = _Element[0];

if( _kExecuteKey == arSTrigger[0] ){
	PrEntity ssE(T("|Select one or more sub elements to add|"), Element());
	if (ssE.go()) {
		Element subElements[] = ssE.elementSet();
		
		for (int i=0;i<subElements.length();i++) {
			Element subElement = subElements[i];
			if (subElement.handle() == mainElement.handle())
				continue;
				
			if( _Element.find(subElement) != -1 )
				continue;
			
			_Element.append(subElement);
		}
	}	
}

if( _kExecuteKey == arSTrigger[1] ){
	PrEntity ssE(T("|Select one or more sub elements to remove|"), Element());
	if (ssE.go()) {
		Element subElements[] = ssE.elementSet();
		
		for (int i=0;i<subElements.length();i++) {
			Element subElement = subElements[i];
			if (subElement.handle() == mainElement.handle())
				continue;
			
			int elementIndex = _Element.find(subElement);
			if( elementIndex == -1 )
				continue;
			
			_Element.removeAt(elementIndex);
		}
	}
}


double dSymbolSize = U(50);
int nColor = 5;

Map subElementsMap;
for (int i=1;i<_Element.length();i++) 
	subElementsMap.appendEntity("SubElement", _Element[i]);

mainElement.setSubMapX("SubElement[]", subElementsMap);

CoordSys csEl = mainElement.coordSys();
Point3d ptEl = csEl.ptOrg();
Vector3d vxEl = csEl.vecX();
Vector3d vyEl = csEl.vecY();
Vector3d vzEl = csEl.vecZ();

// visualisation
Display dpVisualisation(nColor);
dpVisualisation.layer("DEFPOINTS");

Point3d ptStartSymbol = ptEl;
Point3d ptSymbol01 = ptStartSymbol - vyEl * 2 * dSymbolSize;
Point3d ptSymbol02 = ptSymbol01 - (vxEl + vyEl) * dSymbolSize;
Point3d ptSymbol03 = ptSymbol01 + (vxEl - vyEl) * dSymbolSize;

PLine plSymbol01(vzEl);
plSymbol01.addVertex(ptStartSymbol);
plSymbol01.addVertex(ptSymbol01);
PLine plSymbol02(vzEl);
plSymbol02.addVertex(ptSymbol02);
plSymbol02.addVertex(ptSymbol01);
plSymbol02.addVertex(ptSymbol03);

dpVisualisation.draw(plSymbol01);
dpVisualisation.draw(plSymbol02);

for( int i=1;i<_Element.length();i++ ){
	Element el = _Element[i];
	Point3d ptName = ptEl + vxEl * 0.15 * dSymbolSize - vyEl * i * dSymbolSize;
	dpVisualisation.draw(el.number(), ptName, vxEl, vyEl, 1, 1);
}
	
#End
#BeginThumbnail

#End
