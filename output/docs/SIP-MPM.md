# SIP-MPM

Creates optimized master panels by nesting multiple SIP (Structural Insulated Panel) child panels together. The tool automatically analyzes panel dimensions and arranges child panels within standard stock-size master panels to maximize material utilization and minimize waste in prefabricated timber panel production.

## Overview

SIP-MPM (SIP Master Panel Manager) is a multi-phase nesting optimization tool for SIP panel production workflows. Given a selection of SIP panels, child panels, or existing master panels, it automatically determines the best arrangement of child panels within master panels of predefined stock sizes. The tool employs a six-phase nesting algorithm that progressively handles panels from constrained (panels that can only fit one way) to flexible (panels that can be freely arranged), ensuring optimal yield at each step.

The tool operates as a self-managing system that creates subordinate TSL instances for individual master panels and an overall summary instance, forming a parent-child hierarchy of tool instances in the drawing.

**Key Capabilities:**
- Automatic creation and optimization of nested master panels from child panels
- Six-phase nesting algorithm that processes panels from most constrained to least constrained
- Painter-based filtering and grouping to organize panels by material, thickness, or other criteria before nesting
- Configurable minimum yield threshold to control material waste acceptance
- Stock size management for defining allowed master panel dimensions per style
- Automatic style-based separation when panels of multiple styles are selected
- Per-master and overall yield reporting with visual feedback
- Import/Export of settings for consistent production workflows

## Usage Environment

| Property | Value |
|----------|-------|
| Script Type | O-Type (Object) |
| Requires Beams | No |
| Grip Points | 0 |
| Model/Paper Space | Model Space |
| Version | 1.1 |
| Author | Thorsten Huck |
| Unit System | Millimeters (mm) |

## Prerequisites

Before using SIP-MPM, ensure the following conditions are met:

1. **Master Panel Styles** must be configured in the drawing. The tool maps SIP panel styles to master panel styles by name (with optional "SIP" suffix convention).
2. **Stock Sizes** must be defined for each master panel style. Without stock sizes, the tool enters a setup mode prompting configuration.
3. **Child Panels** or **SIP Panels** should already exist in the drawing. The tool can accept SIP panels (and will create child panels from them), existing child panels, or existing master panels as input.
4. **Optional:** Create a Painter Definition collection named "SIP Nesting" to provide custom filtering and grouping options. If this collection exists, only its painters appear in the painter selection list; otherwise, all available painters are shown.

## Step-by-Step Usage Guide

### Initial Setup (First Use)

1. Insert the SIP-MPM tool into your drawing.
2. If no stock sizes are configured in the settings file, the tool enters setup mode and displays a message explaining that stock sizes must be configured.
3. Right-click the tool instance and select **Add Stock Sizes**.
4. When prompted, select existing master panels whose dimensions represent your allowed stock sizes.
5. The tool reads each selected master panel's style, length, and width, then stores these dimensions as available stock sizes.
6. If you have only one style configured but multiple master panel styles exist in the drawing, use **Clone Stock Sizes** from the right-click menu to copy the sizes from the first style to all other master panel styles.

### Standard Nesting Workflow

1. **Insert the Tool:**
   - Type `SIP-MPM` in the AutoCAD command line, or use the hsbCAD menu to insert the script.

2. **Configure Parameters:**
   - A properties dialog appears with filter/grouping and nesting settings.
   - Set the **Painter** to group panels by specific criteria (optional; defaults to Disabled).
   - Choose **Sort Direction** to control the ordering within painter groups (Ascending or Descending).
   - Set **Minimal Yield %** to define the lowest acceptable material utilization (default: 80%).
   - Adjust the **Gap** between child panels within a master panel (default: 8 mm, typically matching saw blade kerf).

3. **Select Entities:**
   - Select any combination of SIP panels, child panels, and/or existing master panels.
   - SIP panels without an existing child panel association will have child panels created automatically.
   - Child panels from selected master panels are extracted and the original master panels are removed, allowing re-nesting.

4. **Specify Insertion Point:**
   - Click to define where the nested master panels will be placed in the drawing.

5. **Automatic Processing:**
   - If a painter is active, panels are first sorted and grouped by the painter definition.
   - If multiple panel styles are detected, the tool creates separate processing instances per style.
   - The six-phase nesting algorithm runs, creating master panels at the specified location.
   - Each master panel receives its own subordinate TSL instance that displays panel labels and yield information.
   - An overall summary instance is created showing the combined yield across all master panels.

### Running Nesting on an Existing Instance

After the initial setup, you can re-run the nesting process on an individual master panel instance:
- **Double-click** the master panel's TSL instance, or
- **Right-click** and select **Nesting**.

This triggers the nester to re-optimize child panel placement within that specific master panel.

## Properties Panel Parameters

### Filter + Grouping Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Painter | String (dropdown) | \<Disabled\> | Selects a painter definition to filter and group entities before nesting. If a painter collection named "SIP Nesting" exists, only painters from that collection are listed. Otherwise, all available painter definitions are shown. When disabled, panels are processed in selection order. |
| Sort Direction | String (dropdown) | Ascending | Controls the sorting order within painter-based groups. Options: Ascending, Descending. Only effective when a painter is selected. |

### Nesting Category

| Parameter | Type | Default | Unit | Description |
|-----------|------|---------|------|-------------|
| Minimal Yield % | Double | 80 | % (unitless) | The minimum acceptable yield percentage for a master panel. Nesting results below this threshold are rejected and the panels are passed to subsequent nesting phases. A value of zero dispatches all panels to the nester regardless of yield. |
| Gap | Double | 8 | mm | The spacing between child panels within a master panel. This value accounts for the saw blade kerf during production cutting. Adjust based on your specific production equipment. |

### Display Category

| Parameter | Type | Default | Unit | Description |
|-----------|------|---------|------|-------------|
| Format | String | @(ElementNumber:D)\n@(Style)\n@(SolidLength:RL0)x@(SolidWidth:RL0) | -- | Format string controlling how child panel properties are displayed as labels on the nested layout. Supports standard hsbCAD format tokens for panel properties. |
| Dimstyle | String (dropdown) | (Drawing default) | -- | The dimension style used for text display on the nesting layout. Lists all available dimension styles from the current drawing. |
| Text Height | Double | 60 | mm | Height of the label text displayed on child panels within the nesting layout. The summary instance uses a larger text height of 500 mm. |

## Right-Click Menu Options

| Menu Item | Context | Availability | Description |
|-----------|---------|--------------|-------------|
| **Add Stock Sizes** | Root | Always | Prompts the user to select existing master panels. Reads their style, length, and width, and stores these dimensions as available stock sizes for nesting calculations. Duplicate sizes are automatically detected and skipped. |
| **Clone Stock Sizes** | Root | When exactly one style has sizes defined and multiple master panel styles exist | Copies the stock sizes from the single configured style to all other master panel styles in the drawing. Useful for initial setup when all styles share the same available sheet sizes. |
| **Nesting** | Root | On child panel mode (mode 0) and master panel mode (mode 1) instances | Triggers the nesting algorithm for the associated child panels. Also activated by double-clicking the tool instance. |
| **Apply Numbers** | Root | On summary mode (mode 2) instances | Assigns sequential numbering to all master panels managed by this summary instance. Numbers continue from the highest existing master panel number in the drawing. |
| **Import Settings** | Context submenu | When a settings file exists at the company path | Reads the XML settings file and replaces the current in-drawing settings with the file contents. |
| **Export Settings** | Context submenu | When settings exist in the drawing | Writes the current settings to the XML file at the company path. Prompts for confirmation if the file already exists. |

## Settings Files

### File Location

Settings are stored in XML format and searched in the following order:

| Priority | Path |
|----------|------|
| 1 (Primary) | `[hsbCAD Company]\TSL\Settings\SIP-MPM.xml` |
| 2 (Fallback) | `[hsbCAD Install]\Content\General\TSL\Settings\SIP-MPM.xml` |

On first insertion, the tool searches for the settings file, reads it, and creates an in-drawing MapObject (`hsbTSL/SIP-MPM`) for persistent storage. Subsequent recalculations use the MapObject directly.

### Settings Structure

The XML settings file uses the standard `<Hsb_Map>` format and contains:

- **Style[]** -- Array of master panel styles, each containing:
  - **Name** -- The master panel style name (matched case-insensitively to SIP panel styles)
  - **Size[]** -- Array of allowed stock sizes for this style:
    - **dX** -- Length of the stock panel (always stored as the larger dimension)
    - **dY** -- Width of the stock panel (always stored as the smaller dimension)
- **GeneralMapObject\Version** -- Version number for compatibility checking

### Version Validation

When a new instance is created (`_bOnDbCreated`), the tool compares the version number stored in the drawing's MapObject against the version in the installation settings file. If they differ, a notice is displayed informing the user of the version mismatch, including both version numbers and file paths.

## Nesting Algorithm

The tool uses a six-phase nesting algorithm. Each phase targets a specific category of panels, progressing from the most constrained (panels with limited placement options) to the least constrained (remaining panels placed freely). Panels successfully nested in earlier phases are excluded from later phases.

### Phase 1: Unique Width Panels

Identifies child panels whose smaller dimension (width) leaves insufficient remaining space in the master panel's width direction for any other panel to fit alongside. These panels can only be nested one-per-width and are assigned to master panels individually. Panels that are also unique in the length direction (identified in Phase 2 pre-check) receive automatic acceptance at 100% effective yield because no further optimization is possible.

Each qualifying panel is matched to the best-fitting stock size based on length yield (panel length divided by master length). A master panel is created for each panel that meets the minimum yield threshold.

### Phase 2: Unique Length Panels

Processes child panels whose larger dimension (length) prevents any other panel from being nested alongside in the length direction. These panels are submitted to the rectangular nester to find optimal width-direction arrangements.

The nester is called iteratively: for each run, the best-yield result is accepted if it meets the minimum yield threshold (with an adjustment for panels that were also flagged as unique-width in Phase 1). Accepted panels are transformed into their master panel positions and removed from subsequent phases.

### Phase 3: Unique Length with Remaining Items

Takes the remaining unique-length panels from Phase 2 and combines them with all remaining un-nested panels. For each unique-length panel, the tool reserves a protected area matching the panel's width, places the panel first, then nests additional remaining panels into the leftover space. This phase maximizes utilization of master panels that must accommodate a large unique-length panel.

### Phase 4: Non-Rotatable Panels

Handles panels whose larger dimension exceeds all available stock widths, meaning they cannot be rotated within a master panel. These panels are combined with panels identified as singular in the width direction and nested together using the rectangular nester.

Yield calculation for this phase uses full-width estimation: the area calculation assumes each child occupies the full width of the master, providing a more realistic yield estimate for strip-like arrangements.

### Phase 5: Similar Length Groups

Groups all remaining panels by their larger dimension (length). Within each group of panels sharing the same length, the nester attempts to fill master panels by stacking panels side by side. This phase efficiently handles sets of panels cut from the same specification.

Groups with fewer than two panels are skipped. The internal yield threshold for this phase is set to 75%.

### Phase 6: Left Over Nesting

Processes all remaining un-nested panels as a single pool, ordered by area (largest first). The rectangular nester attempts to fit as many panels as possible into each master panel. The yield threshold progressively relaxes: if a nesting result's yield is lower than the previous best, that lower value becomes the new threshold for subsequent attempts.

### Summary

After all phases complete, the tool creates a summary TSL instance (mode 2) that references all created master panels and displays the overall combined yield percentage. Panels that could not be nested within the yield constraints remain as standalone child panels.

## Internal Modes

The tool creates multiple TSL instances with different internal modes to manage the nesting hierarchy:

| Mode | Name | Purpose |
|------|------|---------|
| 0 | Child Panel Mode | Manages a collection of child panels for a single style. Runs the six-phase nesting algorithm. Splits into per-style instances if multiple styles are present. |
| 1 | Master Panel Mode | Manages an individual master panel and its nested child panels. Displays child labels, yield, and stock size indicators. Supports re-nesting via double-click or context menu. |
| 2 | Summary Mode | Manages the collection of all created master panels. Displays overall yield. Supports applying sequential numbers to master panels. |
| 3 | Setup Mode | Displayed when no stock sizes are configured. Shows a setup message guiding the user to use the Add Stock Sizes command. |
| 4 | Painter Grouping Mode | Intermediate mode that separates panels into painter-based groups and creates mode-0 instances for each group. |

## Tips

1. **Define Multiple Stock Sizes:** Providing several stock sizes per style gives the nesting algorithm more flexibility and typically produces higher yields. For example, defining both 5500x1220 mm and 4000x1220 mm sizes allows the algorithm to choose the better fit for each panel combination.

2. **Use Painters for Production Grouping:** Create painter definitions in the "SIP Nesting" collection to pre-filter panels by material, thickness, or production batch. This ensures only compatible panels are nested together.

3. **Start with 80% Minimum Yield:** The default 80% threshold provides a good balance between waste reduction and complete panel coverage. Lower this value only if you need to accept more panels with less efficient nesting, or set to 0 to nest all panels regardless of yield.

4. **Gap Setting for Saw Kerf:** The default 8 mm gap corresponds to a standard saw blade kerf. Adjust this value to match your specific CNC or panel saw specifications.

5. **Batch Processing for Best Results:** Select all panels at once rather than processing in small batches. The algorithm achieves better overall yield when it has a larger pool of panels to optimize from.

6. **Review Yield Indicators:** Each master panel instance shows its individual yield percentage. The summary instance shows the overall yield. Yield values displayed in red (color 1) indicate they fall below the minimum threshold.

7. **Re-Nesting:** If child panels are moved or modified, double-click the master panel's TSL instance or use the Nesting context menu to re-run the optimization.

8. **Layout Management:** Master panels are arranged in columns at the insertion point. After every 20 master panels, the layout wraps to a new row to keep the display manageable.

## FAQ

**Q: Why does the tool show "Could not find any stock sizes for style"?**

A: The master panel style referenced by the SIP panels has no stock sizes configured. Use the "Add Stock Sizes" right-click menu option and select existing master panels whose dimensions represent the available stock sheet sizes. If no stock sizes exist at all, the tool falls back to a default size of 5500 x 1220 mm.

**Q: Can I nest panels of different styles together?**

A: No. When multiple styles are detected in the selection, the tool automatically creates separate instances (mode 0) for each style and processes them independently. Each master panel contains only child panels matching its style.

**Q: What happens if a panel is too large for any defined stock size?**

A: Panels whose dimensions exceed all available stock sizes are skipped during nesting. Consider adding larger stock sizes via "Add Stock Sizes" or verify that the panel dimensions are correct.

**Q: How does the style name matching work?**

A: The tool matches SIP panel styles to master panel styles by name (case-insensitive). It also supports a convention where the SIP panel style has a " SIP" suffix: for example, a SIP panel style "CLT120 SIP" will match a master panel style named "CLT120".

**Q: What is the difference between double-clicking and using the Nesting context menu?**

A: Both actions trigger the same nesting operation. Double-clicking the tool instance is a shortcut equivalent to right-clicking and selecting "Nesting."

**Q: How do I change the stock sizes after setup?**

A: Use "Add Stock Sizes" from the right-click menu to add new sizes. The tool automatically detects and skips duplicates. To remove sizes, either edit the XML settings file manually at the company path or delete the in-drawing MapObject and re-import settings.

**Q: Why are some of my SIP panels not being nested?**

A: The tool filters out SIP panels that already have an associated ChildPanel entity in the drawing. This prevents double-nesting. If you want to re-nest these panels, select their existing child panels or master panels instead.

**Q: Can I undo the nesting operation?**

A: Yes, use the standard AutoCAD Undo command (Ctrl+Z) to reverse the nesting operation, including all created master panels and child panel transformations.

**Q: What does the "Apply Numbers" command do?**

A: Available on the summary instance (mode 2), it assigns sequential numbers to all master panels managed by that instance. The numbering starts from the highest existing master panel number found in the drawing, ensuring no conflicts with previously numbered panels.

**Q: Why do I see a version mismatch notice?**

A: This occurs when the settings stored in the drawing were created with a different version of the settings file than what is currently installed. Use "Import Settings" to update the drawing settings from the current file, or "Export Settings" to update the file from the drawing.

## Related Scripts

- **SIP panel tools** -- For creating individual SIP panels that serve as input to this nesting tool
- **MasterPanel / MasterPanelStyle** -- Master panel style configuration and management
- **ChildPanel** -- Child panel entity type used for nesting associations
- **PainterDefinition** -- Painter definitions used for filtering and grouping panels
