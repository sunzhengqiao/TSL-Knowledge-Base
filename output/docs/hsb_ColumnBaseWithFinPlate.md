# hsb_ColumnBaseWithFinPlate.mcr

## Overview
Generates a steel column base connection consisting of a height-adjustable stub (column section), a bottom base plate for anchoring, a top bearing plate, and a side fin plate. The fin plate slots into and bolts through the selected timber beam for lateral stability.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script constructs 3D geometry and requires a selected beam. |
| Paper Space | No | Not designed for 2D drawing generation. |
| Shop Drawing | No | Generates physical elements, not views. |

## Prerequisites
- **Required Entities**: At least one GenBeam (Timber Beam).
- **Minimum Beam Count**: 1.
- **Required Settings**: Ensure an extrusion profile catalog is available if using the `sProfile` property.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_ColumnBaseWithFinPlate.mcr`

### Step 2: Select Timber Beam
```
Command Line: 
Action: Click on the timber beam (column) that will receive the base connection.
```

### Step 3: Locate Insertion Point
```
Command Line: 
Action: Click in the 3D model to position the base of the steel column stub.
```

### Step 4: Configure Parameters
```
Dialog: Dynamic Properties
Action: Adjust dimensions (Plate sizes, Stub height, Drill patterns) and click OK to generate.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Steel Grade** | Text | S275 | Specifies the material grade of the steel plates and stub (e.g., S275, S355). |
| **Color** | Number | -1 | Visual color of the generated steel parts (-1 = ByLayer). |
| **Overall Foot Height** | Number | 300 | Vertical height of the steel stub (distance between Top Plate and Base Plate). |
| **Extrusion profile name** | Dropdown | | Cross-sectional profile of the steel stub (e.g., HEA100, SHS 100x100). |
| **Flip Direction** | Dropdown | Yes | Rotates the stub profile 90 degrees around the vertical axis. |
| **Name** | Text | Base Plate | Identifier for the Base Plate element. |
| **Base Plate Thickness** | Number | 20 | Thickness of the bottom steel plate anchoring to the foundation. |
| **Base Plate Length** | Number | 400 | Length of the base plate. |
| **Base Plate Width** | Number | 300 | Width of the base plate. |
| **Quantity of Drill Rows** | Number | 3 | Number of anchor bolt holes along the width. |
| **Quantity of Drill Columns** | Number | 3 | Number of anchor bolt holes along the length. |
| **Drill Row Centers** | Number | 100 | Center-to-center spacing between holes along the width. |
| **Drill Col Centers** | Number | 100 | Center-to-center spacing between holes along the length. |
| **Base Plate Drill** | Number | 20 | Diameter of the holes for anchor rods in the base plate. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (Standard hsbCAD Context) | Standard options like **Erase** or **Edit** are available to regenerate or delete the element. |

## Settings Files
- **Filename**: None specified.
- **Location**: N/A
- **Purpose**: This script relies on standard hsbCAD profile catalogs for the stub profile.

## Tips
- Use the **Flip Direction** property if the steel stub profile is oriented incorrectly relative to the timber beam's width.
- Ensure the **Drill Row/Col Centers** are set small enough so holes fit within the **Base Plate** dimensions.
- The script automatically creates cuts/drills in the selected timber beam for the fin plate connection.

## FAQ
- Q: Can I use a rectangular tube for the stub?
  A: Yes, select the desired profile name from the **Extrusion profile name** dropdown in the properties.
- Q: How do I raise the timber column off the floor?
  A: Increase the **Overall Foot Height** value. This extends the length of the steel stub between the top and bottom plates.