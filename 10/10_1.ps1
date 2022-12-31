$In = Get-Content "$PSScriptRoot\Input.txt"

[int]$RollingValue = 1 #Initial signal strength, updated in loop
$CycleValues = [System.Collections.Generic.List[int]]::new()
$CycleValues.Add($RollingValue)

for($i = 0; $i -lt $In.Count; $i++) { #Get signal strength at each moment in time
    $CycleValues.Add($RollingValue) #Both addx and noop start by making no change for one cycle
    if($In[$i] -match '^addx (?<val>-?\d+)$') {
        $RollingValue += $Matches.val
        $CycleValues.Add($RollingValue)
    }
}

$RunningTotal = 0
for($i = 19; $i -le $CycleValues.Count; $i += 40) { #Sum signal strengths at cycles 20, 40,..
    $RunningTotal += (($i + 1) * $CycleValues[$i])
    # $CycleValues[$i]
    # (($i + 1) * $CycleValues[$i])
}

$RunningTotal