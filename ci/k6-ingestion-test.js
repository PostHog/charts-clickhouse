import http from 'k6/http'
import {check, group, sleep} from 'k6'
import { Gauge } from 'k6/metrics'

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
  const res = http.post(`http://${__ENV.POSTHOG_HOSTNAME}:8000/e/`, JSON.stringify({
    api_key: 'e2e_token_1239',
    event: 'k6s_custom_event',
    distinct_id: __VU
  }));

  check(res, { 'status 200': (r) => r.status === 200 })

  sleep(0.1)
}

export function checkIngestion() {
  const res = http.get(`http://${__ENV.POSTHOG_HOSTNAME}:8000/api/insight/trend/?events=[{"id":"k6s_custom_event","type":"events"}]&refresh=true`, {
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
