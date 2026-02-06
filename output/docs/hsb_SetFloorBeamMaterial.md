# Set Floor Beam Material Properties

## Overview
Assigns material, grade, beam type, name, color, and nailing properties to floor beams, automatically updating the beam code with the specified attributes.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary usage environment for floor beam modification |
| Paper Space | No | Not applicable |
| Shop Drawing | No | Not applicable |

## Prerequisites
- **Materials.xml** file must exist at: `Company Path\Abbund\Materials.xml`
- Run the **hsbMaterial Utility** before first use to configure materials
- One or more beams must be selected for modification

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_SetFloorBeamMaterial.mcr`

### Step 2: Configure Properties
If no catalog/preset is being used, a properties dialog will appear.

### Step 3: Select Beams
AutoCAD Command Line: **"Select one or more beams"**
- Click on the beams you want to modify
- Press **Enter** to complete selection

### Step 4: Automatic Processing
The script will:
1. Apply the selected beam type to all selected beams
2. Set the material and grade
3. Update the beam name
4. Apply the specified color
5. Update the beam code with all new properties
6. Automatically erase itself after completion

## Properties Panel Parameters
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Beam Use | Dropdown | Rim Board | Defines the structural function: Rim Board, Joist, Trimmer, Rim Joist, Blocking, Packers, Strongbacks, Beam, or Furring |
| Beam Name | Text | (empty) | Custom name for the beam. If left empty, the script uses the Beam Use value as the name |
| Material | Dropdown | (from Materials.xml) | Timber material type loaded from the company materials catalog |
| Grade | Text | (empty) | Timber grade specification (e.g., "C24", "GL24h") |
| Allow Nailing | Dropdown | Yes | Controls whether beams can receive automatic nailing: Yes/No |
| Color | Integer | 32 | AutoCAD color index for the beams (1-255) |

## Right-Click Menu Options
This script does not provide context menu options.

## Settings Files
**Materials Catalog:**
- **File**: `[Company Path]\Abbund\Materials.xml`
- **Format**: XML file containing material definitions
- **Management**: Use **hsbMaterial Utility** to edit materials
- **Required**: Script will not run without this file

## Tips
- **Beam Use determines type**: Each Beam Use option automatically sets the corresponding internal beam type constant (e.g., Joist → `_kJoist`, Blocking → `_kBlocking`)
- **Empty beam name**: Leave Beam Name blank to automatically use the Beam Use value as the name
- **Beam code update**: The script automatically rebuilds the beam code string with Material, Grade, Name, and Allow Nailing settings
- **Catalog shortcuts**: Save commonly used material/grade/type combinations as catalogs for quick reuse from Tool Palettes
- **Color standardization**: Use consistent colors for different beam types to improve visual identification in drawings
- **Nailing control**: Set "Allow Nailing" to "No" for beams that should not receive automatic nails (e.g., temporary members)

## FAQ

**Q: What if I get "Materials not been set" error?**
A: Run the **hsbMaterial Utility** to create the Materials.xml file in your company path, or contact your support desk for configuration assistance.

**Q: What's the difference between "Beam Use" and "Beam Name"?**
A: "Beam Use" sets the structural beam type constant (which controls behavior in other scripts). "Beam Name" is a label that appears in reports and can be customized. If you leave Beam Name empty, it defaults to the Beam Use value.

**Q: Can I apply different materials to beams in the same operation?**
A: No, each script execution applies one set of properties to all selected beams. Run the script multiple times with different selections for different materials.

**Q: What beam types are available?**
A: The script supports: Rim Board (_kRimBeam), Joist (_kJoist), Trimmer (_kFloorBeam), Rim Joist (_kRimJoist), Blocking (_kBlocking), Packers (_kExtraBlock), Strongbacks (_kSupportingCrossBeam), Beam (_kBeam), and Furring (_kRisingBeam).

**Q: How does the beam code get updated?**
A: The script rebuilds the 13-token beam code string, preserving existing tokens but overwriting Material (token 1), Allow Nailing (token 8), Grade (token 9), Information (token 10), and Name (token 11) with the new values.

**Q: Can I use this script from a Tool Palette?**
A: Yes, the script supports execution from Tool Palettes using catalog/execute keys, which will skip the dialog and use predefined values.
