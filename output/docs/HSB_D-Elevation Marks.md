# HSB_D-Elevation Marks.mcr

## Overview
Automatically generates elevation height marks (level indicators) in Paper Space for a selected timber frame element view. It displays floor-to-floor heights and opening sill/head heights, excluding non-structural materials based on configurable filters.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is designed for Paper Space only. |
| Paper Space | Yes | Requires an active layout with a hsbCAD Viewport. |
| Shop Drawing | No | Manual insertion script for layouts. |

## Prerequisites
- **Required Entities**: A Paper Space Layout containing a valid hsbCAD Viewport displaying an Element (Model Space).
- **Element Contents**: The Element must contain structural GenBeams (walls/floors) and optionally Openings.
- **Required Settings**: `HSB_G-FilterGenBeams.mcr` (must be loaded for filter configurations).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_D-Elevation Marks.mcr`

### Step 2: Configuration
Upon insertion, a configuration dialog appears.
- **Action**: Define filter settings (Beam Codes, Materials), positioning offsets, and dimension styles.
- **Note**: You can change these later via the Properties Palette.

### Step 3: Select Viewport
```
Command Line: Select a viewport in PaperSpace
Action: Click on the viewport border that displays the elevation you wish to dimension.
```

### Step 4: Place Script
```
Command Line: Select an insertion point
Action: Click in the Paper Space to place the script reference point (usually near the elevation).
```

## Properties Panel Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| **genBeamFilterDefinition** | String | Selects a pre-defined filter configuration (from `HSB_G-FilterGenBeams`) to exclude specific elements (e.g., sheathing) when determining the structural envelope. |
| **sFilterBC** | String | Exclude beams/sheets with specific Beam Codes from the elevation calculation. |
| **sOpeningOutline** | Index | Determines how opening geometry is calculated: <br>0: Standard opening dimensions (width/height). <br>1: Structural profile of beams/sheets surrounding the opening. |
| **sOpeningMarks** | Index | Controls where opening marks are placed: <br>0: Inside the opening (mixed with floor levels). <br>1: At the side of the element (offset). <br>2: Ignore openings (floor levels only). |
| **Distance to opening side** | Double | The offset distance from the element when `sOpeningMarks` is set to "At element side". |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Filter this element** | Adds the current element to an exclusion list. The script will hide all elevation marks and display a red "Active filter" warning. Useful for temporarily disabling marks on specific views without deleting the script. |

## Settings Files
- **Filename**: `HSB_G-FilterGenBeams.mcr`
- **Purpose**: Provides catalog entries for filtering specific structural elements (e.g., distinguishing between structural timber and cladding/sheathing).

## Tips
- **Troubleshooting Empty Views**: If no marks appear, check your filters. You may have filtered out all structural beams (e.g., if the filter only looks for "Floor" but the element is a "Wall").
- **Moving Marks**: Use the grip point to move the script name/label. The dimension lines update automatically based on the model geometry, but the label position is controlled by the insertion point.
- **Right-Click to Disable**: If you need to suppress marks for a specific viewport quickly, use the "Filter this element" right-click option.

## FAQ
- **Q: Why do my elevation marks not line up with the physical timber?**
  - **A:** Check the `sOpeningOutline` property. If set to "Standard opening dimensions," it uses the opening rough-in size rather than the structural beam size. Switch to "Beams and sheets around opening" for structural accuracy.
- **Q: Can I show floor levels but ignore window heights?**
  - **A:** Yes. Set the `sOpeningMarks` property to "Ignore openings".
- **Q: The script shows "Active filter" in red text.**
  - **A:** You have likely right-clicked and selected "Filter this element" previously. To fix this, access the context menu again to remove the filter or check the internal exclusion map logic (requires developer access) or simply delete and re-insert the script if the filter state is stuck.