# hsbCLT-Slot-Distribution.mcr

## Overview
Automates the creation of ventilation, wiring, or architectural slot patterns across multiple coplanar CLT panels. It allows for adjustable spacing, angles, and depth for consistent machining across a selection of elements.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates in 3D model space to create physical slots. |
| Paper Space | No | Not applicable for 2D layout. |
| Shop Drawing | No | Generates geometry used in shop drawings but does not run within the drawing view itself. |

## Prerequisites
- **Required Entities:** GenBeam or Element entities (CLT Panels).
- **Minimum Beam Count:** 1.
- **Required Settings:** `hsbCLT-Slot-Distribution.xml` (Optional, used to save/load dimension configurations).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-Slot-Distribution.mcr`

### Step 2: Select Entities
```
Command Line: Select Entities
Action: Select the CLT panels (GenBeams/Elements) you wish to apply the slot distribution to. Press Enter to confirm.
```

### Step 3: Specify Insertion Point
```
Command Line: Specify insertion point
Action: Click in the model space to define the origin point for the distribution (usually on the face of a panel).
```

### Step 4: Specify Rotation
```
Command Line: Specify rotation point
Action: Click a second point to define the direction/orientation of the slot distribution line.
```

## Properties Panel Parameters

### Geometry
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Width | number | 8 mm | The visible width of the slot opening on the panel face. |
| Depth | number | 16 mm | The half-depth of the slot. **Note:** The physical cut depth will be twice this value (Total Cut = Depth * 2). |

### Alignment
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Face | dropdown | Reference Side | Determines which side of the panel the angle calculation references (Reference Side or Opposite Side). |
| Angle | number | 19.5° | The inclination of the slot relative to the panel normal. Range: -89° to 89°. |

### Distribution
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Mode | dropdown | Fixed | **Fixed:** Uses exact `Interdistance`. **Even:** Calculates spacing to fill area between Start/End offsets. |
| Interdistance | number | 60 mm | Distance between the centers of consecutive slots (used in Fixed mode). |
| Rotation | number | 0° | Rotates the entire distribution line of slots relative to the default axis. |

### Distribution Offsets
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Left | number | 0 mm | Offsets the start of the distribution pattern. |
| Right | number | 0 mm | Offsets the end of the distribution pattern. |
| Start Distance | number | 150 mm | Margin from the start edge before the first slot appears. |
| End Distance | number | 150 mm | Margin from the end edge after the last slot appears. |

### Dimension
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Format | text | @(Quantity-2)x @(Width) / @(Depth) >@(Angle)° | Text template for labeling the slot group in shop drawings. |
| Stereotype | dropdown | * | Links the dimension to a specific drafting style for layering/filtering. |
| View | dropdown | XY-View | Specifies if dimensions appear in Plan view (XY) or Section view. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Flip Side | Toggles the `Face` property, switching the slots to the opposite side of the panel. |
| Add Panels | Prompts you to select additional panels to add to the current distribution group. |
| Remove Panels | Prompts you to select panels to remove from the current distribution group. |
| Edit in Place | Converts the distribution into individual `hsbCLT-Slot` instances. This allows you to edit single slots independently. The main script instance is removed. |
| Configure Shopdrawing | Opens a dialog to quickly adjust Dimension settings (Format, Stereotype, View). |
| Import Settings | Loads configuration settings from `hsbCLT-Slot-Distribution.xml`. |
| Export Settings | Saves current configuration to `hsbCLT-Slot-Distribution.xml`. |

## Settings Files
- **Filename**: `hsbCLT-Slot-Distribution.xml`
- **Location**: `_kPathHsbCompany\TSL\Settings` or `_kPathHsbInstall\Content\General\TSL\Settings`
- **Purpose**: Stores persistent configuration for Dimension settings (Format, Stereotype, View) and general map object data, allowing you to share settings between projects.

## Tips
- **Avoid 90° Angle:** Ensure the `Angle` property is not set to 90° or -90°, as this creates an invalid infinite plane and will cause the script to fail.
- **Edit in Place:** If you need to adjust just one slot in a wall (e.g., avoid a structural beam), use the **Edit in Place** context menu option. This breaks the link to the main distribution and lets you move individual slots.
- **Even vs Fixed:** Use **Even** mode if you want a specific number of slots to perfectly fill a gap between two defined margins. Use **Fixed** mode to maintain standard construction spacing regardless of the panel length.
- **Depth Calculation:** Remember that the value you enter for `Depth` is only half the total penetration. If you need a 40mm deep cut, enter `20`.

## FAQ
- **Q: Can I add panels to an existing slot distribution without starting over?**
  **A:** Yes. Select the script instance in the model, right-click, and choose **Add Panels**. You can then select the new panels to include.
  
- **Q: Why are my slots not cutting through the full panel thickness?**
  **A:** Check the `Depth` property in the Properties Palette. The script calculates total depth as `2 * dDepth`. Double your input value if the cut is too shallow.

- **Q: What happens if I use "Edit in Place"?**
  **A:** The main `hsbCLT-Slot-Distribution` script will delete itself and replace the pattern with individual `hsbCLT-Slot` scripts. You can no longer control the whole pattern as one unit, but you can move or modify specific slots.

- **Q: How do I apply the same slot settings to another project?**
  **A:** Configure your slots as desired, right-click the instance, and select **Export Settings**. In the new project, insert the script and select **Import Settings** to load the configuration.