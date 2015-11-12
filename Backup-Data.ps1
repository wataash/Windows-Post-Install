#
# Backup-Data.ps1
#

function Backup-Directory
{
	<#
	.DESCRIPTION
	TODO: 下の Restore Data の書き方まねる。
	# newuser
	# home, mozzila
	#>
	[CmdletBinding()]
	param (
		[parameter()]
		[string]$BackupTo = 'D:\2015-10-06_optiplex9600',

		[parameter()]
		[string[]]$BackupDirectoriesAbs =
			@(
				'C:\Sandbox',
				'C:\tools\cygwin\home'
			),

		[parameter()]
		[string[]]$BackupDirectoriesOnHome =
			@(
				'Desktop',
				'Documents',
				'Downloads',
				'Dropbox',
				'Music',
				'Pictures',
				'Videos',
				# https://productforums.google.com/forum/#!topic/ime-ja/ut-s3UFrO88
				'appdata\LocalLow\Google\Google Japanese Input'
			),

		[parameter()]
		[string[]]$BackupDirectoriesOnAppdata =
			@(
				'aacs',
				'Dropbox',
				'dvdcss',
				'Mozilla',
				'StrokesPlus',
				# http://mgzl.jp/2014/10/28/sync-sublime-text-3-over-dropbox/
				'Sublime Text 3',
				'Thunderbird',
				'VirtuaWin'
			)
	)
	
	<#
	なぜかstring[]のデフォルトパラメータがVS2015のLocalsで[]になる。Watch、QuickWatchでも同様。
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

	$BackupDirectoriesAbs +=
		$DirectoriesOnHome |
		% {$HOME + '/' + $_}

	$BackupDirectoriesAbs +=
		$BackupDirectoriesOnAppdata |
		% {$ENV:APPDATA + '/' + $_}

	# foreach中のitemはLocalsに出る。
	foreach($d in $BackupDirectoriesAbs){
		$to = $HOME + '/Documents/tmp/' + $d.TrimStart('C:\')
		# R:0 skip locked resource. Check log.
		ROBOCOPY $d $to /MIR /R:0 > $($HOME + '/Documents/robocopy.log')
	}
} 


function Backup-File
{
	$copy_files_home = @('.gitconfig', 'contestapplet.conf')
	foreach($f in $copy_files_home){
		Copy-Item -Path $($HOME + '\' + $f) `
		-Destination $BackupTo -Force -Recurse -Verbose
	}
}


function Get-InstalledSoftwares
{
	# http://www.howtogeek.com/165293/how-to-get-a-list-of-software-installed-on-your-pc-with-a-single-command/
	Get-WmiObject -Class Win32_Product | Select-Object -Property Name
}


function Backup-EntireHomeDirectory
{
	<#
	.DESCRIPTION
	ホームディレクトリ丸ごとバックアップ。くそ時間かかるのでボツ。動作確認してない。
	#>
	[CmdletBinding()]
	param (
		[parameter()]
		[string]$BackupTo = 'D:\2015-10-06_optiplex9600/wsh'
	)

	# TODO: xclude appdata/Local/[Packages,Temp]
	# TODO: exclude directory できてない？
	ROBOCOPY $HOME $BackupTo `
		/XD $($HOME + '.android') `
		$($HOME + '/.PyCharm40') `
		$($HOME + '/Anaconda')`
		$($HOME + '/Anaconda3')`
		$($HOME + '/Miniconda3') `
	    # R:0 skip locked resource. Check log.
		/MIR /R:0 > $($HOME + '/robocopy.log')
}

Backup-Directory

