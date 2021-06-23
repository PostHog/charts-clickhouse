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
  stages: [
    { duration: '2m', target: 100 }, // below normal load
    { duration: '2m', target: 100 },
    { duration: '2m', target: 200 }, // Digital Ocean small lb connection limit is 250
    { duration: '2m', target: 200 },
    { duration: '5m', target: 0 }, // scale down. Recovery stage.
  ],
  //scenarios: {
  //  captureEvents: {
  //    exec: 'captureEvents',
  //    executor: 'shared-iterations',
  //    iterations: __ENV.CE_ITERATIONS || 10000,
  //    vus: __ENV.CE_VUS || 20,
  //  }
  //}
}

export default function () {
  const res = http.post(`${__ENV.POSTHOG_URL}/e/`, JSON.stringify({
    api_key: 'ws6xnNaSGqAbY07-Q0SVJPJrhfGtpPKSecKDiBn97ps',
    event: 'k6s_custom_event',
    distinct_id: __VU
  }));

  check(res, { 'status 200': (r) => r.status === 200 })

  sleep(__ENV.CE_SLEEP || 1)
}
