#Version 8
#BeginDescription
This tsl swaps the Y- and Z-Axis and the corresponding values simultaneously 

#Versions
Version 1.0 07.12.2022 HSB-17248 new command to switch Y- and Z-Axis but keep geometry in space
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
//region <History>
// #Versions
// 1.0 07.12.2022 HSB-17248 new command to switch Y- and Z-Axis but keep geometry in space , Author Thorsten Huck

/// <insert Lang=en>
/// Select beams to swap width and height
/// </insert>

// <summary Lang=en>
// This tsl swaps the Y- and Z-Axis and the corresponding values simultaneously 
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "SwapBeamHeight")) TSLCONTENT

//endregion


//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
//end Constants//endregion

//region OnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }

	// prompt for beams
		Beam beams[0];
		PrEntity ssE(T("|Select beams|"), Beam());
		if (ssE.go())
			beams.append(ssE.beamSet());
		
		
		for (int i=0;i<beams.length();i++) 
		{ 
			double w = beams[i].dW();
			double h = beams[i].dH();
			
			beams[i].setD(beams[i].vecY(), h);
			beams[i].setD(beams[i].vecZ(), w);

			pushCommandOnCommandStack("_HSB_BEAMSWITCHYZ");
 			pushCommandOnCommandStack("(handent \""+beams[i].handle()+"\")");
			pushCommandOnCommandStack("(Command \"\")");

		}//next i

		eraseInstance();
		return;
	}			
//endregion 
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
      <str nm="Comment" vl="HSB-17248 new command to switch Y- and Z-Axis but keep geometry in space" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="12/7/2022 3:26:54 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End