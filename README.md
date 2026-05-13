# simple_log — Remote DLT Logging Demo

A small C++ application that demonstrates `mw::log` remote logging via the datarouter daemon.
Log messages appear in real time in **dlt-viewer** over UDP on `127.0.0.1:3490`.

## Architecture

```
simple_log (mw::log kRemote)
      │
      │  shared memory ring buffer
      ▼
  datarouter --no_adaptive_runtime
      │
      │  UDP  127.0.0.1:3490
      ▼
  dlt-viewer (GUI)
```

## 1 — Build

Build the demo app:

```bash
bazel build --config=x86_64-linux //:simple_log
```

Build the datarouter:

```bash
bazel build @score_logging//score/datarouter --config=x86_64-linux
```

## 2 — Enable multicast on loopback

Required once per boot for DLT UDP:

```bash
sudo ip link set lo multicast on
```

## 3 — Run the datarouter

In a dedicated terminal:

```bash
bazel run --config=x86_64-linux //:run_datarouter -- --no_adaptive_runtime
```

The `run_datarouter` target copies `config/datarouter/log-channels.json` into `./etc/` (which the datarouter reads on startup) before exec-ing the binary.

## 4 — Connect dlt-viewer

1. Launch dlt-viewer
2. **File → New connection** (or the plug icon)
3. Set **Protocol** = `UDP`, **Host** = `127.0.0.1`, **Port** = `3490`
4. Click **OK / Connect**

## 5 — Run the demo app

In a second terminal:

```bash
bazel run --config=x86_64-linux //:run_simple_log
```

The `run_simple_log` target sets `MW_LOG_CONFIG_FILE` to `config/demo_app/logging.json` before running the binary.

## Config files

| File | Purpose |
|------|---------|
| `config/demo_app/logging.json` | App config: `appId=DEMO`, `logMode=kRemote`, `logLevel=kVerbose` |
| `config/datarouter/log-channels.json` | Single channel → `127.0.0.1:3490`, threshold `kVerbose` |
| `config/datarouter/logging.json` | Datarouter's own logging (`appId=DR`, `logMode=kRemote`, `logLevel=kInfo`) |

## What the demo logs

- **MAIN** context — startup, loop counter, shutdown
- **SENS** context — simulated temperature readings + threshold warnings every 5 iterations
- **NETW** context — hex packet IDs + simulated network errors every 10 iterations
