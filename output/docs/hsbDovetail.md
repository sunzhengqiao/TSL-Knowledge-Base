# hsbDovetail

## Overview

The **hsbDovetail** tool creates precision dovetail and butterfly (loose key) timber joints between beams or between a beam and a CLT panel in hsbCAD. It generates CNC-ready machining profiles that interlock two timber members mechanically, producing self-tightening connections without additional fasteners.

The script supports three connection geometries: a **T-Connection** (one beam terminating into the face of another), an **End-to-End** joint (two beam ends meeting at a mitre or straight cut), and a **Parallel Connection** (two beams lying face-to-face alongside each other). Within T-Connection and End-to-End modes, you choose between a classic **Dovetail** profile (integral tenon on the male beam with a matching socket on the female) or a **Butterfly / Loose Key** profile (slots cut into both members for a separate spline). Parallel Connection always uses the Butterfly profile. Setting a Duplex Interdistance generates two side-by-side tenons where applicable.

When only a single male beam is selected and no female beam is provided, the script prompts you to pick a split point along the beam, automatically divides it into two pieces, and creates an End-to-End dovetail connection between them. Beam-to-CLT-panel connections are supported for T-Connection and Parallel modes.

## Usage Environment

| Attribute | Value |
|-----------|-------|
| Script Type | O (Object -- parametric instance linked to beam geometry) |
| Beams Required | 0 (beams are selected interactively during insertion) |
| Intended Space | Model Space only |

## Prerequisites

- Two timber beams (GenBeam/Beam entities) that share a physical intersection or overlap, **or** one beam and one CLT panel (Sip entity) in a compatible orientation, **or** a single beam (which will be split automatically).
- For Parallel Connection, the two beams must be parallel and share a contact face at least as large as the defined joint Width.
- For beam-to-panel T-Connections, the male beam must not be parallel to the panel XY-plane; otherwise the script removes itself with a warning.
- Butterfly (loose key) mode generates machining pockets in both members but does not create the spline element itself.

## How to Use

### Workflow A -- T-Connection or End-to-End Joint (Two Beams)

1. Launch the script via `TSLINSERT` and select **hsbDovetail**.
2. A dialog box appears on first use. Select your preferred defaults (connection type, joint dimensions) and confirm. On subsequent uses the last-used values are remembered.
3. At the prompt **"Select male beams"**, click on the beam(s) that will receive the tenon. Press Enter to finish selection.
4. At the prompt **"Select female beams or panels"**, click on the beam(s) or panel(s) that will receive the socket. Press Enter to finish selection.
5. The script automatically detects the intersection geometry and creates one joint instance per valid male-female pair.
6. After insertion, select the joint instance and open the Properties Palette (Ctrl+1) to fine-tune dimensions.

### Workflow B -- Single Beam Auto-Split

1. Launch the script via `TSLINSERT` and select **hsbDovetail**.
2. At the prompt **"Select male beams"**, click the beam you want to split and connect, then press Enter.
3. At the prompt **"Select female beams or panels"**, press Enter immediately without selecting anything.
4. A live preview of the split location appears as you move your cursor along the beam. The keyword option **"Flip direction"** is available to reverse which end becomes male or female.
5. Click to confirm the split point. The beam is divided into two pieces and an End-to-End dovetail joint is created between them.

### Workflow C -- Parallel Connection (Face-to-Face Beams or Beam-to-Panel)

1. Launch the script via `TSLINSERT` and select **hsbDovetail**.
2. Select the male beam(s) and the parallel female beam(s) or panel(s) as prompted.
3. When prompted **"Pick location"**, click a point on or near the desired position along the parallel interface.
4. The script detects the common face area and places the butterfly slot at the picked location.
5. Use the right-click **Rotate** option or double-click the instance to flip the connection direction 180 degrees if needed.

## Properties Panel (OPM Parameters)

Access these parameters via the Properties Palette (Ctrl+1) after selecting the joint instance.

### Connection Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Connection | Dropdown | T-Connection | Geometric relationship between the two members. Options: **T-Connection**, **End-End**, **Parallel Connection**. Hidden after insertion (read-only); to change the connection type, erase and re-insert the joint. |
| Type | Dropdown | Dovetail | Joint profile type. **Dovetail** creates an integral tenon and matching socket. **Butterfly** creates matching slots for a loose key. Forced to Butterfly and hidden when Connection is set to Parallel Connection. |

### Dovetail Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Width | Length | 45 mm | Overall width of the dovetail tenon or butterfly slot measured along the beam axis. |
| Depth | Length | 28 mm | How far the dovetail or slot penetrates into each member (cut depth perpendicular to the connection face). |
| Additional Depth | Length | 0 mm | Extra depth added to the female (socket) side only, providing a clearance gap so the tenon seats fully. Only visible in Dovetail mode; hidden for Butterfly. |
| Offset | Length | 0 mm | Shifts the joint away from the beam edge. A value of 0 produces a continuous mortise running the full height of the beam. |
| Angle | Angle | 10 degrees | Taper angle of the dovetail sides. A larger angle creates a stronger self-tightening wedge. Only visible in Dovetail mode; Butterfly connections always use 0 degrees. |

### Alignment Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Horizontal Offset | Length | 0 mm | Shifts the joint laterally along the connection face, away from the male beam centre axis. Visible for T-Connection and End-End modes; hidden for Parallel Connections. The value is automatically clamped so the dovetail does not exceed the male beam edge. |
| Rotation | Angle | 0 degrees | Rotates the joint profile around the connection axis. In T-Connection mode, right-click **Rotate** or double-click launches an interactive jig to set this angle graphically. Hidden when Offset is greater than 0 in Butterfly mode. |
| Duplex Interdistance | Length | 0 mm | Distance between two side-by-side tenons for a duplex (double) connection. Set to 0 for a single joint. Only visible in Butterfly mode. A duplex pair is only generated when this value is at least the Width plus 20 mm. |

### Keyhole Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Height | Length | 0 mm | Height of the loose-key pocket opening. **0** = calculated automatically from the contact geometry. **-1** = disabled (no keyhole cut). Visible for Dovetail mode in T-Connection and End-End joints. |
| Width | Length | 0 mm | Width of the loose-key pocket opening. **0** = calculated automatically. Visible for Dovetail mode in T-Connection and End-End joints. |

## Right-Click Menu Options

| Menu Item | Availability | Description |
|-----------|--------------|-------------|
| Flip Direction | T-Connection and End-End, beam-to-beam only | Swaps which beam is treated as male and which is female, reversing the tenon and socket assignment. |
| Join | End-to-End with parallel beams only | Merges the two beams back into a single continuous beam and removes the joint instance. |
| Rotate | T-Connection (interactive jig) and Parallel Connection (180-degree toggle) | In T-Connection mode, launches a live jig so you can pick a new rotation angle graphically or type a value at the command-line prompt **"Enter rotation angle"**. In Parallel mode, toggles the connection direction by 180 degrees. Double-clicking the instance also triggers Rotate. |

## Tips and Notes

- **Connection type is locked after insertion.** The Connection dropdown is hidden in the Properties Palette once the instance is placed. To change from T-Connection to End-End or vice versa, erase the joint and re-insert.
- **Duplex dovetails** (two tenons side by side) are only generated when the Interdistance value is at least the Width plus 20 mm. Below this threshold, a single tenon is created.
- **Butterfly mode and Parallel Connections always use 0-degree taper**, regardless of the Angle property, because tapered sides would prevent the key from sliding in.
- **The grip point can be dragged** after insertion in End-to-End mode with parallel beams to reposition the joint along the beam length. The script enforces bounds so the joint cannot be dragged past the beam ends.
- **Beam-to-panel connections** are supported for T-Connection and Parallel modes. In T-Connection mode the male beam must not be perpendicular to the panel Z-axis (i.e., not parallel to the panel face), otherwise the script removes itself with a warning.
- If you see the message **"Tool will be deleted"**, common causes are: (1) beams do not intersect or have insufficient overlap for the defined Width, (2) beams are not parallel when Parallel Connection mode is selected, or (3) a single beam was selected without confirming a split point.
- **CNC machining**: The Dove tools applied to the beams export to CNC automatically. No extra setup is required.
- **Horizontal Offset auto-clamp**: If the entered offset would push the dovetail past the male beam edge, it is automatically reduced to the maximum allowed value and a message is shown.

## Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.6 | 10 May 2022 | T. Huck | Added beam-to-panel connections; new keyhole size options |
| 1.5 | 14 Mar 2022 | T. Huck | Adjusted default property values |
| 1.4 | 22 Jun 2020 | G. Cenni | Support for rotated and non-perpendicular beams; additional mortise depth |
| 1.3 | 05 Mar 2020 | D. Delombaerde | Grip point boundary enforcement and out-of-bounds reset |
| 1.2 | 24 Oct 2015 | T. Huck | Reference edges consider common connection edges |
| 1.1 | 14 Oct 2015 | T. Huck | Enhanced dialog image |
| 1.0 | 07 Oct 2015 | T. Huck | Initial release |
