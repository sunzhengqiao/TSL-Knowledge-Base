# instaCombination.mcr

## Overview
This script inserts and manages complex electrical installation combinations (groups of sockets, switches, and conduits) into timber elements. It handles the automatic generation of cutouts, 3D placement of components, and symbol representation for electrical planning.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for 3D placement and machining |
| Paper Space | No | Not supported |
| Shop Drawing | No | Not supported |

## Prerequisites
- **Required Entities**: An Element (Panel/GenBeam) must exist in the model.
- **Minimum Beam Count**: 0 (Works on single panels or assemblies).
- **Required Settings**:
    - `instaCell TSL` (Sub-script for individual units)
    - `instaConduit TSL` (Sub-script for wiring channels)
    - Conduit Catalog (Profile definitions for pipes/channels)

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Select `instaCombination.mcr` from the file dialog.

### Step 2: Select Configuration
```
Command Line: Select Catalog Entry, Rule, or Default.
Action: A dialog appears. Select the predefined electrical group (e.g., "Switch Group A") or "Default" to start manually.
```

### Step 3: Select Target Element
```
Command Line: Select element:
Action: Click on the timber wall panel or beam where you want to install the electrical combination.
```

### Step 4: Position Combination
```
Command Line: Specify insertion point:
Action: Move your cursor over the element.
- A Green/Cyan symbol indicates a valid position (Face 1 or Face 2).
- A Red/Orange 'X' indicates the cursor is outside the element boundary.
- Click to place the combination.
```
*Note: You can change the Anchor Mode on the command line or properties to snap to specific grid points (`Cells`) or the center of the group (`Combination`).*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **nFace** | Integer | 1 | Determines which side of the panel the installation is applied to (e.g., Interior vs. Exterior). |
| **dElevation** | Double | 0.0 | The vertical height (mm) of the combination relative to the insertion reference. |
| **ConduitCatalog** | String | Empty | The name of the profile catalog used to generate conduits (pipes/channels). If empty, no conduits are created. |
| **bIsCourseElevation** | Boolean | 0 | **Log Wall Only**: If set to 1, vertical positioning snaps to the height of log courses instead of absolute millimeters. |
| **AnchorMode** | Enum | \|Default\| | Controls snapping behavior during insertion. Options: `<|Default|>`, `|Cells|` (Snap to grid), or `|Combination|` (Snap to group center). |
| **ScaleElement** | Double | User Defined | Scales the size of the 2D symbol in Element Views without changing the physical cutout size. |
| **TextHeightElement** | Double | User Defined | Sets the text height for labels in Element Views. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **\|Flip Face\|** | Toggles the installation side (e.g., from Interior to Exterior). Updates the `nFace` property and symbol color. |
| **\|Save as rule\|** | Saves the current configuration (cell types, offsets, catalogs) as a new entry in the Catalog for future use. |
| **\|Plan view settings\|** | Opens a dialog to adjust colors, line types, and scales for the 2D symbol in Plan views. |
| **\|Element view settings\|** | Opens a dialog to adjust visual representation settings for Elevations/Sections. |
| **\|Specify vertical cell offset\|** | Applies a vertical shift to the cells within the combination (useful for aligning vertical stacks). |
| **\|Hide Tools\| / \|Show Tools\|** | Toggles the visibility of CNC toolpaths/machining in the model view. |
| **\|Log Wall Settings\|** | *Only visible for Log Walls*. Opens options specific to log construction, such as course snapping. |

## Settings Files
- **Filename**: `instaConduit` (Catalog Name defined in properties)
- **Location**: `...\hsbCompany\Tsl\Catalogs` (or hsbCAD install path)
- **Purpose**: Defines the geometric profiles (width, height) for the conduits/pipes connecting the electrical units to the edge of the element.

## Tips
- **Snapping**: Use the `|Cells|` Anchor Mode when installing sockets in a regular grid (e.g., standard stud spacing). Use `|Combination|` mode if you want to freely center a group of switches.
- **Visual Feedback**: If you see a Red 'X' while moving the cursor, check if you are clicking on the correct face (Front/Back) of the wall or if you are outside the panel's geometry.
- **Conduits**: To see the pipe routing, ensure the `ConduitCatalog` property matches an existing catalog name in your database.

## FAQ
- **Q: Why can't I place the combination on my wall?**
  A: Ensure your cursor is inside the contour of the element. If the preview shows a Red 'X', you are trying to place it in an empty space or outside the panel bounds.
- **Q: How do I switch the installation to the other side of the wall?**
  A: Select the placed combination, right-click, and choose `|Flip Face|`. The symbol color will change (Green to Cyan or vice versa).
- **Q: Can I save my current setup for another project?**
  A: Yes. Right-click the combination and select `|Save as rule|`. Give it a name, and it will be available in the insertion dialog next time you run the script.