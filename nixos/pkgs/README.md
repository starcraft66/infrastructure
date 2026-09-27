# OpenBao Agent PKI renewal patch

OpenBao Agent embeds OpenBao Template. The template fork lacks Vault's configurable `pkiCert` renewal timing until [openbao-template PR #9](https://github.com/openbao/openbao-template/pull/9) lands, and Agent also needs to pass `template_config.lease_renewal_threshold` to the template runner. This overlay pins that PR and patches the Agent wiring; our `0.66` setting then controls PKI certificate rotation.

When upgrading OpenBao, if `openbao-agent-pki-threshold.patch` no longer applies, inspect the new Agent `TemplateConfig` and template-runner config code. Rebase the patch to add `lease_renewal_threshold` to the config struct and forward it to `conf.Vault.LeaseRenewalThreshold`. The Agent sources moved from `command/agent/...` in 2.6 to `internal/command/agent/...` in 2.7; update the patch paths and context accordingly. Check application with `patch --dry-run` against the new source, and update the package/template pin as needed.
