<#
  ______     _ _                   _____          _ _             
 |  ____|   | (_)                 / ____|        | (_)            
 | |__   ___| |_ _ __  ___ ______| |     ___   __| |_ _ __   __ _ 
 |  __| / __| | | '_ \/ __|______| |    / _ \ / _` | | '_ \ / _` |
 | |___| (__| | | |_) \__ \      | |___| (_) | (_| | | | | | (_| |
 |______\___|_|_| .__/|___/       \_____\___/ \__,_|_|_| |_|\__, |
                | |                                          __/ |
                |_|                                         |___/ 

Hello and welcome back to another video,

Today we will be making Tic-Tac-Toe in python.
This was done on semi request of redditor Darthbamf

This function is fully free to use for any purpose(outside of not having fun).

To make Tic-Tac-Toe we will need a few logic functions to have the game work:
    - Display the game
    - Make a move
    - State testing
        - Win
        - Tie
    - cordsconversion
    - Swapping the player

To have the game work we will be using a 2D array wich is an array in an array(so it has 2 dimensions)
These are fairly simple to make $a = @((01,02,03),(11,12,13)) the way we call these is with $a[0][1]($a[y][x])

Now that we have some basic logic down lets look at the code.
#>

function New-TTT # This is the function we will be calling to play the game
{
    [CmdletBinding()] # We use this as it lets us use things like write-debug and write-verbose wich are just good practice
    param # This part will be empty as this function doesnt take paramaters
    (

    )

    BEGIN # We will use this section to startup and get ready to play the game
    {
        Write-Verbose('--BEGIN--') # (Good practice)

        Write-Verbose('Variable decleration') # (Good practice)
            [char]$player = 'X' # The variable we will use to know whoms turn it is

        Write-Verbose('Making the board') # (Good practice)
            [array]$board = @(('1','2','3'), # This is the 2D array i was talking about
                              ('4','5','6'),
                              ('7','8','9'))

        Write-Verbose('Making functions') # (Good practice)
            Write-Verbose('Display function') # (Good practice)
                function TTT-Display # We are stating the next bit is a function
                {
                    Write-Output('') # Blank line To make it clearer
                    Write-Output('') # ^
                    for($i = 0; $i -lt 3; $i++) # This loop contains 3 items: making the variable; the while statement; that we want to add 1 each loop
                    {
                        Write-Output($board[$i][0] + ',' + $board[$i][1] + ',' + $board[$i][2]) # We are writing the board so ppl know what they are playing
                    }
                }  
            
            Write-Verbose('Move function') # (Good practice)
                function TTT-Move([int]$x, [int]$y) # We are stating the next bit is a function
                {
                    if ($board[$y][$x] -ne 'X' -and $board[$y][$x] -ne 'O') # Here we are testing if the position we give it is not already taken
                    {
                        $board[$y][$x] = $player # Here we are setting the slot we chose to the player whoms turn it is
                    }
                }         
            
            Write-Verbose('WinTest function') # (Good practice)
                function TTT-WinTest # We are stating the next bit is a function
                {
                    for($i = 0; $i -lt 3; $i++) # This loop contains 3 items: making the variable; the while statement; that we want to add 1 each loop
                    {
                        if ($board[$i][0] -eq $board[$i][1] -and $board[$i][2] -eq $board[$i][1]) # We use this to check if all horizontal slots are the same
                        {
                            return $board[$i][0] # This will return the player whom has made the line
                        }
                    
                        if ($board[0][$i] -eq $board[1][$i] -and $board[0][$i] -eq $board[2][$i]) # We use this to check if all vertical slots are the same
                        {
                            return $board[0][$i] # This will return the player whom has made the line
                        }
                    }

                    if ($board[0][0] -eq $board[1][1] -and $board[0][0] -eq $board[2][2]) # There are only 2 diagonals so these are just hard-coded
                    {
                        return $board[0][0] # This will return the player whom has made the line
                    }
                    if ($board[0][2] -eq $board[1][1] -and $board[0][0] -eq $board[2][0]) # There are only 2 diagonals so these are just hard-coded
                    {
                        return $board[0][2] # This will return the player whom has made the line
                    }

                    return 'NOT FOUND' # If we cant find any lines we will just return that there are non
                }

            Write-Verbose('TieTest function') # (Good practice)
                function TTT-TieTest # We are stating the next bit is a function
                {
                    for($i = 0; $i -lt 3; $i++) # This loop contains 3 items: making the variable; the while statement; that we want to add 1 each loop
                    {
                        for($a = 0; $a -lt 3; $a++) # This loop is the same as the others only its nested meaning each time the last loop fires this one will fire 3 times
                        {
                            if ($board[$a][$i] -ne 'X' -and $board[$a][$i] -ne 'O') # If we found an untaken slot
                            {
                                return $false # This will return false as we will have found a empty slot meaning there isnt a tie
                            }
                        }
                    }

                    return $true # If we cant find a open slot that will mean there is a tie
                }

            Write-Verbose('CordsConv function') # (Good practice)
                function TTT-CordsConv([int]$index) # We are stating the next bit is a function
                {
                    if ($index -ge 7) # This will just test on what row our choice is
                    {
                        return ($index -7),2 # We use the double return feature wich is where we can return 2 values and capture them in separate variables
                    }
                    elseif ($index -ge 4) # This will just test on what row our choice is
                    {
                        return ($index -4),1 # We use the double return feature wich is where we can return 2 values and capture them in separate variables
                    }
                    else # This will just test on what row our choice is
                    {
                        return ($index -1),0 # We use the double return feature wich is where we can return 2 values and capture them in separate variables
                    }
                }

            Write-Verbose('Swap function') # (Good practice)
                function TTT-Swap # We are stating the next bit is a function
                {
                    if ($player -eq 'X') # If the last turn was X
                    {
                        return 'O' # Make the player O
                    }
                    if ($player -eq 'O') # If the last turn was O
                    {
                        return 'X' # Make the player O
                    }
                }
    }

    PROCESS # Here we will actualy play the game
    {
        Write-Verbose('--PROCESS--') # (Good practice)
        
        Write-Verbose('Main loop') # (Good practice)
            while ($true) # We use this as it will make a infinite loop
            {
                TTT-Display # This is the function we use to show the board
                $in = Read-Host($player) # We use this as it will let us take in what move you want to make
                if ($in -le 9 -and $in -ge 1) # A quick check to make shure that its a valid position
                {
                    [int]$x,[int]$y = TTT-CordsConv($in) # This is where the double return feature is used
                    
                    TTT-Move $x $y # Then we just call the function to make a move
                }
                $winner = TTT-WinTest # Getting the posible winner
                if ($winner -ne 'NOT FOUND') # If there is a winner found
                {
                    break # Quit the loop
                }
                if (TTT-TieTest) # If there is a tie
                {
                    $winner = 'TIE' # Change the winner to TIE
                    break # Quit the loop
                }
                $player = TTT-Swap # Swapping the player
            }
    }

    END # This is where we will roundup like showing the winner
    {
        Write-Verbose('--END--') # (Good practice)
        if ($winner -ne 'TIE') # If there wasnt a tie
        {
            return "$winner has won" # Tell them that a person has won
        }
        return 'Its a tie' # If there was a tie
    }
}