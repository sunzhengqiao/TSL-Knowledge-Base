# GCS (General Column Shoe)

## Overview

GCS places a parametric metal column shoe connector at the base of a timber post or column. The shoe is selected from an XML catalog containing manufacturer data -- you pick the manufacturer, product family, and article number through a dialog, and the script builds the 3D geometry automatically in the model.

The connector is assembled from four structural sections: a top connection piece that attaches to the timber column (bar, brace, or slot-and-drill profile), a flat middle plate that sits against the column face, an adjustable anchor bar that extends into the concrete or substrate, and a bottom base plate with anchor bolt holes. All dimensions, drill patterns, and material properties are read directly from the catalog file, so the geometry always matches the physical hardware.

When the shoe is placed, it cuts the bottom of the post to the correct level and drills the bolt holes into the timber at the required diameter, spacing, and depth. The hardware connector is also automatically registered in the project Bill of Materials with the correct article number, manufacturer, and quantity. If the post moves or is resized, the shoe recalculates automatically.

## Usage Environment

| Attribute | Value |
|-----------|-------|
| Script Type | O (Object -- inserts as a standalone intelligent entity attached to a beam) |
| Beams Required | 1 (the timber post or column to receive the shoe) |
| Intended Space | Model Space (3D detailing) |
| Catalog Required | `GCS.xml` in Company or Installation TSL Settings folder |

## Prerequisites

- A timber post or column (GenBeam) must already exist in the drawing at the intended location.
- The `GCS.xml` catalog file must be installed in the Company TSL Settings folder (`_kPathHsbCompany\TSL\Settings\GCS.xml`) or the hsbCAD installation content folder. If the file is missing, the script aborts immediately with an error message and deletes itself.
- The catalog must contain at least one manufacturer entry with valid data. If the catalog is present but empty of manufacturer records, the script also aborts.

## How to Use

1. **Start the command.** Run the `GCS` script from the hsbCAD ribbon or by typing the configured command alias at the AutoCAD command line. You can also insert it from a product catalog button, in which case the manufacturer and article may be pre-selected automatically via an execute key token (format: `Manufacturer?ArticleNumber`).

2. **Select manufacturer (dialog).** A selection dialog appears listing available manufacturers from the catalog. If only one manufacturer exists, the field is set automatically and no dialog appears.

3. **Select family (dialog).** Choose the product family within the selected manufacturer. If only one family exists, it is set automatically. If multiple families are available, a dialog is shown.

4. **Select the article number.** If the chosen family has multiple product sizes, a further dialog allows you to select the specific article number (SKU). If there is only one product, it is selected automatically.

5. **Select the timber post.** At the command prompt "Select Posts", click on the timber column in the 3D model. The script creates one shoe instance per selected post. If a Painter filter is active, only posts matching the painter criteria are accepted.

6. **Review the result.** The column shoe geometry appears at the base of the post. The post bottom is cut flush with the shoe, and bolt holes are drilled into the timber. Use the Properties panel to adjust tolerances or drill offsets, and the right-click menu to rotate or cycle drill direction.

## Properties Panel (OPM Parameters)

These parameters appear in the AutoCAD Properties Palette when the inserted shoe is selected.

### General Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Manufacturer | String (read-only) | From catalog | The connector manufacturer name. Locked after insertion. |
| Family | String (read-only) | From catalog | The product family within the manufacturer range. Locked after insertion. |
| Article Number | String | From catalog | The specific product SKU. If the family contains multiple sizes, this can be changed to switch sizes. Read-only when only one product exists. |

### Filter Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Painter | String (read-only) | Disabled | Optional filter based on a painter definition. When set during insertion, only posts matching the filter criteria receive the shoe. Shows "Disabled" when no filter is applied. |

### Tolerance Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Top Shape Height | Double | From catalog | Vertical clearance added to the top connection cavity so the timber fits without binding. |
| Top Shape Width | Double | From catalog | Horizontal clearance added to the top connection cavity width. |

### Drill Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Top Drill offset X | Double | 1/4 of post width | Controls how far the top bolts are offset inward from the post face, creating installation tension. |
| Top Drill offset Z | Double | 0 | Vertical offset applied to the top bolt drill pattern along the height of the shoe. |
| Top Drill Alignment | String | Right | Direction from which the top bolts are drilled into the timber. Options: Right, Left, Complete Through. |

### Offsets Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Bar Height | Double | From catalog | The height of the anchor bar section. For extendable shoe types, this value can be adjusted between the catalog minimum and maximum to control embedded length. Read-only for non-extendable models. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Rotate | Rotates the shoe 90 degrees around the post axis. For extendable shoes, the script checks whether the post dimensions allow rotation before permitting the change. If the post only fits in one orientation, the option is hidden. |
| Cycle Drill Face (DoubleClick) | Steps the top bolt drill direction through the sequence: Right, Left, Complete Through, then back to Right. Double-clicking the shoe entity also triggers this action. |

Note: A hidden "Flip Drill Face" trigger can reverse drill direction programmatically (Right to Left or vice versa) but does not appear as a visible menu item in standard configurations.

## Geometry Generated

The script produces the following 3D geometry, drawn in the catalog-specified color:

- **Top connection** -- One of three forms depending on the catalog entry:
  - *Bar*: A cylindrical peg that inserts into a drilled hole in the post bottom.
  - *Brace*: Two rectangular bracket arms that grip the sides of the post.
  - *Slot*: A rectangular plate that slides into a slot cut in the post bottom; bolt holes are drilled through both the plate and the timber.
- **Middle plate** -- A rectangular or circular flat plate pressed against the column face. For extendable types, the plate length adapts to the actual post dimension.
- **Anchor bar** -- A cylindrical rod connecting the middle plate to the base plate. Height is adjustable within catalog limits for extendable models.
- **Bottom base plate** -- A rectangular plate with anchor bolt holes for fixing to the concrete slab or foundation. Drill positions auto-adjust to remain inside the plate boundary.

Additionally, the script applies these tools to the timber post:

- A **Cut** at the base to trim the post bottom flush with the shoe.
- **Drill** holes through the post for top connection bolts (pattern follows the catalog row/column/spacing configuration).
- A **Slot** in the post bottom for slot-type top connections (with tolerance clearance applied).

## Bill of Materials

The script registers two hardware components automatically:

1. **The column shoe itself** -- using the article number, manufacturer, family, description, and material from the catalog. Category is set to "Connector."
2. **The connection pegs/bolts** -- if top drill holes are specified, a sub-component entry is added for each bolt, identified as `Peg[diameter]x[post width]` with quantity equal to the total number of holes (rows multiplied by columns). Category is set to "Fixture."

These entries are grouped with the element that owns the post, or with the first available group if no element is present.

## Tips and Notes

- **Duplicate prevention**: If two GCS instances are placed on the same post, the script detects the duplicate and automatically erases the newer one. Only one column shoe per post is allowed.
- **Catalog file is mandatory**: If `GCS.xml` is not found in either the company or installation path, the script aborts and deletes the instance. Contact your CAD manager to verify the file location.
- **Post size validation**: For extendable shoes, the script checks whether the selected article fits the actual post dimensions (including the extend range). If the post is too wide or too narrow, an error message is shown and the instance is removed.
- **Extendable shoes**: Some catalog entries include a `Middle Length Extend` value and/or a `Bar Height Extend` value. The middle plate length automatically adjusts to match the actual post width. The bar height can be manually adjusted within the allowed range via the Properties panel.
- **Rotation after placement**: Use the right-click Rotate option if the shoe aligns with the wrong face. For extendable shoes, the script verifies the post fits in the rotated orientation before allowing the change. If it does not fit, rotation is blocked with a message.
- **Catalog tokens**: The script can be called from a catalog button with a pre-specified manufacturer and article name encoded in the execute key (format: `Manufacturer?ArticleNumber`). In that case, the selection dialogs are skipped.
- **Horizontal post detection**: If the post is oriented horizontally (perpendicular to the world Z axis), the script cannot determine a valid base direction and will delete itself.
- **Hardware BOM update**: On first placement, the script runs two execution loops to ensure hardware components are properly registered. This is normal behavior.
