#!/usr/bin/env python3
import sys
import logging
import xml.etree.ElementTree as ET
import copy
import requests

# ─── Config (hard-coded) ────────────────────────────────────────────────
FEED_FILE     = "test_usage_data.xml"
BASE_URL      = "http://localhost:8080/DataCustodian"
CUSTOMER_ID   = "1"
CLIENT_ID     = "data_custodian"
CLIENT_SECRET = "secret"
TOKEN_URL     = f"{BASE_URL}/oauth/token"

# endpoints from Routes.java
BATCH_ENDPOINT = f"{BASE_URL}/espi/1_1/resource/Batch/RetailCustomer/{CUSTOMER_ID}/UsagePoint"
ATOM_ENDPOINT  = f"{BASE_URL}/espi/1_1/resource/RetailCustomer/{CUSTOMER_ID}/UsagePoint"

# namespaces
ATOM_NS = "http://www.w3.org/2005/Atom"
ESPI_NS = "http://naesb.org/espi"
NSMAP   = {'atom': ATOM_NS, 'espi': ESPI_NS}
ET.register_namespace('', ATOM_NS)
ET.register_namespace('espi', ESPI_NS)

logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s")


def fetch_token():
    resp = requests.post(
        TOKEN_URL,
        auth=(CLIENT_ID, CLIENT_SECRET),
        data={'grant_type': 'client_credentials'},
        timeout=10
    )
    resp.raise_for_status()
    token = resp.json().get('access_token')
    if not token:
        raise RuntimeError("OAuth response missing access_token")
    return token


def build_batch():
    tree = ET.parse(FEED_FILE)
    root = tree.getroot()

    batch = ET.Element(f"{{{ESPI_NS}}}BatchList")
    for entry in root.findall('atom:entry', NSMAP):
        content = entry.find('atom:content', NSMAP)
        if content is None or len(content) == 0:
            logging.warning(f"Skipping entry {entry.find('atom:id', NSMAP).text}: no content")
            continue
        item = ET.SubElement(batch, f"{{{ESPI_NS}}}BatchItemInfo")
        # deep-copy the ESPI resource under BatchItemInfo
        resource = content[0]
        item.append(copy.deepcopy(resource))
    return batch


def build_single_atom():
    tree = ET.parse(FEED_FILE)
    root = tree.getroot()
    entry = root.find('atom:entry', NSMAP)
    if entry is None:
        logging.error("No <entry> in feed")
        sys.exit(1)
    return entry


def main():
    if len(sys.argv) != 2 or sys.argv[1] not in ("atom", "batch"):
        print("Usage: autoload_whole_batch.py [atom|batch]")
        sys.exit(1)
    mode = sys.argv[1]

    if mode == "batch":
        url       = BATCH_ENDPOINT
        root_elem = build_batch()
    else:
        url       = ATOM_ENDPOINT
        root_elem = build_single_atom()

    payload = ET.tostring(root_elem, encoding='utf-8', xml_declaration=True)
    logging.info("Built payload (%d bytes), fetching token…", len(payload))

    try:
        token = fetch_token()
    except Exception as e:
        logging.error("Failed to fetch OAuth token: %s", e)
        sys.exit(1)

    headers = {
        'Authorization': f'Bearer {token}',
        'Content-Type':  'application/xml; charset=UTF-8'
    }
    logging.info("POSTing to %s", url)
    resp = requests.post(url, headers=headers, data=payload, timeout=60)

    if resp.ok:
        logging.info("Success (HTTP %d):\n%s", resp.status_code, resp.text)
    else:
        logging.error("Failed (HTTP %d): %s", resp.status_code, resp.text.strip())
        sys.exit(1)


if __name__ == "__main__":
    main()
