#Requires -RunAsAdministrator

param (
  [Parameter(Mandatory = $true)][string]$BaseInstallPath = $env:ProgramFiles,
  [Parameter(Mandatory = $true)][ValidateSet("All", "Firewall", "Rules")][string]$Reset
)

$ProgramPaths = @{
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

  # AE
  "After Effects 2022" = "Adobe After Effects 2022\Support Files\AfterFX.exe";
  "After Effects 2023" = "Adobe After Effects 2023\Support Files\AfterFX.exe";
  "After Effects 2024" = "Adobe After Effects 2024\Support Files\AfterFX.exe";

  # Media Encoder
  "Media Encoder 2022" = "Adobe Media Encoder 2022\Adobe Media Encoder.exe";
  "Media Encoder 2023" = "Adobe Media Encoder 2023\Adobe Media Encoder.exe";
  "Media Encoder 2024" = "Adobe Media Encoder 2024\Adobe Media Encoder.exe";
}

foreach ($program in $ProgramPaths.GetEnumerator()) {
  $programName = $program.Key
  $programDir = "$($BaseInstallPath)\Adobe\$($program.Value)"

  # Verify if $programDir is valid and it exists; by default this should automatically pass if "$env:ProgramFiles" is set to default
  if (!(Test-Path $programDir)) {
    exit 1
  }

  $fwDisplayName = "Block connections from $programName"

  # Skip if the Firewall rule is already created and to prevent any dups
  if (!$(Get-NetFirewallRule -DisplayName $fwDisplayName -Direction Inbound)) {
    New-NetFirewallRule -DisplayName $fwDisplayName -Direction Inbound -Action Block -Program $programDir
  }
  Write-Host "Inbound firewall rule: `"$fwDisplayName`" already added!"
  
  if (!$(Get-NetFirewallRule -DisplayName $fwDisplayName -Direction Outbound)) {
    New-NetFirewallRule -DisplayName $fwDisplayName -Direction Outbound -Action Block -Program $programDir
  }
  Write-Host "Outbound firewall rule: `"$fwDisplayName`" already added!"
}

# Get the hosts URL from https://github.com/Ruddernation-Designs/Adobe-URL-Block-List
$BlockListRepository = "Ruddernation-Designs/Adobe-URL-Block-List"

$IPBlockListUrl = "https://raw.githubusercontent.com/$($BlockListRepository)/master/hosts"
$AdobeIPBlocklist = $(Invoke-WebRequest -Uri $IPBlockListUrl).Content -split "[`r`n]"

$hostsFile = "$env:windir\System32\drivers\etc\hosts"

Add-Content -Path $hostsFile -Value "`n# Block known Adobe hosts"
Add-Content -Path $hostsFile -Value "# From: https://github.com/$($BlockListRepository)`n"

foreach ($line in $AdobeIPBlocklist) {
  if ($line.StartsWith('0.0.0.0')) {
    Add-Content -Path $hostsFile -Value $line -Force
  }
}
