# hsbCLT-ProfileConnection.mcr

## Overview
This script automatically creates a profile pocket (cutout) in a CLT or SIP panel to fit over a steel beam connection. It calculates the necessary cutout geometry based on the beam's profile dimensions and applies user-defined clearance gaps to the top flange, web, and bottom flange.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D model entities. |
| Paper Space | No | Not designed for 2D layout or detailing views. |
| Shop Drawing | No | Does not generate shop drawings directly. |

## Prerequisites
- **Required Entities**: At least one Beam (typically a steel profile) and one Panel (Sip/CLT element).
- **Minimum Beam Count**: 1.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-ProfileConnection.mcr`

### Step 2: Select Elements
```
Command Line: Select panel and beam
Action: Select the CLT/SIP panel(s) and the connecting steel beam. 
Note: You can select multiple panels to connect to a single beam simultaneously.
```

### Step 3: Configure Properties
After selection, the script inserts and the **Properties Palette** will appear. Adjust the gap values as needed for your specific connection details (e.g., insulation thickness, tolerance).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Top Vertical** | Number | 10.0 mm | Vertical clearance between the top flange of the beam and the panel. |
| **Top Horizontal** | Number | 10.0 mm | Horizontal clearance along the beam length at the top flange level. |
| **Bottom Vertical** | Number | 10.0 mm | Vertical clearance between the bottom flange of the beam and the panel. |
| **Bottom Horizontal** | Number | 0.0 mm | Horizontal clearance along the beam length at the bottom flange level. |
| **Main Vertical** | Number | 10.0 mm | Clearance around the main body (web) of the steel beam profile. |
| **Facet** | Number | 15.0 mm | Size of the 45-degree chamfer (bevel) at the corners of the cutout. |
| **Beam** | Number | 10.0 mm | Longitudinal clearance added to the start and end of the beam cutout. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Select new profile beam** | Allows you to select a different beam to update the connection without deleting and re-running the script. |

## Settings Files
- No external settings files are required for this script.

## Tips
- **Multiple Panels**: You can select several panels at once during insertion. The script will create a separate instance for each panel linked to the selected beam.
- **Visualization**: The script displays a symbol at the midpoint of the connection edge to indicate where the connection is applied.
- **Update Automatically**: If you move or stretch the connected beam, the cutout in the panel will automatically update to match the new position.

## FAQ
- **Q: Why is there a chamfer (facet) in the cutout?**
  A: The facet prevents sharp 90-degree internal corners in the wood, which are weak points, and helps the panel slide over the steel beam flanges during installation.
- **Q: Can I use this on timber beams?**
  A: This script is designed for profile connections (typically steel) interacting with CLT/SIP panels. While it may work on timber beams, the "profile" logic is best suited for steel sections like I-beams or U-channels.
- **Q: The script erased itself after selection. What happened?**
  A: Ensure you selected at least one valid Panel and one valid Beam. If the selection contains only beams or only panels, the script will cancel and erase itself.