# Verification scripts

Run on an authorised Windows endpoint in Windows PowerShell 5.1 or PowerShell 7 with Windows management modules available:

```powershell
.\scripts\Test-EndpointSecurityBaseline.ps1
.\scripts\Test-EndpointSecurityBaseline.ps1 -OutputPath .\baseline-results.json
```

Checks are read-only and return Pass, Fail or Unknown; Unknown is not compliant. Run with appropriate permissions. Reports include hostname and timestamp but **never recovery keys**; treat reports as internal operational data and redact hostnames before publication. This does not verify recovery-key escrow, cloud policy assignment, signature freshness or tenant compliance.
