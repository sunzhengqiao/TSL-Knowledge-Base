# HSB_S-EdgeBeams

## Overview
This script automatically generates structural timber beams or sheets along specific edges of wall panels (SIPs or Timber Frame). It is designed to create rim joists, ribbon joists, or ledger boards, with options to join edges, trim for openings, and create panel recesses.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script generates 3D Beam and Sheet entities. |
| Paper Space | No | Not applicable for 3D generation. |
| Shop Drawing | No | Generates model elements only. |

## Prerequisites
- **Required Entities**: Elements (Wall Panels) with valid SipEdge details assigned.
- **Minimum Beam Count**: 0.
- **Required Settings Files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Select `HSB_S-EdgeBeams.mcr` from the catalog browser.

### Step 2: Select Panels
```
Command Line: Select elements:
Action: Click on the wall panels (Elements) you wish to process and press Enter.
```

### Step 3: Configure Properties
Action: With the script instance selected (or immediately after insertion), open the **Properties Palette** (Ctrl+1). Set the `sApplyToSipEdge` to match the edge code on your panels (e.g., "F", "L", "R") and adjust beam dimensions.

### Step 4: Execution
Action: The script will automatically calculate geometry, generate the beams/sheets, apply any machining (Panel Stops), and then **erase itself** from the drawing, leaving only the new beams.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sApplyToSipEdge | String | "" | The edge detail code to process (e.g., "R"). Beams are only created on edges with this code. |
| sJoinEdges | Enum | No | If "Yes", connects collinear edges of adjacent panels to create one continuous beam. |
| sUseOpeningInLengthCalculation | Enum | No | If "Yes", trims the beam length to fit between the nearest window or door opening. |
| sDeleteExistingBeams | Enum | Yes | If "Yes", removes beams previously created by this script for the same edge code before generating new ones. |
| nDetailCodeColor | Integer | 7 | The display color for the edge detail markers. |

### Beam Configuration (Sets 1-4)
The script contains 4 independent configuration sets (1-4) allowing multiple beams per edge.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sBeamType[1-4] | Enum | (List) | The classification of the beam (e.g., Rim Joist, Ledger). |
| dBeamOnPanel[1-4] | Double | 44 mm | The width of the beam (perpendicular to the panel face). |
| dBeamFromPanel[1-4] | Double | 44 mm | The height of the beam (parallel to the panel face). |
| dOffsetFromPanelFace[1-4] | Double | 0 mm | Shifts the beam left/right along the panel plane. |
| dOffsetFromEdge[1-4] | Double | 0 mm | Shifts the beam in or out from the panel surface. |
| dOffsetStartOfEdge[1-4] | Double | 0 mm | Extends (+) or trims (-) the beam at the start of the edge. |
| dOffsetEndOfEdge[1-4] | Double | 0 mm | Extends (+) or trims (-) the beam at the end of the edge. |
| sApplyPanelStop[1-4] | Enum | No | If "Yes", creates a recess (pocket) in the panel to accommodate the beam. |

## Right-Click Menu Options
*Note: This script acts as a "generator" and erases itself after execution. Therefore, there are no persistent script-specific context menu options for the generated elements. You can edit the resulting beams using standard hsbCAD beam editing tools.*

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Continuous Beams**: Enable `sJoinEdges` = "Yes" to ensure your rim beams stretch seamlessly across multiple wall panels without breaks.
- **Automatic Swapping**: If you define a Width (`dBeamOnPanel`) that is larger than the Height (`dBeamFromPanel`), the script will automatically swap them to ensure correct cross-sectional orientation.
- **Recesses for Insulation**: Use `sApplyPanelStop` = "Yes" if you need to rout out the SIP foam/core so the timber beam sits flush against the outer skins.
- **Re-running**: To update the beams, simply re-run the script and select the panels. Ensure `sDeleteExistingBeams` is "Yes" to prevent duplicates.

## FAQ
- **Q: Why did the script disappear after I ran it?**
  A: This is intentional. The script is a "fire and forget" generator. It creates the physical beams and sheets in the model and then removes its logical instance to keep your drawing clean.
- **Q: Can I modify the beams after they are created?**
  A: Yes. The beams are standard hsbCAD entities. You can grip-edit them, stretch them, or modify their properties manually in the Properties Palette.
- **Q: My beams aren't appearing. What is wrong?**
  A: Check the `sApplyToSipEdge` property. It must exactly match the edge code assigned to your wall panels. Also, verify that `dBeamOnPanel` and `dBeamFromPanel` are not set to 0.