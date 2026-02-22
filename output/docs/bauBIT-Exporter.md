# bauBIT-Exporter

## Overview

bauBIT-Exporter writes extended machining and geometry data from hsbCAD panels into a format understood by the bauBIT production management system, then calls the bauBIT exporter to generate the output file. For every SIP (Structural Insulated Panel / panel) in the selection, the script analyses all machining operations -- drills, angled cuts, and beam-housing recesses -- stores that data back onto the panel entity as a structured sub-map, and hands everything to the configured bauBIT exporter group.

The script erases itself from the drawing immediately after the export completes; it leaves no permanent geometry in the model.

## Usage Environment

| Property | Value |
|---|---|
| Script type | O-Type (Object / runs once on insert) |
| Works in | Model Space only |
| Beams required | 0 |
| Version | 1.6 (22 Dec 2017) |
| Units | Millimetres (set internally) |
| Settings | bauBIT Exporter Group defined in ModelMap (project settings) |

### Version History

| Version | Date | Description |
|---|---|---|
| 1.0 | 27 Jan 2014 | Initial release |
| 1.1 | 17 Nov 2014 | Cut normals are exported as cuts |
| 1.2 | 27 Jan 2015 | Element, beam and electrical output added |
| 1.3 | 15 Apr 2015 | Bugfix for spline beam output and rabbet length calculation |
| 1.4 | 22 Nov 2017 | Bugfix for beamcut length |
| 1.5 | 08 Dec 2017 | Bugfix for beamcut length (enhanced) |
| 1.6 | 22 Dec 2017 | Debug code removed for production release |

## Prerequisites

Before running bauBIT-Exporter:

1. At least one **bauBIT Exporter Group** must be configured in the hsbCAD project's ModelMap settings. The script reads the list of available groups via `ModelMap().exporterGroups()`. If no group is found the script aborts with an error message.
2. The model must contain one or more of the following entity types: Elements, MasterPanels, ChildPanels, SIPs, GenBeams, or TslInst objects.
3. The drawing must be saved so that a valid drawing path (`_kPathDwg`) exists. This path is used as the export output folder.

## How to Use

### Step 1 -- Launch the script

Run **TSLINSERT** (or use the hsbCAD toolbar) and select **bauBIT-Exporter**. The script starts immediately on insert.

### Step 2 -- Choose Exporter Group (conditional)

The script retrieves all configured Exporter Groups from the ModelMap and sorts them alphabetically.

- **Multiple groups defined**: A dialog appears automatically so you can pick the correct configuration.
- **Exactly one group defined**: That group is used directly; no dialog is shown.
- **No groups defined**: The script displays the notice _"Please define an Exporter Group first and try again."_ and cancels. Contact your CAD manager to set up the ModelMap configuration.

### Step 3 -- Select objects

```
Command line prompt:
Select object(s) <Enter> to select all:
```

- Click individual walls, panels, or elements to limit the export to a subset of the project.
- Press **Enter** without selecting anything to auto-collect **all** valid entities from Model Space. The auto-collection gathers the following entity types: GenBeams, Elements, TslInsts, ChildPanels, and MasterPanels.

After selection the script performs several expansion and filtering steps:

1. **MasterPanel expansion** -- Every selected MasterPanel is expanded to include all its nested ChildPanels. Each ChildPanel's associated SIP entity is appended to the working set.
2. **Element expansion** -- Every selected Element is expanded to include all its associated SIPs.
3. **Beam type filter** -- Only beams of type `_kPanelSplineLumber` (spline-lumber) pass through. All other beam sub-types and dummy beams are silently removed.
4. **Parent element collection** -- For each SIP in the final set, the script also finds and appends its parent Element (if valid and not already in the set). This ensures the exporter receives complete element-level context.

### Step 4 -- Automatic analysis and export

For each SIP in the final selection set the script delegates per-panel analysis via a MapIO call (the script calls itself with the SIP reference, so the analysis logic runs once per panel). The analysis covers three categories of machining data:

#### Drills

- Collects all `AnalysedDrill` operations from the SIP.
- Groups drills by diameter and depth. Drills with the same diameter and depth (within 0.1 mm tolerance) are merged into a single entry with a Quantity counter.
- Excludes drills belonging to lifting devices or electrical installations (identified by their sub-map keys `LiftingDevice` and `Electrical`).
- Depth values are rounded to one decimal place (0.1 mm precision).

#### Cuts

Cuts are collected from two sources and merged into a single list:

1. **Analysed tool cuts** -- All `AnalysedCut` operations attached to the SIP. For each cut the bevel angle is computed as the angle between the cut normal and the SIP's Z-axis. Perpendicular cuts (bevel = 90 degrees) are skipped. Cuts with codirectional normal vectors are deduplicated so that each unique cutting plane appears only once.

2. **SIP edge cuts** -- The SIP's edge geometry is inspected independently. Edges perpendicular to the SIP's Z-axis are ignored. Edges that were already captured by the analysed-tool pass (same normal and position within tolerance) are skipped. Edges that intersect the SIP body in a way that indicates a beam housing rather than a cut are also skipped. For each remaining edge the bevel angle and length are measured from the extracted contact face on the SIP body.

All cut entries are ordered by bevel angle (smallest first).

#### Beam-Housing Recesses (BeamCuts)

- Collects all `AnalysedBeamCut` operations from the SIP.
- Sorts beamcuts by volume (largest first) before processing, so that larger housings are analysed before smaller ones.
- Only beamcuts whose free face is aligned with the SIP's main face (top or bottom) are processed; others are skipped.
- For certain tool sub-types (`SimpleHousing` and `OpenDiagonalSeatCut`) the script performs an advanced edge-intersection analysis:
  - It finds all SIP edges that intersect the beamcut bounding box.
  - When intersecting edges are found the beamcut solid is decomposed along those edges, producing separate sub-bodies for each portion.
  - Each sub-body is measured independently and classified as a **Dado** (groove closed on both Y sides) or a **Rabbet** (open on one Y side) based on which faces of the bounding quader are free.
  - Sub-bodies are ordered by volume (largest first) and processed sequentially until the envelope volume is consumed.
- For all other tool sub-types (`Dado`, `DiagonalSeatCut`, `Rabbet`, `HousingThroughout`, `HouseRotated`, and generic beamcuts) a simpler classification is used based on the tool sub-type name.
- The largest of the Length and Width dimensions is always assigned as the Length value.
- All beamcut entries are ordered by depth/height (shallowest first).

#### Export Execution

After all SIPs are annotated the script composes a ModelMap and calls `ModelMap().callExporter(...)` with the selected Exporter Group and the current drawing folder as the destination. The following export flags are enabled automatically (all default to FALSE in hsbCAD):

| Flag | Set by this script |
|---|---|
| Solid info | TRUE |
| Analysed tool info | TRUE |
| Element tool info | TRUE |
| Construction tool info | TRUE |
| Hardware info | TRUE |
| Roof planes above walls and roof sections | TRUE |
| Collection definitions | TRUE |

A `mapProjectInfoOverwrite` parameter is available in the code for overriding project info keys (such as project revision or drawing path), but it is left empty by default.

### Step 5 -- Script removes itself

Once the exporter call returns the script instance is automatically erased from the drawing. No manual clean-up is needed. If the exporter call fails, a message is printed to the command line, but the instance still erases itself.

## Properties Panel (OPM Parameters)

| Property | Type | Default | Description |
|---|---|---|---|
| Exporter Group | Dropdown (PropString) | First group in alphabetical list | Selects which bauBIT export configuration to use. The list is populated from all configured Exporter Groups in the ModelMap and sorted alphabetically. The dialog is only shown when multiple groups are defined. |

## Right-Click Menu Options

None. This script does not define any context-menu entries.

## Machining Data Written to Each Panel

The script stores a `Tool[]` sub-map on every processed SIP before export. Each entry in the map uses the following structure:

| Tool Type | Fields Written |
|---|---|
| Drill | Type = "Drill", Diameter (mm), Depth (mm, rounded to 0.1 mm), Quantity (count of identical drills) |
| Cut | Type = "Cut", Bevel (degrees, unit-tagged as angle), Length (mm, unit-tagged as length) |
| Beamcut | Type = "Beamcut", Length (mm), Width (mm), Height (mm) -- all unit-tagged as length |

**Deduplication rules:**
- Drill entries with the same diameter and depth are merged into a single entry with a cumulative Quantity counter.
- Cut entries with codirectional normal vectors are deduplicated (only the first occurrence is kept).
- Beamcut entries are not deduplicated but are ordered by height/depth (shallowest first).

## Debug Mode

The script has a built-in debug mode for advanced troubleshooting (not for normal production use):

**Activation methods (any one of the following):**
- The hsbCAD debug flag `_bOnDebug` is true.
- The project special string (accessible via `projectSpecial()`) contains "DEBUGTSL" or the script name (case-insensitive).
- At the selection prompt, select a single SIP as the first entity and use the execute key "DEBUG".

**Debug mode behaviour:**
- The script remains inserted in the drawing instead of erasing itself.
- For the selected SIP, visual overlays are drawn directly in the 3D model:
  - **Drills**: Circles at drill locations. Top-face drills are shown in green (colour 3); through-drills are also green and projected to the top face; bottom-face drills are shown in cyan (colour 6) with a rotated cross marker. Diameter and depth labels are displayed next to each drill.
  - **Cuts**: Lines along the cutting edge, projected to the visible face. Length and bevel angle are labelled (e.g. "245.50/12.30 degrees"). Front-face cuts are drawn in continuous linetype; back-face cuts in dashed linetype.
  - **Beam housings**: Filled profile overlays for housing-throughout and house-rotated types, with labels indicating "Dado", "Rabbet", or "Beamcut" followed by Length x Width x Height dimensions. Angle, bevel, and twist values are shown when non-zero.
- The envelope body (gross) is shown in green (colour 3) and the net body (openings subtracted) is shown in magenta (colour 6).
- Analysis progress messages are printed to the command line for each SIP processed.

## Tips and Notes

- **Exporter Group must be configured first.** The script will not run without at least one group. This is a one-time project setup task performed by the CAD manager in the hsbCAD project/ModelMap settings.
- **Pressing Enter at the selection prompt exports the entire project.** This is the most common workflow when preparing a complete set of production files.
- **Only SIPs receive machining analysis.** Beams and Elements in the selection are used to find their associated SIPs; the beams themselves are not analysed for tooling data.
- **Supported beam type filter.** Only spline-lumber beam types pass the filter. All other beam sub-types and dummy beams are silently removed from the selection before processing.
- **The export destination folder is the current drawing folder.** Ensure the drawing is saved to the correct project location before running the exporter.
- **Lifting device and electrical drill holes are excluded** from the tooling summary written to the SIP. These are tracked separately by their respective sub-systems.
- **Re-running the script overwrites the `Tool[]` sub-map** on affected SIPs with freshly analysed data, so the export always reflects the current model state.
- **Tolerance value.** The script uses a tolerance of 0.1 mm for geometric comparisons (drill grouping, cut deduplication, and edge intersection tests).
- **Multi-lump beamcuts.** When a beamcut body intersects the panel envelope and produces multiple separate lumps, the script recomposes them into a single bounding box for measurement. This prevents fragmented housings from producing incorrect dimensions.
- **Catalog/execute key support.** The script supports the standard hsbCAD catalog mechanism via `setPropValuesFromCatalog(_kExecuteKey)`, allowing it to be launched with pre-set property values from a toolbar button or script call.
