# hsbCLT-LevelMarker.mcr

## Overview
Generates and manages elevation level markers (level stamps) attached to CLT panels in the 3D model to indicate floor levels or ceiling heights.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script is designed for 3D model interaction. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Not applicable for detail/element drawings. |

## Prerequisites
- **Required Entities**: CLT Panels (Sip entities) must exist in the model.
- **Minimum beam count**: 1 (though multiple panels are typically selected).
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or drag and drop from the catalog)
Action: Select `hsbCLT-LevelMarker.mcr` from the list.

### Step 2: Configure Marker Properties
```
Dialog: Dynamic Dialog
Action: Set the elevation level (e.g., 500), marker size, style (Finished/Raw), and type (Floor/Ceiling).
```
*Note: If run from a Catalog Key with predefined properties, this step may be skipped.*

### Step 3: Select CLT Panels
```
Command Line: Select CLT panels
Action: Click on the CLT panels (Sip entities) you wish to mark. Press Enter when finished.
```
*The script will filter panels based on their orientation relative to the level (e.g., vertical walls vs. horizontal floors).*

### Step 4: Set Location
```
Command Line: Select insertion point
Action: Click a point in the model space to define the location of the level marker.
```
*This establishes the reference plane for the elevation.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Elevation** | Number | 500 | The numeric height value displayed on the marker (e.g., +500.00). |
| **Size** | Number | 50 | The physical size/scale of the marker symbol and text height in the model. |
| **Style** | Dropdown | Finished Face | Determines if the marker arrow is **Solid** (Finished Face) or an **Outline** (Raw Face). |
| **Type** | Dropdown | Floor | Determines the arrow direction: **Up** (Floor) or **Down** (Ceiling). |
| **Dimstyle** | Dropdown | *Current* | The text style used for the elevation label (populated from drawing DimStyles). |
| **Color** | Number | 211 | The color index used for the marker geometry and text. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Add Childs** | Prompts you to select additional CLT panels. New marker instances will be created on these panels and linked to the current instance. |
| **Delete Childs** | Erases all child marker instances associated with this level. The main (Parent) instance remains. |

## Settings Files
None.

## Tips
- **Parent-Child Workflow**: The first instance created is the "Parent". If you select multiple panels during insertion, "Child" instances are automatically created on them. Always select and modify the **Parent** instance to update the Elevation, Size, or Style for all markers in that level simultaneously.
- **Moving Levels**: If you use the Move or Grip Edit command to reposition the Parent instance, all Child instances will move with it to maintain alignment.
- **Orientation**: Ensure your CLT panels are modeled correctly. The script may ignore panels that do not intersect the calculated elevation plane or have non-standard orientations.

## FAQ
- **Q: Why did the script disappear immediately after I ran it?**
  A: The script erases itself if no valid CLT panels are detected or if the selected panels do not intersect the defined elevation plane. Check that your panels are modeled as Solids (Sip) and are correctly positioned in 3D space.
- **Q: Can I change the text font of the elevation label?**
  A: Yes. Use the **Dimstyle** property in the Properties Palette to select a different dimension style defined in your CAD project.
- **Q: What is the difference between "Finished Face" and "Raw Face"?**
  A: "Finished Face" draws a solid filled triangle, typically used for final floor levels. "Raw Face" draws a wireframe outline, often used for structural levels or unfinished surfaces.