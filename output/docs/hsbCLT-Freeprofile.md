# hsbCLT-Freeprofile

## Overview
This script generates CNC free-profile milling operations on CLT panels based on a selected polyline path. It supports tool definition either via an internal XML configuration file or directly through the AutoCAD Properties Palette.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D GenBeam entities and polylines. |
| Paper Space | No | Not designed for layout or sheet generation. |
| Shop Drawing | No | Machining operations are applied in the model environment. |

## Prerequisites
- **Required Entities**: At least one GenBeam (CLT Panel) and one Polyline (defining the tool path).
- **Minimum Beam Count**: 1
- **Required Settings**:
  - XML Settings file (`hsbCLT-Freeprofile.xml`) is optional but recommended for saving standard configurations.
  - Catalog entry (if using `nMode=1` to specify tools from a catalog).

## Usage Steps

### Step 1: Launch Script
```
Command: TSLINSERT
Action: Select the file "hsbCLT-Freeprofile.mcr" from the file browser.
```

### Step 2: Select Panels
```
Command Line: Select beams/panels:
Action: Click on one or multiple CLT panels (GenBeams) you wish to machine. Press Enter to confirm selection.
```

### Step 3: Select Polyline
```
Command Line: Select polyline:
Action: Click on the polyline that defines the shape of the free-profile cut.
```

### Step 4: Configure Tool
*(This step varies depending on the `nMode` property)*
- **If nMode = 0 (Default/XML Mode)**: The script uses default settings. To modify them, right-click the script instance in the model and select **Configure Tool**.
- **If nMode = 1 (Catalog Mode)**: Select the script instance and open the **Properties Palette** (Ctrl+1). Modify the Tool Diameter, Length, and Index directly in the palette.

### Step 5: Verify Visualization
- Check the generated colored preview bodies on the panel.
- If adjustments to color or transparency are needed, right-click and select **Configure Display**.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **nMode** | Integer | 0 | **Operation Mode**: 0 = Use XML Settings (saved with script); 1 = Use OPM Properties (saved in element). |
| **sToolname** | String | "" | Name of the tool (e.g., "Cutter 20mm"). Used for identification in lists/Catalog. |
| **dDiameter** | Double | 0 | Diameter of the milling cutter (mm). The polyline will be offset by half this value. |
| **dLength** | Double | 0 | Functional cutting length of the tool (mm). |
| **nToolindex** | Integer | 0 | Magazine slot number on the CNC machine. |
| **dLineApproxAccuracy** | Double | 0.1 | Chordal tolerance for converting curves to linear segments (mm). Lower = smoother curves, larger file size. |
| **nColor** | Integer | 7 | Visual color for the "Display" preview body (AutoCAD Color Index). |
| **nColor2** | Integer | 7 | Visual color for the "Extrusion" preview body. |
| **nColor3** | Integer | 7 | Visual color for the "Contour" preview body. |
| **nTransparency** | Integer | 50 | Transparency level (0-100) for the preview body. |
| **sDimStyle** | String | *Current* | Dimension style used for generated labels. |
| **dTextHeight** | Double | 0 | Height of text annotations (mm). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Configure Display** | Opens a dialog (or swaps Properties Palette view) to modify visualization settings like Color, Transparency, and Dimension Styles for the preview bodies. |
| **Configure Tool** | Opens a dialog to modify machining parameters (Diameter, Length, CNC Mode, Accuracy) and save them to the internal XML map. |
| **Import Settings** | Reloads the configuration from the `hsbCLT-Freeprofile.xml` file, overwriting current memory settings. |
| **Export Settings** | Saves the current tool and display configuration to the `hsbCLT-Freeprofile.xml` file for use in other projects. |
| **Flip Side** | Inverts the side of the panel where the tool is applied (Top/Bottom or Left/Right). |

## Settings Files
- **Filename**: `hsbCLT-Freeprofile.xml`
- **Location**:
  - Priority: `_kPathHsbCompany\TSL\Settings`
  - Fallback: `_kPathHsbInstall\Content\General\TSL\Settings`
- **Purpose**: Stores tool dimensions, CNC parameters, and display preferences. This allows standard configurations to be shared across a project or company without re-entering data for every instance.

## Tips
- **Project vs. Element Settings**: Use `nMode = 0` if you want to update the tool size once and have it apply to all instances using that XML configuration. Use `nMode = 1` if you need unique tool settings for specific panels.
- **Export Settings**: After setting up your perfect tool configuration, use the **Export Settings** right-click option to back it up to the XML file.
- **CNC Data**: Ensure the `dLineApproxAccuracy` is set appropriately. For high-quality curved cuts, set this lower (e.g., 0.5mm or less), but be aware it increases the G-Code file size.

## FAQ
- **Q: I changed the diameter in the Properties Palette, but nothing happened.**
  - **A**: Check your `nMode` property. If it is set to `0` (XML Mode), the script reads from the XML map, not the individual properties. Change `nMode` to `1` to enable direct editing in the palette, or use the "Configure Tool" right-click menu.
- **Q: How is the tool path calculated relative to my polyline?**
  - **A**: The script calculates the center of the tool path. The final cut on the panel will be offset from your selected polyline by half of the `dDiameter` value.
- **Q: Where do I put the XML file so the script finds it?**
  - **A**: Place it in your company folder under `...\TSL\Settings`. If the script cannot find it there, it will look in the hsbCAD installation directory.