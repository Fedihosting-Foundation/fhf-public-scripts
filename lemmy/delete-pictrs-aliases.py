import argparse
import csv
import logging
import os

import requests


logging.basicConfig(
    format="%(asctime)s %(levelname)-8s %(message)s",
    level=logging.INFO,
)


parser = argparse.ArgumentParser(
    description="Batch delete pict-rs images through Lemmy using their delete tokens.",
    epilog="""Please set the environment variable LEMMY_JWT to a valid JWT of a Lemmy user on the instance.
As of Lemmy 0.19.8 this can be any local user as long as the token is valid.
Use the following command to read your JWT into an env var (input will not be visible): read -s LEMMY_JWT && export LEMMY_JWT""",
)
parser.add_argument(
    "--lemmy-domain",
    help="The domain your Lemmy instance is running on. This will be used to construct the URLs for pict-rs API requests. Defaults to lemmy.world",
    default="lemmy.world",
)
parser.add_argument(
    "csv_file", help="CSV file containing columns pictrs_alias and pictrs_delete_token."
)
args = parser.parse_args()

s = requests.Session()
s.headers.update({"authorization": f"Bearer {os.environ['LEMMY_JWT']}"})

logging.info("Validating LEMMY_JWT")
r = s.get(f"https://{args.lemmy_domain.lower()}/api/v3/user/validate_auth")
r.raise_for_status()

pictrs_url_prefix = f"https://{args.lemmy_domain.lower()}/pictrs/image/"

with open(args.csv_file, newline="") as csvfile:
    reader = csv.DictReader(csvfile)

    images = {}

    for row in reader:
        images[row["pictrs_alias"]] = row["pictrs_delete_token"]

image_count = len(images)
image_index = 0
for pictrs_alias, pictrs_delete_token in images.items():
    image_index += 1
    logging.info(
        "[%s/%s] Attempting to delete %s%s",
        image_index,
        image_count,
        pictrs_url_prefix,
        pictrs_alias,
    )
    r = s.get(f"{pictrs_url_prefix}delete/{pictrs_delete_token}/{pictrs_alias}")
    logging.info(
        "[%s/%s] Deletion response: %s", image_index, image_count, r.status_code
    )
