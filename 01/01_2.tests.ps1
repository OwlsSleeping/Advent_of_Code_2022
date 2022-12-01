BeforeAll {
    $In = (Get-Content .\TestInput.txt -raw) -split "`r`n`r`n"
}

Describe "Totals" {
    It "Biggest Elf" {
        $Sum = (Get-Total -Elf ($In[3]))
        $Sum | Should -Be 24000
    }
    It "Same Top 3" {
        $Top3Sum = (Get-Top3 -In @(24000,11000,6000,10000)) 
        $Top3Sum | Should -Be 45000
    }
}