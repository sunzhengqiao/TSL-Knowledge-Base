# hsbNailing.mcr

## Overview
This script automates the calculation and placement of nail lines on timber elements (such as walls or panels). It supports multiple nailing modes (e.g., Lath, Sheet, Stud) to generate temporary nail markers which can then be converted into permanent physical NailLine entities for production.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script must be attached to an Element (Wall/Panel). |
| Paper Space | No | Not applicable for 2D drawings. |
| Shop Drawing | No | This script operates on 3D production data. |

## Prerequisites
- **Required Entities**: An existing Element (e.g., a Wall or Panel).
- **Minimum Beam Count**: 0 (Script operates on the Element level).
- **Required Settings**: Catalog entries for `hsbNailing` must exist (e.g., `hsbNailing-Lath`, `hsbNailing-Sheet`, `hsbNailing-Stud`).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbNailing.mcr` from the list.

### Step 2: Select Target Element
```
Command Line: Select Element:
Action: Click on the Wall or Panel you wish to apply nailing to.
```

### Step 3: Configuration Check
```
Command Line: [Optional Prompt if Catalog is missing]
Action: 
- If the catalog is empty, you will be prompted. Press **Enter** to launch the Configuration Wizard and create the required catalog entries.
- If the catalog exists, the script will attach automatically based on the current mode (Setup, Insert, or specific nailing logic).
```

### Step 4: Review Nailing
The script calculates the nailing pattern based on the Element's geometry, material, and the specific catalog mode. It displays temporary nail markers (ElemNail tools) on the element.

### Step 5: Finalize Nailing
```
Action: Right-click the script instance and select "Release Naillines" OR Double-click the script.
Result: The temporary markers are converted into permanent NailLine entities in the database, and the script instance is deleted.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not expose user-editable properties in the Properties palette. Configuration is handled via Catalog entries. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Release Naillines | Converts the temporary nail calculation (ElemNail tools) into actual NailLine entities and removes the script instance from the element. |

## Settings Files
- **Filename**: Variable (Optional external settings).
- **Location**: Company or Install path.
- **Purpose**: Used to provide filters for GenBeam names (optional configuration).

## Tips
- **First-Time Use**: If the script does nothing when attached, ensure the `hsbNailing` catalog entries are created by running the Configuration Wizard (Press Enter during insertion if prompted, or check your Catalog).
- **Modifications**: If you change the Element geometry (e.g., move a stud or resize a sheet), the script will automatically recalculate the nail positions.
- **Finalizing**: Remember to "Release Naillines" (Double-click) when you are satisfied with the layout. This commits the data to the model for production.

## FAQ
- **Q: No nail lines appear after inserting the script.**
  - A: This usually means the catalog configuration is missing or the Element properties (Code, Material) do not match the filters in the catalog. Re-insert the script and check if you are prompted to configure the catalog.
- **Q: How do I change the nailing pattern or spacing?**
  - A: The pattern logic and spacing are determined by the specific Catalog entry used (e.g., `hsbNailing-Sheet` vs `hsbNailing-Lath`). You may need to edit these settings in the Catalog or run the Configuration Wizard again.
- **Q: Can I undo the nailing?**
  - A: You can use the standard AutoCAD Undo command (`Ctrl+Z`) immediately after using "Release Naillines" to revert the creation of NailLines.