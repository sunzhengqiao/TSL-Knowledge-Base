# HSB_E-ShowModule

## Overview
Creates visual identifiers (hatching and text labels) for specific groups of timber beams (modules) within the 3D model. It is used to graphically highlight and label assembly or delivery packages for production planning or site logistics.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model environment. |
| Paper Space | No | |
| Shop Drawing | No | Not intended for generating 2D layout views. |

## Prerequisites
- **Required entities**: An `Element` containing `GenBeams`.
- **Minimum beam count**: 0 (The script scans elements for beams with assigned "Module" names).
- **Required settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_E-ShowModule.mcr`

### Step 2: Select Element
```
Command Line: Select element(s)
Action: Click on the construction Element(s) in the model that contain the beams you want to visualize.
```

### Step 3: Configure Properties
```
Action: The Properties Palette will appear automatically. Adjust settings like Module Name, Colors, or Hatch Pattern if desired.
Note: The script will automatically detect beams with unique "Module" property values and create a visualization for each group.
```

### Step 4: Position Label (Optional)
```
Action: Click and drag the blue grip point (square) on the text label to reposition it within the module.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimension style | dropdown | (current) | Sets the text style (font/size) for the module label. |
| Body Color | number | 2 | Sets the color of the solid body visualization of the selected beams. |
| Name Color | number | -1 | Sets the color of the module name text (-1 = ByBlock). |
| Hatch Color | number | -1 | Sets the color of the hatch pattern (-1 = ByBlock). |
| Show module name | dropdown | Yes | Toggles the visibility of the module name text label (Yes/No). |
| Module name | text | Auto | The identifier for the group. "Auto" uses the name from the beams; otherwise, it overrides them. |
| Module hatch | dropdown | (current) | Selects the graphic pattern used to fill the module area. |
| Hatch scale | number | 1.0 | Adjusts the density or size of the hatch pattern. |
| Show hatch in zone | dropdown | 8 | Sets the Element Display Zone (0-10) where the hatch and text are visible. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add GenBeams | Prompts you to select beams in the model to add to the current module visualization. |
| Remove GenBeams | Prompts you to select beams currently in the module to remove them from the group. |
| Remove all GenBeams | Removes all beams from the module instance, clearing the visualization. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies on standard AutoCAD dimension styles and hatch patterns available in the current drawing.

## Tips
- **Grip Edit**: You can move the text label to a clearer location by clicking and dragging the blue square grip point (_PtG) displayed in the model.
- **Auto-Naming**: Keep the "Module name" property set to "Auto" to let the script read and display the names already assigned to your beams.
- **View Control**: Use the "Show hatch in zone" property to hide the module labels in detailed views while keeping them visible in device or assembly views (e.g., Zone 8).
- **Batch Processing**: When you insert the script, it scans the entire selected Element and automatically creates separate visual instances for every unique "Module" name found on the beams.

## FAQ
- **Q: Why did the script seem to disappear after I selected an element?**
  **A:** The script automatically clones itself for every unique module name found in the element. The original "host" instance is erased, leaving only the specific visualizations for the modules found.
  
- **Q: How do I change the name of a module?**
  **A:** Select the module visualization (hatch or text), open the Properties Palette, and change the "Module name" field. This will update the text label and the "Module" property on all linked beams.
  
- **Q: The text label is in the wrong spot. How do I fix it?**
  **A:** Select the module entity, click the blue square grip point on the text, and drag it to the desired position.