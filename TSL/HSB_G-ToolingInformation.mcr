#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
10.07.2014  -  version 1.00

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 0
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// Tsl to map properties
/// </summary>

/// <insert>
/// -
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.00" date="10.07.2014"></version>

/// <history>
/// AS - 1.00 - 10.07.2014 - 	Pilot version
/// </hsitory>

int arNNailIndex[0];			String arSNailType[0];
arNNailIndex.append(-1);	arSNailType.append("Unknown");
arNNailIndex.append(10);	arSNailType.append("A-38");
arNNailIndex.append(20);	arSNailType.append("A-47");

PropString sSeparatorContent(2, "", T("|Content|"));
sSeparatorContent.setReadOnly(true);
String arSContent[] = {
	T("|Per element|"),
	T("|Entire project|")
};
PropString sContent(3, arSContent, "     "+T("|Content|"));
sContent.setDescription(T("|Sets the breakdown of the table.|"));

PropString sSeparatorStyle(0, "", T("|Style|"));
sSeparatorStyle.setReadOnly(true);
PropString sDimStyle(1, _DimStyles, "     "+T("|Dimension style|"));
sDimStyle.setDescription(T("|Sets the dimension style.|"));
PropDouble dTextSize(0, -U(1), "     "+T("|Text size|"));
dTextSize.setDescription(T("|Sets the text size.|") +
	TN("|The text size specified in the dimension style is used if the text size is set to zero or less.|"));
PropInt nLineColor(0, 1, "     "+T("|Line color|"));
nLineColor.setDescription(T("|Sets the color of the lines.|"));
PropInt nTextColor(1, 1, "     "+T("|Text color|"));
nTextColor.setDescription(T("|Sets the color of the text.|"));

double dxOffset = U(0);
double dyOffset = U(0);

int bListPerElement = arSContent.find(sContent) == 0;
int bListPerProject = arSContent.find(sContent) == 1;

Entity entities[] = Group().collectEntities(true, Element(), _kModelSpace);

Map mapProjectTools;

for (int i = 0; i < entities.length(); i++) {
	Element el = (Element)entities[i];
	
	int nailToolIndexes[0];
	double numberOfNails[0];
	for (int j = -5; j <= 5; j++) {
		NailLine naillines[] = el.nailLine(j);
		
		for (int k = 0; k<naillines.length(); k++) {
			NailLine nailline = naillines[k];
			
			PLine nailPath = nailline.plPath();
			double pathLength = nailPath.length();
			double nailSpacing = nailline.spacing();
			double numberOfNailsForThisNailline = pathLength/nailSpacing;
			
			int nailToolIndex = nailline.toolIndex();
			
			int listIndex = nailToolIndexes.find(nailToolIndex);
			if (listIndex != -1) {
				numberOfNails[listIndex] += numberOfNailsForThisNailline;
			}
			else {
				nailToolIndexes.append(nailToolIndex);
				numberOfNails.append(numberOfNailsForThisNailline);
			}
		}
	}
	
	Map mapElementTools;
	mapElementTools.setEntity("Element", el);
	for (int j = 0;j < nailToolIndexes.length(); j++) {
		Map mapNails;
		int nailToolIndex = nailToolIndexes[j];
		double numberOfNailsForThisIndex = numberOfNails[j];
		mapNails.setDouble(nailToolIndex, numberOfNailsForThisIndex);
		
		mapElementTools.appendMap("Nails", mapNails);
	}
	
	mapProjectTools.appendMap("ElementTools", mapElementTools);
}

Display dpText(nTextColor);
dpText.dimStyle(sDimStyle);
if (dTextSize > 0)
	dpText.textHeight(dTextSize);
Display dpLine(nLineColor);
	
double dHRow = 2 * dpText.textHeightForStyle("hsbCAD", sDimStyle);
if (dTextSize > 0)
	dHRow = 2 * dTextSize;
double dWColumn = 7 * dHRow;

double dxOffsetProjectName = dHRow/5;
double dxOffsetElementName = dHRow/2;

// Insertion point of table.
Point3d ptTable = _Pt0 + _XU * dxOffset - _YU * dyOffset;

// Line segments to draw the table.
LineSeg lnSegRow(ptTable, ptTable + _XU *  3 * dWColumn);
dpLine.draw(lnSegRow);
LineSeg lnSegColumn(ptTable, ptTable - _YU * dHRow);
dpLine.draw(lnSegColumn);
lnSegColumn.transformBy(_XU *  3 * dWColumn);
dpLine.draw(lnSegColumn);

// Point used to display text.
Point3d ptText = ptTable - _YU * 0.5 * dHRow;
dpText.draw(projectNumber() + " - " + projectName(), ptText + _XU * dxOffsetProjectName, _XU, _YU, 1, 0);

// Update line position
lnSegRow.transformBy(-_YU * 0.95 * dHRow);
dpLine.draw(lnSegRow);
lnSegRow.transformBy(-_YU * 0.05 * dHRow);
dpLine.draw(lnSegRow);

// Move to next row for text.
ptText -= _YU * dHRow;

int arNNailIndexProject[0];
double arDNrOfNailsPerIndexProject[0];
for (int i=0;i<mapProjectTools.length();i++) {
	if (!mapProjectTools.hasMap(i) && mapProjectTools.keyAt(i) != "ElementTools")
		continue;
	
	Map mapElementTools = mapProjectTools.getMap(i);
	Entity ent = mapElementTools.getEntity("Element");
	Element el = (Element)ent;
	
	if (bListPerElement) {
		dpText.draw(el.number(), ptText + _XU * dxOffsetProjectName, _XU, _YU, 1, 0);
		
		lnSegColumn.transformBy(ptText - lnSegColumn.ptMid());
		dpLine.draw(lnSegColumn);
		lnSegColumn.transformBy(_XU *  3 * dWColumn);
		dpLine.draw(lnSegColumn);
		
		// Update line position
		lnSegRow.transformBy(-_YU * dHRow);
		dpLine.draw(lnSegRow);
		
		// Move to next row for text.
		ptText -= _YU * dHRow;
		
		lnSegColumn.transformBy(ptText - lnSegColumn.ptMid());
		dpLine.draw(lnSegColumn);
		lnSegColumn.transformBy(_XU *  3 * dWColumn);
		dpLine.draw(lnSegColumn);
	
		dpText.draw("Nails", ptText + _XU * dxOffsetElementName, _XU, _YU, 1, 0);
		
		// Update line position
		lnSegRow.transformBy(-_YU * dHRow);
		dpLine.draw(lnSegRow);
		
		// Move to next row for text.
		ptText -= _YU * dHRow;
		
		// Update line position for column
		lnSegColumn.transformBy(ptText - lnSegColumn.ptMid());
		dpLine.draw(lnSegColumn);
		lnSegColumn.transformBy(_XU * dWColumn);
		dpLine.draw(lnSegColumn);
		lnSegColumn.transformBy(_XU * dWColumn);
		dpLine.draw(lnSegColumn);
		lnSegColumn.transformBy(_XU * dWColumn);
		dpLine.draw(lnSegColumn);
		
		dpText.draw("Index", ptText + _XU * dxOffsetElementName, _XU, _YU, 1, 0);
		dpText.draw("Type", ptText + _XU * (dxOffsetElementName + dWColumn), _XU, _YU, 1, 0);
		dpText.draw("Amount", ptText + _XU * (dxOffsetElementName + 2 * dWColumn), _XU, _YU, 1, 0);
		
		// Update line position
		lnSegRow.transformBy(-_YU * dHRow);
		dpLine.draw(lnSegRow);
		
		// Move to next row for text.
		ptText -= _YU * dHRow;
		
		// Update line position for column
		lnSegColumn.transformBy(ptText - lnSegRow.ptMid());
	}
	for (int j=0;j<mapElementTools.length();j++) {
		// get the nails
		if (mapElementTools.hasMap(j) && mapElementTools.keyAt(j) == "Nails") {
			Map mapNails = mapElementTools.getMap(j);
			for (int k=0;k<mapNails.length();k++) {
				int nailIndex = mapNails.keyAt(k).atoi();
				double numberOfNails = mapNails.getDouble(k);
				String roundedNumberOfNails;
				roundedNumberOfNails.formatUnit(ceil(numberOfNails), 2, 0);
				String nailType = arSNailType[arNNailIndex.find(nailIndex,0)];
				
				// Add the project
				int nIndexProject = arNNailIndexProject.find(nailIndex);
				if (nIndexProject < 0){
					arNNailIndexProject.append(nailIndex);
					arDNrOfNailsPerIndexProject.append(numberOfNails);
				}
				else{
					arDNrOfNailsPerIndexProject[nIndexProject] += numberOfNails;
				}
				
				// Do we have to draw nails per element?
				if (bListPerElement) {
					// Update line position for column
					lnSegColumn.transformBy(ptText - lnSegColumn.ptMid());
					dpLine.draw(lnSegColumn);
					lnSegColumn.transformBy(_XU * dWColumn);
					dpLine.draw(lnSegColumn);
					lnSegColumn.transformBy(_XU * dWColumn);
					dpLine.draw(lnSegColumn);
					lnSegColumn.transformBy(_XU * dWColumn);
					dpLine.draw(lnSegColumn);
					
					// Move to next row for text.
					dpText.draw(nailIndex, ptText + _XU * dxOffsetElementName, _XU, _YU, 1, 0);
					dpText.draw(nailType, ptText + _XU * (dxOffsetElementName + dWColumn), _XU, _YU, 1, 0);
					dpText.draw(roundedNumberOfNails, ptText + _XU * (dxOffsetElementName + 2 * dWColumn), _XU, _YU, 1, 0);
					
					// Update line position
					lnSegRow.transformBy(-_YU * dHRow);
					dpLine.draw(lnSegRow);
					
					// Move to next row for text.
					ptText -= _YU * dHRow;
				}
			}
		}		
	}
}

// Do we have to draw nails per element?
if (bListPerProject) {
	lnSegColumn.transformBy(ptText - lnSegColumn.ptMid());
	dpLine.draw(lnSegColumn);
	lnSegColumn.transformBy(_XU *  3 * dWColumn);
	dpLine.draw(lnSegColumn);

	dpText.draw("Nails", ptText + _XU * dxOffsetElementName, _XU, _YU, 1, 0);
	
	// Update line position
	lnSegRow.transformBy(-_YU * dHRow);
	dpLine.draw(lnSegRow);
	
	// Move to next row for text.
	ptText -= _YU * dHRow;
	
	// Update line position for column
	lnSegColumn.transformBy(ptText - lnSegColumn.ptMid());
	dpLine.draw(lnSegColumn);
	lnSegColumn.transformBy(_XU * dWColumn);
	dpLine.draw(lnSegColumn);
	lnSegColumn.transformBy(_XU * dWColumn);
	dpLine.draw(lnSegColumn);
	lnSegColumn.transformBy(_XU * dWColumn);
	dpLine.draw(lnSegColumn);
	
	dpText.draw("Index", ptText + _XU * dxOffsetElementName, _XU, _YU, 1, 0);
	dpText.draw("Type", ptText + _XU * (dxOffsetElementName + dWColumn), _XU, _YU, 1, 0);
	dpText.draw("Amount", ptText + _XU * (dxOffsetElementName + 2 * dWColumn), _XU, _YU, 1, 0);
	
	// Update line position
	lnSegRow.transformBy(-_YU * dHRow);
	dpLine.draw(lnSegRow);
	
	// Move to next row for text.
	ptText -= _YU * dHRow;
	
	// Update line position for column
	lnSegColumn.transformBy(ptText - lnSegRow.ptMid());
	
	for (int i=0;i<arNNailIndexProject.length();i++) {
		int nailIndex = arNNailIndexProject[i];
		double numberOfNails = arDNrOfNailsPerIndexProject[i];
		String roundedNumberOfNails;
		roundedNumberOfNails.formatUnit(ceil(numberOfNails), 2, 0);
		String nailType = arSNailType[arNNailIndex.find(nailIndex,0)];
	
		// Update line position for column
		lnSegColumn.transformBy(ptText - lnSegColumn.ptMid());
		dpLine.draw(lnSegColumn);
		lnSegColumn.transformBy(_XU * dWColumn);
		dpLine.draw(lnSegColumn);
		lnSegColumn.transformBy(_XU * dWColumn);
		dpLine.draw(lnSegColumn);
		lnSegColumn.transformBy(_XU * dWColumn);
		dpLine.draw(lnSegColumn);
		
		// Move to next row for text.
		dpText.draw(nailIndex, ptText + _XU * dxOffsetElementName, _XU, _YU, 1, 0);
		dpText.draw(nailType, ptText + _XU * (dxOffsetElementName + dWColumn), _XU, _YU, 1, 0);
		dpText.draw(roundedNumberOfNails, ptText + _XU * (dxOffsetElementName + 2 * dWColumn), _XU, _YU, 1, 0);
		
		// Update line position
		lnSegRow.transformBy(-_YU * dHRow);
		dpLine.draw(lnSegRow);
		
		// Move to next row for text.
		ptText -= _YU * dHRow;
	}
}

#End
#BeginThumbnail
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
B%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110!__V5%`
`

#End