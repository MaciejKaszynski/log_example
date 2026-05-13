# simple_log — Remote DLT Logging Demo

```bash
bazel run --config=x86_64-linux //:run_demo
```

The script will pause and let you start the dlt viewer.

Open dlt-viewer and add an ECU with **Interface Type** as **UDP DLT** and
the port being **3490**. And finally connect.

WARNING: Seems that using dlt-viewer from WSL isn't working (need to figure out why)
but the windows apps works fine.

Alternatively, receive logs on the command line:

```bash
dlt-receive -u -m 239.255.42.99 -p 3490 -a
```

Then press Enter to continue the demo.

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

## Cleanup

```bash
sudo ip link set lo multicast off
```

## Custom staging path

By default the demo is ran in ./.demo_runtime

```bash
bazel run --config=x86_64-linux //:run_demo -- --target=/opt/logging
```
