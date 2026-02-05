# HSB_G-SetToElement.mcr

## Overview
This utility script allows you to link selected structural items (beams, sheets, or SIPs) to a specific construction Element. It provides options to assign specific "Zone" numbers and classification characters to the items, ensuring they are correctly organized within the project hierarchy for listings and production.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | This is a model organization tool, not a drawing generation script. |

## Prerequisites
- **Required Entities**: At least one GenBeam (beam, sheet, or SIP) and one Element must exist in the model.
- **Minimum Beam Count**: 1
- **Required Settings**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_G-SetToElement.mcr`

### Step 2: Configure Assignment Settings
A dialog will appear automatically upon launch (unless a specific catalog execute key is used).
**Action**: Choose how you want to classify the items you are about to select.
- **Assign to element zone**: Select a number (0-10) to put items in a specific zone, or select "Don't assign" to only link them to the element parent.
- **Zone character**: Select a code (e.g., 'Z' for general, 'E' for element tools) to categorize the item type.
- **Add exclusive**: Select "Yes" to remove the items from any other elements they might currently belong to, or "No" to keep existing associations.

### Step 3: Select Source Entities
```
Command Line: Select a set of beams, sheets or sips
Action: Click on the beams, sheets, or SIPs you wish to modify. Press Enter to confirm selection.
```

### Step 4: Select Target Element
```
Command Line: Select element to set the panhand for the selected entities to.
Action: Click on the main Element (e.g., a Wall or Floor) that you want the selected items to belong to.
```

**Result**: The script updates the data links and then automatically deletes itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Assign to element zone | Dropdown | Don't assign | Selects the specific Zone Number (0-10) within the target element. If "Don't assign" is selected, only the parent link (Panhand) is updated. |
| Zone character | Dropdown | 'Z' for general items | Defines the functional category of the item (e.g., 'Z' for general, 'T' for beam tools, 'E' for element tools). |
| Add exclusive | Dropdown | Yes | If "Yes", the items are removed from any other element groups they previously belonged to. If "No", they are added to this element while keeping previous associations. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script erases itself immediately after execution. No right-click menu options are available after the script runs. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not use external settings files.

## Tips
- **Auto-Delete**: The script instance is removed from the drawing immediately after processing. You cannot change settings afterwards via the Properties Palette; you must run the script again if you need to make changes.
- **Zone Assignment**: If you only want to "parent" the items to an element without setting specific zone data, ensure "Assign to element zone" is set to "Don't assign".
- **Multiple Selection**: You can select multiple beams, sheets, or SIPs in Step 3 using standard AutoCAD selection windows (Crossing or Window).

## FAQ
- **Q: Where did the script go after I used it?**
  **A:** This is a "transient" utility script. It automatically deletes itself from the model once it has finished updating the element data.
- **Q: What is the difference between "Assign to element zone" and just linking?**
  **A:** Linking (Panhand) groups the item under the element structurally. Assigning a "Zone" adds a specific attribute (index 0-10) often used for detailed filtering in production lists or reports.
- **Q: What does "Exclusive" mean?**
  **A:** If set to "Yes", the script will ensure the selected items belong *only* to the newly selected element, severing ties to any other elements they were previously assigned to.