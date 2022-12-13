$In = Get-Content $PSScriptRoot\Input.txt
#Parse input to coordinates
$Instructions = $In |
ForEach-Object {
    if($_ -match '^(?<Direction>\w)\s(?<Spaces>\d+)$') {
        switch ($Matches.Direction) {
            'L' {[PsCustomObject]@{X = -($Matches.Spaces); Y = 0}}
            'R' {[PsCustomObject]@{X = ($Matches.Spaces); Y = 0}}
            'U' {[PsCustomObject]@{X = 0; Y = ($Matches.Spaces)}}
            'D' {[PsCustomObject]@{X = 0; Y = -($Matches.Spaces)}}
        }
    }
}

$Head = [PsCustomObject]@{X = 0;Y = 0}
$Tail = [PsCustomObject]@{X = 0;Y = 0}
$TailVisited = [System.Collections.Generic.HashSet[System.Tuple[int,int]]]::new() #HashSet because I only want this to hold distinct positions. The tuple is X,Y
[void]$TailVisited.Add([System.Tuple[int,int]]::new(0, 0)) #Start Position

foreach($Command in $Instructions) {
    $Head.X += $Command.X
    $Head.Y += $Command.Y

    $DiffX = $Head.X - $Tail.X
    $DiffY = $Head.Y - $Tail.Y

    $TailMove = [PsCustomObject]@{X = 0; Y = 0} #For convenience to avoid constantly declaring this later.

    while([math]::Abs($DiffY) -ge 2) { #While tail is lagging behind, make steps to catch up
        $TailMove.Y = [math]::Sign($DiffY)
        if($DiffX -ne 0) {
            $TailMove.X = [math]::Sign($DiffX)
        }
        else {$TailMove.X = 0}
    
        $DiffY -= $TailMove.Y
        $DiffX -= $TailMove.X
        $Tail.Y += $TailMove.Y
        $Tail.X += $TailMove.X

        [void]$TailVisited.Add([System.Tuple[int,int]]::new($Tail.X,$Tail.Y))
    }

    while([math]::Abs($DiffX) -ge 2) { #same as above block, but X/Y reversed.
        $TailMove.X = [math]::Sign($DiffX)
        if($DiffY -ne 0) {
            $TailMove.Y = [math]::Sign($DiffY)
        }
        else {$TailMove.Y = 0}
    
        $DiffY -= $TailMove.Y
        $DiffX -= $TailMove.X
        $Tail.Y += $TailMove.Y
        $Tail.X += $TailMove.X

        [void]$TailVisited.Add([System.Tuple[int,int]]::new($Tail.X,$Tail.Y))
    }
}


$Tail
$TailVisited.Count