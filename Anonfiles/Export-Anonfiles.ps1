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
        $pageUrl = ($output | ConvertFrom-Json).data.file.url.short

        $html = Invoke-RestMethod $pageUrl

        foreach ($line in ($html -split ' ')){
            if ($line.Contains('href="https://cdn')){
                $directUrl = $line
            }
        }
    }
    
    end {
        $buff = $directUrl -replace 'href="'
        $out = $buff -replace '">'
        
        return $out
    }
}