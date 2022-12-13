function Count-Visible {
    param (
        [System.Collections.Generic.List[int[]]]$Trees,
        [int]$StartX,
        [int]$StartY,
        [int]$StepX,
        [int]$StepY,
        [int]$Width
    )

    [int]$InputHeight = $Trees[$StartY][$StartX]
    [int]$CurrentX = $StartX + $StepX #Separate current vs start to help with debugging, add one step to ignore starting position
    [int]$CurrentY = $StartY + $StepY
    [int]$VisibleCount = 0

    while($CurrentX -ge 0 -and $CurrentX -lt $Width -and $CurrentY -ge 0 -and $CurrentY -lt $Width) {
        $VisibleCount++
        if($Trees[$CurrentY][$CurrentX] -ge $InputHeight) {
            return $VisibleCount
        }
        [void](($StepX)?($CurrentX = $CurrentX + $StepX):($CurrentY = $CurrentY + $StepY)) #Move one step. X or Y only, no diagonals.
    }

    return $VisibleCount
}

$Direction = @{} #Store directions, just for convenience
$Direction.Add('Left', @{ X = -1; Y = 0})
$Direction.Add('Right',@{ X = 1; Y = 0})
$Direction.Add('Up', @{ X = 0; Y = 1})
$Direction.Add('Down', @{ X = 0; Y = -1})

$In = Get-Content $PSScriptRoot\Input.txt

$Parsed = [System.Collections.Generic.List[int[]]]::new() #Load input
foreach($Row in $In) {
    $Trees = $Row.ToCharArray() | ForEach-Object {[int]::Parse($_)}
    $Parsed.Add($Trees)
}


$Width = $In.Count #assumed square
$VisibleCount = ($Width * 4) - 4 #No need to outside layer of trees, always visible from the outside

for ($y = 1; $y -le ($Width - 2); $y++) {
    for($x = 1; $x -le $Width - 2; $x++) {
        $BaseParams = @{ #Shared between all directions, no need to re-enter these
            Trees = $Parsed
            InputHeight = $Parsed[$y][$x]
            StartX = $x
            StartY = $y
            Width = $Width
        }
        $RollingProduct = 1
        foreach($DirName in $Direction.Keys) {
            $RollingProduct = $RollingProduct * (Count-Visible @BaseParams -StepX ($Direction.$DirName.X) -StepY ($Direction.$DirName.Y))
        }
        [int]$MaxRollingProduct = [System.Math]::Max($MaxRollingProduct, $RollingProduct)
    }
}

$MaxRollingProduct