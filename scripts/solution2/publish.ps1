$tenantId="72f988bf-86f1-41af-91ab-2d7cd011db47"
$subscriptionId="eeb84c6a-7753-4a8a-b39e-d66612be62a0"
$resourceGroup="sdubey-stig"
$storageAccountName="sdubeystig1"

$containerName="files"
$acureDeployFile="azuredeploy.json"
$createUIDefFile="createUiDefinition.json"

#Set-AzContext -Tenant $tenantId -SubscriptionId $subscriptionId
$context = (Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName).Context

Set-AzStorageBlobContent -File ".\azuredeploy.json" -Container $containerName -Blob "azuredeploy.json" -Context $context -Force
Set-AzStorageBlobContent -File ".\createUiDefinition.json" -Container $containerName -Blob "createUiDefinition.json" -Context $context -Force

$azureDeployUrl = New-AzStorageBlobSASToken -Container $containerName -Blob (Split-Path $acureDeployFile -leaf) -Context $context -FullUri -Permission r
$createUIDefUrl = New-AzStorageBlobSASToken -Container $containerName -Blob (Split-Path $createUIDefFile -leaf) -Context $context -FullUri -Permission r

$azureDeployUrlEncoded=[uri]::EscapeDataString($azureDeployUrl)
$createUIDefUrlEncoded=[uri]::EscapeDataString($createUIDefUrl)
$deployUrl="https://portal.azure.com/#create/Microsoft.Template/uri/$($azureDeployUrlEncoded)/createUIDefinitionUri/$($createUIDefUrlEncoded)"
$deployUrl