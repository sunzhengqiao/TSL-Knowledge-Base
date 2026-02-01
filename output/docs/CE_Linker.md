# CE_Linker

## Overview
This script is used to install and manage parametric sub-assemblies (Collection Entities) onto structural beams. It automates the generation of machining details (drills and cuts) and hardware components based on a selected assembly definition.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script runs in Model Space to apply connections to beams. |
| Paper Space | No | Not applicable for Paper Space. |
| Shop Drawing | No | Outputs machining data and hardware lists for drawings, but is not a drawing layout script. |

## Prerequisites
- **Required Entities**: At least one GenBeam (Beam or Panel). You also need an existing Collection Entity in the model to define the assembly type upon insertion.
- **Minimum Beam Count**: 1 (Parent Beam).
- **Required Settings**:
  - Valid Collection Definitions (.hsc or .hc files) must be available in the project.
  - `Materials.xml` (Optional): Located at `_kPathHsbCompany\Abbund\Materials.xml`. Used for calculating hardware weights.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `CE_Linker.mcr` from the list.

### Step 2: Define Assembly Type
```
Command Line: Select Existing
Action: Click on an existing Collection Entity in the model to use as a template. 
Note: You must select an existing entity. If you press Esc or click nothing, the script will report "Nothing selected" and erase itself.
```

### Step 3: Select Parent Beam
```
Command Line: Select Main Beam/Panel (Parent)
Action: Click the primary beam or panel that will host the connection.
```

### Step 4: Select Child Beams
```
Command Line: Select Other Beams/Panels (Children)
Action: Click any secondary beams involved in the connection. 
Note: This step is optional. Press Enter to finish if only the parent beam is involved.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Assembly Name | dropdown | *Dynamic* | The name of the Collection Entity definition applied to the beams. |
| Installation | dropdown | Installed | Determines if the hardware is "Installed" or "Shipped Loose". Affects BOM and filtering. |
| Apply Drills | dropdown | Yes | Toggles the generation of drill holes on the beams. |
| Shopdraw Notes | text | | Custom notes for the shop floor or installer regarding this instance. |
| Show Label? | dropdown | Yes | Toggles the visibility of the 3D assembly label in the model. |
| Manufacturer | text | Generic | The name of the hardware manufacturer (e.g., Simpson, MiTek). |
| Text Height | number | 1.0 | Height of the origin/identifier text in the model (mm). |
| Label Text Height | number | 25.0 | Height of the assembly label text (mm). |
| Parent Entity | number | -1 | (Read-only) The Entity number of the parent beam. |
| Label Text Color | number | 30 | The AutoCAD color index for the label. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Reselect Parent Beam | Prompts you to select a new primary beam to replace the current parent. |
| Reselect Child Beams | Clears current child beams and prompts you to select new ones. |
| Reselect All Beams | Clears all links and prompts you to select the Parent and Children again from scratch. |
| Pick New Custom Assembly | Opens the Properties dialog to allow you to select a different Assembly Name (Collection Entity). |

## Settings Files
- **Filename**: `Materials.xml`
- **Location**: `_kPathHsbCompany\Abbund\Materials.xml`
- **Purpose**: Provides material density values (specifically for Steel) to calculate the weight of the generated hardware components.

## Tips
- If you need to change the type of connection after placing the script, use the **Pick New Custom Assembly** option in the right-click menu instead of deleting and re-inserting.
- To keep your model view clean, set **Show Label?** to "No" once you have verified the installation.
- The script automatically filters duplicate beams; if you accidentally click the same beam twice, it will only be linked once.

## FAQ
- **Q: The script disappeared immediately after I tried to insert it. Why?**
  **A:** You likely did not select a Collection Entity when prompted to "Select Existing". This script requires you to click an existing assembly definition in the model to know what type of connection to build.
- **Q: How do I stop the script from drilling holes in my beam?**
  **A:** Select the script instance, open the Properties Palette, and change **Apply Drills** to "No".
- **Q: Can I use this for single-sided connections?**
  **A:** Yes. When prompted to "Select Other Beams/Panels (Children)", simply press Enter without selecting anything.