# HSB-DetailInfo.mcr

## Overview
Automates the placement and configuration of construction detail labels on roof elements and openings. It pulls text content from a predefined catalog based on the specific geometric context (e.g., eaves, verges, openings) to ensure consistent labeling in the model.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates on 3D elements and assigns labels to element groups. |
| Paper Space | No | Not designed for Paper Space directly. |
| Shop Drawing | No | Does not generate shop drawings or views. |

## Prerequisites
- **Required Entities**: An existing Element (Wall/Roof) or OpeningRoof.
- **Minimum Beam Count**: N/A (Operates on Elements).
- **Required Settings**: A valid **Detail Catalog** must be configured and referenced by the generator.

## Usage Steps

### Step 1: Generate Model
**Action**: Run a Roof or Wall generator that includes "Detail" or "Info" settings configured to use this script (HSB-DetailInfo).
**Note**: This script is designed to be attached automatically by the generator. See the FAQ regarding manual insertion.

### Step 2: Verify Placement
**Action**: Once generation is complete, inspect the model. Text labels should appear at critical roof locations (eaves, ridges, openings) based on the catalog rules.

### Step 3: Customize Properties (Optional)
**Action**: If you need to modify the label for a specific instance:
1. Select the detail label in the Model Space.
2. Open the **Properties Palette** (Ctrl+1).
3. Modify the text fields (Name, Description) or visual settings (Color, Layer) as described below.

---

## Properties Panel Parameters

### Information
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sSeperator01 | String | - | *Visual Separator only.* |
| Detail name | String | Line A | The primary identifier or code for the detail (e.g., "Detail A"). |
| Description | String | Line B | The main descriptive text for the detail (e.g., "Fascia & Soffit"). |
| Extra description | String | - | Additional description line 1. |
| Extra description 2 | String | - | Additional description line 2. |
| Extra description 3 | String | - | Additional description line 3. |
| Extra description 4 | String | - | Additional description line 4. |
| Extra description 5 | String | - | Additional description line 5. |

### Presentation
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sSeperator02 | String | - | *Visual Separator only.* |
| Dimension style | String | _DimStyles | Select the dimension style to control text font and height. |
| Color | Integer | -1 | Sets the text color. Use `-1` for "ByLayer". |
| Horizontal text alignment | Dropdown | Left | Sets text justification: **Left**, **Right**, or **Center**. |
| Horizontal text offset | Double | 0 | Shifts the text horizontally from the insertion point (in mm). |
| Visible on top view only | Dropdown | No | If set to **Yes**, the label is hidden in 3D views, sections, and elevations. |

### Layering
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Assign to layer | Dropdown | Tooling | Assigns the label to a logical group: **Tooling**, **Information**, **Zone**, or **Element**. |
| Zone index | Integer | 0 | Specifies a sub-index for the layer assignment (0-9). |

---

## Right-Click Menu Options
This script does not add custom options to the right-click context menu. Standard hsbCAD context options apply.

## Settings Files
- **Filename**: Defined by the `DspToTsl` map variable in the generator.
- **Location**: Referenced within the Project or Catalog configuration.
- **Purpose**: Provides the default text strings (Name, Description) based on the geometric location of the detail point.

## Tips
- **Cleaning up Views**: Set `Visible on top view only` to **Yes** if you want the labels to appear on your floor plans but not clutter your 3D model views or Section cuts.
- **Avoiding Overlaps**: Use the `Horizontal text offset` property to nudge text away from geometry if it overlaps with beams or other annotations.
- **Color Coding**: Change the `Color` property to make critical details (e.g., special structural connections) stand out from standard dimensions.

## FAQ
- **Q: I tried to insert this script manually, but it disappeared. Why?**
  A: This script is designed to be attached to a "DSP Detail" point by a generator. If inserted manually via `TSLINSERT`, it detects it lacks the required geometry context, displays a warning, and erases itself to prevent errors.
- **Q: How do I change the text for all details of a certain type?**
  A: You should modify the source **Detail Catalog** used by your generator. Changing properties on individual instances in the model is usually for one-off exceptions.
- **Q: What does the "Zone index" do?**
  A: It acts as a suffix or subgroup for the layer assignment. This is useful if you want to export different groups of details to separate CAD layers or production reports.