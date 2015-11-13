#
# Backup-Data.ps1
#

# -Force: to clear cache
# http://tech.guitarrapc.com/entry/2013/12/03/014013
# -> 5. モジュールの破棄と再読み込み
# -> 一度モジュールを読み込んだセッションでモジュールファイルを変更して読み込み直す
Import-Module $PSScriptRoot/Configurations.psm1 -PassThru -Verbose -Force


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
		[string[]]$Paths
	)
	
	<#
	なぜかstring[]のパラメータはVS2015のLocalsで[]になる。Watch、QuickWatchでも同様。
	echoするとちゃんと定義されている。
	echo $Paths
	別の変数に代入しても同様。
	$a = $Paths
	echo $a
	新たに定義するとLocalsに出る。
	$a = @("a", "b")
	$a =
		@(
			"a",
			"b"
		)
	#>

	New-Item -ItemType Directory $HOME/Documents/Windows-Post-Install_log/

	# foreach中のitemはLocalsに出る。
	foreach($d in $Paths){
		$to = $BackupTo + '/' + $d.TrimStart('C:\')
		$LogPath = Remove-InvalidFileNameChars($d)
		$LogPath = $($HOME + '/Documents/Windows-Post-Install_log/robocopy_' + $LogPath + '.log')
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
		[string[]]$Paths
	)

	foreach($f in $Paths){
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



Backup-File -BackupTo $BackupTo -Paths $BackupFilePaths
Backup-Directory -BackupTo $BackupTo -Paths $BackupDirectoryPaths
