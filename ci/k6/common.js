import { fail } from 'k6'

export const POSTHOG_API_ENDPOINT = __ENV.POSTHOG_API_ENDPOINT
export const POSTHOG_EVENT_ENDPOINT = __ENV.POSTHOG_EVENT_ENDPOINT

export function checkPrerequisites() {
  if (!POSTHOG_API_ENDPOINT || !POSTHOG_EVENT_ENDPOINT) {
    fail("Please specify env variables POSTHOG_API_ENDPOINT and POSTHOG_EVENT_ENDPOINT")
  }
}

export const SKIP_SOURCE_IP_ADDRESS_CHECK = __ENV.SKIP_SOURCE_IP_ADDRESS_CHECK
