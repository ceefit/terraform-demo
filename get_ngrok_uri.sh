#!/usr/bin/env bash

sleep 10;
curl -s localhost:4040/api/tunnels | jq '{"uri": .tunnels[0].public_url}'