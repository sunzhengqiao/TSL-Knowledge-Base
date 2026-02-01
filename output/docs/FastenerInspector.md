# FastenerInspector.mcr

## Overview
Displays detailed textual information about a selected Fastener Assembly style (such as screws, bolts, or connectors) directly in the model view. It is used to verify configuration data, dimensions, materials, and article numbers defined in the catalog.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Standard execution environment. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Fastener Catalog Entries**: Fastener Assembly Definitions must exist in your current hsbCAD catalog.
- **Existing Entities** (Optional): If using the selection option, a Fastener Assembly entity must already exist in the model.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `FastenerInspector.mcr`

### Step 2: Configure Fastener Style
The Properties Palette (OPM) opens automatically.
- **Action**: Select a Fastener Style from the dropdown list (e.g., "SPAX 8x200").
- **Alternative**: Select `<|bySelection|>` from the top of the list to identify a style already placed in the model.

### Step 3: Select Entity (Conditional)
*Only appears if `<|bySelection|>` was chosen in Step 2.*
```
Command Line: Select fastener assembly
Action: Click on an existing fastener in the drawing.
```

### Step 4: Insert Location
```
Command Line: Point:
Action: Click in the Model Space to place the text report.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| |Fastener Style| | Dropdown | Empty | Selects the specific Fastener Assembly Style to inspect. Choose `<|bySelection|>` to pick an entity from the model. |
| |Text Height| | Number | 50 | Sets the height of the generated text in the model (in mm). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Properties | Opens the Properties Palette to change the Fastener Style or Text Height, which updates the visualization immediately. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies solely on the internal Fastener Assembly Catalog (FastenerAssemblyDef).

## Tips
- **Identify Unknown Fasteners**: If you see a fastener in the model but don't know its specific catalog definition, insert this script, choose `<|bySelection|>`, and click the fastener to view its details.
- **Readability**: If the text report is too small to read at your current zoom level, increase the **Text Height** parameter in the Properties Palette.
- **Data Verification**: Use this tool to double-check thread lengths, pilot diameters, and material properties before generating production data.

## FAQ
- **Q: What happens if I select `<|bySelection|>` but click the wrong object?**
  **A:** The script will likely report an invalid definition or fail to generate the text. Select the object again via the Properties Palette `Fastener Style` dropdown or re-insert the script.
- **Q: Can I update the report if the catalog definition changes?**
  **A:** Yes. Select the generated text in the model, open the Properties Palette, and simply re-select the style name from the dropdown to force a refresh.