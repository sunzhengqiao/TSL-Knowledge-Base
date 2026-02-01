#Version 8
#BeginDescription









#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
//basics and props
	Unit(1,"mm"); // script uses mm
	double dEps=U(.1);
	int nDebug = 1;
	
	PropInt nColor(0,132, T("|Color|"));
	
// on insert
	if (_bOnInsert)
	{
	// a metalPart could be linked as tool to multiple beams. to distinguish which beam is part of the assembly to be shopdrawn
	// one can select the defining dummy beam
		PrEntity ssB(T("|Select a set of dummy beams with tools which define the link to the assembly|") + " " + 
			T("|<Enter> to select shopdraw views|"), Beam());
		Beam bm[0];
		if (ssB.go())	
			bm =  ssB.beamSet();
		for(int b=0;b<bm.length();b++)
			if (bm[b].bIsDummy())
				_Beam.append(bm[b]);
	
	// if no dummy beam was selected it is assumed that one wants to define a shopdraw blockdefinition	
		if (_Beam.length()<1)
		{	
			PrEntity ssE(T("|Select a set of shopdraw views|"), ShopDrawView());
			if (ssE.go()) 
			{
				_Entity = ssE.set();
			}
		}
		_Pt0 = getPoint();
		return;
	}
//end on insert________________________________________________________________________________

// validate
	if( _Entity.length() == 0 && _Beam.length()==0){ eraseInstance(); return;}


// this script supports two modes depending from the selection set
	int nMode = 0; // shopdraw block definition mode
	if (_Beam.length()>0) nMode = 1; 

	Display dp(nColor);
	dp.textHeight(U(25));

// the shopdraw block mode
//	this mode defines the showSet of the multipage
	if (nMode==0)
	{	
		if (nDebug>0) reportMessage("\nTsl execution: " +scriptName() + ": " + _kExecuteKey + " - " + _bOnGenerateShopDrawing );
		
		addRecalcTrigger(_kShopDrawEvent, _kShopDrawViewDataShowSet );
		if (_bOnGenerateShopDrawing && _kExecuteKey==_kShopDrawViewDataShowSet ) 
		{
			// interprete the list of ViewData in my _Map
			ViewData arViewData[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets,2); // 2 means verbose
			
			// use the first entity / ShopDrawView for defining the show set from the define set.
			Entity entView = _Entity[0];
				
			int nIndFound = ViewData().findDataForViewport(arViewData, entView);// find the viewData for my view
			
			Entity entDefine;
			Entity entsShowSet[0];
			if (nIndFound>=0) { // my entView its viewdata is found at index nIndFound
				ViewData vwData = arViewData[nIndFound];
				Entity ents[] = vwData.showSetDefineEntities();
				entsShowSet = vwData.showSetEntities();
				if (ents.length()==1) // in case there is only one entity
					entDefine = ents[0];
			}
			
			if (!entDefine.bIsValid()) {
				reportMessage("\nError in "+scriptName()+": no define set entity found.");
			}
			GenBeam gbm = (GenBeam)entDefine;
			if (!gbm.bIsValid()) {
				reportMessage("\nError in "+scriptName()+": define set entity is not a genbeam.");
			}
		// there was one entity, and this one entity is a genbeam
			else 
			{ 
				// append to the existing showset all the tsl's which are attached to the beam
				Entity entTools[] = gbm.eToolsConnected();
				Body bdParent = gbm.envelopeBody();
				for (int e=0; e<entTools.length(); e++)
				{
					Entity ent = entTools[e];
					if (entsShowSet.find(ent)>=0)
						continue; // entity already in list
					
				// cast potential tsl's and mpc's		
					TslInst tsl = (TslInst)ent;
					MetalPartCollectionEnt mpce = (MetalPartCollectionEnt)ent;

					if (tsl.bIsValid())
					{
					// now append the tsl entity to the showset
					// remove clones of this tsl
						if(tsl.scriptName()!=scriptName()) 
							entsShowSet.append(tsl);
					}	
					// now append the MetalPartCollectionEnt entity to the showset				
					else if (mpce.bIsValid())
					{	
						// validate if clones of this script are attached to any of the mpce beams
						// if this is the case then enrich the showSet only for those which intersect with the
						// parent beam
						MetalPartCollectionDef mcd = mpce.definition();
						CoordSys csMpc=mpce.coordSys();
						TslInst tslMpd[] = mcd.tslInst();
						// remove notThis tsl's
						for (int t=tslMpd.length()-1; t>=0; t--)
							if (tslMpd[t].scriptName() != scriptName())
								tslMpd.removeAt(t);	
						
						if (tslMpd.length()>0)
						{
							for (int t=0; t<tslMpd.length(); t++)
							{
								Beam bmMpd[] = tslMpd[t].beam();
								for (int b=0; b<bmMpd.length(); b++)
								{
									Beam bm = bmMpd[b];
									bm.transformBy(csMpc);
									Body bdThis = bm.envelopeBody();
									if (bdThis.intersectWith(bdParent))
									{
										entsShowSet.append(mpce);	
										reportMessage("\n   Filtered set defined.");
										break;	
									}
									else
										reportMessage("\n   display refused for " + bm.posnum());
								}	
							}
						}
						// if no clones are found we append this to be shown
						else		
							entsShowSet.append(mpce);
					}
					else
						continue; // entity is not a Tsl or an metalpartColEnt
				}
				
				String strViewData = "ViewData";
				
				// now loop over all the ShopDrawViews and append a map to _Map for each
				for (int e=0; e<_Entity.length(); e++) 
				{
					ShopDrawView sdv = (ShopDrawView)_Entity[e];
					if (!sdv.bIsValid())
						continue;
						
					String strViewHandle = sdv.handle();
		
					// adjust the show set for the view
					Map mpViewData;
					// add new show set
					mpViewData.setEntityArray(entsShowSet, TRUE, "Handle[]", "showSetEntities", "han");
					// add view identification
					mpViewData.setString("ViewHandle",strViewHandle);
					// now add ViewData[]\\ViewData to _Map
					_Map.appendMap(_kShopDrawViewDataShowSet + "\\" + strViewData + "[]" + "\\" + strViewData, 
						mpViewData); // add to _Map with special key
				}
			}// END IF  this one entity is a genbeam
			
		// for debugging export map
			if (nDebug>0) _Map.writeToDxxFile(_kPathDwg+"\\"+_kShopDrawViewDataShowSet +".dxx",FALSE);
		}// END IF (_bOnGenerateShopDrawing && _kExecuteKey==_kShopDrawViewDataShowSet )
		
		// do not draw anything during shopdraw generation
		if (_bOnGenerateShopDrawing==TRUE) 
		{ 
			return;
		}
		
	// display in normal block mode
		// visualize the link to the viewport
		for (int e=0; e<_Entity.length(); e++) 
		{
			ShopDrawView sdv = (ShopDrawView)_Entity[e];
			if (!sdv.bIsValid())		continue;
			Point3d pt = (_Pt0+sdv.coordSys().ptOrg())/2;
			PLine pl(_ZW);
			pl.addVertex(_Pt0);
			pl.addVertex(_Pt0-_YW*_YW.dotProduct(_Pt0-pt));
			pl.addVertex(pt);
			pl.addVertex(sdv.coordSys().ptOrg());
			
			dp.draw(pl);	
		}
		dp.draw(scriptName() + " " + T("|defines these views|"), _Pt0, _YW,-_XW, 1,-1.2,_kDevice );
		dp.draw(T("|to display linked MetalPartCollection Entities|"), _Pt0, _YW,-_XW, 1,-4.2,_kDevice );	
	}
	else
	{
		for(int b=0;b<_Beam.length();b++)
			if (_Beam[b].bIsDummy())
				dp.draw(PLine(_Beam[b].quader().pointAt(1,1,1),_Beam[b].quader().pointAt(-1,-1,-1)));
		
		dp.draw(scriptName(), _Pt0, _XW,_YW, .95,1,_kDeviceX );
		dp.draw(T("|Beams intersecting the marked dummies|"), _Pt0, _XW,_YW, 1,-2,_kDeviceX );
		dp.draw(T("|will show MetalPartCollection Entities|"), _Pt0, _XW,_YW, 1,-5,_kDeviceX );
	}

#End
#BeginThumbnail


#End
