$ErrorActionPreference = 'Stop'

function ConvertTo-ReverseCaseAscii {
    param(
        [string]$Rucksack
    )
    $Ascii = [byte[]]$Rucksack.ToCharArray() 
    $ReversedCase = ForEach($Letter in $Ascii) {
        if($Letter -ge 97) { #lower case
            $Letter - 96
        }
        else { #upper case
            $Letter - 38
        }
    }
    return $ReversedCase
}

function Split-RucksackValuesInHalf {
    param (
        [int[]]$Items
    )
    #can add validation of odd number here if that becomes possible
    $Cnt = $Items.Count
    $Split = [PSCustomObject]@{
        First = [int[]]$Items[0..(($Cnt/2) - 1)]
        Second = [int[]]$Items[($Cnt/2)..($Cnt - 1)]
    }
    return $Split
}

function Get-SharedValue {
    param (
        [int[]]$ReferenceObject,
        [int[]]$DifferenceObject
    )
    return ($ReferenceObject | Where-Object {$_ -in $DifferenceObject} | Get-Unique)
}

$In = Get-Content $PSScriptRoot\Input.txt

[int]$RunningTotal = 0
foreach($Rucksack in $in) {
    $Converted = Convert-ToReverseCaseAscii -Rucksack $Rucksack
    $Split = Split-RucksackValuesInHalf -Items $Converted
    $RunningTotal += (Get-SharedValue -ReferenceObject ($Split.First) -DifferenceObject ($Split.Second))[0] #We known only one item shared. Arbitrarily take first if multiple
}

$RunningTotal