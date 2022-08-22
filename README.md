# faraday_retry
Ruby example to  use faraday retry.

**Retry Options**:

- `max_retries`: The number of times to retry an endpoint call if it fails.
- `retry_interval`: Pause in seconds between retries.
- `backoff_factor`: The amount to multiply each successive retry's interval amount by in order to provide backoff.
- `max_interval`: max time interval
- `interval_randomness`: ramdon float interval number.
- `retry_if: -> (env, _exc) { env.body[:success] == 'false' }`


**Calculate backoff_factor**:

max = 3

interval = 3

backoff_factor = 2

retry_index = max - (max - 2)
retry_v = (backoff_factor**retry_index) * interval



Faraday Supported
- HTTP Header retry-after: 21
- Lambdas or procs
