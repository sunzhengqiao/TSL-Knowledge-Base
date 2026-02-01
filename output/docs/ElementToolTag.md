# ElementToolTag.mcr

## Overview
This script automatically generates and labels machining tags (such as saw lines, milling lines, drills, and nailing lines) for timber elements. It is designed to create production annotations in both Model Space and Paper Space viewports.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Select elements directly to generate tags. |
| Paper Space | Yes | Select a viewport to tag elements visible in that view. |
| Shop Drawing | Yes | Specifically designed for detailing views. |

## Prerequisites
- **Required Entities**: `Element`, `GenBeam`, `Section2d`, or `ShopDrawView`.
- **Minimum Beam Count**: 0 (Can be used on single elements).
- **Required Settings**: A valid `DimStyle` must exist in the drawing.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `ElementToolTag.mcr` from the list.

### Step 2: Configure Tool Type
A dialog or property prompt appears upon insertion.
1.  Select the desired **Tool** (e.g., Saw Line, Milling Line).
2.  Select the **Zone** (0 for all zones, or a specific index).
3.  Click OK or Enter to confirm.

### Step 3: Select Input (Context Dependent)
The script behaves differently depending on your current workspace:

**If in Paper Space (Layout Tab):**
1.  **Command Line**: `Select a viewport`
2.  **Action**: Click on the border of the viewport where the element is drawn.
3.  **Conditional**: If the viewport does not contain specific element data, the script may prompt you to switch to Model Space to select the element.

**If in Model Space:**
1.  **Command Line**: `Select elements or sections`
2.  **Action**: Click on the timber elements (`Element` or `GenBeam`) or a 2D section you wish to annotate. Press Enter when finished.

### Step 4: Position Tags
1.  **Command Line**: `Pick insertion point`
2.  **Action**: Click in the drawing to define the base location for the annotations.
3.  **Result**: The script generates text labels at the midpoints of the detected machining operations.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zone | dropdown | 0 | Defines which construction zone to analyze. Set to `0` to tag all valid zones (usually -5 to 5). |
| Tool | dropdown | Saw Line | Selects the machining category to visualize (Saw Line, Milling Line, Element Drill, Nailing Line). |
| Format | text | *(Empty)* | Defines the label text template. Leave empty for the default format. Supports dynamic variables (e.g., `@Angle`, `@Diameter`). |
| DimStyle | dropdown | *(First in list)* | Sets the graphical style (font, arrows) for the dimension text. |
| Text Height | number | 0 | Defines the text height. `0` uses the height defined in the selected DimStyle. |
| Color | number | 0 | Defines the text color. `0` = by Zone, `-1` = by Tool Index. Otherwise, uses the specific Autodesk Color Index entered. |
| Layer | dropdown | I | Defines the sublayer for the tag (I, T, E, C, or J). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add/Remove Format | Displays a list of available format variables in the command line. Type the index number to add or remove that variable (e.g., Angle, Diameter) from the label format. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies on standard drawing DimStyles rather than external XML files.

## Tips
- **Zone 0**: Use `Zone = 0` during insertion to automatically create tags for all sides of an element in one operation.
- **Custom Labels**: Use the "Add/Remove Format" right-click option to quickly customize what data appears on the tag without typing complex strings manually.
- **Text Height**: For cleaner shop drawings, set `Text Height` to `0` so the tags automatically scale according to your active DimStyle.

## FAQ
- **Q: Why did the script create multiple tags for one element?**
  **A**: If the `Zone` property is set to `0`, the script detects and tags machining operations on all valid zones of the element. To target a specific side, change the Zone property to a non-zero value.
- **Q: How do I display the cut angle on the tag?**
  **A**: Right-click the script instance and select "Add/Remove Format". The command line will list available variables (usually including `Angle`). Enter the corresponding index to add it to your format string.