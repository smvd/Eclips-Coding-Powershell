function Export-Anonfiles {                                                                                                 # Function decleration
    [CmdletBinding()]                                                                                                       # Lets you use write-verbose, write-debug, etc..
                                                                                                                            # Any write-verbose and write-debug wont be commented on
    param (
        [parameter(Mandatory, ValueFromPipeline)]                                                                           # Its needed and it can be piped
        [ValidateScript({Test-Path $_ -PathType leaf})]                                                                     # Validation that you entered a valid and existing path
        [string]$path,                                                                                                      # The string to the path
        [parameter()]                                                                                                       # No weird shit here
        [string]$key = $null                                                                                                # Set it to null unless you give a key
    )
    
    begin {                                                                                                                 # Setup section
        Write-Verbose 'BEGIN'
        if ($null -eq $key){                                                                                                # If you didnt pass a key
            Write-Verbose 'Not using key'
            Write-Verbose 'Uploading...'
            $output = Invoke-WebRequest -InFile "file=@$path" -Uri 'https://api.anonfiles.com/upload' 2> $null              # Upload the file and discard any errors
        }
        else {
            Write-Verbose 'Using key'
            Write-Verbose 'Uploading...'
            $output = Invoke-RestMethod -InFile "file=@$path" -Uri "https://api.anonfiles.com/upload?token=$key" 2> $null   # Uploading the file with your key and ditch any errors
        }
    }
    
    process {    
        Write-Verbose 'PROCESS'                                                                                                           # Processing section
        Write-Verbose 'Getting url to page...'
        $pageUrl = ($output | ConvertFrom-Json).data.file.url.short                                                         # Get the short page url from the json

        Write-Verbose 'Getting hmtl...'
        $html = Invoke-RestMethod $pageUrl                                                                                  # Get the html webpage

        Write-Verbose 'Looping threw words...'
        foreach ($line in ($html -split ' ')){                                                                              # Loop threw each word in the webpage
            if ($line.Contains('href="https://cdn')){                                                                       # If it contains 'href="https://cdn'
                Write-Verbose 'Found url'
                $directUrl = $line                                                                                          # Extract the href to the url
                break;
            }
        }
    }
    
    end {                                                                                                                   # Finishing section
        Write-Verbose 'END'
        Write-Verbose 'Replacing...'
        $buff = $directUrl -replace 'href="'                                                                                # Remove 'href="' 
        $out = $buff -replace '">'                                                                                          # Remove '">'
        
        Write-Verbose 'Returning...'
        return $out                                                                                                         # Spit it out
    }
}