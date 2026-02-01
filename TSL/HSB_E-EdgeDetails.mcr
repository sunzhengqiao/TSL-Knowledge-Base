#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
16.01.2017  -  version 1.00













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
/// 
/// </summary>

/// <insert>
/// Select a viewport
/// </insert>

/// <remark Lang=en>
/// .
/// </remark>

/// <version  value="1.00" date="16.01.2017"></version>

/// <history>
/// AS - 1.00 - 16.01.2017 - Pilot version
/// </history>

Unit(1,"mm");
double vectorTolerance = U(0.001);

double detailSize = U(500);


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

Element el = vp.element();
CoordSys csEl = el.coordSys();
Vector3d elX = csEl.vecX();
Vector3d elY = csEl.vecY();
Vector3d elZ = csEl.vecZ();

Display detailDisplay(-1);

PlaneProfile outline = el.profBrutto(0);
outline.transformBy(ms2ps);
outline.vis(1);

PLine envelope = el.plEnvelope();
envelope.transformBy(ms2ps);
envelope.vis(3);

ElementRoof elRf = (ElementRoof)el;
if (elRf.bIsValid())
{
	GenBeam genBeams[] = el.genBeam();
	
	ElemRoofEdge roofEdges[] = elRf.elemRoofEdges();
	for (int e=0;e<roofEdges.length();e++) 
	{
		ElemRoofEdge roofEdge = roofEdges[e];
		PLine edge(roofEdge.ptNode(), roofEdge.ptNodeOther());
		
		PLine edgePreview = edge;
		edgePreview.transformBy(ms2ps);
		edgePreview.vis(5);
		
		Point3d edgeMidPoint = edge.ptMid();
		
		Vector3d detailY = el.vecZ();
		Vector3d detailZ = roofEdge.vecDir();
		Vector3d detailX = detailY.crossProduct(detailZ);
		
		PLine areaOutline(detailZ);
		areaOutline.createRectangle(LineSeg(edgeMidPoint - (detailX + detailY) * 0.5 * detailSize, edgeMidPoint + (detailX + detailY) * 0.5 * detailSize), detailX, detailY);
		
		CoordSys csDetail(edgeMidPoint, detailX, detailY, detailZ);
				
		Point3d edgeMidPointPS = edgeMidPoint;
		edgeMidPointPS.transformBy(ms2ps);
		CoordSys detailToVisualisation;
		detailToVisualisation.setToAlignCoordSys(edgeMidPoint, detailX, detailY, detailZ, edgeMidPointPS, _XW * vpScale, _YW * vpScale, _ZW * vpScale);
		
		PlaneProfile areaProfile(csDetail);
		areaProfile.joinRing(areaOutline, _kAdd);
		
		Plane areaPlane(edgeMidPoint, detailZ);
		
		for (int g=0;g<genBeams.length();g++) 
		{
			GenBeam gBm = genBeams[g];
			PlaneProfile gBmSlice = gBm.realBody().getSlice(areaPlane);
			PLine rings[] = gBmSlice.allRings();
			
			detailDisplay.color(gBm.color());
			
			for (int r=0;r<rings.length();r++)
			{
				Point3d vertices[] = rings[r].vertexPoints(false);
				
				for (int v=0;v<(vertices.length() - 1);v++)
				{
					LineSeg lnSeg(vertices[v], vertices[v+1]);
					LineSeg detailSegments[] = areaProfile.splitSegments(lnSeg, true);
					for (int s=0;s<detailSegments.length();s++)
					{
						LineSeg detailSegment = detailSegments[s];
						detailSegment.transformBy(detailToVisualisation);
						detailDisplay.draw(detailSegment);
					}
				}
			}
		}		
	}
}
#End
#BeginThumbnail

#End