To run the perf test

Set the `POSTHOG_URL` env variable, e.g.
```
export POSTHOG_URL="https://posthog.click"
export POSTHOG_URL="http://localhost:8000"
```

Run k6 ([docs](https://k6.io/docs/)).
```
k6 run k6-capture-events.js
```

Sleep time can be customized to add more load.
```
CE_SLEEP=0.1 k6 run k6-capture-events.js
```
