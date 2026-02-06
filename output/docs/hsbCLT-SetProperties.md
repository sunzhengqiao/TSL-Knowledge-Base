# hsbCLT-SetProperties.mcr

## Overview
This script allows you to batch update metadata properties (Material, Grade, Information, and Labels) for CLT panels. You can apply updates to panels selected directly or indirectly by selecting their parent entities, such as master panels, trucks, or packages.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on panels and freight items in the 3D model. |
| Paper Space | No | Not designed for layout views. |
| Shop Drawing | No | Not a drawing generation script. |

## Prerequisites
- **Required Entities**: MasterPanels, ChildPanels, Sip entities, or TslInst freight items (Trucks, Packages).
- **Minimum Count**: At least one relevant entity must be selected to perform an update.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-SetProperties.mcr`

### Step 2: Configure Properties
**Action**: A dialog (Dynamic Dialog) or the Properties Palette will appear automatically.
1. Enter the values you wish to apply to the panels.
2. **Important**:
   - Leave a field **Blank** to keep the existing value on the panels.
   - Type `---` (three dashes) to clear the existing value on the panels.
3. Press **Enter** or click **OK** to confirm the settings.

### Step 3: Select Entities
```
Command Line: Select panels(s) or any referenced entity (child or master panels, freight item(s), packages or trucks)
Action: Click on the desired objects in the model.
```
- You can select individual panels, or click on a **Truck/Package** to update all panels inside it.
- You can click on a **Master Panel** to update its children.
- Press **Enter** to finalize the selection and apply the changes.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Material | Text | "" | Sets the material code (e.g., "CLT C24"). Leave blank to keep current; enter "---" to clear. |
| Grade | Text | "" | Sets the structural grade (e.g., "C24"). Leave blank to keep current; enter "---" to clear. |
| Information | Text | "" | Sets general information or notes. Leave blank to keep current; enter "---" to clear. |
| Label | Text | "" | Sets the primary label/sorting code. Leave blank to keep current; enter "---" to clear. |
| Sublabel | Text | "" | Sets the secondary sublabel. Leave blank to keep current; enter "---" to clear. |
| Sublabel2 | Text | "" | Sets the tertiary sublabel. Leave blank to keep current; enter "---" to clear. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script runs immediately upon insertion and erases itself; it does not persist as an object with context menus. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Smart Selection**: To save time, select a "Truck" or "Package" entity. The script will automatically find and update all panels contained within it.
- **Resetting Values**: If you need to erase data from a specific property field (e.g., remove the Grade), use the special code `---` in the input field.
- **Partial Updates**: You do not need to fill in every field. Only the fields containing text will be updated on the selected panels.

## FAQ
- **Q: How do I clear a property so it is empty?**
  A: Enter exactly `---` (three hyphens/dashes) into the property field before selecting the panels.
- **Q: What happens if I leave a field blank?**
  A: The script will ignore that field and leave the existing value on the panels unchanged.
- **Q: Can I use this on standard beams?**
  A: No, this script is designed specifically for CLT panels (Sip entities) and related freight objects.