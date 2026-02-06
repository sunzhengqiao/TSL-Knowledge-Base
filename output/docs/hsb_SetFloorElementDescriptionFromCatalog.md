# Set Floor Element Description from Catalog

## Overview
Applies saved catalog settings to floor or roof elements, automatically updating their edge detail descriptions and framing parameters.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary usage environment for element configuration |
| Paper Space | No | Not applicable |
| Shop Drawing | No | Not applicable |

## Prerequisites
- One or more Floor or Roof elements must exist in the drawing
- Catalog definitions must be previously created for the floor/roof element types
- The catalog name must match exactly (case-insensitive matching is supported)

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_SetFloorElementDescriptionFromCatalog.mcr`

### Step 2: Configure Catalog Name
If no catalog/preset is being used, a properties dialog will appear.
- Enter the **Catalog Name** that matches a saved element catalog

### Step 3: Select Elements
AutoCAD Command Line: **"Select a set of elements"**
- Click on one or more floor or roof elements
- Press **Enter** to complete selection

### Step 4: Automatic Processing
The script will:
1. For each selected element, invoke **hsb_SetBeamNameFloor** to configure beam naming
2. Search for a matching catalog definition (case-insensitive)
3. Apply the catalog values to the element if a match is found
4. Automatically erase itself after completion

## Properties Panel Parameters
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Catalog Name | Text | (empty) | Name of the floor/roof element catalog containing edge detail settings, framing rules, and other element parameters |

## Right-Click Menu Options
This script does not provide context menu options.

## Settings Files
**Element Catalogs:**
- **Source**: Floor/Roof element catalog definitions stored within the drawing
- **Creation**: Use the element's native catalog management tools to create named catalogs
- **Matching**: Catalog name matching is case-insensitive (e.g., "STANDARD" matches "standard")

## Tips
- **Create catalogs first**: Before using this script, configure a floor/roof element with desired settings and save it as a catalog through the element's properties interface
- **Case-insensitive names**: The script performs uppercase comparison, so "MyFloor", "MYFLOOR", and "myfloor" are treated as identical
- **Automatic beam naming**: The script automatically inserts **hsb_SetBeamNameFloor** for each element, ensuring beam naming consistency
- **Bulk assignment**: Select multiple elements to apply the same catalog to all of them in one operation
- **Tool Palette shortcuts**: Use this script from a Tool Palette with an execute key to skip the dialog and apply a specific catalog immediately

## FAQ

**Q: What happens if the catalog name doesn't match?**
A: If no matching catalog is found, the element is left unchanged. Verify the exact catalog name using the element's catalog list.

**Q: Where are the catalog definitions stored?**
A: Catalog definitions are stored within each floor/roof element type internally in the drawing. Use the element's "Get List of Catalog Names" function to see available catalogs.

**Q: Can I use this on walls?**
A: No, this script is specifically designed for Floor and Roof elements (ElementRoof type). Use corresponding wall-specific scripts for wall elements.

**Q: What settings are included in a floor element catalog?**
A: Element catalogs typically include edge detail descriptions (DSP), framing rules, beam spacing, blocking configurations, and material assignments. The exact contents depend on how the catalog was created.

**Q: What does "hsb_SetBeamNameFloor" do?**
A: This helper script is automatically inserted by the main script to ensure beam naming conventions are properly applied to the element's beams before catalog settings are assigned.

**Q: Can I skip the dialog when running this script?**
A: Yes, use the script with an execute key (from Tool Palette or programmatically) to automatically use a predefined catalog name without showing the dialog.

**Q: Is "Generate Element" option available?**
A: Previous versions included a "Generate Element" option to automatically regenerate construction. This feature is currently commented out in the script code.
