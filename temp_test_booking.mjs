import fs from 'fs';

(async () => {
  try {
    const res = await fetch('http://localhost:3000/dev/test-create', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ userId: 'test-user', showId: '6a19227a6432efc2865642b9', selectedSeats: ['A1', 'A2'] }),
    });
    const json = await res.json();
    console.log(JSON.stringify(json, null, 2));
  } catch (e) {
    console.error('request failed', e);
    process.exit(1);
  }
})();
