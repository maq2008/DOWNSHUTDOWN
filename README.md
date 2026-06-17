# DOWNSHUTDOWN

A PowerShell script that monitors a folder for a specific file download completion and automatically shuts down your PC.

## Description

This tool solves a common problem: you start a large download and want your PC to shut down when it finishes, but you don't want to stay at your desk waiting. DOWNSHUTDOWN monitors the folder where your file is downloading and automatically shuts down your computer once the download is confirmed complete.

## How It Works

1. You provide the **file name** (or part of it) to search for
2. You provide the **folder path** where the file will appear
3. You provide the **expected file size** and unit (KB, MB, or GB)
4. The script continuously monitors the folder every 3 seconds
5. Once the file reaches the expected size and stops changing, your PC shuts down

## Files

- **`auto-shutdown.ps1`** - The main PowerShell script
- **`run.bat`** - Batch file to easily run the script

## Requirements

- Windows OS
- PowerShell 5.0 or higher
- Git installed (optional, for cloning)

## Usage

### Method 1 - Using run.bat (Recommended)

1. Clone or download this repository
2. Navigate to the `downshutdown` folder
3. Double-click `run.bat` or run it from command prompt
4. Follow the on-screen prompts

### Method 2 - Using PowerShell directly

```powershell
powershell -ExecutionPolicy Bypass -File "C:\path\to\downshutdown\auto-shutdown.ps1"
```

## How to Use

When you run the script, it will ask for:

1. **File name**: Enter the name (or part of the name) of the file you're downloading. Example: `BloodstrikeSetup.exe` or just `Bloodstrike`

2. **Folder path**: Enter the full path to the folder where your file is downloading. Example: `C:\Users\Admin\Downloads`

3. **Expected file size**: Enter the expected size of the file (just the number). Example: `1500` for a 1.5GB file

4. **Size unit**: Enter KB, MB, or GB depending on your file size

The script will then:
- Monitor the specified folder every 3 seconds
- Show download progress when the file is found
- Wait until the file reaches the expected size and stops changing
- Automatically shut down your PC with a 30-second warning

### To Cancel Shutdown

If you change your mind and don't want your PC to shut down, open Command Prompt and run:

```
shutdown /a
```

This will abort the shutdown.

## Examples

### Example 1 - Monitoring a game download

```
Enter file name (or part of name): BloodstrikeSetup.exe
Enter folder path to monitor: C:\Users\Admin\Downloads
Enter expected file size: 1500
Enter size unit (KB, MB, GB): MB
```

### Example 2 - Monitoring a large ISO file

```
Enter file name (or part of name): ubuntu
Enter folder path to monitor: C:\Users\Admin\Downloads\ISOs
Enter expected file size: 4
Enter size unit (KB, MB, GB): GB
```

## How It Detects Download Completion

The script uses a two-step verification:
1. **Size check**: The file must reach the expected size you specified
2. **Stability check**: The file size must remain unchanged for 5 seconds

This prevents premature shutdown if the file is still being written to.

## Disclaimer

- The script will shut down your PC automatically. Make sure you save all your work before running it.
- You can cancel the shutdown by running `shutdown /a` within 30 seconds.
- The script only monitors the specific folder you specify.

## License

Free to use and modify.