# HSB_W-SplitPlatesExtraOptions

Split plates on walls avoiding modules and studs for internal rows, with option to alternate split locations to external rows and set sorted beam codes. Can also be used to reset plates to original framing length.

## Script Type

**Type: O (Object)**

This is an Object-type TSL script that attaches to wall elements. It operates without requiring pre-selected beams and is inserted onto ElementWallSF (Stick Frame Wall) elements.

- **Implicit Insert**: Yes
- **DXA Output**: Enabled
- **Sequence Number**: 110

## Keywords

`Plate`, `Split`

## Version History

| Version | Date | Description |
|---------|------|-------------|
| 1.11 | 24.05.2022 | Add display and grip points to manually define splitting points |
| 1.10 | 16.02.2022 | Add Locating Plate to list of beams that need splitting |
| 1.9 | 10.11.2021 | Add blocking and SFBlocking to list of beams that need splitting |
| 1.8 | 20.09.2021 | Fix bug when splitting at studs; fix bug when setting beamcode |
| 1.7 | 17.09.2021 | New property "Side of Stud Clear Space" with 3 options |
| 1.6 | 07.04.2021 | Bugfix endless loop |
| 1.5 | 25.03.2021 | Filter plates by centerpoint of first plate |
| 1.4 | 25.03.2021 | Added beam type verybottomplate |
| 1.3 | 23.03.2021 | No beamcode overwrite at default; bugfix on element creation |
| 1.2 | 17.03.2021 | Bugfix inaccuracy of searchpoint |
| 1.1 | 26.02.2021 | Added property "add to label" and beamcode suffix direction choice |
| 1.0 | 18.04.2019 | Initial release |

## User Properties

### General Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Maximum length | Double | 4800 mm | Maximum allowed length for plate segments after splitting |
| Opening module dimensions greater than | Double | 605 mm | Threshold to identify opening modules (doors, windows) |
| Split distance to opening module | Double | 269 mm | Minimum distance to maintain from opening module edges when splitting |
| Split distance to small module | Double | 119 mm | Minimum distance to maintain from small module edges when splitting |
| Split distance to stud | Double | 119 mm | Minimum distance to maintain from stud centers when splitting |
| Side of Stud Clear Space | String | both | Defines which side of studs to avoid: "both", "left", or "right" |

### Additional Options Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Split Location | String | Opposite | Defines if splits are aligned ("Same") or opposite ("Opposite") from bottom to top plates |
| Split on stud | String | No | Defines if splits on very top/bottom plates are over a stud; also affects Blocking splitting |
| Create splice blocks | String | Yes | Creates splice blocks (blocking pieces) at split locations |
| Set BeamCode | String | Left to Right | Sets beam codes for identification: "No", "Left to Right", or "Right to Left" |
| Write BeamCode suffix to Label | String | No | Writes the suffix of the beam code to the Label field |

### Reset Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Reset plates | String | No | Resets plates to original lengths by rejoining split segments |

### Debug Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Preview mode | String | Yes | Allows changing settings without removing TSL from element |
| Show non split regions | String | Yes | Displays the non-split regions (areas around studs and modules) visually |

## Supported Beam Types

The script processes the following beam types for splitting:

**Top Plates:**
- TopPlate, SFTopPlate, PanelTopPlate
- SFVeryTopPlate, SFVeryTopSlopedPlate
- PanelCapStrip
- SFAngledTPLeft, SFAngledTPRight

**Bottom Plates:**
- Bottom, PanelBottomPlate
- SFBottomPlate, SFVeryBottomPlate

**Other Beams:**
- SFBlocking, Blocking, Brace
- LocatingPlate

## Usage Workflow

### Step 1: Insert the Script

1. Run the TSL insertion command or use the button command:
   ```
   ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "HSB_W-SplitPlates_Enhanced")) TSLCONTENT
   ```
2. When prompted, select one or more wall elements (ElementWallSF)
3. The script will be attached to each selected wall element

### Step 2: Configure Split Parameters

After insertion, select the TSL instance and adjust properties in the Properties Palette (OPM):

1. **Set Maximum Length**: Define the maximum plate segment length (default 4800mm)
2. **Configure Module Distances**: Adjust distances from openings and small modules
3. **Set Stud Clearance**: Define the clear space around studs and which side to respect
4. **Choose Split Location**: Select "Same" for aligned splits or "Opposite" for staggered splits between top and bottom plates

### Step 3: Configure Output Options

1. **Splice Blocks**: Enable/disable creation of blocking at split points
2. **Beam Codes**: Choose whether to assign sequential beam codes and the direction
3. **Label Writing**: Optionally write beam code suffixes to labels for identification

### Step 4: Preview and Apply

1. Keep "Preview mode" set to "Yes" to see results without committing
2. Adjust settings as needed while viewing the split visualization
3. When satisfied, the splits are applied automatically on recalculation

## Context Menu Commands

Right-click on the TSL instance to access these commands:

| Command | Description |
|---------|-------------|
| **Split Plates** | Recalculates and applies plate splitting with current settings |
| **Reset Plates** | Rejoins all split plates back to their original framing length |
| **Reset Plates And Delete** | Resets plates to original length and removes the TSL instance |
| **Delete** | Removes the TSL instance without resetting plates |

## How It Works

### Splitting Logic

1. **Module Detection**: Identifies opening modules (doors, windows) and small modules within the wall
2. **Non-Split Zones**: Calculates protected zones around modules and studs where splits should not occur
3. **Internal Plates First**: Splits bottom plates and top plates, respecting the non-split zones
4. **External Plates**: Splits very bottom plates, very top plates, and blocking members
5. **Staggering**: When "Opposite" is selected, external plates are split at opposite positions from internal plates

### Beam Code Assignment

When "Set BeamCode" is enabled:
- Bottom plate rows receive codes: B1, B2, B3...
- Top plate rows receive codes: T1, T2, T3...
- Other beams receive codes: O1, O2...
- Direction (Left to Right / Right to Left) determines suffix increment order

### Splice Block Creation

When enabled, blocking pieces are automatically created:
- Positioned at each split location
- Material and grade match the parent plate
- Named "SPLICE BLOCK" for easy identification
- Stretched between adjacent studs

## Notes

- The script will not attach to an element that already has this TSL attached
- If maximum length is shorter than the minimum required split distance, an error is reported
- The script automatically rejoins previously split plates before applying new splits
- Manual split points can be defined using grip points (version 1.11+)
- Debug visualization shows non-split regions in red when enabled
