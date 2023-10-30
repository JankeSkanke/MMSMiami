# Demo, pagination

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
    "Consistencylevel" = "eventual"
}


# Constrict array list to contain all retrieved objects from Graph API
$ResponseList = New-Object -TypeName "System.Collections.Generic.List[object]"

# Construct request with support for handling pagination responses with @odata.nextLink URI's

# Query for totalt amount of users by using Count=true
$Parameters = @{
    Method = "Get"
    Uri = "https://graph.microsoft.com/beta/users/?`$count=true"
    Headers = $AuthenticationHeader
    ContentType = "application/json"
}
$Response = Invoke-RestMethod @Parameters
Write-Output "The total amount of users is : $($Response.'@odata.count')"
#How many are actually returned?
$Response.value.count

#Get them all
$Parameters = @{
    Method = "Get"
    Uri = "https://graph.microsoft.com/beta/users/"
    Headers = $AuthenticationHeader
    ContentType = "application/json"
}
do {
    $Response = Invoke-RestMethod @Parameters
    Write-Output "Count of returned objects: $($Response.value.count)"
    if ($null -ne $Response.'@odata.nextLink') {
        Write-Output -InputObject "Response contains '@odata.nextLink'"
        $ResponseList.AddRange($Response.value)
        $Parameters["Uri"] = $Response.'@odata.nextLink'
    }
    else {
        $ResponseList.AddRange($Response.value)
    }
}
until ($null -eq $Response.'@odata.nextLink')
$ResponseList.Count
