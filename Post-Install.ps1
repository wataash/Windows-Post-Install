<#
TODO
install office

App config after install
disable: akamai… (w/ autocad), autodesk…, callnote.exe, Java…, LINE,
	Microsoft OneDrive, onenote…, national instruments…, Skype
startup: altdrag
Thunderbird mailnews.wraplength 65000

cygwin: 他のスクリプトに移す。
https://github.com/transcode-open/apt-cyg
lynx -source rawgit.com/transcode-open/apt-cyg/master/apt-cyg > apt-cyg
install apt-cyg /bin
apt-cyg install wget
apt-cyg install ip openssh autossh rsync zsh



Windows 10 セットアップ画面で全パーティション消去、unallocated spaceにインストール
ASUS：左のUSBポートだとエラー（ we couldn't wait create a partition…）、右だといけた
ブートの優先順位が関係してる？MBRを書き込むデバイスが変わるから？

まずBitLocker ON。
http://helpdeskgeek.com/help-desk/fix-device-cant-use-trusted-platform-module-enabling-bitlocker/
http://www.howtogeek.com/193649/how-to-make-bitlocker-use-256-bit-aes-encryption-instead-of-128-bit-aes/
gpedit.msc
	Computer Configuration ->
	Administrative Templates ->
	Windows Components ->
	BitLocker Drive Encryption
		enabled and AES 256
		-> Operating System Drives ->
		Require additional authentication at startup -> enabled
Right click C drive, turn on bitlocker

Change the computer name.
Restart after execute Set-Tweaks.
#>


function Set-Tweaks
{
	Set-ExecutionPolicy RemoteSigned # press y. TODO: 効力あるか？
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

function Restore-Data
{
	throw [System.NotImplementedException]
}

function Install-Driver
{
	throw [System.NotImplementedException]
}


function Install-App
{
	<#
	TODO: リファクター
	#>

	# chocolatey
	# run ps with admin privilege
	iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
	# Sometimes restarts while the process due to windows update
	# sort http://www.online-utility.org/text/sort.jsp
	# 2015/10/17 poshgit できてない？
	choco install -y adobereader altdrag autohotkey_l conemu cyg-get cygwin dropbox firefox git gitextensions google-chrome-x64 googlejapaneseinput greenshot kdiff3 linkshellextension pdfcreator picasa scite4autohotkey sourcetree SublimeText3 sudo thunderbird vlc
	choco install -y eclipse filezilla jdk8 ruby skype sqlite sumatrapdf tortoisegit vmwareplayer winmerge winscp wireshark
	choco install -y Console2 fiddler4 lessmsi mysql.workbench poshgit procexp
	# not install
	# 7zip.install autohotkey atom boxstarter ccleaner ditto easybcd flashplayeractivex gnucash golang hg inkscape javaruntime libreoffice mousewithoutborders paint.net pscx puppet putty pycharm resharper tor-browser virtualbox virtuawin youtube-dl nodejs.install keepass docker # 2015/08/19 failed resharper, "7zip.install"でなく"7zip"だとインストールされてないように見える（どこのディレクトリにあるか分からなかった）

	# Not in chocolatey
	# mendeley https://www.mendeley.com/download-mendeley-desktop/
		# Uncheck "Automatically mark documet as read", organize my Files, Rename document files
	# xvid https://www.xvid.com/download/
	# RealVnc https://www.realvnc.com/download/get/1710/
	# StrokesPlus http://www.strokesplus.com/downloads/
	# swish http://www.swish-sftp.org/
	# camstudio http://camstudio.org/
	# callnote synergy tincam CPU モニター
	# Python
	# http://conda.pydata.org/miniconda.html
		# 2 x86をhome/Miniconda_x86にインストール
		# 3 x86をhome/Miniconda3_x86にインストール・「デフォルト 3.4」チェックを外す
		# Miniconda x64 3.4をhome/Miniconda3にインストール
			# 最後に入れたものが環境変数の先頭に来ると思われる
	conda install -y ipython-notebook matplotlib
		# Miniconda3 x64にのみインストールされるっぽい
	pip install pyvisa
		# Miniconda3 x64のみか？
	# Heavy
	# Visual studio https://www.visualstudio.com/ja-jp/downloads/download-visual-studio-vs.aspx
		# PTVS intellisense
	# autocad
	# Sandboxie http://www.sandboxie.com/index.php?DownloadSandboxie
		# default box -> block internet
	# Mathematica
	# rewrite: ver 10
	# &( $( $HOME+ '\Documents\apps\apps_utokyo_lab\ver901_lab\ver901_lab\Mathematica_9.0.1_Japanese_WIN_LabVersion.exe' )) /norestart /silent | Out-Null
}


function Set-AppConfigration
{
	<#
	.DESCRIPTION
	設定ファイルをDropboxからダウンロードする。過去の遺物。
	TODO: 設定アップロード・ダウンロード関数として他のスクリプトに移す。
	#>
	# virtuawin
	mkdir -Force  $($env:appdata + '\VirtuaWin')
	# $URL = 'https://dl.dropboxusercontent.com/u/39450683/apps-conf/VirtuaWin/virtuawin_ctrlWin.cfg'
	$URL = 'https://dl.dropboxusercontent.com/u/39450683/apps-conf/VirtuaWin/virtuawin_ctrlAlt.cfg'
	$path = $($env:appdata + '\VirtuaWin\virtuawin.cfg')
	(New-Object System.Net.WebClient).DownloadFile($URL, $path)
	# Next time: see this when error, if not, delete this lines
	# http://en.gpunktschmitz.de/504-powershell-download-file-from-server-via-https-which-has-a-self-signed-certificate
	
	# Strokesplus
	# config --> preferences --> Stroke Button --> Ignore Key: None
	# Ignore Key: ctrl causes 'ctrl+shift' disable
	$URL = 'https://dl.dropboxusercontent.com/u/39450683/apps-conf/StrokesPlus/StrokesPlus.xml'
	$dir = $($env:appdata + '/StrokesPlus/')
	$path = $( $dir + 'StrokesPlus.xml')
	mkdir -Force $dir
	(New-Object System.Net.WebClient).DownloadFile($URL, $path)
}


function Set-Miscallaneous
{
	<#
	.DESCRIPTION
	過去の遺物。
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
	# Startup
	# wolud work only for 64 bit
	$shell = New-Object -ComObject WScript.Shell
	$startup = $( $env:appdata + '\Microsoft\Windows\Start Menu\Programs\Startup')

	$shortcut = $shell.CreateShortcut("$startup\AltDrag.lnk")
	$shortcut.TargetPath = 'C:\Program Files (x86)\AltDrag\AltDrag.exe'
	$shortcut.Save()
}
