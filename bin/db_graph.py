#!/usr/bin/env python3
"""db_graph.py

Generate simple graphs of the OpenESPI DataCustodian MySQL database:

1) Schema graph: tables + foreign-key edges (from information_schema)
2) Privacy-variant data graph: canonical UsagePoint <-> privacy variants

Outputs:
- Graphviz DOT (.dot)
- Mermaid flowchart (.mmd)

This script intentionally uses the `mysql` CLI (not a Python DB driver)
so it can run in dev environments without extra dependencies.

Env vars (defaults match common dev setup):
- MYSQL_HOST=localhost
- MYSQL_PORT=3306
- MYSQL_USER=root
- MYSQL_PASS=password
"""

from __future__ import annotations

import argparse
import os
import re
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable, List, Optional, Tuple


def _mysql_args() -> List[str]:
    host = os.getenv("MYSQL_HOST", "localhost")
    port = os.getenv("MYSQL_PORT", "3306")
    user = os.getenv("MYSQL_USER", "root")
    pw = os.getenv("MYSQL_PASS", "password")

    args = ["mysql", "-N", "-B", "-h", host, "-P", str(port), "-u", user]
    if pw:
        args.append(f"-p{pw}")
    return args


def mysql_query(db: Optional[str], sql: str) -> str:
    cmd = _mysql_args()
    if db:
        cmd.append(db)
    cmd.extend(["-e", sql])

    proc = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    if proc.returncode != 0:
        raise RuntimeError(f"mysql failed: {proc.stderr.strip()}")
    return proc.stdout


def write_text(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")


def maybe_render_dot(dot_path: Path, fmt: str = "png") -> Optional[Path]:
    dot = shutil_which("dot")
    if not dot:
        return None
    out = dot_path.with_suffix("." + fmt)
    subprocess.run([dot, f"-T{fmt}", str(dot_path), "-o", str(out)], check=False)
    return out if out.exists() else None


def shutil_which(cmd: str) -> Optional[str]:
    # small local shim to avoid importing shutil (kept explicit)
    for p in os.getenv("PATH", "").split(os.pathsep):
        candidate = Path(p) / cmd
        if candidate.exists() and os.access(candidate, os.X_OK):
            return str(candidate)
    return None


@dataclass(frozen=True)
class FkEdge:
    from_table: str
    from_col: str
    to_table: str
    to_col: str


def fetch_fk_edges(schema: str) -> List[FkEdge]:
    sql = f"""
SELECT
  TABLE_NAME,
  COLUMN_NAME,
  REFERENCED_TABLE_NAME,
  REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = '{schema}'
  AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME, COLUMN_NAME;
""".strip()

    out = mysql_query(None, sql)
    edges: List[FkEdge] = []
    for line in out.splitlines():
        parts = line.split("\t")
        if len(parts) != 4:
            continue
        edges.append(
            FkEdge(
                from_table=parts[0],
                from_col=parts[1],
                to_table=parts[2],
                to_col=parts[3],
            )
        )
    return edges


def emit_schema_dot(schema: str, edges: List[FkEdge], table_filter: Optional[re.Pattern[str]]) -> str:
    tables = set()
    filtered_edges: List[FkEdge] = []

    for e in edges:
        if table_filter and not (
            table_filter.search(e.from_table) or table_filter.search(e.to_table)
        ):
            continue
        filtered_edges.append(e)
        tables.add(e.from_table)
        tables.add(e.to_table)

    lines = [
        "digraph datacustodian_schema {",
        "  rankdir=LR;",
        "  node [shape=box, fontname=Helvetica];",
        f"  label=\"Schema FK Graph: {schema}\";",
        "  labelloc=top;",
        "  fontsize=20;",
        "",
    ]

    for t in sorted(tables):
        lines.append(f'  "{t}";')

    lines.append("")

    for e in filtered_edges:
        lines.append(
            f'  "{e.from_table}" -> "{e.to_table}" [label="{e.from_col}→{e.to_col}"];'
        )

    lines.append("}")
    return "\n".join(lines) + "\n"


def emit_schema_mermaid(schema: str, edges: List[FkEdge], table_filter: Optional[re.Pattern[str]]) -> str:
    def m_id(name: str) -> str:
        # Mermaid IDs must be alnum/_; keep stable mapping
        return "t_" + re.sub(r"[^A-Za-z0-9_]", "_", name)

    filtered: List[FkEdge] = []
    tables = set()
    for e in edges:
        if table_filter and not (
            table_filter.search(e.from_table) or table_filter.search(e.to_table)
        ):
            continue
        filtered.append(e)
        tables.add(e.from_table)
        tables.add(e.to_table)

    lines = [
        "flowchart LR",
        f"  %% Schema FK Graph: {schema}",
        "  %% Styling",
        "  classDef core fill:#1f6feb,stroke:#0b3d91,color:#ffffff,stroke-width:2px;",
        "  classDef link fill:#7c3aed,stroke:#4c1d95,color:#ffffff,stroke-width:2px;",
        "  classDef dim fill:#111827,stroke:#334155,color:#e5e7eb,stroke-width:1px;",
        "",
    ]

    for t in sorted(tables):
        lines.append(f"  {m_id(t)}[{t}]")

    # Assign classes to keep the graph readable and intentional.
    core_tables = {
        "retail_customers",
        "subscriptions",
        "usage_points",
        "meter_readings",
    }
    link_tables = {
        "usage_point_related_links",
        "meter_reading_related_links",
        "subscriptions_usage_points",
        "reading_types_meter_readings",
    }

    for t in sorted(tables):
        if t in core_tables:
            lines.append(f"  class {m_id(t)} core;")
        elif t in link_tables:
            lines.append(f"  class {m_id(t)} link;")
        else:
            lines.append(f"  class {m_id(t)} dim;")

    for e in filtered:
        lines.append(
            f"  {m_id(e.from_table)} -- \"{e.from_col}→{e.to_col}\" --> {m_id(e.to_table)}"
        )

    return "\n".join(lines) + "\n"


@dataclass(frozen=True)
class PrivacyLink:
    canonical_id: int
    canonical_uuid: str
    rel: str
    variant_uuid: str


_UUID_SUFFIX_RE = re.compile(r"-(full|medium|low|high)$", re.IGNORECASE)


def base_uuid(uuid: str) -> str:
    return _UUID_SUFFIX_RE.sub("", uuid)


def fetch_privacy_links(db: str) -> Tuple[List[PrivacyLink], List[Tuple[int, str]]]:
    # Get canonical usagepoints (those that have privacy:* related links)
    sql = """
SELECT
  up.id,
  up.uuid,
  upl.rel,
  SUBSTRING_INDEX(upl.href, '/UsagePoint/', -1) AS variant_uuid
FROM usage_points up
JOIN usage_point_related_links upl
  ON upl.usage_point_id = up.id
WHERE upl.rel LIKE 'privacy:%'
ORDER BY up.id, upl.rel;
""".strip()

    out = mysql_query(db, sql)
    links: List[PrivacyLink] = []
    for line in out.splitlines():
        parts = line.split("\t")
        if len(parts) != 4:
            continue
        try:
            links.append(
                PrivacyLink(
                    canonical_id=int(parts[0]),
                    canonical_uuid=parts[1],
                    rel=parts[2],
                    variant_uuid=parts[3],
                )
            )
        except Exception:
            continue

    # Also include the concrete rows that exist (canonical + variants) for reference
    usage_sql = """
SELECT id, uuid
FROM usage_points
ORDER BY id;
""".strip()
    usage_out = mysql_query(db, usage_sql)
    usage_points: List[Tuple[int, str]] = []
    for line in usage_out.splitlines():
        parts = line.split("\t")
        if len(parts) != 2:
            continue
        try:
            usage_points.append((int(parts[0]), parts[1]))
        except Exception:
            continue

    return links, usage_points


def emit_privacy_dot(db: str, links: List[PrivacyLink], usage_points: List[Tuple[int, str]]) -> str:
    # Build a small subgraph per base UUID.
    by_base: dict[str, List[PrivacyLink]] = {}
    for l in links:
        by_base.setdefault(base_uuid(l.canonical_uuid), []).append(l)

    # Helpful lookup for whether a node exists as a row.
    uuid_to_id = {u: i for (i, u) in usage_points}

    lines = [
        "digraph privacy_variants {",
        "  rankdir=LR;",
        "  node [shape=box, fontname=Helvetica];",
        f"  label=\"Privacy Variant Graph (data): {db}\";",
        "  labelloc=top;",
        "  fontsize=20;",
        "",
    ]

    for b, group in sorted(by_base.items()):
        cluster_id = re.sub(r"[^A-Za-z0-9_]", "_", b)[:40]
        lines.append(f"  subgraph cluster_{cluster_id} {{")
        lines.append(f"    label=\"{b}\";")
        lines.append("    style=rounded;")

        # canonical
        canonical_uuid = group[0].canonical_uuid
        canonical_label = f"canonical\\n{canonical_uuid}\\n(id={uuid_to_id.get(canonical_uuid, '?')})"
        lines.append(f'    "{canonical_uuid}" [label="{canonical_label}", style="filled", fillcolor="#E8F0FE"];')

        for l in group:
            v = l.variant_uuid
            v_label = f"{l.rel}\\n{v}\\n(id={uuid_to_id.get(v, '?')})"
            lines.append(f'    "{v}" [label="{v_label}", style="filled", fillcolor="#F1F8E9"];')
            lines.append(f'    "{canonical_uuid}" -> "{v}" [label="{l.rel}"];')
            # Backlink (if present) is stored on the variant row; draw as dotted arrow for clarity.
            lines.append(f'    "{v}" -> "{canonical_uuid}" [label="canonical", style=dashed];')

        lines.append("  }")
        lines.append("")

    lines.append("}")
    return "\n".join(lines) + "\n"


def emit_privacy_mermaid(db: str, links: List[PrivacyLink]) -> str:
    # Mermaid: group by base UUID, show canonical -> variants
    by_base: dict[str, List[PrivacyLink]] = {}
    for l in links:
        by_base.setdefault(base_uuid(l.canonical_uuid), []).append(l)

    def m_id(uuid: str) -> str:
        return "u_" + re.sub(r"[^A-Za-z0-9_]", "_", uuid)

    lines = [
        "flowchart LR",
        f"  %% Privacy Variant Graph (data): {db}",
        "  %% Styling",
        "  classDef canonical fill:#1f6feb,stroke:#0b3d91,color:#ffffff,stroke-width:2px;",
        "  classDef p_full fill:#16a34a,stroke:#14532d,color:#ffffff,stroke-width:2px;",
        "  classDef p_high fill:#0ea5e9,stroke:#075985,color:#ffffff,stroke-width:2px;",
        "  classDef p_medium fill:#f59e0b,stroke:#78350f,color:#111827,stroke-width:2px;",
        "  classDef p_low fill:#ef4444,stroke:#7f1d1d,color:#ffffff,stroke-width:2px;",
        "  classDef variant fill:#64748b,stroke:#334155,color:#ffffff,stroke-width:1.5px;",
        "",
    ]

    for b, group in sorted(by_base.items()):
        lines.append(f"  subgraph {re.sub(r'[^A-Za-z0-9_]', '_', b)}[{b}]")
        c_uuid = group[0].canonical_uuid
        lines.append(f"    {m_id(c_uuid)}[[canonical\n{c_uuid}]]")
        lines.append(f"    class {m_id(c_uuid)} canonical;")
        for l in group:
            v = l.variant_uuid
            lines.append(f"    {m_id(v)}[{l.rel}\n{v}]")
            lines.append(f"    {m_id(c_uuid)} -- \"{l.rel}\" --> {m_id(v)}")
            lines.append(f"    {m_id(v)} -. \"canonical\" .-> {m_id(c_uuid)}")

            rel = (l.rel or "").lower()
            if rel == "privacy:full":
                lines.append(f"    class {m_id(v)} p_full;")
            elif rel == "privacy:high":
                lines.append(f"    class {m_id(v)} p_high;")
            elif rel == "privacy:medium":
                lines.append(f"    class {m_id(v)} p_medium;")
            elif rel == "privacy:low":
                lines.append(f"    class {m_id(v)} p_low;")
            else:
                lines.append(f"    class {m_id(v)} variant;")
        lines.append("  end")

    return "\n".join(lines) + "\n"


def main(argv: List[str]) -> int:
    p = argparse.ArgumentParser(description="Graph OpenESPI MySQL schema and privacy-variant linkages")
    sub = p.add_subparsers(dest="cmd", required=True)

    p_schema = sub.add_parser("schema", help="Generate schema FK graph")
    p_schema.add_argument("--schema", default="datacustodian", help="MySQL schema name (default: datacustodian)")
    p_schema.add_argument("--filter", default=None, help="Regex filter on table names (optional)")
    p_schema.add_argument("--out-dot", default="/tmp/datacustodian_schema.dot")
    p_schema.add_argument("--out-mmd", default="/tmp/datacustodian_schema.mmd")

    p_priv = sub.add_parser("privacy", help="Generate privacy variant linkage graph (data)")
    p_priv.add_argument("--db", default="datacustodian", help="Database name (default: datacustodian)")
    p_priv.add_argument("--out-dot", default="/tmp/datacustodian_privacy.dot")
    p_priv.add_argument("--out-mmd", default="/tmp/datacustodian_privacy.mmd")

    args = p.parse_args(argv)

    if args.cmd == "schema":
        table_filter = re.compile(args.filter) if args.filter else None
        edges = fetch_fk_edges(args.schema)
        dot = emit_schema_dot(args.schema, edges, table_filter)
        mmd = emit_schema_mermaid(args.schema, edges, table_filter)
        write_text(Path(args.out_dot), dot)
        write_text(Path(args.out_mmd), mmd)
        print(f"Wrote: {args.out_dot}")
        print(f"Wrote: {args.out_mmd}")
        return 0

    if args.cmd == "privacy":
        links, ups = fetch_privacy_links(args.db)
        dot = emit_privacy_dot(args.db, links, ups)
        mmd = emit_privacy_mermaid(args.db, links)
        write_text(Path(args.out_dot), dot)
        write_text(Path(args.out_mmd), mmd)
        print(f"Wrote: {args.out_dot}")
        print(f"Wrote: {args.out_mmd}")
        return 0

    return 2


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
