#!/usr/bin/env python3
"""serve_graphs.py

Dev helper:
- Regenerates Mermaid/DOT graphs from the current DB on an interval
- Serves OpenESPI-Common-java/docs/graphs/ over HTTP

This is intentionally simple and dependency-free.

Usage:
  cd OpenESPI-Common-java
  ./bin/serve_graphs.py --port 7777 --refresh-seconds 5

Env vars are the same as db_graph.py:
  MYSQL_HOST, MYSQL_PORT, MYSQL_USER, MYSQL_PASS

"""

from __future__ import annotations

import argparse
import http.server
import os
import socketserver
import subprocess
import threading
import time
from pathlib import Path
import sys


def regen_once(root: Path) -> None:
    script = root / "bin" / "db_graph.py"
    if not script.exists():
        raise RuntimeError(f"Missing {script}")

    graphs_dir = root / "docs" / "graphs"
    schema_mmd = graphs_dir / "dc_schema_focus.mmd"
    schema_dot = graphs_dir / "dc_schema_focus.dot"
    privacy_mmd = graphs_dir / "dc_privacy.mmd"
    privacy_dot = graphs_dir / "dc_privacy.dot"

    try:
        # Run generators (write into docs/graphs)
        subprocess.run(
            [
                sys.executable,
                str(script),
                "schema",
                "--schema",
                "datacustodian",
                "--filter",
                "usage_points|usage_point_related_links|meter_readings|interval_blocks|subscriptions|retail_customers|authorization",
                "--out-dot",
                str(schema_dot),
                "--out-mmd",
                str(schema_mmd),
            ],
            cwd=str(root),
            check=False,
        )
        subprocess.run(
            [
                sys.executable,
                str(script),
                "privacy",
                "--db",
                "datacustodian",
                "--out-dot",
                str(privacy_dot),
                "--out-mmd",
                str(privacy_mmd),
            ],
            cwd=str(root),
            check=False,
        )
    except Exception:
        # Keep serving even if regeneration fails.
        pass


class MyHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/refresh':
            try:
                root = Path(__file__).resolve().parents[1]
                regen_once(root)
                self.send_response(200)
                self.send_header('Content-type', 'text/plain')
                self.end_headers()
                self.wfile.write(b'Graphs refreshed')
            except Exception as e:
                self.send_response(500)
                self.send_header('Content-type', 'text/plain')
                self.end_headers()
                self.wfile.write(f'Error: {e}'.encode())
        else:
            super().do_GET()
    script = root / "bin" / "db_graph.py"
    if not script.exists():
        raise RuntimeError(f"Missing {script}")

    graphs_dir = root / "docs" / "graphs"
    schema_mmd = graphs_dir / "dc_schema_focus.mmd"
    schema_dot = graphs_dir / "dc_schema_focus.dot"
    privacy_mmd = graphs_dir / "dc_privacy.mmd"
    privacy_dot = graphs_dir / "dc_privacy.dot"

    while True:
        try:
            # Run generators (write into docs/graphs)
            subprocess.run(
                [
                    sys.executable,
                    str(script),
                    "schema",
                    "--schema",
                    "datacustodian",
                    "--filter",
                    "usage_points|usage_point_related_links|meter_readings|interval_blocks|subscriptions|retail_customers|authorization",
                    "--out-dot",
                    str(schema_dot),
                    "--out-mmd",
                    str(schema_mmd),
                ],
                cwd=str(root),
                check=False,
            )
            subprocess.run(
                [
                    sys.executable,
                    str(script),
                    "privacy",
                    "--db",
                    "datacustodian",
                    "--out-dot",
                    str(privacy_dot),
                    "--out-mmd",
                    str(privacy_mmd),
                ],
                cwd=str(root),
                check=False,
            )
        except Exception:
            # Keep serving even if regeneration fails.
            pass
        time.sleep(refresh_seconds)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--port", type=int, default=7777)
    parser.add_argument("--refresh-seconds", type=float, default=5.0)
    args = parser.parse_args()

    root = Path(__file__).resolve().parents[1]
    graphs_dir = root / "docs" / "graphs"
    if not graphs_dir.exists():
        raise RuntimeError(f"Missing {graphs_dir}")

    t = threading.Thread(
        target=regen_loop,
        args=(root, args.refresh_seconds),
        daemon=True,
    )
    t.start()

    os.chdir(graphs_dir)

    handler = MyHandler
    try:
        with socketserver.TCPServer(("127.0.0.1", args.port), handler) as httpd:
            httpd.serve_forever()
    except OSError as e:
        if getattr(e, "errno", None) == 98:
            print(f"Port {args.port} is already in use. Pick another with --port.")
            return 2
        raise

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
