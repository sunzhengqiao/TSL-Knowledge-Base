# hsbElementTypeCategories.mcr

## Overview
This script serves as a configuration utility for creating, editing, and managing "Style" libraries that categorize specific Element Types within the project database. It allows BIM Managers to define standardized groups (categories) of hsbCAD element types which can then be selected in other scripts via dropdown menus.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script must be inserted in Model Space to access the project database. |
| Paper Space | No | Not applicable. |
| Shop Drawing | No | Not applicable. |

## Prerequisites
- **Required Entities:** None.
- **Minimum Beam Count:** 0.
- **Required Settings:** 
  - Access to the `ElementTypes.xml` file (typically located in the Company folder).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbElementTypeCategories.mcr`

### Step 2: Select Action (Dialog 1)
A dynamic dialog titled "Step1" will appear.
1.  **Action:** Select the desired operation from the dropdown:
    -   `|New|`: Create a brand new style category.
    -   `|Edit|`: Modify the element types of an existing style.
    -   `|Copy|`: Duplicate an existing style to a new name.
    -   `|Rename|`: Change the name of an existing style.
    -   `|Delete|`: Remove a style from the database.
2.  **Style to modify:** Select the target style from the dropdown list (loaded from the current project database).
3.  Click **OK** to proceed.

### Step 3: Configure Details (Dialog 2)
A second dialog titled "Step2" will appear based on your selected Action. The fields visible will change depending on the context:

*   **If Action is |New|:**
    *   Enter a **New style name**.
    *   Enter the **Element types** (list of types/codes to include).
*   **If Action is |Edit|:**
    *   Modify the **Element types** field.
    *   (The Style Name is locked here as it was selected in Step 1).
*   **If Action is |Copy|:**
    *   Enter a **New style name** for the copy.
    *   (Element types are inherited from the source style).
*   **If Action is |Rename|:**
    *   Enter the **New style name**.
*   **If Action is |Delete|:**
    *   No second dialog appears. The script proceeds immediately to deletion logic.

4.  Click **OK** to confirm changes. The script will update the database and the XML file, then automatically remove itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Action | dropdown | \|New\| | Select the administrative operation to perform (New, Edit, Copy, Rename, Delete). |
| Style to modify | dropdown | <Dynamic> | Select the existing configuration name (Style) to act upon. |
| New style name | text | "" | Enter the unique name for a new style or the target name for renaming. |
| Element types | text | <Dynamic> | Define the list of specific Element Types associated with this Style. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| ReadFromFile | Reloads the ElementTypes dictionary from the `ElementTypes.xml` file located in the company folder. Useful for importing standards shared by other users. |

## Settings Files
- **Filename**: `ElementTypes.xml`
- **Location**: `%_kPathHsbCompany%\Element\`
- **Purpose**: Stores the dictionary of element type categories to ensure data persistence across different drawings and sessions.

## Tips
- **Self-Cleaning Script:** This script does not leave a traceable entity in the drawing. It executes, updates the background database/XML, and erases itself immediately.
- **Unique Names:** When creating a new style, ensure the "New style name" is unique. If a duplicate is detected, the script will notify you and skip the creation.
- **Safe Deletion:** The script checks for dependencies before deleting. If a style is currently being used by other objects in the project, the deletion will fail with a warning message to prevent data corruption.

## FAQ
- **Q: Where did the script go after I ran it?**
  - A: This is a "transient" script. It calls `eraseInstance()` immediately after finishing its task. You will not find an entity to click or edit later.
- **Q: How do I share my configurations with colleagues?**
  - A: The script automatically writes to `ElementTypes.xml` in the shared company folder. Your colleagues can use the "ReadFromFile" right-click option on the script to update their local databases with your changes.
- **Q: Why did the Delete action fail?**
  - A: The script prevents deletion if the Style is still referenced by other elements in the project. Remove those references first to delete the style.