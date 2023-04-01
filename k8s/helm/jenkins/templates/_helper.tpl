{{- define "docker_config" -}}
{{ $auth := printf "%s:%s" .Values.docker.dockerHubUser .Values.docker.dockerHubPassword }}
auths:
  "https://index.docker.io/v1/":
    auth: {{ $auth | b64enc }}
{{- end -}}
