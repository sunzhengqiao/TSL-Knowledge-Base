# GE_HDWR_ITW_TDS.mcr

## Overview
Generates a 3D model of a Continuous Rod Tie-Down System (ITW style) for timber frame walls. This script calculates and places threaded rods, couplers, take-up devices, bearing plates, and associated reinforcement based on the selected wall geometry.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be inserted in the model where wall elements exist. |
| Paper Space | No | Not designed for shop drawing layouts. |
| Shop Drawing | No | Generates 3D model geometry only. |

## Prerequisites
- **Required Entities**: `ElementWall` entities (wall panels) must exist in the drawing.
- **Minimum beam count**: 0 (This script works with Walls, not Beams).
- **Required settings files**: `hsbFramingDefaults.Inventory.dll` (Must be present in the hsbCAD installation path to populate the Stud Type list).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_HDWR_ITW_TDS.mcr` from the list.

### Step 2: Select Walls
```
Command Line: Select walls
Action: Select the wall panels or entire wall assembly that requires the tie-down system. Press Enter to confirm selection.
```

### Step 3: Specify Insertion Point
```
Command Line: Point
Action: Click a point within the wall run. This point determines the vertical location of the rod run relative to the wall reference.
```

### Step 4: Configure Properties
```
Action: The Properties Palette will open automatically. Adjust the System Type, Stud reinforcement, and Rod dimensions as required. The 3D preview will update based on these settings.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| System type | dropdown | 5/8 | Diameter of the continuous rod (e.g., 5/8", 1/2", 7/8"). |
| Stud type | dropdown | *From DLL* | Specifies the lumber grade/species for the studs (retrieved from Inventory settings). |
| Studs at left | dropdown | 0 | Number of reinforced studs to pack at the start of the wall run (0-5). |
| Studs at right | dropdown | 0 | Number of reinforced studs to pack at the end of the wall run (0-5). |
| Floor system blocking | dropdown | No | Enables or disables wood blocking between floor joists. |
| Straps on blocking | dropdown | No | Enables metal tension straps over the floor blocking (requires Blocking to be Yes). |
| Run Start Options | dropdown | Concrete | Anchorage condition at the bottom (Concrete or Wood beam). |
| Run Termination | dropdown | Top plates | Termination condition at the top (Top plates or Compression Bridge). |
| Anchor bolt Embedment | number | 200 mm / 8 in | Depth the rod extends into the concrete foundation (if Start is Concrete). |
| Rod Extension | number | 75 mm / 3 in | Length of rod projecting past the nut/washer for threading. |
| First Level Coupler Height | number | 300 mm / 12 in | Vertical distance from the bottom to the center of the first coupler. |
| Other Levels Coupler Height | number | 300 mm / 12 in | Vertical distance to couplers on subsequent floor levels. |
| Clear distance between posts | number | 150 mm / 6 in | Required spacing clearance between posts or hardware elements. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Erase | Removes the TSL instance and generated 3D bodies from the drawing. |
| Recalculate | Updates the geometry if associated walls are modified or properties change (also available via property updates). |

## Settings Files
- **Filename**: `hsbFramingDefaults.Inventory.dll`
- **Location**: `...\Utilities\hsbFramingDefaultsEditor\` (hsbCAD Install path)
- **Purpose**: Provides the list of available lumber items for the "Stud type" dropdown property.

## Tips
- **Insertion Point Matters**: Ensure you click the insertion point inside the bounds of the wall elements. If the point is outside, the script will fail to find a reference and erase itself.
- **Automatic Updates**: If you stretch or move the associated walls, the tie-down rods and couplers will automatically recalculate their length and position.
- **Top Termination**: Use the "Compression Bridge" option if your design requires a specialized bridge termination rather than standard bearing on top plates.

## FAQ
- **Q: Why did the script disappear immediately after insertion?**
  **A:** The insertion point was likely outside the physical boundary of the selected walls, or the selected walls did not align correctly. Verify your selection and click inside the wall area.
- **Q: Can I use this for a single story or multi-story walls?**
  **A:** This script is designed to handle continuous runs. It calculates coupler heights for the first level and subsequent levels differently, making it suitable for multi-story stacks.
- **Q: What happens if I change the "System type" to a larger diameter?**
  **A:** The 3D geometry of the rods, nuts, and washers will update to reflect the new size. Ensure your wall framing has sufficient space for the larger hardware.