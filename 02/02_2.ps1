#ABC = RPS
#XYX = LDW

$ScoreLookup = @{
    'A X' = 3
    'B X' = 1
    'C X' = 2
    'A Y' = 4
    'B Y' = 5
    'C Y' = 6
    'A Z' = 8
    'B Z' = 9
    'C Z' = 7
}

$Strategy = Get-Content $PSScriptRoot\Input.txt

$Strategy.ForEach{
    $ScoreLookup.$_
} | Measure-Object -Sum