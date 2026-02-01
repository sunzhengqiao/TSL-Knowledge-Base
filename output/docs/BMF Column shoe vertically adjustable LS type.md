# BMF Column shoe vertically adjustable LS type.mcr

## Overview
This script generates a vertically adjustable column shoe (specifically LS and LB types) attached to a selected timber beam. It automatically creates the necessary hardware geometry, including base plates, rods, and nuts, and performs the required cut on the beam to accommodate the connection.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for 3D geometry creation and beam modification. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: GenBeam (Generic Beam)
- **Minimum Beam Count**: 1
- **Required Settings**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `BMF Column shoe vertically adjustable LS type.mcr`

### Step 2: Initial Configuration
A dialog will appear automatically upon insertion.
```
Action: Configure basic settings (Type, Fixing, etc.) in the dialog, or accept defaults to proceed.
```

### Step 3: Select Beam
```
Command Line: Select a beam
Action: Click on the timber beam (GenBeam) you wish to attach the column shoe to.
```

### Step 4: Define Insertion Point
```
Command Line: Specify insertion point
Action: Click on the beam to define the exact location for the column shoe.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type | dropdown | LS 60x65 | Selects the shoe profile (LS or LB series). Options include various size combinations (e.g., LS 60x65, LB 80x190). |
| Fixing | dropdown | nails | Specifies the type of fasteners to be used. Options: nails, screws. |
| Extra Beam Height | number | 0 | Adjusts the beam height calculation/cut by this additional amount. |
| Elevation | number | 0 | Vertically adjusts the position of the column shoe. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are defined for this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not use external settings files; all configurations are handled via properties.

## Tips
- **Switching Types**: You can switch between LS and LB types via the Properties Palette (OPM) after insertion. This regenerates the geometry automatically (LS types do not include a base plate offset, while LB types do).
- **Error Handling**: If you manually enter a Type that does not exist in the internal list, the script will erase the instance and display "Shoe cannot be used!". Always select from the dropdown list.

## FAQ
- **Q: Can I adjust the shoe height after placing it?**
  - A: Yes, use the **Elevation** parameter in the Properties Palette to move the shoe vertically.
- **Q: What is the difference between LS and LB types?**
  - A: The script generates different geometry for these groups. LS types (Indices 0-3) are constructed without a base plate offset, whereas LB types (Indices 4-7) include calculations for a base plate thickness.
- **Q: Why did the script disappear when I changed the Type?**
  - A: This likely occurs if an invalid type was selected. Ensure the type selected matches the predefined options in the dropdown list exactly.