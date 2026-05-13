# simple_log

```bash
bazel run --config=x86_64-linux //:run_demo
```

The script will pause and let you start the dlt-recieve to get the messages.

Note: You can install this using `sudo apt install dlt-tools`

```bash
dlt-receive -u -m 239.255.42.99 -p 3490 -a
```

Then press Enter to continue the demo.
You should see logs coming in from the example app.

## Troubleshooting

Installing `dlt-daemon` enables a `dlt-daemon` systemd service
on startup that binds port 3490, which conflicts with the datarouter.

```bash
sudo ss -ulnp | grep 3490
sudo kill <pid>
```

To stop it permanently:

```bash
sudo systemctl disable dlt-daemon
```

## Custom staging path

By default the demo is ran in ./.demo_runtime

```bash
bazel run --config=x86_64-linux //:run_demo -- --target=/opt/logging
```
