# HSB_E-OpeningBlock.mcr

## Overview
This script automatically inserts 2D CAD blocks (symbols) into wall or floor openings (`OpeningSF`) based on the opening's description code. It is typically used to visualize specific symbols for windows, doors, or penetrations in the model on assigned layers and zones.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script inserts the block into the 3D model geometry relative to the element. |
| Paper Space | No | Not designed for layout or sheet views. |
| Shop Drawing | No | This is a model-space visualization tool, not a 2D shop drawing generator. |

## Prerequisites
- **Required Entities**: An `Element` (Wall or Floor) and an `OpeningSF` (Opening).
- **External Files**: DWG block files must exist in the project's drawing path (`_kPathDwg`). The filename must match the opening's description.
- **Minimum Beam Count**: 0.

## Usage Steps

### Step 1: Launch Script
Run the command `TSLINSERT` in the command line and select `HSB_E-OpeningBlock.mcr` from the list.

### Step 2: Configure Properties (Optional)
If the Properties Palette does not open automatically, double-click the script name or press `Enter` without selecting anything.
- Set the **Drawing subfolder** if your blocks are organized in folders (e.g., "Windows").
- Set the **Zone index** and **Layer** as required for your project standards.

### Step 3: Select Elements or Openings
The command line will prompt:
```
Select elements <Enter> to select openings:
```
**Option A:** Click on the Wall or Floor elements containing the openings you wish to process. The script will find all openings inside those elements.
**Option B:** Press `Enter`. The prompt will change to:
```
Select openings:
```
Click directly on the specific `OpeningSF` entities you want to tag. Press `Enter` to finish selection.

### Step 4: Automatic Insertion
The script will automatically attach to the selected elements/openings and insert the corresponding block at the bottom-left corner of the opening.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Drawing subfolder | Text | "" | Specifies a subdirectory inside the project drawing folder (`_kPathDwg`) where the DWG files are stored (e.g., "MySymbols"). Leave empty if files are in the root drawing folder. |
| Zone index | Number | 0 | Sets the zone index (0-10) for the symbol. Used to filter visibility in different views or export stages. |
| Layer | Dropdown | Tooling | Sets the display category for the symbol. Options: Tooling, Information, Zone, Element. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add custom items to the right-click menu. Standard options like Erase or Recalculate are available. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A (Script relies on external DWG files found in `_kPathDwg`)

## Tips
- **Naming Convention**: Ensure the name of your DWG block file matches the *Description* field of your opening in hsbCAD. The script looks at the first part of the description to find the file.
- **Troubleshooting Missing Blocks**: If the script displays text saying "Cannot find [Path]", check the file path in the properties, verify the DWG file exists, and ensure the file extension is lowercase `.dwg`.
- **Bulk Processing**: You can select multiple walls/floors at once (Option A in Step 3) to apply symbols to all openings within them rapidly.
- **Positioning**: The block is inserted at the bottom-left reference point of the opening, oriented to the element's coordinate system.

## FAQ
- **Q: Why do I see the text "Cannot find..." instead of my symbol?**
  A: The script cannot locate the DWG file. Check that the filename matches the opening description exactly. If you used the "Drawing subfolder" property, ensure the folder name is spelled correctly and exists in your drawing path.

- **Q: Can I rotate the block?**
  A: The script orients the block based on the element's coordinate system. To change orientation, you would need to edit the source DWG block file or the element's rotation.

- **Q: What happens if I change the Layer property?**
  A: The symbol will move to the new entity group (e.g., from "Tooling" to "Information"), which may change its color and visibility depending on your layer filters.