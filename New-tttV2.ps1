function New-tttV2 {                                                                        # Function decleration
    [CmdletBinding()]                                                                       # Not used here but i keep it cuz i'm lazy
    param (
        [Parameter()]
        [Switch]$bot,                                                                       # If you use this switch you will play against a bot
        [Parameter()]
        [string]$player = 'X'                                                               # Lets you set the player whom starts(You)
    )
    
    begin {                                                                                 # Starting section
        [array]$board = @(                                                                  # A 2D for the game board
                            ('1','2','3'),
                            ('4','5','6'),
                            ('7','8','9')
                         )
        function Display () {                                                               # The function to display the board
            for ($i = 0; $i -le 2; $i++){                                                   # Loop 0,1,2
                Write-Output '+---+---+---+'                                                # Formatting
                for ($x = 0; $x -le 2; $x++){                                               # Loop 0,1,2 x3 cuz its inside the other loop
                    Write-Host '| ' -NoNewline                                              # Formatting
                    if ($board[$i][$x] -eq 'X'){                                            # If its an X
                        Write-Host "$($board[$i][$x]) " -NoNewline -ForegroundColor 'Green' # Display it in green
                    }
                    elseif ($board[$i][$x] -eq 'O'){                                        # If its an O
                        Write-Host "$($board[$i][$x]) " -NoNewline -ForegroundColor 'Blue'  # Display it in blue
                    }
                    else{                                                                   # If its an untaken slot
                        Write-Host "$($board[$i][$x]) " -NoNewline                          # Just display in standard color
                    }
                }
                Write-Output '|'                                                            # Formatting
            }
            Write-Output '+---+---+---+'                                                    # Formatting
        }

        function WinTest () {                                                               # The function to test whom is the winner
            function BuffM($a, $b, $c, $d, $e ,$f) {                                        # Function to match the board slots against a character
                if ($f -eq 0) {                                                             # If we use mode 1
                    [string]$buff = $board[$a][$b] + $board[$a][$c] + $board[$a][$d]        # Match x=a y=b,c,d
                }
                else {                                                                      # If we use mode 2
                    [string]$buff = $board[$b][$a] + $board[$c][$a] + $board[$d][$a]        # Match x=b,c,d y=a
                }

                [string]$buff2 = $e + $e + $e                                               # Make a compare buffer of the character
                if ($buff -eq $buff2){                                                      # Test if they match
                    return $true                                                            # Return true                      
                }
                else {                                                                      # If they dont match
                    return $false                                                           # Return false
                }
            }

            #                                                                               # Test if any vertical and horizontal lines exist if so return their matching values
            for ($i = 0; $i -le 2; $i++)
            {
                if (BuffM $i 0 1 2 'X' 0){return 1}                                         
                if (BuffM $i 0 1 2 'O' 0){return 2}
                if (BuffM $i 0 1 2 'X' 1){return 1}
                if (BuffM $i 0 1 2 'O' 1){return 2}
            }

            #                                                                               # Hard coded diagonal
            if ($board[0][0] -eq $board[1][1] -and $board[0][0] -eq $board[2][2])
            {
                if ($board[0][0] -eq 'X') {return 1}
                else {return 2}
            }
            
            #                                                                               # The other hardcoded diagonal
            if ($board[0][2] -eq $board[1][1] -and $board[0][2] -eq $board[2][0])
            {
                if ($board[0][2] -eq 'X') {return 1}
                else {return 2}
            }

            #                                                                               # Loop threw each character and test if it is 123456789
            for ($i = 0; $i -le 2; $i++)
            {
                for ($x = 0; $x -le 2; $x++)
                {
                    if ($board[$i][$x] -match '^[123456789]*$')
                    {
                        return 0                                                            # Return 0 = no win or tie
                    }
                }
            }

            return 3                                                                        # Return that there is a tie
        }

        function MakeMove ($x, $y, $player) {                                               # Set the given xy to the current player
            $board[$y][$x] = $player
        }

        function Swap () {                                                                  # Function to swap the player
            if ($player -eq 'O') {return 'X'}                                               # If its o return x
            elseif ($player -eq 'X') {return 'O'}                                           # If its x return O
        }

        function Translate ($loc) {                                                         # Function to convert index (12345679) to x,y
            if ($loc -le 3){                                                                # If its 123
                return ($loc -1), 0                                                         # Return the correct x,y
            }
            elseif ($loc -le 6){                                                            # If its 456
                return ($loc -4), 1                                                         # Return x,y
            }
            else{                                                                           # If its 789
                return ($loc -7), 2                                                         # Return x,y
            }
        }

        # The bot function is such a mess i will not even take credit for it.
        # It just raw tests if it can win and if not it just picks one with its eyes closed
        if ($bot) {
            function Bot () {
                for ($i = 0; $i -le 2; $i++){
                    if ($board[0][$i] -eq $board[1][$i] -and $board[2][$i] -ne 'O' -and $board[2][$i] -ne 'X' -and $board[1][$i]-eq 'X'){
                        return $i, 2
                    }
                    if ($board[0][$i] -eq $board[2][$i] -and $board[1][$i] -ne 'O' -and $board[1][$i] -ne 'X' -and $board[2][$i]-eq 'X'){
                        return $i, 1
                    }
                    if ($board[1][$i] -eq $board[2][$i] -and $board[0][$i] -ne 'O' -and $board[0][$i] -ne 'X' -and $board[2][$i]-eq 'X'){
                        return $i, 0
                    }
                }
                for ($i = 0; $i -le 2; $i++){
                    if ($board[$i][0] -eq $board[$i][1] -and $board[$i][2] -ne 'O' -and $board[$i][2] -ne 'X' -and $board[$i][1]-eq 'X'){
                        return 2, $i
                    }
                    if ($board[$i][0] -eq $board[$i][2] -and $board[$i][1] -ne 'O' -and $board[$i][1] -ne 'X' -and $board[$i][2]-eq 'X'){
                        return 1, $i
                    }
                    if ($board[$i][1] -eq $board[$i][2] -and $board[$i][0] -ne 'O' -and $board[$i][0] -ne 'X' -and $board[$i][2]-eq 'X'){
                        return 0, $i
                    }
                }

                if ($board[0][0] -eq $board[1][1] -and $board[2][2] -ne 'O' -and $board[2][2] -ne 'X' -and $board[1][1]-eq 'X'){
                    return 2, 2
                }
                if ($board[0][0] -eq $board[2][2] -and $board[1][1] -ne 'O' -and $board[1][1] -ne 'X' -and $board[2][2]-eq 'X'){
                    return 1, 1
                }
                if ($board[1][1] -eq $board[2][2] -and $board[0][0] -ne 'O' -and $board[0][0] -ne 'X' -and $board[2][2]-eq 'X'){
                    return 0, 0
                }

                if ($board[0][2] -eq $board[1][1] -and $board[2][0] -ne 'O' -and $board[2][0] -ne 'X' -and $board[1][1]-eq 'X'){
                    return 2, 0
                }
                if ($board[0][2] -eq $board[2][0] -and $board[1][1] -ne 'O' -and $board[1][1] -ne 'X' -and $board[2][0]-eq 'X'){
                    return 1, 1
                }
                if ($board[1][1] -eq $board[2][0] -and $board[0][2] -ne 'O' -and $board[0][2] -ne 'X' -and $board[2][0]-eq 'X'){
                    return 0, 2
                }

                if ($board[1][1] -eq '5'){
                    return 1,1
                }
                else {
                    for ($i = 0; $i -le 2; $i++){
                        for ($x = 0; $x -le 2; $x++){
                            if ($board[$i][$x] -ne 'X' -and $board[$i][$x] -ne 'O'){
                                return $x,$i
                            }
                        }
                    }
                }
            }
        }
    }
    
    process {                                                                               # The game section
        $win = 0                                                                            # Variable with game state
        while ($win -eq 0) {                                                                # Loop while no win or tie
            Display                                                                         # Draw the game
            while ($true) {                                                                 # Inf loop
                $move = Read-Host -Prompt "Move for $player"                                # Get the users move
                $xa,$ya = Translate($move)                                                  # Convert the index to x,y
                write-Host "[$xa`:$ya]" -ForegroundColor 'Red'                              # Display the formatted x,y
                if (@(0,1,2) -contains $xa -and @(0,1,2) -contains $ya) {                   # If it was a valid move
                    if ($board[$ya][$xa] -eq $move) {                                       # If the x,y are free
                        MakeMove $xa $ya $player                                            # Make the move
                        break;                                                              # Leave the loop    
                    }
                }                                                                           # If its invalid ask again
            }

            $player = Swap                                                                  # Swap the player
            $win = WinTest                                                                  # Test if there has been a win
            if ($win -ne 0){                                                                # It only updates the test at the end so i need to manualy test
                break                                                                       # Leave the loop
            }

            if ($bot)                                                                       # If we are playing against a bot
            {
                $xa, $ya = bot                                                              # Get the next move the bot wants
                write-Host "[$xa`:$ya]"                                                     # Display it
                MakeMove $xa $ya $player                                                    # Make the move
                $player = Swap                                                              # Swap the player
                $win = WinTest                                                              # Test for a win
            }
        }  
    }
    
    end {                                                                                   # Ending section

        Display                                                                             # Display the game board in its finished state

        if ($win -eq 3){                                                                    # If it was a tie
            Write-Host 'Its a: ' -NoNewline                                                 # Let them know its a tie
            return 'Tie'
        }
        else {                                                                              # If there was a winner
            Write-Host 'Its a win for: ' -NoNewline                                         # Let them know there was a winner
            if ($win -eq 1) {                                                               # If its X
                return 'X'                                                                  # Show x
            }
            else {                                                                          # If its O
                return 'O'                                                                  # Show O
            }
        }
        
    }
}