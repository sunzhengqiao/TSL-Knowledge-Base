#Version 8
#BeginDescription
1.2 18/06/2021 Add option for clockwise or counterclockwise direction Author: Robert Pol
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// 
/// </summary>

/// <insert>
/// Select a viewport
/// </insert>

/// <remark Lang=en>
/// .
/// </remark>

/// <version  value="1.02" date="14.11.2019"></version>

/// <history>
/// AS - 1.00 - 20.10.2017 - Pilot version
/// AS - 1.01 - 27.10.2017 - Display edge corners and angles.
//Rvw - 1.02 - 14.11.2019 - Add option to round the corners and angles to whole integers.
// #Versions
/// </history>

double tolerance = Unit(0.01,"mm");
double vectorTolerance = U(0.001);

double detailSize = U(500);

String categories[] = 
{
	T("|Angles|"),
	T("|Corners|")
};

String noYes[] = { T("|No|"), T("|Yes|")};

PropString showEdgeAnglesProp(0, noYes, T("|Show edge angles|"), 1);
showEdgeAnglesProp.setCategory(categories[0]);
showEdgeAnglesProp.setDescription(T("|Specifies whether the angles should be visible or not.|"));

PropString roundEdgeAngels(2, noYes, T("|Round off edge angles|"), 0);
roundEdgeAngels.setCategory(categories[0]);
roundEdgeAngels.setDescription(T("|Round off the edge angles to whole numbers|"));

PropString switchDirectionProp(4, noYes, T("|Switch direction|"), 1);
switchDirectionProp.setCategory(categories[0]);
switchDirectionProp.setDescription(T("|Specifies whether the angles should be clockwise or not.|"));

PropDouble angleOffsetFromEdge(0, U(10), T("|Offset from edge|"));
angleOffsetFromEdge.setCategory(categories[0]);
angleOffsetFromEdge.setDescription(T("|Sets the offset of the angles from the sip edges.|"));

PropInt angleColor(0, 1, T("|Angle color|"));
angleColor.setCategory(categories[0]);
angleColor.setDescription(T("|Sets the angle of the corners.|"));

PropString showCornersProp(1, noYes, T("|Show corners|"), 1);
showCornersProp.setCategory(categories[1]);
showCornersProp.setDescription(T("|Specifies whether the corners should be visible or not.|"));

PropString roundCornerAngles(3, noYes, T("|Round off corners angles|"), 0);
roundCornerAngles.setCategory(categories[1]);
roundCornerAngles.setDescription(T("|Round off the corner angles to whole numbers|"));

PropDouble cornerOffsetFromEdge(1, U(5), T("|Offset from corner|"));
cornerOffsetFromEdge.setCategory(categories[1]);
cornerOffsetFromEdge.setDescription(T("|Sets the offset of the corners from the sip.|"));

PropInt cornerColor(1, 1, T("|Corner color|"));
cornerColor.setCategory(categories[1]);
cornerColor.setDescription(T("|Sets the color of the corners.|"));

if (_bOnInsert) 
{
	if (insertCycleCount() > 1)
	{
		eraseInstance();
		return;
	}
	
	  showDialog();
	  
	_Viewport.append(getViewport(T("|Select a viewport|")));
	return;
}

if (_Viewport.length()==0)
{
	eraseInstance();
	return;
}
Viewport vp = _Viewport[0];

// check if the viewport has hsb data
if (!vp.element().bIsValid()) return;

CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps; ps2ms.invert();
double  vpScale = vp.dScale();

int showEdgeAngles = noYes.find(showEdgeAnglesProp, 1);
int showCorners = noYes.find(showCornersProp, 1);

int roundCornerAngle = noYes.find(roundCornerAngles, 0);
int roundEdgeAngle = noYes.find(roundEdgeAngels, 0);
int clockWiseAngle = noYes.find(switchDirectionProp, 0);

int cornerRounding = roundCornerAngle > 0 ? 0 : 1;
int edgeRounding = roundEdgeAngle > 0 ? 0 : 1;
int clockWise = clockWiseAngle > 0 ? 0 : 1;

Element el = vp.element();
CoordSys csEl = el.coordSys();
Vector3d elX = csEl.vecX();
Vector3d elY = csEl.vecY();
Vector3d elZ = csEl.vecZ();

Display edgeInfoDisplay(-1);

ElementRoof elRf = (ElementRoof)el;
if (elRf.bIsValid())
{
	Sip sips[] = el.sip();
	for (int s=0;s<sips.length();s++)
	{
		Sip sip = sips[s];
		SipEdge sipEdges[] = sip.sipEdges();
		if (sipEdges.length() > 1)
		{
			sipEdges.append(sipEdges[0]);
			sipEdges.append(sipEdges[1]);
		}
		
		Vector3d previousEdgeDirection;
		Vector3d previousEdgeNormal;
		for (int e = 0; e < sipEdges.length(); e++)
		{
			SipEdge sipEdge = sipEdges[e];
			// Direction
			Point3d edgeStart = sipEdge.ptStart();
			Point3d edgeStartPS = edgeStart;
			edgeStartPS.transformBy(ms2ps);
			Point3d edgeEnd = sipEdge.ptEnd();
			Vector3d edgeDirection(edgeEnd - edgeStart);
			edgeDirection.normalize();
			Vector3d edgeDirectionPS = edgeDirection;
			edgeDirectionPS.transformBy(ms2ps);
			edgeDirectionPS.normalize();
			edgeDirectionPS.vis(edgeStartPS, e + 1);
			// Normal
			Vector3d edgeNormal = sipEdge.vecNormal();
			Vector3d edgeNormalPS = edgeNormal;
			edgeNormalPS.transformBy(ms2ps);
			edgeNormalPS.normalize();
			edgeNormalPS.vis(edgeStartPS, e + 1);
			if (showEdgeAngles && e != (sipEdges.length() - 2)) // Skip the last two. These ones are the same edge as the first ones.
			{
				double bevel = sip.vecZ().dotProduct(edgeNormal);
				double angle = asin(bevel);
				if (clockWise)
				{
					angle *= -1;
				}
				if (abs(angle) > tolerance)
				{
					String roundedAngle = String().formatUnit(angle, 2, edgeRounding);
					
					Point3d anglePosition = sipEdge.ptMid();
					anglePosition.transformBy(ms2ps);
					anglePosition += edgeNormalPS * angleOffsetFromEdge;
					
					edgeInfoDisplay.color(angleColor);
					edgeInfoDisplay.draw(roundedAngle + "°", anglePosition, _XW, _YW, 0, 0);
				}
			}
			
			if (showCorners && e > 0) // Skip first edge, this edge is also added as the last one in the list. We will process that one.
			{ 
				double edgeProduct = previousEdgeDirection.dotProduct(edgeDirection);
				
				if (abs(edgeProduct) > vectorTolerance)
				{
					double corner = previousEdgeDirection.angleTo(edgeDirection);
					double cornerRelaytiveToElZ = previousEdgeDirection.angleTo(edgeDirection, elZ);
					if (corner != cornerRelaytiveToElZ)
					{
						corner = 180 - corner;
					}
					
					String roundedCorner = String().formatUnit(corner, 2, cornerRounding);
					
					Point3d cornerPosition = edgeStart;
					cornerPosition.transformBy(ms2ps);
					Vector3d offsetDirectionPS = edgeNormal + previousEdgeNormal;
					offsetDirectionPS.transformBy(ms2ps);
					offsetDirectionPS.normalize();
					
					cornerPosition += offsetDirectionPS * cornerOffsetFromEdge;
					
					edgeInfoDisplay.color(cornerColor);
					edgeInfoDisplay.draw(roundedCorner + "°", cornerPosition, _XW, _YW, 0, 0);
				}
			}
			
			previousEdgeDirection = edgeDirection;
			previousEdgeNormal = edgeNormal;
		}
	}
}
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
      <str nm="Comment" vl="Add option for clockwise or counterclockwise direction" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="6/18/2021 2:18:07 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End