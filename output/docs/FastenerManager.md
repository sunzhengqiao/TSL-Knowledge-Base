# FastenerManager.mcr

## Overview
This script automates the management of fasteners within metal part collections. It calculates fastener paths from metal plates to intersecting timber beams, generating the necessary clearance holes and managing 3D hardware representations.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for 3D interaction with beams and metal parts. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: A `MetalPartCollection` (containing sub-components with FastenerGuidelines) and intersecting `GenBeams`.
- **Minimum Beam Count**: 0 (Script can be inserted without beams, but beams are required to generate drill holes).
- **Required Settings**: Valid entries in the **Fastener Assembly Catalog**.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `FastenerManager.mcr`

### Step 2: Select Metalparts
```
Command Line: Select metalparts
Action: Click on the metal connection plate or assembly (MetalPartCollection) that contains the fastener definitions.
```

### Step 3: Configure Properties (Optional)
*If not using a predefined catalog entry, the Properties Palette will appear automatically.*
```
Action: Adjust the 'Extra Radius' if necessary to define clearance tolerances, then press Enter or click Close.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Extra Radius | Number | 0 | Defines additional clearance radius (in mm) added to the fastener radius. Increasing this creates larger holes in the timber to accommodate manufacturing tolerances. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add Fastener | Deletes existing fastener assemblies and re-creates them based on the current guidelines and catalog definitions. Use this to reset the hardware if the catalog configuration has changed. |

## Settings Files
- **Source**: Fastener Assembly Catalog
- **Location**: hsbCAD Company/Install Configuration
- **Purpose**: Provides the geometric definitions and diameters for the 3D fasteners (screws, bolts, etc.) used to calculate hole sizes.

## Tips
- **Clearance Tolerances**: If you find the holes in the wood are too tight for the screws, increase the **Extra Radius** property (e.g., to 1.0 mm) to add 2mm total clearance to the hole diameter.
- **Automatic Updates**: If you move the metal plate or modify the connected timber beams, the script will automatically recalculate and update the drill hole positions.
- **Visualizing Hardware**: Use the "Add Fastener" context menu option if the 3D screws/bolts disappear or need to be updated to match a new catalog standard.

## FAQ
- **Q: Why didn't any holes appear?**
  - A: Ensure the metal part collection is actually intersecting with timber GenBeams. The script only drills holes where the fastener volume physically intersects the wood.
- **Q: Can I change the hole size later?**
  - A: Yes. Select the script instance (or the metal plate it is attached to), open the Properties Palette, and modify the **Extra Radius** value.
- **Q: What happens if I delete the metal plate?**
  - A: Since the script instance is anchored to the metal part collection, deleting the plate will usually result in the script instance erasing itself as it loses its reference point.