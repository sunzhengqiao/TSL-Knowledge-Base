# ObjectNester

## Overview
This script automatically arranges and groups `ObjectClone` instances (such as wall panels or roof cassettes) into a nested layout. It ensures that the grouped bundle fits within specific physical dimensions (Length/Width) required for transport or production, providing visual feedback if the limits are exceeded.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script must be inserted and runs within the Model Space to organize `ObjectClone` entities. |
| Paper Space | No | Not designed for Paper Space or layout views. |
| Shop Drawing | No | This is a production/logistics script, not a detailing tool for drawings. |

## Prerequisites
- **Required Entities**: `ObjectClone` instances (TslInst) must be present in the Model Space.
- **Minimum Beam Count**: 0 (This script organizes other TSL instances, not beams).
- **Required Settings**: `ObjectClone.xml` (Used to store and load default configuration parameters).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `ObjectNester.mcr`

### Step 2: Insert and Organize
```
Command Line: [Click insertion point]
Action: Click in the Model Space to place the ObjectNester instance. 
The script will automatically detect surrounding ObjectClone entities and calculate the nesting layout.
```
*Note: The script establishes a parent/child relationship, treating the selected clones as a single assembly.*

### Step 3: Configure Dimensions
```
Action: Select the inserted ObjectNester instance.
```
1. Open the **Properties Palette** (Ctrl+1).
2. Adjust **Min X-Range** and **Min Y-Range** to match your transport or packaging limits.
3. Observe the visual indicator: a colored box appears indicating the boundary limits.

### Step 4: Validation
```
Action: Check the visual feedback in the model.
```
- **Green/Standard/Invisible**: The nested objects fit within the specified X and Y ranges.
- **Colored Filled Box**: The current layout exceeds the specified range. You must adjust the dimensions, remove items, or rearrange the nesting.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Min X-Range | Number | U(0) | Defines the maximum allowed length (X-axis) of the nesting bundle (e.g., truck bed length). |
| Min Y-Range | Number | U(0) | Defines the maximum allowed width (Y-axis) of the nesting bundle (e.g., transport width). |
| Color | Integer | 150 | Sets the display color of the bounding box visualization (AutoCAD Color Index). |
| Transparency | Integer | 150 | Sets the opacity of the bounding box (0 = Opaque, 255 = Fully Transparent). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Settings** | Opens a configuration dialog to quickly set X-Range, Y-Range, Color, and Transparency. |
| **Import Settings** | Loads previously saved configuration parameters from the `ObjectClone.xml` file. |
| **Export Settings** | Saves the current configuration parameters to `ObjectClone.xml`. If the file exists, you will be prompted to confirm overwriting it. |

## Settings Files
- **Filename**: `ObjectClone.xml`
- **Location**: Company or Install path (detected automatically by the script).
- **Purpose**: Stores the default values for Range, Color, and Transparency, ensuring consistency across different projects or users.

## Tips
- **Visual Checking**: Use the **Color** property to set a highly visible color (like Red) for the bounding box. If the box appears, you immediately know the bundle is too large for the truck or machine.
- **Transparency**: Adjust the **Transparency** to a higher value if you need to see the timber parts clearly inside the bounding box.
- **Uniform Rows**: The script groups items by uniform height. Ensure your ObjectClones have compatible dimensions for optimal row generation.
- **Grips**: You can use grips to drag and modify the size of the nester visually in newer versions (v1.4+).

## FAQ
- **Q: Why do I see a solid box around my nested items?**
  A: This indicates that your current configuration (X/Y Range) is smaller than the actual size of the nested items. Increase the `Min X-Range` or `Min Y-Range` in the properties panel.
- **Q: Can I save my transport dimensions for future projects?**
  A: Yes. Configure your dimensions, right-click the script, and select **Export Settings**. This saves the values to the XML file.
- **Q: The script isn't picking up my elements.**
  A: Ensure the elements you are trying to nest are valid `ObjectClone` TSL instances. This script specifically nests other TSL instances, not raw beams or polylines.