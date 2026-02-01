#Version 8
#BeginDescription
Last modified by: Anno Sportel (support.nl@hsbcad.com)
17.12.2019 - version 1.00

This tsl creates and maintains a subcomponent definition. The name and Id are written to the beams in the subcomponents. The beams in the subcomponents have to be aligned.
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
/// This tsl creates and maintains a subcomponent definition. 
/// The name and Id are written to the beams in the subcomponents. The beams in the subcomponents have to be aligned.
/// </summary>

/// <insert>
/// Show dialog - specify the name of the subcomponent.
/// Select a set of beams
/// </insert>

/// <remark Lang=en>
/// There are a couple of constraints in place for this first version. 
/// 1. Only beams are allowed in subcomponents. 
/// 2. All beams in the subcomponent have to be aligned with each other. 
/// </remark>

/// <version  value="1.00" date="17.12.2019"></version>

/// <history>
/// AS - 1.00 - 17.12.2019 - Pilot version (HSB-6243)
/// </history>

double vectorTolerance = Unit(0.01, "mm");

String subcomponentDataKey = "Hsb_SubcomponentData";
String subcomponentNameKey = "Name";
String subcomponentIdKey = "Id";

PropString subcomponentName(0, T("|Unknown|"), T("|Name|"));
subcomponentName.setDescription(T("|Sets the name of the subcomponent|."));

int textColour = 3;
double textSize = U(50);
double shrinkSize = U(5);
int transparencyPercent = 50;

if (_bOnInsert)
{	
	showDialog();
	
	PrEntity ssE(T("|Select beam(s)|"), Beam());
	if (ssE.go())
	{
		_Beam.append(ssE.beamSet());
	}
	
	int beamsAreAligned = true;
	Vector3d subcomponentX;
	for (int b=0;b<_Beam.length();b++)
	{
		Beam bm = _Beam[b];
		if (b==0)
		{
			subcomponentX = bm.vecX();
		}
		else
		{
			if (abs(abs(subcomponentX.dotProduct(bm.vecX())) - 1) > vectorTolerance)
			{
				beamsAreAligned = false;
			}
		}
		
		// Remove existing subcomponent data.
		String subMapXKeys[] = bm.subMapXKeys();
		if (subMapXKeys.find(subcomponentDataKey) != -1)
		{
			bm.removeSubMapX(subcomponentDataKey);
		}
	}
	
	if (!beamsAreAligned)
	{
		reportWarning(TN("|The subcomponent defintion could not be created|") + TN("|The selected beams are not aligned.|"));
		eraseInstance();
		return;
	}
	
	return;
}

Display dp(textColour);
dp.textHeight(textSize);

String componentGuids[0];
Body componentBodies[0];

int componentIndexes[0];
for (int b=0;b<_Beam.length();b++)
{
	componentIndexes.append(-1);
}

for (int b=0;b<_Beam.length();b++)
{
	Beam thisBm = _Beam[b];
	Vector3d thisBmX = thisBm.vecX();
	Body thisBmBody = thisBm.envelopeBody();
	CoordSys thisBmBlowUp;
	thisBmBlowUp.setToAlignCoordSys(thisBm.ptCenSolid(), thisBm.vecX(), thisBm.vecY(), thisBm.vecZ(),
								      thisBm.ptCenSolid(), thisBm.vecX(), 1.001 * thisBm.vecY(), 1.001 * thisBm.vecZ());
	thisBmBody.transformBy(thisBmBlowUp);
	
	int loopProtector = - 1;
	for (int c=b+1;c<_Beam.length();c++)
	{
		if (loopProtector++> 100) 
		{
			reportWarning(TN("|The subcomponent defintion could not be created|") + TN("|Infinite loop detected.|"));
			eraseInstance();
			return;
		}
		if (componentIndexes[c] != -1) continue;
		
		Beam otherBm = _Beam[c];
		Vector3d otherBmX = otherBm.vecX();
		if ( ! otherBmX.isParallelTo(thisBmX)) continue;
		
		Body otherBmBody = otherBm.envelopeBody();
		CoordSys otherBmBlowUp;
		otherBmBlowUp.setToAlignCoordSys(otherBm.ptCenSolid(), otherBm.vecX(), otherBm.vecY(), otherBm.vecZ(),
									          otherBm.ptCenSolid(), otherBm.vecX(), 1.001 * otherBm.vecY(), 1.001 * otherBm.vecZ());
		otherBmBody.transformBy(otherBmBlowUp);
		
		if ( ! thisBmBody.hasIntersection(otherBmBody)) continue;
		
		int combined = thisBmBody.addPart(otherBmBody);
		
		if (componentIndexes[b] == -1)
		{
			componentGuids.append(createNewGuid());
			componentBodies.append(thisBmBody);
			componentIndexes[b] = componentGuids.length() - 1;
		}
		
		componentBodies[componentIndexes[b]] = thisBmBody;
		componentIndexes[c] = componentIndexes[b];
		
		c = b;
	}
}

if (componentGuids.length() != 1)
{
	reportWarning(TN("|The subcomponent defintion could not be created|") + TN("|The selected beams are not touching each other.|"));
	eraseInstance();
	return;
}

Body subcomponentBody = componentBodies[0];
String subcomponentId = componentGuids[0];

Point3d subcomponentCentroid = subcomponentBody.ptCen();
_Pt0 = subcomponentCentroid + _ZW * _ZW.dotProduct(_PtW - subcomponentCentroid);

PlaneProfile subcomponentShadow = subcomponentBody.shadowProfile(Plane(_Pt0, _ZW));

subcomponentShadow.shrink(shrinkSize);
dp.draw(subcomponentShadow, _kDrawFilled, transparencyPercent);

subcomponentShadow.shrink(-(2 * textSize + shrinkSize));
LineSeg minMax = subcomponentShadow.extentInDir(_XW);

PLine boundingBox(_ZW);
boundingBox.createRectangle(minMax, _XW, _YW);

Point3d namePosition = minMax.ptMid();
namePosition += _YW * _YW.dotProduct(minMax.ptEnd() - namePosition);

dp.draw(boundingBox);
dp.draw(subcomponentName, namePosition, _XW, _YW, 0, -2);

Map subcomponentData;
subcomponentData.setString(subcomponentNameKey, subcomponentName);
subcomponentData.setString(subcomponentIdKey, subcomponentId);

for (int b=0;b<_Beam.length();b++)
{
	Beam bm = _Beam[b];
	bm.setSubMapX(subcomponentDataKey, subcomponentData);
}

#End
#BeginThumbnail

#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="0.03937008" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="inches" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End