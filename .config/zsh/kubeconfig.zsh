if [ -d ~/.kube/configs ]; then
  if [ -z "$KUBECONFIG_OVERRIDE" ]; then
    export KUBECONFIG=~/.kube/config$(find ~/.kube/configs -type f,l 2>/dev/null | xargs -I % echo -n ":%")
  else
    export KUBECONFIG=$KUBECONFIG_OVERRIDE
  fi
fi

# kubeconfig per session & init with context of last session if available
KUBECONFIG_LAST_CTX=`ls -t /tmp | grep kubectx | head -n 1`
KUBECONFIG_NEXT_CTX="$(mktemp -t "kubectx.XXXXXX")"
export KUBECONFIG="${KUBECONFIG_NEXT_CTX}:${KUBECONFIG}"
if [ -z "$KUBECONFIG_LAST_CTX" ]
then
     cat <<EOF >"${KUBECONFIG_NEXT_CTX}"
apiVersion: v1
kind: Config
current-context: ""
EOF
else
  cp "/tmp/${KUBECONFIG_LAST_CTX}" "${KUBECONFIG_NEXT_CTX}"
fi

# consider simple alternative:
# Build KUBECONFIG from multiple files in ~/.kube
# FILES=(~/.kube/*.conf); IFS=: eval 'export KUBECONFIG="${FILES[*]}"'
