#
# Configurations.psm1
#

$BackupTo = 'D:/2015-11-13_UX31E'

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
	'Appdata/Roaming/ConEmu.xml'  # TODO: �����ConEmu�����H
) | % {$HOME + '\' + $_}


$BackupDirectoryPaths = @(
	'!*?fasInvalid directory name'
	'C:\NotExistDirectoryName'
	'C:\Sandbox'
	'C:\tools\cygwin\home'
)
$BackupDirectoryPaths += @(
	# on home directory
	'.gnucash'
	'Desktop'
	'Documents'
	'Downloads'
	'Dropbox'  # �I�v�V����
	'Music'
	'Pictures'
	'Videos'
	# https://productforums.google.com/forum/#!topic/ime-ja/ut-s3UFrO88
	'appdata\LocalLow\Google\Google Japanese Input'
) | % {$HOME + '/' + $_}
$BackupDirectoryPaths += @(
	# on %APPDATA%
	'aacs',
	'Dropbox',
	'dvdcss',
	'GitExtensions',
	'Greenshot',
	'JetBrains',
	'Microsoft\Windows\Start Menu\Programs\Startup'
	'Microsoft\Windows\SendTo'
	'Mozilla',
	'MySQL/Workbench',
	'StrokesPlus',
	# http://mgzl.jp/2014/10/28/sync-sublime-text-3-over-dropbox/
	'Sublime Text 3',
	'Thunderbird',
	'VirtuaWin'
) | % {$ENV:APPDATA + '/' + $_}

Export-ModuleMember -Variable *
