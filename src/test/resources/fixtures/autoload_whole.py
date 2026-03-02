#!/usr/bin/env python3
import os, time, copy, xml.etree.ElementTree as ET, requests
from requests.auth import HTTPBasicAuth

# ─── CONFIG ───────────────────────────────────────────────────────────────
BASE_URL      = "http://localhost:8080/DataCustodian"
TOKEN_URL     = f"{BASE_URL}/oauth/token"
POST_URL      = f"{BASE_URL}/espi/1_1/resource/Batch/RetailCustomer/1/UsagePoint"
CLIENT_ID     = "data_custodian"
CLIENT_SECRET = "secret"
INPUT_XML     = "test_usage_data_10.xml"     # make sure this matches your file
OUT_DIR       = "entries"                    # where each file is written
DELAY_SEC     = 0.4                          # pause between requests
# ──────────────────────────────────────────────────────────────────────────

ATOM_NS = "http://www.w3.org/2005/Atom"
ESPI_NS = "http://naesb.org/espi"
ET.register_namespace("", ESPI_NS)           # default namespace is now ESPI

# ─── helper: OAuth token ─────────────────────────────────────────────────
def get_token():
    r = requests.post(
        TOKEN_URL,
        auth=HTTPBasicAuth(CLIENT_ID, CLIENT_SECRET),
        data={"grant_type": "client_credentials"},
        timeout=15
    )
    r.raise_for_status()
    return r.json()["access_token"]

# ─── helper: generator over Atom entries ─────────────────────────────────
def iter_entries(atom_path):
    feed = ET.parse(atom_path).getroot()
    return feed.findall(f"{{{ATOM_NS}}}entry")

# ─── main routine ────────────────────────────────────────────────────────
def main():
    os.makedirs(OUT_DIR, exist_ok=True)
    token   = get_token()
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/xml",
        "Accept": "application/atom+xml"
    }

    entries = list(iter_entries(INPUT_XML))
    i = 0
    while i < len(entries):
        content = entries[i].find(f"{{{ATOM_NS}}}content")
        if content is None:
            i += 1
            continue

        # copy the (first) ESPI child
        espi_child = next((c for c in content if isinstance(c.tag, str)), None)
        if espi_child is None:
            i += 1
            continue
        espi_copy = copy.deepcopy(espi_child)

        # If it's MeterReading and the *next* entry holds IntervalBlock,
        # nest that block inside before posting
        tag_local = espi_child.tag.split('}')[-1]
        if tag_local == "MeterReading" and i+1 < len(entries):
            nxt_content = entries[i+1].find(f"{{{ATOM_NS}}}content")
            if nxt_content is not None:
                nxt_child = next((c for c in nxt_content if isinstance(c.tag, str)), None)
                if nxt_child is not None and nxt_child.tag.endswith("IntervalBlock"):
                    espi_copy.append(copy.deepcopy(nxt_child))
                    i += 1   # skip the IntervalBlock entry because we merged it

        # write file
        idx      = f"{len(os.listdir(OUT_DIR))+1:02}"
        tag_name = espi_copy.tag.split('}')[-1]
        fname    = f"{idx}_{tag_name}.xml"
        fpath    = os.path.join(OUT_DIR, fname)
        ET.ElementTree(espi_copy).write(fpath, xml_declaration=True, encoding="utf-8")
        print(f"saved {fpath}")

        # POST
        payload = ET.tostring(espi_copy, xml_declaration=True, encoding="utf-8")
        resp    = requests.post(POST_URL, headers=headers, data=payload, timeout=30)
        print(f"{fname} → HTTP {resp.status_code}")
        if not resp.ok:
            print(resp.text[:400])   # print first 400 chars of error

        time.sleep(DELAY_SEC)
        i += 1

if __name__ == "__main__":
    main()
