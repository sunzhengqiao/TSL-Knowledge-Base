# hsb_DSP-SeatCut.mcr

## Overview
This script automatically applies a vertical static seat cut to specific beams within a construction element. Once the cut is applied, the script instance deletes itself from the model.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Operates on 3D construction elements. |
| Paper Space | No | Not designed for layout views. |
| Shop Drawing | No | Not designed for manufacturing drawings. |

## Prerequisites
- **Required Entities:** An Element (e.g., a wall or floor assembly) containing structural beams.
- **Configuration:** The script instance requires a **Map** property attached to it with a specific key `BEAMCODE`.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
1. Run the command in AutoCAD.
2. Browse and select `hsb_DSP-SeatCut.mcr`.

### Step 2: Define Location
1. **Command Line:** `Specify insertion point:`
2. **Action:** Click in the model where you want the vertical seat cut to originate (the top of the cut).

### Step 3: Attach Element (If required)
*Note: Depending on your hsbCAD version settings, you may need to manually attach the script to an Element if it is not automatically detected.*
1. Select the script instance if it remains visible.
2. Use the hsbCAD function to add the script to the relevant Element (e.g., via Element properties or context menu).
3. Ensure the target beams are inside this Element.

### Step 4: Configure the Beam Code
Since this script has no input dialogs, you must configure the target beam code via the Properties Palette:
1. Select the script instance.
2. Open the **Properties** palette (Ctrl+1).
3. Locate the **Map** property.
4. Add a Key-Value pair:
   - **Key:** `BEAMCODE`
   - **Value:** The Beam Code you wish to target (e.g., "JST" or "RAFTER").
5. *Note: The script checks the first part of the beam's code against this value.*

### Step 5: Execute the Cut
1. Trigger a recalculation. You can do this by running `TSLUPDATEALL` or using `TSLUPDATESINGLE` on the script instance.
2. The script will process the beams, apply the vertical cut to matches, and then **erase itself**.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Map** | Map | - | A collection of Key-Value pairs. Must contain the key `BEAMCODE` to function. |

*Note: This script does not expose standard numeric or text properties; it relies entirely on the Map entry for configuration.*

## Right-Click Menu Options

This script has no custom right-click menu options. Standard hsbCAD context menus apply.

## Settings Files
- **Filename:** None
- **Location:** N/A
- **Purpose:** This script operates independently of external XML settings files.

## Tips
- **Self-Destructing:** Do not be alarmed if the script icon disappears after updating. This is intended behavior; the cut becomes a permanent part of the beam geometry.
- **Cut Direction:** The cut is always vertical downwards (Negative World Z-axis) from the insertion point.
- **Beam Matching:** The script looks for an exact match (case-insensitive) between the `BEAMCODE` value and the *first token* of the beam's property code. For example, if `BEAMCODE` is "RF", beams named "RF-100" and "RF-200" will be cut.
- **Undo:** If the cut is applied incorrectly, you can use the AutoCAD `UNDO` command to remove the script and the cuts, then try again.

## FAQ
- **Q: Why did the script disappear immediately after I inserted it?**
  - A: The script is designed to run once (upon the first update/refresh after insertion) and then delete itself. If it disappeared before you could configure the `BEAMCODE`, the check ran and failed (finding no code), or the system updated automatically.
- **Q: The script is still there, but no cuts appeared.**
  - A: Check the **Map** property in the Properties Palette. Ensure the key `BEAMCODE` exists and matches the start of your target beams' codes. Also, ensure the beams are actually inside the Element attached to the script.
- **Q: Can I move the cut after it is applied?**
  - A: No. This script applies a "static" cut. Unlike a parametric connection, it does not maintain a link to the original script (since the script deletes itself). To move the cut, you must delete the machining from the beam manually and re-run the script.