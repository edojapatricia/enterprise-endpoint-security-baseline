# Microsoft Defender Antivirus baseline

| Setting | Recommended intent |
|---|---|
| Real-time protection | Enabled |
| Antivirus service | Running and healthy |
| Signatures | Updated according to organisational SLA |
| Cloud-delivered protection | Enabled where licensed and permitted |
| Tamper protection | Managed centrally where supported |
| Exclusions | Minimal, approved and reviewed |

Apply with Intune Antivirus policy or supported Defender management tools. `Get-MpComputerStatus` is a local verification source, not proof of tenant policy assignment.
