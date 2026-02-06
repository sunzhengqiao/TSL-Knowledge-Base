# hsbOpeningReinforcement.mcr

## Overview
This script creates temporary reinforcement beams inside wall openings to stabilize the structure during transportation. It automatically places vertical studs for wide openings and horizontal beams for tall openings based on your defined limits.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script generates 3D beams in the model. |
| Paper Space | No | Not applicable for detailing views. |
| Shop Drawing | No | Does not generate 2D drawings directly. |

## Prerequisites
- **Required entities:** An existing Wall Element or Opening object in the model.
- **Minimum beam count:** None.
- **Required settings:** None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbOpeningReinforcement.mcr`

### Step 2: Select Elements
```
Command Line: Select elements or/and openings
Action: Click on the wall elements or specific openings in the drawing that require reinforcement. Press Enter to confirm selection.
```

### Step 3: Configure Properties (Optional)
```
Action: With the script selected, open the Properties Palette (Ctrl+1) to adjust beam sizes, material, and opening limits before the calculation runs.
```

## Properties Panel Parameters

### Beam Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Width | number | 44 | Defines the Width (thickness) of the reinforcing beam. |
| Height | number | 44 | Defines the Height (depth) of the reinforcing beam. |
| BeamCode | text | [empty] | Defines the BeamCode for the reinforcing beam (e.g., for scheduling). |
| Information | text | [empty] | Defines the Beam Information (e.g., "Remove on site"). |
| Material | text | [empty] | Defines the Beam Material grade. |
| Label | text | [empty] | Defines the Label for identification in lists. |

### Opening Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Width | number | 2500 | Defines the max. opening width. If the opening is wider than this, a vertical beam is added. |
| Height | number | 2500 | Defines the max. opening height. If the opening is taller than this, a horizontal beam is added. |

### Tolerances
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Left | number | 0 | Defines the Left tolerance (offset from the left edge). |
| Right | number | 0 | Defines the Right tolerance (offset from the right edge). |
| Top | number | 0 | Defines the Top tolerance (offset from the top edge). |
| Bottom | number | 0 | Defines the Bottom tolerance (offset from the bottom edge). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | No specific custom context menu items are defined for this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Transport Logic:** Use this script when wall panels are too large or weak to be lifted safely. The reinforcement prevents the wall from collapsing during transport.
- **Sizing Limits:** If you see reinforcement beams appearing in small windows where you don't want them, increase the `Width` and `Height` limits in the Opening settings.
- **Clearance:** If you need the reinforcement to be slightly shorter than the exact opening size (e.g., to avoid clashing with plasterboard), enter small values in the Tolerances fields (Left, Right, Top, Bottom).
- **Identification:** Always fill in the `BeamCode` or `Label` field (e.g., "TEMP_BRACE") so you can easily filter and delete these temporary beams before or after installation on site.

## FAQ
- **Q: Why didn't the script generate a beam for my large window?**
  - A: Check the `Width` and `Height` settings in the Properties panel. The opening dimensions must exceed these values to trigger the creation of a reinforcement beam.
- **Q: Are these beams permanent structural members?**
  - A: Typically, no. They are intended for transportation stability. You should mark them (via the Label or Information property) for removal on-site.
- **Q: Can I use different sizes for horizontal vs vertical reinforcement?**
  - A: This script uses a single Width and Height setting for all generated beams. If different sizes are needed, you may need to run the script separately with different settings or adjust the beams manually afterwards.