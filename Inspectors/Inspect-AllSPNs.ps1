$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


Function Inspect-AllSPNs{
    Try {
        $SPNs = @()

        $query = New-Object DirectoryServices.DirectorySearcher([ADSI]"")

        $query.Filter = "(serviceprincipalname=*)"

        $results = $query.FindAll()

        Foreach ($result in $results){
            $entity = $result.GetDirectoryEntry()
            $SPNs += $entity.Name, $entity.ServicePrinicpalName
        }

        if ($SPNs.count -ne 0){
            Return $SPNs
        }
    }
    Catch {
    Write-Warning "Error message: $_"
    $message = $_.ToString()
    $exception = $_.Exception
    $strace = $_.ScriptStackTrace
    $failingline = $_.InvocationInfo.Line
    $positionmsg = $_.InvocationInfo.PositionMessage
    $pscmdpath = $_.InvocationInfo.PSCommandPath
    $failinglinenumber = $_.InvocationInfo.ScriptLineNumber
    $scriptname = $_.InvocationInfo.ScriptName
    Write-Verbose "Write to log"
    Write-ErrorLog -message $message -exception $exception -scriptname $scriptname -failinglinenumber $failinglinenumber -failingline $failingline -pscmdpath $pscmdpath -positionmsg $positionmsg -stacktrace $strace
    Write-Verbose "Errors written to log"
    }
}

Return Inspect-AllSPNs
