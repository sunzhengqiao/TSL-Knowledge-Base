# hsbDoubleCut

## Overview
This script applies a double cut (intersecting planes) to timber elements, allowing for complex angular geometries such as hips, valleys, or diagonal end cuts. It can function as a standard subtraction tool or as an end tool that determines the length of the beam.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for beam selection and 3D geometry. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: GenBeam (Beam, Wall, Panel, CLT, etc.)
- **Minimum Beam Count**: 1
- **Required Settings**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbDoubleCut.mcr`

### Step 2: Select Timber Element
```
Command Line: Select GenBeam
Action: Click on the beam, panel, or timber element you wish to cut.
```

### Step 3: Define Apex Location
```
Command Line: Select apex location of double cut.
Action: Click in the 3D model to specify the peak point where the two cut planes will meet.
```
*(Note: If the property "Use second point for direction" is set to **Yes**, an additional prompt will appear here to define the direction line.)*

### Step 4: Define First Plane
```
Command Line: Select point on first plane.
Action: Click a point that lies on the surface of the first desired cut plane (along with the apex).
```

### Step 5: Define Second Plane
```
Command Line: Select point on second plane.
Action: Click a point that lies on the surface of the second desired cut plane.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Insert as end tool | Dropdown | No | If set to **Yes**, this cut acts as the physical end of the beam, replacing other end tools in this direction and setting the element's length. If **No**, it acts as an internal subtraction. |
| Use second point for direction | Dropdown | No | If set to **Yes**, you must manually select a second point during insertion to define the specific direction of the cut intersection. If **No**, the direction is calculated automatically perpendicular to the beam surface. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Standard Edit Options | Use grips to move the apex or plane points. Use properties to change tool behavior. |

## Settings Files
- **Filename**: N/A
- **Location**: N/A
- **Purpose**: This script relies on internal logic and standard catalogs rather than external settings files.

## Tips
- **Visualizing the Cut:** The script draws crossing lines at the intersection to help you visualize the double cut geometry.
- **Grip Editing:** After insertion, select the script and drag the blue grip points to dynamically adjust the apex location or the tilt of the cut planes.
- **Automatic Direction:** For most standard applications, leave "Use second point for direction" as **No** so the system calculates the optimal intersection line automatically.

## FAQ
- **Q: What happens if the two points I select for the planes are parallel?**
  - A: The script will automatically switch to a Single Cut mode instead of a Double Cut.
- **Q: How do I make the cut shorten the beam?**
  - A: Change the property "Insert as end tool" to **Yes** in the Properties Palette.
- **Q: The cut direction is wrong. How do I fix it?**
  - A: Either adjust the property "Use second point for direction" to **Yes** and define it manually, or use the grip points to rotate the planes into the correct position.