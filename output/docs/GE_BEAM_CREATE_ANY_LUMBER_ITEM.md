# GE_BEAM_CREATE_ANY_LUMBER_ITEM

## Overview
Creates a single generic timber beam (such as blocking, nogs, or stiffeners) between two user-selected points. It allows you to select a profile from a predefined inventory list or enter manual dimensions.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is the primary environment for creating 3D beams. |
| Paper Space | No | Not designed for 2D layout views. |
| Shop Drawing | No | Not used for generating drawings directly. |

## Prerequisites
- **Required entities**: None.
- **Minimum beam count**: 0.
- **Required settings**: `hsbFramingDefaults.Inventory.dll` must be configured with available lumber items.

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT`
**Action**: Browse and select `GE_BEAM_CREATE_ANY_LUMBER_ITEM.mcr`.

### Step 2: Configuration
**Action**: A dialog will appear upon first insertion. Select the desired **Lumber Item** from the inventory list or choose "Manual Size" to define dimensions yourself.

### Step 3: Define Start Point
```
Command Line: Specify start point:
Action: Click in the Model Space to set the beginning of the beam.
```

### Step 4: Define End Point
```
Command Line: Specify end point:
Action: Click to set the endpoint of the beam. The beam will be generated, and the script instance will automatically disappear, leaving a standard beam entity.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Lumber Item | Dropdown | *First in List* | Select a predefined profile from the inventory or "Manual Size". |
| Width | Number | 35 mm | The thickness (width) of the beam. Used when "Manual Size" is selected. |
| Height | Number | 42 mm | The depth (height) of the beam. Used when "Manual Size" is selected. |
| Block Type | Index | 28 (Solid Stud) | Classifies the beam for reporting (e.g., Stud, Joist, Blocking). |
| Color | Number | 32 | The display color of the beam (AutoCAD Color Index). |
| Name | Text | *Empty* | A user-defined name or tag for the beam. |
| Material | Text | *Empty* | Overrides the material species from the inventory selection. |
| Grade | Text | *Empty* | Overrides the structural grade from the inventory selection. |
| Elevation | Number | 0 mm | Vertical Z-offset applied to the start point. Shifts the beam up or down. |
| Information | Text | *Empty* | Custom notes appended to the beam entity. |
| Label | Text | *Empty* | Primary label or marker text. |
| SubLabel | Text | *Empty* | Secondary label or marker text. |
| SubLabel2 | Text | *Empty* | Tertiary label or marker text. |
| BeamCode | Text | *Empty* | Production code for CNC machinery or factory logic. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | The script instance erases itself immediately after creating the beam. To modify the beam, use the standard AutoCAD/hsbCAD properties and grips on the resulting beam object. |

## Settings Files
- **Filename**: `hsbFramingDefaults.Inventory.dll`
- **Location**: hsbCAD Install path or Company Standards folder.
- **Purpose**: Provides the list of available Lumber Items (Materials, Grades, and Dimensions) used in the Lumber Item dropdown.

## Tips
- **Manual Dimensions**: If you select "Manual Size" in the Lumber Item dropdown, ensure you manually input valid values for Width and Height in the properties palette before insertion.
- **Vertical Adjustment**: Use the **Elevation** property to place blocking at specific heights relative to the points you click, which is useful for mid-height blocking in walls.
- **Post-Creation Editing**: Once created, the beam is a standard hsbCAD entity. You can stretch it using grips or change its properties via the Properties Palette.
- **Overrides**: You can use the **Material** and **Grade** fields in the properties to quickly switch species or grade without changing the Inventory selection.

## FAQ
- **Q: Why can't I find the script to edit it after insertion?**
  A: The script is designed to "run once" and delete itself (`eraseInstance`). It converts itself into a native beam entity for better performance in the model.
- **Q: What happens if my dimensions are 0 or negative?**
  A: The script will detect invalid dimensions, display an error ("Data incomplete..."), and abort the creation process without leaving any geometry.
- **Q: Can I use this to create curved beams?**
  A: No, this script creates straight linear beams between two defined points.