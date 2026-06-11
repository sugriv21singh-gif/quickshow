import fetch from 'node-fetch';

(async () => {
  try {
    const response = await fetch('http://localhost:3000/api/booking/create', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ showId: '6a19227a6432efc2865642b9', selectedSeats: ['G3', 'G4'] }),
    });
    const data = await response.text();
    console.log('STATUS', response.status);
    console.log('BODY', data);
  } catch (err) {
    console.error('ERROR', err);
  }
})();
