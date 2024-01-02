#Requires -RunAsAdministrator

# Probably need a fix when someone has a different install location
$ProgramPaths = @{
  "Premiere Pro 2022"  = "Adobe Premiere Pro 2022\Adobe Premiere Pro.exe";
  "Premiere Pro 2023"  = "Adobe Premiere Pro 2023\Adobe Premiere Pro.exe";
  "Premiere Pro 2024"  = "Adobe Premiere Pro 2024\Adobe Premiere Pro.exe";
  "Illustrator 2021"   = "Adobe Illustrator 2021\Support Files\Contents\Windows\Illustrator.exe";
  "Illustrator 2022"   = "Adobe Illustrator 2022\Support Files\Contents\Windows\Illustrator.exe";
  "Illustrator 2023"   = "Adobe Illustrator 2023\Support Files\Contents\Windows\Illustrator.exe";
  "Illustrator 2024"   = "Adobe Illustrator 2024\Support Files\Contents\Windows\Illustrator.exe";
  "After Effects 2022" = "Adobe After Effects 2022\Support Files\AfterFX.exe";
  "After Effects 2023" = "Adobe After Effects 2023\Support Files\AfterFX.exe";
  "After Effects 2024" = "Adobe After Effects 2024\Support Files\AfterFX.exe";
  "Media Encoder 2022" = "Adobe Media Encoder 2022\Adobe Media Encoder.exe";
  "Media Encoder 2023" = "Adobe Media Encoder 2023\Adobe Media Encoder.exe";
  "Media Encoder 2024" = "Adobe Media Encoder 2024\Adobe Media Encoder.exe";
  "Photoshop 2022"     = "Adobe Photoshop 2022\Photoshop.exe";
  "Photoshop 2023"     = "Adobe Photoshop 2023\Photoshop.exe";
  "Photoshop 2024"     = "Adobe Photoshop 2024\Photoshop.exe";
}

foreach ($program in $ProgramPaths.GetEnumerator()) {
  $programName = $program.Key
  $programDir = "$($env:ProgramFiles)\$($program.Value)"

  New-NetFirewallRule -DisplayName "Block $programName Connection" -Direction Inbound -Action Block -Program $programDir
  New-NetFirewallRule -DisplayName "Block $programName Connection" -Direction Outbound -Action Block -Program $programDir

  Write-Host "Blocked $programName from location: $programDir"
}

# Get the hosts URL from https://github.com/Ruddernation-Designs/Adobe-URL-Block-List
$IPBlockListUrl = "https://raw.githubusercontent.com/Ruddernation-Designs/Adobe-URL-Block-List/master/hosts"
$AdobeIPBlocklist = $(Invoke-WebRequest -Uri $IPBlockListUrl).Content -split "[`r`n]"

$hostFile = "$env:windir\System32\drivers\etc\hosts"

Add-Content -Path $hostFile -Value "`n# Block known Adobe hosts"
Add-Content -Path $hostFile -Value "# From: https://github.com/Ruddernation-Designs/Adobe-URL-Block-List`n"

foreach ($line in $AdobeIPBlocklist) {
  if ($line.StartsWith('127.0.0.1')) {
    Add-Content -Path $hostFile -Value $line -Force
  }
}