load("@rules_cc//cc:defs.bzl", "cc_binary")

cc_binary(
    name = "console",
    srcs = ["src/main.cpp"],
    data = ["etc/logging.json"],
    env = {"MW_LOG_CONFIG_FILE": "$(location etc/logging.json)"},
    deps = ["@score_logging//score/mw/log"],
)
