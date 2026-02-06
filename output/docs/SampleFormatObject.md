# SampleFormatObject.mcr

## Overview
This script generates a visual label displaying custom properties and calculated data (such as weight, dimensions, or surface quality) for selected timber construction elements in the model.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used for tagging 3D elements like beams, panels, and openings. |
| Paper Space | No | Not designed for layout views. |
| Shop Drawing | No | Not designed for manufacturing details. |

## Prerequisites
- **Required Entities**: At least one valid entity (GenBeam, Sip, ChildPanel, Opening, OpeningSF, or MetalPartCollectionEnt).
- **Minimum Count**: 1 entity. If no entity is selected, the script instance will be deleted.
- **Required Settings**: The `hsbCenterOfGravity` TSL must be available to calculate and display the "Weight" property.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `SampleFormatObject.mcr`

### Step 2: Select Entities
```
Command Line: Select entities:
Action: Select one or more construction entities (beams, panels, openings, etc.) from the model that you wish to label.
```

### Step 3: Define Insertion Point
```
Command Line: Specify insertion point:
Action: Click in the model space where you want the label to appear.
```

### Step 4: Configure Format
```
Dialog: Properties
Action: Enter the Format string (e.g., @(Weight), @(Surface Quality)) or use the default. Click OK to generate the label.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Format | text | | Defines the layout and content of the label using placeholders (e.g., `@(Width)`, `@(GrainDirectionText)`). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add/Remove Format | Opens a command-line list of available properties. Type the index number to add a property to the format or type `-index` to remove it. Type `-1` to finish. |

## Settings Files
- **Script Dependency**: `hsbCenterOfGravity.tsl`
- **Location**: TSL Search Path
- **Purpose**: Calculates the weight used in the `@(Weight)` variable.

## Tips
- Use the **Add/Remove Format** right-click option to build your label string easily instead of typing it manually.
- The available properties change depending on the entity type selected (e.g., Sips show Grain Direction, Openings show Dimensions).
- You can move the label later using **Grip Edit** (click the label and drag the grip) to reposition it in the drawing.

## FAQ
- **Q: Why did the script disappear immediately after I placed it?**
  - A: The script automatically deletes itself if no valid entities were selected during the selection step. Ensure you select a beam, panel, or opening before placing the label.

- **Q: The "Weight" shows as 0 or is missing.**
  - A: Ensure the `hsbCenterOfGravity` TSL is installed and accessible in your hsbCAD environment, as the script relies on it to calculate weight.

- **Q: Can I label multiple different types of entities at once?**
  - A: Yes, you can select mixed entities (e.g., a Beam and a Panel). The script will attempt to resolve properties relevant to each specific entity type.