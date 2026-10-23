# Claim the npm package names shinjuku, shinjuku-shield, shinpay and shinai for the npm user shinjuku-shield.
# Run it in a PowerShell window:
#   powershell -ExecutionPolicy Bypass -File C:\Users\newma\shinjuku-npm-names\claim.ps1
# npm shows a link (press ENTER to open it in the browser) at each step: sign in as shinjuku-shield and approve with
# your phone passkey. Expect about six approvals: the sign-in, one per package, and the GitHub publish permissions.
$ErrorActionPreference = 'Continue'
$here = $PSScriptRoot
$reg = 'https://registry.npmjs.org/'
$names = @('shinjuku', 'shinjuku-shield', 'shinpay', 'shinai')
# npm 11.13.0 has `npm trust` (step 3); this machine's npm can be older.
function Invoke-Npm {
  # npx.ps1 drops arguments splatted with @args: call npx.cmd with one array.
  $a = @('-y', 'npm@11.13.0') + $args + @('--registry', $reg)
  & npx.cmd @a
  if ($LASTEXITCODE -ne 0) { throw "npm $($args -join ' ') failed (exit $LASTEXITCODE)" }
}
# A read that may fail (a name not published yet): its errors stay out of the window.
function Read-Npm { cmd /c "npx -y npm@11.13.0 $($args -join ' ') --registry $reg 2>nul" }

try {
  Write-Host ''
  Write-Host 'Step 1 of 3: sign in to npm as shinjuku-shield.'
  Invoke-Npm login --auth-type=web
  $who = "$(Read-Npm whoami)".Trim()
  if ($who -ne 'shinjuku-shield') { throw "npm says you are '$who', not shinjuku-shield. Run: npx -y npm@11.13.0 logout, then start this again." }

  Write-Host ''
  Write-Host 'Step 2 of 3: publish the four packages (approve each one).'
  foreach ($p in $names) {
    $dir = Join-Path $here $p
    $v = (Get-Content (Join-Path $dir 'package.json') -Raw | ConvertFrom-Json).version
    if ("$(Read-Npm view "$p@$v" version)".Trim() -eq $v) { Write-Host "$p@$v is already published."; continue }
    Push-Location $dir
    try { Invoke-Npm publish --access public --provenance=false } finally { Pop-Location }
    Write-Host "$p@$v is published."
  }

  Write-Host ''
  Write-Host 'Step 3 of 3: let the public GitHub workflows publish later versions (then a release needs no passkey).'
  $workflow = @{ 'shinjuku' = 'publish.yml'; 'shinjuku-shield' = 'publish.yml'; 'shinpay' = 'names.yml'; 'shinai' = 'names.yml' }
  foreach ($p in $names) {
    try { Invoke-Npm trust github $p --file $workflow[$p] --repo ShinjukuStaition/shinjuku-mcp --yes; Write-Host "$p trusts $($workflow[$p])." }
    catch { Write-Host "$p trust was not set ($($_.Exception.Message)). The name is still ours; tell the release session." }
  }
} finally {
  Read-Npm logout | Out-Null
}

Write-Host ''
Write-Host 'Owners on npm now:'
foreach ($p in $names) { Write-Host "$p : $("$(Read-Npm view $p maintainers)".Trim())" }
