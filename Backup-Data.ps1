#
# Backup-Data.ps1
#


# http://stackoverflow.com/questions/23066783/how-to-strip-illegal-characters-before-trying-to-save-filenames
Function Remove-InvalidFileNameChars {
  param(
    [Parameter(Mandatory=$true,
      Position=0,
      ValueFromPipeline=$true,
      ValueFromPipelineByPropertyName=$true)]
    [String]$Name
  )

  $invalidChars = [IO.Path]::GetInvalidFileNameChars() -join ''
  $re = "[{0}]" -f [RegEx]::Escape($invalidChars)
  return ($Name -replace $re)
}


function Backup-Directory
{
	<#
	.DESCRIPTION
	memo All user home, mozzila
	#>
	[CmdletBinding()]
	param (
		[parameter()]
		[string]$BackupTo,

		[parameter()]
		[string[]]$BackupDirectoriesAbs,

		[parameter()]
		[string[]]$BackupDirectoriesOnHome,

		[parameter()]
		[string[]]$BackupDirectoriesOnAppdata
	)
	
	<#
	なぜかstring[]のパラメータはVS2015のLocalsで[]になる。Watch、QuickWatchでも同様。
	echoするとちゃんと定義されている。
	echo $BackupDirectoriesAbs
	別の変数に代入しても同様。
	$a = $BackupDirectoriesAbs
	echo $a
	新たに定義するとLocalsに出る。
	$a = @("a", "b")
	$a =
		@(
			"a",
			"b"
		)
	#>

	$BackupDirectoriesAbs += $BackupDirectoriesOnHome | % {$HOME + '/' + $_}

	$BackupDirectoriesAbs +=
		$BackupDirectoriesOnAppdata | % {$ENV:APPDATA + '/' + $_}

	# foreach中のitemはLocalsに出る。
	foreach($d in $BackupDirectoriesAbs){
		$to = $BackupTo + '/' + $d.TrimStart('C:\')
		$LogPath = Remove-InvalidFileNameChars($d)
		$LogPath = $($HOME + '/Documents/robocopy_' + $LogPath + '.log')
		# R:0 skip locked resource. Check log.
		ROBOCOPY $d $to /MIR /R:0 > $LogPath
		If ($?) {
			Write-Output $('ROBOCOPYied ' + $d)
		}
		Else {
			Write-Output $('Failed to ROBOCOPY ' + $d)
		}
	}
} 


function Backup-File
{
	<#
	.DESCRIPTION
	ファイルを指定してバックアップ。
	#>
	[CmdletBinding()]
	param (
		[parameter()]
		[string]$BackupTo,

		[parameter()]
		[string[]]$FilesOnHome
	)
	
	$BackupFilesAbs = @()
	
	$BackupFilesAbs += $FilesOnHome | % {$HOME + '\' + $_}

	foreach($f in $BackupFilesAbs){
		# ↓これが原因でワイルドカード使えない
		$to = $BackupTo + '/' + $f.TrimStart('C:\')
		
		# http://stackoverflow.com/questions/7523497/should-copy-item-create-the-destination-directory-structure
		New-Item -ItemType File -Path $to -Force -Verbose
		
		# TODO: ロックされていても大丈夫？
		Copy-Item -Path $f -Destination $to -Force -Verbose
	}
}


function Get-InstalledSoftwares
{
	# http://www.howtogeek.com/165293/how-to-get-a-list-of-software-installed-on-your-pc-with-a-single-command/
	Get-WmiObject -Class Win32_Product | Select-Object -Property Name
}


#function Backup-EntireHomeDirectory
#{
#	<#
#	.DESCRIPTION
#	ホームディレクトリ丸ごとバックアップ。くそ時間かかるのでボツ。動作確認してない。
#	#>
#	[CmdletBinding()]
#	param (
#		[parameter()]
#		[string]$BackupTo = 'D:\2015-10-06_optiplex9600/wsh'
#	)

#	# TODO: xclude appdata/Local/[Packages,Temp]
#	# TODO: exclude directory できてない？
#	ROBOCOPY $HOME $BackupTo `
#		/XD $($HOME + '.android') `
#		$($HOME + '/.PyCharm40') `
#		$($HOME + '/Anaconda')`
#		$($HOME + '/Anaconda3')`
#		$($HOME + '/Miniconda3') `
#	    # R:0 skip locked resource. Check log.
#		/MIR /R:0 > $($HOME + '/robocopy.log')
#}



$BackupFilesOnHome = @(
	'not exist file'
	'.bash_history'
	'.gitconfig'
	'.kdiff3rc'
	'.python_history'
	'contestapplet.conf'
	'Untitled.ipynb'  # temporary
	'Untitled1.ipynb'  # temporary
	'Untitled2.ipynb'  # temporary
	'Appdata/Roaming/ConEmu.xml'  # TODO: これでConEmu復元？
)

#Backup-File `
#	-BackupTo 'D:/2015-11-13_UX31E' -FilesOnHome $BackupFilesOnHome
#exit


$BackupDirectoriesAbs = @(
	'!*?fasInvalid directory name'
	'C:\NotExistDirectoryName'
	'C:\Sandbox'
	'C:\tools\cygwin\home'
)
$BackupDirectoriesOnHome = @(
	'.gnucash'
	'Desktop'
	'Documents'
	'Downloads'
	'Dropbox'  # オプション
	'Music'
	'Pictures'
	'Videos'
	# https://productforums.google.com/forum/#!topic/ime-ja/ut-s3UFrO88
	'appdata\LocalLow\Google\Google Japanese Input'
)
$BackupDirectoriesOnAppdata = @(
	'aacs',
	'Dropbox',
	'dvdcss',
	'GitExtensions',
	'Greenshot',
	'JetBrains',
	'Mozilla',
	'MySQL/Workbench',
	'StrokesPlus',
	# http://mgzl.jp/2014/10/28/sync-sublime-text-3-over-dropbox/
	'Sublime Text 3',
	'Thunderbird',
	'VirtuaWin'
)

Backup-Directory `
	-BackupTo 'D:/2015-11-13_UX31E' `
	-BackupDirectoriesAbs $BackupDirectoriesAbs `
	-BackupDirectoriesOnHome $BackupDirectoriesOnHome `
	-BackupDirectoriesOnAppdata $BackupDirectoriesOnAppdata

exit
