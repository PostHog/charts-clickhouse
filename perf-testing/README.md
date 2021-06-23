To run the perf test

Set the `POSTHOG_URL` and `API_KEY` env variables (the latter can be found in Posthog project/settings page), e.g.
```
export POSTHOG_URL="https://posthog.click"
export POSTHOG_URL="http://localhost:8000"
export API_KEY='ws6xnNaSGqAbY07-Q0SVJPJrhfGtpPKSecKDiBn97ps'
```

Run k6 ([docs](https://k6.io/docs/)).
```
k6 run k6-capture-events.js
```

Sleep time can be customized to add more load.
```
CE_SLEEP=0.1 k6 run k6-capture-events.js
```
