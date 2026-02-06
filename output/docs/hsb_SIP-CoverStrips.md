# hsb_SIP-CoverStrips.mcr

## Overview
Automatically generates cover strips (filler sheets) to bridge gaps between Structural Insulated Panels (SIPs) and adjacent structural components like beams or sheets within a selected Element.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D Elements containing SIP entities. |
| Paper Space | No | Not applicable for 2D layout generation. |
| Shop Drawing | No | Not applicable for detailing views. |

## Prerequisites
- **Required Entities**: Elements containing SIP (Structural Insulated Panel) definitions.
- **Minimum Beam Count**: 0 (Script relies on Element and SIP data).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_SIP-CoverStrips.mcr` from the catalog.

### Step 2: Configure Properties (If Manual Insert)
If the script is run manually (without a pre-configured execute key), a properties dialog will appear.
```
Dialog: Properties
Action: Set the desired Name, Material, and Color for the cover strips, then click OK.
```

### Step 3: Select Elements
```
Command Line: Select one or More Elements
Action: Click on the desired Element(s) in the Model Space and press Enter to confirm.
```
The script will process each selected Element, calculate the gaps between SIPs and other components, and generate the cover strips.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Add Sheet Name | Text | "" | Assigns a specific name to the newly generated cover strips for identification in lists and BIM data. |
| Add Sheet Material Type | Text | "" | Defines the material composition (e.g., 'OSB', 'Plywood') of the cover strips. |
| Add sheet color | Number | 1 | Determines the visual display color (AutoCAD Color Index 1-255) of the generated sheets. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No specific context menu options are added by this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not use external settings files.

## Tips
- The script automatically ignores gaps smaller than 1mm to prevent the creation of tiny, unusable entities.
- The script instance erases itself immediately after generating the geometry. This means the link between the strips and the script is broken once created.
- If you modify the underlying wall geometry (Beams/SIPs), you must delete the existing cover strips and re-run the script to update them.

## FAQ
- **Q: I selected an element, but no sheets were created. Why?**
  **A:** The script only processes Elements that contain SIP entities. If the element is a standard timber frame without SIP data, the script will skip it silently.
- **Q: Can I change the material of the strips after they are created?**
  **A:** Yes. Since the script instance is removed after creation, the resulting sheets become standard hsbCAD Sheet entities. You can select them and modify their properties directly in the Properties Palette.
- **Q: How is the thickness of the cover strip determined?**
  **A:** The script automatically matches the thickness of the existing internal or external SIP layer associated with the gap.