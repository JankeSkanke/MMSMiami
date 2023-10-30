# Demo, decode tokens

Import-Module -Name "JWTDetails"

# Delegated access (authorization code flow)
# Property with permissions: scp
$Parameters = @{
    TenantId = ""
    ClientId = ""
    RedirectUri = "http://localhost"
}
$DelegatedAccessToken = Get-MsalToken @Parameters

$DelegatedAccessToken.AccessToken | Get-JWTDetails | Select-Object -ExpandProperty "scp" | ForEach-Object { $PSItem.Split(" ") }


# Application access (client credentials flow)
# Property with permissions: roles
$Parameters = @{
    TenantId = ""
    ClientId = ""
    ClientSecret = ("" | ConvertTo-SecureString -AsPlainText -Force)
    RedirectUri = "http://localhost"
}
$CredentialsAccessToken = Get-MsalToken @Parameters
$CredentialsAccessToken.AccessToken | Get-JWTDetails | Select-Object -ExpandProperty "roles" | ForEach-Object { $PSItem.Split(" ") }