import http from 'k6/http'
import { check } from 'k6'
import { Counter } from 'k6/metrics'
import { URL } from './lib/url_1_0_0.js'
import { describe } from './lib/expect_0_0_5.js';
import { isPrivateIP } from './utils.js'
import {
  POSTHOG_API_ENDPOINT,
  POSTHOG_EVENT_ENDPOINT,
  SKIP_SOURCE_IP_ADDRESS_CHECK,
  checkPrerequisites
} from './common.js';


checkPrerequisites();

let failedTestCases = new Counter('failedTestCases');

export let options = {
  scenarios: {
    generateEvents: {
      exec: 'generateEvents',
      executor: 'constant-vus',
      vus: 20,
      duration: '30s',
      gracefulStop: '10s', // wait for iterations to finish in the end
    },
    checkEvents: {
      exec: 'checkEvents',
      executor: 'per-vu-iterations',
      vus: 1,           // Number of VUs to run concurrently.
      iterations: 1,    // only run a single iteration after generateEvents() completes
      startTime: '40s',  // duration + gracefulStop of the above
    },
  },
  thresholds: {
    'http_req_failed{scenario:generateEvents}': ['rate < 0.01'],    // HTTP errors of the generateEvents scenario should be less than 1%
    'http_req_duration{scenario:generateEvents}': ['p(90) < 1000'], // 90% of requests of the generateEvents scenario should be below 1s
    failedTestCases: [{
      threshold: 'count===0',
      abortOnFail: true
    }],
  },
}

export function generateEvents() {
  const URI = new URL(`${POSTHOG_EVENT_ENDPOINT}/e/`)

  const res = http.post(URI.toString(), JSON.stringify({
    api_key: 'e2e_token_1239',
    event: 'k6s_custom_event',
    distinct_id: __VU
  }));

  check(res, { 'status 200': (r) => r.status === 200 })
}

export function checkEvents() {
  var success;

  success = describe('Check the count of events ingested', (t) => {

    const URI = new URL(`${POSTHOG_API_ENDPOINT}/api/projects/@current/insights/trend/?events=[{"id":"k6s_custom_event","type":"events"}]&refresh=true`)
    const res = http.get(URI.toString(), {
      headers: {
        Authorization: `Bearer e2e_demo_api_key`
      }
    })

    t.expect(res.status).as('HTTP response status').toEqual(200)
    t.expect(res).toHaveValidJson()

    const eventCount = res.json()["result"][0]["count"]
    t.expect(eventCount).as(`Count of ingested events (${eventCount})`).toBeGreaterThan(100)
  })
  failedTestCases.add(success === false);

  /*
    TODO: add non-flaky test for $pluginEvents. After the release of the buffer
    changes, this test has not been reliable, and has meant introducing sleeps
    around the place making the tests slow.
  */
  // success = describe('Check onEvent called enough times', (t) => {

  //   // :TRICKY: We generate there being a plugin generating $pluginEvent events, see setup_ingestion_test.sh
  //   const URI = new URL(`${POSTHOG_API_ENDPOINT}/api/projects/@current/events/?event=$pluginEvent`)
  //   const res = http.get(URI.toString(), {
  //     headers: {
  //       Authorization: `Bearer e2e_demo_api_key`
  //     }
  //   })

  //   t.expect(res.status).as('HTTP response status').toEqual(200)
  //   t.expect(res).toHaveValidJson()

  //   const eventCount = res.json()['results'].length
  //   t.expect(eventCount).as(`Count of $pluginEvents (${eventCount})`).toBeGreaterThan(0)
  // })
  // failedTestCases.add(success === false);

  // This test case doesn't work in all the environments (e.g. k3s) so we made it optional
  if (!SKIP_SOURCE_IP_ADDRESS_CHECK) {
    success = describe('Check if the source IP address of a random ingested event is not part of a private range', (t) => {

      const URI = new URL(`${POSTHOG_API_ENDPOINT}/api/projects/@current/events/?event=k6s_custom_event`)
      const res = http.get(URI.toString(), {
        headers: {
          Authorization: `Bearer e2e_demo_api_key`
        }
      })

      t.expect(res.status).as('HTTP response status').toEqual(200)
      t.expect(res).toHaveValidJson()

      var random_event = res.json()["results"].pop()
      var source_ip = random_event["properties"]["$ip"]

      t.expect(!isPrivateIP(source_ip))
        .as(`The source IP address of a random ingested event (${source_ip}) is not part of a private range`)
        .toEqual(true)
    })
    failedTestCases.add(success === false);
  }
}
