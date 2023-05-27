# include Class
. $PSScriptRoot"\class\FolderDialog.ps1"
. $PSScriptRoot"\class\MsgBox.ps1"


function main() {
    [object] $fd = New-Object FolderDialog
    [object] $mb = New-Object MsgBox

    if( !($fd.showDialog()) ) {
        $mb.warningMsg("フォルダが選択されませんでした`r`n処理を終了しました")
        exit
    }

    [array] $folders = Get-ChildItem -Path $fd.getSelectDirPath() -Directory -Name
    
    if($folders.Count -eq 0) {
        $mb.warningMsg("フォルダ内に「.zip」ファイルが存在しません`r`n処理を終了しました")
        exit
    }

    foreach($folder in $folders) {
        [string] $targetPath = Join-Path $fd.getSelectDirPath() $folder
        [string] $outputPath = $targetPath + ".zip"
        Compress-Archive -Path $targetPath -DestinationPath $outputPath -Force
    }

    Write-Host "処理完了"
}
main