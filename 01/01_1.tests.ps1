BeforeAll {
    $In = (Get-Content .\TestInput.txt -raw) -split "`r`n`r`n"
}

Describe "Example-Total" {
    It "Biggest Elf" {
        $Sum = (Get-Total -Elf ($In[3]))
        $Sum | Should -Be 24000
    }
}