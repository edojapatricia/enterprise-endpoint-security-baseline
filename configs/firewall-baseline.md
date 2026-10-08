# Windows Defender Firewall baseline

Enable Domain, Private and Public firewall profiles. Prefer blocking unsolicited inbound connections; allow only approved, scoped rules for business requirements. Test VPN, remote management and line-of-business applications in a pilot ring.

Use Intune Firewall policy or centrally managed GPO. Verify with `Get-NetFirewallProfile | Select-Object Name,Enabled,DefaultInboundAction,DefaultOutboundAction`. Avoid changing profiles automatically during assessment.
