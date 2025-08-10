# PowerShell helper for running Gemini CLI with Terraform directives

$MasterFile = ".directives\system-terraform.md"

if (-Not (Test-Path $MasterFile)) {
    Write-Error "Master file $MasterFile not found!"
    exit 1
}

# Read the system prompt from the file
$SystemPrompt = Get-Content $MasterFile -Raw

if (-Not $args) {
    Write-Host "Usage: .\.directives\gemini-terraform.ps1 \"Your prompt here\"" -ForegroundColor Yellow
    exit 1
}

# Join all passed arguments into a single user prompt
$UserPrompt = $args -join " "

# Run Gemini CLI with the system prompt and user prompt
gemini chat --system "$SystemPrompt" "$UserPrompt"
