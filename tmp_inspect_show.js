import mongoose from 'mongoose';

await mongoose.connect('mongodb://localhost:27017', { dbName: 'test' });

const showSchema = new mongoose.Schema(
  {
    movie: String,
    showDateTime: Date,
    showPrice: Number,
    occupiedSeats: Object,
  },
  { minimize: false }
);

const Show = mongoose.model('Show', showSchema, 'shows');
const show = await Show.findById('6a19227a6432efc2865642b9').lean();
console.log(JSON.stringify(show, null, 2));

await mongoose.disconnect();
