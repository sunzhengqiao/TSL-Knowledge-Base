# HSB_R-OpeningCreator.mcr

## Overview
This script automates the creation of structural openings in roof elements. It calculates and inserts trimming beams (trimmers/headers), splits existing rafters to fit the opening, and cuts voids in sheeting layers.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script runs exclusively in Model Space. |
| Paper Space | No | Not supported for Paper Space usage. |
| Shop Drawing | No | This is a modeling/scripting tool, not a drafting tool. |

## Prerequisites
- **Required Entities**: A valid `ElementRoof` (Roof panel) must exist in the model.
- **Minimum Beam Count**: 0.
- **Required Settings**: `hsbOpeningCreator.dll` (Required for the structural calculation logic).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_R-OpeningCreator.mcr`

### Step 2: Select Roof Element
```
Command Line: |Select an element|
Action: Click on the roof element (ElementRoof) where you want to create the opening.
```

### Step 3: Define Opening Corner 1
```
Command Line: |Select lower lefthand corner|
Action: Click the point on the roof plane that represents the lower-left corner of your future opening.
```

### Step 4: Define Opening Corner 2
```
Command Line: |Select upper righthand corner|
Action: Click the diagonally opposite point (upper-right) to complete the rectangular opening outline.
```

### Step 5: Generate Framing
**Note**: After insertion, only the outline is visible. You must trigger the creation of the physical beams.
```
Action: Select the newly created OpeningRoof entity, then either:
1. Double-click the entity, OR
2. Right-click and select "|Create opening|"
```
*This will generate the trimmers, headers, and split the existing rafters.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Opening roof catalog | dropdown | (Empty) | Selects the construction preset or standard profile to be used for the trimming beams and connection details. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| |Create opening| | Executes the calculation. It removes old framing (if any), restores original zones, calculates new beams via the DLL, inserts them, and splits interfering rafters. |

## Settings Files
- **Filename**: `hsbOpeningCreator.dll`
- **Location**: hsbCAD application directory (or defined DLL path).
- **Purpose**: Performs the structural calculations to determine the size and placement of trimmers and headers based on the selected catalog and opening dimensions.

## Tips
- **Two-Step Process**: Remember that inserting the script only draws the outline. You must double-click or use the right-click menu to actually cut the beams and add the framing.
- **Modifying Openings**: If you change the `Opening roof catalog` property in the Properties Palette, you must re-run the "Create opening" command to update the physical beams to match the new standard.
- **Geometry**: Ensure the two points you click form a valid rectangle on the roof plane. The script projects these points to ensure they lie flat on the roof element.

## FAQ
- **Q: I inserted the script, but I don't see any new beams?**
  **A**: This is expected behavior. The insertion phase only defines the location (outline). Select the entity and Double-click (or Right-click -> Create opening) to generate the structural framing.
- **Q: Can I move the opening after creation?**
  **A**: Yes, you can move or stretch the OpeningRoof entity. After moving it, you must trigger "Create opening" again to update the rafter splits and trimmer positions.
- **Q: What happens to the existing rafters?**
  **A**: The script automatically splits (cuts) any rafters that intersect with the opening boundaries to make room for the new trimmers.