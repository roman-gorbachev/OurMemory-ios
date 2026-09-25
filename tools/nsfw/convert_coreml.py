"""Download the GantMan NSFW MobileNet V2 model and convert it to a Core ML package.

This is the same source model the Android app converts to TFLite (tools/nsfw/convert_model.py in OurMemory-80),
so both apps classify photos the same way. Run once with Python 3.11:

    uv run --python 3.11 --with-requirements tools/nsfw/requirements.txt tools/nsfw/convert_coreml.py

The resulting package is committed to OurMemory/Resources, so the Xcode build does not need Python.
"""

import argparse
import io
import tempfile
import zipfile
from pathlib import Path

import coremltools as ct
import requests
import tensorflow as tf

MODEL_URL = "https://github.com/GantMan/nsfw_model/releases/download/1.1.0/nsfw_mobilenet_v2_140_224.zip"
SAVED_MODEL_DIR = "mobilenet_v2_140_224"
INPUT_SIZE = 224
PIXEL_SCALE = 1 / 255.0
REPO_ROOT = Path(__file__).resolve().parents[2]
DEFAULT_OUTPUT = REPO_ROOT / "OurMemory/Resources/NsfwClassifier.mlpackage"


def download_saved_model(target: Path) -> Path:
    response = requests.get(MODEL_URL, timeout=120)
    response.raise_for_status()
    with zipfile.ZipFile(io.BytesIO(response.content)) as archive:
        archive.extractall(target)
    return target / SAVED_MODEL_DIR


def convert(saved_model: Path) -> ct.models.MLModel:
    model = tf.keras.models.load_model(str(saved_model), compile=False)
    return ct.convert(
        model,
        source="tensorflow",
        inputs=[ct.ImageType(name="input", shape=(1, INPUT_SIZE, INPUT_SIZE, 3), scale=PIXEL_SCALE,
                             color_layout=ct.colorlayout.RGB)],
        convert_to="mlprogram",
        compute_precision=ct.precision.FLOAT16,
        minimum_deployment_target=ct.target.iOS17,
    )


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    args = parser.parse_args()

    with tempfile.TemporaryDirectory() as workdir:
        model = convert(download_saved_model(Path(workdir)))
    model.short_description = "GantMan NSFW MobileNet V2: drawings, hentai, neutral, porn, sexy"
    args.output.parent.mkdir(parents=True, exist_ok=True)
    model.save(str(args.output))
    print(f"Wrote {args.output}")


if __name__ == "__main__":
    main()
