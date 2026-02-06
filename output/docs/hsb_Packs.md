# hsb_Packs.mcr

## Overview
Inserts Backer Blocks (stiffeners) and/or Squash Blocks (load packers) onto a supporting beam to stabilize joists or transfer loads, commonly used in timber floor and roof framing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used for 3D detailing and BIM modeling. |
| Paper Space | No | Not applicable for 2D drawings. |
| Shop Drawing | No | Not a shop drawing generation script. |

## Prerequisites
- **Required Entities**: At least one `GenBeam` (supporting beam) must exist in the model.
- **Minimum Beam Count**: 1.
- **Required Settings**: The file `Materials.xml` must exist in your company folder structure (`...\Abbund\Materials.xml`) to provide material grades.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_Packs.mcr` from the list.
*The Properties palette will open to allow configuration before insertion.*

### Step 2: Configure Properties
In the Properties palette (OPM), set the desired dimensions and types:
- Choose **Insertion Mode** (Single or Multiple).
- Set dimensions for **Backer Block Width/Height/Thickness** and **Squash Block Thickness**.
- Select **Type** (Backer Block, Squash Block, or Both).
- Select **Shape** (Left, Right, or Both sides relative to the point).
- Set **Material** and **Names** as required.

### Step 3: Select Beam(s)
The command line prompt depends on the Insertion Mode selected in properties.

**If Mode = Single Instance:**
```
Command Line: Select Male Beam
Action: Click on the single beam where you want to add packers.
```

**If Mode = Multiple Instance:**
```
Command Line: Select a set of beams
Action: Select multiple beams in the drawing (e.g., using a window or crossing selection) and press Enter.
```

### Step 4: Define Location
**If Mode = Single Instance:**
```
Command Line: Please select a point where you need the Packers
Action: Click on the selected beam to place the packers.
```
*Note: If you click near the end of the beam (within 5mm), the packer snaps to the end. If you click in the middle, it centers at that location.*

**If Mode = Multiple Instance:**
```
Command Line: Please select a point that define the side of the beam to insert the packs
Action: Click a point in the model to define which side (Left or Right) the packers will be applied to for all selected beams.
```

### Step 5: Completion
- **Single Mode**: The script generates the packer beams and applies cuts (if Backer Blocks are used) immediately.
- **Multiple Mode**: The script creates individual script instances for each selected beam and erases the parent "Multiple" instance. You can then grip-edit individual instances later.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Insertion Mode | dropdown | Single Instance | Sets whether to process one beam or a batch of beams at once. |
| Backer Block Width | number | 80.0 | The length of the packer block measured along the beam axis (mm). |
| Backer Block Height | number | 150.0 | The vertical height of the Backer Block (mm). |
| Backer Block Thickness | number | 15.0 | The thickness (depth into the beam) of the Backer Block (mm). |
| Squash Block Thickness | number | 15.0 | The thickness (depth) of the Squash Block (mm). |
| Shape | dropdown | Left | Determines if the packer is placed on the Left, Right, or Both sides of the selection point. |
| Type | dropdown | Backer Block | Selects which component to create: Backer Block, Squash Block, or Both. |
| Name Backer | text | Backer Block | The entity name assigned to created Backer Blocks for lists and BIM data. |
| Name Squash | text | Squash Block | The entity name assigned to created Squash Blocks. |
| Material | dropdown | Default | The timber material grade (e.g., C24, GL24h) read from Materials.xml. |
| Label | text | (Empty) | Custom label text for the packers. |
| Information | text | (Empty) | Additional comments or information. |
| Code Backer | text | (Empty) | Production/assembly code for the Backer Block. |
| Code Squash | text | (Empty) | Production/assembly code for the Squash Block. |
| Color | number | ByLayer | The color index for displaying the new beams. |
| Zones | number | 1 | The construction zone or phase assignment. |

## Right-Click Menu Options
The standard TSL context menu options apply to the script instance after insertion:
- **Erase Instance**: Removes the script and deletes the associated packer beams.
- **Show Dynamic Dialog**: Re-opens the properties dialog for quick changes.

## Settings Files
- **Filename**: `Materials.xml`
- **Location**: `_kPathHsbCompany\Abbund\`
- **Purpose**: Provides the list of available timber material grades used for the **Material** property.

## Tips
- **Mid-Span vs. Ends**: When using Single Instance mode, click precisely on the beam end if you want the packer exactly at the end. The script detects if you are within 5mm of the end. Otherwise, it places the packer centered on your clicked point.
- **Multiple Mode Flexibility**: After using Multiple Instance mode, the script converts the batch into individual Single Instances. This allows you to select and move specific packers later using grip points without affecting the others.
- **Backer vs. Squash**: Remember that **Backer Blocks** cut a pocket into the main beam (machining), while **Squash Blocks** are simply placed against the beam without cutting it.

## FAQ
- **Q: What is the difference between a Backer Block and a Squash Block?**
  - **A:** A *Backer Block* is a vertical stiffener placed between joist webs to prevent rotation (usually requires a pocket cut in the main beam). A *Squash Block* is a block placed under a joist bottom chord to transfer vertical loads to the main beam below (does not cut the main beam).
- **Q: Why did my script disappear after selecting multiple beams?**
  - **A:** This is normal behavior for "Multiple Instance" mode. The parent script spawns individual scripts for every beam you selected and then deletes itself to keep the model lightweight.
- **Q: Can I change the size of the packer after inserting?**
  - **A:** Yes. Select the packer beam (or the script instance grip), open the Properties palette, and modify the dimension parameters (e.g., `dPlateWidth`). The model will update automatically.