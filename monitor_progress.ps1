# TSL Documentation Generation Progress Monitor
# Usage: .\monitor_progress.ps1

$projectPath = "C:\Users\ZhengqiaoSun\Desktop\Neuer Ordner\kb\TSL"
$checkpointPath = Join-Path $projectPath "output\checkpoint.json"
$docsPath = Join-Path $projectPath "output\docs"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "TSL Documentation Generation Monitor" -ForegroundColor Cyan
Write-Host "Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check checkpoint status
if (Test-Path $checkpointPath) {
    $checkpoint = Get-Content $checkpointPath | ConvertFrom-Json
    $completed = $checkpoint.completed_scripts.Count
    $failed = $checkpoint.failed_scripts.Count
    $tokens = $checkpoint.total_tokens_used

    Write-Host "Checkpoint Status:" -ForegroundColor Yellow
    Write-Host "  Completed: $completed scripts" -ForegroundColor Green
    Write-Host "  Failed: $failed scripts" -ForegroundColor Red
    Write-Host "  Total tokens: $tokens" -ForegroundColor Gray

    if ($failed -gt 0) {
        Write-Host "  Failed scripts:" -ForegroundColor Red
        foreach ($script in $checkpoint.failed_scripts) {
            Write-Host "    - $script" -ForegroundColor Red
        }
    }
} else {
    Write-Host "Checkpoint file not found!" -ForegroundColor Red
}

Write-Host ""

# Check generated docs count
if (Test-Path $docsPath) {
    $docCount = (Get-ChildItem -Path $docsPath -Filter "*.md" | Measure-Object).Count
    $remaining = 1216 - $completed
    $progress = [math]::Round(($completed / 1216) * 100, 2)

    Write-Host "Documentation Files:" -ForegroundColor Yellow
    Write-Host "  Generated: $docCount .md files" -ForegroundColor Green
    Write-Host "  Remaining: $remaining scripts" -ForegroundColor Cyan
    Write-Host "  Progress: $progress%" -ForegroundColor Cyan

    # Progress bar
    $barLength = 50
    $filledLength = [math]::Floor(($completed / 1216) * $barLength)
    $bar = "[" + ("=" * $filledLength) + (" " * ($barLength - $filledLength)) + "]"
    Write-Host "  $bar" -ForegroundColor Green
} else {
    Write-Host "Docs directory not found!" -ForegroundColor Red
}

Write-Host ""

# Check background agent status
Write-Host "Background Agent Status:" -ForegroundColor Yellow
$agents = @(
    @{ID="b719a64"; Name="Agent 1 (Base/Core)"},
    @{ID="b993b1f"; Name="Agent 2 (Base/Function)"},
    @{ID="b7cc382"; Name="Agent 3 (CLT+SIP)"},
    @{ID="b56f98b"; Name="Agent 4 (Workflow+Other)"},
    @{ID="b614390"; Name="Agent 5 (Hardware)"},
    @{ID="b3f8465"; Name="Agent 6 (Manufacturing+MEP)"}
)

foreach ($agent in $agents) {
    $outputFile = "C:\Users\ZHENGQ~1\AppData\Local\Temp\claude\C--Users-ZhengqiaoSun-Desktop-Neuer-Ordner-kb-TSL\tasks\$($agent.ID).output"
    if (Test-Path $outputFile) {
        $lastLines = Get-Content $outputFile -Tail 3 -ErrorAction SilentlyContinue
        Write-Host "  $($agent.Name) [$($agent.ID)]:" -ForegroundColor Cyan
        if ($lastLines) {
            foreach ($line in $lastLines) {
                Write-Host "    $line" -ForegroundColor Gray
            }
        } else {
            Write-Host "    (No output yet)" -ForegroundColor Gray
        }
    } else {
        Write-Host "  $($agent.Name) [$($agent.ID)]: Output file not found" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "To run status check: python tsl_doc_generator/main.py --status" -ForegroundColor Gray
Write-Host "========================================" -ForegroundColor Cyan
