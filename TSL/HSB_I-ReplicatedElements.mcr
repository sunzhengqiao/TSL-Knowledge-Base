#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
09.07.2015  -  version 1.00

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
/// Show a list of elements which are a replica of this element.
/// </summary>

/// <insert>
/// Select a viewport and a position.
/// </insert>

/// <remark Lang=en>
/// An element is a replica if the subtype is equal to the number of this element.
/// </remark>

/// <version  value="1.00" date="09.07.2015"></version>

/// <history>
/// AS - 1.00 - 09.07.2015 -  Pilot version.
/// </hsitory>

PropString dimStyle(0, _DimStyles, T("|Dimension style|"));
dimStyle.setDescription(T("|Sets the dimension style to use|"));

PropDouble textSize(0, U(-1), T("|Text size|"));
textSize.setDescription(T("|Sets the text size.|") + TN("|The text size of the dimension style is used if the text size is zero or negative.|"));

if (_bOnInsert) {
	if (insertCycleCount() > 1) {
		eraseInstance();
		return;
	}
	
	_Viewport.append(getViewport(T("|Select a viewport|")));
	_Pt0 = getPoint(T("|Select a position|"));
	
	return;
}

if (_Viewport.length() == 0) {
	reportWarning(T("|No viewport selected|"));
	eraseInstance();
	return;
}
Viewport vp = _Viewport[0];

Display dp(-1);
dp.dimStyle(dimStyle);

if (textSize > 0)
	dp.textHeight(textSize);

Element el = vp.element();
if (!el.bIsValid())
	return;

String replicatedElements = el.number();
Entity allElements[] = Group().collectEntities(true, Element(), _kModelSpace);
for (int e=0;e<allElements.length();e++) {
	Element element = (Element)allElements[e];
	if (!element.bIsValid())
		continue;
	
	if (element.subType() == el.number())
		replicatedElements += (", " + element.number());
}

dp.draw(replicatedElements , _Pt0, _XW, _YW, 1, 1);

#End
#BeginThumbnail


#End