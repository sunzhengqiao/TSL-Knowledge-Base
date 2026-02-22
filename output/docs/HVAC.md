# HVAC

## Overview

The HVAC tool is a coordinated suite of five TSL scripts that enables timber frame designers to model, manage, and annotate HVAC ductwork systems directly inside hsbCAD. The parent script **HVAC** converts ordinary structural beams into a managed ductwork system by reading catalog-defined properties from an XML settings file and applying them to a connected chain of beams. Each beam in the chain becomes a duct segment, automatically adopting the correct cross-section (rectangular or round), dimensions, color coding, line type, and airflow direction as defined in the catalog.

During insertion the tool guides the user through an interactive point-picking workflow to route ductwork in plan or 3D. The underlying beams are created automatically and an elbow connector script (HVAC-G) is placed at every change of direction. The resulting system is fully parametric: when any segment moves or is resized, the entire system recalculates and updates flow-direction arrows, plan-view shadow outlines, dimension labels, and hardware/BOM records.

The suite also includes utility scripts for T-branch connections (HVAC-T), inline splits and joins (HVAC-P), and descriptive annotation tags (HVAC-Tag). Together these scripts allow complete HVAC routing documentation within the structural model without leaving AutoCAD or hsbCAD.

---

## Script Suite Overview

| Script | Purpose | Script Type | Beams Required |
|--------|---------|-------------|----------------|
| **HVAC** | Parent controller. Creates ductwork routes, manages the connected system, displays flow arrows and plan shadows, exports hardware data | O (Object) | 0 (creates beams during insertion) |
| **HVAC-G** | Elbow/bend connector. Automatically inserted at every direction change between two duct segments | G (Generic, two-beam connection) | 2 |
| **HVAC-T** | T-branch connector. Links a branch duct to one or two main-run ducts at a perpendicular intersection | T (Tool, two-beam connection) | 2 |
| **HVAC-P** | Split/join utility. Splits one duct beam at a point or rejoins two collinear segments | O (Object) | 0 (prompts for beam selection) |
| **HVAC-Tag** | Annotation tag. Draws a configurable label and flow-direction arrow for a selected HVAC system | O (Object) | 0 (prompts for system selection) |

---

## Usage Environment

| Attribute | Value |
|-----------|-------|
| Script Type | O -- Object (attached to beams, recalculates when beams move) |
| Beams Required at Launch | 0 (beams are created interactively during insertion) |
| Intended Space | Model Space (3D design environment) |
| Settings File | `HVAC.xml` at `<company>\TSL\Settings\` |
| Version | 2.5 (21 November 2018) |
| Author | thorsten.huck@hsbcad.com |
| Unit System | Millimeters (internally converts via `U()`) |
| Display Representations | Supports display-representation switching; plan view shows shadow outlines, model view shows 3D solids or linework |

---

## Prerequisites

1. **Settings catalog**: The file `HVAC.xml` must exist at `<company>\TSL\Settings\HVAC.xml`. This file defines all available duct families and their child entries (dimensions, colors, line types, flow symbols). If the file is missing the tool cannot start.
2. **No pre-existing beams needed**: For standard routing the tool creates beams during the interactive point-picking workflow. Pre-existing beams are only needed when using the BEAMASSIGN workflow (see below).
3. **Dimension style**: The catalog may reference a specific AutoCAD dimension style for labels. Ensure the referenced style exists in the drawing template.

---

## How to Use

### Workflow A -- Inserting a New Ductwork Route (Primary Workflow)

1. **Launch the HVAC script.** Use the toolbar button or command alias configured by your CAD administrator (typically mapped as `hsb_ScriptInsert "HVAC"`).

2. **Select a duct family.** A dialog appears listing the available families from the catalog, sorted alphabetically (for example: Supply Air, Return Air, Exhaust). Click the family that matches the system you are routing.

3. **Select a duct model (child entry).** A second dialog lists the available sizes and types within that family. Pick the appropriate entry. On first use for a given family the tool automatically writes default catalog entries for all child models so that your team can reuse the same settings on subsequent insertions.

4. **Pick the first point.** The command line displays:
   ```
   Select point <Enter> to specify elevation
   ```
   - Click in the drawing to set the starting point. The Z coordinate of the clicked point becomes the working elevation.
   - Alternatively, press Enter to type an elevation value numerically, then click the plan location.

5. **Pick subsequent points to define the route.** The command line displays:
   ```
   Pick next point, <Enter> to change elevation
   ```
   - **Horizontal segment**: Click in plan view. The segment is created at the current working elevation.
   - **Elevation change**: Press Enter, type a new elevation value, and continue clicking. A vertical segment is inserted automatically at the current plan location.
   - **Free 3D mode**: Type `P` and press Enter. Subsequent clicks use the full 3D coordinate of each point. Press Enter again to return to plan mode.
   - **Finish**: Type `E`, or press Enter on an empty prompt to end the route.

6. **First vertical segment orientation.** If the very first segment is vertical (parallel to Z), the tool prompts:
   ```
   Specify width direction, <Enter> = Y-UCS
   ```
   Click a point to indicate the width-face direction. Press Enter to accept the current Y-axis. This prompt is skipped for round ducts.

7. **System creation.** Beams representing duct segments appear in the model. An HVAC-G elbow connector is automatically placed at every change of direction. The parent HVAC instance manages the whole route and displays flow-direction arrows and, in plan view, the duct outline shadow. The insertion instance erases itself after creating the system.

---

### Workflow B -- Assigning HVAC Properties to Existing Beams (BEAMASSIGN)

Use this when beams already exist in the model and you want to label them as ductwork.

1. Launch the HVAC script with the `BEAMASSIGN` command key (for example: `hsb_ScriptInsert "HVAC" "BEAMASSIGN"`).
2. Select the beams you want to assign when prompted.
3. If the selected beams already carry HVAC data (from a previous assignment), the tool pre-selects the matching family and model. Otherwise the family/model selection dialogs appear as described above.
4. A separate HVAC instance is created for each selected beam.
5. The insertion instance erases itself after creating all instances.

---

### Workflow C -- Silent Insertion via Command Key

The tool supports silent (dialog-free) insertion when both the family name and child entry name are provided in the command key, separated by a question mark:

```
hsb_ScriptInsert "HVAC" "Supply Air?200x100"
```

- If only the family name is provided, the family is pre-selected and only the child dialog appears.
- If both family and child are found in the catalog, no dialog is shown at all.
- If the specified name cannot be matched, the full two-step dialog workflow is used as a fallback.

---

### Adding a T-Branch (HVAC-T)

Use this when a duct branch meets a main duct run at a perpendicular angle.

1. Launch **HVAC-T**.
2. Select the **male ductwork** beam (the branch coming in).
3. Select the **female ductwork** beam(s) (the main run; supports one or two parallel female beams). The tool validates that the beams are not parallel to each other and places a T-fitting solid at the intersection.
4. If the branch beam does not already belong to an HVAC system, a new HVAC instance is created for it automatically.

---

### Adding an Elbow Manually (HVAC-G)

Elbows are placed automatically during HVAC insertion. To add one manually between two existing duct beams at a direction change:

1. Launch **HVAC-G**.
2. Select the **first ductwork beam**.
3. Select the **second ductwork beam** (must not be parallel to the first).
4. The elbow geometry is drawn at the intersection. Connection points are published so that the parent HVAC system can trace connectivity through the elbow.

---

### Splitting or Joining Duct Segments (HVAC-P)

Use this to break a duct segment into two at a specific point, or to reconnect two collinear segments that were previously split.

**To split:**
1. Launch **HVAC-P**.
2. Select **one beam**.
3. Click a point on the beam where the split should occur.

**To join:**
1. Launch **HVAC-P**.
2. Select **two collinear, parallel beams** that share an axis.
3. The tool automatically calculates the connection point between them and merges them.

You can repeat the selection loop without relaunching the script. Press Enter with no selection to exit.

---

### Adding a Label Tag (HVAC-Tag)

1. Launch **HVAC-Tag**.
2. Select the HVAC system (beam or HVAC instance) you want to label.
3. Pick a point for the label location.
4. The tag draws the duct name and family information using the format string defined in the **Format** property. Adjust the format in the Properties Palette as needed.

---

## Properties Panel (OPM Parameters)

These parameters appear in the AutoCAD Properties Palette when an HVAC instance is selected.

### HVAC (Parent Script)

| Property | Type | Default | Read-Only | Description |
|----------|------|---------|-----------|-------------|
| **Family** | String list | First catalog family | Yes (after insertion) | The duct family group (e.g., Supply Air, Return Air, Exhaust). Determines the default visual style, color, line type, and the set of available models. The list is populated from the `HVAC.xml` catalog and sorted alphabetically. |
| **Model** | String list | First child in family | No | The specific duct size or type within the selected family. Each model defines its own Width, Height, Diameter, Insulation thickness, and bend Radius. Changing this value updates the beam dimensions and profile accordingly. |

> **Note:** Dimensions (width, height, diameter, insulation) and visual properties (color, line type) are controlled by the catalog entry, not by direct OPM input. To change these, select a different Family or Model.

### HVAC-Tag

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Format** | String | `@(Name)` | Controls the text content of the label. Uses token syntax: `@(Name)` inserts the duct model name, `@(Label)` inserts the family label, and so on. Supports left/right substring, rounding, and tokenizer operators. |

---

## Right-Click Menu Options

Right-click an HVAC instance to access these context-menu commands:

| Menu Item | Description |
|-----------|-------------|
| **-> [Flow Name]** | One entry appears for each alternative flow configuration defined in the catalog (e.g., different supply/return directions). Selecting one switches the active flow to that configuration and updates arrows and colors. |
| **Swap Flow (Doubleclick)** | Reverses the airflow direction arrows on all segments in the system. This can also be triggered by double-clicking the instance. |
| **Set special color** | Prompts for an AutoCAD color index (1--255) to apply a visual override to this duct system, independent of the catalog color. Enter a negative number to remove the override and revert to the catalog color. |
| **3D Ductwork** / **Linework** | Toggles the display between full 3D solid geometry and a simplified 2D centerline representation. The label changes dynamically to reflect the mode that is not currently active. |
| **Erase** | Removes the HVAC script instance and erases all duct beams belonging to this system from the model. This is a destructive action. |

### HVAC-Tag Right-Click

| Menu Item | Description |
|-----------|-------------|
| **Select format variables** | Opens a dialog to browse and insert the available data tokens for the Format property. |

---

## Settings File Structure

The `HVAC.xml` catalog file drives all duct types available in the tool. It must be placed at:

```
<company>\TSL\Settings\HVAC.xml
```

### Top-Level Structure

The file uses the standard `<Hsb_Map>` XML format and contains:

- A **Family[]** list with one or more family entries
- A **Display** section with global rendering settings

### Family Entry Fields

| Field | Type | Description |
|-------|------|-------------|
| `Name` | String | The family label shown in the selection dialog (e.g., "Supply Air") |
| `Color` | Integer | Default AutoCAD color index for the family |
| `LineType` | String | The linetype applied to duct outlines in plan view |
| `LineTypeScale` | Double | Scale factor for the line type |
| `SymbolOffset` | Double | Offset distance of the flow-direction arrow from the beam centerline |
| `SymbolSize` | Double | Size of the flow-direction arrows |
| `ColorText` | Integer | Color index for dimension label text |
| `Child[]` | List | One or more child (model) entries |

### Child Entry Fields

| Field | Type | Description |
|-------|------|-------------|
| `Name` | String | The model name shown in the second selection dialog |
| `Width` | Double | Duct width for rectangular profiles |
| `Height` | Double | Duct height for rectangular profiles |
| `Diameter` | Double | Nominal diameter for round profiles (if present, the duct uses a circular extrusion) |
| `Insulation` | Double | Insulation thickness added around the duct; the displayed cross-section size becomes Diameter + 2 x Insulation |
| `Radius` | Double | Bend radius for elbows at direction changes |
| `Flow[]` | List | One or more flow configurations, each with its own Color, LineType, LineTypeScale, SymbolSize, SymbolOffset, Feed direction, and Name |

### Display Section Fields

| Field | Type | Description |
|-------|------|-------------|
| `TextHeight` | Double | Default text height for labels (default: 100 mm) |
| `DispRepName` | String | Display representation name to use |
| `DimStyle` | String | AutoCAD dimension style for annotation labels |

### Round vs. Rectangular Logic

The catalog entry determines the cross-section type:
- If a `Diameter` value is present and greater than zero, the duct uses a **circular extrusion profile**.
- If only `Width` and `Height` are present, the duct uses a **rectangular extrusion profile**.

---

## Bill of Materials / Hardware Export

The HVAC script automatically registers each ductwork system as a hardware component in the hsbCAD hardware database. The exported record contains:

| Hardware Field | Source |
|----------------|--------|
| **Article Number** | Composed from Family name + Model name + active Flow configuration name |
| **Name** | Family name |
| **Model** | Child/model name |
| **Description** | "Ductwork" |
| **Category** | "HVAC" |
| **Total Length** (`DScaleX`) | Cumulative centerline length of all segments in the connected system |
| **Cross-section width** (`DScaleY`) | Duct width or diameter (including insulation for round) |
| **Cross-section height** (`DScaleZ`) | Duct height or diameter (including insulation for round) |
| **Group** | Assigned from the group membership of the HVAC instance |

This data feeds into the hsbCAD hardware export and BOM reports without any additional manual step. Each time the system geometry changes, the hardware record is updated automatically.

---

## System Connectivity and Master Beam Logic

### How Connectivity Is Traced

The HVAC system uses a recursive MapIO mechanism to discover all beams belonging to a connected ductwork route:

1. Starting from the beam attached to the current HVAC instance (the "base beam"), the script examines all tools connected to that beam.
2. For each connected tool that publishes two connection points (such as HVAC-G elbows), the script identifies the adjacent beam on the other side of the connection.
3. The process repeats recursively until all reachable beams in the chain have been found.
4. For each beam, the flow direction relative to the base beam is calculated and stored (tail/head orientation).

### Master Beam Selection

When multiple beams in a connected chain each have an HVAC instance attached, only one instance acts as the "master" controller:

- The master is the HVAC instance attached to the beam with the **lowest entity handle** among all connected beams that carry an HVAC instance.
- All non-master HVAC instances erase themselves during recalculation.
- If the master beam is deleted, the next beam in handle order becomes the new master and a new HVAC instance is created for it. This keeps the system self-healing when segments are removed.

### System Splitting

If HVAC-P is used to split a duct, or if a beam is deleted from the middle of a route, the parent HVAC instance detects the connectivity change on the next recalculation. Any beams no longer reachable from the master beam are dropped from the system. A new HVAC instance may be created for the disconnected sub-chain if it still contains beams with HVAC data.

---

## Display Modes

The HVAC system supports two display modes, toggled via the right-click context menu:

| Mode | Behavior |
|------|----------|
| **3D Ductwork** (default) | Beams are visible as full 3D solids. In plan view, a shadow profile outline is drawn around all duct segments and elbow connectors. Flow-direction arrows are shown on each segment. |
| **Linework** | Beam solids are hidden (`setIsVisible(false)`). Only centerline segments and flow-direction arrows are drawn. This significantly reduces display complexity in large projects while preserving all data for BOM export. |

In both modes, flow-direction arrows are drawn as small solid arrow shapes on each beam segment. The arrow direction follows the Feed setting from the active flow configuration and respects the Swap Flow toggle.

---

## Tips and Notes

- **Elevation changes during routing**: You do not need to switch to a 3D view to route vertical segments. Type the new elevation value at the prompt and the tool inserts a vertical segment automatically at the current plan location.

- **Linework mode for large models**: Switching a system to Linework mode hides the 3D beam solids and draws only centerlines. This significantly reduces display complexity in large projects while preserving all data for BOM export.

- **Automatic flow detection**: The system traces connectivity between beams via the HVAC-G elbow connectors. If you add or remove a connector, the parent HVAC instance recalculates and updates the flow arrow sequence accordingly. You do not need to re-insert the system.

- **Catalog entries are saved automatically**: The first time HVAC is run for a given family, it writes default catalog entries for all child models. This means your team can reuse the same settings on subsequent insertions without seeing the two-step dialog again.

- **Color overrides**: Use the Set special color context menu option to visually distinguish one HVAC system from others of the same family (for example, marking a problem area or differentiating systems during coordination). The override stores independently of the catalog color and can be removed by entering a negative number.

- **Coordinate system alignment**: When routing, the tool automatically determines the Y and Z axes for each new beam based on the previous beam in the chain. It handles parallel continuation, same-plane bends, vertical transitions, and rising segments. If the first segment is vertical and the duct is not round, you are prompted for the width direction.

- **Group assignment**: The HVAC instance inherits group membership from its attached beam (using the `I` -- inherit flag). This ensures hardware export and BOM reports respect the group hierarchy.

- **Invalid dimensions**: If the catalog entry results in zero-dimension beams (for example, missing Width or Height), the tool reports an error and asks you to check the configuration. The segment is skipped and you can continue routing.

---

## Related Scripts

| Script | Relationship |
|--------|-------------|
| **HVAC-G** | Child script -- automatically created at direction changes during routing |
| **HVAC-T** | Companion tool -- manually placed T-branch connections |
| **HVAC-P** | Companion tool -- split or join duct segments |
| **HVAC-Tag** | Companion tool -- annotation labels with configurable format tokens |
| **HVAC-Copy** | Utility -- copy variant of the HVAC script |

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 2.5 | 21 Nov 2018 | Minor bugfix reading settings |
| 2.4 | 20 Nov 2018 | Bugfix purging references on splitting a system |
| 2.3 | 25 Oct 2018 | Coordinate systems fixed; new prompt to align first vertical segment; tag data published |
| 2.2 | 09 Aug 2018 | Parent reference set to child; hardware export added; linework display corrected |
| 2.1 | 08 Aug 2018 | Automatic creation of default catalog entries |
| 2.0 | 08 Aug 2018 | Dialog behaviour improved |
| 1.9 | 07 Aug 2018 | Renamed to HVAC; OPM names introduced |
| 1.8 | 20 Jun 2018 | References published |
| 1.7 | 19 Jul 2018 | Automatic detection and flow recognition enhanced; commands to add, remove and combine are now obsolete |
| 1.6 | 17 Jul 2018 | Sequencing further enhanced; new custom command to combine two systems; new custom command for color override |
| 1.5 | 21 Jun 2018 | Sequencing of system enhanced |
| 1.3 | 20 Jun 2018 | Initial version |
