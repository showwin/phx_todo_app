#!/bin/bash

cd /app/assets && npm install && cd /app

exec "$@"
