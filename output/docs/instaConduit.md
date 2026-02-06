# instaConduit.mcr

## Overview
This script automates the creation and routing of installation conduits (holes and drills) through timber elements. It connects installation cells or loose points with flexible routing options (straight or polygonal) and manages associated hardware assignments.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Designed for 3D modeling and machining. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: Panels (GenBeams) or timber elements to drill through.
- **Minimum Beam Count**: 0 (Can be used loosely or between specific elements).
- **Required Settings**: TSL set including `instaCombination`, `instaCell`, and `instaConduit`.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `instaConduit.mcr` from the list.

### Step 2: Select Configuration
Upon launching, you may be prompted to select a Strategy or catalog entry. This defines the default diameter and hardware settings for the conduit. Press OK to confirm.

### Step 3: Define Insertion Point
```
Command Line: Select a panel and an insertion point, select properties or catalog entry and press OK
Action: Click on a panel or element in the model where the conduit should start.
```

### Step 4: Define Path
The script will enter "Jig" mode.
- **Straight Connection**: Click the destination point.
- **Free Path**: Click multiple points to create a polyline route. Right-click or press Enter to finish the path.

### Step 5: Finalize
After placing the points, the script generates the visual conduit and calculates the drill holes.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Strategy | String | \<Default\> | Selects a preset configuration that bundles Diameter, Radius, Anchoring, and Hardware settings. |
| Diameter | Number | Strategy Dependent | Sets the physical size of the hole (mm). |
| AnchorMode | Integer | 0 | 0 = Default, 1 = Cells, 2 = Combination. Controls how the conduit snaps to elements. |
| ConnectionType | String | Straight | Switches between 'Straight' (direct line) and 'FreePath' (polygonal with vertices). |
| Radius Contour | Number | 0 | Adds a radius to corners in a FreePath (mm). 0 creates sharp corners. |
| Reference Side | String | Reference Side | Toggles between 'Reference Side' and 'Opposite Side' for alignment. |
| Transparency | Number | 50 | Visual opacity of the conduit solid (0-90%). |
| ShowElementTool | Boolean | True | Toggles the visibility of the generated CNC tools/drills in the model. |
| SplitSegmentGap | Number | 0 | Distance between segments if a long drill is split (mm). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Flip Direction | Reverses the start and end points of the conduit. |
| Flip Face | Flips the conduit to the opposite side of the reference plane. (Can also be triggered by Double Click). |
| Hide Tools / Show Tools | Toggles the visibility of the calculated CNC drill holes. |
| Reset Path | Resets the path to the default straight line (Only available in FreePath mode with >1 cell). |
| Connect to Center | Snaps the conduit connection to the center of the target element/combination. |
| Add Vertex | Adds a new grip point/vertex to the path. |
| Delete Vertex | Removes the selected vertex from the path. |
| Add Strategy | Opens a dialog to create a new named configuration strategy. |
| Edit Strategy | Opens a dialog to modify the selected strategy. |
| Set Strategy Hardware | Opens the hardware catalog to link specific sleeves or boxes to the strategy. |
| Delete Strategy | Removes the currently selected strategy. |
| Import Settings | Loads strategy configurations from an external file. |
| Export Settings | Saves current strategy configurations to an external file. |
| Show all Commands for UI Creation | Displays a list of all script commands in a report dialog. |

## Settings Files
- **Filename**: User-defined (via Export Settings)
- **Location**: User selected path
- **Purpose**: Stores strategy configurations (Diameter, Hardware, Offsets) so they can be shared between projects or users.

## Tips
- **Vertex Editing**: After insertion, select the conduit and drag the **Cyan Grip Points** to adjust the path in 3D space.
- **Rounded Corners**: For a smoother conduit path in "FreePath" mode, increase the **Radius Contour** property to round sharp turns.
- **Strategies**: Create strategies for repetitive tasks (e.g., "20mm Electrical", "50mm Plumbing") to quickly switch hardware and dimensions without entering individual values.
- **Visuals**: If the model becomes too cluttered, set **Transparency** to 80 or use **Hide Tools** to see only the structural timber.

## FAQ
- **Q: How do I change the diameter of the hole after placing it?**
  A: Select the conduit, open the Properties palette (Ctrl+1), and change the **Diameter** value or select a different **Strategy**.
- **Q: The conduit isn't snapping to the center of the beam.**
  A: Right-click and select **Connect to Center**, or change the **AnchorMode** property in the properties panel.
- **Q: Can I hide the solid tube and only see the hole?**
  A: Yes, but this script generates a solid body to represent the conduit. You can lower the **Transparency** to 90 to make it almost invisible, or use standard AutoCAD layer freezing to hide the visual representation while keeping the machining tools visible.