"""
6-Pass Prompt Templates for TSL Script Analysis

Each pass builds upon previous results for progressive refinement.
"""

# System prompt for all passes
SYSTEM_PROMPT = """You are an expert analyzer of TSL (Timber Script Language) scripts for hsbCAD.
TSL is a C-based scripting language for timber construction CAD systems.

Key TSL concepts:
- PropDouble/PropInt/PropString: User-editable properties in AutoCAD Properties Palette (OPM)
- getPoint/getGenBeam/getString: Command line prompts for user input
- TslUtilities.dll dialogs: SelectFromList, SelectOption, GetText, AskYesNo, ShowDynamicDialog
- addRecalcTrigger: Right-click context menu items
- _bOnInsert: Flag true only during script insertion
- U(): Unit conversion function (critical for unit independence)
- Body/GenBeam/Element: Core geometric and construction entities

Always output valid JSON as specified in the user prompt."""


# ============================================================================
# PASS 1: Metadata Extraction
# ============================================================================
PASS1_PROMPT = """Analyze this TSL script and extract ONLY structural metadata from headers.
Do NOT infer or interpret - extract exactly what is written.

Script filename: {filename}

```
{code}
```

Extract and return JSON with this exact structure:
{{
  "header": {{
    "type": "<O/T/E/etc from #Type>",
    "numBeamsReq": <number from #NumBeamsReq>,
    "keywords": ["<from #KeyWords>"],
    "majorVersion": <number>,
    "minorVersion": <number>,
    "dxaOut": <0 or 1 if present>,
    "implInsert": <0 or 1 if present>
  }},
  "description": "<text from #BeginDescription block>",
  "versionHistory": [
    {{
      "version": "<version number>",
      "date": "<date>",
      "author": "<author>",
      "changes": "<description>"
    }}
  ],
  "settingsFiles": ["<any .xml files referenced>"],
  "dependencies": ["<any other .mcr scripts referenced>"]
}}

Return ONLY the JSON, no explanation."""


# ============================================================================
# PASS 2: Usage Environment Detection
# ============================================================================
PASS2_PROMPT = """Analyze this TSL script to determine its usage environment.

Script filename: {filename}
Pass 1 Results:
{pass1_results}

Code to analyze:
```
{code}
```

Determine:
1. Which AutoCAD space(s) the script operates in:
   - Model Space: 3D modeling (default, uses _kModelSpace)
   - Paper Space: 2D layouts (_Viewport, _kPaperSpace)
   - ShopDrawing: Fabrication drawings (sd_* prefix, #Type E + _Entity[])

2. Prerequisites for running the script

Detection patterns:
- sd_* or Multipage* prefix → Paper Space/ShopDrawing
- _Viewport.length() > 0 → Supports Paper Space
- #Type E with _Entity[] → ShopDrawing script
- No space detection → Likely Model Space only

Return JSON:
{{
  "usageEnvironment": {{
    "primarySpace": "<ModelSpace/PaperSpace/Both>",
    "supportsPaperSpace": <true/false>,
    "isShopDrawingScript": <true/false>,
    "isMultipageScript": <true/false>,
    "detectionEvidence": "<code patterns found>"
  }},
  "prerequisites": {{
    "requiredEntities": ["<GenBeam/Element/Sheet/etc>"],
    "minimumBeams": <number>,
    "requiredSpace": "<description>",
    "requiredSettings": ["<XML files that must exist>"]
  }}
}}

Return ONLY the JSON."""


# ============================================================================
# PASS 3: Complete UI Extraction
# ============================================================================
PASS3_PROMPT = """Extract ALL user interface elements from this TSL script.
This is the CORE pass for user documentation.

Script filename: {filename}
Previous results:
{previous_results}

Code to analyze:
```
{code}
```

Extract every UI element:

1. Command Line Interactions:
   - getPoint("prompt") - User clicks a point
   - getGenBeam("prompt") - User selects a beam
   - getString("prompt") - User types text
   - getInt("prompt") - User types integer
   - getReal("prompt") - User types number
   - getKword("[A/B/C]") - User chooses keyword
   - PLine.getByUser() - User draws polyline

2. Dialog Boxes (TslUtilities.dll):
   - SelectFromList - Searchable dropdown
   - SelectOption - Radio buttons
   - GetText - Text input
   - AskYesNo - Yes/No confirmation
   - ShowNotice - Message box
   - ShowDynamicDialog - Complex form

3. OPM Properties (Properties Palette):
   - PropDouble(index, default, "Name")
   - PropInt(index, default, "Name")
   - PropString(index, default, "Name")
   - PropString(index, options[], "Name") - Dropdown
   - Look for .setDescription() and .setCategory()

4. Context Menu (Right-Click):
   - addRecalcTrigger(_kContext, "Menu Item")
   - _kExecuteKey == "item" handlers
   - TslDoubleClick handlers

5. Settings XML Files:
   - Paths with _kPathHsbCompany, _kPathHsbInstall
   - .readFromXmlFile() calls

Return JSON:
{{
  "commandLine": {{
    "insertionFlow": [
      {{
        "step": <number>,
        "function": "<getPoint/getGenBeam/etc>",
        "promptOriginal": "<exact prompt string>",
        "condition": "<_bOnInsert/etc or null>",
        "required": <true/false>
      }}
    ],
    "keywordOptions": [
      {{
        "prompt": "<prompt text>",
        "options": ["<option1>", "<option2>"]
      }}
    ]
  }},
  "dialogs": [
    {{
      "type": "<SelectFromList/SelectOption/etc>",
      "trigger": "<when shown>",
      "title": "<dialog title if found>",
      "dataSource": "<where data comes from>",
      "features": {{
        "searchable": <true/false>,
        "multiSelect": <true/false>
      }}
    }}
  ],
  "opmProperties": [
    {{
      "index": <number>,
      "variable": "<variable name>",
      "type": "<PropDouble/PropInt/PropString>",
      "displayName": "<shown name>",
      "defaultValue": "<default>",
      "inputType": "<number/text/dropdown>",
      "options": ["<if dropdown>"],
      "category": "<category name or null>",
      "description": "<tooltip or null>"
    }}
  ],
  "contextMenu": [
    {{
      "menuItem": "<menu text>",
      "handler": "<_kExecuteKey value>",
      "action": "<what it does>",
      "alsoTriggeredBy": "<double-click if applicable>"
    }}
  ],
  "settingsFiles": [
    {{
      "filename": "<file.xml>",
      "searchPaths": ["<path1>", "<path2>"],
      "purpose": "<what data it provides>",
      "required": <true/false>
    }}
  ]
}}

Return ONLY the JSON."""


# ============================================================================
# PASS 4: Semantic Analysis
# ============================================================================
PASS4_PROMPT = """Analyze the BUSINESS MEANING of each parameter and UI element.

Script filename: {filename}
Previous results:
{previous_results}

Code snippets for context:
```
{code}
```

For each parameter identified in Pass 3, determine:
1. What it actually controls in timber construction terms
2. Reasonable value ranges for real-world use
3. How it affects the output (geometry, machining, etc.)
4. Dependencies on other parameters

Return JSON:
{{
  "scriptPurpose": {{
    "summary": "<1-2 sentence description in user terms>",
    "category": "<Hardware/Framing/ShopDrawing/etc>",
    "typicalUseCase": "<when a user would use this>"
  }},
  "parameters": [
    {{
      "name": "<variable name>",
      "technicalDefault": "<code default>",
      "businessMeaning": "<what it controls in plain language>",
      "validRange": "<practical range>",
      "unit": "<mm/degrees/count/etc>",
      "affectsOutput": "<what changes when this changes>"
    }}
  ],
  "parameterDependencies": [
    {{
      "trigger": "<when parameter X changes>",
      "effect": "<what happens to other parameters>",
      "cascade": ["<affected parameters>"]
    }}
  ],
  "outputEntities": [
    {{
      "type": "<MetalPart/Drill/Cut/etc>",
      "description": "<what gets created>",
      "appliedTo": "<which beams/elements>"
    }}
  ]
}}

Return ONLY the JSON."""


# ============================================================================
# PASS 5: Logic/Workflow Analysis
# ============================================================================
PASS5_PROMPT = """Map the complete user workflow and conditional branches.

Script filename: {filename}
Previous results:
{previous_results}

Code for flow analysis:
```
{code}
```

Analyze:
1. Step-by-step workflow from launch to completion
2. Conditional branches (1 beam vs 2 beams, etc.)
3. Error conditions and validation
4. Post-insertion modifications

Return JSON:
{{
  "workflowDiagram": [
    "<1. Step description>",
    "<2. Step description>",
    "<3. [Conditional] Branch description>"
  ],
  "conditionalBranches": [
    {{
      "condition": "<condition description>",
      "path1": {{
        "name": "<path name>",
        "steps": ["<step1>", "<step2>"]
      }},
      "path2": {{
        "name": "<path name>",
        "steps": ["<step1>", "<step2>"]
      }}
    }}
  ],
  "validationRules": [
    {{
      "check": "<what is validated>",
      "errorMessage": "<message shown>",
      "recovery": "<how user can fix>"
    }}
  ],
  "postInsertionActions": [
    {{
      "action": "<what user can do after insertion>",
      "how": "<OPM/context menu/grip edit>",
      "effect": "<what changes>"
    }}
  ]
}}

Return ONLY the JSON."""


# ============================================================================
# PASS 6: User Guide Generation
# ============================================================================
PASS6_PROMPT = """Generate user-friendly documentation in English Markdown.

Script filename: {filename}

Analysis results from passes 1-5:
{all_results}

Generate documentation following this template:

# [Script Name]

## Overview
Brief 1-2 sentence description of what this script does.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes/No | ... |
| Paper Space | Yes/No | ... |
| Shop Drawing | Yes/No | ... |

## Prerequisites
- Required entities
- Minimum beam count
- Required settings files

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `[script].mcr`

### Step 2: [First Prompt]
```
Command Line: [prompt text]
Action: [what user does]
```
(Continue for all steps)

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Name | dropdown/number/text | value | Description |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Item | What it does |

## Settings Files
- **Filename**: `name.xml`
- **Location**: Company or Install path
- **Purpose**: What data it provides

## Tips
- Practical tips for users

## FAQ
- Q: Common question?
- A: Answer

---

Requirements:
1. Write ENTIRELY in English
2. Focus on USER ACTIONS, not code internals
3. Be specific about AutoCAD commands and clicks
4. Include practical tips from the workflow analysis
5. Make it understandable for CAD operators without programming knowledge
6. Do NOT use Chinese characters anywhere

Return ONLY the Markdown documentation."""


def get_pass_prompt(pass_number: int) -> str:
    """Get the prompt template for a specific pass"""
    prompts = {
        1: PASS1_PROMPT,
        2: PASS2_PROMPT,
        3: PASS3_PROMPT,
        4: PASS4_PROMPT,
        5: PASS5_PROMPT,
        6: PASS6_PROMPT
    }
    return prompts.get(pass_number, "")


def format_prompt(pass_number: int, **kwargs) -> str:
    """Format a pass prompt with provided values"""
    template = get_pass_prompt(pass_number)
    return template.format(**kwargs)
