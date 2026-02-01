# HSB_E-SquaredMill

## Overview
This script creates rectangular (square) milling cuts on timber beams where they intersect with specific "milling" beams defined by a beam code. Instead of following the complex angled profile of the intersecting beam, it generates a clean square pocket or through-hole with an optional clearance gap.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates on 3D Elements and GenBeams in the model. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Does not process 2D drawings or viewports. |

## Prerequisites
- **Required Entities**: At least two Elements or GenBeams. One to act as the "Cutter" (defined by Beamcode) and one to receive the cut.
- **Minimum Beam Count**: 2 (One intersecting, one being intersected).
- **Required Settings Files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_E-SquaredMill.mcr`

### Step 2: Configure Properties
A dialog will appear automatically upon insertion. Adjust the following settings before proceeding:
- **Beamcode**: Enter the beam code of the element that defines the cut size (e.g., the wall or trimmer).
- **Gap**: Enter the clearance allowance (in mm).
- **Mill at the end of the beam**: Select "Yes" for a deep through-cut or "No" for a shallow pocket.
- **Square off beam at shortest point**: Select "Yes" to trim the beam length to the cut, or "No" to keep the beam length.
- **Filter beams with beamcode**: (Optional) Enter beam codes to exclude specific beams from processing.

### Step 3: Select Elements
```
Command Line: Select one or more elements
Action: Click on the Elements or GenBeams in the Model Space that you wish to process.
```
*Note: The script will automatically distinguish between "Milling Beams" (cutters) and "Target Beams" (receivers) based on the properties set in Step 2.*

### Step 4: Completion
Once selected, the script calculates the intersections, applies the milling operations and saw cuts, and then automatically removes itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Squared Mill** | | | *Section Header* |
| Beamcode | Text | KK-05 | The beam code of the intersecting element that will drive the cut geometry. Beams with this code will act as the "tool". |
| Gap | Number | 1 | Clearance allowance added to the cut size (in mm). Note: The applied gap increases as the intersection angle becomes shallower. |
| Mill at the end of the beam | Dropdown | Yes | If **Yes**, the cut penetrates deeply through the beam. If **No**, the depth is limited to the intersection width. |
| Square off beam at shortest point | Dropdown | Yes | If **Yes**, the beam is axially cut (shortened) to create a square end at the intersection. If **No**, the beam retains its length and receives a pocket only. |
| **Filter** | | | *Section Header* |
| Filter beams with beamcode | Text | (Empty) | List of beam codes to ignore during processing (e.g., "STU;PLT"). Beams matching these codes will not be modified. |

## Right-Click Menu Options
*None. The script instance is erased immediately after execution.*

## Settings Files
*None. All configuration is handled via the Properties Panel/Dialog during insertion.*

## Tips
- **Gap Calculation**: The script divides the Gap by the sine of the intersection angle. For shallow angles (beams running nearly parallel), the gap will expand significantly to ensure clearance. Use small values (e.g., 1mm) for tight fits.
- **Trimming vs. Pocketing**: Use "Square off beam at shortest point" = **Yes** when you want to cut a beam back to a wall face. Use **No** if you just want a slot or hole in the middle of a beam.
- **Re-running**: Since the script deletes itself after running, to edit the cuts, you must manually delete the generated BeamCut/Cut tools and run the script again.

## FAQ
- **Q: Why did the script disappear after I selected the elements?**
  - A: This is normal behavior. The script is a "generator" that creates machining tools (BeamCuts) and then removes itself. You can edit the resulting cuts via the beam's properties, but you must re-insert the script to generate new cuts with different settings.
- **Q: The cut is much larger than the gap I specified. Why?**
  - A: This occurs when beams intersect at a very sharp angle. To ensure the intersecting beam fits, the script mathematically increases the gap based on the angle. Reduce the `Gap` parameter or check the intersection angle.
- **Q: Can I use this to square off the end of a beam against a slanted wall?**
  - A: Yes. Set the "Beamcode" to match the wall beam and ensure "Square off beam at shortest point" is set to **Yes**. This will cut the target beam perpendicular to its own axis at the point of intersection.