# HSB_W-IntegrateHeader.mcr

## Overview
This script automates the framing process by cutting notches in vertical wall studs to accommodate header beams located above openings (such as windows or doors).

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D model elements (Beams, Openings). |
| Paper Space | No | Not designed for 2D drawing views. |
| Shop Drawing | No | Does not generate views or dimensions. |

## Prerequisites
- **Required Entities**: Wall Elements (`Element`) containing Openings (`OpeningSF`) and Beams (`GenBeam`).
- **Minimum Beam Count**: The wall must contain both a header beam and vertical studs.
- **Preparation**: The header beam must have a specific "Beam Code" assigned to it in the element properties before running this script.

## Usage Steps

### Step 1: Launch Script
Command: Type `TSLINSERT` in the command line and select `HSB_W-IntegrateHeader.mcr`.

### Step 2: Configure Properties
```
Interface: Dynamic Properties Dialog
Action: Locate the "Beamcode Header" field. Enter the exact string used as the Beam Code property for your header beams (e.g., "H", "HDR", or "HEAD"). Click OK to proceed.
```

### Step 3: Select Openings
```
Command Line: Select one or more openings
Action: Click on the OpeningSF entities (window/door symbols) in the drawing that require header integration. Press Enter to confirm selection.
```
*Note: The script will automatically process the parent wall elements associated with the selected openings.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Beamcode Header | Text | (Empty) | The "Beam Code" property value that identifies which beam within the wall is the header beam. Only beams matching this code will be used to cut the studs. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script executes once and erases itself. There are no editable context menu options after insertion. |

## Settings Files
- **Filename**: None used.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Verify Beam Codes**: Before running the script, select a header beam in your model and check its Properties Palette to ensure the "Beam Code" matches what you plan to type into the script dialog.
- **Batch Processing**: You can select multiple openings at once during the selection prompt to process several headers in a single operation.
- **Static Tooling**: The cuts created by this script are static tooling. If you move the header or opening later, the cuts will not automatically update. You must undo and re-run the script if the geometry changes.

## FAQ
- **Q: I ran the script, but no notches appeared on the studs. Why?**
- **A:** This usually happens if the "Beamcode Header" parameter does not exactly match the "Beam Code" property of the header beam in the wall. Check for typos or extra spaces in the code.
- **Q: Can I edit the notch size after running the script?**
- **A:** No. The script creates a permanent cut on the beam geometry. To change the integration, you must use the Undo command to revert the script execution, modify your setup, and run it again.
- **Q: Does this script work on curved walls?**
- **A:** The script calculates geometric intersections. While designed for standard framing, it will attempt to cut any stud intersecting the header volume, provided the beams are standard GenBeams.