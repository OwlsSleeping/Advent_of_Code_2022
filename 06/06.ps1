$In = (Get-Content $PSScriptRoot\Input.txt).ToCharArray()

function Find-StartPosition {
    param(
        [int]$BufferSize,
        [char[]]$Signal
    )

    $Buffer = [System.Collections.Generic.Queue[char]]::new($BufferSize)

    for($i = 0; $i -lt $Signal.Count; $i++) {
        if(-not ($i -lt $BufferSize)) {
            [void]$Buffer.Dequeue()
        }
        $Buffer.Enqueue($Signal[$i])
        if(($Buffer | Sort-Object -Unique).Count -eq $BufferSize) {
            return ($i + 1)
        }
    }
}

Find-StartPosition -BufferSize 4 -Signal $In #Part 1
Find-StartPosition -BufferSize 14 -Signal $In #Part 2