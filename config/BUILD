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

filegroup(
    name = "datarouter_configs",
    srcs = glob(["datarouter/*.json"]),
    visibility = ["//visibility:public"],
)

filegroup(
    name = "demo_app_configs",
    srcs = glob(["demo_app/*.json"]),
    visibility = ["//visibility:public"],
)

config_setting(
    name = "x86_64-linux",
    define_values = {
        "config": "x86_64-linux",
    },
)

config_setting(
    name = "host",
    define_values = {
        "config": "host",
    },
)
