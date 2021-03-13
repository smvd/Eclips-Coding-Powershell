function Export-Anonfiles {
    [CmdletBinding()]
    param (
        [parameter(Mandatory, ValueFromPipeline)]
        [string]$path,
        [parameter()]
        [string]$key = $null
    )
    
    begin {
        if ($null -eq $key){
            $output = curl.exe -F "file=@$path" 'https://api.anonfiles.com/upload' 2> $null
        }
        else {
            $output = curl.exe -F "file=@$path" "https://api.anonfiles.com/upload?token=$key" 2> $null
        }
    }
    
    process {
        $output
    }
    
    end {
        
    }
}