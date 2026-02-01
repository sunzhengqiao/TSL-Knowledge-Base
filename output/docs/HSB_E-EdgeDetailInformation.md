# HSB_E-EdgeDetailInformation.mcr

## Overview
This script displays custom text annotations and detail markers on the edges of timber elements. It allows you to attach manufacturing notes, edge treatments, or drawing references (e.g., "Detail A") directly to an element in Model Space, based on configurations defined in an external XML file.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Attaches to Elements and uses Grippoints to position text on edges. |
| Paper Space | No | Not designed for direct insertion in Layouts. |
| Shop Drawing | No | This is a Model Space annotation tool. |

## Prerequisites
- **Required Entities**: An existing Timber Element (Wall, Floor, Roof).
- **Minimum Beam Count**: 0 (Operates on Elements).
- **Required Settings**: `EdgeInformationConfigurations.xml` (Located in the Company or Install `Tsl\Settings` folder. A default file is generated automatically if missing).

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT`
**Action**: Browse and select `HSB_E-EdgeDetailInformation.mcr`.

### Step 2: Select Element
```
Command Line: Select element:
Action: Click on the timber element (wall/beam) you wish to annotate.
```

### Step 3: Select Edge Position
```
Command Line: Specify point on element (Grippoint):
Action: Click on the specific edge of the element where the information should appear. This serves as the anchor point for the text and leader.
```

### Step 4: Configure Properties
**Action**: Press `Esc` to end the insertion command (if applicable) or select the newly created instance. Open the **Properties Palette** (Ctrl+1) to select a configuration and adjust the style settings.

## Properties Panel Parameters

### Edge Configuration
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Configuration name | dropdown | *Empty* | Selects the predefined text block to display (loaded from the XML configuration file). |

### Position and Style (Text Block)
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Offset from edge | number | 0 | Distance between the element edge and the start of the text block (mm). |
| Horizontal text offset | number | 0 | Shifts the text block parallel to the edge direction (mm). |
| Text size | number | -1 | Height of the annotation text. Use `-1` to adopt the default text style height. |
| Text color | number | -1 | Color index for the text. Use `-1` for "ByLayer". |
| Only show in elevation view | dropdown | Yes | Controls visibility. If "Yes", text only appears in views looking along the element's Z-axis (plan/elevation) and hides in 3D isometric views. |

### Detail Marker (Specific Tag)
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Detail name | text | @(VAR60) | The text label inside the detail marker (e.g., "1", "A", "S1"). Can use variable codes. |
| Dimension style detail name | dropdown | *Current* | Selects the CAD Text/Dim Style for the detail tag. |
| Text size detail | number | -1 | Height of the detail tag text. Use `-1` to match the selected Dimension Style. |
| Detail color | number | -1 | Color index for the detail marker (text and leader). Use `-1` for "ByLayer". |
| Detail leader | dropdown | No leader | Graphic style: "No leader", "Line", "Circle", or "Line with circle". |
| Line length | number | 300 | Length of the leader line extending from the edge (mm). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Reload edge information configurations | Reloads the `EdgeInformationConfigurations.xml` file from disk. This is useful if you have manually edited the XML file to add new text presets while hsbCAD is running. |

## Settings Files
- **Filename**: `EdgeInformationConfigurations.xml`
- **Location**: `..\Tsl\Settings` (Company or Install folder).
- **Purpose**: Stores the library of text configurations. Each configuration defines the text content, alignment, and row structure for the edge labels.

## Tips
- **Default Text Size**: Leaving `Text size` or `Text size detail` as `-1` ensures the annotation automatically scales with your drawing's dimension styles.
- **Visibility Control**: If you cannot see the annotation in a 3D view, check the "Only show in elevation view" property. Setting this to "No" makes the annotation visible in all views.
- **Batch Insertion**: The script can automatically handle multiple edges if configured correctly, or you can insert multiple instances manually, one for each specific edge note.
- **Creating Presets**: To add new text presets, edit the `EdgeInformationConfigurations.xml` file in a text editor and use the "Reload" context menu option to see them in hsbCAD.

## FAQ
- **Q: Why is my annotation not showing up?**
  **A**: Check the "Only show in elevation view" property. If set to "Yes", switch to a Plan or Elevation view. Also, verify the "Configuration name" is actually selected in the properties palette.

- **Q: How do I add custom text labels (e.g., "Sawn Finish")?**
  **A**: You cannot type multi-line text directly into the properties. You must add a new entry to the `EdgeInformationConfigurations.xml` file defining that text, then select it from the dropdown.

- **Q: What does the default "@(VAR60)" in the Detail name mean?**
  **A**: This is a token that links to hsbCAD variable 60. It allows the detail name to be dynamically generated by the system (e.g., based on a sheet number) rather than being static text. You can overwrite this with static text like "Detail 1".