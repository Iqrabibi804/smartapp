#!/usr/bin/env python3
"""Import the supplied Punjab directory workbook into a Flutter JSON asset.

Usage:
  python -m pip install openpyxl
  python scripts/import_directory_workbook.py Punjab_Islamabad_Hierarchy_Police_completed.xlsx

All directory entries remain reference-only. This importer never marks a
business, phone number, police station or administrative record as verified.
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
    "islamabadAreaToStation": "Islamabad_Area_to_Station",
    "islamabadZoneSummary": "Islamabad_Zone_Summary",
    "lahorePolice": "Lahore_Police",
    "punjabHierarchy": "Punjab_Hierarchy",
    "punjabDistrictSummary": "Punjab_District_Summary",
    "appCities": "App_Cities_81",
    "tehsilCoverage": "Tehsil_Coverage",
    "divisionSummary": "Division_Summary",
    "citySummary": "City_Summary",
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
    rows = workbook[sheet_name].iter_rows(values_only=True)
    headers = [str(normalise(value) or "") for value in next(rows, ())]
    records: list[dict[str, Any]] = []
    for row in rows:
        record = {
            headers[index]: normalise(value)
            for index, value in enumerate(row)
            if index < len(headers) and headers[index]
            and normalise(value) is not None
        }
        if record:
            records.append(record)
    return records


def annotate_osm(records: list[dict[str, Any]]) -> list[dict[str, Any]]:
    seen: set[str] = set()
    for record in records:
        osm_link = str(record.get("OSM link") or "").strip()
        record["duplicateOSMReference"] = bool(osm_link and osm_link in seen)
        if osm_link:
            seen.add(osm_link)
        try:
            latitude = float(record["Latitude"])
            longitude = float(record["Longitude"])
            record["hasValidCoordinates"] = (
                -90 <= latitude <= 90 and -180 <= longitude <= 180
            )
        except (KeyError, TypeError, ValueError):
            record["hasValidCoordinates"] = False
        record["verified"] = False
        record["verificationStatus"] = "needs_verification"
        record["referenceOnly"] = True
    return records


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("workbook", type=Path)
    parser.add_argument(
        "--output",
        type=Path,
        default=Path("mobile/assets/data/punjab_directory.json"),
    )
    args = parser.parse_args()
    if not args.workbook.is_file():
        raise SystemExit(f"Workbook not found: {args.workbook}")

    workbook = load_workbook(args.workbook, read_only=True, data_only=True)
    data = {
        key: sheet_records(workbook, sheet_name)
        for key, sheet_name in SHEETS.items()
    }
    workbook.close()

    for key in ("busStations", "hotels", "restaurants"):
        data[key] = annotate_osm(data[key])

    for key in ("islamabadPolice", "islamabadAreaToStation", "lahorePolice"):
        for record in data[key]:
            record["verified"] = False
            record["verificationStatus"] = "needs_official_verification"
            record["referenceOnly"] = True

    for key in (
        "islamabadZoneSummary", "punjabHierarchy", "punjabDistrictSummary",
        "appCities", "tehsilCoverage", "divisionSummary", "citySummary",
    ):
        for record in data[key]:
            record["referenceOnly"] = True

    data["metadata"] = {
        "workbook": args.workbook.name,
        "generatedAt": datetime.now(timezone.utc).isoformat(),
        "verificationPolicy": (
            "Imported workbook records are reference-only and are not verified."
        ),
        "openStreetMapAttribution": "© OpenStreetMap contributors",
        "openStreetMapLicense": "Open Database License (ODbL)",
        "sourceNotice": (
            "OpenStreetMap listings do not establish that a business is open, "
            "licensed, reachable, safe or currently providing a service. Phone "
            "numbers, hours, ratings and amenities require independent current "
            "verification. Police listings and area mappings are secondary-source "
            "references, not an official emergency directory. Administrative "
            "hierarchy and city profiles are supplied workbook data and should be "
            "checked against current official records."
        ),
        "sheetCounts": {key: len(value) for key, value in data.items()},
    }

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(
        json.dumps(data, ensure_ascii=False, separators=(",", ":")) + "\n",
        encoding="utf-8",
    )
    print(f"Generated: {args.output}")
    for key, count in data["metadata"]["sheetCounts"].items():
        print(f"  {key}: {count}")
    print("All imported records remain reference-only / unverified.")


if __name__ == "__main__":
    main()
