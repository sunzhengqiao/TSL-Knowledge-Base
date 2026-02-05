# HSB_W-Sanitary

## Overview
Automates the creation of wall openings for sanitary installations (e.g., washbasins, toilets). It generates structural trimmers (headers), handles king stud modifications, and applies bottom plate machining for piping, ensuring proper clearances and structural support.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for 3D wall element modification. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: A pre-existing Wall Element in the drawing.
- **Minimum Beam Count**: 2 (The wall must contain existing studs to define the opening location).
- **Required Settings**: None specific to external files.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_W-Sanitary.mcr` from the list.

### Step 2: Select Wall Element
```
Command Line: Select an element
Action: Click on the Wall Element in the 3D model where you want to place the sanitary object.
```

### Step 3: Select First Position
```
Command Line: Select a position between two studs
Action: Click in the model space to place the center of the first sanitary object (e.g., washbasin).
Note: The script automatically projects this point to the wall line and adjusts it if it is too close to a stud center.
```

### Step 4: Select Second Position (Conditional)
```
Command Line: Select a position for second sanitary object
Action: If the "Single/Double" property is set to "Double", click to place the second object.
Note: The script ensures a minimum distance is maintained between the two objects.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| dHSanitary | Double | 1100 mm | Vertical installation height of the sanitary object (measured from finished floor). |
| sDoubleSanitary | Dropdown | Single | Select "Single" for one unit or "Double" for two adjacent units (e.g., double sink). |
| dMinimumDistanceBetweenSanitary | Double | 750 mm | Minimum spacing required between two objects in Double mode. |
| dMinimumDistanceToStudCenter | Double | 110 mm | Minimum allowable distance between the opening edge and the center of adjacent studs. |
| sSide | Dropdown | Front | Determines the wall face (Front or Back) used for orientation and machining. |
| dTrimmerWidth | Double | 0 (Auto) | Vertical height of the trimmer beam (header). If 0, uses the wall's default beam height. |
| dTrimmerHeight | Double | 0 (Auto) | Thickness of the trimmer beam. If 0, uses the wall's default beam width. |
| nColorTrimmer | Integer | 3 | Color index for the generated trimmer beams. |
| sDimStyleWarning | String | _DimStyles | Text style used for warning labels or dimensions. |
| Change width of connecting studs | Boolean | No | If "Yes", resizes the flanking studs to the specified width. |
| dWConnectingStuds | Double | [User Defined] | New width for the flanking studs (if modification is enabled). |
| nColorConnectingStuds | Integer | [User Defined] | Color for the modified flanking studs. |
| Apply milling | Boolean | Yes | If "Yes", creates cut-outs (milling) in the bottom plate for pipes. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Erase | Removes the script instance and all generated geometry (trimmers, cuts). |
| Properties | Opens the Properties Palette to adjust parameters listed above. |

## Settings Files
- **Filename**: None specified.
- **Location**: N/A
- **Purpose**: This script relies on internal standard hsbCAD catalogs for beam creation rather than external settings files.

## Tips
- **Automatic Adjustments**: You do not need to click perfectly in the center of a bay. The script detects nearby studs and snaps the opening to ensure the "Minimum Distance to Stud Center" is respected.
- **Double Units**: When using "Double" mode, if the two openings are very close, the script automatically calculates and inserts an extra middle stud to support the trimmers correctly.
- **Quick Height Adjustment**: Use the `dHSanitary` property in the Properties Palette to adjust the height up or down after insertion without re-running the script.

## FAQ
- **Q: Why did the trimmers generate in a different position than I clicked?**
  **A:** The script enforces a safety margin (`dMinimumDistanceToStudCenter`). If you click too close to an existing stud, it automatically shifts the opening to the nearest valid position to ensure structural integrity.
  
- **Q: Can I use this for a toilet and a bidet next to each other?**
  **A:** Yes. Change `sDoubleSanitary` to "Double" and select the location for the second fixture during insertion. Ensure the `dMinimumDistanceBetweenSanitary` allows for your specific fixtures.

- **Q: The bottom plate isn't being cut for my pipes.**
  **A:** Check the Properties Palette for the "Apply milling" option and ensure it is set to "Yes".