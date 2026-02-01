#Version 8
#BeginDescription
#Versions: 
1.7 03.04.2023 HSB-18065: Support Lowfield-SpaceStudAssembly 
1.6 06.05.2022 HSB-15357: Support GC-SpaceStudAssembly 
v1.6










#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 0
#FileState 1
#MajorVersion 1
#MinorVersion 7
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// Consumes any GenBeam and creates several dimrequests in dependency of the contour and containg drills
/// </summary>

/// <insert Lang=en>
/// This tsl is only executed by the shopdraw engine and to use it one
/// needs to append it to the ruleset of a multipage style.
/// </insert>

/// <remark Lang=en>
/// This tsl requires the TSL mapIO_GetArcPLine.mcr in the drawing or
/// in one of the search path's 
/// </remark>

/// <remark Lang=en>
/// Uses the following Stereotypes: Drill, Extremes, Contour, Beamcut (optimized to 'relative to offset direction')
/// </remark>

/// History
/// #Versions
// 1.7 03.04.2023 HSB-18065: Support Lowfield-SpaceStudAssembly Author: Marsel Nakuci
// 1.6 06.05.2022 HSB-15357: Support GC-SpaceStudAssembly Author: Marsel Nakuci
/// Version 1.0   aj@hsb-cad.com   14.04.2011
/// Version 1.3   aj@hsb-cad.com   14.04.2011 Fix issue with filter for Space Stud Assembly
/// Version 1.4   aj@hsb-cad.com   27.03.2012 Added sip to the fitler list
/// Version 1.5   aj@hsb-cad.com   16.07.2012 Add filter only for beams that have tools
/// initial


// basics and props
	U(1,"mm");
	double dEps = U(0.1);
	int nDebug=0;
	int bReportViews = false;
	int bReportOptions = false;	

// on insert
	if (_bOnInsert)
	{
		_GenBeam.append(getGenBeam());
		//_Entity.append(_GenBeam[0]);
		_Pt0 = getPoint("Select point near tool");
		return;
	}
//end on insert________________________________________________________________________________


// declare the options to be set through the Map
	// NOTE: the CustomMapSettings and CustomMapTypes need to have the same length !
	String sCustomMapSettings[] = {"InsertOption"};
	String sCustomMapTypes[] = {"int"};
	
// on MapIO
	String sInsertOptions[] = {T("|Beams|"),T("|Sheets|"),T("|Wall Elements|"), T("|SubAssembly|"), T("|SpaceStud Assembly|"),T("|Sip|"), T("|Only beams with tools|"), T("|Only sheets with tools|")};

	if (_bOnMapIO)
	{
		PropString sEntityType(0,sInsertOptions,T("|Entity to Select|"));
		sEntityType.setDescription(T("|Only this entities will be added to the shopdraw|"));		

		//PropString NotchDimMode(3,sArNotchDimMode,sCustomMapSettings[3]);// NotchDimMode


	// make sure the offsets are not set to zero when called the first time
		//if(!_Map.hasString(sCustomMapSettings[0]))		_Map.setString(sCustomMapSettings[0],String().formatUnit(U(5),2,0));

												
	// find value in _Map, if found, change the property values
		
		sEntityType.set(sInsertOptions[_Map.getString(sCustomMapSettings[0]).atoi()]);
		
		// show the dialog to the user
		showDialog("---"); // use "---" such that the set values are used, and not the last dialog values
		_Map = Map();

		// interpret the properties, and fill _Map
		// by checking the index default values will not be written to _Map
		_Map.setString(sCustomMapSettings[0],sInsertOptions.find(sEntityType));	
	
		return;
	}

// declare the map of options
	Map mapOption;
	
// append user defined map settings to the options map
	for (int s = 0;s<sCustomMapSettings.length();s++)	
	{
		for (int i = 0;i<_Map.length();i++)
		{
			if (_Map.keyAt(i).makeUpper()==sCustomMapSettings[s].makeUpper() && _Map.hasString(i))
			{
				if (sCustomMapTypes.length() < s)
					;
				else if (sCustomMapTypes[s] == "int")
					mapOption.setInt(sCustomMapSettings[s],_Map.getString(i).atoi()); 	
				else if (sCustomMapTypes[s] == "double")
					mapOption.setDouble(sCustomMapSettings[s],_Map.getString(i).atof()); 						
				else
					mapOption.setString(sCustomMapSettings[s],_Map.getString(i)); 
			}
		}
	}

// properties
	int nEntityType = mapOption.getInt(sCustomMapSettings[0]);
		// 0 = Beam
		// 1 = Sheet
		// 2 = Wall
		// 3 = SubAssembly
		// 4 = SpaceStud Assembly
		// 5 = Sip
		// 6 = Only beams with tools
		// 7 = Only sheets with tools


	if (_Entity.length()==0)
	{
		return; // do not do anything
	}
	
	// take copy of _Entity array
	Entity arAll[_Entity.length()];
	for (int i=0; i<_Entity.length(); i++) 
		arAll[i] = _Entity[i];
	
	// reset content of _Entity
	_Entity.setLength(0);
	
	// filter the beams that belong to an element
	for (int i=0; i<arAll.length(); i++)
	{
		if (nEntityType==0)//Beam
		{
			Beam bm = (Beam)arAll[i];
			if (bm.bIsValid())
			{
				_Entity.append(bm);
			}	
		}

		if (nEntityType==1)//Sheet
		{
			Sheet sh = (Sheet)arAll[i];
			if (sh.bIsValid())
			{
				_Entity.append(sh);
			}
		}

		if (nEntityType==2)//Wall
		{
			ElementWall el = (ElementWall)arAll[i];
			if (el.bIsValid())
			{
				_Entity.append(el);
			}
		}
		if (nEntityType==3)//SubAssembly
		{
			TslInst tsl = (TslInst) arAll[i];
			if (tsl.bIsValid())
			{
				_Entity.append(tsl);
			}
		}
		if (nEntityType==4)//Space Stud Assembly
		{
			TslInst tsl = (TslInst) arAll[i];
			if (tsl.bIsValid())
			{
				if (tsl.scriptName()=="hsb_SpaceStudAssembly")
				{
					Map mp=tsl.map();
					if (mp.hasString("SpaceStudAssembly"))
					{
						_Entity.append(tsl);
					}
				}
				// HSB-15357: support for Greencore TSL
				if (tsl.scriptName()=="GC-SpaceStudAssembly")
				{
					Map mp=tsl.map();
					if (mp.hasString("SpaceStudAssembly"))
					{
						_Entity.append(tsl);
					}
				}
				// HSB-18065: support for Lowfield TSL
				if (tsl.scriptName()=="Lowfield-SpaceStudAssembly")
				{
					Map mp=tsl.map();
					if (mp.hasString("SpaceStudAssembly"))
					{
						_Entity.append(tsl);
					}
				}
			}
		}
		if (nEntityType==5)//Panel
		{
			Sip sip = (Sip)arAll[i];
			if (sip.bIsValid())
			{
				_Entity.append(sip);
			}
		}
		
		if (nEntityType==6)//Beam
		{
			Beam bm = (Beam)arAll[i];
			if (bm.bIsValid())
			{
				AnalysedTool allTools[]=bm.analysedTools();
				for (int i=0; i<allTools.length(); i++)
				{
					AnalysedTool at=allTools[i];
					if ( at.toolType()=="AnalysedCut" && at.toolSubType()== _kACPerpendicular)
					{
						allTools.removeAt(i);
						i--;
					}
				}
				if (allTools.length()>0)
				{
					_Entity.append(bm);
				}
			}	
		}
		
		if (nEntityType==7)//Beam
		{
			Sheet sh = (Sheet) arAll[i];
			if (sh.bIsValid())
			{
				PLine plSh=sh.plEnvelope();
				Point3d ptAllVertex[]=plSh.vertexPoints(false);
				
				if (ptAllVertex.length()!=5)
				{
					_Entity.append(sh);
				}
				else
				{
					int nShape=false;
					
					AnalysedTool allTools[]=sh.analysedTools();
					
					if (allTools.length()>0)
					{
						nShape=true;
					}
					else
					{
						for (int i=0; i<ptAllVertex.length()-2;i++)
						{
							Vector3d vA(ptAllVertex[i]-ptAllVertex[i+1]);
							Vector3d vB(ptAllVertex[i+1]-ptAllVertex[i+2]);
							vA.normalize();
							vB.normalize();
	
							if (abs(vA.dotProduct(vB))>0.01)
							{
								nShape=true;
							}
						}
					}

					if (nShape)
					{
						_Entity.append(sh);
					}
				}
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
      <str nm="Comment" vl="HSB-18065: Support Lowfield-SpaceStudAssembly" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="4/3/2023 4:59:54 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15357: Support GC-SpaceStudAssembly" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="5/6/2022 1:44:12 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End