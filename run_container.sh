#!/usr/bin/env bash
docker run -it --name flaskapp --rm -p 5000:5000 --mount type=bind,source="$(pwd)",target=/app \
                                    -t jaredchung_blog:latest python jaredchung_blog.py