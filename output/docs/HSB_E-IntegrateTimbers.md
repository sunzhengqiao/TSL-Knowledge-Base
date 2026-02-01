# HSB_E-IntegrateTimbers.mcr

## Overview
Automates the creation of timber integrations (pockets/cuts) between selected "male" beams (to be cut) and intersecting "female" beams within an Element. This is typically used for batch processing floor cassettes or roof structures where joists must be notched or housed into main support beams.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for processing 3D geometry and intersections. |
| Paper Space | No | Not applicable. |
| Shop Drawing | No | This script modifies the 3D model geometry. |

## Prerequisites
- **Required Entities:** An `Element` containing `GenBeams`.
- **Minimum Beam Count:** At least 1 beam (though practical application requires intersecting sets).
- **Required Settings/Scripts:**
    - `HSB_G-FilterGenBeams` (must be loaded in the drawing for beam filtering).
    - `HSB_T-IntegrateTimber` (required for creating the actual milling operations).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: In the dialog that appears, select `HSB_E-IntegrateTimbers.mcr` and click Open.

### Step 2: Configure Parameters (Optional)
Action: Before selecting the element, you can adjust properties in the Properties Palette (OPM) if you know the specific Beam Codes or depth settings required.

### Step 3: Select Element
```
Command Line: Select Element(s):
Action: Click on the Element (e.g., a floor cassette) containing the beams you wish to process. Press Enter to confirm selection.
```
*Note: If `HSB_G-FilterGenBeams` is not loaded, the script will report an error and abort.*

### Step 4: Processing
Action: The script automatically identifies intersections based on your filters, creates satellite instances of `HSB_T-IntegrateTimber`, and generates the cuts.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **sMaleFilterBC** | String | (Empty) | Beam Code defining which beams are to be cut (the "Male" beams). |
| **genBeamFilterDefinitionMale** | String | (Empty) | Name of a filter catalog (from HSB_G-FilterGenBeams) to select Male beams using complex criteria (e.g., material, name). |
| **alwaysIntegrate** | String | (Empty) | Forces specific beams (by Beam Code) to always be treated as Male beams, regardless of standard intersection logic. |
| **sFemaleFilterBC** | String | (Empty) | Beam Code defining the target beams (the "Female" beams). The Male beam is cut to fit these. |
| **genBeamFilterDefinitionFeMale** | String | (Empty) | Name of a filter catalog to select Female beams (the reference beams). |
| **dDepth** | Number | 3 | Standard depth of the integration cut/pocket into the Male beam (mm). |
| **dOverrideDepth** | Number | 3 | Special cut depth used when a beam matches the `sBmCodeOverrideDepth` code (mm). |
| **sBmCodeOverrideDepth** | String | (Empty) | The Beam Code that triggers the use of `dOverrideDepth` instead of the standard `dDepth`. |
| **dMinimumMillWidth** | Number | 25 | Smallest allowed width for a cut. Intersections narrower than this will be ignored (mm). |
| **dGapWidth** | Number | 1 | Clearance added to the sides of the cut (perpendicular to beam length) for assembly tolerance (mm). |
| **dGapLength** | Number | 200 | Clearance added to the ends of the cut (parallel to beam length) to prevent binding (mm). |
| **extraWidthForAdjacentConnections** | Number | 0 | Additional width added to the mill specifically when beams are adjacent or parallel (mm). |
| **sApplyMarking** | Enum | Yes | Enables or disables text/engraving on the beam to indicate the integration (Yes/No). |
| **sMarkingSide** | Enum | Inside | Specifies which face of the beam receives the marking (Inside/Outside relative to construction). |
| **dSymbolSize** | Number | 20 | Size of the visualization symbol drawn in the CAD model to represent this script (mm). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Restore connection** | Removes all integration cuts/pockets created by this script on the Element, restores the original beam geometry, and deletes the script instance. |

## Settings Files
- **Script Dependency**: `HSB_G-FilterGenBeams.mcr`
- **Purpose**: Provides the catalog names and complex logic for filtering Male and Female beams based on properties other than just Beam Code.

## Tips
- **Using Filters**: If you have many different beam types, use `genBeamFilterDefinitionMale` instead of `sMaleFilterBC` to select beams based on multiple attributes (like width or material) defined in the Filter catalog.
- **Prevent Small Cuts**: If you see small, unwanted slivers or cuts appearing on your beams, increase the `dMinimumMillWidth` value (e.g., to 30 or 40).
- **Assembly Gaps**: Ensure `dGapLength` is sufficient if you are using tenons or loose tongues so that parts do not bottom out during assembly.
- **Visualizing**: If you cannot see the script marker in the model, increase `dSymbolSize`.

## FAQ
- **Q: The script reports "GenBeams could not be filtered!" and stops. What is wrong?**
  **A:** The script `HSB_G-FilterGenBeams.mcr` is not loaded in your current drawing. You must load this script using `TSLLOAD` or ensure it is in your autoload list.
- **Q: Some intersections are not being cut. Why?**
  **A:** Check if the intersection width is smaller than your `dMinimumMillWidth` setting. Also, verify that your `sMaleFilterBC` and `sFemaleFilterBC` settings match the actual Beam Codes of the elements in your model.
- **Q: How can I make one specific beam type cut deeper than the others?**
  **A:** Enter the Beam Code of the special beam in the `sBmCodeOverrideDepth` field, then set the specific deeper value in `dOverrideDepth`. Leave `dDepth` for the standard depth.