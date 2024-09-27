{ final, prev, libfinal, libprev }:
{
  tdude.vault = rec {
    # mkRestartUnitPolkitRule = user: unit: ''
    #   polkit.addRule(function(action, subject) {
    #     if (action.id == "org.freedesktop.systemd1.manage-units" &&
    #       action.lookup("unit") == "${unit}.service" &&
    #       subject.isInGroup("mygroup")) {
    #       return polkit.Result.YES;
    #     }
    #   });
    # ''
    mkRestartServiceSudoersRule = user: servicesToRestart: {
      commands = map (service: { command = "${prev.systemd}/bin/systemctl restart ${service}"; options = [ "NOPASSWD" ]; }) servicesToRestart;
      users = [ user ];
    };
    # path: string, servicesToRestart: [string], template: partially-applied function, mkCertificateTemplate to be called with the writeDir argument
    mkVaultAgentTemplate = path: servicesToRestart: template: libprev.mkMerge [
      {
        destination = path;
        source = template (builtins.dirOf path);
        perms = "0600";
      }
      (libprev.mkIf (builtins.length servicesToRestart != 0) {
        # We need to create the appropriate sudo rule using mkRestartServiceSudoersRule defined above
        # for this to succeed
        command = "/run/wrappers/bin/sudo ${prev.systemd}/bin/systemctl restart ${libprev.concatStringsSep " " servicesToRestart}";
      })
    ];
    # component: string, role: string, templates: [{ destination: string, source: string }]
    mkVaultAgentInstance = component: role: vaultURL: vaultSNI: templates: {
      enable = true;
      user = component;
      group = component;
      settings = {
        auto_auth = [
          {
            method = [
              {
                config = [
                  {
                    remove_secret_id_file_after_reading = false;
                    role_id_file_path = "/var/lib/secrets/${component}/vault_agent_role_id";
                    secret_id_file_path = "/var/lib/secrets/${component}/vault_agent_secret_id";
                  }
                ];
                type = "approle";
              }
            ];
            sink = [
              {
                config = [
                  {
                    path = "/var/lib/secrets/${component}/vault_agent_token";
                  }
                ];
                type = "file";
              }
            ];
          }
        ];
        # cache = [
        #   {
        # https://github.com/hashicorp/vault/issues/19436
        # use_auto_auth_token = true;
        #   }
        # ];
        template = templates;
        pid_file = if role != null then "/var/lib/secrets/${component}/vault-agent-${component}-${role}.pid" else "/var/lib/secrets/${component}/vault-agent-${component}.pid";
        vault = [
          {
            address = vaultURL;
            tls_server_name = vaultSNI;
            ca_cert = "/etc/ssl/certs/vault-ca.pem";
          }
        ];
      };
    };
    mkCertificateTemplate = clusterName: component: pkiRole: name: commonName: altNames: ipSans: writeDir: prev.writeTextFile {
      name = "${component}-${name}-cert.ctmpl";
      text = ''
        {{- with pkiCert "${clusterName}/pki/${component}/issue/${pkiRole}" "ttl=768h" "common_name=${commonName}" ${if altNames != [] then "\"alt_names=${libprev.concatStringsSep "," altNames}\"" else ""} ${if ipSans != [] then "\"ip_sans=${libprev.concatStringsSep "," ipSans}\"" else ""} -}}
        {{ .Cert }}{{ .CA }}{{ .Key }}
        {{ .Key | writeToFile "${writeDir}/${name}-key.pem" "" "" "0600" }}
        {{ .CA | writeToFile "${writeDir}/${component}-ca.pem" "" "" "0640" }}
        {{ .Cert | writeToFile "${writeDir}/${name}.pem" "" "" "0640" }}
        {{- end -}}
      '';
    };
    mkUrlSafePkiRole = pkiRole: libprev.replaceStrings [ ":" ] [ "_" ] pkiRole;
    mkEtcdCertificateTemplate = clusterName: pkiRole: name: commonName: writeDir: mkCertificateTemplate clusterName "etcd" pkiRole name commonName [ ] [ ] writeDir;
    mkEtcdServerCertificateTemplate = clusterName: commonName: writeDir: mkEtcdCertificateTemplate clusterName "server" "server" commonName writeDir;
    mkEtcdClientCertificateTemplate = clusterName: commonName: writeDir: mkEtcdCertificateTemplate clusterName"client" "client" commonName writeDir;
    mkEtcdPeerCertificateTemplate = clusterName: commonName: writeDir: mkEtcdCertificateTemplate clusterName "peer" "peer" commonName writeDir;
    mkKubernetesCertificateTemplate = clusterName: name: spec: /*(pkiRole: commonName: altNames: ipSans:)*/ writeDir: mkCertificateTemplate clusterName "kubernetes" (mkUrlSafePkiRole spec.pkiRole) name spec.commonName spec.altNames spec.ipSans writeDir;
    mkFrontProxyCertificateTemplate = clusterName: pkiRole: name: commonName: writeDir: mkCertificateTemplate clusterName "front-proxy" pkiRole name commonName [ ] [ ] writeDir;
    mkFrontProxyClientCertificateTemplate = clusterName: commonName: writeDir: mkFrontProxyCertificateTemplate clusterName "client" "front-proxy-client" commonName writeDir;
  };
}
