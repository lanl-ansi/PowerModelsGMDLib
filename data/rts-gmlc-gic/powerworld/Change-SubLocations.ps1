param (
    $InputPath,
    $GeoPath,
    $BusSubPath,
    $OutputPath 
)

Write-Host " In: $InputPath"
Write-Host "Geo: $GeoPath"
Write-Host "Out: $OutputPath"


If (Test-Path $OutputPath) {
    Remove-Item "$OutputPath" | Out-Null
}

function Test-SimAutoOutput {
    param (
        $Output,
        $ErrorMessage
    )

    $SimAutoError = $Output[0].Trim()

    If ($SimAutoError.Length -gt 0) {
        $SimAuto = $null

        If ($ErrorMessage -eq $null) {
            Throw "$SimAutoError"
        } Else {
            Throw "${ErrorMessage}. $SimAutoError"
        }
    }
    
    $Output[1]
}

function Invoke-SimAutoScript {
    param (
        $Instance,
        $Command,
        $ErrorMessage
    )

    Test-SimAutoOutput -Output $SimAuto.RunScriptCommand($Command) -ErrorMessage $ErrorMessage
}

$SimAuto = New-Object -ComObject pwrworld.SimulatorAuto
$SimAuto.CreateIfNotFound = $True
Test-SimAutoOutput -Output $SimAuto.OpenCase($InputPath) -ErrorMessage "There was an error opening ${InputPath}"
Invoke-SimAutoScript -Instance $SimAuto -Command 'EnterMode(EDIT)'

$Geo = Get-Content $GeoPath | ConvertFrom-Json

Foreach ($Sub in $Geo.substations.features) {
    $SubKeys = "Number", "Name", "Longitude", "Latitude"
    $SubVals = $Sub.properties.id, $Sub.properties.name, $Sub.geometry.coordinates[0], $Sub.geometry.coordinates[1]
    # Write-Host "Adding Substation $SubVals"
    Test-SimAutoOutput $SimAuto.ChangeParametersSingleElement("Substation", $SubKeys, $SubVals)

    foreach ($Bus in $Sub.properties.buses) {
        $BusKeys = "Number", "SubNumber"
        $BusVals = $Bus.id, $Sub.properties.id
        # Write-Host "  Adding bus $BusVals"
        Test-SimAutoOutput $SimAuto.ChangeParametersSingleElement("Bus", $BusKeys, $BusVals)
    }
}

Test-SimAutoOutput $SimAuto.ProcessAuxFile("$HOME\Repos\gmd-tools\auxfiles\BusSubView.aux")
Test-SimAutoOutput $SimAuto.ProcessAuxFile("$HOME\Repos\gmd-tools\auxfiles\SubGeoView.aux")
# Test-SimAutoOutput $SimAuto.RunScriptCommand("OpenOneline(""$BaseOnelinePath"")") -ErrorMessage "Can't open $BaseOnelinePath"
# Test-SimAutoOutput $SimAuto.RunScriptCommand("LoadAXD(""$HOME\Repos\gmd-tools\auxfiles\AutoInsertSubOnelineObjects.axd"", ""OCONUS"", YES)")
# Test-SimAutoOutput $SimAuto.RunScriptCommand("SaveOneline(""$OnelinePath"", ""OCONUS"", PWB)") 

$Out = $SimAuto.SaveCase($OutputPath, "PWB21", $true) 
$Err = $Out[0]


If ($Err.Length -gt 0) {
    Write-Host "Error saving ${OutputPath}: $Err"
}

$SimAuto = $null
