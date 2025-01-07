# repositories-check.ps1

# Add configuration file support
$configPath = Join-Path $PSScriptRoot "config.json"

# Default configuration
$defaultConfig = @{
    work = @{
        email = "work@email.com"
        name = "username"
        gitHost = "github.com"
        sshConfig = "github.com"
    }
    personal = @{
        email = "your.personal@email.com"
        name = "Your Personal Name"
        gitHost = "github.com"
        sshConfig = "github.com-personal"
    }
    defaultPath = ""
}

# Load or create configuration
function Load-Configuration {
    if (Test-Path $configPath) {
        try {
            $config = Get-Content $configPath | ConvertFrom-Json -AsHashtable
            return $config
        }
        catch {
            Write-Warning "Error loading configuration file. Using defaults."
            return $defaultConfig
        }
    }
    else {
        $defaultConfig | ConvertTo-Json | Set-Content $configPath
        return $defaultConfig
    }
}

# Function to validate Git installation
function Test-GitInstallation {
    try {
        $gitVersion = git --version
        return $true
    }
    catch {
        Write-Error "Git is not installed or not in PATH"
        return $false
    }
}

# Improved Check-GitRemotes function
function Check-GitRemotes {
    param (
        [string]$path,
        [hashtable]$config
    )
    
    Write-Host "`n----------------------------------------"
    Write-Host "Checking repository: $path" -ForegroundColor Green
    
    # Verify it's a git repository
    if (-not (Test-Path (Join-Path $path ".git"))) {
        Write-Warning "Not a git repository: $path"
        return
    }
    
    try {
        # Change to repository directory
        Push-Location $path -ErrorAction Stop
        
        # Get remote information
        $remotes = git remote -v
        Write-Host "`nCurrent remotes:"
        $remotes | ForEach-Object { Write-Host $_ }
        
        # Get git config
        $email = git config user.email
        $name = git config user.name
        Write-Host "`nCurrent git config:"
        Write-Host "Email: $email"
        Write-Host "Name: $name"
        
        # Ask if update is needed
        $update = Read-Host "`nDo you want to update this repository? (y/n)"
        if ($update -eq 'y') {
            Update-Repository -config $config
        }
    }
    catch {
        Write-Error "Error processing repository: $_"
    }
    finally {
        Pop-Location
        Write-Host "----------------------------------------"
    }
}

# New function to handle repository updates
function Update-Repository {
    param (
        [hashtable]$config
    )
    
    do {
        $accountType = Read-Host "Which account should this use? (work/personal)"
    } while ($accountType -notin @('work', 'personal'))
    
    try {
        if ($accountType -eq 'work') {
            $newRemote = Read-Host "Enter work repository URL (format: username/repo)"
            git remote set-url origin "git@$($config.work.sshConfig):$newRemote.git"
            git config user.email $config.work.email
            git config user.name $config.work.name
        }
        else {
            $newRemote = Read-Host "Enter personal repository URL (format: username/repo)"
            git remote set-url origin "git@$($config.personal.sshConfig):$newRemote.git"
            git config user.email $config.personal.email
            git config user.name $config.personal.name
        }
        
        Write-Host "`nUpdated remotes:"
        git remote -v
    }
    catch {
        Write-Error "Failed to update repository: $_"
    }
}

# Main script
if (-not (Test-GitInstallation)) {
    exit 1
}

$config = Load-Configuration

# Ask for repositories root directory
$reposPath = if ($config.defaultPath -and (Test-Path $config.defaultPath)) {
    $userPath = Read-Host "Enter the path to your repositories directory (press Enter to use default: $($config.defaultPath))"
    if ([string]::IsNullOrWhiteSpace($userPath)) { $config.defaultPath } else { $userPath }
} else {
    Read-Host "Enter the path to your repositories directory"
}

if (-not (Test-Path $reposPath)) {
    Write-Error "Invalid path: $reposPath"
    exit 1
}

# Get all git repositories
$gitRepos = Get-ChildItem -Path $reposPath -Recurse -Directory -Force |
    Where-Object { $_.Name -eq ".git" } |
    ForEach-Object { $_.Parent.FullName }

if (-not $gitRepos) {
    Write-Warning "No Git repositories found in $reposPath"
    exit 0
}

# Check each repository
foreach ($repo in $gitRepos) {
    Check-GitRemotes -path $repo -config $config
}

Write-Host "`nAll repositories have been checked!"
