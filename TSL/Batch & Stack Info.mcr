#Version 8
#BeginDescription


1.0 09/12/2021 Show batch and stacking information in the drawing. Author: Anno Sportel
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// Show grouping information
/// </summary>

/// <insert>
/// -
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

//#Versions
// 1.0 09/12/2021 Show batch and stacking information in the drawing. Author: Anno Sportel

/// <history>

/// </history>

String parentUIDKey = "ParentUID";

String myUIDKey = "MyUID";
String contentKey = "Content";
String sequenceKey = "Seq";

if (_bOnInsert)
{
	if (insertCycleCount() > 1)
	{
		eraseInstance();
		return;
	}
	_Pt0 = getPoint(T("|Select a position|"));
	
	return;
}

Entity entities[] = Group().collectEntities(true, Element(), _kModelSpace);

Element batchedElements[0];
String batches[0];
String stacks[0];
int stackChildSequences[0];
String sequenceKeys[0];

for (int e = 0; e < entities.length(); e++)
{
	Element element = (Element)entities[e];
	String mapXKeys[] = element.subMapXKeys();
	
	String batchName;
	String stackName;
	int stackChildIndex;
	for (int m = 0; m < mapXKeys.length(); m++)
	{
		String mapXKey = mapXKeys[m];
		if (mapXKey.left(4).makeUpper() == "HSB_" && mapXKey.right(5).makeUpper() == "CHILD")
		{
			Map groupingChildMap = element.subMapX(mapXKey);
			String groupingType = mapXKey.mid(4, mapXKey.length() - 9);
			
			String parentName = groupingChildMap.getString(parentUIDKey);
			Map childContent = groupingChildMap.getMap(contentKey);
			
			if (groupingType == "Batch")
			{
				batchName = parentName;
			}
			else if (groupingType == "Stacking")
			{
				stackName = parentName;
				stackChildIndex = childContent.getInt(sequenceKey) + 1;
			}
		}
	}
	if (batchName == "")
	{
		if (stackName != "")
		{
			reportNotice(TN("|Element| ") + element.number() + T(" |is part of stack| ") + stackName + T(", |but is not in a batch|!"));
		}
		continue;
	}
	
	batchedElements.append(element);
	batches.append(batchName);
	stacks.append(stackName);
	stackChildSequences.append(stackChildIndex);
	String paddedStackChildSequences;
	paddedStackChildSequences.format("%04s", (String)stackChildIndex);
	sequenceKeys.append(batchName + "-" + stackName + "-" + paddedStackChildSequences + "-" + element.number());
}

for (int s1 = 1; s1 < sequenceKeys.length(); s1++)
{
	int s11 = s1;
	for (int s2 = s1 - 1; s2 >= 0; s2--)
	{
		if ( sequenceKeys[s11] < sequenceKeys[s2] )
		{
			sequenceKeys.swap(s2, s11);
			batchedElements.swap(s2, s11);
			batches.swap(s2, s11);
			stacks.swap(s2, s11);
			stackChildSequences.swap(s2, s11);
			
			s11 = s2;
		}
	}
}

Display dp(-1);
int batchColor = 1;
int stackColor = 7;
int elementColor = 3;

double textSize = U(100);
double batchTextSize = U(200);
dp.textHeight(textSize);

double rowHeight = 1.45 * textSize;;
double columnWidth = 10 * textSize;

Point3d rowStart = _Pt0;
Point3d columnStart = rowStart;
Point3d cellLocation = columnStart;

String currentBatch;
String currentStack = "";
int elementsInBatch = 0;
for (int b=0; b<batchedElements.length();b++)
{
	Element batchedElement = batchedElements[b];
	String batch = batches[b];
	String stack = stacks[b];
	
	if (batch != currentBatch)
	{
		currentStack = "";
		elementsInBatch = 0;
		// New batch - Draw batch name.
		dp.color(batchColor);
		dp.textHeight(batchTextSize);
		rowStart -= _YW * rowHeight;
		dp.draw("Batch " + batch, rowStart, _XW, _YW, 1, - 1);
		dp.textHeight(textSize);
		
		columnStart = rowStart - _YW * 2 * rowHeight;
		cellLocation = columnStart;
		
		currentBatch = batch;
	}
	
	if (stack != currentStack)
	{ 
		// New stack - Draw stack name.
		dp.color(batchColor);
		PLine stackHeader(_ZW);
		stackHeader.createRectangle(LineSeg(columnStart - _XW * 0.05 * columnWidth + _YW * 0.2 * rowHeight, columnStart + _XW * 0.9 * columnWidth - _YW * 0.9 * rowHeight), _XW, _YW);
		PlaneProfile stackHeaderProfile(stackHeader);
		dp.draw(stackHeaderProfile, _kDrawFilled, 75);
		dp.color(stackColor);
		dp.draw("Stack " + stack, columnStart, _XW, _YW, 1, - 1);
		cellLocation = columnStart - _YW * rowHeight;
		columnStart += _XW * columnWidth;
		currentStack = stack;
	}
	
	if (stack == "" && (elementsInBatch++ % 5) == 0)
	{
		cellLocation = columnStart;
		columnStart += _XW * columnWidth;
	}
	
	dp.color(elementColor);
	dp.draw(batchedElement.number(), cellLocation + _XW * rowHeight, _XW, _YW, 1, - 1);
	cellLocation -= _YW * rowHeight;
	
	if (_YW.dotProduct(cellLocation - rowStart) < 0)
	{
		rowStart += _YW * _YW.dotProduct(cellLocation - rowStart);
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
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Show batch and stacking information in the drawing." />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="12/9/2021 9:27:38 AM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End