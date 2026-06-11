import http from 'http';
import fs from 'fs';

const data = JSON.stringify({
  razorpay_payment_id: 'mock_payment_123456',
  razorpay_order_id: 'order_SvYyLB41k8ahN1',
  razorpay_signature: 'mock_signature',
  bookingId: '6a1acd39cf04e25cc12ba1ac',
  mock: true,
});

const options = {
  hostname: 'localhost',
  port: 3000,
  path: '/api/booking/verify',
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Content-Length': Buffer.byteLength(data),
  },
};

const req = http.request(options, (res) => {
  let body = '';
  res.setEncoding('utf8');
  res.on('data', (chunk) => { body += chunk; });
  res.on('end', () => {
    fs.writeFileSync('verify_response.json', body);
    console.log('VERIFY_COMPLETE');
  });
});

req.on('error', (e) => console.error('request error', e));
req.write(data);
req.end();
