(async () => {
  try {
    const res = await fetch('http://localhost:3000/dev/force-create', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ userId: 'test-user', showId: '6a19227a6432efc2865642b9', selectedSeats: ['A1', 'A2'] }),
    });
    const json = await res.json();
    // write response to file for inspection
    import fs from 'fs';
    fs.writeFileSync('temp_force_response.json', JSON.stringify(json, null, 2));
    console.log('WROTE_RESPONSE_FILE');
  } catch (e) {
    console.error('request failed', e);
    process.exit(1);
  }
})();
