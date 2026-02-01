#Version 8
#BeginDescription
Draw a table in model with information from the panel and export it to Excel.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 09.08.2012 - version 1.1


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords master
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2011 by
*  hsbSOFT 
*  IRELAND
*
*  The program may be used and/or copied only with the written
*  permission from hsbSOFT, or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
* REVISION HISTORY
* -------------------------
*
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 29.09.2011
* version 1.0: Release Version
*
*/

U(1,"mm");
PropString 	sDimStyle(0, _DimStyles, T("|Dimstyle|"));
//PropString 	sDimStyle(0, "QTR INCH", T("Dimstyle"));
PropString		prStrTitulo( 1, T("|Wall Schedule|"), T("|Title:| "));
//prStrTitulo.setReadOnly(TRUE);

//sr
String strStringType[]={T("|Left|"),T("|Right|"),T("|Center|")};
PropString prStrType(2,strStringType,T("|String Type Align|"));
int nStringType=strStringType.find(prStrType);

String strDoubleType[]={T("|Left|"),T("|Right|"),T("|Center|")};
PropString prDbleType(3,strDoubleType,T("|Double Type Align|"));
int nDoubleType=strDoubleType.find(prDbleType);

String strIntType[]={T("|Left|"),T("|Right|"),T("|Center|")};
PropString prIntType(4,strIntType,T("|Int Type Align|"));
int nIntType=strIntType.find(prIntType);

String strPlineType[]={T("|Left|"),T("|Right|"),T("|Center|")};
PropString prPlineType(5,strPlineType,T("|Pline Type Align|"));
int nPlineType=strPlineType.find(prPlineType);

PropDouble dScalePl (0, 0, T("|Scale Factor|"));
//PropDouble dOffset (1, U(300), T("|Offset Align|"),0); //AJ
double dOffset=U(3);
//sr

PropInt nColorGrid(0, 8, T("|Grid Color|"),0);
PropInt nColorText(1, 254, T("|Text Color|"),0);

// -----------------------------------------------------------------------------
//  insert .........
// -----------------------------------------------------------------------------
if (_bOnInsert) {
	
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}

	if (_kExecuteKey=="")
		showDialogOnce();

	_Pt0 = getPoint("Pick insertion point for the table" );

	
	PrEntity ssE(T("Select Elements"),Element());
	
	if( ssE.go() )
	{
		_Element.append(ssE.elementSet());
	}
	
	return;
}

// ----------------------------------------------------------------------------
//   _Map properties to be used in other tsls
// ----------------------------------------------------------------------------
_Map.setString( "OID", _ThisInst.handle() );
_Map.setPoint3d( "LOC", _Pt0 );
_Map.setString( "TIPO", "TslCuadro" );
// ----------------------------------------------------------------------------

if (_Element.length()==0)
{
	eraseInstance();
	return;
}

Entity ent[0];
for (int i=0; i<_Element.length(); i++)
{
	//Entity en=
	ent.append(_Element[i]);
	GenBeam gb[]=_Element[i].genBeam();
	for (int j=0; j<gb.length(); j++)
	{
		ent.append(gb[j]);
	}
}


ModelMapComposeSettings mmOutFlags;
mmOutFlags.addSolidInfo(TRUE); // default FALSE
mmOutFlags.addAnalysedToolInfo(TRUE); // default FALSE
mmOutFlags.addElemToolInfo(TRUE); // default FALSE
mmOutFlags.addConstructionToolInfo(TRUE); // default FALSE
mmOutFlags.addHardwareInfo(TRUE); // default FALSE
mmOutFlags.addRoofplanesAboveWallsAndRoofSectionsForRoofs(TRUE); // default FALSE
mmOutFlags.addCollectionDefinitions(TRUE); // default FALSE


// compose ModelMap
ModelMap mmOut;
mmOut.setEntities(ent);
mmOut.dbComposeMap(mmOutFlags);

String strDllPath   = _kPathHsbInstall+ "\\Content\\UK\\TSL\\DLLs\\WallSchedule\\hsb_WallPanelSchedule.dll";
String strClassName = "hsbSoft.WallPanelSchedule.Insertion.MapTransaction";					// please exact matching
String strFunction  = "LoadWallPanelSchedule";					// nombre de la funcion
Map mapOut = callDotNetFunction2(strDllPath, strClassName, strFunction, mmOut.map());
Map mp1;
mp1.setMap("Table", mapOut);
mp1.setString("Path", _kPathDwg);
mp1.writeToDxxFile("C:\\TableOut.dxx");

_Map=Map();
_Map=mp1;

// -----------------------------------------------------------------------------
Display dp(nColorGrid);									// display to draw the color by layer
dp.dimStyle(sDimStyle);							// set dimstyle 
double 	aText = dp.textHeightForStyle( "0.00", sDimStyle);	//  text height
Map mapNiveles;
if( _Map.hasMap( "Table" ) ){
	mapNiveles = _Map.getMap( "Table" );
}

Map mpTest=mapNiveles.getMap(0);

// ------------------------------------------------------------------------------
// drawing the table
// ---------------------------------------------------------------------------------
// all the options for the table
// ---------------------------------------------------------------------------------
if( mapNiveles.length() != 0 )
{
	double 	dRH = dp.textHeightForStyle( "AREAS", sDimStyle) * 2;	// Height rows
	double 	dRowLen = 0.0;			//  table length 

	// -----------------------------------------------------------------------
	// calculating rows length 
	// -----------------------------------------------------------------------
	int maplen = mapNiveles.length();	
	int submapalen = mapNiveles.getMap(0).length();		// is the number of columns 
	double arDColW2[submapalen];
	for( int i = 0; i < submapalen; i ++ )	// initialize  the length
		arDColW2[i] = 0.0;
	
	double anchocont;
	for( int nel = 0; nel < mapNiveles.length(); nel ++ ) {
		Map submapa = mapNiveles.getMap( nel );	// get the first map
		for( int i = 0; i < submapalen; i ++ ) {
			
			String stemp;
			double dstemp=0;
			int nstemp=0;
			if(submapa.hasString(i))
				stemp= ( submapa.getString( i ));
			
			if(submapa.hasDouble(i))
				stemp= ( submapa.getDouble( i ));
					
			if(submapa.hasInt(i))
				stemp= ( submapa.getInt( i ));
					
			int 		len 	= stemp.length()+7;
			String    scero;
			for( int cc = 0; cc < len; cc ++ )
				scero += "0";
			stemp = scero;
			anchocont = dp.textLengthForStyle( stemp , sDimStyle );
			//reportMessage( "fila " + nel + " col " + i + " " + anchocont + " " + stemp + "\n" );		
			if( anchocont >	arDColW2[i] ){
				arDColW2[i] = anchocont;
				//reportMessage( " MAYOR " + stemp+ " "  + nel + " col " + i + " " + anchocont + "\n" );		
			}
		}
	}
	dRowLen = 0.0;
	for( int i = 0; i < submapalen; i ++ ){
		arDColW2[i] *= 1.25;		// the length increase 45%
		dRowLen += arDColW2[i];	
		//reportMessage( " final " + i + " "  + arDColW2[i]+ "\n" );		
	}

	// ----------------------------------------------------------------------------
	//Draw header and outline of table.
	// ----------------------------------------------------------------------------
	int nNrOfRows = mapNiveles.length()+1; 							// rows number = submaps number
	Point3d ptTL = _Pt0;											// 
	Point3d ptTR = ptTL + _XW * dRowLen;					// top left
	Point3d ptBR = ptTR - _YW * dRH * (nNrOfRows + 1);	// top right
	Point3d ptBL = ptBR - _XW * dRowLen;					// bottom right
	PLine plOutline(ptTL, ptTR, ptBR, ptBL); 				// outline
	plOutline.close();
	dp.draw(plOutline);
	Point3d ptTitulo = ptTL + _XW * 0.5 * dRowLen;
	ptTitulo = ptTitulo - _YW * 0.5 * dRH;
	dp.draw( prStrTitulo, ptTitulo,_XW, _YW, 0, 0);
	_Map.setString( "titulo", prStrTitulo );
	// ----------------------------------------------------------------------------
	// other lines
	// ----------------------------------------------------------------------------
	PLine 		plHor(ptTL, ptTR);
	Vector3d 	vMoveHor(-_YW * dRH);			// rows distance
	plHor.transformBy(vMoveHor);
	dp.draw(plHor);
	PLine 		plVer(ptTL -_YW * dRH, ptTL -_YW * 2 * dRH);
	dp.draw(plVer);
	
	//-----------------------------------------------------------------------------------
	// draw the header of each column
	// taking  in count the length of the text
	// is important to know the last line where the half distance of the current column and the next are added 
	// by now is static
	//-----------------------------------------------------------------------------------
	Map mapaHeader = mapNiveles.getMap( 0 );
	Point3d ptTextHeader = ptTL - _YW * 1.5 * dRH;
	ptTextHeader = ptTextHeader + _XW * 0.5 * arDColW2[0];	// the position is in the center of the column
	for( int i = 0; i < submapalen; i ++ ) {
		dp.draw( mapaHeader.keyAt(i) , ptTextHeader, _XW, _YW, 0, 0);
		Vector3d vMoveVer( _XW * arDColW2[i]);
		plVer.transformBy(vMoveVer);
		dp.draw(plVer);
		if( i < submapalen - 1 )
			ptTextHeader = ptTextHeader + _XW * 0.5 * arDColW2[i]+ _XW * 0.5 * arDColW2[i+1];
		else
			ptTextHeader = ptTextHeader + _XW * 0.5 * arDColW2[i]+ _XW * 0.5 * arDColW2[i];
	}
	
	// --------------------------------------------------------------------------------
	// drawing the vertical lines of each row
	// -------------------------------------------------------------------------------
	{
		Vector3d vxW( - _XW * dRowLen );	// length of the table 
		for( int i = 0; i < mapNiveles.length(); i ++ ) {
			plHor.transformBy(vMoveHor);		// 
			dp.draw(plHor);
			plVer.transformBy( vMoveHor );
			plVer.transformBy( vxW );
			for( int i = 0; i < submapalen; i ++ ) {
				Vector3d vMoveVer( _XW * arDColW2[i]);
				plVer.transformBy(vMoveVer);
				dp.draw(plVer);
			}
		}
	}
	// -------------------------------------------------------------------------------
	// fill the rows with the submaps
	// change the color  ????
	// -------------------------------------------------------------------------------
	{
		ptTextHeader = ptTL - _YW * 2.5 * dRH;
		ptTextHeader = ptTextHeader + _XW * 0.5 * arDColW2[0];	
		Point3d ptemp = ptTextHeader;
		Point3d ptText1 = ptTL - _YW * 2.5 * dRH;			//vertical  position 
		ptemp = ptText1;
		String  scontenido;
		double  dAncho;
		PLine PlContenido;
		PLine PlAux;
		PLine PlAux1;

		Point3d ptT = ptText1;
		Point3d ptUno = ptT;
		
		for( int i = 0; i < mapNiveles.length(); i ++ ) {
			Map submap = mapNiveles.getMap(i);
			String strAb = submap.getString( 4 );
			dp.color(nColorText);
			
			Point3d ptL[0];  //left points of the row
			Point3d ptR [0]; //right points of the row
			//------------------------------left
			ptL.append(ptUno +_XW*dOffset );    //60
			Point3d ptAux=ptUno+_XW*dOffset  ;    //60 
			
			for (int k=0;k<submap.length();k++)
			{
				Point3d ptLaux=ptAux+_XW* arDColW2[k];
				ptL.append(ptLaux);
				ptR .append(ptLaux-_XW*(dOffset*2 ));    //120
				ptAux=ptLaux;
			}
			ptL.removeAt(ptL.length()-1);
			
			
			//---------------------------right
			for( int x = 0; x < submap.length(); x ++ ) {
				Point3d ptExp; //point where the text/double/int /pline will be possitioned
				int flag=0;
				if(submap.hasString(x))
				{
					scontenido = submap.getString(x);//--------->get string
					if(nStringType==0)   // left
					{
						ptExp=ptL[x];
						flag=1.1;
					}
					if(nStringType==1)//right
					{
						ptExp=ptR[x];
						flag=-1.1;
					}
					if(nStringType==2)//center
					{
						ptExp=LineSeg(ptL[x],ptR[x]).ptMid();
					}
				}
				
				if(submap.hasDouble(x))
				{
					scontenido = submap.getDouble(x);//-------->get double
					if(nDoubleType==0)//left
					{
						ptExp=ptL[x];
						flag=1.1;
					}
					if(nDoubleType==1)//right
					{
						ptExp=ptR[x];
						flag=-1.1;
					}
					if(nDoubleType==2)//center
					{
						ptExp=LineSeg(ptL[x],ptR[x]).ptMid();
					}
				}
	
				if(submap.hasInt(x))
				{
					scontenido = submap.getInt(x);//-------->get pline
					if(nIntType==0) //left
					{
						ptExp=ptL[x];
						flag=1.1;
					}
					if(nIntType==1)//right
					{
						ptExp=ptR[x];
						flag=-1.1;
					}
					if(nIntType==2)//center
					{
						ptExp=LineSeg(ptL[x],ptR[x]).ptMid();
					}
				}
				
				if(submap.hasPLine(x))
				{
					PlContenido= submap.getPLine(x);//-------->get pline
					PlAux=PlContenido;
					PlaneProfile ppPline(PlAux);//  plane profile creation
					int nShk=ppPline.shrink(dScalePl ); //  pline size modification
					
					PLine plAll[]=ppPline.allRings();
					PlAux1=plAll[0];	 //pline modificated
					
					if(nPlineType==0) //left
					{
						ptExp=ptL[x]+_XW*U(200);
						flag=1.1;
					}
					if(nPlineType==1)// right
					{
						ptExp=ptR[x]-_XW*U(200);
						flag=-1.1;
					}
					if(nPlineType==2) //center
					{
						ptExp=LineSeg(ptL[x],ptR[x]).ptMid();
					}
				}
				
				Point3d ptVert[]=PlAux1.vertexPoints(TRUE);
				Point3d ptMi;
				ptMi.setToAverage(ptVert);//---------------------> pline central point
				
				dAncho = dp.textLengthForStyle( scontenido,sDimStyle ) / 2.0;
				if( x == 0 ){
									
					ptText1 = ptText1 + _XW * arDColW2[x]*.5;				// right side
					ptUno = ptText1 - _XW * arDColW2[x] ;				// left side
					ptUno = ptUno + _XW * dAncho -_XW * dRH * 0.5+ _XW * arDColW2[x] * 0.1;   
					ptText1 .vis(2);
					
					if(!submap.hasPLine(x))	
						dp.draw( scontenido, ptExp, _XW, _YW, flag, 0);
								
					if(submap.hasPLine(x))//---------------<draw poliline 
					{
												
						CoordSys scptUno(ptMi,_XW,_YW,_ZW);
						scptUno.setToAlignCoordSys(ptMi,_XW,_ZW,_YW,ptExp,_XU,_YU,_ZU); 
						
						PlAux1.transformBy(scptUno);
						dp.draw( PlAux1);
					}

				} 
				else {
					
					ptText1 = ptText1 + _XW * arDColW2[x] ;				// right side
					ptT = ptText1 - _XW * dAncho -_XW * arDColW2[x] * 0.1;  
						
					if(!submap.hasPLine(x))	
						dp.draw( scontenido, ptExp, _XW, _YW, flag, 0);

					if(submap.hasPLine(x))
					{
						CoordSys scptT(ptMi,_XW,_YW,_ZW);
						scptT.setToAlignCoordSys(ptMi,_XW,_ZW,_YW,ptExp,_XU,_YU,_ZU);
						
						PlAux1.transformBy(scptT);
						dp.draw( PlAux1);
					}

				}
			}
			ptUno = ptemp;
			ptUno = ptUno + vMoveHor;
			ptemp = ptemp + vMoveHor;		
			//ptText1 = ptemp;
			//ptText1 = ptText1 + vMoveHor;
			//ptemp = ptemp + vMoveHor;			
		}
	}
	// Display
	//dp.draw(scriptName(),_Pt0, _XE, _YE, 0,0,_kDeviceX);
	/*{ // crea un nombre adecuado para el archivo xml
		String strPathxml = _kPathPersonal + "\\area.xml";
		String strName = dwgName();	// solo el nombre
		String strFullName = dwgFullName().left(dwgFullName().find( strName, 0)) ;
		strName = strName.token( 0, "." );
		strFullName += strName;	
		strFullName += ".xml";
		reportMessage( "Exportando a: " + strFullName +  "\n" );
		if( !mapNiveles.writeToXmlFile( strFullName ) ){
			reportError( "No se pudo escribir en " + strFullName + "\n" );
		}
	}*/
} else{
	// ----------------------------------------------------------------------------
	//Draw header and outline of table.
	// ----------------------------------------------------------------------------
	double anchotit = dp.textLengthForStyle( prStrTitulo , sDimStyle ) * 1.5;
	double altotit = dp.textHeightForStyle( prStrTitulo, sDimStyle ) * 2;
	Point3d ptTL = _Pt0;			
	Point3d ptTR = ptTL + _XW * anchotit;					// top left
	Point3d ptBR = ptTR - _YW * altotit ;	// top right
	Point3d ptBL = ptBR - _XW * anchotit;					// bottom right
	PLine plOutline(ptTL, ptTR, ptBR, ptBL); 				// outline
	plOutline.close();
	dp.draw(plOutline);
	Point3d ptTitulo = ptTL + _XW * 0.5 * anchotit;
	ptTitulo = ptTitulo - _YW * 0.5 * altotit;
	dp.draw( prStrTitulo, ptTitulo,_XW, _YW, 0, 0);

}

// ----------------------------------------------------------------------------
// adicion de comandos al menu contextual
// para exportar el resumen de areas
// como la funcion en .net es capas de sacar varias hojas
// es buena idea poner el mapa dentro de otro para generalizar
// ----------------------------------------------------------------------------
{
	String strExportExcel = T("Export to Microsoft Excel");
	addRecalcTrigger(_kContext, strExportExcel);

	if (_bOnRecalc && _kExecuteKey==strExportExcel) {
		Map mapTotal;
		mapTotal.setMap( 0, mp1 );
		reportMessage("\n Export to Microsoft Excel ");
		String strDllPath   = _kPathHsbInstall + "\\Content\\UK\\TSL\\DLLs\\WriteExcelTable\\hsb_WriteExcelTable.dll";
		String strClassName = "hsbSoft.WriteExcelTable.Insertion.MapTransaction";		// please exact matching
		String strFunction  = "CreateExcelExportTable";					// nombre de la funcion
		Map rmap3 = callDotNetFunction2(strDllPath, strClassName, strFunction, mp1);
		reportWarning("\nExporter Finish... WallSchedule.xlsx file available in the project path.\n");
	}
}
// ---------------------------------------------------------------------------
// comando del menu contextual para exportar a una tabla de autocad
// --------------------------------------------------------------------------
/*
{
	String strExportTable = T("Exportar a Tabla de Autocad");
	addRecalcTrigger(_kContext, strExportTable);

	if (_bOnRecalc && _kExecuteKey==strExportTable) {
		if( _Map.hasMap( "cuadro" ) && _Map.hasString("titulo" )){
			//if(mapNiveles.length() != 0 ){
			reportMessage("\n Creando una tabla de autocad ");
			String strDllPath   = "D:\\proy\\dotnet\\ctable\\bin\\Debug\\ctable.dll";
			String strClassName = "ctable.CTable";					// please exact matching
			String strFunction  = "CreaAcadTable";					// nombre de la funcion
			Map rmap3 = callDotNetFunction2(strDllPath, strClassName, strFunction, _Map);
		}
	}
}
*/















#End
#BeginThumbnail



#End
