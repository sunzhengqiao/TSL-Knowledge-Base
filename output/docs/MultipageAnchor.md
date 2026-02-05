# MultipageAnchor.mcr

## Overview
This script creates a positional anchor that links drafting entities (such as text, dimensions, or blocks) to a specific ShopDrawView or MultiPage. It ensures that annotations remain in the correct relative position even if the drawing layout or view is moved.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary environment for inserting and managing the anchor. |
| Paper Space | Yes | Supported indirectly via MultiPage and ShopDrawView interaction. |
| Shop Drawing | Yes | Automatically generates instances during shop drawing creation. |

## Prerequisites
- **Required Entities**: A valid **MultiPage** or **ShopDrawView** must exist in the drawing.
- **Minimum Beam Count**: 0 (This script is for drafting/layout, not timber elements).
- **Required Settings**: None specific (uses internal properties or catalog defaults).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or `TSLCONTENT`) → Select `MultipageAnchor.mcr`

### Step 2: Select Parent and Linked Entities
**Command Line:** `Select Shopdraw View or multipage and entities to link`
**Action:**
1. Click on the **ShopDrawView** or **MultiPage** you wish to anchor to.
2. Select the additional entities (text, dimensions, symbols) you want to link to that view.
3. Press **Enter** to confirm selection.

*(Note: If the script detects specific contexts, it may restrict the selection to just the ShopDrawView or generic entities, but generally, it allows selecting the parent and children together.)*

### Step 3: Define Anchor Position
**Command Line:** `Specify insertion point`
**Action:** Click in the drawing to place the symbolic anchor. This point determines the relative offset for all linked entities.

### Step 4: Configure Properties (Optional)
If no catalog preset was selected, a properties dialog may appear automatically. You can adjust the **Size** of the anchor symbol here or later in the Properties Palette.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Size | Number | 10 mm | Defines the graphical size of the square anchor symbol and the text height of the linked entity counter. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add Entities | Prompts you to select additional entities to link to the anchor. Automatically filters out structural elements (Beams/TSLs). |
| Remove Entities | Prompts you to select entities currently linked to the anchor to remove them from the group. |

**Note:** Double-clicking the anchor also triggers the **Add Entities** command.

## Settings Files
- **Filename**: None required
- **Location**: N/A
- **Purpose**: This script relies on internal properties and standard catalogs rather than external settings XML files.

## Tips
- **Grouping without Blocks**: Use this script instead of standard CAD Groups if you need items to follow a specific View or MultiPage layout during regeneration.
- **Visual Feedback**: The anchor draws as a square with a number in the center. This number indicates how many entities are currently linked to it.
- **Moving Layouts**: If you move the parent MultiPage or ShopDrawView using standard CAD commands, the anchor and all its linked entities will automatically move to maintain their relative positions.
- **Grip Editing**: You can drag the anchor grip point (`_Pt0`) to reposition the anchor; the linked entities will follow the new offset.

## FAQ
- **Q: Can I link structural beams or elements?**
  **A:** No. The "Add Entities" function automatically filters out TSL Instances, GenBeams, and Elements. It is intended for annotations and drafting symbols only.

- **Q: What happens if my MultiPage becomes empty or invalid?**
  **A:** The script detects if the parent MultiPage is invalid or its ShowSet is empty. If so, it will automatically delete the anchor and the empty MultiPage to prevent errors.

- **Q: Why did the anchor disappear?**
  **A:** The anchor may have erased itself because the linked MultiPage was deleted or found to be invalid. Check that your parent drawing view still exists.