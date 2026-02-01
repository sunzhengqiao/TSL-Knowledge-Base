#Version 8
#BeginDescription
version value="1.3" date="06jul20" author="nils.gregor@hsbcad.com"> 
HSB-7515 bugfix length/depth as double 










Version 1.4 07/08/2023 Thickness is an optional incoming parameter now. , Tamas Racz
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 0
#FileState 0
#MajorVersion 1
#MinorVersion 4
#KeyWords 
#BeginContents
// Rev 1.1 - Initial Coding.

/// <History>//region
/// <version value="1.3" date="06jul20" author="nils.gregor@hsbcad.com"> HSB-7515 bugfix length/depth as double </version>
/// </History>



	double dLength = _Map.getDouble("Length");
	Unit(1,"mm");

	if ( _bOnDbCreated )
	{
      _ThisInst.setColor( 8 );
	}

	if ( dLength > 0 )
	{
		Display dp( -1 );
	
		Vector3d VecBX(_Map.getDouble("XV_X"),_Map.getDouble("XV_Y"),_Map.getDouble("XV_Z"));
		Vector3d VecBY(_Map.getDouble("YV_X"),_Map.getDouble("YV_Y"),_Map.getDouble("YV_Z"));
		Vector3d VecBZ(_Map.getDouble("ZV_X"),_Map.getDouble("ZV_Y"),_Map.getDouble("ZV_Z"));
		double vecZOffset = 0.0;
		int singlePlate = _Map.getInt("singlePlate");
		
		// If no vectors definded in map then we are using the new modelmap. Vector are in the coord sys.
		if ( _Map.getDouble("XV_X") == 0.0 &&_Map.getDouble("XV_Y") == 0.0 && _Map.getDouble("XV_Z") == 0.0 )
		{
			CoordSys coord = _ThisInst.coordSys();

			VecBX = coord.vecX();
			VecBY = coord.vecY();
			VecBZ = coord.vecZ();
			vecZOffset= _Map.getDouble("vecZOffset");
		}

		double dDepth = _Map.getDouble("Width");
		String strGauge = _Map.getString("Gauge");
		String strLabel = _Map.getString("Label");

		if ( dLength > 0 && dDepth > 0 )
		{
			double dThickness = U(2.0,"mm");
			String thicknessParamName = "Thickness";
			if(_Map.hasDouble(thicknessParamName))
			{ 
				dThickness = _Map.getDouble(thicknessParamName);
			}

			PropString strPlateGauge( 1, strGauge, T( "|Plate Gauge|") );
			PropString strPlateLabel( 2, strLabel, T( "|Plate Label|") );
			PropDouble dPlateLength( 3, dLength, T("|Plate Length|") );
			PropDouble dPlateHeight( 4, dDepth, T("|Plate Height|") );
			PropDouble dPlateThickness(5, dThickness, T("|Plate Thickness|") );

			dPlateLength.setReadOnly( TRUE );
			dPlateHeight.setReadOnly( TRUE );
			dPlateThickness.setReadOnly( TRUE );
			strPlateGauge.setReadOnly( TRUE );
			strPlateLabel.setReadOnly( TRUE );

			VecBX.normalize();
			VecBY.normalize();
			VecBZ.normalize();

			if  ( vecZOffset > 0.0  || singlePlate != 0)
			{
				Body BdPlateLeft( _Pt0 + vecZOffset* VecBZ, VecBX, VecBY, VecBZ, (double)dLength ,(double)dDepth, (double)dPlateThickness );
				BdPlateLeft.vis(3);
				dp.draw(BdPlateLeft);

				if (!singlePlate) 
				{
					Body BdPlateRight( _Pt0 - vecZOffset* VecBZ, VecBX, VecBY, VecBZ, (double)dLength ,(double)dDepth, (double)dPlateThickness );
					BdPlateRight.vis(3);
					dp.draw(BdPlateRight);
				}
			}
			else
			{
				Body BdPlate( _Pt0, VecBX, VecBY, VecBZ, (double)dLength , (double)dPlateThickness , (double)dDepth );
				BdPlate.vis(3);
				dp.draw(BdPlate);
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
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Thickness is an optional incoming parameter now." />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="8/7/2023 1:05:51 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End