function Start-Watcher {
    param (
        [Parameter(Mandatory = $true)]
        [string] $recordType,
        [Parameter(Mandatory = $true)]
        [string] $dnsName,
        [Parameter(Mandatory = $true)]
        [string] $recordValue
    )    

    Add-Type -AssemblyName System.Windows.Forms

    $recordDoesNotMatch = $true

    while ($recordDoesNotMatch) {
        $record = Resolve-DnsName $dnsName -Type "$recordType" -NoHostsFile

        switch ($record.QueryType) {
            ##A Records    
            'A' {
                if ($recordValue -eq $record.IPAddress) {
                    $recordDoesNotMatch = $false
                    break;
                }
            }
            ##Cname Records
            'CNAME' {
                if ($recordValue -eq $record.NameHost) {
                    $recordDoesNotMatch = $false
                    break;
                }
            }

            Default {

            }

        }

        if ($recordDoesNotMatch){
            Start-Sleep 30
        }

    }

    $global:balmsg = New-Object System.Windows.Forms.NotifyIcon
    $path = (Get-Process -Id $pid).Path
    $balmsg.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
    $balmsg.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Warning
    $balmsg.BalloonTipText = "The $recordType record for $dnsName now matches $recordValue"
    $balmsg.BalloonTipTitle = "Attention $Env:USERNAME"
    $balmsg.Visible = $true
    $balmsg.ShowBalloonTip(20000)


}

function Watch-DNSRecord {
    param (
        [Parameter(Mandatory = $true)]
        [string] $recordType,
        [Parameter(Mandatory = $true)]
        [string] $dnsName,
        [Parameter(Mandatory = $true)]
        [string] $recordValue
    )
    
    
    
}