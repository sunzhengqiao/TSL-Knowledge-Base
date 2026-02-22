# instaCell

MEP (Mechanical, Electrical, Plumbing) Installation Cell Tool

---

## Overview

The **instaCell** script creates a single installation cell that represents a penetration or routing point for MEP services (electrical outlets, plumbing fixtures, HVAC connections) in timber panels. These cells are designed to work within the **instaCombination** system, which manages multiple cells along a defined path.

This tool is particularly useful for:
- Electrical installations (outlets, switches, junction boxes)
- Sanitary/plumbing penetrations
- HVAC routing through CLT/SIP panels
- Any MEP service requiring defined openings in timber construction

The script creates parametric machining operations (drills, mortises, beam cuts, or octagon cuts) that automatically update when the parent element or combination changes.

---

## Environment

| Property | Value |
|----------|-------|
| Type | O (Object) |
| Version | 3.4 |
| Keywords | Electra, Sanitary, Sip, Installation, CLT, BSP |
| Requires | Part of "insta" suite (instaCombination, instaCell, instaConduit) |
| Model Space | Yes |
| Paper Space | No |

---

## Prerequisites

Before using instaCell, ensure:

1. **Parent Combination**: An **instaCombination** must already exist in the drawing. The cell cannot function independently.

2. **Target Element**: The cell must be placed on one of the following:
   - Stickframe wall element (ElementWallSF)
   - Stickframe roof element (ElementRoof)
   - SIP panel
   - Loose GenBeam

3. **Block Library** (Optional): For visual symbols, blocks can be stored in:
   - Company path: `[Company]\Block\insta\`
   - Organized by Category and Subcategory subfolders

4. **Settings File**: Configuration is read from `instaCombination.xml` located in:
   - Company: `[Company]\TSL\Settings\`
   - Install: `[Install]\Content\General\TSL\Settings\`

---

## Usage

### Inserting a New Cell

1. Run the insertion command or select from the TSL browser
2. A properties dialog appears to configure the cell
3. Select an existing **instaCombination** when prompted: "Select combination"
4. Click a point to position the cell along the combination path

### Workflow

1. **Create Combination First**: Insert an instaCombination on your target element
2. **Add Cells**: Insert instaCell instances and link them to the combination
3. **Configure Tools**: Set the tool type (Drill, Mortise, etc.) and dimensions
4. **Assign Block**: Select a symbol block for element view display
5. **Add Hardware**: Attach hardware components if needed

---

## Parameters

### Tool Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Tool** | List | Drill | Tool type: Drill, Mortise, Beamcut, or Octagon |
| **Diameter** (or Width) | Double | 68 mm | Diameter for drills/octagons, width for mortise/beamcut |
| **Height** | Double | 68 mm | Height of mortise/beamcut; tangent height for octagon (0 = regular octagon). Hidden for Drill tool. |
| **Depth** | Double | 68 mm | Cutting depth (0 = complete through) |
| **Radius** | Double | 0 | Explicit corner radius for mortise (when height > 0). Only visible for Mortise tool. |
| **Tool Index** | Integer | 1 | CNC tool index for element tools. Hidden if element does not support tools. |
| **Diameter Through Drill** | Double | 0 | Optional secondary through-drill diameter (0 = none) |
| **Offset** | Double | 1 mm | Spacing offset to adjacent cells |

### Model Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Blockname** | List | Disabled | Symbol block for element view display. Lists all available blocks from the block library. |

### Tool Types Explained

- **Drill**: Circular hole with specified diameter and depth
- **Mortise**: Rectangular pocket with rounded corners, ideal for outlet boxes
- **Beamcut**: Full-depth rectangular cut through the member
- **Octagon**: Eight-sided cut, with adjustable tangent height for shape control

---

## Context Menu

Right-click on an instaCell to access these commands:

| Command | Description |
|---------|-------------|
| **Hide Tools** | Hide CNC tool visualization in element view |
| **Show Tools** | Display CNC tool visualization |
| **Swap Width <-> Height** | Exchange width and height values (Mortise/Beamcut only, when dimensions differ) |
| **Set block definition** | Select a block reference and configure its category/subcategory, then save to the block library |
| **Store hardware in block definition** | Save current hardware components into the block file for reuse across all instances |
| **Show all Commands for UI Creation** | Display command strings for creating custom toolbar buttons |

---

## Tips

### Block Management

- Blocks are automatically discovered from `[Company]\Block\insta\` with category/subcategory folder structure
- When selecting a new block, it is automatically imported and tagged with instaCell metadata
- Hardware components attached to the cell can be stored within the block definition for reuse
- The "Store hardware in block definition" option is only available when a valid block is selected

### Tool Selection

- Use **Drill** for round penetrations (cables, pipes)
- Use **Mortise** for electrical boxes and rectangular fixtures
- Use **Beamcut** for full-depth rectangular openings
- Use **Octagon** for specialized hardware requiring non-circular, non-rectangular cuts
- When switching from Drill to Mortise/Beamcut, Height is automatically set equal to Width
- When switching to Drill or Octagon, Height is automatically reset to 0

### Performance

- Block definitions are cached in a MapObject for faster loading in drawings with many blocks
- Set tool mode to "byCombination" (in parent instaCombination) to defer machining operations and process multiple cells efficiently
- When in "byCombination" mode, tool outlines are displayed but not applied to beams

### Element Tools

- For stickframe walls and roofs, element-level CNC tools (ElemDrill, ElemMill) are automatically generated
- Tool visibility can be toggled via the context menu
- The cell is automatically assigned to the appropriate element zone based on face direction
- Zone 0 assignments use Z-Layer for layer management

### Visual Indicators

- A half-filled display indicates which face the cell penetrates from
- Different colors distinguish front-face vs. back-face installations (configurable in settings)
- The block symbol is displayed in element view at the configured scale
- Plan view and element view have independent color and scale settings

### Creating Custom Toolbar Buttons

Use the "Show all Commands for UI Creation" context menu option to get copy-paste ready command strings for:
- Direct insertion: `^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "instaCell")) TSLCONTENT`
- Catalog-based insertion (silent, no dialog): `^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "instaCell" "CatalogName")) TSLCONTENT`
- Tool visibility control
- Block definition management

### Version Compatibility

- On first insertion, the script compares settings file versions between Company and Install paths
- A notice is displayed if versions differ, allowing you to review and update settings as needed

---

## FAQ

**Q: Why did I get a notice about version mismatch when inserting?**
A: The script detected that the version of `instaCombination.xml` in your Company folder differs from the default installation version. Review the settings to ensure compatibility.

**Q: Can I use this without a beam?**
A: The cell requires an instaCombination parent. Without a valid element or GenBeam, the instance will be deleted with the message "Invalid reference. Tool will be deleted".

**Q: How do I add standard hardware to an electrical box?**
A: Insert the hardware on the instance using the hardware dialog, then right-click and select "Store hardware in block definition" to save them as part of the block for future use.

**Q: What happens if my selected block is not found?**
A: The Blockname is automatically reset to "Disabled" with a message indicating the change.
