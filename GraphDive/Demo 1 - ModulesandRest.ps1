# Native Rest
#Geth the auth token and builds the header using MSAL.PS
$Auth = Get-MsalToken -ClientID '<ENTER>' -Interactive -TenantID 'yourdomain.onmicrosoft.com'
$Autheader = @{Authorization = $Auth.CreateAuthorizationHeader()}
#Define a Graph URI
$GraphURI = "https://graph.microsoft.com/beta/deviceManagement/managedDevices?filter=operatingSystem eq 'Windows'&select=id, deviceName"

#Query the Graph API
$Result = (Invoke-RestMethod -Method Get -Uri $GraphURI -Headers $Autheader).value
$Result

#Using the Graph SDK
Connect-MgGraph -Scopes "DeviceManagementManagedDevices.Read.All"
$Result =Get-MgDeviceManagementManagedDevice -Filter "operatingSystem eq 'Windows'" | Select-Object id, deviceName
$Result

