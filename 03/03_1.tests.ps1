BeforeAll {
    $In = (Get-Content $PSScriptRoot\TestInput.txt -raw)
}

Describe "Match Examples" {
    It "Conversion of Example Matches" {
        $Converted = ConvertTo-ReverseCaseAscii -Rucksack 'vJrwpWtwJgWrhcsFMMfFFhFp'
        $Converted | Should -Be @(22,36,18,23,16,49,20,23,36,7,49,18,8,3,19,32,39,39,6,32,32,8,32,16)
    }
    It "Split in half works" {
        $Split = Split-RucksackValuesInHalf -Items @(1, 2, 4, 4, 6, 7)
        $Split.First | Should -Be @(1, 2, 4)
        $Split.Second | Should -Be @(4, 6, 7)
    }
    It "Shared Value Works" {
        Get-SharedValue -ReferenceObject @(1, 2, 3) -DifferenceObject @(3, 4, 0) | Should -Be 3
    }
}