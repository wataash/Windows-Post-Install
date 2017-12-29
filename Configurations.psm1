#
# Configurations.psm1
#

$BackupRoot = 'D:/path_to_backup_root'

$BackupFilePaths = @()
$BackupFilePaths += @(
	# on home directory
	'non-exist file'
	'.bash_history'
	'.gitconfig'
	'.kdiff3rc'
	'.python_history'
	'contestapplet.conf'
	'Appdata/Roaming/ConEmu.xml'
) | % {$HOME + '\' + $_}


$BackupDirectoryPaths = @(
	'!*?fasInvalid directory name'
	'C:\NonExistDirectoryName'
	'C:\Sandbox'
	# 'C:\tools\cygwin\home'
	'C:\cygwin64\home'
)
$BackupDirectoryPaths += @(
	# on home directory
	'.gnucash'
	'Desktop'
	'Documents'
	'Downloads'
	# 'Dropbox'
	'Music'
	'Pictures'
	'Videos'
	# https://productforums.google.com/forum/#!topic/ime-ja/ut-s3UFrO88
	'appdata\LocalLow\Google\Google Japanese Input'
) | % {$HOME + '/' + $_}
$BackupDirectoryPaths += @(
	# on %APPDATA%
	# 'aacs'
	# 'Dropbox'
	# 'dvdcss'
	'FileZilla'
	'Greenshot'
	'Microsoft/OneNote'
	'Microsoft/VisualStudio'
	'Microsoft\Windows\PowerShell'
	'Microsoft\Windows\Start Menu\Programs\Startup'
	'Microsoft\Windows\SendTo'
	'Mozilla'
	'MySQL/Workbench'
	# http://mgzl.jp/2014/10/28/sync-sublime-text-3-over-dropbox/
	'Sublime Text 3'
	'Thunderbird'
) | % {$ENV:APPDATA + '/' + $_}
$BackupDirectoryPaths += @(
	# on %LOCALAPPDATA%
	'Atlassian'
	'Mendeley Ltd'
) | % {$ENV:LOCALAPPDATA + '/' + $_}

Export-ModuleMember -Variable *


<#
c: copy and check
s: save (TODO: manage in git)
?: check and/or copy
i: ignore: copy, but no check, probably removed
d: don't copy because it's large and not needed

$Recycle.Bin\	d
bootmgr	i
BOOTNXT	i
Dell\	i
Documents and Settings	i	link to Users
eula.\d\d\d\d.txt	i
hiberfil.sys'	d
Intel\Logs	i
MSOCache\	i
NVIDIA\DisplayDriver\
PerfLogs\	i
ProgramData\	c
Sandbox\	?
swapfile.sys'	d
System Volume Information\	i
tools\cygwin\home\$USER
Users\$USER\3D Objects\	i
Users\$USER\AppData\Local\	?	TODO
Users\$USER\AppData\LocalLow\Google\Google Japanese Input\	s
Users\$USER\AppData\LocalLow\LastPass	?
Users\$USER\AppData\LocalLow\Microsoft\	?
Users\$USER\AppData\LocalLow\Sun\Java\Deployment\	i
Users\$USER\AppData\Roaming\Adobe\Flash Player	i
Users\$USER\AppData\Roaming\Atom\DevTool Extensions	?
Users\$USER\AppData\Roaming\ConEmu.xml	s
Users\$USER\AppData\Roaming\dvdcss\	i
Users\$USER\AppData\Roaming\Greenshot\Greenshot.ini	s
Users\$USER\AppData\Roaming\Micromedia\Flash Player\	i
Users\$USER\AppData\Roaming\Microsort\	c
Users\$USER\AppData\Roaming\Mozilla\Firefox\Profiles\	s
Users\$USER\AppData\Roaming\StrokesPlus\	s
Users\$USER\AppData\Roaming\Sublime Text 3\	s
Users\$USER\AppData\Roaming\Sun\	i
Users\$USER\AppData\Roaming\vlc\	i
Users\$USER\Contacts\	s
Users\$USER\Desktop\	s

User

AutoHotkey\	?
Downloads\	s
Favorites\	i
Links\	i
Music\	s
OneDrive\	?
Pictures\	s
Saved Games\	i
Searches\	i
Videos\	s


Users\All Users	i	link to Users\ProgramData
Users\Default User	i	link to Users\Default
Users\Default\	i
Users\desktop.ini	i
Users\Public\	c
Windows\	d
#>
