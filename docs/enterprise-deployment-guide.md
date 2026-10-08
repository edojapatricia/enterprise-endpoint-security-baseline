# Enterprise endpoint security deployment guide

## Scope and safeguards
Windows 10/11 Enterprise or Pro managed endpoints. Pilot first on representative devices; obtain change approval, confirm licensing, backup and recovery procedures, and use Intune or Group Policy as the authoritative configuration plane. This repository provides **sample configuration guidance and read-only verification**, not an unattended production rollout.

## 1. Prerequisites
- Record device ownership, OS/build, TPM status, Entra ID/domain join, management authority and local administrator access.
- Confirm supported Microsoft Defender, BitLocker and Windows Firewall capabilities and conflicts with third-party endpoint protection.
- Confirm device backup and recovery-key escrow policy **before** enabling encryption. Never print, commit or email recovery passwords.
- Establish pilot group, baseline exceptions, maintenance window, service owner and rollback plan.

## 2. BitLocker
- Intune: Endpoint security > Disk encryption > create Windows BitLocker policy; select OS-drive encryption method and require recovery key backup to Microsoft Entra ID before enablement where supported.
- Configure startup authentication and silent-enablement eligibility to match TPM, user interaction and organisational requirements.
- For domain-joined devices, use approved Group Policy recovery escrow to AD DS and verify successful backup.
- Do not enforce encryption until key escrow has been independently verified.
- Verify using `Get-BitLockerVolume` and `manage-bde -status`. Protectors and recovery-key material must not be exported into logs.

## 3. Microsoft Defender
- Intune: Endpoint security > Antivirus > Windows profile; enable real-time protection, cloud-delivered protection, behaviour monitoring and signature updates where supported.
- Configure tamper protection in the supported Defender management portal. Do not attempt to bypass tamper protection using scripts.
- Configure exclusions only when approved and documented; avoid blanket folder or process exclusions.
- Verify with `Get-MpComputerStatus`; check health, signature age and real-time protection.

## 4. Windows Firewall
- Intune: Endpoint security > Firewall > Windows profile; enable Domain, Private and Public profiles, retain inbound block by default and document narrowly scoped exceptions.
- Test line-of-business applications, VPN and remote support in the pilot before wider rollout.
- Verify using `Get-NetFirewallProfile`; record disabled profiles as noncompliant.

## 5. Compliance and rollout
- Intune: Devices > Compliance policies > Windows; define minimum OS version, encryption, secure boot and threat protection requirements based on supported platform signals.
- Set realistic grace periods and integrate Conditional Access only after evaluating exclusion groups and break-glass access.
- Deploy in rings: lab -> pilot -> staged production; monitor device check-in, policy conflicts, encryption escrow, Defender health and firewall connectivity.
- Run `scripts/Test-EndpointSecurityBaseline.ps1 -OutputPath .\baseline-results.json` locally with PowerShell 5.1+ and appropriate permissions. JSON excludes recovery secrets.
- Investigate failed checks; do not interpret a single local script as proof of Intune compliance or deployment success.

## 6. Validation and rollback
- Verify policy assignment, device sync, escrow records, security posture, application access and audit evidence.
- Roll back the **management policy assignment or approved configuration** through the management plane; do not automatically decrypt disks, disable Defender or open firewall profiles.
- Document change ticket, policy versions, exceptions, approvals, observed results and owner sign-off.

## Evidence integrity
Screenshots and reports must reflect actual device state and dated test results. Do not present sample scripts or policies as proof of a completed enterprise deployment.
