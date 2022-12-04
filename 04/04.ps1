$In = Get-Content $PSScriptRoot\Input.txt

$FullyContainedCount = 0
$OverlapCount = 0

for($i = 0; $i -lt ($In.Count); $i++){
    if($In[$i] -match '^(?<From1>\d+)-(?<To1>\d+),(?<From2>\d+)-(?<To2>\d+)$') {
        [int]$f1 = $Matches.From1
        [int]$t1 = $Matches.To1
        [int]$f2 = $Matches.From2
        [int]$t2 = $Matches.To2

        if(
            ($f1 -le $f2 -and $t1 -ge $t2) -or
            ($f1 -ge $f2 -and $t1 -le $t2)
        )
        {
            $FullyContainedCount++
        }

        if(
            [math]::Max($f1, $f2) -le [math]::Min($t1, $t2)
        )
        {
            $OverlapCount++
        }

    }
}

$FullyContainedCount #Part 1
$OverlapCount #Part 2