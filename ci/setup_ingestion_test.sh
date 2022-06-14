#!/usr/bin/env sh
#
# This script setup PostHog in DEV mode to do ingestion testing
#

sleep 10 # TODO: remove this. It was added as the command below often errors with 'unable to upgrade connection: container not found ("posthog-web")'

WEB_POD=$(kubectl get pods -n posthog -l role=web -o jsonpath="{.items[].metadata.name}")

kubectl exec "$WEB_POD" -n posthog -- python manage.py setup_dev --no-data --create-e2e-test-plugin

# :KLUDGE: Inline this setup script until 1.37.0 is out and `--create-e2e-test-plugin` does something.
echo << EOF
from django.utils.timezone import now

organization = Organization.objects.first()
team = organization.teams.first()
plugin = Plugin.objects.create(organization=organization, name="e2e test plugin", plugin_type="source")
plugin_config = PluginConfig.objects.create(plugin=plugin, team=team, order=1, config={})

PluginSourceFile.objects.update_or_create(
    plugin=plugin, filename="plugin.json", source='{ "name": "e2e test plugin", "config": [] }',
)
PluginSourceFile.objects.update_or_create(
    plugin=plugin, filename="index.ts", source="""
        export async function onEvent(event, meta) {
            const ratelimit = await meta.cache.get('ratelimit')
            if (!ratelimit && event.event !== '$pluginEvent') {
                posthog.capture('$pluginEvent', { event: event.event })
                await meta.cache.set('ratelimit', 1)
                await meta.cache.expire('ratelimit', 60)
            }
        }
    """,
)

plugin_config.enabled = True
plugin_config.save()
EOF | kubectl exec "$WEB_POD" -n posthog -- python manage.py shell
