# hsbMassElementTool

## Overview

`hsbMassElementTool` turns generic 3D solid primitives (MassElements) into parametric machining operations on timber beams. After you insert the script, it reads the shape of each selected MassElement and automatically creates the corresponding tool:

- **Cylinder MassElement** → **Drill** (the cylinder's axis and radius define the hole)
- **Box MassElement** → **BeamCut** or **Slot** (the box dimensions and position define the cut volume)

The tool is persistent: if a linked beam moves or rotates, the right-click "Alignment Dependency" feature can move the MassElements with it so that all machining positions stay correct. Tools can be added or removed at any time through the right-click context menu without reinserting the script.

This script is intended for advanced workflows where the connection geometry is already modelled as MassElements (for example, imported from a structural analysis model or placed manually as construction aids) and needs to be translated into hsbCAD machining operations.

## Usage Environment

| Property | Value |
|---|---|
| Script type | O-Type (Object / persistent entity) |
| Works in | Model Space only |
| Beams required at insert | 0 (selected interactively during insertion) |
| Minimum beams for E-Type | 1 |
| Minimum beams for T-Type | 2 (one male, one or more female) |

## Prerequisites

- At least one `GenBeam` (timber beam) must already exist in the drawing.
- One or more `MassElement` entities (Cylinders or Boxes) must already be placed at the correct positions and orientations in 3D space. Their geometry (radius, width, depth, height) directly determines the resulting tool dimensions — the script does not resize them.
- For T-Type connections, both the male and female beams must be modelled and accessible for selection.

## How to Use

### Step 1: Start the insertion

Run `TSLINSERT` and choose `hsbMassElementTool.mcr`, or use the hsbCAD script toolbar.

### Step 2: Choose the connection type

A small dialog box appears with a **Connection Type** dropdown. Select the type that matches the structural relationship between the beams:

| Option | When to use |
|---|---|
| **E-Type** | The tool applies to one beam or a group of parallel beams (end or edge connection). |
| **T-Type** | Two beams meet at a T-junction. The script also automatically cuts the male beam flush against the female beam. |
| **O-Type** | Any other geometry. No automatic beam cut is applied; all machining is defined manually by the MassElements. |

Click **OK** to proceed.

### Step 3: Select beam(s)

- **E-Type**: A selection prompt appears. Click one or more beams to be machined. Press **Enter** when done.
- **T-Type**: Two separate prompts appear:
  1. `Select Male Beam` — click the beam that will be cut flush (the stub).
  2. `Select female Beam(s)` — click the beam(s) it connects to. Press **Enter** when done.
  3. `Select point on stretching plane` — click a point in 3D space on the face where the male beam meets the female beam. This point defines the cutting plane for the automatic end trim.
- **O-Type**: No beam selection prompt at this stage; beams are assigned per MassElement group in the next step.

The script aborts with a notice if the required number of beams is not selected.

### Step 4: Assign MassElements to beams (repeating loop)

The script enters a loop. In each iteration:

1. `Select MassElements` — draw a selection window around one or more **Cylinder** MassElements that belong to a single target beam. Only Cylinders are accepted here (Boxes are added via the right-click menu later).
2. `Select Beam` — click the beam these MassElements should drill into.
3. `Depth <0> (0=complete through)` — type the drill depth in millimetres and press **Enter**, or press **Enter** directly for a through-hole (depth = 0).

The loop repeats until you press **Enter** at an empty selection. Each iteration adds a new beam-to-MassElement relation that is stored in the script's internal map.

If no valid Cylinder MassElements were collected in any iteration, the script erases itself and cancels.

### Step 5: Script is placed

The script entity (`TslInst`) is placed at the centre of the first collected MassElement. The tools are immediately applied to the beams. A colour-3 (green) display shows the drill circles and cut lines for visual feedback.

## Properties Panel (OPM Parameters)

`hsbMassElementTool` does not expose editable properties in the AutoCAD Properties Palette after insertion. All parameters (connection type, beam relations, MassElement relations, depths) are stored internally in the script's `_Map` and are managed exclusively through the right-click context menu.

The **Connection Type** is chosen only once at insertion time and cannot be changed afterwards without reinserting the script.

## Right-Click Menu Options

Right-click the placed script entity to access the following operations:

| Menu Item | Applicable MassElement Shape | Description |
|---|---|---|
| **Add/Remove Drills** | Cylinder | Select a beam and then one or more Cylinder MassElements. If a Cylinder is not yet associated with that beam, it is added as a new Drill relation (depth prompt appears). If it is already associated, it is removed. |
| **Add/Remove Beamcut** | Box | Select a beam and then one Box MassElement. Adds a volumetric BeamCut using the full box dimensions. If already present for that beam, it is removed. |
| **Add/Remove Slot** | Box | Select a beam and then one Box MassElement. Adds a Slot tool. A depth prompt appears (default = the MassElement's height; enter 0 for a through-slot). If already present, it is removed. |
| *(separator)* | — | Visual divider in the menu. |
| **Add/Remove Alignment Dependency** | Any | Links a group of MassElements to a beam's coordinate system. When the beam moves or rotates, the script automatically transforms the MassElements to follow, keeping all tool positions correct after model updates. Prompts: (1) `Select base point` — a pivot point for the rotation, (2) `Select Beam` — the reference beam, (3) `Select MassElements` — the MassElements to track. |

### Toggle behaviour (Add/Remove)

All four active menu items work as toggles. Selecting a MassElement that already has a relation for the chosen operation **removes** that relation; selecting one that does not yet have a relation **adds** it. This means you can correct mistakes without reinserting the script.

## Tips and Notes

- **Shape determines tool type.** Cylinder = Drill only. Box = BeamCut or Slot only. If you select the wrong shape for a menu item, the script silently skips it.
- **Through-hole shortcut.** Enter `0` for depth at any prompt to make the drill or slot pass completely through the beam. The script then uses the beam's own cross-section depth as the actual cutting depth.
- **Drill axis projection.** For Drills, the script projects the cylinder's axis onto the beam's face normal and uses that projected direction. If the cylinder axis is not parallel to the beam face normal, the drill is skipped (`continue`). Make sure your Cylinder MassElements are oriented perpendicular to the intended drilling face.
- **T-Type automatic cut.** When two non-parallel beams are connected in T-Type mode, the script computes a cutting plane from the male beam's axis and the reference point you clicked, and applies a `Cut` tool to the male beam automatically. This trims the male beam flush without needing a separate Box MassElement.
- **Alignment Dependency for moving models.** If you expect beams to be repositioned or rotated later (for example, during layout adjustments), use **Add/Remove Alignment Dependency** immediately after insertion. Without it, the MassElements stay in world-space coordinates and the tools will be applied at the wrong positions after the beam moves.
- **MassGroup for MetalPart behaviour.** If you apply an hsbCAD MassGroup to the MassElements, the script gains MetalPart behaviour: the tools appear in the Bill of Materials and are treated as hardware items rather than plain geometry modifications.
- **Debug mode.** If the company's `hsbTSLDebugController` map object lists this script by name, verbose diagnostic messages are printed to the command line and intermediate geometry (vectors, axes) is visualised in colour on screen.
- **Script self-erases on invalid state.** If the beams linked at insertion are later deleted or the drawing is opened in a context where they are unavailable, the script erases itself and prints a notice. Re-insert if needed.
- **Keywords for search.** This script is tagged with the keywords `Metalpart`, `Tool`, `Masselement`, `Massgroup` and can be found by these terms in the hsbCAD script browser.
