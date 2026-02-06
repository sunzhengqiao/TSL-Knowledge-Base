# sd_FilterEntities.mcr

## Overview
This script filters the list of entities available in a Multipage Shop Drawing layout. It allows specific views to display only selected element types (such as beams or sheets) or only elements that require machining (tools).

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used for inserting the script instance into the drawing. |
| Paper Space | Yes | Functionality is applied here when generating Shop Drawings. |
| Shop Drawing | Yes | This script is executed by the Shopdrawing engine as part of a Multipage style ruleset. |

## Prerequisites
- **Required Entities**: Beams, Sheets, Wall Elements, Sub-assemblies, SpaceStud Assemblies, or SIPs must exist in the drawing to be filtered.
- **Minimum Beam Count**: 0 (The script processes whatever entities are currently in the layout).
- **Required Settings Files**:
  - `mapIO_GetArcPLine.mcr` must be available in the drawing folder or the hsbCAD search path.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `sd_FilterEntities.mcr`

### Step 2: Select Anchor Beam
```
Command Line: Select GenBeam
Action: Click on a beam in the model to act as the anchor/reference for this script instance.
```

### Step 3: Place Instance
```
Command Line: Select point near tool
Action: Click a location in the drawing to place the script instance.
```

### Step 4: Configure Filter (Properties Palette)
After insertion, select the script instance and open the **Properties Palette** (Ctrl+1). Use the **Entity to Select** dropdown to define what should be visible in the specific Shop Drawing view.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Entity to Select | dropdown | \|Beams\| | Determines which entities are passed to the Shopdrawing engine for processing in the current view. |
| *Available Options* | - | - | **\|Beams\|**: Shows only structural beams. <br> **\|Sheets\|**: Shows only cladding/sheets. <br> **\|Wall Elements\|**: Shows only wall panels. <br> **\|SubAssembly\|**: Shows sub-assemblies. <br> **\|SpaceStud Assembly\|**: Shows SpaceStud assemblies. <br> **\|Sip\|**: Shows Structural Insulated Panels. <br> **\|Only beams with tools\|**: Shows only beams with CNC machining/drilling. <br> **\|Only sheets with tools\|**: Shows only sheets with cuts or machining. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No specific custom context menu items are added by this script. |

## Settings Files
- **Filename**: `mapIO_GetArcPLine.mcr`
- **Location**: Drawing folder or hsbCAD Search Paths
- **Purpose**: Required dependency for the script to function correctly. It handles geometry calculations.

## Tips
- **Clean up Detail Views**: Use the "Only beams with tools" option in a detail view. This automatically hides simple, straight beams (which might clutter the drawing) and highlights only complex members that require dimensions for machining.
- **Separate Structural and Cladding Plans**: Create two different rulesets in your Multipage style. Use one instance of this script set to "\|Beams\|" for the framing plan, and another instance set to "\|Sheets\|" for the sheathing layout.
- **Troubleshooting**: If a view appears empty, check the **Entity to Select** property. You may have selected a filter type (like "\|Sip\|") that does not exist in the current model.

## FAQ
- **Q: I inserted the script, but I don't see any changes in my Model Space.**
  - A: This script is designed primarily for the **Shop Drawing (Paper Space)** generation process. It filters the list of entities when the layout is calculated. In Model Space, it acts as a placeholder for your settings.
- **Q: What is the difference between "\|Beams\|" and "\|Only beams with tools\|"?**
  - A: "\|Beams\|" will show every single beam in the view. "\|Only beams with tools\|" acts as a smart filter, removing beams that are simple rectangles without drill holes or cuts, helping you focus on complex connections.
- **Q: Can I filter for custom assemblies?**
  - A: Yes, provided they are mapped correctly in the system. Use the "\|SubAssembly\|" or "\|SpaceStud Assembly\|" options if your drawing contains those specific entities.