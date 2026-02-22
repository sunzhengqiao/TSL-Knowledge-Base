# hsb_CreateSoleplate

## Overview

This script automates the creation of timber soleplates (base plates) beneath wall elements. It generates multi-level soleplate beams for selected walls, handles wall-to-wall junction geometry (T-junctions, angled connections), splits long soleplates to configurable maximum lengths, and optionally creates associated hardware (nail plates, anchors, holding-down straps), packers, DPC, screws, nails, and a Bill of Materials table.

The script erases itself after execution, leaving behind the generated beams, hardware, and optional BOM table as standalone objects in the model.

## Script Metadata

| Property | Value |
|----------|-------|
| Type | O (Object) |
| Version | 1.31 |
| Beams Required | 0 |
| Keywords | Soleplate |

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Generates 3D beams, metal parts, and optional BOM table. |
| Paper Space | No | Not applicable. |
| Shop Drawing | No | Not applicable. |

## Prerequisites

- One or more wall elements (`ElementWall` / `ElementWallSF`) must exist in the model.
- The following companion scripts must be available in the TSL search path:
  - `hsb_NailPlate` -- Metal part for nail plate connections at soleplate joints.
  - `hsb_Anchor` -- Metal part for soleplate anchors.
  - `hsb_Restraint` -- Metal part for holding-down straps.
  - `hsb_SolePlate Material Table` -- Generates the BOM table.
  - `hsb_SolePlateSplitAtDoors` -- Splits soleplates at door openings.

## Usage Steps

### Step 1: Launch the Script

1. Run the `TSLINSERT` command in AutoCAD.
2. Select `hsb_CreateSoleplate.mcr` from the file browser.
3. A dialog appears on first insertion for catalog-based property configuration.

### Step 2: Place the BOM Table (Optional)

If "Show BOM" is set to Yes, the command line prompts:

```
Select the Location for the Material Table
```

Click a point in the drawing to place the material schedule.

### Step 3: Select Wall Elements

```
Select a set of elements
```

Select one or more wall elements. The script accepts any combination of external, internal, and party walls. Press Enter to confirm the selection.

### Step 4: Automatic Generation

The script immediately generates all soleplate beams, applies junction cuts, splits long members, and creates any enabled hardware and BOM content. The script instance is erased after execution; the generated geometry remains.

## Properties Panel Parameters

### Soleplate Geometry

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Height of soleplate 1 | Double | 38 mm | Height of the first (bottom) soleplate layer. Set to 0 to skip. |
| Height of soleplate 2 | Double | 38 mm | Height of the second soleplate layer. Set to 0 to skip. |
| Height of soleplate 3 | Double | 0 mm | Height of the third soleplate layer. Set to 0 to skip. |
| Height of soleplate 4 | Double | 0 mm | Height of the fourth soleplate layer. Set to 0 to skip. |
| Min Length | Double | 600 mm | Minimum allowable soleplate segment length after splitting. |
| Max Length | Double | 4800 mm | Maximum soleplate segment length; longer members are automatically split. |
| Color | Integer | 1 | AutoCAD color index for the generated soleplate beams. |
| Chamfer soleplate 1 | Yes/No | No | Applies 45-degree chamfer cuts to both edges of the first soleplate layer. |
| Soleplate Location | Selection | Below Wall | "Below Wall" places soleplates beneath the wall origin. "Within Wall" positions them inside the wall height, adjusting the origin upward. |
| Overwrite Bottom Detail | Yes/No | No | When Soleplate Location is "Within Wall", updates the wall bottom construction detail code to reflect the number of soleplate levels. |

### Wall Classification

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Code External Walls | String | A;B; | Semicolon-separated wall type codes identifying external walls. Soleplates on matching walls are labeled "Ext". |
| Code Party Walls | String | F;G; | Semicolon-separated wall type codes identifying party walls. Soleplates on matching walls are labeled "Int Party". |
| T Junction Soleplate Overlap | Yes/No | No | Controls whether internal wall soleplates overlap with external wall soleplates at T-junctions. |

### Beam Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Name | String | SolePlate | Name assigned to all generated soleplate beams. |
| Material | String | (empty) | Material property for the beams. |
| Grade | String | (empty) | Timber grade assignment. |
| Information | String | (empty) | Additional information field. The wall number is automatically appended. |
| Sublabel | String | (empty) | Sublabel for beam identification. The top-level soleplate may be overridden to "Precut" if the precut group option is enabled. |
| Sublabel 2 | String | (empty) | Secondary sublabel. |

### Locating Plate

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Create Locating Plate | Yes/No | No | Replaces the first soleplate layer with a narrower locating plate. |
| Width Locating Plate | Double | 90 mm | Width of the locating plate (narrower than the full wall width). |
| Locator Position | Selection | Inside face | Positions the locating plate on the inside or outside face of the wall. |
| Offset | Double | 0 mm | Lateral offset for the locating plate from the wall face. |
| Wall types filter for Locating Plate | String | (empty) | Semicolon-separated wall codes. If empty, all walls receive locating plates. If populated, only matching wall types get locating plates. |
| Split soleplate at doors | Yes/No | No | Splits soleplate beams at door openings using the companion script `hsb_SolePlateSplitAtDoors`. |

### Grouping

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| House Level group name | String | 00_GF-Soleplates | Top-level group name in the deliverable container hierarchy. |
| Floor Level group name | String | GF-Soleplates | Floor-level group name. Soleplate beams are organized into sub-groups by level (e.g., "GF-Soleplates_Level 1"). |
| Create Precut Group | Yes/No | No | Marks the topmost soleplate level as "Precut" and appends "_Precut" to its group name. |

### Nail Plates

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Insert Nail Plates | Yes/No | No | Inserts nail plate metal parts at soleplate joints and split points on the precut level. |
| Nail Plate Model | Selection | NP-80-100 | Select from predefined models (NP-80-100 through NP-150-300) or choose "Other Model Type". |
| Other Nail Plate Type | String | **Other Type** | Custom nail plate model name when "Other Model Type" is selected. |
| Show the Metal Parts in Disp Rep | String | (empty) | Display representation filter for metal parts. |

### Holding Down Straps (Restraints)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Insert Holding Down Straps | Selection | No | "No" disables restraints. "External" applies only to external walls. "All" applies to all walls. |
| Holding Down Straps | Selection | ST-PFS-50 | Predefined restraint models or "Other Model Type". |
| Other Restraint Type | String | **Other Type** | Custom restraint model name. |
| Distance Between Straps | Double | 1000 mm | Spacing between holding-down straps along the wall length. |

### Anchors

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Insert Soleplate Anchors | Yes/No | No | Inserts anchor metal parts along the bottom soleplate. |
| Anchor Model | Selection | SP90 | Predefined models (SP90, SP240, SPU90, SPU96, SPU240, SPA38, SPA50) or "Other Model Type". |
| Other Anchor Type | String | **Other Type** | Custom anchor model name. |
| Distance Between Anchors | Double | 1000 mm | Spacing between anchors. Total quantity also includes one per door opening. |

### Packers

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Insert Packers | Yes/No | No | Includes plastic soleplate packers in the BOM. |
| Number of Packers | Integer | 4 | Number of packers per spacing interval. |
| Distance Between Packers | Double | 900 mm | Spacing between packer groups along the wall. |

### DPC (Damp Proof Course)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Insert DPC | Yes/No | No | Includes DPC rolls in the BOM, sized by wall width (225 mm for 140 mm walls, 150 mm for 89 mm walls, 100 mm for internal walls). |

### Screws

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Insert Screws | Yes/No | No | Includes concrete screws in the BOM. |
| Screw Material Description | Selection | (list) | Select from predefined Tapcon/Hit models or "Other Model Type". |
| Other Screws Type | String | **Other Type** | Custom screw description. |
| Distance Between Screws | Double | 900 mm | Spacing between screws. |
| Screws per Box | Integer | 50 | Box size for quantity rounding in BOM. |

### Nails

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Insert Nails | Yes/No | No | Includes nails in the BOM for connecting soleplate layers. |
| Nails Type Description | Selection | (list) | Select from predefined Paslode nail types or "Other Model Type". |
| Other Nail Type | String | **Other Type** | Custom nail description. |
| Distance Between Nails | Double | 600 mm | Nail spacing along the soleplate. |
| Nails per Box | Integer | 2200 | Box size for quantity rounding. |

### BOM and Table

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Show BOM | Yes/No | No | Generates a material schedule table at the point selected during insertion. |
| Dimstyle | Selection | (drawing styles) | Dimension style used for the BOM table. |
| Color Header and Lines | Integer | 171 | Color for the table header and grid lines. |
| Row Color | Integer | 143 | Color for table row text. |
| Extra Percent for Materials | Double | 10 | Waste percentage added to DPC, packer, screw, and nail quantities. |

## Child Scripts

| Script Name | Purpose |
|-------------|---------|
| hsb_NailPlate | Creates nail plate metal parts at soleplate joints. |
| hsb_Anchor | Creates anchor metal parts along the bottom soleplate. |
| hsb_Restraint | Creates holding-down strap metal parts. |
| hsb_SolePlate Material Table | Generates the material schedule/BOM table. |
| hsb_SolePlateSplitAtDoors | Splits soleplate beams at door openings in the wall. |

## Automatic Behaviors

- **Width Detection**: The soleplate width is automatically derived from the wall beam width. For SIP walls, it uses the panel thickness. If neither is available, it defaults to 89 mm (walls up to 105 mm thick) or 140 mm (thicker walls).
- **Junction Handling**: At T-junctions, soleplates are automatically cut and split. Odd-numbered levels (1, 3) and even-numbered levels (2, 4) receive different cut positions, creating an interlocking overlap pattern.
- **Angled Connections**: At non-perpendicular wall junctions, the script calculates the bisector angle and applies angled cuts to the soleplate ends.
- **Beam Joining**: Adjacent soleplate segments on the same level with matching dimensions are automatically joined into a single beam.
- **Length Splitting**: Soleplates exceeding the maximum length are split into segments, respecting the minimum length constraint to avoid short offcuts.
- **Labeling**: Each soleplate beam is automatically labeled "Ext", "Int Party", or "Int" based on the wall code classification.

## Tips

- Enter wall codes exactly as they appear in the element properties, separated by semicolons (e.g., "A;B;"). Mismatched codes will cause walls to be classified as internal by default.
- Start with basic settings (no hardware, no BOM) to verify soleplate geometry, then enable hardware and BOM features incrementally.
- The script supports up to four stacked soleplate layers. Set unused layer heights to 0 to disable them.
- When using the "Within Wall" location, ensure your wall bottom construction details accommodate the soleplate height, or enable "Overwrite Bottom Detail" to update them automatically.
- The locating plate filter accepts semicolon-separated wall codes. Leave it empty to apply locating plates to all wall types.

## FAQ

**Q: No soleplates appear after running the script.**
A: Verify that the selected objects are valid wall elements (`ElementWall`). The script silently skips non-wall entities. Also confirm that at least one soleplate height is greater than zero.

**Q: Soleplates are the wrong width.**
A: The width is derived from the wall beam width, not from a user property. If the wall has no beam width set, the script falls back to 89 mm or 140 mm based on wall thickness. Adjust the wall element properties to control soleplate width.

**Q: Anchors or restraints are not appearing.**
A: Ensure the companion scripts (`hsb_Anchor`, `hsb_Restraint`) exist in the TSL search path. Also verify that the spacing values are greater than zero and the relevant toggle is set to "Yes" or "External"/"All".

**Q: The BOM table quantities seem incorrect.**
A: BOM quantities for DPC, packers, screws, and nails include the "Extra Percent for Materials" waste factor. Soleplate timber is reported in linear meters rounded up. Check the extra percentage setting if quantities appear inflated.
