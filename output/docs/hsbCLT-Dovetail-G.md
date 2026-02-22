# hsbCLT-Dovetail-G

## Overview

`hsbCLT-Dovetail-G` is a TSL script for hsbCAD that creates a **dovetail or butterfly spline connection at a G-connection (mitre/perpendicular corner)** between two sets of CLT or timber panels. Unlike the standard `hsbCLT-Dovetail` script which handles panel edges that run alongside each other, this variant is designed for corners where the panels meet at an angle — typically a 90-degree wall-to-wall or wall-to-floor junction — with one panel set running perpendicular into or alongside the face of the other.

The script works by having the user separately select a **male panel set** and a **female panel set**. It then automatically determines the geometric intersection direction, stretches the panel edges to match, and cuts the appropriate dovetail profiles into each side. Two connection modes are available:

- **Dovetail mode**: A male tenon is cut into the male panels; a matching female mortise is cut into the female panels. The panels interlock directly with no additional hardware.
- **Butterfly Spline mode**: A female mortise (pocket) is cut into both panel sets. A separate key insert (X-fix L connector by Greenethic) is required to join them. Hardware is automatically registered in the Bill of Materials.

The script handles panel geometry dynamically. If a panel involved in the connection is moved or resized, the script recalculates and updates all machining cuts automatically.

**Script version:** 1.3 (24 May 2017)
**Author:** thorsten.huck@hsbcad.com
**Keywords:** CLT, Dove, G-Connection, Mitre

---

## Usage Environment

| Space | Supported | Notes |
|---|---|---|
| **Model Space** | Yes | Primary workspace. Operates on Sip (CLT panel) entities in 3D. |
| **Paper Space** | No | Not applicable. |
| **Shop Drawing** | No | Machining data is generated in the 3D model and exported to CNC separately. |

- **Script type:** O-Type (Object — not pre-linked to beams at definition time; panels are selected interactively during insertion)
- **Beams required:** 0 (panels are selected during insertion, not pre-linked)
- **Settings file:** None required. All parameters are defined through OPM properties.

---

## Prerequisites

Before running `hsbCLT-Dovetail-G`, confirm the following:

1. **At least one male CLT panel and one female CLT panel must exist in the model.** The script accepts `Sip` entities only. Standard `GenBeam` or `Beam` entities are not supported as panel selections.

2. **The male and female panel sets must not be parallel to each other.** This script targets G-connections (corners): the panel face normals of the male set must not be parallel to those of the female set. If you select two sets of panels with identical face orientations, the script will reject the selection with the message "Invalid selection set." and cancel.

3. **Panels should be geometrically adjacent or close enough to form a valid corner intersection.** The script calculates the connection direction by finding the closest intersection between the male panel axes and the female panel face plane. If no valid intersection can be found, the connection cannot be placed.

4. **Panels should belong to a named element group** (wall, floor, or roof element) if you want hardware components (Butterfly Spline mode) to be assigned to the correct Bill of Materials group.

---

## How to Use

### Step 1 — Launch the script

Type `hsbCLT-Dovetail-G` at the AutoCAD command prompt, or activate it from the hsbCAD tool palette. The insertion phase starts immediately.

If the script name is stored in a catalog (shortcut key), it can be launched with pre-set property values, bypassing the dialog. When no catalog match is found, a property dialog is displayed before the selection prompts.

### Step 2 — Select male panels

The prompt **"Select male panel(s)"** appears. Click to select one or more CLT panels that will receive the **male side** of the connection. In Dovetail mode, these panels get the tenon (protruding profile). In Butterfly Spline mode, these panels get a female mortise pocket on the side facing the junction.

Use any standard AutoCAD selection method (single click, window, crossing). The script automatically filters your selection:
- Only `Sip` (CLT panel) entities are accepted.
- All selected panels are checked for a common face orientation (parallel normals). Panels that are not co-planar in orientation are silently excluded.

If no valid panels remain after filtering, the script cancels with the message "Invalid selection set."

### Step 3 — Select female panels

The prompt **"Select female panel(s)"** appears. Click to select one or more CLT panels that will receive the **female side** of the connection. In Dovetail mode, these panels get the mortise (receiving slot). In Butterfly Spline mode, these panels also get a female mortise pocket on the side facing the junction.

The same filtering rules apply: only `Sip` entities with consistent face orientations are accepted.

> **Important:** The male and female panel sets must not be parallel to each other. If both sets have the same face direction, the script cannot determine a connection direction and will cancel.

### Step 4 — Connection is created

The script automatically:

1. Determines the connection direction by calculating the shortest geometric path between the center of the male panels and the face plane of the female panels.
2. Stretches the edges of each panel set to meet at the calculated intersection plane.
3. Applies the dovetail or butterfly spline machining tool (`Dove`) to each panel side.
4. Checks for and removes any duplicate instances that may have been created if a panel was previously split perpendicular to an existing instance.
5. Draws a visual symbol at the connection point to indicate the connection type and direction.

### Step 5 — Review and adjust in OPM

After insertion, click the connection instance to select it. Open the Properties Palette (Ctrl+1) to inspect and modify the parameters described below.

Changes made in OPM take effect immediately on the next recalculation.

---

## Properties Panel (OPM Parameters)

Access via the AutoCAD Properties Palette (Ctrl+1) after selecting the script instance in the model.

### Geometry Category

Controls the shape and size of the dovetail or spline profile cut into the panels.

| Property | Default | Unit | Description |
|---|---|---|---|
| **(A) Width** | 50 | mm | Depth of the lap joint measured from the reference face of the male panels. This controls how far the dovetail profile extends into the panel thickness. Set to **0** to automatically use 50% of the panel thickness, ensuring a balanced joint centered on the panel's mid-plane. |
| **(B) Depth** | 20 | mm | Width of the dovetail profile measured along the connection direction. This is the dimension of the tenon or mortise in the direction the panels meet. Larger values create a deeper interlock. |
| **(C) Angle** | 0 | degrees | Taper angle of the dovetail sides. A value of **0** creates a straight rectangular profile (simple lap joint or slot). A non-zero value creates the angled wedge shape of a traditional dovetail, which provides mechanical resistance to pull-out. Typical dovetail angles are 5 to 15 degrees. |
| **(D) Gap** | 0 | mm | Clearance added to the depth of the joint on the female side. This small offset allows for manufacturing tolerance, glue space, or panel swelling. For glued joints, a value of 1 to 2 mm is typical. Has no effect on the male side profile. |

### Alignment Category

Controls the position and vertical extent of the connection tool along the panel height.

| Property | Default | Unit | Description |
|---|---|---|---|
| **(E) Axis Offset X** | 0 | mm | Horizontal offset of the tool profile from the auto-detected intersection point. Use this to shift the connection laterally when the joint should not be centered on the geometric intersection. |
| **(F) Bottom Offset** | 0 | mm | Vertical distance from the bottom of the panel range at which the tool starts. A value of **0** makes the cut run through the entire panel height (a full-height through-connection). Positive values create a blind pocket that stops short of the panel bottom edge. |
| **(G) Open Tool Side** | bottom | — | Determines which end of the tool is left "open" (not limited) when the male and female panels have different heights. Options: **bottom** (the tool extends from the bottom), **top** (extends from the top), **Both** (extends in both directions to the full combined range of both panel sets). This parameter is important when the panels at the corner are not the same height. |

### Connection Type

| Property | Default | Options | Description |
|---|---|---|---|
| **(H) Connection Type** | Dovetail | Dovetail / Butterfly Spline | Switches between the two available connection modes. **Dovetail**: applies a male tenon to the male panels and a female mortise to the female panels. No hardware is required. **Butterfly Spline**: applies a female mortise (pocket) to **both** panel sets. A separate key insert (X-fix L) is required and is automatically registered in the Bill of Materials. |

---

## Right-Click Menu Options

Right-click on the script instance in the model to access the following context menu option.

| Menu Item | When Available | Description |
|---|---|---|
| **Flip Direction** | Dovetail mode only | Swaps the male and female panel assignments. The panels that previously received the male tenon will now receive the female mortise, and vice versa. Use this to correct the machining direction without deleting and re-inserting the connection. This trigger is also activated by **double-clicking** the instance. |

> **Note:** The Flip Direction option is only shown in the context menu when the Connection Type is set to **Dovetail**. In Butterfly Spline mode, both sides receive an identical female pocket, so flipping direction has no effect and the option is hidden.

---

## Connection Type Comparison

### Dovetail Mode (H = Dovetail)

- A male tenon is cut into the male panel set.
- A female mortise is cut into the female panel set.
- The gap (D) is added only to the female mortise depth, creating clearance for assembly.
- The panels interlock directly. No additional hardware or inserts are needed.
- A dovetail symbol (arrow/trapezoid shape) is drawn at the connection point indicating which side is female.
- Best for: direct structural panel-to-panel corner connections where the joint must resist pull-out.

### Butterfly Spline Mode (H = Butterfly Spline)

- A female mortise (pocket) is cut into **both** the male and female panel sets.
- A separate **X-fix L** butterfly key insert (by Greenethic) is required to bridge the two pockets and join the panels.
- The key insert is automatically registered in the Bill of Materials as a `HardWrComp` hardware component with:
  - **Category:** Connector
  - **Manufacturer:** Greenethic
  - **Model name:** `X-fix L[Depth] x [Width]` — where Depth and Width reflect the (B) Depth and (A) Width property values.
  - **Dimensions:** The hardware component is scaled to the actual tool length, width (A), and depth (B) so that material quantities are accurate.
- A butterfly/hourglass symbol is drawn at the connection point.
- Best for: alignment keys, repair joints, or connections that may need to be disassembled.

---

## How This G-Variant Differs from hsbCLT-Dovetail

| Feature | hsbCLT-Dovetail | hsbCLT-Dovetail-G |
|---|---|---|
| **Connection geometry** | Panel edges running alongside each other (coplanar panels in a flat or vertical array) | Panels meeting at a corner or perpendicular junction (G-connection/mitre) |
| **Panel selection** | Single-step panel selection with automatic edge detection; can split one panel into two | Two-step selection: user explicitly picks male set then female set |
| **Panel orientation** | Male and female panels are parallel (same face direction) | Male and female panels are non-parallel (different face directions, meeting at an angle) |
| **Insertion point** | User can click near a specific edge or press Enter for all | Insertion point is auto-calculated from the geometric center of the male panels |
| **Workflow modes** | Supports single-panel split, multi-panel batch, and wall element modes | Single batch mode with explicit male/female selection |
| **Context menu** | Flip Side, Flip Direction, Add Panel(s), Remove Panel(s), Edit in Place | Flip Direction only |
| **Chamfer support** | Yes (Reference Side and Opposite Side chamfers) | Code present but commented out — chamfers are not active in version 1.3 |

---

## Tips and Notes

**The connection direction is determined automatically.** The script tests both the X and Y axes of the male panel set to find which one intersects the face plane of the female panel set at the shortest distance. The shorter path is used as the connection direction. You do not need to specify an angle or direction manually.

**Twisted connections are not supported.** If the face normal of the female panel set is not perpendicular to the panel height direction of the male set, the script will display the message "Twisted connections are not supported." and cancel. Ensure the two panel sets meet in a geometrically clean 90-degree configuration.

**Open Tool Side (G) is critical when panel heights differ.** When a taller panel meets a shorter panel at a corner, the tool must be anchored at the correct end. Setting (G) to "bottom" anchors the tool at the bottom of the shared range. Setting it to "top" anchors at the top. Use "Both" only if you want the tool to cover the full height range of both panel sets combined.

**Use Gap (D) for glued connections.** In production applications with adhesive, set Gap (D) to 1 or 2 mm. This prevents the panels from bottoming out before the glue is squeezed, and allows for minor manufacturing tolerances without affecting the visible joint quality.

**Flip Direction corrects wrong-side machining without re-insertion.** If the tenon appears on the wrong panel set after insertion, right-click and select "Flip Direction." The script swaps the male and female roles internally and recalculates all cuts. This is faster and more reliable than deleting and re-inserting the connection.

**Duplicate instances are removed automatically.** If a panel split operation (performed by another script) copies this instance to a new location that overlaps an existing instance with identical properties, the duplicate is automatically merged and the extra instance is erased. This prevents double-cutting of the same joint.

**Butterfly Spline hardware is linked to the element BOM.** The X-fix L component registered in Butterfly Spline mode is attached to the parent element group of the panels. It will appear automatically in all standard hsbCAD Bill of Materials reports and exports. You do not need to add it manually.

**Unit independence.** The script uses the `U()` function for all dimensional parameters and is compatible with both metric (mm) and imperial (inch) hsbCAD drawing templates.

---

## Version History

| Version | Date | Changes |
|---|---|---|
| 1.3 | 24 May 2017 | Article name of butterfly spline hardware changed to "X-fix L" |
| 1.2 | 23 May 2017 | Article name changed to "XFix-L" |
| 1.1 | 13 Jun 2016 | Bug fix; thumbnail image updated |
| 1.0 | 30 May 2016 | Initial release |
