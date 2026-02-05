# HSB_T-Squared

## Overview
This script automatically calculates and applies cuts for two intersecting beams to create a structural connection. It includes a safety feature to limit the depth of the cut, preventing the secondary beam from penetrating too deeply into the primary beam.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script modifies beam geometry and is intended for use in the 3D model. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | This is a model generation script, not a detailing tool. |

## Prerequisites
- **Required Entities**: Two `GenBeam` entities (Beams).
- **Minimum Beam Count**: 2 (One Primary, One Secondary).
- **Required Settings**: None specific (uses default hsbCAD environment).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_T-Squared.mcr` from the list.

### Step 2: Select Primary Beam
```
Command Line: Select beam:
Action: Click on the main structural beam (e.g., a girder or rafter) that will receive the connection.
```

### Step 3: Define Insertion Point
```
Command Line: Give point:
Action: Click on the primary beam to define the exact intersection point where the secondary beam will connect.
```

### Step 4: Select Secondary Beam
```
Command Line: Select beam to cut:
Action: Click on the secondary beam (e.g., a purlin or joist) that will be cut to fit against the primary beam.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Maximum depth | Number | 10 mm | The maximum distance the cut is allowed to penetrate into the main beam (Primary Beam). If the geometric intersection requires a deeper cut, the script will limit it to this value to preserve the structural integrity of the main beam. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *(None)* | This script does not add specific custom options to the right-click context menu. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script operates independently of external settings files.

## Tips
- **Structural Integrity**: Adjust the **Maximum depth** property if the default 10mm cut is too aggressive for the size of your primary beam. This is particularly useful for narrow beams where deep cuts might weaken the section.
- **Visualization**: The script draws a crosshair and circle at the insertion point to help you visually verify the connection location.
- **Order Matters**: Ensure you select the "Main" beam first (the one you want to keep mostly intact) and the "Secondary" beam second (the one that will be notched/cut).

## FAQ
- **Q: Why did the script cut the secondary beam shorter than the intersection point?**
- **A: This happens when the geometric intersection exceeds the **Maximum depth** setting. The script projects the cut plane to the maximum depth limit to ensure the primary beam is not cut too deeply.

- **Q: Can I use this for orthogonal connections (90 degrees)?**
- **A: Yes, the script calculates the intersection angle automatically and applies the correct planar cut regardless of the angle between the beams.