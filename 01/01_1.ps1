$In = (Get-Content .\Input.txt -raw) -split "`r`n`r`n"

function Get-Total {
    param(
        [string[]]$Elf
    )
    $Parsed = ($Elf -split "`r`n").ForEach{[int]::Parse(($_ ))}
    return ($Parsed | Measure-Object -Sum).Sum
}

$Highest = 0
foreach($Elf in $In) {
    $Highest = [math]::Max((Get-Total $Elf), $Highest)
}

$Highest