<#
TODO
install office
user nameが変わった場合に非対応

App config after install
disable: akamai… (w/ autocad), autodesk…, callnote.exe, Java…, LINE,
    Microsoft OneDrive, onenote…, national instruments…, Skype
startup: altdrag
Thunderbird mailnews.wraplength 65000

Windows 10 セットアップ画面で全パーティション消去、unallocated spaceにインストール
ASUS：左のUSBポートだとエラー (we couldn't wait create a partition...)
      右だといけた
ブートの優先順位が関係してる？MBRを書き込むデバイスが変わるから？
#>


Import-Module $PSScriptRoot/Configurations.psm1 -PassThru -Verbose -Force
Import-Module $PSScriptRoot/Remove-InvalidFileNameChars.psm1 `
    -PassThru -Verbose -Force


Function Set-InitialConfiguration
{
    # 手動でやる。スクリプト化する気無し。
    throw [System.NotImplementedException]

    # まずadmin ps上で
    Set-ExecutionPolicy Unrestricted
    # を実行してpress y。

    <#
    BitLocker ON。
    http://helpdeskgeek.com/help-desk/fix-device-cant-use-trusted-platform-module-enabling-bitlocker/
    http://www.howtogeek.com/193649/how-to-make-bitlocker-use-256-bit-aes-encryption-instead-of-128-bit-aes/
    gpedit.msc Computer Configuration -> Administrative Templates ->
        Windows Components -> BitLocker Drive Encryption ->
            Operating System Drives ->
                Require additional authentication at startup -> Enabled
        Choose drive encryption method and cipher strength, Enabled, AES256bit
    Right click C drive, turn on bitlocker

    Change the computer name.
    Restart after execute Set-Tweaks.
    githubからこのrepoをzipで落とす。ISEにこのファイルをドラッグして開いて実行。
    or PSの方がハイライトがあって見やすい。
    #>
}


function Set-Tweaks
{
    # TODO: show the taskbar only in the main screen.

    # Power options to prevent PC from sleeping while executing this script.
    # http://blog.coretech.dk/mip/power-management-trough-the-ts-no-more-automatic-sleep/
    powercfg -x -standby-timeout-dc 15
    powercfg -x -standby-timeout-ac 300
    powercfg -x -hibernate-timeout-dc 60
    powercfg -x -hibernate-timeout-ac 1200

    # Do nothing when closing the lid
    # # TODO: 改行大丈夫か？
    powercfg -setdcvalueindex `
        381b4222-f694-41f0-9685-ff5bb260df2e `
        4f971e89-eebd-4455-a8de-9e59040e7347 `
        5ca83367-6e45-459f-a27b-476b1d01c936 0
    powercfg -setacvalueindex `
        381b4222-f694-41f0-9685-ff5bb260df2e `
        4f971e89-eebd-4455-a8de-9e59040e7347 `
        5ca83367-6e45-459f-a27b-476b1d01c936 0

    # Show file extentions, configure taskbar settings (works after reboot)
    # http://stackoverflow.com/questions/4491999/configure-windows-explorer-folder-options-through-powershell
    # http://objwmiservice.wordpress.com/registry-tweaks/registry-tweaks-windows-7/taskbar-and-start-menu-properties-windows-7/
    $key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    Set-ItemProperty $key HideFileExt 0
    Set-ItemProperty $key TaskbarGlomLevel 2 # Never combine
    Set-ItemProperty $key TaskbarSizeMove 1
    Set-ItemProperty $key TaskbarSmallIcons 1
}


Function Restore-Data
{
    Param (
        [Parameter(Mandatory=$true)]
        [string]$BackupRoot,
        [string[]]$FilePaths,
        [string[]]$DirectoryPaths
    )
    
    # TODO user nameが変わったときに対応できない

    If ($PSBoundParameters.ContainsKey('FilePaths')) {
        foreach($fp in $FilePaths){
            # ↓これが原因でワイルドカード使えない
            $src = $BackupRoot + '/' + $fp.TrimStart('C:\')
        
            # http://stackoverflow.com/questions/7523497/should-copy-item-create-the-destination-directory-structure
            New-Item -ItemType File -Path $fp -Force -Verbose
            Copy-Item -Path $src -Destination $fp -Force -Verbose
        }
    }

    If ($PSBoundParameters.ContainsKey('DirectoryPaths')) {
        New-Item -ItemType Directory $HOME/Documents/Windows-Post-Install_log/

        # foreach中のitemはLocalsに出る。
        foreach($dp in $DirectoryPaths){
            $src = $BackupRoot + '/' + $dp.TrimStart('C:\')
            $LogPath = Remove-InvalidFileNameChars($src)
            $LogPath = $($HOME +
                         '/Documents/Windows-Post-Install_log/robocopy_' + 
                         $LogPath + '.log')
            # R:0 skip locked resource. Check log.
            ROBOCOPY $src $dp /E /R:0 > $LogPath
            If ($?) {
                Write-Output $('ROBOCOPYied ' + $dp)
            }
            Else {
                Write-Output $('Failed to ROBOCOPY ' + $dp)
            }
        }
    }
} 


function Install-Driver
{
    throw [System.NotImplementedException]
}


function Install-App
{
    <#
    TODO: リファクター
    google japanese inputなどはインストール後に設定ファイルがロックされてしまうので、
    インストール前にSet-AppConfigrationしたい。
    今のところRestore-Dataがこの役割を担っている。なのでコンピュータ間非同期。
    Sometimes restarts while the process due to windows update.
    #>

    # Chocolatey
    # run ps with admin privilege
    iex ((new-object net.webclient).
        DownloadString('https://chocolatey.org/install.ps1'))
    
    # sort http://www.online-utility.org/text/sort.jsp
   
    # 必須
    choco install -y 7zip.install adobereader altdrag autohotkey_l conemu cygwin dropbox firefox git gitextensions google-chrome-x64 googlejapaneseinput javaruntime kdiff3 linkshellextension pdfcreator picasa scite4autohotkey sourcetree SublimeText3 sudo thunderbird vlc
    # 試す
    # choco install -y Console2 fiddler4 lessmsi procexp tortoisegit
    # HDDに余裕あればインストール
    # choco install -y ditto filezilla wireshark
    
    <#
    not install
    2015/08/19 failed resharper
    "7zip.install"でなく"7zip"だとインストールされてないように見える
    （どこのディレクトリにあるか分からなかった）
    2015/10/17 poshgit できてない？
    atom autohotkey boxstarter ccleaner cyg-get docker easybcd eclipse flashplayeractivex gnucash golang hg inkscape javaruntime jdk8 keepass libreoffice mousewithoutborders mysql.workbench nodejs.install paint.net poshgit pscx puppet putty pycharm resharper ruby skype sqlite sumatrapdf tor-browser virtualbox virtuawin vmwareplayer winmerge winscp youtube-dl
    #>

    <#
    Not in chocolatey
    TODO mysql autocad
    mendeley https://www.mendeley.com/download-mendeley-desktop/
        Uncheck "Automatically mark documet as read",
        organize my Files, Rename document files
    xvid https://www.xvid.com/download/
    RealVnc https://www.realvnc.com/download/get/1710/
    StrokesPlus http://www.strokesplus.com/downloads/
    swish http://www.swish-sftp.org/
    camstudio http://camstudio.org/
    callnote synergy tincam CPU モニター
    
    Heavy
    
    Python (miniconda x64 3.5)
    http://conda.pydata.org/miniconda.html
    # TODO migrate
    conda install -y ipython-notebook matplotlib numpy django
    pip install pyvisa
    
    Visual studio https://www.visualstudio.com/ja-jp/downloads/downloadvisualstudio-vs.aspx
      PTVS intellisense
    autocad
    Sandboxie http://www.sandboxie.com/index.php?DownloadSandboxie
      default box -> block internet
    Mathematica
    rewrite: ver 10
    &( $( $HOME+ '\Documents\apps\apps_utokyo_lab\ver901_lab\ver901_l\Mathematica_9.0.1_Japanese_WIN_LabVersion.exe' )) /norestart /silent |
       Out-Null
    #>
}


function Install-Font
{
    <#
    .DESCRIPTION
    ドロップボックス上のフォントをインストール。過去の遺物。
    #>
    # Fonts
    # remove dropbox dependency
    # http://social.technet.microsoft.com/Forums/windowsserver/en-US/578a82ad-5f23-4c29-a887-92d0c6179311/install-fonts-in-windows7-with-powershell
    $FONTS = 0x14
    $Path = $home + "\Dropbox\doc\fonts\install"
    $objShell = New-Object -ComObject Shell.Application
    $objFolder = $objShell.Namespace($FONTS)
    $Fontdir = dir $Path
    foreach($File in $Fontdir)
    {
      $objFolder.CopyHere($File.fullname)
    }
    remove-item $Path -recurse
}

Function Set-Startup
{
    # TODO メンテナンス
    # Startup
    # wolud work only for 64 bit
    $shell = New-Object -ComObject WScript.Shell
    $startup = `
        $( $env:appdata + '\Microsoft\Windows\Start Menu\Programs\Startup')

    $shortcut = $shell.CreateShortcut("$startup\AltDrag.lnk")
    $shortcut.TargetPath = 'C:\Program Files (x86)\AltDrag\AltDrag.exe'
    $shortcut.Save()
}



#Restore-Data -BackupRoot $BackupRoot `
#             -FilePaths $BackupFilePaths `
#             -DirectoryPaths $BackupDirectoryPaths
