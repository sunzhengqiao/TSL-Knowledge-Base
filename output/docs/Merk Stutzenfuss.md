# Merk Stutzenfuss (Post Shoe)

## Overview

This script inserts a **Merk K1-A post shoe** (column base connector) onto a timber column. It generates the complete steel hardware assembly -- base plate, threaded cylinder, pressure plate, and hexagonal nut -- and applies the required machining operations (central bore, housing drill, anchor bolt holes, and end cut) to the selected beam. The script automatically selects the correct article size (150, 250, or 450) based on the specified height parameter.

| Property | Value |
|----------|-------|
| Script Type | E-Type (Entity) |
| Beams Required | 1 |
| Unit System | Millimeters (mm) |
| Version | 1.5 |

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | 3D hardware placement and beam machining |
| Paper Space | No | Not applicable |
| Shop Drawing | No | Not applicable |

## Prerequisites

- One timber column (GenBeam) must exist in the model.
- The column axis must be oriented so that the base of the column can be identified (the script uses the beam axis intersection with the world XY plane).

## Usage Steps

### Step 1: Launch the Script
Run the `TSLINSERT` command and select **Merk Stutzenfuss.mcr** from the script list.

### Step 2: Select the Column
Click on the timber column (GenBeam) where the post shoe should be installed. A dialog opens automatically for initial parameter configuration.

### Step 3: Adjust Parameters
Modify the Height, Diameter, Base Height, and other properties as needed in the dialog or later through the Properties Palette.

### Step 4: Result
The script performs the following on the selected column:
1. Cuts the column end at the specified height above the base.
2. Drills a central bore hole (default diameter 40 mm) for the threaded rod.
3. Drills a wider housing recess (50 mm diameter, 20 mm deep) at the top of the connection.
4. Creates four 6 mm anchor bolt holes in the base plate (at 80 mm x 30 mm offsets from center).
5. Generates all metal parts: base plate (200 x 100 x 4 mm), cylinder (diameter 42 mm), pressure plate (diameter 50 mm, 4 mm thick), and hexagonal nut.

## Properties Panel Parameters

| Parameter | Type | Default | Unit | Description |
|-----------|------|---------|------|-------------|
| Height | Number | 200 | mm | Height of the connection above the base. Controls which article size is selected (see Tips). |
| Diameter | Number | 40 | mm | Diameter of the central bore hole drilled into the column for the threaded rod. |
| Base Height | Number | 0 | mm | Vertical offset of the entire assembly. Use to raise the base plate above floor level for foundation details. |
| Extra Drilling Depth | Number | 0 | mm | Additional depth added to the central bore beyond the standard cylinder length. |
| Depth Drill Housing | Number | 20 | mm | Depth of the wider housing recess (50 mm diameter) where the pressure plate seats into the column. |
| Group, Layername or Zone Character | Text | Z | -- | Controls layer/group assignment. Accepts a group name, zone character (C, I, J, T, Z), or a custom layer name. |

## Automatic Article Selection

The script selects the hardware model based on the **Height** parameter:

| Height Range | Cylinder Length | Article Code |
|--------------|----------------|--------------|
| up to 210 mm | 300 mm | 118 150 |
| 211 -- 310 mm | 400 mm | 118 250 |
| above 310 mm | 620 mm | 118 450 |

The article code and description ("Merk Stutzenfuss K1-A") are written to the DXA output for BOM extraction.

## Generated Metal Parts

| Part | Dimensions | Material |
|------|-----------|----------|
| Base Plate (Grundplatte) | 200 x 100 x 4 mm, with four 6 mm bolt holes | Steel, zinc-coated |
| Cylinder (Zylinder) | Diameter 42 mm, length depends on article | Steel, zinc-coated |
| Pressure Plate (Druckplatte) | Diameter 50 mm, 4 mm thick | Steel, zinc-coated |
| Hexagonal Nut (Mutter) | Hex profile, 20 mm height | Steel, zinc-coated |

## Beam Machining Applied

| Operation | Details |
|-----------|---------|
| End Cut | Cuts the column at the connection height (Height + Base Height from world plane) |
| Central Bore | Drilled from the cut face downward, diameter = Diameter parameter, depth = cylinder length + Extra Drilling Depth |
| Housing Drill | 50 mm diameter recess at the top of the connection, depth = Depth Drill Housing (default 20 mm) |
| Anchor Bolt Holes | Four 6 mm holes through the base plate at 80/30 mm Y/Z offsets from center |

## Layer and Group Assignment

The **Group, Layername or Zone Character** property provides flexible organization:

- **Group name** (e.g., `House\Ground Floor\Column`): Assigns the instance to the specified group.
- **Zone character** (T, I, J, Z, C): Assigns to the zone layer of the parent beam's group, controllable through the Console settings tab.
- **Custom layer name**: Creates or assigns to a layer with that name.

## Settings Files

This script does not require external XML settings files.

## Tips

- Observe the manufacturer's specified limits when setting the Height parameter. The script does not enforce maximum values.
- Use **Base Height** to accommodate concrete plinths or raised foundations without modifying the column geometry.
- The script outputs BOM data via `dxaout` with description format "Merk Stutzenfuss K1-A [article]", which can be extracted in element Bills of Material.
- All dimensions are unit-safe. The script works correctly in both millimeter and inch drawing templates.
