# BitLocker baseline (policy design)

| Setting | Recommended intent |
|---|---|
| OS drive encryption | Required on eligible managed devices |
| Recovery escrow | Required and verified before encryption |
| TPM | Confirm TPM readiness and approved startup authentication |
| Algorithm | XTS-AES 128 or 256 per organisational standard |
| Recovery access | Least privilege; audited retrieval |
| Exceptions | Document devices lacking prerequisites |

Use Intune Disk encryption or approved Group Policy. Never store recovery passwords in this repository. Check `Get-BitLockerVolume` and management-plane escrow separately.
