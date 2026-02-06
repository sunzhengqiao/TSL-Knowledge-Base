# hsbCNC-Drill.mcr

## Overview
This script creates vertical CNC drilling operations on timber elements (walls or roofs). It supports primary and secondary drilling (e.g., counterbores for bolt heads), calculates depth based on material zones, and generates 3D holes with customizable text labels.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used for 3D modeling and assigning CNC data. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: An existing Element (Wall or Roof) or a Sheet within an element.
- **Minimum Beam Count**: 0
- **Required Settings**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `hsbCNC-Drill.mcr`.

### Step 2: Select Target Entity
```
Command Line: Select a sheet of the desired zone or an element
Action: Click on a Wall, Roof, or a specific Sheet (layer) within the element.
```
*Note: Selecting a specific sheet pre-sets the "Zone" property to that layer.*

### Step 3: Configure Properties
Action: The Properties Palette (OPM) will appear. Adjust the parameters (Diameter, Depth, Zone, etc.) as needed.
*Tip: If using a Catalog Entry, properties may load automatically.*

### Step 4: Set Insertion Point
```
Command Line: Insertion point
Action: Click on the face of the element where the center of the drill should be located.
```
*Note: Ensure you click within the bounds of the selected zone, or the tool will be deleted.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **General** | | | |
| Zone | dropdown | - | Selects the specific material layer (e.g., stud layer, sheathing). -99 is outermost, 99 is innermost. |
| Relation | dropdown | Standard | Determines how the drill behaves if the element construction changes (Standard, Relative, or Exclusive). |
| **Drill** | | | |
| Depth | number | 20.0 | Depth of the hole. `0` = through selected zone. Negative value = through zone + extra offset. |
| Diameter | number | 68.0 | Diameter of the drill bit. |
| Tooling index | number | 1 | CNC machine tool number to use. |
| **Drill 2** | | | |
| Depth | number | 0.0 | Depth for a second hole (e.g., counterbore). Set to 0 to disable. |
| Diameter | number | 0.0 | Diameter for the second hole. |
| Tooling index | number | 1 | CNC machine tool number for the second hole. |
| **Display** | | | |
| Description | text | - | Format string for the label. Use variables like `@(Diameter)`, `@(Depth)`, or `@(Elevation)`. Example: `@(Diameter)x@(Depth)`. |
| Text Height | number | 80.0 | Size of the text label in the model. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Hide Definition | Hides the script instance graphics while keeping the CNC data active. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: Standard properties are used. Catalog entries can be created to save preset configurations.

## Tips
- **Through-Drilling**: To drill completely through the selected material layer, set **Depth** to `0`.
- **Counterbores**: Use the "Drill 2" section to create a larger, shallower hole (perfect for washers/nuts). Ensure Drill 2 Diameter is larger than the primary Diameter.
- **Deep Drills**: If the set Depth exceeds the thickness of the selected zone, the script will automatically continue drilling into the zones behind it.
- **Label Formatting**: You can display dynamic data on the drawing label. Try entering `D@(Diameter) L@(Depth)` in the Description field to show dimensions clearly.

## FAQ
- **Q: Why did my drill disappear after I moved it?**
  - A: The insertion point likely moved outside the physical bounds of the selected zone. Move the grip back onto the timber surface.
- **Q: How do I drill through the entire wall?**
  - A: Select the outermost zone and set Depth to `0`. If the wall is thick, you may need to select the innermost zone or use a negative depth value to penetrate through multiple layers.
- **Q: What does a negative depth mean?**
  - A: A negative value calculates the depth as "Zone Thickness + Absolute Value". For example, if the zone is 50mm thick and you enter `-10`, the total drill depth will be 60mm.