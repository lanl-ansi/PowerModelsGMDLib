$NetworkFolders = Get-ChildItem "..\data"

foreach ($NetworkFolder in $NetworkFolders) {
    $PwbFiles = Get-ChildItem (Join-Path $NetworkFolder 'powerworld' '*.pwb')
    Write-Host $PwbFiles
}