# HSB_E-Ladder

## Overview

| Property | Value |
|----------|-------|
| Script Name | HSB_E-Ladder |
| Type | Object (O) |
| Version | 4.4 |
| Category | StickFrame / Framing Distribution |
| Keywords | Ladder |
| Description | Creates a distribution of multiple beams (ladders) from a beam section. Can be attached to DSP details when the insertion point is in the section. |

## Usage Environment

| Environment | Supported |
|-------------|-----------|
| Model Space | Yes |
| Paper Space | No |
| Shop Drawing | No |
| Element-Based | Yes (Wall, Roof, Floor) |
| Beam-Based | Yes |
| DSP Detail Integration | Yes |

## Purpose

The HSB_E-Ladder script transforms existing beams into a series of smaller "ladder" beams distributed along the original beam's length. This is commonly used for:

- Creating wind bracing or fixing sub-structures
- Generating blocking or noggins along a beam run
- Creating infill framing between rafters
- Distributing studs or joists with precise spacing
- Creating ladder-style framing for floor or roof systems

## Usage Workflow

### Method 1: Element-Based Insertion

1. Run the HSB_E-Ladder script from the TSL library (TSLINSERT command)
2. A dialog appears to configure ladder parameters
3. Select one or more elements (walls, roofs, floors) or press ENTER to select beams directly
4. The script automatically creates ladder distributions for all matching beams within the selected elements

### Method 2: Manual Beam Selection

1. Run the HSB_E-Ladder script
2. Press ENTER at the element selection prompt (without selecting elements)
3. Select individual beams to transform into ladders
4. The script processes each selected beam

### Method 3: DSP Detail Integration

1. Insert the script from a DSP (Detail Specification) generator
2. The script reads configuration from DSP variables using the override parameters
3. Ladders are automatically created based on detail line positions

## Prerequisites

- **Required Entities**: GenBeam (for manual execution) or Element (for automatic execution)
- **Minimum Beam Count**: 1 source beam
- **Required Helper Scripts**: `HSB_G-Distribution` (Map configuration for distribution logic), `HSB_G-FilterGenBeams` (for beam filtering)

## Properties Panel Parameters

### General Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Sequence number | Integer | 0 | Used to sort TSL instances during construction generation |
| Filter Beamcode(s) | String | "" | Specifies beamcodes to exclude from processing (rafters, existing ladders) |
| Beamcode ladder | String | "KSTL-01" | Specifies which beamcodes should be transformed into ladders |
| Extrusion Profile | String | "--" | Sets the extrusion profile for created beams. Select "--" for no profile |

### Distribution Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Distribution | List | Left | Defines the direction/pattern of ladder distribution along the original beam |
| Place first beam | Yes/No | Yes | Places a beam at the start end of the original beam |
| Place last Beam | Yes/No | Yes | Places a beam at the end of the original beam |
| Thickness ladder | Length | 48 mm | The thickness (depth in extrusion direction) of each ladder beam |
| Thickness ladder variable override | Integer | -1 | DSP variable index to look up for ladder thickness (-1 disables) |
| Height ladder | Length | 200 mm | The height of each ladder beam |
| Height ladder variable override | Integer | -1 | DSP variable index to look up for ladder height (-1 disables) |
| Spacing ladder | Length | 600 mm | Maximum spacing between ladder beams (used when "Distribute evenly" is enabled) |
| Spacing ladder variable override | Integer | -1 | DSP variable index to look up for ladder spacing (-1 disables) |
| Start first ladder | Length | 0 mm | Offset distance from the start of the original beam to the first ladder |
| Start first ladder variable override | Integer | -1 | DSP variable index to look up for start offset (-1 disables) |
| Start last ladder | Length | 0 mm | Offset distance from the end of the original beam to the last ladder |
| Start last ladder variable override | Integer | -1 | DSP variable index to look up for end offset (-1 disables) |
| Offset rafter ladders | Length | 0 mm | Additional offset for ladders placed relative to rafters |
| Rafter offset variable override | Integer | -1 | DSP variable index to look up for rafter offset (-1 disables) |
| Distribute evenly y/n | Yes/No | No | When enabled, distributes beams evenly using spacing as maximum spacing |
| Flip in Thickness direction | Yes/No | No | Flips the Y direction of all created beams |
| Flip first Beam | Yes/No | No | Flips the first beam in thickness direction |
| Flip last Beam | Yes/No | No | Flips the last beam in thickness direction |
| Allow clash with rafter | Yes/No | No | When enabled, allows beams to be placed even if they clash with rafters |

## Distribution Options

The script supports multiple distribution patterns:

| Option | Description |
|--------|-------------|
| Left | Distributes ladders from the left end of the beam |
| Right | Distributes ladders from the right end of the beam |
| Centre | Places ladders centered along the beam with a beam in the center |
| Centre, no beam in centre | Centers distribution without placing a beam at the exact center |
| At Rafter | Places ladders at rafter positions |
| Left from Rafter | Places ladders to the left of each rafter |
| Right from Rafter | Places ladders to the right of each rafter |
| Left & Right from Rafter | Places ladders on both sides of each rafter |
| On Grid | Places ladders at grid intersection points |

## Right-Click Menu Options

This script instance removes itself immediately after generating the beams. Standard recalculation is not available post-execution.

## How It Works

1. **Beam Filtering**: The script identifies which beams to transform based on the "Beamcode ladder" filter
2. **Rafter Detection**: Automatically detects rafters in the element (studs, center joists, edge joists, extra rafters, SF studs)
3. **Distribution Calculation**: Uses the HSB_G-Distribution helper script to calculate ladder positions based on the selected distribution mode
4. **Beam Creation**: Creates new ladder beams at calculated positions, inheriting properties from the original beam
5. **Original Beam Removal**: The original beam is erased after ladders are created

## Inherited Properties

Created ladder beams automatically inherit the following properties from the original beam:

- Color
- Beam type
- Beam code
- Layer assignment
- Information text
- Grade
- Material
- Label and sub-labels (Label, SubLabel, SubLabel2)
- Name
- Module
- HSB ID
- Isotropic setting

## Settings Files

- **Filename**: `HSB_G-Distribution`
- **Location**: Company Standards or hsbCAD Install path
- **Purpose**: Provides configuration data for distribution logic, specifically when using "At Rafter" or "On Grid" modes to locate structural members

## Tips and Best Practices

1. **Beamcode Configuration**: Set the "Beamcode ladder" parameter to match the beamcodes you want to transform. Use "Filter Beamcode(s)" to exclude specific beams.

2. **Even Distribution**: Enable "Distribute evenly" to ensure uniform spacing. The spacing value becomes the maximum spacing, and the script calculates optimal spacing to fit within the beam length.

3. **Rafter-Based Distribution**: Use rafter-based distribution options (At Rafter, Left/Right from Rafter) for creating blocking between rafters or studs.

4. **DSP Integration**: When using with DSP generators, use the variable override parameters to read values from DSP variables dynamically.

5. **Avoid Duplicates**: The script marks processed beams with a subMapX flag to prevent duplicate processing.

6. **Opening Awareness**: When attached to roof elements, the script can detect and work around roof openings.

7. **Grid-Based Placement**: Use "On Grid" distribution to align ladders with project grid lines.

8. **Clash Prevention**: If you notice missing rungs in the middle of the span, check if "Allow clash with rafter" is set to "No"; the script may be deleting rungs that overlap with rafters.

## Dependencies

- **HSB_G-Distribution**: Required helper script for calculating distribution positions
- **HSB_G-FilterGenBeams**: Required helper script for filtering beams by beamcode

## Error Handling

The script will:
- Erase itself if no valid beams are found to process
- Display a warning if the HSB_G-Distribution script is not loaded
- Skip beams that have already been processed by a previous instance
- Skip ladder placement if it would clash with a rafter (unless "Allow clash with rafter" is enabled)
- Report invalid element or beam selections

## FAQ

- **Q: Why did the original beam disappear?**
  A: The script is designed to erase the source beam and replace it with the individual ladder rungs.

- **Q: Why are no rungs being generated?**
  A: Check the "Beamcode ladder" property to ensure it matches the code of the beam you selected. Also verify that the calculated spacing does not exceed the beam length.

- **Q: Can I use variable sizes for the rungs?**
  A: Yes. Set the variable override parameters (Thickness, Height, Spacing) to the corresponding Design Standard Property (DSP) indices to control dimensions dynamically.

## Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 4.4 | 24/06/2025 | Robert Pol | Ensures points for rafters are not duplicated |
| 4.3 | 30/04/2025 | Robert Pol | Added tolerance for start endpoint check |
| 4.0 | 26/11/2019 | Robert Pol | Changed insert method for DSP and manual use |
| 3.0 | 25/05/2018 | Robert Pol | Added extrusion profile and flip options |
| 2.0 | 14/01/2018 | Robert Pol | Redesigned using MapIO with HSB_G-Distribution |
| 1.0 | 19/01/2016 | Robert Pol | First version |

## Related Scripts

- **HSB_G-Distribution**: Helper script for position calculation
- **HSB_G-FilterGenBeams**: Helper script for beam filtering
- **HSB_E-Bracing**: Similar element-based framing script
- **HSB_W-Lifting**: Related wall framing tool
- **HSB_E-Lifting**: Related element lifting tool
