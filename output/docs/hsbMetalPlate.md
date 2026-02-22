# hsbMetalPlate

## Overview

`hsbMetalPlate` is a hsbCAD TSL script that places metal connector plates (gang-nail / toothed plates) at the joint between two or three GenBeam timber members. The plate is positioned on a coplanar face shared by the selected beams and is represented as a thin 3D solid that follows the joint if any connected beam moves. All product data (manufacturer, family, dimensions) is read from an external XML catalog file (`MetalPlateCatalog.xml`), so every placed plate corresponds to a real product.

After placement, the plate entity is fully parametric: its product selection, alignment offsets, rotation, and side placement can be modified at any time through the AutoCAD Properties Palette (OPM). The script automatically registers a hardware component record (`HardWrComp`) on each placed plate, so the connector appears in Bills of Material and element hardware schedules without manual data entry.

The initial release (version 1.0, 12 May 2021, issue HSB-11670) ships with catalog support for MiTek Tylok Plates, a line of toothed gang-nail plates manufactured from 0.95 mm G300 Z275 galvanised steel, available in eight sizes from 34 x 60 mm up to 34 x 480 mm.

## Usage Environment

- **Model Space only.** The script creates 3D geometry on timber members in the model space.
- **Script type: Object (O-type).** Inserted as a standalone parametric entity that links itself to the connected beams. It does not cut or drill the beams.
- **No pre-selected beams required** (`#NumBeamsReq 0`). Beams are selected interactively during the insertion workflow.

## Prerequisites

1. **At least two GenBeam members** must exist in the drawing. The beams must share a coplanar face -- two flat side faces of different beams lying in the same geometric plane and close enough to touch or overlap (within 0.1 mm tolerance).
2. **The Metal Plate Catalog XML file** (`MetalPlateCatalog.xml`) must be accessible at one of the following locations:
   - Company path: `<HsbCompany>\TSL\Settings\MetalPlateCatalog.xml`
   - Fallback installation path: `<HsbInstall>\Content\General\TSL\Settings\MetalPlateCatalog.xml`

   If the catalog cannot be found at either location, the script displays an error message and deletes itself. During insertion, if the Settings folder does not exist under the company TSL path, the script creates it automatically.
3. If no coplanar adjacent face pair is found among the selected beams, the script reports "Beams not OK" and cancels.

## How to Use

### Single Insertion Mode (Default)

1. **Start the command** using `hsb_ScriptInsert "hsbMetalPlate"` from the AutoCAD command line, or launch it from the hsbCAD ribbon or menu if configured.
2. **Select GenBeams:** A selection prompt appears asking you to select all timber members that should participate in the connection. Select two or more GenBeams and confirm the selection.
3. **Product selection dialog:** If no OPM key is pre-specified (see Automation below), a cascading dialog sequence appears. Work through the three stages:
   - First dialog: choose a **Manufacturer** (e.g., MiTek).
   - Second dialog: choose a **Family** (e.g., Tylok Plates). The Manufacturer is locked once selected.
   - Third dialog: choose a **Product** (e.g., 8T5). The Family is locked once selected.
4. **Select insertion point (Jig):** After product selection, a graphical jig preview is activated. All valid plate positions are displayed as filled rectangular shapes on the beam faces. As you move the cursor, the candidate position beneath it is highlighted in a contrasting colour (green). Click on the desired plate location to confirm placement.
   - During this step you can toggle between **2 Genbeams** and **3 Genbeams** connection mode by typing the keyword shown in the command prompt (e.g., type `3Genbeams` to switch to three-beam mode, or `2Genbeams` to switch back). The preview updates immediately to show valid positions for the selected mode.
   - Press Escape to cancel placement without inserting.
   - After placing a plate, the jig remains active so you can place additional plates at other positions on the same beam set. Press Escape or right-click to finish.
5. The plate is inserted as a parametric entity. All properties can be adjusted in the OPM at any time.

### Multiple Insertion Mode

When **Mode** is set to `Multiple` before confirming the insertion dialog, the script automatically places a plate instance at every valid coplanar face pair (or triplet, depending on Type setting) found among the selected beams. In this mode:

- **Face** filtering controls which joints receive plates:
  - **View Direction** -- only faces whose normal points toward the current view direction.
  - **Normal to View Direction** -- only faces whose normal is perpendicular to the view.
  - **All** -- all valid coplanar face pairs regardless of view orientation.
- Each placed instance is automatically set back to Single mode and becomes an independent parametric entity.
- If a plate entity somehow retains Multiple mode after insertion, it will erase itself and display a message, since Multiple mode is only supported during the insertion phase.

### Automation via OPM Key

The script supports automated insertion through an OPM key string passed via `_kExecuteKey`. The key can specify one, two, or three levels of the product hierarchy, separated by `?`:

- `MiTek` -- sets the manufacturer, prompts for family and product via dialog.
- `MiTek?Tylok Plates` -- sets manufacturer and family, prompts for product only.
- `MiTek?Tylok Plates?8T5` -- sets all three, no dialogs shown.

The script also supports catalog-based insertion: if the execute key matches a catalog entry name, the script loads all property values from that catalog entry without showing any dialogs.

## Properties Panel (OPM Parameters)

The following parameters are visible in the AutoCAD Properties Palette after the plate is placed. Some properties are only visible during insertion and are hidden afterwards.

### Component

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Manufacturer | String (dropdown) | First manufacturer in catalog | Selects the plate manufacturer from the catalog. Changing this resets the Family and Product fields to the first available option under the new manufacturer. |
| Family | String (dropdown) | First family of selected manufacturer | Selects the product family within the chosen manufacturer. Changing this resets the Product field. The family entry also defines the material description and optional hyperlink URL. |
| Product | String (dropdown) | First product of selected family | Selects the specific plate model. The plate dimensions (Length and Width) are loaded from the catalog entry for the selected product. |

### Insertion Mode (visible during insertion only)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Mode | String (dropdown) | Single | Controls whether the plate is placed one at a time with jig preview (`Single`) or automatically at all valid positions (`Multiple`). Hidden after insertion. |
| Face | String (dropdown) | View Direction | Controls which beam faces are considered for plate placement in Multiple mode. Options: `View Direction`, `Normal to View Direction`, `All`. Hidden after insertion. |

### Alignment

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Side | String (dropdown) | One | Controls whether the plate is placed on one face of the joint or on both opposite faces simultaneously. Options: `One`, `Both`. When `Both` is selected, two plates are created at the same joint (mirrored on each side) and the Swap Side context menu option is hidden. The hardware quantity is set to 2 when Both is selected. |
| Offset Length | Double (length) | 0 | Shifts the plate position along its length axis relative to the computed joint centre. Positive values move the plate in the length direction; negative values move it in the opposite direction. |
| Offset Width | Double (length) | 0 | Shifts the plate position perpendicular to the length axis within the face plane. |
| Rotate | Double (angle) | 0 | Rotates the plate about the face-plane normal at its centre point, allowing the plate to be oriented at an angle relative to the beam axis. |
| Type | String (dropdown) | 2 Genbeams | Defines how many beams the plate spans. `2 Genbeams` spans a joint between two timbers; `3 Genbeams` places the plate at the common overlap zone of three timbers (e.g., a king-post truss node). This property is hidden after insertion; the beam count is fixed at placement time. |

### Catalog Products (MiTek Tylok Plates)

The following products are available in the default catalog. All plates are 34 mm wide and made from 0.95 mm G300 Z275 galvanised steel. The 3D body thickness is fixed at 0.95 mm.

| Product Name | Width (mm) | Length (mm) | Rows | Teeth per Row |
|-------------|------------|-------------|------|---------------|
| 2T5 | 34 | 60 | 2 | 5 |
| 4T5 | 34 | 120 | 4 | 5 |
| 6T5 | 34 | 180 | 6 | 5 |
| 8T5 | 34 | 240 | 8 | 5 |
| 10T5 | 34 | 300 | 10 | 5 |
| 12T5 | 34 | 360 | 12 | 5 |
| 14T5 | 34 | 420 | 14 | 5 |
| 16T5 | 34 | 480 | 16 | 5 |

Product codes follow the pattern `NTW` where N is the number of tooth rows along the length and W is the number of teeth per row across the width (always 5 for this family).

## Right-Click Context Menu

| Menu Item | Condition | Description |
|-----------|-----------|-------------|
| Swap Side | Visible only when Side = `One` | Flips the metal plate to the opposite face of the joint. Internally, the plane vector is negated, the length direction is reversed, and both the Offset Length and Rotate values are negated so that the plate orientation remains visually consistent on the opposite side. This option is hidden when Side is set to `Both`, since both faces already have a plate. |

## How It Works (Technical Summary)

### Face Detection Algorithm

The script examines each selected GenBeam along all six face directions (+X, -X, +Y, -Y, +Z, -Z). For each face, it extracts a `PlaneProfile` (2D footprint on that face plane) from the beam's envelope body. It then tests every combination of beam pairs (or triplets for 3-beam mode) to find faces that:

1. Have co-directional normal vectors (faces point the same way).
2. Lie in the same geometric plane (distance between face origins along the normal is less than 0.1 mm).
3. Have overlapping or adjacent footprints (the extended profiles intersect when each is grown by 20 mm).

For each qualifying pair, the script computes the plate centre point at the geometric midpoint of the overlap zone and determines the plate length and width directions from the first beam's local axes.

### 3D Geometry Generation

After placement, the script creates the plate body as follows:
1. A rectangular `PLine` is created at the computed centre point with dimensions from the catalog (Length x Width).
2. The rectangle is extruded along the face normal by the plate thickness (0.95 mm) to create a `Body` solid.
3. The body is rotated by the Rotate angle about the face normal.
4. The body is translated by the Offset Length and Offset Width values.
5. The plate is displayed as both a filled 2D profile (colour 252, light grey) and a 3D wireframe body.

When Side is set to `Both`, the entire process runs twice -- once for each opposing face of the joint.

### Hardware Registration

After geometry creation, the script creates a `HardWrComp` record containing:
- **Article number**: the Family name (e.g., "Tylok Plates")
- **Quantity**: 1 for one-sided, 2 for both-sided placement
- **Manufacturer**, **Model** (product name), **Material** (from the family definition)
- **Dimensional scales**: DScaleX = plate length, DScaleY = plate width, DScaleZ = plate thickness
- **Category**: "Connector"
- **Group**: inherited from the primary beam's element group
- **Linked entity**: the primary beam (gb0)

This record ensures the plate appears correctly in BOM reports and hardware schedules.

## Tips and Notes

- **Valid placement requires coplanar faces.** If the selected beams do not share a common face plane (within 0.1 mm tolerance), the script displays "Beams not OK" and cancels. Ensure beams are actually touching or sharing a face before running the tool.

- **Visual jig during placement.** In Single mode, all valid plate positions are displayed as filled preview rectangles. The position beneath the cursor is highlighted in green. This makes it straightforward to identify which joint you are targeting, especially in dense framing.

- **The plate thickness is fixed at 0.95 mm.** This matches the standard gauge for MiTek Tylok toothed plates and is used for both the 3D body geometry and the BOM dimensional scaling.

- **Hyperlink to product specification.** When a family entry in the catalog includes a `url` field, the script attaches a web hyperlink to the placed entity. For MiTek Tylok Plates, this links to the MiTek New Zealand product code report page. The link can be opened from the AutoCAD entity properties.

- **Version compatibility checking.** When a new plate instance is created, the script compares the catalog version number stored in memory (from the drawing's MapObject) against the version in the XML file on disk. If they differ, a notice is printed to the command line, alerting you that the drawing was made with a different catalog version.

- **Extending the catalog.** To add custom plate products or a new manufacturer, copy `MetalPlateCatalog.xml` to the company settings folder (`<HsbCompany>\TSL\Settings\`) and edit it following the existing XML structure. New manufacturers, families, and products will appear in the OPM dropdowns automatically. Increment the `Version` integer in the `GeneralMapObject` section when making changes so that existing drawings receive the version mismatch notice.

- **Layer and group assignment.** The placed plate is assigned to layer `"i"` and added to the same group as the primary connected beam. This keeps hardware co-located with its parent framing member for selection and layer management.

- **Toggling beam count during jig.** During the Single-mode jig phase, type the keyword displayed in the command prompt to toggle between `2 Genbeams` and `3 Genbeams` detection. The preview updates immediately so you can compare which mode suits the joint before committing.

- **Multiple mode places only view-facing joints.** In Multiple mode with the default Face setting of `View Direction`, only joints whose face normal points toward the current view direction receive plates. Rotate your view or change the Face setting to `All` if you want to plate joints on all sides in a single operation.

## Version History

| Version | Date | Reference | Description |
|---------|------|-----------|-------------|
| 1.0 | 12 May 2021 | HSB-11670 | Initial release. Author: Marsel Nakuci. Supports 2-beam and 3-beam connections with MiTek Tylok Plates catalog. |
