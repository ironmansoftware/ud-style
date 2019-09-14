$BuildFolder = $PSScriptRoot

$powerShellGet = Import-Module PowerShellGet  -PassThru -ErrorAction Ignore
if ($powerShellGet.Version -lt ([Version]'1.6.0')) {
	Install-Module PowerShellGet -Scope CurrentUser -Force -AllowClobber
	Import-Module PowerShellGet -Force
}

Set-Location $BuildFolder

$OutputPath = "$BuildFolder\output\UniversalDashboard.Style"

Remove-Item -Path $OutputPath -Force -ErrorAction SilentlyContinue -Recurse
Remove-Item -Path "$BuildFolder\public" -Force -ErrorAction SilentlyContinue -Recurse

New-Item -Path $OutputPath -ItemType Directory

npm install
npm run build

Copy-Item $BuildFolder\public\*.bundle.js $OutputPath
Copy-Item $BuildFolder\public\*.map $OutputPath
Copy-Item $BuildFolder\UniversalDashboard.Style.psm1 $OutputPath

$Version = "1.0.0"

$manifestParameters = @{
	Path = "$OutputPath\UniversalDashboard.Style.psd1"
	Author = "Adam Driscoll"
	CompanyName = "Ironman Software, LLC"
	Copyright = "2019 Ironman Software, LLC"
	RootModule = "UniversalDashboard.Style.psm1"
	Description = "Easily create stylesheets on the fly."
	ModuleVersion = $version
	Tags = @("universaldashboard", "emotion", "ud-control", "style")
	ReleaseNotes = "Initial release"
	FunctionsToExport = @(
		"New-UDStyle"
	)
	IconUri = "https://github.com/ironmansoftware/ud-style/raw/master/images/logo.png"
	ProjectUri = "https://github.com/ironmansoftware/ud-style"
  RequiredModules = @()
}

New-ModuleManifest @manifestParameters 

if ($prerelease -ne $null) {
	Update-ModuleManifest -Path "$OutputPath\UniversalDashboard.Style.psd1" -Prerelease $prerelease
}

