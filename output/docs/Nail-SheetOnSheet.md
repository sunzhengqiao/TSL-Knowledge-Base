# Nail-SheetOnSheet.mcr

## Overview
Generates nailing patterns (nail lines) to connect overlapping sheets or panels based on configurable strategies, spacing, and detection rules. This is typically used for sheathing, cladding, or structural panel connections in timber frame models.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model. |
| Paper Space | No | Not applicable for layout generation. |
| Shop Drawing | No | Generates 3D nail data, not 2D drawing views. |

## Prerequisites
- **Required Entities**: Sheets or Panels (e.g., GenBeam entities with sheet properties).
- **Minimum Beam Count**: 0 (Script operates on attached elements).
- **Required Settings**:
  - `Nail-Configuration.xml` (Auto-generated if missing).
  - Painter Definitions (hsbCAD version 23+) to detect overlapping sheets.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Select `Nail-SheetOnSheet.mcr` from the file dialog.

### Step 2: Select Element
```
Command Line: Select Sheet/Panel:
Action: Click on the sheet or panel in the model where you want to apply nailing.
```
*Note: The script will automatically detect overlapping neighbors based on the selected "Painter Contact" property.*

### Step 3: Configure Properties
Action: The properties dialog appears automatically. Set your desired Tool Index, Spacing, and Strategy. Click OK to generate the nails.

### Step 4: (Optional) Save Configuration
If you plan to reuse these settings:
1. Right-click the script instance and select **Save as rule**.
2. Enter a Rule Name.
3. If the rule exists, the command line will ask: `Overwrite existing rule? [No]/Yes`. Type `Y` to overwrite or `N` to cancel.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Tool Index | Number | 1 | Defines the tool (nail gun/fastener) index used for production data. |
| Spacing | Number | 70 mm | Defines the distance between nail centers. |
| Spacing Mode | Dropdown | Fixed Spacing | Options: Fixed Spacing, Even Spacing, Fixed Spacing (Last odd). Determines how spacing is calculated along the line. |
| Strategy | Dropdown | Perimeter | Options: Perimeter, Perimeter + Grid, Grid. Defines the pattern layout (edges only, field, or both). |
| Configuration | Dropdown | | Select a saved configuration preset from the list. |
| Painter Contact | Dropdown | | Selects the Painter Definition used to detect which other sheets are touching/overlapping. |
| Overwrite | Dropdown | No | If Yes, deletes existing nail lines from this script before regenerating. |
| Min Length | Number | 200 mm | The minimum overlap length required to generate a nail line. Prevents nails on small overlaps. |
| Use Fixed Length | Dropdown | No | If Yes, ignores actual sheet thickness and uses a specific nail length. |
| Fixed Length | Number | 100 mm | The explicit length to use when "Use Fixed Length" is Yes. |
| Zone | Number | 1 | Filters which construction elements to process (e.g., Wall=1, Floor=2). |
| Debug | Dropdown | No | If Yes, displays debug text in the model instead of drawing nail lines. |
| Save as rule | Dropdown | No | Set to Yes to save the current settings as a reusable rule. |
| Rule Name | Text | | The name for the new or existing rule. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Edit in Place | Opens the main properties dialog to modify Tool Index, Spacing, Strategy, etc. Updates geometry on OK. |
| Save as rule | Saves the current property settings as a named rule within the selected configuration. |
| Add new Configuration | Creates a new configuration group in the project settings. |
| Remove Configuration | Deletes a configuration group and all its rules from the project settings. |
| Delete rule | Removes a specific named rule from a configuration. |
| Show Rule Definitions | Prints a report of all configurations and their rules to the command line. |

## Settings Files
- **Filename**: `Nail-Configuration.xml`
- **Location**: `Company\TSL\Settings` or `Install\Content\General\TSL\Settings`
- **Purpose**: Stores saved configurations and rules (Tool Index, Spacing, Strategy, etc.) so they can be reused across different elements or projects.

## Tips
- **Configurations**: Use the "Configuration" dropdown to quickly switch between standard nailing patterns (e.g., "Standard Wall Sheathing" vs "Heavy Duty Floor") without manually adjusting parameters every time.
- **Detection Logic**: If nails are not appearing where expected, check the "Painter Contact" property. It must match the Painter Definition assigned to the sheets you want to nail into.
- **Small Edges**: Increase the "Min Length" value if you are seeing unwanted nails on very small corner overlaps or incidental geometry intersections.

## FAQ
- **Q: Why are no nails showing up?**
  A: Check that "Painter Contact" is set correctly and that the sheets actually overlap according to that Painter definition. Also, check if the overlap length is shorter than the "Min Length" setting.
- **Q: Can I nail sheets together that are in different Zones?**
  A: No, the script only processes elements within the same Zone number defined in the properties. Ensure both sheets have the same Zone assignment or adjust the script's Zone property.
- **Q: What does "Fixed Spacing, Last odd" do?**
  A: It places nails at the exact fixed spacing interval, but ensures the last nail is placed at a standard odd offset if the remaining space is too small, often used to maintain consistent edge distances.