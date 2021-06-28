import http from "k6/http"
import { check, sleep } from "k6"

export let options = {
  thresholds: {
    http_req_failed: ["rate<0.01"], // http errors should be less than 1%
    http_req_duration: ["p(95)<500"], // 95% of requests should be below 500ms
  },
  stages: [
    { duration: "2m", target: 100 },
    { duration: "2m", target: 100 },
    { duration: "2m", target: 200 }, // Digital Ocean small lb connection limit is 250
    { duration: "2m", target: 200 },
    { duration: "5m", target: 0 }, // scale down. Recovery stage.
  ],
}

export default function () {
  const res = http.post(
    `${__ENV.POSTHOG_URL}/e/`,
    JSON.stringify({
      api_key: __ENV.API_KEY,
      event: "k6s_custom_event",
      distinct_id: __VU,
    })
  )

  check(res, { "status 200": (r) => r.status === 200 })

  sleep(__ENV.CE_SLEEP || 1)
}
