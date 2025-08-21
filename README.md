# NotumV1

Instructions to run the project on **Ubuntu 25.04**.

## Setup
1. Ensure Python 3.12 and Chrome are installed.
2. Create a virtual environment:
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   ```
3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

## Backend
Start the development server:
```bash
uvicorn backend.main:app --reload
```
The API exposes a `POST /api/save` endpoint accepting JSON `{url, content}`.
Captured data with a SHA256 hash is appended to `captures/log.jsonl`.

## Chrome Extension
1. Open Chrome and navigate to `chrome://extensions`.
2. Enable **Developer mode**.
3. Click **Load unpacked** and select the `extension/` folder.
4. Use the popup button "Envoyer à NotumV1" to send the current page to the backend.

## Directories
- `captures/` – incoming data
- `reports/` – analysis outputs
