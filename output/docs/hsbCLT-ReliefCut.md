# hsbCLT-ReliefCut.mcr

## Overview
This script automatically creates expansion relief cuts (notches) between adjacent CLT or timber panels where their edges are touching or collinear. It is used to ensure a specified expansion gap exists between panel connections during the detailing process without manual modeling.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D panel geometry. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required entities**: Sip (CLT Panels)
- **Minimum beam count**: 2
- **Required settings files**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or select from hsbCAD Catalog) → Select `hsbCLT-ReliefCut.mcr`

### Step 2: Select Reference Panels
```
Command Line: Select panel(s)
Action: Select the primary set of panels (Male panels). 
        Press Enter to confirm the selection.
```

### Step 3: Select Female Panels (Optional)
```
Command Line: Select female panel(s)
Action: 
   - Option A (Specific Edges): Select the specific mating panels to define exactly which edges get the cut.
   - Option B (All Edges): Press Enter to skip this step. The script will process all internal edges between the panels selected in Step 2.
```

### Step 4: Configure Parameters
```
Action: Use the Properties Palette (Ctrl+1) to set the "Gap Relief" distance. 
        The visual preview will update automatically.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| (A) Gap Relief | Number | 0 | Defines the width of the expansion gap to be cut. If set to 0, the cut is removed and the script instance is deleted. |
| (B) Side | Dropdown | Reference Side | Defines which side of the panel (Top vs Bottom) is used as the reference surface for calculating the cut geometry. Useful for complex roof slopes. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Flip Side | Toggles the Side property between "Reference Side" and "Opposite Side". Can also be triggered by Double-Clicking the element. |
| Reset relief cut | Sets the Gap Relief value to 0, effectively removing the cut and the script instance. |
| Edit in Place | Converts the single multi-relief instance into separate individual TSL instances for each detected edge. This allows you to control the gap size for each joint independently. |

## Settings Files
- **Filename**: None specific
- **Location**: N/A
- **Purpose**: This script relies on user input via the Properties Palette and does not require external XML settings files.

## Tips
- **Script Deletion**: If the "Gap Relief" is set to 0, the script will automatically erase itself from the drawing. You must re-insert the script if you delete it this way.
- **Batch Processing**: To create cuts between all touching panels in a floor area, select all panels in Step 2 and skip Step 3. This is the fastest workflow for standard flooring.
- **Visualizing the Cut**: The script displays text "Edge Relief" and graphics indicating the cut location. If you see no preview, check if your panels are coplanar or if the Gap Relief is 0.

## FAQ
- **Q: Why did the script disappear after I changed a property?**
  **A**: If you set the "Gap Relief" to 0, the script is designed to remove itself. You must set a value greater than 0 to see the cut.
  
- **Q: The script isn't cutting one of my panels. Why?**
  **A**: The script automatically filters out panels that are not coplanar (flat on the same plane) as the reference panel. Ensure your panels are aligned correctly in 3D space.

- **Q: How do I make different gap sizes for different edges?**
  **A**: Insert the script, select your panels, and then right-click and select "Edit in Place". This will break the single tool into multiple tools, one for each edge, which you can then edit individually.