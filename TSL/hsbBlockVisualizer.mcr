#Version 8
#BeginDescription


Version 1.0 26-3-2025 Initial version. Ronald van Wijngaarden
Version 1.2 24-6-2025 Add scaling for blockrefs which have been inserted with a scale. Ronald van Wijngaarden

Version 1.1 17-6-2025 Fix check whether the block is found in the libarary in the drawing. Ronald van Wijngaarden

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

//Description
//Tsl to visualize blockRefs in the drawing to be displayed in the displaycomposer of the hsbClient or hsbView.
//Tsl is added to the same element layer the BlockRef is in.

//#Versions
//1.2 24-6-2025 Add scaling for blockrefs which have been inserted with a scale. Ronald van Wijngaarden
//1.1 17-6-2025 Fix check whether the block is found in the libarary in the drawing. Ronald van Wijngaarden
//1.0 26-3-2025 Initial version. Ronald van Wijngaarden


U(1,"mm");	
double dEps =U(.1);
int nDoubleIndex, nStringIndex, nIntIndex;
String sLastInserted =T("|_LastInserted|");	
String sDefault =T("|_Default|");
String sYesNo[] = { T("|Yes|"), T("|No|")};
String triggerRecalcKey = "Recalc";
int zones[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
int realZones[] = {0, 1, 2, 3, 4, 5, - 1, -2, -3, -4, -5};

// bOnInsert//region
if (_bOnInsert)
	{
		if (insertCycleCount() > 1) 
		{
			eraseInstance();
			return;
		}
		
		PrEntity ssBlockRefs(T("|Select blockref entities|"), BlockRef());
		if (ssBlockRefs.go())
		{
			Entity selectedBlockRefs[] = ssBlockRefs.set();
			
			for (int b = 0; b < selectedBlockRefs.length(); b++)
			{
				BlockRef blockRef = (BlockRef)selectedBlockRefs[b];
				
				// create TSL
				GenBeam gbsTsl[] = { };
				Entity entsTsl[] = { blockRef};
				Point3d ptsTsl[] = { blockRef.coordSys().ptOrg()};
				TslInst blockVisualizerTsl;
				int lstPropInt[0];
				double lstPropDouble[0];
				String lstPropString[0];
				
				blockVisualizerTsl.dbCreate(scriptName(), _XW , _YW, gbsTsl, entsTsl, ptsTsl, sLastInserted, true, Map(), "", "");				
			}
		}
		
		eraseInstance();
		return;
	}
// end on insert	__________________//endregion


if (_Entity.length() > 0)
{	
	Display dp;
	dp.color(2);
//	Map blockRefInfo;
	
	BlockRef blockref = (BlockRef)_Entity[0];
	if ( ! blockref.bIsValid())
	{
		eraseInstance();
		return;
	}
	
	CoordSys csBlockref = blockref.coordSys();
	Point3d blockOrg = csBlockref.ptOrg();
	Vector3d blockrefX = csBlockref.vecX();
	Vector3d blockrefY = csBlockref.vecY();
	Vector3d blockrefZ = csBlockref.vecZ();
	
	double scaleX = blockref.dScaleX();
	double scaleY = blockref.dScaleY();
	double scaleZ = blockref.dScaleZ();
	
	String blockRefHandle = blockref.handle();
	
	Element el = blockref.element();
	_Pt0 = blockOrg;
	
	_ThisInst.assignToElementGroup(el, true, 0, 'Z');
	
	int nIndFound = _BlockNames.find(blockref.definition());
	if (nIndFound != false)
	{
		String strBlockName = blockref.definition();
		Block newblock(strBlockName);//= (Block)blockref;
		newblock.visualize(blockOrg, blockrefX * scaleX, blockrefY * scaleY, blockrefZ * scaleZ);
	}
	else
	{
		reportMessage(TN("|Block is not loaded in the drawing, load block |" + blockref.definition() + "| again.|"));
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
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Add scaling for blockrefs which have been inserted with a scale." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="6/24/2025 2:58:49 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Fix check whether the block is found in the libarary in the drawing." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="6/17/2025 6:11:46 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Initial version." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="3/26/2025 4:44:44 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End