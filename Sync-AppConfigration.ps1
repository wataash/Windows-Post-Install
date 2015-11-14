#
# Sync_AppConfigration.ps1
#

# 草稿

function Set-AppConfigration
{
    <#
    .DESCRIPTION
    設定ファイルをDropboxからダウンロードする。
    TODO: 設定アップロード・ダウンロードスクリプトとして書き直す。。
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
