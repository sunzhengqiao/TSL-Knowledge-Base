# HSB_E-SquareBeamCut

## Overview
This script identifies specific beams within a selected element (based on their BeamCode) and automatically applies a square-cutting operation to their ends using a sub-script.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in the 3D model where elements and beams exist. |
| Paper Space | No | Not applicable for 2D drawings. |
| Shop Drawing | No | Not applicable for shop drawings. |

## Prerequisites
- **Required Entities**: An Element containing GenBeams.
- **Minimum Beam Count**: 1 (The element must contain at least one beam).
- **Required Settings/Scripts**: The script `HSB_T-SquareBeamCut` must be loaded in the drawing.

## Usage Steps

### Step 1: Launch Script
```
Command Line: TSLINSERT
Action: Select HSB_E-SquareBeamCut.mcr from the list and press Enter.
```

### Step 2: Configure Beam Codes
```
Dialog: Properties Palette
Action: In the "General" category, locate the "BeamCode(s)" field. 
Enter the beam code(s) you wish to process. If entering multiple codes, separate them with a semicolon (e.g., FREES;RAFTER).
```

### Step 3: Select Elements
```
Command Line: Select element(s)
Action: Click on the element(s) (wall or floor) in the model that contain the beams you want to cut. Press Enter to confirm selection.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| BeamCode(s) | Text | FREES | Specify the beam codes to target for the square cut. Use a semicolon (;) to separate multiple codes. |

## Right-Click Menu Options
None. The script is transient and does not remain on the element for right-click context menu modification.

## Settings Files
None specified for this script.

## Tips
- **Multiple Codes**: You can target different types of beams at once by separating their codes with a semicolon (e.g., `FREES;STUD`).
- **Script Dependency**: Ensure the tool script `HSB_T-SquareBeamCut` is loaded in your drawing, or the script will fail to process the beams.
- **Re-running**: This script erases itself after running (Transient behavior). If you need to change the beam codes or re-run the operation, simply insert the script again on the desired elements.

## FAQ
- **Q: The script disappeared after I ran it. Is this normal?**
  - A: Yes. This is a "transient" script designed to perform a one-time action and then delete itself.
  
- **Q: I got a warning "Beams could not be processed!"**
  - A: This usually means the required sub-script (`HSB_T-SquareBeamCut`) is not loaded in your drawing. Please load this file and try again.

- **Q: Nothing happened to my beams.**
  - A: Check the "BeamCode(s)" property. The beams in your selected element must match the codes exactly (excluding the semicolon). If the codes do not match, the script will ignore them.