#!/usr/bin/env python3
"""Convert the supplied Punjab directory workbook into the Flutter offline JSON asset.

Usage:
  python -m pip install openpyxl
  python scripts/import_directory_workbook.py "Punjab_Islamabad_Hierarchy_Police_completed.xlsx"

The output is deliberately marked as unverified reference data. This script does
not promote any record to verified and does not invent missing coordinates,
ratings, hours, operators, prices or contact information.
"""
from __future__ import annotations

import argparse
import json
import math
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

from openpyxl import load_workbook

SHEETS = {
    "busStations": "Bus_Stations",
    "hotels": "Hotels",
    "restaurants": "Restaurants",
    "islamabadPolice": "Islamabad_Police",
    "lahorePolice": "Lahore_Police",
    "punjabHierarchy": "Punjab_Hierarchy",
    "appCities": "App_Cities_81",
}


def normalise(value: Any) -> Any:
    if value is None:
        return None
    if isinstance(value, float) and (math.isnan(value) or math.isinf(value)):
        return None
    if isinstance(value, str):
        value = value.strip()
        return value or None
    if isinstance(value, (int, float, bool)):
        return value
    return str(value).strip() or None


def sheet_records(workbook, sheet_name: str) -> list[dict[str, Any]]:
    if sheet_name not in workbook.sheetnames:
        return []
    ws = workbook[sheet_name]
    values = ws.iter_rows(values_only=True)
    headers = [str(normalise(v) or "") for v in next(values, ())]
    result = []
    for row in values:
        record = {
            headers[i]: normalise(value)
            for i, value in enumerate(row)
            if i < len(headers) and headers[i] and normalise(value) is not None
        }
        if record:
            result.append(record)
    return result


def valid_lat_lon(record: dict[str, Any]) -> bool:
    try:
        lat = float(record["Latitude"])
        lon = float(record["Longitude"])
        return -90 <= lat <= 90 and -180 <= lon <= 180
    except (KeyError, TypeError, ValueError):
        return False


def deduplicate_osm(records: list[dict[str, Any]]) -> list[dict[str, Any]]:
    seen: set[str] = set()
    result = []
    for record in records:
        osm = str(record.get("OSM link") or "").strip()
        # Use OSM object identity when present. Do not collapse different places
        # merely because their names happen to match.
        if osm and osm in seen:
            continue
        if osm:
            seen.add(osm)
        record["verified"] = False
        record["verificationStatus"] = "needs_verification"
        record["referenceOnly"] = True
        result.append(record)
    return result


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("workbook", type=Path, help="Path to the supplied .xlsx workbook")
    parser.add_argument(
        "--output",
        type=Path,
        default=Path("mobile/assets/data/punjab_directory.json"),
        help="Flutter asset output path",
    )
    args = parser.parse_args()
    if not args.workbook.is_file():
        raise SystemExit(f"Workbook not found: {args.workbook}")

    wb = load_workbook(args.workbook, read_only=True, data_only=True)
    data = {key: sheet_records(wb, sheet) for key, sheet in SHEETS.items()}
    wb.close()

    data["busStations"] = [
        r for r in deduplicate_osm(data["busStations"]) if valid_lat_lon(r)
    ]
    data["hotels"] = deduplicate_osm(data["hotels"])
    data["restaurants"] = deduplicate_osm(data["restaurants"])

    # Police directory rows come from a secondary directory, so they remain
    # reference-only and are never treated as emergency dispatch instructions.
    for key in ("islamabadPolice", "lahorePolice"):
        for record in data[key]:
            record["verified"] = False
            record["verificationStatus"] = "needs_official_verification"
            record["referenceOnly"] = True

    data["metadata"] = {
        "workbook": args.workbook.name,
        "snapshotDate": "2026-11-23",
        "importedAt": datetime.now(timezone.utc).date().isoformat(),
        "verificationPolicy": "All imported rows are unverified reference data.",
        "openStreetMapAttribution": "© OpenStreetMap contributors",
        "openStreetMapLicense": "Open Database License (ODbL)",
        "sourceNotice": (
            "OSM listings do not establish that a business is open, licensed, "
            "reachable, safe or currently providing a service. Police listings "
            "are secondary-source references, not an official emergency directory."
        ),
    }

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(
        json.dumps(data, ensure_ascii=False, separators=(",", ":")) + "\n",
        encoding="utf-8",
    )
    print("Directory asset generated:", args.output)
    for key in SHEETS:
        print(f"  {key}: {len(data[key])}")
    print("All records remain unverified; OSM attribution is included in metadata.")


if __name__ == "__main__":
    main()
