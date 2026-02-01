# HSB_W-Post

**Creates a post with top and bottom plates in a timber frame wall element.**

---

## Overview

The HSB_W-Post script inserts a vertical post (column) into Zone 0 of a wall element, with optional steel plates at the top and bottom connections. This tool is commonly used for structural support points within wall framing, such as load-bearing posts or connection points.

The post can use various extrusion profiles (rectangular, round, or custom shapes) and includes options to split the top and bottom rails at the post location.

---

## Script Information

| Property | Value |
|----------|-------|
| **Script Type** | O (Object) |
| **Version** | 1.5 |
| **Last Updated** | 27.05.2021 |
| **Beams Required** | 0 (selects wall element interactively) |

---

## Properties

### Post Settings

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Extrusion profile name** | String (dropdown) | (available profiles) | Select the cross-section profile for the post. Options include rectangular, round, and custom extrusion profiles. |
| **Default post width** | Double | 70 mm | The width of the post cross-section. Only used for rectangular and round profiles. |
| **Default post height** | Double | 70 mm | The height (depth) of the post cross-section. Only used for rectangular and round profiles. |
| **Alignment** | String (dropdown) | Left / Center / Right | Horizontal alignment of the post relative to the insertion point. |
| **Offset top** | Double | 0 mm | Vertical offset from the top plate of the wall. Positive values move the post downward. |
| **Offset bottom** | Double | 0 mm | Vertical offset from the bottom plate of the wall. Positive values move the post upward. |

### Top Plate Settings

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Top plate** | (separator) | - | Section header for top plate properties. |
| **Create plate top** | String (dropdown) | No / Yes | Enable or disable creation of the top connection plate. |
| **Plate top width** | Double | 1500 mm | Width of the top plate (horizontal extent). |
| **Plate top height** | Double | 150 mm | Height of the top plate (vertical dimension). |
| **Plate top thickness** | Double | 250 mm | Thickness of the top plate (in wall depth direction). |
| **Plate top offset X** | Double | 0 mm | Horizontal offset of the top plate from the post center. |
| **Plate top offset Y** | Double | 0 mm | Vertical offset of the top plate from its default position. |

### Bottom Plate Settings

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Bottom plate** | (separator) | - | Section header for bottom plate properties. |
| **Create plate bottom** | String (dropdown) | No / Yes | Enable or disable creation of the bottom connection plate. |
| **Plate bottom width** | Double | 1500 mm | Width of the bottom plate (horizontal extent). |
| **Plate bottom height** | Double | 150 mm | Height of the bottom plate (vertical dimension). |
| **Plate bottom thickness** | Double | 250 mm | Thickness of the bottom plate (in wall depth direction). |
| **Plate Bottom offset X** | Double | 0 mm | Horizontal offset of the bottom plate from the post center. |
| **Plate bottom offset Y** | Double | 0 mm | Vertical offset of the bottom plate from its default position. |

### Plate Zone Assignment

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Zone to assign the plates** | Integer (dropdown) | 1-10 | Assigns the created plates to a specific wall zone. Values 1-5 are positive zones; values 6-10 map to negative zones (-1 to -5). |

### Rail Split Settings

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Split top and bottom rail** | (separator) | - | Section header for rail splitting options. |
| **Split type bottom** | String (dropdown) | Do not split / Split at plate / Split at post | Controls whether and where the bottom rail is split. |
| **Split type top** | String (dropdown) | Do not split / Split at plate / Split at post | Controls whether and where the top rail is split. |
| **Split gap** | Double | 0 mm | Gap distance between the split rail ends. |

---

## Usage Workflow

### Step 1: Insert the Script

1. Launch the HSB_W-Post command from the TSL menu or command line.
2. A dialog may appear for initial configuration (shown once on first use).

### Step 2: Select Wall Element(s)

1. When prompted with "Please select Element", click on one or more wall elements in your drawing.
2. Press Enter to confirm your selection.

### Step 3: Pick Insertion Point

1. When prompted "Pick a reference point to insert post", click at the desired location along the wall where the post should be placed.
2. The post will be created vertically between the top and bottom plates of the wall.

### Step 4: Adjust Properties

After insertion, select the post object and use the Properties Palette (OPM) to modify:

- Post dimensions and profile
- Alignment (Left, Center, Right)
- Top and bottom plate creation and dimensions
- Rail splitting behavior

---

## Behavior Notes

### Dynamic Updates

- The script automatically recalculates when the associated wall element is modified.
- If the wall is split, the script finds the closest wall element to the original insertion point and reassigns itself.

### Post Creation

- The post is created as a beam with type "Post" (_kPost).
- Default material label is set to "Metaal" (Metal).
- The post is assigned to the wall element group in Zone 0.

### Plate Creation

- Top and bottom plates are created as Sheet objects with "Steel" material.
- Plates are assigned to the specified zone number.
- Plate dimensions can be independently controlled for top and bottom.

### Rail Splitting

- **Do not split**: Rails remain continuous through the post location.
- **Split at plate**: Rails are split at the edges of the connection plate.
- **Split at post**: Rails are split at the edges of the post itself.
- When the script is deleted, split rails are automatically rejoined.

---

## Tips

- Use the **Alignment** property to position the post relative to grid lines or reference points.
- For heavy-load connections, increase the plate dimensions and consider using thicker plates.
- The **Split gap** allows for thermal expansion or tolerance in steel-to-timber connections.
- Custom extrusion profiles (e.g., hollow steel sections) can be selected for the post cross-section.

---

## See Also

- HSB_W-Stud - Standard wall stud creation
- HSB_W-Header - Header beam for openings
- Wall framing element commands

