# log_example

Minimal examples of `score_logging` with three backends.

## File and console

Both examples run with a single command 
configs are exposed using the  `MW_LOG_CONFIG_FILE` env var

Run with:
```bash
bazel run --config=x86_64-linux //console
bazel run --config=x86_64-linux //file
```

## Remote

The remote demo also launches a `datarouter`, so it needs a small script. See [remote/README.md](remote/README.md) for details.

```bash
bazel run --config=x86_64-linux //remote
```
