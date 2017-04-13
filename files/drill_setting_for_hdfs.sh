#!/usr/bin/env sh

/usr/bin/curl -H 'Content-Type: application/json' -XPOST http://localhost:8047/storage/hdfs.json -d'{
  "name": "hdfs",
  "config": {
    "type": "file",
    "enabled": true,
    "connection": "hdfs://vm-centos73-hadsp-oe4iu4vi-1:8020",
    "config": null,
    "workspaces": {
      "root": {
        "location": "/apps/drill-data/",
        "writable": false,
        "defaultInputFormat": "csv"
      },
      "tmp": {
        "location": "/tmp",
        "writable": true,
        "defaultInputFormat": null
      }
    },
    "formats": {
      "psv": {
        "type": "text",
        "extensions": [
          "tbl"
        ],
        "delimiter": "|"
      },
      "csv": {
        "type": "text",
        "extensions": [
          "csv"
        ],
        "delimiter": ",",
        "quote": "\"",
        "skipFirstLine": false,
        "extractHeader": true
      },
      "tsv": {
        "type": "text",
        "extensions": [
          "tsv"
        ],
        "delimiter": "\t"
      },
      "parquet": {
        "type": "parquet"
      },
      "json": {
        "type": "json",
        "extensions": [
          "json"
        ]
      },
      "avro": {
        "type": "avro"
      },
      "sequencefile": {
        "type": "sequencefile",
        "extensions": [
          "seq"
        ]
      },
      "csvh": {
        "type": "text",
        "extensions": [
          "csvh"
        ],
        "extractHeader": true,
        "delimiter": ","
      }
    }
  }
}'
