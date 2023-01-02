$In = Get-Content "$PSScriptRoot\Input.txt"

[int]$RollingValue = 1 #Initial signal strength, updated in loop
$CycleValues = [System.Collections.Generic.List[int]]::new()
$CycleValues.Add($RollingValue)
$xWidth = 40

for($i = 0; $i -lt $In.Count; $i++) { #Get signal strength at each moment in time
    $CycleValues.Add($RollingValue) #Both addx and noop start by making no change for one cycle
    if($In[$i] -match '^addx (?<val>-?\d+)$') {
        $RollingValue += $Matches.val
        $CycleValues.Add($RollingValue)
    }
    elseif($In[$i] -ne 'noop'){
        $ErrMsg = " row $($i): `"$($In[$i])`" failed to parse as addx or noop"
        throw $ErrMsg
    }
}

$Image = [System.Collections.Generic.List[char[]]]::new()
for($y = 0; $y -lt ($CycleValues.Count - 1) / $xWidth; $y++) {
    $Image.Add([char[]]@()) #Add empty array for new row

    for($i = 0; $i -lt $xWidth; $i++) {
        if($CycleValues[$i + ($y * $xWidth)] -ge ($i - 1) -and $CycleValues[$i + ($y * $xWidth)] -le ($i + 1)) {
            $Image[$y] += '#' #bad perf, rewrite with mutable object if it matters
        }
        else {
            $Image[$y] += '.'
        }
    }
}

foreach($Row in $Image) {$Row -join ''}