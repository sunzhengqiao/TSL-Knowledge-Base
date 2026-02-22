# GH-Verbinder Top OV

## Overview

GH-Verbinder Top OV is an O-Type TSL script (version 3.11) that places concealed **GH TOP OV aluminum connectors** between two timber beams. The connector is a hidden splice hardware product manufactured by GH, installed as a mortised pocket (House tooling) milled into both beam faces. The result is a structural connection with no visible fasteners on the exterior surface.

Three connection types are supported:

- **T-Connection**: A beam end meeting another beam at an angle (typical stud-to-plate or joist-to-header).
- **Length Connection**: Two beams meeting along their length at a mitered or angled splice.
- **Parallel Connection**: Two side-by-side parallel beams joined laterally.

The script auto-detects beam pairings for T-connections, places pocket geometry into both members, registers hardware (connector plates and screws) in the bill of materials, creates no-nail exclusion zones around the connector, and optionally adds a locating mill into the parent element for CNC positioning.

The GH Top OV connector is available in four widths: 40, 60, 80, and 100 mm. All variants are 104 mm long and 20 mm deep. Fasteners are GH 8 mm full-thread screws with separately configurable lengths for each beam side.

Keywords: `Baufritz`, `GH`, `Verbinder`.

---

## Usage Environment

- **Script Type**: Object (O-Type) -- an independent parametric entity attached to two beams.
- **Space**: Model Space only.
- **Beam Requirement**: Exactly two beams. The entity erases itself if fewer than two beams are referenced.
- **Parametric Behavior**: Recalculates automatically when either linked beam moves or changes.
- **Element Assignment**: If the beams belong to wall, floor, or roof elements, the connector assigns itself to those element groups and manages no-nail zones accordingly.
- **DXA Output**: Enabled. Exports connector dimensions and beam group for hsbExcel BOM reports.

---

## Prerequisites

1. Two timber beams must exist in the drawing forming a valid connection geometry.
2. For T-connections, beams must be within the IntelliSnap search range (default 200 mm).
3. For Length or Parallel connections, you select both beams manually.
4. For Parallel connections, beams must be parallel and in contact (no gap between faces).
5. Beam width must accommodate the selected connector type. Minimum width equals the connector width plus 20 mm (10 mm clearance on each side).

---

## Insertion Workflow

1. Run the GH-Verbinder Top OV command (via TSLINSERT or the hsbCAD toolbar).
2. A dialog appears. Select the **Connection Type**: T-Connection, Length Connection, or Parallel Connection.
3. **T-Connection**: Select one or more beams. The script detects neighboring beams forming valid T-joints using the IntelliSnap capsule intersection method and places a connector at each detected junction. Multiple connectors can be created in one operation.
4. **Length or Parallel Connection**: Select exactly two beams. The script aborts if fewer than two unique beams are chosen.
5. **Parallel Connection** additionally prompts for a reference point to position the connector along the beam length.
6. The connector entity is created. Pocket geometry (House tooling) is milled into both beams. Beam cuts are applied where required.
7. Hardware components are registered in the BOM under manufacturer "GH".

After insertion, adjust properties at any time through the Properties Palette. Right-click for orientation and mounting-stage options.

---

## Properties Panel (OPM Parameters)

### Geometry

| Property | Type | Default | Description |
|---|---|---|---|
| **Type** | Dropdown | Type 40 | Connector width: Type 40, Type 60, Type 80, or Type 100 (40/60/80/100 mm). Length is always 104 mm, depth always 20 mm. |
| **Tooling** | Dropdown | Rounded | Pocket corner treatment: Not Rounded, Rounded, Relief, Rounded with Small Diameter, Relief with Small Diameter. Controls CNC milling corner finish. |
| **Connection Type** | Dropdown | T-Connection | Joint type: T-Connection, Length Connection, or Parallel Connection. Normally set at insertion. |
| **Drill with element** | Dropdown | No | Add a locating mill into the parent element (Zone 1) for assembly positioning. When enabled, a milling pocket and SolidSubtract on intersecting sheets are created. |

### Alignment

| Property | Type | Default | Description |
|---|---|---|---|
| **Offset** | Number | 0 mm | Shift the connector perpendicular to the beam face (Z direction of the beam). |
| **Offset from center** | Number | 0 mm | Lateral offset from beam centerline (Y direction). |

### Multiple Connectors

| Property | Type | Default | Description |
|---|---|---|---|
| **Quantity** | Integer | 1 | Number of connectors at this joint. For quantities above 2, connectors are distributed symmetrically about the beam centerline. |
| **Axis Offset between 2** | Number | 0 mm | Center-to-center spacing between connectors when Quantity is 2 or more. Must be at least equal to the connector width; the script enforces this minimum automatically. |
| **Gap** | Number | 0 mm | Structural gap between beam ends at the joint (shrinkage or tolerance allowance). |
| **Gap applies to** | Dropdown | Male beam | Which beam receives the gap: Male beam, Female beam, or Both beams. |
| **Length - screw female beam** | Number | 100 mm | Screw length for the female (receiving) beam. Affects BOM. |
| **Length - screw male beam** | Number | 100 mm | Screw length for the male (inserted) beam. Affects BOM. |

### General

| Property | Type | Default | Description |
|---|---|---|---|
| **hsbIntelliSnap** | Number | 200 mm | Search range for T-connection auto-detection during insertion. Read-only after placement. |

---

## Right-Click Menu Options

### Orientation Controls

| Command | Description |
|---|---|
| **Flip Side** | For T-connections, toggles an internal flip flag mirroring the connector along the joint axis. For Length and Parallel connections, swaps primary/secondary beam assignment. |
| **Top** | Orients the pocket toward the beam top face. |
| **Bottom** | Orients the pocket toward the beam bottom face. |
| **Right** | Orients to the right side face. Available only for Length and Parallel connections. |
| **Left** | Orients to the left side face. Available only for Length and Parallel connections. |

Double-clicking the connector cycles through orientations (90-degree steps for Length/Parallel; 180-degree steps for T-connections).

### Mounting Stage

Controls when the connector is installed during production. The active option shows a checkmark. Selection affects screw distribution in the BOM between plant and site phases.

| Command | Description |
|---|---|
| **Partial Assembly Plant** | Installed at partial pre-assembly in the factory. |
| **Plant** | Fully installed in the factory (default). |
| **Construction Site** | Installed on-site after delivery. For Baufritz projects, the element milling profile is modified for site-mode CNC output. |

### Badge Display

| Command | Description |
|---|---|
| **Show Badge** | Displays a text label (e.g., "Top OV 60") near the connector. Green for plant production, cyan for on-site. |
| **Hide Badge** | Removes the label. |

---

## Tips and Notes

- **Connector material**: The connector plate is registered as Aluminium in the hardware list. Screws are registered as Steel. The DXA entity-level material description is set to "Steel, zincated."
- **Beam width validation**: If the beam is too narrow for the selected type, a warning is printed at insertion and on each recalculation. Minimum beam width = connector width + 20 mm.
- **Screw hole counts by type**: Type 40 has 3 fastener positions; Type 60 and Type 80 each have 7; Type 100 has 8. These determine total screw quantities in the BOM.
- **No-nail zones**: When assigned to an element, the script adds ElemNoNail exclusion areas to all intersecting elements in the same floor group, preventing automatic nailing or sheet fastening from overlapping the connector area.
- **Element locating mill**: With "Drill with element" set to Yes, a milling operation is added to Zone 1 of the parent element, and a SolidSubtract cuts the pocket opening through any sheathing layers. For Baufritz projects in Construction Site mode, the milling profile matches the full connector outline (HSB-22143).
- **Multiple connectors**: For even quantities, connectors are placed in mirrored pairs. For odd quantities, one sits at center with pairs distributed outward. The Axis Offset property controls spacing.
- **Parallel connection validation**: The script warns if beams are not truly parallel or in contact, but does not erase the entity, allowing correction and recalculation.
- **Baufritz behavior**: When the project identifier contains "Baufritz", the badge is shown by default using the "BF 1.0" dimension style if available.
- **Legacy compatibility**: Connectors from versions prior to 2.7 using the old flip flag are automatically migrated to the current rotation system on first recalculation.
