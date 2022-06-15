organization = Organization.objects.last()
team = organization.teams.last()
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
