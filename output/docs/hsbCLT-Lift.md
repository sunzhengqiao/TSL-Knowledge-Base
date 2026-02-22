# hsbCLT-Lift

## Overview

`hsbCLT-Lift` places lifting hardware onto CLT (Cross-Laminated Timber) panels to prepare them for crane lifting on a construction site. The script supports four distinct hardware families:

- **Hebeschlaufe** (Lifting Loop) - standard threaded lifting loop drilled into the face of the panel
- **Rampa** (Ramp Socket) - threaded socket, valid for floor/roof panels only
- **Würth System** - wall-mounted anchor using a notch (BeamCut) or drill depending on subtype
- **Stahlanker** (Steel Anchor) - heavy-duty steel anchor with an additional side drill for the anchor pin

On insertion, the script automatically calculates the required number of devices and their positions on the panel based on the panel area, weight, and orientation. It drills or mills the corresponding geometry directly into the CLT panel solid and registers the hardware as a BOM component for material take-off. Shop drawing symbols (DimRequests) are published so the lifting point appears automatically in panel fabrication layouts.

## Usage Environment

| Property | Value |
|---|---|
| Script type | O-Type (Object - attaches itself to a CLT panel as a linked entity) |
| Works in | Model Space only |
| Beams required | 0 (panels are selected interactively during insertion) |
| Settings file | None (load capacities and geometry are hard-coded per subtype) |

## Prerequisites

- One or more CLT panels (SIP entities) or CLT Elements must exist in the drawing.
- The panels must be assigned an `hsbCLT` property set so that weight and association type can be read automatically. If the property set is absent, the script falls back to a default density of 471 kg/m³ to estimate panel weight.
- Sufficient panel geometry to accommodate the selected edge offset (default 200 mm from the panel edge). Panels that are too small to fit any device will display an error message instead of a drill.

## How to Use

### Step 1: Launch the script

The recommended way is to call the script from a ribbon button, tool palette, or macro that pre-selects the hardware family:

```
^C^C(hsb_scriptinsert "hsbCLT-Lift.mcr" "Standard?Hebeschlaufe")
^C^C(hsb_scriptinsert "hsbCLT-Lift.mcr" "Standard?Rampa")
^C^C(hsb_scriptinsert "hsbCLT-Lift.mcr" "Standard?Würth")
^C^C(hsb_scriptinsert "hsbCLT-Lift.mcr" "Standard?Stahl")
```

The catalog entry string before the `?` character is a description label; the keyword after `?` selects the hardware family. Adding the word `Vorgabe` to the label suppresses the dialog and uses the stored default values:

```
^C^C(hsb_scriptinsert "hsbCLT-Lift.mcr" "Standard Vorgabe?Würth")
```

### Step 2: Configure in the dialog (distribution mode)

A dialog appears allowing you to confirm or adjust the hardware family, subtype, and distribution offset. Click **OK** to continue.

If the entry name contains `Vorgabe`, the dialog is skipped and the preset values are used directly.

### Step 3: Select panels

The command line prompts:

```
Select CLT panels or elements:
```

Select one or more CLT panels or complete CLT elements. The script collects all SIP panels from the selection. Panels that already have a lifting device of the same script attached are automatically skipped and a message is printed to the command line.

### Step 4: Automatic placement

The script calculates the number of devices required per panel (1, 2, or 3 depending on panel size, orientation, and family) and their positions along the longer panel axis at the configured distribution offset (default `1/3` of the panel dimension). Drilling or milling geometry is applied to the panel solid immediately.

### Step 5: Review results

Each device is shown in the model with a cross symbol in the family color (yellow = Hebeschlaufe, green = Rampa, light blue = Würth, dark grey = Steel Anchor) and labeled with the selected subtype name. Review the colors for warnings:

- **Red filled circle** at a device location: the panel weight per device exceeds the maximum rated capacity of the selected subtype. Select a larger subtype or add more devices.
- **Red filled solid projection** (Würth wall anchor only): the milled slot extends outside the panel envelope. Reduce the depth or reposition the anchor.

### Alternative: Single device mode (SINGLE keyword)

To place one device at a precise user-defined point rather than having the script distribute automatically, add `SINGLE` to the catalog entry label:

```
^C^C(hsb_scriptinsert "hsbCLT-Lift.mcr" "Single?Hebeschlaufe")
```

In this mode the command line prompts you to click on the target panel and then specify the insertion point. The device is placed at exactly that location (snapped to the valid placement range inside the edge offset).

## Properties Panel (OPM Parameters)

After insertion, select the device instance and open the **Properties Palette** (Ctrl+1) to adjust its settings. Any change triggers an automatic recalculation of drilling geometry and BOM data.

### Geometry category

| Property | Type | Default | Description |
|---|---|---|---|
| Edge Offset | Double | 200 mm | Minimum distance from any panel edge to the centre of the lifting device. The script snaps device positions to remain inside this boundary. |
| Association | String (list) | Auto | Defines the panel orientation used to orient the drill vector. `Auto` reads the value from the `hsbCLT` property set. `Wall` drills horizontally through the panel face. `Roof/Floor` drills vertically through the top or bottom face. |

### Tooling category

| Property | Type | Default | Description |
|---|---|---|---|
| Type | String (list) | Auto | Selects the specific hardware subtype within the active family (see table below). `Auto` lets the script pick the smallest subtype whose rated capacity covers the calculated load per device. |
| Diameter | Double | 0 mm | Overrides the drill hole diameter. Set to `0` to use the family default (Hebeschlaufe = 30 mm, Rampa = 15 mm, Würth drill = 30 mm, Steel Anchor = 30 mm). |
| Depth | Double | 0 mm | Overrides the drill or slot depth. Set to `0` to use the automatic depth (Hebeschlaufe = full panel thickness, Rampa = 60/70/80 mm by subtype, Würth = 30 mm, Steel Anchor = panel thickness minus 20 mm). |
| Interdistance | Double | 0 mm | Distance between the two drill holes of a double-hole Hebeschlaufe used in floor/roof associations. Set to `0` for a single hole. Only relevant when Association is `Roof/Floor` and Family is `Hebeschlaufe`. |

### Distribution mode only

| Property | Type | Default | Description |
|---|---|---|---|
| Distribution Offset | String | 1/3 | Distance between two adjacent devices in distribution mode. Enter a fraction of the panel dimension (e.g. `1/3`) or an absolute value in drawing units (e.g. `2000`). Set to `0` to place only a single device at the panel centre. |

## Hardware Subtypes and Load Capacities

### Hebeschlaufe (Lifting Loop)

| Subtype | Max load per device (kg) |
|---|---|
| Auto | (selected automatically) |
| H1 | 800 |
| H1.1 | 2000 |
| H2 | 1600 |
| H2.1 | 4000 |

### Rampa (Floor/Roof only)

| Subtype | Max load per device (kg) |
|---|---|
| Auto | (selected automatically) |
| R1 | 600 |
| R2 | 800 |
| R3 | 900 |

### Würth System (Floor/Roof)

| Subtype | Max load per device (kg) |
|---|---|
| Auto | (selected automatically) |
| W1 | 300 |
| W2 | 500 |
| W3 | 800 |

### Würth System (Wall) - Association = Wall

| Subtype | Max load per device (kg) | Notes |
|---|---|---|
| Auto | (selected automatically) | |
| W4 | 600 | Standard wall anchor, drilled from panel edge |
| W4.1 | 600 | Wall anchor with wider BeamCut notch (200 mm wide) |

### Stahlanker (Steel Anchor)

| Subtype | Max load per device (kg) |
|---|---|
| Auto | (selected automatically) |
| S1 | 800 |
| S1.1 | 1200 |
| S2 | 1600 |
| S2.1 | 4000 |

## Right-Click Menu Options

Right-click the placed lifting device instance to access the following context commands:

| Menu Item | Description |
|---|---|
| Change Family | Top-level submenu. Below it, one entry per available family (excluding the currently active one). Clicking a sub-entry switches the device to that family and resets the subtype to `Auto`. Note: `Rampa` is hidden from the list when the panel is a wall. |
| (family names as sub-items) | For example: `   Hebeschlaufe`, `   Würth`, `   Stahlanker`. The leading spaces are part of the internal trigger key. |
| Flip Side | Visible only when the top and bottom surface quality styles of the panel are equal. Toggles the face on which the device is mounted (e.g. switches from the lower to the upper face). |
| Edit in Place | Distribution mode only. Converts the shared distribution instance into individual single-mode instances at each calculated location, allowing each device to be repositioned or configured independently afterward. |
| Set lifting direction | Single mode, Wall association only. Prompts for a point in the desired lifting direction to override the default vertical orientation. Click at the same position as the device to reset to the automatic direction. |

## Tips and Notes

- **Rampa family is for floors and roofs only.** If a Rampa device is placed on a panel that is recognised as a wall (either via the `hsbCLT` property set or by the `Association` property), the script automatically switches the family to Hebeschlaufe and prints a message to the command line.

- **Automatic subtype selection.** When the Type property is set to `Auto`, the script divides the total panel net weight by the number of lifting devices of the same lifting direction (including those placed by other instances on the same panel) and selects the smallest subtype that can carry that load. If no subtype is sufficient, the device is shown in red.

- **BOM registration.** Each device instance registers its hardware components via `HardWrComps` under the category `LiftingDevice`. This data feeds into hsbCAD bill-of-material exports automatically.

- **Shop drawing output.** The script publishes DimRequest entries to the panel's data map. Compatible shop drawing layouts will automatically show the lifting symbol and subtype label on panel fabrication drawings without additional setup.

- **Steel Anchor secondary drill.** The Stahlanker family always creates an additional horizontal drill (17 mm diameter, 400 mm deep) at the bottom of the anchor pocket. This is the side hole required to insert the anchor pin through the panel edge. It is not configurable and is always applied.

- **Würth W4.1 uses a BeamCut, not a drill.** The W4.1 subtype mills a 200 mm wide rectangular notch (BeamCut) into the panel edge instead of a round drill. The Diameter property controls the depth of this notch and the Depth property controls its height.

- **Distribution offset of zero.** If the Distribution Offset property is set to `0`, the script places only one device at the panel centre regardless of the panel size. This is useful for small panels that structurally need only one point.

- **Panels with openings.** The script is aware of openings in CLT panels. It subtracts enlarged opening profiles from the valid placement range so that devices are not placed over holes. For floor/roof panels with openings near the edge, it may fall back to a reduced edge offset (half the configured value) to find a valid position.

- **Grip editing (single mode).** When the device is in single mode, moving the insertion grip (`_Pt0`) snaps the device to the nearest valid point inside the edge offset boundary. The script runs an extra recalculation cycle after grip moves to enforce this snapping.

- **Panel weight fallback.** If the panel has no `hsbCLT` property set or the stored weight value is zero, the script calculates a volumetric weight using the default CLT density of 471 kg/m³. Attach the property set to the panel for accurate load calculations.

- **Version history summary.** The current version (2.4, November 2017) adds the behaviour that a Distribution Offset of exactly `0` results in a single centre device only. Earlier notable changes include the addition of the W4/W4.1 Würth wall subtypes (v2.1–2.2), the optional third Rampa device for large floors (v2.0), and the initial BOM export and Steel Anchor end-drill support (v1.2–1.3).
