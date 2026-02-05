# HSB_R-Hip T-Solution.mcr

## Overview
Automates the detailing of Ridge-to-Hip roof intersections by generating a structural "T" connection (short rafter and trimmer) and applying corresponding cuts to the main beams. It also supports solutions for Hip-to-Hip connections.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D elements and beams. |
| Paper Space | No | Not designed for 2D drawing layouts. |
| Shop Drawing | No | Not a multipage or annotation script. |

## Prerequisites
- **Required Entities:** An Element containing structural members.
- **Minimum Beam Count:** At least 2 beams (typically one Ridge and one Hip).
- **Required Settings:** Ensure your project catalog contains the beam codes specified in the script properties (defaults: HK-01, NK-01, etc.).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_R-Hip T-Solution.mcr`

### Step 2: Select Element
```
Command Line: Select one or more elements
Action: Click on the roof element where the Hip and Ridge intersect.
```

### Step 3: Configure Properties
After selection, the script attaches to the element. Open the **Properties Palette** (Ctrl+1) to adjust beam codes and dimensions to match your specific project requirements.

## Properties Panel Parameters

### Hip Configuration
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Beamcode hip | Text | HK-01 | The beam code identifying the Hip rafter in the element. |

### Ridge Configuration
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Beamcode ridge | Text | NK-01 | The beam code identifying the Ridge beam in the element. |

### T-Solution Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Minimum length short rafter | Number | 250 | The absolute smallest allowed length for the generated connecting rafter (top of the 'T'). |
| Length short rafter | Number | 1000 | The threshold distance determining if a separate Trimmer beam is created. If the gap is smaller than this, the short rafter stretches to the support. |
| Beamcode short rafter | Text | HK-R | The beam code assigned to the newly created short rafter connecting Hip to Ridge. |
| Beamcode trim | Text | HK-T | The beam code assigned to the newly created Trimmer beam (parallel to the ridge). |

### Hip-Hip Solution Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Extend rafter from hip | Number | 100 | Determines how far to extend the support or offset cuts for Hip-to-Hip connections where no ridge exists. |

## Right-Click Menu Options
No custom context menu options are defined for this script. Use standard hsbCAD entity commands for recalculation or updates.

## Settings Files
No external settings files are required for this script. All configuration is handled via the Properties Palette.

## Tips
- **Beam Codes:** If the script does not seem to detect your beams, verify that the `Beamcode hip` and `Beamcode ridge` properties exactly match the codes used in your model.
- **Trimmer Generation:** If you expect a trimmer beam but don't see one, check the distance between the intersection and the next support. If it is less than the `Length short rafter` (1000mm), the script will extend the jack rafter instead of adding a trimmer.
- **Hip-Hip Roofs:** For roof shapes without a ridge (e.g., pyramid roofs), ensure the `Extend rafter from hip` value is sufficient to create a valid connection.

## FAQ
- **Q: Why did the script fail to generate a beam?**
  **A:** Check the `Minimum length short rafter`. If the calculated intersection requires a beam shorter than 250mm, the geometry may be invalid for this script.

- **Q: Can I use this for vaulted ceilings?**
  **A:** This script is designed for standard pitched roof intersections (Ridge-to-Hip). Results on complex vaulted geometries may vary.

- **Q: How do I update the connection after changing the roof pitch?**
  **A:** Use the standard `hsbCAD` update command (usually right-click the element and select **Update** or **Recalculate**) to run the script again with the new geometry.