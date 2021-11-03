IF ( $PSScriptRoot ) { $ScriptRoot = $PSScriptRoot} ELSE { $ScriptRoot = Get-Location }
Write-Host "   INFO - `"`$ScriptRoot`" set to `"$ScriptRoot`""

IF ( -NOT ((Get-Command "cl.exe" -ErrorAction SilentlyContinue).Path) ) {
  Write-Host "WARNING - MSVC with `"cl.exe`", version 19 or newer, is a hard requirement to build NQP, Moar and Rakudo now, see"
  Write-Host "          https://github.com/rakudo/rakudo/commit/d01d4b26641bec2a62b43007b476f668982b9ab6#diff-a3c0a8904b9af2275c7ef3d4616ad9c3481898d3cc0e4698133948520b2df2ed"
  Write-Host "          https://github.com/Raku/nqp-configure/blob/e068508a94d643c1174bcd29e333dd659df502c5/lib/NQP/Config.pm#L252"
  
  IF ( -NOT ((Get-Command "Launch-VsDevShell.ps1" -ErrorAction SilentlyContinue).Path) ) {
    Write-Host "  ERROR - Couldn't neither find `"cl.exe`" nor `"Launch-VsDevShell.ps1`""
    Write-Host "  ERROR - Make sure `"Microsoft Visual C++ 2019`" or newer is installed and try again"
    EXIT
  } ELSE {
    Write-Host "   INFO - Executing `"Launch-VsDevShell.ps1`""
    & Launch-VsDevShell.ps1 2>&1 | Out-Null
  }
}

# "Launch-VsDevShell.ps1" seems to change the directory. Let's get back...
IF ( $ScriptRoot -ne (pwd).Path ) { cd $ScriptRoot }


IF ((( & cl /v 2>&1 | Select-String "^Microsoft .+ Compiler Version .+ for") -match "^Microsoft .+ Compiler Version (?<VERSION>\d{2}).+" ) -AND ( $Matches.VERSION -ge 19 )) {
  Write-Host "   INFO - `"cl.exe`" version", $Matches.VERSION, "or newer found, continue..."
} ELSE {
  Write-Host "  ERROR - `"cl.exe`" version 19 or newer expected, but only version", $Matches.VERSION, "found"
  Write-Host "  ERROR - Make sure `"Microsoft Visual C++ 2019`" or newer is installed and try again"
  EXIT
}

# Let's use choco to make sure all prerequisites are installed
# Check if choco is installed. If not, install it.
Write-Host "   INFO - Checking all prerequisites (choco, git, perl5, WiX toolset, gpg) and installing them, if required"
IF ( -NOT ((Get-Command "choco" -ErrorAction SilentlyContinue).Path) ) { iex (New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1') }
# Now install all prerequisites to build NQP, Moar and finally Rakudo
IF (  -NOT ((Get-Command  "git.exe" -ErrorAction SilentlyContinue).Path) ) { & choco install --yes --force --no-progress --limit-output --timeout 0 git }
IF (  -NOT ((Get-Command  "curl.exe" -ErrorAction SilentlyContinue).Path) ) { & choco install --yes --force --no-progress --limit-output --timeout 0 curl }
IF (  -NOT ((Get-Command "perl.exe" -ErrorAction SilentlyContinue).Path) ) { & choco install --yes --force --no-progress --limit-output --timeout 0 perl }
IF ( (-NOT ((Get-Command "heat.exe" -ErrorAction SilentlyContinue).Path)) -OR (-NOT ((Get-Command "candle.exe" -ErrorAction SilentlyContinue).Path)) ) { & choco install --yes --force --no-progress --limit-output --timeout 0 wixtoolset }
IF ( ($sign) -AND ( -NOT ((Get-Command "gpg.exe" -ErrorAction SilentlyContinue).Path) ) ) { & choco install --yes --force --no-progress --limit-output --timeout 0 gpg4win-vanilla }

Copy-Item -Path ..\config\setup.sh -Destination .\setup.ps1
& perl -pi -e "s/^#.+\n//" .\setup.ps1
& type .\setup.ps1
& perl -pi -e "s/^(.+?)=(.+?)\n.+/Set-Variable -Name $1 -Value $2\r\n/" .\setup.ps1
& type .\setup.ps1
. .\setup.ps1
& gci env:* | sort-object name