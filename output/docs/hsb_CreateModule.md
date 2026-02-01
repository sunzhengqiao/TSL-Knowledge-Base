# hsb_CreateModule.mcr

## Overview
Groups selected beams into a logical module and standardizes their material, grade, and visual properties.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D beam elements. |
| Paper Space | No | Not designed for layout space. |
| Shop Drawing | No | Not designed for generating views. |

## Prerequisites
- **Required entities**: Beams (GenBeam).
- **Minimum beam count**: 1 or more.
- **Required settings files**: `Abbund\Materials.xml` (must exist in the Company folder).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_CreateModule.mcr`

### Step 2: Configure Properties
```
Action: The Properties Palette (OPM) opens automatically.
1. Enter a Name for the beams (optional).
2. Select a Material from the dropdown list.
3. Enter a Grade (e.g., C24).
4. Set the Color index (default is Yellow/2).
```

### Step 3: Select Beams
```
Command Line: Select beams
Action: Click on the beams you wish to group and modify in the model. 
Press Enter or Right-click to confirm selection.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Name | Text | "" | Assigns a specific name label to the beams for reports or drawings. |
| Material | dropdown | (First in list) | Defines the wood species or product type. List is loaded from your company materials file. |
| Grade | Text | "" | Defines the structural strength grade (e.g., C24, GL24h). |
| Color | Number | 2 | Sets the AutoCAD display color (1-255) for the selected beams. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add persistent right-click menu options as it deletes itself after running. |

## Settings Files
- **Filename**: `Abbund\Materials.xml`
- **Location**: Company folder (`_kPathHsbCompany`)
- **Purpose**: Provides the list of available materials for the Material property dropdown.

## Tips
- Ensure you have run the `hsbMaterial` utility previously; otherwise, the script will fail to find the materials list.
- The script assigns a Module ID based on the first beam selected, linking them logically in the database.
- The script instance erases itself immediately after execution; you cannot edit the script properties later, only the modified beams.

## FAQ
- **Q: Why does the script disappear after I select the beams?**
  A: This is a "run-once" script. It applies the changes to the beams and then removes itself from the drawing to keep the file size optimized.

- **Q: I get a notice "Materials not been set". What do I do?**
  A: The script cannot find `Abbund\Materials.xml`. Run the `hsbMaterial` utility to generate the required settings file or contact your support desk to restore the file.