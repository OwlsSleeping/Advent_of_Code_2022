$In = Get-Content $PSScriptRoot\Input.txt -Raw

$RawStartPos = ($In -split '\r\n\r\n')[0] -split '\r\n'
$RawInstructions = (($In -split '\r\n\r\n')[1] -split '\r\n')

$Instructions =  $RawInstructions |
    ForEach-Object {
        if($_ -match '^move (?<Move>\d+) from (?<From>\d+) to (?<To>\d+)$') {
            [PSCustomObject]@{
                Move = [int]$Matches.Move
                From = [int]$Matches.From
                To = [int]$Matches.To
            }
        }
    }

$CountColumns = $RawStartPos[$RawStartPos.Count - 1] -Split ' ' | Sort-Object -Descending -Top 1
$HighestStart = ($RawStartPos.Count - 2) #-1 for skip column footers, -1 for zero-based indexing
#$MaxLength = $RawStartPos[0].Length

$Positions = @{}
for($i = 0; $i -lt $CountColumns; $i++) {
    $Positions[$i] = [collections.generic.stack[char]]::new()
}

for ($y = $HighestStart; $y -ge 0; $y--) { #Start from bottom of tower, usi
    for($x = 0; $x -lt $CountColumns; $x++) { #Go across row
        [char]$Chr = $RawStartPos[$y].Substring(((4 * $x) + 1), 1) #Position based on column number
            if($Chr -ne ' ') {
            ($Positions.$x).Push($Chr)
        }
    }
}

$Instructions | ForEach-Object { #Process each row of instructions
    $From = $_.From - 1 #Offset 1 for zero-based indexing
    $To = $_.To - 1 #Offset 1 for zero-based indexing
    for ($i = 0; $i -lt $_.Move; $i++) {
        $ToMove = $Positions[$From].Pop()
        $Positions[$To].Push($ToMove)
    }
}

$Result = for($i = 0; $i -lt $CountColumns; $i++) {
    $Positions[$i].Pop()
}
$Result