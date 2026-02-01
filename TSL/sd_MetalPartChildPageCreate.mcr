#Version 8
#BeginDescription
/// Version 1.2   th@hsbCAD.de   01.03.2011
/// supports childpages of genBeams

/// Creates nested multipages in dependency of the content of the metalpart collection entity
/// and of the given styles


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// Creates nested multipages in dependency of the content of the metalpart collection entity
/// and of the given styles
/// </summary>

/// <insert Lang=en>
/// Select a viewport in the blockdefinition and a pline which represents the area of child pages
/// </insert>

/// History
/// Version 1.2   th@hsbCAD.de   01.03.2011
/// supports childpages of genBeams
/// Version 1.1   th@hsbCAD.de   19.10.2010

//basics and props
	Unit(1,"mm");
	PropString sShopDrawStyleCE(0,"",T("|Shopdraw style|") + " " + T("|Metalpart|") + " " + T("|Assembly|"));
	PropString sShopDrawStyleCESingle(2,"",T("|Shopdraw style|") + " " + T("|Metalpart|")+ " " + T("|Single|"));		
	PropString sShopDrawStyleBM(1,"",T("|Shopdraw style|") + " " + T("|GenBeam|"));
	

	String sPrompt = T("|Select pline area where child pages can be placed|");
	
	int nDebug = 1;
	
// on insert
	if (_bOnInsert)
	{
		_Pt0 = getPoint();
		EntPLine ent = getEntPLine(sPrompt);
		// store the PLine from the selected entity in my map
		_Map.setPLine("myPL",ent.getPLine());
		// erase selected pline
		ent.dbErase();		
		showDialogOnce();
		return;
	}
	
// debug	
	reportMessage("\nTsl execution: " +scriptName() + ": " + sShopDrawStyleCE+ " - " + _kExecuteKey + " " + _bOnGenerateShopDrawing );

// append context command to select a different childPageArea Pline
	String strChangeEntity = sPrompt ;
	addRecalcTrigger(_kContext, strChangeEntity );
	if (_bOnRecalc && _kExecuteKey==strChangeEntity) {
		EntPLine ent = getEntPLine(sPrompt );
		// store the PLine from the selected entity in my map
		_Map.setPLine("myPL",ent.getPLine());
		// erase selected pline
		ent.dbErase();
	}
	
// retrieve my own pline
	PLine pline = _Map.getPLine("myPL");
	addRecalcTrigger(_kShopDrawEvent, _kShopDrawChildPageArea );
	if (_bOnGenerateShopDrawing && _kExecuteKey==_kShopDrawChildPageArea) 
	{
		// create a map with content plArea
		_Map.setPLine(_kShopDrawChildPageArea+ "\\plArea", pline);
		// for debugging export map
		//_Map.writeToDxxFile(_kPathDwg+"\\"+_kShopDrawChildPageArea+".dxx");
	}	
	

// add shopdraw events
	addRecalcTrigger(_kShopDrawEvent, _kShopDrawChildPageCreate );
	if (_bOnGenerateShopDrawing && _kExecuteKey==_kShopDrawChildPageCreate ) 
	{
		String strMapLocation = _kShopDrawChildPageCreate + "\\" + "Handle[]";
		Entity arEnts[] = _Map.getEntityArray(strMapLocation, "defineSetEntities", "han");
		if (arEnts.length()==0)
		{ // no entities to shopdraw?
			reportMessage("\nNo entities to shopdraw." + strMapLocation );
		}
	
	// find a beam
		GenBeam arGenBeams[0];
		String strPage = "Page";
	
		for (int e=0; e<arEnts.length(); e++) 
		{
			GenBeam gb = (GenBeam)arEnts[e];
		// process only beams and/or collection entities
			if (!gb.bIsValid() && !arEnts[e].bIsKindOf(CollectionEntity())) 
				continue;
				
		// flag if separate SD for each CE to be created
			int bCreateCE;		

		// collect connected metalparts
			CollectionEntity ce[0];
			Entity entTools[0];					
			if (gb.bIsValid())
			{	
				arGenBeams.append(gb);
				entTools = gb.eToolsConnected();
				bCreateCE=true;
			}
			else if (arEnts[e].bIsKindOf(CollectionEntity()))
			{
				reportMessage("\n   Collection Entity recognized.");
				entTools.append(arEnts[e]);
			}
	
		// loop all tools	
			for (int t=0; t<entTools.length(); t++) 
			{
				Entity arEntsNewDefineSet[0];
				Map mpPage;
				if(entTools[t].bIsKindOf(MetalPartCollectionEnt ()))
				{
					reportMessage("\n   processing definition " + ((MetalPartCollectionEnt )entTools[t]).definition());
					
				// get the ent and the definition	
					MetalPartCollectionEnt mpce = (MetalPartCollectionEnt )entTools[t];
					CoordSys csMpc=mpce.coordSys();
					MetalPartCollectionDef mpcd = mpce.definition();					
					
					TslInst tslMpd[] = mpcd.tslInst();
					// remove notThis tsl's
					for (int t=tslMpd.length()-1; t>=0; t--)
						if (tslMpd[t].scriptName().makeUpper() != "HSBDEFINESHOPDRAWSHOWSETMETALPART")
							tslMpd.removeAt(t);	
					
					int bOk=true;
					reportMessage("\n   testing for filtered set defined.");
					if (tslMpd.length()>0 && gb.bIsValid())
					{
						for (int t=0; t<tslMpd.length(); t++)
						{
							GenBeam gbMpd[] = tslMpd[t].genBeam();
							for (int b=0; b<gbMpd.length(); b++)
							{
								GenBeam gbTest= gbMpd[b];
								gbTest.transformBy(csMpc);
								Body bdThis = gbTest.envelopeBody();
								if (bdThis.intersectWith(gb.envelopeBody()))
								{
									reportMessage("\n   Filtered set defined.");
									break;	
								}
								else
								{
									reportMessage("\n   display refused for " + gb.posnum());
									bOk=false;	
								}
							}	
						}
					}
					if (!bOk)continue;
				
				// before adding the child page validate if the metalpart conmsists of more than one beam
				// recurse all CE genbeams	if more than 1
					GenBeam gbCE[] = mpcd.genBeam();
					
					// no dummies
					for (int b=gbCE.length()-1; b>=0; b--)
						if(gbCE[b].bIsDummy())
							gbCE.removeAt(b);				
				
					
				// add the shopDrawStyle
					if (bCreateCE)
					{
						String sMyStyle = sShopDrawStyleCE;
						if (gbCE.length()==1) sMyStyle = sShopDrawStyleCESingle;
						
						
						mpPage.setString("shopDrawStyle",sMyStyle );
						ce.append((CollectionEntity)entTools[t]);	
					// add the define set for the page to be inserted
						arEntsNewDefineSet.append(entTools[t]);				
						mpPage.setEntityArray(arEntsNewDefineSet, TRUE, "Handle[]", "defineSetEntities", "han");
					// now add Page[]\\Page to _Map
						_Map.appendMap(_kShopDrawChildPageCreate + "\\" + strPage + "[]" + "\\" + strPage , mpPage); // add to _Map with special key
					}
					

					
					if (gbCE.length()>1)
					{
					// order by posnum
						for (int b=0; b<gbCE.length(); b++)
							for (int c=0; c<gbCE.length()-1; c++)							
								if (gbCE[b].posnum()<gbCE[c].posnum())
									gbCE.swap(b,c);
							
					// create child pages	
						int bWarningDisplayed;
						for (int b=0; b<gbCE.length(); b++)
						{						
							int posnum = gbCE[b].posnum();
							// alert if not numbered
							if (posnum==-1 && !bWarningDisplayed)
							{
								reportNotice("\n\n******************** " + T("|Warning|") + " ********************" + "\n" + 
													T("|The shopdrawing might be incomplete due\nto missing numbers of the metal part entities.|") + "\n" +
													T("|Please edit the block definition of the metal part,\napply posnums and regenerate the multipage.|")+
													"\n****************************************************\n");
								bWarningDisplayed=true;
							}
							// no duplicates
							if (b>0 && gbCE[b-1].posnum()==posnum) continue;
							if (nDebug>0) reportMessage("\n   recursing " + posnum);
							
							arEntsNewDefineSet.setLength(0);
							arEntsNewDefineSet.append(gbCE[b]);
							Map mpPage2;
							mpPage2.setString("shopDrawStyle",sShopDrawStyleBM);
							mpPage2.setEntityArray(arEntsNewDefineSet, TRUE, "Handle[]", "defineSetEntities", "han");
							_Map.appendMap(_kShopDrawChildPageCreate + "\\" + strPage + "[]" + "\\" + strPage , mpPage2); // add to _Map with special key
							if (nDebug>0) reportMessage("\n   define set is" + arEntsNewDefineSet);	
						}// next b beam
					}// END IF gbCE.length()>1
				}// END IF (entTools[t].bIsKindOf(MetalPartCollectionEnt ()))
			}// next t entool
		}// next e arEnts
		
	// for debugging export map
	_Map.writeToDxxFile(_kPathDwg+"\\"+_kShopDrawChildPageCreate +".dxx");
	}
	
// do not draw anything during shopdraw generation
	if (_bOnGenerateShopDrawing==TRUE) { 
		return;
	}
	
// display in normal block mode
	Display dp(-1);
	dp.textHeight(U(50));
	dp.draw(scriptName(), _Pt0, _XU, _YU, 0.8,3,_kDevice );
	dp.draw(T("|Metal Part Assembly|")+": "+sShopDrawStyleCE, _Pt0, _XU, _YU, 1,0,_kDevice );
	dp.draw(T("|Metal Part Single|")+": "+sShopDrawStyleCESingle, _Pt0, _XU, _YU, 1,-3,_kDevice );	
	dp.draw(T("|GenBeam|")+": "+sShopDrawStyleBM, _Pt0, _XU, _YU, 1,-6,_kDevice );

	// draw the child page area
	dp.draw(pline);	
	


#End
#BeginThumbnail
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
.O5,7;CHB?K_C3L%S_]FH
`



#End
