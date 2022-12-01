$In = (Get-Content .\Input.txt -raw) -split "`r`n`r`n"

function Get-Total {
    param(
        [string]$Elf
    )
    $Parsed = ($Elf -split "`r`n").ForEach{[int]::Parse(($_ ))}
    return ($Parsed | Measure-Object -Sum).Sum
}

function Get-Top3 {
    param(
        $In
    )    
    $Totals = 
    foreach($Elf in $In) {
        (Get-Total $Elf)
    }

    (
        ($Totals | Sort-Object -Descending -Top 3) |
        Measure-Object -Sum
    ).Sum
}

Get-Top3 $In