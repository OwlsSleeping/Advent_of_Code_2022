#ABC = RPS
#XYX = RPS

$ScoreLookup = @{
    'A X' = 4
    'B X' = 1
    'C X' = 7
    'A Y' = 8
    'B Y' = 5
    'C Y' = 2
    'A Z' = 3
    'B Z' = 9
    'C Z' = 6
}

$Strategy = Get-Content $PSScriptRoot\Input.txt

$Strategy.ForEach{
    $ScoreLookup.$_
} | Measure-Object -Sum