function New-tttV2 {
    [CmdletBinding()]
    param (
        [Parameter()]
        [Switch]$bot,
        [Parameter()]
        [string]$player = 'X'
    )
    
    begin {
        [array]$board = @(
                            ('1','2','3'),
                            ('4','5','6'),
                            ('7','8','9')
                         )
        function Display () {
            for ($i = 0; $i -le 2; $i++){
                Write-Output '+---+---+---+'
                for ($x = 0; $x -le 2; $x++){
                    Write-Host '| ' -NoNewline
                    if ($board[$i][$x] -eq 'X'){
                        Write-Host "$($board[$i][$x]) " -NoNewline -ForegroundColor 'Green'
                    }
                    elseif ($board[$i][$x] -eq 'O'){
                        Write-Host "$($board[$i][$x]) " -NoNewline -ForegroundColor 'Blue'
                    }
                    else{
                        Write-Host "$($board[$i][$x]) " -NoNewline
                    }
                }
                Write-Output '|'
            }
            Write-Output '+---+---+---+'
        }

        function WinTest () {
            <#
            0=none
            1=X
            2=O
            3=Tie
            #>
            function BuffM($a, $b, $c, $d, $e ,$f) {
                if ($f -eq 0) {
                [string]$buff = $board[$a][$b] + $board[$a][$c] + $board[$a][$d]
                }
                else {
                    [string]$buff = $board[$b][$a] + $board[$c][$a] + $board[$d][$a]
                }

                write-Host "$buff"

                [string]$buff2 = $e + $e + $e
                if ($buff.Contains($buff2)){
                    return $true
                }
                else {
                    return $false
                }
            }

            for ($i = 0; $i -le 2; $i++)
            {
                if (BuffM $i 0 1 2 'X' 0){return 1}
                if (BuffM $i 0 1 2 'O' 0){return 2}
                if (BuffM $i 0 1 2 'X' 1){return 1}
                if (BuffM $i 0 1 2 'O' 1){return 2}
            }

            if ($board[0][0] -eq $board[1][1] -and $board[0][0] -eq $board[2][2])
            {
                if ($board[0][0] -eq 'X') {return 1}
                else {return 2}
            }
            
            if ($board[0][2] -eq $board[1][1] -and $board[0][2] -eq $board[2][0])
            {
                if ($board[0][2] -eq 'X') {return 1}
                else {return 2}
            }

            for ($i = 0; $i -le 2; $i++)
            {
                for ($x = 0; $x -le 2; $x++)
                {
                    if ($board[$i][$x] -match '^[OX]*$')
                    {
                        return 0
                    }
                }
            }

            return 3
        }

        function MakeMove ($x, $y, $player) {
            $board[$y][$x] = $player
        }

        function Swap () {
            if ($player -eq 'O') {$player = 'X'}
            elseif ($player -eq 'X') {$player = 'O'}
        }

        function Translate ($loc) {
            if ($loc -le 3){
                return ($loc -1), 0
            }
            elseif ($loc -le 6){
                return ($loc -4), 1
            }
            else{
                return ($loc -7), 2
            }
        }
    }
    
    process {
        $win = 0
        while ($win -eq 0) {
            Display
            while ($true) {
                $move = Read-Host -Prompt "Move for $player"
                $xa,$ya = Translate($move)
                write-Host "[$xa`:$ya]"
                if (@(0,1,2) -contains $xa -and @(0,1,2) -contains $ya) {
                    if ($board[$ya][$xa] -eq $move) {
                        MakeMove $xa $ya $player
                        break;
                    }
                }
            }
            Swap
            $win = WinTest
        }  
    }
    
    end {
        
    }
}