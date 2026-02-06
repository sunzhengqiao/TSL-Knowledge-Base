# Rothoblaas Typ X

## Overview
Inserts and configures Rothoblaas Typ X post bases. It automatically generates the 3D steel geometry, drills connection holes or slots into the timber post, and assigns the correct hardware and anchors to the BOM.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for 3D geometry and machining. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: At least one GenBeam (Post/Column).
- **Minimum Beam Count**: 1.
- **Required Settings**: None (uses internal catalogs or property defaults).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Rothoblaas Typ X.mcr` from the catalog.

### Step 2: Configuration
```
Dialog: Properties
Action: Select the Post Base Type (e.g., S1-SBD, S2-STA, R1) and Anchoring method (e.g., Expansion anchor, Screw anchor).
Note: For Epoxy types (R1/R2), adjust the Slot Width if necessary.
```

### Step 3: Select Beams
```
Command Line: Select beams
Action: Click on the timber post(s) you wish to anchor.
```

### Step 4: Select Insertion Point
```
Command Line: Select point / <Enter> for bottom
Action:
- Press Enter: The script defaults to the bottom point of vertical beams (standard installation).
- Click a Point: Select a specific location to define the base height or to install upside-down.
```

### Step 5: Confirmation
The script generates the steel base, drills the timber, and populates the BOM.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sType | Dropdown | S1-SBD | Selects the Rothoblaas configuration type (S1-S4 for pegs, R1-R2 for epoxy). This changes the steel geometry, drill patterns, and fasteners. |
| sAnchoring | Dropdown | Expansion anchor | Defines how the base plate anchors to concrete. Options include Expansion anchor, Screw anchor, and Chemical dowel. Updates the bottom fastener article. |
| dSlotWidth | Number | 10.0 | Defines the width of slots in mm for Epoxy types (R1/R2) to allow adhesive flow. Only applies if R1 or R2 is selected. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Properties | Opens the properties palette to modify Type, Anchoring, or Slot Width. |
| Recalculate | Regenerates the 3D geometry, holes, and BOM if the beam is moved or properties change. |

## Settings Files
- **Catalog**: Internal or Custom Catalog
- **Purpose**: Stores default dimensions and article numbers based on the selected `sType` and `sAnchoring`.

## Tips
- **Sloped Beams**: To anchor a post base on a sloped beam (or upside-down), you must pick a point during insertion rather than pressing Enter.
- **Epoxy Types**: If using R1 or R2, ensure your CNC machine supports the required slot width.
- **Machine Warning**: Be aware that the slots required for Epoxy types (R1/R2) cannot be executed on Hundegger BVN machines automatically.

## FAQ
- **Q: Can I use this script on horizontal beams?**
  A: No, this script is designed for vertical or sloped posts/columns only. Horizontal beams are not supported.

- **Q: What is the difference between S-Type and R-Type?**
  A: S-Types (S1-S4) use self-drilling pegs and require cylindrical drill holes. R-Types (R1-R2) use epoxy resin and require wider slots to allow the glue to flow.

- **Q: How do I change the anchor type after inserting the base?**
  A: Select the script instance, open the Properties palette, and change the `sAnchoring` dropdown. The BOM will update automatically.