# *******************************************************************************
# Copyright (c) 2025 Contributors to the Eclipse Foundation
#
# See the NOTICE file(s) distributed with this work for additional
# information regarding copyright ownership.
#
# This program and the accompanying materials are made available under the
# terms of the Apache License Version 2.0 which is available at
# https://www.apache.org/licenses/LICENSE-2.0
#
# SPDX-License-Identifier: Apache-2.0
# *******************************************************************************
load("@rules_cc//cc:defs.bzl", "cc_binary")

_DEMO_DATA = [
    "@score_logging//score/datarouter",
    ":simple_log",
    "//remote/etc:datarouter/log-channels.json",
    "//remote/etc:datarouter/logging.json",
    "//remote/etc:demo_app/logging.json",
]

_DEMO_ARGS = [
    "$(rlocationpath @score_logging//score/datarouter)",
    "$(rlocationpath :simple_log)",
    "$(rlocationpath //remote/etc:datarouter/log-channels.json)",
    "$(rlocationpath //remote/etc:datarouter/logging.json)",
    "$(rlocationpath //remote/etc:demo_app/logging.json)",
]

sh_binary(
    name = "remote",
    srcs = ["run_demo.sh"],
    args = _DEMO_ARGS,
    data = _DEMO_DATA,
)

cc_binary(
    name = "simple_log",
    srcs = ["main.cpp"],
    visibility = ["//visibility:public"],
    deps = [
        "@score_logging//score/mw/log",
        "@score_logging//score/mw/log/backend:remote",
    ],
)
