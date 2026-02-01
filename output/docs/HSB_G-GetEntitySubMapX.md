# HSB_G-GetEntitySubMapX.mcr

## Overview
This utility script extracts internal non-graphical data (SubMapX) from a selected entity and saves it to a text file. It is primarily used for debugging or inspecting hidden data structures attached to hsbCAD elements.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script runs in Model Space only. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required entities**: Any valid hsbCAD entity (e.g., Beam, Wall, or Custom Element) that contains internal SubMapX data.
- **Minimum beam count**: 0 (Works on any entity type).
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the AutoCAD command line.
2. Select `HSB_G-GetEntitySubMapX.mcr` from the list.
3. The script instance is created, and the Properties palette (OPM) will open automatically.

### Step 2: Configure Parameters
1. In the Properties Palette, locate the **SubMapX** parameter.
2. Enter the exact name (key) of the internal data map you wish to extract.
   - *Note: This value is case-sensitive and must match the internal name used by the script that created the data.*

### Step 3: Select Entity
1. The command line will prompt: `Select entities`
2. Click on the specific object in your drawing that holds the data.
3. The script will process the selection.

### Step 4: Locate Output
1. If data matching the name is found, a `.dxx` file is created in the same folder as your current DWG.
2. The filename format is: `subMapX-[EntityHandle].dxx`.
3. The script instance will automatically erase itself from the drawing upon completion.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| SubMapX | Text | \|SubMapX name\| | The unique identifier (key) for the specific internal data map attached to the entity that you wish to inspect. |

## Right-Click Menu Options
There are no specific right-click menu options added by this script.

## Settings Files
- No specific settings files are required for this script.

## Tips
- **Script Behavior**: This script is "fire and forget." It creates the export file and then deletes itself from the drawing to avoid clutter.
- **Finding the File**: Check the folder where your DWG is saved. The file name includes the entity handle to ensure it is unique.
- **Usage**: This is an advanced tool. You generally need to know the specific "SubMapX name" defined by a developer or another script to get a result. If the name does not match, the export will fail.

## FAQ

- **Q: The script disappeared after I selected an entity. Is that normal?**
  - A: Yes. The script is designed to perform the export and then automatically erase itself from the drawing.

- **Q: Where can I find the exported data?**
  - A: The script creates a `.dxx` file in the exact same directory where your current DWG drawing is saved.

- **Q: I get a "No valid SubMapX found" message. What does that mean?**
  - A: This means the entity you selected either does not have internal data attached, or the "SubMapX" name you entered in the Properties panel does not match the key stored on the entity.

- **Q: What should I enter in the "SubMapX" property?**
  - A: This depends entirely on what data you are looking for. It is often the name of a specific script or function (e.g., "CalculationData"). Consult the documentation for the script that created the entity to find the correct key.