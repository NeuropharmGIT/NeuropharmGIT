document.getElementById('send-btn').addEventListener('click', () => {
  chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
    const url = tabs[0]?.url || '';
    chrome.scripting.executeScript(
      {
        target: { tabId: tabs[0].id },
        func: () => document.body.innerText,
      },
      (results) => {
        const content = results[0].result;
        fetch('http://localhost:8000/api/save', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ url, content }),
        });
      }
    );
  });
});
