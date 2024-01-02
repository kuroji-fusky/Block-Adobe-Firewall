#Requires -RunAsAdministrator

# Get the hosts URL from https://github.com/Ruddernation-Designs/Adobe-URL-Block-List
$AdobeIPBlocklist = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Ruddernation-Designs/Adobe-URL-Block-List/master/hosts"

$AdobeIPBlocklist.Content

# Probably need a fix when someone has a different install location
$installRoot = $env:ProgramFiles

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
  Write-Host "Blocked $($program.Key) from location: $installRoot/$($program.Value)"
}