# ScandiByg_MEPMasterAssignment.mcr

## Overview
This script automates the assignment of MEP (Mechanical, Electrical, and Plumbing) processing to timber elements. It detects intersections between AutoCAD MEP objects (pipes, ducts, conduits) and hsbCAD structural elements, automatically generating the necessary child scripts to create holes or cut-outs.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required. The script calculates 3D intersections between MEP entities and timber elements. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: 
  - hsbCAD Elements (Walls or Floors).
  - AutoCAD MEP Entities (Conduits, Pipes, Ducts).
- **Minimum Beam Count**: 0 (This script interacts with existing elements).
- **Required Settings/Dependencies**: 
  - The child script `ScandiByg_MEPSingleObject.mcr` must be installed and accessible in the TSL search path.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or select from tool palette) → Select `ScandiByg_MEPMasterAssignment.mcr`.

### Step 2: Configure Processing Mode
```
Dialog: "Add Tolls to Curve Segments"
Action: Select "No" to process straight runs only, or "Yes" to include fittings (elbows, tees, bends). Click OK.
```

### Step 3: Select MEP Objects
```
Command Line: "Select MEP objects"
Action: Select the pipes, ducts, or conduits that pass through the timber structure. Press Enter when finished.
```

### Step 4: Select Timber Elements
```
Command Line: "Select elements"
Action: Select the hsbCAD Walls or Floors that the selected MEP objects intersect with. Press Enter to confirm.
```

### Step 5: Automatic Processing
The script will automatically calculate intersections, attach specific processing scripts to the timber elements, and then erase itself. The result is visible on the timber elements as new script instances.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Add Tolls to Curve Segments | dropdown | No | Determines if MEP fittings (elbows, tees) are included. "Yes" processes fittings; "No" processes only straight segments. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | The script runs once upon insertion and self-erases; there are no persistent right-click options. |

## Settings Files
- **Filename**: `ScandiByg_MEPSingleObject.mcr` (Dependency)
- **Location**: TSL Search Path
- **Purpose**: This is the child script instantiated by the master script. It contains the logic to actually generate the geometry for the holes or cut-outs on the specific element.

## Tips
- **Batch Processing**: You can select multiple MEP objects and multiple timber elements in a single window selection to speed up the workflow.
- **Re-running the Script**: If you run the script again on the same elements, it will automatically detect and erase old instances of the child script before creating new ones, preventing duplicates.
- **Complex Junctions**: If your MEP model contains many elbows and tees, set "Add Tolls to Curve Segments" to **Yes**. This ensures that the volume of the fittings is also calculated for the cut-out.

## FAQ
- **Q: Why did the script disappear immediately after I ran it?**
  - A: This is normal behavior. The "Master" script is designed to assign the specific "Single Object" scripts to your walls and floors and then clean itself up. You do not need the master script to remain in the drawing.
  
- **Q: What happens if I select an object that isn't a pipe or duct?**
  - A: The script filters the selection list. If an object is not a recognized MEP type (e.g., a generic line or text), it will be ignored silently.

- **Q: Can I edit the parameters after insertion?**
  - A: No, because the script instance erases itself immediately after processing. To change settings, simply run the script again.