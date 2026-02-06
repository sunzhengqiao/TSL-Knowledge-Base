# T-Connection.mcr

## Overview
Automates the creation of T-connections between timber beams by calculating intersections and applying precise cuts or pockets. This script is ideal for joining cross beams (male) into main beams (female), such as studs into plates or purlins into rafters.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model environment. |
| Paper Space | No | Not designed for 2D layout or detailing views. |
| Shop Drawing | No | Does not generate shop drawing details directly. |

## Prerequisites
- **Required entities**: At least two `GenBeams` (one male, one female) or an `Element` containing beams.
- **Minimum beam count**: 2.
- **Required settings files**: None (Standard Painter catalogs are used).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `T-Connection.mcr` from the list.

### Step 2: Select Male Beams
```
Command Line: Select male beam(s) or element(s)
Action: Click on the beam(s) that will cut into the main beam (e.g., a stud or purlin). You can also select an entire Wall/Element.
```
*Note: If you select an Element, the script automatically finds the connections within it and skips the next step.*

### Step 3: Select Female Beams (If not in Element Mode)
```
Command Line: Select female beams
Action: Click on the main beam(s) that will receive the cut (e.g., a top plate or rafter).
```

### Step 4: Configuration
After selection, the Properties Palette (OPM) will display the connection parameters. Adjust settings like Depth and Side Gap as needed. Press Enter to place the connection.

### Step 5: Verification
The script calculates the intersection. If the beams align correctly, a cut/pocket is applied. If the geometry is invalid, the script instance may erase itself automatically.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Male beams** | dropdown | Disabled | Selects a predefined profile (Painter) to apply to the male beams. Acts as a filter to select specific beams or apply specific machining. |
| **Female beams** | dropdown | Disabled | Selects a predefined profile (Painter) to apply to the female beams. Defines the shape of the cut/pocket. |
| **Depth / Distance** | number | 0 | Defines how deep the male beam penetrates into the female beam (or the depth of the pocket). |
| **Side Gap** | number | 0 | Adds a clearance allowance around the cut profile (e.g., 2mm) for easier assembly or tolerances. |
| **Tool Alignment** | dropdown | Female beam | Determines the reference for the cut width. "Female beam" cuts the full width of the main beam; "Male beam" creates a slot sized exactly to the cross beam. |
| **PainterMaleStream** | text | (Empty) | Internal storage for the male beam profile configuration. usually managed via catalogs. |
| **PainterFemaleStream** | text | (Empty) | Internal storage for the female beam profile configuration. usually managed via catalogs. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Reset + Erase** | Converts the dynamic connection into static cuts (keeping the geometry) and deletes the TSL instance. This is also triggered by Double-Clicking the instance. |

## Settings Files
- **Filename**: None specific
- **Location**: N/A
- **Purpose**: This script relies on standard hsbCAD Painter catalogs loaded in your environment rather than a specific local settings file.

## Tips
- **Element Mode**: For walls or floors, select the whole Element in Step 2 to process all internal T-connections at once.
- **Tool Alignment**: Use "Male beam" alignment if you want a slot that is exactly the width of the incoming beam, rather than cutting across the entire width of the main beam.
- **Side Gap**: If your parts are fitting too tightly, increase the **Side Gap** parameter (e.g., to 1mm or 2mm) to add tolerance.
- **Debugging**: If the script disappears immediately after insertion, check if the male beam axis actually intersects the female beam volume. The script performs a strict intersection check.

## FAQ
- **Q: Why did the script disappear after I placed it?**
  A: The script performs an automatic validity check. If the male beam does not physically intersect the female beam (based on the Distance parameter) or if the geometry is invalid, the script erases itself. Check your beam alignment and ensure the "Depth" is sufficient.
  
- **Q: How do I make the cut wider than the male beam?**
  A: Change the **Tool Alignment** property to "Female beam". This will calculate the cut width based on the main beam's dimensions.

- **Q: Can I use this on multiple studs at once?**
  A: Yes. You can window-select multiple male beams in Step 2, then select the single female plate in Step 3. One instance will manage all connections.