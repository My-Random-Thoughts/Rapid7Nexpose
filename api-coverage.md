# API Coverage

This list shows the current API coverage of the module as of 2019-04-08.

---

    Get  Put  Post Delete Url                                                                        Command
    ---  ---  ---- ------ ---                                                                        -------
              [X]         administration/commands                                                    {Invoke-NexposeSystemCommand.ps1 (POST)}
    [X]                   administration/info                                                        {Get-NexposeSystemInfo.ps1 (GET)}
    [X]       [X]         administration/license                                                     {Get-NexposeLicense.ps1 (GET), Set-NexposeLicense.ps1 (POST)}
    [X]                   administration/properties                                                  {Get-NexposeSystemProperty.ps1 (GET)}
    [X]                   administration/settings                                                    {Get-NexposeSystemSetting.ps1 (GET), Get-NexposeUser2FAToken.ps1 (GET), New-NexposeUser2FAToken.ps1 (GET), Set-NexposeUser2FAToken.ps1 (GET)}
    [X]                   agents                                                                     {Get-NexposeAgent.ps1 (GET)}
    [X]       [X]         asset_groups                                                               {Get-NexposeAssetGroup.ps1 (GET), New-NexposeAssetGroup.ps1 (POST)}
    [X]  [X]       [X]    asset_groups/{id}                                                          {Add-NexposeAssetToGroup.ps1 (GET), Get-NexposeAssetGroup.ps1 (GET), Remove-NexposeAssetFromGroup.ps1 (DELETE), Update-NexposeAssetGroup.ps1 (PUT)}
    [X]  [X]       [X]    asset_groups/{id}/assets                                                   {Add-NexposeAssetToGroup.ps1 (PUT), Get-NexposeAsset.ps1 (GET), Remove-NexposeAssetFromGroup.ps1 (DELETE)}
         [X]       [X]    asset_groups/{id}/assets/{assetId}                                         {Add-NexposeAssetToGroup.ps1 (PUT), Remove-NexposeAssetFromGroup.ps1 (DELETE)}
    [~]  [~]              asset_groups/{id}/search_criteria                                          {[~] Get-NexposeAssetGroup.ps1 (GET), [~] Update-NexposeAssetGroup.ps1 (PUT)}
    [X]  [~]       [X]    asset_groups/{id}/tags                                                     {[~] Add-NexposeTagToObject.ps1 (PUT), Get-NexposeTag.ps1 (GET), Remove-NexposeTagFromObject.ps1 (DELETE)}
         [~]       [X]    asset_groups/{id}/tags/{tagId}                                             {[~] Add-NexposeTagToObject.ps1 (PUT), Remove-NexposeTagFromObject.ps1 (DELETE)}
    [X~] [~]              asset_groups/{id}/users                                                    {[~] Add-NexposeUserToAssetGroup.ps1 (PUT), [~] Get-NexposeUser.ps1 (GET), Get-NexposeAssetGroupUserList.ps1 (GET)}
         [~]       [~]    asset_groups/{id}/users/{userId}                                           {[~] Add-NexposeUserToAssetGroup.ps1 (PUT), [~] Remove-NexposeUserFromAssetGroup.ps1 (DELETE)}
    [X]                   assets                                                                     {Get-NexposeAsset.ps1 (GET)}
    [X]                   assets/{assetId}/policies                                                  {Get-NexposePolicy.ps1 (GET)}
    [~]                   assets/{assetId}/policies/{policyId}/children                              {[~] Get-NexposePolicy.ps1 (GET)}
    [~]                   assets/{assetId}/policies/{policyId}/groups/{groupId}/children             {[~] Get-NexposePolicy.ps1 (GET)}
    [~]                   assets/{assetId}/policies/{policyId}/groups/{groupId}/rules                {[~] Get-NexposePolicy.ps1 (GET)}
    [~]                   assets/{assetId}/policies/{policyId}/rules                                 {[~] Get-NexposePolicy.ps1 (GET)}
    [X]            [X]    assets/{id}                                                                {Get-NexposeAsset.ps1 (GET), Remove-NexposeAsset.ps1 (DELETE)}
    [X]                   assets/{id}/databases                                                      {Get-NexposeAssetDatabase.ps1 (GET)}
    [X]                   assets/{id}/files                                                          {Get-NexposeAssetFileList.ps1 (GET)}
    [X]                   assets/{id}/policy_overrides                                               {Get-NexposePolicyOverride.ps1 (GET)}
    [X]                   assets/{id}/services                                                       {Get-NexposeAssetService.ps1 (GET)}
    [X]                   assets/{id}/services/{protocol}/{port}                                     {Get-NexposeAssetService.ps1 (GET)}
    [~]                   assets/{id}/services/{protocol}/{port}/configurations                      {[~] Get-NexposeAssetService.ps1 (GET)}
    [~]                   assets/{id}/services/{protocol}/{port}/databases                           {[~] Get-NexposeAssetService.ps1 (GET)}
    [~]                   assets/{id}/services/{protocol}/{port}/user_groups                         {[~] Get-NexposeAssetService.ps1 (GET)}
    [~]                   assets/{id}/services/{protocol}/{port}/users                               {[~] Get-NexposeAssetService.ps1 (GET)}
    [~]                   assets/{id}/services/{protocol}/{port}/vulnerabilities                     {[~] Get-NexposeAssetService.ps1 (GET)}
    [~]                   assets/{id}/services/{protocol}/{port}/web_applications                    {[~] Get-NexposeAssetService.ps1 (GET)}
    [~]                   assets/{id}/services/{protocol}/{port}/web_applications/{webApplicationId} {[~] Get-NexposeAssetService.ps1 (GET)}
    [X]                   assets/{id}/software                                                       {Get-NexposeSoftware.ps1 (GET)}
    [X]                   assets/{id}/tags                                                           {Get-NexposeTag.ps1 (GET)}
         [~]       [X]    assets/{id}/tags/{tagId}                                                   {[~] Add-NexposeTagToObject.ps1 (PUT), Remove-NexposeTagFromObject.ps1 (DELETE)}
    [~]                   assets/{id}/user_groups                                                    {[~] Get-NexposeAsset.ps1 (GET)}
    [~]                   assets/{id}/users                                                          {[~] Get-NexposeAsset.ps1 (GET), [~] Get-NexposeUser.ps1 (GET)}
    [X]                   assets/{id}/vulnerabilities                                                {Get-NexposeAssetVulnerability.ps1 (GET)}
    [X]                   assets/{id}/vulnerabilities/{vulnerabilityId}                              {Get-NexposeAssetVulnerability.ps1 (GET)}
    [X]                   assets/{id}/vulnerabilities/{vulnerabilityId}/solution                     {Get-NexposeAssetVulnerability.ps1 (GET)}
    [X]       [X]         assets/{id}/vulnerabilities/{vulnerabilityId}/validations                  {Add-NexposeAssetVulnerabilityValidation.ps1 (POST), Get-NexposeAssetVulnerability.ps1 (GET)}
    [X]            [X]    assets/{id}/vulnerabilities/{vulnerabilityId}/validations/{validationId}   {Get-NexposeAssetVulnerability.ps1 (GET), Remove-NexposeAssetVulnerabilityValidation.ps1 (DELETE)}
              [X@]        assets/search                                                              {Find-NexposeAssetSite.ps1 (POST), Get-NexposeAsset.ps1 (POST), Invoke-NexposeAssetSearch.ps1 (POST)}
    [X]                   authentication_sources                                                     {Get-NexposeAuthenticationSource.ps1 (GET)}
    [X]                   authentication_sources/{id}                                                {Get-NexposeAuthenticationSource.ps1 (GET)}
    [X]                   authentication_sources/{id}/users                                          {Get-NexposeUser.ps1 (GET)}
    [X]                   discovery_connections                                                      {Get-NexposeDiscoveryConnection.ps1 (GET)}
    [X]                   discovery_connections/{id}                                                 {Get-NexposeDiscoveryConnection.ps1 (GET)}
              [X]         discovery_connections/{id}/connect                                         {Invoke-NexposeDiscoveryConnection.ps1 (POST)}
    [X]                   exploits                                                                   {Get-NexposeVulnerabilityExploit.ps1 (GET)}
    [X]                   exploits/{id}                                                              {Get-NexposeVulnerabilityExploit.ps1 (GET)}
    [X]                   exploits/{id}/vulnerabilities                                              {Get-NexposeVulnerabilityExploit.ps1 (GET)}
    [X]                   malware_kits                                                               {Get-NexposeVulnerabilityMalwareKit.ps1 (GET)}
    [X]                   malware_kits/{id}                                                          {Get-NexposeVulnerabilityMalwareKit.ps1 (GET)}
    [X]                   malware_kits/{id}/vulnerabilities                                          {Get-NexposeVulnerabilityMalwareKit.ps1 (GET)}
    [X]                   operating_systems                                                          {Get-NexposeOperatingSystem.ps1 (GET)}
    [X]                   operating_systems/{id}                                                     {Get-NexposeOperatingSystem.ps1 (GET)}
    [X]                   policies                                                                   {Get-NexposePolicy.ps1 (GET)}
    [X]                   policies/{id}/children                                                     {Get-NexposePolicy.ps1 (GET)}
    [X]                   policies/{policyId}                                                        {Get-NexposePolicy.ps1 (GET)}
    [X]                   policies/{policyId}/assets                                                 {Get-NexposePolicy.ps1 (GET)}
    [~]                   policies/{policyId}/assets/{assetId}                                       {[~] Get-NexposePolicy.ps1 (GET)}
    [X]                   policies/{policyId}/groups                                                 {Get-NexposePolicy.ps1 (GET), Get-NexposePolicyGroup.ps1 (GET)}
    [X]                   policies/{policyId}/groups/{groupId}                                       {Get-NexposePolicyGroup.ps1 (GET)}
    [~]                   policies/{policyId}/groups/{groupId}/assets                                {[~] Get-NexposePolicy.ps1 (GET)}
    [~]                   policies/{policyId}/groups/{groupId}/assets/{assetId}                      {[~] Get-NexposePolicy.ps1 (GET)}
    [X]                   policies/{policyId}/groups/{groupId}/children                              {Get-NexposePolicyGroup.ps1 (GET)}
    [X]                   policies/{policyId}/groups/{groupId}/rules                                 {Get-NexposePolicyGroup.ps1 (GET)}
    [X]                   policies/{policyId}/rules                                                  {Get-NexposePolicy.ps1 (GET), Get-NexposePolicyRule.ps1 (GET)}
    [X]                   policies/{policyId}/rules/{ruleId}                                         {Get-NexposePolicyRule.ps1 (GET)}
    [X]                   policies/{policyId}/rules/{ruleId}/assets                                  {Get-NexposePolicyRule.ps1 (GET)}
    [~]                   policies/{policyId}/rules/{ruleId}/assets/{assetId}                        {[~] Get-NexposePolicyRule.ps1 (GET)}
    [X]                   policies/{policyId}/rules/{ruleId}/assets/{assetId}/proof                  {Get-NexposeAssetPolicyRuleProof.ps1 (GET)}
    [X]                   policies/{policyId}/rules/{ruleId}/controls                                {Get-NexposePolicyRule.ps1 (GET)}
    [X]                   policies/{policyId}/rules/{ruleId}/rationale                               {Get-NexposePolicyRule.ps1 (GET)}
    [X]                   policies/{policyId}/rules/{ruleId}/remediation                             {Get-NexposePolicyRule.ps1 (GET)}
    [X]                   policies/{policyId}/rules/disabled                                         {Get-NexposePolicyRule.ps1 (GET)}
    [X]                   policy/summary                                                             {Get-NexposePolicySummary.ps1 (GET)}
    [X]       [X]         policy_overrides                                                           {Get-NexposePolicyOverride.ps1 (GET), New-NexposePolicyOverride.ps1 (POST)}
    [X]            [X]    policy_overrides/{id}                                                      {Get-NexposePolicyOverride.ps1 (GET), Remove-NexposePolicyOverride.ps1 (DELETE), Update-NexposePolicyOverride.ps1 (GET)}
              [X]         policy_overrides/{id}/{status}                                             {Update-NexposePolicyOverride.ps1 (POST)}
    [~]  [X]              policy_overrides/{id}/expires                                              {[~] Get-NexposePolicyOverride.ps1 (GET), Update-NexposePolicyOverride.ps1 (PUT)}
    [X]                   privileges                                                                 {Get-NexposePrivilege.ps1 (GET)}
    [~]                   privileges/{id}                                                            {[~] Get-NexposePrivilege.ps1 (GET)}
    [X]                   privileges/{id}/users                                                      {Get-NexposeUser.ps1 (GET)}
    [X]                   report_formats                                                             {Get-NexposeReportFormat.ps1 (GET)}
    [X]                   report_templates                                                           {Get-NexposeReportTemplate.ps1 (GET)}
    [X@]                  report_templates/{id}                                                      {Get-NexposeReportTemplate.ps1 (GET)}
    [X]       [ ]         reports                                                                    {Get-NexposeReport.ps1 (GET), Get-NexposeReportHistory.ps1 (GET)}
    [X]  [ ]       [X]    reports/{id}                                                               {Get-NexposeReport.ps1 (GET), Remove-NexposeReport.ps1 (DELETE)}
              [X]         reports/{id}/generate                                                      {Invoke-NexposeReport.ps1 (POST)}
    [X]                   reports/{id}/history                                                       {Get-NexposeReportHistory.ps1 (GET)}
    [X]            [X]    reports/{id}/history/{instance}                                            {Get-NexposeReportHistory.ps1 (GET), Remove-NexposeReportHistory.ps1 (DELETE)}
    [X]                   reports/{id}/history/{instance}/output                                     {Export-NexposeReport.ps1 (GET)}
    [X]                   roles                                                                      {Get-NexposeRole.ps1 (GET), New-NexposeUser.ps1 (GET)}
    [X]  [X]       [X]    roles/{id}                                                                 {Get-NexposeRole.ps1 (GET), Remove-NexposeRole.ps1 (DELETE), Update-NexposeRole.ps1 (PUT)}
    [X]                   roles/{id}/users                                                           {Get-NexposeUser.ps1 (GET)}
    [X]       [X]         scan_engine_pools                                                          {Get-NexposeScanEnginePool.ps1 (GET), New-NexposeScanEnginePool.ps1 (POST)}
    [X]  [X]       [X]    scan_engine_pools/{id}                                                     {Get-NexposeScanEnginePool.ps1 (GET), Remove-NexposeScanEnginePool.ps1 (DELETE), Update-NexposeScanEnginePool.ps1 (PUT)}
    [X]  [~]              scan_engine_pools/{id}/engines                                             {[~] Update-NexposeScanEnginePool.ps1 (PUT), Get-NexposeScanEnginePoolEngine.ps1 (GET)}
         [X]       [X]    scan_engine_pools/{id}/engines/{engineId}                                  {Add-NexposeScanEngineToPool.ps1 (DELETE), Add-NexposeScanEngineToPool.ps1 (PUT)}
    [X]                   scan_engine_pools/{id}/sites                                               {Get-NexposeScanEnginePoolSite.ps1 (GET)}
    [X]       [X]         scan_engines                                                               {Get-NexposeScanEngine.ps1 (GET), New-NexposeScanEngine.ps1 (POST)}
    [X]  [@X]      [X]    scan_engines/{id}                                                          {Get-NexposeScanEngine.ps1 (GET), Remove-NexposeScanEngine.ps1 (DELETE), Update-NexposeScanEngine.ps1 (PUT)}
    [~]                   scan_engines/{id}/scan_engine_pools                                        {[~] Get-NexposeScanEngine.ps1 (GET)}
    [X]                   scan_engines/{id}/scans                                                    {Get-NexposeScan.ps1 (GET)}
    [~]                   scan_engines/{id}/sites                                                    {[~] Get-NexposeScanEngine.ps1 (GET)}
    [X]       [X]  [X]    scan_engines/shared_secret                                                 {Get-NexposeScanEngineSharedSecret.ps1 (GET), New-NexposeScanEngineSharedSecret.ps1 (POST), Remove-NexposeScanEngineSharedSecret.ps1 (DELETE)}
    [X]                   scan_engines/shared_secret/time_to_live                                    {Get-NexposeScanEngineSharedSecret.ps1 (GET)}
    [X@]      [X]         scan_templates                                                             {Get-NexposeScanTemplate.ps1 (GET), New-NexposeScanTemplate.ps1 (POST)}
    [X@] [ ]       [X]    scan_templates/{id}                                                        {Get-NexposeScanTemplate.ps1 (GET), Remove-NexposeScanTemplate.ps1 (DELETE)}
    [X]                   scans                                                                      {Get-NexposeScan.ps1 (GET)}
    [X]                   scans/{id}                                                                 {Get-NexposeScan.ps1 (GET)}
              [X]         scans/{id}/{status}                                                        {Update-NexposeScanStatus.ps1 (POST)}
    [X]       [X@] [~]    shared_credentials                                                         {[~] Remove-NexposeSharedCredential.ps1 (DELETE), Get-NexposeSharedCredential.ps1 (GET), New-NexposeSharedCredential.ps1 (GET)...} 
    [X]  [@X]      [X]    shared_credentials/{id}                                                    {Get-NexposeSharedCredential.ps1 (GET), Remove-NexposeSharedCredential.ps1 (DELETE), Update-NexposeSharedCredential.ps1 (PUT)}
    [X]       [X]         sites                                                                      {Get-NexposeSite.ps1 (GET), New-NexposeSite.ps1 (POST)}
    [X]  [X]       [X]    sites/{id}                                                                 {Get-NexposeSite.ps1 (GET), Remove-NexposeSite.ps1 (DELETE), Update-NexposeSite.ps1 (PUT)}
    [X]            [X]    sites/{id}/alerts                                                          {Get-NexposeSiteAlert.ps1 (GET), Remove-NexposeSiteAlert.ps1 (DELETE)}
    [X]  [X]  [X]  [X]    sites/{id}/alerts/smtp                                                     {Get-NexposeSiteAlert.ps1 (GET), New-NexposeSiteAlert.ps1 (POST), Remove-NexposeSiteAlert.ps1 (DELETE), Update-NexposeSiteAlert.ps1 (PUT)}
    [X]  [X]       [X]    sites/{id}/alerts/smtp/{alertId}                                           {Get-NexposeSiteAlert.ps1 (GET), Remove-NexposeSiteAlert.ps1 (DELETE), Update-NexposeSiteAlert.ps1 (PUT)}
    [X]  [X]  [X]  [X]    sites/{id}/alerts/snmp                                                     {Get-NexposeSiteAlert.ps1 (GET), New-NexposeSiteAlert.ps1 (POST), Remove-NexposeSiteAlert.ps1 (DELETE), Update-NexposeSiteAlert.ps1 (PUT)}
    [X]  [X]       [X]    sites/{id}/alerts/snmp/{alertId}                                           {Get-NexposeSiteAlert.ps1 (GET), Remove-NexposeSiteAlert.ps1 (DELETE), Update-NexposeSiteAlert.ps1 (PUT)}
    [X]  [X]  [X]  [X]    sites/{id}/alerts/syslog                                                   {Get-NexposeSiteAlert.ps1 (GET), New-NexposeSiteAlert.ps1 (POST), Remove-NexposeSiteAlert.ps1 (DELETE), Update-NexposeSiteAlert.ps1 (PUT)}
    [X]  [X]       [X]    sites/{id}/alerts/syslog/{alertId}                                         {Get-NexposeSiteAlert.ps1 (GET), Remove-NexposeSiteAlert.ps1 (DELETE), Update-NexposeSiteAlert.ps1 (PUT)}
    [~]       [X]  [X]    sites/{id}/assets                                                          {[~] Get-NexposeAsset.ps1 (GET), New-NexposeAsset.ps1 (POST), Remove-NexposeAssetFromSite.ps1 (DELETE)}
                   [X]    sites/{id}/assets/{assetId}                                                {Remove-NexposeAssetFromSite.ps1 (DELETE)}
    [X]  [ ]              sites/{id}/discovery_connection                                            {Get-NexposeSiteDiscoveryConnection.ps1 (GET)}
    [X]  [ ]              sites/{id}/discovery_search_criteria                                       {Get-NexposeSiteDiscoverySearchCriteria.ps1 (GET)}
    [X]  [X]       [X]    sites/{id}/excluded_asset_groups                                           {Get-NexposeSiteAssetConfiguration.ps1 (GET), Remove-NexposeSiteAssetConfiguration.ps1 (DELETE), Set-NexposeSiteAssetConfiguration.ps1 (PUT)}
                   [X]    sites/{id}/excluded_asset_groups/{assetGroupId}                            {Remove-NexposeSiteAssetConfiguration.ps1 (DELETE)}
    [X]  [X]              sites/{id}/excluded_targets                                                {Find-NexposeIpTargetSite.ps1 (GET), Get-NexposeSiteAssetConfiguration.ps1 (GET), Set-NexposeSiteAssetConfiguration.ps1 (PUT)}
    [X]  [X]       [X]    sites/{id}/included_asset_groups                                           {Get-NexposeSiteAssetConfiguration.ps1 (GET), Remove-NexposeSiteAssetConfiguration.ps1 (DELETE), Set-NexposeSiteAssetConfiguration.ps1 (PUT)}
                   [X]    sites/{id}/included_asset_groups/{assetGroupId}                            {Remove-NexposeSiteAssetConfiguration.ps1 (DELETE)}
    [X]  [X]              sites/{id}/included_targets                                                {Find-NexposeIpTargetSite.ps1 (GET), Get-NexposeSiteAssetConfiguration.ps1 (GET), Set-NexposeSiteAssetConfiguration.ps1 (PUT)}
    [X]  [X]              sites/{id}/organization                                                    {Get-NexposeSiteOrganization.ps1 (GET), Update-NexposeSiteOrganization.ps1 (PUT)}
    [X]  [X]              sites/{id}/scan_engine                                                     {Get-NexposeScanEngine.ps1 (GET), Update-NexposeScanEngine.ps1 (PUT)}
    [X]  [~]  [X@] [~]    sites/{id}/scan_schedules                                                  {[~] Get-NexposeSiteScanSchedule.ps1 (DELETE), [~] Get-NexposeSiteScanSchedule.ps1 (PUT), Get-NexposeSiteScanSchedule.ps1 (GET)...}
    [X]  [X]       [X]    sites/{id}/scan_schedules/{scheduleId}                                     {Get-NexposeSiteScanSchedule.ps1 (GET), Remove-NexposeSiteScanSchedule.ps1 (DELETE), Update-NexposeSiteScanSchedule.ps1 (PUT)}
    [X]  [X]              sites/{id}/scan_template                                                   {Get-NexposeSiteScanTemplate.ps1 (GET), Set-NexposeSiteScanTemplate.ps1 (PUT)}
    [X]       [X]         sites/{id}/scans                                                           {Get-NexposeScan.ps1 (GET), Start-NexposeSiteScan.ps1 (POST)}
    [~]                   sites/{id}/shared_credentials                                              {[~] Get-NexposeSharedCredential.ps1 (GET)}
         [X]              sites/{id}/shared_credentials/{credentialId}/enabled                       {Set-NexposeSiteCredentialEnablement.ps1 (PUT)}
    [X]  [~]  [X@] [X]    sites/{id}/site_credentials                                                {[~] Update-NexposeSiteCredential.ps1 (PUT), Get-NexposeSiteCredential.ps1 (GET), New-NexposeSiteCredential.ps1 (GET)...}          
    [X]  [X]       [X]    sites/{id}/site_credentials/{credentialId}                                 {Get-NexposeSiteCredential.ps1 (GET), Remove-NexposeSiteCredential.ps1 (DELETE), Update-NexposeSiteCredential.ps1 (PUT)}
         [X]              sites/{id}/site_credentials/{credentialId}/enabled                         {Set-NexposeSiteCredentialEnablement.ps1 (PUT)}
    [X]  [~]              sites/{id}/tags                                                            {[~] Add-NexposeTagToObject.ps1 (PUT), Get-NexposeTag.ps1 (GET)}
         [~]       [X]    sites/{id}/tags/{tagId}                                                    {[~] Add-NexposeTagToObject.ps1 (PUT), Remove-NexposeTagFromObject.ps1 (DELETE)}
    [~]  [~]  [~]         sites/{id}/users                                                           {[~] Add-NexposeUserToSite.ps1 (POST), [~] Add-NexposeUserToSite.ps1 (PUT), [~] Get-NexposeUser.ps1 (GET)}
                   [~]    sites/{id}/users/{userId}                                                  {[~] Remove-NexposeUserFromSite.ps1 (DELETE)}
    [X]                   sites/{id}/web_authentication/html_forms                                   {Get-NexposeSiteCredential.ps1 (GET)}
    [X]                   sites/{id}/web_authentication/http_headers                                 {Get-NexposeSiteCredential.ps1 (GET)}
    [X]                   software                                                                   {Get-NexposeSoftware.ps1 (GET)}
    [X]                   software/{id}                                                              {Get-NexposeSoftware.ps1 (GET)}
    [X]                   solutions                                                                  {Get-NexposeSolution.ps1 (GET)}
    [X]                   solutions/{id}                                                             {Get-NexposeSolution.ps1 (GET)}
    [X]                   solutions/{id}/prerequisites                                               {Get-NexposeSolution.ps1 (GET)}
    [X]                   solutions/{id}/supersedes                                                  {Get-NexposeSolution.ps1 (GET)}
    [X]                   solutions/{id}/superseding                                                 {Get-NexposeSolution.ps1 (GET)}
    [X]       [ ]         sonar_queries                                                              {Get-NexposeSonarQuery.ps1 (GET)}
    [X]  [ ]       [X]    sonar_queries/{id}                                                         {Get-NexposeSonarQuery.ps1 (GET), Remove-NexposeSonarQuery.ps1 (DELETE)}
    [X]                   sonar_queries/{id}/assets                                                  {Get-NexposeSonarQuery.ps1 (GET)}
              [ ]         sonar_queries/search                                                       {}                                                                                                                                                              
    [X]       [X]         tags                                                                       {Get-NexposeTag.ps1 (GET), New-NexposeTag.ps1 (POST)}
    [X]  [X]       [X]    tags/{id}                                                                  {Get-NexposeTag.ps1 (GET), Remove-NexposeTag.ps1 (DELETE), Update-NexposeTag.ps1 (PUT)}
    [X]  [~]       [~]    tags/{id}/asset_groups                                                     {[~] Add-NexposeTagToObject.ps1 (PUT), [~] Remove-NexposeTagFromObject.ps1 (DELETE), Get-NexposeAssetGroup.ps1 (GET)}
         [X]       [~]    tags/{id}/asset_groups/{assetGroupId}                                      {[~] Remove-NexposeTagFromObject.ps1 (DELETE), Add-NexposeTagToObject.ps1 (PUT)}
    [~]                   tags/{id}/assets                                                           {[~] Get-NexposeTag.ps1 (GET)}
         [X]       [~]    tags/{id}/assets/{assetId}                                                 {[~] Remove-NexposeTagFromObject.ps1 (DELETE), Add-NexposeTagToObject.ps1 (PUT)}
    [~]  [X]       [X]    tags/{id}/search_criteria                                                  {[~] Get-NexposeTag.ps1 (GET), Remove-NexposeTagSearchCriteria.ps1 (DELETE), Update-NexposeTagSearchCriteria.ps1 (PUT)}
    [X]  [~]       [~]    tags/{id}/sites                                                            {[~] Add-NexposeTagToObject.ps1 (PUT), [~] Remove-NexposeTagFromObject.ps1 (DELETE), Get-NexposeSite.ps1 (GET)}
         [X]       [~]    tags/{id}/sites/{siteId}                                                   {[~] Remove-NexposeTagFromObject.ps1 (DELETE), Add-NexposeTagToObject.ps1 (PUT)}
    [X]       [X]         users                                                                      {Get-NexposeUser.ps1 (GET), New-NexposeUser.ps1 (POST)}
    [X]  [X]       [X]    users/{id}                                                                 {Get-NexposeUser.ps1 (GET), Remove-NexposeUser.ps1 (DELETE), Update-NexposeUser.ps1 (PUT)}
    [X]  [X]  [X]         users/{id}/2FA                                                             {Get-NexposeUser2FAToken.ps1 (GET), New-NexposeUser2FAToken.ps1 (POST), Set-NexposeUser2FAToken.ps1 (PUT)}
    [X]  [~]       [~]    users/{id}/asset_groups                                                    {[~] Add-NexposeUserToAssetGroup.ps1 (PUT), [~] Remove-NexposeUserFromAssetGroup.ps1 (DELETE), Get-NexposeUser.ps1 (GET)}
         [X]       [X]    users/{id}/asset_groups/{assetGroupId}                                     {Add-NexposeUserToAssetGroup.ps1 (PUT), Remove-NexposeUserFromAssetGroup.ps1 (DELETE)}
                   [X]    users/{id}/lock                                                            {Unlock-NexposeUserAccount.ps1 (DELETE)}
         [X]              users/{id}/password                                                        {Set-NexposeUserPassword.ps1 (PUT)}
    [~]                   users/{id}/privileges                                                      {[~] Get-NexposeUser.ps1 (GET)}
    [X]  [~]       [~]    users/{id}/sites                                                           {[~] Add-NexposeUserToSite.ps1 (PUT), [~] Remove-NexposeUserFromSite.ps1 (DELETE), Get-NexposeUser.ps1 (GET)}
         [X]       [X]    users/{id}/sites/{siteId}                                                  {Add-NexposeUserToSite.ps1 (PUT), Remove-NexposeUserFromSite.ps1 (DELETE)}
    [X]                   vulnerabilities                                                            {Get-NexposeVulnerabilityItem.ps1 (GET)}
    [X]                   vulnerabilities/{id}                                                       {Get-NexposeVulnerabilityItem.ps1 (GET)}
    [X]                   vulnerabilities/{id}/assets                                                {Get-NexposeVulnerabilityItemAsset.ps1 (GET)}
    [X]                   vulnerabilities/{id}/checks                                                {Get-NexposeVulnerabilityItemCheck.ps1 (GET)}
    [X]                   vulnerabilities/{id}/exploits                                              {Get-NexposeVulnerabilityItemExploit.ps1 (GET)}
    [X]                   vulnerabilities/{id}/malware_kits                                          {Get-NexposeVulnerabilityItemMalwareKit.ps1 (GET)}
    [X]                   vulnerabilities/{id}/references                                            {Get-NexposeVulnerabilityItemReference.ps1 (GET)}
    [X]                   vulnerabilities/{id}/solutions                                             {Get-NexposeVulnerabilityItemSolution.ps1 (GET)}
    [X]                   vulnerability_categories                                                   {Get-NexposeVulnerabilityCategory.ps1 (GET)}
    [X]                   vulnerability_categories/{id}                                              {Get-NexposeVulnerabilityCategory.ps1 (GET)}
    [X]                   vulnerability_categories/{id}/vulnerabilities                              {Get-NexposeVulnerabilityCategory.ps1 (GET)}
    [X]                   vulnerability_checks                                                       {Get-NexposeVulnerabilityCheck.ps1 (GET)}
    [X]                   vulnerability_checks/{id}                                                  {Get-NexposeVulnerabilityCheck.ps1 (GET)}
    [X]                   vulnerability_checks_types                                                 {Get-NexposeVulnerabilityCheckType.ps1 (GET)}
    [X]       [X]         vulnerability_exceptions                                                   {Get-NexposeVulnerabilityException.ps1 (GET), New-NexposeVulnerabilityException.ps1 (POST)}
    [X]            [X]    vulnerability_exceptions/{id}                                              {Get-NexposeVulnerabilityException.ps1 (GET), Remove-NexposeVulnerabilityException.ps1 (DELETE), Update-NexposeVulnerabilityException.ps1 (GET)}
              [X]         vulnerability_exceptions/{id}/{status}                                     {Update-NexposeVulnerabilityException.ps1 (POST)}
    [~]  [X]              vulnerability_exceptions/{id}/expires                                      {[~] Get-NexposeVulnerabilityException.ps1 (GET), Update-NexposeVulnerabilityException.ps1 (PUT)}
    [X]                   vulnerability_references                                                   {Get-NexposeVulnerabilityReference.ps1 (GET)}
    [X]                   vulnerability_references/{id}                                              {Get-NexposeVulnerabilityReference.ps1 (GET)}
    [X]                   vulnerability_references/{id}/vulnerabilities                              {Get-NexposeVulnerabilityReference.ps1 (GET)}
    ---- ---- ---- ------ -------------------                                                        -------
    100% 88%  91%  100%   Percentage Complete


     [X]  277  Done
     [ ]    8  Todo
     [!]    0  RequiresWork
     [~]   59  Skipped
     [@]   10  Bugs
     ---  ---  -------
          354  Total


`ReqWork` are endpoints that require extra work or need to be re-written

`Skipped` API endpoints are ones that are duplicated elsewhere

