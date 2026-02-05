# IOMethods.mcr

## Overview
This is a background utility script that retrieves manufacturing details (Type Name, Material, and Grade) from a timber element based on a specific numerical ID. It is typically used by ERP systems or other scripts to look up property data without user interaction.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Operates on existing entities within the model. |
| Paper Space | No | Not designed for layout or annotation usage. |
| Shop Drawing | No | Not intended for production drawing views. |

## Prerequisites
- **Required entities**: An existing hsbCAD Entity (e.g., a beam or wall) that contains `BEAMPROPERTIES` data in its extended attributes (MapX).
- **Minimum beam count**: 0 (This script processes data passed to it, it does not require pre-selection of beams).
- **Required settings**: None.

## Usage Steps

### Step 1: Usage Context
**Note:** This script is designed for **Map I/O (Input/Output)** processing. It does not function as a standard interactive tool. You generally do not run this script manually by typing commands or clicking screen prompts.

### Step 2: Automatic Execution
This script is triggered automatically by other processes (such as an ERP export or a parent script).
- **Action:** The calling system sends a "Map" containing the **Element** and the **nType** (numerical ID) to this script.
- **Result:** The script reads the entity's properties and returns the corresponding Name, Material, and Grade to the calling system.

## Properties Panel Parameters
This script does not create graphical elements and does not expose any parameters in the AutoCAD Properties Palette.

## Right-Click Menu Options
This script does not add any options to the Entity right-click context menu.

## Settings Files
No external settings files (XML) are used by this script.

## Tips
- **Data Consistency:** Ensure your elements have valid `BEAMPROPERTIES` MapX data assigned. If the script returns an error, check if the selected element is a standard hsbCAD component that has been properly generated/processed.
- **Debugging:** If an external system reports "Beam type not found," verify that the numerical Type ID being requested actually exists in the element's property list.

## FAQ
- **Q: Can I insert this script into my drawing?**
  - A: While you can load the script, it will not generate any geometry or ask for input. It acts as a hidden function for other programs to use.
- **Q: Why does the script fail with "Entity does not contain mapX"?**
  - A: The element being queried is missing its internal property definitions. This often happens if the element is a plain CAD line or a generic block rather than a native hsbCAD parametric object.
- **Q: How do I change the material it returns?**
  - A: You must change the material properties of the source element itself (the one being queried). This script only reads existing data; it does not modify it.