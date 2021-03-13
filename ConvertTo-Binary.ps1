function ConvertTo-Binary {                                                                                 # Function decleration
    [CmdletBinding()]                                                                                       # So we can use write-verbose(wich i wont be commenting)
    param (
        [parameter(Mandatory, ValueFromPipeline)]                                                           # Needed and can be piped
        [ValidateRange(1, 1000000)]                                                                         # Input must be between 1 and a million
        [int]$decimal                                                                                       # Its stored in a int called deciaml
    )
    
    begin {
        Write-Verbose 'BEGIN'
        Write-Verbose 'Making variables...'

        [array]$binary                                                                                      # An array to store the binary
        [int]$i = 0                                                                                         # Loop count
    }
    
    process {
        Write-Verbose 'PROCESS'
        Write-Verbose 'Looping...'
        while($i -le 20) {                                                                                  # Loop 20 times
            $binary += ($decimal % 2) -as [string]                                                          # Add the remainder to the array 
            [int]$decimal = ($decimal / 2) -as [int]                                                        # Set the value \2 

            $i++                                                                                            # Add 1 to i
        }
    }
    
    end {
        Write-Verbose 'END'
        
        Write-Verbose 'Inverting output...'
        [string]$left = ([regex]::Matches($binary,'.','RightToLeft') | ForEach-Object {$_.value}) -join ''  # Inverting the array of binary

        Write-Verbose 'Removing leading 0s...'
        $out = $left -replace '^0+', '0'                                                                    # Remove leading 0s accept the last one

        Write-Verbose 'Returing...'
        return $out                                                                                         # Returning
    }
}