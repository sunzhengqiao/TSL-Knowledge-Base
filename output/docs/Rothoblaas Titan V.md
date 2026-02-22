# Rothoblaas Titan V

## Overview

The Rothoblaas Titan V script places a **TITAN V (TTV240) angle bracket** at the junction of two perpendicular timber panels (Sip entities such as CLT or SIP panels). The TITAN V is a structural shear connector manufactured by Rothoblaas, designed for panel-to-panel connections in cross-laminated timber and timber frame construction.

The script manages the complete insertion workflow: it prompts you to select two panels, automatically determines which panel is the "female" (base plate side) and which is the "male" (vertical plate side) based on geometry, validates that the bracket fits within both panel faces while respecting a configurable edge offset, and then places a 3D metal part with the correct fastener pattern. Fastener quantities (Anker nails and VGS screws) are automatically registered in the Bill of Materials (BOM) based on the selected structural variant.

**Key features:**
- Automatic male/female panel role detection based on geometric analysis
- Pre-insertion feasibility check with color-coded visual feedback (green = OK, red = problem)
- Four structural variants (F1 / F2-3, each with Full or Partial nailing) controlling fastener sets
- Four display modes ranging from no annotation to fully drilled 3D geometry for CNC export
- BOM registration for the bracket (TTV240), Anker nails (LBA 460, 4x60 mm), and VGS screws (11x150 mm or 11x200 mm)

## Usage Environment

- **Script type:** O-Type (Object) -- attaches to Sip panel entities and recalculates automatically if panels move or change
- **Works in:** Model Space only
- **Beams required:** 0 (operates on Sip panel entities, not GenBeam members)
- **Panels required:** Exactly 2 Sip entities, arranged perpendicularly
- **Implicit insert:** Yes (the script handles its own insertion workflow)
- **Settings file:** None (no external XML catalog required; all parameters are embedded)

## Prerequisites

Before running this script, ensure the following conditions are met:

- Two Sip (Structural Insulated Panel or CLT panel) entities exist in the drawing and meet at a corner or perpendicular joint.
- The two panels must be **exactly perpendicular** to each other (their Z-axes must be perpendicular). The script rejects non-perpendicular arrangements with an error message.
- The bracket footprint (240 mm long, 83 mm base plate height, 120 mm vertical plate height, 4 mm plate thickness) must fit entirely within both panel face areas at the chosen insertion point.
- The insertion point must maintain the configured **Offset** distance (default 50 mm) from all panel edges along the joint direction.
- The two panels must not geometrically overlap at the connection zone (the script detects clashing materials and aborts).

## Bracket Physical Dimensions

| Dimension | Value |
|---|---|
| Length (along joint) | 240 mm |
| Base plate height (female side) | 83 mm |
| Vertical plate height (male side) | 120 mm |
| Plate thickness | 4 mm |

## How to Use

### Step 1 -- Launch the Script

Run the TSL insert command and select **Rothoblaas Titan V** from the script catalog or list. The script's property dialog will appear, allowing you to configure the connector type, offset, and display settings before placement.

If a catalog Execute Key is passed (for example, by a batch script or parent tool), the script silently loads the matching catalog entry and skips the dialog. If no matching key is found, it falls back to the last inserted settings.

### Step 2 -- Configure Properties in the Dialog

When the dialog opens, set:

- **Type** -- Choose the structural variant. This controls how many nails and screws are placed and registered in the BOM. See the Fastener Sets table below.
- **Offset** -- Set the minimum edge distance (in mm) from the bracket edges to the panel edges along the joint direction.
- **Display** -- Choose how fasteners are visualized (see Display Modes section).
- **Dimstyle** -- Select the dimension text style for text annotations (only relevant when Display is set to Text).
- **Scale** -- Adjust the height of text annotations and graphical symbols relative to the bracket dimensions.

Click **OK** to proceed to panel selection.

### Step 3 -- Select the Two Panels

The command line will prompt:

```
Select 2 panels for insertion at specified point
```

Click on the first panel, then the second panel. Both must be Sip entities. The selection order does not matter -- the script automatically determines which panel is the female (base) and which is the male (vertical) based on their geometric relationship.

If fewer than 2 panels are selected or the selection is cancelled, the script aborts. If more than 2 are selected, the script also aborts with an error.

### Step 4 -- Click the Insertion Point

After panel selection, you are prompted to click a point on or near the panel joint. This point defines where along the joint the bracket center will be placed. The script automatically projects the point onto the correct panel faces so the bracket sits flush against both panels.

### Step 5 -- Automatic Validation and Placement

The script performs several checks:

1. **Perpendicularity check** -- Verifies the two panels are perpendicular. If not, the script aborts with an error message.
2. **Clashing materials check** -- Verifies the panels do not overlap at the connection zone.
3. **Panel face contact check** -- Verifies that the full base plate rectangle (240 x 83 mm) lies within the female panel face, and the full vertical plate rectangle (240 x 120 mm) lies within the male panel face.
4. **Edge offset check** -- Verifies that the bracket plus the configured Offset distance fits within both panel faces.

If all checks pass, the metal part is created and hardware components are registered.

If validation fails, the script draws diagnostic geometry instead of the bracket:
- **Green regions** (color 3) show the portion of the bracket area that is properly supported by the panel face.
- **Red regions** (color 1) show the area where the bracket extends beyond the panel face or violates the offset requirement.
- **Yellow crosshair markers** (color 2) indicate the required minimum edge positions (the bracket edge plus the Offset distance).

## Properties Panel (OPM Parameters)

These parameters appear in the AutoCAD Properties Palette when the placed bracket instance is selected. Changing any value causes the script to recalculate and update the 3D representation and BOM automatically.

### General

| Property | Type | Default | Description |
|---|---|---|---|
| Type | Dropdown (String) | F1-Full nailing | Structural variant of the TITAN V bracket. Controls the number of VGS screws and Anker nails placed and registered in the BOM. Options: **F1-Full nailing**, **F1-Partial nailing**, **F2/3-Full nailing**, **F2/3-Partial nailing**. See the Fastener Sets table for exact quantities. |
| Offset | Number (mm) | 50 mm | Minimum required distance from any panel edge to the outer edge of the bracket along the joint direction. If the bracket at the chosen insertion point violates this offset, placement is blocked and error geometry is shown. |

### Display

| Property | Type | Default | Description |
|---|---|---|---|
| Display | Dropdown (String) | Text | Controls how fasteners are visualized on the bracket plates. See the Display Modes section below for details. |
| Dimstyle | Dropdown (String) | (current drawing default) | Dimension style used for text labels when Display is set to **Text**. Lists all dimension styles available in the current drawing, sorted alphabetically. |
| Scale | Number | 1.0 | Scales the height of text annotations and graphical symbols. Does not affect the physical size of the metal part. Use values greater than 1 to enlarge annotations in small-scale views. |

## Display Modes

| Mode | Behavior |
|---|---|
| **No nail info** | The bracket plates are drawn as plain 3D metal parts with manufacturer labeling only. No fastener annotation. |
| **Text** | Fastener quantities are shown as text labels on each plate face. The female plate shows the nail count and screw count (e.g., "30x Anker nails 4x60" and "5x VGS screws 11x200"). The male plate shows its nail count. Text height is controlled by the Scale property and uses the selected Dimstyle. |
| **Graphical** | Each fastener hole position is drawn as a 2D circle with a crosshair marker on the plate surface. **Active holes** (used in the selected variant) are drawn in **green** (color 3). **Unused holes** are drawn in **red** (color 1). This provides a clear visual distinction between full and partial nailing patterns, and between F1 (5 screws) and F2/3 (2 screws) variants. |
| **Realistic** | Actual 3D drill holes are cut through the metal plate geometry at each fastener position. This mode is required for CNC fabrication export. Screw holes have a radius of 6 mm; nail holes have a radius of 2.5 mm. This mode is slower to compute due to Boolean subtraction operations. |

All display modes include a manufacturer label ("rothoblass" and "TITAN TTV240") on the vertical plate face, drawn in color 252 (light gray).

## Fastener Sets by Type

| Type | Male Plate Nails | Female Plate Nails | Female Plate VGS Screws | Screw Size |
|---|---|---|---|---|
| F1 - Full nailing | 36 x Anker nails 4x60 | 30 x Anker nails 4x60 | 5 x VGS screws | 11x200 |
| F1 - Partial nailing | 24 x Anker nails 4x60 | 24 x Anker nails 4x60 | 5 x VGS screws | 11x150 |
| F2/3 - Full nailing | 36 x Anker nails 4x60 | 30 x Anker nails 4x60 | 2 x VGS screws | 11x200 |
| F2/3 - Partial nailing | 24 x Anker nails 4x60 | 24 x Anker nails 4x60 | 2 x VGS screws | 11x150 |

**Notes:**
- F1 and F2/3 differ in the number of VGS structural screws (5 vs. 2). Consult Rothoblaas technical documentation for load capacity differences between the variants.
- Full and Partial nailing differ in the total nail count and screw length. Full nailing uses the maximum hole pattern; Partial nailing omits certain rows.

### Fastener Layout Details

**Female plate (base plate, 240 x 83 mm):**
- **Screw holes:** 5 positions along the joint direction, spaced at 50 mm intervals, centered on the plate. Located 13 mm from the panel junction edge. Hole radius: 6 mm. For F2/3 variants, only the 2 outermost screw positions are active (the inner 3 are shown in red in Graphical mode).
- **Nail holes:** 5 rows of 6 holes each, spaced at 40 mm along the joint and 10 mm between rows, starting 33 mm from the junction edge. Alternating rows are offset by 10 mm for a staggered pattern. Hole radius: 2.5 mm. For Partial nailing, the last (outermost) row is inactive.

**Male plate (vertical plate, 240 x 120 mm):**
- **Nail holes:** 6 rows of 6 holes each, same spacing as the female plate (40 mm along joint, 10 mm between rows), starting 60 mm from the junction edge. Alternating rows offset by 10 mm. Hole radius: 2.5 mm. For Partial nailing, the last 2 rows (rows 5 and 6) are inactive.

## Male/Female Panel Detection

The script automatically determines panel roles based on geometry. You do not need to select panels in any particular order. The detection logic works as follows:

1. The script projects the center of each panel onto the other panel's mid-plane.
2. If the projected point falls inside one panel's profile but not the other, the panel containing the point is the **female** (base) panel, and the other is the **male** (vertical) panel.
3. If the point falls inside both profiles, the script reports a **clashing materials** error and aborts.
4. If the point falls inside neither profile (a gap between panels), the script uses a fallback heuristic: the more vertical panel (whose Z-axis is more horizontal, i.e., perpendicular to world Z) is assigned as the **male** panel.

## BOM Registration

Every placed instance automatically registers three hardware components linked to the element group of the first selected panel:

| Article Number | Manufacturer | Description | Quantity |
|---|---|---|---|
| TTV240 | Rothoblaas | TITAN V angle bracket, 240 mm | 1 per instance |
| LBA 460 | Rothoblaas | Anker nails 4x60 (zinc-coated steel, "Kammnagel") | Total nail count from both plates, per Type setting |
| VGS screws (11x150 or 11x200) | -- | Structural VGS screws for base plate | Per Type setting (2 or 5) |

The bracket dimensions (length, base height, vertical height) are stored in the hardware component's scale fields for downstream processing. The hardware group name is taken from the parent element of the first panel, allowing BOM export tools to correctly attribute hardware to the appropriate wall or floor element.

## Right-Click Menu Options

This script does not define custom right-click context menu entries. Standard hsbCAD right-click options for TSL instances apply (Edit Properties, Recalculate, Delete, etc.).

## Error Messages

| Message | Cause | Resolution |
|---|---|---|
| `2 panels are needed` | Fewer than 2 or more than 2 Sip entities were selected. | Select exactly 2 Sip panels and reinsert. |
| `Invalid reference` | The Sip entities linked to the instance are no longer valid (e.g., panels were deleted or became corrupted). | Delete the bracket instance and reinsert after verifying both panels exist. |
| `Panels are not perpendicular` | The two selected panels do not meet at a 90-degree angle (their Z-axes are not perpendicular). | Correct the panel geometry so they are exactly perpendicular before inserting the bracket. |
| `Possible clashing materials` | The geometric analysis detected that both panels overlap in the connection zone (both panel profiles contain the axis intersection point). | Check panel geometry for overlapping solids and resolve the clash before inserting. |
| `Not possible connection to female panel` | The bracket base plate area (240 x 83 mm) extends beyond the face of the horizontal (female) panel at the chosen insertion point. | Move the insertion point further from the panel edge, or increase the panel dimensions. |
| `Not possible connection to male panel` | The bracket vertical plate area (240 x 120 mm) extends beyond the face of the vertical (male) panel at the chosen insertion point. | Move the insertion point further from the panel edge, or increase the panel dimensions. |

### Diagnostic Geometry

When placement fails due to contact or offset issues, the script draws colored diagnostic geometry instead of the bracket:

- **Green regions** (color 3): The portion of the bracket plate area that is properly supported by the panel face.
- **Red regions** (color 1): The area where the bracket extends beyond the panel face or the offset zone extends beyond the panel edge.
- **Yellow crosshair markers** (color 2): 3D crosshairs at the positions where the bracket edge plus the Offset distance should fall. These indicate the minimum panel extent required for valid placement.

If the bracket is completely outside both panels (no overlap at all), the instance is silently deleted rather than showing error geometry.

## Tips and Notes

- **Adjusting position after insertion:** Select the placed bracket and change the **Offset** property in the Properties Palette. The bracket will recalculate its position relative to the panel edges without needing to delete and reinsert.
- **CNC drill holes:** Only enable **Display: Realistic** when preparing for fabrication export. This mode creates actual 3D Boolean subtractions through the plate geometry, which increases computation time. For design review, use **Text** or **Graphical** mode.
- **Graphical mode color coding:** In Graphical mode, green circles represent holes that are used in the selected Type variant, and red circles represent holes that exist in the physical plate but are not nailed/screwed in the selected variant. This helps verify nailing patterns visually.
- **Catalog key automation:** If a catalog Execute Key is passed (e.g., by a batch script or parent tool), the script silently loads the matching catalog entry and skips the dialog. If no matching key is found, it loads the last inserted settings.
- **Single-panel mode:** Connecting a bracket to a single panel is not supported. The script requires both panels and will abort if only one is provided.
- **Panel selection order:** You do not need to select panels in a specific order. The script automatically determines which panel is the base (female) and which is the vertical face (male).
- **Manufacturer label:** All display modes show "rothoblass" and "TITAN TTV240" text on the vertical plate face for identification in the 3D model.
- **Recalculation:** When a linked panel moves or is modified, the bracket automatically recalculates its position and orientation. On first creation (`_bOnDbCreated`), the script runs two execution loops to ensure hardware components are fully initialized.
