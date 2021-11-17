import http from 'k6/http'
import {check, sleep, fail} from 'k6'
import { Gauge } from 'k6/metrics'
import { URL } from 'https://jslib.k6.io/url/1.0.0/index.js';

const POSTHOG_ENDPOINT = __ENV.POSTHOG_ENDPOINT
const POSTHOG_API_ENDPOINT = __ENV.POSTHOG_API_ENDPOINT || POSTHOG_ENDPOINT
const POSTHOG_EVENT_ENDPOINT = __ENV.POSTHOG_EVENT_ENDPOINT || POSTHOG_ENDPOINT

const captureURL = new URL(`${POSTHOG_EVENT_ENDPOINT}/e/`);
const apiURL = new URL(`${POSTHOG_API_ENDPOINT}/api/insight/trend/?events=[{"id":"k6s_custom_event","type":"events"}]&refresh=true`);

if (POSTHOG_EVENT_ENDPOINT == null && POSTHOG_API_ENDPOINT == null) {
  fail("Please specify env variable POSTHOG_ENDPOINT or POSTHOG_EVENT_ENDPOINT and POSTHOG_API_ENDPOINT")
}

let eventsIngested = new Gauge('events_ingested')

export let options = {
  thresholds: {
    http_req_failed: ['rate<0.01'],   // http errors should be less than 1%
    http_req_duration: ['p(95)<500'], // 95% of requests should be below 500ms
    events_ingested: ['value > 0', 'value > 100']
  },
  scenarios: {
    captureEvents: {
      exec: 'captureEvents',
      executor: 'shared-iterations',
      iterations: 10000,
      vus: 20,
    },
    checkIngestion: {
      startTime: '1m',
      exec: 'checkIngestion',
      executor: 'shared-iterations',
      iterations: 100,
      vus: 1,
    }
  }
}

export function captureEvents() {
  const res = http.post(captureURL.toString(), JSON.stringify({
    api_key: 'e2e_token_1239',
    event: 'k6s_custom_event',
    distinct_id: __VU
  }));

  check(res, { 'status 200': (r) => r.status === 200 })
  sleep(0.1)
}

export function checkIngestion() {
  const res = http.get(apiURL.toString(), {
    headers: {
      Authorization: `Bearer e2e_demo_api_key`
    }
  })

  let count = 0
  try {
    count = JSON.parse(res.body)["result"][0]["count"]
  } catch(err) {
    console.error(err)
  }

  check(res, {
    'status 200': (r) => r.status === 200
  })

  eventsIngested.add(count)
  sleep(0.5)
}
