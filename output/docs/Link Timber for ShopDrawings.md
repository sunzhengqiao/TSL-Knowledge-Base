# Link Timber for ShopDrawings.mcr

## Overview
This script allows you to link secondary timber elements (like braces or connecting beams) to a primary element so they appear in the primary element's shop drawings. It provides context for fabrication by showing surrounding elements in plan, elevation, and 3D views without generating separate drawings for them.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script is inserted and attached to the primary beam here. |
| Paper Space | No | Not applicable. |
| Shop Drawing | Yes | The linked elements appear and are dimensioned here. |

## Prerequisites
- **Required entities**: One primary GenBeam (the main timber element).
- **Minimum beam count**: 1 (Primary beam). Additional beams are optional during insertion.
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Link Timber for ShopDrawings.mcr`

### Step 2: Select Primary Beam
```
Command Line: Select the primary beam for the shopdrawing
Action: Click on the main timber element you want to generate the shop drawing for.
```

### Step 3: Select Additional Beams
```
Command Line: Select a set of additional beams to be shown in the shopdrawing of the primary
Action: Select the surrounding beams, braces, or elements you want to include as reference. Press Enter when finished.
```

### Step 4: Configure Properties
After selection, the script attaches to the beam. Use the **Properties Palette** (Ctrl+1) to adjust visibility and dimension settings as described below.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Show in Top | dropdown | Yes | Shows the linked beams in the Top view (Plan) of the shop drawing. |
| Show in Bottom | dropdown | Yes | Shows the linked beams in the Bottom view of the shop drawing. |
| Show in Front | dropdown | Yes | Shows the linked beams in the Front elevation view. |
| Show in Back | dropdown | Yes | Shows the linked beams in the Back elevation view. |
| Show in Left | dropdown | Yes | Shows the linked beams in the Left side elevation view. |
| Show in Right | dropdown | Yes | Shows the linked beams in the Right side elevation view. |
| Show in Isometric | dropdown | Yes | Shows the linked beams in the 3D Isometric view. |
| Turn on dimensioning | dropdown | Yes | If set to Yes, dimensions are generated for linked beams in Top, Bottom, Front, and Back views. |
| Turn off | dropdown | Yes | **Master Switch**: If set to "Yes", the script stops generating content in the shop drawing. Set to "No" to activate the link. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script uses standard TSL behavior. Modify settings via the Properties Palette. |

## Settings Files
- **Filename**: None required
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Duplicate Prevention**: If you insert this script on a beam that already has a link instance, the old instance is automatically removed to prevent conflicts.
- **Dimension Limitations**: Dimensions are only created for the Top, Bottom, Front, and Back views. They are ignored in Left, Right, and Isometric views.
- **Master Switch**: If your linked beams disappear, check the "Turn off" property in the palette. It defaults to "Yes" (disabled), so you must change it to "No" to see the links.
- **Self-Selection**: You cannot select the primary beam as an additional beam; the script filters this out automatically.

## FAQ
- **Q: Why don't I see the linked beams in my shop drawing?**
  - A: Check the **Turn off** property in the Properties Palette. It must be set to **No**. Also, verify that the specific view property (e.g., "Show in Front") is set to Yes.
- **Q: Can I dimension the linked beams in the 3D view?**
  - A: No, automatic dimensioning is only supported in 2D views (Top, Bottom, Front, Back).
- **Q: What happens if I delete a linked beam from the model?**
  - A: The script will automatically recalculate and remove the geometry/dimensions of that deleted beam from the shop drawing.