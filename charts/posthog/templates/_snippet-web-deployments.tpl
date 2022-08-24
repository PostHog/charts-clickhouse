{{/*

    Defines a lifecycle command to be used by web traffic serving deployments.
    This will delay the sending of the TERM signal

    To achieve zero downtime deploys, we introduce a delay between Pod
    delete request and sending the TERM signal to Gunicorn. Gunicorn
    will gracefully complete in-flight requests with a TERM signal,
    but removal from Kubernetes endpoints will not be instant, so
    there will be some requests reaching Gunicorn after shutdown has
    been initiated. Gunicorn will reject any requests that come in
    after shutdown is initiated resulting in 502s reported by the
    ingress controller.

    The delay here will be proceeded by kubelet sending a TERM signal
    to process 1.

*/}}
{{- define "snippet.web-deployments.lifecycle" -}}
lifecycle:
    preStop:
        exec:
            command: [
                "sh", "-c",
                "(echo '{\"event\": \"preStop_started\"}'; sleep 10; echo '{\"event\": \"preStop_ended\"}') > /proc/1/fd/1"
            ]
{{- end -}}


{{/*

    Set a grace period that is 10 seconds delay (from
    lifecycle.exec.preStop) + 30 seconds for Gunicorn to gracefully shutdown
    + 5 seconds leeway

*/}}
{{- define "snippet.web-deployments.terminationGracePeriodSeconds" -}}
45
{{- end -}}
