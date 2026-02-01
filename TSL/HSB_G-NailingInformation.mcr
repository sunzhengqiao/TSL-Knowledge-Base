#Version 8
#BeginDescription

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



Entity entities[] = Group().collectEntities(true, Element(), _kModelSpace);

int nailToolIndexes[0];
double numberOfNails[0];

for (int i = 0; i < entities.length(); i++) {
	Element el = (Element)entities[i];
	
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
}

reportNotice(TN("|Nails used in drawing|."));
for (int i = 0;i < nailToolIndexes.length(); i++) {
	int nailToolIndex = nailToolIndexes[i];
	double numberOfNailsForThisIndex = numberOfNails[i];
	reportNotice("\n   ----------------");
	reportNotice(TN("|Tool index|: ") + nailToolIndex);
	reportNotice(TN("|Number of nails|: ") + ceil(numberOfNailsForThisIndex));
}

eraseInstance();

#End
#BeginThumbnail

#End
