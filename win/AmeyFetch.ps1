$COMPUTER = Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction Stop;
$CPU_INFO = Get-CimInstance -ClassName Win32_Processor -ErrorAction Stop;
$MOTHERBOARD = Get-CimInstance -ClassName Win32_BaseBoard -ErrorAction Stop;
$GPU_INFO = Get-CimInstance -ClassName Win32_VideoController -ErrorAction Stop;
$Curr_Date = Get-Date;
$SysUPTIME = $Curr_Date - $COMPUTER.LastBootUpTime;
$SHELL = Get-CimInstance -ClassName Win32_Process -Filter "ProcessId=$PID";
$Shell_Info = Get-Process -Id $SHELL[0].ParentProcessId;
$MEM_INFO =  (($COMPUTER.TotalVisibleMemorySize - $COMPUTER.FreePhysicalMemory)/1024)/1024;
$DISK_INFO = (Get-PSDrive -Name C);
$SYS_INFO = @{};
$SYS_INFO[0] = "{0}@{1}" -f $env:USERNAME, $COMPUTER.CSName;
$SYS_INFO[1] = "-" * $SYS_INFO[0].Length;
$SYS_INFO[2] = "OS: {0} {1}" -f $COMPUTER.Name.Split("|")[0], $COMPUTER.OSArchitecture;
$SYS_INFO[3] = "HOST: {0}" -f $MOTHERBOARD.Manufacturer;
$SYS_INFO[4] = "KERNEL: {0}" -f $COMPUTER.Version;
$SYS_INFO[5] = "MOTHERBOARD: {0}" -f $MOTHERBOARD.Product;
$SYS_INFO[6] = "UPTIME: {0} Days {1} Hours {2} Minutes" -f $SysUPTIME.Days, $SysUPTIME.Hours, $SysUPTIME.Minutes;
$SYS_INFO[7] = "SHELL: {0}" -f $SHELL.ProcessName;
$SYS_INFO[8] = "RESOLUTION: {0}x{1}" -f  $GPU_INFO.CurrentHorizontalResolution, $GPU_INFO.CurrentVerticalResolution;
$SYS_INFO[9] = "TERMINAL: {0}" -f $Shell_Info.ProcessName;
$SYS_INFO[10] = "GPU: {0}" -f $GPU_INFO.Name;
$SYS_INFO[11] = "CPU: {0}" -f $CPU_INFO.Name;
$SYS_INFO[12] = "MEMORY: {0} GiB / {1} GiB" -f [math]::Round($MEM_INFO, 2), [math]::Round(($COMPUTER.TotalVisibleMemorySize/1024)/1024, 2);
$SYS_INFO[13] = "DISK (C:): {0} GiB / {1} GiB" -f [math]::Round((($DISK_INFO.Used/1024)/1024)/1024, 2), [math]::Round(((($DISK_INFO.Free+$DISK_INFO.Used)/1024)/1024)/1024, 2);
for ($arg=0; $arg -lt $args.Count; $arg++){
    if($args[$arg].ToLower().Contains("--ascii_logo:")){
        $ASCII_LOGO = $args[$arg].ToLower().replace("--ascii_logo:", "");
    }
    else{
        $ASCII_LOGO = "logo.txt";
    }
    if ($args[$arg].ToLower().Contains("--ascii_color:")){
        $ASCII_COLOR = $args[$arg].ToLower().replace("--ascii_color:", "");
    }
    else{
        $ASCII_COLOR = "";
    }
}
$LOGO_FILE = Get-Content $ASCII_LOGO;
if ($LOGO_FILE.Count -gt $SYS_INFO.Count){
    for ($i=0; $i -lt $LOGO_FILE.Count; $i++){
        try{
            $FINAL_OUT = "{0} {1}" -f $LOGO_FILE[$i].replace(".", ""), $SYS_INFO[$i];
        }
        catch{
            $SPACE_CHAR = " " * ($LOGO_FILE[0].Length-1);
            $FINAL_OUT = "{0} {1}" -f $SPACE_CHAR, $SYS_INFO[$i];
        }
        Write-Host -ForegroundColor $ASCII_COLOR $FINAL_OUT;
    }
}
else{
    for ($i=0; $i -lt $SYS_INFO.Count; $i++){
        try{
            $FINAL_OUT = "{0} {1}" -f $LOGO_FILE[$i].replace(".", ""), $SYS_INFO[$i];
        }
        catch{
            $SPACE_CHAR = " " * ($LOGO_FILE[0].Length-1);
            $FINAL_OUT = "{0} {1}" -f $SPACE_CHAR, $SYS_INFO[$i];
        }
        Write-Color -ForegroundColor $ASCII_COLOR $FINAL_OUT;
    }
}