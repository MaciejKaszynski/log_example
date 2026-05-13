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

sh_binary(
    name = "run_datarouter",
    srcs = ["datarouter.sh"],
    data = [
        "@score_logging//score/datarouter",
        "//config:datarouter_configs",
    ],
)

sh_binary(
    name = "run_simple_log",
    srcs = ["simple_log.sh"],
    data = [
        "//:simple_log",
        "//config:demo_app_configs",
    ],
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
