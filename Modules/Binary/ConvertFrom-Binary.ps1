function ConvertFrom-Binary {
    [CmdletBinding()]
    param (
        [parameter(Mandatory, ValueFromPipeline)]
        [string]$binary
    )
    
    begin {
        if ($binary -notmatch '^[01]*$')
        {
            Throw 'Input isnt binary'
        }
    }
    
    process {
        $i = 0;
        $num = 0;
        foreach ($char in $binary.ToCharArray())
        {
            if ($char -eq '1')
            {
                $num += [Math]::Pow(2,$i)
            }

            $i++
        }
    }
    
    end {
        return $num
    }
}