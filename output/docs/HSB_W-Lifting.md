# HSB_W-Lifting

Adds lifting points to a wall element for crane operations. Automatically calculates optimal lifting rope positions based on wall length and weight. If the element exceeds a specified length or weight threshold, additional lifting ropes are added (up to 4 ropes).

## Script Type

**Type O (Object Script)** - This script operates on wall elements to add lifting point indicators, drills, and optional reinforcement plates for crane lifting operations.

## User Properties

### General

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Identifier | String | "Pos 1" | Unique identifier to prevent duplicate lifting instances on the same element. Only one TSL instance per identifier can be attached to an element. |

### Tooling

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Tooling | String | "Drill stud and topplate" | Tooling operation type. Options: "Drill stud and topplate", "Drill stud", "Side cuts in topplate", "No drills", "Drill stud and topplate one side", "Drill topplate one side" |
| Side | String | "Top plate" | Defines the tooling side. Options: "Top plate", "Bottom plate", "Both", "Custom". If Custom is selected, lifting points can be positioned individually by dragging their grip point. |
| Filter beams with beamcode | String | (empty) | Exclude beams with specific beamcodes from lifting point calculations. Use semicolon separator for multiple codes. Wildcards supported (*). |
| Filter beams with label | String | (empty) | Exclude beams with specific labels from lifting point calculations. |
| Exclude jacks | String | "Yes" | Whether to exclude jack studs (over/under openings) from lifting point calculations. |

### Drill Settings

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Centerpoint for drills | String | "Beam by code" | Reference point for centering drills. Options: "Element" (element center) or "Beam by code" (specific beam center). |
| Beamcode to center drills | String | (empty) | Beamcode of the beam to use as drill center reference. Required if "Beam by code" is selected. |
| Offset from center point | Double | 0 mm | Horizontal offset from the center reference point for drill placement. |
| Offset symmetric or asymmetric | String | "Symmetric" | Whether drill offsets are symmetric or asymmetric relative to center. |
| Horizontal offset drill | Double | 80 mm | Horizontal offset for drill position. |
| Vertical offset drill | Double | 80 mm | Vertical offset for drill position from the top of the stud. |
| Diameter drill | Double | 16 mm | Diameter of the lifting drill hole. |

### Side Cuts

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Width side cut | Double | 100 mm | Width of side cuts in topplate (when "Side cuts in topplate" tooling is selected). |
| Depth side cut | Double | 6 mm | Depth of side cuts in topplate. |

### Reinforcement Plate

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Stud drill reinforcement | String | "No" | Whether to add reinforcement plates next to studs at lifting points. |
| Width of plate | Double | 0 mm | Width of reinforcement plate. If zero, stud width is used. |
| Height of plate | Double | 200 mm | Height of reinforcement plate. If zero, plate equals vertical drill offset. |
| Thickness of plate | Double | 12 mm | Thickness of reinforcement plate. |
| Offset plate vertical | Double | 0 mm | Vertical offset for reinforcement plate positioning. |
| Offset plate horizontal | Double | 0 mm | Horizontal offset for reinforcement plate positioning. |
| Angle plate | Double | 0 | Rotation angle for reinforcement plate. |
| Material of plate | String | (empty) | Material specification for reinforcement plate. |
| Grade of plate | String | (empty) | Grade specification for reinforcement plate. |
| Name of plate | String | (empty) | Name for reinforcement plate. |
| Beamcode of plate | String | (empty) | Beamcode for reinforcement plate. |
| Color of plate | Integer | 1 | Display color for reinforcement plate. |
| Zone of plate | Integer | 0 | Zone assignment for reinforcement plate. |

### Reinforcement Batten

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Batten Symmetry | String | "Yes" | Whether battens are placed symmetrically. Only relevant for "Drill stud and topplate one side" tooling. |
| Batten Side | String | "Outside" | Side for batten placement. Options: "Outside", "Inside". |
| Batten Length | Double | 300 mm | Length of reinforcement batten. |
| Beamcode of Batten | String | (empty) | Beamcode for reinforcement batten. |
| Material of Batten | String | (empty) | Material specification for reinforcement batten. |
| Grade of Batten | String | (empty) | Grade specification for reinforcement batten. |
| Name of Batten | String | (empty) | Name for reinforcement batten. |

### Ruleset

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Four ropes on walls longer than | Double | 7800 mm | Wall length threshold for switching from 2 to 4 lifting ropes. |
| One rope on walls shorter than | Double | 1200 mm | Wall length threshold for using only 1 lifting rope. |
| Four ropes on walls heavier than | Double | 999999 | Weight threshold (no unit) for switching to 4 ropes regardless of length. |
| Double lifting | String | "No" | Forces 4 ropes with paired lifting points near each other. |
| Minimal Stud Length | Double | 0 mm | Minimum stud length required for a stud to be considered for lifting point placement. |
| Offset ratio from center for 2 ropes | Double | 0.525 | Ratio (0-1) for positioning 2 ropes from center. Example: 0.33 at 2400mm from center = 800mm offset. |
| Offset ratio first rope from center for 4 ropes | Double | 0.25 | Ratio (0-1) for first rope position when using 4 ropes. |
| Offset ratio second rope from center for 4 ropes | Double | 0.75 | Ratio (0-1) for second rope position when using 4 ropes. |

### Style

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Layer | String | "I-Layer" | Display layer for lifting visualization. Options: "I-Layer", "D-Layer", "T-Layer", "Z-Layer". |
| Zone index | Integer | 0 | Zone index assignment (0-10). |

### Visualization

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Color | Integer | 3 | Display color for lifting point visualization. |
| Symbol size | Double | 30 mm | Size of the lifting point symbol. |

## Usage Workflow

1. **Select Elements**: Run the script and select one or more wall elements when prompted.

2. **Configure Settings**: A dialog appears on first insertion. Set the tooling type, drill parameters, and ruleset thresholds according to your project requirements.

3. **Automatic Calculation**: The script automatically:
   - Calculates the center of gravity of the wall element
   - Determines optimal lifting point positions based on wall length and weight
   - Places 1, 2, or 4 lifting points according to the ruleset thresholds
   - Finds suitable studs connected to top/bottom plates for drill placement

4. **Tooling Options**:
   - **Drill stud and topplate**: Creates through-drills in both vertical studs and horizontal plates
   - **Drill stud**: Creates drills only in vertical studs
   - **Side cuts in topplate**: Creates notches in the topplate for strap placement
   - **No drills**: Only displays lifting point locations without drilling
   - **Drill stud and topplate one side**: Single-sided drilling with optional batten reinforcement
   - **Drill topplate one side**: Drills only in topplate on one side

5. **Manual Adjustment**: If "Custom" side is selected, drag the grip points to manually position each lifting point. The script will adjust to the nearest valid stud.

6. **Reinforcement Options**: Enable reinforcement plates or battens if additional strength is needed at lifting points.

## Context Menu Commands

| Command | Description |
|---------|-------------|
| Reset positions | Resets all lifting point positions to their calculated defaults based on center of gravity. |
| Delete | Removes the lifting instance from the element. |
| Flip Side (inside/outside) | Available for "Drill stud and topplate one side" tooling. Toggles batten placement between inside and outside of the wall. |
| Set Symmetric/Asymmetric Batten | Available for "Drill stud and topplate one side" tooling. Toggles between symmetric and asymmetric batten placement. |

## Technical Notes

- The script uses the `hsbCenterOfGravity` function to calculate the true center of gravity including all beams and openings.
- Drills are oriented from outside to inside of the wall for proper CNC machining.
- The script excludes Randek machines from CNC drill output.
- Version history spans from 2012 to 2025 with continuous improvements for various edge cases and customer requirements.
- Filter properties support wildcard patterns: `*text*` (contains), `*text` (ends with), `text*` (starts with).
