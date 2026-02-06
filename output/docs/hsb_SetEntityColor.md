# Set Entity Color by Dimensions

## Overview
Sets the color of all beams within selected elements that match specific height and width filter criteria.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary usage environment |
| Paper Space | No | Not applicable |
| Shop Drawing | No | Not applicable |

## Prerequisites
- One or more elements (walls, floors, or roofs) must exist in the drawing
- Filter definitions must be created using the **HSB_G-FilterGenBeams** script
- Beams within the elements must match the filter criteria

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_SetEntityColor.mcr`

### Step 2: Configure Filter Settings
If no catalog/preset is being used, a dialog will appear. Configure the following:
- Select filter definition for beam height
- Select filter definition for beam width
- Choose the color to apply

Click **OK** to confirm.

### Step 3: Select Elements
AutoCAD Command Line: **"Select elements"**
- Click on one or more elements (walls, floors, roofs)
- Press **Enter** to complete selection

### Step 4: Automatic Processing
The script will:
1. Extract all beams from the selected elements
2. Apply height and width filters to identify matching beams
3. Set the specified color to all beams that pass both filters
4. Automatically erase itself after completion

## Properties Panel Parameters
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Filter definition for entity height | Dropdown | (empty) | Predefined filter criteria for beam height matching. Use **HSB_G-FilterGenBeams** to create filter definitions |
| Filter definition for entity width | Dropdown | (empty) | Predefined filter criteria for beam width matching. Use **HSB_G-FilterGenBeams** to create filter definitions |
| Color | Integer | 0 | AutoCAD color index to apply to matching beams (1-255) |

## Right-Click Menu Options
This script does not provide context menu options.

## Settings Files
**Filter Definition Tool:**
- Uses: **HSB_G-FilterGenBeams.mcr**
- Purpose: Create and manage beam dimension filters that define height/width matching rules

## Tips
- **Create filters first**: Before using this script, use **HSB_G-FilterGenBeams** to create named filter definitions for common beam dimensions
- **Catalog shortcuts**: Save frequently used filter and color combinations as catalogs to skip the dialog on subsequent uses
- **Multiple elements**: The script can process multiple elements in a single operation—select all elements you want to modify
- **Automatic cleanup**: The script automatically removes itself after execution, so the instance will not remain visible in the element
- **Filter logic**: Both height AND width filters must match for a beam to receive the color change

## FAQ

**Q: Why does the script report "Beams could not be filtered"?**
A: This occurs when the **HSB_G-FilterGenBeams** script is not loaded in the drawing. Insert that script first to define filter criteria.

**Q: Can I skip the dialog when inserting?**
A: Yes, use the script from a Tool Palette or with an execute key that references a saved catalog. The script will use the cataloged values automatically.

**Q: What happens if no beams match my filter criteria?**
A: The script will complete without error, but no beams will be recolored. Verify your filter definitions match the actual beam dimensions in your elements.

**Q: Can I use this on individual beams instead of elements?**
A: No, this script is designed to work at the element level. Use other beam-specific scripts for individual beam color changes.

**Q: What color numbers should I use?**
A: Standard AutoCAD color indexes: 1=Red, 2=Yellow, 3=Green, 4=Cyan, 5=Blue, 6=Magenta, 7=White/Black, 8=Dark Gray, etc. Use 0 for ByBlock or 256 for ByLayer.
