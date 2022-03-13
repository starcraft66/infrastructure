{ pkgs, ... }:
let
  jq = pkgs.jq;
  kubectl = pkgs.kubectl;
in {
  minecraft-console = pkgs.writeShellScriptBin "minecraft-console" ''
    set -euo pipefail
    usage () {
      cat <<EOF${"\n" + ''
        Access a minecraft server hosted in kubernetes' console via RCON
        Usage:
          $(basename "$0") NAMESPACE
        Options:
          -h, --help      Print this help message
        Args:
          <NAMESPACE>: Kubernetes namespace hosting the minecraft server to connect to
      ''}EOF
    }
    if [ "$#" -eq 0 ]; then
        echo "Missing <NAMESPACE> argument"
        usage
        exit 1
    fi
    TEMP=$(${pkgs.getopt}/bin/getopt -s bash -o +vh --long help -n minecraft-console -- "$@")
    if [ $? -ne 0 ]; then
        usage
        exit 1
    fi
    eval set -- "$TEMP"
    unset TEMP
    VERBOSE=""
    while true; do
        case "$1" in
            '-h'|'--help') usage; exit 1;;
            '--') shift; break;;
            *) echo "$1"; usage; exit 1;;
        esac
    done
    shift $(($OPTIND - 1))
    NAMESPACE="$1"
    echo "Connecting to Minecraft console in namespace: $NAMESPACE..."
    # Use pod instead of sts since name is reliable and we get the IP
    POD=$(${kubectl}/bin/kubectl get pod -n cacaffichage minecraft-0 -o json)
    SECRET=$(echo $POD | ${jq}/bin/jq -r '.spec.containers[0].envFrom[].secretRef.name' | grep minecraft-secrets)
    RCON_IP=$(echo $POD | ${jq}/bin/jq -r '.status.podIP')
    RCON_PASSWORD=$(${kubectl}/bin/kubectl get secret $SECRET -n $NAMESPACE -o "jsonpath={.data.RCON_PASSWORD}" | base64 -d)
    ${pkgs.mcrcon}/bin/mcrcon -H $RCON_IP -p $RCON_PASSWORD
  '';
}