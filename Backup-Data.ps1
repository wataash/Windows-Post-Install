#
# Backup-Data.ps1
#

# -Force: to clear cache
# http://tech.guitarrapc.com/entry/2013/12/03/014013
# -> 5. モジュールの破棄と再読み込み
# -> 一度モジュールを読み込んだセッションでモジュールファイルを変更して読み込み直す
Import-Module $PSScriptRoot/Configurations.psm1 -PassThru -Verbose -Force
Import-Module $PSScriptRoot/Remove-InvalidFileNameChars.psm1 `

# TODO test
# http://www.powershellmagazine.com/2013/05/13/pstip-detecting-if-the-console-is-in-interactive-mode/
[Environment]::GetCommandLineArgs()
# if interactive, $PSScriptRootだめ

Exit-PSSession
# TODO: Post-Install.ps1のように Backup-Directory と Backup-File をまとめる
function Backup-Directory
{
	<#
	.DESCRIPTION
	memo All user home, mozzila
	#>
	[CmdletBinding()]
	param (
		[parameter()]
		[string]$BackupRoot,

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

    $resp = Read-Host $('Overrides ' + $BackupRoot + ' !!')
    If ($resp -ne 'yes') {
        Write-Host $('Aborted {0}.' -f $MyInvocation.MyCommand)
        return
    }

	New-Item -ItemType Directory $HOME/Documents/Windows-Post-Install_log/

	# foreach中のitemはLocalsに出る。
	foreach($d in $Paths){
		$to = $BackupRoot + '/' + $d.TrimStart('C:\')
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
		[string]$BackupRoot,

		[parameter()]
		[string[]]$Paths
	)

	foreach($f in $Paths){
		# ↓これが原因でワイルドカード使えない
		$to = $BackupRoot + '/' + $f.TrimStart('C:\')
		
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
#		[string]$BackupRoot = 'D:\2015-10-06_optiplex9600/wsh'
#	)

#	# TODO: xclude appdata/Local/[Packages,Temp]
#	# TODO: exclude directory できてない？
#	ROBOCOPY $HOME $BackupRoot `
#		/XD $($HOME + '.android') `
#		$($HOME + '/.PyCharm40') `
#		$($HOME + '/Anaconda')`
#		$($HOME + '/Anaconda3')`
#		$($HOME + '/Miniconda3') `
#	    # R:0 skip locked resource. Check log.
#		/MIR /R:0 > $($HOME + '/robocopy.log')
#}


Backup-File -BackupRoot $BackupRoot -Paths $BackupFilePaths
Backup-Directory -BackupRoot $BackupRoot -Paths $BackupDirectoryPaths
	'Microsoft\Windows\Start Menu\Programs\Startup'
	'Microsoft\Windows\SendTo'
