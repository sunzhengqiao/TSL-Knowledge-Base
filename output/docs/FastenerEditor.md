# FastenerEditor.mcr

## Overview
This script serves as a configuration tool to create, import, and manage fastener assembly styles (such as bolts, screws, and dowels) from a central database. It allows users to define the geometric and material properties of fasteners before applying them to structural timber connections.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script runs in Model Space to manage fastener definitions and previews. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: None (Creates `FastenerAssemblyDef` styles).
- **Minimum Beam Count**: 0.
- **Required Settings Files**:
    - `TslUtilities.dll`
    - `FastenerManager.dll` (Must be present in the hsbCAD Utilities folder).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `FastenerEditor.mcr` from the list.
*Note: Upon insertion, if no existing fastener styles are detected in the drawing, you will be automatically prompted to create styles from the database.*

### Step 2: Initial Insertion
```
Command Line: Select insertion point:
Action: Click in the Model Space to place the Fastener Editor instance.
```

### Step 3: Configure Fastener Styles
Once inserted, use the **Properties Palette** (Ctrl+1) to filter available fasteners or use the **Right-Click Context Menu** to manage styles.
1.  Select the inserted `FastenerEditor` object.
2.  In the Properties Palette, select the **Manufacturer**, **Type** (Bolt, Screw, etc.), and **Diameter** to filter the list of available fasteners.
3.  Select a specific **Fastener Style** from the list to generate a visual preview.

### Step 4: Import or Create New Styles (Optional)
If the required fastener is not in the list:
1.  Right-click the `FastenerEditor` object.
2.  Select **Create Styles from Database** to launch the graphical selector and generate new styles.
3.  OR select **Import Styles** to load definitions from an external DWG file.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **kManufacturer** | String | Any | Filters the fastener list by supplier/brand (e.g., Simpson, SFS). |
| **kType** | Dropdown | Bolt | Defines the fastener category (Screw, Bolt, ThreadedRod, AnchorBolt, DowelRod). |
| **kDiameter** | Number | --All-- | The nominal diameter of the fastener shaft (e.g., M12, M16). |
| **kHeadType** | String | --All-- | The shape of the fastener head (e.g., Hex, Flat, Pan). |
| **kLength** | Number | Not Defined | The total length of the fastener shaft. |
| **sLocations** | String | Closing end | Defines where washers and nuts are placed (Head, Closing Component, or Both). |
| **nMode** | Integer | 0 | Operational mode: 0=General, 1=Edit Head Components, 2=Edit Tail Components. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Open Database Manager** | Launches the external FastenerManager configuration window to edit the central database. |
| **Show Style Manager** | Opens the AutoCAD Style Manager palette to manage Aec styles. |
| **Load Graphical Ruleset** | Imports graphical rules for fasteners. |
| **Import Styles** | Prompts you to select a DWG file to import fastener definitions into the current drawing. |
| **Create Styles from Database** | Launches a visual selector allowing you to pick components and generate new FastenerAssemblyDef styles. |

## Settings Files
- **Filename**: `FastenerManager.dll`
- **Location**: `hsbCAD Install Path\Utilities\FastenerManager\`
- **Purpose**: This library provides the connection to the fastener database and handles the logic for creating and managing fastener styles.

## Tips
- **Importing Styles**: Use the "Import Styles" function to copy fastener configurations from a standard template drawing to your current project, ensuring consistency across the team.
- **Visual Preview**: The script creates visual preview instances (`SimpleFastener`) in the model space when you select a style. This allows you to verify the geometry (head type, washer location) before using the fastener in connections.
- **Component Editing**: If you need to adjust only the head (e.g., change a washer) without affecting the tail, change the `nMode` property to **1**. Use **2** for the tail components.

## FAQ
- **Q: I get an error "Could not find file... FastenerManager.dll".**
  **A:** Ensure hsbCAD is installed correctly and the `FastenerManager.dll` is present in the Utilities folder. Without this file, the script cannot access the fastener database.
- **Q: Can I use my own custom fastener shapes?**
  **A:** You can import styles from other drawings that contain custom `FastenerAssemblyDef` definitions using the "Import Styles" context menu option.
- **Q: What happens if I import a style that already exists?**
  **A:** The script will ask if you want to **Overwrite** the existing style or **Skip** it. Select "Overwrite" to update the style to the imported version.