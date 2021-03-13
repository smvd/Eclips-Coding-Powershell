function ConvertFrom-Binary {                       # Function decleration
    [CmdletBinding()]                               # Lets us use write-verbose
                                                    # I wont comment each write-verbose
    param (
        [parameter(Mandatory, ValueFromPipeline)]   # Needed and you can pipe it in
        [string]$binary                             # Its a string alright
    )
    
    begin {
        Write-Verbose 'BEGIN'
        Write-Verbose 'Validating input...'
        if ($binary -notmatch '^[01]*$') {          # REGEX: If each character in the string is 0,1 return true
            Write-Verbose 'Input isnt binary'
            Throw 'Input isnt binary'               # Error: 'Input isnt binary'
        }
    }
    
    process {
        Write-Verbose 'PROCESS'
        Write-Verbose 'Making variables...'
        $i = 0;                                     # The variable for the bit position
        $num = 0;                                   # The variable for the total
        Write-Verbose 'Looping each bit'
        foreach ($char in $binary.ToCharArray()) {  # Loop threw each bit in the binary
            if ($char -eq '1') {                    # If its a 1
                Write-Verbose 'Running the math...'
                $num += [Math]::Pow(2,$i)           # Get 2 to the power of the number
            }

            $i++                                    # Add 1 to i
        }
    }
    
    end {
        Write-Verbose 'END'
        Write-Verbose 'Returning'
        return $num                                 # Return the number
    }
}