param (
  [string]$BaseInstallPath = $env:ProgramFiles,

  [Parameter(ParameterSetName = "Reset")]
  [ValidateSet("All", "Firewall", "Rules")]
  [string]$ResetFlag
)

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrator")) {
  Write-Error "Please re-run this script as administrator for this to work."
  Write-Error "`nAdding firewall rules requires elevated privilages."
  exit 1
}

# TODO: add a check for scanned exe's
$ProgramPaths = @{
  "Acrobat DC"         = "Acrobat DC\Acrobat.exe";
  "Acrobat Reader DC"  = "Acrobat Reader DC\Reader\AcroRd32.exe";

  # Photoshop
  "Photoshop 2022"     = "Adobe Photoshop 2022\Photoshop.exe";
  "Photoshop 2023"     = "Adobe Photoshop 2023\Photoshop.exe";
  "Photoshop 2024"     = "Adobe Photoshop 2024\Photoshop.exe";
  
  # Premiere Pro
  "Premiere Pro 2022"  = "Adobe Premiere Pro 2022\Adobe Premiere Pro.exe";
  "Premiere Pro 2023"  = "Adobe Premiere Pro 2023\Adobe Premiere Pro.exe";
  "Premiere Pro 2024"  = "Adobe Premiere Pro 2024\Adobe Premiere Pro.exe";

  # Illustrator
  "Illustrator 2022"   = "Adobe Illustrator 2022\Support Files\Contents\Windows\Illustrator.exe";
  "Illustrator 2023"   = "Adobe Illustrator 2023\Support Files\Contents\Windows\Illustrator.exe";
  "Illustrator 2024"   = "Adobe Illustrator 2024\Support Files\Contents\Windows\Illustrator.exe";
  "Illustrator 2025"   = "Adobe Illustrator 2025\Support Files\Contents\Windows\Illustrator.exe";

  # AE
  "After Effects 2022" = "Adobe After Effects 2022\Support Files\AfterFX.exe";
  "After Effects 2023" = "Adobe After Effects 2023\Support Files\AfterFX.exe";
  "After Effects 2024" = "Adobe After Effects 2024\Support Files\AfterFX.exe";
  "After Effects 2025" = "Adobe After Effects 2025\Support Files\AfterFX.exe";

  # Media Encoder
  "Media Encoder 2022" = "Adobe Media Encoder 2022\Adobe Media Encoder.exe";
  "Media Encoder 2023" = "Adobe Media Encoder 2023\Adobe Media Encoder.exe";
  "Media Encoder 2024" = "Adobe Media Encoder 2024\Adobe Media Encoder.exe";
  "Media Encoder 2025" = "Adobe Media Encoder 2025\Adobe Media Encoder.exe";
}

if (!(Test-Path -Path $BaseInstallPath)) {
  Write-Error "It looks like the base directory doesn't exist.`n"
  Write-Error "Did you double check the base Adobe path? If you installed it from a different directory or drive, you can overwrite the path with -BaseInstallPath."
  exit 1
}

foreach ($program in $ProgramPaths.GetEnumerator()) {
  $programName = $program.Key
  $programDir = Join-Path $($BaseInstallPath) "Adobe\$($program.Value)"

  # Verify if $programDir is valid and it exists; by default this should automatically pass if "$env:ProgramFiles" is set to default
  if (!(Test-Path $programDir)) {
    continue
  }

  $fwDisplayName = "Block connections from $programName"

  # Skip if the Firewall rule is already created and to prevent any dups
  if (!(Get-NetFirewallRule -DisplayName $fwDisplayName -Direction Inbound)) {
    New-NetFirewallRule -DisplayName $fwDisplayName -Direction Inbound -Action Block -Program $programDir -Profile Any
    Write-Host "Inbound firewall rule: `"$fwDisplayName`" added"
  }
  
  if (!(Get-NetFirewallRule -DisplayName $fwDisplayName -Direction Outbound)) {
    New-NetFirewallRule -DisplayName $fwDisplayName -Direction Outbound -Action Block -Program $programDir -Profile Any
    Write-Host "Outbound firewall rule: `"$fwDisplayName`" added"
  }
}

<# Get the hosts URL from https://github.com/Ruddernation-Designs/Adobe-URL-Block-List #>
$BlockListRepository = "Ruddernation-Designs/Adobe-URL-Block-List"

$IPBlockListUrl = "https://raw.githubusercontent.com/$($BlockListRepository)/master/hosts"
$hostsFile = "$env:windir\System32\drivers\etc\hosts"

try {
  $AdobeIPBlocklist = (Invoke-WebRequest -Uri $IPBlockListUrl).Content -split "[`r`n]"

  Add-Content -Path $hostsFile -Value "`n# Block known Adobe hosts"
  Add-Content -Path $hostsFile -Value "# From: https://github.com/$BlockListRepository`n"
  
  foreach ($line in $AdobeIPBlocklist) {
    if ($line -match "^0\.0\.0\.0\s+\S+") {
      if ($existingHostsContent -notcontains $line) {
        Add-Content -Path $hostsFile -Value $line
      }
    }
  }
}
catch {
  Write-Error "Failed to fetch contents: $_"
  exit 1
}
