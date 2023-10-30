# Demo 2, authentication flows
#
# Authorization Code
# - Using native Microsoft Graph Powershell application 
#
$Parameters = @{
    TenantId = "<enter>"
    ClientId = "14d82eec-204b-4c2f-b7e8-296a70dab67e"
    RedirectUri = "http://localhost"
}
$AccessToken = Get-MsalToken @Parameters
$AuthenticationHeader = @{
    "Content-Type" = "application/json"
    "Authorization" = $AccessToken.CreateAuthorizationHeader()
    "ExpiresOn" = $AccessToken.ExpiresOn.LocalDateTime
}
$AuthenticationHeader
$MobileApps = Invoke-RestMethod -Method "Get" -Uri "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps" -Headers $AuthenticationHeader -ContentType "application/json"
$MobileApps.value | Select-Object -First 17

#
# Client Credentials
# - Using custom app registration
#
$Parameters = @{
    TenantId = "<enter>"
    ClientId = "<enter>"
    ClientSecret = ("<enter>" | ConvertTo-SecureString -AsPlainText -Force)
    RedirectUri = "http://localhost"
}
$AccessToken = Get-MsalToken @Parameters
$AuthenticationHeader = @{
    "Content-Type" = "application/json"
    "Authorization" = $AccessToken.CreateAuthorizationHeader()
    "ExpiresOn" = $AccessToken.ExpiresOn.LocalDateTime
}
$AuthenticationHeader
$MobileApps = Invoke-RestMethod -Method "Get" -Uri "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps" -Headers $AuthenticationHeader -ContentType "application/json"
$MobileApps.value | Select-Object -First 1


#
# Device Code
# - Using native Microsoft Intune PowerShell application (support with PowerShell 7.x and Windows PowerShell 5.1)
#
$Parameters = @{
    TenantId = "<enter>"
    ClientId = "d1ddf0e4-d672-4dae-b554-9d5bdfd93547"
    RedirectUri = "urn:ietf:wg:oauth:2.0:oob"
    DeviceCode = $true
}
$AccessToken = Get-MsalToken @Parameters
$AuthenticationHeader = @{
    "Content-Type" = "application/json"
    "Authorization" = $AccessToken.CreateAuthorizationHeader()
    "ExpiresOn" = $AccessToken.ExpiresOn.LocalDateTime
}
$AuthenticationHeader
$MobileApps = Invoke-RestMethod -Method "Get" -Uri "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps" -Headers $AuthenticationHeader -ContentType "application/json"
$MobileApps.value.displayName


#
#  Client Credentials (Managed System Identity in Function App)
#
$APIVersion = "2017-09-01"
$ResourceUri = "https://graph.microsoft.com"
$Uri = $env:MSI_ENDPOINT + "?resource=$($ResourceUri)&api-version=$($APIVersion)"
$Response = Invoke-RestMethod -Uri $URI -Method "Get" -Headers @{ "Secret" = "$($env:MSI_SECRET)" }
$AuthenticationHeader = @{
    "Authorization" = "Bearer $($Response.access_token)"
    "ExpiresOn" = $Response.expires_on
}