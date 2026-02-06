# hsbScrewStudTie.mcr

## Overview
Automates the insertion of stud tie screws (center stud locks) at T-connections between wall studs and top or bottom plates. It supports batch processing for entire wall elements using rulesets or manual placement for individual beam connections.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Intended for use in the 3D model. |
| Paper Space | No | Not supported in layout views. |
| Shop Drawing | No | Not used for generating 2D drawings directly. |

## Prerequisites
- **Required Entities**: An `Element` (pre-defined wall) or two `GenBeams` (Stud and Plate).
- **Minimum Beam Count**: 2 (One Stud and one Plate intersecting).
- **Required Settings**: `ScrewCatalog.xml` (Must be present in `\\Company\TSL\Settings\` or the installation `Content\General\TSL\Settings\` folder).

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT` → Select `hsbScrewStudTie.mcr` from the list.

### Step 2: Select Insertion Mode
```
Command Line: Select insertion mode => [Element/Beams]
Action:
  - Press ENTER to select [Element] (Batch mode for a whole wall).
  - Type "B" and press ENTER to select [Beams] (Manual mode for a single connection).
```

### Step 3: Select Geometry
- **If Element Mode:** Click on the Wall Element containing the studs and plates you wish to process.
- **If Beams Mode:** Click on the **Stud** (vertical beam), then click on the **Plate** (horizontal beam) to define the connection point.

### Step 4: Configure Properties
Use the **Properties Palette** (Ctrl+1) to select the Screw Manufacturer, Family, and Ruleset. The screw geometry will update automatically upon selection.

### Step 5: Finish
- **Element Mode:** The script generates screws at all valid locations and then removes itself from the model (only the screws remain).
- **Beams Mode:** The screw instance remains in the model, attached to the two beams.

## Properties Panel Parameters

### Catalog Selection
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Manufacturer | Dropdown | (First in XML) | Select the screw brand (e.g., Simpson, Mitek). |
| Family | Dropdown | (First in XML) | Select the specific product model. |
| Length | Dropdown | (First in XML) | Select the physical length of the screw (mm). |
| Material | Dropdown | (Catalog Dependent) | Select the material finish (e.g., Galvanized, Stainless). |

### Ruleset (Element Mode Only)
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Position | Dropdown | Top plate | Set connection to Top plate, Bottom plate, or Both plates. |
| Distribution | Dropdown | Every Stud | Pattern: Every Stud, Every odd Stud, or Every even Stud. |
| Opening rule | Dropdown | Screws in King studs... | Logic for windows/doors: King studs only, King + Cripples, or No rule. |

### Drill Options
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Drill | Dropdown | No | Enable or disable drilling a hole in the stud. |
| Diameter | Number | 0 | Diameter of the drill hole (mm). |
| Depth | Number | 0 | Depth of the drill hole (mm). |

### Filter
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Painter | Dropdown | <Disabled> | Filter studs based on a Painter definition (e.g., only load-bearing walls). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the screw position and geometry if beams have moved or properties changed. |
| Properties | Opens the Properties Palette to edit parameters. |
| Erase | Removes the screw instance. |

## Settings Files
- **Filename**: `ScrewCatalog.xml`
- **Location**: `\Company\TSL\Settings\` or `Content\General\TSL\Settings\`
- **Purpose**: Contains all geometric data for available screw manufacturers, families, and dimensions.

## Tips
- **Element Mode Behavior:** When using Element mode, the script acts as a "Manager". It creates the individual screws and then deletes itself. To change settings later, you typically need to erase the generated screws and run the script again, or edit the screws individually if they are independent instances.
- **Drill Holes:** If you enable drilling, ensure the Diameter is slightly larger than the screw shank to avoid clashes.
- **Openings:** Use the "Opening rule" to prevent unnecessary screws in cripple studs above windows, saving material and time.

## FAQ
- **Q: Why can't I see the "Distribution" or "Opening rule" properties?**
  **A:** These are only available in **Element Mode**. If you are in **Beams Mode**, they are hidden because the placement is manually determined by your selection.
  
- **Q: Why did the script disappear immediately after I ran it?**
  **A:** You likely used **Element Mode**. This is normal behavior; the script finishes its job (placing screws) and removes itself to keep the model clean. The screws should remain in the wall.

- **Q: The tool says "Could not find manufacturer data". What do I do?**
  **A:** The `ScrewCatalog.xml` file is missing or misplaced. Ask your CAD Manager to ensure it is located in the correct Company or Install settings folder.