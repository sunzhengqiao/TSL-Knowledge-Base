# hsbHardwareLabel.mcr

## Overview
This script automatically generates text labels in Model Space for hardware components (such as screws, bolts, and fittings) attached to beams or tools. It extracts specific data from hardware definitions and fastener assemblies to create clear, on-model labeling of construction details.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script creates labels directly on the 3D model. |
| Paper Space | No | This script does not function in Layout tabs. |
| Shop Drawing | No | This is for model labeling only, not 2D drawing views. |

## Prerequisites
- **Required Entities**: `GenBeam` (timber beams) with connected tools or `ToolEnt` (individual tools) with valid hardware definitions.
- **Minimum Beams**: 0 (You can label standalone tools or tools attached to beams).
- **Required Settings**:
  - Hardware catalogs must be loaded and assigned to the tools.
  - Fastener Assembly catalogs (if using fastener assemblies) must be available.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Browse the catalog and select `hsbHardwareLabel.mcr`.

### Step 2: Configure Label Settings (Optional)
1. Before inserting, look at the **Properties Palette** (usually on the right side).
2. Adjust settings like **Text Height**, **Color**, or toggle which fields (Name, Article No, etc.) you want to display.

### Step 3: Insert and Select Entities
1. Click in the Model Space to set the initial insertion point (this is temporary).
2. The command line will prompt: `Select entities with attached hardware`.
3. Select your beams or specific tools in the 3D model and press **Enter**.

### Step 4: Automatic Generation
1. The script scans your selection.
2. It identifies valid hardware and creates a label instance at the origin of each tool or assembly.
3. The temporary initial instance is automatically removed.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Text Height | Double | 100.0 | The height of the generated text label. |
| Color | Integer | BYLAYER | The color index for the text. |
| DimStyle | String | Standard | The dimension style applied to the text. |
| Show Name | Boolean | True | Toggle visibility of the Hardware Name. |
| Show Article No | Boolean | True | Toggle visibility of the Article Number. |
| Show Description | Boolean | True | Toggle visibility of the Description. |
| Show Quantity | Boolean | True | Toggle visibility of the Quantity (Total count). |
| Show Diameter | Boolean | False | Toggle visibility of the Diameter (for fasteners). |
| Show Length | Boolean | False | Toggle visibility of the Length (for fasteners). |
| Show Material | Boolean | False | Toggle visibility of the Material/Grade. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the label text if the hardware properties have been modified or if the label position needs updating. |

## Settings Files
- **Filename**: Hardware and Fastener Catalogs (varies by project).
- **Location**: Defined in your hsbCAD configuration (Company or Install path).
- **Purpose**: Provides the text data (Article numbers, descriptions, sizes) that populates the labels.

## Tips
- **Selection Efficiency**: You can select a beam that has multiple different tools attached; the script will find and label all valid hardware on that beam automatically.
- **Fastener Assemblies**: If you label a Fastener Assembly, the script intelligently groups identical components (e.g., grouping all screws of the same size) and displays the total quantity required for that assembly.
- **Moving Labels**: If a label is placed in a difficult spot, simply select the label instance and use the **Move** grip or command to reposition it. It will remain linked to the hardware.
- **Duplicate Prevention**: The script checks if a label already exists for a specific piece of hardware. It will not create a second label for the same item, preventing clutter.

## FAQ
- **Q: I selected a beam, but no label appeared.**
  - A: Ensure the beam actually has tools connected to it, and that those tools have valid hardware definitions assigned in their properties.
- **Q: Can I label just one screw out of a group?**
  - A: The script labels the Tool/Assembly entity. To label individual components, you would need to select the specific sub-component if it exists as a separate entity, otherwise, it labels the whole assembly.
- **Q: The text is too small to read.**
  - A: Select the label instance, open the **Properties Palette**, and increase the **Text Height** value. The label will update automatically.