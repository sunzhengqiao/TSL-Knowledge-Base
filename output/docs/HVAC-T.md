# HVAC-T.mcr

## Overview
Automatically generates a T-connection fitting between intersecting HVAC ductwork beams. It cuts the ducts to the correct length and creates the 3D connector solid along with the manufacturing bill of materials entry.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for 3D operations and beam modification. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: HVAC GenBeams (Ducts).
- **Minimum Beam Count**: 2 beams (Split Mode) or 3 beams (Connect Mode).
- **Required Settings**: `HVAC.xml` (Must exist in the TSL Settings path).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HVAC-T.mcr` from the catalog or file dialog.

### Step 2: Select Main Duct
```
Command Line: Select male ductwork
Action: Click on the main duct that runs continuously through the intersection.
```

### Step 3: Select Branch Duct(s)
```
Command Line: Select female ductwork(s)
Action: Click on the branch duct(s) connecting into the main duct.
- You can select a single beam (the script will split it).
- You can select two beams if they are already separate.
```

## Properties Panel Parameters
There are no user-editable properties in the Properties Palette for this script. Configuration is determined automatically based on the dimensions of the selected beams and the HVAC settings file.

## Right-Click Menu Options
There are no custom context menu options for this script instance.

## Settings Files
- **Filename**: `HVAC.xml`
- **Location**: `<company>\\TSL\\Settings`
- **Purpose**: Provides configuration settings, specifically defining the Display Representation name (visual style) used for the generated connector body.

## Tips
- **Split Mode (2 Beams):** If you select only one branch duct, the script automatically splits it into two at the intersection point to create a perfect T-shape.
- **Connect Mode (3 Beams):** If you select two separate branch ducts, ensure they are perfectly collinear (aligned in a straight line) and perpendicular to the main duct. The script will draw "Not possible" if the alignment is invalid.
- **System Assignment:** The script automatically assigns the correct HVAC system to the new or split beams if it is missing.
- **Sizing:** The T-connector size is automatically derived from the dimensions (diameter or width/height) of the selected beams.

## FAQ
- **Q: How is the length of the T-connector determined?**
  **A:** The script calculates the engagement length automatically. It typically defaults to 50mm or uses width-based logic found in the beam submaps.
- **Q: Why did the script draw text saying "Not possible"?**
  **A:** This usually happens in Connect Mode (3 beams) if the two female beams are not perfectly aligned or if they are not perpendicular to the male beam.
- **Q: Can I edit the connector size after insertion?**
  **A:** You cannot edit the connector parameters directly via the Properties Palette. To change the size, modify the dimensions of the connected duct beams and update/reload the script.