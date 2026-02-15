CREATING AZURE APP SERVICE

To create the service as demonstrated:

1. Log on to Azure and search for App Services.
2. Click Create on the App Services page, and choose Web App.
3. Set the appropriate subscription and resource group.
4. Set a name for the Web app, such as bertietestapp.
5. Set Publish to Code.
6. Set the Runtime Stack to .NET 9 (STS).
7. Set the Operating System to Linux.
8. Set an appropriate region.
9. Choose Basic as the Pricing Plan.
10. Do not create a database.
11. Do not change any of the deployment settings.
12. Do not change any of the networking settings.
13. On the Monitor and Secure page, click No against Enable Application Insights.
14. Do not add any tags.
15. Click Create to create the Azure App Service.

PUBLISHING THE APP

The Visual Studio solution is in the 3.3\\HourlyDataWebApplication folder.
Download Visual Studio Community Edition if necessary - this is free!

1. In Visual Studio, right-click on HourlyDataWebApplication in Solution Explorer, and click Publish.
2. Choose Azure App Service (Linux).
3. Choose the app service from the resource list.
4. Click Finish to publish.