# sd_ABeamcutDE - Beam Cut Dimension Display

## Overview

**sd_ABeamcutDE** is a shop drawing script that automatically generates dimensions and visual annotations for analyzed beam cuts (joints) displayed on fabrication drawings. It processes various timber joinery types and creates appropriate dimension requests, markings, and reference lines based on the viewing direction and cut geometry.

This script is executed by the shop drawing engine and must be appended to a multipage style ruleset. It does not run interactively but responds to the shop drawing generation process.

## Environment

| Property | Value |
|----------|-------|
| Type | E-Type (Element-based) |
| Space | Paper Space / Shop Drawing |
| Version | 4.9 |
| Requires | 1 beam |

## Prerequisites

- The script must be added to a **Multipage Style Ruleset** to function
- A beam with analyzed beam cuts must exist in the model
- The shop drawing engine handles script execution automatically

## Supported Beam Cut Types

The script processes the following beam cut (joint) types:

| Cut Type | Description |
|----------|-------------|
| SeatCut | Standard seat cut |
| RisingSeatCut | Seat cut on rising members |
| OpenSeatCut | Open-ended seat cut |
| LapJoint | Lap joint connection |
| Birdsmouth | Standard birdsmouth notch |
| ReversedBirdsmouth | Inverted birdsmouth |
| ClosedBirdsmouth | Enclosed birdsmouth |
| DiagonalSeatCut | Angled seat cut |
| OpenDiagonalSeatCut | Open-ended diagonal seat |
| BlindBirdsmouth | Hidden birdsmouth |
| Housing | Mortise/housing joint |
| HousingThroughout | Through housing |
| HouseRotated | Rotated housing |
| HouseTilted | Tilted housing |
| JapaneseHipCut | Japanese-style hip cut |
| HipBirdsmouth | Hip rafter birdsmouth (Herzkerve) |
| ValleyBirdsmouth | Valley rafter birdsmouth |
| RisingBirdsmouth | Birdsmouth on rising member |
| Housed5Axis | 5-axis machined housing |
| SimpleHousing | Basic housing joint |
| 5Axis | 5-axis machined cut |

## Parameters (OPM Properties)

When editing via the Properties Palette (after selecting the TSL instance), the following settings are available:

### X-Dimension Line Settings

| Parameter | Options | Description |
|-----------|---------|-------------|
| X-Dimline Seat Cuts | two points, last point (with/without width), center point (with/without width), first point (with/without width), Japanese Style, Do not show | Controls how seat cuts are dimensioned along the beam length |
| X-Dimline Lap Joints | (same options as above) | Controls how lap joints are dimensioned along the beam length |
| Preferred Viewing Direction of X-Dimline | Default (varies by tool), Side View left/right, Most aligned with tool, Top View left/right | Sets which side receives the length dimension |

### Display Options

| Parameter | Options | Description |
|-----------|---------|-------------|
| Show Obholz | Do not show, plump, perpendicular | Controls display of Obholz (plumb/perpendicular cut reference) dimension |
| Show Seat depth | at beam head, at tool, at beam head (depth only), at tool (depth only), do not show | Controls seat depth dimension location |
| Hatch Lap Joint | No, Yes | Hatches the lap joint area in perpendicular view |
| Hide Angular Dimensions | No, Yes | Suppresses angle dimension display |
| Hide Tools | none, complete through, not complete through | Hides specific tool types from display |

### Dimension Line Organization

| Parameter | Options | Description |
|-----------|---------|-------------|
| Show all in one dimline on left side | No, Yes | Collects all tooling dimension points into a single "LeftStart" stereotype dimension line |
| Show all in one dimline on right side | No, Yes | Collects all tooling dimension points into a single "RightStart" stereotype dimension line |
| Add dimensions from Start and End | (length value) | If beam exceeds this length, creates two dimension lines from each end toward the middle |
| Show 6 Sides | No, Yes | Enables dimension collection for all six viewing directions |
| Show Compass Views | No, Yes | Replaces main viewing directions with compass-aligned views (East, North, West, South) for vertical beams |

### Style Settings

| Parameter | Default | Description |
|-----------|---------|-------------|
| Set Japanese Style | No | Enables Japanese dimensioning conventions and symbol display |
| Stereotype Depth Housings | (empty) | Custom stereotype name for housing depth dimensions |
| Color of Markings | 16 | AutoCAD color index for reference line markings |

## Ruleset Commands

When adding this TSL to a multipage ruleset, these execution key commands are available:

### Information Display Commands

| Command | Effect |
|---------|--------|
| `Name` | Appends the tooling beam's name to dimension text |
| `Information` | Appends the tooling beam's information property |
| `Label` | Appends the tooling beam's label |
| `Sublabel` | Appends the tooling beam's sublabel |
| `POS` | Appends the tooling beam's position number |
| `Marking` | Creates horizontal and vertical marking lines with descriptions |
| `MarkingColor;<color>` | Sets the marking color (AutoCAD color index). Back side increments by 1 |

### Dimension Mode Commands

| Command | Values | Effect |
|---------|--------|--------|
| `showOnlyOnePointAtSeat;<n>` | 0-9 | Controls seat cut dimension point mode (see table below) |
| `modeLapPoints;<n>` | 0-9 | Controls lap joint dimension point mode |
| `hatchLapJoint;<n>` | 0 or 1 | 0=no hatch, 1=hatch lap joint in perpendicular view |
| `showSeatDepth;<n>` | 0-4 | Controls seat depth display location |
| `showObholz;<n>` | 0-2 | 0=hide, 1=plump, 2=perpendicular Obholz |
| `setPreferredViewXDim;<n>` | 0-5 | Sets preferred X-dimension viewing direction |
| `JapaneseStyle;<n>` | 0 or 1 | Enables Japanese dimensioning style |
| `show6Sides;<n>` | 0 or 1 | Enables all six viewing directions |
| `setCompassViews;<n>` | 0 or 1 | Uses compass-aligned views for vertical beams |
| `hideAngles;<n>` | 0 or 1 | 0=show angles, 1=hide angles |
| `hideBeamcut;<n>` | 0 or 1 | Hides beam cut display |

### Point Mode Values (showOnlyOnePointAtSeat / modeLapPoints)

| Value | Dimension Point(s) |
|-------|-------------------|
| 0 | Two points (both edges) |
| 1 | Last point in dimline direction + width appended |
| 2 | Center point + width appended |
| 3 | First point in dimline direction + width appended |
| 4 | Last point only |
| 5 | Center point only |
| 6 | First point only |
| 7 | Japanese style (center for horizontal/rising, last for vertical) + width |
| 8 | Japanese style (center for horizontal/rising, last for vertical) |
| 9 | No points |

### Stereotype Commands

| Command | Effect |
|---------|--------|
| `StereotypeDepthHouse;<name>` | Uses custom stereotype for housing depth dimensions |
| `ShowAllInOneLeft;<0/1>` | Collects dimension points to "LeftStart" stereotype |
| `ShowAllInOneRight;<0/1>` | Collects dimension points to "RightStart" stereotype |
| `DimFromStartEndLength;<length>` | When beam exceeds length, creates two dimlines from Start and End |

## Dimension Stereotypes

The script uses these stereotypes (which should exist in the layout override):

- **Birdsmouth** - Default for birdsmouth notch dimensions
- **SectionLeft** / **SectionRight** - For sectional/depth dimensions
- **Obholz** - For Obholz (plumb line) dimensions
- **LeftStart** / **RightStart** - For consolidated dimension lines
- **EndLeft** / **EndRight** - For second dimension line when using DimFromStartEndLength
- **LeftInfo** / **RightInfo** - For Japanese-style info annotations

## Usage Tips

1. **Basic Setup**: Add `sd_ABeamcutDE` to your multipage style ruleset. The script automatically detects and dimensions beam cuts.

2. **Add Tooling Beam Information**: Use execution keys like `Name;POS` to display the contacting beam's name and position number alongside the dimension.

3. **Marking Lines**: Add `Marking` to the execution key to display Ursenkel (plumb line) and Waageriss (horizontal reference) as colored polylines.

4. **Japanese Style**: Enable `JapaneseStyle;1` for Japanese timber framing conventions, which:
   - Dimensions the dove joint when mortise/house/dove exist together
   - Varies dimension points based on beam orientation
   - Enables Japanese symbol display

5. **Long Beams**: Use `DimFromStartEndLength;<value>` (e.g., `DimFromStartEndLength;6000`) to split dimension lines for beams exceeding the specified length.

6. **Hip/Valley Rafters**: The script automatically detects hip and valley rafters and adjusts dimension projections accordingly.

7. **Debug Mode**: Add `Debug` to the execution key to enable verbose reporting in the command line.

## Localization

The script supports internationalization through the T() function. Required translation keys include:
- `|Height (abbreviate)|` - Abbreviation for height
- `|Width (abbreviate)|` - Abbreviation for width
- `|Ursenkel|` - Plumb line reference
- `|Waageriss|` - Horizontal reference line
- `|back side|` - Back side indicator

## Related Scripts

- **sd_BmDE** / **sd_BmXX** - Beam display scripts that can set global options inherited by this script
- **MultipageController** - Parent controller for shop drawing generation
- **sd_ACutDE** - Similar script for cut dimensions

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 4.9 | 2010-05-26 | Bugfix for head dimension of seat cuts |
| 4.8 | 2009-07-27 | Seat depth only for perpendicular seats; closed birdsmouth enhancements |
| 4.7 | 2009-07-13 | New "hide tools" option; showSeatDepth extended |
| 4.6 | 2009-06-29 | Option dialog enhancements; Japanese override for Neda tool |
| 4.5 | 2009-06-26 | Sectional dimension improvements for seat cuts |
| 4.0 | 2009-05-25 | Dialog-driven option setup |
| 3.7 | 2009-04-08 | Lap joint and optional hatching added |
| 3.0 | 2009-01-15 | ReversedBirdsmouth support added |
