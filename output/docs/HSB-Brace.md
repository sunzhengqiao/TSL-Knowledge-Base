# HSB-Brace.mcr

## Overview
Automatically generates structural studs and interior cladding sheets for knee walls or bracing within a roof element. It processes existing construction beams to create a detailed sub-structure, including vertical supports and sheathing, while managing material assignments and splitting adjacent sheets.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be inserted into the 3D model. |
| Paper Space | No | Not applicable for 2D drawings. |
| Shop Drawing | No | This is a model generation script. |

## Prerequisites
- **Required Entities**: A constructed **Element** containing the main roof structure (e.g., rafters) and draft beams indicating the brace location.
- **Minimum Beam Count**: 0 (but requires specific brace beams to function meaningfully).
- **Required Settings**: Valid Beam Codes in the catalog for Braces, Studs, and Sheets.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB-Brace.mcr` from the file browser.

### Step 2: Configure Properties
The script will load and attach to your cursor. Before placing it, open the **Properties Palette** (Ctrl+1) to configure the script parameters:
- Set the **Beam Codes** to match your catalog (e.g., `KSTL-01` for braces).
- Define **Zones** for sheeting and splitting logic.
- Configure **Material** settings (you can type "Zone 6" to copy material from existing sheets in that zone).

### Step 3: Select Target Element
```
Command Line: Select Element:
Action: Click on the roof Element that contains the rafters and the draft brace beams.
```

### Step 4: Generate Geometry
Once the Element is selected, the script will:
1. Identify the rafters and the brace beams.
2. Generate vertical studs between the brace and rafters.
3. Create interior and cover sheets.
4. Split any existing sheets in the specified zones if required.
5. Erase the original draft brace beams, replacing them with the detailed assembly.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sBmCodeBrace | Text | KSTL-01 | The code of the draft beams that define the brace/knee wall location. These beams will be replaced. |
| sBmCodeSupportingStud | Text | KSTL-02 | The material code to use for the vertical studs generated against the rafters. |
| sBmCodeSheet | Text | KSPL-01 | The material code for the interior sheathing placed on the brace face. |
| sLabelSheet | Text | | Custom label for the interior sheets. |
| sMaterialSheet | Text | | Material name for interior sheets. Type "Zone 6" or "Zone 7" to copy material from existing sheets in those zones. |
| nZnSheet | Number | 6 | The construction zone index for the newly created interior sheets. |
| sZnSheetSplit | Dropdown | 7 | Select a zone (e.g., "7") to split existing sheets in that zone, or "No split" to leave them intact. |
| sBmCodeCoverSheet | Text | KSPL-02 | The material code for the cover sheets (gables/sides). |
| dThicknessCoverSheet | Number | 11 | Thickness of the cover sheets (in mm). |
| sLblCoverSheet | Text | | Custom label for the cover sheets. |
| sMatCoverSheet | Text | | Specific material name override for cover sheets. |
| sInfoCoverSheet | Text | | Additional comment or information field for cover sheets. |
| nZnCoverSheet | Number | 8 | The construction zone index for the cover sheets. |
| nColorCoverSheet | Number | 1 | The AutoCAD color index (1-255) for displaying the cover sheets. |
| beamFilterDefinition | Text | | Catalog name of an external filter script (HSB_G-FilterGenBeams) to identify rafters. |
| sFilterBC | Text | ZKRB-03;... | Semicolon-separated list of beam codes identifying the rafters. Used only if 'beamFilterDefinition' is empty. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Update | Re-runs the calculation based on current properties and geometry. |
| Erase | Removes the script instance from the element. |
| Properties | Opens the Properties Palette to edit parameters. |

## Settings Files
- **Filename**: `HSB_G-FilterGenBeams.mcr`
- **Location**: TSL Catalog
- **Purpose**: (Optional) Provides advanced filtering logic to identify rafters if the default string list is insufficient.

## Tips
- **Material Inheritance**: To ensure the new sheets match the rest of the roof, set `sMaterialSheet` to **"Zone 6"** (or the zone number your current roof sheets are in). The script will automatically find and apply the correct material.
- **Sheet Splitting**: If your brace passes through existing floor or wall sheets, set `sZnSheetSplit` to the zone containing those sheets. The script will automatically cut holes or split them around the new brace geometry.
- **Workflow**: Draw the generic "Brace" beams manually first to define the location, then run this script to convert them into the detailed framed structure.

## FAQ
- **Q: Why did my original brace beams disappear?**
  - A: The script is designed to "consume" the draft beams defined in `sBmCodeBrace`. It uses them to calculate the geometry and then replaces them with the specific studs and sheets defined in the script.
- **Q: How do I change the rafter selection?**
  - A: If your rafters don't match the default codes in `sFilterBC`, you can either update that list with your specific codes (separated by semicolons) or select a custom filter script in `beamFilterDefinition`.