import http from 'http';
import fs from 'fs';

const data = JSON.stringify({ userId: 'test-user', showId: '6a19227a6432efc2865642b9', selectedSeats: ['A1','A2'] });

const options = {
  hostname: 'localhost',
  port: 3000,
  path: '/dev/force-create',
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Content-Length': Buffer.byteLength(data),
  },
};

const req = http.request(options, (res) => {
  let body = '';
  res.setEncoding('utf8');
  res.on('data', (chunk) => body += chunk);
  res.on('end', () => {
    try {
      fs.writeFileSync('force_response.json', body);
      console.log('WROTE force_response.json');
    } catch (e) {
      console.error('write failed', e);
    }
  });
});

req.on('error', (e) => console.error('request error', e));
req.write(data);
req.end();
