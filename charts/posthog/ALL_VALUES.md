# PostHog Helm chart configuration

![Version: 23.1.0](https://img.shields.io/badge/Version-23.1.0-informational?style=flat-square) ![AppVersion: 1.36.1](https://img.shields.io/badge/AppVersion-1.36.1-informational?style=flat-square)

## Configuration

The following table lists the configurable parameters of the PostHog chart and their default values.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cloud | string | `nil` | Cloud service being deployed on (example: `aws`, `azure`, `do`, `gcp`, `other`). |
| notificationEmail | string | `nil` | Notification email for notifications to be sent to from the PostHog stack |
| image.repository | string | `"posthog/posthog"` | PostHog image repository to use. |
| image.sha | string | `nil` | PostHog image SHA to use (example: `sha256:20af35fca6756d689d6705911a49dd6f2f6631e001ad43377b605cfc7c133eb4`). |
| image.tag | string | `nil` | PostHog image tag to use (example: `release-1.35.0`). |
| image.default | string | `":release-1.36.1"` | PostHog default image. Do not overwrite, use `image.sha` or `image.tag` instead. |
| image.pullPolicy | string | `"IfNotPresent"` | PostHog image pull policy. |
| sentryDSN | string | `nil` | Sentry endpoint to send errors to. |
| posthogSecretKey.existingSecret | string | `nil` | Specify that the key should be pulled from an existing secret key. By default the chart will generate a secret and create a Kubernetes Secret containing it. |
| posthogSecretKey.existingSecretKey | string | `"posthog-secret"` | Specify the key within the secret from which SECRET_KEY should be taken. |
| env | list | `[]` | Environment variables to inject into every PostHog deployment. |
| migrate.enabled | bool | `true` | Whether to install the PostHog migrate job or not. |
| events.enabled | bool | `true` | Whether to install the PostHog events stack or not. |
| events.replicacount | int | `1` | Count of events pods to run. This setting is ignored if `events.hpa.enabled` is set to `true`. |
| events.hpa.enabled | bool | `false` | Whether to create a HorizontalPodAutoscaler for the events stack. |
| events.hpa.cputhreshold | int | `60` | CPU threshold percent for the events stack HorizontalPodAutoscaler. |
| events.hpa.minpods | int | `1` | Min pods for the events stack HorizontalPodAutoscaler. |
| events.hpa.maxpods | int | `10` | Max pods for the events stack HorizontalPodAutoscaler. |
| events.securityContext | object | `{"enabled":false}` | Container security context for the events stack HorizontalPodAutoscaler. |
| events.podSecurityContext | object | `{"enabled":false}` | Pod security context for the events stack HorizontalPodAutoscaler. |
| web.enabled | bool | `true` | Whether to install the PostHog web stack or not. |
| web.replicacount | int | `1` | Count of web pods to run. This setting is ignored if `web.hpa.enabled` is set to `true`. |
| web.hpa.enabled | bool | `false` | Whether to create a HorizontalPodAutoscaler for the web stack. |
| web.hpa.cputhreshold | int | `60` | CPU threshold percent for the web stack HorizontalPodAutoscaler. |
| web.hpa.minpods | int | `1` | Min pods for the web stack HorizontalPodAutoscaler. |
| web.hpa.maxpods | int | `10` | Max pods for the web stack HorizontalPodAutoscaler. |
| web.resources | object | `{}` | Resource limits for web service. |
| web.env | list | `[{"name":"SOCIAL_AUTH_GOOGLE_OAUTH2_KEY","value":null},{"name":"SOCIAL_AUTH_GOOGLE_OAUTH2_SECRET","value":null},{"name":"SOCIAL_AUTH_GOOGLE_OAUTH2_WHITELISTED_DOMAINS","value":"posthog.com"}]` | Additional env variables to inject into the web stack deployment. |
| web.env[0] | object | `{"name":"SOCIAL_AUTH_GOOGLE_OAUTH2_KEY","value":null}` | Set google oauth 2 key. Requires posthog ee license. |
| web.env[1] | object | `{"name":"SOCIAL_AUTH_GOOGLE_OAUTH2_SECRET","value":null}` | Set google oauth 2 secret. Requires posthog ee license. |
| web.env[2] | object | `{"name":"SOCIAL_AUTH_GOOGLE_OAUTH2_WHITELISTED_DOMAINS","value":"posthog.com"}` | Set google oauth 2 whitelisted domains users can log in from. |
| web.internalMetrics.capture | bool | `true` | Whether to capture information on operation of posthog into posthog, exposed in /instance/status page |
| web.nodeSelector | object | `{}` | Node labels for web stack deployment. |
| web.tolerations | list | `[]` | Toleration labels for web stack deployment. |
| web.affinity | object | `{}` | Affinity settings for web stack deployment. |
| web.secureCookies | bool | `true` |  |
| web.livenessProbe.failureThreshold | int | `5` | The liveness probe failure threshold |
| web.livenessProbe.initialDelaySeconds | int | `50` | The liveness probe initial delay seconds |
| web.livenessProbe.periodSeconds | int | `10` | The liveness probe period seconds |
| web.livenessProbe.successThreshold | int | `1` | The liveness probe success threshold |
| web.livenessProbe.timeoutSeconds | int | `2` | The liveness probe timeout seconds |
| web.readinessProbe.failureThreshold | int | `10` | The readiness probe failure threshold |
| web.readinessProbe.initialDelaySeconds | int | `50` | The readiness probe initial delay seconds |
| web.readinessProbe.periodSeconds | int | `10` | The readiness probe period seconds |
| web.readinessProbe.successThreshold | int | `1` | The readiness probe success threshold |
| web.readinessProbe.timeoutSeconds | int | `2` | The readiness probe timeout seconds |
| web.securityContext | object | `{"enabled":false}` | Container security context for web stack deployment. |
| web.podSecurityContext | object | `{"enabled":false}` | Pod security context for web stack deployment. |
| worker.enabled | bool | `true` | Whether to install the PostHog worker stack or not. |
| worker.replicacount | int | `1` | Count of worker pods to run. This setting is ignored if `worker.hpa.enabled` is set to `true`. |
| worker.hpa.enabled | bool | `false` | Whether to create a HorizontalPodAutoscaler for the worker stack. |
| worker.hpa.cputhreshold | int | `60` | CPU threshold percent for the worker stack HorizontalPodAutoscaler. |
| worker.hpa.minpods | int | `1` | Min pods for the worker stack HorizontalPodAutoscaler. |
| worker.hpa.maxpods | int | `10` | Max pods for the worker stack HorizontalPodAutoscaler. |
| worker.env | list | `[]` | Additional env variables to inject into the worker stack deployment. |
| worker.resources | object | `{}` | Resource limits for the worker stack deployment. |
| worker.nodeSelector | object | `{}` | Node labels for the worker stack deployment. |
| worker.tolerations | list | `[]` | Toleration labels for the worker stack deployment. |
| worker.affinity | object | `{}` | Affinity settings for the worker stack deployment. |
| worker.securityContext | object | `{"enabled":false}` | Container security context for the worker stack deployment. |
| worker.podSecurityContext | object | `{"enabled":false}` | Pod security context for the worker stack deployment. |
| plugins.enabled | bool | `true` | Whether to install the PostHog plugin-server stack or not. This service handles data ingestion into ClickHouse, running apps and async jobs. See `pluginsAsync` to scale this separately. |
| plugins.replicacount | int | `1` | Count of plugin-server pods to run. This setting is ignored if `plugins.hpa.enabled` is set to `true`. |
| plugins.hpa.enabled | bool | `false` | Whether to create a HorizontalPodAutoscaler for the plugin stack. |
| plugins.hpa.cputhreshold | int | `60` | CPU threshold percent for the plugin-server stack HorizontalPodAutoscaler. |
| plugins.hpa.minpods | int | `1` | Min pods for the plugin-server stack HorizontalPodAutoscaler. |
| plugins.hpa.maxpods | int | `10` | Max pods for the plugin-server stack HorizontalPodAutoscaler. |
| plugins.env | list | `[]` | Additional env variables to inject into the plugin-server stack deployment. |
| plugins.resources | object | `{}` | Resource limits for the plugin-server stack deployment. |
| plugins.nodeSelector | object | `{}` | Node labels for the plugin-server stack deployment. |
| plugins.tolerations | list | `[]` | Toleration labels for the plugin-server stack deployment. |
| plugins.affinity | object | `{}` | Affinity settings for the plugin-server stack deployment. |
| plugins.securityContext | object | `{"enabled":false}` | Container security context for the plugin-server stack deployment. |
| plugins.podSecurityContext | object | `{"enabled":false}` | Pod security context for the plugin-server stack deployment. |
| plugins.livenessProbe.failureThreshold | int | `3` | The liveness probe failure threshold |
| plugins.livenessProbe.initialDelaySeconds | int | `10` | The liveness probe initial delay seconds |
| plugins.livenessProbe.periodSeconds | int | `10` | The liveness probe period seconds |
| plugins.livenessProbe.successThreshold | int | `1` | The liveness probe success threshold |
| plugins.livenessProbe.timeoutSeconds | int | `2` | The liveness probe timeout seconds |
| plugins.readinessProbe.failureThreshold | int | `3` | The readiness probe failure threshold |
| plugins.readinessProbe.initialDelaySeconds | int | `50` | The readiness probe initial delay seconds |
| plugins.readinessProbe.periodSeconds | int | `30` | The readiness probe period seconds |
| plugins.readinessProbe.successThreshold | int | `1` | The readiness probe success threshold |
| plugins.readinessProbe.timeoutSeconds | int | `5` | The readiness probe timeout seconds |
| pluginsAsync.enabled | bool | `false` | Whether to install the PostHog plugin-server async stack or not. If disabled (default), plugins service handles both ingestion and running of async tasks. Allows for separate scaling of this service. |
| pluginsAsync.replicacount | int | `1` | Count of plugin-server-async pods to run. This setting is ignored if `pluginsAsync.hpa.enabled` is set to `true`. |
| pluginsAsync.hpa.enabled | bool | `false` | Whether to create a HorizontalPodAutoscaler for the plugin stack. |
| pluginsAsync.hpa.cputhreshold | int | `60` | CPU threshold percent for the plugin-server stack HorizontalPodAutoscaler. |
| pluginsAsync.hpa.minpods | int | `1` | Min pods for the plugin-server stack HorizontalPodAutoscaler. |
| pluginsAsync.hpa.maxpods | int | `10` | Max pods for the plugin-server stack HorizontalPodAutoscaler. |
| pluginsAsync.env | list | `[]` | Additional env variables to inject into the plugin-server stack deployment. |
| pluginsAsync.resources | object | `{}` | Resource limits for the plugin-server stack deployment. |
| pluginsAsync.nodeSelector | object | `{}` | Node labels for the plugin-server stack deployment. |
| pluginsAsync.tolerations | list | `[]` | Toleration labels for the plugin-server stack deployment. |
| pluginsAsync.affinity | object | `{}` | Affinity settings for the plugin-server stack deployment. |
| pluginsAsync.securityContext | object | `{"enabled":false}` | Container security context for the plugin-server stack deployment. |
| pluginsAsync.podSecurityContext | object | `{"enabled":false}` | Pod security context for the plugin-server stack deployment. |
| pluginsAsync.livenessProbe.failureThreshold | int | `3` | The liveness probe failure threshold |
| pluginsAsync.livenessProbe.initialDelaySeconds | int | `10` | The liveness probe initial delay seconds |
| pluginsAsync.livenessProbe.periodSeconds | int | `10` | The liveness probe period seconds |
| pluginsAsync.livenessProbe.successThreshold | int | `1` | The liveness probe success threshold |
| pluginsAsync.livenessProbe.timeoutSeconds | int | `2` | The liveness probe timeout seconds |
| pluginsAsync.readinessProbe.failureThreshold | int | `3` | The readiness probe failure threshold |
| pluginsAsync.readinessProbe.initialDelaySeconds | int | `50` | The readiness probe initial delay seconds |
| pluginsAsync.readinessProbe.periodSeconds | int | `30` | The readiness probe period seconds |
| pluginsAsync.readinessProbe.successThreshold | int | `1` | The readiness probe success threshold |
| pluginsAsync.readinessProbe.timeoutSeconds | int | `5` | The readiness probe timeout seconds |
| email.host | string | `nil` | SMTP service host. |
| email.port | string | `nil` | SMTP service port. |
| email.user | string | `nil` | SMTP service user. |
| email.password | string | `nil` | SMTP service password. |
| email.existingSecret | string | `""` | Name of an existing Kubernetes secret object containing the SMTP service password. |
| email.existingSecretKey | string | `""` | Name of the key pointing to the password in your Kubernetes secret. |
| email.use_tls | bool | `true` | Use TLS to authenticate to the SMTP service. |
| email.use_ssl | string | `nil` | Use SSL to authenticate to the SMTP service. |
| email.from_email | string | `nil` | Outbound email sender to use. |
| saml.enforced | bool | `false` | Whether password-based login is disabled and users automatically redirected to SAML login. Requires SAML to be properly configured. |
| saml.disabled | bool | `false` | Whether SAML should be completely disabled. If set at build time, this will also prevent SAML dependencies from being installed. |
| saml.entity_id | string | `nil` | Entity ID from your SAML IdP. entity_id: "id-from-idp-5f9d4e-47ca-5080" |
| saml.acs_url | string | `nil` | Assertion Consumer Service URL from your SAML IdP. acs_url: "https://mysamlidp.com/saml2" |
| saml.x509_cert | string | `nil` | Public X509 certificate from your SAML IdP to validate SAML assertions x509_cert: | MIID3DCCAsSgAwIBAgIUdriHo8qmAU1I0gxsI7cFZHmna38wDQYJKoZIhvcNAQEF BQAwRTEQMA4GA1UECgwHUG9zdEhvZzEVMBMGA1UECwwMT25lTG9naW4gSWRQMRow GAYDVQQDDBFPbmVMb2dpbiBBY2NvdW50IDAeFw0yMTA4MTYyMTUyMzNaFw0yNjA4 MTYyMTUyMzNaMEUxEDAOBgNVBAoMB1Bvc3RIb2cxFTATBgNVBAsMDE9uZUxvZ2lu IElkUDEaMBgGA1UEAwwRT25lTG9naW4gQWNjb3VudCAwggEiMA0GCSqGSIb3DQEB AQUAA4IBDwAwggEKAoIBAQDEfUWFIU38ztF2EgijVsIbnlB8OIwkjZU8c34B9VwZ BQQUSxbrkuT9AX/5O27G04TBCHFZsXRId+ABSjVo8daCPu0d38Quo9KS3V3627Nw YcTYsje95lB02E/PgfiEQ6ZGCOV0P4xY9C99d26PoYTcoMT1S73jDDMOFtoD5WXG ZsKqwBks1jbLkv6RYoFBlZX00aGzOXDzUXI59/0c15KR4EzgTad0t6CU7X0HZ2Qf xGUiRb7hDLvgSby0SzpQpYUyYDnN9aSNYzpu1hiyIqrhQ7kZNy7LyGBz0UIuIImF pF6A3bzzrR4wdacFY9U0vmqFXXcepxuT5p2UyAxwbLeDAgMBAAGjgcMwgcAwDAYD VR0TAQH/BAIwADAdBgNVHQ4EFgQURLVVKanZPoXGEfYr1HmlaCEoD54wgYAGA1Ud IwR5MHeAFES1VSmp2T6FxhH2K9R5pWghKA+eoUmkRzBFMRAwDgYDVQQKDAdQb3N0 SG9nMRUwEwYDVQQLDAxPbmVMb2dpbiBJZFAxGjAYBgNVBAMMEU9uZUxvZ2luIEFj Y291bnQgghR2uIejyqYBTUjSDGwjtwVkeadrfzAOBgNVHQ8BAf8EBAMCB4AwDQYJ KoZIhvcNAQEFBQADggEBALP5lhlcV8avbnVnqO7PBtlS2mVOJ2B7obm50OaJCbRh t0I/dcNssWhT31/zmtNfKtrFicNImlKhdirApxpIp1WLEFY01a40GLmO6FG/WVvB EzwXonWP+cP8jYQnqZ15JkuHjP3DYJuOak2GqAJAfaGO67q6IkRZzRq6UwEUgNJD TlcsJAFaJDrcw07TY3mRFragdzGC7Xt/CM6r/0seY3+VBwMUMiJlvawcyQxap7om EdgmQkJA8Dk6f+geI+U7jV3orkPiofBJi9K6cp5Fd9usut8jwi3GYg2wExNGbhF4 wlMD1LOhymQGBnTXPk+000nkBnYdqEnqXzVpDiCG1Pc= |
| saml.attr_permanent_id | string | `nil` | Name of attribute that contains the permanent ID of the user in SAML assertions. attr_permanent_id: "nameID" |
| saml.attr_first_name | string | `nil` | Name of attribute that contains the first name of the user in SAML assertions. attr_first_name: "firstName" |
| saml.attr_last_name | string | `nil` | Name of attribute that contains the last name of the user in SAML assertions. attr_last_name: "lastName" |
| saml.attr_email | string | `nil` | Name of attribute that contains the email of the user in SAML assertions. attr_email: "email" |
| service.name | string | `"posthog"` | PostHog service name. |
| service.type | string | `"NodePort"` | PostHog service type. |
| service.externalPort | int | `8000` |  |
| service.internalPort | int | `8000` |  |
| service.annotations | object | `{}` | PostHog service annotations. |
| cert-manager.enabled | bool | `false` | Whether to install `cert-manager` resources. |
| cert-manager.installCRDs | bool | `true` | Whether to install `cert-manager` CRDs. |
| cert-manager.email | string | `nil` | Base default is noreply@<your-ingress-hostname> |
| cert-manager.podDnsPolicy | string | `"None"` |  |
| cert-manager.podDnsConfig.nameservers[0] | string | `"8.8.8.8"` |  |
| cert-manager.podDnsConfig.nameservers[1] | string | `"1.1.1.1"` |  |
| cert-manager.podDnsConfig.nameservers[2] | string | `"208.67.222.222"` |  |
| ingress.enabled | bool | `true` | Enable ingress controller resource |
| ingress.type | string | `nil` | Ingress handler type. Defaults to `nginx` if nginx is enabled and to `clb` on gcp. |
| ingress.hostname | string | `nil` | URL to address your PostHog installation. You will need to set up DNS after installation |
| ingress.gcp.ip_name | string | `"posthog"` | Specifies the name of the global IP address resource to be associated with the google clb |
| ingress.gcp.forceHttps | bool | `true` | If true, will force a https redirect when accessed over http |
| ingress.gcp.secretName | string | `""` | Specifies the name of the tls secret to be used by the ingress. If not specified a managed certificate will be generated. |
| ingress.letsencrypt | string | `nil` | Whether to enable letsencrypt. Defaults to true if hostname is defined and nginx and cert-manager are enabled otherwise false. |
| ingress.nginx.enabled | bool | `false` | Whether nginx is enabled |
| ingress.nginx.redirectToTLS | bool | `true` | Whether to redirect to TLS with nginx ingress. |
| ingress.annotations | object | `{}` | Extra annotations |
| ingress.secretName | string | `nil` | TLS secret to be used by the ingress. |
| ingress-nginx.controller.config.use-forwarded-headers | string | `"true"` | [ingress-nginx documentation](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/configmap/#use-forwarded-headers) |
| postgresql.enabled | bool | `true` | Whether to deploy a PostgreSQL server to satisfy the applications requirements. To use an external PostgreSQL instance set this to `false` and configure the `externalPostgresql` parameters. |
| postgresql.nameOverride | string | `"posthog-postgresql"` | Name override for PostgreSQL app. |
| postgresql.postgresqlDatabase | string | `"posthog"` | PostgreSQL database name. |
| postgresql.postgresqlPassword | string | `"postgres"` | PostgreSQL database password. |
| postgresql.persistence.enabled | bool | `true` | Enable persistence using PVC. |
| postgresql.persistence.size | string | `"10Gi"` | PVC Storage Request for PostgreSQL volume. |
| externalPostgresql.postgresqlHost | string | `nil` | External PostgreSQL service host. |
| externalPostgresql.postgresqlPort | int | `5432` | External PostgreSQL service port. |
| externalPostgresql.postgresqlDatabase | string | `nil` | External PostgreSQL service database name. |
| externalPostgresql.postgresqlUsername | string | `nil` | External PostgreSQL service user. |
| externalPostgresql.postgresqlPassword | string | `nil` | External PostgreSQL service password. Either this or `externalPostgresql.existingSecret` must be set. |
| externalPostgresql.existingSecret | string | `nil` | Name of an existing Kubernetes secret object containing the PostgreSQL password |
| externalPostgresql.existingSecretPasswordKey | string | `"postgresql-password"` | Name of the key pointing to the password in your Kubernetes secret |
| pgbouncer.enabled | bool | `true` | Whether to deploy a PgBouncer service to satisfy the applications requirements. |
| pgbouncer.hpa.enabled | bool | `false` | Adding pgbouncers can cause running out of connections for Postgres |
| pgbouncer.hpa.cputhreshold | int | `60` | CPU threshold percent for pgbouncer |
| pgbouncer.hpa.minpods | int | `1` | Min pods for pgbouncer |
| pgbouncer.hpa.maxpods | int | `10` | Max pods for pgbouncer |
| pgbouncer.replicacount | int | `1` | How many replicas of pgbouncer to run. Ignored if hpa is used |
| pgbouncer.env | list | `[]` | Additional env vars to be added to the pgbouncer deployment |
| pgbouncer.extraVolumeMounts | list | `[]` | Additional volumeMounts to be added to the pgbouncer deployment |
| pgbouncer.extraVolumes | list | `[]` | Additional volumes to be added to the pgbouncer deployment |
| pgbouncer.securityContext | object | `{"enabled":false}` | Container security context for the pgbouncer deployment |
| pgbouncer.podSecurityContext | object | `{"enabled":false}` | Pod security context for the pgbouncer deployment |
| redis.enabled | bool | `true` | Whether to deploy a Redis server to satisfy the applications requirements. To use an external redis instance set this to `false` and configure the `externalRedis` parameters. |
| redis.nameOverride | string | `"posthog-redis"` |  |
| redis.fullnameOverride | string | `""` |  |
| redis.architecture | string | `"standalone"` |  |
| redis.auth.enabled | bool | `false` | Enable Redis password authentication. |
| redis.auth.password | string | `""` | Redis password.    Defaults to a random 10-character alphanumeric string if not set.    NOTE: ignored unless `redis.auth.enabled` is `true` or if `redis.auth.existingSecret` is set. |
| redis.auth.existingSecret | string | `""` | The name of an existing secret containing the Redis credential to use.    NOTE: ignored unless `redis.auth.enabled` is `true`.          When it is set, the previous `redis.auth.password` parameter is ignored. |
| redis.auth.existingSecretPasswordKey | string | `""` | Password key to be retrieved from existing secret.    NOTE: ignored unless `redis.auth.existingSecret` parameter is set. |
| redis.master.persistence.enabled | bool | `true` | Enable data persistence using PVC. |
| redis.master.persistence.size | string | `"5Gi"` | Persistent Volume size. |
| redis.master.extraFlags | list | `["--maxmemory 400mb","--maxmemory-policy allkeys-lru"]` | Array with additional command line flags for Redis master. |
| externalRedis.host | string | `""` | External Redis host to use. |
| externalRedis.port | int | `6379` | External Redis port to use. |
| externalRedis.password | string | `""` | Password for the external Redis. Ignored if `externalRedis.existingSecret` is set. |
| externalRedis.existingSecret | string | `""` | Name of an existing Kubernetes secret object containing the Redis password. |
| externalRedis.existingSecretPasswordKey | string | `""` | Name of the key pointing to the password in your Kubernetes secret. |
| kafka.enabled | bool | `true` | Whether to deploy Kafka as part of this release. To use an external Kafka instance set this to `false` and configure the `externalKafka` values. |
| kafka.nameOverride | string | `"posthog-kafka"` |  |
| kafka.fullnameOverride | string | `""` |  |
| kafka.logRetentionBytes | string | `"_15_000_000_000"` | A size-based retention policy for logs. |
| kafka.logRetentionHours | int | `24` | The minimum age of a log file to be eligible for deletion due to age. |
| kafka.numPartitions | int | `1` | The default number of log partitions per topic. |
| kafka.persistence.enabled | bool | `true` |  |
| kafka.persistence.size | string | `"20Gi"` | PVC Storage Request for Kafka data volume. |
| kafka.zookeeper.enabled | bool | `false` | Switch to enable or disable the ZooKeeper helm chart. !!! Please DO NOT override this (this chart installs Zookeeper separately) !!! |
| kafka.externalZookeeper.servers | list | `["posthog-posthog-zookeeper:2181"]` | List of external zookeeper servers to use. |
| externalKafka.brokers | list | `[]` |  |
| zookeeper.enabled | bool | `true` | Whether to deploy Zookeeper as part of this release. |
| zookeeper.nameOverride | string | `"posthog-zookeeper"` |  |
| zookeeper.replicaCount | int | `1` | Number of ZooKeeper nodes |
| zookeeper.autopurge.purgeInterval | int | `1` | The time interval (in hours) for which the purge task has to be triggered |
| zookeeper.metrics.enabled | bool | `false` | Enable Prometheus to access ZooKeeper metrics endpoint. |
| zookeeper.metrics.service.annotations."prometheus.io/scrape" | string | `"false"` |  |
| zookeeper.podAnnotations | string | `nil` |  |
| clickhouse.enabled | bool | `true` | Whether to install clickhouse. If false, `clickhouse.host` must be set |
| clickhouse.namespace | string | `nil` | Which namespace to install clickhouse and the `clickhouse-operator` to (defaults to namespace chart is installed to) |
| clickhouse.cluster | string | `"posthog"` | Clickhouse cluster |
| clickhouse.database | string | `"posthog"` | Clickhouse database |
| clickhouse.user | string | `"admin"` | Clickhouse user |
| clickhouse.password | string | `"a1f31e03-c88e-4ca6-a2df-ad49183d15d9"` | Clickhouse password |
| clickhouse.secure | bool | `false` | Whether to use TLS connection connecting to ClickHouse |
| clickhouse.verify | bool | `false` | Whether to verify TLS certificate on connection to ClickHouse |
| clickhouse.image.repository | string | `"clickhouse/clickhouse-server"` | ClickHouse image repository. |
| clickhouse.image.tag | string | `"22.3.6.5"` | ClickHouse image tag. Note: PostHog does not support all versions of ClickHouse. Please override the default only if you know what you are doing. |
| clickhouse.tolerations | list | `[]` | Toleration labels for clickhouse pod assignment |
| clickhouse.affinity | object | `{}` | Affinity settings for clickhouse pod |
| clickhouse.resources | object | `{}` | Clickhouse resource requests/limits. See more at http://kubernetes.io/docs/user-guide/compute-resources/ |
| clickhouse.securityContext.enabled | bool | `true` |  |
| clickhouse.securityContext.runAsUser | int | `101` |  |
| clickhouse.securityContext.runAsGroup | int | `101` |  |
| clickhouse.securityContext.fsGroup | int | `101` |  |
| clickhouse.serviceType | string | `"ClusterIP"` | Kubernetes Service type. |
| clickhouse.allowedNetworkIps | list | `["10.0.0.0/8","172.16.0.0/12","192.168.0.0/16"]` | An allowlist of IP addresses or network masks the ClickHouse user is allowed to access from. By default anything within a private network will be allowed. This should suffice for most use case although to expose to other networks you will need to update this setting. For more details on usage, see https://posthog.com/docs/self-host/deploy/configuration#securing-clickhouse |
| clickhouse.persistence.enabled | bool | `true` | Enable data persistence using PVC. |
| clickhouse.persistence.existingClaim | string | `""` | Use a manually managed Persistent Volume and Claim.    If defined, PVC must be created manually before volume will be bound. |
| clickhouse.persistence.storageClass | string | `nil` | Persistent Volume Storage Class to use.    If defined, `storageClassName: <storageClass>`.    If set to `storageClassName: ""`, disables dynamic provisioning.    If undefined (the default) or set to `null`, no storageClassName spec is    set, choosing the default provisioner. |
| clickhouse.persistence.size | string | `"20Gi"` | Persistent Volume size |
| clickhouse.profiles | object | `{}` |  |
| clickhouse.defaultProfiles.default/allow_experimental_window_functions | string | `"1"` |  |
| clickhouse.defaultProfiles.default/allow_nondeterministic_mutations | string | `"1"` |  |
| clickhouse.layout.shardsCount | int | `1` |  |
| clickhouse.layout.replicasCount | int | `1` |  |
| clickhouse.settings | object | `{}` |  |
| clickhouse.defaultSettings.format_schema_path | string | `"/etc/clickhouse-server/config.d/"` |  |
| clickhouse.podAnnotations | string | `nil` |  |
| externalClickhouse.host | string | `nil` | Host of the external cluster. This is required when clickhouse.enabled is false |
| externalClickhouse.cluster | string | `nil` | Name of the external cluster to run DDL queries on. This is required when clickhouse.enabled is false |
| externalClickhouse.database | string | `"posthog"` | Database name for the external cluster |
| externalClickhouse.user | string | `nil` | User name for the external cluster to connect to the external cluster as |
| externalClickhouse.password | string | `nil` | Password for the cluster. Ignored if existingClickhouse.existingSecret is set |
| externalClickhouse.existingSecret | string | `nil` | Name of an existing Kubernetes secret object containing the password |
| externalClickhouse.existingSecretPasswordKey | string | `nil` | Name of the key pointing to the password in your Kubernetes secret |
| externalClickhouse.secure | bool | `false` | Whether to use TLS connection connecting to ClickHouse |
| externalClickhouse.verify | bool | `false` | Whether to verify TLS connection connecting to ClickHouse |
| cloudwatch.enabled | bool | `false` | Enable cloudwatch container insights to get logs and metrics on AWS |
| cloudwatch.region | string | `nil` | AWS region |
| cloudwatch.clusterName | string | `nil` | AWS EKS cluster name |
| cloudwatch.fluentBit | object | `{"port":2020,"readHead":"On","readTail":"Off","server":"On"}` | fluentBit configuration |
| hooks.affinity | object | `{}` | Affinity settings for hooks |
| hooks.migrate.env | list | `[]` | Env variables for migate hooks |
| hooks.migrate.resources | object | `{}` | Hook job resource limits/requests |
| serviceAccount.create | bool | `true` | Configures if a ServiceAccount with this name should be created |
| serviceAccount.name | string | `nil` | name of the ServiceAccount to be used by access-controlled resources. @default autogenerated |
| serviceAccount.annotations | object | `{}` | Configures annotation for the ServiceAccount |
| minio.enabled | bool | `false` | Whether to install MinIO (object storage system) or not. You can keep it disabled or rely on `externalObjectStorage` if you want to use a managed object storage service (AWS S3, Google Cloud Storage, ...). |
| minio.auth.rootUser | string | `"root-user"` | MinIO root username |
| minio.auth.rootPassword | string | `"root-password-change-me-please"` | MinIO root password |
| minio.auth.existingSecret | string | `nil` | Use existing secret for credentials details (`auth.rootUser` and `auth.rootPassword` will be ignored and picked up from this secret). The secret has to contain the keys `root-user` and `root-password`) |
| minio.persistence.enabled | bool | `true` | Enable MinIO data persistence using PVC. |
| minio.defaultBuckets | string | `"posthog"` | Comma, semi-colon or space separated list of buckets to create at initialization (only in standalone mode) |
| minio.disableWebUI | bool | `true` | Disable MinIO Web UI |
| minio.service.ports.api | string | `"19000"` | MinIO API service port |
| minio.service.ports.console | string | `"19001"` | MinIO Console service port |
| minio.podAnnotations | string | `nil` |  |
| externalObjectStorage.endpoint | string | `nil` | Endpoint of the external object storage. e.g. https://s3.us-east-1.amazonaws.com |
| externalObjectStorage.host | string | `nil` | Host of the external object storage. Deprecated: use endpoint instead |
| externalObjectStorage.port | string | `nil` | Port of the external object storage. Deprecated: use endpoint instead |
| externalObjectStorage.bucket | string | `nil` | Bucket name to use. |
| externalObjectStorage.existingSecret | string | `nil` | Name of an existing Kubernetes secret object containing the `access_key_id` and `secret_access_key`. The secret has to contain the keys `root-user` and `root-password`). |
| grafana.enabled | bool | `false` | Whether to install Grafana or not. |
| grafana.sidecar | object | `{"dashboards":{"enabled":true,"folderAnnotation":"grafana_folder","label":"grafana_dashboard","provider":{"foldersFromFilesStructure":true}}}` | Sidecar configuration to automagically pull the dashboards from the `charts/posthog/grafana-dashboard` folder. See [official docs](https://github.com/grafana/helm-charts/blob/main/charts/grafana/README.md) for more info. |
| grafana.datasources | object | `{"datasources.yaml":{"apiVersion":1,"datasources":[{"access":"proxy","isDefault":true,"name":"Prometheus","type":"prometheus","url":"http://posthog-prometheus-server"},{"access":"proxy","isDefault":false,"name":"Loki","type":"loki","url":"http://posthog-loki:3100"}]}}` | Configure Grafana datasources. See [docs](http://docs.grafana.org/administration/provisioning/#datasources) for more info. |
| loki.enabled | bool | `false` | Whether to install Loki or not. |
| promtail.enabled | bool | `false` | Whether to install Promtail or not. |
| promtail.config.lokiAddress | string | `"http://posthog-loki:3100/loki/api/v1/push"` |  |
| prometheus.enabled | bool | `false` | Whether to enable a minimal prometheus installation for getting alerts/monitoring the stack |
| prometheus.alertmanager.enabled | bool | `true` | If false, alertmanager will not be installed |
| prometheus.alertmanager.resources | object | `{"limits":{"cpu":"100m"},"requests":{"cpu":"50m"}}` | alertmanager resource requests and limits |
| prometheus.kubeStateMetrics.enabled | bool | `true` | If false, kube-state-metrics sub-chart will not be installed |
| prometheus.nodeExporter.enabled | bool | `true` | If false, node-exporter will not be installed |
| prometheus.nodeExporter.resources | object | `{"limits":{"cpu":"100m","memory":"50Mi"},"requests":{"cpu":"50m","memory":"30Mi"}}` | node-exporter resource limits & requests |
| prometheus.pushgateway.enabled | bool | `false` | If false, pushgateway will not be installed |
| prometheus.alertmanagerFiles."alertmanager.yml" | object | `{"global":{},"receivers":[{"name":"default-receiver"}],"route":{"group_by":["alertname"],"receiver":"default-receiver"}}` | alertmanager configuration rules. See https://prometheus.io/docs/alerting/latest/configuration/ |
| prometheus.serverFiles."alerting_rules.yml" | object | `{"groups":[{"name":"PostHog alerts","rules":[{"alert":"PodDown","annotations":{"description":"Pod {{ $labels.kubernetes_pod_name }} in namespace {{ $labels.kubernetes_namespace }} down for more than 5 minutes.","summary":"Pod {{ $labels.kubernetes_pod_name }} down."},"expr":"up{job=\"kubernetes-pods\"} == 0","for":"1m","labels":{"severity":"alert"}},{"alert":"PodFrequentlyRestarting","annotations":{"description":"Pod {{$labels.namespace}}/{{$labels.pod}} was restarted {{$value}} times within the last hour","summary":"Pod is restarting frequently"},"expr":"increase(kube_pod_container_status_restarts_total[1h]) > 5","for":"10m","labels":{"severity":"warning"}},{"alert":"VolumeRemainingCapacityLowTest","annotations":{"description":"Persistent volume claim {{ $labels.persistentvolumeclaim }} disk usage is above 85% for past 5 minutes","summary":"Kubernetes {{ $labels.persistentvolumeclaim }} is full (host {{ $labels.kubernetes_io_hostname }})"},"expr":"kubelet_volume_stats_used_bytes/kubelet_volume_stats_capacity_bytes >= 0.85","for":"5m","labels":{"severity":"page"}}]}]}` | Alerts configuration, see https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/ |
| prometheus-statsd-exporter.enabled | bool | `false` | Whether to install the `prometheus-statsd-exporter` or not. |
| prometheus-statsd-exporter.podAnnotations | object | `{"prometheus.io/path":"/metrics","prometheus.io/port":"9102","prometheus.io/scrape":"true"}` | Map of annotations to add to the pods. |
| externalStatsd.host | string | `nil` | External Statsd host to use. |
| externalStatsd.port | string | `nil` | External Statsd port to use. |
| prometheus-kafka-exporter.enabled | bool | `false` | Whether to install the `prometheus-kafka-exporter` or not. |
| prometheus-kafka-exporter.image | object | `{"tag":"v1.4.2"}` | We want to pin to image tag `v1.4.2` as it is currently the only available version working on Apple M1 (otherwise we break local development). TODO: remove the override once `prometheus-kafka-exporter` will default to this version. |
| prometheus-kafka-exporter.annotations | object | `{"prometheus.io/path":"/metrics","prometheus.io/port":"9308","prometheus.io/scrape":"true"}` | Map of annotations to add to the pods. |
| prometheus-kafka-exporter.kafkaServer | list | `["posthog-posthog-kafka:9092"]` | Specify the target Kafka brokers to monitor. |
| prometheus-postgres-exporter.enabled | bool | `false` | Whether to install the `prometheus-postgres-exporter` or not. |
| prometheus-postgres-exporter.annotations | object | `{"prometheus.io/path":"/metrics","prometheus.io/port":"9187","prometheus.io/scrape":"true"}` | Map of annotations to add to the pods. |
| prometheus-postgres-exporter.config | object | `{"datasource":{"host":"posthog-posthog-postgresql","passwordSecret":{"key":"postgresql-password","name":"posthog-posthog-postgresql"},"user":"postgres"}}` | Configuration options. |
| prometheus-redis-exporter.enabled | bool | `false` | Whether to install the `prometheus-redis-exporter` or not. |
| prometheus-redis-exporter.annotations | object | `{"prometheus.io/path":"/metrics","prometheus.io/port":"9121","prometheus.io/scrape":"true"}` | Map of annotations to add to the pods. |
| prometheus-redis-exporter.redisAddress | string | `"redis://posthog-posthog-redis-master:6379"` | Specify the target Redis instance to monitor. |
| installCustomStorageClass | bool | `false` |  |
| busybox.image | string | `"busybox:1.34"` | Specify the image to use for e.g. init containers |

Dependent charts can also have values overwritten. For more info see our [docs](https://posthog.com/docs/self-host/deploy/configuration).

