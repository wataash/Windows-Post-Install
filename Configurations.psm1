#
# Configurations.psm1
#

$BackupRoot = 'D:/path_to_backup_root'

$BackupFilePaths = @()
$BackupFilePaths += @(
	# on home directory
	'not exist file'
	'.bash_history'
	'.gitconfig'
	'.kdiff3rc'
	'.python_history'
	'contestapplet.conf'
	'Untitled.ipynb'  # temporary
	'Untitled1.ipynb'  # temporary
	'Untitled2.ipynb'  # temporary
	'Appdata/Roaming/ConEmu.xml'
) | % {$HOME + '\' + $_}


$BackupDirectoryPaths = @(
	'!*?fasInvalid directory name'
	'C:\NotExistDirectoryName'
	'C:\Sandbox'
	# 2015/11/16 C:/cygwin64/home がcygwin rootになった
	'C:\tools\cygwin\home'
)
$BackupDirectoryPaths += @(
	# on home directory
	'.gnucash'
	'.PyCharm50'
	'Desktop'
	'Documents'
	'Downloads'
	'Dropbox'  # オプション
	'Music'
	'Pictures'
	'Videos'
	# https://productforums.google.com/forum/#!topic/ime-ja/ut-s3UFrO88
	'appdata\LocalLow\Google\Google Japanese Input'
) | % {$HOME + '/' + $_}
$BackupDirectoryPaths += @(
	# on %APPDATA%
	# 'aacs'
	'Dropbox'
	# 'dvdcss'
	'FileZilla'
	'GitExtensions'
	'Greenshot'
	'JetBrains'
	'Microsoft/InputMethod'
	'Microsoft/OneNote'
	'Microsoft/VisualStudio'
	'Microsoft\Windows\PowerShell'
	'Microsoft\Windows\Start Menu\Programs\Startup'
	'Microsoft\Windows\SendTo'
	'Mozilla'
	'MySQL/Workbench'
	'StrokesPlus'
	# http://mgzl.jp/2014/10/28/sync-sublime-text-3-over-dropbox/
	'Sublime Text 3'
	'Thunderbird'
	'VirtuaWin'
) | % {$ENV:APPDATA + '/' + $_}
$BackupDirectoryPaths += @(
	# on %LOCALAPPDATA%
	'Atlassian'
	'Mendeley Ltd'
) | % {$ENV:LOCALAPPDATA + '/' + $_}

Export-ModuleMember -Variable *
