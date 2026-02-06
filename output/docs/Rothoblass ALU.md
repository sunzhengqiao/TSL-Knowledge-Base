# Rothoblass ALU

## Overview
Generates and inserts Rothoblaas ALU connectors (AluMini, AluMidi, AluMaxi) for timber-to-timber or timber-to-concrete connections. The script automatically handles the creation of 3D brackets, beam machining (slots and housings), and hardware assignment (nails, screws, and dowels).

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D beams and geometry. |
| Paper Space | No | Not designed for 2D layout views. |
| Shop Drawing | No | Does not generate dimensions or labels for drawings. |

## Prerequisites
- **Required Entities:** At least two `GenBeam` elements.
- **Minimum Beam Count:** 1 Male beam (shank side) and 1 Female beam (wing side).
- **Required Settings:** None (Catalog entries for families MINI, MIDI, MAXI are optional but recommended).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Rothoblass ALU.mcr`

### Step 2: Select Male Beams
```
Command Line: Select one or multiple male beams
Action: Click the beam(s) that will connect into the side of the other beam (the side receiving the connector "shank").
```

### Step 3: Select Female Beams
```
Command Line: Select a set of female beams
Action: Click the beam(s) that will receive the connection on their face (the side receiving the connector "wing").
```

### Step 4: Configure Properties
After selection, the script inserts the connector. Select the script instance in the model to open the **Properties Palette** and adjust dimensions, modes, and machining gaps as needed.

## Properties Panel Parameters

### Connection Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type | dropdown | Auto detect | Sets the height of the bracket. "Auto detect" picks the largest size that fits. Options vary by Family (e.g., 65, 95, 125, etc.). |
| Connection Mode | dropdown | Wood/Wood | Defines the connection scenario. <br>- **Wood/Wood**: Uses nails/screws for timber.<br>- **Wood/Concrete with Screw**: Uses screw-in anchors.<br>- **Wood/Concrete with chemical Dowel**: Uses chemical dowels. |
| Shank Drills | dropdown | No | "Yes" includes holes on the vertical shank for through-bolting/pins. "No" uses self-perforating pins. |
| Gap between Beams | number | 3.0 mm | The spacing distance between the end of the male beam and the face of the female beam. |
| Offset Z-Direction | number | 0.0 mm | Vertical adjustment of the connector assembly relative to the beam's local Z-axis. |

### Housing Settings (Female Beam)
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Housing Type | dropdown | Bottom | Vertical position of the pocket cut in the female beam. Options: Bottom, Centered, Top, None. |
| House gap | number | 2.0 mm | Tolerance clearance added to the width and height of the pocket. |
| Extra house depth | number | 2.0 mm | Additional depth of the pocket cut beyond the bracket thickness. |

### Slot Settings (Male Beam)
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Slot | dropdown | Top | Location of the slot cut in the male beam. Options: Top, Bottom, Full height. |
| Gap (X) | number | 20.0 mm | Extra length added to the slot cut (along beam axis). |
| Gap (Y) | number | 2.0 mm | Extra width added to the slot cut. |
| Gap (Z) | number | 2.0 mm | Extra depth added to the slot cut. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| MINI | Changes the bracket family to MINI and auto-detects the appropriate type. Updates available sizes. |
| MIDI | Changes the bracket family to MIDI and auto-detects the appropriate type. |
| MAXI | Changes the bracket family to MAXI and auto-detects the appropriate type. |
| Extend length to be cut from rod | Extends the list of available types in the Properties Palette to include custom lengths up to the maximum rod length. |

## Settings Files
- **Catalog Entries**: `MINI`, `MIDI`, `MAXI` (Optional)
- **Location**: Company standard or hsbCAD installation path.
- **Purpose**: Pre-define default geometric data and size limits for the different bracket families.

## Tips
- **Quick Size Change**: Use the Right-Click menu (MINI/MIDI/MAXI) to switch between connector families without re-inserting the script.
- **Auto Detect**: Leave the **Type** property as "Auto detect" initially. The script will calculate the largest possible bracket that fits the geometry.
- **Concrete Connections**: When attaching to concrete, change the **Connection Mode** to automatically switch fasteners from wood nails to concrete anchors or dowels.
- **Machining Control**: If you do not want a pocket cut in the female beam, set **Housing Type** to "None".

## FAQ
- **Q: How do I use a custom bracket size not listed in the Type dropdown?**
  - **A:** Right-click the script instance and select "Extend length to be cut from rod". This unlocks the full range of sizes up to the rod's maximum length.
- **Q: The bracket is floating in the wrong position vertically.**
  - **A:** Adjust the "Offset Z-Direction" property in the Properties Palette to move the connector up or down.
- **Q: What is the difference between Wood/Wood and Wood/Concrete modes?**
  - **A:** Wood/Wood applies standard timber fasteners (nails/screws). Wood/Concrete modes switch the hardware list to use anchors or chemical dowels suitable for masonry/concrete.