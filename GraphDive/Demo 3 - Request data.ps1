# Demo, request data

# First things first, authenticate
$Parameters = @{
    TenantId = ""
    ClientId = ""
    RedirectUri = "http://localhost"
}
$AccessToken = Get-MsalToken @Parameters
$AuthenticationHeader = @{
    "Content-Type" = "application/json"
    "Authorization" = $AccessToken.CreateAuthorizationHeader()
    "ExpiresOn" = $AccessToken.ExpiresOn.LocalDateTime
}

#
# Construct a request using GET method
# - Retrieve data from Graph API
#
$Parameters = @{
    Method = "Get"
    Uri = "https://graph.microsoft.com/beta/deviceManagement/managedDevices"
    Headers = $AuthenticationHeader
    ContentType = "application/json"
}
$ManagedDevices = Invoke-RestMethod @Parameters
$ManagedDevices.value


#
# Construct a request using POST method
# - Add a new item resource to Graph API
#
$BodyTable = @{
    displayName = "HP Devices"
    platform = "windows10AndLater"
    rule = '(device.manufacturer -eq "HP")'
}
$Parameters = @{
    Method = "Post"
    Uri = "https://graph.microsoft.com/beta/deviceManagement/assignmentFilters"
    Body = ($BodyTable | ConvertTo-Json)
    Headers = $AuthenticationHeader
    ContentType = "application/json"
}
Invoke-RestMethod @Parameters


#
# Construct a request using PATCH method
# - Update an existing property of an item resource in Graph API
#
(Invoke-RestMethod -Method "Get" -Uri "https://graph.microsoft.com/beta/deviceManagement/assignmentFilters" -Headers $AuthenticationHeader -ContentType "application/json").value

$BodyTable = @{
    displayName = "MSE HP Devices"
}
$Parameters = @{
    Method = "Patch"
    Uri = "https://graph.microsoft.com/beta/deviceManagement/assignmentFilters/<enter id>"
    Body = ($BodyTable | ConvertTo-Json)
    Headers = $AuthenticationHeader
    ContentType = "application/json"
}
Invoke-RestMethod @Parameters

#
# Construct a request using PATCH method, sometimes requires the @odata.type property with the value of the data type
#
$BodyTable = @{
    "@odata.type" = "#microsoft.graph.win32LobApp"
    "displayName" = "7-Zip"
}


#
# Construct a request using DELETE method
# - Remove an item resource from Graph API
#
$Parameters = @{
    Method = "Delete"
    Uri = "https://graph.microsoft.com/beta/deviceManagement/assignmentFilters/<enter id>"
    Headers = $AuthenticationHeader
    ContentType = "application/json"
}
Invoke-RestMethod @Parameters
(Invoke-RestMethod -Method "Get" -Uri "https://graph.microsoft.com/beta/deviceManagement/assignmentFilters" -Headers $AuthenticationHeader -ContentType "application/json").value


#
# Using query parameters - Filtering
#
$SerialNumber = ""
$Parameters = @{
    Method = "Get"
    Uri = "https://graph.microsoft.com/beta/deviceManagement/windowsAutopilotDeviceIdentities?`$filter=contains(serialNumber,'$($SerialNumber)')"
    Headers = $AuthenticationHeader
    ContentType = "application/json"
}
$AutopilotDevice = Invoke-RestMethod @Parameters
$AutopilotDevice.value


#
# Using query parameters - Expanding data
#
$Parameters = @{
    Method = "Get"
    Uri = "https://graph.microsoft.com/beta/deviceManagement/windowsAutopilotDeviceIdentities/<enter id>"
    Headers = $AuthenticationHeader
    ContentType = "application/json"
}
$AutopilotDevice = Invoke-RestMethod @Parameters
$AutopilotDevice

$Parameters = @{
    Method = "Get"
    Uri = "https://graph.microsoft.com/beta/deviceManagement/windowsAutopilotDeviceIdentities/<enter id>?`$expand=deploymentProfile,intendedDeploymentProfile"
    Headers = $AuthenticationHeader
    ContentType = "application/json"
}
$AutopilotDeviceDeploymentProfile = Invoke-RestMethod @Parameters
$AutopilotDeviceDeploymentProfile


#
# Using query parameters - Filtering on a collection property
#
$Parameters = @{
    Method = "Get"
    Uri = "https://graph.microsoft.com/v1.0/devices?`$filter=physicalIds/any(p:p eq '[OrderId]:MIAMI')"
    Headers = $AuthenticationHeader
    ContentType = "application/json"
}
$AzureADDevice = Invoke-RestMethod @Parameters
$AzureADDevice.value | Select-Object -Property "id", "displayName", "physicalIds"


#
# Using query parameters - Filtering for a given @odata.type
#
$Parameters = @{
    Method = "Get"
    Uri = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations?`$filter=(isof('microsoft.graph.windows10CustomConfiguration'))"
    Headers = $AuthenticationHeader
    ContentType = "application/json"
}
$CustomProfiles = Invoke-RestMethod @Parameters
$CustomProfiles.value | Select-Object -Property '@odata.type', "id", "displayName"
