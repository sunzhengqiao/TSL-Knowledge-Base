# HSB_T-Neda

## Overview
Automates the creation of a 'Neda' timber connection (a specific type of lap or keyed notch) between a main female beam and one or more intersecting male beams. It calculates and applies the necessary cuts to both beams to ensure a proper fit with user-defined gaps.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script modifies 3D beam geometry in the model. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | Not applicable for processing views/layouts. |

## Prerequisites
- **Required Entities**: At least two `GenBeam` entities.
- **Minimum Beams**: 1 Female beam and at least 1 Male beam.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Browse and select `HSB_T-Neda.mcr`.

### Step 2: Select Female Beam
```
Command Line: Select female beam
Action: Click on the main beam that will receive the other beams (the 'female' part of the joint).
```

### Step 3: Select Male Beams
```
Command Line: Select a set of male beams
Action: Select one or multiple beams that will intersect the female beam (the 'male' parts). Press Enter to confirm selection.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Neda tool | Separator | - | Visual separator for this tool's settings. |
| Height male beam | Number | 50 mm | Defines the depth of the cut on the male beam (tenon depth). Controls how deep the male beam engages into the female beam. |
| Vertical gap | Number | 5 mm | The vertical clearance between the top of the male beam and the bottom of the cut in the female beam. Allows for shrinkage or tolerances. |
| Horizontal gap | Number | 1 mm | The horizontal clearance (width tolerance) added to the slot in the female beam. Prevents tight binding during assembly. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add specific custom options to the right-click context menu. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A.
- **Purpose**: N/A.

## Tips
- **Batch Selection**: You can select multiple male beams in a single window selection during the "Select a set of male beams" prompt to apply the connection to all intersections at once.
- **Dynamic Updates**: If you move or rotate the beams after insertion, the script automatically recalculates and updates the cuts to maintain the connection.
- **Parametric Adjustments**: You can fine-tune the fit by changing the `Vertical gap` or `Horizontal gap` in the Properties Palette after the tool is inserted.

## FAQ
- **Q: How do I change the depth of the notch?**
  **A**: Select the tool instance in the drawing, open the Properties Palette (Ctrl+1), and modify the value for `Height male beam`.

- **Q: Can I connect several small beams to one large beam simultaneously?**
  **A**: Yes. When prompted for the "set of male beams," select all the intersecting beams you wish to connect. The script will create a separate connection instance for each one.

- **Q: Why are my beams not touching?**
  **A**: Check your `Vertical gap` and `Horizontal gap` settings in the Properties Palette. If these values are too high, there will be visible space between the beams.