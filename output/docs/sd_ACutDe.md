# sd_ACutDe.mcr (Automatic Cut Dimensions)

## Overview
This script automates the dimensioning of timber beam cuts, such as tenons, notches, and angles, on hsbCAD shop drawings. It calculates measurement points based on tool geometry and assigns them to specific drawing layers (stereotypes) for consistent production documentation.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used primarily for manual insertion and testing. |
| Paper Space | Yes | Primary environment. Executed by the Shopdrawing engine during layout generation. |
| Shop Drawing | Yes | Must be added to a Multipage Style Ruleset to function automatically. |

## Prerequisites
- **Required Entities**: `GenBeam` (with at least one Tool/Cut applied).
- **Minimum Beam Count**: 1.
- **Required Settings**: A **Multipage Style Ruleset** (for automatic execution) or manual insertion via command line.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `sd_ACutDe.mcr` from the file list.

### Step 2: Select Beam
```
Command Line: Select beam:
Action: Click on the timber beam (GenBeam) you wish to dimension.
```

### Step 3: Select Location
```
Command Line: Select point near tool:
Action: Click near the specific cut, tenon, or notch on the beam surface to target it for dimensioning.
```
*Note: In a production environment, this script is typically triggered automatically by the Shopdrawing engine based on the Multipage Style configuration, skipping these prompts.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **showAllInOneLeft** | dropdown | \|No\| | If set to **\|Yes\|**, aggregates all dimension points for cuts on the left side into a single continuous dimension line to reduce clutter. |
| **showAllInOneRight** | dropdown | \|No\| | If set to **\|Yes\|**, aggregates all dimension points for cuts on the right side into a single continuous dimension line. |
| **hideAnglesCut** | dropdown | \|No\| | If set to **\|Yes\|**, suppresses the display of cut angle text (e.g., 45°) in the drawing views. |
| **Dimension from Start and End** | text | 0 | If the beam length exceeds this value (in mm), dimensions are split into two lines (Start and End) to prevent overcrowding on long beams. Set to 0 to disable. |
| **japaneseStyle** | dropdown | \|No\| | If set to **\|Yes\|**, applies specific dimensioning rules for Japanese timber framing (e.g., prioritizing Dove cuts, altering reference points). |
| **Show dimpoints on x-axis** | dropdown | \|Default\| | Forces the longitudinal dimensions to appear in a specific view (e.g., left in side view, right in top view) rather than using the automatic default. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu items are defined for this script. |

## Settings Files
- **Configuration**: **Multipage Style Ruleset**
- **Location**: hsbCAD Company / Project Configuration
- **Purpose**: Controls the automatic execution of this script during shop drawing generation. You can pass parameters (e.g., `showAllInOneLeft;\|Yes\|`) via the Execution Map within the style settings.

## Tips
- **Clean Up Drawings**: For beams with multiple notches or cuts close together, enable `showAllInOneLeft` and `showAllInOneRight` to create a single chain dimension instead of overlapping individual dimensions.
- **Long Beams**: If dimensioning long Glulam beams, use `Dimension from Start and End` (e.g., set to `10000`) to split dimensions into a "Start" and "End" group, making the drawing easier to read.
- **View Control**: Use `Show dimpoints on x-axis` if the system is placing dimensions on the "wrong" side of the beam in the view you are looking at.

## FAQ
- **Q: Why are my dimensions not appearing on the shop drawing?**
  **A**: Ensure the script is added to the Ruleset of the Multipage Style you are using to generate the layout. Also, verify that the cuts on the beam are valid tools.
- **Q: Can I change the dimension style without editing the script?**
  **A**: Yes. Select the script instance (or the element it is attached to) and change the properties in the AutoCAD Properties Palette (OPM). For global changes, update the parameters in the Multipage Style Execution Map.
- **Q: What does the "0" value mean for Dimension from Start and End?**
  **A**: A value of "0" disables the splitting logic. Dimensions will follow the standard aggregation rules defined by `showAllInOneLeft`/`Right`.