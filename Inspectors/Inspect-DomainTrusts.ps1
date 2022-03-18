<#
.SYNOPSIS
    Gather information about Active Directory High-value target accounts
.DESCRIPTION
    This script checks Active Directory Accounts that are High-value targets and offers remediation steps
.COMPONENT
    PowerShell, Active Directory PowerShell Module, and sufficient rights to change admin accounts
.ROLE
    Domain Admin or Delegated rights
.FUNCTIONALITY
    Gather information about Active Directory high-value target accounts
#>
$path = @($out_path)

Function Inspect-Trusts{
    $Trusts = Get-ADTrust -Filter *
    $Trusts | Out-File -FilePath "$path\DomainTrusts.txt"
    Return $Trusts
}

Return Inspect-Trusts