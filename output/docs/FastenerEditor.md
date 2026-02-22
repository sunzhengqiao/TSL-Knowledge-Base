# FastenerEditor

## Overview and Purpose

The **FastenerEditor** is a specialized visual tool for creating and modifying **Fastener Assembly Definition** styles in hsbCAD. It provides a graphical interface for composing complete fastener assemblies by combining a primary component (typically a bolt, screw, threaded rod, or anchor bolt) with additional accessories such as washers, nuts, lock washers, and other components on either the head side or the threaded end.

The editor creates a live visual preview of the fastener assembly in Model Space, allowing you to see exactly how components stack together. Once satisfied with your configuration, you save the assembly as a reusable style definition that can be applied throughout your project.

**Key Capabilities:**
- Create new fastener assembly styles from the FastenerManager database
- Add head components (washers, lock washers) to the bolt head side
- Add closing components (nuts, washers) to the threaded end
- Visual real-time stacking preview with accurate geometry
- Import existing styles from other drawings or DWG templates
- Save custom assemblies as reusable style definitions
- Integration with the hsbCAD Style Manager and SimpleFastener tool

**Primary Use Cases:**
- Defining standard fastener assemblies for timber connections
- Creating custom bolt/washer/nut combinations for repeated use
- Standardizing hardware specifications across projects
- Importing proven assembly configurations from template drawings
- Building fastener libraries for different connection types

---

## Usage Environment

| Property | Value |
|----------|-------|
| Script Type | O (Object) |
| Workspace | Model Space |
| Beams Required | 0 |
| Version | 2.1 (October 2025) |
| Database Dependency | FastenerManager.dll required |

**Script Modes:**
- **Mode 0**: Main fastener assembly editor (primary insertion point)
- **Mode 1**: Head component (child instance on head side)
- **Mode 2**: Closing component (child instance on threaded end)
- **Mode 3**: Component selection dialog mode (internal)
- **Mode 98**: SimpleFastener invocation mode (internal)

---

## Prerequisites

Before using FastenerEditor, ensure the following:

### 1. FastenerManager Database

The tool requires access to the **FastenerManager** database located at:
```
[hsbCAD Install]\Utilities\FastenerManager\FastenerManager.dll
```

This database contains all fastener and component specifications including:
- Fastener types (Bolt, Screw, Threaded Rod, Anchor Bolt)
- Component types (Washer, Lock Washer, Nut, Barrel Nut, Split Ring, Square Washer)
- Manufacturer catalogs
- Dimensional data (diameters, heights, stack thicknesses)
- Article numbers and descriptions

If the database is missing, the script will display an error and terminate.

### 2. Fastener Assembly Styles

**Initial Setup:**
- If no `FastenerAssemblyDefinition` styles exist in your drawing when you first insert FastenerEditor, you will be automatically prompted to create them from the database.
- The script launches the **SimpleFastener** tool to populate initial styles based on your selected manufacturer and fastener type.
- Alternatively, you can import existing styles from template drawings using the "Import Styles from Drawing" command.

**Recommended Workflow:**
1. First-time users: Allow the automatic SimpleFastener prompt to create base styles
2. Import additional styles from company templates or previous projects
3. Customize and save new assemblies as needed

### 3. AutoCAD/hsbCAD Environment

- Model Space must be active (script operates in Model Space only)
- DimStyles available for annotation during drag operations
- Write access to drawing database for saving new style definitions

---

## Insertion and Initial Configuration

### Step 1: Launching the Script

**Via Command Line:**
```
hsb_ScriptInsert "FastenerEditor"
```

**Via TSL Browser:**
Navigate to the script in the TSL Browser and double-click to launch.

### Step 2: Initial Configuration Dialog

Upon insertion, a dialog appears with the following options:

| Field | Type | Description |
|-------|------|-------------|
| **Manufacturer** | Dropdown | Filters fasteners by manufacturer. Select "Any" to show all manufacturers in the database. Options dynamically populate from FastenerManager database. |
| **Type** | Dropdown | Fastener type: Bolt, Screw, Threaded Rod, Anchor Bolt. Determines available assembly styles and component compatibility (e.g., Screws only support head components). |
| **Assembly Style** | Dropdown | Lists existing FastenerAssemblyDefinition styles matching the manufacturer and type filters. If no styles exist, you'll be prompted to create them via SimpleFastener. |

**Type Selection Guide:**
- **Bolt**: Full threading support, allows both head and closing components (nuts, washers on both ends)
- **Screw**: Head components only (no threaded end components)
- **Threaded Rod**: Symmetric, allows components on both ends
- **Anchor Bolt**: Special anchor applications, component support varies

### Step 3: Pick Insertion Point

After confirming the dialog:
1. Click a point in Model Space (`_Pt0`) to place the FastenerEditor instance
2. The fastener assembly displays vertically from the insertion point
3. The main fastener body renders in **dark gray** (saved) or **dark yellow** (unsaved/edited)
4. Component instances automatically attach as child entities

**Visual Feedback:**
- **Dark Gray**: Assembly matches saved style definition
- **Dark Yellow/Orange**: Unsaved changes exist
- **Dove Blue**: Thread length indicator (for bolts)
- **Colored Components**: Head and closing components render with realistic geometry

### Step 4: Understanding the Instance Hierarchy

The FastenerEditor creates a parent-child entity structure:

```
FastenerEditor (Parent, Mode 0)
├─ Head Component 1 (Child, Mode 1)
├─ Head Component 2 (Child, Mode 1)
├─ Closing Component 1 (Child, Mode 2)
└─ Closing Component 2 (Child, Mode 2)
```

- **Parent**: Controls main fastener, manages overall assembly
- **Children**: Individual components, auto-stack along fastener axis
- **Deletion**: Deleting parent removes all children; deleting child updates parent

---

## Adding and Managing Components

### Adding a New Component

**Method 1: Context Menu**
1. Right-click the main FastenerEditor instance
2. Select **"Add Component"** from the context menu
3. Configure component in the dialog (see below)

**Method 2: Double-Click**
1. Double-click the main FastenerEditor instance
2. Dialog appears automatically

### Component Configuration Dialog

When adding a component, you configure:

| Field | Type | Description | Notes |
|-------|------|-------------|-------|
| **Manufacturer** | Dropdown | Component manufacturer | "Any" shows all manufacturers |
| **Type** | Dropdown | Component type | Washer, Lock Washer, Nut, Barrel Nut, Split Ring, Square Washer |
| **Component** | Dropdown | Specific component model | Filtered by type and diameter compatibility with main fastener |
| **Location** | Dropdown | Placement position | See Location Options below |

**Location Options:**

| Location | Mode | Description | Availability |
|----------|------|-------------|--------------|
| **Head Component** | Mode 1 | Placed on the head side of the bolt/screw | Always available |
| **Closing Component** | Mode 2 | Placed on the threaded end | Available for Bolts and Threaded Rods only |
| **Head+Closing Component** | Both 1&2 | Places identical component on both ends | Only when adding from main assembly (Mode 0) |

**Component Type Compatibility:**

| Component Type | Description | Geometry | Special Notes |
|----------------|-------------|----------|---------------|
| **Washer** | Flat washer | Cylindrical ring with central hole | Standard load distribution |
| **Lock Washer** | Spring washer | Ring with angled split | Visual split rendered at 90° |
| **Nut** | Hex nut | Hexagonal body with thread | Auto-placed at closing end for bolts |
| **Barrel Nut** | Cylindrical nut | Round barrel shape | For special applications |
| **Split Ring** | Split ring connector | Ring with gap | Centered on fastener axis |
| **Square Washer** | Square plate washer | Rectangular plate with hole | For timber bearing applications |

**Diameter Compatibility Filtering:**
The component dropdown automatically filters based on:
- Main fastener diameter
- Component compatibility range (MinDiameter to MaxDiameter)
- If no compatible components exist, the dropdown is empty

### Modifying Existing Components

**Changing a Component:**
1. Select the component instance (child entity)
2. Double-click **OR** right-click and select **"Select Component"**
3. Component Selector Dialog appears (advanced database browser)
4. Choose a different component from the database
5. Component geometry updates immediately

**Component Selector Dialog Features:**
- Manufacturer filtering
- Diameter filtering (auto-set to main fastener diameter)
- Type filtering
- Search functionality
- Last-used settings persistence

**Deleting a Component:**
1. Select the component instance
2. Press **Delete** or use AutoCAD **ERASE** command
3. Main assembly recalculates and updates stacking
4. Assembly marked as "Edited" (unsaved changes)

### Component Stacking Behavior

Components automatically stack along the fastener axis (`vecZ` direction):

**Head Components (Mode 1):**
- Stack **away from** insertion point
- Order: Main fastener head → Component 1 → Component 2 → ...
- Spacing determined by each component's `StackThickness` property

**Closing Components (Mode 2):**
- Stack **inward from** threaded end
- Order: Thread end → Component 1 → Component 2 → ...
- Position calculated from `dFastenerLength - dThreadOffset`

**Automatic Repositioning:**
- Triggered when main fastener moves (`_Pt0` changed)
- Triggered when assembly style changes
- Triggered when components are added/deleted
- Components freeze during repositioning to prevent interference
- All children recalculate after repositioning completes

**Stack Order Persistence (HSB-24419):**
- Components are stored in the order they appear in the stack
- Saved styles preserve component sequence
- Head components save from head outward
- Closing components save from thread inward

---

## Properties Panel (OPM) Reference

When a FastenerEditor or component instance is selected, properties appear in the AutoCAD Properties Palette.

### Main Instance Properties (Mode 0)

**Category: General**

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Manufacturer** | String Dropdown | "Any" | Filters fasteners by manufacturer. Selecting "Any" shows all manufacturers. Changes trigger type cache update. |
| **Type** | String Dropdown | - | Fastener type: Bolt, Screw, Threaded Rod, Anchor Bolt. Affects available assembly styles and component locations. |
| **Assembly Style** | String Dropdown | - | The FastenerAssemblyDefinition style to edit. Lists existing styles matching manufacturer and type filters. |

**Category: Display**

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Dimstyle** | String Dropdown | "Standard" | Dimension style used for length annotations during drag operations. Lists all available dimension styles in drawing. |

**Property Dependencies:**
- Changing **Manufacturer** → Rebuilds **Type** list → Rebuilds **Assembly Style** list
- Changing **Type** → Rebuilds **Assembly Style** list
- Changing **Assembly Style** → Triggers full recalculation, rebuilds child components

### Component Instance Properties (Mode 1 & 2)

**Category: Fastener Component**

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Manufacturer** | String Dropdown | - | Manufacturer of the accessory component. "Any" shows all manufacturers. |
| **Type** | String Dropdown | - | Component type: Washer, Lock Washer, Nut, Barrel Nut, Split Ring, Square Washer. |
| **Component** | String Dropdown | - | Specific component model. Filtered by type and diameter compatibility with main fastener. |
| **Location** | String Dropdown | - | Placement position: Head Component (Mode 1), Closing Component (Mode 2). Auto-set for nuts on bolts. |

**Automatic Location Constraints (HSB-24054):**
- When a **Nut** is added to a **Bolt**, Location is automatically set to **"Closing Component"** (Mode 2)
- This constraint cannot be changed (nuts logically belong on the threaded end)
- Other component types allow manual location selection

**Property Update Behavior:**
- Changing **Manufacturer** or **Type** → Rebuilds **Component** list
- Changing **Component** → Triggers geometry recalculation
- Changing **Location** → Triggers repositioning along stack

---

## Context Menu Commands

FastenerEditor provides context-sensitive right-click menus depending on the instance mode.

### Main Instance Menu (Mode 0)

Right-click the main FastenerEditor instance to access:

| Command | Shortcut | Description |
|---------|----------|-------------|
| **Add Component** | Double-Click | Opens dialog to add a new washer, nut, or other component to the assembly. Allows selection of component type, manufacturer, and location (head/closing). |
| **Save** | - | Saves the current assembly configuration as a FastenerAssemblyDefinition style. Prompts for style name and handles overwrites. |
| **Import Styles from Drawing** | - | Browse and import fastener assembly styles from another DWG file. Opens file browser, then style selection dialog. Handles duplicates intelligently. |
| **Create Styles from Database** | - | Launches SimpleFastener tool to create new styles directly from the FastenerManager database. Sets default type to "Bolt". |
| **Show Style Manager** | - | Opens the AutoCAD Style Manager (`_AecStyleManager`) to manage all style definitions in the drawing. |
| **Load Graphical Ruleset** | - | Imports a graphics ruleset file for fastener visualization (calls `hsb_fa_importgraphicsruleset`). For advanced rendering customization. |
| **Open Database Manager** | - | Opens the FastenerManager database utility for viewing and managing fastener data. Allows database inspection and verification. |

### Component Instance Menu (Mode 1 & 2)

Right-click a component instance to access:

| Command | Shortcut | Description |
|---------|----------|-------------|
| **Select Component** | Double-Click | Opens the Component Selector Dialog (advanced database browser) to change the component. Provides manufacturer, type, diameter filtering and search. |

---

## Saving Fastener Assembly Styles

### Save Workflow

**Step 1: Trigger Save Command**
1. Right-click the main FastenerEditor instance
2. Select **"Save"** from context menu

**Step 2: Enter Style Name**
A text input dialog appears:
- **Prompt**: "Modify the existing assembly style or create a new one."
- **Title**: "Save Fastener Assembly Style"
- **Prefill**: Current assembly style name (if editing existing style)
- **Prefill Selected**: Yes (for easy overwriting)

**Step 3: Handle Conflicts**
If a style with the entered name already exists:
- **Conflict Dialog** appears
- **Question**: "[Style Name] already exists, overwrite?"
- **Positive Option**: "Overwrites the existing assembly style with the new content. Any existing instance referring to this style will be updated."
- **Negative Option**: "Will not save the modifications"

**Step 4: Save Execution**

**Creating New Style:**
```
Creates new FastenerAssemblyDef with specified name
Copies description from base style
Copies listComponent (main fastener) from base style
Sets headComponents[] array from child instances (Mode 1)
Sets tailComponents[] array from child instances (Mode 2)
Reports: "[Style Name] has been created with [N] Fastener Components."
```

**Overwriting Existing Style:**
```
Updates existing FastenerAssemblyDef
Preserves description and listComponent
Updates headComponents[] array
Updates tailComponents[] array
Triggers recalculation of all FastenerAssembly entities using this style
Reports: "[Style Name] has been updated with [N] Fastener Components. [M] fastener assemblies updated with new definition"
```

### Component Sequence Preservation (HSB-24419)

**Critical Detail:**
The save function preserves the exact stacking order of components:

**Head Components:**
- Saved in order from head outward (stack direction)
- Sequence: Head surface → Component 1 → Component 2 → ...

**Closing Components:**
- Saved in order from thread inward (reverse stack direction)
- Sequence: Thread end → Component 1 → Component 2 → ...

**Why This Matters:**
When the style is loaded on a FastenerAssembly entity, components appear in the same stacking order, ensuring visual and functional consistency.

### Save State Tracking

**Edited Flag:**
The script tracks whether the current assembly differs from the saved style:

- **Comparison Key**: Generated from component lists
- **Edited = True**: Current assembly differs from saved style (renders in **dark yellow**)
- **Edited = False**: Current assembly matches saved style (renders in **dark gray**)

**Triggers for Edited State:**
- Adding a component
- Deleting a component
- Changing a component's model
- Changing a component's location

**Reset on Save:**
After successfully saving, the comparison key updates and Edited flag resets to False.

### Cross-Instance Updates

**Automatic Propagation:**
When you save a style, the script automatically finds and updates all other FastenerEditor instances in the drawing that reference the same style:

```
Searches all TslInst entities with scriptName "FastenerEditor"
Filters for instances where Assembly Style property matches saved style
Triggers recalc() on each matching instance
Recalculates child components for each instance
```

This ensures all visual previews stay synchronized with the saved definition.

---

## Importing Styles from Other Drawings

### Import Workflow

**Step 1: Trigger Import**
1. Right-click main FastenerEditor instance
2. Select **"Import Styles from Drawing"**

**Step 2: Browse for File**
File browser dialog appears:
- **Title**: "Select Drawing with Fastener Styles"
- **Start Location**: Last used path (persisted in catalog)
- **File Type**: `*.dwg`

**Step 3: Validate Selection**

**File Checks:**
- **File must exist**: Non-existent paths rejected
- **File must be closed**: Open drawings cannot be imported this way (use Style Manager for open files)
  - Error message: "The selected file must be closed in AutoCAD to import styles this way. You can import styles from open files using the Style Manager instead."

**Step 4: Style Selection**
If styles are found in the DWG:
- **Selection Dialog** appears with sorted list of all FastenerAssemblyDefinition styles
- **Multi-select enabled**: Check multiple styles to import
- **Select All** button available

If no styles found:
- Notice dialog: "No styles are defined in the file located at [path]"

**Step 5: Handle Duplicates**

If any selected style already exists in the current drawing:
- **Duplicate Dialog** appears
- **Question**: "Overwrite existing styles?"
- **Positive Option**: "Overwrites the existing style with the new content. Instances referring to this style will be updated."
- **Negative Option**: "Duplicate style definitions will not be imported."

**Step 6: Import Execution**

**With Overwrite:**
```
Imports all selected styles
Overwrites duplicates
Updates existing FastenerAssembly entities
Reports: "[Style Names] successfully imported from [path]"
```

**Without Overwrite:**
```
Imports only non-duplicate styles
Skips duplicates
Reports: "Import completed, duplicates ignored from [path]"
```

**Step 7: Auto-Update**

After successful import:
```
Updates FastenerEditor instance to reflect new styles
Triggers full recalculation
Adds new styles to Assembly Style dropdown
Reports number of updated FastenerAssembly entities per style
```

### Path Persistence

**Last Used Path Tracking:**
The script stores the last browsed folder path in the catalog:
- Stored in **PropString[8]** of the "FastenerEditor" catalog entry
- Persists across sessions
- Automatically populates "Start Location" on next import

---

## Creating Styles from Database

### Automatic Creation (HSB-24011)

**Trigger Conditions:**
When you insert FastenerEditor and **no** FastenerAssemblyDefinition styles exist in the drawing, the script automatically:

1. Displays a dialog prompting to create styles
2. Launches **SimpleFastener** tool in creation mode (Mode 98)
3. Pre-fills manufacturer filter from current selection
4. Sets default fastener type to **"Bolt"** (HSB-24054)

**SimpleFastener Configuration:**
```
Filter Settings:
- SelectedManufacturer: [Current sFManufacturer]
- SelectedHeadType: "--All--"
- FastenerType: "Bolt"
- SelectedDiameter: "--All--"

Mode: 98 (Create styles mode)
Event: OnDbCreated
```

**After Creation:**
- SimpleFastener creates basic single-component styles
- FastenerEditor reloads available styles
- User can now select a base style to begin editing

### Manual Creation

**Trigger:**
Right-click main instance → Select **"Create Styles from Database"**

**Process:**
Identical to automatic creation, but uses current manufacturer/type settings from the FastenerEditor instance.

**Use Case:**
Creating additional base styles after initial setup, or adding styles for different manufacturers/types.

---

## Fastener Geometry Rendering

The FastenerEditor renders accurate 3D geometry for visual preview. Understanding the geometry helps interpret what you see.

### Main Fastener Body

**Bolt (kFTBolt):**
```
Cylindrical shaft with uniform diameter
Conical tip (faceted end)
Facet depth = 10% of diameter
Thread length displayed as dove blue indicator
```

**Screw (kFTScrew):**
```
Tapered pilot section (smaller diameter before threads)
Threaded section (full diameter)
Pointed tip (28° taper angle)
Tip length = 0.5 * diameter / tan(28°)
```

**Threaded Rod (kFTThreadedRod):**
```
Uniform cylinder with facets at both ends
Symmetrical geometry
```

**Anchor Bolt (kFTAnchorBolt):**
```
Uniform cylinder with facets at both ends
Similar to threaded rod
```

### Head Geometries

**Flat Head (kFlatHead):**
```
Countersunk conical profile
Cylindrical pilot section at bottom
Conical transition to full head diameter
Default head diameter = 1.9 * main diameter
```

**Hex Head (kHexHead):**
```
Hexagonal prism
Inner circle radius derived from outer radius
Facets on top and bottom edges (8% chamfer)
Outer tips trimmed to circular profile
```

**Exterior Flange (kExteriorFlange):**
```
Hex head with additional flange ring
Flange height = 10-20% of head height
Flange extends beyond hex profile
```

**Oval Head (kOvalHead):**
```
Half-dome profile
Radius = head diameter / 2
Height = 50% of standard head height
Rendered via circular sweep path
```

**Pan Head (kPanHead):**
```
Cylindrical side walls
Flat top with chamfered edge
Height derived from standard rules
```

**Truss Head (kTrussHead):**
```
Low-profile rounded dome
Radius > head diameter (creates flatter profile)
Rendered via circular sweep path
```

**Round Head (kRoundHead):**
```
Full hemisphere
Radius = head diameter / 2
Rendered via circular sweep path
```

**Socket Head (kSocketHead):**
```
Cylindrical profile
Flat top surface
Height from standard nut height rules
```

**Button Head (kButtonHead):**
```
Low-profile dome
Similar to truss head
Rendered via circular sweep path
```

**Washer Head (kWasherHead):**
```
Integrated washer flange at base
Cylindrical or dome top section
Larger diameter than standard head
```

**Threaded End (kThreadedEnd):**
```
No head geometry
Direct thread from end
Used for double-ended threaded rods
```

### Component Geometries

**Washer (kCTWasher):**
```
Cylindrical ring
Outer diameter = SinkDiameter
Inner diameter = MainDiameter (bolt shaft)
Height = StackThickness
```

**Lock Washer (kCTLockWasher):**
```
Cylindrical ring with angled split
Split rendered at 90° rotation
Gap aligned with Y-axis
Height = StackThickness
```

**Nut (kCTNut):**
```
Hexagonal prism (same as hex head)
Top and bottom facets (chamfers)
Inner thread hole = MainDiameter
Height = StackThickness
```

**Barrel Nut (kCTBarrelNut):**
```
Cylindrical body
Diameter = SinkDiameter
Length along X-axis = SinkDiameter
Centered on Z-axis
```

**Split Ring (kCTSplitRing):**
```
Cylindrical ring (no split gap in geometry)
Centered on fastener axis
Outer diameter = SinkDiameter
Inner diameter = MainDiameter
```

**Square Washer (kCTSquareWasher):**
```
Rectangular prism
Side length = SinkDiameter
Central circular hole = MainDiameter
Height = StackThickness
```

### Geometry Performance Notes

**Display vs. Real Body:**
- The script uses `realBody()` for component geometry (accurate ACIS solids)
- Main fastener can use `envelopeBody()` for performance (simplified bounding geometry)
- All bodies stored in `_Map.getMap("Bodies")` for persistence

**Visual Debug Mode:**
- Set `bDebug = true` to enable debug visualization
- Components render with `.vis()` color codes
- Stacking order visible via colored lines
- Useful for troubleshooting geometry issues

---

## Dialog Services and UI Components

FastenerEditor uses the **TslUtilities.dll** dialog service for all UI interactions.

### Dialog Methods Used

| Method | Purpose | Input Parameters | Output |
|--------|---------|------------------|--------|
| **SelectFromList** | List selection with search | Items[], Title, Prompt, SelectedIndex | SelectedIndex, Selection[] (multi) |
| **GetText** | Text input dialog | Title, Prompt, PrefillText, Alignment | Text, WasCancelled |
| **AskYesNo** | Binary question | Title, Question, ToolTips (positive/negative) | Answer (1=Yes, 0=No) |
| **ShowNotice** | Information message | Notice | - |
| **BrowseForFile** | File browser | Title, StartLocation, FileType | FilePath, WasCancelled |
| **ShowDynamicDialog** | Dynamic multi-control form | RowDefinitions[], ControlTypes | Map with control values |

### Component Selector Dialog (Database Browser)

**Invoked By:**
- Double-click component instance
- Right-click component → "Select Component"

**Interface Features:**
- **Manufacturer Filter**: Dropdown with all manufacturers
- **Type Filter**: Dropdown with component types
- **Diameter Filter**: Auto-set to main fastener diameter, editable
- **Search Box**: Full-text search across component models
- **Results Grid**: Displays matching components with specifications
- **Last State Persistence**: Remembers previous filter selections

**Data Flow:**
```
Input Map (ComponentSelector):
├─ ComponentSelectorState
│  ├─ SelectedManufacturer
│  ├─ Type
│  ├─ SelectedDiameter
│  └─ SearchTerm (optional)
└─ SelectedComponents (previous selection)

Output Map:
├─ ComponentSelectorState (updated filters)
└─ SelectedComponents (newly selected items)
```

**Component Data Structure:**
Each component returns:
```
Map Component:
├─ Name: Component name
├─ Type: Component type (Washer, Nut, etc.)
├─ Manufacturer: Manufacturer name
├─ Model: Component model identifier
├─ Diameter: Main diameter
├─ StackThickness: Height/thickness
├─ SinkDiameter: Outer diameter
├─ ArticleNumber: Catalog part number
├─ Description: Component description
└─ Map: Full database map (all custom fields)
```

---

## Database Integration (FastenerManager)

### Database Structure

**Location:**
```
[hsbCAD Install]\Utilities\FastenerManager\FastenerManager.dll
```

**DLL Class:**
```
FastenerManager.TslConnector
```

**Key Methods:**

| Method | Purpose | Input | Output |
|--------|---------|-------|--------|
| **VerifyDatabaseExists** | Check database availability | - | Boolean |
| **GetLastDatabasePath** | Get active database path | - | String path |
| **GetManufacturers** | Get all manufacturers | - | String[] |
| **GetManufacturersList** | Get manufacturers with metadata | - | Map[] |
| **GetScrewListWithFilter** | Get fasteners by filter | Manufacturer, Type | Map[] fasteners |
| **GetComponents** | Get components by filter | Manufacturer, Type, Diameter | Map[] components |
| **ShowComponentSelectorDialog** | Open component browser UI | ComponentSelectorState | SelectedComponents |
| **ShowFastenerManager** | Open database manager app | - | - |

### Fastener Type Caching (HSB-24011)

**Performance Optimization:**
To avoid repeated database queries, fastener types are cached:

```
Cache Structure (_Map.getMap("FastenerTypeCache")):
├─ Manufacturer: "Simpson StrongTie"
└─ FastenerTypes:
   ├─ [0]: "Bolt"
   ├─ [1]: "Screw"
   └─ [2]: "ThreadedRod"

Cache Invalidation:
- Triggered when Manufacturer property changes
- Triggered on _bOnRecalc
- Cache rebuilds via GetScrewListWithFilter() call
```

**Why Cache?**
Querying all fastener types for a manufacturer can return thousands of entries. Caching reduces API calls and improves OPM responsiveness.

### Component Filtering Logic

**Diameter Compatibility:**
When selecting components, the script filters based on diameter ranges:

```
If main fastener diameter is 12mm:
- Query MinDiameter <= 12mm AND MaxDiameter >= 12mm
- Only compatible components appear in dropdown

Special Case (exact match):
- If minDiameter == maxDiameter:
  - Query: Diameter = exactValue
  - Used for precise component matching
```

**Manufacturer Filtering:**
```
"Any" manufacturer:
- Queries all manufacturers
- Large result sets possible
- Type list limited to first 6 unique types

Specific manufacturer:
- Queries single manufacturer
- Faster, more focused results
```

### Database Map Conversion

**Database Format → SimpleComponent Format:**
The script translates database maps to FastenerSimpleComponent structures:

```
Database Map Fields:
- ArticleNumber, Description, Notes
- Type, SubType, Manufacturer, Model
- Material, Category, Group, Coating, Grade, Norm
- Diameter, Height, OuterDiameter
- FastenerLength, ThreadLength
- MinProjectionLength, MaxProjectionLength
- HasLengthInfo, IsBespoke
- (Custom fields in nested Map)

Converted to FastenerSimpleComponent:
├─ FastenerComponentData (fcd)
│  ├─ Type, SubType, Manufacturer, Model
│  ├─ Material, Category, Group, Coating, Grade, Norm
│  ├─ MainDiameter, SinkDiameter, StackThickness
└─ FastenerArticleData (fad)
   ├─ ArticleNumber, Description, Notes
   ├─ FastenerLength, ThreadLength
   ├─ MinProjectionLength, MaxProjectionLength
   ├─ HasLengthInfo, IsBespoke
   └─ Map (full database map preserved)
```

**Why Preserve Full Map?**
The nested `Map` field preserves all database fields, including manufacturer-specific custom fields (e.g., `HeadHeightN`, `headDiameter`, `pilotDiameter`). This ensures no data loss during conversion.

---

## Advanced Features and Workflows

### Drag Operation Enhancements (HSB-24011)

**Length List Display:**
During grip-drag operations, the script displays available fastener lengths:

**Condensed Display Mode:**
- Lists all available lengths from `FastenerArticleData`
- Displays as comma-separated values
- Updates dynamically as you drag
- Uses selected DimStyle for annotation

**Implementation:**
```
If dragging _Pt0 grip:
- Calls FastenerLengthList(definition)
- Extracts FastenerLength and ThreadLength arrays
- Sorts ascending
- Renders text annotation at drag point
```

**Visual Aids:**
- Thread length indicator (dove blue line) for bolts
- Length values displayed near cursor
- Real-time geometry updates

### Child Component Copying

**Remote Component References:**
When a component child is copied (e.g., via AutoCAD COPY command), the parent must be notified to maintain the entity relationship.

**Mechanism:**
```
Component stores parent reference in _Map.setEntity("parent")
On copy, component writes itself to parent's _Map.appendEntity("remote[]")
Parent reads remote[] array and appends to _Entity[]
Remote references cleared after processing
```

**Why This Matters:**
Ensures copied components integrate into the assembly hierarchy and participate in stacking calculations.

### Version Compatibility

**MapX Metadata:**
The script embeds version history in the `#BeginMapX` section:

```xml
<Hsb_Map>
  <str nm="Version" vl="2.1"/>
  <str nm="Date" vl="17.10.2025"/>
  <str nm="IssueID" vl="HSB-24011"/>
  <str nm="Description" vl="fastener types are cached, graphics on drag improved"/>
</Hsb_Map>
```

**Version History Tracking:**
- Every release documented in `#BeginDescription`
- Issue IDs linked to hsbCAD bug tracker
- Major/Minor version numbers in header

**Breaking Changes:**
- Version 2.0: Auto-prompt for style creation
- Version 1.9: Component sequence fix (critical for save)
- Version 1.5: Import from drawing feature added

### Debugging and Development

**Debug Mode Activation:**
```
int bDebug = _bOnDebug;  // Set via hsbCAD debug flag
```

**Debug Features:**
- Verbose logging (`reportNotice` calls)
- Visual debugging (`.vis()` colored geometry)
- Map inspection (writes to `.dxx` files for hsbMapExplorer)
- Component stacking visualization
- Frozen instance during drag

**Debug Triggers:**
```
Set bDebug = 1 manually in script
Use hsbCAD debug mode
Inspect _Map.getEntity("thisInst") for instance details
```

**MapExplorer Integration:**
```
If debugging:
  mapOut.writeToDxxFile(_kPathPersonalTemp + "\\FastenerEditor.dxx");
  spawn_detach("", _kPathHsbInstall + "\\Utilities\\hsbMapExplorer\\hsbMapExplorer.exe", sFileMap, "");
```

Launches external map viewer for deep inspection of FastenerComponentData and ArticleData structures.

---

## Settings and Persistence

### Catalog Storage

**Catalog Entries:**
- **"_Default"**: Default property values for new insertions
- **"_LastInserted"**: Last used property values (persists across sessions)

**Stored Properties:**
```
PropString[]:
├─ [0]: Manufacturer (sFManufacturer)
├─ [1]: Type (sFType)
├─ [2]: Assembly Style (sDefinition)
├─ [3]: Component Manufacturer (sCManufacturer)
├─ [4]: Component Type (sCType)
├─ [5]: Component Model (sComponent)
├─ [6]: Location (sLocation)
├─ [7]: DimStyle (sDimStyleUI)
└─ [8]: Last Import Path (sLastPath)
```

**Read/Write Workflow:**
```
On Insertion:
- Read catalog "_LastInserted"
- Populate properties from catalog
- Display dialog with prefilled values

On User Change:
- Update property values
- Write to catalog "_LastInserted"
- Persist for next session
```

**Last Import Path Persistence:**
```
On Import Styles from Drawing:
- Read PropString[8] from catalog "FastenerEditor._Default"
- Use as StartLocation for file browser
- After file selection, extract parent directory
- Write updated path to PropString[8]
- Save catalog
```

### Map Storage (_Map Persistence)

**Key Map Entries:**

| Key | Type | Purpose |
|-----|------|---------|
| **mode** | Int | 0=Main, 1=HeadComponent, 2=ClosingComponent |
| **Edited** | Int | Boolean: Assembly differs from saved style |
| **compareKey** | String | Hash/key for detecting save state |
| **Bodies** | Map | Array of Body objects for rendering |
| **MainComponent** | Map | SimpleComponentToMap() of main fastener |
| **Component** | Map | SimpleComponentToMap() of this component (Mode 1&2) |
| **FastenerTypeCache** | Map | Cached fastener types by manufacturer |
| **ComponentSelector** | Map | Last ComponentSelector dialog state |
| **OnStyleImport** | Int | Flag: Style import in progress |
| **OrderChildsLocation** | Int | Flag: Trigger child repositioning |
| **remote[]** | Entity[] | Copied component references |
| **thisInst** | Entity | Self-reference for debug (HSB-22564) |

**Body Array Storage:**
```
Map Bodies:
├─ [0]: Body (main fastener)
├─ [1]: Body (head component 1)
├─ [2]: Body (head component 2)
├─ [3]: Body (closing component 1)
└─ ...

Accessed via:
Body bodies[] = GetBodyArray(_Map.getMap("Bodies"));
```

**Component Map Storage:**
```
Map Component (for child instances):
├─ Name: "Washer M12"
├─ Type: "Washer"
├─ Manufacturer: "Generic"
├─ Model: "DIN125-A"
├─ MainDiameter: 12.0
├─ SinkDiameter: 24.0
├─ StackThickness: 2.5
├─ ArticleNumber: "W-M12-DIN125"
└─ Map: {...} (full database map)
```

---

## Troubleshooting and Error Handling

### Common Issues

**Issue 1: No Assembly Styles Available**

**Symptom:**
- Assembly Style dropdown is empty when inserting FastenerEditor

**Cause:**
- No FastenerAssemblyDefinition styles exist in drawing

**Solution:**
- **Automatic**: If inserting new instance, auto-prompt appears to create styles via SimpleFastener
- **Manual**: Right-click → "Create Styles from Database"
- **Import**: Right-click → "Import Styles from Drawing" from a template

**Prevention:**
- Maintain a company template DWG with standard fastener styles
- Import base styles at project start

---

**Issue 2: Can Only Add Components to Head Side**

**Symptom:**
- "Closing Component" option not available in Location dropdown

**Cause:**
- Main fastener Type is "Screw"
- Screws do not have threaded ends, only head-side components are supported

**Solution:**
- Change Assembly Style to a **Bolt** or **Threaded Rod** type
- Or accept head-side components only for screws

**Technical Reason:**
Screws have integrated threads along their length, not a separate threaded end section like bolts.

---

**Issue 3: Component Not in Dropdown List**

**Symptom:**
- Expected component model missing from Component dropdown

**Cause:**
- Component diameter incompatible with main fastener diameter
- Component not in database for selected manufacturer

**Solution:**
1. Check main fastener diameter
2. Verify component exists in database using "Open Database Manager"
3. Check manufacturer filter (try "Any" manufacturer)
4. Verify component MinDiameter/MaxDiameter range covers main diameter

**Diameter Filtering Logic:**
```
Main Fastener Diameter: 12mm

Compatible Component:
- MinDiameter: 10mm
- MaxDiameter: 16mm
- Result: SHOWN

Incompatible Component:
- MinDiameter: 16mm
- MaxDiameter: 24mm
- Result: HIDDEN
```

---

**Issue 4: Location Property Locked to "Closing Component"**

**Symptom:**
- Cannot change Location property for nut component
- Property appears grayed out or resets automatically

**Cause:**
- **Nuts on Bolts** automatically default to Closing Component (HSB-24054)
- This is intentional design behavior

**Explanation:**
Nuts logically belong on the threaded end of bolts. The script enforces this constraint to prevent illogical configurations.

**Solution:**
- No action needed; this is correct behavior
- If you need a nut-like component on the head side, use a different component type

---

**Issue 5: Edited Flag Always True (Won't Save)**

**Symptom:**
- Assembly always renders in dark yellow
- Edited flag never clears after saving

**Cause:**
- Component order mismatch between instance and saved style
- Corrupted compareKey in _Map

**Solution:**
1. Delete all child components
2. Save as new style name
3. Re-add components in desired order
4. Save again

**Technical Reason:**
The `compareKey` is generated from component arrays. If arrays don't match (due to manual reordering or script bugs), the comparison fails.

---

**Issue 6: Import from Drawing Fails (File Open Error)**

**Symptom:**
- Error message: "The selected file must be closed in AutoCAD to import styles this way."

**Cause:**
- Target DWG file is currently open in AutoCAD session

**Solution:**
- Close the target DWG file
- Retry import
- **Alternative**: Use AutoCAD Style Manager (`_AecStyleManager`) to import from open drawings

**Technical Reason:**
TSL cannot read from locked DWG files. Style Manager uses different API with open-file support.

---

**Issue 7: Database Not Found Error**

**Symptom:**
- Script terminates with error: "Could not find file: [path]\FastenerManager.dll"

**Cause:**
- FastenerManager database missing from installation
- Incorrect hsbCAD installation path

**Solution:**
1. Verify hsbCAD installation directory: `_kPathHsbInstall`
2. Check file exists: `[hsbCAD Install]\Utilities\FastenerManager\FastenerManager.dll`
3. Reinstall hsbCAD or copy database from another installation
4. Contact hsbCAD support if issue persists

---

**Issue 8: Components Stack in Wrong Order**

**Symptom:**
- Components appear reversed from expected order
- Saving doesn't preserve sequence

**Cause:**
- Prior to Version 1.9 (HSB-24419), component sequence was reversed during save
- Older drawings may have legacy data

**Solution:**
- Update to Version 2.1 or later
- Delete and re-add components in correct order
- Save new style to fix sequence

**Technical Fix (HSB-24419):**
```
// OLD (buggy):
for (int i=tslHeads.length()-1; i>=0; i--)
  fscHeads.append(tslHeads[i]);

// FIXED:
for (int i=0; i<tslHeads.length(); i++)
  fscHeads.append(tslHeads[i]);
```

---

**Issue 9: Geometry Not Updating After Property Change**

**Symptom:**
- Change Assembly Style but geometry doesn't update
- Components remain from previous style

**Cause:**
- Recalculation loop not triggered
- Execution loops set too low

**Solution:**
- Manually trigger recalc: `_HSB_Recalc` command on selected instance
- Check `setExecutionLoops(2)` calls in script

**Prevention:**
Ensure `_kNameLastChangedProp` triggers `setProperties()` and geometry rebuild.

---

**Issue 10: Duplicate Styles After Import**

**Symptom:**
- Style list shows duplicate names after import
- Instances refer to wrong style

**Cause:**
- Imported styles without overwrite flag
- Style name collision

**Solution:**
- Use "Overwrite existing styles" option during import
- Or rename conflicting styles before import
- Use Style Manager to merge/delete duplicates

---

## Performance Considerations

### Large Fastener Lists

**Symptom:**
- Slow dropdown population when Manufacturer = "Any"
- OPM delays when changing properties

**Optimization:**
- Use specific manufacturers instead of "Any"
- Fastener type caching (HSB-24011) reduces repeated queries
- Type list limited to first 6 unique types when using "Any"

**Code:**
```
if (types.length() == maxNum) // maxNum = 6
  break; // Stop querying after 6 types found
```

### Geometry Rendering

**Symptom:**
- Slow recalculation with many components
- Drag operations lag

**Optimization:**
- Script uses `realBody()` for accurate geometry
- Consider using `envelopeBody()` for simplified preview (commented out in script)
- Freeze components during repositioning to prevent mid-calculation rendering

**Code:**
```
// Freeze during stack operation
for (int i=0; i<comps.length(); i++)
  comps[i].setFrozen(true);

// Reposition...

// Thaw and recalc
for (int i=0; i<comps.length(); i++)
{
  comps[i].setFrozen(false);
  comps[i].recalc();
}
```

### Database Queries

**Symptom:**
- Slow component selection dialog
- Long wait for diameter filtering

**Optimization:**
- Diameter filtering done server-side (FastenerManager.dll)
- ComponentSelector state persists to avoid re-querying
- Consider pre-loading common components at project start

---

## Related Scripts and Ecosystem

### SimpleFastener

**Purpose:**
Creates basic single-component FastenerAssemblyDefinition styles directly from the database.

**Relationship to FastenerEditor:**
- SimpleFastener creates the **base styles** (main fastener only, no accessories)
- FastenerEditor **extends** those styles by adding head/closing components
- FastenerEditor can launch SimpleFastener via "Create Styles from Database" command

**Workflow:**
```
1. SimpleFastener → Create base "M12 Hex Bolt" style (bolt only)
2. FastenerEditor → Load "M12 Hex Bolt" style
3. FastenerEditor → Add washer, lock washer, nut
4. FastenerEditor → Save as "M12 Hex Bolt Assembly"
```

**Mode 98:**
When FastenerEditor launches SimpleFastener, it passes Mode 98 to indicate "style creation mode" rather than "entity placement mode."

---

### FastenerManager

**Purpose:**
External database management application for viewing, editing, and maintaining fastener/component catalogs.

**Access:**
- Right-click FastenerEditor → "Open Database Manager"
- Standalone executable: `[hsbCAD Install]\Utilities\FastenerManager\FastenerManager.exe`

**Features:**
- Browse all fasteners and components
- Edit manufacturer data
- Add custom components
- Import/export catalog data
- Verify database integrity

**Use Case:**
If required components are missing from dropdowns, use FastenerManager to inspect the database and add missing items.

---

### FastenerAssembly Entity (User-Facing)

**Purpose:**
The actual fastener placement entity used in production drawings (not covered in this FastenerEditor doc).

**Relationship:**
- FastenerAssembly **uses** FastenerAssemblyDefinition styles created by FastenerEditor
- FastenerEditor is the **style editor**, FastenerAssembly is the **entity placer**
- Updating a style in FastenerEditor automatically updates all FastenerAssembly entities using that style

**Workflow:**
```
1. FastenerEditor → Create/edit "M12 Bolt w/ Washers" style
2. Save style
3. FastenerAssembly → Select "M12 Bolt w/ Washers" from style dropdown
4. Place on timber connection
5. All instances update if style is modified in FastenerEditor
```

---

### Style Manager Integration

**Purpose:**
AutoCAD/hsbCAD built-in style management interface.

**Access:**
- Right-click FastenerEditor → "Show Style Manager"
- AutoCAD command: `_AecStyleManager`

**Features:**
- View all style definitions in drawing
- Copy styles between drawings (including open drawings)
- Purge unused styles
- Rename styles
- Set style descriptions

**Use Case:**
- Importing styles from open drawings (FastenerEditor import requires closed files)
- Bulk style operations
- Style cleanup and organization

---

### Graphics Ruleset (Advanced)

**Purpose:**
Customizes fastener rendering appearance (colors, line weights, detail levels).

**Access:**
Right-click FastenerEditor → "Load Graphical Ruleset"

**Command:**
Invokes `hsb_fa_importgraphicsruleset` command.

**Use Case:**
- Company-specific rendering standards
- Detail level control (schematic vs. realistic)
- Print/plot appearance customization

---

## Tips and Best Practices

### Naming Conventions

**Recommended Style Names:**
```
Good:
- "M12_HexBolt_Washer_LockWasher_Nut"
- "1/2_LagScrew_FlatWasher"
- "M16_AnchorBolt_PlateWasher_HexNut"

Bad:
- "Bolt1"
- "FastenerStyle_New"
- "Assembly"
```

**Why:**
- Descriptive names aid dropdown navigation
- Diameter prefix groups similar sizes
- Component sequence clarifies assembly

---

### Template Drawing Strategy

**Best Practice:**
Maintain a company template DWG with standardized fastener assemblies.

**Setup:**
1. Create new DWG: `CompanyStandard_Fasteners.dwg`
2. Insert FastenerEditor
3. Create all standard assemblies (M8, M10, M12, M16, etc.)
4. Save styles with consistent naming
5. Distribute template to project teams

**Usage:**
1. New project: Import styles from template
2. Customize as needed for project-specific requirements
3. Save project-specific styles back to template (periodic updates)

---

### Component Selection Efficiency

**Manufacturer Filtering:**
- Start with specific manufacturer for focused results
- Use "Any" only when searching broadly
- Switch to "Any" if preferred manufacturer lacks required component

**Type Filtering:**
- Know your component types (Washer vs. Lock Washer)
- Use database manager to learn component taxonomy
- Search feature is case-insensitive and searches all fields

---

### Assembly Reusability

**Maximize Style Reuse:**
- Create generic assemblies (M12 Bolt Assembly) rather than connection-specific ones
- Use descriptive names that indicate component count ("M12_Bolt_2Washers_Nut")
- Avoid over-specialization (e.g., "M12_Bolt_For_BeamToColumn" is too narrow)

**Project-Specific Styles:**
- Create project-specific assemblies only when required by specs
- Name with project prefix: "Proj123_M12_SpecialAssembly"
- Document deviations from standard in style description field (use Style Manager)

---

### Import vs. Create

**When to Import:**
- Starting new project based on previous work
- Adopting company standards
- Collaborating with teams using shared templates

**When to Create:**
- First-time setup of company standards
- Custom fastener specifications not in existing templates
- Experimenting with new assembly configurations

**Hybrid Approach:**
1. Import base styles from template
2. Customize for project
3. Save customized styles to project drawing
4. Periodically update template with proven customizations

---

### Visual Verification

**Always Check:**
1. Component stacking order (head to tail sequence)
2. Geometry accuracy (no overlapping or gaps)
3. Diameter compatibility (washers fit around bolt shaft)
4. Location correctness (nuts on closing end, washers on head)

**Use Drag Preview:**
- Grip-drag insertion point to see length annotations
- Verify available lengths match project requirements
- Check thread length indicator (dove blue) for bolt engagement

---

### Diameter Compatibility

**Before Adding Components:**
1. Note main fastener diameter (e.g., M12 = 12mm)
2. Verify component outer diameter accommodates bolt head (if head-side)
3. Check component inner diameter matches bolt shaft (12mm for M12)
4. If component missing from list, verify diameter range in database

**Washer Sizing:**
```
Example: M12 Bolt (12mm shaft)
- Washer inner diameter: 12mm (matches shaft)
- Washer outer diameter: 24mm (twice shaft, typical)
- Nut outer diameter: 18mm (hex, ~1.5x shaft)
```

---

### Save Workflow Optimization

**Efficient Saving:**
1. Build entire assembly before first save (avoid multiple saves)
2. Use descriptive name immediately (avoid "Assembly1" → rename later)
3. Overwrite existing styles deliberately (not accidentally)
4. Check "Edited" flag before closing drawing (unsaved work indicator)

**Batch Style Creation:**
1. Insert one FastenerEditor instance
2. Create and save first assembly
3. Change Assembly Style property to next base style
4. Add components for second assembly
5. Save second assembly
6. Repeat for all required assemblies
7. Delete FastenerEditor instance when done

---

### Error Recovery

**If Script Freezes:**
1. Press **Esc** to cancel operations
2. Use `_HSB_Recalc` command to force recalculation
3. Delete instance and re-insert if corrupted

**If Database Errors:**
1. Check database file exists: `[Install]\Utilities\FastenerManager\FastenerManager.dll`
2. Verify file not locked by another process
3. Test database with "Open Database Manager" command
4. Reinstall hsbCAD if database corrupted

**If Styles Disappear:**
1. Check Style Manager (styles may be present but not listed)
2. Verify manufacturer/type filters not hiding styles
3. Use `FastenerAssemblyDef().getAllEntryNames()` in script to list all styles
4. Reimport from backup/template if truly lost

---

## Version History and Changelog

| Version | Date | Issue ID | Changes |
|---------|------|----------|---------|
| **2.1** | 17.10.2025 | HSB-24011 | Fastener types are cached for performance. Graphics on drag improved with condensed length list display. |
| **2.0** | 15.10.2025 | HSB-24011 | When inserting without existing styles, user is automatically prompted to create styles from database via SimpleFastener. |
| **1.9** | 14.10.2025 | HSB-24419 | **CRITICAL FIX**: Sequence of head components fixed when saving the style. Components now save in correct stacking order. |
| **1.8** | 10.10.2025 | HSB-24043 | FastenerEditor style import improved. Condensed display of length list when dragging. File-open validation added. |
| **1.7** | 20.05.2025 | HSB-24054 | Type "Bolt" set as default when creating styles via SimpleFastener invocation. |
| **1.6** | 19.05.2025 | HSB-24054 | Location property automatically defaults to "Closing End" when using bolts with nuts (enforces logical placement). |
| **1.5** | 16.05.2025 | HSB-24043 | New command "Import Styles from Drawing" added. Browse and import styles from external DWG files with duplicate handling. |
| **1.4** | 15.05.2025 | HSB-24015 | Bugfix for component stacking. Supports executeKey to open database manager directly. |
| **1.3** | 15.05.2025 | HSB-23921 | Custom field `HeadHeightN` supported for manufacturer-specific head height data. |
| **1.2** | 14.05.2025 | HSB-24015 | Components persist within DWG. Component Map storage in child instances. |
| **1.1** | 12.05.2025 | HSB-24015 | Component stacking improved. RepositionOnStack() logic enhanced. |
| **1.0** | 25.04.2025 | HSB-23764 | Initial version of FastenerEditor. Core functionality: visual assembly editor, save styles, add/remove components. |

**Critical Upgrade Notes:**
- **Version 1.9+**: If using Version 1.8 or earlier, re-save all custom assemblies to fix component sequence (HSB-24419)
- **Version 2.0+**: Auto-prompt for style creation improves new user onboarding
- **Version 1.5+**: Import from drawing feature essential for template-based workflows

---

## Frequently Asked Questions

### General Usage

**Q: What's the difference between FastenerEditor and SimpleFastener?**

**A:**
- **SimpleFastener**: Creates basic single-component styles (main fastener only, no accessories)
- **FastenerEditor**: Extends SimpleFastener styles by adding head/closing components (washers, nuts, etc.)

Think of SimpleFastener as the "fastener catalog importer" and FastenerEditor as the "assembly builder."

---

**Q: Can I use FastenerEditor without SimpleFastener?**

**A:** Technically yes, if you already have FastenerAssemblyDefinition styles (imported from another drawing). However, SimpleFastener is the easiest way to create initial base styles from the database. FastenerEditor will auto-prompt to launch SimpleFastener if no styles exist.

---

**Q: Why are there no Assembly Styles in the dropdown when I insert FastenerEditor?**

**A:** No FastenerAssemblyDefinition styles exist in your drawing.

**Solutions:**
1. Allow the auto-prompt to launch SimpleFastener (Version 2.0+)
2. Right-click → "Create Styles from Database"
3. Right-click → "Import Styles from Drawing" from a template

---

**Q: Can I edit styles from other drawings without importing them?**

**A:** No, you must first import the styles using "Import Styles from Drawing" (for closed files) or Style Manager (for open files). FastenerEditor only operates on styles in the current drawing database.

---

### Component Management

**Q: Why can I only add components to the head side?**

**A:** Your main fastener type is **Screw**. Screws only support head-side components because they don't have a separate threaded end section like bolts.

**Solution:** Change the Assembly Style to a **Bolt** or **Threaded Rod** type to enable closing-end components.

---

**Q: How do I delete a component from the assembly?**

**A:** Select the component instance (child entity) and press **Delete** or use the AutoCAD **ERASE** command. The main assembly will update automatically. The assembly will be marked as "Edited" (dark yellow).

---

**Q: Why is the Location property locked to "Closing Component" for my nut?**

**A:** This is intentional design (HSB-24054). **Nuts on bolts** automatically default to Closing Component (threaded end) and cannot be changed. This prevents illogical configurations where nuts appear on the bolt head.

---

**Q: The component I need is not in the dropdown list. What should I do?**

**A:** The component list is filtered by diameter compatibility and manufacturer.

**Troubleshooting:**
1. Check that your component's diameter range includes the main fastener diameter
2. Try changing Manufacturer to "Any" to see all manufacturers
3. Use "Open Database Manager" to verify the component exists in the database
4. Check component Type (Washer vs. Lock Washer vs. Square Washer)

**Technical:** A component appears in the list only if:
```
componentMinDiameter <= mainFastenerDiameter <= componentMaxDiameter
```

---

**Q: Can I use the same component on both ends?**

**A:** Yes, when adding a component from the main assembly (Mode 0), select **"Head+Closing Component"** as the location. This places the same component type on both the head side and the closing (threaded) end.

**Note:** This option is only available when adding from the main instance, not when modifying child components.

---

### Saving and Styles

**Q: How do I update an existing style with my changes?**

**A:** Use the "Save" command from the context menu and enter the **same name** as the existing style. You will be prompted to confirm the overwrite.

**Result:**
- Existing style definition is updated
- All FastenerAssembly entities using that style are automatically recalculated
- All FastenerEditor instances showing that style are updated

---

**Q: Why does my assembly always show in dark yellow (Edited state)?**

**A:** The assembly differs from the saved style definition.

**Causes:**
- You added/removed/changed a component but haven't saved
- Component order differs from saved style (rare, see Version 1.9 fix)
- CompareKey mismatch (corrupted data)

**Solution:**
1. Save the assembly to update the style
2. Or reload the style by changing Assembly Style property away and back
3. If issue persists, delete all components, save, and re-add components

---

**Q: Can I rename a saved style?**

**A:** Not directly within FastenerEditor. Use the **AutoCAD Style Manager** (`_AecStyleManager`) to rename style definitions.

**Workflow:**
1. Right-click FastenerEditor → "Show Style Manager"
2. Navigate to FastenerAssemblyDefinition section
3. Right-click style → Rename
4. Update FastenerEditor instance to use new name

---

**Q: What happens to existing FastenerAssembly entities when I update a style?**

**A:** They automatically recalculate to reflect the new style definition. This is a powerful feature for updating all connections in a project by modifying one style.

**Example:**
- 50 FastenerAssembly entities use "M12_Bolt_Washer_Nut" style
- You edit the style in FastenerEditor to add a lock washer
- Save the style
- All 50 entities update to include the lock washer

---

### Importing

**Q: Import from Drawing fails with "File must be closed" error. What do I do?**

**A:** The target DWG file is currently open in AutoCAD.

**Solutions:**
1. Close the target DWG file and retry
2. **Recommended:** Use **AutoCAD Style Manager** instead, which can import from open files

**Why:** TSL cannot read from file-locked DWG databases. Style Manager uses a different API with open-file support.

---

**Q: Should I overwrite duplicate styles during import?**

**A:** Depends on your goal.

**Overwrite if:**
- Importing updated versions of company standards
- Fixing errors in current styles
- Synchronizing with a master template

**Don't overwrite if:**
- Current styles contain project-specific customizations
- Unsure of changes in imported styles
- Want to compare styles side-by-side first

**Recommendation:** If unsure, **don't overwrite**. Import without overwrite, then use Style Manager to compare and manually merge.

---

**Q: How do I import only specific styles from a drawing with hundreds of styles?**

**A:** The import dialog provides a **multi-select list** of all styles in the target drawing.

**Workflow:**
1. Right-click → "Import Styles from Drawing"
2. Browse to target DWG
3. In the style selection dialog, check only the styles you want
4. Use "Select All" button to select all, then uncheck unwanted styles
5. Confirm import

---

### Database and Performance

**Q: The database manager won't open. What's wrong?**

**A:**

**Causes:**
- FastenerManager.dll missing from installation
- File path incorrect
- DLL corrupted or incompatible version

**Solution:**
1. Verify file exists: `[hsbCAD Install]\Utilities\FastenerManager\FastenerManager.dll`
2. Check hsbCAD installation integrity
3. Reinstall hsbCAD if necessary
4. Contact hsbCAD support if issue persists

---

**Q: Property dropdowns are very slow when Manufacturer = "Any". How can I speed this up?**

**A:** Use a specific manufacturer instead of "Any".

**Why:** "Any" queries the entire database (potentially thousands of fasteners/components). Specific manufacturers query a focused subset.

**Optimization (Version 2.1):**
- Fastener types are now cached to reduce repeated queries
- Type list limited to first 6 unique types when using "Any"

---

**Q: Can I add custom fasteners/components to the database?**

**A:** Yes, use the **FastenerManager** application.

**Access:**
Right-click FastenerEditor → "Open Database Manager"

**Features:**
- Add custom manufacturers
- Add custom fastener models
- Add custom components
- Define diameter ranges, stack thicknesses, article numbers
- Import/export catalog data

**Note:** This is an advanced feature. Consult hsbCAD documentation or support for database editing procedures.

---

### Troubleshooting

**Q: Components are stacking in the wrong order. How do I fix this?**

**A:**

**If using Version 1.8 or earlier:**
- Upgrade to Version 1.9+ (HSB-24419 fixed component sequence bug)
- Delete all components
- Re-add components in the correct order
- Save the style

**If using Version 1.9+:**
- Components stack in the order they were added
- Delete and re-add components in desired sequence
- Or manually reorder by copying components in desired sequence

**Technical:** Component sequence is preserved during save. The order you see in the stack is the order saved in the style.

---

**Q: Geometry doesn't update after changing properties. What should I do?**

**A:**

**Solutions:**
1. Manually trigger recalculation: Select instance → `_HSB_Recalc` command
2. Grip-drag the insertion point slightly and return to original position (forces recalc)
3. Delete and re-insert the instance if issue persists

**Prevention:**
Ensure execution loops are set correctly (`setExecutionLoops(2)` in script).

---

**Q: I deleted a component but it still appears. Why?**

**A:**

**Causes:**
- Component child not properly erased (orphaned entity)
- Parent instance not recalculated after deletion
- Execution loop issue

**Solution:**
1. Select main FastenerEditor instance
2. Run `_HSB_Recalc` command
3. If component still appears, use AutoCAD ERASE on the component entity directly
4. Force main instance recalc again

---

**Q: Error: "Could not find file: FastenerManager.dll". What's wrong?**

**A:** The FastenerManager database is missing from your hsbCAD installation.

**Solution:**
1. Verify hsbCAD installation directory via `_kPathHsbInstall`
2. Check that file exists: `[Install]\Utilities\FastenerManager\FastenerManager.dll`
3. If missing, reinstall hsbCAD or copy the DLL from another valid installation
4. Ensure installation path is correct (no custom installation directory issues)

---

**Q: Can I undo changes to an assembly?**

**A:** Yes, use standard AutoCAD **UNDO** command.

**What can be undone:**
- Adding components (creates child entities → undo deletes them)
- Deleting components (erases child entities → undo restores them)
- Changing properties (property changes → undo reverts)

**What cannot be undone:**
- Saving styles (style database changes are permanent until next save/overwrite)

**Best Practice:**
Save assembly styles only when satisfied with the configuration. Use multiple test assemblies to experiment before overwriting production styles.

---

## Summary and Recommended Workflow

### Typical Project Workflow

**Phase 1: Setup (Project Start)**
1. Insert FastenerEditor in a clean drawing
2. Import base styles from company template (if available)
   - Right-click → "Import Styles from Drawing"
3. Or create initial styles from database
   - Allow auto-prompt to launch SimpleFastener
   - Or Right-click → "Create Styles from Database"

**Phase 2: Customization (Assembly Creation)**
1. Select a base assembly style (e.g., "M12 Hex Bolt")
2. Add required components:
   - Right-click → "Add Component" → Select washer
   - Right-click → "Add Component" → Select lock washer
   - Right-click → "Add Component" → Select nut (Location: Closing Component)
3. Verify visual stack order and geometry
4. Save with descriptive name: "M12_HexBolt_Washer_LockWasher_Nut"

**Phase 3: Production (Assembly Placement)**
1. Use FastenerAssembly entity to place assemblies in drawings
2. Select custom assembly styles from dropdown
3. Apply to timber connections

**Phase 4: Updates (Style Maintenance)**
1. Open FastenerEditor in project drawing
2. Load existing assembly style
3. Modify components (add/remove/change)
4. Save to update style
5. All placed FastenerAssembly entities update automatically

**Phase 5: Archival (Template Update)**
1. Export proven assemblies to company template
   - Save project DWG as template
   - Or use Style Manager to copy styles to template DWG
2. Distribute updated template to team

---

### Key Takeaways

1. **FastenerEditor is a style editor**, not an entity placer
2. **Visual preview** allows verification before saving
3. **Component stacking** is automatic based on Location and StackThickness
4. **Diameter filtering** ensures only compatible components appear
5. **Save triggers updates** to all instances using the style
6. **Import from templates** accelerates project setup
7. **Database manager** provides access to raw catalog data

---

### Related Commands

| Command | Purpose |
|---------|---------|
| `hsb_ScriptInsert "FastenerEditor"` | Insert FastenerEditor instance |
| `_HSB_Recalc` | Force recalculation of selected instance |
| `_AecStyleManager` | Open AutoCAD Style Manager |
| `hsb_fa_importgraphicsruleset` | Import fastener graphics ruleset |
| FastenerManager.exe | Open database manager (via context menu) |

---

## Conclusion

The **FastenerEditor** is a powerful tool for creating and managing fastener assembly styles in hsbCAD. By providing a visual, interactive interface for composing complex assemblies, it streamlines the definition of standardized hardware configurations for timber construction projects.

**Core Benefits:**
- **Visual Assembly**: See exactly how components stack before saving
- **Reusable Styles**: Define once, use throughout the project
- **Template Integration**: Import proven assemblies from company standards
- **Automatic Updates**: Change a style, update all instances
- **Database Access**: Full catalog of fasteners and components

**Best Practices:**
- Maintain a company template with standard assemblies
- Use descriptive naming conventions
- Verify diameter compatibility before adding components
- Save frequently to preserve work
- Import from templates to accelerate setup

**For Support:**
Consult the hsbCAD documentation, use the database manager for catalog verification, and contact hsbCAD support for database-related issues.

---

**End of FastenerEditor Documentation**
