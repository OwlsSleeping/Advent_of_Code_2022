$ErrorActionPreference = 'Stop'

function ConvertTo-ReverseCaseAscii {
    param(
        [string]$Rucksack
    )
    $Ascii = [byte[]]$Rucksack.ToCharArray()
    $ReversedCase = ForEach($Letter in $Ascii) {
        if($Letter -ge 97) { #lower case. Ascii 'a' = 97, needs to be 1
            $Letter - 96
        }
        else { #upper case. Ascii 'A' = 65, needs to be 27
            $Letter - 38
        }
    }
    return [int[]]$ReversedCase
}

function Group-Elves {
    param(
        [string[]]$In,
        [int]$GroupSize
    )
    $Grouped = For($i = 0; $i -lt $In.Count; $i++) {
        [PSCustomObject]@{
            Group = [Math]::Floor($i / $GroupSize)
            Rucksack = ConvertTo-ReverseCaseAscii -Rucksack $In[$i]
        }
    }
    return $Grouped
}

function Get-SharedValue {
    param (
        [int[]]$ReferenceObject,
        [int[]]$DifferenceObject
    )
    return ($ReferenceObject | Where-Object {$_ -in $DifferenceObject} | Get-Unique)
}

$GroupSize = 3
$In = Get-Content $PSScriptRoot\Input.txt

$Grouped = Group-Elves -In $In -GroupSize $GroupSize
$GroupNumbers = ($Grouped.Group) | Get-Unique

[int]$RunningTotal = 0
ForEach($Group in $GroupNumbers) {
    $Rucksacks = $Grouped | Where-Object {$_.Group -eq $Group} | Select-Object -Property 'Rucksack'

    $ReferenceObject = $Rucksacks[0].Rucksack
    foreach($SingleRucksack in ($Rucksacks[1..($GroupSize - 1)])) { #Get shared between 1 and 2, then recursively compare that set vs 3, 4, 5.. so that only items shared between all are output
        $ReferenceObject = Get-SharedValue -ReferenceObject $ReferenceObject -DifferenceObject $SingleRucksack.Rucksack
    }

    $RunningTotal += $ReferenceObject
}

$RunningTotal