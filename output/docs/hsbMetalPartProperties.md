# hsbMetalPartProperties.mcr

## Overview
This script automatically synchronizes the internal hsbCAD Position Number (`hsbPosNum`) of a selected MassGroup to a specific field named `POSNUM` within its AutoCAD Property Sets. It is designed to facilitate data export to external production systems (ERP) or labeling by ensuring critical numbering data is accessible via standard AutoCAD properties.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in Model Space. |
| Paper Space | No | Not supported for layout entities. |
| Shop Drawing | No | Not intended for use within shop drawing views. |

## Prerequisites
- **Required Entities:** A MassGroup entity present in the drawing.
- **Numbering:** The selected MassGroup must have a valid hsbCAD Position Number (`hsbPosNum`) assigned (i.e., a numbering run has been executed).
- **Property Set Definition:** An AutoCAD Property Set Definition must exist in the drawing containing a property specifically named `POSNUM`.
- **Settings Files:** `hsbGenBeamDensityConfig.xml` (Standard hsbCAD configuration file).

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the AutoCAD command line.
2.  Browse to the location of `hsbMetalPartProperties.mcr` and select it.
3.  Click **Open**.

### Step 2: Select Entity
```
Command Line: Select entity
Action: Click on the desired MassGroup in the drawing.
```
*Note: The script will automatically verify if the selected object is a MassGroup.*

### Step 3: Automatic Processing
Once the entity is selected, the script performs the following actions automatically:
1.  Retrieves the internal hsbCAD Position Number.
2.  Attaches the relevant Property Set Definition to the MassGroup (if not already attached).
3.  Updates the `POSNUM` field with the Position Number.
4.  Erases itself from the drawing (it is a "fire-and-forget" script).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script has no user-editable parameters in the Properties Palette. It runs automatically upon insertion. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This script does not add any specific options to the right-click context menu. |

## Settings Files
- **Filename**: `hsbGenBeamDensityConfig.xml`
- **Location**: `<hsbCompany>\Abbund\` (or your configured company path)
- **Purpose**: Required material table configuration file for script execution.

## Tips
- **Verify Property Names:** Ensure your AutoCAD Property Set Definition contains a property strictly named `POSNUM`. If the name differs (e.g., "PosNum" or "Position No"), the script will not update the value.
- **Pre-numbering:** Run the hsbCAD numbering commands on your model before using this script to ensure the `hsbPosNum` is available for export.
- **Clean Up:** If the script attaches a Property Set but does not find the `POSNUM` property inside it, it will detach the set again to keep your drawing data clean.

## FAQ

**Q: Why did the script disappear immediately after I selected the object?**
A: This is intended behavior. The script is designed to run once (insert), perform the update, and then erase itself to avoid cluttering the drawing.

**Q: The script ran, but the "POSNUM" field in my properties is still empty.**
A: Check the following:
1. Does the MassGroup actually have a Position Number assigned (check the hsbCAD Entity Properties)?
2. Does your Property Set Definition actually have a property named `POSNUM` (case-sensitive)?

**Q: Can I change the target property name from "POSNUM" to something else?**
A: No, this script is hardcoded to look specifically for the property name "POSNUM". You must ensure your Property Set Definition matches this name.