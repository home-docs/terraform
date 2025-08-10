# PowerShell script to convert system-terraform.md into .copilot.json
# and place it at the repo root.

$MasterFile = ".directives\system-terraform.md"
$OutputFile = ".copilot.json"

if (-Not (Test-Path $MasterFile)) {
    Write-Error "Master file $MasterFile not found!"
    exit 1
}

# Extract bullet points (lines starting with "- ") and join into one string
$Prompt = -join (
    Get-Content $MasterFile |
        Where-Object { $_ -match "^- " } |
        ForEach-Object { $_ -replace "^- ", "" } |
        ForEach-Object { $_.Trim() }
)

# Create the JSON content
$JsonContent = @{
    prompt = $Prompt
} | ConvertTo-Json -Compress

# Write to .copilot.json in repo root
Set-Content -Path $OutputFile -Value $JsonContent -Encoding UTF8

Write-Host ".copilot.json updated from $MasterFile" -ForegroundColor Green
