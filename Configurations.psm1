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
	'Appdata/Roaming/ConEmu.xml'
) | % {$HOME + '\' + $_}


$BackupDirectoryPaths = @(
	'!*?fasInvalid directory name'
	'C:\NotExistDirectoryName'
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
