# Azure subscription details - set your subscription ID
$subscriptionId = ''
$resourceGroupName = "SQL"
$location = "uksouth"           # TODO: Change the location to US

# SQL admin login details
$adminLogin = "sqladmin"
$password = "adminpassword1!"

# SQL Server details
$serverName = "bertieazuresql02"
$databaseName = "stocksystem"

# Set Azure subscription to create database within
Set-AzContext -SubscriptionId $subscriptionId

Write-Host "Set correct subscription."

# Create the server
$server = New-AzSqlServer -ResourceGroupName $resourceGroupName -ServerName $serverName -Location $location -SqlAdministratorCredentials $(New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $adminLogin, $(ConvertTo-SecureString -String $password -AsPlainText -Force))

Write-Host "Created SQL Server."

# Create the database
$database = New-AzSqlDatabase -ResourceGroupName $resourceGroupName -ServerName $serverName -DatabaseName $databaseName -RequestedServiceObjectiveName "GP_S_Gen5_2"

Write-Host "Created SQL database."