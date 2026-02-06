# hsbPropellerTool.mcr

## Overview
This script creates a complex "propeller" surface machining (3D sweep/mill) on a timber beam. It uses projected polylines to define the start and end geometry of the cut, allowing for variable depth grooves or angled housings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be used in the 3D model. |
| Paper Space | No | Not supported for 2D layouts. |
| Shop Drawing | No | Not applicable for shop drawing details. |

## Prerequisites
- **Required Entities**: One GenBeam and at least one EntPLine (Polyline).
- **Minimum Beam Count**: 1
- **Required Settings**: `hsbCLT-FreeProfile.xml` (Must be present in Company or Install settings path).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbPropellerTool.mcr`

### Step 2: Select Tool
```
Command Line: [Dialog appears]
Action: A dialog displays a list of available CNC tools. Select the desired tool (e.g., "Ø 10/50") from the dropdown list.
```

### Step 3: Select Beam
```
Command Line: Select beam
Action: Click on the beam (GenBeam) where you want to apply the propeller machining.
```

### Step 4: Select Polylines
```
Command Line: Select 1 (defining polyline) or 2 polylines (defining + bevel polyline).
Action: Click the polyline(s) that define the shape of the cut.
- Option A: Select 1 polyline. The script will project this to the beam surface and try to find a perpendicular face for the bevel.
- Option B: Select 2 polylines. The script identifies the larger area as the defining profile and the smaller as the bevel profile.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Tool | dropdown | First item from XML list | Selects the CNC cutter from the catalog. The description updates dynamically to show Diameter and Length (e.g., "Defines the CNC Tool, Ø 10/50"). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Mirror to opposite side | Projects the tool definition to the opposite side of the beam and recreates the tool. |

## Settings Files
- **Filename**: `hsbCLT-FreeProfile.xml`
- **Location**: 
  - `_kPathHsbCompany\TSL\Settings`
  - `_kPathHsbInstall\Content\General\TSL\Settings`
- **Purpose**: Provides the list of available CNC tools, including their Name, Diameter, Length, and CNC Mode index.

## Tips
- **Polyline Direction**: The script automatically aligns the direction of two selected polylines. You do not need to manually ensure they point the same way.
- **Closed Polylines**: This tool does not support closed polylines. Ensure your defining lines are open segments.
- **Volume Check**: Upon insertion, the script automatically calculates which side of the beam removes more material to ensure the cut is applied to the correct face.
- **Double-Click**: Double-clicking the tool in the model triggers the "Mirror to opposite side" function.
- **Updates**: If you modify the original polylines used to create the tool, the tool will automatically update to reflect the new geometry.

## FAQ
- **Q: What happens if I select a closed polyline?**
  - A: The script will report a message saying closed polylines are not supported and will ignore that selection.
- **Q: How do I change the cutter size after insertion?**
  - A: Select the tool, open the Properties (OPM) palette, and choose a different tool from the "Tool" dropdown list.
- **Q: The tool disappeared after I moved my beam. Why?**
  - A: If the beam reference is lost or the linking polylines are deleted/invalid, the script will self-delete to prevent errors. Re-insert the tool and select the valid entities.
- **Q: Can I use this for a straight groove?**
  - A: Yes, but standard linear milling tools may be more efficient. This tool is best for transitions where the start and end profiles differ.