# HSB_G-NumberGenBeams

This TSL script automatically assigns position numbers to all selected GenBeams (timber members). It provides a quick way to number beams in your model, which is essential for fabrication documentation and shop drawings.

**Author:** Robert Pol (support.nl@hsbcad.com)
**Version:** 1.00
**Last Modified:** 14.08.2020

## Script Type

**Type O (Object Script)**

This is an Object-type script that operates independently without requiring pre-selected beams. It runs once to process beams and then erases itself from the drawing - it does not persist as a parametric entity.

## User Properties

This script has no user-configurable properties in the Properties Palette (OPM). It operates automatically based on beam selection.

## Usage Workflow

### Step 1: Launch the Script
Run the script from the hsbCAD TSL menu or command line.

### Step 2: Select GenBeams
When prompted, you have two options:

| Action | Result |
|--------|--------|
| **Select specific beams** | Click on one or more GenBeams in your model to number only those beams |
| **Press ENTER without selecting** | The script will automatically select ALL GenBeams in Model Space |

The command line displays:
> "Select one or more genbeams, ENTER to select all genbeams"

### Step 3: Automatic Numbering
After selection, the script:
1. Iterates through all selected GenBeams
2. Assigns position numbers using the `assignPosnum(0)` method
3. Verifies that all beams have been properly numbered
4. Automatically erases itself from the drawing when complete

### Step 4: Verify Results
Check the assigned position numbers in:
- The beam properties (OPM panel)
- Shop drawings generated from the numbered beams
- Part lists and schedules

## Technical Details

### How Numbering Works
- The script calls `gBm.assignPosnum(0)` on each beam
- The parameter `0` tells hsbCAD to use automatic position number assignment
- Beams with `posnum() == -1` indicate numbering has not yet completed
- The script includes a safety loop (max 50 iterations) to ensure all beams are processed

### Behavior Notes
- **Non-persistent**: The script erases itself after execution - it does not remain in your drawing
- **One-time execution**: If you need to renumber beams, run the script again
- **Multiple insert protection**: If launched multiple times accidentally, duplicate instances are automatically removed

## Context Menu Commands

This script has no context menu commands as it does not persist in the drawing after execution.

## Related Scripts

This numbering script works in conjunction with:
- Shop drawing scripts (`sd_*`) that display position numbers
- Part list generation tools that use position numbers for BOM creation
- Other `HSB_G-*` general utility scripts

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Some beams not numbered | Run the script again and select ALL beams (press ENTER at selection prompt) |
| Position numbers not visible | Check that position number display is enabled in your drawing settings |
| Script seems to hang | The script has a 50-iteration safety limit; if beams cannot be numbered due to model issues, it will eventually complete |
